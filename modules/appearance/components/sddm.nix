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
        "User.${config.my.user.name}" = {
          preferred-session = if config.my.desktop.environment == "kde" then "plasma" else "niri";
        };
      } // lib.optionalAttrs (config.my.users.nini.enable) {
        "User.nini" = {
          preferred-session = if config.my.desktop.environment == "kde" then "plasma" else "niri";
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
        WLR_NO_HARDWARE_CURSORS = "1";
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
      wayland.enable = lib.mkOverride 90 true;
      wayland.compositor = "kwin";
      extraPackages = [ pkgs.bibata-cursors ];
      settings = {
        General = {
          GreeterEnvironment = lib.mkForce "QML2_IMPORT_PATH=${config.programs.silentSDDM.package'}/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard,QT_WAYLAND_SHELL_INTEGRATION=layer-shell,XCURSOR_PATH=/run/current-system/sw/share/icons,XCURSOR_THEME=Bibata-Modern-Classic,XCURSOR_SIZE=24";
        };
        Theme = {
          CursorTheme = "Bibata-Modern-Classic";
          CursorSize = 24;
        };
      };
    };
  };
}
