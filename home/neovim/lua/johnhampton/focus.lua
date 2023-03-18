local focus = require "focus"
local wk = require("johnhampton.which-key-nvim")

focus.setup({
  hybridnumber = true,
  absolutenumber_unfocussed = true,
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
