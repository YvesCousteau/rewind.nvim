local rewind = require("rewind")
local M = {}

local content = {
	init = {
		"Rewind Plugin Help",
		"",
		"Navigation:",
		"  j/k   - Move up/down",
		"  q     - Close windows",
		"  h     - Show/Hide help",
		"",
		"Windows:",
		"  Boards - Select a Board",
		"  Lists  - View Lists in a board",
		"  Tasks  - View Tasks in a list",
		"",
		"Commands:",
		"  :RewindToggle - Toggle Rewind UI",
		"",
	},
	boards = {
		"------------- Boards -------------",
		"",
		"Navigation:",
		"  Esc   - Close windows",
		"  Enter - Go to selected List items",
		"  a     - Create new Board",
		"  d     - Delete selected Board",
	},
	lists = {
		"------------- Lists --------------",
		"in => ",
		"",
		"Navigation:",
		"  Esc   - Go back to previous Boards",
		"  Enter - Go to selected Tasks items",
		"  a     - Create new List",
		"  d     - Delete selected List",
	},
	tasks = {
		"------------- Tasks --------------",
		"",
		"Navigation:",
		"  Esc   - Go back to previous Lists",
		"  Enter - Update selected Task name",
		"  a     - Create new Task",
		"  d     - Delete selected Task",
	},
}

function M.get()
	if rewind.state.help.is_expanded then
		local updated_content = vim.deepcopy(content["init"])
		local type = rewind.state.help.type
		if type and content[type] then
			for _, line in ipairs(content[type]) do
				table.insert(updated_content, line)
			end
		end
		return updated_content
	else
		return { 'Press - "h"' }
	end
end

return M
