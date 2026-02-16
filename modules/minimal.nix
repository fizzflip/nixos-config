{ inputs, ... }:
{
  imports = [
    ./appearence/fonts.nix

    ./services/sound.nix
    ./services/fhs-env.nix
    ./services/networking.nix

    ../hosts/laptop/configuration.nix
    ../hosts/laptop/system-packages.nix
    ../hosts/laptop/hardware-configuration.nix

    ./boot/plymouth.nix
    ./boot/bootloader.nix

    ./shell/zsh.nix

    ./system-tuning/all.nix

    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];
}
