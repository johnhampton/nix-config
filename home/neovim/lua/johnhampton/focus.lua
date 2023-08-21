local focus = require "focus"

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
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
    then
      vim.w.focus_disable = true
    else
      vim.w.focus_disable = false
    end
  end,
  desc = 'Disable focus autoresize for BufType',
})

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'FileType' }, {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.w.focus_disable = true
    else
      vim.w.focus_disable = false
    end
  end,
  desc = 'Disable focus autoresize for FileType',
})

vim.keymap.set('n', '<leader>wn', '<cmd>FocusSplitNicely<cr>', { desc = "New Split" })
vim.keymap.set('n', '<leader>wh', '<cmd>FocusSplitLeft<cr>', { desc = "Split Left" })
vim.keymap.set('n', '<leader>wj', '<cmd>FocusSplitDown<cr>', { desc = "Split Down" })
vim.keymap.set('n', '<leader>wk', '<cmd>FocusSplitUp<cr>', { desc = "Split Up" })
vim.keymap.set('n', '<leader>wl', '<cmd>FocusSplitRight<cr>', { desc = "Split Right" })
vim.keymap.set('n', '<leader>wo', '<cmd>FocusMaximise<cr>', { desc = "Maximize" })
vim.keymap.set('n', '<leader>w=', '<cmd>FocusEqualise<cr>', { desc = "Equalize" })
