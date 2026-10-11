{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.my.users.nini.enable {
  users.users.nini = {
    isNormalUser = true;
    description = "nini";
    hashedPasswordFile = lib.mkDefault (
      if builtins.pathExists "/etc/nixos/passwords/nini" then "/etc/nixos/passwords/nini" else null
    );
    initialHashedPassword = "$6$hOO/0lRLLWfwNp6h$B2LSv0GFi1NC1aABLYJ.3CZUpIBXCp5xfkKpBdw9f9nlTXb15Ao3WWuKob2SYVXov/ml0/RGorosWqmNUsha70";
    extraGroups = [ ];
    packages = [
      pkgs.google-chrome
    ];
  };
}
