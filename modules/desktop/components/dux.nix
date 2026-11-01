{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.my.desktop.environment == "niri") {
    programs = {
      dux-shell = {
        enable = true;
        systemd = {
          enable = true;
          restartIfChanged = true;
        };
      };
    };

    services.upower.enable = true;
    security.pam.services.dankshell = { };

    environment.systemPackages = [
      pkgs.libnotify
      pkgs.pulseaudio
      pkgs.lm_sensors
      pkgs.pavucontrol
      pkgs.brightnessctl
    ];
  };
}
