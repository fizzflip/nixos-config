{ inputs, ... }: {
  programs.nh.clean = {
    enable = true;
    dates = "weekly";
    extraArgs = "--keep-since 7d --keep 3";
  };
  documentation = {
    enable = true;
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
    dev.enable = false;
    man.cache.enable = false;
  };
  services.journald.settings.Journal = {
    SystemMaxUse = "100M";
    SystemMaxFileSize = "20M";
    MaxRetentionSec = "1month";
  };
  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    flake-registry = ""; # Prevents fetching global flake-registry.json over the network
    keep-outputs = false;
    keep-derivations = false;
  };

  # Pin nixpkgs registry to active flake input to make `nix run/shell nixpkgs#...` instant
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.channel.enable = false; # Pure flake setup without legacy channel state drift

  # NixOS 24.11+: Verify all systemd unit scripts with shellcheck at build time
  systemd.enableStrictShellChecks = true;

  systemd.coredump.enable = false;
}
