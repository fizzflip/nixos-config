{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # # Enable the sched_ext framework and set bpfland as the default
  # services.scx = {
  #   enable = true;
  #   scheduler = "scx_bpfland";
  # };

  environment.systemPackages = [ pkgs.scx.full ];

  # --- 1. The Power Saver Scheduler ---
  systemd.services.scx-lavd = {
    description = "scx_lavd (Power Saver)";
    # Starting this service automatically stops the others
    conflicts = [
      "scx-bpfland.service"
      "scx-rusty.service"
    ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.scx.full}/bin/scx_lavd";
    };
  };

  # --- 2. The Balanced Scheduler ---
  systemd.services.scx-bpfland = {
    description = "scx_bpfland (Balanced)";
    conflicts = [
      "scx-lavd.service"
      "scx-rusty.service"
    ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.scx.full}/bin/scx_bpfland";
    };
  };

  # --- 3. The Performance Scheduler ---
  systemd.services.scx-rusty = {
    description = "scx_rusty (Performance)";
    conflicts = [
      "scx-lavd.service"
      "scx-bpfland.service"
    ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.scx.full}/bin/scx_rusty";
    };
  };

  # --- 4. Sudo Permissions for the Script ---
  security.sudo.extraRules = [
    {
      users = [ "mrbot" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start scx-lavd.service";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl start scx-bpfland.service";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl start scx-rusty.service";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop scx-lavd.service scx-bpfland.service scx-rusty.service";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Load network congestion control modules
  boot.kernelModules = [ "tcp_bbr" ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;

    # TCP BBR Congestion Control & Network Optimizations
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_mtu_probing" = 1;
  };
}
