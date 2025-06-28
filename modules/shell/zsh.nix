{ pkgs, config, ... }:

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

# shell.nix

# { pkgs, ... }: {
#   environment.systemPackages = with pkgs; [ zsh-powerlevel10k ];
#   programs.zsh = {
#     enable = true;
#     enableCompletion = true;
#     enableBashCompletion = true;
#     autosuggestions.enable = true;
#     syntaxHighlighting.enable = true;
#     histSize = 10000;
#     # shellAliases = {
#     #   #...
#     # };
#     setOptions = [
#       "AUTO_CD"
#     ]
#     # prompInit = ''
#     #   source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
#     # '';
#     ohMyZsh = {
#       enable = true;
#       plugins = [ "git" "dirhistory" "history" ];
#     };
#   };
#   users.defaultUserShell = pkgs.zsh;
#   system.userActivationScripts.zshrc = "touch .zshrc";
#   environment.shells = with pkgs; [ zsh ];
# }
