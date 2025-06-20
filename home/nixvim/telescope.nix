{ ... }:
{
  programs.nixvim = {

    plugins.telescope = {
      enable = true;

      settings = {
        defaults = {
          mappings = {
            n = {
              "<M-p>" = {
                __raw = "require('telescope.actions.layout').toggle_preview";
              };
            };
            i = {
              "<M-p>" = {
                __raw = "require('telescope.actions.layout').toggle_preview";
              };
            };
          };
        };
      };

      extensions = {
        fzf-native = {
          enable = true;
        };
        ui-select = {
          enable = true;
        };
      };

      keymaps = {
        "<leader>f" = {
          action = "find_files";
          options = {
            desc = "Find files";
          };
        };
        "<leader>Fa" = {
          action = "Find_files no_ignore=true";
          options = {
            desc = "Find files (include ignored)";
          };
        };

        "<leader>." = {
          action = "buffers";
          options = {
            desc = "Buffers";
          };
        };

        "<leader>/" = {
          action = "live_grep";
          options = {
            desc = "Live Grep";
          };
        };

        "<leader>Fh" = {
          action = "help_tags";
          options = {
            desc = "Help Tags";
          };
        };

        "<leader>Fk" = {
          action = "keymaps";
          options = {
            desc = "Keymaps";
          };
        };

        "<leader>F." = {
          action = "resume";
          options = {
            desc = "Resume last picker";
          };
        };

        "<leader>Fg" = {
          action = "git_files";
          options = {
            desc = "Git files";
          };
        };

        "<leader>FR" = {
          action = "oldfiles";
          options = {
            desc = "Recent files (Global)";
          };
        };
        "<leader>Fr" = {
          action = "oldfiles cwd_only=true";
          options = {
            desc = "Recent files (CWD)";
          };
        };
      };
    };
  };
}
