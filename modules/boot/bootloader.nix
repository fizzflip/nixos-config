{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.security.secureboot;
in
{
  options.my.security.secureboot = {
    enable = lib.mkEnableOption "UEFI Secure Boot using Lanzaboote Unified Kernel Images (UKIs) signed via sbctl";
  };

  config = {
    # Hardware security & Secure Boot key management tooling
    environment.systemPackages = [
      pkgs.sbctl
      pkgs.tpm2-tools
    ];

    boot = {
      # Standard GRUB bootloader configuration (active when Secure Boot is not enabled)
      loader.grub = {
        enable = !cfg.enable;
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

      # Lanzaboote UEFI Secure Boot integration (active when my.security.secureboot.enable = true)
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = lib.mkIf cfg.enable {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
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
  };
}
