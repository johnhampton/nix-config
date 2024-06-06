{ ... }:
{
  programs.nixvim = {
    plugins = {

      cmp = {
        enable = true;

        settings = {
          completion.autocomplete = false;

          cmdline = {
            "/" = {
              mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
              sources = [
                {
                  name = "buffer";
                }
              ];
              "?" = {
                mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
                sources = [
                  {
                    name = "buffer";
                  }
                ];
              };
              ":" = {
                mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
                sources = [
                  {
                    name = "buffer";
                  }
                  {
                    name = "cmdline";
                  }
                ];
                matching = {
                  disallow_symbol_nonprefix_matching = false;
                };
              };
            };
          };

          snippet.expand = ''
            function(args)
              vim.snippet.expand(args.body)
            end
          '';

          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<Tab>'] = cmp.mapping(function(fallback)

                  local copilot = require("copilot.suggestion")

                  local has_words_before = function()
                    unpack = unpack or table.unpack
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                  end

                  if copilot.is_visible() then
                    copilot.accept()
                  elseif cmp.visible() then
                    cmp.select_next_item()
                  elseif vim.snippet.active({ direction = 1}) then
                    vim.snippet.jump(1)
                  elseif has_words_before() then
                    cmp.complete()
                  else
                    fallback()
                  end
                end, { 'i', 's'}),
               ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif vim.snippet.active({ direction = -1}) then
                    vim.snippet.jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
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
          ];
        };
      };

      cmp-buffer.enable = true;
      cmp-cmdline.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
    };
  };
}
