{ ... }:
{
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "monthly";
  };

  hardware.block.defaultSchedulerRotational = "bfq";
}
