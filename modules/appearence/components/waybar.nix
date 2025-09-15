{ pkgs, ... }:

{
  programs.nm-applet.enable = true;
  services.power-profiles-daemon.enable = true;

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

  fonts.packages = [
    pkgs.noto-fonts
    pkgs.font-awesome
    pkgs.material-icons
    pkgs.noto-fonts-emoji
    pkgs.noto-fonts-cjk-sans
    pkgs.helvetica-neue-lt-std
    pkgs.material-design-icons
  ];
}
