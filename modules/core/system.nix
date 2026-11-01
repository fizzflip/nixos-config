_: {
  # Modern stage-2 init and declarative filesystem overlay
  system = {
    nixos-init.enable = true;
    etc.overlay.enable = true;
  };

  # Declarative user account lifecycle management (replaces shadow/pam imperative creation)
  services.userborn.enable = true;

  # Lightweight documentation build policy
  documentation = {
    enable = true;
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
    dev.enable = false;
    man.cache.enable = false;
  };

  # Controlled system journal retention limits
  services.journald.settings.Journal = {
    SystemMaxUse = "100M";
    SystemMaxFileSize = "20M";
    MaxRetentionSec = "1month";
  };

  # Verify all systemd unit scripts with shellcheck at build time
  systemd.enableStrictShellChecks = true;

  # Disable coredump dumps to conserve storage wear
  systemd.coredump.enable = false;
}
