{ pkgs, ... }:

{
  imports = [
    ../components/dms.nix
    ../components/sddm.nix
    ../../services/bluetooth.nix
    ../../services/printing.nix
  ];

  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    # xdg-desktop-portal-gtk: handles file pickers, inhibit (sleep/screen), and
    # other portal interfaces not supported by the wlr backend.
    # programs.niri.enable already sets up the core Niri portal — don't set wlr.enable here.
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  security = {
    polkit.enable = true;
    # soteria.enable = true;
  };

  systemd.user.services.polkit-agent = {
    description = "Polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      Type = "simple";
    };
  };

  # systemd.user.services.polkit-gnome-agent = {
  #   description = "Polkit GNOME Authentication Agent";
  #   wantedBy =  [ "graphical-session-target"];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.polkit_gnome}/libexec/"
  #   };
  # };

  # Auto-mounting stuff
  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = [
    pkgs.foot

    pkgs.polkit_gnome
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

    pkgs.gparted
  ];
}
