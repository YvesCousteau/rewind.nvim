local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui
local command = rewind.command

function M.setup()
	local key = "tasks"

	keymap.util.set(key, "n", {
		config.keymaps.select,
		config.keymaps.update,
	}, function()
		util.prompt.set(key, function(prompt)
			command.update_item(key, prompt)
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.add }, function()
		util.prompt.set(key, function(prompt)
			command.add_item(key, prompt)
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.delete }, function()
		command.delete_item(key)
	end)

	keymap.util.set(key, "n", { config.keymaps.back }, function()
		util.switch_window("lists")
	end)
end

return M
