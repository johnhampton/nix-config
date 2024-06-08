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
    ./neotest.nix
    ./telescope.nix
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
          "<leader>a" = { name = "+AI"; mode = ["n" "v"]; };
          "<leader>c" = { name = "+Code"; mode = ["n" "v"]; };
          "<leader>F" = { name = "+Find"; mode = ["n" "v"]; };
          "<leader>l" = { name = "+LSP"; mode = ["n" "v"]; };
          "<leader>L" = { name = "+LSP Control"; mode = ["n" "v"]; };
          "gq" = { name = "Format"; };
        };
      };
    };

    extraPlugins = [
      pkgs.vimPlugins.nvim-web-devicons
    ];
  };
}
