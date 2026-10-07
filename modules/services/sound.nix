{
  config,
  lib,
  ...
}:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.extraConfig = {
      # Disable node suspension on idle to eliminate DAC click/pop and audio latency
      "10-disable-suspension" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_input.*"; }
              { "node.name" = "~alsa_output.*"; }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
      };
    }
    // lib.optionalAttrs (!config.hardware.bluetooth.enable) {
      "10-disable-bluetooth" = {
        "wireplumber.profiles" = {
          "main" = {
            "hardware.bluetooth" = "disabled";
          };
        };
      };
    };
  };
  services.pulseaudio.enable = false;
  services.speechd.enable = false;

  # Disable aggressive HDA Intel power saving to prevent hardware analog DAC clicks and pops
  boot.extraModprobeConfig = "options snd_hda_intel power_save=0 power_save_controller=N";
}
