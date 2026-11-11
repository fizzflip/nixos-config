{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.dedup;
in
{
  options.my.services.dedup = {
    enable = lib.mkEnableOption "scheduled Btrfs extent-level deduplication via duperemove";

    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/home"
        "/nix"
      ];
      description = "List of directories or Btrfs subvolumes to recursively scan and deduplicate.";
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "weekly";
      description = "Systemd timer OnCalendar schedule for scheduled deduplication.";
    };

    batchSize = lib.mkOption {
      type = lib.types.int;
      default = 500;
      description = "Number of files to batch during extent submission to keep memory usage minimal.";
    };

    blockSize = lib.mkOption {
      type = lib.types.str;
      default = "128k";
      description = "Extent block size (128k aligns with Btrfs transparent zstd compression chunk limit).";
    };

    hashFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/cache/duperemove/hashfile.db";
      description = "Path to sqlite hash database for incremental change tracking across runs.";
    };

    threads = lib.mkOption {
      type = lib.types.int;
      default = 2;
      description = "Number of CPU and I/O worker threads for hashing and deduplication.";
    };

    conditionACPower = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Only execute deduplication when connected to AC power to preserve laptop battery.";
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "--skip-zeroes" ];
      description = "Additional command line options passed to duperemove.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.duperemove ];

    systemd.services.duperemove = {
      description = "Btrfs Extent Deduplication Service (duperemove)";
      unitConfig = lib.mkIf cfg.conditionACPower {
        ConditionACPower = true;
      };
      serviceConfig = {
        Type = "oneshot";
        CacheDirectory = "duperemove";
        Nice = 19;
        IOSchedulingClass = "idle";
        IOSchedulingPriority = 7;
        MemoryMax = "1G";
        ExecStart = lib.concatStringsSep " " (
          [
            "${pkgs.duperemove}/bin/duperemove"
            "-r"
            "-d"
            "--batchsize=${toString cfg.batchSize}"
            "--hashfile=${cfg.hashFile}"
            "-b"
            cfg.blockSize
            "--io-threads=${toString cfg.threads}"
            "--cpu-threads=${toString cfg.threads}"
          ]
          ++ cfg.extraOptions
          ++ cfg.paths
        );
      };
    };

    systemd.timers.duperemove = {
      description = "Weekly Btrfs Extent Deduplication Timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.interval;
        Persistent = true;
        RandomizedDelaySec = "1800";
      };
    };
  };
}
