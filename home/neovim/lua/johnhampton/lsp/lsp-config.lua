local lspconfig = require "lspconfig"

local hls_opts = require("johnhampton.lsp.settings.hls")
local json_opts = require("johnhampton.lsp.settings.jsonls")
local lua_opts = require("johnhampton.lsp.settings.lua_ls")

local opts = {
  on_attach = require("johnhampton.lsp.handlers").on_attach,
  capabilities = require("johnhampton.lsp.handlers").capabilities,
}

local lsps = {
  gopls = {},
  hls = hls_opts,
  jsonls = json_opts,
  lua_ls = lua_opts,
  nil_ls = {
    settings = {
      ["nil"] = {
        formatting = {
          command = { "nixpkgs-fmt" },
        },
      },
    },
  },
  ocamlls = {},
  ocamllsp = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        files = {
          excludeDirs = { ".direnv", ".devenv" }
        }
      }
    }
  },
  terraformls = {},
  tsserver = {},
}

for lsp, lsp_opts in pairs(lsps) do
  lspconfig[lsp].setup(vim.tbl_extend("force", opts, lsp_opts))
end
