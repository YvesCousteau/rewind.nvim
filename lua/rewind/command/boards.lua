local M = {}
local data = require("rewind.data")

function M.get_items()
	local titles = {}
	local data = data.load_items()
	if data then
		for _, board in ipairs(data) do
			table.insert(titles, board.title)
		end
	end
	return titles
end

return M
