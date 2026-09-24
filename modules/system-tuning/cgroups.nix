{ ... }: {
  # Userspace Out-Of-Memory (OOM) Daemon with Pressure Stall Information (PSI) monitoring
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
    enableSystemSlice = true;
    settings.OOM = {
      DefaultMemoryPressureDurationSec = "20s";
    };
  };

  # Prevent shutdown hangs and service startup lag via structured Manager settings
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
    DefaultTimeoutStartSec = "15s";
  };

  # Prioritize interactive user slices over background background tasks
  systemd.slices = {
    user.sliceConfig = {
      CPUWeight = 100;
      IOWeight = 100;
    };
    system.sliceConfig = {
      CPUWeight = 100;
      IOWeight = 100;
    };
    background.sliceConfig = {
      CPUWeight = 20;
      IOWeight = 20;
    };
  };
}
