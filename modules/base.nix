{ inputs, ... }:
{
  imports = [
    ./shell/fish.nix
    ./appearance/fonts.nix
    ./boot/plymouth.nix
    ./boot/bootloader.nix
    ./services/sound.nix
    ./services/nextdns.nix
    ./services/fhs-env.nix
    ./services/flatpaks.nix
    ./services/networking.nix
    ./system-tuning/all.nix
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
}
