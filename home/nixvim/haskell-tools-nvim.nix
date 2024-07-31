{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [
      pkgs.vimPlugins.haskell-tools-nvim
      pkgs.vimPlugins.telescope_hoogle
    ];
    extraPackages = [
      pkgs.haskellPackages.fast-tags
      pkgs.haskellPackages.haskell-debug-adapter
    ];
    plugins = {
      telescope.enabledExtensions = [
        "hoogle"
      ];
      which-key.settings.spec = [
        { "<leader>h" = { name = "Haskell"; }; }
        { "<leader>hr" = { name = "REPL"; }; }
      ];
    };
    files = {
      "after/ftplugin/haskell.lua" = {
        keymaps = [
          {
            key = "<leader>he";
            action = { __raw = ''require("haskell-tools").lsp.buf_eval_all''; };
            mode = "n";
            options = {
              noremap = true;
              silent = true;
              buffer = true;
              desc = "Evaluate all code snippets";
            };
          }
          {
            key = "<leader>hh";
            action = "<cmd>Telescope hoogle<cr>";
            mode = "n";
            options = {
              buffer = true;
              desc = "Hoogle search";
            };
          }
          {
            key = "<leader>hp";
            action = { __raw = ''require("haskell-tools").project.open_package_cabal''; };
            mode = "n";
            options = {
              noremap = true;
              silent = true;
              buffer = true;
              desc = "Open the package cabal file";
            };
          }
          {
            key = "<leader>hP";
            action = { __raw = ''require("haskell-tools").project.open_project_file''; };
            mode = "n";
            options = {
              noremap = true;
              silent = true;
              buffer = true;
              desc = "Open the project file";
            };
          }
          {
            key = "<leader>hrf";
            action = { __raw = ''function() require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0)) end''; };
            mode = "n";
            options = {
              noremap = true;
              silent = true;
              buffer = true;
              desc = "Toggle a GHCi repl for the current buffer";
            };
          }
          {
            key = "<leader>hrq";
            action = { __raw = ''require("haskell-tools").repl.quit''; };
            mode = "n";
            options = {
              noremap = true;
              silent = true;
              buffer = true;
              desc = "Quit the GHCi repl";
            };
          }
          {
            key = "<leader>hrr";
            action = { __raw = ''require("haskell-tools").repl.toggle''; };
            mode = "n";
            options = {
              noremap = true;
              silent = true;
              buffer = true;
              desc = "Toggle a GHCi repl for the current package";
            };
          }
          {
            key = "<leader>hs";
            action = { __raw = ''require("haskell-tools").hoogle.hoogle_signature''; };
            mode = "n";
            options = {
              noremap = true;
              silent = true;
              buffer = true;
              desc = "Hoogle signature search";
            };
          }
        ];

        extraConfigLua = ''
          require('haskell-tools')
        '';
      };

      "after/ftplugin/cabal.lua" = {
        extraConfigLua = ''
          require('haskell-tools')
        '';
      };
    };
  };
}
