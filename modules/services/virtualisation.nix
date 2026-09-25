{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.virtualisation;
in
{
  config = lib.mkIf cfg.enable {
    # Lightweight Libvirt & KVM hypervisor stack
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm; # Lightweight KVM-only x86_64 build without multi-arch bloat
          runAsRoot = false;       # Non-root daemon execution for hardened security
          swtpm.enable = true;     # Software TPM 2.0 for modern Windows (WinApps / Win 11)
        };
        onBoot = "ignore";         # Don't auto-start VMs on boot: zero idle CPU & RAM overhead
        onShutdown = "shutdown";   # Graceful guest shutdown on host poweroff
        nss = {
          enable = true;           # Resolve guest VM hostnames via NSS
          enableGuest = true;
        };
      };
      spiceUSBRedirection.enable = true; # USB passthrough for virt-manager & WinApps
    };

    # Virt-manager GUI
    programs.virt-manager.enable = true;

    # Grant primary user libvirt & kvm permissions
    users.users.${config.my.user.name}.extraGroups = [
      "libvirtd"
      "kvm"
    ];
  };
}
