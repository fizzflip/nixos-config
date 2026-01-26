{ ... }:
{
  programs = {
    dms-shell = {
      enable = true;
      # systemd = {
      #   enable = true;
      #   restartIfChanged = true;
      # };
      enableClipboardPaste = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableSystemMonitoring = true;
    };
    dsearch = {
      enable = true;
      # systemd.enable = true;
    };
  };
}
