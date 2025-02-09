local M = {}
local config = require("rewind.config").config

function M.load_items()
	local file = io.open(config.todo_file, "r")
	if not file then
		return {}
	end

	local items = {}
	for line in file:lines() do
		table.insert(items, line)
	end
	file:close()
	return items
end

function M.add_item(item)
	local file = io.open(config.todo_file, "a")
	file:write(string.format("[%s] %s\n", item.status, item.content))
	file:close()
end

function M.toggle_status(id)
	-- Logic to toggle status in the file (e.g., TODO -> DONE).
end

return M
