{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    craftapps = {
      url = "github:Devitek/artcraft-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    preload-ng = {
      url = "github:miguel-b-p/preload-ng";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gaze = {
      url = "github:GunduLabs/gaze";
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
      treefmtEval = inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.x86_64-linux ./treefmt.nix;
      baseModules = [
        inputs.lanzaboote.nixosModules.lanzaboote
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
          ];
        };
      };
      formatter."x86_64-linux" = treefmtEval.config.build.wrapper;
      checks."x86_64-linux" = {
        formatting = treefmtEval.config.build.check self;
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
