local function setup_lsp_zero()
  local lsp_zero = require("lsp-zero").preset({})

  -- Global keymaps
  vim.keymap.set("n", "gl", "<cmd>Lspsaga show_line_diagnostics ++unfocus<cr>", { desc = "Show diagnostics" })

  vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { desc = "Move to previous diagnostic" })
  vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", { desc = "Move to next diagnostic" })
  -- Diagnostic jump with filters such as only jumping to an error
  vim.keymap.set("n", "[e", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Move to prev error" })
  vim.keymap.set("n", "]e", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Move to next error" })

  vim.keymap.set('n', '<leader>lq', "<cmd>Lspsaga diagnostic_jump_prev<cr>", { desc = "Location list" })

  vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga show_buf_diagnostics<cr>", { desc = "Document diagnostics" })
  vim.keymap.set("n", "<leader>lw", "<cmd>Lspsaga show_workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
  vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })

  lsp_zero.on_attach(function(_, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false, omit = { "gl", "[d", "]d" } })

    local function bind(mode, key, cmd, desc)
      vim.keymap.set(mode, key, cmd, { buffer = bufnr, desc = desc })
    end

    bind("n", "K", "<cmd>Lspsaga hover_doc<cr>", "Hover doc")

    bind("n", "gd", "<cmd>Lspsaga goto_definition<cr>", "Goto definition")
    bind("n", "gh", "<cmd>Lspsaga finder<cr>", "Usage")
    bind("n", "gp", "<cmd>Lspsaga peek_definition<cr>", "Peek definition")
    bind('n', 'gr', '<cmd>Telescope lsp_references<cr>', "References")

    bind("n", "go", "<cmd>Lspsaga goto_type_definition<cr>", "Goto type definition")
    bind("n", "gt", "<cmd>Lspsaga peek_type_definition<cr>", "Peek type definition")

    bind({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<cr>", "Code Action")
    bind({ 'n', 'x' }, '<leader>lf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', "Format")
    bind("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action")

    bind("n", "<leader>lr", "<cmd>Lspsaga rename<cr>", "Rename")
    bind("n", "<F2>", "<cmd>Lspsaga rename<cr>", "Rename")

    bind("n", "<leader>lo", "<cmd>Lspsaga outline<cr>", "Outline")

    bind("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols")
    bind("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols")

    bind("n", "<Leader>lci", "<cmd>Lspsaga incoming_calls<cr>", "Incoming calls")
    bind("n", "<Leader>lco", "<cmd>Lspsaga outgoing_calls<cr>", "Outgoing calls")
  end)

  lsp_zero.set_sign_icons({
    error = "󰅚 ",
    warn = " ",
    hint = "󰌶 ",
    info = " "
  })

  lsp_zero.setup_servers({
    "gopls",
    "ocamlls",
    "ocamllsp",
    "pyright",
    "terraformls",
    "tsserver",
  })

  local lsp_config = require("lspconfig")

  -- Configure lua language server for neovim
  lsp_config.lua_ls.setup(lsp_zero.nvim_lua_ls())

  lsp_config.jsonls.setup({
    settings = {
    },
    setup = {
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
          end,
        },
      },
    },
  })

  lsp_config.nil_ls.setup({
    settings = {
      ["nil"] = {
        formatting = {
          command = { "nixpkgs-fmt" },
        },
      },
    },
  })

  lsp_config.rust_analyzer.setup({
    settings = {
      ["rust-analyzer"] = {
        files = {
          excludeDirs = { ".direnv", ".devenv" }
        }
      }
    }
  })

  lsp_zero.setup()


  local null_ls = require("null-ls")

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics

  null_ls.setup({
    sources = {
      -- formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
      formatting.prettier,
      formatting.black.with({ extra_args = { "--fast" } }),
      formatting.pg_format,
      formatting.stylua,
      formatting.cabal_fmt,
      diagnostics.eslint_d,
      -- diagnostics.flake8
      diagnostics.yamllint,
      formatting.yamlfmt
    },
  })

  ---
  -- Setup haskell LSP
  ---
  local def_opts = { noremap = true, silent = true, }

  vim.g.haskell_tools = {
    hls = {
      capabilities = lsp_zero.get_capabilities(),
      default_settings = {
        haskell = {
          formattingProvider = "ormolu",
          plugin = {
            refineImports = {
              codeActionsOn = true,
              codeLensOn = false,
            },
            rename = {
              config = {
                crossModule = true,
              },
            },
          },
        },
      }
    }
  }

  -- Autocmd that will actually be in charging of starting hls
  local hls_augroup = vim.api.nvim_create_augroup('haskell-lsp', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = hls_augroup,
    pattern = { 'haskell' },
    callback = function()
      local haskell_tools = require('haskell-tools')
      local bufnr = vim.api.nvim_get_current_buf()
      local opts = { noremap = true, silent = true, buffer = bufnr } -- Toggle a GHCi repl for the current package

      vim.keymap.set('n', '<leader>lhs', haskell_tools.hoogle.hoogle_signature,
        { desc = "Hoogle symbol", buffer = bufnr })
      vim.keymap.set('n', '<leader>lea', haskell_tools.lsp.buf_eval_all, { desc = "Evaluate all", buffer = bufnr })

      ---
      -- Suggested keymaps that do not depend on haskell-language-server:
      ---

      -- set buffer = bufnr in ftplugin/haskell.lua
      vim.keymap.set('n', '<leader>rr', haskell_tools.repl.toggle, opts)

      -- Toggle a GHCi repl for the current buffer
      vim.keymap.set('n', '<leader>rf', function()
        haskell_tools.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, def_opts)

      vim.keymap.set('n', '<leader>rq', haskell_tools.repl.quit, opts)
    end
  })


  local cmp = require('cmp')
  local cmp_action = require('lsp-zero').cmp_action()
  local lspkind = require('lspkind')

  require('luasnip.loaders.from_vscode').lazy_load()

  cmp.setup({
    completion = {
      autocomplete = false,
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol',       -- show only symbol annotations
        maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      })
    },
    mapping = {
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({ select = false }),

      -- Supertab
      ['<Tab>'] = cmp.mapping(function(fallback)
        local luasnip = require('luasnip')
        local col = vim.fn.col('.') - 1

        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        elseif cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          cmp.complete()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),

      -- Ctrl+Space to trigger completion menu
      ['<C-Space>'] = cmp.mapping.complete(),

      -- Navigate between snippet placeholder
      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    },
    sources = {
      { name = "path" },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "buffer",  keyword_length = 3 },
      { name = "luasnip", keyword_length = 2 },
    }
  })

  cmp.event:on("menu_opened", function()
    vim.b.copilot_suggestion_hidden = true
    if require("copilot.suggestion").is_visible() then
      require("copilot.suggestion").dismiss()
    end
  end)

  cmp.event:on("menu_closed", function()
    vim.b.copilot_suggestion_hidden = false
  end)
end


setup_lsp_zero()
