local M = {}
local help = require("rewind.keymap.help")
local boards = require("rewind.keymap.boards")

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
