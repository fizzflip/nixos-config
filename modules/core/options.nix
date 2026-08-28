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

    user.hashedPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = "/etc/nixos/passwords/${cfg.user.name}";
      description = "Path to the user's hashed password file.";
    };

    user.extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "networkmanager"
        "wheel"
        "kvm"
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

    desktop.environment = lib.mkOption {
      type = lib.types.enum [
        "niri"
        "kde"
        "gnome"
        "none"
      ];
      default = "none";
      description = "Desktop environment to enable.";
    };

    configPath = lib.mkOption {
      type = lib.types.str;
      default = "~/.nixos-config";
      description = "Path to the NixOS config repo (used in shell abbreviations).";
    };

    packages.minimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When enabled, installs only core CLI tools and desktop essentials, omitting heavy IDEs, media, internet applications, and flatpaks.";
    };
  };
}
