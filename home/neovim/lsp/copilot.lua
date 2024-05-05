local copilot = vim.api.nvim_create_augroup('copilot-nvim', { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  group = copilot,
  callback = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = false;
          accept_line = "<M-m>";
        }
      }
    })
  end
})
