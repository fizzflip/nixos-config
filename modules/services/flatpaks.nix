{ ... }:
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
  };
}
