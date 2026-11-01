{ inputs, ... }: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    # Core system options & shared settings
    ./core/options.nix
    ./core/locale.nix
    ./core/system.nix
    ./core/nix.nix
    ./core/compat.nix
    ./users/default.nix

    # Subsystem categories
    ./boot/default.nix
    ./hardware/default.nix
    ./services/default.nix
    ./system-tuning/default.nix
    ./shell/default.nix
    ./packages/default.nix
    ./appearance/default.nix
    ./desktop/default.nix

    # External flake modules
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    SDL_VIDEODRIVER = "wayland,x11";
  };
  # Use reference dbus implementation to prevent dbus-broker duplicate service shadowing error spam
  services.dbus.implementation = "dbus";
}
