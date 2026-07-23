{ ... }: {
  # Dynamic, hardware-aware I/O scheduler rules
  services.udev.extraRules = ''
    # NVMe SSDs: bypass scheduling entirely to maximize parallel IOPS
    ACTION=="add|change", KERNEL=="nvme*", ATTR{queue/scheduler}="none"

    # SATA SSDs: use lightweight mq-deadline
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

    # HDDs / Mechanical: use BFQ for fair queuing
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
  '';

  # Enable i2c for ddcutil (display brightness/colour via DDC/CI)
  # Loads i2c-dev module, creates the i2c group, sets udev rules
  hardware.i2c.enable = true;

  # Enable periodic SSD TRIM service (complements btrfs discard=async and handles ext4/vfat)
  services.fstrim.enable = true;

  # Mount /tmp on compressed tmpfs in RAM/ZRAM to reduce SSD write wear
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };
}
