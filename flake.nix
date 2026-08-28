{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
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
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      baseModules = [
        ./hosts/laptop/configuration.nix
        ./modules/base.nix
      ];
      mkSystem =
        {
          myConfig ? { },
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = baseModules ++ [ myConfig ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        fluid = mkSystem {
          myConfig = {
            my.user.name = "mrbot";
            my.desktop.environment = "kde";
          };
        };
        minimal = mkSystem {
          myConfig = {
            my.user.name = "mrbot";
            my.desktop.environment = "niri";
          };
        };
        preview = mkSystem {
          myConfig = {
            my.user.name = "mrbot";
            my.desktop.environment = "niri";
            my.packages.minimal = true;
          };
          extraModules = [ ./hosts/preview/configuration.nix ];
        };
        preview-full = mkSystem {
          myConfig = {
            my.user.name = "mrbot";
            my.desktop.environment = "niri";
            my.packages.minimal = false;
          };
          extraModules = [
            ./hosts/preview/configuration.nix
            ./modules/packages/lab/default.nix
            ./modules/services/virtualisation.nix
          ];
        };
      };
      apps."x86_64-linux" = {
        default = self.apps."x86_64-linux".preview;
        preview = {
          type = "app";
          program = "${self.nixosConfigurations.preview.config.system.build.vm}/bin/run-preview-vm";
        };
        preview-full = {
          type = "app";
          program = "${self.nixosConfigurations.preview-full.config.system.build.vm}/bin/run-preview-vm";
        };
      };
    };
}
