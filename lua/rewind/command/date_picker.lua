local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local data = rewind.data
local command = rewind.command

local month_names = {
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December",
}

function M.get_items()
	local items = {}
	local raw_items = {}

	local date = os.date("*t", os.time())
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
				if task then
					if task.date and task.date ~= "UNDEFINED" then
						local unformated_date = util.date_picker.get_unformated(task.date)
						if unformated_date then
							date = unformated_date
						end
					end
				end
			end
		end
	end

	if date then
		table.insert(items, "Year  : " .. tostring(date.year))
		table.insert(raw_items, date.year)
		table.insert(items, "Month : " .. month_names[date.month])
		table.insert(raw_items, date.month)
		table.insert(items, "Day   : " .. tostring(date.day))
		table.insert(raw_items, date.day)
	end
	return items, raw_items
end

function M.update_item(date)
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
				local date_formated = "UNDEFINED"
				if date ~= "UNDEFINED" then
					date_formated = util.date_picker.get_formated(date)
				end
				if task and date_formated then
					task.date = date_formated
					data.update_items(boards)
					command.get_items("tasks")
					return true
				end
			end
		end
	end
end

return M
