{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.gaze;
in
{
  options.my.services.gaze = {
    enable = lib.mkEnableOption "Gaze facial authentication daemon, PAM integration, and configuration GUI";
  };

  config = lib.mkIf cfg.enable {
    services.gaze = {
      enable = true;
      gui.enable = true;

      # Enable desktop environment integration when active
      kde = lib.mkIf (config.my.desktop.environment == "kde") {
        lockScreen = true;
        loginScreen = true;
      };

      gnome = lib.mkIf (config.my.desktop.environment == "gnome") {
        enable = true;
      };
    };
  };
}
