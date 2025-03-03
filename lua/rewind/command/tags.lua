local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local data = rewind.data
local command = rewind.command

function generate_unique_color(index)
	local function get_character(i)
		local hex_chars = "0123456789ABCDEF"
		return string.sub(hex_chars, i % 16 + 1, i % 16 + 1)
	end

	local color = "#"
	for i = 0, 5 do
		local bit_value = bit.band(bit.rshift(index, i * 4), 0x0F)
		color = color .. get_character(bit_value)
	end
	return color
end

function M.get_tags(callback)
	local key = "tags"
	local _, board = util.get_cursor_content("boards")
	local buf = util.buf.get(key)

	if buf and board and board.tags and #board.tags > 0 then
		for id, tag in ipairs(board.tags) do
			if tag.title and tag.color then
				callback(buf, board, id, tag)
			end
		end
	end
end

function M.get_items()
	local items = {}
	local raw_items = {}
	local _, current_board = util.get_cursor_content("boards")
	if current_board and current_board.tags and #current_board.tags > 0 then
		for _, tag in ipairs(current_board.tags) do
			table.insert(items, " 󰽢 " .. tag.title)
			table.insert(raw_items, tag)
		end
	end
	return items, raw_items
end

function M.add_item(tag)
	local _, current_board = util.get_cursor_content("boards")
	local buf = util.buf.get("tags")
	if current_board and current_board.tags and buf then
		for _, existing_tag in ipairs(current_board.tags) do
			if existing_tag.title == tag then
				print("tag " .. tag .. " is already present")
				return false
			end
		end

		local new_color = generate_unique_color(#current_board.tags)

		table.insert(current_board.tags, {
			title = tag,
			color = new_color,
		})

		local updated = command.update_item("boards", {
			key = "tags",
			data = current_board.tags,
		})

		if updated then
			command.get_items("tags")
			util.tags.init_tags_color()
			return true
		end
	end
	return false
end

function M.update_item(value)
	local _, current_board = util.get_cursor_content("boards")
	if current_board and current_board.tags then
		current_board.tags[value.id][value.key] = value.data
		command.update_item("boards", {
			key = "tags",
			data = current_board.tags,
		})
		command.get_items("tags")
		util.tags.init_tags_color()
	end
end

return M
