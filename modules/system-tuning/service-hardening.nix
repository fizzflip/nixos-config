{ lib, ... }: {
  # Dedicated Systemd Service Hardening Overrides
  # Reduces systemd-analyze security exposure levels across core system services

  systemd.services = {
    # NextDNS DNS Resolver Hardening (Exposure 9.6 UNSAFE -> 2.4 OK)
    nextdns.serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectHostname = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictNamespaces = true;
      NoNewPrivileges = true;
      CapabilityBoundingSet = [
        "CAP_NET_BIND_SERVICE"
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
      ];
      AmbientCapabilities = [
        "CAP_NET_BIND_SERVICE"
      ];
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
        "AF_NETLINK"
      ];
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@clock"
        "~@debug"
        "~@module"
        "~@mount"
        "~@reboot"
        "~@swap"
      ];
    };

    # Man page database indexer hardening (Exposure 8.8 EXPOSED -> 2.1 OK)
    mandb.serviceConfig = {
      ProtectSystem = lib.mkForce "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectHostname = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictNamespaces = true;
      NoNewPrivileges = true;
      CapabilityBoundingSet = "";
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@clock"
        "~@debug"
        "~@module"
        "~@mount"
        "~@reboot"
        "~@swap"
      ];
    };

    # Wireless daemon hardening (Exposure 6.0 MEDIUM -> 5.4 MEDIUM)
    iwd.serviceConfig = {
      ProtectHome = true;
      ProtectSystem = "full";
      PrivateTmp = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      NoNewPrivileges = true;
    };

    # Sched-ext scheduler loader hardening (Exposure 5.6 MEDIUM -> 2.5 OK)
    scx_loader.serviceConfig = {
      ProtectHome = true;
      ProtectSystem = "full";
      PrivateNetwork = true;
      NoNewPrivileges = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
    };

    # Accounts daemon hardening (Exposure 5.5 MEDIUM -> 2.2 OK)
    accounts-daemon.serviceConfig = {
      ProtectHome = "read-only";
      PrivateTmp = lib.mkDefault true;
      ProtectKernelLogs = true;
      ProtectClock = true;
      NoNewPrivileges = true;
      RestrictSUIDSGID = true;
      SystemCallFilter = [
        "@system-service"
        "~@clock"
        "~@debug"
        "~@module"
        "~@reboot"
        "~@swap"
      ];
    };

    # Name service cache daemon hardening (Exposure 8.2 EXPOSED -> 2.8 OK)
    nscd.serviceConfig = {
      ProtectHome = lib.mkForce true;
      ProtectSystem = lib.mkForce "strict";
      PrivateTmp = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      NoNewPrivileges = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    # RFKill state daemon hardening (Exposure 9.4 UNSAFE -> 2.6 OK)
    systemd-rfkill.serviceConfig = {
      ProtectHome = true;
      ProtectSystem = "full";
      PrivateNetwork = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
      MemoryDenyWriteExecute = true;
      RestrictSUIDSGID = true;
    };
  };
}
