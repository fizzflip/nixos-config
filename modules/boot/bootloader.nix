{ ... }:

{
  boot.loader = {
    grub = {
      enable = true;
      devices = [ "nodev" ];
      theme = ./themes/grub/catppuccin-mocha;

      default = 2;
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = true;
      splashImage = null;
    };
  };
}
