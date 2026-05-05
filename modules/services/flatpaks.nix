{ lib, ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "com.github.tchx84.Flatseal"
      "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
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
      Restart = "on-failure";
      RestartSec = lib.mkForce "10s";
      # Disable the burst limit so RestartSec is used immediately
      StartLimitIntervalSec = 0;
    };
  };
}
