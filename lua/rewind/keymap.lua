local api = vim.api

local rewind = require("rewind")

local M = {}

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.quit(win, buf)
	if buf and api.nvim_buf_is_valid(buf) then
		api.nvim_buf_set_keymap(buf, "n", "q", "", {
			callback = function()
				rewind.ui.close_window(win)
			end,
			noremap = true,
			silent = true,
		})
	end
end

function M.help(buf)
	if buf and api.nvim_buf_is_valid(buf) then
		api.nvim_buf_set_keymap(buf, "n", "h", "", {
			callback = function()
				rewind.ui.toggle_help_window()
			end,
			noremap = true,
			silent = true,
		})
	end
end

function M.select_board(buf, callback)
	api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

function M.select_list(buf, callback)
	api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

function M.select_task(buf, callback)
	api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

function M.escape_board(win, buf)
	api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
		callback = function()
			rewind.ui.close_window(win)
		end,
		noremap = true,
		silent = true,
	})
end

function M.escape_list(buf, callback)
	api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

function M.escape_task(buf, callback)
	api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

function M.enter_input(buf, callback)
	api.nvim_buf_set_keymap(buf, "i", "<CR>", "", {
		callback = function()
			local input = api.nvim_buf_get_lines(buf, 0, -1, false)[1]
			rewind.ui.close_input_window()
			callback(input)
		end,
		noremap = true,
		silent = true,
	})
end

function M.escape_input(buf)
	api.nvim_buf_set_keymap(buf, "i", "<Esc>", "", {
		callback = function()
			rewind.ui.close_input_window()
		end,
		noremap = true,
		silent = true,
	})
end

return M
