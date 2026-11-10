{
  config,
  lib,
  ...
}:
{
  options.my.users.nini = {
    enable = lib.mkEnableOption "Secondary user profile nini";
  };

  config = lib.mkIf config.my.users.nini.enable {
    users.users.nini = {
      isNormalUser = true;
      homeMode = "0700";
      description = "nini";
      hashedPasswordFile = lib.mkDefault (
        if builtins.pathExists "/etc/nixos/passwords/nini" then "/etc/nixos/passwords/nini" else null
      );
      extraGroups = [ ];
    };
  };
}
