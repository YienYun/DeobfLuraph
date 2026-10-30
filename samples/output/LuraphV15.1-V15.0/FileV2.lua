-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime1(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime2(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime3(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime4(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime5(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime6(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime7(...)
	error("Luraph runtime function, not devirtualized")
end

local tbl = {}
local v = nil
local v2 = nil
local v3 = nil
local v4 = nil
local v5 = nil
local v32 = v3
local v42 = v4
local v52 = v5
local v6 = task
local cancel = v6.cancel
local spawn = v6.spawn
local defer = v6.defer
local delay = v6.delay
local wait = v6.wait
local v7 = Instance
local v8 = Vector3
local v9 = Vector2
local v10 = CFrame
local v11 = Random
local v12 = identifyexecutor
local v13 = loadstring
local tbl2 = {}
local n = 0

local function fn(arg, arg2)
	n += 1
	tbl2[n] = arg2 % 256
end

local function fn2(arg, arg2)
	local tbl3 = { 1, arg2 + 0, nil, 0, nil }

	while true do
		local v14 = tbl3[1]
		local v15 = tbl3[2]
		local n2 = tbl3[4] + v14
		tbl3[4] = n2

		if n2 <= v15 then
			local n3 = arg % 256
			arg = (arg - n3) / 256
			n += 1
			tbl2[n] = n3
		else
			break
		end
	end
end

local v14 = assert(debug, "The debug library is required on Luau platforms. Please open a support ticket.")
local info = v14.info
local traceback = v14.traceback
local n2 = 249549787

local function fn3()
	local function fn4()
		while true do
		end
	end

	fn4(nil, nil, nil, nil, 215831591, nil)

	while true do
	end
end

local function fn4()
	fn2(63640569, 4)
	n2 = 463964030
	fn3()
end

local tbl3 = { [false] = true, [true] = false }
local tbl4 = {}
local n3 = -4079319771

local function fn5(arg, arg2)
	if not nil and nil then
		if not nil and nil then
			return true
		end
		return false
	end

	tbl4[arg] = true
	local v15 = tbl4[arg2]

	if nil then
		n3 = bit32.bxor(n3, 1735407453)
	end

	tbl4[arg] = nil
	return v15
end

n3 = 460124378

local function fn6(arg)
	if not tbl3[not arg] then
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end

	local kind = type(arg)
	fn5("table", kind)

	if not nil then
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end

	local v15 = getmetatable(arg)
	fn5(nil, v15)

	if not nil then
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end

	pcall(setmetatable, arg, nil)
end

local function fn7(arg, arg2, ...)
	table.pack(string.byte(arg2, 1, -1))
	local tbl5 = { nil, nil, 1, select("#", table.unpack(t216_20_1, 1, t216_20_1.n)) + 0, 0 }

	while true do
		local v15 = tbl5[3]
		local v16 = tbl5[4]
		local n4 = tbl5[5] + v15
		tbl5[5] = n4

		if n4 <= v16 then
		else
			break
		end
	end

	local n4 = 2962552180

	if nil then
	end

	return n4
end

local function fn8(arg, arg2, arg3)
	for k in arg2, nil, nil do
		arg3[fn7(177471587, k)] = nil
	end

	for k in arg3, nil, nil do
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end
end

local new = v7.new
local new2 = v8.new
local new3 = v9.new
local color3New = Color3.new
local rectNew = Rect.new
local uDim2New = UDim2.new
local uDimNew = UDim.new
local new4 = Path2DControlPoint.new
local tbl5 = {}
local str = "lastlinedefined"
local fn62 = fn6
local fn82 = fn8
tbl5[str] = -1
tbl5.linedefined = -1
tbl5.nparams = 0
tbl5.short_src = "[C]"
tbl5.isvararg = true
tbl5.currentline = -1
tbl5.what = "C"
tbl5.namewhat = ""
tbl5.source = "=[C]"

local function fn9()
end

fn9(getmetatable, "getmetatable")
fn9(setmetatable, "setmetatable")
fn9(tonumber, "tonumber")
fn9(tostring, "tostring")
fn9(rawset, "rawset")
fn9(rawget, "rawget")
fn9(select, "select")
fn9(xpcall, "xpcall")
fn9(assert, "assert")
fn9(error, "error")
fn9(pcall, "pcall")
fn9(type, "type")
fn9(next, "next")
fn9(getfenv, "getfenv")
fn9(setfenv, "setfenv")
fn9(typeof, "typeof")
fn9(string.gmatch, "gmatch")
fn9(string.format, "format")
fn9(string.match, "match")
fn9(string.find, "find")
fn9(string.char, "char")
fn9(string.byte, "byte")
fn9(string.gsub, "gsub")
fn9(string.sub, "sub")
fn9(string.rep, "rep")
fn9(string.unpack, "unpack")
fn9(string.pack, "pack")
fn9(table.concat, "concat")
fn9(table.insert, "insert")
fn9(table.pack, "pack")
fn9(table.clear, "clear")
fn9(table.create, "create")
fn9(table.move, "move")
fn9(bit32.bor, "bor")
fn9(bit32.bnot, "bnot")
fn9(bit32.bxor, "bxor")
fn9(bit32.band, "band")
fn9(bit32.lshift, "lshift")
fn9(bit32.rshift, "rshift")
fn9(bit32.rrotate, "rrotate")
fn9(bit32.lrotate, "lrotate")
fn9(bit32.countlz, "countlz")
fn9(bit32.countrz, "countrz")
fn9(buffer.len, "len")
fn9(buffer.fill, "fill")
fn9(buffer.copy, "copy")
fn9(buffer.create, "create")
fn9(buffer.tostring, "tostring")
fn9(buffer.fromstring, "fromstring")
fn9(buffer.readstring, "readstring")
fn9(buffer.writestring, "writestring")
fn9(buffer.readi8, "readi8")
fn9(buffer.readu8, "readu8")
fn9(buffer.readi16, "readi16")
fn9(buffer.readu16, "readu16")
local n4 = 0
fn9(buffer.readi32, "readi32")
fn9(buffer.readu32, "readu32")
fn9(buffer.readf32, "readf32")
fn9(buffer.readf64, "readf64")
fn9(buffer.writei8, "writei8")
fn9(buffer.writeu8, "writeu8")
fn9(buffer.writei16, "writei16")
fn9(buffer.writeu16, "writeu16")
fn9(buffer.writei32, "writei32")
fn9(buffer.writeu32, "writeu32")
fn9(buffer.writef32, "writef32")
fn9(buffer.writef64, "writef64")
fn9(buffer.readbits, "readbits")
local n5 = 4143774346
fn9(buffer.writebits, "writebits")
fn9(coroutine.isyieldable, "isyieldable")
fn9(coroutine.running, "running")
fn9(coroutine.create, "create")
fn9(coroutine.status, "status")
fn9(coroutine.yield, "yield")
fn9(coroutine.close, "close")
fn9(coroutine.resume, "resume")
fn9(coroutine.wrap, "wrap")
fn9(cancel, "cancel")
fn9(spawn, "spawn")
fn9(defer, "defer")
fn9(delay, "delay")
fn9(wait, "wait")
fn9(unpack, "unpack")
fn9(info, "info")
fn9(traceback, "traceback")
fn9(v13)
local v15 = pcall
local v16 = xpcall
local n6 = 260821805
local n7 = 205896066
new3(0.7517365712237748, 0.59805309283839669, 0.55702010294356563)
new("Folder")
local ScreenGui = new("ScreenGui")
local Frame = new("Frame")
local Path2D = new("Path2D")
Frame.Parent = ScreenGui
Path2D.Parent = Frame
vector.create(0.3059279971254053, 0.42956609292458714, 0.37629488499073949)

local function fn10()
	assert(0.45115462618858726)
	getfenv(0)
	tostring(0.058354116442588144)
	rawequal(scratch, scratch)
	local tbl6 = {}
	next(tbl6)
	pairs(tbl6)(tbl6)
	ipairs(tbl6)(tbl6, 1)
	rawlen(tbl6)
	rawget(tbl6, 0.56008514205482085)
	rawset(tbl6, 0.11299694538901328, 0.4316797901618018)
	getmetatable(tbl6)
	setmetatable(tbl6, tbl6)
	setmetatable(tbl6, nil)
	info(15846, "slnaf")
	local buf = buffer.create(70)
	buffer.len(buf)
	buffer.fromstring("")
	buffer.tostring(buf)
	buffer.readi8(buf, 9)
	buffer.readu8(buf, 17)
	buffer.readi16(buf, 22)
	buffer.readu16(buf, 3)
	buffer.readi32(buf, 7)
	buffer.readu32(buf, 22)
	buffer.readf32(buf, 10)
	buffer.readf64(buf, 8)
	buffer.writei8(buf, 17, -123)
	buffer.writeu8(buf, 6, 88)
	buffer.writei16(buf, 22, -20305)
	buffer.writeu16(buf, 7, 6232)
	buffer.writei32(buf, 2, -1782026297)
	buffer.writeu32(buf, 7, 1891269988)
	buffer.writef32(buf, 2, 2380)
	buffer.writef64(buf, 15, 4695)
	buffer.readstring(buf, 21, 13)
	buffer.writestring(buf, 15, "Luraph", 2)
	buffer.readbits(buf, 233, 21)
	buffer.writebits(buf, 135, 8, 670279733)
	buffer.copy(buf, 32, buf, 0, 16)
	buffer.fill(buf, 1, 99, 5)
	local v17 = v11.new()
	v17:NextInteger(38, 373)
	v17:NextNumber(29, 286)
	v17:NextUnitVector()
	v17:NextNumber()
	v17:Shuffle({})
	v17:Clone()
	local n8 = Vector3.new(0.76930344, 0.3435795, 0.065249935) + Vector3.new(0.80995685, 0.47355163, 0.00061973213)
	local vector_ = Vector3.new(0.76930344, 0.3435795, 0.065249935)
	local vector_2 = Vector3.new(0.80995685, 0.47355163, 0.00061973213)
	local vector_3 = Vector3.new(1, 0, 0)
	local vector_4 = Vector3.new(0, 1, 0)
	local v18 = v10.new()
	local vector_5 = v10.new(vector_)
	v10.Angles(0.49980179326977336, 0.01577664895715547, 0.096608342611930076)
	local xyz = Enum.RotationOrder.XYZ
	v10.new(vector_, n8)
	v10.new(vector_.X, vector_.Y, vector_.Z)
	v10.new(vector_.X, vector_.Y, vector_.Z, 0, 0, 0, 1)
	v10.new(vector_.X, vector_.Y, vector_.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	v10.lookAt(vector_, n8, vector_4)
	v10.lookAlong(vector_, vector_2, vector_4)
	v10.fromEulerAnglesXYZ(0.49980179326977336, 0.01577664895715547, 0.096608342611930076)
	v10.fromEulerAnglesYXZ(0.49980179326977336, 0.01577664895715547, 0.096608342611930076)
	v10.fromOrientation(0.49980179326977336, 0.01577664895715547, 0.096608342611930076)
	v10.fromAxisAngle(vector_2.Unit, 0.49980179326977336)
	v10.fromRotationBetweenVectors(vector_3, vector_4)
	v10.fromMatrix(vector_, vector_3, vector_4, Vector3.new(0, 0, 1))
	v10.fromEulerAngles(0.49980179326977336, 0.01577664895715547, 0.096608342611930076, xyz)
	v18:Inverse()
	v18:Orthonormalize()
	v18:Lerp(vector_5, 0.96737976245748847)
	v18:ToWorldSpace(vector_5)
	v18:ToObjectSpace(vector_5)
	v18:ToEulerAnglesXYZ()
	v18:ToEulerAnglesYXZ()
	v18:PointToWorldSpace(vector_)
	v18:PointToObjectSpace(vector_)
	v18:VectorToWorldSpace(vector_2)
	v18:VectorToObjectSpace(vector_2)
	v18:ToEulerAngles(xyz)
	v18:GetComponents()
	v18:ToOrientation()
	v18:ToAxisAngle()
	v18:FuzzyEq(vector_5)
	v18:AngleBetween(vector_5)
	v8.FromAxis(Enum.Axis.X)
	local vector_6 = Vector3.new(0.054354988, 0.121100344, 0.5512487)
	local vector_7 = Vector3.new(0.2554549, 0.87889993, 0.033886522)
	v8.FromNormalId(Enum.NormalId.Top)
	vector_6:Abs()
	vector_6:Ceil()
	vector_6:Floor()
	vector_6:Sign()
	vector_6:Dot(vector_7)
	vector_6:Cross(vector_7)
	vector_6:Angle(vector_7)
	vector_6:FuzzyEq(vector_7)
	vector_6:Lerp(vector_7, 0.66179362191360336)
	vector_6:Max(vector_7)

	vector_6:Min(vector_7)
	;(Vector2.new(0.31562909483909607, 0.40285417437553406)):Abs()
	local vector2 = Vector2.new(0.31562909483909607, 0.40285417437553406)
	local vector22 = Vector2.new(0.72420793771743774, 0.59745031595230103)
	vector2:Ceil()
	vector2:Floor()
	vector2:Sign()
	vector2:Dot(vector22)
	vector2:Cross(vector22)
	vector2:Angle(vector22)
	vector2:FuzzyEq(vector22)
	vector2:Lerp(vector22, 0.82833628585149599)
	vector2:Max(vector22)
	vector2:Min(vector22)
	uDimNew(-0.29534205190148755, -83)
	uDimNew(0.074790411142247493, -56)
	uDim2New(-0.095028970038190774, 78, -0.22443983594424166, 126):Lerp(uDim2New(-0.79236753088467249, 125, -0.48932297403511948, 86), 0.026393579993841731)
	local displayWhenDamaged = Enum.HumanoidHealthDisplayType.AlwaysOn.EnumType.DisplayWhenDamaged
	local enumType = displayWhenDamaged.EnumType
	enumType:GetEnumItems()
	enumType:FromName(displayWhenDamaged.Name)
	enumType:FromValue(displayWhenDamaged.Value)
	local v19 = uDim2New(0.14373576790455606, 49, 0.16917100552728859, 24)
	local v20 = uDim2New(0.018305378403495859, 15, 0.10021926790668145, 9)
	local v21 = uDim2New(0.74435584946779154, 131, 0.67791791043804772, 151)
	local v22 = new4(v19, v20, v20)
	new4(v19:Lerp(v21, 0.50263895976053052))
	local ctx = {}
	local v23 = new4(v21)
	ctx.v22 = v22
	ctx.v23 = v23
	local v24 = utf8.char(98, 1467, 951076)
	utf8.codepoint(v24, 1, #v24)
	utf8.len(v24)
	utf8.offset(v24, 2)
	utf8.offset(v24, -3)
	local v242, v25, v26 = utf8.codes(v24)
	v242(v25, v26)
	v242(v25, utf8.offset(v24, 2))
	local v27 = utf8.char(119, 857)
	utf8.nfcnormalize(v27)
	utf8.nfdnormalize(v24)
	utf8.graphemes(v27, 1, #v27)()
	n6 = (594709 * n6 + 239211861) % 268435456
	n7 = (1 * n7 + 241367256) % 268435456
end

local fn102 = coroutine.wrap(fn10)
local tbl6 = {}
local n8 = 0

local function fn11()
	n8 += 1

	if nil then
		setmetatable({}, { __index = fn4 })
		local v17 = luraph_runtime6(nil, nil, table.pack(v2, v7, fn2, n2, fn3))
		v15(v17)
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
		return
	end

	if nil then
		fn102()
	end

	n6 = (352631 * n6 + 392029) % 268435456
	n7 = (1 * n7 + 32945034) % 268435456
end

setmetatable(tbl6, { __index = fn11, __newindex = fn11 })
local ok, result = pcall(fn11)
local v17 = result
local n9 = bit32.bor(4143774346, n4)

if tbl3[not ok] then
	fn(514828236, 45)
else
	fn2(63640569, 4)
	n2 = 463964030
	fn3()
end

if tbl3[not v17] then
	fn2(63640569, 4)
	n2 = 463964030

	while true do
	end
else
	fn(n9 - 3628946110, 41)
	local v18 = luraph_runtime1(nil, nil, table.pack(n6, n7))
	local flag = false
	local v19 = luraph_runtime3(nil, nil, table.pack(v15, r220))

	local function fn12()
		n7 = (1 * n7 + 38448576) % 268435456
		n6 = (822767 * n6 + 173578129) % 268435456
	end

	local v20 = luraph_runtime4(nil, nil, table.pack(n7, n6))

	local function fn13()
		n7 = n7 - n7 % 2 + 1
		n6 = (774041 * n6 + 172871121) % 268435456
		n6 = (181785 * n6 + 110103309) % 268435456
	end

	local n10 = 0

	v32 = function()
		n10 += 1

		if n10 ~= 2499 then
			if n10 == 2498 then
				fn12()
			end

			n7 = (1 * n7 + 259853764) % 268435456
			n6 = (763815 * n6 + 134361023) % 268435456
			v32()
			return
		end

		v18()
		n7 = (1 * n7 + 263118560) % 268435456
		n6 = (652559 * n6 + 245126261) % 268435456
	end

	v42 = function(arg)
		if arg ~= 19998 then
			if arg ~= 19997 then
				if arg == 8701 then
					fn10(arg)
				end
			else
				fn10(arg)
			end

			v42(arg + 1)

			if arg == 19997 then
				if not v16(v18, v20) then
					n7 = n7 - n7 % 2 + 1
					n6 = (808979 * n6 + 91943509) % 268435456
					return
				end

				fn12()

				if not v15(v18) then
					n7 = n7 - n7 % 2 + 1
					n6 = (2031 * n6 + 101733111) % 268435456
					n6 = (193159 * n6 + 179560121) % 268435456
					return
				end

				if v16(fn13, v32) then
					n7 = n7 - n7 % 2 + 1
					n6 = (441323 * n6 + 84286363) % 268435456
					n6 = (520491 * n6 + 184696795) % 268435456
					return
				end

				v19()

				if flag then
					n7 = n7 - n7 % 2 + 1
					n6 = (26303 * n6 + 80476001) % 268435456
					n6 = (713607 * n6 + 225478109) % 268435456
					return
				end

				n6 = (881963 * n6 + 181217197) % 268435456
				n7 = (1 * n7 + 69705998) % 268435456
			end

			n6 = (692111 * n6 + 139989323) % 268435456
			n7 = (1 * n7 + 15433764) % 268435456
			return
		end

		v18()
		n7 = (1 * n7 + 268172592) % 268435456
		n6 = (516691 * n6 + 113833011) % 268435456
	end

	coroutine.resume(coroutine.create(v42), 1)
	ScreenGui:Destroy()
	fn2(n6, 4)
	fn2(n7, 4)
	local n22 = n2
	local n11 = 166822200
	local n12 = 2022437053
	local n13 = 206586079

	local function fn14()
		local yield = coroutine.yield

		if nil then
			n13 = bit32.bxor(n13, 2441626945)
		end

		yield(n11)
		coroutine.yield(n12)
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end

	n13 = 513312934
	local fn142 = coroutine.wrap(fn14)

	if fn5(fn142(), n11) then
		fn(n5 + 666021186, 154)
		n2 = n22
	else
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end

	if fn5(fn142(), n12) then
		fn(514828236, 119)
	else
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end

	local thread = coroutine.create(wait)
	coroutine.resume(thread, 0)
	local thread2 = coroutine.status(thread)
	fn5("suspended", thread2)

	if not nil then
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end

	pcall(coroutine.close, thread)
	local v21 = nil
	local flag2 = false

	spawn(function()
		v21 = coroutine.running()
		wait(0)
		flag2 = true
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end)

	local v22 = pcall
	local n14 = 157080125
	local flag3 = not v22(coroutine.close, v21)

	if not nil then
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
		n9 = n9 - n14 - 4137887171
	end

	local close = coroutine.close

	local v23 = spawn(function()
		coroutine.yield()
		fn2(63640569, 4)
		n2 = 463964030
		fn3()
	end)

	close(v23)
	local close2 = coroutine.close
	local v24 = defer(fn4)
	close2(v24)
	local close3 = coroutine.close
	local v25 = delay(124, fn4)
	close3(v25)

	local function fn15()
	end

	fn15(getfenv, -24167)
	fn15(setfenv, -5649)
	fn15(getmetatable)
	fn15(setmetatable)
	fn15(tonumber)
	fn15(tostring)
	fn15(rawset)
	fn15(rawget)
	fn15(assert)
	fn15(type)
	fn15(next)
	fn15(typeof)
	fn15(string.gmatch)
	fn15(string.format)
	fn15(string.match)
	fn15(string.find)
	fn15(string.byte)
	fn15(string.gsub)
	fn15(string.sub)
	fn15(string.rep)
	fn15(string.char, nil)
	local n52 = table.pack(bit32.band(n5, 4294967295))
	local n142 = table.pack(bit32.band(n14, 4294967295))
	local v26 = table.pack(bit32.band(n52[1], 65535))
	local v27 = table.pack(bit32.rshift(n52[1], 16))
	local v28 = table.pack(bit32.band(n142[1], 65535))
	local v29 = bit32.band(v26[1] * v28[1] + bit32.lshift(bit32.band(v26[1] * bit32.rshift(n142[1], 16) + v27[1] * v28[1], 65535), 16), 4294967295)
	fn15(string.unpack)
	fn15(string.pack)
	fn15(table.concat)
	fn15(table.insert)
	fn15(table.clear)
	fn15(table.create, nil)
	local v292 = table.pack(bit32.band(v29, 4294967295))
	local n143 = table.pack(bit32.band(n14, 4294967295))
	local v30 = table.pack(bit32.band(v292[1], 65535))
	local v31 = table.pack(bit32.rshift(v292[1], 16))
	local v33 = table.pack(bit32.band(n143[1], 65535))
	local v34 = bit32.band(v30[1] * v33[1] + bit32.lshift(bit32.band(v30[1] * bit32.rshift(n143[1], 16) + v31[1] * v33[1], 65535), 16), 4294967295)
	fn15(table.move)
	fn15(bit32.bor, nil)
	fn15(bit32.bxor, nil)
	fn15(bit32.band, nil)
	fn15(bit32.bnot)
	fn15(bit32.lshift)
	fn15(bit32.rshift)
	fn15(bit32.rrotate)
	fn15(bit32.lrotate)
	fn15(bit32.countlz)
	fn15(bit32.countrz)
	fn15(buffer.len)
	fn15(buffer.fill)
	fn15(buffer.copy)
	fn15(buffer.create, nil)
	fn15(buffer.tostring)
	fn15(buffer.fromstring)
	fn15(buffer.readstring)
	fn15(buffer.writestring)
	fn15(buffer.readi8)
	fn15(buffer.readu8)
	fn15(buffer.readi16)
	fn15(buffer.readu16)
	fn15(buffer.readi32)
	fn15(buffer.readu32)
	fn15(buffer.readf32)
	fn15(buffer.readf64)
	fn15(buffer.writei8)
	fn15(buffer.writeu8)
	fn15(buffer.writei16)
	fn15(buffer.writeu16)
	fn15(buffer.writei32)
	fn15(buffer.writeu32)
	fn15(buffer.writef32)
	fn15(buffer.writef64)
	fn15(buffer.readbits)
	fn15(buffer.writebits)
	fn15(coroutine.create)
	fn15(coroutine.status)
	fn15(coroutine.close)
	fn15(coroutine.resume)
	fn15(coroutine.wrap)
	fn15(cancel)
	fn15(spawn)
	fn15(defer)
	fn15(delay)
	fn15(wait, {})
	fn15(unpack)
	fn15(info)
	fn15(v13)
	fn9(new, "new")
	fn15(new, nil)
	fn9(new2, "new")
	local n92 = bit32.bor(n9, v34)
	fn9(new3, "new")
	fn9(color3New, "new")
	fn9(rectNew, "new")
	local fromAxis = v8.FromAxis
	fn9(fromAxis, "FromAxis")
	fn15(fromAxis, nil)
	local vector_ = fromAxis(Enum.Axis.Y)
	local top = v8.FromNormalId(Enum.NormalId.Top)
	local n93 = n92
	local kind = type(vector_)
	local kind2 = type(top)

	if kind == "vector" then
		fn(514828236, 197)
		fn(514828236, kind2 == "vector" and 93 or 37)
		local y = top.Y
		fn2(vector_.Y * 488903522, 4)
		fn2(y * 1 * 3540436332, 4)

		if fn5("vector", kind) then
			fn(514828236, 233)
			n2 = n22
		else
			fn2(63640569, 4)
			n2 = 463964030
			fn3()
		end

		if fn5("vector", kind2) then
			fn(n92 + 665888754, 177)
		else
			fn2(63640569, 4)
			n2 = 463964030
			fn3()
		end

		fn(n93 - 3629078542, vector_.X == 0 and 94 or 154)
		fn(514828236, vector_.Y == 1 and 30 or 235)
		local flag4 = vector_.Z == 0 and 7

		if not flag4 then
			n92 = 4143906778
			flag4 = 149
		end

		fn(514828236, flag4)
		fn(n93 + 665888754, top.X == 0 and 113 or 142)
		fn(514828236, top.Y == 1 and 8 or 19)
		fn(514828236, top.Z == 0 and 24 or 73)
		fn9(uDim2New, "new")
		fn9(uDimNew, "new")
		fn82(273842640, utf8, { [754464684] = 700290637, [3013733784] = 1733351851, [3656796767] = 731115201 })
		local tbl7 = {}
		local v35 = utf8.nfcnormalize("뇧세쿡퉒뤭앇랹쯮쾯")

		do
			local values = table.pack(v35:byte(1, -1))
			table.move(values, 1, values.n, 1, tbl7)
		end

		local tbl8 = {}
		local v36 = utf8.nfdnormalize("큟붱둍뺟펧꾒")

		do
			local values = table.pack(v36:byte(1, -1))
			table.move(values, 1, values.n, 1, tbl8)
		end

		local v37 = tbl8[14]
		fn(514828236, v37)
		fn(514828236, tbl7[24])
		fn(n92 - 3629078542, tbl7[1])
		local v38 = tbl8[45]
		local v372 = v37
		fn(514828236, v38)
		fn(514828236, tbl8[35])
		local v39 = tbl8[25]
		fn(v372 + 514828103, v39)
		local v40 = tbl7[18]
		local v382 = v38
		fn(n93 + 665888754, v40)
		fn(514828236, tbl7[8])
		fn(v372 + 514828103, tbl7[27])
		fn(514828236, tbl8[16])
		fn(514828236, tbl8[53])
		fn(v372 - 3780139193, tbl7[10])
		fn(514828236, tbl8[4])
		fn(514828236, tbl7[5])
		fn(v372 + 514828103, tbl8[44])
		fn(514828236, tbl7[23])
		fn(514828236, tbl8[23])
		fn(v372 + 514828103, tbl7[16])
		fn(n93 - 3629078542, tbl7[25])
		fn(514828236, tbl7[3])
		fn(v372 - 3780139193, tbl8[36])
		fn(n93 - 3629078542, tbl8[11])
		fn(514828236, tbl7[2])
		fn(514828236, tbl7[15])
		fn(4809795532, tbl8[54])
		fn(514828236, tbl8[17])
		fn(514828236, tbl8[7])
		fn(4809795532, tbl8[9])
		fn(514828236, tbl7[6])
		fn(v372 - 3780139193, tbl7[26])
		fn(4809795532, tbl8[34])
		local v3822 = table.pack(bit32.band(v382, 4294967295))
		local v41 = table.pack(bit32.band(v3822[1], 65535))
		local v43 = bit32.band(65396 * v41[1] + bit32.lshift(bit32.band(65396 * bit32.rshift(v3822[1], 16) + 63230 * v41[1], 65535), 16), 4294967295)
		fn(514828236, tbl8[41])
		fn(v372 - 3780139193, tbl8[49])
		fn(v43 - 2056909996, tbl8[1])
		fn(514828236, tbl8[27])
		fn(514828236, tbl7[22])
		fn(v43 + 2238057300, tbl8[30])
		fn(514828236, tbl8[3])
		fn(v372 - 3780139193, tbl8[37])
		fn(v43 + 2238057300, tbl7[14])
		fn(514828236, tbl8[2])
		fn(514828236, tbl8[47])
		fn(v43 - 2056909996, tbl8[42])
		fn(514828236, tbl8[18])
		fn(514828236, tbl7[11])
		fn(v43 - 2056909996, tbl8[38])
		fn(514828236, tbl8[51])
		fn(514828236, tbl7[19])
		fn(v43 - 2056909996, tbl7[12])
		fn(514828236, tbl8[28])
		fn(514828236, tbl8[33])
		fn(v43 - 2056909996, tbl8[43])
		fn(514828236, tbl8[5])
		fn(514828236, tbl8[8])
		fn(v43 - 2056909996, tbl7[13])
		fn(514828236, tbl8[15])
		fn(514828236, tbl8[26])
		fn(v43 + 2238057300, tbl7[20])
		fn(514828236, tbl7[21])
		fn(514828236, tbl8[21])
		fn(514828236, tbl7[9])
		fn(514828236, tbl8[50])
		fn(514828236, tbl8[31])
		fn(v43 - 2056909996, tbl8[12])
		local v44 = bit32.bor(3, v39)
		fn(514828236, tbl8[52])
		fn(v44 - 3780139287, tbl8[24])
		local v45 = tbl8[39]
		fn(v43 + 2238057300, v45)
		fn(514828236, tbl8[40])
		fn(v44 - 3780139287, tbl8[46])
		fn(514828236, tbl8[6])
		fn(514828236, tbl8[10])
		fn(514828236, tbl8[32])
		fn(514828236, tbl8[22])
		fn(514828236, tbl7[7])
		fn(514828236, tbl8[20])
		fn(514828236, tbl8[48])
		fn(514828236, tbl7[17])
		fn(514828236, tbl8[29])
		fn(514828236, tbl8[13])
		fn(514828236, tbl8[19])
		fn(514828236, tbl7[4])
		fn9(new4, "new")
		fn15(new4, nil)
		local ScreenGui2 = new("ScreenGui")
		local Frame2 = new("Frame")
		Frame2.Position = uDim2New(0, 0, 0, 0)
		Frame2.Size = uDim2New(0, 201, 0, 297)
		Frame2.Parent = ScreenGui2
		local Path2D2 = new("Path2D")
		Path2D2.Parent = Frame2
		local Path2D3 = Path2D2
		local setControlPoints = Path2D3.SetControlPoints
		local tbl9 = {}
		local v46 = new4(uDim2New(0, -1, 0.5, -1), uDim2New(0.125, -3, -0.125, -1), uDim2New(0, -4, 0, 2))
		local v47 = new4(uDim2New(0, 4, 0.3125, -7), uDim2New(0, 4, 0, -2), uDim2New(0.0625, 7, 0.125, -8))
		local v48 = new4(uDim2New(0, -8, 0.375, -8), uDim2New(-0.125, -5, -0.125, -8), uDim2New(0, 2, 0, -6))
		local v49 = new4(uDim2New(0, -10, 0, -2), uDim2New(0, 0, 0, 0), uDim2New(0.125, 0, 0, -7))
		local v50 = uDim2New(0.5, -9, 0, 9)
		local v51 = uDim2New(-0.125, -8, -0.125, -8)
		tbl9[1] = v46
		tbl9[2] = v47
		tbl9[3] = v48
		tbl9[4] = v49

		do
			local values = table.pack(new4(v50, v51, uDim2New(0, 3, 0, 0)))
			table.move(values, 1, values.n, 5, tbl9)
		end

		setControlPoints(Path2D3, tbl9)
		local length = Path2D3:GetLength()
		fn2(string.unpack(">I4", string.pack("<f", length)), 4)
		local positionOnCurve = Path2D3:GetPositionOnCurve(0.5)
		fn2(string.unpack(">I4", string.pack("<f", positionOnCurve.X.Scale)), 4)
		fn2(string.unpack("<I4", string.pack("<f", positionOnCurve.Y.Scale)), 4)
		local positionOnCurve2 = Path2D3:GetPositionOnCurve(0.8571428656578064)
		fn2(string.unpack(">I4", string.pack(">f", positionOnCurve2.X.Scale)), 4)
		fn2(string.unpack("<I4", string.pack("<f", positionOnCurve2.Y.Scale)), 4)
		local tangentOnCurve = Path2D3:GetTangentOnCurve(0.46666666865348816)
		fn2(string.unpack(">I4", string.pack("<f", tangentOnCurve.X)), 4)
		fn2(string.unpack(">I4", string.pack("<f", tangentOnCurve.Y)), 4)
		local tangentOnCurve2 = Path2D3:GetTangentOnCurve(0.78571426868438721)
		fn2(string.unpack("<I4", string.pack("<f", tangentOnCurve2.X)), 4)
		fn2(string.unpack("<I4", string.pack("<f", tangentOnCurve2.Y)), 4)
		local positionOnCurveArcLength = Path2D3:GetPositionOnCurveArcLength(0.75)
		fn2(string.unpack(">I4", string.pack("<f", positionOnCurveArcLength.X.Scale)), 4)
		fn2(string.unpack("<I4", string.pack("<f", positionOnCurveArcLength.Y.Scale)), 4)
		local positionOnCurveArcLength2 = Path2D3:GetPositionOnCurveArcLength(0.25)
		fn2(string.unpack(">I4", string.pack(">f", positionOnCurveArcLength2.X.Scale)), 4)
		fn2(string.unpack("<I4", string.pack(">f", positionOnCurveArcLength2.Y.Scale)), 4)
		local positionOnCurveArcLength3 = Path2D3:GetPositionOnCurveArcLength(0.60000002384185791)
		fn2(string.unpack(">I4", string.pack("<f", positionOnCurveArcLength3.X.Scale)), 4)
		fn2(string.unpack("<I4", string.pack(">f", positionOnCurveArcLength3.Y.Scale)), 4)
		local tangentOnCurveArcLength = Path2D3:GetTangentOnCurveArcLength(0.5)
		fn2(string.unpack("<I4", string.pack(">f", tangentOnCurveArcLength.X)), 4)
		fn2(string.unpack(">I4", string.pack("<f", tangentOnCurveArcLength.Y)), 4)
		local tangentOnCurveArcLength2 = Path2D3:GetTangentOnCurveArcLength(0.30000001192092896)
		fn2(string.unpack("<I4", string.pack("<f", tangentOnCurveArcLength2.X)), 4)
		fn2(string.unpack(">I4", string.pack("<f", tangentOnCurveArcLength2.Y)), 4)
		ScreenGui2:Destroy()
		fn82(273842640, math, { [396031431] = 719541634, [388266345] = 787715759, [2151393499] = 233978537 })

		fn82(273842640, v14, {
			[1359245530] = 368582598,
			[238419033] = 895176910,
			[2754165730] = 764359919,
			[2780529910] = 2070237367,
			[988361861] = 667400208,
		})

		fn82(273842640, v6, { [4276131481] = 103276482, [1336870540] = 1618747533 })
		local gameRef = game
		local workspaceRef = workspace

		local function fn16(arg, arg2)
			local kind3 = type(arg)
			fn5("userdata", kind3)

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local kind4 = typeof(arg)
			fn5("Instance", kind4)

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local parent = arg.Parent
			local parent2 = arg.Parent

			if tbl3[not parent] then
				fn5(parent, parent2)

				if not nil then
					fn2(63640569, 4)
					n2 = 463964030
					fn3()
				end
			end

			local name = arg.Name
			local name2 = arg.Name
			local kind5 = type(name)
			fn5("string", kind5)

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			fn5(name, name2)

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			fn5(#name, #name2)

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			fn5(tostring(arg), name)

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			fn5(arg2, arg.ClassName)

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local childRemoved = arg.ChildRemoved
			fn5(childRemoved, arg.ChildRemoved)

			if nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local connect = childRemoved.Connect
			local connect2 = childRemoved.Connect
			fn9(connect, "Connect")
			fn9(connect2, "Connect")
			fn5(connect, connect2)

			if nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local flag5 = false
			local childAdded = arg.ChildAdded
			local childAdded2 = childAdded
			local connect3 = childAdded.Connect
			local n15 = 12155931

			local function fn17()
				local flag6

				if nil then
					flag6 = true
					n15 = bit32.bxor(n15, 2901837807)
				else
					flag6 = true
				end

				flag5 = flag6
			end

			n15 = 211897066
			local v53 = connect3(childAdded2, fn17)

			if nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			else
			end

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local disconnect = v53.Disconnect
			fn9(disconnect, "Disconnect")
			fn15(disconnect, nil)
			disconnect(v53)

			if nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local wait2 = childRemoved.Wait
			fn9(wait2, "Wait")
			local n16 = 365070289

			local function fn18()
				local wait3 = wait2

				if nil then
					n16 = bit32.bxor(n16, 469729027)
				end

				return (wait3(childRemoved))
			end

			n16 = 92925098
			local thread3 = coroutine.create(fn18)
			local thread4, v54 = coroutine.resume(thread3)
			local v55 = tbl3[not thread4]
			local flag6 = not v55
			local flag62

			if v55 then
				flag62 = tbl3[not v54]
			else
				flag62 = flag6
			end

			if not flag62 then
				local thread5 = coroutine.status(thread3)
				flag62 = not fn5("suspended", thread5)
			end

			if flag62 then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local ok2, result2 = pcall(coroutine.close, thread3)
			local v56 = tbl3[not ok2]
			local flag7 = not v56
			local flag8

			if v56 then
				flag8 = not tbl3[not result2]
			else
				flag8 = flag7
			end

			if not flag8 then
				local thread5 = coroutine.status(thread3)
				flag8 = not fn5("dead", thread5)
			end

			if flag8 then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local v57 = getmetatable(arg)
			fn5("The metatable is locked", v57)

			if not nil then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end
		end

		fn16(gameRef, "DataModel")
		fn16(workspaceRef, "Workspace")

		if fn5(gameRef, workspaceRef.Parent) then
			fn(514828236, 205)
			n2 = n22
		else
			fn2(63640569, 4)
			n2 = 463964030
			fn3()
		end

		local Folder = new("Folder")
		fn16(Folder, "Folder")
		local ok2, result2 = pcall(Folder.IsAncestorOf, Vector3.new(-195.87396, 53.51306, -641.35925), 1874145477)
		local flag5 = not ok2

		if not tbl3[flag5] then
			fn2(fn7(177471587, result2), 4)
		end

		local n23 = n2

		if tbl3[flag5] then
			fn2(63640569, 4)
			n2 = 463964030
			fn3()
		else
			fn(514828236, 157)
			n2 = n23
		end

		local children, v53, v54 = Folder:GetChildren()
		local iter_y_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v55, v310, v410, v56, v62, v72, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v55, v310, v410, v56, v62, v72, v82, v92, v102) end end); co(); return co end)(children, v53, v54)
		local v55 = table.pack(iter_y_1())

		if v55[1] then
			repeat
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
				local v56 = table.pack(iter_y_1())
			until not v56[1]
		end

		Folder:Destroy()
		local n24 = n2
		local Folder2 = Folder
		local Folder3 = new("Folder", Folder2)
		fn16(Folder3, "Folder")
		local n242

		if fn5(Folder2, Folder3.Parent) then
			n242 = n24
			fn(514828236, 215)
			n2 = n242
		else
			n242 = n24
			fn2(63640569, 4)
			n2 = 463964030
			fn3()
		end

		if fn5(Folder3.Parent, Folder3.Parent) then
			fn(514828236, 139)
		else
			fn2(63640569, 4)
			n2 = 463964030
			fn3()
		end

		local waitForChild = Folder2.WaitForChild
		fn9(waitForChild, "WaitForChild")
		fn15(waitForChild, nil)
		local name = tostring(1932680949)
		Folder3.Name = name
		local v56 = waitForChild(Folder2, name)

		if fn5(Folder3, v56) then
			fn(514828236, 44)
		else
			fn2(63640569, 4)
			n2 = 463964030
			fn3()
		end

		Folder2:Destroy()
		Folder3:Destroy()

		if tbl3[not Folder3.Parent] then
			fn2(63640569, 4)
			n2 = 463964030
			fn3()
		else
			fn(514828236, 155)
		end

		if tbl3[not pcall(function()
			Folder3.Parent = Folder2
		end)] then
			fn2(63640569, 4)
			n2 = 463964030
			fn3()
		else
			fn(514828236, 139)
		end

		n2 = n242
		local HttpService = gameRef:GetService("HttpService")
		fn16(HttpService, "HttpService")
		local fn52 = fn5
		local n243 = n2

		if fn52(gameRef, HttpService.Parent) then
			local HttpService2 = HttpService
			fn(514828236, 62)
			n2 = n243

			if not v12 then
				fn9(HttpService2.GetAsync, "GetAsync")
				fn9(HttpService2.PostAsync, "PostAsync")
				fn9(HttpService2.RequestAsync, "RequestAsync")
			end

			local RunService = gameRef:GetService("RunService")
			fn16(RunService, "RunService")

			if fn5(gameRef, RunService.Parent) then
				fn(514828236, 222)
				n2 = n243
			else
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			fn9(RunService.IsStudio, "IsStudio")
			fn9(RunService.IsClient, "IsClient")
			fn9(RunService.IsServer, "IsServer")
			fn15(RunService.IsStudio)
			fn15(RunService.IsClient)
			fn15(RunService.IsServer)
			RunService:IsServer()

			if nil then
				local StarterPlayer = gameRef:GetService("StarterPlayer")
				fn16(StarterPlayer, "StarterPlayer")
				fn5(gameRef, StarterPlayer.Parent)

				if not nil then
					fn2(63640569, 4)
					n2 = 463964030
					fn3()
				end

				local children2, v57, v58 = StarterPlayer:GetChildren()
				iter_y_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v59, v310, v410, v510, v62, v72, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v59, v310, v410, v510, v62, v72, v82, v92, v102) end end); co(); return co end)(children2, v57, v58)
				local v59 = table.pack(iter_y_1())

				if v59[1] then
					repeat
						local v60 = table.pack(iter_y_1())
					until not v60[1]
				end

				if nil then
					fn2(63640569, 4)
					n2 = 463964030
					fn3()
				end
			end

			if tbl3[not pcall(gameRef.GetChildren)] then
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			else
				fn(514828236, 66)
				n2 = n243
			end

			local v57 = Enum
			local fn53 = fn5
			local n2432 = n2
			local n24322

			if fn53(type(v57), "userdata") then
				fn(514828236, 122)
				n2 = n2432
				n24322 = n2432
			else
				n24322 = n2432
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			if fn5(typeof(v57), "Enums") then
				fn(514828236, 35)
			else
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local v58 = getmetatable(v57)

			if fn5("The metatable is locked", v58) then
				fn(514828236, 141)
			else
				fn2(63640569, 4)
				n2 = 463964030
				fn3()
			end

			local none = v57.HumanoidDisplayDistanceType.Viewer.EnumType.None

			if fn5(type(none), "userdata") then
				fn(514828236, 187)

				if fn5(typeof(none), "EnumItem") then
					fn(514828236, 222)
				else
					fn2(63640569, 4)
					n2 = 463964030
					fn3()
				end

				local v59 = getmetatable(none)

				if fn5("The metatable is locked", v59) then
					fn(514828236, 152)
				else
					fn2(63640569, 4)
					n2 = 463964030
					fn3()
				end

				fn9(none.IsA, "IsA")
				fn15(none.IsA)
				local name2 = none.Name
				local value = none.Value

				if fn5(type(name2), "string") then
					fn(514828236, 168)

					if fn5(type(value), "number") then
						fn(514828236, 166)
					else
						fn2(63640569, 4)
						n2 = 463964030
						fn3()
					end

					do
						local enumType = none.EnumType

						if fn5(none, enumType[name2]) then
							fn(514828236, 188)
						else
							fn2(63640569, 4)
							n2 = 463964030
							fn3()
						end

						if fn5(type(enumType), "userdata") then
							fn(514828236, 188)
						else
							fn2(63640569, 4)
							n2 = 463964030
							fn3()
						end

						if fn5(typeof(enumType), "Enum") then
							fn(514828236, 139)
						else
							fn2(63640569, 4)
							n2 = 463964030
							fn3()
						end

						local v60 = getmetatable(enumType)

						if fn5("The metatable is locked", v60) then
							fn(514828236, 176)
						else
							fn2(63640569, 4)
							n2 = 463964030
							fn3()
						end

						fn9(enumType.FromName, "FromName")
						fn9(enumType.FromValue, "FromValue")
						fn15(enumType.FromName)
						fn15(enumType.FromValue)
						local v61 = enumType:FromName(name2)

						if fn5(none, v61) then
							fn(514828236, 99)
						else
							fn2(63640569, 4)
							n2 = 463964030
							fn3()
						end

						local v62 = enumType:FromValue(value)

						if fn5(none, v62) then
							fn(514828236, 229)
						else
							fn2(63640569, 4)
							n2 = 463964030
							fn3()
						end
					end

					do
						local new5 = v11.new
						fn9(new5, "new")
						fn15(new5, {})
						local v60 = new5(251769837)
						local v602

						if fn5(type(v60), "userdata") then
							v602 = v60
							fn(514828236, 252)
							n2 = n24322
						else
							fn2(63640569, 4)
							n2 = 463964030
							fn3()
							v602 = v60
						end

						if fn5(typeof(v602), "Random") then
							do
								local v61, clone

								do
									do
										fn(514828236, 166)
										fn9(v602.NextUnitVector, "NextUnitVector")
										fn9(v602.NextInteger, "NextInteger")
										fn9(v602.NextNumber, "NextNumber")
										fn9(v602.Shuffle, "Shuffle")
										fn9(v602.Clone, "Clone")
										v61 = new5(298846180)
										clone = v61:Clone()

										do
											local unpack_ = string.unpack
											local pack = string.pack
											local randNum = v61:NextNumber()
											fn2(unpack_("<I4", pack("<f", randNum)), 4)
										end
									end

									do
										fn2(v61:NextInteger(146, 1055), 4)
										fn2(clone:NextInteger(427, 1254), 4)
										fn2(clone:NextInteger(708, 1214), 4)

										do
											local unpack_ = string.unpack
											local pack = string.pack
											local randNum = clone:NextNumber()
											fn2(unpack_(">I4", pack(">f", randNum)), 4)
										end
									end

									fn2(clone:NextInteger(500, 1011), 4)

									do
										local unpack_ = string.unpack
										local pack = string.pack
										local randNum = clone:NextNumber()
										fn2(unpack_("<I4", pack(">f", randNum)), 4)
									end
								end

								local clone2

								do
									fn2(clone:NextInteger(844, 1583), 4)

									do
										local clone3 = v61:Clone()
										local unpack_ = string.unpack
										local pack = string.pack
										local randNum = clone:NextNumber()
										fn2(unpack_("<I4", pack(">f", randNum)), 4)
										clone2 = clone3:Clone()
									end
								end

								do
									fn2(v61:NextInteger(685, 1486), 4)
									fn2(v61:NextInteger(736, 935), 4)

									do
										local unpack_ = string.unpack
										local pack = string.pack
										local randNum = clone2:NextNumber()
										fn2(unpack_("<I4", pack(">f", randNum)), 4)
									end
								end

								v61:Clone()

								do
									local unpack_ = string.unpack
									local pack = string.pack
									local randNum = v61:NextNumber()
									fn2(unpack_("<I4", pack(">f", randNum)), 4)
								end
							end

							local v61

							do
								do
									local n15 = 876

									local tbl10 = {
										[1937608253] = 876,
										[3722448177] = 876,
										[2196869677] = 876,
										[1771117083] = 876,
										[3618396519] = 219,
										[3001659247] = 876,
										[3246216791] = 219,
										[812813756] = 219,
										[953901549] = 876,
										[2205211867] = 876,
										[2172967037] = 219,
										[2292792095] = n15,
										[862571761] = n15,
										[3552770509] = n15,
										[822768723] = n15,
										[452852753] = n15,
										[4135141429] = 219,
										[2047834256] = n15,
										[3346866409] = 219,
										[4064115689] = 219,
										[1348606217] = 438,
										[1642457259] = n15,
										[3430759404] = 219,
										[3543588516] = n15,
										[516907505] = 438,
										[746725134] = 219,
										[151842481] = 219,
										[2090752270] = 219,
										[2370174957] = n15,
										[637157367] = n15,
										[2780203426] = 219,
										[3151939390] = n15,
									}

									local env = getfenv()
									local envMap = {}
									local tbl11 = {}
									local n16 = 0
									local tbl12 = { 1, nil, v, 3, 0 }

									while true do
										local v62 = tbl12[1]
										local v63 = tbl12[4]
										local n17 = tbl12[5] + v62
										tbl12[5] = n17

										if n17 <= v63 then
											do
												if nil then
													break
												end

												if nil then
													break
												end
												envMap[env] = true

												do
													local n18 = 0
													iter_y_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v64, v310, v410, v510, v65, v72, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v64, v310, v410, v510, v65, v72, v82, v92, v102) end end); co(); return co end)(env, nil, nil)

													for k in env, nil, nil do
														n18 += 1

														do
															local kind3 = type(k)

															if fn5("string", kind3) and #k < 20 then
																local v64 = fn7(177471587, k)

																if not tbl11[v64] then
																	n16 += tbl10[v64] or 0
																	tbl11[v64] = true
																	if n18 > 50 then
																		break
																	end
																	continue
																end
															end
														end

														if n18 > 50 then
															break
														end
													end
												end
											end

											do
												local n162 = n16
												local v64 = getmetatable(env)
												local flag6 = type(v64) == "table"
												local n1622, value2

												if flag6 then
													n1622 = n162
													value2 = rawget(v64, "__index")
												else
													n1622 = n162
													value2 = flag6
												end

												if value2 then
													do
														local n1623 = n1622
														env = value2
														n16 = n1623
													end

													continue
												end

												n16 = n1622
											end

											env = nil
										else
											break
										end
									end

									v61 = tbl12[3]
									fn(514828236, n16 < n15 and 58 or 210)
								end

								if nil then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								do
									local ok3, result3 = pcall(assert, false)
									local result4 = result3

									if ok3 or not result4 or type(result4) ~= "string" then
										fn2(63640569, 4)
										n2 = 463964030
										fn3()
									end
								end
							end

							local v62, result3, result4

							do
								local ok3

								do
									do
										local ok4, result5 = pcall(function(a, ...)
	(...)[...] = nil
end)

										ok3 = ok4
										v62 = result5
									end
								end

								local ok4

								ok4, result3 = pcall(function(a, ...)
	return (...)[...]
end)

								local ok5

								ok5, result4 = pcall(function(a, ...)
	return (...)()
end)

								if ok3 or ok4 or ok5 then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end
							end

							do
								local function fn17(arg, arg2)
									local n15 = 738742652
									local pos, v63, n16 = string.find(arg, "%:[^%a%A]-([0-9]+)[\r:\n][^%c%C]*")
									local flag6 = not pos
									local flag7

									if pos then
										flag7 = not v63
									else
										flag7 = flag6
									end

									if flag7 then
										fn2(63640569, 4)
										n2 = 463964030
										fn3()
									end

									fn2(pos, 2)
									fn2(v63, 2)
									local match = string.match(arg, "[:][^%w%W]?(%d+)[\n%:\r][^%c%C]*")
									local fn22 = fn2
									local match2

									if n16 then
										match2 = match
									else
										match2 = match
										n16 = 0
									end

									fn22(n16 + 0, 2)
									fn2((match2 or 0) + 0, 2)
									local v64 = string.gmatch(arg, "%:(%d%d*)[^%p%P]-[%:\n\r][^%c%C]-")
									local n17 = v64()
									fn5(v64(), nil)

									if not nil then
										fn2(63640569, 4)
										n2 = 463964030
										fn3()
									end

									local fn23 = fn2
									local fn232

									if n17 then
										fn232 = fn23
									else
										fn232 = fn23
										n17 = 0
									end

									fn232(n17 + 0, 2)
									local str2 = string.sub(arg, pos + 1, v63 - 1)
									local v65 = string.char(string.byte(arg, pos + 1, v63 - 1))
									local v66 = string.byte(arg, pos + 1, pos + 1)
									fn2(str2 + 0, 2)
									fn2(v65 + 0, 2)
									fn(514828236, v66)
									local tbl10 = { v63 - 1 + 0, 1, nil, pos + 1 - 1, nil }
									local n18 = 0
									local tbl102 = tbl10

									while true do
										local v67 = tbl102[2]
										local v68 = tbl102[1]
										local n19 = tbl102[4] + v67
										tbl102[4] = n19

										if n19 <= v68 then
											n18 = n18 * 10 + string.byte(arg, n19, n19) - 48
										else
											break
										end
									end

									fn2(n18, 2)
									local v67 = nil
									local n19 = 0
									local n20 = n15 + 4051788599

									local function fn18(arg3)
										v67 = arg3
										local n192 = n19

										if nil then
											n20 = bit32.bxor(n20, 2060259011)
										end

										n19 = n192 + 1
									end

									n20 = 483193586
									local str3, v68 = string.gsub(arg, "[:]([0-9][0-9]*)[^%d%D]*[\r%:\n]", fn18, 1)
									fn5(n19, 1)

									if nil then
									else
										fn2(63640569, 4)
										n2 = 463964030
										fn3()
									end

									fn5(v68, 1)

									if not nil then
										fn2(63640569, 4)
										n2 = 463964030
										fn3()
									end

									fn2((v67 or 0) + 0, 2)
									fn5(string.sub(arg, 2, 2), arg2)

									if not nil then
										fn2(63640569, 4)
										n2 = 463964030
										fn3()
									end

									local v69 = fn
									local v70 = string.byte(arg, 2, 2)
									v69(514828236, v70)
								end

								fn17("ModuleScript:135: attempt to get length of a thread value", "o")
								fn17("module.lua:195: attempt to get length of a boolean value", "o")
							end

							v52 = function(arg)
								local n15 = 1566489223
								local fn17 = nil
								local match = string.match(arg, "[%:]([%d]%d*)[\r%:\n]")
								local v63 = string.gmatch(arg, "%:(%d%d*)[\r\n:][^%s%S]-")()
								local pos, v64 = string.find(arg, "[:][^%p%P]*([0-9]+)[^%c%C]?[:\n\r]")
								local flag6 = not pos
								local flag7

								if pos then
									flag7 = not v64
								else
									flag7 = flag6
								end

								if flag7 then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								local str2 = string.sub(arg, pos + 1, v64 - 1)
								local v65 = string.char(string.byte(arg, pos + 1, v64 - 1))
								local v66 = nil
								local n16 = 0
								local str22 = str2
								local n17 = 66451406

								fn17 = function(arg2)
									fn5(info(1, "f"), fn17)

									if not nil then
										fn2(63640569, 4)
										n2 = 463964030
										fn3()
									end

									local gsub = string.gsub

									if fn5(info(2, "f"), gsub) then
										local v67 = info(3, "f")
										local v522 = v52
										local fn54 = fn5

										if nil then
											n17 = bit32.bxor(n17, 2591766565)
										end

										fn54(v67, v522)

										if not nil then
											fn2(63640569, 4)
											n2 = 463964030
											fn3()
										end

										v66 = arg2
										n16 += 1
										return
									end

									fn2(63640569, 4)
									return nil, 16
								end

								n17 = 199622052
								local str3, v67 = string.gsub(arg, ":[^%p%P]*([%d]+)[\n\r:]", fn17, 1)
								local n18 = 1073020736
								fn5(n16, 1)

								if nil then
								else
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								fn5(v67, 1)

								if not nil then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								local flag8 = not match
								local flag9

								if match then
									flag9 = not v63
								else
									flag9 = flag8
								end

								if flag9 or not str22 or not v65 or not v66 then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								local n19 = match + 0
								local n20 = v63 + 0
								local n21 = str22 + 0
								local n25 = v65 + 0
								local n26 = v66 + 0
								fn5(match, v63)
								local n202

								if nil then
									n202 = n20
								else
									n202 = n20
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								fn5(v63, str22)

								if not nil then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								fn5(str22, v65)

								if not nil then
									local fn22 = fn2
									local n152 = table.pack(bit32.band(n15, 4294967295))
									local n182 = table.pack(bit32.band(n18, 4294967295))
									local v68 = table.pack(bit32.band(n152[1], 65535))
									local v69 = table.pack(bit32.rshift(n152[1], 16))
									local v70 = table.pack(bit32.band(n182[1], 65535))
									local v71 = bit32.band(v68[1] * v70[1] + bit32.lshift(bit32.band(v68[1] * bit32.rshift(n182[1], 16) + v69[1] * v70[1], 65535), 16), 4294967295)
									fn22(63640569, 4)
									n2 = 463964030
									fn3()
									n15 = v71 + 2822217671
								end

								fn5(v65, v66)

								if not nil then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								fn5(n19, n202)

								if not nil then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								fn5(n202, n21)

								if not nil then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								fn5(n21, n25)

								if not nil then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								fn5(n25, n26)

								if not nil then
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								return n19
							end

							do
								local v63 = v52(v62)
								local v64 = v52(result3)
								local v65 = v52(result4)

								if fn5(v63, v64) then
									fn(514828236, 83)
									n2 = n24322
								else
									fn2(63640569, 4)
									n2 = 463964030
									fn3()
								end

								if fn5(v64, v65) then
									local n15

									do
										do
											do
												fn(514828236, 56)

												if fn5(v65, v63) then
													fn(514828236, 215)
												else
													fn2(63640569, 4)
													n2 = 463964030
													fn3()
												end

												do
													local tbl10 = {}
													iter_y_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v66, v310, v410, v510, v67, v72, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v66, v310, v410, v510, v67, v72, v82, v92, v102) end end); co(); return co end)(tbl10, nil, nil)

													for _, v66 in tbl10, nil, nil do
														do
															local exitTo2 = nil

															while true do
																local kind3 = type(v66)

																if fn5("function", kind3) then
																	info(v66, "sl")
																	local v67 = table.pack(iter_y_1())
																	if v67[1] then
																		v66 = v67[3]
																		continue
																	end
																	exitTo2 = 1
																	break
																else
																	break
																end
															end

															if exitTo2 == 1 then
																break
															end
														end
													end
												end
											end

											fn62(nil --[[ the caller's registers ]], 10679534)
											setmetatable(nil --[[ the caller's registers ]], nil)

											do
												local tbl10 = {}
												local tbl11 = {}
												local n16 = 193
												local n17 = 101
												local tbl12 = { -1, nil, 1, 255, v61 }

												while true do
													local v66 = tbl12[3]
													local v67 = tbl12[4]
													local n18 = tbl12[1] + v66
													tbl12[1] = n18

													if n18 <= v67 then
														local n182 = n18
														local n19 = (n16 * n182 + n17) % 256
														local n20 = (n16 * n19 + n17) % 256
														local n21 = (n16 * n20 + n17) % 256
														local n25 = (n16 * n21 + n17) % 256
														tbl10[n182] = n19 + n20 * 256 + n21 * 65536 + n25 * 16777216
														tbl11[n182] = n25
													else
														break
													end
												end
											end
										end

										buffer.create(16)
										n15 = 13

										do
											local n16 = 6
											local n17 = 7
											local n18 = 8
											tbl[n16] = 6
											tbl[n17] = 10
											tbl[n18] = 14
										end
									end

									do
										do
											local n16 = 13
											local n17 = 14
											local n18 = 15
											local n19 = 16
											tbl[n16] = 4
											tbl[n17] = 8
											tbl[n18] = 12
											tbl[n19] = 16
										end
									end

									do
										local n16 = 21
										local n17 = 22
										local n18 = 23
										local n19 = 24
										local n20 = 2
										local n21 = 7
										local n25 = 12

										while true do
											do
												local n26 = 13
												tbl[n16] = n20
												tbl[n17] = n21
												tbl[n18] = n25
												tbl[n19] = n26

												if v45 ~= 145 then
												end

												tbl4 = n26 - n15
											end

											n17 = 30
											n18 = 31
											n19 = 32
											n20 = 4
											n21 = 5
											n25 = 10
										end
									end
								else
									fn2(63640569, 4)
									n2 = 463964030
									fn3()

									while true do
									end
								end
							end
						else
							while true do
							end
						end
					end
				else
					fn2(63640569, 4)
					n2 = 463964030
					fn3()

					while true do
					end
				end
			else
				while true do
				end
			end
		else
			fn2(63640569, 4)

			while true do
			end
		end
	else
		while true do
		end
	end
end
