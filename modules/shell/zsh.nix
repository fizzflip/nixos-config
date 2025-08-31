{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.starship ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      zsh-autoenv.enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        edit = "sudo -e";
        update = "sudo nixos-rebuild switch --fast";
      };

      ohMyZsh = {
        enable = true;
        theme = "agnoster";
        plugins = [
          "git"
          "python"
          "man"
          "npm"
          "history"
          "starship"
          "podman"
          "nmap"
        ];
      };
    };
  };
}
