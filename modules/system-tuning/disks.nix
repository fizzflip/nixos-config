{
  config,
  lib,
  pkgs,
  ...
}:
{
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
  '';

  # Enable periodic SSD TRIM service (complements btrfs discard=async and handles ext4/vfat)
  services.fstrim.enable = lib.mkDefault true;

  # Periodic Btrfs scrub for silent bit-rot detection on Btrfs storage
  services.btrfs.autoScrub = {
    enable = lib.mkDefault ((config.fileSystems."/".fsType or "") == "btrfs");
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # Place /tmp on NVMe SSD to prevent OOM/ENOSPC failures and ZRAM double-compression during package builds
  boot.tmp = {
    useTmpfs = lib.mkDefault false;
    cleanOnBoot = lib.mkDefault true;
  };
}
