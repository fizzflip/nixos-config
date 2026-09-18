{
  config,
  pkgs,
  ...
}:
{
  virtualisation.docker.enable = true;

  # Virt-manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ config.my.user.name ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
      nss = {
        enable = true;
        enableGuest = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = [
    pkgs.oracle-instantclient
    # pkgs.winboat
    pkgs.freerdp
    pkgs.rlwrap
  ];
}
