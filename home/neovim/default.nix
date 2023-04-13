{ pkgs, ... }:

let
  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });
in

{
  imports = [ ./navigator.nix ];

  home.packages = with pkgs; [
    glow
    htop
    lazygit
    # NDCU doesn't install because zig is marked as broken. Revisit when 
    # we upgrade our flakes
    # ncdu
    nil
    nixpkgs-fmt
    nodePackages.vscode-langservers-extracted
    sumneko-lua-language-server
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/lua".recursive = true;

  programs.neovim.extraConfig = ''
    lua << EOF

    require("johnhampton.options")
    require("johnhampton.settings")
    require("johnhampton.keymaps")

    require('johnhampton.onenord-nvim')
    require('johnhampton.cmp')
    require('johnhampton.lsp')

    require('johnhampton.which-key-nvim')

    require('johnhampton.nvim-treesitter')

    require('johnhampton.comment-nvim')

    require('johnhampton.nvim-tree-lua')
    require("johnhampton.bufferline")
    require('johnhampton.lualine')
    require('johnhampton.project')
    require('johnhampton.impatient')
    require('johnhampton.gitsigns')

    require('johnhampton.telescope-nvim')
    require('johnhampton.toggleterm')
    require('johnhampton.focus')
    require('johnhampton.indentline')
    require('johnhampton.glow')
    EOF
  '';

  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-bbye
    bufferline-nvim
    # colorscheme
    { plugin = onenord-nvim; }

    # which-key
    { plugin = which-key-nvim; }

    # treesitter
    {
      plugin = (nvim-treesitter.withPlugins (p: ([ pkgs.tree-sitter-grammars.tree-sitter-just ]
        ++ nvim-treesitter.allGrammars)));
    }
    {
      plugin = tree-sitter-just;
      type = "lua";
      config = ''
        require('tree-sitter-just').setup({ 
          ["local"] = true 
        })
      '';
    }


    # Comment
    { plugin = nvim-ts-context-commentstring; }
    { plugin = comment-nvim; }

    # LSP
    { plugin = nvim-lspconfig; }
    null-ls-nvim

    lualine-nvim
    lualine-lsp-progress

    nvim-cmp
    cmp-buffer
    cmp-path
    cmp-cmdline
    cmp_luasnip
    cmp-nvim-lsp
    cmp-nvim-lua

    gitsigns-nvim

    luasnip
    friendly-snippets

    project-nvim
    impatient-nvim

    # nvim-tree
    { plugin = pluginWithDeps nvim-tree-lua [ nvim-web-devicons ]; }

    # telescope
    { plugin = telescope-nvim; }
    { plugin = telescope-ui-select-nvim; }
    { plugin = telescope-fzf-native-nvim; }
    { plugin = telescope-hoogle-nvim; }
    b64-nvim
    vim-surround
    toggleterm-nvim
    focus-nvim
    indent-blankline-nvim
    glow-nvim
  ];
}