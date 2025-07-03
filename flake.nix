{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dnscrypt-module = {
      url = "github:andreoss/dnscrypt-nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          ./modules/appearence/fonts.nix
          ./hosts/laptop/configuration.nix
          ./hosts/laptop/system-packages.nix
          ./hosts/laptop/hardware-configuration.nix
          ./modules/appearence/desktop-environment/kde.nix

          ./modules/boot/plymouth.nix
          ./modules/boot/bootloader.nix

          ./users/nini.nix
          ./users/mrbot.nix

          ./modules/security.nix
          ./modules/services/sound.nix
          ./modules/services/printing.nix
          ./modules/services/networking.nix
          ./modules/services/virtualisation.nix

          ./modules/shell/zsh.nix

          ./modules/system-tuning.nix
          ./modules/hardware/graphics.nix
          inputs.dnscrypt-module.nixosModules.default

          chaotic.nixosModules.default
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-intel
        ];
      };

      # Kim Dokja => kimja #
    };
}
