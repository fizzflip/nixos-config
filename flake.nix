{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      nix-cachyos-kernel,
      ...
    }:
    {
      nixosConfigurations = {

        "fluid" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/appearence/desktop-environment/kde.nix
            ./modules/services/adguard-home.nix
            ./modules/minimal.nix
            ./users/mrbot.nix
          ];
        };

        "minimal" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/appearence/desktop-environment/niri.nix
            ./modules/services/adguard-home.nix
            ./modules/minimal.nix
            ./users/mrbot.nix
          ];
        };
      };
    };
}
