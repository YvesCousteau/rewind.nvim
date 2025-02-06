local api = vim.api

local rewind = require("rewind")

local M = {}

--------------------------------------------------
-- Local Variables and Cache
--------------------------------------------------
local help_content = {
	init = {
		"Rewind Plugin Help",
		"",
		"Navigation:",
		"  j/k   - Move up/down",
		"  q     - Close windows",
		"  h     - Show help",
		"",
		"Windows:",
		"  Boards - Select a Board",
		"  Lists  - View Lists in a board",
		"  Tasks  - View Tasks in a list",
		"",
		"Commands:",
		"  :RewindToggle - Toggle Rewind UI",
		"",
		"----------------------------------",
		"",
	},
	boards = {
		"in => Boards",
		"",
		"Navigation:",
		"  Esc   - Close windows",
		"  Enter - Go to selected List items",
		"  a     - Create new Board",
		"  d     - Delete selected Board",
	},
	lists = {
		"in => Lists",
		"",
		"Navigation:",
		"  Esc   - Go back to previous Boards",
		"  Enter - Go to selected Tasks items",
		"  a     - Create new List",
		"  d     - Delete selected List",
	},
	tasks = {
		"in => Tasks",
		"",
		"Navigation:",
		"  Esc   - Go back to previous Lists",
		"  Enter - Update selected Task name",
		"  a     - Create new Task",
		"  d     - Delete selected Task",
	},
}

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.create_help(buffer, buffer_type)
	local content = vim.deepcopy(help_content["init"])
	if buffer_type and help_content[buffer_type] then
		for _, line in ipairs(help_content[buffer_type]) do
			table.insert(content, line)
		end
	end
	api.nvim_buf_set_lines(buffer, 0, -1, false, content)
end

function M.update_help(buf_table, current_buffer)
	local buffer_type = rewind.util.get_buffer_type(buf_table, current_buffer)
	if buffer_type then
		M.create_help(buf_table.help, buffer_type)
	else
		print("Unknown buffer type")
	end
end

return M
