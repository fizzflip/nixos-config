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

  environment.systemPackages = [
    pkgs.kitty
    pkgs.rofi-wayland
    pkgs.waybar
    pkgs.dunst
    pkgs.swww
    # kdePackages.dolphin
    pkgs.libnotify
    pkgs.networkmanagerapplet

    pkgs.pyprland
    pkgs.hyprpicker
    pkgs.hyprcursor
    pkgs.hyprlock
    pkgs.hypridle
    pkgs.hyprpaper
  ];

  fonts.packages = [
    pkgs.font-awesome
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
