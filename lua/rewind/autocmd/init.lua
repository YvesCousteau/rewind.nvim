local M = {}
local rewind = require("rewind")
local util = rewind.util
M.util = rewind.lazy_load("rewind.autocmd.util")
local boards = rewind.lazy_load("rewind.autocmd.boards")

M.list = {
	-- boards = boards,
}

local function common(key)
	M.util.set(key, { "WinLeave" }, function()
		util.set_prev_buf(key)
	end)
	M.util.set(key, { "CursorMoved" }, function()
		local board = ""
		local board_content = util.get_cursor_content("boards")
		if board_content then
			board = board_content.title
		end

		local list = ""
		local list_content = util.get_cursor_content("lists")
		if list_content then
			list = list_content.title
		end

		local task = ""
		local task_content = util.get_cursor_content("tasks")
		if task_content then
			task = task_content.title
		end

		print("board: " .. vim.inspect(board) .. " |> list: " .. vim.inspect(list) .. " |> task: " .. vim.inspect(task))
	end)

	-- M.util.set(key, { "CursorMoved" }, function()
	-- 	-- should update highlight into formating update
	-- end)
end

function M.setup(key)
	if M.list[key] ~= nil then
		M.list[key].setup()
	end
	common(key)
end

return M
