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
			util.prompt.set(key, nil, function(prompt)
				command.add_item("lists", prompt)
			end, true)
		end
	end)

	keymap.util.set(key, "n", { config.keymaps.back }, function()
		ui.util.close_all_window()
	end)

	keymap.util.set(key, "n", { config.keymaps.update }, function()
		util.prompt.set(key, "title", function(prompt)
			command.update_item(key, { key = "title", data = prompt })
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.add }, function()
		util.prompt.set(key, nil, function(prompt)
			command.add_item(key, prompt)
		end, true)
	end)

	keymap.util.set(key, "n", { config.keymaps.delete }, function()
		util.confirmation.set(key, function()
			command.delete_item(key)
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.tags }, function()
		ui.util.toggle_window("tags")
	end)
end

return M
