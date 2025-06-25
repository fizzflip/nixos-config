{ pkgs, ... }:
{
  programs = {
    # waybar.enable = true;
    nm-applet.enable = true;
  };

  services.playerctld.enable = true;
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    waybar

    lm_sensors
    brightnessctl
    # pamixer
    # playerctl
    libnotify
    cliphist
    wl-clipboard-rs
    # wlogout #TODO
    pavucontrol

    swww
    networkmanagerapplet
    # common fallback for tray icons

    hicolor-icon-theme
    adwaita-icon-theme # optional: includes symbolic nm icons
    power-profiles-daemon

    jq
    pulseaudio
    playerctl
  ];

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    helvetica-neue-lt-std
  ];
}
