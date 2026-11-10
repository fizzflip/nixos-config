{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.sunshine;
in
{
  options.my.services.sunshine = {
    enable = lib.mkEnableOption "Sunshine self-hosted game & desktop streaming server for Moonlight";

    forceVirtualDisplay = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Force digital connector active via kernel parameter (video=HDMI-A-1:1920x1080@60D) for headless streaming without a physical monitor.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      capSysAdmin = true;
    };

    # Input device injection for Moonlight virtual gamepad, mouse, and keyboard
    hardware.uinput.enable = true;

    # Ensure user has access to input/video subsystems and enable lingering on headless servers
    users.users.${config.my.user.name} = {
      extraGroups = [
        "input"
        "video"
        "uinput"
      ];
      linger = lib.mkDefault (config.my.desktop.environment == "none");
    };

    systemd.user.services.sunshine = lib.mkIf (config.my.desktop.environment == "none") {
      wantedBy = lib.mkForce [ "default.target" ];
      partOf = lib.mkForce [ ];
    };

    # Kernel parameter to force an active 1080p@60Hz display connector when no physical monitor is plugged in
    boot.kernelParams = lib.mkIf cfg.forceVirtualDisplay [
      "video=HDMI-A-1:1920x1080@60D"
    ];
  };
}
