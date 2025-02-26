local M = {}
local rewind = require("rewind")
local util = rewind.util
local command = rewind.command

function M.get()
	return util.buf.get_var("date_picker")
end

function M.get_unformated(date)
	local year, month, day = date:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")

	if year and month and day then
		year = tonumber(year)
		month = tonumber(month)
		day = tonumber(day)

		if month < 1 or month > 12 then
			print("Invalid month")
			return nil
		end

		local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
		if year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0) then
			days_in_month[2] = 29
		end

		if day < 1 or day > days_in_month[month] then
			print("Invalid day for the given month")
			return nil
		end

		if year < 1 then
			print("Invalid year")
			return nil
		end

		local is_valid = os.date("*t", os.time({ year = year, month = month, day = day }))

		if is_valid and is_valid.year == year and is_valid.month == month and is_valid.day == day then
			return {
				is_valid.year,
				is_valid.month,
				is_valid.day,
			}
		else
			print("Invalid date")
		end
	else
		print("Invalid date format")
	end
end

function M.get_formated(date)
	if date then
		return string.format("%04d-%02d-%02d", date[1], date[2], date[3])
	else
		return "UNDEFINED"
	end
end

local function format_checker(date, new_value, line_id)
	if new_value <= 0 then
		return nil
	end

	local year = date[1]
	local month = date[2]
	local day = date[3]

	if line_id == 2 and new_value > 12 then
		return nil
	elseif line_id == 3 then
		local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

		if year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0) then
			days_in_month[2] = 29
		end

		if new_value > days_in_month[month] then
			return nil
		end
	end
	return true
end

function M.set(date)
	util.buf.set_var("date_picker", date)
end

local function format_checker(date, new_value, line_id)
	if new_value <= 0 then
		return nil
	end

	local year = date[1]
	local month = date[2]
	local day = date[3]

	if line_id == 1 then
		year = new_value
	end

	local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

	if year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0) then
		days_in_month[2] = 29
	end

	if line_id == 2 then
		if new_value > 12 then
			return nil
		end
		month = new_value
	end

	if line_id == 2 or line_id == 1 then
		day = math.min(day, days_in_month[month])
	elseif line_id == 3 then
		if new_value > days_in_month[month] then
			return nil
		end
		day = new_value
	end

	return true, year, month, day
end

function M.increment()
	local line_id, value = util.get_cursor_content("date_picker")
	local date = M.get()
	if date and line_id and value and type(value) == "number" and date[line_id] then
		local new_value = value + 1
		local success, year, month, day = format_checker(date, new_value, line_id)
		if success then
			command.update_item("date_picker", {
				year or date[1],
				month or date[2],
				day or date[3],
			})
			command.get_items("date_picker")
		else
			print("Date format is invalid")
		end
	end
end

function M.decrement()
	local line_id, value = util.get_cursor_content("date_picker")
	local date = M.get()
	if date and line_id and value and type(value) == "number" and date[line_id] then
		local new_value = value - 1
		local success, year, month, day = format_checker(date, new_value, line_id)
		if success then
			command.update_item("date_picker", {
				year or date[1],
				month or date[2],
				day or date[3],
			})
			command.get_items("date_picker")
		else
			print("Date format is invalid")
		end
	end
end

function M.clear()
	command.update_item("tasks", { key = "date", data = "UNDEFINED" })
end

return M
