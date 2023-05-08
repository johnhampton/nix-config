require("lspsaga").setup({
  request_timeout = 5000,
  code_action = {
    keys = {
      quit = { "q", "<ESC>" },
    },
    finder = {
      expand_or_jump = { 'o', '<CR>' }
    },
  },
})
