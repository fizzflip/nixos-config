{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
        preview = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/preview/configuration.nix ];
        };
      };
      apps."x86_64-linux" = {
        default = self.apps."x86_64-linux".preview;
        preview = {
          type = "app";
          program = "${self.nixosConfigurations.preview.config.system.build.vm}/bin/run-preview-vm";
        };
      };
    };
}
