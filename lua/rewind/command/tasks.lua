local M = {}
local data = require("rewind.data")

function M.get_items()
	local titles = {}
	local data = data.load_items()
	if data then
		for _, board in ipairs(data) do
			for _, list in ipairs(board.lists) do
				for _, task in ipairs(list.tasks) do
					table.insert(titles, "  [" .. task.state .. "] - " .. task.title)
				end
			end
		end
	end
	return titles
end

return M
