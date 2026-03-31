{ inputs, ... }:
{
  imports = [
    ./appearence/fonts.nix
    ./services/sound.nix
    ./services/nextdns.nix
    ./services/fhs-env.nix
    ./services/networking.nix
    ./boot/bootloader.nix
    ./shell/zsh.nix
    ./system-tuning/all.nix
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];
}
