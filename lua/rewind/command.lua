local M = {}
local data = require("rewind.data")

local function get_board_titles()
	local titles = {}
	local data = data.load_items()
	if data then
		for _, board in ipairs(data) do
			table.insert(titles, board.title)
		end
	end
	return titles
end

local function get_list_titles()
	local titles = {}
	local data = data.load_items()
	if data then
		for _, board in ipairs(data) do
			for _, list in ipairs(board.lists) do
				table.insert(titles, list.title)
			end
		end
	end
	return titles
end

local function get_task_titles()
	local titles = {}
	local data = data.load_items()
	if data then
		for _, board in ipairs(data) do
			for _, list in ipairs(board.lists) do
				for _, task in ipairs(list.tasks) do
					table.insert(titles, "  [" .. task.state .. "] - " .. task.title)
				end
			end
		end
	end
	return titles
end

local function get_help()
	local titles = { "help me lol" }
	return titles
end

function M.get_titles(key)
	if key == "boards" then
		return get_board_titles()
	elseif key == "lists" then
		return get_list_titles()
	elseif key == "tasks" then
		return get_task_titles()
	elseif key == "help_min" or key == "help_max" then
		return get_help()
	else
		return {}
	end
end

return M
