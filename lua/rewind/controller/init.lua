local rewind = require("rewind")
local M = {}

M.boards = rewind.lazy_load("rewind.controller.boards")
M.lists = rewind.lazy_load("rewind.controller.lists")
M.tasks = rewind.lazy_load("rewind.controller.tasks")

function M.get_data(type, board_title, list_title)
	local boards = rewind.util.load_json_file(rewind.config.options.file_path)
	if type == "boards" then
		return boards
	else
		for _, board in ipairs(boards) do
			if board.title and board.title == board_title and board.lists and #board.lists > 0 then
				if type == "lists" then
					return board.lists
				else
					for _, list in ipairs(board.lists) do
						if list.title and list.title == list_title and list.tasks and #list.tasks > 0 then
							if type == "tasks" then
								return list.tasks
							end
						end
					end
				end
			end
		end
	end
end

function M.update_data(input, type, board_title, list_title, task_title)
	if not input or input == "" then
		return nil
	end

	local boards = function()
		local boards = rewind.util.load_json_file(rewind.config.options.file_path)

		for _, board in ipairs(boards) do
			if board.title and board.title == board_title then
				if type == "board" then
					board.title = input
					return boards
				else
					for _, list in ipairs(board.lists) do
						if list.title and list.title == list_title then
							if type == "list" then
								list.title = input
								return boards
							else
								for _, task in ipairs(list.tasks) do
									if task.title and task.title == task_title then
										if type == "task" then
											task.title = input
											return boards
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	rewind.util.save_json_file(rewind.config.options.file_path, boards)
end

return M
