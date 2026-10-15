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
          runAsRoot = false; # Non-root daemon execution for hardened security
          swtpm.enable = true; # Software TPM 2.0 for modern Windows (Win 11) and secure guests
          vhostUserPackages = [ pkgs.virtiofsd ]; # Standalone Rust daemon required by QEMU >= 8.0 for virtio-fs
        };
        parallelShutdown = 2;
        onBoot = "ignore"; # Don't auto-start VMs on boot: zero idle CPU & RAM overhead
        onShutdown = "shutdown"; # Graceful guest shutdown on host poweroff
        nss = {
          enable = true; # Resolve guest VM hostnames via NSS
          enableGuest = true;
        };
      };
      spiceUSBRedirection.enable = true; # USB passthrough for virt-manager
    };

    # Virt-manager GUI
    programs.virt-manager.enable = true;

    # Grant primary user libvirt & kvm permissions
    users.users.${config.my.user.name}.extraGroups = [
      "libvirtd"
      "kvm"
    ];

    # Windows guest VM support (virtio-win ISO pool symlink, virt-viewer, nested KVM, MSR protection)
    environment.systemPackages = lib.mkIf cfg.windows.enable [
      pkgs.virt-viewer
    ];

    boot.extraModprobeConfig = lib.mkIf cfg.windows.enable ''
      options kvm_intel nested=1
      options kvm_amd nested=1
      options kvm ignore_msrs=1 report_ignored_msrs=0
    '';

    systemd.tmpfiles.rules = lib.mkIf cfg.windows.enable [
      "L+ /var/lib/libvirt/images/virtio-win.iso - - - - ${pkgs.virtio-win.src}"
    ];
  };
}
