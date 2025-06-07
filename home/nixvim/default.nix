{ pkgs, ... }:
{

  imports = [
    ./conform.nix
    ./copilot.nix
    ./cmp.nix
    ./onenord.nix
    ./haskell-tools-nvim.nix
    ./lualine.nix
    ./lsp.nix
    ./mini.nix
    ./neotest.nix
    ./nvim-aider.nix
    ./smart-splits.nix
    ./telescope.nix
    ./terraform.nix
  ];

  programs.nixvim = {
    enable = true;

    opts = {
      cmdheight = 2;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
    };

    globals = { };
    
    keymaps = [
      {
        mode = "n";
        key = "<leader>y";
        action = '':let @+ = @" | echo "Copied to system clipboard"<CR>'';
        options = {
          desc = "Copy unnamed register to system clipboard";
          silent = true;
        };
      }
    ];

    plugins = {
      dap.enable = true;

      treesitter = {
        enable = true;
        settings = {
          highlight = {
            enable = true;
          };
          incremental_selection = {
            enable = true;
          };
        };
      };

      web-devicons.enable = true;
      which-key = {
        enable = true;

        settings = {
          operators = {
            # "gq" = "Format";
          };

          spec = [
            { __unkeyed-1 = "<leader>a"; group = "+AI"; mode = [ "n" "v" ]; }
            { __unkeyed-1 = "<leader>A"; group = "+Aider"; mode = [ "n" "v" ]; }
            { __unkeyed-1 = "<leader>c"; group = "+Code"; mode = [ "n" "v" ]; }
            { __unkeyed-1 = "<leader>F"; group = "+Find"; mode = [ "n" "v" ]; }
            { __unkeyed-1 = "<leader>l"; group = "+LSP"; mode = [ "n" "v" ]; }
            { __unkeyed-1 = "<leader>L"; group = "+LSP Control"; mode = [ "n" "v" ]; }
            { __unkeyed-1 = "gq"; group = "Format"; }
          ];
        };
      };
    };

    extraPlugins = [
      pkgs.vimPlugins.nvim-web-devicons
    ];
  };
}
