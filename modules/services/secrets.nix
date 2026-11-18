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
      description = "Enable standard GNOME Keyring Secret Service with PAM auto-unlocking and Portal integration.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable GNOME Keyring daemon, D-Bus activation, capability wrapper, and portal
    services.gnome.gnome-keyring.enable = true;

    # Explicitly ensure oo7 is disabled
    services.oo7.enable = lib.mkForce false;

    # Route Secret interface to gnome-keyring backend system-wide
    xdg.portal.config.common."org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];

    # Enable PAM auto-unlocking on login (SDDM display manager and text console)
    security.pam.services.sddm.enableGnomeKeyring = true;
    security.pam.services.login.enableGnomeKeyring = true;

    # Upstream SDDM sets useDefaultRules = false, which causes NixOS to ignore enableGnomeKeyring.
    # Explicitly hook pam_gnome_keyring into SDDM after substack login to capture the auth token
    # and automatically unlock login.keyring upon graphical login.
    security.pam.services.sddm.rules = {
      auth.gnome-keyring = {
        order = 11200;
        control = "optional";
        modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so";
      };
      session.gnome-keyring = {
        order = 11200;
        control = "optional";
        modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so";
        args = [ "auto_start" ];
      };
      password.gnome-keyring = {
        order = 11200;
        control = "optional";
        modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so";
        args = [ "use_authtok" ];
      };
    };

    # GNOME Keyring graphical manager (Seahorse)
    environment.systemPackages = [
      pkgs.seahorse
    ];
  };
}
