local api = vim.api
local rewind = require("rewind")
local M = {}

function M.create_window(buf, type, win, title, width, height, col, row, is_focused, is_modifiable, position)
	win[type] = api.nvim_open_win(buf[type], is_focused, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		title = title,
		title_pos = position or "center",
		style = "minimal",
		border = "rounded",
		zindex = 100,
	})
	api.nvim_buf_set_option(buf[type], "modifiable", is_modifiable)
	rewind.keymap.quit(win[type], buf[type])
	rewind.keymap.help(buf[type])
end

return M
