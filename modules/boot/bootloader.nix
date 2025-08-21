{ ... }:
{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = true;
      theme = ./themes/grub/catppuccin-latte;
    };
    efi.canTouchEfiVariables = true;
  };
}
