local api = vim.api

local rewind = require("rewind")

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
			rewind.util.update_highlight(buf.boards, rewind_highlight_namespace)
			local current_board = api.nvim_get_current_line()
			rewind.util.update_contents(buf.lists, rewind.util.get_lists(current_board))
			rewind.util.update_contents(
				buf.tasks,
				rewind.util.get_tasks(current_board, rewind.util.get_first_list(current_board))
			)
		end,
	})

	rewind.help.update(buf.help, "boards")

	-- Initial highlight
	rewind.util.clear_highlights(buf, rewind_highlight_namespace)
	rewind.util.update_highlight(buf.boards, rewind_highlight_namespace)

	rewind.keymap.select_board(buf, function()
		local current_board = api.nvim_get_current_line()
		api.nvim_set_current_win(win.lists)
		M.init_lists_selection(win, buf, current_board)
	end)

	rewind.keymap.escape_board(buf)
end

function M.init_lists_selection(win, buf, current_board)
	-- Set up autocmd to update highlight on cursor move
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.lists,
		callback = function()
			rewind.util.update_highlight(buf.lists, rewind_highlight_namespace)
			local current_list = api.nvim_get_current_line()
			rewind.util.update_contents(buf.tasks, rewind.util.get_tasks(current_board, current_list))
		end,
	})

	rewind.help.update(buf.help, "lists")

	-- Initial highlight
	rewind.util.clear_highlights(buf, rewind_highlight_namespace)
	rewind.util.update_highlight(buf.lists, rewind_highlight_namespace)

	rewind.keymap.select_list(buf, function()
		local current_list = api.nvim_get_current_line()
		api.nvim_set_current_win(win.tasks)
		M.init_tasks_selection(win, buf, current_board, current_list)
	end)

	rewind.keymap.escape_list(buf, function()
		api.nvim_set_current_win(win.boards)
		M.init_boards_selection(win, buf)
	end)
end

function M.init_tasks_selection(win, buf, current_board, current_list)
	-- Set up autocmd to update highlight on cursor move
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.tasks,
		callback = function()
			rewind.util.update_highlight(buf.tasks, rewind_highlight_namespace)
		end,
	})

	rewind.help.update(buf.help, "tasks")

	-- Initial highlight
	rewind.util.clear_highlights(buf, rewind_highlight_namespace)
	rewind.util.update_highlight(buf.tasks, rewind_highlight_namespace)

	-- maybe not enter
	rewind.keymap.select_task(buf, function()
		rewind.ui.open_input(function(input)
			if input then
				print(
					"User entered: " .. input .. " | with board: " .. current_board .. " | with list: " .. current_list
				)
			end
		end)
	end)

	rewind.keymap.escape_task(buf, function()
		api.nvim_set_current_win(win.lists)
		M.init_lists_selection(win, buf)
	end)
end

return M
