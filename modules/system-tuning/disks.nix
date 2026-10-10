{ pkgs, ... }: {
  # Dynamic, hardware-aware I/O scheduler rules
  services.udev.extraRules = ''
    # NVMe SSDs: bypass scheduling entirely to maximize parallel IOPS on block namespace devices
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="nvme[0-9]*n[0-9]*", ATTR{queue/scheduler}="none"

    # SATA SSDs: use lightweight mq-deadline
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

    # HDDs / Mechanical: use BFQ for fair queuing
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

    # Enable Runtime PM for SCSI/ATA block devices
    ACTION=="add", SUBSYSTEM=="scsi", ENV{DEVTYPE}=="scsi_device", ATTR{power/control}="auto"

    # Mechanical HDD aggressive power saving: 5-minute spindown (60 * 5s = 300s) and APM 127 on rotational disks
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${pkgs.hdparm}/sbin/hdparm -B 127 -S 60 /dev/%k"
  '';

  # Enable i2c for ddcutil (display brightness/colour via DDC/CI)
  # Loads i2c-dev module, creates the i2c group, sets udev rules
  hardware.i2c.enable = true;

  # Enable periodic SSD TRIM service (complements btrfs discard=async and handles ext4/vfat)
  services.fstrim.enable = true;

  # Periodic Btrfs scrub for silent bit-rot detection on NVMe storage
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # Mount /tmp on compressed tmpfs in RAM/ZRAM to reduce SSD write wear
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };
}
