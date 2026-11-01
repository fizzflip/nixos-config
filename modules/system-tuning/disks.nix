{ pkgs, ... }: {
  # Preload multi-queue block scheduling modules
  boot.kernelModules = [
    "kyber-iosched"
    "bfq"
  ];

  # Dynamic, hardware-aware I/O scheduler rules
  services.udev.extraRules = ''
    # NVMe SSDs: Kyber enforces read latency targets (<2ms) to prevent Wayland/audio starvation during builds
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="nvme[0-9]*n[0-9]*", ATTR{queue/scheduler}="kyber"
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="nvme[0-9]*n[0-9]*", ATTR{queue/iosched/read_lat_nsec}="2000000"
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="nvme[0-9]*n[0-9]*", ATTR{queue/iosched/write_lat_nsec}="10000000"

    # SATA SSDs: use lightweight mq-deadline
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

    # HDDs / Mechanical: use BFQ for fair queuing and VM I/O isolation
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

    # Enable Runtime PM for SCSI/ATA block devices
    ACTION=="add", SUBSYSTEM=="scsi", ENV{DEVTYPE}=="scsi_device", ATTR{power/control}="auto"

    # Mechanical HDD aggressive power saving: 5-minute spindown (60 * 5s = 300s) and APM 127 on rotational disks
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${pkgs.hdparm}/sbin/hdparm -B 127 -S 60 /dev/%k"
  '';

  # Enable periodic SSD TRIM service (complements btrfs discard=async and handles ext4/vfat)
  services.fstrim.enable = true;

  # Periodic Btrfs scrub for silent bit-rot detection on NVMe storage
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # Place /tmp on NVMe SSD to prevent OOM/ENOSPC failures and ZRAM double-compression during package builds
  boot.tmp = {
    useTmpfs = false;
    cleanOnBoot = true;
  };
}
