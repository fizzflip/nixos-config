{
  lib,
  pkgs,
  ...
}:
{
  # Display manager: SDDM with native Wayland support
  services.displayManager.sddm = {
    enable = lib.mkDefault true;
    wayland.enable = lib.mkDefault true;
  };

  # Desktop environment: KDE Plasma 6
  services.desktopManager.plasma6.enable = lib.mkDefault true;

  # Xorg/Wayland modesetting DDX driver
  services.xserver.videoDrivers = [ "modesetting" ];

  # Useful utilities for the desktop session
  environment.systemPackages = [
    pkgs.kitty
    pkgs.firefox
  ];
}
