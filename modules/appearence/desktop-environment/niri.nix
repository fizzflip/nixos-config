{ pkgs, ... }:

{
  imports = [
    ../components/waybar.nix
    ../components/sddm.nix
  ];

  programs.niri.enable = true;

  # services.xserver.displayManager.gdm = {
  #   enable = true;
  #   wayland = true;
  # };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
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
    pkgs.alacritty
    pkgs.swayidle
    pkgs.swaylock
    pkgs.xwayland-satellite

    pkgs.material-icons
    pkgs.material-design-icons

    pkgs.cava
    pkgs.mpris-timer

    pkgs.xfce.thunar
    pkgs.xfce.thunar-volman
    pkgs.xfce.thunar-vcs-plugin
    pkgs.xfce.thunar-archive-plugin
    pkgs.xfce.thunar-media-tags-plugin

    pkgs.orchis-theme

    pkgs.wallust
  ];
}
