{ pkgs, ... }:

{
  imports = [
    ../components/waybar.nix
  ];

  programs.niri.enable = true;

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  security = {
    polkit.enable = true;
    soteria.enable = true;
  };

  services = {
    # Auto-mounting stuff
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = [
    pkgs.fuzzel
    pkgs.mako
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-gnome
    pkgs.alacritty
    pkgs.swayidle
    pkgs.swaylock
    pkgs.xwayland-satellite

    pkgs.material-icons
    pkgs.material-design-icons

    pkgs.cava
    pkgs.mpris-timer
    pkgs.kdePackages.dolphin
  ];
}
