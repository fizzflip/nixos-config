{ pkgs, ... }:
{
  programs.nm-applet.enable = true;
  environment.systemPackages = [
    pkgs.waybar

    pkgs.jq
    pkgs.cava
    pkgs.swww
    pkgs.libnotify

    pkgs.pulseaudio
    pkgs.lm_sensors
    pkgs.pavucontrol
    pkgs.brightnessctl
    pkgs.networkmanagerapplet
    pkgs.power-profiles-daemon

    pkgs.hicolor-icon-theme
    pkgs.adwaita-icon-theme
  ];
}
