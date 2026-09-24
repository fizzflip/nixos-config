{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  env = config.my.desktop.environment;
in
{
  imports = [ inputs.silentSDDM.nixosModules.default ];
  config = lib.mkIf (env == "niri" || env == "kde") {
    programs.silentSDDM = {
      enable = true;
      theme = "catppuccin-mocha";
      settings = {
        "LoginScreen.LoginArea.Avatar" = {
          always-active = "true";
        };
      };
      profileIcons = {
        ${config.my.user.name} = ./avatars/mrbot.svg;
      } // lib.optionalAttrs (builtins.hasAttr "nini" config.users.users) {
        nini = ./avatars/nini.svg;
      };
    };

    systemd.services.display-manager = {
      environment = {
        XCURSOR_PATH = "/run/current-system/sw/share/icons";
        XCURSOR_THEME = "Bibata-Modern-Classic";
        XCURSOR_SIZE = "24";
        XDG_DATA_DIRS = "/run/current-system/sw/share";
      };
      serviceConfig = {
        SyslogLevel = "info";
        LogLevelMax = "notice";
      };
    };

    services.displayManager.sddm = {
      extraPackages = [ pkgs.bibata-cursors ];
      settings = {
        General = {
          GreeterEnvironment = lib.mkForce "QML2_IMPORT_PATH=${config.programs.silentSDDM.package'}/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard,XCURSOR_PATH=/run/current-system/sw/share/icons,XCURSOR_THEME=Bibata-Modern-Classic,XCURSOR_SIZE=24";
        };
        Theme = {
          CursorTheme = "Bibata-Modern-Classic";
          CursorSize = 24;
        };
      };
    };
  };
}
