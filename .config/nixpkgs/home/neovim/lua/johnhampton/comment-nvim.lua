vim.cmd([[ 
  packadd comment.nvim
  packadd nvim-ts-context-commentstring
]])

local comment = require 'Comment'
local comment_string = require 'ts_context_commentstring.integrations.comment_nvim' 

comment.setup({
  pre_hook = comment_string.create_pre_hook(),
})
