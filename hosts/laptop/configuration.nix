{
  inputs,
  config,
  pkgs,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    ../../hosts/laptop/hardware-configuration.nix
    ../../hosts/laptop/system-packages.nix

    # ../../modules/appearence/desktop-environment/kde.nix
    ../../modules/appearence/desktop-environment/niri.nix
    # ../../modules/appearence/desktop-environment/gnome.nix
    # ../../modules/appearence/desktop-environment/hyprland.nix
    ../../modules/appearence/fonts.nix

    ../common.nix
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # programs.zsh.enable = true;

  # enable zsh and oh my zsh

  # programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
