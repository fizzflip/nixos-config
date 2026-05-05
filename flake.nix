{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      baseModules = [
        ./hosts/laptop/configuration.nix
        ./modules/base.nix
        ./users/mrbot.nix
      ];
      mkSystem =
        desktopModule:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = baseModules ++ [ desktopModule ];
        };
    in
    {
      nixosConfigurations = {
        fluid = mkSystem ./modules/appearance/desktop-environment/kde.nix;
        minimal = mkSystem ./modules/appearance/desktop-environment/niri.nix;
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/iso/configuration.nix ];
        };
      };
    };
}
