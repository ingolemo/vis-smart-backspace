require('vis')

local mod = {
	tab_width = 8,
}

local function is_spaces(str)
	return string.match(str, '^ *$') ~= nil
end

local function utf8_prefix_byte(byte)
	local number = byte:byte()
	return number < 128 or number >= 191
end

local function delete_characters(position, num_chars)
	local prefixes_seen = 0
	local num_bytes = 0
	repeat
		num_bytes = num_bytes + 1
		byte = vis.win.file:content(position - num_bytes, 1)
		if utf8_prefix_byte(byte) then
			prefixes_seen = prefixes_seen + 1
		end
	until (prefixes_seen >= num_chars)
	vis.win.file:delete(position - num_bytes, num_bytes)
	return num_bytes
end

local function near_space_indent(selection)
	local line_start = selection.pos - (selection.col - 1)
	local line_prefix = vis.win.file:content(line_start, selection.col - 1)
	return is_spaces(line_prefix)
end

local function modulus_big(dividend, divisor)
	local quotient = dividend % divisor
	if quotient == 0 then return divisor end
	return quotient
end

local function constrain(num, minimum, maximum)
	return math.max(minimum, math.min(num, maximum))
end

local function get_selections(win)
	local selections = {}
	for selection in win:selections_iterator() do
		if selection.pos ~= nil and selection.pos ~= 0 then
			table.insert(selections, selection)
		end
	end

	-- handle deletions backwards so as not to invalidate indices
	table.sort(selections, function(a, b) return a.pos > b.pos end)
	return selections
end

local function smart_backspace()
	for _, selection in ipairs(get_selections(vis.win)) do
		local length = 1
		if near_space_indent(selection) then
			local tab_stop = modulus_big(selection.col - 1, mod.tab_width)
			length = math.floor(constrain(tab_stop, 1, selection.col))
		end

		if length ~= nil then
			local pos = selection.pos
			local deleted_bytes = delete_characters(pos, length)
			selection.pos = pos - deleted_bytes
		end
	end
end

vis.events.subscribe(vis.events.INIT, function()
	vis:map(vis.modes.INSERT, '<Backspace>', smart_backspace)
end)

return mod