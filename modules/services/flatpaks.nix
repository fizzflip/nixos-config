{ lib, ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
      "com.unity.UnityHub"
      "app.zen_browser.zen"
      "com.github.tchx84.Flatseal"
    ];
    update.onActivation = true;
    uninstallUnmanaged = true;
  };
  systemd.services.flatpak-managed-install = {
    wants = [ "network-online.target" ];
    after = [
      "network-online.target"
      "nextdns.service"
    ];
    serviceConfig = {
      # Wait for a real default route before attempting DNS — avoids the boot
      # network race caused by NetworkManager-wait-online being disabled.
      ExecStartPre = [
        ""
        "${/bin/sh} -c 'for i in $(seq 1 15); do ip route get 1.1.1.1 &>/dev/null && break; sleep 2; done'"
      ];
      Restart = "on-failure";
      RestartSec = "10s";
      # Disable the burst limit so RestartSec is used immediately
      StartLimitIntervalSec = 0;
    };
  };
}
