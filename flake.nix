{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      ...
    }:
    {
      nixosConfigurations = {

        "fluid" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/appearence/fonts.nix
            ./hosts/laptop/configuration.nix
            ./hosts/laptop/system-packages.nix
            ./hosts/laptop/hardware-configuration.nix
            ./modules/appearence/desktop-environment/gnome.nix

            ./modules/boot/plymouth.nix
            ./modules/boot/bootloader.nix

            ./users/mrbot.nix

            ./modules/services/sound.nix
            ./modules/services/networking.nix

            ./modules/shell/zsh.nix

            ./modules/system-tuning/all.nix
            ./modules/hardware/graphics.nix
            ./modules/services/adguard-home.nix

            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-intel
          ];
        };

        "minimal" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/appearence/fonts.nix
            ./hosts/laptop/configuration.nix
            ./hosts/laptop/system-packages.nix
            ./hosts/laptop/hardware-configuration.nix
            ./modules/appearence/desktop-environment/niri.nix

            ./modules/boot/plymouth.nix
            ./modules/boot/bootloader.nix

            ./users/mrbot.nix

            ./modules/services/sound.nix
            ./modules/services/networking.nix

            ./modules/shell/zsh.nix

            ./modules/system-tuning/all.nix
            ./modules/hardware/graphics.nix
            ./modules/services/adguard-home.nix

            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-intel
          ];
        };
      };
    };
}
