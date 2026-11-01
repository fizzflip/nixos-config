_: {
  # Disable systemd-oomd on user slices to protect desktop sessions from abrupt terminations
  systemd.oomd.enable = false;

  # EarlyOOM: Instant userspace OOM intervention targeting runaway compilers while shielding desktop & audio
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    extraArgs = [
      "-r"
      "60"
      "--prefer"
      "(^|/)(cc1plus|rustc|clang|ld\\.lld|ghc|cargo)$"
      "--avoid"
      "(^|/)(niri|foot|waybar|Xwayland|systemd|dbus-daemon|pipewire|wireplumber)$"
    ];
  };

  # Harden EarlyOOM daemon filesystem & capability boundaries
  systemd.services.earlyoom.serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateNetwork = true;
    CapabilityBoundingSet = [
      "CAP_KILL"
      "CAP_SYS_RESOURCE"
    ];
  };

  # Prevent shutdown hangs and service startup lag via structured Manager settings
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
    DefaultTimeoutStartSec = "15s";
  };

  # Prioritize interactive user slices over background tasks
  systemd.slices = {
    user.sliceConfig = {
      CPUWeight = 1000;
      IOWeight = 1000;
    };
    system.sliceConfig = {
      CPUWeight = 100;
      IOWeight = 100;
    };
    background.sliceConfig = {
      CPUWeight = 20;
      IOWeight = 20;
      CPUQuota = "350%";
    };
  };
}
