{ ... }:
{
  security = {
    # userland niceness
    rtkit.enable = true;
    sudo.wheelNeedsPassword = true;
  };
}
