{ pkgs, ... }:
{

  imports = [
	  ./copilot.nix	
	  ./cmp.nix
    ./onenord.nix
    ./haskell-tools-nvim.nix
		./lualine.nix
    ./lsp.nix
    ./mini.nix
    ./telescope.nix
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

      tmux-navigator.enable = true;
      treesitter.enable = true;

      which-key = {
        enable = true;
				operators = {
					# "gq" = "Format";
				};
        registrations = {
          "<leader>c" = { name = "+Code"; };
          "<leader>F" = { name = "+Find"; };
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
