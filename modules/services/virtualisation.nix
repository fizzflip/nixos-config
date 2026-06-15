{ pkgs, ... }: {
  virtualisation.docker.enable = true;

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
    pkgs.oracle-instantclient
    pkgs.winboat
    pkgs.freerdp
    pkgs.rlwrap
  ];
}
