local M = {}

-- Setup chatgpt with default options
local function setup_chatgpt(default_options)
  local chatgpt = require("chatgpt")
  local opts = {
    edit_with_instructions = {
      keymaps = {
        use_output_as_input = "<C-n>",
      }
    },

    openai_params = {
      max_tokens = 500,
    }
  }

  chatgpt.setup(vim.tbl_deep_extend("keep", opts, default_options))

  local function bind_key(mode, key, cmd, o)
    vim.keymap.set(
      mode,
      key,
      cmd,
      vim.tbl_deep_extend("keep", o or {}, { noremap = true, silent = true }))
  end

  bind_key("n", "<leader>ac", (function()
    chatgpt.openChat()
  end), { desc = "Chat" })

  bind_key({ "n", "v" }, "<leader>ae", (function()
    chatgpt.edit_with_instructions()
  end), { desc = "Edit with Instructions" })
end

M.setup_chatgpt = setup_chatgpt

return M
