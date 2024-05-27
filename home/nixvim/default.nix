{ pkgs, ... }:
{

  imports = [
    ./onenord.nix
    ./haskell-tools-nvim.nix
    ./mini.nix
  ];

  programs.nixvim = {
    enable = true;



    globals = {
      # mapleader = " ";
    };


    plugins = {
      lsp = {
        enable = true;

        servers = {
          nil_ls = { enable = false; };
          nixd = {
            enable = true;
            settings.formatting.command = [ "nixpkgs-fmt" ];
          };
        };

        keymaps = {
          lspBuf = {
            "<leader>lf" = {
              action = "format";
              desc = "Format";
            };
          };
        };
      };

      telescope = {
        enable = true;
        extensions = {
          fzf-native = {
            enable = true;
          };
        };
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options = {
              desc = "Find files";
            };
          };

          "<leader>fb" = {
            action = "buffers";
            options = {
              desc = "Buffers";
            };
          };

          "<leader>fg" = {
            action = "live_grep";
            options = {
              desc = "Live Grep";
            };
          };

          "<leader>fh" = {
            action = "help_tags";
            options = {
              desc = "Help Tags";
            };
          };
        };
      };


      tmux-navigator.enable = true;
      treesitter.enable = true;

      which-key = {
        enable = true;
        registrations = {
          "<leader>l" = { name = "+LSP"; };
          "<leader>f" = { name = "+find"; };
        };
      };
    };

    extraPlugins = [
      pkgs.vimPlugins.nvim-web-devicons
    ];
  };
}
