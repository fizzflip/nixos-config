{
  nixConfig = {
    extra-substituters = [
      "https://artcraft.cachix.org"
    ];
    extra-trusted-public-keys = [
      "artcraft.cachix.org-1:DVvueuBTTIU1ZMP8eNCGTr1oYvCfBik3uGicXhM0dXs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    artcraft.url = "github:jervw/artcraft-flake";
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
    preload-ng = {
      url = "github:miguel-b-p/preload-ng";
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
          extraModules = [ ./hosts/laptop/configuration.nix ];
        };
        minimal = mkSystem {
          myConfig = {
            my.user.name = "mrbot";
            my.desktop.environment = "niri";
          };
          extraModules = [ ./hosts/laptop/configuration.nix ];
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
            my.services.virtualisation.enable = true;
          };
          extraModules = [
            ./hosts/preview/configuration.nix
            ./modules/packages/lab/default.nix
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
