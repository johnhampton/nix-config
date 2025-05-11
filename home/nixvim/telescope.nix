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

				"<leader>FR" = {
					action = "oldfiles";
					options = {
						desc = "Recent files (Global)";
					};
				};
      };
    };

    keymaps = [{
      key = "<leader>Fr";
      action = "<cmd>Telescope oldfiles cwd_only=true<cr>";
      options = {
        desc = "Recent files";
      };
    }];
  };
}
