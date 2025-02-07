local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup(content)
	local active_icon = rewind.config.options.formatting.boards.is_active.icon
	local inactive_icon = rewind.config.options.formatting.boards.is_inactive.icon
	local formated_content = {}
	for _, item in ipairs(content) do
		local icon = ""
		if rewind.state.get_current("board") == item.title then
			icon = active_icon
		else
			icon = inactive_icon
		end
		table.insert(formated_content, icon .. item.title)
	end
	return formated_content
end

function M.reverse(boards) end

return M
