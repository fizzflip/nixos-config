{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../modules/appearance/desktop-environment/niri.nix
    ../../modules/appearance/components/dms.nix
    ../../modules/shell/fish.nix
    ../../modules/appearance/fonts.nix
    ../../users/mrbot.nix
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
  networking.hostName = "preview";

  # Dummy file systems and bootloader for evaluation (VM builder will override this)
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  boot.loader.grub.devices = [ "nodev" ];

  # Use default kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  # Enable graphics (Mesa drivers) - required for Wayland to start!
  hardware.graphics.enable = true;

  # Prevent Weston core dumps in the VM by forcing SDDM to use X11 instead of Wayland
  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = lib.mkForce false;

  # Basic networking and sound required for a desktop
  networking.networkmanager.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  virtualisation.vmVariant = {
    virtualisation.memorySize = 4096;
    virtualisation.cores = 4;
    virtualisation.resolution = {
      x = 1920;
      y = 1080;
    };
    virtualisation.qemu.options = [
      "-vga none"
      "-device virtio-vga-gl"
      "-display gtk,gl=on"
    ];
    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "pixman";
      LIBGL_ALWAYS_SOFTWARE = "1";
    };
    users.users.mrbot.hashedPasswordFile = lib.mkForce null;
    users.users.mrbot.password = "nixos";
  };
}
