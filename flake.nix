{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
      url = "github:schembriaiden/helium-browser-nix-flake";
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
        ({ lib, ... }: {
          virtualisation.vmVariant = {
            # Give the VM sufficient resources for a desktop environment
            virtualisation.memorySize = 4096;
            virtualisation.cores = 4;
            # Provide a default password for the 'mrbot' user in the VM
            users.users.mrbot.hashedPasswordFile = lib.mkForce null;
            users.users.mrbot.password = "nixos";
          };
        })
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
      };
      
      apps."x86_64-linux" = {
        default = self.apps."x86_64-linux".fluid;
        fluid = {
          type = "app";
          program = "${self.nixosConfigurations.fluid.config.system.build.vm}/bin/run-machine-vm";
        };
        minimal = {
          type = "app";
          program = "${self.nixosConfigurations.minimal.config.system.build.vm}/bin/run-machine-vm";
        };
      };
    };
}
