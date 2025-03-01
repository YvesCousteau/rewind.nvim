local M = {
	min = {
		init = {
			'Press - "h"',
		},
	},
	max = {
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
			"  u     - Update selected Board",
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
			"  u     - Update selected List",
		},
		tasks = {
			"------------- Tasks --------------",
			"",
			"Navigation:",
			"  Esc   - Go back to previous Lists",
			"  Enter - Update selected Task",
			"  a     - Create new Task",
			"  d     - Delete selected Task",
			"  u     - Update selected Task",
		},
	},
}

return M
