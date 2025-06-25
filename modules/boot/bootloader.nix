{
  config,
  ...
}:

{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      # useOSProber = true;
      theme = ../../themes/grub/fallout;
    };
    efi.canTouchEfiVariables = true;
  };
}
