{ config, ... }:
let
  cfg = config.my.user;
in
{
  imports = [
    ./nini.nix
  ];

  users.users.${cfg.name} = {
    isNormalUser = true;
    homeMode = "0700";
    inherit (cfg) shell;
    inherit (cfg) extraGroups;
    openssh.authorizedKeys.keys = cfg.authorizedKeys;
    hashedPasswordFile =
      if cfg.hashedPasswordFile != null && builtins.pathExists cfg.hashedPasswordFile then
        cfg.hashedPasswordFile
      else
        null;
  };
}
