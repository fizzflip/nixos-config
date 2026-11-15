{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.spectranet;
in
{
  options.my.services.spectranet = {
    enable = lib.mkEnableOption "spectraNET real-time network monitor, CLI (snet), and desktop GUI";

    daemon = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the background snetd system service for continuous telemetry, blocklists, and socket communication.";
    };

    interval = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Seconds between network traffic samples.";
    };

    feedUpdates = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to automatically fetch blocklist feeds from public sources every 12 hours.";
    };

    metricsAddress = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "127.0.0.1:9790";
      description = "Listen address for Prometheus metrics HTTP server.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional command line arguments passed to snetd run.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [
          config.services.spectranet.package
        ];
      }
      (lib.mkIf cfg.daemon {
        services.spectranet = {
          enable = true;
          inherit (cfg) interval;
          inherit (cfg) feedUpdates;
          inherit (cfg) metricsAddress;
          inherit (cfg) extraArgs;
        };
      })
    ]
  );
}
