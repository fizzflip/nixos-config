{ pkgs, ... }:
{
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
    dsearch = {
      enable = true;
      systemd.enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.libnotify
    pkgs.pulseaudio
    pkgs.lm_sensors
    pkgs.pavucontrol
    pkgs.brightnessctl
    pkgs.hicolor-icon-theme
    pkgs.adwaita-icon-theme
  ];

  fonts.packages = [
    pkgs.noto-fonts
    pkgs.font-awesome
    pkgs.material-icons
    pkgs.noto-fonts-color-emoji
    pkgs.noto-fonts-cjk-sans
    pkgs.helvetica-neue-lt-std
    pkgs.material-design-icons
  ];
}
