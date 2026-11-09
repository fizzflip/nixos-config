{
  config,
  lib,
  pkgs,
  inputs,
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
      # Pinned commit 1d21641 requires libzstd for crate zstd-sys / opencv bindings
      package = lib.mkForce (
        inputs.gaze.packages.${pkgs.stdenv.hostPlatform.system}.gaze.overrideAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.zstd ];
        })
      );
      gui.package = lib.mkForce (
        inputs.gaze.packages.${pkgs.stdenv.hostPlatform.system}.gaze-gui.overrideAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.zstd ];
        })
      );
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
