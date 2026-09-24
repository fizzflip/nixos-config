{
  config,
  inputs,
  ...
}:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      config.my.user.name
    ];
    substituters = [
      "https://cache.nixos.org?priority=10"
      "https://attic.xuyh0120.win/lantian?priority=41"
      "https://cache.xinux.uz?priority=50"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
    ];
  };

  imports = [
    ./hardware-configuration.nix
  ];

  specialisation.lab.configuration = {
    users.users.${config.my.user.name}.extraGroups = [
      "adbusers"
      "podman"
      "docker"
    ];
    imports = [
      (inputs.self + "/modules/services/virtualisation.nix")
      (inputs.self + "/modules/packages/lab/default.nix")
      (inputs.self + "/modules/services/android.nix")
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
