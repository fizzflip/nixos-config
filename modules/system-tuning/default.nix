{ ... }: {
  imports = [
    ./kernel.nix
    ./security.nix
    ./service-hardening.nix
    ./graphics.nix
    ./disks.nix
    ./cleanup.nix
    ./swap.nix
    ./preload.nix
    ./cgroups.nix
  ];
}
