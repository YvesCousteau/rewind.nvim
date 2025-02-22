local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util

function M.get_items()
	local titles = {}
	local data = data.load_items()
	local current_board = util.get_cursor_content("boards")
	local current_list = util.get_cursor_content("lists")
	if data and current_board and current_list then
		for _, board in ipairs(data) do
			if board.title == current_board.title then
				for _, list in ipairs(board.lists) do
					if list.title == current_list.title then
						for _, task in ipairs(list.tasks) do
							table.insert(titles, "  [" .. task.state .. "] - " .. task.title)
						end
						return titles, list.tasks
					end
				end
			end
		end
	end
end

function M.add_item(title)
	local data = data.load_items()
	local new_item = {
		title = title,
		state = "TODO",
		date = "UNDEFINED",
	}
	local current_board = util.get_cursor_content("boards")
	local current_list = util.get_cursor_content("lists")
	if data and current_board and current_list then
		for _, board in ipairs(data) do
			if board.title == current_board.title then
				for _, list in ipairs(board.lists) do
					if list.title == current_list.title then
						table.insert(list.tasks, new_item)
						return data.update_items(data)
					end
				end
			end
		end
	end
end

function M.delete_item(title)
	local data = data.load_items()
	local current_board = util.get_cursor_content("boards")
	local current_list = util.get_cursor_content("lists")
	local current_task = util.get_cursor_content("tasks")
	if data and current_board and current_list and current_task then
		for _, board in ipairs(data) do
			if board.title == current_board.title then
				for _, list in ipairs(board.lists) do
					if list.title == current_list.title then
						for id, task in ipairs(list.tasks) do
							if task.title == current_task.title then
								table.remove(list.tasks, id)
								return data.update_items(data)
							end
						end
					end
				end
			end
		end
	end
end

function M.update_item(title)
	local data = data.load_items()
	local current_board = util.get_cursor_content("boards")
	local current_list = util.get_cursor_content("lists")
	local current_task = util.get_cursor_content("tasks")
	if data and current_board and current_list and current_task then
		for _, board in ipairs(data) do
			if board.title == current_board.title then
				for _, list in ipairs(board.lists) do
					if list.title == current_list.title then
						for _, task in ipairs(list.tasks) do
							if task.title == current_task.title then
								task.title = title
								return data.update_items(data)
							end
						end
					end
				end
			end
		end
	end
end

return M
