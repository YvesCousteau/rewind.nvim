local api = vim.api

local rewind = require("rewind")

local M = {}

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function load_json_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*all")
	file:close()

	local success, decoded = pcall(vim.json.decode, content)
	if not success then
		print("Error: Invalid JSON in file " .. path)
		return nil
	end

	if not decoded or type(decoded) ~= "table" then
		print("Failed to load JSON file or invalid data")
		return nil
	end

	return decoded
end

local function save_json_file(path, data)
	local file = io.open(path, "w")
	if not file then
		print("Error: Unable to open file for writing at " .. path)
		return false
	end

	local success, encoded = pcall(vim.json.encode, data)
	if not success then
		print("Error: Unable to encode data to JSON")
		file:close()
		return false
	end

	file:write(encoded)
	file:close()
	return true
end

local function extract_data(todo_type, board_title, list_title)
	local boards = load_json_file(rewind.config.options.file_path)
	if todo_type == "boards" then
		return boards
	else
		for _, board in ipairs(boards) do
			if board.title and board.title == board_title and board.lists and #board.lists > 0 then
				if todo_type == "lists" then
					return board.lists
				else
					for _, list in ipairs(board.lists) do
						if list.title and list.title == list_title and list.tasks and #list.tasks > 0 then
							if todo_type == "tasks" then
								return list.tasks
							end
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.get_boards()
	local boards = extract_data("boards")
	if not boards then
		return {}
	end

	local boards_title = {}
	for _, board in ipairs(boards) do
		if board.title then
			table.insert(boards_title, board.title)
		end
	end
	return boards_title
end

function M.get_lists(board_title)
	local lists = extract_data("lists", board_title)
	if not lists then
		return {}
	end

	local lists_title = {}
	for _, list in ipairs(lists) do
		table.insert(lists_title, list.title)
	end
	return lists_title
end

function M.get_first_list(board_title)
	local lists = extract_data("lists", board_title)
	if not lists then
		return {}
	end

	local first_list = lists[1].title
	if first_list then
		return first_list
	else
		return nil
	end
end

function M.get_tasks(board_title, list_title)
	local tasks = extract_data("tasks", board_title, list_title)

	if not tasks then
		return {}
	end

	local tasks_title = {}
	for _, task in ipairs(tasks) do
		table.insert(tasks_title, task.title)
	end
	return tasks_title
end

function M.clear_highlights(buf, namespace)
	for _, buffer_id in pairs(buf) do
		api.nvim_buf_clear_namespace(buffer_id, namespace, 0, -1)
	end
end

function M.update_highlight(buf, namespace)
	-- Clear previous highlights
	api.nvim_buf_clear_namespace(buf, namespace, 0, -1)

	-- Add highlight to the current line
	local current_line = api.nvim_win_get_cursor(0)[1] - 1
	api.nvim_buf_add_highlight(buf, namespace, "Visual", current_line, 0, -1)
end

function M.update_contents(buf, contents)
	if contents then
		local success, result = pcall(function()
			api.nvim_buf_set_option(buf, "modifiable", true)
			api.nvim_buf_set_lines(buf, 0, -1, false, contents)
			api.nvim_buf_set_option(buf, "modifiable", false)
		end)
		if not success then
			print("Error in update_contents: " .. result)
		end
	end
end

function M.update_data(input, todo_type, board_title, list_title, task_title)
	if not input or input == "" then
		return nil
	end
	local boards = load_json_file(rewind.config.options.file_path)

	for _, board in ipairs(boards) do
		if board.title and board.title == board_title then
			if todo_type == "board" then
				board.title = input
				return save_json_file(rewind.config.options.file_path, boards)
			else
				for _, list in ipairs(board.lists) do
					if list.title and list.title == list_title then
						if todo_type == "list" then
							list.title = input
							return save_json_file(rewind.config.options.file_path, boards)
						else
							for _, task in ipairs(list.tasks) do
								if task.title and task.title == task_title then
									if todo_type == "task" then
										task.title = input
										return save_json_file(rewind.config.options.file_path, boards)
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

function M.is_buffer_empty(buf)
	local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
	return #lines == 0 or (#lines == 1 and lines[1] == "")
end

function M.get_buffer_type(buf_table, buffer)
	for key, value in pairs(buf_table) do
		if value == buffer then
			return key
		end
	end
	return nil
end

return M
