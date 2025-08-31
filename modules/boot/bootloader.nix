{ ... }:

{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = true;
      theme = ./themes/grub/catppuccin-latte;
      efiInstallAsRemovable = true;
    };
    # efi.canTouchEfiVariables = true;
  };
}
