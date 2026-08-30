{
  lib,
  config,
  inputs,
  modulesPath,
  ...
}:
let
  btrfsCommonOptions = [
    "compress-force=zstd:6"
    "noatime"
    "discard=async"
    "ssd"
    "space_cache=v2"
    "commit=60"
  ];
in
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
    options = [ "subvol=@root" ] ++ btrfsCommonOptions;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/0487551a-49fb-48d7-bbd2-841cfdf6d861";
    fsType = "btrfs";
    options = [ "subvol=@home" ] ++ btrfsCommonOptions;
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/0487551a-49fb-48d7-bbd2-841cfdf6d861";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ btrfsCommonOptions;
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
