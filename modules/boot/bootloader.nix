{ ... }:

{
  boot.loader = {
    grub = {
      enable = true;
      devices = [ "nodev" ];
      theme = ./themes/grub/catppuccin-latte;

      default = 2;
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = true;
    };
  };
}
