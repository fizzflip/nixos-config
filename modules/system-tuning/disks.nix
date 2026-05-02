{ ... }:
{
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  hardware.block.defaultSchedulerRotational = "bfq";
  # Enable i2c for ddcutil (display brightness/colour via DDC/CI)
  # Loads i2c-dev module, creates the i2c group, sets udev rules
  hardware.i2c.enable = true;
}
