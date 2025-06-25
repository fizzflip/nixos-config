{ pkgs, ... }:

{
  programs.nm-applet.enable = true;

  services = {
    playerctld.enable = true;
    power-profiles-daemon.enable = true;
  };

  environment.systemPackages = with pkgs; [
    waybar

    lm_sensors
    brightnessctl
    # pamixer
    libnotify
    cliphist
    wl-clipboard-rs
    # wlogout #TODO
    pavucontrol

    swww
    networkmanagerapplet

    hicolor-icon-theme
    adwaita-icon-theme
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
