local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup(content)
	local todo = rewind.config.options.formatting.tasks.state.todo.icon
	local doing = rewind.config.options.formatting.tasks.state.doing.icon
	local done = rewind.config.options.formatting.tasks.state.done.icon
	local formated_content = {}
	for _, item in ipairs(content) do
		local icon = ""
		if "TODO" == item.state then
			icon = todo
		elseif "DOING" == item.state then
			icon = doing
		elseif "DONE" == item.state then
			icon = done
		end
		table.insert(formated_content, icon .. item.title)
	end
	return formated_content
end

function M.reverse(content)
	return content
end

return M
