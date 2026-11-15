{ lib, ... }: {
  # Modern stage-2 init and declarative filesystem overlay
  system = {
    nixos-init.enable = true;
    etc.overlay.enable = true;
  };

  # Declarative user account lifecycle management (replaces shadow/pam imperative creation)
  services.userborn.enable = true;

  # Lightweight documentation build policy
  documentation = {
    enable = lib.mkDefault true;
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
    dev.enable = false;
    man.cache.enable = false;
  };

  # Controlled system journal retention limits and write-rate limiting to conserve flash wear
  services.journald.settings.Journal = {
    SystemMaxUse = lib.mkDefault "100M";
    SystemMaxFileSize = lib.mkDefault "20M";
    RuntimeMaxUse = lib.mkDefault "50M";
    RateLimitIntervalSec = lib.mkDefault "30s";
    RateLimitBurst = lib.mkDefault 1000;
    MaxRetentionSec = lib.mkDefault "1month";
  };

  # Verify all systemd unit scripts with shellcheck at build time
  systemd.enableStrictShellChecks = true;

  # Disable coredump dumps to conserve storage wear
  systemd.coredump.enable = false;
}
