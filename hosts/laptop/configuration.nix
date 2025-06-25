# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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

    # ../../modules/appearence/kde.nix
    # ../../modules/appearence/pantheon.nix
    ../../modules/appearence/desktop-environment/niri.nix
    # ../../modules/appearence/gnome.nix
    # ../../modules/appearence/hyprland.nix
    ../../modules/appearence/fonts.nix

    ../common.nix

    # (if config.userInterface == "gnome" then ./modules/gnome.nix else null)
    # (if config.userInterface == "hyprland" then ./modules/hyprland.nix else null)
  ];

  # userInterface = = "gnome";

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # programs.zsh.enable = true;

  # enable zsh and oh my zsh

  # programs.nix-ld.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
