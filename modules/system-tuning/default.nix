{ ... }: {
  imports = [
    ./kernel.nix
    ./security.nix
    ./service-hardening.nix
    ./graphics.nix
    ./disks.nix
    ./cleanup.nix
    ./swap.nix
    ./cgroups.nix
  ];
}
