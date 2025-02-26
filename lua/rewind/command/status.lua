local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local data = rewind.data
local command = rewind.command

function M.get_items()
	local items = {}
	local raw_items = {}

	local status = "TODO"
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")
	local _, current_task = util.get_cursor_content("tasks")

	local boards = data.load_items()
	if boards then
		local _, board = command.list.boards.get(boards, current_board)
		if board then
			local _, list = command.list.lists.get(board, current_list)
			if list then
				local _, task = command.list.tasks.get(list, current_task)
				if task and task.state then
					status = task.state
				end
			end
		end
	end

	if status then
		table.insert(items, config.status.todo)
		table.insert(raw_items, "TODO")
		table.insert(items, config.status.doing)
		table.insert(raw_items, "DOING")
		table.insert(items, config.status.done)
		table.insert(raw_items, "DONE")
	end
	return items, raw_items
end

-- function M.update_item(date)
-- 	local _, current_board = util.get_cursor_content("boards")
-- 	local _, current_list = util.get_cursor_content("lists")
-- 	local _, current_task = util.get_cursor_content("tasks")
--
-- 	local boards = data.load_items()
-- 	if boards then
-- 		local _, board = command.list.boards.get(boards, current_board)
-- 		if board then
-- 			local _, list = command.list.lists.get(board, current_list)
-- 			if list then
-- 				local _, task = command.list.tasks.get(list, current_task)
-- 				local date_formated = "UNDEFINED"
-- 				if date ~= "UNDEFINED" then
-- 					date_formated = util.date_picker.get_formated(date)
-- 				end
-- 				if task and date_formated then
-- 					task.date = date_formated
-- 					data.update_items(boards)
-- 					command.get_items("tasks")
-- 					return true
-- 				end
-- 			end
-- 		end
-- 	end
-- end

return M
