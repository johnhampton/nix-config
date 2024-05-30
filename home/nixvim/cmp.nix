{ ... }:
{
  programs.nixvim = {
    plugins = {
      cmp = {
        enable = true;

        settings = {
          snippet.expand = ''
            								function(args)
														  print(vim.inspect(args))
														  vim.snippet.expand(args.body)
            								end
            							'';

          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
              })
            '';
          };

          sources = [
            { name = "path"; }
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            # { name = "luasnip"; }
          ];
        };
      };

      cmp-buffer.enable = true;
      cmp-cmdline.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      # cmp_luasnip.enable = true;

      # luasnip = {
      #   enable = true;
      #   fromVscode = [{ }];
      # };
    };

    # keymaps = [
    #   {
    #     mode = "i";
    #     key = "<Tab>";
    #     action = "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'";
    #     options = {
    #       expr = true;
    #       silent = true;
    #       desc = "Expand or jump in a snippet";
    #     };
    #   }
    #   {
    #     mode = "i";
    #     key = "<S-Tab>";
    #     action = "<cmd>lua require'luasnip'.jump(-1)<CR>";
    #     options = {
    #       silent = true;
    #       desc = "Jump backwards in snippet";
    #     };
    #   }
    #   {
    #     mode = "s";
    #     key = "<Tab>";
    #     action = "<cmd>lua require'luasnip'.jump(1)<CR>";
    #     options = {
    #       silent = true;
    #       desc = "Jump forwards in snippet";
    #     };
    #   }
    #   {
    #     mode = "s";
    #     key = "<S-Tab>";
    #     action = "<cmd>lua require'luasnip'.jump(-1)<CR>";
    #     options = {
    #       silent = true;
    #       desc = "Jump backwards in snippet";
    #     };
    #   }
    #   {
    #     mode = "i";
    #     key = "<C-E>";
    #     action = "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'";
    #     options = {
    #       expr = true;
    #       silent = true;
    #       desc = "Change choices in choiceNodes";
    #     };
    #   }
    #   {
    #     mode = "s";
    #     key = "<C-E>";
    #     action = "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'";
    #     options = {
    #       expr = true;
    #       silent = true;
    #       desc = "Change choices in choiceNodes";
    #     };
    #   }
    # ];
  };
}
