{ ... }:
{
  # Disabled by default — set enable = true to re-enable.
  hardware.bluetooth = {
    enable = true;
    # powerOnBoot = true; # auto-power on at boot
    settings.General.Experimental = true; # shows battery % and extra BT info
  };
}
