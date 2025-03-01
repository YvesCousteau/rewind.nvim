local M = {}
local rewind = require("rewind")
M.status = rewind.lazy_load("rewind.config.status")
M.windows = rewind.lazy_load("rewind.config.windows")
M.help = rewind.lazy_load("rewind.config.help")
M.date_picker = rewind.lazy_load("rewind.config.date_picker")
M.confirmation = rewind.lazy_load("rewind.config.keymaps")
M.status = rewind.lazy_load("rewind.config.status")
M.keymaps = rewind.lazy_load("rewind.config.keymaps")

M.month = {
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December",
}

M.defaults = {
	file_path = "/path/to/save/todo.json",
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
