{ inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./core/options.nix
    ./boot/plymouth.nix
    ./boot/bootloader.nix
    ./services/sound.nix
    ./services/nextdns.nix
    ./services/fhs-env.nix
    ./services/flatpaks.nix
    ./services/networking.nix
    ./services/podman.nix
    # ./services/printing.nix
    ./system-tuning/default.nix
    ../hosts/common.nix
    ../users/default.nix
    ../users/nini.nix
    ./shell/fish.nix
    # ./shell/nu.nix
    ./packages/default.nix
    ./appearance/fonts.nix
    ./appearance/desktop-environment/default.nix
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
  # Use reference dbus implementation to prevent dbus-broker duplicate service shadowing error spam
  services.dbus.implementation = "dbus";
}
