local M = {}
local rewind = require("rewind")
local config = rewind.config
local ui = rewind.ui
local help = rewind.lazy_load("rewind.keymap.help")
M.util = rewind.lazy_load("rewind.keymap.util")

M.list = {
	help_min = help,
	help_max = help,
	prompt = rewind.lazy_load("rewind.keymap.prompt"),
	boards = rewind.lazy_load("rewind.keymap.boards"),
	lists = rewind.lazy_load("rewind.keymap.lists"),
	tasks = rewind.lazy_load("rewind.keymap.tasks"),
	confirmation = rewind.lazy_load("rewind.keymap.confirmation"),
	date_picker = rewind.lazy_load("rewind.keymap.date_picker"),
	status = rewind.lazy_load("rewind.keymap.status"),
	tags = rewind.lazy_load("rewind.keymap.tags"),
}

local function common(key)
	M.util.set(key, "n", { config.keymaps.help }, function()
		ui.util.toggle_window("help_min")
		ui.util.toggle_window("help_max")
	end)
end

function M.setup(key)
	if M.list[key] ~= nil then
		M.list[key].setup()
	end
	common(key)
end

return M
