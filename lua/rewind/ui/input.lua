local api = vim.api
local rewind = require("rewind")
local M = {}

local function setup(default, callback)
	api.nvim_buf_set_option(rewind.state.buf.input, "modifiable", true)

	api.nvim_buf_set_lines(rewind.state.buf.input, 0, -1, false, { default or "" })
	local line_length = #default
	api.nvim_win_set_cursor(rewind.state.win.floating.input, { 1, line_length })
	vim.cmd("startinsert!")

	rewind.util.set_keymap(rewind.state.buf.input, "i", rewind.config.options.keymaps.select, function()
		local input = api.nvim_buf_get_lines(rewind.state.buf.input, 0, -1, false)[1]
		if
			rewind.state.win.floating.input
			and rewind.state.win.floating.input
			and api.nvim_win_is_valid(rewind.state.win.floating.input)
		then
			rewind.ui.close_window(rewind.state.win.floating.input)
			vim.cmd("stopinsert")
			vim.schedule(function()
				callback(input)
			end)
		end
	end)

	rewind.util.set_keymap(rewind.state.buf.input, "i", rewind.config.options.keymaps.back, function()
		rewind.ui.close_window(rewind.state.win.floating.input)
		vim.cmd("stopinsert")
	end)
end

local function create_window()
	local pos = rewind.config.options.ui.position.input
	rewind.ui.util.create_window(rewind.state.buf, "input", rewind.state.win.floating, pos, true, true)
end

function M.open_window(title, callback, default)
	rewind.config.options.ui.position.input.title = title
	create_window()
	setup(default or "", callback)
end

return M
