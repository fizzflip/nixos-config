{ ... }: {
  imports = [
    ./sound.nix
    ./nextdns.nix
    ./flatpaks.nix
    ./networking.nix
    ./podman.nix
    ./printing.nix
    ./bluetooth.nix
    ./virtualisation.nix
    ./android.nix
    ./gaze.nix
  ];
}
