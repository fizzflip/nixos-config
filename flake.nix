{
  nixConfig = {
    extra-substituters = [
      "https://cache.lantian.pub/lantian"
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      # "https://niri.cachix.org"
      # "https://nixpkgs-wayland.cachix.org"
      # "https://chaotic-nyx.cachix.org"
      # "https://nix-gaming.cachix.org"
      # "https://numtide.cachix.org"
      # "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      # "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      # "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      # "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.flake-compat.follows = "lanzaboote/pre-commit/flake-compat";
    };
    packaging-nixos-apps = {
      url = "git+https://github.com/fizzflip/packaging-nixos-apps.git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "lanzaboote/crane";
    };
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    metrolist = {
      url = "github:MetrolistGroup/Metrolist";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gaze = {
      url = "github:GunduLabs/gaze/v0.5.2";
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opentubex = {
      url = "github:OpenTubeX/nix";
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
      mkSystem =
        {
          myConfig ? { },
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/base.nix
            myConfig
          ]
          ++ extraModules;
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
        machine = mkSystem {
          myConfig = {
            my.user.name = "mrbot";
            my.desktop.environment = "none";
          };
          extraModules = [ ./hosts/machine/configuration.nix ];
        };
        machine-desktop = mkSystem {
          myConfig = {
            my.user.name = "mrbot";
            my.desktop.environment = "kde";
          };
          extraModules = [
            ./hosts/machine/configuration.nix
            ./hosts/machine/desktop.nix
          ];
        };
        installer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./modules/installer/unattended-iso.nix ];
        };
      };
      packages."x86_64-linux" = {
        installer-iso = self.nixosConfigurations.installer.config.system.build.isoImage;
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
          meta = {
            description = "Run minimal preview VM";
          };
        };
        preview-full = {
          type = "app";
          program = "${self.nixosConfigurations.preview-full.config.system.build.vm}/bin/run-preview-vm";
          meta = {
            description = "Run full preview VM";
          };
        };
      };
    };
}
