{ ... }:
{
  boot = {
    loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      theme = ./themes/grub/catppuccin-mocha;
      default = 3;
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = true;
      splashImage = null;
    };
    initrd = {
      systemd.enable = true;
      verbose = false;
    };
  };
  system = {
    nixos-init.enable = true;
    etc.overlay.enable = true;
  };
  services.userborn.enable = true;
}