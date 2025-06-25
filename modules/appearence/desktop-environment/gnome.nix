{ config, pkgs, ... }:

{
  services.xserver = {
    # Enable the X11 windowing system.
    # enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager = {
      gdm.enable = true;
      gdm.wayland = true;
    };
    desktopManager.gnome.enable = true;

    xkb = {
      layout = "us";
      variant = "";
    };

    excludePackages = [ pkgs.xterm ];
  };

  # services.gnome.core-utilities.enable = false;

  # Excluded GNOME components
  environment.gnome.excludePackages = (
    with pkgs;
    [
      geary # email reader
      totem # video player
      baobab # disk usage analyzer
      yelp # help
      # seahorse # password manager
      snapshot # webcam viewer

      gnome-clocks
      gnome-contacts
      gnome-weather
      gnome-logs
      gnome-characters
      gnome-music
      gnome-tour
      gnome-maps
    ]
  );

  # GNOME Extensions/Themes/Stuff
  environment.systemPackages = with pkgs; [

    # Blur goes brrr
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    # gnomeExtensions.dynamic-panel

    # WMs on top of GNOME
    # gnomeExtensions.forge
    # gnomeExtensions.tiling-shell
    gnomeExtensions.paperwm

    # Theme
    gnomeExtensions.user-themes
    # marble-shell-theme
    # flat-remix-gnome
    orchis-theme
    whitesur-gtk-theme
    whitesur-cursors
    whitesur-icon-theme

    # Icon-packs
    flat-remix-icon-theme
    papirus-icon-theme

    # QoL
    gnomeExtensions.launch-new-instance
    gnomeExtensions.soft-brightness-plus
    gnomeExtensions.appindicator

    # gnomeExtensions.astra-monitor
    # lspci
    # nethogs
    # iotop
    # gtop

    gnome-settings-daemon
    gnome-tweaks

    gnomeExtensions.clipboard-indicator
    gnomeExtensions.day-progress
    gnomeExtensions.just-perfection
    gnomeExtensions.open-bar
    # gnomeExtensions.media-controls
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
