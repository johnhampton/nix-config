{ pkgs, ... }:
{

  imports = [
	  ./cmp.nix
    ./onenord.nix
    ./haskell-tools-nvim.nix
		./lualine.nix
    ./lsp.nix
    ./mini.nix
  ];

  programs.nixvim = {
    enable = true;

    opts = {
      cmdheight = 2;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
    };

    globals = { };

    plugins = {
			dap.enable = true;
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
				operators = {
					# "gq" = "Format";
				};
        registrations = {
          "<leader>c" = { name = "+Code"; };
          "<leader>f" = { name = "+Find"; };
          "<leader>l" = { name = "+LSP"; };
					"gq" = { name = "Format"; };
        };
      };
    };

    extraPlugins = [
      pkgs.vimPlugins.nvim-web-devicons
    ];
  };
}
