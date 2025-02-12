local M = {}
local rewind = require("rewind")
local config = rewind.config
local ui = rewind.ui
local help = rewind.lazy_load("rewind.keymap.help")
local prompt = rewind.lazy_load("rewind.keymap.prompt")
local boards = rewind.lazy_load("rewind.keymap.boards")
local lists = rewind.lazy_load("rewind.keymap.lists")
local tasks = rewind.lazy_load("rewind.keymap.tasks")
M.util = rewind.lazy_load("rewind.keymap.util")

M.keymaps = {
	help_min = help,
	help_max = help,
	prompt = prompt,
	boards = boards,
	lists = lists,
	tasks = tasks,
}

local function common(key)
	M.util.set_keymap(key, "n", { config.keymaps.help }, function()
		ui.util.help_toggle_window("help_min")
		ui.util.help_toggle_window("help_max")
	end)
end

function M.setup(key)
	if M.keymaps[key] ~= nil then
		M.keymaps[key].setup()
	end
	common(key)
end

return M
