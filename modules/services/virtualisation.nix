{
  config,
  pkgs,
  inputs,
  ...
}:
let
  winpodx = inputs.winpodx.packages.${pkgs.stdenv.hostPlatform.system}.winpodx.overridePythonAttrs (_: {
    doCheck = false;
  });
in
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

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
    pkgs.freerdp
    pkgs.rlwrap
    pkgs.podman-compose
    winpodx
  ];
}
