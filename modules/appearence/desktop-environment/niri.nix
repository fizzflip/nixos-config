{ pkgs, ... }:

{
  imports = [
    ../components/waybar.nix
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
    pkgs.xfce.thunar
    pkgs.xfce.thunar-volman
    pkgs.xfce.thunar-vcs-plugin
    pkgs.xfce.thunar-archive-plugin
    pkgs.xfce.thunar-media-tags-plugin

    # GTK Theme
    pkgs.orchis-theme

    # Colors
    pkgs.wallust

    # Image viewer
    pkgs.nomacs

    pkgs.gnome-disk-utility
  ];
}
