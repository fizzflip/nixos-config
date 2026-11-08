{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.secrets;
in
{
  options.my.services.secrets = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable modern memory-safe oo7 Secret Service and Portal provider.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable upstream oo7 daemon, D-Bus activation, capability wrapper, and portal
    services.oo7.enable = true;

    # Suppress legacy GNOME Keyring to prevent D-Bus service contention
    services.gnome.gnome-keyring.enable = lib.mkForce false;

    # Enable PAM auto-unlocking on login
    security.pam.services.sddm.oo7.enable = true;
    security.pam.services.login.oo7.enable = true;

    # Modern Libadwaita GUI secret viewer/editor
    environment.systemPackages = [ pkgs.key-rack ];
  };
}
