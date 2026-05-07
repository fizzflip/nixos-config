{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    settings.yazi = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        mouse_events = [
          "click"
          "scroll"
        ];
        ratio = [
          1
          4
          3
        ];
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      opener = {
        edit = [
          {
            run = ''''${EDITOR:-vi} "$@"'';
            block = true;
            desc = "Edit";
          }
        ];
        play = [
          {
            run = ''mpv "$@"'';
            orphan = true;
            desc = "Play";
          }
        ];
        open = [
          {
            run = ''xdg-open "$@"'';
            desc = "Open";
          }
        ];
      };
      open = {
        rules = [
          {
            name = "*/";
            use = [
              "edit"
              "open"
            ];
          }
          {
            mime = "text/*";
            use = [
              "edit"
              "open"
            ];
          }
          {
            mime = "image/*";
            use = [ "open" ];
          }
          {
            mime = "video/*";
            use = [
              "play"
              "open"
            ];
          }
          {
            mime = "audio/*";
            use = [
              "play"
              "open"
            ];
          }
          {
            mime = "inode/x-empty";
            use = [
              "edit"
              "open"
            ];
          }
          {
            mime = "application/json";
            use = [
              "edit"
              "open"
            ];
          }
          {
            mime = "application/pdf";
            use = [ "open" ];
          }
        ];
      };
      plugin.prepend_previewers = [
        {
          name = "*.md";
          run = "glow";
        }
        {
          mime = "audio/*";
          run = "mediainfo";
        }
        {
          mime = "video/*";
          run = "mediainfo";
        }
        {
          name = "*.csv";
          run = "duckdb";
        }
        {
          name = "*.ipynb";
          run = "rich-preview";
        }
        {
          mime = "application/json";
          run = "rich-preview";
        }
        # Office formats
        {
          mime = "application/openxmlformats-officedocument.*";
          run = "office";
        }
        {
          mime = "application/msword";
          run = "office";
        }
        {
          mime = "application/vnd.ms-*";
          run = "office";
        }
      ];
      plugin.prepend_preloaders = [
        {
          mime = "application/pdf";
          run = "pdf";
        }
        {
          mime = "application/openxmlformats-officedocument.*";
          run = "office";
        }
      ];
    };
    settings.keymap = {
      manager.prepend_keymap = [
        {
          on = [ "l" ];
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = [ "<Enter>" ];
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = [ "f" ];
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
        {
          on = [ "T" ];
          run = "plugin toggle-pane preview";
          desc = "Toggle preview pane";
        }
        {
          on = [ "p" ];
          run = "plugin ouch --preview";
          desc = "Preview archive";
        }
      ];
    };
    plugins = {
      inherit (pkgs.yaziPlugins)
        full-border
        git
        smart-enter
        chmod
        ouch
        starship
        relative-motions
        glow
        mediainfo
        duckdb
        jump-to-char
        toggle-pane
        rich-preview
        office
        mime-ext
        ;
    };
    initLua = pkgs.writeText "init.lua" ''
      require("full-border"):setup()
      require("git"):setup()
      require("starship"):setup()
      require("relative-motions"):setup({
        show_numbers = true,
        show_rel_numbers = true,
      })
    '';
  };
  environment.systemPackages = [
    pkgs.jq
    pkgs.fzf
    pkgs.ouch
    pkgs.glow
    pkgs.pandoc
    pkgs.duckdb
    pkgs.rich-cli
    pkgs.mediainfo
    pkgs.imagemagick
    pkgs.ghostscript
    pkgs.poppler-utils
  ];
}
