{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../components/dux.nix
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
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config.niri = {
        default = [
          "gnome"
          "gtk"
        ];
        # Route FileChooser to GTK to prevent D-Bus freeze when Nautilus is not a running daemon
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        # Niri natively implements Mutter ScreenCast and RemoteDesktop D-Bus interfaces
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
        # Route idle/sleep inhibition to GTK (systemd-logind); GNOME portal fails without gnome-session
        "org.freedesktop.impl.portal.Inhibit" = "gtk";
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      };
    };

    security = {
      polkit.enable = true;
      # soteria.enable = true;
    };

    # Systemd user service to autostart Polkit authentication agent in Niri session
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
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

      # GTK Theme & Cursors
      # pkgs.orchis-theme
      pkgs.bibata-cursors

      # Colors
      pkgs.wallust

      # Image viewer
      pkgs.nomacs
    ];
  };
}
