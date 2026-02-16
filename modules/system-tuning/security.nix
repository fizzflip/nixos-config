{ ... }:
{
  security = {
    # userland niceness
    rtkit.enable = true;
    # don't ask for password for wheel group
    sudo.wheelNeedsPassword = false;
  };
}
