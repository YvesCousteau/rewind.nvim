local api = vim.api

local rewind = require("rewind")

local M = {}

--------------------------------------------------
-- Local Variables and Cache
--------------------------------------------------
local rewind_highlight_namespace = api.nvim_create_namespace("RewindHighlight")

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function update_board_selection(buf, current_board)
	rewind.util.update_contents(buf.lists, rewind.util.get_lists(current_board))
	rewind.util.update_contents(
		buf.tasks,
		rewind.util.get_tasks(current_board, rewind.util.get_first_list(current_board))
	)
end

local function update_list_selection(buf, current_board, current_list)
	rewind.util.update_contents(buf.tasks, rewind.util.get_tasks(current_board, current_list))
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.init_boards_selection(win, buf)
	rewind.ui.close_help_window()

	-- Set up autocmd to update highlight on cursor move
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.boards,
		callback = function()
			rewind.util.update_highlight(buf.boards, rewind_highlight_namespace)
			local current_board = api.nvim_get_current_line()
			update_board_selection(buf, current_board)
		end,
	})

	-- Initial highlight
	rewind.util.clear_highlights(buf, rewind_highlight_namespace)
	rewind.util.update_highlight(buf.boards, rewind_highlight_namespace)

	rewind.keymap.select_board(buf.boards, function()
		local current_board = api.nvim_get_current_line()

		if not rewind.util.is_buffer_empty(buf.lists) then
			api.nvim_set_current_win(win.lists)
			M.init_lists_selection(win, buf, current_board)
		end
	end)

	rewind.keymap.escape_board(win.boards, buf.boards)
end

function M.init_lists_selection(win, buf, current_board)
	rewind.ui.close_help_window()

	-- Set up autocmd to update highlight on cursor move
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.lists,
		callback = function()
			rewind.util.update_highlight(buf.lists, rewind_highlight_namespace)
			local current_list = api.nvim_get_current_line()
			update_list_selection(buf, current_board, current_list)
		end,
	})

	-- Initial highlight
	rewind.util.clear_highlights(buf, rewind_highlight_namespace)
	rewind.util.update_highlight(buf.lists, rewind_highlight_namespace)

	rewind.keymap.select_list(buf.lists, function()
		local current_list = api.nvim_get_current_line()
		if not rewind.util.is_buffer_empty(buf.tasks) then
			api.nvim_set_current_win(win.tasks)
			M.init_tasks_selection(win, buf, current_board, current_list)
		end
	end)

	rewind.keymap.escape_list(buf.lists, function()
		api.nvim_set_current_win(win.boards)
		M.init_boards_selection(win, buf)
	end)
end

function M.init_tasks_selection(win, buf, current_board, current_list)
	rewind.ui.close_help_window()

	-- Set up autocmd to update highlight on cursor move
	api.nvim_create_autocmd("CursorMoved", {
		buffer = buf.tasks,
		callback = function()
			rewind.util.update_highlight(buf.tasks, rewind_highlight_namespace)
		end,
	})

	-- Initial highlight
	rewind.util.clear_highlights(buf, rewind_highlight_namespace)
	rewind.util.update_highlight(buf.tasks, rewind_highlight_namespace)

	-- maybe not enter
	rewind.keymap.select_task(buf.tasks, function()
		local current_task = api.nvim_get_current_line()
		rewind.ui.open_input_window("Update Task", function(input)
			if input then
				rewind.util.update_data(input, "task", current_board, current_list, current_task)
				update_list_selection(buf, current_board, current_list)
			end
		end, current_task)
	end)

	rewind.keymap.escape_task(buf.tasks, function()
		api.nvim_set_current_win(win.lists)
		M.init_lists_selection(win, buf, current_board)
	end)
end

return M
