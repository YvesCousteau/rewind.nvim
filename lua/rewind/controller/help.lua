local rewind = require("rewind")
local M = {}

function M.get()
	if rewind.state.help.is_expanded then
		return {
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
		}
	else
		return { 'Press - "h"' }
	end
end

function M.toggle()
	rewind.state.help.is_expanded = not rewind.state.help.is_expanded
	rewind.ui.help.open_window()
end

return M
