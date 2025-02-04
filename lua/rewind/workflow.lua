local api = vim.api

local help = require("rewind.help")
local util = require("rewind.util")
local keymap = require("rewind.keymap")

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
			util.update_contents(buf.lists, util.get_lists(current_board))
			util.update_contents(buf.tasks, util.get_tasks(current_board, util.get_first_list(current_board)))
		end,
	})

	help.update(buf.help, "boards")

	-- Initial highlight
	util.clear_highlights(buf, rewind_highlight_namespace)
	util.update_highlight(buf.boards, rewind_highlight_namespace)

	keymap.select_board(buf, function()
		local current_board = api.nvim_get_current_line()
		api.nvim_set_current_win(win.lists)
		M.init_lists_selection(win, buf, current_board)
	end)

	keymap.escape_board(buf)
end

function M.init_lists_selection(win, buf, current_board)
	-- Set up autocmd to update highlight on cursor move
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.lists,
		callback = function()
			util.update_highlight(buf.lists, rewind_highlight_namespace)
			local current_list = api.nvim_get_current_line()
			util.update_contents(buf.tasks, util.get_tasks(current_board, current_list))
		end,
	})

	help.update(buf.help, "lists")

	-- Initial highlight
	util.clear_highlights(buf, rewind_highlight_namespace)
	util.update_highlight(buf.lists, rewind_highlight_namespace)

	keymap.select_list(buf, function()
		api.nvim_set_current_win(win.tasks)
		M.init_tasks_selection(win, buf)
	end)

	keymap.escape_list(buf, function()
		api.nvim_set_current_win(win.boards)
		M.init_boards_selection(win, buf)
	end)
end

function M.init_tasks_selection(win, buf)
	-- Set up autocmd to update highlight on cursor move
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.tasks,
		callback = function()
			util.update_highlight(buf.tasks, rewind_highlight_namespace)
		end,
	})

	help.update(buf.help, "tasks")

	-- Initial highlight
	util.clear_highlights(buf, rewind_highlight_namespace)
	util.update_highlight(buf.tasks, rewind_highlight_namespace)

	keymap.select_task(buf, function()
		local line = api.nvim_get_current_line()
		print("Selected: " .. line)
	end)

	keymap.escape_task(buf, function()
		api.nvim_set_current_win(win.lists)
		M.init_lists_selection(win, buf)
	end)
end

return M
