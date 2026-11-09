{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.hardware.rotationalHdd;
in
{
  options.my.hardware.rotationalHdd = {
    enable = lib.mkEnableOption "Mechanical rotational HDD wear protection, BFQ I/O scheduler, and ZRAM swap priority";
  };

  config = lib.mkIf cfg.enable {
    # 2. Udev rules: BFQ scheduler, SATA ALPM max_performance, and disable APM head parking
    services.udev.extraRules = ''
      # Rotational HDD: assign BFQ fair queue scheduler to minimize seek starvation
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

      # SATA ALPM max_performance: prevents COMINIT/COMWAKE bus dropouts on degraded SATA links
      ACTION=="add", SUBSYSTEM=="scsi_host", ATTR{link_power_management_policy}="max_performance"

      # Disable APM head parking & spindown on enterprise/degraded drives to prevent head wear
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
    '';

    # 3. Kernel parameters: disable SATA link power management at kernel level
    boot.kernelParams = [ "ahci.mobile_lpm_policy=0" ];

    # 4. Storage failure mitigations: volatile RAM logging & SMART monitoring
    services.journald.settings.Journal = {
      Storage = "volatile";
      RuntimeMaxUse = "64M";
      RuntimeMaxFileSize = "8M";
    };
    services.smartd = {
      enable = true;
      notifications.wall.enable = true;
      notifications.systembus-notify.enable = true;
    };
  };
}
