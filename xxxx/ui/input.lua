local api = vim.api
local rewind = require("rewind")
local M = {}

local function create_window(buf, win, title, callback, default_input)
	rewind.ui.util.create_window(
		buf,
		"input",
		win,
		"   INPUT " .. "- " .. title,
		60,
		1,
		math.floor((vim.o.lines * 60) / 2),
		math.floor((vim.o.lines * 1) / 2),
		true,
		true,
		"left"
	)

	local line_length = #default_input
	api.nvim_win_set_cursor(win.input, { 1, line_length })
	vim.cmd("startinsert!")

	rewind.keymap.enter_insert(buf.input, function()
		local input = api.nvim_buf_get_lines(buf, 0, -1, false)[1]
		rewind.ui.close_input_window()
		callback(input)
	end)
	rewind.keymap.escape_insert(buf.input, function()
		rewind.ui.close_input_window()
	end)
end

function M.open_window(buf, win, title, callback, default_input)
	create_window(buf, win, title, function(input)
		vim.schedule(function()
			if input then
				callback(input)
			end
		end)
	end, default_input)
	return input_result
end

function M.close_window()
	if win_opt.input and win_opt.input and api.nvim_win_is_valid(win_opt.input) then
		api.nvim_win_close(win_opt.input, true)
		vim.cmd("stopinsert")
	end
end

return M
