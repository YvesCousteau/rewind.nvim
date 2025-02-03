local M = {}

function M.load_json_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*all")
	file:close()
	return vim.json.decode(content)
end

return M
