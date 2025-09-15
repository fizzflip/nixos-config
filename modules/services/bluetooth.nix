{ ... }:
{
  hardware.bluetooth = {
    enable = true;
    # powerOnBoot = true; # optional, auto-power on at boot
    settings.General.Experimental = true; # shows battery % and extra info
  };
}
