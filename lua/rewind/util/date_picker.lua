local M = {}
local rewind = require("rewind")
local util = rewind.util

function M.set()
	local date = os.date("*t", os.time())
	if date then
		util.set_var("date", date)
	end
end

function M.get()
	local date = util.get_var("date")
	if date then
		return date
	else
		return {}
	end
end

function M.get_formated()
	local date = M.get()
	if date then
		return string.format("%04d-%02d-%02d", date.year, date.month, date.day)
	else
		return "UNDEFINED"
	end
end

-- function M.set()
-- 	local date = os.date("*t", os.time())
-- 	util.set_var("date", date_formated)
-- end

-- function M.incrementDay()
-- 	date.day = date.day + 1
-- 	date = os.date("*t", os.time(date))
-- end
--
-- function M.decrementDay()
-- 	date.day = date.day - 1
-- 	date = os.date("*t", os.time(date))
-- end
--
-- function M.incrementMonth()
-- 	date.month = date.month + 1
-- 	date = os.date("*t", os.time(date))
-- end
--
-- function M.decrementMonth()
-- 	date.month = date.month - 1
-- 	date = os.date("*t", os.time(date))
-- end
--
-- function M.incrementYear()
-- 	date.year = date.year + 1
-- end
--
-- function M.decrementYear()
-- 	date.year = date.year - 1
-- end

return M
