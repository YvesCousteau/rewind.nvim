local api = vim.api

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
	return vim.json.decode(content)
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.get_boards()
	local data = load_json_file("/home/me/perso/rewind.nvim/test/data.json")
	if not data or type(data) ~= "table" then
		print("Failed to load JSON file or invalid data")
		return
	end

	local boards = {}
	for _, board in ipairs(data) do
		if board.title then
			table.insert(boards, board.title)
		end
	end
	return boards
end

function M.get_lists(board_title)
	local data = load_json_file("/home/me/perso/rewind.nvim/test/data.json")
	if not data or type(data) ~= "table" then
		print("Failed to load JSON file or invalid data")
		return
	end

	for _, board in ipairs(data) do
		if board.title and board.title == board_title then
			local lists = {}
			for _, list in ipairs(board.lists) do
				table.insert(lists, list.title)
			end
			return lists
		end
	end
end

function M.get_first_list(board_title)
	local data = load_json_file("/home/me/perso/rewind.nvim/test/data.json")
	if not data or type(data) ~= "table" then
		print("Failed to load JSON file or invalid data")
		return
	end

	for _, board in ipairs(data) do
		if board.title and board.title == board_title then
			if board.lists and #board.lists > 0 then
				local first_list = board.lists[1].title
				if first_list then
					return first_list
				else
					return nil
				end
			else
				return nil
			end
		end
	end
end

function M.get_tasks(board_title, list_title)
	local data = load_json_file("/home/me/perso/rewind.nvim/test/data.json")
	if not data or type(data) ~= "table" then
		print("Failed to load JSON file or invalid data")
		return
	end

	for _, board in ipairs(data) do
		if board.title and board.title == board_title then
			for _, list in ipairs(board.lists) do
				if list.title and list.title == list_title then
					local tasks = {}
					for _, task in ipairs(list.tasks) do
						table.insert(tasks, task.title)
					end
					return tasks
				end
			end
		end
	end
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

return M
