{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
      user = "mrbot";
    };
  };
  environment.etc."greetd/environments".text = "Hyprland";

  programs.hyprland.enable = true;
  # programs.hyprland.xwayland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    rofi-wayland
    waybar
    dunst
    swww
    # kdePackages.dolphin
    libnotify
    networkmanagerapplet

    pyprland
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
  ];

  fonts.packages = with pkgs; [
    font-awesome
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
  ];
}
