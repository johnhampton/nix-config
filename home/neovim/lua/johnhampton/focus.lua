local focus = require "focus"
local wk = require("johnhampton.which-key-nvim")

focus.setup({
  ui = {
    hybridnumber = true,
    absolutenumber_unfocussed = true,
  },
})

local ignore_filetypes = { 'NvimTree' }
local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

local augroup =
    vim.api.nvim_create_augroup('FocusDisable', { clear = true })

vim.api.nvim_create_autocmd('WinEnter', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            vim.b.focus_disable = true
        end
    end,
    desc = 'Disable focus autoresize for BufType',
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
        end
    end,
    desc = 'Disable focus autoresize for FileType',
})

wk.which_key.register({
  w = {
    name = "Window",
    n = { "<cmd>FocusSplitNicely<cr>", "New Split" },
    h = { "<cmd>FocusSplitLeft<cr>", "Split Left" },
    j = { "<cmd>FocusSplitDown<cr>", "Split Down" },
    k = { "<cmd>FocusSplitUp<cr>", "Split Up" },
    l = { "<cmd>FocusSplitRight<cr>", "Split Right" },
    o = { "<cmd>FocusMaximise<cr>", "Maximize" },
    ["="] = { "<cmd>FocusEqualise<cr>", "Equalize" },
  }
}, wk.default_opts)
