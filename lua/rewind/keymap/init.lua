local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local help = rewind.lazy_load("rewind.keymap.help")
local boards = rewind.lazy_load("rewind.keymap.boards")

M.keymaps = {
	help_min = help,
	help_max = help,
	help_max = boards,
}

function M.setup(key)
	if M.keymaps[key] ~= nil then
		M.keymaps[key].setup()
	end
end

return M
