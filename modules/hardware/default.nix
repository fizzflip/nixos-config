{ ... }: {
  imports = [
    ./intel-gpu.nix
    ./peripherals.nix
    ./ivybridge.nix
    ./mechanical-hdd.nix
    ./power.nix
  ];
}
