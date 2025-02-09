local M = {}
local state = require("rewind.state")
local config = require("rewind.config")

function create_window(key)
	local config_default = config.defaults.window.default
	local config_specific = config.defaults.window[key] or {}

	local width_percentage = config_specific.width_percentage or config_default.width_mult
	local height_percentage = config_specific.height_percentage or config_default.height_mult
	local width_mult = config_specific.width_mult or config_default.width_mult
	local height_mult = config_specific.height_mult or config_default.height_mult
	local col_mult = config_specific.col_mult or config_default.width_mult
	local row_mult = config_specific.row_mult or config_default.height_mult
	local layout = config_specific.layout or config_default.layout
	local border_style = config_specific.border_style or config_default.border_style
	local zindex = config_specific.zindex or config_default.zindex_base
	local title = config_specific.title or config_default.title
	local visible = config_specific.visible or config_default.visible

	local is_focused = config_specific.is_focused or config_default.is_focused

	local width = math.floor(vim.o.columns * width_percentage)
	local height = math.floor(vim.o.lines * height_percentage)

	state.init_buffer(key)
	state.win[key] = api.nvim_open_win(state.buf[type], is_focused, {
		relative = "editor",
		width = math.floor(width * width_mult),
		height = math.floor(height * height_mult),
		col = math.floor(width * col_mult),
		row = math.floor(height * row_mult),
		title = title,
		title_pos = layout,
		style = "minimal",
		border = border,
		zindex = zindex,
	})

	if not visible then
		vim.api.nvim_win_hide(state.win[key])
	end
end

function M.setup()
	state.reset_buffers()
	state.reset_windows()

	for key, _ in pairs(state.win.core) do
		create_window(key)
	end
end

return M
