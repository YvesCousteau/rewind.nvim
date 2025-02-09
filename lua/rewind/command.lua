local M = {}
local data = require("rewind.data")

function M.add_todo()
	local input = vim.fn.input("New TODO: ")
	if input ~= "" then
		data.add_item({ content = input, status = "TODO" })
		print("TODO added!")
	end
end

-- function M.toggle_status()
-- 	local item_id = vim.fn.input("Enter TODO ID: ")
-- 	data.toggle_status(tonumber(item_id))
-- end

return M
