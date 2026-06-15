{ pkgs, ... }: {
  boot = {
    loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      theme = pkgs.catppuccin-grub;
      default = "saved";
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = true;
      splashImage = null;
      configurationLimit = 10;
    };
    initrd = {
      systemd.enable = true;
      verbose = false;
    };
    consoleLogLevel = 3;
    loader.timeout = 10;
  };
  system = {
    nixos-init.enable = true;
    etc.overlay.enable = true;
  };
  services.userborn.enable = true;

  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"

    "8250.nr_uarts=0"
    "tpm_tis.interrupts=0"
    "tpm.disable_pcr_read=1"
  ];
  boot.initrd.kernelModules = [ "i915" ];
}
