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
    # Upgrade oo7 suite (oo7-cli, oo7-server, oo7-portal) to 0.7.0
    # Fixes collection lowercase naming and alias resolution (/org/freedesktop/secrets/aliases/default)
    # required by zalando/go-keyring and gh auth login.
    nixpkgs.overlays = [
      (final: prev: {
        oo7 = prev.oo7.overrideAttrs (_old: {
          version = "0.7.0";
          src = prev.fetchFromGitHub {
            owner = "linux-credentials";
            repo = "oo7";
            tag = "0.7.0";
            hash = "sha256-/KMrRa/Rj1zE1ge7h01yG8dsCCpUnTytcF5kIBbKNpQ=";
          };
          cargoHash = "sha256-9o2nR8b06KSHLbQdlcWAq4bWUz273qCk9qsl3D/XJso=";
        });
      })
    ];

    # Enable upstream oo7 daemon, D-Bus activation, capability wrapper, and portal
    services.oo7.enable = true;

    # Route Secret interface to oo7-portal backend system-wide
    xdg.portal.config.common."org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];

    # Suppress legacy GNOME Keyring to prevent D-Bus service contention
    services.gnome.gnome-keyring.enable = lib.mkForce false;

    # Enable PAM auto-unlocking on login
    security.pam.services.sddm.oo7.enable = true;
    security.pam.services.login.oo7.enable = true;

    # Modern Libadwaita GUI secret viewer/editor and CLI
    environment.systemPackages = [
      pkgs.key-rack
      pkgs.oo7
    ];
  };
}
