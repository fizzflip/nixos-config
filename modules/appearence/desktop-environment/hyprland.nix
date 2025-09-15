{ pkgs, inputs, ... }:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd hyprland";
      user = "mrbot";
    };
  };
  environment.etc."greetd/environments".text = "Hyprland";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  environment.systemPackages = [
    inputs.caelestia-shell.packages."${pkgs.system}".default
    pkgs.kitty
    pkgs.rofi
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

  fonts.packages = [ pkgs.font-awesome ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
