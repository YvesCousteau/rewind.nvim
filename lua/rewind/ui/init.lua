local M = {}
local state = require("rewind.state")
local config = require("rewind.config")

function create_window(key)
	local config_default = config.defaults.window
	local config_specific = config.defaults.window.custom[key] or {}

	local width_percentage = config_specific.width_percentage or config_default.width_percentage
	local height_percentage = config_specific.height_percentage or config_default.height_percentage
	local width_mult = config_specific.width_mult or config_default.width_mult
	local height_mult = config_specific.height_mult or config_default.height_mult
	local col_mult = config_specific.col_mult or config_default.col_mult
	local row_mult = config_specific.row_mult or config_default.row_mult
	local layout = config_specific.layout or config_default.layout
	local border = config_specific.border or config_default.border
	local zindex = config_specific.zindex or config_default.zindex
	local title = config_specific.title or config_default.title

	local is_visible = config_specific.is_visible or config_default.is_visible
	local is_focused = config_specific.is_focused or config_default.is_focused

	local width = math.floor(vim.o.columns * width_percentage)
	local height = math.floor(vim.o.lines * height_percentage)

	state.init_buffer(key)
	state.win[key] = vim.api.nvim_open_win(state.buf[key], is_focused == "true", {
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

	if is_visible == "false" then
		vim.api.nvim_win_hide(state.win[key])
	elseif not vim.api.nvim_win_is_valid(state.win[key]) then
		print("Window creation failed for key: " .. key)
	end
end

function M.setup()
	state.reset_buffers()
	state.reset_windows()

	for key, _ in pairs(config.defaults.window.custom) do
		create_window(key)
	end
end

return M
