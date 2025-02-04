local api = vim.api

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
		"--------------------------------------",
		"",
		"in => Boards",
		"",
		"Navigation:",
		"  Esc   - Close windows",
		"  Enter - Go to List items",
	},
	lists = {
		"--------------------------------------",
		"",
		"in => Lists",
		"",
		"Navigation:",
		"  Esc   - Go back Boards",
		"  Enter - Go to Tasks items",
	},
	tasks = {
		"--------------------------------------",
		"",
		"in => Tasks",
		"",
		"Navigation:",
		"  Esc   - Go back to Lists",
		"  Enter - Display Task name",
	},
}
--------------------------------------------------
-- Helper Functions
--------------------------------------------------
--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.init(buf, buffer_type)
	local content = vim.deepcopy(help_content["init"])
	if buffer_type and help_content[buffer_type] then
		for _, line in ipairs(help_content[buffer_type]) do
			table.insert(content, line)
		end
	end
	api.nvim_buf_set_lines(buf, 0, -1, false, content)
end

function M.update(buf, buffer_type)
	api.nvim_buf_set_option(buf, "modifiable", true)
	M.init(buf, buffer_type)
	api.nvim_buf_set_option(buf, "modifiable", false)
end

return M
