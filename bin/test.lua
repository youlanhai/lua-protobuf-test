
print("hello lua")

local pb = pb or require "pb"
local testutil = require "testutil"

local dump = testutil.dump
local print_t = testutil.print_t
local test = testutil.test
local test_float = testutil.test_float
local compare_table = testutil.compare_table

local function test_addressbook()

	local person = {
		name = "Alice",
		id = 12345,
		phone = {
			{ number = "1301234567" },
			{ number = "87654321", type = "WORK" },
		}
	}

	local code = assert(pb.encode("addressbook.Person", person))
	local v = assert(pb.decode("addressbook.Person", code))

	test(v.name, person.name, "person.name")
	test(v.id, person.id, "person.name")
	test(v.phone[1].number, person.phone[1].number, "person.phone[1].number")
	test(v.phone[2].number, person.phone[2].number, "person.phone[1].number")
	test(v.phone[2].type, 2, "person.phone[1].type")
end

local function test_types()
	-- 当数字比较大时，由于lua的double和int64转换的时候会丢失精度，
	-- 因此，内部自动转换成了字符串。
	local MAX_UINT64 = "18446744073709551615"
	local MAX_INT64  = "9223372036854775807"
	local MIN_INT64  = "-9223372036854775808"

	-- 通用测试 和 int64正边界测试
	local input = {
		v_double 	= 123456789.12345,
		v_float 	= 12345.67,

		v_int32 	= 0x7fffffff,
		v_sint32 	= 0x7fffffff,
		v_uint32 	= 0xffffffff,
		v_sfixed32 	= 0x7fffffff,
		v_fixed32 	= 0xffffffff,

		v_int64 	= MAX_INT64,
		v_sint64 	= MAX_INT64,
		v_uint64 	= MAX_UINT64,
		v_sfixed64 	= MAX_INT64,
		v_fixed64 	= MAX_UINT64,

		v_bool 		= false,
		v_string 	= "hello world",
		v_bytes 	= "hello\0world",

		v_enum 		= 1,
	}
	print_t(input, "test")

	local bin_data = assert(pb.encode("test.TestTypes", input))
	print("len proto data", #bin_data)

	local output = assert(pb.decode("test.TestTypes", bin_data))

	print("test pb 1 ...")
	test_float(output.v_float, input.v_float, "v_float", 0.01)
	test(output.v_double, input.v_double, "v_double")

	test(output.v_int32, input.v_int32, "v_int32")
	test(output.v_sint32, input.v_sint32, "v_sint32")
	test(output.v_uint32, input.v_uint32, "v_uint32")
	test(output.v_sfixed32, input.v_sfixed32, "v_sfixed32")
	test(output.v_fixed32, input.v_fixed32, "v_fixed32")

	test(output.v_int64, input.v_int64, "v_int64")
	test(output.v_sint64, input.v_sint64, "v_sint64")
	test(output.v_uint64, input.v_uint64, "v_uint64")
	test(output.v_sfixed64, input.v_sfixed64, "v_sfixed64")
	test(output.v_fixed64, input.v_fixed64, "v_fixed64")

	test(output.v_bool, input.v_bool, "v_bool")
	test(output.v_string, input.v_string, "v_string")
	test(output.v_bytes, input.v_bytes, "v_bytes")
	test(output.v_enum, input.v_enum, "v_enum")

	-- 通用测试 和 int64负边界测试
	print("test pb 2 ...")
	input = {
		v_double 	= -0.1234567890123,
		v_float 	= -0.12345,

		v_int32 	= -0x7fffffff,
		v_sint32 	= -0x7fffffff,
		v_uint32 	= -1,
		v_sfixed32 	= -0x7fffffff,
		v_fixed32 	= -1,
		
		v_int64 	= MIN_INT64,
		v_sint64 	= MIN_INT64,
		v_uint64 	= "-1",
		v_sfixed64 	= MIN_INT64,
		v_fixed64 	= -1,

		v_bool 		= true,
		v_string 	= "hello world",
		v_bytes 	= "hello\0world",
	}
	output = pb.decode("test.TestTypes", pb.encode("test.TestTypes", input))

	test_float(output.v_float, input.v_float, "v_float", 0.00001)
	test(output.v_double, input.v_double, "v_double")

	test(output.v_int32, input.v_int32, "v_int32")
	test(output.v_sint32, input.v_sint32, "v_sint32")
	test(output.v_uint32, 0xffffffff, "v_uint32")
	test(output.v_sfixed32, input.v_sfixed32, "v_sfixed32")
	test(output.v_fixed32, 0xffffffff, "v_fixed32")

	test(output.v_int64, input.v_int64, "v_int64")
	test(output.v_sint64, input.v_sint64, "v_sint64")
	test(output.v_uint64, MAX_UINT64, "v_uint64")
	test(output.v_sfixed64, input.v_sfixed64, "v_sfixed64")
	test(output.v_fixed64, MAX_UINT64, "v_fixed64")

	test(output.v_bool, input.v_bool, "v_bool")
	test(output.v_string, input.v_string, "v_string")
	test(output.v_bytes, input.v_bytes, "v_bytes")

	-- int32正边界测试
	print("test pb 3 ...")
	input.v_int64 = 0x7fffffff
	input.v_sint64 = 0x7fffffff
	input.v_uint64 = 0xffffffff
	input.v_sfixed64 = 0x7fffffff
	input.v_fixed64 = 0xffffffff
	output = pb.decode("test.TestTypes", pb.encode("test.TestTypes", input))
	test(output.v_int64, input.v_int64, "v_int64")
	test(output.v_sint64, input.v_sint64, "v_sint64")
	test(output.v_uint64, input.v_uint64, "v_uint64")
	test(output.v_sfixed64, input.v_sfixed64, "v_sfixed64")
	test(output.v_fixed64, input.v_fixed64, "v_fixed64")

	-- int32负边界测试
	print("test pb 4 ...")
	input.v_int64 = -0x7fffffff
	input.v_sint64 = -0x7fffffff
	input.v_uint64 = 4294967297
	input.v_sfixed64 = -0x7fffffff
	input.v_fixed64 = 4294967297
	output = pb.decode("test.TestTypes", pb.encode("test.TestTypes", input))
	test(output.v_int64, input.v_int64, "v_int64")
	test(output.v_sint64, input.v_sint64, "v_sint64")
	test(output.v_uint64, "4294967297", "v_uint64")
	test(output.v_sfixed64, input.v_sfixed64, "v_sfixed64")
	test(output.v_fixed64, "4294967297", "v_fixed64")
end

local dump_type

local function dump_fields(types, type)
	local fields = {}
	for i = 1, type:nfields() do
		local f = type:getfield(i)
		if f then
			local tp = f:type()
			local field = {
				name = f:name(),
				type = tp and tp:name(),
				tag = f:tag(),
				value = f:value(),
				isrequired = f:isrequired(),
				isrepeated = f:isrepeated(),
			}
			table.insert(fields, field)
			if tp then
				dump_type(types, tp)
			end
		end
	end
	return fields
end

dump_type = function(types, type)
	local name = type:name()
	if types[name] ~= nil then
		return
	end

	local ret = {
		__cname = type.__cname,
		name = name,
		basename = type:basename(),
		isenum = type:isenum(),
	}
	types[name] = ret

	if ret.isenum then
		ret.enums = type:to_enums()
	else
		ret.fields = dump_fields(types, type)
	end
end

local function test_map()
	print("test map ...")
	-- local tp = pb.findtype("test.TestMap")
	-- local types = {}
	-- dump_type(types, tp)
	-- print_t(types, "types")

	local input = {
		v_map = {
			[1] = "xxx",
			[4] = "yyy",
		},
		users = {
			jack = {name = "jack", age = 20},
			lily = {name = "lily", age = 22},
		},
	}

	local bin, err = pb.encode("test.TestMap", input)
	assert(bin, err)
	local output = pb.decode("test.TestMap", bin)
	print_t(output)

	compare_table(output.v_map, input.v_map, "test.TestMap")
	compare_table(output.users.jack, input.users.jack, "test.TestMap")
	compare_table(output.users.lily, input.users.lily, "test.TestMap")
end

local function test_enum()
	print("test enum ..")
	local tp = pb.findtype("test.TestEnum")
	print(tp.__cname, tp:name(), tp:basename())
	print("is enum:", tp:isenum())

	print_t(tp:to_enums(), "enums")
end

pb.loadfile("addressbook.pb")
test_addressbook()

pb.loadfile("test.pb")
test_types()
test_map()
test_enum()
