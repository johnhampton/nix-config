local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("johnhampton.lsp.mason-lspconfig")
require("johnhampton.lsp.lsp-config")
require("johnhampton.lsp.handlers").setup()
require("johnhampton.lsp.null-ls")
