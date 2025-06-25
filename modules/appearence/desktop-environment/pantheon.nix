{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.xserver.enable = true;

  # Enable LightDM (recommended for Pantheon)
  services.xserver.displayManager.lightdm.enable = true;

  # Enable Pantheon desktop
  services.xserver.desktopManager.pantheon.enable = true;

  # (Optional) If you just want the desktop environment itself without its default apps:
  # services.pantheon.apps.enable = false;

  # (Optional) Customize Wingpanel or Switchboard plugins:
  # services.xserver.desktopManager.pantheon.extraWingpanelIndicators = [ pkgs.someIndicator ];
  # services.xserver.desktopManager.pantheon.extraSwitchboardPlugs = [ pkgs.somePlug ];
}
