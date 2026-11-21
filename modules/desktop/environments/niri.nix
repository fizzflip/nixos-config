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
    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              icon-theme = "Adwaita";
              cursor-theme = "Bibata-Modern-Classic";
              color-scheme = "prefer-dark";
            };
          };
        }
      ];
    };

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
      pkgs.bibata-cursors

      # Colors
      pkgs.wallust

      # Image viewer
      pkgs.nomacs
    ];
  };
}
