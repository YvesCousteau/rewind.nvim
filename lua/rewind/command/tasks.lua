local M = {}
local rewind = require("rewind")
local data = rewind.data
local util = rewind.util
local command = rewind.command

function M.get(list, current_task, callback)
	if list then
		for id, task in ipairs(list.tasks) do
			if current_task then
				if task.title == current_task.title then
					return id, task
				end
			else
				callback(task.title, task.state, task.date, task.tags)
			end
		end
	end
end

function M.get_items()
	local titles = {}
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if list and list.tasks then
				M.get(list, nil, function(title, state, date, tags)
					local tag_chars = ""
					for _, tag in pairs(tags) do
						local r, g, b = tag.color:match("#(%x%x)(%x%x)(%x%x)")
						r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
						-- local color_code = string.format("\27[38;2;%d;%d;%dm", r, g, b)
						-- tag_chars = tag_chars .. color_code .. "•\27[0m"
						tag_chars = tag_chars .. string.format("\27[38;2;%d;%d;%dm%s\27[0m", r, g, b, tag.title .. " ")
					end
					-- local name = "  [" .. state .. "] - " .. title .. " - " .. tag_chars
					-- local name = "x\27[31m"
					local name = tag_chars .. string.format("\27[38;2;0;0;0m%s\27[0m", title)
					if date ~= "UNDEFINED" then
						table.insert(titles, name .. " - " .. date)
					else
						table.insert(titles, name)
					end
				end)
				return titles, list.tasks
			end
		end
	end
	return titles, {}
end

function M.add_item(title)
	local new_item = {
		title = title,
		state = "TODO",
		date = "UNDEFINED",
		tags = {},
	}

	local boards = data.load_items()
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")

	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if list and list.tasks then
				table.insert(list.tasks, new_item)
				return data.update_items(boards)
			end
		end
	end
end

function M.delete_item()
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")
	local _, current_task = util.get_cursor_content("tasks")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if list and current_task then
				local id, _ = M.get(list, current_task)
				if list.tasks and id then
					table.remove(list.tasks, id)
					return data.update_items(boards)
				end
			end
		end
	end
end

function M.update_item(value)
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")
	local _, current_task = util.get_cursor_content("tasks")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if list and current_task then
				local _, task = M.get(list, current_task)
				if task and task[value.key] then
					task[value.key] = value.data
					return data.update_items(boards)
				end
			end
		end
	end
end

return M
