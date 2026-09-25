{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../components/dms.nix
    ../components/nautilus.nix
  ];

  config = lib.mkIf (config.my.desktop.environment == "niri") {
    programs.niri = {
      enable = true;
      # Route FileChooser portal to xdg-desktop-portal-gtk instead of Nautilus
      useNautilus = false;
    };
    programs.xwayland.enable = true;
    programs.dconf.enable = true;

    xdg.portal = {
      enable = true;
      # xdg-desktop-portal-gnome is automatically added by programs.niri.enable for screencast/remotedesktop
      # xdg-desktop-portal-gtk handles FileChooser, Access, Notification, and Inhibit
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.niri = {
        # Route idle/sleep inhibition to GTK (systemd-logind); GNOME portal fails without gnome-session
        "org.freedesktop.impl.portal.Inhibit" = "gtk";
      };
    };

    security = {
      polkit.enable = true;
      # soteria.enable = true;
    };

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
      pkgs.gnome-disk-utility

      # GTK Theme
      # pkgs.orchis-theme
      pkgs.bibata-cursors

      # Colors
      pkgs.wallust

      # Image viewer
      pkgs.nomacs
    ];
  };
}
