{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.my;
in
{
  options.my = {
    user.name = lib.mkOption {
      type = lib.types.str;
      description = "Primary system username.";
    };

    user.authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of verbatim SSH public keys authorized for the primary user. Kept empty by default; managed via ~/.ssh/authorized_keys or per-host overrides.";
    };

    user.authorizedKeyFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "Paths to files containing authorized SSH public keys for the primary user.";
    };

    user.hashedPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default =
        let
          path = "/etc/nixos/passwords/${cfg.user.name}";
        in
        if builtins.pathExists path then path else null;
      description = "Path to the user's hashed password file.";
    };

    user.extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "networkmanager"
        "wheel"
        "i2c"
        "input"
        "wireshark"
      ];
      description = "Extra groups for the primary user.";
    };

    user.shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.fish;
      description = "Default shell for the primary user.";
    };

    configPath = lib.mkOption {
      type = lib.types.str;
      default = "~/.nixos-config";
      description = "Path to the NixOS config repo (used in shell abbreviations).";
    };
  };
}
