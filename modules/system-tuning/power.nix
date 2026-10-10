{
  pkgs,
  lib,
  ...
}:
{
  powerManagement.enable = true;
  # SATA Link Power Management (ALPM): enables DIPM/HIPM link sleep without disk dropouts
  powerManagement.scsiLinkPolicy = "med_power_with_dipm";

  services.thermald.enable = true;
  # Non-adaptive mode prevents crash on machines without complete DPTF/PSVT ACPI tables
  systemd.services.thermald.serviceConfig.ExecStart =
    lib.mkForce "${pkgs.thermald}/sbin/thermald --no-daemon --dbus-enable";
  services.power-profiles-daemon.enable = true;

  # Declarative udev rules for Runtime PM & Peripheral responsiveness
  services.udev.extraRules = ''
    # Enable Runtime Power Management for all PCI devices (unlocks Tiger Lake CPU Package C8/C10 states)
    ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

    # Enable Runtime Power Management for ATA host ports
    ACTION=="add", KERNEL=="ata[0-9]*", ATTR{power/control}="auto"

    # Safeguard USB Optical Mice & HID pointing devices: exempt from autosuspend to eliminate cursor lag
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c077", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ENV{ID_USB_INTERFACES}=="*:030102:*", ATTR{power/control}="on"
  '';
}
