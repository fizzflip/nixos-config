{ pkgs, ... }: {
  programs = {
    dms-shell = {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
      enableClipboardPaste = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableSystemMonitoring = true;
    };
  };

  services.upower.enable = true;
  security.pam.services.dankshell = { };

  environment.systemPackages = [
    pkgs.libnotify
    pkgs.pulseaudio
    pkgs.lm_sensors
    pkgs.pavucontrol
    pkgs.brightnessctl
    pkgs.hicolor-icon-theme
    pkgs.adwaita-icon-theme
  ];
}
