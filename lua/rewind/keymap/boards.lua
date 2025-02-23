local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui
local command = rewind.command

function M.setup()
	local key = "boards"
	keymap.util.set(key, "n", { config.keymaps.select }, function()
		if util.buf.is_empty("lists") then
			util.switch_window("lists")
		else
			util.prompt.set(key, function(prompt)
				command.add_item("lists", prompt)
			end)
		end
	end)

	keymap.util.set(key, "n", { config.keymaps.back }, function()
		ui.util.close_all_window()
	end)

	keymap.util.set(key, "n", { config.keymaps.update }, function()
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
end

return M
