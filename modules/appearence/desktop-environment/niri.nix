{ pkgs, ... }:

{
  imports = [
    ../components/dms.nix
    # ../components/waybar.nix
    ../components/sddm.nix
  ];

  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security = {
    polkit.enable = true;
    soteria.enable = true;
  };

  # Auto-mounting stuff
  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = [
    pkgs.mako
    pkgs.fuzzel
    pkgs.swayidle
    pkgs.swaylock
    pkgs.alacritty
    pkgs.xwayland-satellite

    # File manager
    pkgs.thunar
    pkgs.thunar-volman
    pkgs.thunar-archive-plugin
    pkgs.thunar-media-tags-plugin

    # GTK Theme
    pkgs.orchis-theme
    pkgs.phinger-cursors

    # Colors
    pkgs.wallust

    # Image viewer
    pkgs.nomacs

    pkgs.gnome-disk-utility
  ];
}
