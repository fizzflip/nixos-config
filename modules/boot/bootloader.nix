{ ... }:
{
  boot = {
    loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      theme = ./themes/grub/catppuccin-mocha;
      default = "saved";
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

  boot.kernelParams = [
    "8250.nr_uarts=0"
    "tpm_tis.interrupts=0"
    "tpm.disable_pcr_read=1"
  ];
  boot.initrd.kernelModules = [ "i915" ];
}
