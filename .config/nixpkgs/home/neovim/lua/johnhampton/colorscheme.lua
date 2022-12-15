-- https://github.com/rmehri01/onenord.nvim
local status_ok, onenord = pcall(require, "onenord")

if not status_ok then
	vim.cmd([[
    colorscheme default
    set background=dark
  ]])

	return
end

onenord.setup()
