{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.hardware.powerManagement;
in
{
  options.my.hardware.powerManagement = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable laptop power management, thermald, power-profiles-daemon, and PCI runtime PM.";
    };
  };

  config = lib.mkIf cfg.enable {
    powerManagement.enable = true;
    # SATA Link Power Management (ALPM): enables DIPM/HIPM link sleep without disk dropouts
    powerManagement.scsiLinkPolicy = "med_power_with_dipm";

    services.thermald.enable = true;
    # Non-adaptive mode prevents crash on machines without complete DPTF/PSVT ACPI tables, with service sandboxing
    systemd.services.thermald.serviceConfig = {
      ExecStart = lib.mkForce "${pkgs.thermald}/sbin/thermald --no-daemon --dbus-enable";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateNetwork = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
    };

    services.power-profiles-daemon.enable = true;
    systemd.services.power-profiles-daemon.serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateNetwork = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
    };

    # Declarative udev rules for Runtime PM & Peripheral responsiveness
    services.udev.extraRules = ''
      # Enable Runtime Power Management for all PCI devices (unlocks Tiger Lake CPU Package C8/C10 states)
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

      # Enable Runtime Power Management for ATA host ports
      ACTION=="add", KERNEL=="ata[0-9]*", ATTR{power/control}="auto"
    '';
  };
}
