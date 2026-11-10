{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.jellyfin;
in
{
  options.my.services.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin Media Server with Ivy Bridge VA-API acceleration and RAM caching";

    mediaDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/jellyfin/media";
      description = "Default media storage directory.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;

      # RAM-backed transcode cache to prevent continuous disk writes and seek thrashing on rotational HDD
      cacheDir = "/tmp/jellyfin-cache";

      # Hardware acceleration tuned for Intel Quick Sync Video (QSV / VA-API)
      hardwareAcceleration = {
        enable = true;
        type = "vaapi";
        device = "/dev/dri/renderD128";
      };

      # Transcode profile tuned specifically for Ivy Bridge Gen 7 (HD 2500 / Pentium G2030)
      transcoding = {
        enableHardwareEncoding = true;
        enableIntelLowPowerEncoding = false; # Unsupported on Ivy Bridge (Gen 9+ only)
        enableToneMapping = false; # Unsupported on Ivy Bridge HD 2500 (requires OpenCL compute)
        enableSubtitleExtraction = true; # Delivers subtitles as text to avoid burning via CPU
        throttleTranscoding = true; # Bounded CPU and RAM pressure
        threadCount = 2; # Dual-core Pentium G2030
        deleteSegments = true;

        hardwareDecodingCodecs = {
          h264 = true;
          mpeg2 = true;
          vc1 = true;
        };

        hardwareEncodingCodecs = {
          hevc = false;
          av1 = false;
        };
      };
    };

    # Grant Jellyfin access to GPU render nodes and video devices
    users.users.jellyfin.extraGroups = [
      "video"
      "render"
    ];

    # Ensure media and cache directories exist with appropriate permissions
    systemd.tmpfiles.rules = [
      "d ${cfg.mediaDir} 0775 ${config.my.user.name} jellyfin -"
      "d /tmp/jellyfin-cache 0770 jellyfin jellyfin 1d"
    ];
  };
}
