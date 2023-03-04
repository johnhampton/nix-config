lspconfig = require "lspconfig"

local hls_opts = require("johnhampton.lsp.settings.hls")
local json_opts = require("johnhampton.lsp.settings.jsonls")
local sumneko_opts = require("johnhampton.lsp.settings.sumneko_lua")

local opts = {
  on_attach = require("johnhampton.lsp.handlers").on_attach,
  capabilities = require("johnhampton.lsp.handlers").capabilities,
}

local lsps = {
  gopls = {},
  hls = hls_opts,
  jsonls = json_opts,
  ocamllsp = {},
  rnix = {},
  sumneko_lua = sumneko_opts,
  terraformls = {},
  tsserver = {},
}

for lsp, lsp_opts in pairs(lsps) do
  lspconfig[lsp].setup(vim.tbl_extend("force", opts, lsp_opts))
end
