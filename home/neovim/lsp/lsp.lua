local function setup_lsp_zero()
  local lsp = require("lsp-zero").preset({})

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

  lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false, omit = { "gl", "[d", "]d" } })

    local function bind(mode, key, cmd, desc)
      vim.keymap.set(mode, key, cmd, { buffer = bufnr, desc = desc })
    end

    bind("n", "K", "<cmd>Lspsaga hover_doc<cr>", "Hover doc")

    bind("n", "gd", "<cmd>Lspsaga goto_definition<cr>", "Goto definition")
    bind("n", "gh", "<cmd>Lspsaga lsp_finder<cr>", "Usage")
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

  lsp.set_sign_icons({
    error = " ",
    warn = " ",
    hint = " ",
    info = " "
  })

  lsp.setup_servers({
    "gopls",
    "ocamlls",
    "ocamllsp",
    "pyright",
    "terraformls",
    "tsserver",
  })

  local lsp_config = require("lspconfig")
  lsp_config.hls.setup({
    filetypes = { "haskell", "lhaskell" },
    settings = {
      haskell = {
        formattingProvider = "fourmolu",
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
    },
  })

  -- Configure lua language server for neovim
  lsp_config.lua_ls.setup(lsp.nvim_lua_ls())

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

  lsp.setup()


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
      formatting.stylua,
      formatting.cabal_fmt,
      diagnostics.eslint_d,
      -- diagnostics.flake8
      diagnostics.yamllint,
      formatting.yamlfmt
    },
  })

  local cmp = require('cmp')
  local cmp_action = require('lsp-zero').cmp_action()
  local lspkind = require('lspkind')

  require('luasnip.loaders.from_vscode').lazy_load()

  cmp.setup({
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
      ['<Tab>'] = cmp_action.luasnip_supertab(),
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
end

setup_lsp_zero()
