{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgPath = config.my.configPath;
in
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

      # Terminal ANSI syntax highlighting & pager (auto-adapts to DMS / Matugen theme)
      set -g fish_color_normal normal
      set -g fish_color_command cyan --bold
      set -g fish_color_keyword blue --bold
      set -g fish_color_quote green
      set -g fish_color_redirection magenta
      set -g fish_color_end yellow
      set -g fish_color_error red
      set -g fish_color_param normal
      set -g fish_color_comment brblack
      set -g fish_color_selection --reverse
      set -g fish_color_search_match --reverse
      set -g fish_color_operator cyan
      set -g fish_color_escape yellow
      set -g fish_color_autosuggestion brblack
      set -g fish_pager_color_prefix cyan --bold
      set -g fish_pager_color_completion normal
      set -g fish_pager_color_description brblack
      set -g fish_pager_color_progress cyan

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
      rfluid = "sudo nixos-rebuild boot --flake ${cfgPath}#fluid --verbose --show-trace";
      rminimal = "sudo nixos-rebuild boot --flake ${cfgPath}#minimal --verbose --show-trace";

      ufluid = "sudo nixos-rebuild boot --flake ${cfgPath}#fluid --verbose --show-trace --upgrade";
      uminimal = "sudo nixos-rebuild boot --flake ${cfgPath}#minimal --verbose --show-trace --upgrade";

      # Developer convenience helpers
      nconf = "cd ${cfgPath}";
      nclean = "nh clean all";
      nlog = "git log --oneline -n 10";
      nfmt = "nix fmt";
      ncheck = "nix flake check";
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

  # Enable Starship prompt system-wide with adaptive Material theme styling
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      # Style 1: Modern Two-Line Layout with status indicators and pushed execution duration
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$package"
        "$rust"
        "$python"
        "$nodejs"
        "$golang"
        "$c"
        "$fill"
        "$cmd_duration"
        "$jobs"
        "$line_break"
        "$character"
      ];

      fill.symbol = " ";

      directory = {
        style = "bold cyan";
        read_only = " 󰌾";
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
        format = "on [$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold yellow";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "🏳 ";
        ahead = "⇡\${count} ";
        behind = "⇣\${count} ";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count} ";
        untracked = "?\${count} ";
        stashed = "📦 ";
        modified = "!\${count} ";
        staged = "+\${count} ";
        renamed = "»\${count} ";
        deleted = "✘\${count} ";
      };

      nix_shell = {
        symbol = "❄️ ";
        style = "bold blue";
        format = "via [$symbol($name )]($style)";
        heuristic = true;
      };

      cmd_duration = {
        min_time = 2000;
        style = "dimmed yellow";
        format = "took [$duration]($style) ";
      };

      jobs = {
        symbol = "✦";
        style = "bold yellow";
        format = "[$symbol$number]($style) ";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      rust = {
        symbol = "🦀 ";
        style = "bold red";
        format = "via [$symbol($version )]($style)";
      };

      python = {
        symbol = "🐍 ";
        style = "bold yellow";
        format = "via [$symbol($version )]($style)";
      };

      nodejs = {
        symbol = "󰎙 ";
        style = "bold green";
        format = "via [$symbol($version )]($style)";
      };

      golang = {
        symbol = "🐹 ";
        style = "bold cyan";
        format = "via [$symbol($version )]($style)";
      };

      c = {
        symbol = "🅒 ";
        style = "bold blue";
        format = "via [$symbol($version )]($style)";
      };

      package = {
        symbol = "📦 ";
        style = "dimmed white";
        format = "is [$symbol$version]($style) ";
      };
    };
  };

  # Modern developer CLI plugins for Fish
  environment.systemPackages = [
    # Core CLI tools needed by plugins
    pkgs.fzf
    pkgs.grc
    pkgs.eza

    # Fish plugins
    pkgs.fishPlugins.autopair # Auto-closes parenthesis, brackets, and quotes
    pkgs.fishPlugins.done # Notifies when long-running terminal commands complete
    pkgs.fishPlugins.fzf-fish # Fast terminal search and navigation with fzf
    pkgs.fishPlugins.grc # Generic colorizer for command line output
    pkgs.fishPlugins.foreign-env # Safely source POSIX/bash scripts in Fish
  ];
}
