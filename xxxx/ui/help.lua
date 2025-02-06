local api = vim.api
local rewind = require("rewind")
local M = {}

local function create_window(buf, win, config)
	rewind.ui.util.create_window(
		buf,
		"help",
		win,
		" 󰋖 HELP ",
		math.floor((vim.o.columns * config.width_percentage) / 4),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		math.floor((vim.o.lines * config.width_percentage) * 3.56),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		false,
		true
	)

	local current_buf = api.nvim_get_current_buf()
	rewind.help.update_help(buf, current_buf)
	api.nvim_buf_set_option(buf.help, "modifiable", false)
end

local function open_help_window(buf, win)
	create_window(buf, win)
end

function M.close_window()
	if win and win.help and api.nvim_win_is_valid(win.help) then
		api.nvim_win_close(win.help, true)
	end
end

function M.toggle_help_window(buf, win)
	if win.help and api.nvim_win_is_valid(win.help) then
		M.close_help_window(win)
	else
		open_help_window(buf, win)
	end
end

return M
