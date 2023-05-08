{ pkgs, ... }:
{
  programs.neovim = {
    plugins = let p = pkgs.vimPlugins; in [

      p.nvim-lspconfig

      p.null-ls-nvim

      p.nvim-cmp
      p.cmp-buffer
      p.cmp-path
      p.cmp-cmdline
      p.cmp_luasnip
      p.cmp-nvim-lsp
      p.cmp-nvim-lua
      p.luasnip
      p.friendly-snippets
      p.lspkind-nvim

      {
        plugin = p.lsp-zero-nvim;
        type = "lua";
        config = builtins.readFile ./lsp.lua;
      }

      {
        plugin = p.lspsaga-nvim-original;
        type = "lua";
        config = builtins.readFile ./lspsaga.lua; 
      }
    ];
  };
}

