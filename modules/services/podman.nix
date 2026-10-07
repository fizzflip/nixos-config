{ pkgs, ... }: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [
        "--all"
        "--filter=until=168h"
      ];
    };
  };

  # Unqualified registries for smooth container image pulls
  virtualisation.containers.registries.settings = {
    unqualified-search-registries = [
      "docker.io"
      "quay.io"
      "ghcr.io"
    ];
  };

  environment.systemPackages = [
    pkgs.podman-compose
  ];
}
