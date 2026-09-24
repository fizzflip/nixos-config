{ ... }: {
  imports = [
    ./sound.nix
    ./nextdns.nix
    ./fhs-env.nix
    ./flatpaks.nix
    ./networking.nix
    ./podman.nix
    ./printing.nix
    ./bluetooth.nix
  ];
}
