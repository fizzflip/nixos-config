{
  config,
  pkgs,
  ...
}:
{
  # Virt-manager & Libvirt
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
    pkgs.freerdp
    pkgs.rlwrap
    pkgs.podman-compose
  ];
}
