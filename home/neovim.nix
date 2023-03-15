{ pkgs, ... }:

let
  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });

  pluginWithConfig = { plugin, optional ? false, jjextraConfig ? "", deps ? [ ] }:
    let plugin' = if deps == [ ] then plugin else pluginWithDeps plugin deps; in
    {
      plugin = plugin';
      type = "lua";
      config = ''
        require('johnhampton.' .. string.gsub('${plugin.pname}', '%.', '-'))
      '';
    };

in

{
  home.packages = with pkgs; [
    fd
    nil
    nixpkgs-fmt
    sumneko-lua-language-server
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim/lua".source = ./neovim/lua;
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
    { plugin = nvim-treesitter.withAllGrammars; }

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
    direnv-vim
    vim-kitty-navigator
    b64-nvim
    vim-surround
  ];
}
