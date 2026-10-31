-- Luarmor v4: Luarmor-served payload (Luraph v15)
-- loader id : 130307ddb90b87125e0a381843ee1563
-- The licence check itself is not bypassed: only the code in this file was lifted.
-- The offline run stopped early (script error: Script:1: invalid argument #1 to 'band' (number expected, got userdata)), so code that
-- never ran in this sandbox is lifted from its protos alone; the trace is partial.
-- 5 Luraph VM runtime function(s) (LPH_ENCFUNC) are named but not lifted: they live in the VM object.

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

local r__R3 = {}
local data = nil
local value = nil
local value2 = nil
local callback = nil
local callback2 = value
local value3 = value2
local value4 = task
local cancel = value4.cancel
local spawn = value4.spawn
local defer = value4.defer
local delay = value4.delay
local wait = value4.wait
local value5 = Instance
local value6 = Vector3
local value7 = Vector2
local value8 = CFrame
local value9 = Random
local number = identifyexecutor
local value10 = loadstring
local data2 = { 218, 28, 16, 96, 36, 87, 244, 124, 145, 187, 228, 126 }
local data3 = {}
local number2 = 0

local function callback3(argument)
	number2 += 1
	data3[number2] = argument % 256
end

local number3 = 343609641

local function callback4(argument, argument2)
	local number4, number5

	if nil then
		number4 = 1
		number5 = 1
		number3 = bit32.bxor(number3, 3784272397)
	else
		number4 = 1
		number5 = 1
	end

	local number6 = number5 + 0
	local data4 = { number4 - number6, nil, argument2 + 0, number6, nil }

	while true do
		local value11 = data4[4]
		local value12 = data4[3]
		local number7 = data4[1] + value11
		data4[1] = number7

		if number7 <= value12 then
			local number8 = argument % 256
			argument = (argument - number8) / 256
			number2 += 1
			data3[number2] = number8
		else
			break
		end
	end
end

local value11 = assert(debug, "The debug library is required on Luau platforms. Please open a support ticket.")
local info = value11.info
local traceback = value11.traceback
local number4 = 77215353
number3 = 319702956

local function callback5()
	local function callback6(argument, argument2, argument3, argument4, argument5)
		local data4 = { argument2, argument3, argument4, argument5 }
		local number5 = 54517094
		local data5 = { 1, 4, nil, 0, nil }
		local value12, number6, number7, number8, number9, value13, value14, value15, value16, value17, value18, value19

		while true do
			local value20 = data5[1]
			local value21 = data5[2]
			local number10 = data5[4] + value20
			local condition = value20 <= 0
			local condition2 = not condition
			local condition3 = number10 >= value21
			local condition4 = number10 <= value21
			local value22, data6, value23, value24, number11, number12, number13, number14, number15, value25, number16, number17, number18, number19, value26, number20, number21, value27, number22, number23, number24, number25, number26, value28, number27, value29, number28, number29, number30, number31, number32, number33, number34, number35, value30, value31, number36, number37, value32, value33, number38, number39, number40, number41, value34, number42, value35

			if condition then
				if condition2 then
					if condition3 then
						data5[4] = number10

						if condition3 then
							value22 = data4[number10]
							data6 = { 0, #value22 + 0, nil, data5, 1 }

							while true do
								value23 = data6[5]
								value24 = data6[2]
								number11 = data6[1] + value23
								data6[1] = number11

								if number11 <= value24 then
									number12 = number11
									number13 = bit32.lshift(bit32.band(number5, number12), 1)
									number14 = bit32.band(number13, number5)
									number15 = bit32.bnot(number14)
									local number43 = bit32.band(number13, 4294967295)
									local number44 = bit32.band(number15, 4294967295)
									local number45 = bit32.band(number43, 65535)
									local number46 = bit32.rshift(number43, 16)
									local number47 = bit32.band(number44, 65535)
									local value36 = bit32.band(number45 * number47 + bit32.lshift(bit32.band(number45 * bit32.rshift(number44, 16) + number46 * number47, 65535), 16), 4294967295)
									local value37 = bit32.band(value36, 65535)
									value25 = bit32.band(19474 * value37 + bit32.lshift(bit32.band(19474 * bit32.rshift(value36, 16) + 39469 * value37, 65535), 16), 4294967295)
									local number48 = bit32.band(number13, 4294967295)
									local number49 = bit32.band(number48, 65535)
									number16 = number12 + number5 + value25 + bit32.band(23587 * number49 + bit32.lshift(bit32.band(23587 * bit32.rshift(number48, 16) + 21404 * number49, 65535), 16), 4294967295)
									number17 = bit32.bnot(number5)
									number18 = bit32.bor(number17, 54517094)
									local number50 = bit32.band(number13, 4294967295)
									local number51 = bit32.band(number18, 4294967295)
									local number52 = bit32.band(number50, 65535)
									local number53 = bit32.rshift(number50, 16)
									local number54 = bit32.band(number51, 65535)
									local value38 = bit32.band(number52 * number54 + bit32.lshift(bit32.band(number52 * bit32.rshift(number51, 16) + number53 * number54, 65535), 16), 4294967295)
									local value39 = bit32.band(value38, 65535)
									number19 = 1402756132 + bit32.band(46062 * value39 + bit32.lshift(bit32.band(46062 * bit32.rshift(value38, 16) + 26066 * value39, 65535), 16), 4294967295)
									local number55 = bit32.bnot(number13)
									local number56 = bit32.band(number55, 65535)
									value26 = bit32.band(23586 * number56 + bit32.lshift(bit32.band(23586 * bit32.rshift(number55, 16) + 21404 * number56, 65535), 16), 4294967295)
									local value40 = bit32.bor(54517095, number17)
									local value41 = bit32.band(value40, 65535)
									number20 = number16 + number19 + value26 + bit32.band(2 * value41 + bit32.lshift(bit32.band(2 * bit32.rshift(value40, 16) + 0 * value41, 65535), 16), 4294967295)
									local number57 = bit32.band(number20, 4294967295)
									local number58 = bit32.band(number57, 65535)
									number21 = 327058238 + 3859571462 + bit32.band(25350 * number58 + bit32.lshift(bit32.band(25350 * bit32.rshift(number57, 16) + 58892 * number58, 65535), 16), 4294967295)
									value27 = bit32.bor(2147483647, number20)
									local value42 = bit32.band(272719449, value27)
									local value43 = bit32.band(value42, 65535)
									number22 = number21 + 375472684 + bit32.band(14836 * value43 + bit32.lshift(bit32.band(14836 * bit32.rshift(value42, 16) + 13287 * value43, 65535), 16), 4294967295) + 1761712016
									number23 = bit32.bnot(number20)
									local value44 = bit32.bor(2092966552, number23)
									local value45 = bit32.band(value44, 65535)
									local value46 = bit32.band(number22 - 4564062016 + 28981759 + bit32.band(50689 * value45 + bit32.lshift(bit32.band(50689 * bit32.rshift(value44, 16) + 32325 * value45, 65535), 16), 4294967295) + 1195411303, 4294967295)
									local value47 = bit32.band(value46, 65535)
									number24 = bit32.band(31367 * value47 + bit32.lshift(bit32.band(31367 * bit32.rshift(value46, 16) + 21986 * value47, 65535), 16), 4294967295) + 21801894718
									value22[number12] = bit32.bxor(value22[number12], 327058238)
									number25 = number5 + 584826193
									local number59 = bit32.band(number25, 4294967295)
									local number60 = bit32.band(number59, 65535)
									number26 = bit32.band(43296 * number60 + bit32.lshift(bit32.band(43296 * bit32.rshift(number59, 16) + 12122 * number60, 65535), 16), 4294967295) + 1588941376
									local number61 = bit32.band(number12, 4294967295)
									local number62 = bit32.band(number61, 65535)
									value28 = bit32.band(number62 * 62187 + bit32.lshift(bit32.band(number62 * 8557 + bit32.rshift(number61, 16) * 62187, 65535), 16), 4294967295)
									number27 = bit32.band(number25, number24)
									local value48 = bit32.band(value28, 4294967295)
									local number63 = bit32.band(number27, 4294967295)
									local value49 = bit32.band(value48, 65535)
									local value50 = bit32.rshift(value48, 16)
									local number64 = bit32.band(number63, 65535)
									local value51 = bit32.band(value49 * number64 + bit32.lshift(bit32.band(value49 * bit32.rshift(number63, 16) + value50 * number64, 65535), 16), 4294967295)
									local value52 = bit32.band(value51, 65535)
									value29 = bit32.band(51485 * value52 + bit32.lshift(bit32.band(51485 * bit32.rshift(value51, 16) + 39315 * value52, 65535), 16), 4294967295)
									local value53 = bit32.band(value28, 4294967295)
									local value54 = bit32.band(value53, 65535)
									number28 = number26 + value29 + bit32.band(29245 * value54 + bit32.lshift(bit32.band(29245 * bit32.rshift(value53, 16) + 51438 * value54, 65535), 16), 4294967295)
									number29 = bit32.band(number24, 272719449)
									number30 = bit32.bnot(number27)
									local value55 = bit32.band(value28, 4294967295)
									local number65 = bit32.band(number30, 4294967295)
									local value56 = bit32.band(value55, 65535)
									local value57 = bit32.rshift(value55, 16)
									local number66 = bit32.band(number65, 65535)
									local value58 = bit32.band(value56 * number66 + bit32.lshift(bit32.band(value56 * bit32.rshift(number65, 16) + value57 * number66, 65535), 16), 4294967295)
									local value59 = bit32.band(value58, 65535)
									number31 = number29 + bit32.band(51485 * value59 + bit32.lshift(bit32.band(51485 * bit32.rshift(value58, 16) + 39315 * value59, 65535), 16), 4294967295)
									number32 = bit32.bor(number25, value28)
									local number67 = bit32.bnot(number32)
									local number68 = bit32.band(number67, 65535)
									number33 = number28 + number31 + 3045076956 + bit32.band(21056 * number68 + bit32.lshift(bit32.band(21056 * bit32.rshift(number67, 16) + 24245 * number68, 65535), 16), 4294967295)
									number34 = bit32.band(number33, 2147483647)
									number35 = bit32.bnot(number34)
									local number69 = bit32.band(number35, 4294967295)
									local number70 = bit32.band(number69, 65535)
									value30 = bit32.band(65535 * number70 + bit32.lshift(bit32.band(65535 * bit32.rshift(number69, 16) + 65535 * number70, 65535), 16), 4294967295)
									local number71 = bit32.band(number33, 4294967295)
									local number72 = bit32.band(number71, 65535)
									value31 = bit32.band(46641 * number72 + bit32.lshift(bit32.band(46641 * bit32.rshift(number71, 16) + 36583 * number72, 65535), 16), 4294967295)
									number36 = bit32.bnot(number33)
									local number73 = bit32.band(number36, 4294967295)
									local number74 = bit32.band(number73, 65535)
									number37 = 2397550128 + value30 + value31 + bit32.band(46641 * number74 + bit32.lshift(bit32.band(46641 * bit32.rshift(number73, 16) + 36583 * number74, 65535), 16), 4294967295)
									local number75 = bit32.band(number33, 4294967295)
									local number76 = bit32.band(number75, 65535)
									value32 = bit32.band(1004 * number76 + bit32.lshift(bit32.band(1004 * bit32.rshift(number75, 16) + 49886 * number76, 65535), 16), 4294967295)
									local number77 = bit32.band(number36, 4294967295)
									local number78 = bit32.band(number77, 65535)
									local value60 = bit32.band(number37 - 3269329899 + value30 + value32 + bit32.band(1004 * number78 + bit32.lshift(bit32.band(1004 * bit32.rshift(number77, 16) + 49886 * number78, 65535), 16), 4294967295), 4294967295)
									local value61 = bit32.band(value60, 65535)
									value33 = bit32.band(21218 * value61 + bit32.lshift(bit32.band(21218 * bit32.rshift(value60, 16) + 47856 * value61, 65535), 16), 4294967295)
									local number79 = bit32.band(number33, 4294967295)
									local number80 = bit32.band(number35, 4294967295)
									local number81 = bit32.band(number79, 65535)
									local number82 = bit32.rshift(number79, 16)
									local number83 = bit32.band(number80, 65535)
									local value62 = bit32.band(number81 * number83 + bit32.lshift(bit32.band(number81 * bit32.rshift(number80, 16) + number82 * number83, 65535), 16), 4294967295)
									local value63 = bit32.band(value62, 65535)
									number38 = 2669559910 + bit32.band(64492 * value63 + bit32.lshift(bit32.band(64492 * bit32.rshift(value62, 16) + 27898 * value63, 65535), 16), 4294967295)
									local number84 = bit32.band(number33, 4294967295)
									local number85 = bit32.band(number84, 65535)
									number39 = number35
									number40 = bit32.bor(number33, 2147483647)
									number41 = number38 + bit32.band(16487 * number85 + bit32.lshift(bit32.band(16487 * bit32.rshift(number84, 16) + 40734 * number85, 65535), 16), 4294967295) + 0
									local number86 = bit32.band(number39, 4294967295)
									local number87 = bit32.band(number86, 65535)
									value34 = bit32.band(15442 * number87 + bit32.lshift(bit32.band(15442 * bit32.rshift(number86, 16) + 3097 * number87, 65535), 16), 4294967295)
									local number88 = bit32.band(number39, 4294967295)
									local number89 = bit32.band(number39, 4294967295)
									local number90 = bit32.band(number88, 65535)
									local number91 = bit32.rshift(number88, 16)
									local number92 = bit32.band(number89, 65535)
									local value64 = bit32.band(number90 * number92 + bit32.lshift(bit32.band(number90 * bit32.rshift(number89, 16) + number91 * number92, 65535), 16), 4294967295)
									local value65 = bit32.band(value64, 65535)
									number42 = value34 + bit32.band(64492 * value65 + bit32.lshift(bit32.band(64492 * bit32.rshift(value64, 16) + 27898 * value65, 65535), 16), 4294967295)
									local number93 = bit32.band(number33, 4294967295)
									local number94 = bit32.band(number93, 65535)
									local value66 = bit32.band(number94 * 0 + bit32.lshift(bit32.band(number94 * 0 + bit32.rshift(number93, 16) * 0, 65535), 16), 4294967295)
									local value67 = bit32.band(value66, 65535)
									value35 = bit32.band(64492 * value67 + bit32.lshift(bit32.band(64492 * bit32.rshift(value66, 16) + 27898 * value67, 65535), 16), 4294967295)
									local number95 = bit32.band(number40, 4294967295)
									local number96 = bit32.band(number95, 65535)
									local value68 = bit32.band(number96 * 0 + bit32.lshift(bit32.band(number96 * 0 + bit32.rshift(number95, 16) * 0, 65535), 16), 4294967295)
									local value69 = bit32.band(value68, 65535)
									number5 = value33 + number41 + number42 + 0 + value35 + bit32.band(1044 * value69 + bit32.lshift(bit32.band(1044 * bit32.rshift(value68, 16) + 37637 * value69, 65535), 16), 4294967295)
								else
									break
								end
							end

							data5 = data6[4]
							continue
						end

						value12 = argument[6]
						number6 = buffer.len(value12) - 32 - 19
						number7 = 32 + 888971832 % number6
						number8 = 32

						while true do
							number9 = number8 + (number7 + bit32.band(number5, 255) + 1) % number6
							value13 = buffer.readi8(value12, number7)
							value14 = buffer.readu8(value12, number9)
							value15 = bit32.lshift(bit32.band(value14, 255), 3)
							value16 = bit32.band(bit32.bxor(bit32.bxor(54517094, value13) + value15 + 584826193, number7), 2147483647)
							value17 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value13, value14), value16), 2147483647), 205469696)
							buffer.writeu32(value12, number7, value17)
							value18 = bit32.rshift(value16, 8)
							value19 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value14, value18), number7), 2147483647), 327527424)
							buffer.writeu8(value12, number9, value19)
							number5 = value16
							number7 = number8 + (number7 + bit32.band(value16, 63) + 1) % number6
						end
					else
						condition3 = condition4
						data5[4] = number10

						if condition3 then
							value22 = data4[number10]
							data6 = { 0, #value22 + 0, nil, data5, 1 }

							while true do
								value23 = data6[5]
								value24 = data6[2]
								number11 = data6[1] + value23
								data6[1] = number11

								if number11 <= value24 then
									number12 = number11
									number13 = bit32.lshift(bit32.band(number5, number12), 1)
									number14 = bit32.band(number13, number5)
									number15 = bit32.bnot(number14)
									local number43 = bit32.band(number13, 4294967295)
									local number44 = bit32.band(number15, 4294967295)
									local number45 = bit32.band(number43, 65535)
									local number46 = bit32.rshift(number43, 16)
									local number47 = bit32.band(number44, 65535)
									local value36 = bit32.band(number45 * number47 + bit32.lshift(bit32.band(number45 * bit32.rshift(number44, 16) + number46 * number47, 65535), 16), 4294967295)
									local value37 = bit32.band(value36, 65535)
									value25 = bit32.band(19474 * value37 + bit32.lshift(bit32.band(19474 * bit32.rshift(value36, 16) + 39469 * value37, 65535), 16), 4294967295)
									local number48 = bit32.band(number13, 4294967295)
									local number49 = bit32.band(number48, 65535)
									number16 = number12 + number5 + value25 + bit32.band(23587 * number49 + bit32.lshift(bit32.band(23587 * bit32.rshift(number48, 16) + 21404 * number49, 65535), 16), 4294967295)
									number17 = bit32.bnot(number5)
									number18 = bit32.bor(number17, 54517094)
									local number50 = bit32.band(number13, 4294967295)
									local number51 = bit32.band(number18, 4294967295)
									local number52 = bit32.band(number50, 65535)
									local number53 = bit32.rshift(number50, 16)
									local number54 = bit32.band(number51, 65535)
									local value38 = bit32.band(number52 * number54 + bit32.lshift(bit32.band(number52 * bit32.rshift(number51, 16) + number53 * number54, 65535), 16), 4294967295)
									local value39 = bit32.band(value38, 65535)
									number19 = 1402756132 + bit32.band(46062 * value39 + bit32.lshift(bit32.band(46062 * bit32.rshift(value38, 16) + 26066 * value39, 65535), 16), 4294967295)
									local number55 = bit32.bnot(number13)
									local number56 = bit32.band(number55, 65535)
									value26 = bit32.band(23586 * number56 + bit32.lshift(bit32.band(23586 * bit32.rshift(number55, 16) + 21404 * number56, 65535), 16), 4294967295)
									local value40 = bit32.bor(54517095, number17)
									local value41 = bit32.band(value40, 65535)
									number20 = number16 + number19 + value26 + bit32.band(2 * value41 + bit32.lshift(bit32.band(2 * bit32.rshift(value40, 16) + 0 * value41, 65535), 16), 4294967295)
									local number57 = bit32.band(number20, 4294967295)
									local number58 = bit32.band(number57, 65535)
									number21 = 327058238 + 3859571462 + bit32.band(25350 * number58 + bit32.lshift(bit32.band(25350 * bit32.rshift(number57, 16) + 58892 * number58, 65535), 16), 4294967295)
									value27 = bit32.bor(2147483647, number20)
									local value42 = bit32.band(272719449, value27)
									local value43 = bit32.band(value42, 65535)
									number22 = number21 + 375472684 + bit32.band(14836 * value43 + bit32.lshift(bit32.band(14836 * bit32.rshift(value42, 16) + 13287 * value43, 65535), 16), 4294967295) + 1761712016
									number23 = bit32.bnot(number20)
									local value44 = bit32.bor(2092966552, number23)
									local value45 = bit32.band(value44, 65535)
									local value46 = bit32.band(number22 - 4564062016 + 28981759 + bit32.band(50689 * value45 + bit32.lshift(bit32.band(50689 * bit32.rshift(value44, 16) + 32325 * value45, 65535), 16), 4294967295) + 1195411303, 4294967295)
									local value47 = bit32.band(value46, 65535)
									number24 = bit32.band(31367 * value47 + bit32.lshift(bit32.band(31367 * bit32.rshift(value46, 16) + 21986 * value47, 65535), 16), 4294967295) + 21801894718
									value22[number12] = bit32.bxor(value22[number12], 327058238)
									number25 = number5 + 584826193
									local number59 = bit32.band(number25, 4294967295)
									local number60 = bit32.band(number59, 65535)
									number26 = bit32.band(43296 * number60 + bit32.lshift(bit32.band(43296 * bit32.rshift(number59, 16) + 12122 * number60, 65535), 16), 4294967295) + 1588941376
									local number61 = bit32.band(number12, 4294967295)
									local number62 = bit32.band(number61, 65535)
									value28 = bit32.band(number62 * 62187 + bit32.lshift(bit32.band(number62 * 8557 + bit32.rshift(number61, 16) * 62187, 65535), 16), 4294967295)
									number27 = bit32.band(number25, number24)
									local value48 = bit32.band(value28, 4294967295)
									local number63 = bit32.band(number27, 4294967295)
									local value49 = bit32.band(value48, 65535)
									local value50 = bit32.rshift(value48, 16)
									local number64 = bit32.band(number63, 65535)
									local value51 = bit32.band(value49 * number64 + bit32.lshift(bit32.band(value49 * bit32.rshift(number63, 16) + value50 * number64, 65535), 16), 4294967295)
									local value52 = bit32.band(value51, 65535)
									value29 = bit32.band(51485 * value52 + bit32.lshift(bit32.band(51485 * bit32.rshift(value51, 16) + 39315 * value52, 65535), 16), 4294967295)
									local value53 = bit32.band(value28, 4294967295)
									local value54 = bit32.band(value53, 65535)
									number28 = number26 + value29 + bit32.band(29245 * value54 + bit32.lshift(bit32.band(29245 * bit32.rshift(value53, 16) + 51438 * value54, 65535), 16), 4294967295)
									number29 = bit32.band(number24, 272719449)
									number30 = bit32.bnot(number27)
									local value55 = bit32.band(value28, 4294967295)
									local number65 = bit32.band(number30, 4294967295)
									local value56 = bit32.band(value55, 65535)
									local value57 = bit32.rshift(value55, 16)
									local number66 = bit32.band(number65, 65535)
									local value58 = bit32.band(value56 * number66 + bit32.lshift(bit32.band(value56 * bit32.rshift(number65, 16) + value57 * number66, 65535), 16), 4294967295)
									local value59 = bit32.band(value58, 65535)
									number31 = number29 + bit32.band(51485 * value59 + bit32.lshift(bit32.band(51485 * bit32.rshift(value58, 16) + 39315 * value59, 65535), 16), 4294967295)
									number32 = bit32.bor(number25, value28)
									local number67 = bit32.bnot(number32)
									local number68 = bit32.band(number67, 65535)
									number33 = number28 + number31 + 3045076956 + bit32.band(21056 * number68 + bit32.lshift(bit32.band(21056 * bit32.rshift(number67, 16) + 24245 * number68, 65535), 16), 4294967295)
									number34 = bit32.band(number33, 2147483647)
									number35 = bit32.bnot(number34)
									local number69 = bit32.band(number35, 4294967295)
									local number70 = bit32.band(number69, 65535)
									value30 = bit32.band(65535 * number70 + bit32.lshift(bit32.band(65535 * bit32.rshift(number69, 16) + 65535 * number70, 65535), 16), 4294967295)
									local number71 = bit32.band(number33, 4294967295)
									local number72 = bit32.band(number71, 65535)
									value31 = bit32.band(46641 * number72 + bit32.lshift(bit32.band(46641 * bit32.rshift(number71, 16) + 36583 * number72, 65535), 16), 4294967295)
									number36 = bit32.bnot(number33)
									local number73 = bit32.band(number36, 4294967295)
									local number74 = bit32.band(number73, 65535)
									number37 = 2397550128 + value30 + value31 + bit32.band(46641 * number74 + bit32.lshift(bit32.band(46641 * bit32.rshift(number73, 16) + 36583 * number74, 65535), 16), 4294967295)
									local number75 = bit32.band(number33, 4294967295)
									local number76 = bit32.band(number75, 65535)
									value32 = bit32.band(1004 * number76 + bit32.lshift(bit32.band(1004 * bit32.rshift(number75, 16) + 49886 * number76, 65535), 16), 4294967295)
									local number77 = bit32.band(number36, 4294967295)
									local number78 = bit32.band(number77, 65535)
									local value60 = bit32.band(number37 - 3269329899 + value30 + value32 + bit32.band(1004 * number78 + bit32.lshift(bit32.band(1004 * bit32.rshift(number77, 16) + 49886 * number78, 65535), 16), 4294967295), 4294967295)
									local value61 = bit32.band(value60, 65535)
									value33 = bit32.band(21218 * value61 + bit32.lshift(bit32.band(21218 * bit32.rshift(value60, 16) + 47856 * value61, 65535), 16), 4294967295)
									local number79 = bit32.band(number33, 4294967295)
									local number80 = bit32.band(number35, 4294967295)
									local number81 = bit32.band(number79, 65535)
									local number82 = bit32.rshift(number79, 16)
									local number83 = bit32.band(number80, 65535)
									local value62 = bit32.band(number81 * number83 + bit32.lshift(bit32.band(number81 * bit32.rshift(number80, 16) + number82 * number83, 65535), 16), 4294967295)
									local value63 = bit32.band(value62, 65535)
									number38 = 2669559910 + bit32.band(64492 * value63 + bit32.lshift(bit32.band(64492 * bit32.rshift(value62, 16) + 27898 * value63, 65535), 16), 4294967295)
									local number84 = bit32.band(number33, 4294967295)
									local number85 = bit32.band(number84, 65535)
									number39 = number35
									number40 = bit32.bor(number33, 2147483647)
									number41 = number38 + bit32.band(16487 * number85 + bit32.lshift(bit32.band(16487 * bit32.rshift(number84, 16) + 40734 * number85, 65535), 16), 4294967295) + 0
									local number86 = bit32.band(number39, 4294967295)
									local number87 = bit32.band(number86, 65535)
									value34 = bit32.band(15442 * number87 + bit32.lshift(bit32.band(15442 * bit32.rshift(number86, 16) + 3097 * number87, 65535), 16), 4294967295)
									local number88 = bit32.band(number39, 4294967295)
									local number89 = bit32.band(number39, 4294967295)
									local number90 = bit32.band(number88, 65535)
									local number91 = bit32.rshift(number88, 16)
									local number92 = bit32.band(number89, 65535)
									local value64 = bit32.band(number90 * number92 + bit32.lshift(bit32.band(number90 * bit32.rshift(number89, 16) + number91 * number92, 65535), 16), 4294967295)
									local value65 = bit32.band(value64, 65535)
									number42 = value34 + bit32.band(64492 * value65 + bit32.lshift(bit32.band(64492 * bit32.rshift(value64, 16) + 27898 * value65, 65535), 16), 4294967295)
									local number93 = bit32.band(number33, 4294967295)
									local number94 = bit32.band(number93, 65535)
									local value66 = bit32.band(number94 * 0 + bit32.lshift(bit32.band(number94 * 0 + bit32.rshift(number93, 16) * 0, 65535), 16), 4294967295)
									local value67 = bit32.band(value66, 65535)
									value35 = bit32.band(64492 * value67 + bit32.lshift(bit32.band(64492 * bit32.rshift(value66, 16) + 27898 * value67, 65535), 16), 4294967295)
									local number95 = bit32.band(number40, 4294967295)
									local number96 = bit32.band(number95, 65535)
									local value68 = bit32.band(number96 * 0 + bit32.lshift(bit32.band(number96 * 0 + bit32.rshift(number95, 16) * 0, 65535), 16), 4294967295)
									local value69 = bit32.band(value68, 65535)
									number5 = value33 + number41 + number42 + 0 + value35 + bit32.band(1044 * value69 + bit32.lshift(bit32.band(1044 * bit32.rshift(value68, 16) + 37637 * value69, 65535), 16), 4294967295)
								else
									break
								end
							end

							data5 = data6[4]
							continue
						end

						value12 = argument[6]
						number6 = buffer.len(value12) - 32 - 19
						number7 = 32 + 888971832 % number6
						number8 = 32

						while true do
							number9 = number8 + (number7 + bit32.band(number5, 255) + 1) % number6
							value13 = buffer.readi8(value12, number7)
							value14 = buffer.readu8(value12, number9)
							value15 = bit32.lshift(bit32.band(value14, 255), 3)
							value16 = bit32.band(bit32.bxor(bit32.bxor(54517094, value13) + value15 + 584826193, number7), 2147483647)
							value17 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value13, value14), value16), 2147483647), 205469696)
							buffer.writeu32(value12, number7, value17)
							value18 = bit32.rshift(value16, 8)
							value19 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value14, value18), number7), 2147483647), 327527424)
							buffer.writeu8(value12, number9, value19)
							number5 = value16
							number7 = number8 + (number7 + bit32.band(value16, 63) + 1) % number6
						end
					end
				end
			else
				condition3 = condition

				if condition2 then
					if not condition3 then
						condition3 = condition4
						data5[4] = number10

						if condition3 then
							value22 = data4[number10]
							data6 = { 0, #value22 + 0, nil, data5, 1 }

							while true do
								value23 = data6[5]
								value24 = data6[2]
								number11 = data6[1] + value23
								data6[1] = number11

								if number11 <= value24 then
									number12 = number11
									number13 = bit32.lshift(bit32.band(number5, number12), 1)
									number14 = bit32.band(number13, number5)
									number15 = bit32.bnot(number14)
									local number43 = bit32.band(number13, 4294967295)
									local number44 = bit32.band(number15, 4294967295)
									local number45 = bit32.band(number43, 65535)
									local number46 = bit32.rshift(number43, 16)
									local number47 = bit32.band(number44, 65535)
									local value36 = bit32.band(number45 * number47 + bit32.lshift(bit32.band(number45 * bit32.rshift(number44, 16) + number46 * number47, 65535), 16), 4294967295)
									local value37 = bit32.band(value36, 65535)
									value25 = bit32.band(19474 * value37 + bit32.lshift(bit32.band(19474 * bit32.rshift(value36, 16) + 39469 * value37, 65535), 16), 4294967295)
									local number48 = bit32.band(number13, 4294967295)
									local number49 = bit32.band(number48, 65535)
									number16 = number12 + number5 + value25 + bit32.band(23587 * number49 + bit32.lshift(bit32.band(23587 * bit32.rshift(number48, 16) + 21404 * number49, 65535), 16), 4294967295)
									number17 = bit32.bnot(number5)
									number18 = bit32.bor(number17, 54517094)
									local number50 = bit32.band(number13, 4294967295)
									local number51 = bit32.band(number18, 4294967295)
									local number52 = bit32.band(number50, 65535)
									local number53 = bit32.rshift(number50, 16)
									local number54 = bit32.band(number51, 65535)
									local value38 = bit32.band(number52 * number54 + bit32.lshift(bit32.band(number52 * bit32.rshift(number51, 16) + number53 * number54, 65535), 16), 4294967295)
									local value39 = bit32.band(value38, 65535)
									number19 = 1402756132 + bit32.band(46062 * value39 + bit32.lshift(bit32.band(46062 * bit32.rshift(value38, 16) + 26066 * value39, 65535), 16), 4294967295)
									local number55 = bit32.bnot(number13)
									local number56 = bit32.band(number55, 65535)
									value26 = bit32.band(23586 * number56 + bit32.lshift(bit32.band(23586 * bit32.rshift(number55, 16) + 21404 * number56, 65535), 16), 4294967295)
									local value40 = bit32.bor(54517095, number17)
									local value41 = bit32.band(value40, 65535)
									number20 = number16 + number19 + value26 + bit32.band(2 * value41 + bit32.lshift(bit32.band(2 * bit32.rshift(value40, 16) + 0 * value41, 65535), 16), 4294967295)
									local number57 = bit32.band(number20, 4294967295)
									local number58 = bit32.band(number57, 65535)
									number21 = 327058238 + 3859571462 + bit32.band(25350 * number58 + bit32.lshift(bit32.band(25350 * bit32.rshift(number57, 16) + 58892 * number58, 65535), 16), 4294967295)
									value27 = bit32.bor(2147483647, number20)
									local value42 = bit32.band(272719449, value27)
									local value43 = bit32.band(value42, 65535)
									number22 = number21 + 375472684 + bit32.band(14836 * value43 + bit32.lshift(bit32.band(14836 * bit32.rshift(value42, 16) + 13287 * value43, 65535), 16), 4294967295) + 1761712016
									number23 = bit32.bnot(number20)
									local value44 = bit32.bor(2092966552, number23)
									local value45 = bit32.band(value44, 65535)
									local value46 = bit32.band(number22 - 4564062016 + 28981759 + bit32.band(50689 * value45 + bit32.lshift(bit32.band(50689 * bit32.rshift(value44, 16) + 32325 * value45, 65535), 16), 4294967295) + 1195411303, 4294967295)
									local value47 = bit32.band(value46, 65535)
									number24 = bit32.band(31367 * value47 + bit32.lshift(bit32.band(31367 * bit32.rshift(value46, 16) + 21986 * value47, 65535), 16), 4294967295) + 21801894718
									value22[number12] = bit32.bxor(value22[number12], 327058238)
									number25 = number5 + 584826193
									local number59 = bit32.band(number25, 4294967295)
									local number60 = bit32.band(number59, 65535)
									number26 = bit32.band(43296 * number60 + bit32.lshift(bit32.band(43296 * bit32.rshift(number59, 16) + 12122 * number60, 65535), 16), 4294967295) + 1588941376
									local number61 = bit32.band(number12, 4294967295)
									local number62 = bit32.band(number61, 65535)
									value28 = bit32.band(number62 * 62187 + bit32.lshift(bit32.band(number62 * 8557 + bit32.rshift(number61, 16) * 62187, 65535), 16), 4294967295)
									number27 = bit32.band(number25, number24)
									local value48 = bit32.band(value28, 4294967295)
									local number63 = bit32.band(number27, 4294967295)
									local value49 = bit32.band(value48, 65535)
									local value50 = bit32.rshift(value48, 16)
									local number64 = bit32.band(number63, 65535)
									local value51 = bit32.band(value49 * number64 + bit32.lshift(bit32.band(value49 * bit32.rshift(number63, 16) + value50 * number64, 65535), 16), 4294967295)
									local value52 = bit32.band(value51, 65535)
									value29 = bit32.band(51485 * value52 + bit32.lshift(bit32.band(51485 * bit32.rshift(value51, 16) + 39315 * value52, 65535), 16), 4294967295)
									local value53 = bit32.band(value28, 4294967295)
									local value54 = bit32.band(value53, 65535)
									number28 = number26 + value29 + bit32.band(29245 * value54 + bit32.lshift(bit32.band(29245 * bit32.rshift(value53, 16) + 51438 * value54, 65535), 16), 4294967295)
									number29 = bit32.band(number24, 272719449)
									number30 = bit32.bnot(number27)
									local value55 = bit32.band(value28, 4294967295)
									local number65 = bit32.band(number30, 4294967295)
									local value56 = bit32.band(value55, 65535)
									local value57 = bit32.rshift(value55, 16)
									local number66 = bit32.band(number65, 65535)
									local value58 = bit32.band(value56 * number66 + bit32.lshift(bit32.band(value56 * bit32.rshift(number65, 16) + value57 * number66, 65535), 16), 4294967295)
									local value59 = bit32.band(value58, 65535)
									number31 = number29 + bit32.band(51485 * value59 + bit32.lshift(bit32.band(51485 * bit32.rshift(value58, 16) + 39315 * value59, 65535), 16), 4294967295)
									number32 = bit32.bor(number25, value28)
									local number67 = bit32.bnot(number32)
									local number68 = bit32.band(number67, 65535)
									number33 = number28 + number31 + 3045076956 + bit32.band(21056 * number68 + bit32.lshift(bit32.band(21056 * bit32.rshift(number67, 16) + 24245 * number68, 65535), 16), 4294967295)
									number34 = bit32.band(number33, 2147483647)
									number35 = bit32.bnot(number34)
									local number69 = bit32.band(number35, 4294967295)
									local number70 = bit32.band(number69, 65535)
									value30 = bit32.band(65535 * number70 + bit32.lshift(bit32.band(65535 * bit32.rshift(number69, 16) + 65535 * number70, 65535), 16), 4294967295)
									local number71 = bit32.band(number33, 4294967295)
									local number72 = bit32.band(number71, 65535)
									value31 = bit32.band(46641 * number72 + bit32.lshift(bit32.band(46641 * bit32.rshift(number71, 16) + 36583 * number72, 65535), 16), 4294967295)
									number36 = bit32.bnot(number33)
									local number73 = bit32.band(number36, 4294967295)
									local number74 = bit32.band(number73, 65535)
									number37 = 2397550128 + value30 + value31 + bit32.band(46641 * number74 + bit32.lshift(bit32.band(46641 * bit32.rshift(number73, 16) + 36583 * number74, 65535), 16), 4294967295)
									local number75 = bit32.band(number33, 4294967295)
									local number76 = bit32.band(number75, 65535)
									value32 = bit32.band(1004 * number76 + bit32.lshift(bit32.band(1004 * bit32.rshift(number75, 16) + 49886 * number76, 65535), 16), 4294967295)
									local number77 = bit32.band(number36, 4294967295)
									local number78 = bit32.band(number77, 65535)
									local value60 = bit32.band(number37 - 3269329899 + value30 + value32 + bit32.band(1004 * number78 + bit32.lshift(bit32.band(1004 * bit32.rshift(number77, 16) + 49886 * number78, 65535), 16), 4294967295), 4294967295)
									local value61 = bit32.band(value60, 65535)
									value33 = bit32.band(21218 * value61 + bit32.lshift(bit32.band(21218 * bit32.rshift(value60, 16) + 47856 * value61, 65535), 16), 4294967295)
									local number79 = bit32.band(number33, 4294967295)
									local number80 = bit32.band(number35, 4294967295)
									local number81 = bit32.band(number79, 65535)
									local number82 = bit32.rshift(number79, 16)
									local number83 = bit32.band(number80, 65535)
									local value62 = bit32.band(number81 * number83 + bit32.lshift(bit32.band(number81 * bit32.rshift(number80, 16) + number82 * number83, 65535), 16), 4294967295)
									local value63 = bit32.band(value62, 65535)
									number38 = 2669559910 + bit32.band(64492 * value63 + bit32.lshift(bit32.band(64492 * bit32.rshift(value62, 16) + 27898 * value63, 65535), 16), 4294967295)
									local number84 = bit32.band(number33, 4294967295)
									local number85 = bit32.band(number84, 65535)
									number39 = number35
									number40 = bit32.bor(number33, 2147483647)
									number41 = number38 + bit32.band(16487 * number85 + bit32.lshift(bit32.band(16487 * bit32.rshift(number84, 16) + 40734 * number85, 65535), 16), 4294967295) + 0
									local number86 = bit32.band(number39, 4294967295)
									local number87 = bit32.band(number86, 65535)
									value34 = bit32.band(15442 * number87 + bit32.lshift(bit32.band(15442 * bit32.rshift(number86, 16) + 3097 * number87, 65535), 16), 4294967295)
									local number88 = bit32.band(number39, 4294967295)
									local number89 = bit32.band(number39, 4294967295)
									local number90 = bit32.band(number88, 65535)
									local number91 = bit32.rshift(number88, 16)
									local number92 = bit32.band(number89, 65535)
									local value64 = bit32.band(number90 * number92 + bit32.lshift(bit32.band(number90 * bit32.rshift(number89, 16) + number91 * number92, 65535), 16), 4294967295)
									local value65 = bit32.band(value64, 65535)
									number42 = value34 + bit32.band(64492 * value65 + bit32.lshift(bit32.band(64492 * bit32.rshift(value64, 16) + 27898 * value65, 65535), 16), 4294967295)
									local number93 = bit32.band(number33, 4294967295)
									local number94 = bit32.band(number93, 65535)
									local value66 = bit32.band(number94 * 0 + bit32.lshift(bit32.band(number94 * 0 + bit32.rshift(number93, 16) * 0, 65535), 16), 4294967295)
									local value67 = bit32.band(value66, 65535)
									value35 = bit32.band(64492 * value67 + bit32.lshift(bit32.band(64492 * bit32.rshift(value66, 16) + 27898 * value67, 65535), 16), 4294967295)
									local number95 = bit32.band(number40, 4294967295)
									local number96 = bit32.band(number95, 65535)
									local value68 = bit32.band(number96 * 0 + bit32.lshift(bit32.band(number96 * 0 + bit32.rshift(number95, 16) * 0, 65535), 16), 4294967295)
									local value69 = bit32.band(value68, 65535)
									number5 = value33 + number41 + number42 + 0 + value35 + bit32.band(1044 * value69 + bit32.lshift(bit32.band(1044 * bit32.rshift(value68, 16) + 37637 * value69, 65535), 16), 4294967295)
								else
									break
								end
							end

							data5 = data6[4]
							continue
						end

						break
					end

					data5[4] = number10

					if condition3 then
						value22 = data4[number10]
						data6 = { 0, #value22 + 0, nil, data5, 1 }

						while true do
							value23 = data6[5]
							value24 = data6[2]
							number11 = data6[1] + value23
							data6[1] = number11

							if number11 <= value24 then
								number12 = number11
								number13 = bit32.lshift(bit32.band(number5, number12), 1)
								number14 = bit32.band(number13, number5)
								number15 = bit32.bnot(number14)
								local number43 = bit32.band(number13, 4294967295)
								local number44 = bit32.band(number15, 4294967295)
								local number45 = bit32.band(number43, 65535)
								local number46 = bit32.rshift(number43, 16)
								local number47 = bit32.band(number44, 65535)
								local value36 = bit32.band(number45 * number47 + bit32.lshift(bit32.band(number45 * bit32.rshift(number44, 16) + number46 * number47, 65535), 16), 4294967295)
								local value37 = bit32.band(value36, 65535)
								value25 = bit32.band(19474 * value37 + bit32.lshift(bit32.band(19474 * bit32.rshift(value36, 16) + 39469 * value37, 65535), 16), 4294967295)
								local number48 = bit32.band(number13, 4294967295)
								local number49 = bit32.band(number48, 65535)
								number16 = number12 + number5 + value25 + bit32.band(23587 * number49 + bit32.lshift(bit32.band(23587 * bit32.rshift(number48, 16) + 21404 * number49, 65535), 16), 4294967295)
								number17 = bit32.bnot(number5)
								number18 = bit32.bor(number17, 54517094)
								local number50 = bit32.band(number13, 4294967295)
								local number51 = bit32.band(number18, 4294967295)
								local number52 = bit32.band(number50, 65535)
								local number53 = bit32.rshift(number50, 16)
								local number54 = bit32.band(number51, 65535)
								local value38 = bit32.band(number52 * number54 + bit32.lshift(bit32.band(number52 * bit32.rshift(number51, 16) + number53 * number54, 65535), 16), 4294967295)
								local value39 = bit32.band(value38, 65535)
								number19 = 1402756132 + bit32.band(46062 * value39 + bit32.lshift(bit32.band(46062 * bit32.rshift(value38, 16) + 26066 * value39, 65535), 16), 4294967295)
								local number55 = bit32.bnot(number13)
								local number56 = bit32.band(number55, 65535)
								value26 = bit32.band(23586 * number56 + bit32.lshift(bit32.band(23586 * bit32.rshift(number55, 16) + 21404 * number56, 65535), 16), 4294967295)
								local value40 = bit32.bor(54517095, number17)
								local value41 = bit32.band(value40, 65535)
								number20 = number16 + number19 + value26 + bit32.band(2 * value41 + bit32.lshift(bit32.band(2 * bit32.rshift(value40, 16) + 0 * value41, 65535), 16), 4294967295)
								local number57 = bit32.band(number20, 4294967295)
								local number58 = bit32.band(number57, 65535)
								number21 = 327058238 + 3859571462 + bit32.band(25350 * number58 + bit32.lshift(bit32.band(25350 * bit32.rshift(number57, 16) + 58892 * number58, 65535), 16), 4294967295)
								value27 = bit32.bor(2147483647, number20)
								local value42 = bit32.band(272719449, value27)
								local value43 = bit32.band(value42, 65535)
								number22 = number21 + 375472684 + bit32.band(14836 * value43 + bit32.lshift(bit32.band(14836 * bit32.rshift(value42, 16) + 13287 * value43, 65535), 16), 4294967295) + 1761712016
								number23 = bit32.bnot(number20)
								local value44 = bit32.bor(2092966552, number23)
								local value45 = bit32.band(value44, 65535)
								local value46 = bit32.band(number22 - 4564062016 + 28981759 + bit32.band(50689 * value45 + bit32.lshift(bit32.band(50689 * bit32.rshift(value44, 16) + 32325 * value45, 65535), 16), 4294967295) + 1195411303, 4294967295)
								local value47 = bit32.band(value46, 65535)
								number24 = bit32.band(31367 * value47 + bit32.lshift(bit32.band(31367 * bit32.rshift(value46, 16) + 21986 * value47, 65535), 16), 4294967295) + 21801894718
								value22[number12] = bit32.bxor(value22[number12], 327058238)
								number25 = number5 + 584826193
								local number59 = bit32.band(number25, 4294967295)
								local number60 = bit32.band(number59, 65535)
								number26 = bit32.band(43296 * number60 + bit32.lshift(bit32.band(43296 * bit32.rshift(number59, 16) + 12122 * number60, 65535), 16), 4294967295) + 1588941376
								local number61 = bit32.band(number12, 4294967295)
								local number62 = bit32.band(number61, 65535)
								value28 = bit32.band(number62 * 62187 + bit32.lshift(bit32.band(number62 * 8557 + bit32.rshift(number61, 16) * 62187, 65535), 16), 4294967295)
								number27 = bit32.band(number25, number24)
								local value48 = bit32.band(value28, 4294967295)
								local number63 = bit32.band(number27, 4294967295)
								local value49 = bit32.band(value48, 65535)
								local value50 = bit32.rshift(value48, 16)
								local number64 = bit32.band(number63, 65535)
								local value51 = bit32.band(value49 * number64 + bit32.lshift(bit32.band(value49 * bit32.rshift(number63, 16) + value50 * number64, 65535), 16), 4294967295)
								local value52 = bit32.band(value51, 65535)
								value29 = bit32.band(51485 * value52 + bit32.lshift(bit32.band(51485 * bit32.rshift(value51, 16) + 39315 * value52, 65535), 16), 4294967295)
								local value53 = bit32.band(value28, 4294967295)
								local value54 = bit32.band(value53, 65535)
								number28 = number26 + value29 + bit32.band(29245 * value54 + bit32.lshift(bit32.band(29245 * bit32.rshift(value53, 16) + 51438 * value54, 65535), 16), 4294967295)
								number29 = bit32.band(number24, 272719449)
								number30 = bit32.bnot(number27)
								local value55 = bit32.band(value28, 4294967295)
								local number65 = bit32.band(number30, 4294967295)
								local value56 = bit32.band(value55, 65535)
								local value57 = bit32.rshift(value55, 16)
								local number66 = bit32.band(number65, 65535)
								local value58 = bit32.band(value56 * number66 + bit32.lshift(bit32.band(value56 * bit32.rshift(number65, 16) + value57 * number66, 65535), 16), 4294967295)
								local value59 = bit32.band(value58, 65535)
								number31 = number29 + bit32.band(51485 * value59 + bit32.lshift(bit32.band(51485 * bit32.rshift(value58, 16) + 39315 * value59, 65535), 16), 4294967295)
								number32 = bit32.bor(number25, value28)
								local number67 = bit32.bnot(number32)
								local number68 = bit32.band(number67, 65535)
								number33 = number28 + number31 + 3045076956 + bit32.band(21056 * number68 + bit32.lshift(bit32.band(21056 * bit32.rshift(number67, 16) + 24245 * number68, 65535), 16), 4294967295)
								number34 = bit32.band(number33, 2147483647)
								number35 = bit32.bnot(number34)
								local number69 = bit32.band(number35, 4294967295)
								local number70 = bit32.band(number69, 65535)
								value30 = bit32.band(65535 * number70 + bit32.lshift(bit32.band(65535 * bit32.rshift(number69, 16) + 65535 * number70, 65535), 16), 4294967295)
								local number71 = bit32.band(number33, 4294967295)
								local number72 = bit32.band(number71, 65535)
								value31 = bit32.band(46641 * number72 + bit32.lshift(bit32.band(46641 * bit32.rshift(number71, 16) + 36583 * number72, 65535), 16), 4294967295)
								number36 = bit32.bnot(number33)
								local number73 = bit32.band(number36, 4294967295)
								local number74 = bit32.band(number73, 65535)
								number37 = 2397550128 + value30 + value31 + bit32.band(46641 * number74 + bit32.lshift(bit32.band(46641 * bit32.rshift(number73, 16) + 36583 * number74, 65535), 16), 4294967295)
								local number75 = bit32.band(number33, 4294967295)
								local number76 = bit32.band(number75, 65535)
								value32 = bit32.band(1004 * number76 + bit32.lshift(bit32.band(1004 * bit32.rshift(number75, 16) + 49886 * number76, 65535), 16), 4294967295)
								local number77 = bit32.band(number36, 4294967295)
								local number78 = bit32.band(number77, 65535)
								local value60 = bit32.band(number37 - 3269329899 + value30 + value32 + bit32.band(1004 * number78 + bit32.lshift(bit32.band(1004 * bit32.rshift(number77, 16) + 49886 * number78, 65535), 16), 4294967295), 4294967295)
								local value61 = bit32.band(value60, 65535)
								value33 = bit32.band(21218 * value61 + bit32.lshift(bit32.band(21218 * bit32.rshift(value60, 16) + 47856 * value61, 65535), 16), 4294967295)
								local number79 = bit32.band(number33, 4294967295)
								local number80 = bit32.band(number35, 4294967295)
								local number81 = bit32.band(number79, 65535)
								local number82 = bit32.rshift(number79, 16)
								local number83 = bit32.band(number80, 65535)
								local value62 = bit32.band(number81 * number83 + bit32.lshift(bit32.band(number81 * bit32.rshift(number80, 16) + number82 * number83, 65535), 16), 4294967295)
								local value63 = bit32.band(value62, 65535)
								number38 = 2669559910 + bit32.band(64492 * value63 + bit32.lshift(bit32.band(64492 * bit32.rshift(value62, 16) + 27898 * value63, 65535), 16), 4294967295)
								local number84 = bit32.band(number33, 4294967295)
								local number85 = bit32.band(number84, 65535)
								number39 = number35
								number40 = bit32.bor(number33, 2147483647)
								number41 = number38 + bit32.band(16487 * number85 + bit32.lshift(bit32.band(16487 * bit32.rshift(number84, 16) + 40734 * number85, 65535), 16), 4294967295) + 0
								local number86 = bit32.band(number39, 4294967295)
								local number87 = bit32.band(number86, 65535)
								value34 = bit32.band(15442 * number87 + bit32.lshift(bit32.band(15442 * bit32.rshift(number86, 16) + 3097 * number87, 65535), 16), 4294967295)
								local number88 = bit32.band(number39, 4294967295)
								local number89 = bit32.band(number39, 4294967295)
								local number90 = bit32.band(number88, 65535)
								local number91 = bit32.rshift(number88, 16)
								local number92 = bit32.band(number89, 65535)
								local value64 = bit32.band(number90 * number92 + bit32.lshift(bit32.band(number90 * bit32.rshift(number89, 16) + number91 * number92, 65535), 16), 4294967295)
								local value65 = bit32.band(value64, 65535)
								number42 = value34 + bit32.band(64492 * value65 + bit32.lshift(bit32.band(64492 * bit32.rshift(value64, 16) + 27898 * value65, 65535), 16), 4294967295)
								local number93 = bit32.band(number33, 4294967295)
								local number94 = bit32.band(number93, 65535)
								local value66 = bit32.band(number94 * 0 + bit32.lshift(bit32.band(number94 * 0 + bit32.rshift(number93, 16) * 0, 65535), 16), 4294967295)
								local value67 = bit32.band(value66, 65535)
								value35 = bit32.band(64492 * value67 + bit32.lshift(bit32.band(64492 * bit32.rshift(value66, 16) + 27898 * value67, 65535), 16), 4294967295)
								local number95 = bit32.band(number40, 4294967295)
								local number96 = bit32.band(number95, 65535)
								local value68 = bit32.band(number96 * 0 + bit32.lshift(bit32.band(number96 * 0 + bit32.rshift(number95, 16) * 0, 65535), 16), 4294967295)
								local value69 = bit32.band(value68, 65535)
								number5 = value33 + number41 + number42 + 0 + value35 + bit32.band(1044 * value69 + bit32.lshift(bit32.band(1044 * bit32.rshift(value68, 16) + 37637 * value69, 65535), 16), 4294967295)
							else
								break
							end
						end

						data5 = data6[4]
						continue
					end

					value12 = argument[6]
					number6 = buffer.len(value12) - 32 - 19
					number7 = 32 + 888971832 % number6
					number8 = 32

					while true do
						number9 = number8 + (number7 + bit32.band(number5, 255) + 1) % number6
						value13 = buffer.readi8(value12, number7)
						value14 = buffer.readu8(value12, number9)
						value15 = bit32.lshift(bit32.band(value14, 255), 3)
						value16 = bit32.band(bit32.bxor(bit32.bxor(54517094, value13) + value15 + 584826193, number7), 2147483647)
						value17 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value13, value14), value16), 2147483647), 205469696)
						buffer.writeu32(value12, number7, value17)
						value18 = bit32.rshift(value16, 8)
						value19 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value14, value18), number7), 2147483647), 327527424)
						buffer.writeu8(value12, number9, value19)
						number5 = value16
						number7 = number8 + (number7 + bit32.band(value16, 63) + 1) % number6
					end
				end
			end

			condition4 = condition2

			if condition3 then
				data5[4] = number10

				if condition3 then
					value22 = data4[number10]
					data6 = { 0, #value22 + 0, nil, data5, 1 }

					while true do
						value23 = data6[5]
						value24 = data6[2]
						number11 = data6[1] + value23
						data6[1] = number11

						if number11 <= value24 then
							number12 = number11
							number13 = bit32.lshift(bit32.band(number5, number12), 1)
							number14 = bit32.band(number13, number5)
							number15 = bit32.bnot(number14)
							local number43 = bit32.band(number13, 4294967295)
							local number44 = bit32.band(number15, 4294967295)
							local number45 = bit32.band(number43, 65535)
							local number46 = bit32.rshift(number43, 16)
							local number47 = bit32.band(number44, 65535)
							local value36 = bit32.band(number45 * number47 + bit32.lshift(bit32.band(number45 * bit32.rshift(number44, 16) + number46 * number47, 65535), 16), 4294967295)
							local value37 = bit32.band(value36, 65535)
							value25 = bit32.band(19474 * value37 + bit32.lshift(bit32.band(19474 * bit32.rshift(value36, 16) + 39469 * value37, 65535), 16), 4294967295)
							local number48 = bit32.band(number13, 4294967295)
							local number49 = bit32.band(number48, 65535)
							number16 = number12 + number5 + value25 + bit32.band(23587 * number49 + bit32.lshift(bit32.band(23587 * bit32.rshift(number48, 16) + 21404 * number49, 65535), 16), 4294967295)
							number17 = bit32.bnot(number5)
							number18 = bit32.bor(number17, 54517094)
							local number50 = bit32.band(number13, 4294967295)
							local number51 = bit32.band(number18, 4294967295)
							local number52 = bit32.band(number50, 65535)
							local number53 = bit32.rshift(number50, 16)
							local number54 = bit32.band(number51, 65535)
							local value38 = bit32.band(number52 * number54 + bit32.lshift(bit32.band(number52 * bit32.rshift(number51, 16) + number53 * number54, 65535), 16), 4294967295)
							local value39 = bit32.band(value38, 65535)
							number19 = 1402756132 + bit32.band(46062 * value39 + bit32.lshift(bit32.band(46062 * bit32.rshift(value38, 16) + 26066 * value39, 65535), 16), 4294967295)
							local number55 = bit32.bnot(number13)
							local number56 = bit32.band(number55, 65535)
							value26 = bit32.band(23586 * number56 + bit32.lshift(bit32.band(23586 * bit32.rshift(number55, 16) + 21404 * number56, 65535), 16), 4294967295)
							local value40 = bit32.bor(54517095, number17)
							local value41 = bit32.band(value40, 65535)
							number20 = number16 + number19 + value26 + bit32.band(2 * value41 + bit32.lshift(bit32.band(2 * bit32.rshift(value40, 16) + 0 * value41, 65535), 16), 4294967295)
							local number57 = bit32.band(number20, 4294967295)
							local number58 = bit32.band(number57, 65535)
							number21 = 327058238 + 3859571462 + bit32.band(25350 * number58 + bit32.lshift(bit32.band(25350 * bit32.rshift(number57, 16) + 58892 * number58, 65535), 16), 4294967295)
							value27 = bit32.bor(2147483647, number20)
							local value42 = bit32.band(272719449, value27)
							local value43 = bit32.band(value42, 65535)
							number22 = number21 + 375472684 + bit32.band(14836 * value43 + bit32.lshift(bit32.band(14836 * bit32.rshift(value42, 16) + 13287 * value43, 65535), 16), 4294967295) + 1761712016
							number23 = bit32.bnot(number20)
							local value44 = bit32.bor(2092966552, number23)
							local value45 = bit32.band(value44, 65535)
							local value46 = bit32.band(number22 - 4564062016 + 28981759 + bit32.band(50689 * value45 + bit32.lshift(bit32.band(50689 * bit32.rshift(value44, 16) + 32325 * value45, 65535), 16), 4294967295) + 1195411303, 4294967295)
							local value47 = bit32.band(value46, 65535)
							number24 = bit32.band(31367 * value47 + bit32.lshift(bit32.band(31367 * bit32.rshift(value46, 16) + 21986 * value47, 65535), 16), 4294967295) + 21801894718
							value22[number12] = bit32.bxor(value22[number12], 327058238)
							number25 = number5 + 584826193
							local number59 = bit32.band(number25, 4294967295)
							local number60 = bit32.band(number59, 65535)
							number26 = bit32.band(43296 * number60 + bit32.lshift(bit32.band(43296 * bit32.rshift(number59, 16) + 12122 * number60, 65535), 16), 4294967295) + 1588941376
							local number61 = bit32.band(number12, 4294967295)
							local number62 = bit32.band(number61, 65535)
							value28 = bit32.band(number62 * 62187 + bit32.lshift(bit32.band(number62 * 8557 + bit32.rshift(number61, 16) * 62187, 65535), 16), 4294967295)
							number27 = bit32.band(number25, number24)
							local value48 = bit32.band(value28, 4294967295)
							local number63 = bit32.band(number27, 4294967295)
							local value49 = bit32.band(value48, 65535)
							local value50 = bit32.rshift(value48, 16)
							local number64 = bit32.band(number63, 65535)
							local value51 = bit32.band(value49 * number64 + bit32.lshift(bit32.band(value49 * bit32.rshift(number63, 16) + value50 * number64, 65535), 16), 4294967295)
							local value52 = bit32.band(value51, 65535)
							value29 = bit32.band(51485 * value52 + bit32.lshift(bit32.band(51485 * bit32.rshift(value51, 16) + 39315 * value52, 65535), 16), 4294967295)
							local value53 = bit32.band(value28, 4294967295)
							local value54 = bit32.band(value53, 65535)
							number28 = number26 + value29 + bit32.band(29245 * value54 + bit32.lshift(bit32.band(29245 * bit32.rshift(value53, 16) + 51438 * value54, 65535), 16), 4294967295)
							number29 = bit32.band(number24, 272719449)
							number30 = bit32.bnot(number27)
							local value55 = bit32.band(value28, 4294967295)
							local number65 = bit32.band(number30, 4294967295)
							local value56 = bit32.band(value55, 65535)
							local value57 = bit32.rshift(value55, 16)
							local number66 = bit32.band(number65, 65535)
							local value58 = bit32.band(value56 * number66 + bit32.lshift(bit32.band(value56 * bit32.rshift(number65, 16) + value57 * number66, 65535), 16), 4294967295)
							local value59 = bit32.band(value58, 65535)
							number31 = number29 + bit32.band(51485 * value59 + bit32.lshift(bit32.band(51485 * bit32.rshift(value58, 16) + 39315 * value59, 65535), 16), 4294967295)
							number32 = bit32.bor(number25, value28)
							local number67 = bit32.bnot(number32)
							local number68 = bit32.band(number67, 65535)
							number33 = number28 + number31 + 3045076956 + bit32.band(21056 * number68 + bit32.lshift(bit32.band(21056 * bit32.rshift(number67, 16) + 24245 * number68, 65535), 16), 4294967295)
							number34 = bit32.band(number33, 2147483647)
							number35 = bit32.bnot(number34)
							local number69 = bit32.band(number35, 4294967295)
							local number70 = bit32.band(number69, 65535)
							value30 = bit32.band(65535 * number70 + bit32.lshift(bit32.band(65535 * bit32.rshift(number69, 16) + 65535 * number70, 65535), 16), 4294967295)
							local number71 = bit32.band(number33, 4294967295)
							local number72 = bit32.band(number71, 65535)
							value31 = bit32.band(46641 * number72 + bit32.lshift(bit32.band(46641 * bit32.rshift(number71, 16) + 36583 * number72, 65535), 16), 4294967295)
							number36 = bit32.bnot(number33)
							local number73 = bit32.band(number36, 4294967295)
							local number74 = bit32.band(number73, 65535)
							number37 = 2397550128 + value30 + value31 + bit32.band(46641 * number74 + bit32.lshift(bit32.band(46641 * bit32.rshift(number73, 16) + 36583 * number74, 65535), 16), 4294967295)
							local number75 = bit32.band(number33, 4294967295)
							local number76 = bit32.band(number75, 65535)
							value32 = bit32.band(1004 * number76 + bit32.lshift(bit32.band(1004 * bit32.rshift(number75, 16) + 49886 * number76, 65535), 16), 4294967295)
							local number77 = bit32.band(number36, 4294967295)
							local number78 = bit32.band(number77, 65535)
							local value60 = bit32.band(number37 - 3269329899 + value30 + value32 + bit32.band(1004 * number78 + bit32.lshift(bit32.band(1004 * bit32.rshift(number77, 16) + 49886 * number78, 65535), 16), 4294967295), 4294967295)
							local value61 = bit32.band(value60, 65535)
							value33 = bit32.band(21218 * value61 + bit32.lshift(bit32.band(21218 * bit32.rshift(value60, 16) + 47856 * value61, 65535), 16), 4294967295)
							local number79 = bit32.band(number33, 4294967295)
							local number80 = bit32.band(number35, 4294967295)
							local number81 = bit32.band(number79, 65535)
							local number82 = bit32.rshift(number79, 16)
							local number83 = bit32.band(number80, 65535)
							local value62 = bit32.band(number81 * number83 + bit32.lshift(bit32.band(number81 * bit32.rshift(number80, 16) + number82 * number83, 65535), 16), 4294967295)
							local value63 = bit32.band(value62, 65535)
							number38 = 2669559910 + bit32.band(64492 * value63 + bit32.lshift(bit32.band(64492 * bit32.rshift(value62, 16) + 27898 * value63, 65535), 16), 4294967295)
							local number84 = bit32.band(number33, 4294967295)
							local number85 = bit32.band(number84, 65535)
							number39 = number35
							number40 = bit32.bor(number33, 2147483647)
							number41 = number38 + bit32.band(16487 * number85 + bit32.lshift(bit32.band(16487 * bit32.rshift(number84, 16) + 40734 * number85, 65535), 16), 4294967295) + 0
							local number86 = bit32.band(number39, 4294967295)
							local number87 = bit32.band(number86, 65535)
							value34 = bit32.band(15442 * number87 + bit32.lshift(bit32.band(15442 * bit32.rshift(number86, 16) + 3097 * number87, 65535), 16), 4294967295)
							local number88 = bit32.band(number39, 4294967295)
							local number89 = bit32.band(number39, 4294967295)
							local number90 = bit32.band(number88, 65535)
							local number91 = bit32.rshift(number88, 16)
							local number92 = bit32.band(number89, 65535)
							local value64 = bit32.band(number90 * number92 + bit32.lshift(bit32.band(number90 * bit32.rshift(number89, 16) + number91 * number92, 65535), 16), 4294967295)
							local value65 = bit32.band(value64, 65535)
							number42 = value34 + bit32.band(64492 * value65 + bit32.lshift(bit32.band(64492 * bit32.rshift(value64, 16) + 27898 * value65, 65535), 16), 4294967295)
							local number93 = bit32.band(number33, 4294967295)
							local number94 = bit32.band(number93, 65535)
							local value66 = bit32.band(number94 * 0 + bit32.lshift(bit32.band(number94 * 0 + bit32.rshift(number93, 16) * 0, 65535), 16), 4294967295)
							local value67 = bit32.band(value66, 65535)
							value35 = bit32.band(64492 * value67 + bit32.lshift(bit32.band(64492 * bit32.rshift(value66, 16) + 27898 * value67, 65535), 16), 4294967295)
							local number95 = bit32.band(number40, 4294967295)
							local number96 = bit32.band(number95, 65535)
							local value68 = bit32.band(number96 * 0 + bit32.lshift(bit32.band(number96 * 0 + bit32.rshift(number95, 16) * 0, 65535), 16), 4294967295)
							local value69 = bit32.band(value68, 65535)
							number5 = value33 + number41 + number42 + 0 + value35 + bit32.band(1044 * value69 + bit32.lshift(bit32.band(1044 * bit32.rshift(value68, 16) + 37637 * value69, 65535), 16), 4294967295)
						else
							break
						end
					end

					data5 = data6[4]
					continue
				end

				value12 = argument[6]
				number6 = buffer.len(value12) - 32 - 19
				number7 = 32 + 888971832 % number6
				number8 = 32

				while true do
					number9 = number8 + (number7 + bit32.band(number5, 255) + 1) % number6
					value13 = buffer.readi8(value12, number7)
					value14 = buffer.readu8(value12, number9)
					value15 = bit32.lshift(bit32.band(value14, 255), 3)
					value16 = bit32.band(bit32.bxor(bit32.bxor(54517094, value13) + value15 + 584826193, number7), 2147483647)
					value17 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value13, value14), value16), 2147483647), 205469696)
					buffer.writeu32(value12, number7, value17)
					value18 = bit32.rshift(value16, 8)
					value19 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value14, value18), number7), 2147483647), 327527424)
					buffer.writeu8(value12, number9, value19)
					number5 = value16
					number7 = number8 + (number7 + bit32.band(value16, 63) + 1) % number6
				end
			else
				condition3 = condition4
				data5[4] = number10

				if condition3 then
					value22 = data4[number10]
					data6 = { 0, #value22 + 0, nil, data5, 1 }

					while true do
						value23 = data6[5]
						value24 = data6[2]
						number11 = data6[1] + value23
						data6[1] = number11

						if number11 <= value24 then
							number12 = number11
							number13 = bit32.lshift(bit32.band(number5, number12), 1)
							number14 = bit32.band(number13, number5)
							number15 = bit32.bnot(number14)
							local number43 = bit32.band(number13, 4294967295)
							local number44 = bit32.band(number15, 4294967295)
							local number45 = bit32.band(number43, 65535)
							local number46 = bit32.rshift(number43, 16)
							local number47 = bit32.band(number44, 65535)
							local value36 = bit32.band(number45 * number47 + bit32.lshift(bit32.band(number45 * bit32.rshift(number44, 16) + number46 * number47, 65535), 16), 4294967295)
							local value37 = bit32.band(value36, 65535)
							value25 = bit32.band(19474 * value37 + bit32.lshift(bit32.band(19474 * bit32.rshift(value36, 16) + 39469 * value37, 65535), 16), 4294967295)
							local number48 = bit32.band(number13, 4294967295)
							local number49 = bit32.band(number48, 65535)
							number16 = number12 + number5 + value25 + bit32.band(23587 * number49 + bit32.lshift(bit32.band(23587 * bit32.rshift(number48, 16) + 21404 * number49, 65535), 16), 4294967295)
							number17 = bit32.bnot(number5)
							number18 = bit32.bor(number17, 54517094)
							local number50 = bit32.band(number13, 4294967295)
							local number51 = bit32.band(number18, 4294967295)
							local number52 = bit32.band(number50, 65535)
							local number53 = bit32.rshift(number50, 16)
							local number54 = bit32.band(number51, 65535)
							local value38 = bit32.band(number52 * number54 + bit32.lshift(bit32.band(number52 * bit32.rshift(number51, 16) + number53 * number54, 65535), 16), 4294967295)
							local value39 = bit32.band(value38, 65535)
							number19 = 1402756132 + bit32.band(46062 * value39 + bit32.lshift(bit32.band(46062 * bit32.rshift(value38, 16) + 26066 * value39, 65535), 16), 4294967295)
							local number55 = bit32.bnot(number13)
							local number56 = bit32.band(number55, 65535)
							value26 = bit32.band(23586 * number56 + bit32.lshift(bit32.band(23586 * bit32.rshift(number55, 16) + 21404 * number56, 65535), 16), 4294967295)
							local value40 = bit32.bor(54517095, number17)
							local value41 = bit32.band(value40, 65535)
							number20 = number16 + number19 + value26 + bit32.band(2 * value41 + bit32.lshift(bit32.band(2 * bit32.rshift(value40, 16) + 0 * value41, 65535), 16), 4294967295)
							local number57 = bit32.band(number20, 4294967295)
							local number58 = bit32.band(number57, 65535)
							number21 = 327058238 + 3859571462 + bit32.band(25350 * number58 + bit32.lshift(bit32.band(25350 * bit32.rshift(number57, 16) + 58892 * number58, 65535), 16), 4294967295)
							value27 = bit32.bor(2147483647, number20)
							local value42 = bit32.band(272719449, value27)
							local value43 = bit32.band(value42, 65535)
							number22 = number21 + 375472684 + bit32.band(14836 * value43 + bit32.lshift(bit32.band(14836 * bit32.rshift(value42, 16) + 13287 * value43, 65535), 16), 4294967295) + 1761712016
							number23 = bit32.bnot(number20)
							local value44 = bit32.bor(2092966552, number23)
							local value45 = bit32.band(value44, 65535)
							local value46 = bit32.band(number22 - 4564062016 + 28981759 + bit32.band(50689 * value45 + bit32.lshift(bit32.band(50689 * bit32.rshift(value44, 16) + 32325 * value45, 65535), 16), 4294967295) + 1195411303, 4294967295)
							local value47 = bit32.band(value46, 65535)
							number24 = bit32.band(31367 * value47 + bit32.lshift(bit32.band(31367 * bit32.rshift(value46, 16) + 21986 * value47, 65535), 16), 4294967295) + 21801894718
							value22[number12] = bit32.bxor(value22[number12], 327058238)
							number25 = number5 + 584826193
							local number59 = bit32.band(number25, 4294967295)
							local number60 = bit32.band(number59, 65535)
							number26 = bit32.band(43296 * number60 + bit32.lshift(bit32.band(43296 * bit32.rshift(number59, 16) + 12122 * number60, 65535), 16), 4294967295) + 1588941376
							local number61 = bit32.band(number12, 4294967295)
							local number62 = bit32.band(number61, 65535)
							value28 = bit32.band(number62 * 62187 + bit32.lshift(bit32.band(number62 * 8557 + bit32.rshift(number61, 16) * 62187, 65535), 16), 4294967295)
							number27 = bit32.band(number25, number24)
							local value48 = bit32.band(value28, 4294967295)
							local number63 = bit32.band(number27, 4294967295)
							local value49 = bit32.band(value48, 65535)
							local value50 = bit32.rshift(value48, 16)
							local number64 = bit32.band(number63, 65535)
							local value51 = bit32.band(value49 * number64 + bit32.lshift(bit32.band(value49 * bit32.rshift(number63, 16) + value50 * number64, 65535), 16), 4294967295)
							local value52 = bit32.band(value51, 65535)
							value29 = bit32.band(51485 * value52 + bit32.lshift(bit32.band(51485 * bit32.rshift(value51, 16) + 39315 * value52, 65535), 16), 4294967295)
							local value53 = bit32.band(value28, 4294967295)
							local value54 = bit32.band(value53, 65535)
							number28 = number26 + value29 + bit32.band(29245 * value54 + bit32.lshift(bit32.band(29245 * bit32.rshift(value53, 16) + 51438 * value54, 65535), 16), 4294967295)
							number29 = bit32.band(number24, 272719449)
							number30 = bit32.bnot(number27)
							local value55 = bit32.band(value28, 4294967295)
							local number65 = bit32.band(number30, 4294967295)
							local value56 = bit32.band(value55, 65535)
							local value57 = bit32.rshift(value55, 16)
							local number66 = bit32.band(number65, 65535)
							local value58 = bit32.band(value56 * number66 + bit32.lshift(bit32.band(value56 * bit32.rshift(number65, 16) + value57 * number66, 65535), 16), 4294967295)
							local value59 = bit32.band(value58, 65535)
							number31 = number29 + bit32.band(51485 * value59 + bit32.lshift(bit32.band(51485 * bit32.rshift(value58, 16) + 39315 * value59, 65535), 16), 4294967295)
							number32 = bit32.bor(number25, value28)
							local number67 = bit32.bnot(number32)
							local number68 = bit32.band(number67, 65535)
							number33 = number28 + number31 + 3045076956 + bit32.band(21056 * number68 + bit32.lshift(bit32.band(21056 * bit32.rshift(number67, 16) + 24245 * number68, 65535), 16), 4294967295)
							number34 = bit32.band(number33, 2147483647)
							number35 = bit32.bnot(number34)
							local number69 = bit32.band(number35, 4294967295)
							local number70 = bit32.band(number69, 65535)
							value30 = bit32.band(65535 * number70 + bit32.lshift(bit32.band(65535 * bit32.rshift(number69, 16) + 65535 * number70, 65535), 16), 4294967295)
							local number71 = bit32.band(number33, 4294967295)
							local number72 = bit32.band(number71, 65535)
							value31 = bit32.band(46641 * number72 + bit32.lshift(bit32.band(46641 * bit32.rshift(number71, 16) + 36583 * number72, 65535), 16), 4294967295)
							number36 = bit32.bnot(number33)
							local number73 = bit32.band(number36, 4294967295)
							local number74 = bit32.band(number73, 65535)
							number37 = 2397550128 + value30 + value31 + bit32.band(46641 * number74 + bit32.lshift(bit32.band(46641 * bit32.rshift(number73, 16) + 36583 * number74, 65535), 16), 4294967295)
							local number75 = bit32.band(number33, 4294967295)
							local number76 = bit32.band(number75, 65535)
							value32 = bit32.band(1004 * number76 + bit32.lshift(bit32.band(1004 * bit32.rshift(number75, 16) + 49886 * number76, 65535), 16), 4294967295)
							local number77 = bit32.band(number36, 4294967295)
							local number78 = bit32.band(number77, 65535)
							local value60 = bit32.band(number37 - 3269329899 + value30 + value32 + bit32.band(1004 * number78 + bit32.lshift(bit32.band(1004 * bit32.rshift(number77, 16) + 49886 * number78, 65535), 16), 4294967295), 4294967295)
							local value61 = bit32.band(value60, 65535)
							value33 = bit32.band(21218 * value61 + bit32.lshift(bit32.band(21218 * bit32.rshift(value60, 16) + 47856 * value61, 65535), 16), 4294967295)
							local number79 = bit32.band(number33, 4294967295)
							local number80 = bit32.band(number35, 4294967295)
							local number81 = bit32.band(number79, 65535)
							local number82 = bit32.rshift(number79, 16)
							local number83 = bit32.band(number80, 65535)
							local value62 = bit32.band(number81 * number83 + bit32.lshift(bit32.band(number81 * bit32.rshift(number80, 16) + number82 * number83, 65535), 16), 4294967295)
							local value63 = bit32.band(value62, 65535)
							number38 = 2669559910 + bit32.band(64492 * value63 + bit32.lshift(bit32.band(64492 * bit32.rshift(value62, 16) + 27898 * value63, 65535), 16), 4294967295)
							local number84 = bit32.band(number33, 4294967295)
							local number85 = bit32.band(number84, 65535)
							number39 = number35
							number40 = bit32.bor(number33, 2147483647)
							number41 = number38 + bit32.band(16487 * number85 + bit32.lshift(bit32.band(16487 * bit32.rshift(number84, 16) + 40734 * number85, 65535), 16), 4294967295) + 0
							local number86 = bit32.band(number39, 4294967295)
							local number87 = bit32.band(number86, 65535)
							value34 = bit32.band(15442 * number87 + bit32.lshift(bit32.band(15442 * bit32.rshift(number86, 16) + 3097 * number87, 65535), 16), 4294967295)
							local number88 = bit32.band(number39, 4294967295)
							local number89 = bit32.band(number39, 4294967295)
							local number90 = bit32.band(number88, 65535)
							local number91 = bit32.rshift(number88, 16)
							local number92 = bit32.band(number89, 65535)
							local value64 = bit32.band(number90 * number92 + bit32.lshift(bit32.band(number90 * bit32.rshift(number89, 16) + number91 * number92, 65535), 16), 4294967295)
							local value65 = bit32.band(value64, 65535)
							number42 = value34 + bit32.band(64492 * value65 + bit32.lshift(bit32.band(64492 * bit32.rshift(value64, 16) + 27898 * value65, 65535), 16), 4294967295)
							local number93 = bit32.band(number33, 4294967295)
							local number94 = bit32.band(number93, 65535)
							local value66 = bit32.band(number94 * 0 + bit32.lshift(bit32.band(number94 * 0 + bit32.rshift(number93, 16) * 0, 65535), 16), 4294967295)
							local value67 = bit32.band(value66, 65535)
							value35 = bit32.band(64492 * value67 + bit32.lshift(bit32.band(64492 * bit32.rshift(value66, 16) + 27898 * value67, 65535), 16), 4294967295)
							local number95 = bit32.band(number40, 4294967295)
							local number96 = bit32.band(number95, 65535)
							local value68 = bit32.band(number96 * 0 + bit32.lshift(bit32.band(number96 * 0 + bit32.rshift(number95, 16) * 0, 65535), 16), 4294967295)
							local value69 = bit32.band(value68, 65535)
							number5 = value33 + number41 + number42 + 0 + value35 + bit32.band(1044 * value69 + bit32.lshift(bit32.band(1044 * bit32.rshift(value68, 16) + 37637 * value69, 65535), 16), 4294967295)
						else
							break
						end
					end

					data5 = data6[4]
					continue
				end

				value12 = argument[6]
				number6 = buffer.len(value12) - 32 - 19
				number7 = 32 + 888971832 % number6
				number8 = 32

				while true do
					number9 = number8 + (number7 + bit32.band(number5, 255) + 1) % number6
					value13 = buffer.readi8(value12, number7)
					value14 = buffer.readu8(value12, number9)
					value15 = bit32.lshift(bit32.band(value14, 255), 3)
					value16 = bit32.band(bit32.bxor(bit32.bxor(54517094, value13) + value15 + 584826193, number7), 2147483647)
					value17 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value13, value14), value16), 2147483647), 205469696)
					buffer.writeu32(value12, number7, value17)
					value18 = bit32.rshift(value16, 8)
					value19 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value14, value18), number7), 2147483647), 327527424)
					buffer.writeu8(value12, number9, value19)
					number5 = value16
					number7 = number8 + (number7 + bit32.band(value16, 63) + 1) % number6
				end
			end
		end

		value12 = argument[6]
		number6 = buffer.len(value12) - 32 - 19
		number7 = 32 + 888971832 % number6
		number8 = 32

		while true do
			number9 = number8 + (number7 + bit32.band(number5, 255) + 1) % number6
			value13 = buffer.readi8(value12, number7)
			value14 = buffer.readu8(value12, number9)
			value15 = bit32.lshift(bit32.band(value14, 255), 3)
			value16 = bit32.band(bit32.bxor(bit32.bxor(54517094, value13) + value15 + 584826193, number7), 2147483647)
			value17 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value13, value14), value16), 2147483647), 205469696)
			buffer.writeu32(value12, number7, value17)
			value18 = bit32.rshift(value16, 8)
			value19 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value14, value18), number7), 2147483647), 327527424)
			buffer.writeu8(value12, number9, value19)
			number5 = value16
			number7 = number8 + (number7 + bit32.band(value16, 63) + 1) % number6
		end
	end

	callback6(nil, nil, nil, nil, nil)
	local number5 = 132035500
	local number6 = 779964

	while true do
		number5 += number6
	end
end

local function callback6()
	callback4(372868618, 4)
	number4 = 43031001
	callback5()
end

local data4 = { [false] = true }
data4[true] = false
local data5 = {}

local function callback7(argument, argument2)
	if not nil and nil then
		if not nil and nil then
			return true
		end
		return false
	end

	data5[argument] = true
	local value12 = data5[argument2]
	data5[argument] = nil
	return value12
end

local function callback8(argument)
	if not nil then
		callback4(372868618, 4)
		number4 = 43031001
		callback5()
	end

	local valueType = type(argument)
	callback7("table", valueType)

	if not nil then
		callback4(372868618, 4)
		number4 = 43031001
		callback5()
	end

	local value12 = getmetatable(argument)
	callback7(nil, value12)

	if not nil then
		callback4(372868618, 4)
		number4 = 43031001
		callback5()
	end

	pcall(setmetatable, argument, nil)
end

local function callback9(argument, ...)
	table.pack(string.byte(argument, 1, -1))
	local data6 = { nil, 1, 0, select("#", table.unpack(t183_23_1, 1, t183_23_1.n)) + 0, nil }

	while true do
		local value12 = data6[2]
		local value13 = data6[4]
		local number5 = data6[3] + value12
		data6[3] = number5

		if number5 <= value13 then
		else
			break
		end
	end

	return 3926377405
end

local function callback10(argument, argument2, argument3)
	for k in argument, nil, nil do
		argument3[callback9(k, 51052561)] = nil
	end

	for k in argument3, nil, nil do
		callback4(372868618, 4)
		number4 = 43031001
		callback5()
	end
end

local new = value5.new
local new2 = value6.new
local new3 = value7.new
local color3New = Color3.new
local rectNew = Rect.new
local uDim2New = UDim2.new
local uDimNew = UDim.new
local new4 = Path2DControlPoint.new
local data6 = { what = "C", currentline = -1, short_src = "[C]" }
local text = "linedefined"
local callback11 = callback8
local callback12 = callback10
data6[text] = -1
data6.isvararg = true
data6.namewhat = ""
data6.nparams = 0
data6.lastlinedefined = -1
data6.source = "=[C]"

local function callback13()
end

callback13(getmetatable, "getmetatable")
callback13(setmetatable, "setmetatable")
callback13(tonumber, "tonumber")
callback13(tostring, "tostring")
callback13(rawset, "rawset")
callback13(rawget, "rawget")
callback13(select, "select")
callback13(xpcall, "xpcall")
callback13(assert, "assert")
callback13(error, "error")
callback13(pcall, "pcall")
callback13(type, "type")
callback13(next, "next")
callback13(getfenv, "getfenv")
callback13(setfenv, "setfenv")
callback13(typeof, "typeof")
callback13(string.gmatch, "gmatch")
callback13(string.format, "format")
callback13(string.match, "match")
callback13(string.find, "find")
callback13(string.char, "char")
callback13(string.byte, "byte")
callback13(string.gsub, "gsub")
callback13(string.sub, "sub")
callback13(string.rep, "rep")
callback13(string.unpack, "unpack")
callback13(string.pack, "pack")
callback13(table.concat, "concat")
callback13(table.insert, "insert")
callback13(table.pack, "pack")
callback13(table.clear, "clear")
callback13(table.create, "create")
callback13(table.move, "move")
callback13(bit32.bor, "bor")
callback13(bit32.bnot, "bnot")
callback13(bit32.bxor, "bxor")
callback13(bit32.band, "band")
callback13(bit32.lshift, "lshift")
callback13(bit32.rshift, "rshift")
callback13(bit32.rrotate, "rrotate")
callback13(bit32.lrotate, "lrotate")
callback13(bit32.countlz, "countlz")
callback13(bit32.countrz, "countrz")
callback13(buffer.len, "len")
callback13(buffer.fill, "fill")
callback13(buffer.copy, "copy")
callback13(buffer.create, "create")
callback13(buffer.tostring, "tostring")
callback13(buffer.fromstring, "fromstring")
callback13(buffer.readstring, "readstring")
callback13(buffer.writestring, "writestring")
callback13(buffer.readi8, "readi8")
callback13(buffer.readu8, "readu8")
callback13(buffer.readi16, "readi16")
callback13(buffer.readu16, "readu16")
callback13(buffer.readi32, "readi32")
callback13(buffer.readu32, "readu32")
callback13(buffer.readf32, "readf32")
callback13(buffer.readf64, "readf64")
callback13(buffer.writei8, "writei8")
callback13(buffer.writeu8, "writeu8")
local number5 = 3848217230
callback13(buffer.writei16, "writei16")
callback13(buffer.writeu16, "writeu16")
callback13(buffer.writei32, "writei32")
callback13(buffer.writeu32, "writeu32")
callback13(buffer.writef32, "writef32")
callback13(buffer.writef64, "writef64")
callback13(buffer.readbits, "readbits")
callback13(buffer.writebits, "writebits")
callback13(coroutine.isyieldable, "isyieldable")
callback13(coroutine.running, "running")
callback13(coroutine.create, "create")
callback13(coroutine.status, "status")
callback13(coroutine.yield, "yield")
callback13(coroutine.close, "close")
callback13(coroutine.resume, "resume")
callback13(coroutine.wrap, "wrap")
callback13(cancel, "cancel")
callback13(spawn, "spawn")
callback13(defer, "defer")
callback13(delay, "delay")
callback13(wait, "wait")
callback13(unpack, "unpack")
callback13(info, "info")
callback13(traceback, "traceback")
callback13(value10)
local value12 = pcall
local value13 = xpcall
local number6 = 147701733
local number7 = 109385640
new3(0.56970392783537138, 0.7177542450144142, 0.50622845078979106)
local number8 = 472605665
new("Folder")
local ScreenGui = new("ScreenGui")
local Frame = new("Frame")
local Path2D = new("Path2D")
Frame.Parent = ScreenGui
Path2D.Parent = Frame
vector.create(0.07370192571826828, 0.34066822994289736, 0.14330319227652777)

local function callback14()
	assert(0.86649202372180822)
	getfenv(0)
	tostring(0.55580137640567118)
	rawequal(scratch, scratch)
	local data7 = {}
	next(data7)
	pairs(data7)(data7)
	ipairs(data7)(data7, 1)
	rawlen(data7)
	rawget(data7, 0.83036873334365979)
	rawset(data7, 0.23222585532335926, 0.20233684500220273)
	getmetatable(data7)
	setmetatable(data7, data7)
	setmetatable(data7, nil)
	info(2291, "slnaf")
	local buf = buffer.create(93)
	buffer.len(buf)
	buffer.fromstring("")
	buffer.tostring(buf)
	buffer.readi8(buf, 16)
	buffer.readu8(buf, 30)
	buffer.readi16(buf, 26)
	buffer.readu16(buf, 5)
	buffer.readi32(buf, 19)
	buffer.readu32(buf, 1)
	buffer.readf32(buf, 21)
	buffer.readf64(buf, 10)
	buffer.writei8(buf, 7, -41)
	buffer.writeu8(buf, 4, 160)
	buffer.writei16(buf, 17, -13304)
	buffer.writeu16(buf, 20, 22536)
	buffer.writei32(buf, 1, -1007158540)
	buffer.writeu32(buf, 2, 882715381)
	buffer.writef32(buf, 31, 5001)
	buffer.writef64(buf, 10, 33849)
	buffer.readstring(buf, 3, 15)
	buffer.writestring(buf, 5, "Luraph", 5)
	buffer.readbits(buf, 130, 21)
	buffer.writebits(buf, 166, 2, 21014419)
	buffer.copy(buf, 32, buf, 0, 16)
	buffer.fill(buf, 23, 70, 10)
	local value14 = value9.new()
	value14:NextInteger(45, 248)
	value14:NextNumber(35, 980)
	value14:NextUnitVector()
	value14:NextNumber()
	value14:Shuffle({})
	value14:Clone()
	local number9 = Vector3.new(0.8674313, 0.86681885, 0.26933977) + Vector3.new(0.38818195, 0.7251892, 0.52870774)
	local vector_ = Vector3.new(0.8674313, 0.86681885, 0.26933977)
	local vector_2 = Vector3.new(0.38818195, 0.7251892, 0.52870774)
	local vector_3 = Vector3.new(1, 0, 0)
	local vector_4 = Vector3.new(0, 1, 0)
	local value15 = value8.new()
	local vector_5 = value8.new(vector_)
	value8.Angles(0.79328950042823942, 0.38704401201925887, 0.96996322323574924)
	local xyz = Enum.RotationOrder.XYZ
	value8.new(vector_, number9)
	value8.new(vector_.X, vector_.Y, vector_.Z)
	value8.new(vector_.X, vector_.Y, vector_.Z, 0, 0, 0, 1)
	value8.new(vector_.X, vector_.Y, vector_.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	value8.lookAt(vector_, number9, vector_4)
	value8.lookAlong(vector_, vector_2, vector_4)
	value8.fromEulerAnglesXYZ(0.79328950042823942, 0.38704401201925887, 0.96996322323574924)
	value8.fromEulerAnglesYXZ(0.79328950042823942, 0.38704401201925887, 0.96996322323574924)
	value8.fromOrientation(0.79328950042823942, 0.38704401201925887, 0.96996322323574924)
	value8.fromAxisAngle(vector_2.Unit, 0.79328950042823942)
	value8.fromRotationBetweenVectors(vector_3, vector_4)
	value8.fromMatrix(vector_, vector_3, vector_4, Vector3.new(0, 0, 1))
	value8.fromEulerAngles(0.79328950042823942, 0.38704401201925887, 0.96996322323574924, xyz)
	value15:Inverse()
	value15:Orthonormalize()
	value15:Lerp(vector_5, 0.33319114787106874)
	value15:ToWorldSpace(vector_5)
	value15:ToObjectSpace(vector_5)
	value15:ToEulerAnglesXYZ()
	value15:ToEulerAnglesYXZ()
	value15:PointToWorldSpace(vector_)
	value15:PointToObjectSpace(vector_)
	value15:VectorToWorldSpace(vector_2)
	value15:VectorToObjectSpace(vector_2)
	value15:ToEulerAngles(xyz)
	value15:GetComponents()
	value15:ToOrientation()
	value15:ToAxisAngle()
	value15:FuzzyEq(vector_5)
	value15:AngleBetween(vector_5)
	local vector_6 = Vector3.new(0.49828404, 0.9437861, 0.78076863)
	local vector_7 = Vector3.new(0.31593144, 0.20840542, 0.2626367)
	value6.FromAxis(Enum.Axis.X)
	value6.FromNormalId(Enum.NormalId.Top)
	vector_6:Abs()
	vector_6:Ceil()
	vector_6:Floor()
	vector_6:Sign()
	vector_6:Dot(vector_7)
	vector_6:Cross(vector_7)
	vector_6:Angle(vector_7)
	vector_6:FuzzyEq(vector_7)
	vector_6:Lerp(vector_7, 0.5802546794961243)
	vector_6:Max(vector_7)
	vector_6:Min(vector_7)
	local vector2 = Vector2.new(0.22515740990638733, 0.64927858114242554)
	local vector22 = Vector2.new(0.93112492561340332, 0.29359400272369385)
	vector2:Abs()
	vector2:Ceil()
	vector2:Floor()
	vector2:Sign()
	vector2:Dot(vector22)
	vector2:Cross(vector22)
	vector2:Angle(vector22)
	vector2:FuzzyEq(vector22)
	vector2:Lerp(vector22, 0.64895705977598)
	vector2:Max(vector22)
	vector2:Min(vector22)
	uDimNew(-0.25769342060672118, -98)
	uDimNew(-0.68111398506959042, -104)
	uDim2New(0.89317547613100179, -32, -0.9289331167444872, 87):Lerp(uDim2New(-0.3859175566900499, 60, -0.093353812555120541, -3), 0.15600796817744589)
	local Allow = Enum.AccessModifierType:FromName("Allow")
	local enumType = Allow.EnumType
	enumType:GetEnumItems()
	enumType:FromName(Allow.Name)
	enumType:FromValue(Allow.Value)
	local value16 = uDim2New(0.07719390615672328, 3, 0.21000489770270028, 59)
	local value17 = uDim2New(0.017163361164568458, 24, 0.059917917968274143, 29)
	local value18 = uDim2New(0.81556951795012611, 185, 0.81958095395152064, 178)
	local value19 = new4(value16, value17, value17)
	new4(value16:Lerp(value18, 0.55103166017453975))
	local context = {}
	local value20 = new4(value18)
	context.value = value19
	context.value2 = value20
	local value21 = utf8.char(46, 766, 83725)
	utf8.codepoint(value21, 1, #value21)
	utf8.len(value21)
	utf8.offset(value21, 2)
	utf8.offset(value21, -3)
	local value22, value23, value24 = utf8.codes(value21)
	value22(value23, value24)
	value22(value23, utf8.offset(value21, 2))
	local value25 = utf8.char(119, 816)
	utf8.nfcnormalize(value25)
	utf8.nfdnormalize(value21)
	utf8.graphemes(value25, 1, #value25)()
	number7 = (1 * number7 + 39391802) % 268435456
	number6 = (287503 * number6 + 111439069) % 268435456
end

local callback15 = coroutine.wrap(callback14)
local data7 = {}
local number9 = 0

local function callback16()
	number9 += 1

	if nil then
		setmetatable({}, { __index = callback6 })
		callback4(372868618, 4)
		number4 = 43031001
		callback5()
		return
	end

	if nil then
		callback15()
	end

	number7 = (1 * number7 + 11083120) % 268435456
	number6 = (327527 * number6 + 64474745) % 268435456
end

setmetatable(data7, { __index = callback16, __newindex = callback16 })
local ok, response = pcall(callback16)
local response2 = response

if data4[not ok] then
	callback3(12, number5 + 595343517)
else
	callback4(372868618, 4)
	number4 = 43031001
	callback5()
end

if data4[not response2] then
	callback4(372868618, 4)
	number4 = 43031001
	callback5()
else
	callback3(81, 148593451)
end

local value14 = luraph_runtime1(table.pack(number6, number7), nil)
local condition = false
local value15
local value16 = luraph_runtime3(table.pack(value12, value15), nil)

local function callback17()
	number6 = (960585 * number6 + 108601139) % 268435456
	number7 = (1 * number7 + 129196086) % 268435456
end

local value17 = luraph_runtime4(table.pack(number7, number6), nil)

local function callback18()
	number7 = number7 - number7 % 2 + 1
	number6 = (502183 * number6 + 4932131) % 268435456
	number6 = (381055 * number6 + 150663887) % 268435456
end

local number10 = 0

callback = function()
	number10 += 1

	if number10 ~= 2499 then
		if number10 == 2498 then
			callback17()
		end

		number6 = (825767 * number6 + 76028495) % 268435456
		number7 = (1 * number7 + 199303012) % 268435456
		callback()
		return
	end

	value14()
	number6 = (633301 * number6 + 118839319) % 268435456
	number7 = (1 * number7 + 227384412) % 268435456
end

callback2 = function(argument)
	if argument ~= 19998 then
		if argument ~= 19997 then
			if argument == 13996 then
				callback14(argument)
			end
		else
			callback14(argument)
		end

		callback2(argument + 1)

		if argument == 19997 then
			if not value13(value14, value17) then
				number7 = number7 - number7 % 2 + 1
				number6 = (109841 * number6 + 221830637) % 268435456
				return
			end

			callback17()

			if not value12(value14) then
				number7 = number7 - number7 % 2 + 1
				number6 = (966177 * number6 + 48847249) % 268435456
				return
			end

			if value13(callback18, callback) then
				number7 = number7 - number7 % 2 + 1
				number6 = (661433 * number6 + 251353109) % 268435456
				return
			end

			value16()

			if condition then
				number7 = number7 - number7 % 2 + 1
				number6 = (82419 * number6 + 130934173) % 268435456
				number6 = (993143 * number6 + 258571403) % 268435456
				return
			end

			number7 = (1 * number7 + 182108670) % 268435456
			number6 = (661321 * number6 + 188621803) % 268435456
		end

		number7 = (1 * number7 + 39749792) % 268435456
		number6 = (573121 * number6 + 248614455) % 268435456
		return
	end

	value14()
	number6 = (96561 * number6 + 140826197) % 268435456
	number7 = (1 * number7 + 2468882) % 268435456
end

local number11 = number5 // 248
coroutine.resume(coroutine.create(callback2), 1)
ScreenGui:Destroy()
local number12 = number8 + 415518735
callback4(number6, 4)
callback4(number7, 4)
local number13 = number4
local number14 = 481860382
local number15 = 1863024894

local value18 = coroutine.wrap(function()
	coroutine.yield(number14)
	coroutine.yield(number15)
	callback4(372868618, 4)
	number4 = 43031001
	callback5()
end)

if callback7(value18(), number14) then
	callback3(1, 148593451)
	number4 = number13
else
	callback4(372868618, 4)
	number4 = 43031001
	callback5()
end

if callback7(value18(), number15) then
	callback3(37, number11 + 133076447)
else
	callback4(372868618, 4)
	number4 = 43031001
	callback5()
end

local thread = coroutine.create(wait)
coroutine.resume(thread, 0)
local number16 = 2681509769
local thread2 = coroutine.status(thread)
callback7("suspended", thread2)

if nil then
	pcall(coroutine.close, thread)
	local value19 = nil
	local condition2 = false

	spawn(function()
		value19 = coroutine.running()
		wait(0)
		condition2 = true
		callback4(372868618, 4)
		number4 = 43031001
		callback5()
	end)

	local condition3 = not pcall(coroutine.close, value19)

	if not nil then
		callback4(372868618, 4)
		number4 = 43031001
		callback5()
	end

	local close = coroutine.close

	local value20 = spawn(function()
		coroutine.yield()
		callback4(372868618, 4)
		number4 = 43031001
		callback5()
	end)

	close(value20)
	local close2 = coroutine.close
	local value21 = defer(callback6)
	close2(value21)
	local close3 = coroutine.close
	local value22 = delay(616, callback6)
	close3(value22)

	local function callback19()
	end

	callback19(getfenv, -4747)
	callback19(setfenv, -31460)
	callback19(getmetatable)
	callback19(setmetatable)
	callback19(tonumber)
	callback19(tostring)
	callback19(rawset)
	local number17 = bit32.band(number11, number16)
	callback19(rawget)
	callback19(assert)
	callback19(type)
	callback19(next)
	callback19(typeof)
	callback19(string.gmatch)
	callback19(string.format)
	local number18 = number12 + number17
	callback19(string.match)
	callback19(string.find)
	callback19(string.byte)
	callback19(string.gsub)
	callback19(string.sub)
	callback19(string.rep)
	callback19(string.char, nil)
	callback19(string.unpack)
	callback19(string.pack)
	callback19(table.concat)
	callback19(table.insert)
	callback19(table.clear)
	callback19(table.create, nil)
	callback19(table.move)
	callback19(bit32.bor, nil)
	callback19(bit32.bxor, nil)
	callback19(bit32.band, nil)
	callback19(bit32.bnot)
	callback19(bit32.lshift)
	callback19(bit32.rshift)
	callback19(bit32.rrotate)
	callback19(bit32.lrotate)
	callback19(bit32.countlz)
	callback19(bit32.countrz)
	callback19(buffer.len)
	callback19(buffer.fill)
	local number19 = number17 - number16
	callback19(buffer.copy)
	callback19(buffer.create, nil)
	callback19(buffer.tostring)
	callback19(buffer.fromstring)
	callback19(buffer.readstring)
	callback19(buffer.writestring)
	callback19(buffer.readi8)
	callback19(buffer.readu8)
	callback19(buffer.readi16)
	callback19(buffer.readu16)
	callback19(buffer.readi32)
	callback19(buffer.readu32)
	callback19(buffer.readf32)
	callback19(buffer.readf64)
	callback19(buffer.writei8)
	callback19(buffer.writeu8)
	callback19(buffer.writei16)
	callback19(buffer.writeu16)
	callback19(buffer.writei32)
	callback19(buffer.writeu32)
	callback19(buffer.writef32)
	callback19(buffer.writef64)
	callback19(buffer.readbits)
	callback19(buffer.writebits)
	callback19(coroutine.create)
	callback19(coroutine.status)
	callback19(coroutine.close)
	callback19(coroutine.resume)
	callback19(coroutine.wrap)
	callback19(cancel)
	callback19(spawn)
	callback19(defer)
	callback19(delay)
	callback19(wait, {})
	callback19(unpack)
	callback19(info)
	callback19(value10)
	callback13(new, "new")
	callback19(new, nil)
	callback13(new2, "new")
	callback13(new3, "new")
	callback13(color3New, "new")
	callback13(rectNew, "new")
	local fromAxis = value6.FromAxis
	local number20 = 2899954607
	callback13(fromAxis, "FromAxis")
	callback19(fromAxis, nil)
	local vector_ = fromAxis(Enum.Axis.Y)
	local bottom = value6.FromNormalId(Enum.NormalId.Bottom)
	local valueType = type(vector_)
	local valueType2 = type(bottom)

	if valueType == "vector" then
		callback3(222, 148593451)
		local number21 = valueType2 == "vector" and 111 or 129
		callback3(number21, 148593451)
		local y = bottom.Y
		callback4(vector_.Y * 953604573, 4)
		local number22 = number18 + number20
		callback4(y * -1 * 741150457, 4)

		if callback7("vector", valueType) then
			callback3(229, number19 - 1477743188)
			number4 = number13

			if callback7("vector", valueType2) then
				callback3(243, 148593451)
			else
				callback4(372868618, 4)
				number4 = 43031001
				callback5()
			end

			callback3(vector_.X == 0 and 15 or 161, 148593451)
			callback3(vector_.Y == 1 and 129 or 72, number19 - 1477743188)
			callback3(vector_.Z == 0 and 184 or 200, number20 - 2751361156)
			callback3(bottom.X == 0 and 165 or 240, 148593451)
			callback3(bottom.Y == -1 and 168 or 210, number19 + 2817224108)
						local number23 = bottom.Z == 0 and 13 or 156
			callback3(number23, number20 + 1543606140)
						local number24 = bit32.bor(number19, number20)
			callback13(uDim2New, "new")
			callback13(uDimNew, "new")
			callback12(utf8, 218723579, { [1986724197] = 1631743329, [3912424273] = 733687465, [2204466326] = 1503519080 })
						local data8 = {}
			local value23 = utf8.nfcnormalize("뫂춥퉐릻켙냖")

			do
				local values = table.pack(value23:byte(1, -1))
				table.move(values, 1, values.n, 1, data8)
			end

						local data9 = {}
			local number25
			local value24 = utf8.nfdnormalize("뿇듧죝떠ō뵗덑")
			number25 = number20 - number22

			do
				local values = table.pack(value24:byte(1, -1))
				table.move(values, 1, values.n, 1, data9)
			end

			local value25, value26, value27, value28, value29, value30, value31, value32, value33, value34
			local value35, number26, value36, data10, value37

			do
				local value38 = data9[22]
				callback3(value38, 148593451)
				local value39 = data8[16]
				callback3(value39, number24 + 467364652)
				value25 = data9[12]
				callback3(value25, 148593451)
				value26 = data8[17]
				callback3(value26, 148593451)
				value27 = data9[16]
				callback3(value27, number24 + 467364652)
				value28 = data9[35]
				callback3(value28, number25 + 1049596963)
				value29 = data9[39]
				callback3(value29, 148593451)
				value30 = data9[18]
				callback3(value30, number24 - 3827602644)
				callback3(data8[10], 148593451)
				value31 = data9[17]
				callback3(value31, 148593451)
				callback3(data9[33], number24 - 3827602644)
				value32 = data9[8]
				callback3(value32, number25 - 3245370333)
				callback3(data8[15], 148593451)
				callback3(data9[15], number24 - 3827602644)
				value33 = data9[23]
				callback3(value33, 148593451)
				callback3(data8[18], 148593451)
				value34 = data9[24]
				value35 = value38
				callback3(value34, value35 - 4146374070)
				callback3(data9[13], number25 + 1049596963)
				callback3(data8[1], 148593451)
				local value40 = data9[2]
				number26 = number22 + value39
				callback3(value40, 148593451)
				local value41 = data8[11]
				callback3(value41, number25 + 1049596963)
				callback3(data9[38], 148593451)
				value36 = data9[5]
				callback3(value36, value35 + 148593226)
				local value42 = data8[6]
				data10 = value40
				value37 = value41
				callback3(value42, number25 + 1049596963)
			end

						local value38 = data9[29]
			callback3(value38, 148593451)
			callback3(data8[3], value35 - 4146374070)
			callback3(data9[36], number25 + 1049596963)
			callback3(data9[32], 148593451)
						local value39 = data9[4]
			callback3(value39, value35 - 4146374070)
			callback3(data9[52], number25 + 1049596963)
			callback3(data9[40], 148593451)
						local value40 = data8[8]
			callback3(value40, value35 + 148593226)
			local number27, value41, value42, number28
			local value43 = data9[49]
			callback3(value43, number25 - 3245370333)
			number27 = bit32.bor(number25, value25)
			callback3(data9[37], 148593451)
			value41 = data9[30]
			callback3(value41, value35 + 148593226)
			value42 = data9[54]
			callback3(value42, number27 - 3245370464)
			number28 = value43
						local value44 = data9[19]
			callback3(value44, 148593451)
						local value45 = data8[5]
			callback3(value45, value35 - 4146374070)
			callback3(data9[34], number27 - 3245370464)
			callback3(data8[2], 148593451)
						local value46 = data9[43]
			callback3(value46, value35 + 148593226)
						local value47 = data9[45]
			callback3(value47, 148593451)
			callback3(data9[27], 148593451)
						local value48 = data9[21]
			callback3(value48, value35 + 148593226)
						local value49 = data8[7]
			callback3(value49, 148593451)
						local value50 = data9[1]
			callback3(value50, 148593451)
			callback3(data9[20], 148593451)
			callback3(data9[11], number27 + 1049596832)
						local value51 = data8[4]
			callback3(value51, 148593451)
			callback3(data9[9], value35 + 148593226)
			local number29, value52, value53

			do
				local value54 = data9[26]
				local value55 = bit32.band(value35, value26)
				callback3(value54, number27 - 3245370464)
				callback3(data9[7], 148593451)
				callback3(data8[13], 148593451)
				callback3(data9[25], number27 + 1049596832)
				callback3(data9[10], 148593451)
				callback3(data9[44], value55 + 148593322)
				number29 = number26 + value27
				callback3(data9[42], number27 + 1049596832)
				callback3(data9[48], 148593451)
				callback3(data9[51], 148593451)
				callback3(data9[41], number27 + 1049596832)
				callback3(data8[9], 148593451)
				callback3(data8[14], value55 + 148593322)
				local value56 = data9[53]
				local number30 = value55 // value28
				callback3(value56, number27 + 1049596832)
				callback3(data9[50], 148593451)
				value52 = data9[3]
				callback3(value52, number30 - 4146373845)
				callback3(data9[28], number27 - 3245370464)
				value53 = data9[14]
				callback3(value53, 148593451)
				callback3(data9[31], number30 + 148593451)
				callback3(data9[6], 148593451)
				callback3(data9[47], 148593451)
				callback3(data8[12], number30 - 4146373845)
			end

			callback3(data9[46], 148593451)
			callback13(new4, "new")
			callback19(new4, nil)
						local ScreenGui2 = new("ScreenGui")
			local Path2D2

			do
				local Frame2 = new("Frame")
				Frame2.Position = uDim2New(0, 0, 0, 0)
				Frame2.Size = uDim2New(0, 132, 0, 241)
				Frame2.Parent = ScreenGui2
				local Path2D3 = new("Path2D")
				Path2D3.Parent = Frame2
				Path2D2 = Path2D3
			end

			do
				local setControlPoints = Path2D2.SetControlPoints
				local data11 = {}
				local value54 = new4(uDim2New(0, -4, 0, -6), uDim2New(0, -1, 0, 7), uDim2New(0, 6, 0, -1))
				local value55 = new4(uDim2New(0, -10, 0.25, -9), uDim2New(0.0625, -4, -0.125, 6), uDim2New(0, 5, 0, -8))
				local value56 = uDim2New(0.5, -8, 0.25, 2)
				local value57 = uDim2New(0.125, 7, -0.0625, -1)
				data11[1] = value54
				data11[2] = value55

				do
					local values = table.pack(new4(value56, value57, uDim2New(0, 0, 0, 0)))
					table.move(values, 1, values.n, 3, data11)
				end

				setControlPoints(Path2D2, data11)
			end

			do
				local number30 = number29 + value29
				local length = Path2D2:GetLength()
				callback4(string.unpack(">I4", string.pack(">f", length)), 4)
				local positionOnCurve = Path2D2:GetPositionOnCurve(0.5)
				callback4(string.unpack(">I4", string.pack(">f", positionOnCurve.X.Scale)), 4)
				local unpack_ = string.unpack
				callback4(unpack_(">I4", string.pack(">f", positionOnCurve.Y.Scale)), 4)
				local positionOnCurve2 = Path2D2:GetPositionOnCurve(0.46666666865348816)
				callback4(string.unpack(">I4", string.pack(">f", positionOnCurve2.X.Scale)), 4)
				callback4(string.unpack(">I4", string.pack(">f", positionOnCurve2.Y.Scale)), 4)
				local tangentOnCurve = Path2D2:GetTangentOnCurve(0.25)
				callback4(string.unpack("<I4", string.pack(">f", tangentOnCurve.X)), 4)
				callback4(string.unpack("<I4", string.pack(">f", tangentOnCurve.Y)), 4)
				local tangentOnCurve2 = Path2D2:GetTangentOnCurve(0.75)
				callback4(string.unpack("<I4", string.pack("<f", tangentOnCurve2.X)), 4)
				callback4(string.unpack(">I4", string.pack("<f", tangentOnCurve2.Y)), 4)
				local positionOnCurveArcLength = Path2D2:GetPositionOnCurveArcLength(0.625)
				callback4(string.unpack(">I4", string.pack("<f", positionOnCurveArcLength.X.Scale)), 4)
				callback4(string.unpack("<I4", string.pack(">f", positionOnCurveArcLength.Y.Scale)), 4)
				local positionOnCurveArcLength2 = Path2D2:GetPositionOnCurveArcLength(0.5)
				callback4(string.unpack(">I4", string.pack(">f", positionOnCurveArcLength2.X.Scale)), 4)
				callback4(string.unpack("<I4", string.pack(">f", positionOnCurveArcLength2.Y.Scale)), 4)
				local positionOnCurveArcLength3 = Path2D2:GetPositionOnCurveArcLength(0.083333335816860199)
				callback4(string.unpack("<I4", string.pack("<f", positionOnCurveArcLength3.X.Scale)), 4)
				local number31 = number30 + value32
				callback4(string.unpack("<I4", string.pack("<f", positionOnCurveArcLength3.Y.Scale)), 4)
				local tangentOnCurveArcLength = Path2D2:GetTangentOnCurveArcLength(0.15384615957736969)
				callback4(string.unpack("<I4", string.pack("<f", tangentOnCurveArcLength.X)), 4)
				callback4(string.unpack("<I4", string.pack(">f", tangentOnCurveArcLength.Y)), 4)
				local tangentOnCurveArcLength2 = Path2D2:GetTangentOnCurveArcLength(0.375)
				callback4(string.unpack(">I4", string.pack(">f", tangentOnCurveArcLength2.X)), 4)
				callback4(string.unpack(">I4", string.pack(">f", tangentOnCurveArcLength2.Y)), 4)
				local tangentOnCurveArcLength3 = Path2D2:GetTangentOnCurveArcLength(0.53846156597137451)
				callback4(string.unpack(">I4", string.pack("<f", tangentOnCurveArcLength3.X)), 4)
				callback4(string.unpack("<I4", string.pack(">f", tangentOnCurveArcLength3.Y)), 4)
				ScreenGui2:Destroy()
				callback12(math, 218723579, { [3668483602] = 331635280, [1303859104] = 1381494275, [1292485390] = 1059621379 })

				callback12(value11, 218723579, {
					[1420216976] = 752316410,
					[194463251] = 1377272538,
					[4280857151] = 1916921198,
					[4273605931] = 2077633238,
					[1618608716] = 1869670192,
				})

				callback12(value4, 218723579, { [2759041104] = 1297627627, [356266053] = 2063474335 })
				local gameRef = game
				local workspaceRef = workspace

				local function callback20(argument, argument2, argument3)
					local state = 1
					local number32, number33, argument4, argument5, argument6, parent, parent2, name, name2, ancestryChanged, resume, parent3, parent4, value54, parent5, callback21, condition4, resume2, condition5, value55, condition6, condition7, parent6, parent7, value56, callback22, condition8, condition9, value57, value58, condition10

					while true do
						local number34

						if state <= 112 then
							if state <= 56 then
								if state <= 28 then
									if state <= 14 then
										if state == 1 then
											number32 = 1983948755
											number33 = 1107289406
											argument4 = argument
											argument5 = argument2
											argument6 = argument3
											local valueType3 = type(argument5)
											callback7("userdata", valueType3)

											if nil then
												state = 3
											else
												state = 2
											end
										elseif state == 2 then
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
											state = 3
										elseif state == 3 then
											local valueType3 = typeof(argument5)
											callback7("Instance", valueType3)

											if nil then
												state = 5
											else
												state = 4
											end
										elseif state == 4 then
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
											state = 5
										elseif state == 5 then
											parent = argument5.Parent
											parent2 = argument5.Parent

											if data4[not parent] then
												state = 6
											else
												state = 9
											end
										elseif state == 6 then
											callback7(parent, parent2)

											if nil then
												state = 8
											else
												state = 7
											end
										elseif state == 7 then
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
											state = 8
										elseif state == 8 then
											state = 9
										elseif state == 9 then
											name = argument5.Name
											name2 = argument5.Name
											local valueType3 = type(name)
											callback7("string", valueType3)

											if nil then
												state = 11
											else
												state = 10
											end
										elseif state == 10 then
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
											state = 11
										elseif state == 11 then
											callback7(name, name2)

											if nil then
												state = 13
											else
												state = 12
											end
										elseif state == 12 then
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
											state = 13
										elseif state == 13 then
											local number35 = #name
											local number36 = #name2
											local callback23 = callback7
											local number37 = bit32.band(number36, 4294967295)
											local number38 = bit32.band(number37, 65535)
											local value59 = bit32.band(54259 * number38 + bit32.lshift(bit32.band(54259 * bit32.rshift(number37, 16) + 37619 * number38, 65535), 16), 4294967295)
											local number39 = bit32.bnot(number36)
											local number40 = bit32.band(number39, 65535)
											argument4 = 2629977780 + argument4 + value59 + bit32.band(54259 * number40 + bit32.lshift(bit32.band(54259 * bit32.rshift(number39, 16) + 37619 * number40, 65535), 16), 4294967295)
											callback23(number35, number36)

											if nil then
												state = 15
											else
												state = 14
											end
										elseif state == 14 then
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
											state = 15
										end
									elseif state == 15 then
										callback7(tostring(argument5), name)

										if nil then
											state = 17
										else
											state = 16
										end
									elseif state == 16 then
										state = 35
									elseif state == 17 then
										callback7(argument6, argument5.ClassName)

										if nil then
											state = 19
										else
											state = 18
										end
									elseif state == 18 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 19
									elseif state == 19 then
										ancestryChanged = argument5.AncestryChanged
										argument6 = argument5.AncestryChanged
										number33 = bit32.band(number33, argument4)
										callback7(ancestryChanged, argument6)

										if nil then
											state = 222
										else
											state = 20
										end
									elseif state == 20 then
										if nil then
											state = 22
										else
											state = 21
										end
									elseif state == 21 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 22
									elseif state == 22 then
										local connect = ancestryChanged.Connect
										local connect2 = ancestryChanged.Connect
										callback13(connect, "Connect")
										callback13(connect2, "Connect")
										callback7(connect, connect2)

										if nil then
											state = 23
										else
											state = 24
										end
									elseif state == 23 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 24
									elseif state == 24 then
										local condition11 = false
										local destroying = argument5.Destroying
										local destroying2 = destroying
										local connect = destroying.Connect
										local argument7 = bit32.bxor(argument4, 280525953)

										local function callback23()
											condition11 = true

											if nil then
												argument7 = bit32.bxor(argument7, 3235034115)
											end
										end

										argument7 = bit32.bxor(argument7, 148119644)
										argument6 = connect(destroying2, callback23)

										if nil then
											state = 26
										else
											state = 25
										end
									elseif state == 25 then
										state = 27
									elseif state == 26 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 27
									elseif state == 27 then
										if nil then
											state = 28
										else
											state = 42
										end
									elseif state == 28 then
										local disconnect = argument6.Disconnect
										callback13(disconnect, "Disconnect")
										callback19(disconnect, nil)
										disconnect(argument6)
										number33 = bit32.bxor(number33, argument4)

										if argument4 + 1906447 == 365670673 then
											state = 30
										else
											state = 29
										end
									end
								elseif state <= 42 then
									if state == 29 then
										if nil then
											state = 46
										else
											state = 47
										end
									elseif state == 30 then
										if nil <= 4 then
											state = 43
										else
											state = 31
										end
									elseif state == 31 then
										if nil <= 7 then
											state = 40
										else
											state = 32
										end
									elseif state == 32 then
										if nil <= 8 then
											state = 36
										else
											state = 33
										end
									elseif state == 33 then
										if nil <= 9 then
											state = 35
										else
											state = 34
										end
									elseif state == 34 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 48
									elseif state == 35 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 17
									elseif state == 36 then
										local value59 = getmetatable(argument5)
										callback7("The metatable is locked", value59)

										if nil then
											state = 38
										else
											state = 37
										end
									elseif state == 37 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 38
									elseif state == 38 then
										if argument4 + 501065228 ~= 361643982 then
											state = 221
										else
											state = 39
										end
									elseif state == 39 then
										state = 19
									elseif state == 40 then
										if nil <= 5 then
											state = 42
										else
											state = 41
										end
									elseif state == 41 then
										if nil <= 6 then
											state = 221
										else
											state = 9
										end
									elseif state == 42 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 28
									end
								elseif state == 43 then
									if nil <= 1 then
										state = 101
									else
										state = 44
									end
								elseif state == 44 then
									if nil <= 2 then
										state = 48
									else
										state = 45
									end
								elseif state == 45 then
									if nil <= 3 then
										state = 13
									else
										state = 46
									end
								elseif state == 46 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 47
								elseif state == 47 then
									local wait2 = ancestryChanged.Wait
									argument4 += 76178503
									callback13(wait2, "Wait")
									number34 = 12478618

									local function callback23()
										local wait3 = wait2

										if nil then
											number34 = bit32.bxor(number34, 1430127237)
										end

										return (wait3(ancestryChanged))
									end

									number34 = bit32.bxor(12478618, number33 - 4246385089)
									argument6 = coroutine.create(callback23)
									resume = coroutine.resume
									state = 145
								elseif state == 48 then
									local valueType3 = typeof(argument5)
									callback7("Instance", valueType3)

									if nil then
										state = 50
									else
										state = 49
									end
								elseif state == 49 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 50
								elseif state == 50 then
									parent3 = argument5.Parent
									parent4 = argument5.Parent
									value54 = data4[not parent3]
									state = 51
								elseif state == 51 then
									if value54 then
										state = 52
									else
										state = 59
									end
								elseif state == 52 then
									parent5 = parent3
									callback7(parent5, parent4)

									if nil then
										state = 58
									else
										state = 53
									end
								elseif state == 53 then
									callback21 = callback4

									if number32 == 369465669 then
										state = 55
									else
										state = 54
									end
								elseif state == 54 then
									callback21(372868618, 4)
									number4 = 43031001
									callback5()
									state = 58
								elseif state == 55 then
									local number35 = bit32.band(number33, 3464781827)
									local thread3 = coroutine.status(argument6)
									condition4 = not callback7("dead", thread3)
									number33 = number35 - 4294960640

									if condition4 then
										state = 56
									else
										state = 85
									end
								elseif state == 56 then
									callback4(372868618, 4)

									if number32 == 282554691 then
										state = 76
									else
										state = 57
									end
								end
							elseif state <= 84 then
								if state <= 70 then
									if state == 57 then
										number4 = 43031001
										callback5()
										state = 85
									elseif state == 58 then
										state = 59
									elseif state == 59 then
										condition4 = argument5.Name
										parent5 = argument5.Name
										local valueType3 = type(condition4)
										callback7("string", valueType3)

										if nil then
											state = 61
										else
											state = 60
										end
									elseif state == 60 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 61
									elseif state == 61 then
										callback7(condition4, parent5)

										if nil then
											state = 63
										else
											state = 62
										end
									elseif state == 62 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 63
									elseif state == 63 then
										local number35 = #condition4
										local number36 = #parent5
										local callback23 = callback7
										local number37 = bit32.band(number36, 4294967295)
										local number38 = bit32.band(number37, 65535)
										local value59 = bit32.band(54259 * number38 + bit32.lshift(bit32.band(54259 * bit32.rshift(number37, 16) + 37619 * number38, 65535), 16), 4294967295)
										local number39 = bit32.bnot(number36)
										local number40 = bit32.band(number39, 65535)
										argument4 = 2629977780 + argument4 + value59 + bit32.band(54259 * number40 + bit32.lshift(bit32.band(54259 * bit32.rshift(number39, 16) + 37619 * number40, 65535), 16), 4294967295)
										callback23(number35, number36)

										if nil then
											state = 65
										else
											state = 64
										end
									elseif state == 64 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 65
									elseif state == 65 then
										callback7(tostring(argument5), condition4)

										if nil then
											state = 66
										else
											state = 84
										end
									elseif state == 66 then
										callback7(argument6, argument5.ClassName)

										if nil then
											state = 68
										else
											state = 67
										end
									elseif state == 67 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 68
									elseif state == 68 then
										ancestryChanged = argument5.AncestryChanged
										argument6 = argument5.AncestryChanged
										number33 = bit32.band(number33, argument4)
										callback7(ancestryChanged, argument6)

										if nil then
											state = 220
										else
											state = 69
										end
									elseif state == 69 then
										if nil then
											state = 71
										else
											state = 70
										end
									elseif state == 70 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 71
									end
								elseif state == 71 then
									local connect = ancestryChanged.Connect
									local connect2 = ancestryChanged.Connect
									callback13(connect, "Connect")
									callback13(connect2, "Connect")
									callback7(connect, connect2)

									if nil then
										state = 72
									else
										state = 73
									end
								elseif state == 72 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 73
								elseif state == 73 then
									local condition11 = false
									local destroying = argument5.Destroying
									local connect = destroying.Connect
									local argument7 = bit32.bxor(argument4, 280525953)

									local function callback23()
										condition11 = true

										if nil then
											argument7 = bit32.bxor(argument7, 3235034115)
										end
									end

									argument7 = bit32.bxor(argument7, number32 - 787161745)
									argument6 = connect(destroying, callback23)

									if nil then
										state = 75
									else
										state = 74
									end
								elseif state == 74 then
									state = 76
								elseif state == 75 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 76
								elseif state == 76 then
									if nil then
										state = 77
									else
										state = 90
									end
								elseif state == 77 then
									local disconnect = argument6.Disconnect
									callback13(disconnect, "Disconnect")
									callback19(disconnect, nil)
									disconnect(argument6)
									number33 = bit32.bxor(number33, argument4)

									if argument4 + 1906447 == 365670673 then
										state = 79
									else
										state = 78
									end
								elseif state == 78 then
									if nil then
										state = 94
									else
										state = 95
									end
								elseif state == 79 then
									if nil <= 4 then
										state = 91
									else
										state = 80
									end
								elseif state == 80 then
									if nil <= 7 then
										state = 88
									else
										state = 81
									end
								elseif state == 81 then
									if nil <= 8 then
										state = 85
									else
										state = 82
									end
								elseif state == 82 then
									if nil <= 9 then
										state = 84
									else
										state = 83
									end
								elseif state == 83 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 97
								elseif state == 84 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 66
								end
							elseif state <= 98 then
								if state == 85 then
									local value59 = getmetatable(argument5)
									callback7("The metatable is locked", value59)

									if nil then
										state = 87
									else
										state = 86
									end
								elseif state == 86 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 87
								elseif state == 87 then
									if argument4 + 501065228 ~= 361643982 then
										state = 221
									else
										state = 68
									end
								elseif state == 88 then
									if nil <= 5 then
										state = 90
									else
										state = 89
									end
								elseif state == 89 then
									if nil <= 6 then
										state = 221
									else
										state = 59
									end
								elseif state == 90 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 77
								elseif state == 91 then
									if nil <= 1 then
										state = 100
									else
										state = 92
									end
								elseif state == 92 then
									if nil <= 2 then
										state = 97
									else
										state = 93
									end
								elseif state == 93 then
									if nil <= 3 then
										state = 63
									else
										state = 94
									end
								elseif state == 94 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 95
								elseif state == 95 then
									local wait2 = ancestryChanged.Wait
									argument4 += 76178503
									callback13(wait2, "Wait")
									number34 = bit32.bxor(number32, 922823287)

									local function callback23()
										local wait3 = wait2

										if nil then
											number34 = bit32.bxor(number34, 1430127237)
										end

										return (wait3(ancestryChanged))
									end

									number34 = bit32.bxor(number34, number33 - 4246385089)
									argument6 = coroutine.create(callback23)
									resume2 = coroutine.resume

									if number32 + 535532559 == 397500711 then
										state = 96
									else
										state = 195
									end
								elseif state == 96 then
									state = 195
								elseif state == 97 then
									local valueType3 = typeof(argument5)
									callback7("Instance", valueType3)

									if nil then
										state = 99
									else
										state = 98
									end
								elseif state == 98 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 99
								end
							elseif state == 99 then
								parent3 = argument5.Parent
								parent4 = argument5.Parent
								value54 = data4[not parent3]
								state = 51
							elseif state == 100 then
								if nil <= 0 then
									state = 69
								else
									state = 201
								end
							elseif state == 101 then
								if nil <= 0 then
									state = 20
								else
									state = 102
								end
							elseif state == 102 then
								condition5 = data4[not name]
								state = 103
							elseif state == 103 then
								if condition5 then
									state = 105
								else
									state = 104
								end
							elseif state == 104 then
								local thread3 = coroutine.status(argument6)
								condition5 = not callback7("suspended", thread3)
								state = 105
							elseif state == 105 then
								if condition5 then
									state = 106
								else
									state = 107
								end
							elseif state == 106 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 107
							elseif state == 107 then
								local ok2, response3 = pcall(coroutine.close, argument6)
								value55 = response3
								local value59 = data4[not ok2]
								condition6 = not value59

								if value59 then
									state = 109
								else
									state = 108
								end
							elseif state == 108 then
								name = condition6
								state = 110
							elseif state == 109 then
								name = not data4[not value55]
								state = 110
							elseif state == 110 then
								if name then
									state = 112
								else
									state = 111
								end
							elseif state == 111 then
								local number35 = bit32.band(number33, 3464781827)
								local thread3 = coroutine.status(argument6)
								name = not callback7("dead", thread3)
								number33 = number35 - 4294960640
								state = 112
							elseif state == 112 then
								if name then
									state = 113
								else
									state = 114
								end
							end
						elseif state <= 168 then
							if state <= 140 then
								if state <= 126 then
									if state == 113 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 114
									elseif state == 114 then
										local value59 = getmetatable(argument5)
										callback7("The metatable is locked", value59)

										if nil then
											state = 116
										else
											state = 115
										end
									elseif state == 115 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 116
									elseif state == 116 then
										if argument4 + 501065228 ~= 361643982 then
											state = 221
										else
											state = 117
										end
									elseif state == 117 then
										ancestryChanged = argument5.AncestryChanged
										argument6 = argument5.AncestryChanged
										number33 = bit32.band(number33, argument4)
										callback7(ancestryChanged, argument6)

										if nil then
											state = 220
										else
											state = 118
										end
									elseif state == 118 then
										if nil then
											state = 120
										else
											state = 119
										end
									elseif state == 119 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 120
									elseif state == 120 then
										local connect = ancestryChanged.Connect
										local connect2 = ancestryChanged.Connect
										callback13(connect, "Connect")
										callback13(connect2, "Connect")
										callback7(connect, connect2)

										if nil then
											state = 121
										else
											state = 122
										end
									elseif state == 121 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 122
									elseif state == 122 then
										local condition11 = false
										local destroying = argument5.Destroying
										local destroying2 = destroying
										local connect = destroying.Connect
										local argument7 = bit32.bxor(argument4, 280525953)

										local function callback23()
											condition11 = true

											if nil then
												argument7 = bit32.bxor(argument7, 3235034115)
											end
										end

										argument7 = bit32.bxor(argument7, 148119644)
										argument6 = connect(destroying2, callback23)

										if nil then
											state = 124
										else
											state = 123
										end
									elseif state == 123 then
										state = 125
									elseif state == 124 then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
										state = 125
									elseif state == 125 then
										if nil then
											state = 126
										else
											state = 139
										end
									elseif state == 126 then
										local disconnect = argument6.Disconnect
										callback13(disconnect, "Disconnect")
										callback19(disconnect, nil)
										disconnect(argument6)
										number33 = bit32.bxor(number33, argument4)

										if argument4 + 1906447 == 365670673 then
											state = 128
										else
											state = 127
										end
									end
								elseif state == 127 then
									if nil then
										state = 143
									else
										state = 144
									end
								elseif state == 128 then
									if nil <= 4 then
										state = 140
									else
										state = 129
									end
								elseif state == 129 then
									if nil <= 7 then
										state = 133
									else
										state = 130
									end
								elseif state == 130 then
									if nil <= 8 then
										state = 114
									else
										state = 131
									end
								elseif state == 131 then
									if nil <= 9 then
										state = 150
									else
										state = 132
									end
								elseif state == 132 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 153
								elseif state == 133 then
									if nil <= 5 then
										state = 139
									else
										state = 134
									end
								elseif state == 134 then
									if nil <= 6 then
										state = 221
									else
										state = 135
									end
								elseif state == 135 then
									name = argument5.Name
									name2 = argument5.Name
									local valueType3 = type(name)
									callback7("string", valueType3)

									if nil then
										state = 137
									else
										state = 136
									end
								elseif state == 136 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 137
								elseif state == 137 then
									callback7(name, name2)

									if nil then
										state = 147
									else
										state = 138
									end
								elseif state == 138 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 147
								elseif state == 139 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 126
								elseif state == 140 then
									if nil <= 1 then
										state = 219
									else
										state = 141
									end
								end
							elseif state <= 154 then
								if state == 141 then
									if nil <= 2 then
										state = 153
									else
										state = 142
									end
								elseif state == 142 then
									if nil <= 3 then
										state = 147
									else
										state = 143
									end
								elseif state == 143 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 144
								elseif state == 144 then
									local wait2 = ancestryChanged.Wait
									argument4 += 76178503
									callback13(wait2, "Wait")
									number34 = 12478618

									local function callback23()
										local wait3 = wait2

										if nil then
											number34 = bit32.bxor(number34, 1430127237)
										end

										return (wait3(ancestryChanged))
									end

									number34 = bit32.bxor(12478618, number33 - 4246385089)
									argument6 = coroutine.create(callback23)
									resume = coroutine.resume
									state = 145
								elseif state == 145 then
									local value59, value60 = resume(argument6)
									name = value60
									local value61 = data4[not value59]
									condition7 = not value61

									if value61 then
										state = 102
									else
										state = 146
									end
								elseif state == 146 then
									condition5 = condition7
									state = 103
								elseif state == 147 then
									local number35 = #name
									local number36 = #name2
									local callback23 = callback7
									local number37 = bit32.band(number36, 4294967295)
									local number38 = bit32.band(number37, 65535)
									local value59 = bit32.band(54259 * number38 + bit32.lshift(bit32.band(54259 * bit32.rshift(number37, 16) + 37619 * number38, 65535), 16), 4294967295)
									local number39 = bit32.bnot(number36)
									local number40 = bit32.band(number39, 65535)
									argument4 = 2629977780 + argument4 + value59 + bit32.band(54259 * number40 + bit32.lshift(bit32.band(54259 * bit32.rshift(number39, 16) + 37619 * number40, 65535), 16), 4294967295)
									callback23(number35, number36)

									if nil then
										state = 149
									else
										state = 148
									end
								elseif state == 148 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 149
								elseif state == 149 then
									callback7(tostring(argument5), name)

									if nil then
										state = 151
									else
										state = 150
									end
								elseif state == 150 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 151
								elseif state == 151 then
									callback7(argument6, argument5.ClassName)

									if nil then
										state = 117
									else
										state = 152
									end
								elseif state == 152 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 117
								elseif state == 153 then
									local valueType3 = typeof(argument5)
									callback7("Instance", valueType3)

									if nil then
										state = 155
									else
										state = 154
									end
								elseif state == 154 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 155
								end
							elseif state == 155 then
								parent6 = argument5.Parent
								parent7 = argument5.Parent
								value56 = data4[not parent6]
								state = 156
							elseif state == 156 then
								if value56 then
									state = 157
								else
									state = 161
								end
							elseif state == 157 then
								parent5 = parent6
								callback7(parent5, parent7)

								if nil then
									state = 160
								else
									state = 158
								end
							elseif state == 158 then
								callback22 = callback4

								if number32 == 369465669 then
									state = 212
								else
									state = 159
								end
							elseif state == 159 then
								callback22(372868618, 4)
								number4 = 43031001
								callback5()
								state = 160
							elseif state == 160 then
								state = 161
							elseif state == 161 then
								condition4 = argument5.Name
								parent5 = argument5.Name
								local valueType3 = type(condition4)
								callback7("string", valueType3)

								if nil then
									state = 163
								else
									state = 162
								end
							elseif state == 162 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 163
							elseif state == 163 then
								callback7(condition4, parent5)

								if nil then
									state = 165
								else
									state = 164
								end
							elseif state == 164 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 165
							elseif state == 165 then
								local number35 = #condition4
								local number36 = #parent5
								local callback23 = callback7
								local number37 = bit32.band(number36, 4294967295)
								local number38 = bit32.band(number37, 65535)
								local value59 = bit32.band(54259 * number38 + bit32.lshift(bit32.band(54259 * bit32.rshift(number37, 16) + 37619 * number38, 65535), 16), 4294967295)
								local number39 = bit32.bnot(number36)
								local number40 = bit32.band(number39, 65535)
								argument4 = 2629977780 + argument4 + value59 + bit32.band(54259 * number40 + bit32.lshift(bit32.band(54259 * bit32.rshift(number39, 16) + 37619 * number40, 65535), 16), 4294967295)
								callback23(number35, number36)

								if nil then
									state = 167
								else
									state = 166
								end
							elseif state == 166 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 167
							elseif state == 167 then
								callback7(tostring(argument5), condition4)

								if nil then
									state = 168
								else
									state = 186
								end
							elseif state == 168 then
								callback7(argument6, argument5.ClassName)

								if nil then
									state = 170
								else
									state = 169
								end
							end
						elseif state <= 196 then
							if state <= 182 then
								if state == 169 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 170
								elseif state == 170 then
									ancestryChanged = argument5.AncestryChanged
									argument6 = argument5.AncestryChanged
									number33 = bit32.band(number33, argument4)
									callback7(ancestryChanged, argument6)

									if nil then
										state = 220
									else
										state = 171
									end
								elseif state == 171 then
									if nil then
										state = 173
									else
										state = 172
									end
								elseif state == 172 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 173
								elseif state == 173 then
									local connect = ancestryChanged.Connect
									local connect2 = ancestryChanged.Connect
									callback13(connect, "Connect")
									callback13(connect2, "Connect")
									callback7(connect, connect2)

									if nil then
										state = 174
									else
										state = 175
									end
								elseif state == 174 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 175
								elseif state == 175 then
									local condition11 = false
									local destroying = argument5.Destroying
									local connect = destroying.Connect
									local argument7 = bit32.bxor(argument4, 280525953)

									local function callback23()
										condition11 = true

										if nil then
											argument7 = bit32.bxor(argument7, 3235034115)
										end
									end

									argument7 = bit32.bxor(argument7, number32 - 787161745)
									argument6 = connect(destroying, callback23)

									if nil then
										state = 177
									else
										state = 176
									end
								elseif state == 176 then
									state = 178
								elseif state == 177 then
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									state = 178
								elseif state == 178 then
									if nil then
										state = 179
									else
										state = 189
									end
								elseif state == 179 then
									local disconnect = argument6.Disconnect
									callback13(disconnect, "Disconnect")
									callback19(disconnect, nil)
									disconnect(argument6)
									number33 = bit32.bxor(number33, argument4)

									if argument4 + 1906447 == 365670673 then
										state = 181
									else
										state = 180
									end
								elseif state == 180 then
									if nil then
										state = 193
									else
										state = 194
									end
								elseif state == 181 then
									if nil <= 4 then
										state = 190
									else
										state = 182
									end
								elseif state == 182 then
									if nil <= 7 then
										state = 187
									else
										state = 183
									end
								end
							elseif state == 183 then
								if nil <= 8 then
									state = 216
								else
									state = 184
								end
							elseif state == 184 then
								if nil <= 9 then
									state = 186
								else
									state = 185
								end
							elseif state == 185 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 197
							elseif state == 186 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 168
							elseif state == 187 then
								if nil <= 5 then
									state = 189
								else
									state = 188
								end
							elseif state == 188 then
								if nil <= 6 then
									state = 221
								else
									state = 161
								end
							elseif state == 189 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 179
							elseif state == 190 then
								if nil <= 1 then
									state = 200
								else
									state = 191
								end
							elseif state == 191 then
								if nil <= 2 then
									state = 197
								else
									state = 192
								end
							elseif state == 192 then
								if nil <= 3 then
									state = 165
								else
									state = 193
								end
							elseif state == 193 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 194
							elseif state == 194 then
								local wait2 = ancestryChanged.Wait
								argument4 += 76178503
								callback13(wait2, "Wait")
								number34 = bit32.bxor(number32, 922823287)

								local function callback23()
									local wait3 = wait2

									if nil then
										number34 = bit32.bxor(number34, 1430127237)
									end

									return (wait3(ancestryChanged))
								end

								number34 = bit32.bxor(number34, number33 - 4246385089)
								argument6 = coroutine.create(callback23)
								resume2 = coroutine.resume
								state = 195
							elseif state == 195 then
								local value59, value60 = resume2(argument6)
								condition4 = value60
								local value61 = data4[not value59]
								condition8 = not value61

								if value61 then
									state = 201
								else
									state = 196
								end
							elseif state == 196 then
								condition9 = condition8
								state = 202
							end
						elseif state <= 210 then
							if state == 197 then
								local valueType3 = typeof(argument5)
								callback7("Instance", valueType3)

								if nil then
									state = 199
								else
									state = 198
								end
							elseif state == 198 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 199
							elseif state == 199 then
								parent6 = argument5.Parent
								parent7 = argument5.Parent
								value56 = data4[not parent6]
								state = 156
							elseif state == 200 then
								if nil <= 0 then
									state = 171
								else
									state = 201
								end
							elseif state == 201 then
								condition9 = data4[not condition4]
								state = 202
							elseif state == 202 then
								if condition9 then
									state = 204
								else
									state = 203
								end
							elseif state == 203 then
								local thread3 = coroutine.status(argument6)
								condition9 = not callback7("suspended", thread3)
								state = 204
							elseif state == 204 then
								if condition9 then
									state = 205
								else
									state = 206
								end
							elseif state == 205 then
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
								state = 206
							elseif state == 206 then
								local ok2, response3 = pcall(coroutine.close, argument6)
								value57 = response3
								value58 = data4[not ok2]
								condition10 = number32 ~= 195444195

								if condition10 then
									state = 208
								else
									state = 207
								end
							elseif state == 207 then
								state = 208
							elseif state == 208 then
								if value58 then
									state = 210
								else
									state = 209
								end
							elseif state == 209 then
								condition4 = condition10
								state = 211
							elseif state == 210 then
								condition4 = not data4[not value57]
								state = 211
							end
						elseif state == 211 then
							if condition4 then
								state = 213
							else
								state = 212
							end
						elseif state == 212 then
							local number35 = bit32.band(number33, 3464781827)
							local thread3 = coroutine.status(argument6)
							condition4 = not callback7("dead", thread3)
							number33 = number35 - 4294960640
							state = 213
						elseif state == 213 then
							if condition4 then
								state = 214
							else
								state = 216
							end
						elseif state == 214 then
							callback4(372868618, 4)

							if number32 == 282554691 then
								state = 178
							else
								state = 215
							end
						elseif state == 215 then
							number4 = 43031001
							callback5()
							state = 216
						elseif state == 216 then
							local value59 = getmetatable(argument5)
							callback7("The metatable is locked", value59)

							if nil then
								state = 218
							else
								state = 217
							end
						elseif state == 217 then
							callback4(372868618, 4)
							number4 = 43031001
							callback5()
							state = 218
						elseif state == 218 then
							if argument4 + 501065228 ~= 361643982 then
								state = 221
							else
								state = 170
							end
						elseif state == 219 then
							if nil <= 0 then
								state = 118
							else
								state = 102
							end
						elseif state == 220 then
							callback4(372868618, 4)
							state = 225
						elseif state == 221 then
							return
						elseif state == 222 then
							callback4(372868618, 4)

							if number33 + 37915839 == 12018273 then
								state = 224
							else
								state = 223
							end
						elseif state == 223 then
							state = 225
						elseif state == 224 then
							state = 225
						elseif state == 225 then
							(29)(nil)
							return
						end
					end
				end

				callback20(12486496, gameRef, "DataModel")
				callback20(12486496, workspaceRef, "Workspace")

				if callback7(gameRef, workspaceRef.Parent) then
					callback3(150, 148593451)
					number4 = number13
				else
					callback4(372868618, 4)
					number4 = 43031001
					callback5()
				end

				local Folder = new("Folder")
				callback20(12486496, Folder, "Folder")
				local number32 = number31 + value33
				local ok2, response3 = pcall(Folder.GetChildren, Vector3.new(-66.08093, -84.9317, 763.03735), 1824775727)
				local condition4 = not ok2

				if data4[condition4] then
					while true do
					end
				else
					local iter_f_1, Folder2, Folder3, number33

					do
						do
							do
								callback4(callback9(response3, 51052561), 4)

								do
									local number34 = number4

									if data4[condition4] then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
									else
										callback3(126, 148593451)
										number4 = number34
									end
								end
							end

							do
								local children, value54, value55 = Folder:GetChildren()
								iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(children, value54, value55)
							end
						end

						do
							local value54 = table.pack(iter_f_1())

							if value54[1] then
								repeat
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
									local value55 = table.pack(iter_f_1())
								until not value55[1]
							end

							Folder:Destroy()

							do
								local number34 = number4
								Folder2 = Folder
								Folder3 = new("Folder", Folder2)
								callback20(12486496, Folder3, "Folder")

								if callback7(Folder2, Folder3.Parent) then
									number33 = number34
									callback3(77, 148593451)
									number4 = number33
								else
									number33 = number34
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
								end
							end
						end

						if callback7(Folder3.Parent, Folder3.Parent) then
							callback3(194, 148593451)
						else
							callback4(372868618, 4)
							number4 = 43031001
							callback5()
						end

						do
							local waitForChild = Folder2.WaitForChild
							callback13(waitForChild, "WaitForChild")
							callback19(waitForChild, nil)
							local name = tostring(1264550249)
							Folder3.Name = name
							local value54 = waitForChild(Folder2, name)

							if callback7(Folder3, value54) then
								callback3(121, 148593451)
							else
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
							end
						end
					end

					Folder2:Destroy()
					Folder3:Destroy()

					do
						local number34 = number32 + value34
						local number35 = 4062162997
						local number36 = number23
						local text2 = "Parent"
						local number37 = 4062162997
						local condition5

						while true do
							local number38

							do
								do
									local number39 = bit32.band(number37, 4294967295)
									local number40 = bit32.band(number36, 4294967295)
									local number41 = bit32.band(number39, 65535)
									local number42 = bit32.rshift(number39, 16)
									local number43 = bit32.band(number40, 65535)

									do
										local value54 = bit32.band(number41 * number43 + bit32.lshift(bit32.band(number41 * bit32.rshift(number40, 16) + number42 * number43, 65535), 16), 4294967295)
										local number44 = bit32.bnot(number36)
										local number45 = bit32.band(number44, 65535)
										number38 = number34 + number35 + value54 + bit32.band(45109 * number45 + bit32.lshift(bit32.band(45109 * bit32.rshift(number44, 16) + 61983 * number45, 65535), 16), 4294967295)
									end
								end

								do
									local number39

									do
										if data4[not Folder3[text2]] then
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
										else
											callback3(32, 148593451)
										end

										if data4[not pcall(function()
											Folder3.Parent = Folder2
										end)] then
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
										else
											callback3(141, 148593451)
										end

										number4 = number33

										do
											local HttpService = gameRef:GetService("HttpService")
											callback20(12486496, HttpService, "HttpService")
											local callback21 = callback7
											local number40 = number4

											if callback21(gameRef, HttpService.Parent) then
												number33 = number40
												callback3(66, 148593451)
												number4 = number33
												number39 = number33
											else
												number39 = number40
												callback4(372868618, 4)
												number4 = 43031001
												callback5()
											end

											if not number then
												callback13(HttpService.GetAsync, "GetAsync")
												callback13(HttpService.PostAsync, "PostAsync")
												callback13(HttpService.RequestAsync, "RequestAsync")
											end
										end
									end

									do
										local RunService = gameRef:GetService("RunService")
										callback20(12486496, RunService, "RunService")

										if callback7(gameRef, RunService.Parent) then
											number = 161
											callback3(number, 148593451)
											number4 = number39
										else
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
										end

										callback13(RunService.IsStudio, "IsStudio")
										callback13(RunService.IsClient, "IsClient")
										callback13(RunService.IsServer, "IsServer")
										callback19(RunService.IsStudio)
										callback19(RunService.IsClient)
										callback19(RunService.IsServer)
										RunService:IsServer()
									end

									if nil then
										do
											local StarterPlayer = gameRef:GetService("StarterPlayer")
											callback20(12486496, StarterPlayer, "StarterPlayer")
											callback7(gameRef, StarterPlayer.Parent)
											if not nil then
												break
											end
											local children, value54, value55 = StarterPlayer:GetChildren()
											iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(children, value54, value55)
										end

										local value54 = table.pack(iter_f_1())

										if value54[1] then
											repeat
												local value55 = table.pack(iter_f_1())
											until not value55[1]
										end

										if nil then
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
										end
									end

									if data4[not pcall(gameRef.GetChildren)] then
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
									else
										callback3(217, 148593451)
										number4 = number39
									end
								end
							end

							local number39, data11, data12, value54, data13, value55, number40, value56, number41, data14
							local number42, value57, value58, number43, value59, value60, data15, value61, data16, value62
							local value63, value64, value65, number44, value66, value67, value68, number45, data17, data18
							local number46, number47, number48, number49, value69, dataMap, value70, number50, number51

							do
								number39 = Enum

								do
									local callback21 = callback7
									local number52 = number4

									if callback21(type(number39), "userdata") then
										callback3(205, 148593451)
										number4 = number52
										text2 = number52
									else
										text2 = number52
										callback4(372868618, 4)

										if value46 == 225.0000000000241 then
											number42 = (number39 + data10[1]) % 16777216
											data16 = { nil, 1, 6, 0, data[3] }

											while true do
												value61 = data16[2]
												value68 = data16[3]
												number40 = data16[4] + value61
												data16[4] = number40

												if number40 <= value68 then
													number47 = number40
													number51 = (number42 * (data10[2] * 2 + 1) + data10[3]) % 16777216
													number28 = number51 % 4096
													number42 = ((number28 * 4096 + (number51 - number51 % 4096) // 4096 + data10[4]) % 16777216 + number47 * data10[5]) % 16777216

													if nil then
														number42 = (number42 + data10[6]) % 16777216
													end
												else
													break
												end
											end

											value54 = data16[5]
											callback4((math_floor_precision(number39) - number42) % 16777216, 8)
											dataMap = {}
											gameRef = 16705
											data12 = { 16, 1, -1, value54, nil }

											while true do
												value56 = data12[2]
												value69 = data12[1]
												number48 = data12[3] + value56
												data12[3] = number48

												if number48 <= value69 then
													value60 = number48
													data11 = {}
													dataMap[data11] = value60 + 1
												else
													break
												end
											end

											value66 = data12[4]
											iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(dataMap, nil, nil)
											local value71 = table.pack(iter_f_1())

											if value71[1] then
												value64 = value71[3]

												while true do
													gameRef = (gameRef * value64 + value64 * 411) % 16776960 + 1
													local value72 = table.pack(iter_f_1())

													if value72[1] then
														value64 = value72[3]
													else
														break
													end
												end
											end

											number44 = number38 + value51
											number35 = 20084442667
											local number53 = bit32.band(number35, 4294967295)
											local number54 = bit32.band(number53, 65535)
											number37 = 1595630789 + bit32.band(31223 * number54 + bit32.lshift(bit32.band(31223 * bit32.rshift(number53, 16) + 5879 * number54, 65535), 16), 4294967295)
											number36 = 3524332562
											value55 = bit32.bor(2931427363, number35)
											local number55 = bit32.band(number36, 4294967295)
											local value72 = bit32.band(value55, 4294967295)
											local number56 = bit32.band(number55, 65535)
											local number57 = bit32.rshift(number55, 16)
											local value73 = bit32.band(value72, 65535)
											number34 = 12884901888
											number50 = (-8589934591 * (1 + ((number37 + bit32.band(number56 * value73 + bit32.lshift(bit32.band(number56 * bit32.rshift(value72, 16) + number57 * value73, 65535), 16), 4294967295) + 1712676800) * 67108864 + number34) / 4503599627370496) * 2 ^ 12884901911 + 1) % 16777216
											data10 = {}
											data13 = { 0, 6, 1, nil, value66 }

											while true do
												value63 = data13[3]
												value59 = data13[2]
												number41 = data13[1] + value63
												data13[1] = number41

												if number41 <= value59 then
													number50 = (number50 * 1103515245 + 12345) % 16777216
													data10[number41] = number50
												else
													break
												end
											end

											callback11 = (gameRef + data10[1]) % 16777216
											data15 = { data13[5], 1, nil, 6, 0 }

											while true do
												value70 = data15[2]
												value67 = data15[4]
												number45 = data15[5] + value70
												data15[5] = number45

												if number45 <= value67 then
													value62 = number45
													number43 = (callback11 * (data10[2] * 2 + 1) + data10[3]) % 16777216
													number28 = number43 % 4096
													callback11 = ((number28 * 4096 + (number43 - number43 % 4096) // 4096 + data10[4]) % 16777216 + value62 * data10[5]) % 16777216

													if nil then
														callback11 = (callback11 + data10[6]) % 16777216
													end
												else
													break
												end
											end

											data = data15[1]
											value57 = math_floor_precision

											if value31 ~= 134.00000000001432 then
												callback4((value57(gameRef) - callback11) % 16777216, 8)
												data17 = {}
												data14 = { data, 1, nil, -1, 16 }

												while true do
													value65 = data14[2]
													value58 = data14[5]
													number46 = data14[4] + value65
													data14[4] = number46

													if number46 <= value58 then
														number49 = number46
														data18 = {}
														data17[data18] = number49 + 1
													else
														break
													end
												end

												iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(data17, nil, nil)
												local value74 = table.pack(iter_f_1())

												if value74[1] then
													while true do
														local value75 = table.pack(iter_f_1())

														if value75[1] then
														else
															break
														end
													end
												end

												if value53 ~= 133 then
												end

												return data2()
											end

											continue
										end

										if value52 == 136.00000000002433 then
										end

										number4 = 43031001
										callback5()
									end
								end
							end

							local number52

							do
								if callback7(typeof(number39), "Enums") then
									callback3(65, 148593451)
								else
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
								end

								number52 = number38 + value37

								do
									local value71 = getmetatable(number39)

									if callback7("The metatable is locked", value71) then
										callback3(191, 148593451)
									else
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
									end
								end
							end

							local wedge = number39.PartType.Wedge

							if callback7(type(wedge), "userdata") then
								callback3(197, 148593451)
							else
								callback4(372868618, 4)
								number4 = 43031001
								callback5()
							end

							if callback7(typeof(wedge), "EnumItem") then
								do
									callback3(53, 148593451)

									do
										local value71 = getmetatable(wedge)

										if callback7("The metatable is locked", value71) then
											callback3(243, 148593451)
										else
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
										end
									end
								end

								local value71 = value36
								callback13(wedge.IsA, "IsA")
								callback19(wedge.IsA)
								local name = wedge.Name
								local value72 = wedge.Value

								if callback7(type(name), "string") then
									callback3(136, 148593451)
								else
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
								end

								if callback7(type(value72), "number") then
									callback3(154, 148593451)
								else
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
								end

								local enumType = wedge.EnumType

								if callback7(wedge, enumType[name]) then
									callback3(201, 148593451)
								else
									callback4(372868618, 4)
									number4 = 43031001
									callback5()
								end

								if callback7(type(enumType), "userdata") then
									do
										do
											callback3(96, 148593451)

											if callback7(typeof(enumType), "Enum") then
												callback3(231, 148593451)
											else
												callback4(372868618, 4)
												number4 = 43031001
												callback5()
												number52 = number52 + value38 - 132
											end

											do
												local value73 = getmetatable(enumType)

												if callback7("The metatable is locked", value73) then
													callback3(147, 148593451)
												else
													callback4(372868618, 4)
													number4 = 43031001
													callback5()
												end
											end
										end

										callback13(enumType.FromName, "FromName")
										callback13(enumType.FromValue, "FromValue")
										callback19(enumType.FromName)
										callback19(enumType.FromValue)

										do
											local value73 = enumType:FromName(name)

											if callback7(wedge, value73) then
												callback3(170, 148593451)
											else
												callback4(372868618, 4)
												number4 = 43031001
												callback5()
											end
										end
									end

									do
										local value73 = enumType:FromValue(value72)

										if callback7(wedge, value73) then
											callback3(70, 148593451)
										else
											callback4(372868618, 4)
											number4 = 43031001
											callback5()
										end
									end

									local new5 = value9.new
									callback13(new5, "new")
									callback19(new5, {})
									local value73 = new5(1902607061)

									if callback7(type(value73), "userdata") then
										callback3(177, 148593451)
										number4 = text2
									else
										callback4(372868618, 4)
										number4 = 43031001
										callback5()
									end

									if callback7(typeof(value73), "Random") then
										local clone, clone2, clone3

										do
											local clone4, clone5

											do
												do
													local value74

													do
														callback3(61, 148593451)
														callback13(value73.NextUnitVector, "NextUnitVector")
														callback13(value73.NextInteger, "NextInteger")
														callback13(value73.NextNumber, "NextNumber")
														callback13(value73.Shuffle, "Shuffle")
														callback13(value73.Clone, "Clone")
														value74 = new5(1542707265)

														do
															local unpack_2 = string.unpack
															local pack = string.pack
															local randNum = value74:NextNumber()
															callback4(unpack_2("<I4", pack("<f", randNum)), 4)
														end
													end

													do
														local clone6 = value74:Clone()
														callback4(value74:NextInteger(379, 733), 4)
														clone4 = value74:Clone()
														number = value74:NextInteger(6, 885)
														callback4(number, 4)
														clone = value74:Clone()
														clone5 = clone6
													end
												end

												number33 = clone:NextInteger(667, 1468)
												callback4(number33, 4)

												do
													local unpack_2 = string.unpack
													local pack = string.pack
													local randNum = clone:NextNumber()
													callback4(unpack_2(">I4", pack(">f", randNum)), 4)
												end
											end

											local clone6

											do
												clone2 = clone4:Clone()

												do
													local randInt = clone4:NextInteger(345, 719)
													callback4(randInt, 4)
													clone6 = clone2:Clone()
													callback4(clone:NextInteger(996, 1063), 4)
													local unpack_2 = string.unpack
													local pack = string.pack
													local randNum = clone4:NextNumber()
													callback4(unpack_2(">I4", pack(">f", randNum)), 4)
													callback20 = randInt
												end
											end

											clone3 = clone:Clone()

											do
												local unpack_2 = string.unpack
												local pack = string.pack
												local randNum = clone2:NextNumber()
												callback4(unpack_2("<I4", pack(">f", randNum)), 4)
											end

											callback4(clone6:NextInteger(417, 1147), 4)
											callback4(clone5:NextInteger(760, 1646), 4)
										end

										do
											local unpack_2 = string.unpack
											local pack = string.pack
											local randNum = clone3:NextNumber()
											callback4(unpack_2("<I4", pack("<f", randNum)), 4)
										end

										local number53, number54, number55, number56, data19

										do
											callback4(clone2:NextInteger(978, 1747), 4)
											callback4(clone:NextInteger(385, 609), 4)
											number53 = 316
											number54 = value71 + value39 + value40
											number55 = number52 + number28

											do
												local data20 = {
													[3527019990] = 316,
													[1402984568] = 79,
													[997645922] = 316,
													[1648908068] = 316,
													[3779981815] = 316,
													[2272476152] = 316,
													[2649626144] = 79,
													[2532183333] = 79,
													[3655592466] = 316,
													[638414791] = 79,
													[3621177636] = 316,
													[2303840004] = number53,
													[3630343396] = number53,
													[4280663915] = 79,
													[183578560] = 158,
													[3675778740] = 79,
													[703510772] = number53,
													[2829995296] = 79,
													[2369744814] = 79,
													[1793178485] = 79,
													[1805206170] = number53,
													[2309351533] = number53,
													[1081002712] = number53,
													[3900348838] = number53,
													[1980836295] = 79,
													[2616090782] = 79,
													[547114585] = number53,
													[1778055736] = number53,
													[1146902328] = 158,
													[855780562] = number53,
													[2901047036] = 79,
													[2137590078] = number53,
												}

												local env = getfenv()
												local envMap = {}
												local data21 = {}
												number56 = 0
												data19 = { nil, 0, 1, 3, data }

												while true do
													local value74 = data19[3]
													local value75 = data19[4]
													local number57 = data19[2] + value74
													data19[2] = number57

													if number57 <= value75 then
														if not nil and not nil then
															do
																envMap[env] = true

																do
																	local number58 = 0
																	iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(env, nil, nil)

																	for k in env, nil, nil do
																		number58 += 1

																		do
																			local valueType3 = type(k)

																			if callback7("string", valueType3) then
																				if #k < 20 then
																					local value76 = callback9(k, 51052561)

																					if data21[value76] then
																						if number58 > 50 then
																							break
																						end
																					else
																						number56 += data20[value76] or 0
																						data21[value76] = true
																						if number58 > 50 then
																							break
																						end
																					end
																				elseif number58 > 50 then
																					break
																				end
																			elseif number58 > 50 then
																				break
																			end
																		end
																	end
																end
															end

															do
																local number58 = number56
																local value76 = getmetatable(env)
																local condition6 = type(value76) == "table"
																local number59, value77

																if condition6 then
																	number59 = number58
																	value77 = rawget(value76, "__index")
																else
																	number59 = number58
																	value77 = condition6
																end

																if value77 then
																	do
																		local number60 = number59
																		env = value77
																		number56 = number60
																	end

																	continue
																end

																number56 = number59
															end

															env = nil
															continue
														end

														break
													else
														break
													end
												end
											end
										end

										do
											local value74 = data19[5]
											local number57 = number56 < number53 and 219 or 243
											callback3(number57, 148593451)

											if not nil then
												local number58, number59, value75

												do
													do
														local response4, response5, value76

														do
															do
																local ok3, value77

																do
																	local response6
																	ok3, response6 = pcall(assert, false)
																	value77 = response6
																end

																local ok4 = ok3 or not value77 or type(value77) ~= "string"

																if ok4 then
																	callback4(372868618, 4)
																	number4 = 43031001
																	callback5()
																end
															end

															do
																local ok3, value77

																do
																	local ok4, response6 = pcall(function(w, ...)
	(...)[...] = nil
end)

																	ok3 = ok4
																	value77 = response6
																end

																do
																	local ok4

																	ok4, response4 = pcall(function(w, ...)
	return (...)[...]
end)

																	local ok5

																	ok5, response5 = pcall(function(w, ...)
	return (...)()
end)

																	if ok3 or ok4 or ok5 then
																		callback4(372868618, 4)
																		number4 = 43031001
																		callback5()
																	end
																end

																do
																	local function callback21(argument, argument2)
																		local pos, value78, number60 = string.find(argument, ":[^%a%A]-([0-9][0-9]*)[\n:\r]")
																		local condition6 = not pos
																		local condition7

																		if pos then
																			condition7 = not value78
																		else
																			condition7 = condition6
																		end

																		if condition7 then
																			callback4(372868618, 4)
																			number4 = 43031001
																			callback5()
																		end

																		callback4(pos, 2)
																		callback4(value78, 2)
																		local match = string.match(argument, ":([%d]%d*)[^%l%L]-[\n\r%:]")
																		local callback22 = callback4
																		local match2

																		if number60 then
																			match2 = match
																		else
																			match2 = match
																			number60 = 0
																		end

																		callback22(number60 + 0, 2)
																		callback4((match2 or 0) + 0, 2)
																		local argument3 = string.gmatch(argument, "%:([%d]%d*)[^%p%P]*[\r:\n]")
																		local number61 = argument3()
																		local callback23 = callback7

																		if not callback7(argument3(), nil) then
																			callback4(372868618, 4)
																			number4 = 43031001
																			callback5()

																			if type(callback23) == "userdata" then
																				callback4(372868618, 4)

																				number4 = 43031001
																				;(nil)[">f"] = 100

																				while true do
																					while not (nil <= nil) do
																					end

																					callback4(372868618, 4)

																					number4 = 43031001
																					;(nil)[">f"] = 100
																				end
																			end
																		end

																		local callback24 = callback4
																		local callback25

																		if number61 then
																			callback25 = callback24
																		else
																			callback25 = callback24
																			number61 = 0
																		end

																		callback25(number61 + 0, 2)
																		local text3 = string.sub(argument, pos + 1, value78 - 1)
																		local argument4 = string.char(string.byte(argument, pos + 1, value78 - 1))
																		local argument5 = string.byte(argument, pos + 1, pos + 1)
																		callback4(text3 + 0, 2)
																		callback4(argument4 + 0, 2)
																		callback3(argument5, 148593451)
																		local data20 = { value78 - 1 + 0, nil, pos + 1 - 1, 1, nil }
																		local number62 = 0
																		local data21 = data20

																		while true do
																			local value79 = data21[4]
																			local value80 = data21[1]
																			local number63 = data21[3] + value79
																			data21[3] = number63

																			if number63 <= value80 then
																				number62 = number62 * 10 + string.byte(argument, number63, number63) - 48
																			else
																				break
																			end
																		end

																		callback4(number62, 2)
																		local value79 = nil
																		local number63 = 0
																		local number64 = 99901787

																		local function callback26(argument6)
																			value79 = argument6
																			local number65 = number63

																			if nil then
																				number64 = bit32.bxor(number64, 2666527995)
																			end

																			number63 = number65 + 1
																		end

																		number64 = 264577875
																		local text4, value80 = string.gsub(argument, "[%:][^%d%D]?([%d]+)[%:\n\r][^%u%U]*", callback26, 1)
																		callback7(number63, 1)

																		if nil then
																		else
																			callback4(372868618, 4)
																			number4 = 43031001
																			callback5()
																		end

																		callback7(value80, 1)

																		if not nil then
																			callback4(372868618, 4)
																			number4 = 43031001
																			callback5()
																		end

																		callback4((value79 or 0) + 0, 2)
																		callback7(string.sub(argument, 2, 2), argument2)
																		if nil then
																			callback3(string.byte(argument, 2, 2), 148593451)
																			return
																		end

																		while true do
																			callback4(372868618, 4)

																			number4 = 43031001
																			;(nil)[">f"] = 100

																			while not (nil <= nil) do
																			end
																		end
																	end

																	callback21("xisbLUyDc:111: attempt to call a userdata value", "i", 413312038)
																	callback21("LocalScript:101: attempt to index string with function", "o", 413312038)
																	callback21("LocalScript:132: attempt to index nil with string", "o", 413312038)
																	callback21("source.lua:110: attempt to index userdata with boolean", "o", 413312038)
																end

																value3 = function(argument)
																	local state = 1
																	local argument2, callback21, match, value78, pos, argument3, condition6, condition7, value79, number60, number61, gsub, number62, condition8, number63, number64, number65, number66, callback22

																	while true do
																		if state <= 40 then
																			if state <= 20 then
																				if state == 1 then
																					argument2 = argument
																					callback21 = nil
																					state = 2
																				elseif state == 2 then
																					match = string.match(argument2, "%:([0-9][0-9]*)[\n:\r]")
																					value78 = string.gmatch(argument2, "[%:](%d%d*)[^%w%W]*[\r%:\n]")()
																					local value80
																					pos, value80 = string.find(argument2, "[:][^%w%W]?(%d+)[%:\r\n]")
																					argument3 = value80
																					condition6 = not pos

																					if pos then
																						state = 4
																					else
																						state = 3
																					end
																				elseif state == 3 then
																					condition7 = condition6
																					state = 5
																				elseif state == 4 then
																					condition7 = not argument3
																					state = 5
																				elseif state == 5 then
																					if condition7 then
																						state = 6
																					else
																						state = 7
																					end
																				elseif state == 6 then
																					callback4(372868618, 4)
																					number4 = 43031001
																					callback5()
																					state = 7
																				elseif state == 7 then
																					local text3 = string.sub(argument2, pos + 1, argument3 - 1)
																					argument3 = string.char(string.byte(argument2, pos + 1, argument3 - 1))
																					value79 = nil
																					number60 = 0
																					number61 = 515348854
																					pos = text3

																					callback21 = function(argument4)
																						local info2 = info
																						local number67

																						if nil then
																							number67 = 1
																							number61 = bit32.bxor(number61, 2255202949)
																						else
																							-- This Source Was Generated by discord.gg/c3xVMnUUBv
																							number67 = 1
																						end

																						local value80 = info2(number67, "f")
																						callback7(value80, callback21)

																						if not nil then
																							callback4(372868618, 4)
																							number4 = 43031001
																							callback5()
																						end

																						local value81 = info(2, "f")
																						callback7(value81, string.gsub)

																						if not nil then
																							callback4(372868618, 4)
																							number4 = 43031001
																							callback5()
																						end

																						local value82 = info(3, "f")
																						callback7(value82, value3)

																						if not nil then
																							callback4(372868618, 4)
																							number4 = 43031001
																							callback5()
																						end

																						value79 = argument4
																						number60 = (number61 == 480569521) + 1
																					end

																					gsub = string.gsub
																					number62 = 480569521
																					state = 8
																				elseif state == 8 then
																					number61 = number62
																					local value80
																					value80, argument2 = gsub(argument2, "%:([%d]%d*)[^%s%S]-[:\n\r][^%u%U]*", callback21, 1)
																					callback7(number60, 1)

																					if nil then
																						state = 10
																					else
																						state = 9
																					end
																				elseif state == 9 then
																					state = 39
																				elseif state == 10 then
																					state = 11
																				elseif state == 11 then
																					callback7(argument2, 1)

																					if nil then
																						state = 12
																					else
																						state = 67
																					end
																				elseif state == 12 then
																					condition8 = not match

																					if match then
																						state = 14
																					else
																						state = 13
																					end
																				elseif state == 13 then
																					argument2 = condition8
																					state = 15
																				elseif state == 14 then
																					argument2 = not value78
																					state = 15
																				elseif state == 15 then
																					if argument2 then
																						state = 16
																					else
																						state = 74
																					end
																				elseif state == 16 then
																					if argument2 then
																						state = 17
																					else
																						state = 46
																					end
																				elseif state == 17 then
																					if argument2 then
																						state = 18
																					else
																						state = 72
																					end
																				elseif state == 18 then
																					if argument2 then
																						state = 19
																					else
																						state = 20
																					end
																				elseif state == 19 then
																					callback4(372868618, 4)
																					number4 = 43031001
																					callback5()
																					state = 20
																				elseif state == 20 then
																					argument2 = match + 0
																					number63 = value78 + 0
																					number64 = pos + 0
																					number65 = argument3 + 0
																					number66 = value79 + 0
																					callback22 = callback7
																					callback7(match, value78)

																					if nil then
																						state = 22
																					else
																						state = 21
																					end
																				end
																			elseif state == 21 then
																				match = number63
																				state = 58
																			elseif state == 22 then
																				match = number63
																				state = 23
																			elseif state == 23 then
																				callback7(value78, pos)

																				if nil then
																					state = 24
																				else
																					state = 69
																				end
																			elseif state == 24 then
																				callback7(pos, argument3)

																				if nil then
																					state = 25
																				else
																					state = 41
																				end
																			elseif state == 25 then
																				callback7(argument3, value79)

																				if nil then
																					state = 26
																				else
																					state = 38
																				end
																			elseif state == 26 then
																				callback7(argument2, match)

																				if nil then
																					state = 75
																				else
																					state = 27
																				end
																			elseif state == 27 then
																				callback4(372868618, 4)
																				number4 = 43031001
																				callback5()

																				if callback22 then
																					state = 75
																				else
																					state = 28
																				end
																			elseif state == 28 then
																				if nil then
																					state = 29
																				else
																					state = 14
																				end
																			elseif state == 29 then
																				if nil <= 17 then
																					state = 53
																				else
																					state = 30
																				end
																			elseif state == 30 then
																				if nil <= 26 then
																					state = 42
																				else
																					state = 31
																				end
																			elseif state == 31 then
																				if nil <= 30 then
																					state = 36
																				else
																					state = 32
																				end
																			elseif state == 32 then
																				if nil <= 32 then
																					state = 35
																				else
																					state = 33
																				end
																			elseif state == 33 then
																				if nil <= 33 then
																					state = 16
																				else
																					state = 34
																				end
																			elseif state == 34 then
																				if nil <= 34 then
																					state = 78
																				else
																					state = 75
																				end
																			elseif state == 35 then
																				if nil <= 31 then
																					state = 7
																				else
																					state = 18
																				end
																			elseif state == 36 then
																				if nil <= 28 then
																					state = 40
																				else
																					state = 37
																				end
																			elseif state == 37 then
																				if nil <= 29 then
																					state = 39
																				else
																					state = 38
																				end
																			elseif state == 38 then
																				callback4(372868618, 4)
																				number4 = 43031001
																				callback5()
																				state = 26
																			elseif state == 39 then
																				callback4(372868618, 4)
																				number4 = 43031001
																				callback5()
																				state = 11
																			elseif state == 40 then
																				if nil <= 27 then
																					state = 41
																				else
																					state = 80
																				end
																			end
																		elseif state <= 60 then
																			if state == 41 then
																				callback4(372868618, 4)
																				number4 = 43031001
																				callback5()
																				state = 25
																			elseif state == 42 then
																				if nil <= 21 then
																					state = 48
																				else
																					state = 43
																				end
																			elseif state == 43 then
																				if nil <= 23 then
																					state = 47
																				else
																					state = 44
																				end
																			elseif state == 44 then
																				if nil <= 24 then
																					state = 46
																				else
																					state = 45
																				end
																			elseif state == 45 then
																				if nil <= 25 then
																					state = 2
																				else
																					state = 6
																				end
																			elseif state == 46 then
																				argument2 = not argument3
																				state = 17
																			elseif state == 47 then
																				if nil <= 22 then
																					state = 6
																				else
																					state = 27
																				end
																			elseif state == 48 then
																				if nil <= 19 then
																					state = 51
																				else
																					state = 49
																				end
																			elseif state == 49 then
																				if nil <= 20 then
																					state = 14
																				else
																					state = 50
																				end
																			elseif state == 50 then
																				callback21 = function(argument4)
																					local info2 = info
																					local number67

																					if nil then
																						number67 = 1
																						number61 = bit32.bxor(number61, 2255202949)
																					else
																						number67 = 1
																					end

																					local value80 = info2(number67, "f")
																					callback7(value80, callback21)

																					if not nil then
																						callback4(372868618, 4)
																						number4 = 43031001
																						callback5()
																					end

																					local value81 = info(2, "f")
																					callback7(value81, string.gsub)

																					if not nil then
																						callback4(372868618, 4)
																						number4 = 43031001
																						callback5()
																					end

																					local value82 = info(3, "f")
																					callback7(value82, value3)

																					if not nil then
																						callback4(372868618, 4)
																						number4 = 43031001
																						callback5()
																					end

																					value79 = argument4
																					number60 = (number61 == 480569521) + 1
																				end

																				gsub = string.gsub
																				number62 = bit32.bxor(number61, 34828743)
																				state = 8
																			elseif state == 51 then
																				if nil <= 18 then
																					state = 52
																				else
																					state = 24
																				end
																			elseif state == 52 then
																				state = 14
																			elseif state == 53 then
																				if nil <= 8 then
																					state = 63
																				else
																					state = 54
																				end
																			elseif state == 54 then
																				if nil <= 12 then
																					state = 60
																				else
																					state = 55
																				end
																			elseif state == 55 then
																				if nil <= 14 then
																					state = 59
																				else
																					state = 56
																				end
																			elseif state == 56 then
																				if nil <= 15 then
																					state = 11
																				else
																					state = 57
																				end
																			elseif state == 57 then
																				if nil <= 16 then
																					state = 19
																				else
																					state = 58
																				end
																			elseif state == 58 then
																				callback4(372868618, 4)
																				number4 = 43031001
																				callback5()
																				state = 23
																			elseif state == 59 then
																				if nil <= 13 then
																					state = 17
																				else
																					state = 76
																				end
																			elseif state == 60 then
																				if nil <= 10 then
																					state = 62
																				else
																					state = 61
																				end
																			end
																		elseif state == 61 then
																			if nil <= 11 then
																				state = 23
																			else
																				state = 19
																			end
																		elseif state == 62 then
																			if nil <= 9 then
																				state = 77
																			else
																				state = 26
																			end
																		elseif state == 63 then
																			if nil <= 3 then
																				state = 70
																			else
																				state = 64
																			end
																		elseif state == 64 then
																			if nil <= 5 then
																				state = 68
																			else
																				state = 65
																			end
																		elseif state == 65 then
																			if nil <= 6 then
																				state = 67
																			else
																				state = 66
																			end
																		elseif state == 66 then
																			if nil <= 7 then
																				state = 79
																			else
																				state = 20
																			end
																		elseif state == 67 then
																			callback4(372868618, 4)
																			number4 = 43031001
																			callback5()
																			state = 12
																		elseif state == 68 then
																			if nil <= 4 then
																				state = 25
																			else
																				state = 69
																			end
																		elseif state == 69 then
																			callback4(372868618, 4)
																			number4 = 43031001
																			callback5()
																			state = 24
																		elseif state == 70 then
																			if nil <= 1 then
																				state = 73
																			else
																				state = 71
																			end
																		elseif state == 71 then
																			if nil <= 2 then
																				state = 72
																			else
																				state = 81
																			end
																		elseif state == 72 then
																			argument2 = not value79
																			state = 18
																		elseif state == 73 then
																			if nil <= 0 then
																				state = 4
																			else
																				state = 74
																			end
																		elseif state == 74 then
																			argument2 = not pos
																			state = 16
																		elseif state == 75 then
																			callback7(match, number64)

																			if nil then
																				state = 77
																			else
																				state = 76
																			end
																		elseif state == 76 then
																			callback4(372868618, 4)
																			number4 = 43031001
																			callback5()
																			state = 77
																		elseif state == 77 then
																			callback7(number64, number65)

																			if nil then
																				state = 79
																			else
																				state = 78
																			end
																		elseif state == 78 then
																			callback4(372868618, 4)
																			number4 = 43031001
																			callback5()
																			state = 79
																		elseif state == 79 then
																			callback7(number65, number66)

																			if nil then
																				state = 81
																			else
																				state = 80
																			end
																		elseif state == 80 then
																			callback4(372868618, 4)
																			number4 = 43031001
																			callback5()
																			state = 81
																		elseif state == 81 then
																			return argument2
																		end
																	end
																end

																value76 = value3(value77)
															end
														end

														do
															do
																do
																	local value77 = value3(response4)
																	local value78 = value3(response5)

																	if callback7(value76, value77) then
																		callback3(165, 148593451)
																		number4 = text2
																	else
																		callback4(372868618, 4)
																		number4 = 43031001
																		callback5()
																	end

																	if callback7(value77, value78) then
																		callback3(183, 148593451)
																	else
																		callback4(372868618, 4)
																		number4 = 43031001
																		callback5()
																	end

																	number58 = number55 + value41

																	if callback7(value78, value76) then
																		callback3(114, 148593451)
																	else
																		callback4(372868618, 4)
																		number4 = 43031001
																		callback5()
																	end
																end

																number59 = number54 + value42

																do
																	local data20 = {}
																	iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(data20, nil, nil)

																	for _, value77 in data20, nil, nil do
																		do
																			local exitTo2 = nil

																			while true do
																				local valueType3 = type(value77)

																				if callback7("function", valueType3) then
																					info(value77, "sl")
																					local value78 = table.pack(iter_f_1())

																					if value78[1] then
																						value77 = value78[3]
																					else
																						exitTo2 = 1
																						break
																					end
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

															callback11(nil --[[ the caller's registers ]], 505483899)
															setmetatable(nil --[[ the caller's registers ]], nil)

															do
																local data20 = {}
																local data21 = {}
																local number60 = 73
																local number61 = 71
																local data22 = { value74, 1, 255, nil, -1 }

																while true do
																	local value77 = data22[2]
																	local value78 = data22[3]
																	local number62 = data22[5] + value77
																	data22[5] = number62

																	if number62 <= value78 then
																		local number63 = number62
																		local number64 = (number60 * number63 + number61) % 256
																		local number65 = (number60 * number64 + number61) % 256
																		local number66 = (number60 * number65 + number61) % 256
																		local number67 = (number60 * number66 + number61) % 256
																		data20[number63] = number64 + number65 * 256 + number66 * 65536 + number67 * 16777216
																		data21[number63] = number67
																	else
																		break
																	end
																end

																value75 = data22[1]
															end
														end
													end

													buffer.create(16)

													do
														local number60 = 5
														local number61 = 6
														local number62 = 7
														local number63 = 8
														r__R3[number60] = 2
														r__R3[number61] = 6
														r__R3[number62] = 10
														r__R3[number63] = 14
													end
												end

												local number60, value76, number61, number62

												do
													local number63

													do
														do
															do
																local number64 = 15
																local number65 = 16
																r__R3[number64] = 12
																r__R3[number65] = 16
															end
														end

														number63 = number59 // value44

														do
															local number64 = 21
															local number65 = 22
															local number66 = 23
															local number67 = 24
															r__R3[number64] = 2
															r__R3[number65] = 7
															r__R3[number66] = 12
															r__R3[number67] = 13
														end
													end

													r__R3[32] = 15

													do
														local data20 = {}
														local number64 = number58 + value45
														number60 = 16705
														local data21 = { nil, value75, 16, -1, 1 }

														while true do
															local value77 = data21[5]
															local value78 = data21[3]
															local number65 = data21[4] + value77
															data21[4] = number65

															if number65 <= value78 then
																local number66 = number65
																data20[{}] = number66 + 1
															else
																break
															end
														end

														value76 = data21[2]
														iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(data20, nil, nil)
														local value77 = table.pack(iter_f_1())

														if value77[1] then
															local value78 = value77[3]

															while true do
																number60 = (number60 * value78 + value78 * 411) % 16776960 + 1
																local value79 = table.pack(iter_f_1())

																if value79[1] then
																	value78 = value79[3]
																else
																	break
																end
															end
														end

														number61 = number64 + value46
													end

													number62 = number63 - value47
												end

												local value77, number63, data20

												do
													local number64 = (-8589934591 * (1 + (8636599760 * 67108864 + 4294967296) / 4503599627370496) * 2 ^ 8589934615 + 1) % 16777216
													local data21 = {}
													local data22 = { 1, value76, 6, nil, 0 }

													while true do
														local value78 = data22[1]
														local value79 = data22[3]
														local number65 = data22[5] + value78
														data22[5] = number65

														if number65 <= value79 then
															number64 = (number64 * 1103515245 + 12345) % 16777216
															data21[number65] = number64
														else
															break
														end
													end

													value77 = data22[2]
													number63 = (number60 + data21[1]) % 16777216
													data20 = { nil, 6, 0, 1, value77 }

													while true do
														local value78 = data20[4]
														local value79 = data20[2]
														local number65 = data20[3] + value78
														condition5 = not (value78 <= 0)
														data20[3] = number65

														if number65 <= value79 then
															do
																local number66 = number65
																local number67 = (number63 * (data21[2] * 2 + 1) + data21[3]) % 16777216
																number63 = ((number67 % 4096 * 4096 + (number67 - number67 % 4096) // 4096 + data21[4]) % 16777216 + number66 * data21[5]) % 16777216
															end

															if nil then
																number63 = (number63 + data21[6]) % 16777216
															end
														else
															break
														end
													end
												end

												local data21

												do
													local value78 = data20[5]

													while true do
														callback4((math_floor_precision(number60) - number63) % 16777216, 8)

														if number62 == 339374311 then
														end

														if not (callback20 >= "function") then
															continue
														end
														break
													end

													Folder3 = "f"
													number39 = 16705
													data21 = { nil, 16, condition5, value78, value77 }
												end

												while true do
													local value78, number64, condition6

													do
														local value79 = data21[5]
														value78 = data21[2]
														number64 = data21[3] + value79
														condition6 = value79 <= 0
													end

													do
														local condition7 = not condition6
														local condition8 = number64 >= value78
														local condition9 = number64 <= value78

														if condition6 then
															if condition7 then
																condition8 = condition8 or condition9
															else
																condition9 = condition7
																condition8 = condition8 or condition9
															end
														else
															condition8 = condition6

															if condition7 then
																condition8 = condition8 or condition9
															else
																condition8 = condition8 or condition7
															end
														end

														data21[3] = number64

														if condition8 then
															do
																local number65 = number64
																number63[{}] = number65 + 1
															end

															continue
														end
													end

													break
												end

												do
													local value78 = data21[4]
													iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(number63, nil, nil)
													local value79 = table.pack(iter_f_1())

													if value79[1] then
														local value80 = value79[3]

														while true do
															number39 = (number39 * value80 + value80 * 411) % 16776960 + 1
															local value81 = table.pack(iter_f_1())

															if value81[1] then
																value80 = value81[3]
															else
																break
															end
														end
													end

													number28 = 8589934592
													local number64 = (-17179869183 * (1 + (8627448832 * 67108864 + number28) / 4503599627370496) * 2 ^ 4294967319 + 1) % 16777216
													number38 = number61 + value48 + value50
													data10 = {}
													data = { nil, 1, value78, 0, 6 }

													while true do
														local value80 = data[2]
														local value81 = data[5]
														local number65 = data[4] + value80
														data[4] = number65

														if number65 <= value81 then
															number64 = (number64 * 1103515245 + 12345) % 16777216
															data10[number65] = number64
														else
															break
														end
													end
												end

												number42 = (number39 + data10[1]) % 16777216
												data16 = { nil, 1, 6, 0, data[3] }

												while true do
													value61 = data16[2]
													value68 = data16[3]
													number40 = data16[4] + value61
													data16[4] = number40

													if number40 <= value68 then
														number47 = number40
														number51 = (number42 * (data10[2] * 2 + 1) + data10[3]) % 16777216
														number28 = number51 % 4096
														number42 = ((number28 * 4096 + (number51 - number51 % 4096) // 4096 + data10[4]) % 16777216 + number47 * data10[5]) % 16777216

														if nil then
															number42 = (number42 + data10[6]) % 16777216
														end
													else
														break
													end
												end

												value54 = data16[5]
												callback4((math_floor_precision(number39) - number42) % 16777216, 8)
												dataMap = {}
												gameRef = 16705
												data12 = { 16, 1, -1, value54, nil }

												while true do
													value56 = data12[2]
													value69 = data12[1]
													number48 = data12[3] + value56
													data12[3] = number48

													if number48 <= value69 then
														value60 = number48
														data11 = {}
														dataMap[data11] = value60 + 1
													else
														break
													end
												end

												value66 = data12[4]
												iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(dataMap, nil, nil)
												local value78 = table.pack(iter_f_1())

												if value78[1] then
													value64 = value78[3]

													while true do
														gameRef = (gameRef * value64 + value64 * 411) % 16776960 + 1
														local value79 = table.pack(iter_f_1())

														if value79[1] then
															value64 = value79[3]
														else
															break
														end
													end
												end

												number44 = number38 + value51
												number35 = 20084442667
												local number64 = bit32.band(number35, 4294967295)
												local number65 = bit32.band(number64, 65535)
												number37 = 1595630789 + bit32.band(31223 * number65 + bit32.lshift(bit32.band(31223 * bit32.rshift(number64, 16) + 5879 * number65, 65535), 16), 4294967295)
												number36 = 3524332562
												value55 = bit32.bor(2931427363, number35)
												local number66 = bit32.band(number36, 4294967295)
												local value79 = bit32.band(value55, 4294967295)
												local number67 = bit32.band(number66, 65535)
												local number68 = bit32.rshift(number66, 16)
												local value80 = bit32.band(value79, 65535)
												number34 = 12884901888
												number50 = (-8589934591 * (1 + ((number37 + bit32.band(number67 * value80 + bit32.lshift(bit32.band(number67 * bit32.rshift(value79, 16) + number68 * value80, 65535), 16), 4294967295) + 1712676800) * 67108864 + number34) / 4503599627370496) * 2 ^ 12884901911 + 1) % 16777216
												data10 = {}
												data13 = { 0, 6, 1, nil, value66 }

												while true do
													value63 = data13[3]
													value59 = data13[2]
													number41 = data13[1] + value63
													data13[1] = number41

													if number41 <= value59 then
														number50 = (number50 * 1103515245 + 12345) % 16777216
														data10[number41] = number50
													else
														break
													end
												end

												callback11 = (gameRef + data10[1]) % 16777216
												data15 = { data13[5], 1, nil, 6, 0 }

												while true do
													value70 = data15[2]
													value67 = data15[4]
													number45 = data15[5] + value70
													data15[5] = number45

													if number45 <= value67 then
														value62 = number45
														number43 = (callback11 * (data10[2] * 2 + 1) + data10[3]) % 16777216
														number28 = number43 % 4096
														callback11 = ((number28 * 4096 + (number43 - number43 % 4096) // 4096 + data10[4]) % 16777216 + value62 * data10[5]) % 16777216

														if nil then
															callback11 = (callback11 + data10[6]) % 16777216
														end
													else
														break
													end
												end

												data = data15[1]
												value57 = math_floor_precision

												if value31 ~= 134.00000000001432 then
													callback4((value57(gameRef) - callback11) % 16777216, 8)
													data17 = {}
													data14 = { data, 1, nil, -1, 16 }

													while true do
														value65 = data14[2]
														value58 = data14[5]
														number46 = data14[4] + value65
														data14[4] = number46

														if number46 <= value58 then
															number49 = number46
															data18 = {}
															data17[data18] = number49 + 1
														else
															break
														end
													end

													iter_f_1 = (function(iteratorFn, state, control) local co = coroutine.wrap(function() coroutine.yield(); for key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth in iteratorFn, state, control do coroutine.yield(true, key, item, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth) end end); co(); return co end)(data17, nil, nil)
													local value81 = table.pack(iter_f_1())

													if value81[1] then
														while true do
															local value82 = table.pack(iter_f_1())

															if value82[1] then
															else
																break
															end
														end
													end

													if value53 ~= 133 then
													end

													return data2()
												end

												continue
											end
										end

										while true do
										end
									else
										while true do
										end
									end
								else
									callback4(372868618, 4)
									number4 = 43031001
									callback5()

									while true do
									end
								end
							else
								while true do
								end
							end
						end
					end

					callback4(372868618, 4)
					number4 = 43031001
					callback5()

					while true do
					end
				end
			end
		else
			callback4(372868618, 4)
			number4 = 43031001
			callback5()

			while true do
			end
		end
	else
		while true do
		end
	end
else
	while true do
	end
end
print("Deobf By Zed")
