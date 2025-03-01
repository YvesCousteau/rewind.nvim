local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local ui = rewind.ui
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "tags"
	keymap.util.set(key, "n", { config.keymaps.back }, function()
		ui.list.status.close_window(key, true)
	end)

	keymap.util.set(key, "n", { config.keymaps.select }, function()
		ui.util.toggle_window(key)
	end)

	keymap.util.set(key, "n", { config.keymaps.add }, function()
		util.prompt.set(key, nil, function(prompt)
			command.add_item(key, prompt)
		end, true)
	end)

	keymap.util.set(key, "n", { config.keymaps.delete }, function()
		util.confirmation.set(key, function()
			-- command.delete_item(key)
		end)
	end)

	keymap.util.set(key, "n", { config.keymaps.update }, function()
		util.prompt.set(key, "title", function(prompt)
			-- command.update_item(key, { key = "", data = prompt })
		end)
	end)

	keymap.util.set(key, "n", { "c" }, function()
		util.prompt.set(key, "color", function(prompt)
			local function is_valid_rgb(color)
				return color:match("^#%x%x%x%x%x%x$") ~= nil
			end

			local id, _ = util.get_cursor_content(key)
			if is_valid_rgb(prompt) and id then
				command.update_item(key, { id = id, key = "tags", data = prompt })
			else
				print("Invalid color format. Please use RGB format like #FFFFFF.")
			end
		end)
	end)
end

return M
