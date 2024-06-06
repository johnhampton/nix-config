{ ... } : 
{
programs.nixvim.plugins.telescope = {
        enable = true;

        extensions = {
          fzf-native = {
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

          "<leader>b" = {
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
        };
      };
}
