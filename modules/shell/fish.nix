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

    # Disable the default welcome greeting
    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    # Modern abbreviations that expand dynamically as they are typed
    shellAbbrs = {
      # Standard tools
      ll = "ls -l";
      edit = "sudo -e";

      # System upgrade & rebuild (matching the Zsh aliases)
      update = "sudo nixos-rebuild boot --flake ~/.nixos-config#minimal --verbose --show-trace";
      upgrade = "sudo nixos-rebuild boot --flake ~/.nixos-config#minimal --verbose --show-trace --upgrade";

      # Developer convenience helpers
      nconf = "cd ~/.nixos-config";
      nclean = "sudo nix-collect-garbage -d";
      nlog = "git log --oneline -n 10";
    };
  };

  # Enable Starship prompt system-wide (automatically configures Fish integration)
  programs.starship.enable = true;

  # Modern developer CLI plugins for Fish
  environment.systemPackages = with pkgs; [
    # Core CLI tools needed by plugins
    fzf grc

    # Fish plugins
    fishPlugins.autopair    # Auto-closes parenthesis, brackets, and quotes
    fishPlugins.done        # Notifies when long-running terminal commands complete
    fishPlugins.fzf-fish    # Fast terminal search and navigation with fzf
    fishPlugins.grc         # Generic colorizer for command line output
    fishPlugins.foreign-env # Safely source POSIX/bash scripts in Fish
  ];
}
