local M = {}
local config = require("rewind.config")

function M.setup()

	-- util.set_keymap(util.get_buffer("help_min"), "n", config.keymaps.help, function()
	-- 	print("should max")
	-- end)

	-- util.set_keymap(util.get_buffer("help_max"), "n", config.keymaps.help, function()
	-- 	print("should min")
	-- end)
end

return M
