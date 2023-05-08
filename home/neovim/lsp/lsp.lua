local function setup_lsp_zero()
  local lsp = require("lsp-zero").preset({})

  -- Global keymaps
  vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnotics" })
  vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Move to next diagnostic" })
  vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Move to previous diagnostic" })
  vim.keymap.set('n', '<leader>lq', "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "Location list" })

  vim.keymap.set("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document diagnostics" })
  vim.keymap.set("n", "<leader>lw", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace diagnostics" })
  vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })

  lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false, omit = { "gl", "[d", "]d" } })

    local function bind(mode, key, cmd, desc)
      vim.keymap.set(mode, key, cmd, { buffer = bufnr, desc = desc })
    end

    bind("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "Goto definition")
    bind("n", "gi", "<cmd>Telescope lsp_implementations<cr>", "Goto implementation")
    bind("n", "go", "<cmd>Telescope lsp_type_definitions<cr>", "Goto type definition")
    bind("n", "gr", "<cmd>Telescope lsp_references<cr>", "References")

    bind({ "n", "v" }, "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")
    bind({ 'n', 'x' }, '<leader>lf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', "Format")
    bind("n", "<leader>lc", "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action")
    bind("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename")

    bind("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols")
    bind("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols")
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
