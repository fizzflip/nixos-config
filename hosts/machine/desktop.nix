{ pkgs, ... }: {
  # Xorg/Wayland modesetting DDX driver
  services.xserver.videoDrivers = [ "modesetting" ];

  # Useful utilities for the desktop session
  environment.systemPackages = [
    pkgs.kitty
    pkgs.firefox
  ];
}
