{ ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;

  # Power down HDA Intel audio codec hardware when idle
  boot.extraModprobeConfig = "options snd_hda_intel power_save=1 power_save_controller=Y";
}
