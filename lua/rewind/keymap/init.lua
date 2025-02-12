local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local help = rewind.lazy_load("rewind.keymap.help")
local boards = rewind.lazy_load("rewind.keymap.boards")
M.util = rewind.lazy_load("rewind.keymap.util")

M.keymaps = {
	help_min = help,
	help_max = help,
	boards = boards,
}

local function common(key)
	M.set_keymap(key, "n", config.keymaps.help, function()
		ui.util.toggle_window("help_min")
		ui.util.toggle_window("help_max")
	end)
end

function M.setup(key)
	if M.keymaps[key] ~= nil then
		M.keymaps[key].setup()
	end
	common(key)
end

return M
