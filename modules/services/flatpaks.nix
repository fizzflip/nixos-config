{ ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
      "app.zen_browser.zen"
      "com.github.tchx84.Flatseal"
    ];
    update.onActivation = true;
    uninstallUnmanaged = true;
  };
}
