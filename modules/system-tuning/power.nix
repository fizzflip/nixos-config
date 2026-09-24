{ pkgs, lib, ... }: {
  powerManagement.enable = true;
  services.thermald.enable = true;
  # Non-adaptive mode prevents crash on machines without complete DPTF/PSVT ACPI tables
  systemd.services.thermald.serviceConfig.ExecStart = lib.mkForce "${pkgs.thermald}/sbin/thermald --no-daemon --dbus-enable";
  services.power-profiles-daemon.enable = true;
}
