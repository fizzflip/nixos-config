{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    silentSDDM.url = "github:uiriansan/SilentSDDM";
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
            # ./users/nini.nix

            ./modules/security.nix
            ./modules/services/sound.nix
            # ./modules/services/printing.nix
            ./modules/services/networking.nix
            # ./modules/services/virtualisation.nix

            ./modules/shell/zsh.nix

            ./modules/system-tuning.nix
            ./modules/hardware/graphics.nix
            ./modules/services/adguard-home.nix

            chaotic.nixosModules.default
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

            #./users/nini.nix
            ./users/mrbot.nix

            ./modules/security.nix
            ./modules/services/sound.nix
            ./modules/services/networking.nix
            #./modules/services/virtualisation.nix

            ./modules/shell/zsh.nix

            ./modules/system-tuning.nix
            ./modules/hardware/graphics.nix
            ./modules/services/adguard-home.nix

            chaotic.nixosModules.default
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-intel
          ];
        };
      };
    };
}
