{ inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./core/options.nix
    ./appearance/desktop-environment/default.nix
    ./appearance/fonts.nix
    ./shell/fish.nix
    ./boot/plymouth.nix
    ./boot/bootloader.nix
    ./services/sound.nix
    ./services/nextdns.nix
    ./services/fhs-env.nix
    ./services/flatpaks.nix
    ./services/networking.nix
    ./system-tuning/default.nix
    ./packages/default.nix
    ../hosts/common.nix
    ../users/default.nix
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.dbus.implementation = "broker";
}
