vim.cmd([[ 
  packadd comment.nvim
  packadd nvim-ts-context-commentstring
]])



local comment = require 'Comment'
local comment_string = require 'ts_context_commentstring.integrations.comment_nvim' 
local wk = require('which-key')

comment.setup({
  pre_hook = comment_string.create_pre_hook(),
})


wk.register({
    c ,
    b 
}, {prefix = 'g'})

-- basic
-- wk.register({
--   gb = 'Togggle block comment',
--   gbc = 'Toggle block comment',
--   gc = 'Toggle line comment',
--   gcc = 'Toggle line comment',
-- }, { mode = "n" })
--
-- wk.register({
--   gb = 'Togggle block comment',
--   gc = 'Toggle line comment',
-- }, { mode = "x" })
--
-- -- extra
-- wk.register({
--   gco = 'Comment next line',
--   gcO = 'Comment prev line',
--   gcA = 'Comment end of line',
-- }, { mode = "n" })
--
-- -- extended
-- wk.register({
--   ["g>"] = 'Comment region',
--   ["g>c"] = 'Add line comment',
--   ["g>b"] = 'Add block comment',
--   ["g<lt>"] = 'Uncomment region',
--   ["g<lt>c"] = 'Remove line comment',
--   ["g<lt>b"] = 'Remove block comment',
-- }, { mode = "n" })
--
-- wk.register({
--   ["g>"] = 'Comment region',
--   ["g<lt>"] = 'Uncomment region',
-- }, { mode = "x" })
