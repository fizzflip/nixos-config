{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    # Enable automatic loading of vendor completions, configs, and functions
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };

    # Disable default welcome greeting & configure colored man pages
    interactiveShellInit = ''
      set -g fish_greeting ""

      # Beautifully colored manual pages
      set -g xp_man_colors 1
      set -g -x LESS_TERMCAP_mb (printf "\e[1;31m")
      set -g -x LESS_TERMCAP_md (printf "\e[1;36m")
      set -g -x LESS_TERMCAP_me (printf "\e[0m")
      set -g -x LESS_TERMCAP_se (printf "\e[0m")
      set -g -x LESS_TERMCAP_so (printf "\e[1;44;33m")
      set -g -x LESS_TERMCAP_ue (printf "\e[0m")
      set -g -x LESS_TERMCAP_us (printf "\e[1;32m")
    '';

    # Modern abbreviations that expand dynamically as they are typed
    shellAbbrs = {
      # Directory listing with eza (modern visual ls replacement)
      ll = "eza -l --icons --git --group-directories-first";
      la = "eza -la --icons --git --group-directories-first";
      lt = "eza --tree --level=2 --icons --git --group-directories-first";

      # Editor shortcut
      edit = "sudo -e";

      # System upgrade & profile-aware rebuild
      rfluid = "sudo nixos-rebuild boot --flake ~/.nixos-config#fluid --verbose --show-trace";
      rminimal = "sudo nixos-rebuild boot --flake ~/.nixos-config#minimal --verbose --show-trace";
      
      ufluid = "sudo nixos-rebuild boot --flake ~/.nixos-config#fluid --verbose --show-trace --upgrade";
      uminimal = "sudo nixos-rebuild boot --flake ~/.nixos-config#minimal --verbose --show-trace --upgrade";

      # Developer convenience helpers
      nconf = "cd ~/.nixos-config";
      nclean = "nh clean all";
      nlog = "git log --oneline -n 10";
    };
  };

  # Smart directory jumping (replaces cd with z/zi)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  # Automatic workspace loader (loads shell.nix / flake.nix environments instantly)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Enable Starship prompt system-wide (automatically configures Fish integration)
  programs.starship.enable = true;

  # Modern developer CLI plugins for Fish
  environment.systemPackages = with pkgs; [
    # Core CLI tools needed by plugins
    fzf grc eza

    # Fish plugins
    fishPlugins.autopair    # Auto-closes parenthesis, brackets, and quotes
    fishPlugins.done        # Notifies when long-running terminal commands complete
    fishPlugins.fzf-fish    # Fast terminal search and navigation with fzf
    fishPlugins.grc         # Generic colorizer for command line output
    fishPlugins.foreign-env # Safely source POSIX/bash scripts in Fish
  ];
}
