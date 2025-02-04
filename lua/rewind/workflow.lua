local api = vim.api

local util = require("rewind.util")

local M = {}

--------------------------------------------------
-- Local Variables and Cache
--------------------------------------------------
local rewind_highlight_namespace = api.nvim_create_namespace("RewindHighlight")

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.init_boards_selection(win, buf)
	-- Set up autocmd to update highlight on cursor move
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.boards,
		callback = function()
			util.update_highlight(buf.boards, rewind_highlight_namespace)
			local current_board = api.nvim_get_current_line()
			print(current_board)
			util.update_contents(buf.lists, util.get_lists(current_board))
		end,
	})

	-- Initial highlight
	util.update_highlight(buf.boards, rewind_highlight_namespace)

	api.nvim_buf_set_keymap(buf.boards, "n", "<CR>", "", {
		callback = function()
			local current_board = api.nvim_get_current_line()
			api.nvim_set_current_win(win.lists)
			M.init_lists_selection(win, buf, current_board)
		end,
		noremap = true,
		silent = true,
	})
end

function M.init_lists_selection(win, buf, current_board)
	-- Set up autocmd to update highlight on cursor move
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.lists,
		callback = function()
			util.update_highlight(buf.lists, rewind_highlight_namespace)
			local current_list = api.nvim_get_current_line()
			print(current_board .. current_list)
			util.update_contents(buf.tasks, util.get_tasks(current_board, current_list))
		end,
	})

	-- Initial highlight
	util.update_highlight(buf.lists, rewind_highlight_namespace)

	api.nvim_buf_set_keymap(buf.lists, "n", "<CR>", "", {
		callback = function()
			api.nvim_set_current_win(win.tasks)
			M.init_tasks_selection(win, buf)
		end,
		noremap = true,
		silent = true,
	})
end

function M.init_tasks_selection(win, buf)
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.tasks,
		callback = function()
			util.update_highlight(buf.tasks, rewind_highlight_namespace)
		end,
	})

	util.update_highlight(buf.tasks, rewind_highlight_namespace)

	api.nvim_buf_set_keymap(buf.tasks, "n", "<CR>", "", {
		callback = function()
			local line = api.nvim_get_current_line()
			print("Selected: " .. line)
		end,
		noremap = true,
		silent = true,
	})
end

return M
