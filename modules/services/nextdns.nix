{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.nextdns;
  nextdnsPkg =
    if cfg.reportHostnameOnly then
      pkgs.nextdns.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace run.go \
            --replace-fail "ci.ID = deviceID" "ci.ID = \"\"" \
            --replace-fail "ci.Model = deviceModel" "ci.Model = \"\"; _ = deviceModel"
        '';
      })
    else
      pkgs.nextdns;
in
{
  options.my.services.nextdns = {
    enable = lib.mkEnableOption "NextDNS encrypted DNS proxy";

    configFile = lib.mkOption {
      type = lib.types.path;
      default = "/var/secrets/nextdns.conf";
      description = "Path to NextDNS configuration file containing profile credentials and secrets";
    };

    profile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional NextDNS profile ID if not using a config file";
    };

    reportHostnameOnly = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Sanitize telemetry to transmit only device hostname without hardware model, OS version, or machine ID";
    };
  };

  config = lib.mkIf cfg.enable {
    # Provide the sanitized nextdns CLI tool system-wide without global nixpkgs overlays
    environment.systemPackages = [ nextdnsPkg ];

    services.nextdns = {
      enable = true;
      arguments = [
        "-config-file"
        cfg.configFile
      ]
      ++ lib.optionals (cfg.profile != null) [
        "-profile"
        cfg.profile
      ]
      ++ [
        "-cache-size"
        "20MB" # High-capacity in-memory cache for sub-millisecond repeat resolutions
        "-cache-max-age"
        "24h" # Retain cache across long work sessions
        "-max-inflight-requests"
        "512" # Absorb high-concurrency browser tab bursts
        "-max-inflight-upstream-requests"
        "128" # High upstream concurrency (<= max-inflight-requests / 2)
        "-bogus-priv=true" # Block reverse lookups for private subnets locally (RFC6303)
        "-mdns"
        "disabled" # Disable LAN mDNS discovery to prevent local network scanning
        "-setup-router=false" # Client machine stub resolver only
        "-detect-captive-portals=false" # Prevent unencrypted DNS downgrade attacks
        "-report-client-info=false" # Disable client discovery warning on loopback stub resolver
      ];
    };

    # Resilient systemd service configuration:
    # Decouple from specific interfaces (e.g. cellular USB tether vs Wi-Fi)
    # Fast 3s recovery on network interface changes or disconnects
    systemd.services.nextdns = {
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = lib.mkForce "${nextdnsPkg}/bin/nextdns run ${lib.escapeShellArgs config.services.nextdns.arguments}";
        Restart = lib.mkForce "on-failure";
        RestartSec = lib.mkForce "3s";
      };
    };

    # Route all host DNS queries strictly through the local NextDNS proxy
    networking.nameservers = [ "127.0.0.1" ];

    # Prevent NetworkManager from overwriting /etc/resolv.conf with DHCP nameservers
    networking.networkmanager.dns = "none";
  };
}
