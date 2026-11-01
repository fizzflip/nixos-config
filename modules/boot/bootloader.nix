{ pkgs, ... }: {
  boot = {
    loader.grub = {
      enable = true;
      font = "${pkgs.catppuccin-grub}/font.pf2";
      devices = [ "nodev" ];
      theme = pkgs.catppuccin-grub;
      default = "saved";
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = true;
      splashImage = null;
      configurationLimit = 10;
    };
    initrd.systemd.emergencyAccess = true;
    consoleLogLevel = 3;
    loader.timeout = 10;
  };

  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"

    "8250.nr_uarts=0"
    "tpm_tis.interrupts=0"
  ];
}
