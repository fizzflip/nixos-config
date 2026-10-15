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

    services.printing.enable = lib.mkEnableOption "CUPS printing service and discovery";

    services.virtualisation = {
      enable = lib.mkEnableOption "Libvirt/KVM virtualization stack with QEMU, virt-manager, and SWTPM";
      windows = {
        enable = lib.mkEnableOption "Windows guest VM support (virtio-win ISO pool symlink, virt-viewer, nested KVM, MSR protection)";
      };
    };

    users.nini.enable = lib.mkEnableOption "Secondary user profile nini";

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

    packages.artcraft = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = !config.my.packages.minimal;
        description = "Enable the ArtCraft productivity suite (PdfCraft, WordCraft).";
      };
      pdfcraft = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install PdfCraft (offline PDF reader & editor).";
      };
      wordcraft = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install WordCraft (clean-room Microsoft Word alternative).";
      };
      setDefaultMimeTypes = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Register ArtCraft apps as default MIME handlers for PDF and document formats.";
      };
    };
  };
}
