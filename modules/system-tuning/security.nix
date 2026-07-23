{ lib, ... }: {
  security = {
    # Protect kernel image (prevents kexec and modifying kernel memory via /dev/mem)
    protectKernelImage = true;

    # Userland security
    rtkit.enable = true;
    sudo = {
      wheelNeedsPassword = true;
      execWheelOnly = true;
    };
  };

  # Security Hardening Sysctls
  boot.kernel.sysctl = {
    # Filesystem Protection
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = 0;
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # Kernel Protection
    "kernel.yama.ptrace_scope" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;

    # Network Security Hardening
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_redirects" = false;
    "net.ipv4.conf.default.accept_redirects" = false;
    "net.ipv4.conf.all.secure_redirects" = false;
    "net.ipv4.conf.default.secure_redirects" = false;
    "net.ipv6.conf.all.accept_redirects" = false;
    "net.ipv6.conf.default.accept_redirects" = false;
    "net.ipv4.conf.all.send_redirects" = false;
    "net.ipv4.conf.default.send_redirects" = false;
    "net.ipv4.icmp_echo_ignore_broadcasts" = true;
    "net.ipv4.icmp_ignore_bogus_error_responses" = true;
    "net.ipv4.conf.all.log_martians" = true;
    "net.ipv4.conf.default.log_martians" = true;
  };
}
