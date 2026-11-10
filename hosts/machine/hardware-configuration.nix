# Hardware configuration discovered from Gigabyte H61M-DS2 & Intel Pentium G2030
{
  lib,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader: UEFI systemd-boot
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Storage and bus controller kernel modules
  boot.initrd.availableKernelModules = [
    "ehci_pci"
    "ahci"
    "ata_piix"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "r8169"
  ];

  # Early Kernel Mode Setting (KMS) for Intel HD 2500 iGPU
  boot.initrd.kernelModules = [ "i915" ];

  # Hardware sensor and SMBus kernel modules
  boot.kernelModules = [
    "coretemp"
    "i2c_i801"
  ];
  boot.extraModulePackages = [ ];

  # Target storage partitions matching unattended installer GPT layout with optimized HDD mount flags
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
      "commit=60"
      "errors=remount-ro"
      "data=ordered"
      "barrier=1"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
      "noatime"
      "errors=remount-ro"
      "utf8=1"
    ];
  };

  # Direct temporary builds and extractions to RAM/zram to eliminate mechanical HDD seek thrashing
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
    cleanOnBoot = true;
  };

  # Host platform & microcode baseline
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
