local M = {}
local rewind = require("rewind")
local config = rewind.config

function M.load_items()
	local path = config.options.file_path
	local file = io.open(path, "r")
	if not file then
		file = io.open(path, "w")
		if file then
			file:write("[]")
			file:close()
			print("Created new file at " .. path)
		else
			print("Unable to create file at " .. path)
			return {}
		end

		file = io.open(path, "r")
		if not file then
			print("Unable to open newly created file for reading at " .. path)
			return {}
		end
	end
	local content = file:read("*all")
	file:close()

	local success, decoded_content = pcall(vim.json.decode, content)
	if not success then
		print("Unable to decode JSON to table")
		return {}
	elseif not decoded_content or type(decoded_content) ~= "table" then
		print("Unable to get table")
		return {}
	else
		return decoded_content
	end
end

function M.save_items(data)
	local path = config.options.file_path
	local file = io.open(path, "w")
	if not file then
		print("Unable to open file for writing at " .. path)
		return nil
	end

	local success, encoded = pcall(vim.json.encode, data)
	if not success then
		print("Unable to encode table to JSON")
		file:close()
		return nil
	elseif not encoded then
		print("Unable to get JSON")
		file:close()
		return
	end

	file:write(encoded)
	file:close()
	return true
end

function M.update_items(new_items)
	local success = M.save_items(new_items)

	if not success then
		print("Failed to save new items")
	end

	return success
end

return M
