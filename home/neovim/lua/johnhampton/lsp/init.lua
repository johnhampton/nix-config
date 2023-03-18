require("johnhampton.lsp.lsp-config")
require("johnhampton.lsp.handlers").setup()
require("johnhampton.lsp.null-ls")

local wk = require('which-key')

wk.register({
  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    c = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    d = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics" },
    w = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
    f = { "<cmd>lua require('johnhampton.lsp.handlers').lsp_formatting(0)<cr>", "Format" },
    h = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
    j = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
    k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
    q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
  }
}, {
  mode = "n",     -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
})
