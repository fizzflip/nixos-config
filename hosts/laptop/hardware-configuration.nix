{
  lib,
  config,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0487551a-49fb-48d7-bbd2-841cfdf6d861";
    fsType = "btrfs";
    options = [
      "subvol=@root"
      "compress-force=zstd:3"
      "noatime"
      "discard=async"
      "ssd"
      "commit=60"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/0487551a-49fb-48d7-bbd2-841cfdf6d861";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress-force=zstd:3"
      "noatime"
      "discard=async"
      "ssd"
      "commit=60"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/0487551a-49fb-48d7-bbd2-841cfdf6d861";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress-force=zstd:3"
      "noatime"
      "discard=async"
      "ssd"
      "commit=60"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/68CB-26B3";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  hardware.enableRedistributableFirmware = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
