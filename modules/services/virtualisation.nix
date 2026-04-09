{ pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      autoPrune.enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Virt-manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "mrbot" ];
  virtualisation = {
    libvirtd.nss = {
      enable = true;
      enableGuest = true;
    };
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = [
    pkgs.podman-tui
    pkgs.podman-compose

    pkgs.rlwrap
    pkgs.oracle-instantclient

    pkgs.freerdp
  ];
}
