{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    dnscrypt-module.url = "github:andreoss/dnscrypt-nixos-module";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      chaotic,
      nixos-hardware,
      ...
    }:
    {

      # Arthur Leywin + King Grey => artrey
      nixosConfigurations."artrey" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          chaotic.nixosModules.default
          # chaotic.nixosModules.nyx-cache
          # chaotic.nixosModules.nyx-overlay
          # chaotic.nixosModules.nyx-registry

          ./hosts/laptop/configuration.nix

          ./modules/boot/plymouth.nix
          ./modules/boot/bootloader.nix

          # ./users/nini.nix
          ./users/mrbot.nix

          # ./modules/appearence/gnome.nix
          # ./modules/appearence/fonts.nix

          ./modules/security.nix
          ./modules/services/sound.nix
          ./modules/services/printing.nix
          ./modules/services/networking.nix

          # ./modules/services/dns-encrypt.nix
          # ./modules/services/android.nix

          ./modules/system-tuning.nix
          ./modules/hardware/graphics.nix
          inputs.dnscrypt-module.nixosModules.default

          ./modules/shell/zsh.nix
          ./modules/services/virtualisation.nix

          # Uncomment if using nixos-hardware
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-intel
        ];
      };

      # Kim Dokja => kimja #
    };
}
