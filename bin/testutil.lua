local format = string.format
local abs = math.abs
local min = math.min
local append = table.insert
local concat = table.concat
local traceback = debug.traceback

local MAX_INDENT = 100
local INDENTS = { [0] = "", }
for i = 1, MAX_INDENT do INDENTS[i] = INDENTS[i - 1] .. "    " end
local TRANSLATION = {
	["\0"] = "\\0",
	["\n"] = "\\n",
	["\t"] = "\\t",
	["\r"] = "\\r",
	["\b"] = "\\b",
}
local function format_s(str)
	local ret = {}
	for i = 1, #str do
		local ch = str:sub(i, i)
		append(ret, TRANSLATION[ch] or ch)
	end
	return concat(ret, "")
end

local function dump(t, max_indent)
	local cache = {}
	local ret = {}
	local function _dump(t, indent, max_indent)
		local tp = type(t)
		if tp == "table" then
			if cache[t] == nil then
				cache[t] = true
				append(ret, "{")
				local empty = true
				for k, v in pairs(t) do
					append(ret, "\n")
					append(ret, INDENTS[min(indent + 1, max_indent)])
					append(ret, "[")
					_dump(k, 0, 0)
					append(ret, "] = ")
					_dump(v, indent + 1, max_indent)
					empty = false
				end
				if not empty then
					append(ret, "\n")
					append(ret, INDENTS[min(indent, max_indent)])
				end
				append(ret, "}")
			else
				append(ret, "{...}")
			end
		elseif tp == "number" or tp == "boolean" or tp == "nil" then
			append(ret, tostring(t))
		else
			append(ret, '"')
			append(ret, format_s(tostring(t)))
			append(ret, '"')
		end
	end

	_dump(t, 0, max_indent or MAX_INDENT)
	return concat(ret, "")
end

local function print_t(t, msg)
	if msg then
		print(msg, dump(t))
	else
		print(dump(t))
	end
end

local function compare_table(a, b, desc)
	desc = desc or "table"
	for k, v1 in pairs(a) do
		local v2 = b[k]
		if v1 ~= v2 then
			print(format("%s: not equal at key = %s, v1 = %s, v2 = %s", desc, k, v1, v2))
			print(traceback(nil, 2))
		end
	end
end

local function test(a, b, msg)
	if a ~= b then
		print(format("Test Failed %s: %s ~= %s", tostring(msg), tostring(a), tostring(b)))
		print(traceback(nil, 2))
	end
end

local function test_float(a, b, msg, epsilon)
	local v = abs(a - b)
	if v > epsilon then
		print(format("Test Failed %s: %f ~= %f", tostring(msg), a, b))
		print(traceback(nil, 2))
	end
end

return {
	dump = dump,
	print_t = print_t,
	test = test,
	test_float = test_float,
	compare_table = compare_table,
}
