local M = {}
local state = require("rewind.state")

function M.create_window(buf, type, win, pos, is_focused, is_modifiable)
	local width = math.floor(vim.o.columns * rewind.config.options.ui.width_percentage)
	local height = math.floor(vim.o.lines * rewind.config.options.ui.height_percentage)

	win[type] = api.nvim_open_win(buf[type], is_focused, {
		relative = "editor",
		width = math.floor(width * pos.width_mult),
		height = math.floor(height * pos.height_mult),
		col = math.floor(width * pos.col_mult),
		row = math.floor(height * pos.row_mult),
		title = pos.title,
		title_pos = pos.layout,
		style = "minimal",
		border = "rounded",
		zindex = pos.zindex,
	})

	api.nvim_buf_set_option(buf[type], "modifiable", is_modifiable)
	rewind.keymaps.setup(buf, win, type)
end

function M.setup()
	state.init_buffers()
	state.reset_windows()
end

return M
