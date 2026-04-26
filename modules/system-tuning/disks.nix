{ ... }:
{
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  hardware.block.defaultSchedulerRotational = "bfq";
}
