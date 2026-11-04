{ lib, ... }: {
  options.my.desktop.environment = lib.mkOption {
    type = lib.types.enum [
      "niri"
      "kde"
      "gnome"
      "none"
    ];
    default = "none";
    description = "Desktop environment to enable.";
  };

  imports = [
    ./environments/default.nix
    ./display-managers/sddm.nix
  ];
}
