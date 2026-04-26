{ ... }:
{
  imports = [
    ./kernel.nix
    ./security.nix
    ./graphics.nix
    ./disks.nix
    ./cleanup.nix
    ./power.nix
    ./swap.nix
  ];
}
