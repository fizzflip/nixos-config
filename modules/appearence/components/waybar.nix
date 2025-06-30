{ pkgs, ... }:

{
  programs.nm-applet.enable = true;

  services = {
    playerctld.enable = true;
    power-profiles-daemon.enable = true;
  };

  environment.systemPackages = [
    pkgs.waybar

    pkgs.lm_sensors
    pkgs.brightnessctl
    # pamixer
    pkgs.libnotify
    pkgs.cliphist
    pkgs.wl-clipboard-rs
    # wlogout #TODO
    pkgs.pavucontrol

    pkgs.swww
    pkgs.networkmanagerapplet

    pkgs.hicolor-icon-theme
    pkgs.adwaita-icon-theme
    pkgs.power-profiles-daemon

    pkgs.jq
    pkgs.pulseaudio
    pkgs.playerctl
  ];

  fonts.packages = [
    pkgs.font-awesome
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-emoji
    pkgs.helvetica-neue-lt-std
    pkgs.material-icons
    pkgs.material-design-icons
  ];
}
