{ inputs, ... }:
{
  imports = [
    ./boot/plymouth.nix
    ./appearence/fonts.nix
    ./services/sound.nix
    ./services/nextdns.nix
    ./services/fhs-env.nix
    ./services/networking.nix
    ./boot/bootloader.nix
    ./shell/zsh.nix
    ./system-tuning/all.nix
    ./services/flatpaks.nix
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  # Firmware updates — needed in all profiles for BIOS/device firmware (fwupdmgr)
  services.fwupd.enable = true;
}
