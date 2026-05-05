{ lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
    ../../modules/appearance/desktop-environment/kde.nix
    ../laptop/system-packages.nix
    ../../modules/base.nix
    ../../users/mrbot.nix
    ../common.nix
  ];

  # Disable custom bootloaders to prevent conflicts with the ISO's bootloader
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # Disable ZFS to prevent build failures with the custom CachyOS kernel
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "reiserfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];

  # Resolve conflict for boot loader timeout between plymouth and iso-image
  boot.loader.timeout = lib.mkForce 10;

  # nixos-init conflicts with boot.postBootCommands used by the ISO builder
  system.nixos-init.enable = lib.mkForce false;

  # Make sure wireless is handled correctly by NetworkManager
  networking.wireless.enable = lib.mkForce false;
}
