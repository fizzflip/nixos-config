{ inputs, ... }: {
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "mrbot"
    ];
  };

  imports = [
    ./hardware-configuration.nix
    ./system-packages.nix
    ../common.nix
  ];

  specialisation.virtualisation.configuration = {
    users.users.mrbot.extraGroups = [
      "adbusers"
      "docker"
    ];
    imports = [
      (inputs.self + "/modules/services/virtualisation.nix")
      (inputs.self + "/modules/services/android.nix")
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
