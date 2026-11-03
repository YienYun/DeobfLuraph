-- VM 717700_698577091@0,534819: root proto #1 (78 protos captured; Luraph loader, not called)
-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
-- unresolved: 1 captured values the walk could not follow across scopes.
-- They are nil here, so a function that needs one stops where the
-- original had a value; each use below says what shape it expected.
local unresolvedCapture1

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

local function vm_root_1(...)
		local number = 1034920903
		local value = nil
		local callback = nil
		local callback2 = nil
		local callback3 = nil
		local value2 = task
		local cancel = value2.cancel
		local spawn = value2.spawn
		local defer = value2.defer
		local delay = value2.delay
		local wait = value2.wait
	local value3, value4, value5, value6, value7, callback4, callback5, value8, info, traceback
	local number2, callback6, callback7, data, callback8, callback9, callback10, callback11, new, callback18
	local new2, new3

	do
		local value = Instance
		value3 = Vector3
		local value2 = Vector2
		value4 = CFrame
		value5 = Random
		value6 = identifyexecutor
		value7 = loadstring
		local data2 = { 11, 143, 143, 172, 5, 184, 208, 233, 73, 227, 7, 29 }
		local number3 = 12
		local data3 = { 211, 208, 62, 232, 147, 238, 162, 86, 91, 173, 227, 22 }
		local number4 = 12
		local number5 = 14868
		local data4 = {}
		local number6 = 0
		callback4 = function(argument, argument2)
			number6 += 1
			data4[number6] = argument2 % 256
		end

		callback5 = function(argument, argument2)
			local data5 = { argument2 + 0, nil, 1, nil, 0 }

			while true do
				local value9 = data5[3]
				local value10 = data5[1]
				local number7 = data5[5] + value9
				data5[5] = number7

				if number7 <= value10 then
					local number8 = argument % 256
					argument = (argument - number8) / 256
					number6 += 1
					data4[number6] = number8
				else
					break
				end
			end
		end

		local function callback12(argument)
			local number7 = 1873970225
			local data = data4
			local number = number6
			local data5 = {}
			local data6 = { -1, 255, 1, nil, nil }

			while true do
				local value9 = data6[3]
				local value10 = data6[2]
				local number8 = data6[1] + value9
				data6[1] = number8
				if number8 <= value10 then
					data5[number8] = number8
				else
					break
				end
			end

			local value9 = data6[5]
			local number8
			if number < 256 then
				number8 = 256
			else
				number8 = number
			end
			local number2 = number7
			local argument2 = bit32.band(argument, 4294967295)
			local number9 = bit32.band(number2, 65535)
			local number10 = bit32.rshift(number2, 16)
			local argument3 = bit32.band(argument2, 65535)
			local value10 = bit32.band(number9 * argument3 + bit32.lshift(bit32.band(number9 * bit32.rshift(argument2, 16) + number10 * argument3, 65535), 16), 4294967295)
			local data7 = { number8 - 1 + 0, value9, -1, 1, nil }
			local number11 = 0
			local data6 = data7

			while true do
				local value11 = data6[4]
				local value12 = data6[1]
				local number12 = data6[3] + value11
				data6[3] = number12

				if number12 <= value12 then
					local number2 = number12
					local number13 = bit32.band(number2, 255)
					number11 = bit32.band(number11 + data5[number13] + data[number2 % number + 1], 255)
					local value13 = data5[number13]
					data5[number13] = data5[number11]
					data5[number11] = value13
				else
					break
				end
			end

			local data8 = {}
			local data9 = { data6[2], 1, 32, 0, nil }
			local number12 = 0
			local number13 = 0

			while true do
				local value11 = data9[2]
				local value12 = data9[3]
				local number14 = data9[4] + value11
				data9[4] = number14

				if number14 <= value12 then
					number12 = bit32.band(number12 + 1, 255)
					number13 = bit32.band(number13 + data5[number12], 255)
					local value13 = data5[number12]
					data5[number12] = data5[number13]
					data5[number13] = value13
					data8[number14] = data5[bit32.band(data5[number12] + data5[number13], 255)]
				else
					break
				end
			end

			local value11 = data9[1]
			unresolvedCapture1[nil] = nil  -- unresolved: #1 table
			number6 = value10 ~= 221383074
			data4[number6] = 178
			local data = data4
			local number = number6
			local data10 = {}
			local data11 = { nil, 1, 255, -1, value11 }
			local number14 = 32
			local number15, condition

			while true do
				local value12 = data11[2]
				local value13 = data11[3]
				number15 = data11[4] + value12
				condition = number15 <= value13
				data11[4] = number15
				if condition then
					data10[number15] = number15
				else
					break
				end
			end

			local value12 = data11[5]
			local number16
			if number < 256 then
				number16 = 256
			else
				number16 = number
			end
			local condition2 = number16 == 0
			local number17, value13, value14, value15, number18, condition3, condition4, condition5, condition6, number2

			if condition2 then
				while true do
					number17 = bit32.band(condition2 + data[condition], 255)
					value13 = data10[number15]
					data10[number15] = data10[number17]
					data10[number17] = value13
					value14 = value12[2]
					value15 = value12[1]
					number18 = value12[5] + value14
					condition3 = value14 <= 0
					condition4 = not condition3
					condition5 = number18 >= value15
					condition6 = number18 <= value15

					if condition3 then
						if condition4 then
							condition5 = condition5 or condition6
						else
							condition6 = condition4
							condition5 = condition5 or condition6
						end
					else
						condition5 = condition3
						if condition4 then
							condition5 = condition5 or condition6
						else
							condition6 = condition4
							condition5 = condition5 or condition6
						end
					end

					value12[5] = number18

					if condition5 then
						number2 = number18
						number15 = bit32.band(number2, 255)
						condition2 = number17 + data10[number15]
						condition = number2 % number + 1
						continue
					end

					break
				end
			else
				local data12 = { number16 - 1 + 0, 1, value12, nil, -1 }
				number17 = 0
				value12 = data12
				value14 = value12[2]
				value15 = value12[1]
				number18 = value12[5] + value14
				condition3 = value14 <= 0
				condition4 = not condition3
				condition5 = number18 >= value15
				condition6 = number18 <= value15

				if condition3 then
					if condition4 then
						condition5 = condition5 or condition6
					else
						condition6 = condition4
						condition5 = condition5 or condition6
					end
				else
					condition5 = condition3
					if condition4 then
						condition5 = condition5 or condition6
					else
						condition6 = condition4
						condition5 = condition5 or condition6
					end
				end

				value12[5] = number18

				if condition5 then
					number2 = number18
					number15 = bit32.band(number2, 255)
					condition2 = number17 + data10[number15]
					condition = number2 % number + 1

					while true do
						number17 = bit32.band(condition2 + data[condition], 255)
						value13 = data10[number15]
						data10[number15] = data10[number17]
						data10[number17] = value13
						value14 = value12[2]
						value15 = value12[1]
						number18 = value12[5] + value14
						condition3 = value14 <= 0
						condition4 = not condition3
						condition5 = number18 >= value15
						condition6 = number18 <= value15

						if condition3 then
							if condition4 then
								condition5 = condition5 or condition6
							else
								condition6 = condition4
								condition5 = condition5 or condition6
							end
						else
							condition5 = condition3
							if condition4 then
								condition5 = condition5 or condition6
							else
								condition5 = condition5 or condition4
							end
						end

						value12[5] = number18

						if condition5 then
							number2 = number18
							number15 = bit32.band(number2, 255)
							condition2 = number17 + data10[number15]
							condition = number2 % number + 1
							continue
						end

						break
					end
				end
			end

			local data12 = {}
			local data13 = { 0, 1, 32, value12[3], nil }
			local number19 = 0
			local number20 = 0

			while true do
				local value16 = data13[2]
				local value17 = data13[3]
				local number21 = data13[1] + value16
				data13[1] = number21

				if number21 <= value17 then
					number19 = bit32.band(number19 + 1, 255)
					number20 = bit32.band(number20 + data10[number19], 255)
					local value18 = data10[number19]
					data10[number19] = data10[number20]
					data10[number20] = value18
					data12[number21] = data10[bit32.band(data10[number19] + data10[number20], 255)]
				else
					break
				end
			end

			local value16 = data13[4]
			data4[number6] = 0
			number6 -= 1
			local data14 = { nil, number3 + 0, 0, 1, value16 }
			local number21 = 32

			while true do
				local value17 = data14[4]
				local value18 = data14[2]
				local number22 = data14[3] + value17
				data14[3] = number22
				if number22 <= value18 then
					number14 += 1
					data8[number14] = data2[number22]
				else
					break
				end
			end

			local condition7 = value10 ~= 422139430
			local data15 = { condition7, 1 - condition7, nil, data14[5], number4 + 0 }

			while true do
				local value17 = data15[1]
				local value18 = data15[5]
				local number22 = data15[2] + value17
				local condition8 = value17 <= 0
				local condition9 = not condition8
				local condition10 = number22 >= value18
				local condition11 = number22 <= value18

				if condition8 then
					if condition9 then
						condition10 = condition10 or condition11
					else
						condition11 = condition9
						condition10 = condition10 or condition11
					end
				else
					condition10 = condition8
					if condition9 then
						condition10 = condition10 or condition11
					else
						condition10 = condition10 or condition9
					end
				end

				data15[2] = number22
				if condition10 then
					number21 += 1
					data12[number21] = data3[number22]
					continue
				end
				break
			end

			local data16 = {}
			local data17 = { -1, data15[4], 255, nil, 1 }

			while true do
				local value17 = data17[5]
				local value18 = data17[3]
				local number22 = data17[1] + value17
				data17[1] = number22
				if number22 <= value18 then
					data16[number22] = number22
				else
					break
				end
			end

			local value17 = data17[2]
			local number22
			if number14 < 256 then
				number22 = 256
			else
				number22 = number14
			end
			local data18 = { number22 - 1 + 0, -1, nil, 1, value17 }
			local number23 = 0
			local data = data18

			while true do
				local value18 = data[4]
				local value19 = data[1]
				local number24 = data[2] + value18
				data[2] = number24

				if number24 <= value19 then
					local number = number24
					local number25 = bit32.band(number, 255)
					number23 = bit32.band(number23 + data16[number25] + data8[number % number14 + 1], 255)
					local value20 = data16[number25]
					data16[number25] = data16[number23]
					data16[number23] = value20
				else
					break
				end
			end

			local data19 = {}
			local number24 = 255
			local value18 = nil
			local data20 = { data[5], value18, number24, -1, 1 }

			while true do
				local value19 = data20[5]
				local value20 = data20[3]
				local number25 = data20[4] + value19
				data20[4] = number25
				if number25 <= value20 then
					data19[number25] = number25
				else
					break
				end
			end

			local value19 = data20[1]
			local number25
			if number21 < 256 then
				number25 = 256
			else
				number25 = number21
			end
			local data21 = { value19, nil, value18, number24, number25 - 1 + 0 }
			local number26 = 0
			local data = data21

			while true do
				local value20 = data[4]
				local value21 = data[5]
				local number27 = data[3] + value20
				data[3] = number27

				if number27 <= value21 then
					local number = number27
					local number28 = bit32.band(number, 255)
					number26 = bit32.band(number26 + data19[number28] + data12[number % number21 + 1], 255)
					local value22 = data19[number28]
					data19[number28] = data19[number26]
					data19[number26] = value22
				else
					break
				end
			end

			local data22 = { 0, data[1], 1, number14 + 0, nil }

			while true do
				local value20 = data22[3]
				local value21 = data22[4]
				local number27 = data22[1] + value20
				data22[1] = number27
				if number27 <= value21 then
					data8[number27] = 0
				else
					break
				end
			end

			local data23 = { 0, data22[2], number21 + 0, nil, 1 }

			while true do
				local value20 = data23[5]
				local value21 = data23[3]
				local number27 = data23[1] + value20
				data23[1] = number27
				if number27 <= value21 then
					data12[number27] = 0
				else
					break
				end
			end

			local data24 = { nil, 1, data23[2], number6 + 0, 0 }

			while true do
				local value20 = data24[2]
				local value21 = data24[4]
				local number27 = data24[5] + value20
				data24[5] = number27
				if number27 <= value21 then
					data4[number27] = 0
				else
					break
				end
			end

			local data25 = { 0, nil, 1, number3 + 0, data24[3] }

			while true do
				local value20 = data25[3]
				local value21 = data25[4]
				local number27 = data25[1] + value20
				data25[1] = number27
				if number27 <= value21 then
					data2[number27] = 0
				else
					break
				end
			end

			local data26 = { nil, 1, 0, number4 + 0, data25[5] }

			while true do
				local value20 = data26[2]
				local value21 = data26[4]
				local number27 = data26[3] + value20
				data26[3] = number27
				-- This Source Was Generated by discord.gg/c3xVMnUUBv
				if number27 <= value21 then
					data3[number27] = 0
				else
					break
				end
			end

			number6 = 0
			number3 = 0
			number4 = 0
			return data16, data19
		end

		local function callback13(argument, argument2, argument3)
			local number7 = 1475694819
			local argument4 = bit32.bxor(argument3, 275072177)
			local value9, value10 = callback12(argument4)
			local value11, value12
			local value13 = luraph_runtime5(nil, table.pack(value12, value11, value9), nil)
			local value14 = value13()
			local data5 = { 1, -1, nil, 255, nil }
			local number

			while true do
				local value15 = data5[1]
				local value16 = data5[4]
				local number8 = data5[2] + value15
				data5[2] = number8
				if number8 <= value16 then
					number = number8
					value9[number] = 0
				else
					break
				end
			end

			local data6 = data5[5]
			local number8 = buffer.len(value14)
			local buf, number9

			if not value10 then
				data6[3] = number8
				local value15

				while true do
					value13 = bit32.band(value13 + 1, 255)
					value15 = bit32.band(value15 + value10[value13], 255)
					local value16 = value10[value13]
					value10[value13] = value10[value15]
					value10[value15] = value16
					local value17 = value10[bit32.band(value10[value13] + value10[value15], 255)]
					local value18 = bit32.bxor(buffer.readu8(value14, nil + number8), value17)
					buffer.writeu8(nil, number8, value18)
					local value19 = data6[2]
					local value20 = data6[4]
					number8 = data6[3] + value19
					local condition = value19 <= 0
					local condition2 = not condition
					local condition3 = number8 >= value20
					local condition4 = number8 <= value20

					if condition then
						if condition2 then
							condition3 = condition3 or condition4
						else
							condition4 = condition2
							condition3 = condition3 or condition4
						end
					else
						condition3 = condition
						if condition2 then
							condition3 = condition3 or condition4
						else
							condition3 = condition3 or condition2
						end
					end

					data6[3] = number8
					if condition3 then
						continue
					end
					break
				end
			else
				local number10 = number8 - 184 - 171
				if number5 < number10 then
					number = number5
				else
					number = number10
				end
				buf = buffer.create(number)
				local number11 = number % 4

				if not value13 then
					local number12 = bit32.band(bit32.rshift(number7, 29), 7)
					local number13 = bit32.band(bit32.bxor(number7, number12), 536870911)
					local value15 = bit32.bxor(24025679, number13)

					-- folded: 3 repetitions of a 6-statement bit32 chain
					local function mixBits(argument5)
						for _ = 1, 3 do
							local argument6 = bit32.lshift(argument5, 13)
							local argument7 = bit32.band(bit32.bxor(argument5, argument6), 536870911)
							local argument8 = bit32.rshift(argument7, 13)
							local argument9 = bit32.bxor(argument7, argument8)
							local argument10 = bit32.lshift(argument9, 14)
							argument5 = bit32.band(bit32.bxor(argument9, argument10), 536870911)
						end

						return argument5
					end

					local value16 = mixBits(value15)
					local value17 = table.pack(bit32.lshift(value16, 13))
				end

				local number12 = number - number11
				local number13 = 0
				local number14 = 0
				number9 = 184
				local data7 = { data6, number12 - 1 + 0, -4, nil, 4 }

				while true do
					local value15 = data7[5]
					local value16 = data7[2]
					local number15 = data7[3] + value15
					data7[3] = number15

					if number15 <= value16 then
						local number = number15
						local value17 = bit32.band(number13 + 1, 255)
						local value18 = bit32.band(number14 + value10[value17], 255)
						local value19 = value10[value17]
						value10[value17] = value10[value18]
						value10[value18] = value19
						local value20 = bit32.lshift(value10[bit32.band(value10[value17] + value10[value18], 255)], 0)
						local value21 = bit32.bor(0, value20)
						local value22 = bit32.band(value17 + 1, 255)
						local value23 = bit32.band(value18 + value10[value22], 255)
						local value24 = value10[value22]
						value10[value22] = value10[value23]
						value10[value23] = value24
						local value25 = bit32.lshift(value10[bit32.band(value10[value22] + value10[value23], 255)], 8)
						local value26 = bit32.bor(value21, value25)
						local value27 = bit32.band(value22 + 1, 255)
						local value28 = bit32.band(value23 + value10[value27], 255)
						local value29 = value10[value27]
						value10[value27] = value10[value28]
						value10[value28] = value29
						local value30 = bit32.lshift(value10[bit32.band(value10[value27] + value10[value28], 255)], 16)
						local value31 = bit32.bor(value26, value30)
						local value32 = bit32.band(value27 + 1, 255)
						local value33 = bit32.band(value28 + value10[value32], 255)
						local value34 = value10[value32]
						value10[value32] = value10[value33]
						value10[value33] = value34
						local value35 = bit32.lshift(value10[bit32.band(value10[value32] + value10[value33], 255)], 24)
						local value36 = bit32.bor(value31, value35)
						local value37 = bit32.bxor(buffer.readu32(value14, number9 + number), value36)
						buffer.writeu32(buf, number, value37)
						number13 = value32
						number14 = value33
					else
						break
					end
				end

				data6 = { nil, 1, number12 - 1, number - 1 + 0, data7[1] }

				while true do
					local value15 = data6[2]
					local value16 = data6[4]
					local number15 = data6[3] + value15
					data6[3] = number15

					if number15 <= value16 then
						number13 = bit32.band(number13 + 1, 255)
						number14 = bit32.band(number14 + value10[number13], 255)
						local value17 = value10[number13]
						value10[number13] = value10[number14]
						value10[number14] = value17
						local value18 = value10[bit32.band(value10[number13] + value10[number14], 255)]
						local value19 = bit32.bxor(buffer.readu8(value14, number9 + number15), value18)
						buffer.writeu8(buf, number15, value19)
					else
						break
					end
				end
			end

			local value15 = data6[5]
			buffer.copy(value14, number9, buf, 0, number)
			local data7 = { -1, value15, 1, nil, 255 }

			while true do
				local value16 = data7[3]
				local value17 = data7[5]
				local number10 = data7[1] + value16
				data7[1] = number10
				if number10 <= value17 then
					value10[number10] = 0
				else
					break
				end
			end

			return value14
		end

		value8 = assert(debug, "The debug library is required on Luau platforms. Please open a support ticket.")
		info = value8.info
		traceback = value8.traceback
		number2 = 90878521

		callback6 = function()
			local function callback14(argument, argument2, argument3, argument4, argument5)
				local number7 = 766702117
				local data5 = { argument2, argument3, argument4, argument5 }
				local data6 = { 4, nil, 1, nil, 0 }
				local value9, number8, number9, number10, number11, value10, value11, value12, value13, value14, value15, value16

				while true do
					local value17 = data6[3]
					local value18 = data6[1]
					local number12 = data6[5] + value17
					local condition = value17 <= 0
					local condition2 = not condition
					local condition3 = number12 >= value18
					local condition4 = number12 <= value18
					local value19, data7, value20, value21, number13, number, number14, value22, number15, number16, value23, number17, value24, number18, value25, value26, value27, value28, value29, number19, number20, value30, number21, number22, number23, value31, number24, number25, value32, number26, value33, number27, number28, value34, value35, value36, number29, number2, number30, value37, number31, number32, number33, value38, number34, number35, value39, number36, value40, number37, value41, number38, value42

					if condition then
						if condition2 then
							if condition3 then
								data6[5] = number12

								if condition3 then
									value19 = data5[number12]
									data7 = { #value19 + 0, nil, 0, data6, 1 }

									while true do
										value20 = data7[5]
										value21 = data7[1]
										number13 = data7[3] + value20
										data7[3] = number13

										if number13 <= value21 then
											number = number13
											number14 = bit32.band(number7, 766702116)
											local number39 = bit32.band(number, 4294967295)
											local number40 = bit32.band(number14, 4294967295)
											local number41 = bit32.band(number39, 65535)
											local number42 = bit32.rshift(number39, 16)
											local number43 = bit32.band(number40, 65535)
											local value43 = bit32.band(number41 * number43 + bit32.lshift(bit32.band(number41 * bit32.rshift(number40, 16) + number42 * number43, 65535), 16), 4294967295)
											local value44 = bit32.band(value43, 65535)
											value22 = bit32.band(173 * value44 + bit32.lshift(bit32.band(173 * bit32.rshift(value43, 16) + 26380 * value44, 65535), 16), 4294967295)
											number15 = bit32.lshift(bit32.band(number7, number), 1)
											local number44 = bit32.band(number15, 4294967295)
											local number45 = bit32.band(number44, 65535)
											number16 = number + 2913192108 + value22 + bit32.band(51373 * number45 + bit32.lshift(bit32.band(51373 * bit32.rshift(number44, 16) + 44451 * number45, 65535), 16), 4294967295)
											local number46 = bit32.band(number7, 4294967295)
											local number47 = bit32.band(number46, 65535)
											value23 = bit32.band(65535 * number47 + bit32.lshift(bit32.band(65535 * bit32.rshift(number46, 16) + 65535 * number47, 65535), 16), 4294967295)
											local number48 = bit32.bnot(number)
											local number49 = bit32.band(number14, 4294967295)
											local number50 = bit32.band(number48, 65535)
											local number51 = bit32.rshift(number48, 16)
											local number52 = bit32.band(number49, 65535)
											local value45 = bit32.band(number50 * number52 + bit32.lshift(bit32.band(number50 * bit32.rshift(number49, 16) + number51 * number52, 65535), 16), 4294967295)
											local value46 = bit32.band(value45, 65535)
											number17 = value23 + bit32.band(173 * value46 + bit32.lshift(bit32.band(173 * bit32.rshift(value45, 16) + 26380 * value46, 65535), 16), 4294967295)
											local number53 = bit32.bnot(number15)
											local number54 = bit32.band(number53, 65535)
											value24 = bit32.band(51372 * number54 + bit32.lshift(bit32.band(51372 * bit32.rshift(number53, 16) + 44451 * number54, 65535), 16), 4294967295)
											local number55 = bit32.band(number14, 4294967295)
											local number56 = bit32.band(number55, 65535)
											number18 = number16 + number17 + value24 + bit32.band(175 * number56 + bit32.lshift(bit32.band(175 * bit32.rshift(number55, 16) + 26380 * number56, 65535), 16), 4294967295)
											local number57 = bit32.band(number18, 4294967295)
											local number58 = bit32.band(number57, 65535)
											value25 = bit32.band(29058 * number58 + bit32.lshift(bit32.band(29058 * bit32.rshift(number57, 16) + 17264 * number58, 65535), 16), 4294967295)
											value26 = bit32.band(540259131, number18)
											local value47 = bit32.bnot(value26)
											local value48 = bit32.band(value47, 65535)
											value27 = bit32.band(29058 * value48 + bit32.lshift(bit32.band(29058 * bit32.rshift(value47, 16) + 17264 * value48, 65535), 16), 4294967295)
											local value49 = bit32.band(3754708164, number18)
											local value50 = bit32.band(value49, 65535)
											local value51 = bit32.band(1358017183 + value25 + value27 + bit32.band(36478 * value50 + bit32.lshift(bit32.band(36478 * bit32.rshift(value49, 16) + 48271 * value50, 65535), 16), 4294967295) - 8816509213, 4294967295)
											local value52 = bit32.band(value51, 65535)
											value28 = bit32.band(55612 * value52 + bit32.lshift(bit32.band(55612 * bit32.rshift(value51, 16) + 1030 * value52, 65535), 16), 4294967295)
											local number59 = bit32.band(number18, 4294967295)
											local number60 = bit32.band(number59, 65535)
											value29 = bit32.band(19250 * number60 + bit32.lshift(bit32.band(19250 * bit32.rshift(number59, 16) + 36273 * number60, 65535), 16), 4294967295)
											local number61 = bit32.band(number18, 4294967295)
											local number62 = bit32.band(number61, 65535)
											local value53 = bit32.band(number62 * 65535 + bit32.lshift(bit32.band(number62 * 32767 + bit32.rshift(number61, 16) * 65535, 65535), 16), 4294967295)
											local value54 = bit32.band(value53, 65535)
											number19 = value29 + bit32.band(19250 * value54 + bit32.lshift(bit32.band(19250 * bit32.rshift(value53, 16) + 36273 * value54, 65535), 16), 4294967295) + 1859921604
											number20 = bit32.band(number18, 540259131)
											local number63 = bit32.band(number20, 4294967295)
											local number64 = bit32.band(number63, 65535)
											local value55 = bit32.band(0 * number64 + bit32.lshift(bit32.band(0 * bit32.rshift(number63, 16) + 32768 * number64, 65535), 16), 4294967295)
											local value56 = bit32.band(value55, 65535)
											value30 = bit32.band(46286 * value56 + bit32.lshift(bit32.band(46286 * bit32.rshift(value55, 16) + 29262 * value56, 65535), 16), 4294967295)
											number21 = bit32.band(number18, 2147483647)
											local number65 = bit32.bnot(number21)
											local number66 = bit32.band(number65, 65535)
											number22 = value30 + bit32.band(9924 * number66 + bit32.lshift(bit32.band(9924 * bit32.rshift(number65, 16) + 28380 * number66, 65535), 16), 4294967295)
											local number67 = bit32.band(number20, 4294967295)
											local number68 = bit32.band(number67, 65535)
											number23 = number19 + number22 + 2136946346 + bit32.band(56210 * number68 + bit32.lshift(bit32.band(56210 * bit32.rshift(number67, 16) + 57642 * number68, 65535), 16), 4294967295)
											local number69 = bit32.band(number18, 4294967295)
											local number70 = bit32.band(number69, 65535)
											local value57 = bit32.band(number70 * 0 + bit32.lshift(bit32.band(number70 * 32768 + bit32.rshift(number69, 16) * 0, 65535), 16), 4294967295)
											local value58 = bit32.band(value57, 65535)
											value31 = bit32.band(19250 * value58 + bit32.lshift(bit32.band(19250 * bit32.rshift(value57, 16) + 36273 * value58, 65535), 16), 4294967295)
											local number71 = bit32.band(number20, 4294967295)
											local number72 = bit32.band(number71, 65535)
											local value59 = bit32.band(65535 * number72 + bit32.lshift(bit32.band(65535 * bit32.rshift(number71, 16) + 32767 * number72, 65535), 16), 4294967295)
											local value60 = bit32.band(value59, 65535)
											number24 = value31 + 2142122663 + bit32.band(46286 * value60 + bit32.lshift(bit32.band(46286 * bit32.rshift(value59, 16) + 29262 * value60, 65535), 16), 4294967295)
											number25 = bit32.bnot(number18)
											value32 = bit32.band(540259131, number25)
											local value61 = bit32.band(value32, 4294967295)
											local value62 = bit32.band(value61, 65535)
											number26 = bit32.band(9326 * value62 + bit32.lshift(bit32.band(9326 * bit32.rshift(value61, 16) + 7893 * value62, 65535), 16), 4294967295) + 0
											local value63 = bit32.band(value32, 4294967295)
											local value64 = bit32.band(value63, 65535)
											local value65 = bit32.band(65535 * value64 + bit32.lshift(bit32.band(65535 * bit32.rshift(value63, 16) + 32767 * value64, 65535), 16), 4294967295)
											local value66 = bit32.band(value65, 65535)
											value33 = bit32.band(19250 * value66 + bit32.lshift(bit32.band(19250 * bit32.rshift(value65, 16) + 36273 * value66, 65535), 16), 4294967295)
											local value67 = bit32.band(value32, 4294967295)
											local value68 = bit32.band(value67, 65535)
											local value69 = bit32.band(0 * value68 + bit32.lshift(bit32.band(0 * bit32.rshift(value67, 16) + 32768 * value68, 65535), 16), 4294967295)
											local value70 = bit32.band(value69, 65535)
											number27 = value28 + number23 + number24 + number26 + value33 + bit32.band(19250 * value70 + bit32.lshift(bit32.band(19250 * bit32.rshift(value69, 16) + 36273 * value70, 65535), 16), 4294967295)
											value19[number] = bit32.bxor(value19[number], 226574621)
											number28 = number7 + 368807284
											local number73 = bit32.band(number28, 4294967295)
											local number74 = bit32.band(number73, 65535)
											value34 = bit32.band(28395 * number74 + bit32.lshift(bit32.band(28395 * bit32.rshift(number73, 16) + 63595 * number74, 65535), 16), 4294967295)
											local number75 = bit32.band(number, 4294967295)
											local number76 = bit32.band(number75, 65535)
											value35 = bit32.band(number76 * 4119 + bit32.lshift(bit32.band(number76 * 13324 + bit32.rshift(number75, 16) * 4119, 65535), 16), 4294967295)
											local value71 = bit32.band(value35, 4294967295)
											local value72 = bit32.band(value71, 65535)
											value36 = bit32.band(51697 * value72 + bit32.lshift(bit32.band(51697 * bit32.rshift(value71, 16) + 64418 * value72, 65535), 16), 4294967295)
											local number77 = bit32.band(number28, 4294967295)
											local number78 = bit32.band(number77, 65535)
											local value73 = bit32.band(number78 * 28558 + bit32.lshift(bit32.band(number78 * 30626 + bit32.rshift(number77, 16) * 28558, 65535), 16), 4294967295)
											local value74 = bit32.band(value73, 65535)
											number29 = value34 + value36 + bit32.band(14556 * value74 + bit32.lshift(bit32.band(14556 * bit32.rshift(value73, 16) + 62478 * value74, 65535), 16), 4294967295)
											number2 = number28
											number30 = bit32.band(number27, 540259131) + 2084891872
											local number79 = bit32.band(number2, 4294967295)
											local number80 = bit32.band(number79, 65535)
											local value75 = bit32.band(number80 * 36977 + bit32.lshift(bit32.band(number80 * 34909 + bit32.rshift(number79, 16) * 36977, 65535), 16), 4294967295)
											local value76 = bit32.band(value75, 65535)
											value37 = bit32.band(14556 * value76 + bit32.lshift(bit32.band(14556 * bit32.rshift(value75, 16) + 62478 * value76, 65535), 16), 4294967295)
											local value77 = bit32.band(bit32.bnot(value35), number2)
											local value78 = bit32.band(value77, 65535)
											number31 = number29 + number30 + value37 + bit32.band(37858 * value78 + bit32.lshift(bit32.band(37858 * bit32.rshift(value77, 16) + 63301 * value78, 65535), 16), 4294967295)
											number32 = bit32.band(number31, 2147483647)
											number33 = bit32.bnot(number32)
											local number81 = bit32.band(number33, 4294967295)
											local number82 = bit32.band(number81, 65535)
											value38 = bit32.band(65535 * number82 + bit32.lshift(bit32.band(65535 * bit32.rshift(number81, 16) + 65535 * number82, 65535), 16), 4294967295)
											number34 = 3095950726 + value38 + 5493983865
											number35 = 591591182 + value38
											local number83 = bit32.band(number31, 4294967295)
											local number84 = bit32.band(number83, 65535)
											value39 = bit32.band(63247 * number84 + bit32.lshift(bit32.band(63247 * bit32.rshift(number83, 16) + 9026 * number84, 65535), 16), 4294967295)
											number36 = bit32.bnot(number31)
											local number85 = bit32.band(number36, 4294967295)
											local number86 = bit32.band(number85, 65535)
											local value79 = bit32.band(number34 - number35 + value39 + bit32.band(63247 * number86 + bit32.lshift(bit32.band(63247 * bit32.rshift(number85, 16) + 9026 * number86, 65535), 16), 4294967295), 4294967295)
											local value80 = bit32.band(value79, 65535)
											value40 = bit32.band(32428 * value80 + bit32.lshift(bit32.band(32428 * bit32.rshift(value79, 16) + 721 * value80, 65535), 16), 4294967295)
											local number87 = bit32.band(number31, 4294967295)
											local number88 = bit32.band(number33, 4294967295)
											local number89 = bit32.band(number87, 65535)
											local number90 = bit32.rshift(number87, 16)
											local number91 = bit32.band(number88, 65535)
											local value81 = bit32.band(number89 * number91 + bit32.lshift(bit32.band(number89 * bit32.rshift(number88, 16) + number90 * number91, 65535), 16), 4294967295)
											local value82 = bit32.band(value81, 65535)
											number37 = 4294967295 + bit32.band(58281 * value82 + bit32.lshift(bit32.band(58281 * bit32.rshift(value81, 16) + 59511 * value82, 65535), 16), 4294967295)
											local number92 = bit32.band(number33, 4294967295)
											local number93 = bit32.band(number92, 65535)
											value41 = bit32.band(58280 * number93 + bit32.lshift(bit32.band(58280 * bit32.rshift(number92, 16) + 59511 * number93, 65535), 16), 4294967295)
											number38 = bit32.bor(number36, 2147483648)
											local number94 = bit32.band(number31, 4294967295)
											local number95 = bit32.band(number38, 4294967295)
											local number96 = bit32.band(number94, 65535)
											local number97 = bit32.rshift(number94, 16)
											local number98 = bit32.band(number95, 65535)
											local value83 = bit32.band(number96 * number98 + bit32.lshift(bit32.band(number96 * bit32.rshift(number95, 16) + number97 * number98, 65535), 16), 4294967295)
											local value84 = bit32.band(value83, 65535)
											value42 = bit32.band(7255 * value84 + bit32.lshift(bit32.band(7255 * bit32.rshift(value83, 16) + 6024 * value84, 65535), 16), 4294967295)
											local number99 = bit32.band(number38, 4294967295)
											local number100 = bit32.band(number99, 65535)
											number7 = value40 + number37 + value41 + value42 + bit32.band(7255 * number100 + bit32.lshift(bit32.band(7255 * bit32.rshift(number99, 16) + 6024 * number100, 65535), 16), 4294967295)
										else
											break
										end
									end

									data6 = data7[4]
									continue
								end

								value9 = argument[6]
								number8 = buffer.len(value9) - 31 - 29
								number9 = 31 + 69333437 % number8
								number10 = 31

								while true do
									number11 = number10 + (number9 + bit32.band(number7, 255) + 1) % number8
									value10 = buffer.readu8(value9, number9)
									value11 = buffer.readi16(value9, number11)
									value12 = bit32.lshift(bit32.band(value11, 255), 3)
									value13 = bit32.band(bit32.bxor(bit32.bxor(766702117, value10) + value12 + 368807284, number9), 2147483647)
									value14 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value10, value11), value13), 2147483647), 589653504)
									buffer.writeu32(value9, number9, value14)
									value15 = bit32.rshift(value13, 8)
									value16 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value11, value15), number9), 2147483647), 610948608)
									buffer.writei8(value9, number11, value16)
									number9 = number10 + (number9 + bit32.band(value13, 63) + 1) % number8
									number7 = value13
								end
							else
								condition3 = condition4
								data6[5] = number12

								if condition3 then
									value19 = data5[number12]
									data7 = { #value19 + 0, nil, 0, data6, 1 }

									while true do
										value20 = data7[5]
										value21 = data7[1]
										number13 = data7[3] + value20
										data7[3] = number13

										if number13 <= value21 then
											number = number13
											number14 = bit32.band(number7, 766702116)
											local number39 = bit32.band(number, 4294967295)
											local number40 = bit32.band(number14, 4294967295)
											local number41 = bit32.band(number39, 65535)
											local number42 = bit32.rshift(number39, 16)
											local number43 = bit32.band(number40, 65535)
											local value43 = bit32.band(number41 * number43 + bit32.lshift(bit32.band(number41 * bit32.rshift(number40, 16) + number42 * number43, 65535), 16), 4294967295)
											local value44 = bit32.band(value43, 65535)
											value22 = bit32.band(173 * value44 + bit32.lshift(bit32.band(173 * bit32.rshift(value43, 16) + 26380 * value44, 65535), 16), 4294967295)
											number15 = bit32.lshift(bit32.band(number7, number), 1)
											local number44 = bit32.band(number15, 4294967295)
											local number45 = bit32.band(number44, 65535)
											number16 = number + 2913192108 + value22 + bit32.band(51373 * number45 + bit32.lshift(bit32.band(51373 * bit32.rshift(number44, 16) + 44451 * number45, 65535), 16), 4294967295)
											local number46 = bit32.band(number7, 4294967295)
											local number47 = bit32.band(number46, 65535)
											value23 = bit32.band(65535 * number47 + bit32.lshift(bit32.band(65535 * bit32.rshift(number46, 16) + 65535 * number47, 65535), 16), 4294967295)
											local number48 = bit32.bnot(number)
											local number49 = bit32.band(number14, 4294967295)
											local number50 = bit32.band(number48, 65535)
											local number51 = bit32.rshift(number48, 16)
											local number52 = bit32.band(number49, 65535)
											local value45 = bit32.band(number50 * number52 + bit32.lshift(bit32.band(number50 * bit32.rshift(number49, 16) + number51 * number52, 65535), 16), 4294967295)
											local value46 = bit32.band(value45, 65535)
											number17 = value23 + bit32.band(173 * value46 + bit32.lshift(bit32.band(173 * bit32.rshift(value45, 16) + 26380 * value46, 65535), 16), 4294967295)
											local number53 = bit32.bnot(number15)
											local number54 = bit32.band(number53, 65535)
											value24 = bit32.band(51372 * number54 + bit32.lshift(bit32.band(51372 * bit32.rshift(number53, 16) + 44451 * number54, 65535), 16), 4294967295)
											local number55 = bit32.band(number14, 4294967295)
											local number56 = bit32.band(number55, 65535)
											number18 = number16 + number17 + value24 + bit32.band(175 * number56 + bit32.lshift(bit32.band(175 * bit32.rshift(number55, 16) + 26380 * number56, 65535), 16), 4294967295)
											local number57 = bit32.band(number18, 4294967295)
											local number58 = bit32.band(number57, 65535)
											value25 = bit32.band(29058 * number58 + bit32.lshift(bit32.band(29058 * bit32.rshift(number57, 16) + 17264 * number58, 65535), 16), 4294967295)
											value26 = bit32.band(540259131, number18)
											local value47 = bit32.bnot(value26)
											local value48 = bit32.band(value47, 65535)
											value27 = bit32.band(29058 * value48 + bit32.lshift(bit32.band(29058 * bit32.rshift(value47, 16) + 17264 * value48, 65535), 16), 4294967295)
											local value49 = bit32.band(3754708164, number18)
											local value50 = bit32.band(value49, 65535)
											local value51 = bit32.band(1358017183 + value25 + value27 + bit32.band(36478 * value50 + bit32.lshift(bit32.band(36478 * bit32.rshift(value49, 16) + 48271 * value50, 65535), 16), 4294967295) - 8816509213, 4294967295)
											local value52 = bit32.band(value51, 65535)
											value28 = bit32.band(55612 * value52 + bit32.lshift(bit32.band(55612 * bit32.rshift(value51, 16) + 1030 * value52, 65535), 16), 4294967295)
											local number59 = bit32.band(number18, 4294967295)
											local number60 = bit32.band(number59, 65535)
											value29 = bit32.band(19250 * number60 + bit32.lshift(bit32.band(19250 * bit32.rshift(number59, 16) + 36273 * number60, 65535), 16), 4294967295)
											local number61 = bit32.band(number18, 4294967295)
											local number62 = bit32.band(number61, 65535)
											local value53 = bit32.band(number62 * 65535 + bit32.lshift(bit32.band(number62 * 32767 + bit32.rshift(number61, 16) * 65535, 65535), 16), 4294967295)
											local value54 = bit32.band(value53, 65535)
											number19 = value29 + bit32.band(19250 * value54 + bit32.lshift(bit32.band(19250 * bit32.rshift(value53, 16) + 36273 * value54, 65535), 16), 4294967295) + 1859921604
											number20 = bit32.band(number18, 540259131)
											local number63 = bit32.band(number20, 4294967295)
											local number64 = bit32.band(number63, 65535)
											local value55 = bit32.band(0 * number64 + bit32.lshift(bit32.band(0 * bit32.rshift(number63, 16) + 32768 * number64, 65535), 16), 4294967295)
											local value56 = bit32.band(value55, 65535)
											value30 = bit32.band(46286 * value56 + bit32.lshift(bit32.band(46286 * bit32.rshift(value55, 16) + 29262 * value56, 65535), 16), 4294967295)
											number21 = bit32.band(number18, 2147483647)
											local number65 = bit32.bnot(number21)
											local number66 = bit32.band(number65, 65535)
											number22 = value30 + bit32.band(9924 * number66 + bit32.lshift(bit32.band(9924 * bit32.rshift(number65, 16) + 28380 * number66, 65535), 16), 4294967295)
											local number67 = bit32.band(number20, 4294967295)
											local number68 = bit32.band(number67, 65535)
											number23 = number19 + number22 + 2136946346 + bit32.band(56210 * number68 + bit32.lshift(bit32.band(56210 * bit32.rshift(number67, 16) + 57642 * number68, 65535), 16), 4294967295)
											local number69 = bit32.band(number18, 4294967295)
											local number70 = bit32.band(number69, 65535)
											local value57 = bit32.band(number70 * 0 + bit32.lshift(bit32.band(number70 * 32768 + bit32.rshift(number69, 16) * 0, 65535), 16), 4294967295)
											local value58 = bit32.band(value57, 65535)
											value31 = bit32.band(19250 * value58 + bit32.lshift(bit32.band(19250 * bit32.rshift(value57, 16) + 36273 * value58, 65535), 16), 4294967295)
											local number71 = bit32.band(number20, 4294967295)
											local number72 = bit32.band(number71, 65535)
											local value59 = bit32.band(65535 * number72 + bit32.lshift(bit32.band(65535 * bit32.rshift(number71, 16) + 32767 * number72, 65535), 16), 4294967295)
											local value60 = bit32.band(value59, 65535)
											number24 = value31 + 2142122663 + bit32.band(46286 * value60 + bit32.lshift(bit32.band(46286 * bit32.rshift(value59, 16) + 29262 * value60, 65535), 16), 4294967295)
											number25 = bit32.bnot(number18)
											value32 = bit32.band(540259131, number25)
											local value61 = bit32.band(value32, 4294967295)
											local value62 = bit32.band(value61, 65535)
											number26 = bit32.band(9326 * value62 + bit32.lshift(bit32.band(9326 * bit32.rshift(value61, 16) + 7893 * value62, 65535), 16), 4294967295) + 0
											local value63 = bit32.band(value32, 4294967295)
											local value64 = bit32.band(value63, 65535)
											local value65 = bit32.band(65535 * value64 + bit32.lshift(bit32.band(65535 * bit32.rshift(value63, 16) + 32767 * value64, 65535), 16), 4294967295)
											local value66 = bit32.band(value65, 65535)
											value33 = bit32.band(19250 * value66 + bit32.lshift(bit32.band(19250 * bit32.rshift(value65, 16) + 36273 * value66, 65535), 16), 4294967295)
											local value67 = bit32.band(value32, 4294967295)
											local value68 = bit32.band(value67, 65535)
											local value69 = bit32.band(0 * value68 + bit32.lshift(bit32.band(0 * bit32.rshift(value67, 16) + 32768 * value68, 65535), 16), 4294967295)
											local value70 = bit32.band(value69, 65535)
											number27 = value28 + number23 + number24 + number26 + value33 + bit32.band(19250 * value70 + bit32.lshift(bit32.band(19250 * bit32.rshift(value69, 16) + 36273 * value70, 65535), 16), 4294967295)
											value19[number] = bit32.bxor(value19[number], 226574621)
											number28 = number7 + 368807284
											local number73 = bit32.band(number28, 4294967295)
											local number74 = bit32.band(number73, 65535)
											value34 = bit32.band(28395 * number74 + bit32.lshift(bit32.band(28395 * bit32.rshift(number73, 16) + 63595 * number74, 65535), 16), 4294967295)
											local number75 = bit32.band(number, 4294967295)
											local number76 = bit32.band(number75, 65535)
											value35 = bit32.band(number76 * 4119 + bit32.lshift(bit32.band(number76 * 13324 + bit32.rshift(number75, 16) * 4119, 65535), 16), 4294967295)
											local value71 = bit32.band(value35, 4294967295)
											local value72 = bit32.band(value71, 65535)
											value36 = bit32.band(51697 * value72 + bit32.lshift(bit32.band(51697 * bit32.rshift(value71, 16) + 64418 * value72, 65535), 16), 4294967295)
											local number77 = bit32.band(number28, 4294967295)
											local number78 = bit32.band(number77, 65535)
											local value73 = bit32.band(number78 * 28558 + bit32.lshift(bit32.band(number78 * 30626 + bit32.rshift(number77, 16) * 28558, 65535), 16), 4294967295)
											local value74 = bit32.band(value73, 65535)
											number29 = value34 + value36 + bit32.band(14556 * value74 + bit32.lshift(bit32.band(14556 * bit32.rshift(value73, 16) + 62478 * value74, 65535), 16), 4294967295)
											number2 = number28
											number30 = bit32.band(number27, 540259131) + 2084891872
											local number79 = bit32.band(number2, 4294967295)
											local number80 = bit32.band(number79, 65535)
											local value75 = bit32.band(number80 * 36977 + bit32.lshift(bit32.band(number80 * 34909 + bit32.rshift(number79, 16) * 36977, 65535), 16), 4294967295)
											local value76 = bit32.band(value75, 65535)
											value37 = bit32.band(14556 * value76 + bit32.lshift(bit32.band(14556 * bit32.rshift(value75, 16) + 62478 * value76, 65535), 16), 4294967295)
											local value77 = bit32.band(bit32.bnot(value35), number2)
											local value78 = bit32.band(value77, 65535)
											number31 = number29 + number30 + value37 + bit32.band(37858 * value78 + bit32.lshift(bit32.band(37858 * bit32.rshift(value77, 16) + 63301 * value78, 65535), 16), 4294967295)
											number32 = bit32.band(number31, 2147483647)
											number33 = bit32.bnot(number32)
											local number81 = bit32.band(number33, 4294967295)
											local number82 = bit32.band(number81, 65535)
											value38 = bit32.band(65535 * number82 + bit32.lshift(bit32.band(65535 * bit32.rshift(number81, 16) + 65535 * number82, 65535), 16), 4294967295)
											number34 = 3095950726 + value38 + 5493983865
											number35 = 591591182 + value38
											local number83 = bit32.band(number31, 4294967295)
											local number84 = bit32.band(number83, 65535)
											value39 = bit32.band(63247 * number84 + bit32.lshift(bit32.band(63247 * bit32.rshift(number83, 16) + 9026 * number84, 65535), 16), 4294967295)
											number36 = bit32.bnot(number31)
											local number85 = bit32.band(number36, 4294967295)
											local number86 = bit32.band(number85, 65535)
											local value79 = bit32.band(number34 - number35 + value39 + bit32.band(63247 * number86 + bit32.lshift(bit32.band(63247 * bit32.rshift(number85, 16) + 9026 * number86, 65535), 16), 4294967295), 4294967295)
											local value80 = bit32.band(value79, 65535)
											value40 = bit32.band(32428 * value80 + bit32.lshift(bit32.band(32428 * bit32.rshift(value79, 16) + 721 * value80, 65535), 16), 4294967295)
											local number87 = bit32.band(number31, 4294967295)
											local number88 = bit32.band(number33, 4294967295)
											local number89 = bit32.band(number87, 65535)
											local number90 = bit32.rshift(number87, 16)
											local number91 = bit32.band(number88, 65535)
											local value81 = bit32.band(number89 * number91 + bit32.lshift(bit32.band(number89 * bit32.rshift(number88, 16) + number90 * number91, 65535), 16), 4294967295)
											local value82 = bit32.band(value81, 65535)
											number37 = 4294967295 + bit32.band(58281 * value82 + bit32.lshift(bit32.band(58281 * bit32.rshift(value81, 16) + 59511 * value82, 65535), 16), 4294967295)
											local number92 = bit32.band(number33, 4294967295)
											local number93 = bit32.band(number92, 65535)
											value41 = bit32.band(58280 * number93 + bit32.lshift(bit32.band(58280 * bit32.rshift(number92, 16) + 59511 * number93, 65535), 16), 4294967295)
											number38 = bit32.bor(number36, 2147483648)
											local number94 = bit32.band(number31, 4294967295)
											local number95 = bit32.band(number38, 4294967295)
											local number96 = bit32.band(number94, 65535)
											local number97 = bit32.rshift(number94, 16)
											local number98 = bit32.band(number95, 65535)
											local value83 = bit32.band(number96 * number98 + bit32.lshift(bit32.band(number96 * bit32.rshift(number95, 16) + number97 * number98, 65535), 16), 4294967295)
											local value84 = bit32.band(value83, 65535)
											value42 = bit32.band(7255 * value84 + bit32.lshift(bit32.band(7255 * bit32.rshift(value83, 16) + 6024 * value84, 65535), 16), 4294967295)
											local number99 = bit32.band(number38, 4294967295)
											local number100 = bit32.band(number99, 65535)
											number7 = value40 + number37 + value41 + value42 + bit32.band(7255 * number100 + bit32.lshift(bit32.band(7255 * bit32.rshift(number99, 16) + 6024 * number100, 65535), 16), 4294967295)
										else
											break
										end
									end

									data6 = data7[4]
									continue
								end

								value9 = argument[6]
								number8 = buffer.len(value9) - 31 - 29
								number9 = 31 + 69333437 % number8
								number10 = 31

								while true do
									number11 = number10 + (number9 + bit32.band(number7, 255) + 1) % number8
									value10 = buffer.readu8(value9, number9)
									value11 = buffer.readi16(value9, number11)
									value12 = bit32.lshift(bit32.band(value11, 255), 3)
									value13 = bit32.band(bit32.bxor(bit32.bxor(766702117, value10) + value12 + 368807284, number9), 2147483647)
									value14 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value10, value11), value13), 2147483647), 589653504)
									buffer.writeu32(value9, number9, value14)
									value15 = bit32.rshift(value13, 8)
									value16 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value11, value15), number9), 2147483647), 610948608)
									buffer.writei8(value9, number11, value16)
									number9 = number10 + (number9 + bit32.band(value13, 63) + 1) % number8
									number7 = value13
								end
							end
						end
					else
						condition3 = condition

						if condition2 then
							if not condition3 then
								condition3 = condition4
								data6[5] = number12

								if condition3 then
									value19 = data5[number12]
									data7 = { #value19 + 0, nil, 0, data6, 1 }

									while true do
										value20 = data7[5]
										value21 = data7[1]
										number13 = data7[3] + value20
										data7[3] = number13

										if number13 <= value21 then
											number = number13
											number14 = bit32.band(number7, 766702116)
											local number39 = bit32.band(number, 4294967295)
											local number40 = bit32.band(number14, 4294967295)
											local number41 = bit32.band(number39, 65535)
											local number42 = bit32.rshift(number39, 16)
											local number43 = bit32.band(number40, 65535)
											local value43 = bit32.band(number41 * number43 + bit32.lshift(bit32.band(number41 * bit32.rshift(number40, 16) + number42 * number43, 65535), 16), 4294967295)
											local value44 = bit32.band(value43, 65535)
											value22 = bit32.band(173 * value44 + bit32.lshift(bit32.band(173 * bit32.rshift(value43, 16) + 26380 * value44, 65535), 16), 4294967295)
											number15 = bit32.lshift(bit32.band(number7, number), 1)
											local number44 = bit32.band(number15, 4294967295)
											local number45 = bit32.band(number44, 65535)
											number16 = number + 2913192108 + value22 + bit32.band(51373 * number45 + bit32.lshift(bit32.band(51373 * bit32.rshift(number44, 16) + 44451 * number45, 65535), 16), 4294967295)
											local number46 = bit32.band(number7, 4294967295)
											local number47 = bit32.band(number46, 65535)
											value23 = bit32.band(65535 * number47 + bit32.lshift(bit32.band(65535 * bit32.rshift(number46, 16) + 65535 * number47, 65535), 16), 4294967295)
											local number48 = bit32.bnot(number)
											local number49 = bit32.band(number14, 4294967295)
											local number50 = bit32.band(number48, 65535)
											local number51 = bit32.rshift(number48, 16)
											local number52 = bit32.band(number49, 65535)
											local value45 = bit32.band(number50 * number52 + bit32.lshift(bit32.band(number50 * bit32.rshift(number49, 16) + number51 * number52, 65535), 16), 4294967295)
											local value46 = bit32.band(value45, 65535)
											number17 = value23 + bit32.band(173 * value46 + bit32.lshift(bit32.band(173 * bit32.rshift(value45, 16) + 26380 * value46, 65535), 16), 4294967295)
											local number53 = bit32.bnot(number15)
											local number54 = bit32.band(number53, 65535)
											value24 = bit32.band(51372 * number54 + bit32.lshift(bit32.band(51372 * bit32.rshift(number53, 16) + 44451 * number54, 65535), 16), 4294967295)
											local number55 = bit32.band(number14, 4294967295)
											local number56 = bit32.band(number55, 65535)
											number18 = number16 + number17 + value24 + bit32.band(175 * number56 + bit32.lshift(bit32.band(175 * bit32.rshift(number55, 16) + 26380 * number56, 65535), 16), 4294967295)
											local number57 = bit32.band(number18, 4294967295)
											local number58 = bit32.band(number57, 65535)
											value25 = bit32.band(29058 * number58 + bit32.lshift(bit32.band(29058 * bit32.rshift(number57, 16) + 17264 * number58, 65535), 16), 4294967295)
											value26 = bit32.band(540259131, number18)
											local value47 = bit32.bnot(value26)
											local value48 = bit32.band(value47, 65535)
											value27 = bit32.band(29058 * value48 + bit32.lshift(bit32.band(29058 * bit32.rshift(value47, 16) + 17264 * value48, 65535), 16), 4294967295)
											local value49 = bit32.band(3754708164, number18)
											local value50 = bit32.band(value49, 65535)
											local value51 = bit32.band(1358017183 + value25 + value27 + bit32.band(36478 * value50 + bit32.lshift(bit32.band(36478 * bit32.rshift(value49, 16) + 48271 * value50, 65535), 16), 4294967295) - 8816509213, 4294967295)
											local value52 = bit32.band(value51, 65535)
											value28 = bit32.band(55612 * value52 + bit32.lshift(bit32.band(55612 * bit32.rshift(value51, 16) + 1030 * value52, 65535), 16), 4294967295)
											local number59 = bit32.band(number18, 4294967295)
											local number60 = bit32.band(number59, 65535)
											value29 = bit32.band(19250 * number60 + bit32.lshift(bit32.band(19250 * bit32.rshift(number59, 16) + 36273 * number60, 65535), 16), 4294967295)
											local number61 = bit32.band(number18, 4294967295)
											local number62 = bit32.band(number61, 65535)
											local value53 = bit32.band(number62 * 65535 + bit32.lshift(bit32.band(number62 * 32767 + bit32.rshift(number61, 16) * 65535, 65535), 16), 4294967295)
											local value54 = bit32.band(value53, 65535)
											number19 = value29 + bit32.band(19250 * value54 + bit32.lshift(bit32.band(19250 * bit32.rshift(value53, 16) + 36273 * value54, 65535), 16), 4294967295) + 1859921604
											number20 = bit32.band(number18, 540259131)
											local number63 = bit32.band(number20, 4294967295)
											local number64 = bit32.band(number63, 65535)
											local value55 = bit32.band(0 * number64 + bit32.lshift(bit32.band(0 * bit32.rshift(number63, 16) + 32768 * number64, 65535), 16), 4294967295)
											local value56 = bit32.band(value55, 65535)
											value30 = bit32.band(46286 * value56 + bit32.lshift(bit32.band(46286 * bit32.rshift(value55, 16) + 29262 * value56, 65535), 16), 4294967295)
											number21 = bit32.band(number18, 2147483647)
											local number65 = bit32.bnot(number21)
											local number66 = bit32.band(number65, 65535)
											number22 = value30 + bit32.band(9924 * number66 + bit32.lshift(bit32.band(9924 * bit32.rshift(number65, 16) + 28380 * number66, 65535), 16), 4294967295)
											local number67 = bit32.band(number20, 4294967295)
											local number68 = bit32.band(number67, 65535)
											number23 = number19 + number22 + 2136946346 + bit32.band(56210 * number68 + bit32.lshift(bit32.band(56210 * bit32.rshift(number67, 16) + 57642 * number68, 65535), 16), 4294967295)
											local number69 = bit32.band(number18, 4294967295)
											local number70 = bit32.band(number69, 65535)
											local value57 = bit32.band(number70 * 0 + bit32.lshift(bit32.band(number70 * 32768 + bit32.rshift(number69, 16) * 0, 65535), 16), 4294967295)
											local value58 = bit32.band(value57, 65535)
											value31 = bit32.band(19250 * value58 + bit32.lshift(bit32.band(19250 * bit32.rshift(value57, 16) + 36273 * value58, 65535), 16), 4294967295)
											local number71 = bit32.band(number20, 4294967295)
											local number72 = bit32.band(number71, 65535)
											local value59 = bit32.band(65535 * number72 + bit32.lshift(bit32.band(65535 * bit32.rshift(number71, 16) + 32767 * number72, 65535), 16), 4294967295)
											local value60 = bit32.band(value59, 65535)
											number24 = value31 + 2142122663 + bit32.band(46286 * value60 + bit32.lshift(bit32.band(46286 * bit32.rshift(value59, 16) + 29262 * value60, 65535), 16), 4294967295)
											number25 = bit32.bnot(number18)
											value32 = bit32.band(540259131, number25)
											local value61 = bit32.band(value32, 4294967295)
											local value62 = bit32.band(value61, 65535)
											number26 = bit32.band(9326 * value62 + bit32.lshift(bit32.band(9326 * bit32.rshift(value61, 16) + 7893 * value62, 65535), 16), 4294967295) + 0
											local value63 = bit32.band(value32, 4294967295)
											local value64 = bit32.band(value63, 65535)
											local value65 = bit32.band(65535 * value64 + bit32.lshift(bit32.band(65535 * bit32.rshift(value63, 16) + 32767 * value64, 65535), 16), 4294967295)
											local value66 = bit32.band(value65, 65535)
											value33 = bit32.band(19250 * value66 + bit32.lshift(bit32.band(19250 * bit32.rshift(value65, 16) + 36273 * value66, 65535), 16), 4294967295)
											local value67 = bit32.band(value32, 4294967295)
											local value68 = bit32.band(value67, 65535)
											local value69 = bit32.band(0 * value68 + bit32.lshift(bit32.band(0 * bit32.rshift(value67, 16) + 32768 * value68, 65535), 16), 4294967295)
											local value70 = bit32.band(value69, 65535)
											number27 = value28 + number23 + number24 + number26 + value33 + bit32.band(19250 * value70 + bit32.lshift(bit32.band(19250 * bit32.rshift(value69, 16) + 36273 * value70, 65535), 16), 4294967295)
											value19[number] = bit32.bxor(value19[number], 226574621)
											number28 = number7 + 368807284
											local number73 = bit32.band(number28, 4294967295)
											local number74 = bit32.band(number73, 65535)
											value34 = bit32.band(28395 * number74 + bit32.lshift(bit32.band(28395 * bit32.rshift(number73, 16) + 63595 * number74, 65535), 16), 4294967295)
											local number75 = bit32.band(number, 4294967295)
											local number76 = bit32.band(number75, 65535)
											value35 = bit32.band(number76 * 4119 + bit32.lshift(bit32.band(number76 * 13324 + bit32.rshift(number75, 16) * 4119, 65535), 16), 4294967295)
											local value71 = bit32.band(value35, 4294967295)
											local value72 = bit32.band(value71, 65535)
											value36 = bit32.band(51697 * value72 + bit32.lshift(bit32.band(51697 * bit32.rshift(value71, 16) + 64418 * value72, 65535), 16), 4294967295)
											local number77 = bit32.band(number28, 4294967295)
											local number78 = bit32.band(number77, 65535)
											local value73 = bit32.band(number78 * 28558 + bit32.lshift(bit32.band(number78 * 30626 + bit32.rshift(number77, 16) * 28558, 65535), 16), 4294967295)
											local value74 = bit32.band(value73, 65535)
											number29 = value34 + value36 + bit32.band(14556 * value74 + bit32.lshift(bit32.band(14556 * bit32.rshift(value73, 16) + 62478 * value74, 65535), 16), 4294967295)
											number2 = number28
											number30 = bit32.band(number27, 540259131) + 2084891872
											local number79 = bit32.band(number2, 4294967295)
											local number80 = bit32.band(number79, 65535)
											local value75 = bit32.band(number80 * 36977 + bit32.lshift(bit32.band(number80 * 34909 + bit32.rshift(number79, 16) * 36977, 65535), 16), 4294967295)
											local value76 = bit32.band(value75, 65535)
											value37 = bit32.band(14556 * value76 + bit32.lshift(bit32.band(14556 * bit32.rshift(value75, 16) + 62478 * value76, 65535), 16), 4294967295)
											local value77 = bit32.band(bit32.bnot(value35), number2)
											local value78 = bit32.band(value77, 65535)
											number31 = number29 + number30 + value37 + bit32.band(37858 * value78 + bit32.lshift(bit32.band(37858 * bit32.rshift(value77, 16) + 63301 * value78, 65535), 16), 4294967295)
											number32 = bit32.band(number31, 2147483647)
											number33 = bit32.bnot(number32)
											local number81 = bit32.band(number33, 4294967295)
											local number82 = bit32.band(number81, 65535)
											value38 = bit32.band(65535 * number82 + bit32.lshift(bit32.band(65535 * bit32.rshift(number81, 16) + 65535 * number82, 65535), 16), 4294967295)
											number34 = 3095950726 + value38 + 5493983865
											number35 = 591591182 + value38
											local number83 = bit32.band(number31, 4294967295)
											local number84 = bit32.band(number83, 65535)
											value39 = bit32.band(63247 * number84 + bit32.lshift(bit32.band(63247 * bit32.rshift(number83, 16) + 9026 * number84, 65535), 16), 4294967295)
											number36 = bit32.bnot(number31)
											local number85 = bit32.band(number36, 4294967295)
											local number86 = bit32.band(number85, 65535)
											local value79 = bit32.band(number34 - number35 + value39 + bit32.band(63247 * number86 + bit32.lshift(bit32.band(63247 * bit32.rshift(number85, 16) + 9026 * number86, 65535), 16), 4294967295), 4294967295)
											local value80 = bit32.band(value79, 65535)
											value40 = bit32.band(32428 * value80 + bit32.lshift(bit32.band(32428 * bit32.rshift(value79, 16) + 721 * value80, 65535), 16), 4294967295)
											local number87 = bit32.band(number31, 4294967295)
											local number88 = bit32.band(number33, 4294967295)
											local number89 = bit32.band(number87, 65535)
											local number90 = bit32.rshift(number87, 16)
											local number91 = bit32.band(number88, 65535)
											local value81 = bit32.band(number89 * number91 + bit32.lshift(bit32.band(number89 * bit32.rshift(number88, 16) + number90 * number91, 65535), 16), 4294967295)
											local value82 = bit32.band(value81, 65535)
											number37 = 4294967295 + bit32.band(58281 * value82 + bit32.lshift(bit32.band(58281 * bit32.rshift(value81, 16) + 59511 * value82, 65535), 16), 4294967295)
											local number92 = bit32.band(number33, 4294967295)
											local number93 = bit32.band(number92, 65535)
											value41 = bit32.band(58280 * number93 + bit32.lshift(bit32.band(58280 * bit32.rshift(number92, 16) + 59511 * number93, 65535), 16), 4294967295)
											number38 = bit32.bor(number36, 2147483648)
											local number94 = bit32.band(number31, 4294967295)
											local number95 = bit32.band(number38, 4294967295)
											local number96 = bit32.band(number94, 65535)
											local number97 = bit32.rshift(number94, 16)
											local number98 = bit32.band(number95, 65535)
											local value83 = bit32.band(number96 * number98 + bit32.lshift(bit32.band(number96 * bit32.rshift(number95, 16) + number97 * number98, 65535), 16), 4294967295)
											local value84 = bit32.band(value83, 65535)
											value42 = bit32.band(7255 * value84 + bit32.lshift(bit32.band(7255 * bit32.rshift(value83, 16) + 6024 * value84, 65535), 16), 4294967295)
											local number99 = bit32.band(number38, 4294967295)
											local number100 = bit32.band(number99, 65535)
											number7 = value40 + number37 + value41 + value42 + bit32.band(7255 * number100 + bit32.lshift(bit32.band(7255 * bit32.rshift(number99, 16) + 6024 * number100, 65535), 16), 4294967295)
										else
											break
										end
									end

									data6 = data7[4]
									continue
								end

								break
							end

							data6[5] = number12

							if condition3 then
								value19 = data5[number12]
								data7 = { #value19 + 0, nil, 0, data6, 1 }

								while true do
									value20 = data7[5]
									value21 = data7[1]
									number13 = data7[3] + value20
									data7[3] = number13

									if number13 <= value21 then
										number = number13
										number14 = bit32.band(number7, 766702116)
										local number39 = bit32.band(number, 4294967295)
										local number40 = bit32.band(number14, 4294967295)
										local number41 = bit32.band(number39, 65535)
										local number42 = bit32.rshift(number39, 16)
										local number43 = bit32.band(number40, 65535)
										local value43 = bit32.band(number41 * number43 + bit32.lshift(bit32.band(number41 * bit32.rshift(number40, 16) + number42 * number43, 65535), 16), 4294967295)
										local value44 = bit32.band(value43, 65535)
										value22 = bit32.band(173 * value44 + bit32.lshift(bit32.band(173 * bit32.rshift(value43, 16) + 26380 * value44, 65535), 16), 4294967295)
										number15 = bit32.lshift(bit32.band(number7, number), 1)
										local number44 = bit32.band(number15, 4294967295)
										local number45 = bit32.band(number44, 65535)
										number16 = number + 2913192108 + value22 + bit32.band(51373 * number45 + bit32.lshift(bit32.band(51373 * bit32.rshift(number44, 16) + 44451 * number45, 65535), 16), 4294967295)
										local number46 = bit32.band(number7, 4294967295)
										local number47 = bit32.band(number46, 65535)
										value23 = bit32.band(65535 * number47 + bit32.lshift(bit32.band(65535 * bit32.rshift(number46, 16) + 65535 * number47, 65535), 16), 4294967295)
										local number48 = bit32.bnot(number)
										local number49 = bit32.band(number14, 4294967295)
										local number50 = bit32.band(number48, 65535)
										local number51 = bit32.rshift(number48, 16)
										local number52 = bit32.band(number49, 65535)
										local value45 = bit32.band(number50 * number52 + bit32.lshift(bit32.band(number50 * bit32.rshift(number49, 16) + number51 * number52, 65535), 16), 4294967295)
										local value46 = bit32.band(value45, 65535)
										number17 = value23 + bit32.band(173 * value46 + bit32.lshift(bit32.band(173 * bit32.rshift(value45, 16) + 26380 * value46, 65535), 16), 4294967295)
										local number53 = bit32.bnot(number15)
										local number54 = bit32.band(number53, 65535)
										value24 = bit32.band(51372 * number54 + bit32.lshift(bit32.band(51372 * bit32.rshift(number53, 16) + 44451 * number54, 65535), 16), 4294967295)
										local number55 = bit32.band(number14, 4294967295)
										local number56 = bit32.band(number55, 65535)
										number18 = number16 + number17 + value24 + bit32.band(175 * number56 + bit32.lshift(bit32.band(175 * bit32.rshift(number55, 16) + 26380 * number56, 65535), 16), 4294967295)
										local number57 = bit32.band(number18, 4294967295)
										local number58 = bit32.band(number57, 65535)
										value25 = bit32.band(29058 * number58 + bit32.lshift(bit32.band(29058 * bit32.rshift(number57, 16) + 17264 * number58, 65535), 16), 4294967295)
										value26 = bit32.band(540259131, number18)
										local value47 = bit32.bnot(value26)
										local value48 = bit32.band(value47, 65535)
										value27 = bit32.band(29058 * value48 + bit32.lshift(bit32.band(29058 * bit32.rshift(value47, 16) + 17264 * value48, 65535), 16), 4294967295)
										local value49 = bit32.band(3754708164, number18)
										local value50 = bit32.band(value49, 65535)
										local value51 = bit32.band(1358017183 + value25 + value27 + bit32.band(36478 * value50 + bit32.lshift(bit32.band(36478 * bit32.rshift(value49, 16) + 48271 * value50, 65535), 16), 4294967295) - 8816509213, 4294967295)
										local value52 = bit32.band(value51, 65535)
										value28 = bit32.band(55612 * value52 + bit32.lshift(bit32.band(55612 * bit32.rshift(value51, 16) + 1030 * value52, 65535), 16), 4294967295)
										local number59 = bit32.band(number18, 4294967295)
										local number60 = bit32.band(number59, 65535)
										value29 = bit32.band(19250 * number60 + bit32.lshift(bit32.band(19250 * bit32.rshift(number59, 16) + 36273 * number60, 65535), 16), 4294967295)
										local number61 = bit32.band(number18, 4294967295)
										local number62 = bit32.band(number61, 65535)
										local value53 = bit32.band(number62 * 65535 + bit32.lshift(bit32.band(number62 * 32767 + bit32.rshift(number61, 16) * 65535, 65535), 16), 4294967295)
										local value54 = bit32.band(value53, 65535)
										number19 = value29 + bit32.band(19250 * value54 + bit32.lshift(bit32.band(19250 * bit32.rshift(value53, 16) + 36273 * value54, 65535), 16), 4294967295) + 1859921604
										number20 = bit32.band(number18, 540259131)
										local number63 = bit32.band(number20, 4294967295)
										local number64 = bit32.band(number63, 65535)
										local value55 = bit32.band(0 * number64 + bit32.lshift(bit32.band(0 * bit32.rshift(number63, 16) + 32768 * number64, 65535), 16), 4294967295)
										local value56 = bit32.band(value55, 65535)
										value30 = bit32.band(46286 * value56 + bit32.lshift(bit32.band(46286 * bit32.rshift(value55, 16) + 29262 * value56, 65535), 16), 4294967295)
										number21 = bit32.band(number18, 2147483647)
										local number65 = bit32.bnot(number21)
										local number66 = bit32.band(number65, 65535)
										number22 = value30 + bit32.band(9924 * number66 + bit32.lshift(bit32.band(9924 * bit32.rshift(number65, 16) + 28380 * number66, 65535), 16), 4294967295)
										local number67 = bit32.band(number20, 4294967295)
										local number68 = bit32.band(number67, 65535)
										number23 = number19 + number22 + 2136946346 + bit32.band(56210 * number68 + bit32.lshift(bit32.band(56210 * bit32.rshift(number67, 16) + 57642 * number68, 65535), 16), 4294967295)
										local number69 = bit32.band(number18, 4294967295)
										local number70 = bit32.band(number69, 65535)
										local value57 = bit32.band(number70 * 0 + bit32.lshift(bit32.band(number70 * 32768 + bit32.rshift(number69, 16) * 0, 65535), 16), 4294967295)
										local value58 = bit32.band(value57, 65535)
										value31 = bit32.band(19250 * value58 + bit32.lshift(bit32.band(19250 * bit32.rshift(value57, 16) + 36273 * value58, 65535), 16), 4294967295)
										local number71 = bit32.band(number20, 4294967295)
										local number72 = bit32.band(number71, 65535)
										local value59 = bit32.band(65535 * number72 + bit32.lshift(bit32.band(65535 * bit32.rshift(number71, 16) + 32767 * number72, 65535), 16), 4294967295)
										local value60 = bit32.band(value59, 65535)
										number24 = value31 + 2142122663 + bit32.band(46286 * value60 + bit32.lshift(bit32.band(46286 * bit32.rshift(value59, 16) + 29262 * value60, 65535), 16), 4294967295)
										number25 = bit32.bnot(number18)
										value32 = bit32.band(540259131, number25)
										local value61 = bit32.band(value32, 4294967295)
										local value62 = bit32.band(value61, 65535)
										number26 = bit32.band(9326 * value62 + bit32.lshift(bit32.band(9326 * bit32.rshift(value61, 16) + 7893 * value62, 65535), 16), 4294967295) + 0
										local value63 = bit32.band(value32, 4294967295)
										local value64 = bit32.band(value63, 65535)
										local value65 = bit32.band(65535 * value64 + bit32.lshift(bit32.band(65535 * bit32.rshift(value63, 16) + 32767 * value64, 65535), 16), 4294967295)
										local value66 = bit32.band(value65, 65535)
										value33 = bit32.band(19250 * value66 + bit32.lshift(bit32.band(19250 * bit32.rshift(value65, 16) + 36273 * value66, 65535), 16), 4294967295)
										local value67 = bit32.band(value32, 4294967295)
										local value68 = bit32.band(value67, 65535)
										local value69 = bit32.band(0 * value68 + bit32.lshift(bit32.band(0 * bit32.rshift(value67, 16) + 32768 * value68, 65535), 16), 4294967295)
										local value70 = bit32.band(value69, 65535)
										number27 = value28 + number23 + number24 + number26 + value33 + bit32.band(19250 * value70 + bit32.lshift(bit32.band(19250 * bit32.rshift(value69, 16) + 36273 * value70, 65535), 16), 4294967295)
										value19[number] = bit32.bxor(value19[number], 226574621)
										number28 = number7 + 368807284
										local number73 = bit32.band(number28, 4294967295)
										local number74 = bit32.band(number73, 65535)
										value34 = bit32.band(28395 * number74 + bit32.lshift(bit32.band(28395 * bit32.rshift(number73, 16) + 63595 * number74, 65535), 16), 4294967295)
										local number75 = bit32.band(number, 4294967295)
										local number76 = bit32.band(number75, 65535)
										value35 = bit32.band(number76 * 4119 + bit32.lshift(bit32.band(number76 * 13324 + bit32.rshift(number75, 16) * 4119, 65535), 16), 4294967295)
										local value71 = bit32.band(value35, 4294967295)
										local value72 = bit32.band(value71, 65535)
										value36 = bit32.band(51697 * value72 + bit32.lshift(bit32.band(51697 * bit32.rshift(value71, 16) + 64418 * value72, 65535), 16), 4294967295)
										local number77 = bit32.band(number28, 4294967295)
										local number78 = bit32.band(number77, 65535)
										local value73 = bit32.band(number78 * 28558 + bit32.lshift(bit32.band(number78 * 30626 + bit32.rshift(number77, 16) * 28558, 65535), 16), 4294967295)
										local value74 = bit32.band(value73, 65535)
										number29 = value34 + value36 + bit32.band(14556 * value74 + bit32.lshift(bit32.band(14556 * bit32.rshift(value73, 16) + 62478 * value74, 65535), 16), 4294967295)
										number2 = number28
										number30 = bit32.band(number27, 540259131) + 2084891872
										local number79 = bit32.band(number2, 4294967295)
										local number80 = bit32.band(number79, 65535)
										local value75 = bit32.band(number80 * 36977 + bit32.lshift(bit32.band(number80 * 34909 + bit32.rshift(number79, 16) * 36977, 65535), 16), 4294967295)
										local value76 = bit32.band(value75, 65535)
										value37 = bit32.band(14556 * value76 + bit32.lshift(bit32.band(14556 * bit32.rshift(value75, 16) + 62478 * value76, 65535), 16), 4294967295)
										local value77 = bit32.band(bit32.bnot(value35), number2)
										local value78 = bit32.band(value77, 65535)
										number31 = number29 + number30 + value37 + bit32.band(37858 * value78 + bit32.lshift(bit32.band(37858 * bit32.rshift(value77, 16) + 63301 * value78, 65535), 16), 4294967295)
										number32 = bit32.band(number31, 2147483647)
										number33 = bit32.bnot(number32)
										local number81 = bit32.band(number33, 4294967295)
										local number82 = bit32.band(number81, 65535)
										value38 = bit32.band(65535 * number82 + bit32.lshift(bit32.band(65535 * bit32.rshift(number81, 16) + 65535 * number82, 65535), 16), 4294967295)
										number34 = 3095950726 + value38 + 5493983865
										number35 = 591591182 + value38
										local number83 = bit32.band(number31, 4294967295)
										local number84 = bit32.band(number83, 65535)
										value39 = bit32.band(63247 * number84 + bit32.lshift(bit32.band(63247 * bit32.rshift(number83, 16) + 9026 * number84, 65535), 16), 4294967295)
										number36 = bit32.bnot(number31)
										local number85 = bit32.band(number36, 4294967295)
										local number86 = bit32.band(number85, 65535)
										local value79 = bit32.band(number34 - number35 + value39 + bit32.band(63247 * number86 + bit32.lshift(bit32.band(63247 * bit32.rshift(number85, 16) + 9026 * number86, 65535), 16), 4294967295), 4294967295)
										local value80 = bit32.band(value79, 65535)
										value40 = bit32.band(32428 * value80 + bit32.lshift(bit32.band(32428 * bit32.rshift(value79, 16) + 721 * value80, 65535), 16), 4294967295)
										local number87 = bit32.band(number31, 4294967295)
										local number88 = bit32.band(number33, 4294967295)
										local number89 = bit32.band(number87, 65535)
										local number90 = bit32.rshift(number87, 16)
										local number91 = bit32.band(number88, 65535)
										local value81 = bit32.band(number89 * number91 + bit32.lshift(bit32.band(number89 * bit32.rshift(number88, 16) + number90 * number91, 65535), 16), 4294967295)
										local value82 = bit32.band(value81, 65535)
										number37 = 4294967295 + bit32.band(58281 * value82 + bit32.lshift(bit32.band(58281 * bit32.rshift(value81, 16) + 59511 * value82, 65535), 16), 4294967295)
										local number92 = bit32.band(number33, 4294967295)
										local number93 = bit32.band(number92, 65535)
										value41 = bit32.band(58280 * number93 + bit32.lshift(bit32.band(58280 * bit32.rshift(number92, 16) + 59511 * number93, 65535), 16), 4294967295)
										number38 = bit32.bor(number36, 2147483648)
										local number94 = bit32.band(number31, 4294967295)
										local number95 = bit32.band(number38, 4294967295)
										local number96 = bit32.band(number94, 65535)
										local number97 = bit32.rshift(number94, 16)
										local number98 = bit32.band(number95, 65535)
										local value83 = bit32.band(number96 * number98 + bit32.lshift(bit32.band(number96 * bit32.rshift(number95, 16) + number97 * number98, 65535), 16), 4294967295)
										local value84 = bit32.band(value83, 65535)
										value42 = bit32.band(7255 * value84 + bit32.lshift(bit32.band(7255 * bit32.rshift(value83, 16) + 6024 * value84, 65535), 16), 4294967295)
										local number99 = bit32.band(number38, 4294967295)
										local number100 = bit32.band(number99, 65535)
										number7 = value40 + number37 + value41 + value42 + bit32.band(7255 * number100 + bit32.lshift(bit32.band(7255 * bit32.rshift(number99, 16) + 6024 * number100, 65535), 16), 4294967295)
									else
										break
									end
								end

								data6 = data7[4]
								continue
							end

							value9 = argument[6]
							number8 = buffer.len(value9) - 31 - 29
							number9 = 31 + 69333437 % number8
							number10 = 31

							while true do
								number11 = number10 + (number9 + bit32.band(number7, 255) + 1) % number8
								value10 = buffer.readu8(value9, number9)
								value11 = buffer.readi16(value9, number11)
								value12 = bit32.lshift(bit32.band(value11, 255), 3)
								value13 = bit32.band(bit32.bxor(bit32.bxor(766702117, value10) + value12 + 368807284, number9), 2147483647)
								value14 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value10, value11), value13), 2147483647), 589653504)
								buffer.writeu32(value9, number9, value14)
								value15 = bit32.rshift(value13, 8)
								value16 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value11, value15), number9), 2147483647), 610948608)
								buffer.writei8(value9, number11, value16)
								number9 = number10 + (number9 + bit32.band(value13, 63) + 1) % number8
								number7 = value13
							end
						end
					end

					condition4 = condition2

					if condition3 then
						data6[5] = number12

						if condition3 then
							value19 = data5[number12]
							data7 = { #value19 + 0, nil, 0, data6, 1 }

							while true do
								value20 = data7[5]
								value21 = data7[1]
								number13 = data7[3] + value20
								data7[3] = number13

								if number13 <= value21 then
									number = number13
									number14 = bit32.band(number7, 766702116)
									local number39 = bit32.band(number, 4294967295)
									local number40 = bit32.band(number14, 4294967295)
									local number41 = bit32.band(number39, 65535)
									local number42 = bit32.rshift(number39, 16)
									local number43 = bit32.band(number40, 65535)
									local value43 = bit32.band(number41 * number43 + bit32.lshift(bit32.band(number41 * bit32.rshift(number40, 16) + number42 * number43, 65535), 16), 4294967295)
									local value44 = bit32.band(value43, 65535)
									value22 = bit32.band(173 * value44 + bit32.lshift(bit32.band(173 * bit32.rshift(value43, 16) + 26380 * value44, 65535), 16), 4294967295)
									number15 = bit32.lshift(bit32.band(number7, number), 1)
									local number44 = bit32.band(number15, 4294967295)
									local number45 = bit32.band(number44, 65535)
									number16 = number + 2913192108 + value22 + bit32.band(51373 * number45 + bit32.lshift(bit32.band(51373 * bit32.rshift(number44, 16) + 44451 * number45, 65535), 16), 4294967295)
									local number46 = bit32.band(number7, 4294967295)
									local number47 = bit32.band(number46, 65535)
									value23 = bit32.band(65535 * number47 + bit32.lshift(bit32.band(65535 * bit32.rshift(number46, 16) + 65535 * number47, 65535), 16), 4294967295)
									local number48 = bit32.bnot(number)
									local number49 = bit32.band(number14, 4294967295)
									local number50 = bit32.band(number48, 65535)
									local number51 = bit32.rshift(number48, 16)
									local number52 = bit32.band(number49, 65535)
									local value45 = bit32.band(number50 * number52 + bit32.lshift(bit32.band(number50 * bit32.rshift(number49, 16) + number51 * number52, 65535), 16), 4294967295)
									local value46 = bit32.band(value45, 65535)
									number17 = value23 + bit32.band(173 * value46 + bit32.lshift(bit32.band(173 * bit32.rshift(value45, 16) + 26380 * value46, 65535), 16), 4294967295)
									local number53 = bit32.bnot(number15)
									local number54 = bit32.band(number53, 65535)
									value24 = bit32.band(51372 * number54 + bit32.lshift(bit32.band(51372 * bit32.rshift(number53, 16) + 44451 * number54, 65535), 16), 4294967295)
									local number55 = bit32.band(number14, 4294967295)
									local number56 = bit32.band(number55, 65535)
									number18 = number16 + number17 + value24 + bit32.band(175 * number56 + bit32.lshift(bit32.band(175 * bit32.rshift(number55, 16) + 26380 * number56, 65535), 16), 4294967295)
									local number57 = bit32.band(number18, 4294967295)
									local number58 = bit32.band(number57, 65535)
									value25 = bit32.band(29058 * number58 + bit32.lshift(bit32.band(29058 * bit32.rshift(number57, 16) + 17264 * number58, 65535), 16), 4294967295)
									value26 = bit32.band(540259131, number18)
									local value47 = bit32.bnot(value26)
									local value48 = bit32.band(value47, 65535)
									value27 = bit32.band(29058 * value48 + bit32.lshift(bit32.band(29058 * bit32.rshift(value47, 16) + 17264 * value48, 65535), 16), 4294967295)
									local value49 = bit32.band(3754708164, number18)
									local value50 = bit32.band(value49, 65535)
									local value51 = bit32.band(1358017183 + value25 + value27 + bit32.band(36478 * value50 + bit32.lshift(bit32.band(36478 * bit32.rshift(value49, 16) + 48271 * value50, 65535), 16), 4294967295) - 8816509213, 4294967295)
									local value52 = bit32.band(value51, 65535)
									value28 = bit32.band(55612 * value52 + bit32.lshift(bit32.band(55612 * bit32.rshift(value51, 16) + 1030 * value52, 65535), 16), 4294967295)
									local number59 = bit32.band(number18, 4294967295)
									local number60 = bit32.band(number59, 65535)
									value29 = bit32.band(19250 * number60 + bit32.lshift(bit32.band(19250 * bit32.rshift(number59, 16) + 36273 * number60, 65535), 16), 4294967295)
									local number61 = bit32.band(number18, 4294967295)
									local number62 = bit32.band(number61, 65535)
									local value53 = bit32.band(number62 * 65535 + bit32.lshift(bit32.band(number62 * 32767 + bit32.rshift(number61, 16) * 65535, 65535), 16), 4294967295)
									local value54 = bit32.band(value53, 65535)
									number19 = value29 + bit32.band(19250 * value54 + bit32.lshift(bit32.band(19250 * bit32.rshift(value53, 16) + 36273 * value54, 65535), 16), 4294967295) + 1859921604
									number20 = bit32.band(number18, 540259131)
									local number63 = bit32.band(number20, 4294967295)
									local number64 = bit32.band(number63, 65535)
									local value55 = bit32.band(0 * number64 + bit32.lshift(bit32.band(0 * bit32.rshift(number63, 16) + 32768 * number64, 65535), 16), 4294967295)
									local value56 = bit32.band(value55, 65535)
									value30 = bit32.band(46286 * value56 + bit32.lshift(bit32.band(46286 * bit32.rshift(value55, 16) + 29262 * value56, 65535), 16), 4294967295)
									number21 = bit32.band(number18, 2147483647)
									local number65 = bit32.bnot(number21)
									local number66 = bit32.band(number65, 65535)
									number22 = value30 + bit32.band(9924 * number66 + bit32.lshift(bit32.band(9924 * bit32.rshift(number65, 16) + 28380 * number66, 65535), 16), 4294967295)
									local number67 = bit32.band(number20, 4294967295)
									local number68 = bit32.band(number67, 65535)
									number23 = number19 + number22 + 2136946346 + bit32.band(56210 * number68 + bit32.lshift(bit32.band(56210 * bit32.rshift(number67, 16) + 57642 * number68, 65535), 16), 4294967295)
									local number69 = bit32.band(number18, 4294967295)
									local number70 = bit32.band(number69, 65535)
									local value57 = bit32.band(number70 * 0 + bit32.lshift(bit32.band(number70 * 32768 + bit32.rshift(number69, 16) * 0, 65535), 16), 4294967295)
									local value58 = bit32.band(value57, 65535)
									value31 = bit32.band(19250 * value58 + bit32.lshift(bit32.band(19250 * bit32.rshift(value57, 16) + 36273 * value58, 65535), 16), 4294967295)
									local number71 = bit32.band(number20, 4294967295)
									local number72 = bit32.band(number71, 65535)
									local value59 = bit32.band(65535 * number72 + bit32.lshift(bit32.band(65535 * bit32.rshift(number71, 16) + 32767 * number72, 65535), 16), 4294967295)
									local value60 = bit32.band(value59, 65535)
									number24 = value31 + 2142122663 + bit32.band(46286 * value60 + bit32.lshift(bit32.band(46286 * bit32.rshift(value59, 16) + 29262 * value60, 65535), 16), 4294967295)
									number25 = bit32.bnot(number18)
									value32 = bit32.band(540259131, number25)
									local value61 = bit32.band(value32, 4294967295)
									local value62 = bit32.band(value61, 65535)
									number26 = bit32.band(9326 * value62 + bit32.lshift(bit32.band(9326 * bit32.rshift(value61, 16) + 7893 * value62, 65535), 16), 4294967295) + 0
									local value63 = bit32.band(value32, 4294967295)
									local value64 = bit32.band(value63, 65535)
									local value65 = bit32.band(65535 * value64 + bit32.lshift(bit32.band(65535 * bit32.rshift(value63, 16) + 32767 * value64, 65535), 16), 4294967295)
									local value66 = bit32.band(value65, 65535)
									value33 = bit32.band(19250 * value66 + bit32.lshift(bit32.band(19250 * bit32.rshift(value65, 16) + 36273 * value66, 65535), 16), 4294967295)
									local value67 = bit32.band(value32, 4294967295)
									local value68 = bit32.band(value67, 65535)
									local value69 = bit32.band(0 * value68 + bit32.lshift(bit32.band(0 * bit32.rshift(value67, 16) + 32768 * value68, 65535), 16), 4294967295)
									local value70 = bit32.band(value69, 65535)
									number27 = value28 + number23 + number24 + number26 + value33 + bit32.band(19250 * value70 + bit32.lshift(bit32.band(19250 * bit32.rshift(value69, 16) + 36273 * value70, 65535), 16), 4294967295)
									value19[number] = bit32.bxor(value19[number], 226574621)
									number28 = number7 + 368807284
									local number73 = bit32.band(number28, 4294967295)
									local number74 = bit32.band(number73, 65535)
									value34 = bit32.band(28395 * number74 + bit32.lshift(bit32.band(28395 * bit32.rshift(number73, 16) + 63595 * number74, 65535), 16), 4294967295)
									local number75 = bit32.band(number, 4294967295)
									local number76 = bit32.band(number75, 65535)
									value35 = bit32.band(number76 * 4119 + bit32.lshift(bit32.band(number76 * 13324 + bit32.rshift(number75, 16) * 4119, 65535), 16), 4294967295)
									local value71 = bit32.band(value35, 4294967295)
									local value72 = bit32.band(value71, 65535)
									value36 = bit32.band(51697 * value72 + bit32.lshift(bit32.band(51697 * bit32.rshift(value71, 16) + 64418 * value72, 65535), 16), 4294967295)
									local number77 = bit32.band(number28, 4294967295)
									local number78 = bit32.band(number77, 65535)
									local value73 = bit32.band(number78 * 28558 + bit32.lshift(bit32.band(number78 * 30626 + bit32.rshift(number77, 16) * 28558, 65535), 16), 4294967295)
									local value74 = bit32.band(value73, 65535)
									number29 = value34 + value36 + bit32.band(14556 * value74 + bit32.lshift(bit32.band(14556 * bit32.rshift(value73, 16) + 62478 * value74, 65535), 16), 4294967295)
									number2 = number28
									number30 = bit32.band(number27, 540259131) + 2084891872
									local number79 = bit32.band(number2, 4294967295)
									local number80 = bit32.band(number79, 65535)
									local value75 = bit32.band(number80 * 36977 + bit32.lshift(bit32.band(number80 * 34909 + bit32.rshift(number79, 16) * 36977, 65535), 16), 4294967295)
									local value76 = bit32.band(value75, 65535)
									value37 = bit32.band(14556 * value76 + bit32.lshift(bit32.band(14556 * bit32.rshift(value75, 16) + 62478 * value76, 65535), 16), 4294967295)
									local value77 = bit32.band(bit32.bnot(value35), number2)
									local value78 = bit32.band(value77, 65535)
									number31 = number29 + number30 + value37 + bit32.band(37858 * value78 + bit32.lshift(bit32.band(37858 * bit32.rshift(value77, 16) + 63301 * value78, 65535), 16), 4294967295)
									number32 = bit32.band(number31, 2147483647)
									number33 = bit32.bnot(number32)
									local number81 = bit32.band(number33, 4294967295)
									local number82 = bit32.band(number81, 65535)
									value38 = bit32.band(65535 * number82 + bit32.lshift(bit32.band(65535 * bit32.rshift(number81, 16) + 65535 * number82, 65535), 16), 4294967295)
									number34 = 3095950726 + value38 + 5493983865
									number35 = 591591182 + value38
									local number83 = bit32.band(number31, 4294967295)
									local number84 = bit32.band(number83, 65535)
									value39 = bit32.band(63247 * number84 + bit32.lshift(bit32.band(63247 * bit32.rshift(number83, 16) + 9026 * number84, 65535), 16), 4294967295)
									number36 = bit32.bnot(number31)
									local number85 = bit32.band(number36, 4294967295)
									local number86 = bit32.band(number85, 65535)
									local value79 = bit32.band(number34 - number35 + value39 + bit32.band(63247 * number86 + bit32.lshift(bit32.band(63247 * bit32.rshift(number85, 16) + 9026 * number86, 65535), 16), 4294967295), 4294967295)
									local value80 = bit32.band(value79, 65535)
									value40 = bit32.band(32428 * value80 + bit32.lshift(bit32.band(32428 * bit32.rshift(value79, 16) + 721 * value80, 65535), 16), 4294967295)
									local number87 = bit32.band(number31, 4294967295)
									local number88 = bit32.band(number33, 4294967295)
									local number89 = bit32.band(number87, 65535)
									local number90 = bit32.rshift(number87, 16)
									local number91 = bit32.band(number88, 65535)
									local value81 = bit32.band(number89 * number91 + bit32.lshift(bit32.band(number89 * bit32.rshift(number88, 16) + number90 * number91, 65535), 16), 4294967295)
									local value82 = bit32.band(value81, 65535)
									number37 = 4294967295 + bit32.band(58281 * value82 + bit32.lshift(bit32.band(58281 * bit32.rshift(value81, 16) + 59511 * value82, 65535), 16), 4294967295)
									local number92 = bit32.band(number33, 4294967295)
									local number93 = bit32.band(number92, 65535)
									value41 = bit32.band(58280 * number93 + bit32.lshift(bit32.band(58280 * bit32.rshift(number92, 16) + 59511 * number93, 65535), 16), 4294967295)
									number38 = bit32.bor(number36, 2147483648)
									local number94 = bit32.band(number31, 4294967295)
									local number95 = bit32.band(number38, 4294967295)
									local number96 = bit32.band(number94, 65535)
									local number97 = bit32.rshift(number94, 16)
									local number98 = bit32.band(number95, 65535)
									local value83 = bit32.band(number96 * number98 + bit32.lshift(bit32.band(number96 * bit32.rshift(number95, 16) + number97 * number98, 65535), 16), 4294967295)
									local value84 = bit32.band(value83, 65535)
									value42 = bit32.band(7255 * value84 + bit32.lshift(bit32.band(7255 * bit32.rshift(value83, 16) + 6024 * value84, 65535), 16), 4294967295)
									local number99 = bit32.band(number38, 4294967295)
									local number100 = bit32.band(number99, 65535)
									number7 = value40 + number37 + value41 + value42 + bit32.band(7255 * number100 + bit32.lshift(bit32.band(7255 * bit32.rshift(number99, 16) + 6024 * number100, 65535), 16), 4294967295)
								else
									break
								end
							end

							data6 = data7[4]
							continue
						end

						value9 = argument[6]
						number8 = buffer.len(value9) - 31 - 29
						number9 = 31 + 69333437 % number8
						number10 = 31

						while true do
							number11 = number10 + (number9 + bit32.band(number7, 255) + 1) % number8
							value10 = buffer.readu8(value9, number9)
							value11 = buffer.readi16(value9, number11)
							value12 = bit32.lshift(bit32.band(value11, 255), 3)
							value13 = bit32.band(bit32.bxor(bit32.bxor(766702117, value10) + value12 + 368807284, number9), 2147483647)
							value14 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value10, value11), value13), 2147483647), 589653504)
							buffer.writeu32(value9, number9, value14)
							value15 = bit32.rshift(value13, 8)
							value16 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value11, value15), number9), 2147483647), 610948608)
							buffer.writei8(value9, number11, value16)
							number9 = number10 + (number9 + bit32.band(value13, 63) + 1) % number8
							number7 = value13
						end
					else
						condition3 = condition4
						data6[5] = number12

						if condition3 then
							value19 = data5[number12]
							data7 = { #value19 + 0, nil, 0, data6, 1 }

							while true do
								value20 = data7[5]
								value21 = data7[1]
								number13 = data7[3] + value20
								data7[3] = number13

								if number13 <= value21 then
									number = number13
									number14 = bit32.band(number7, 766702116)
									local number39 = bit32.band(number, 4294967295)
									local number40 = bit32.band(number14, 4294967295)
									local number41 = bit32.band(number39, 65535)
									local number42 = bit32.rshift(number39, 16)
									local number43 = bit32.band(number40, 65535)
									local value43 = bit32.band(number41 * number43 + bit32.lshift(bit32.band(number41 * bit32.rshift(number40, 16) + number42 * number43, 65535), 16), 4294967295)
									local value44 = bit32.band(value43, 65535)
									value22 = bit32.band(173 * value44 + bit32.lshift(bit32.band(173 * bit32.rshift(value43, 16) + 26380 * value44, 65535), 16), 4294967295)
									number15 = bit32.lshift(bit32.band(number7, number), 1)
									local number44 = bit32.band(number15, 4294967295)
									local number45 = bit32.band(number44, 65535)
									number16 = number + 2913192108 + value22 + bit32.band(51373 * number45 + bit32.lshift(bit32.band(51373 * bit32.rshift(number44, 16) + 44451 * number45, 65535), 16), 4294967295)
									local number46 = bit32.band(number7, 4294967295)
									local number47 = bit32.band(number46, 65535)
									value23 = bit32.band(65535 * number47 + bit32.lshift(bit32.band(65535 * bit32.rshift(number46, 16) + 65535 * number47, 65535), 16), 4294967295)
									local number48 = bit32.bnot(number)
									local number49 = bit32.band(number14, 4294967295)
									local number50 = bit32.band(number48, 65535)
									local number51 = bit32.rshift(number48, 16)
									local number52 = bit32.band(number49, 65535)
									local value45 = bit32.band(number50 * number52 + bit32.lshift(bit32.band(number50 * bit32.rshift(number49, 16) + number51 * number52, 65535), 16), 4294967295)
									local value46 = bit32.band(value45, 65535)
									number17 = value23 + bit32.band(173 * value46 + bit32.lshift(bit32.band(173 * bit32.rshift(value45, 16) + 26380 * value46, 65535), 16), 4294967295)
									local number53 = bit32.bnot(number15)
									local number54 = bit32.band(number53, 65535)
									value24 = bit32.band(51372 * number54 + bit32.lshift(bit32.band(51372 * bit32.rshift(number53, 16) + 44451 * number54, 65535), 16), 4294967295)
									local number55 = bit32.band(number14, 4294967295)
									local number56 = bit32.band(number55, 65535)
									number18 = number16 + number17 + value24 + bit32.band(175 * number56 + bit32.lshift(bit32.band(175 * bit32.rshift(number55, 16) + 26380 * number56, 65535), 16), 4294967295)
									local number57 = bit32.band(number18, 4294967295)
									local number58 = bit32.band(number57, 65535)
									value25 = bit32.band(29058 * number58 + bit32.lshift(bit32.band(29058 * bit32.rshift(number57, 16) + 17264 * number58, 65535), 16), 4294967295)
									value26 = bit32.band(540259131, number18)
									local value47 = bit32.bnot(value26)
									local value48 = bit32.band(value47, 65535)
									value27 = bit32.band(29058 * value48 + bit32.lshift(bit32.band(29058 * bit32.rshift(value47, 16) + 17264 * value48, 65535), 16), 4294967295)
									local value49 = bit32.band(3754708164, number18)
									local value50 = bit32.band(value49, 65535)
									local value51 = bit32.band(1358017183 + value25 + value27 + bit32.band(36478 * value50 + bit32.lshift(bit32.band(36478 * bit32.rshift(value49, 16) + 48271 * value50, 65535), 16), 4294967295) - 8816509213, 4294967295)
									local value52 = bit32.band(value51, 65535)
									value28 = bit32.band(55612 * value52 + bit32.lshift(bit32.band(55612 * bit32.rshift(value51, 16) + 1030 * value52, 65535), 16), 4294967295)
									local number59 = bit32.band(number18, 4294967295)
									local number60 = bit32.band(number59, 65535)
									value29 = bit32.band(19250 * number60 + bit32.lshift(bit32.band(19250 * bit32.rshift(number59, 16) + 36273 * number60, 65535), 16), 4294967295)
									local number61 = bit32.band(number18, 4294967295)
									local number62 = bit32.band(number61, 65535)
									local value53 = bit32.band(number62 * 65535 + bit32.lshift(bit32.band(number62 * 32767 + bit32.rshift(number61, 16) * 65535, 65535), 16), 4294967295)
									local value54 = bit32.band(value53, 65535)
									number19 = value29 + bit32.band(19250 * value54 + bit32.lshift(bit32.band(19250 * bit32.rshift(value53, 16) + 36273 * value54, 65535), 16), 4294967295) + 1859921604
									number20 = bit32.band(number18, 540259131)
									local number63 = bit32.band(number20, 4294967295)
									local number64 = bit32.band(number63, 65535)
									local value55 = bit32.band(0 * number64 + bit32.lshift(bit32.band(0 * bit32.rshift(number63, 16) + 32768 * number64, 65535), 16), 4294967295)
									local value56 = bit32.band(value55, 65535)
									value30 = bit32.band(46286 * value56 + bit32.lshift(bit32.band(46286 * bit32.rshift(value55, 16) + 29262 * value56, 65535), 16), 4294967295)
									number21 = bit32.band(number18, 2147483647)
									local number65 = bit32.bnot(number21)
									local number66 = bit32.band(number65, 65535)
									number22 = value30 + bit32.band(9924 * number66 + bit32.lshift(bit32.band(9924 * bit32.rshift(number65, 16) + 28380 * number66, 65535), 16), 4294967295)
									local number67 = bit32.band(number20, 4294967295)
									local number68 = bit32.band(number67, 65535)
									number23 = number19 + number22 + 2136946346 + bit32.band(56210 * number68 + bit32.lshift(bit32.band(56210 * bit32.rshift(number67, 16) + 57642 * number68, 65535), 16), 4294967295)
									local number69 = bit32.band(number18, 4294967295)
									local number70 = bit32.band(number69, 65535)
									local value57 = bit32.band(number70 * 0 + bit32.lshift(bit32.band(number70 * 32768 + bit32.rshift(number69, 16) * 0, 65535), 16), 4294967295)
									local value58 = bit32.band(value57, 65535)
									value31 = bit32.band(19250 * value58 + bit32.lshift(bit32.band(19250 * bit32.rshift(value57, 16) + 36273 * value58, 65535), 16), 4294967295)
									local number71 = bit32.band(number20, 4294967295)
									local number72 = bit32.band(number71, 65535)
									local value59 = bit32.band(65535 * number72 + bit32.lshift(bit32.band(65535 * bit32.rshift(number71, 16) + 32767 * number72, 65535), 16), 4294967295)
									local value60 = bit32.band(value59, 65535)
									number24 = value31 + 2142122663 + bit32.band(46286 * value60 + bit32.lshift(bit32.band(46286 * bit32.rshift(value59, 16) + 29262 * value60, 65535), 16), 4294967295)
									number25 = bit32.bnot(number18)
									value32 = bit32.band(540259131, number25)
									local value61 = bit32.band(value32, 4294967295)
									local value62 = bit32.band(value61, 65535)
									number26 = bit32.band(9326 * value62 + bit32.lshift(bit32.band(9326 * bit32.rshift(value61, 16) + 7893 * value62, 65535), 16), 4294967295) + 0
									local value63 = bit32.band(value32, 4294967295)
									local value64 = bit32.band(value63, 65535)
									local value65 = bit32.band(65535 * value64 + bit32.lshift(bit32.band(65535 * bit32.rshift(value63, 16) + 32767 * value64, 65535), 16), 4294967295)
									local value66 = bit32.band(value65, 65535)
									value33 = bit32.band(19250 * value66 + bit32.lshift(bit32.band(19250 * bit32.rshift(value65, 16) + 36273 * value66, 65535), 16), 4294967295)
									local value67 = bit32.band(value32, 4294967295)
									local value68 = bit32.band(value67, 65535)
									local value69 = bit32.band(0 * value68 + bit32.lshift(bit32.band(0 * bit32.rshift(value67, 16) + 32768 * value68, 65535), 16), 4294967295)
									local value70 = bit32.band(value69, 65535)
									number27 = value28 + number23 + number24 + number26 + value33 + bit32.band(19250 * value70 + bit32.lshift(bit32.band(19250 * bit32.rshift(value69, 16) + 36273 * value70, 65535), 16), 4294967295)
									value19[number] = bit32.bxor(value19[number], 226574621)
									number28 = number7 + 368807284
									local number73 = bit32.band(number28, 4294967295)
									local number74 = bit32.band(number73, 65535)
									value34 = bit32.band(28395 * number74 + bit32.lshift(bit32.band(28395 * bit32.rshift(number73, 16) + 63595 * number74, 65535), 16), 4294967295)
									local number75 = bit32.band(number, 4294967295)
									local number76 = bit32.band(number75, 65535)
									value35 = bit32.band(number76 * 4119 + bit32.lshift(bit32.band(number76 * 13324 + bit32.rshift(number75, 16) * 4119, 65535), 16), 4294967295)
									local value71 = bit32.band(value35, 4294967295)
									local value72 = bit32.band(value71, 65535)
									value36 = bit32.band(51697 * value72 + bit32.lshift(bit32.band(51697 * bit32.rshift(value71, 16) + 64418 * value72, 65535), 16), 4294967295)
									local number77 = bit32.band(number28, 4294967295)
									local number78 = bit32.band(number77, 65535)
									local value73 = bit32.band(number78 * 28558 + bit32.lshift(bit32.band(number78 * 30626 + bit32.rshift(number77, 16) * 28558, 65535), 16), 4294967295)
									local value74 = bit32.band(value73, 65535)
									number29 = value34 + value36 + bit32.band(14556 * value74 + bit32.lshift(bit32.band(14556 * bit32.rshift(value73, 16) + 62478 * value74, 65535), 16), 4294967295)
									number2 = number28
									number30 = bit32.band(number27, 540259131) + 2084891872
									local number79 = bit32.band(number2, 4294967295)
									local number80 = bit32.band(number79, 65535)
									local value75 = bit32.band(number80 * 36977 + bit32.lshift(bit32.band(number80 * 34909 + bit32.rshift(number79, 16) * 36977, 65535), 16), 4294967295)
									local value76 = bit32.band(value75, 65535)
									value37 = bit32.band(14556 * value76 + bit32.lshift(bit32.band(14556 * bit32.rshift(value75, 16) + 62478 * value76, 65535), 16), 4294967295)
									local value77 = bit32.band(bit32.bnot(value35), number2)
									local value78 = bit32.band(value77, 65535)
									number31 = number29 + number30 + value37 + bit32.band(37858 * value78 + bit32.lshift(bit32.band(37858 * bit32.rshift(value77, 16) + 63301 * value78, 65535), 16), 4294967295)
									number32 = bit32.band(number31, 2147483647)
									number33 = bit32.bnot(number32)
									local number81 = bit32.band(number33, 4294967295)
									local number82 = bit32.band(number81, 65535)
									value38 = bit32.band(65535 * number82 + bit32.lshift(bit32.band(65535 * bit32.rshift(number81, 16) + 65535 * number82, 65535), 16), 4294967295)
									number34 = 3095950726 + value38 + 5493983865
									number35 = 591591182 + value38
									local number83 = bit32.band(number31, 4294967295)
									local number84 = bit32.band(number83, 65535)
									value39 = bit32.band(63247 * number84 + bit32.lshift(bit32.band(63247 * bit32.rshift(number83, 16) + 9026 * number84, 65535), 16), 4294967295)
									number36 = bit32.bnot(number31)
									local number85 = bit32.band(number36, 4294967295)
									local number86 = bit32.band(number85, 65535)
									local value79 = bit32.band(number34 - number35 + value39 + bit32.band(63247 * number86 + bit32.lshift(bit32.band(63247 * bit32.rshift(number85, 16) + 9026 * number86, 65535), 16), 4294967295), 4294967295)
									local value80 = bit32.band(value79, 65535)
									value40 = bit32.band(32428 * value80 + bit32.lshift(bit32.band(32428 * bit32.rshift(value79, 16) + 721 * value80, 65535), 16), 4294967295)
									local number87 = bit32.band(number31, 4294967295)
									local number88 = bit32.band(number33, 4294967295)
									local number89 = bit32.band(number87, 65535)
									local number90 = bit32.rshift(number87, 16)
									local number91 = bit32.band(number88, 65535)
									local value81 = bit32.band(number89 * number91 + bit32.lshift(bit32.band(number89 * bit32.rshift(number88, 16) + number90 * number91, 65535), 16), 4294967295)
									local value82 = bit32.band(value81, 65535)
									number37 = 4294967295 + bit32.band(58281 * value82 + bit32.lshift(bit32.band(58281 * bit32.rshift(value81, 16) + 59511 * value82, 65535), 16), 4294967295)
									local number92 = bit32.band(number33, 4294967295)
									local number93 = bit32.band(number92, 65535)
									value41 = bit32.band(58280 * number93 + bit32.lshift(bit32.band(58280 * bit32.rshift(number92, 16) + 59511 * number93, 65535), 16), 4294967295)
									number38 = bit32.bor(number36, 2147483648)
									local number94 = bit32.band(number31, 4294967295)
									local number95 = bit32.band(number38, 4294967295)
									local number96 = bit32.band(number94, 65535)
									local number97 = bit32.rshift(number94, 16)
									local number98 = bit32.band(number95, 65535)
									local value83 = bit32.band(number96 * number98 + bit32.lshift(bit32.band(number96 * bit32.rshift(number95, 16) + number97 * number98, 65535), 16), 4294967295)
									local value84 = bit32.band(value83, 65535)
									value42 = bit32.band(7255 * value84 + bit32.lshift(bit32.band(7255 * bit32.rshift(value83, 16) + 6024 * value84, 65535), 16), 4294967295)
									local number99 = bit32.band(number38, 4294967295)
									local number100 = bit32.band(number99, 65535)
									number7 = value40 + number37 + value41 + value42 + bit32.band(7255 * number100 + bit32.lshift(bit32.band(7255 * bit32.rshift(number99, 16) + 6024 * number100, 65535), 16), 4294967295)
								else
									break
								end
							end

							data6 = data7[4]
							continue
						end

						value9 = argument[6]
						number8 = buffer.len(value9) - 31 - 29
						number9 = 31 + 69333437 % number8
						number10 = 31

						while true do
							number11 = number10 + (number9 + bit32.band(number7, 255) + 1) % number8
							value10 = buffer.readu8(value9, number9)
							value11 = buffer.readi16(value9, number11)
							value12 = bit32.lshift(bit32.band(value11, 255), 3)
							value13 = bit32.band(bit32.bxor(bit32.bxor(766702117, value10) + value12 + 368807284, number9), 2147483647)
							value14 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value10, value11), value13), 2147483647), 589653504)
							buffer.writeu32(value9, number9, value14)
							value15 = bit32.rshift(value13, 8)
							value16 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value11, value15), number9), 2147483647), 610948608)
							buffer.writei8(value9, number11, value16)
							number9 = number10 + (number9 + bit32.band(value13, 63) + 1) % number8
							number7 = value13
						end
					end
				end

				value9 = argument[6]
				number8 = buffer.len(value9) - 31 - 29
				number9 = 31 + 69333437 % number8
				number10 = 31

				while true do
					number11 = number10 + (number9 + bit32.band(number7, 255) + 1) % number8
					value10 = buffer.readu8(value9, number9)
					value11 = buffer.readi16(value9, number11)
					value12 = bit32.lshift(bit32.band(value11, 255), 3)
					value13 = bit32.band(bit32.bxor(bit32.bxor(766702117, value10) + value12 + 368807284, number9), 2147483647)
					value14 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value10, value11), value13), 2147483647), 589653504)
					buffer.writeu32(value9, number9, value14)
					value15 = bit32.rshift(value13, 8)
					value16 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(value11, value15), number9), 2147483647), 610948608)
					buffer.writei8(value9, number11, value16)
					number9 = number10 + (number9 + bit32.band(value13, 63) + 1) % number8
					number7 = value13
				end
			end

			callback14(nil, nil, nil, nil, nil)
			local number7 = 50069866
			local number8 = 164827
			while true do
				number7 += number8
			end
		end

		callback7 = function()
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		data = { [false] = true, [true] = false }
		local argumentMap = {}

		callback8 = function(argument, argument2)
			if not nil and nil then
				if not nil and nil then
					return true
				end
				return false
			end
			argumentMap[argument] = true
			local argumentEntry = argumentMap[argument2]
			argumentMap[argument] = nil
			return argumentEntry
		end

		callback9 = function(argument)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			local valueType = type(argument)
			callback8("table", valueType)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			local value9 = getmetatable(argument)
			callback8(nil, value9)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			pcall(setmetatable, argument, nil)
		end

		callback10 = function(argument, ...)
			table.pack(string.byte(argument, 1, -1))
			local value9 = select("#", table.unpack(t31_18_1, 1, t31_18_1.n))
			local data5 = { 1, value9 + 0, 1 - 1, nil, nil }

			while true do
				local value10 = data5[1]
				local value11 = data5[2]
				local number7 = data5[3] + value10
				data5[3] = number7
				if not (number7 <= value11) then
					break
				end
			end

			return 3698116446
		end

		callback11 = function(argument, argument2)
			for k in nil, nil do
				argument2[callback10(k, 335884524)] = nil
			end
			for k in nil, nil do
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
		end

		new = value.new
		callback18 = callback13
		new2 = value3.new
		new3 = value2.new
	end

		local color3New = Color3.new
		local rectNew = Rect.new
		local uDim2New = UDim2.new
		local uDimNew = UDim.new
		local new4 = Path2DControlPoint.new
	local callback12
	callback12 = function()
	end
	callback12(getmetatable, "getmetatable")
	callback12(setmetatable, "setmetatable")
	callback12(tonumber, "tonumber")
	callback12(tostring, "tostring")
	callback12(rawset, "rawset")
	callback12(rawget, "rawget")
	callback12(select, "select")
	callback12(xpcall, "xpcall")
	callback12(assert, "assert")
	callback12(error, "error")
	callback12(pcall, "pcall")
	callback12(type, "type")
	callback12(next, "next")
	callback12(getfenv, "getfenv")
	callback12(setfenv, "setfenv")
	callback12(typeof, "typeof")
	callback12(string.gmatch, "gmatch")
	callback12(string.format, "format")
	callback12(string.match, "match")
	callback12(string.find, "find")
	callback12(string.char, "char")
	callback12(string.byte, "byte")
	callback12(string.gsub, "gsub")
	callback12(string.sub, "sub")
	callback12(string.rep, "rep")
	callback12(string.unpack, "unpack")
	callback12(string.pack, "pack")
	callback12(table.concat, "concat")
	callback12(table.insert, "insert")
	callback12(table.pack, "pack")
	callback12(table.clear, "clear")
	callback12(table.create, "create")
	callback12(table.move, "move")
	callback12(bit32.bor, "bor")
	callback12(bit32.bnot, "bnot")
	callback12(bit32.bxor, "bxor")
	callback12(bit32.band, "band")
	callback12(bit32.lshift, "lshift")
	callback12(bit32.rshift, "rshift")
	callback12(bit32.rrotate, "rrotate")
	callback12(bit32.lrotate, "lrotate")
	callback12(bit32.countlz, "countlz")
	callback12(bit32.countrz, "countrz")
	callback12(buffer.len, "len")
	callback12(buffer.fill, "fill")
	callback12(buffer.copy, "copy")
	callback12(buffer.create, "create")
	callback12(buffer.tostring, "tostring")
	callback12(buffer.fromstring, "fromstring")
	callback12(buffer.readstring, "readstring")
	callback12(buffer.writestring, "writestring")
	callback12(buffer.readi8, "readi8")
	callback12(buffer.readu8, "readu8")
		local number3 = 0 - number
	callback12(buffer.readi16, "readi16")
	callback12(buffer.readu16, "readu16")
	callback12(buffer.readi32, "readi32")
	callback12(buffer.readu32, "readu32")
	callback12(buffer.readf32, "readf32")
	callback12(buffer.readf64, "readf64")
	callback12(buffer.writei8, "writei8")
	callback12(buffer.writeu8, "writeu8")
	callback12(buffer.writei16, "writei16")
	callback12(buffer.writeu16, "writeu16")
	callback12(buffer.writei32, "writei32")
	callback12(buffer.writeu32, "writeu32")
	callback12(buffer.writef32, "writef32")
	callback12(buffer.writef64, "writef64")
	callback12(buffer.readbits, "readbits")
	callback12(buffer.writebits, "writebits")
	callback12(coroutine.isyieldable, "isyieldable")
	callback12(coroutine.running, "running")
	callback12(coroutine.create, "create")
	callback12(coroutine.status, "status")
	callback12(coroutine.yield, "yield")
	callback12(coroutine.close, "close")
	callback12(coroutine.resume, "resume")
	callback12(coroutine.wrap, "wrap")
	callback12(cancel, "cancel")
	callback12(spawn, "spawn")
	callback12(defer, "defer")
	callback12(delay, "delay")
	callback12(wait, "wait")
	callback12(unpack, "unpack")
	callback12(info, "info")
	callback12(traceback, "traceback")
	callback12(value7)

	do
		local value = pcall
		local value2 = xpcall
		local number4 = 250156969
		local number5 = 264474006
		new3(0.84673035188925794, 0.093727452431537017, 0.99733327850195685)
		new("Folder")
		local ScreenGui = new("ScreenGui")
		local Frame = new("Frame")
		local Path2D = new("Path2D")
		Frame.Parent = ScreenGui
		Path2D.Parent = Frame
		vector.create(0.72114584276546267, 0.36318795186918562, 0.65638086327026679)

		local function callback13()
			assert(0.10782306830453703)
			getfenv(0)
			tostring(0.070299249307049672)
			rawequal(scratch, scratch)
			local data2 = {}
			next(data2)
			pairs(data2)(data2)
			ipairs(data2)(data2, 1)
			rawlen(data2)
			rawget(data2, 0.68217785062081304)
			rawset(data2, 0.6658957430766963, 0.42194055033039479)
			getmetatable(data2)
			setmetatable(data2, data2)
			setmetatable(data2, nil)
			info(18057, "slnaf")
			local buf = buffer.create(174)
			buffer.len(buf)
			buffer.fromstring("")
			buffer.tostring(buf)
			buffer.readi8(buf, 30)
			buffer.readu8(buf, 8)
			buffer.readi16(buf, 22)
			buffer.readu16(buf, 26)
			buffer.readi32(buf, 1)
			buffer.readu32(buf, 25)
			buffer.readf32(buf, 16)
			buffer.readf64(buf, 8)
			buffer.writei8(buf, 24, -2)
			buffer.writeu8(buf, 14, 234)
			buffer.writei16(buf, 17, -10399)
			buffer.writeu16(buf, 17, 52034)
			buffer.writei32(buf, 19, -1422761893)
			buffer.writeu32(buf, 13, 690632566)
			buffer.writef32(buf, 11, 31531)
			buffer.writef64(buf, 22, 3833)
			buffer.readstring(buf, 23, 15)
			buffer.writestring(buf, 17, "Luraph", 1)
			buffer.readbits(buf, 28, 4)
			buffer.writebits(buf, 238, 6, 1822520637)
			buffer.copy(buf, 32, buf, 0, 16)
			buffer.fill(buf, 1, 221, 26)
			local value9 = value5.new()
			value9:NextInteger(32, 345)
			value9:NextNumber(53, 114)
			value9:NextUnitVector()
			value9:NextNumber()
			value9:Shuffle({})
			value9:Clone()
			local number6 = Vector3.new(0.4075893, 0.3559033, 0.81262535) + Vector3.new(0.29363313, 0.15452562, 0.49740827)
			local vector_ = Vector3.new(0.4075893, 0.3559033, 0.81262535)
			local vector_2 = Vector3.new(0.29363313, 0.15452562, 0.49740827)
			local vector_3 = Vector3.new(1, 0, 0)
			local vector_4 = Vector3.new(0, 1, 0)
			local value10 = value4.new()
			local vector_5 = value4.new(vector_)
			value4.Angles(0.21131814509936042, 0.43531011758386562, 0.61660347155447415)
			local xyz = Enum.RotationOrder.XYZ
			value4.new(vector_, number6)
			value4.new(vector_.X, vector_.Y, vector_.Z)
			value4.new(vector_.X, vector_.Y, vector_.Z, 0, 0, 0, 1)
			value4.new(vector_.X, vector_.Y, vector_.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
			value4.lookAt(vector_, number6, vector_4)
			value4.lookAlong(vector_, vector_2, vector_4)
			value4.fromEulerAnglesXYZ(0.21131814509936042, 0.43531011758386562, 0.61660347155447415)
			value4.fromEulerAnglesYXZ(0.21131814509936042, 0.43531011758386562, 0.61660347155447415)
			value4.fromOrientation(0.21131814509936042, 0.43531011758386562, 0.61660347155447415)
			value4.fromAxisAngle(vector_2.Unit, 0.21131814509936042)
			value4.fromRotationBetweenVectors(vector_3, vector_4)
			value4.fromMatrix(vector_, vector_3, vector_4, Vector3.new(0, 0, 1))
			value4.fromEulerAngles(0.21131814509936042, 0.43531011758386562, 0.61660347155447415, xyz)
			value10:Inverse()
			value10:Orthonormalize()
			value10:Lerp(vector_5, 0.63750918829394077)
			value10:ToWorldSpace(vector_5)
			value10:ToObjectSpace(vector_5)
			value10:ToEulerAnglesXYZ()
			value10:ToEulerAnglesYXZ()
			value10:PointToWorldSpace(vector_)
			value10:PointToObjectSpace(vector_)
			value10:VectorToWorldSpace(vector_2)
			value10:VectorToObjectSpace(vector_2)
			value10:ToEulerAngles(xyz)
			value10:GetComponents()
			value10:ToOrientation()
			value10:ToAxisAngle()
			value10:FuzzyEq(vector_5)
			value10:AngleBetween(vector_5)
			value3.FromAxis(Enum.Axis.X)
			local vector_6 = Vector3.new(0.34569693, 0.5524278, 0.5360805)
			local vector_7 = Vector3.new(0.43171802, 0.94338423, 0.49583018)
			value3.FromNormalId(Enum.NormalId.Top)
			vector_6:Abs()
			vector_6:Ceil()
			vector_6:Floor()
			vector_6:Sign()
			vector_6:Dot(vector_7)
			vector_6:Cross(vector_7)
			vector_6:Angle(vector_7)
			vector_6:FuzzyEq(vector_7)
			vector_6:Lerp(vector_7, 0.51588446494187379)
			vector_6:Max(vector_7)
			vector_6:Min(vector_7)
			;(Vector2.new(0.039697688072919846, 0.22205919027328491)):Abs()
			local vector2 = Vector2.new(0.039697688072919846, 0.22205919027328491)
			local vector22 = Vector2.new(0.52975994348526, 0.13805945217609406)
			vector2:Ceil()
			vector2:Floor()
			vector2:Sign()
			vector2:Dot(vector22)
			vector2:Cross(vector22)
			vector2:Angle(vector22)
			vector2:FuzzyEq(vector22)
			vector2:Lerp(vector22, 0.4717291396665908)
			vector2:Max(vector22)
			vector2:Min(vector22)
			uDimNew(-0.17671884419267769, 34)
			uDimNew(-0.49213428502166834, 126)
			uDim2New(0.0032168333958821904, 80, 0.57311543164281953, 100):Lerp(uDim2New(-0.072407008087735036, -114, -0.56594180659109128, 116), 0.46966254037966992)
			local top = Enum.NormalId.Top.EnumType.Top
			local enumType = top.EnumType
			enumType:GetEnumItems()
			enumType:FromName(top.Name)
			enumType:FromValue(top.Value)
			local value11 = uDim2New(0.094739300801399529, 37, 0.036042505143074943, 22)
			local value12 = uDim2New(0.035178557492017676, 11, 0.024132791385398353, 14)
			local value13 = uDim2New(0.89984635449481853, 153, 0.85229312037533012, 166)
			local value14 = new4(value11, value12, value12)
			new4(value11:Lerp(value13, 0.41321798473972965))
			local context = {}
			local value15 = new4(value13)
			context.data = value14
			context.data2 = value15
			local value16 = utf8.char(81, 1861, 648675)
			utf8.codepoint(value16, 1, #value16)
			utf8.len(value16)
			utf8.offset(value16, 3)
			utf8.offset(value16, -2)
			local value17, value18, value19 = utf8.codes(value16)
			value17(value18, value19)
			value17(value18, utf8.offset(value16, 2))
			local value20 = utf8.char(108, 813)
			utf8.nfcnormalize(value20)
			utf8.nfdnormalize(value16)
			utf8.graphemes(value20, 1, #value20)()
			number5 = (1 * number5 + 32698948) % 268435456
			number4 = (372869 * number4 + 66631331) % 268435456
		end

		local callback14 = coroutine.wrap(callback13)
		local data2 = {}
		local number6 = 0

		local function callback15()
			number6 += 1

			if nil then
				setmetatable({}, { __index = callback7 })
				local value9, value10
				local value11 = luraph_runtime6(nil, table.pack(value10, value9, callback5, number2, callback6), nil)
				value(value11)
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
				return
			end

			if nil then
				callback14()
			end
			number4 = (183907 * number4 + 140557531) % 268435456
			number5 = (1 * number5 + 89632852) % 268435456
		end

		setmetatable(data2, { __index = callback15, __newindex = callback15 })
		local ok, response = pcall(callback15)
		local response = response

		if data[not ok] then
			callback4(number + 2378707526, 79)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if data[not response] then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		else
			callback4(number3 + 1896175595, 161)
		end

		local value9 = luraph_runtime1(nil, table.pack(number4, number5), nil)
		local condition = false
		local value10
		local value11 = luraph_runtime3(nil, table.pack(value, value10), nil)
		local function callback16()
			number4 = (524773 * number4 + 21046209) % 268435456
			number5 = (1 * number5 + 166256722) % 268435456
		end
		local value12 = luraph_runtime4(nil, table.pack(number5, number4), nil)
		local function callback17()
			number5 = number5 - number5 % 2 + 1
			number4 = (796781 * number4 + 145810883) % 268435456
			number4 = (469605 * number4 + 194694015) % 268435456
		end
		local number7 = 0

		callback = function()
			number7 += 1

			if number7 ~= 2499 then
				if number7 == 2498 then
					callback16()
				end
				number4 = (951187 * number4 + 167652415) % 268435456
				number5 = (1 * number5 + 91491278) % 268435456
				callback()
				return
			end

			value9()
			number5 = (1 * number5 + 44671616) % 268435456
			number4 = (924949 * number4 + 58504891) % 268435456
		end

		callback2 = function(argument)
			if argument ~= 19998 then
				if argument ~= 19997 then
					if argument == 13184 then
						callback13(argument)
					end
				else
					callback13(argument)
				end

				callback2(argument + 1)

				if argument == 19997 then
					if not value2(value9, value12) then
						number5 = number5 - number5 % 2 + 1
						number4 = (338939 * number4 + 110120459) % 268435456
						return
					end
					callback16()
					if not value(value9) then
						number5 = number5 - number5 % 2 + 1
						number4 = (857759 * number4 + 196711549) % 268435456
						return
					end
					if value2(callback17, callback) then
						number5 = number5 - number5 % 2 + 1
						number4 = (212537 * number4 + 56070641) % 268435456
						number4 = (418009 * number4 + 173187139) % 268435456
						return
					end
					value11()
					if condition then
						number5 = number5 - number5 % 2 + 1
						number4 = (457011 * number4 + 144702877) % 268435456
						return
					end
					number4 = (68113 * number4 + 101200063) % 268435456
					number5 = (1 * number5 + 177586784) % 268435456
				end

				number5 = (1 * number5 + 97743858) % 268435456
				number4 = (243053 * number4 + 14712065) % 268435456
				return
			end

			value9()
			number4 = (532587 * number4 + 170887851) % 268435456
			number5 = (1 * number5 + 127229776) % 268435456
		end

		coroutine.resume(coroutine.create(callback2), 1)
		ScreenGui:Destroy()
		callback5(number4, 4)
		callback5(number5, 4)
	end

		local number4 = number2
	local number5

	do
		local number6 = 1368927392
		local number7 = 1772569646
		number5 = number3 // number
		local number8 = number + 2085226528

		local function callback13()
			coroutine.yield(number6)
			if nil then
				number8 = bit32.bxor(number8, 2343367499)
			end
			coroutine.yield(number7)
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		number8 = 464992897
		local callback14 = coroutine.wrap(callback13)

		if callback8(callback14(), number6) then
			callback4(393832580, 172)
			number2 = number4
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(callback14(), number7) then
			callback4(number + 2378707526, 234)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
	end

	do
		local thread = coroutine.create(wait)
		coroutine.resume(thread, 0)
		local thread2 = coroutine.status(thread)
		callback8("suspended", thread2)
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		pcall(coroutine.close, thread)
	end

	do
		local value9 = nil
		local condition = false

		spawn(function()
			value9 = coroutine.running()
			wait(0)
			condition = true
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end)

		local condition2 = not pcall(coroutine.close, value9)
	end

	if not nil then
		callback5(503354784, 4)
		number2 = 35521203
		callback6()
	end

	do
		local close = coroutine.close
		local value9 = spawn(function()
			coroutine.yield()
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end)
		close(value9)
	end

	do
		local close = coroutine.close
		local value9 = defer(callback7)
		close(value9)
	end
	do
		local close = coroutine.close
		local value9 = delay(227, callback7)
		close(value9)
	end
	local callback13
	callback13 = function()
	end
	callback13(getfenv, -1646)
	callback13(setfenv, -26385)
	callback13(getmetatable)
	callback13(setmetatable)
	callback13(tonumber)
	callback13(tostring)
	callback13(rawset)
	callback13(rawget)
	callback13(assert)
	callback13(type)
	callback13(next)
	callback13(typeof)
	callback13(string.gmatch)
	callback13(string.format)
	callback13(string.match)
	callback13(string.find)
	callback13(string.byte)
	callback13(string.gsub)
	callback13(string.sub)
	callback13(string.rep)
	callback13(string.char, nil)
	callback13(string.unpack)
	callback13(string.pack)
	callback13(table.concat)
	callback13(table.insert)
	callback13(table.clear)
	callback13(table.create, nil)
	callback13(table.move)
	callback13(bit32.bor, nil)
		local number6 = 81240569
	callback13(bit32.bxor, nil)
	callback13(bit32.band, nil)
	callback13(bit32.bnot)
	callback13(bit32.lshift)
	callback13(bit32.rshift)
	callback13(bit32.rrotate)
	callback13(bit32.lrotate)
	callback13(bit32.countlz)
	callback13(bit32.countrz)
	callback13(buffer.len)
	callback13(buffer.fill)
	callback13(buffer.copy)
	callback13(buffer.create, nil)
	callback13(buffer.tostring)
	callback13(buffer.fromstring)
	callback13(buffer.readstring)
	callback13(buffer.writestring)
	callback13(buffer.readi8)
	callback13(buffer.readu8)
	callback13(buffer.readi16)
	callback13(buffer.readu16)
	callback13(buffer.readi32)
	callback13(buffer.readu32)
	callback13(buffer.readf32)
	callback13(buffer.readf64)
	callback13(buffer.writei8)
	callback13(buffer.writeu8)
	callback13(buffer.writei16)
	callback13(buffer.writeu16)
	callback13(buffer.writei32)
	callback13(buffer.writeu32)
	callback13(buffer.writef32)
	callback13(buffer.writef64)
	callback13(buffer.readbits)
		local number7 = number5 // 42
	callback13(buffer.writebits)
	callback13(coroutine.create)
	callback13(coroutine.status)
	callback13(coroutine.close)
	callback13(coroutine.resume)
	callback13(coroutine.wrap)
	callback13(cancel)
	callback13(spawn)
	callback13(defer)
	callback13(delay)
	callback13(wait, {})
	callback13(unpack)
	callback13(info)
	callback13(value7)
	callback12(new, "new")
	callback13(new, nil)
	callback12(new2, "new")
	callback12(new3, "new")
	callback12(color3New, "new")
	callback12(rectNew, "new")
	local condition8, condition9, condition10, data2, data3, number8

	do
		local fromAxis = value3.FromAxis
		callback12(fromAxis, "FromAxis")
		callback13(fromAxis, nil)
		local vector_ = fromAxis(Enum.Axis.Y)
		local front = value3.FromNormalId(Enum.NormalId.Front)
		local valueType = type(vector_)
		local valueType2 = type(front)
		local condition = valueType == "vector"
		condition8 = condition and 46 or 247
		callback4(number7 + 393832580, condition8)
		local condition2 = valueType2 == "vector"
		callback4(393832580, condition2 and 245 or 232)
		local z = front.Z
		callback5(vector_.Y * 246681053, 4)
		callback5(z * -1 * 2010475437, 4)

		if callback8("vector", valueType) then
			callback4(number - 173565424, 29)
			number2 = number4
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8("vector", valueType2) then
			callback4(number7 + 393832580, 205)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local condition3 = vector_.X == 0
		condition9 = condition3 and 131 or 15
		callback4(393832580, condition9)
		local condition4 = vector_.Y == 1
		condition10 = condition4 and 177 or 176
		callback4(393832580, condition10)
		local condition5 = vector_.Z == 0
		callback4(number7 + 393832580, condition5 and 7 or 18)
		local condition6 = front.X == 0
		callback4(393832580, condition6 and 95 or 232)
		local number9 = bit32.bor(number7, number)
		callback4(number - 173565424, front.Y == 0 and 184 or 68)
		local condition7 = front.Z == -1
		callback4(number9 + 4121401872, condition7 and 241 or 112)
		callback12(uDim2New, "new")
		callback12(uDimNew, "new")
		callback11(utf8, { [3037624437] = 1249179632, [1073743238] = 1196239870, [3747209138] = 1215242468 })
		data2 = { utf8.nfcnormalize("됏뱚흈갍굔훵팴췝쒺"):byte(1, -1) }
		data3 = { utf8.nfdnormalize("앪즌륿푼텅햳콹션"):byte(1, -1) }
		number8 = bit32.band(number9, number6)
	end

	callback4(393832580, data3[45])
	callback4(number - 173565424, data3[69])
	callback4(393832580, data3[28])
		local value9 = data3[48]
	callback4(393832580, value9)
	callback4(393832580, data3[35])
	callback4(number8 - 3914864620, data3[12])
	callback4(393832580, data3[68])
	callback4(number - 173565424, data3[56])
	callback4(number8 - 3914864620, data3[50])
	callback4(393832580, data3[4])
	callback4(393832580, data3[31])
	local value10 = data3[29]
	callback4(393832580, value10)
	callback4(393832580, data3[18])
	callback4(number - 3901134752, data2[3])
	callback4(number8 - 3914864620, data3[15])
	callback4(393832580, data2[25])
	callback4(number + 393832544, data3[72])
	callback4(number8 + 380102676, data2[16])
	callback4(393832580, data3[11])
	callback4(number + 393832544, data3[57])
	callback4(number8 - 3914864620, data3[17])
	callback4(393832580, data3[14])
	callback4(number - 3901134752, data3[53])
	callback4(393832580, data3[20])
	callback4(393832580, data3[67])
	callback4(number + 393832544, data3[10])
	callback4(number8 - 3914864620, data2[15])
	callback4(393832580, data2[13])
	callback4(number - 3901134752, data2[20])
	callback4(number8 + 380102676, data2[23])
	callback4(393832580, data3[49])
	callback4(number + 393832544, data3[38])
	callback4(393832580, data3[43])
	callback4(393832580, data3[33])
	callback4(number + 393832544, data3[25])
	callback4(number8 - 3914864620, data2[18])
	callback4(393832580, data2[9])
	local value11 = data2[17]
	callback4(number - 3901134752, value11)
	callback4(number8 // value9 - 3901228756, data3[6])
		local value12 = data3[27]
	callback4(393832580, value12)
	callback4(393832580, data3[21])
	callback4(393832580, data3[40])
	callback4(393832580, data2[14])
	callback4(393832580, data3[7])
	callback4(393832580, data3[51])
	callback4(393832580, data3[59])
	local number9

	do
		local value13 = data2[2]
		local condition = bit32.band(condition8, 4294967295)
		local condition2 = bit32.band(condition, 65535)
		local value14 = bit32.band(31757 * condition2 + bit32.lshift(bit32.band(31757 * bit32.rshift(condition, 16) + 22010 * condition2, 65535), 16), 4294967295)
		local condition3 = bit32.bnot(condition8)
		local condition4 = bit32.band(condition3, 65535)
		number9 = 1523719471 + value14 + bit32.band(31757 * condition4 + bit32.lshift(bit32.band(31757 * bit32.rshift(condition3, 16) + 22010 * condition4, 65535), 16), 4294967295)
		callback4(393832580, value13)
	end

	callback4(393832580, data2[8])
	callback4(393832580, data3[64])
	callback4(393832580, data3[34])
	callback4(393832580, data2[19])
	callback4(393832580, data3[30])
	callback4(393832580, data3[60])
	callback4(393832580, data2[5])
	callback4(393832580, data3[58])
	callback4(393832580, data2[24])
	callback4(393832580, data3[24])
	callback4(393832580, data3[41])
	callback4(393832580, data3[5])
	callback4(393832580, data3[3])
	callback4(393832580, data3[8])
	callback4(393832580, data3[66])
	callback4(393832580, data3[61])
	callback4(393832580, data3[44])
	callback4(393832580, data3[32])
	callback4(393832580, data3[42])
	callback4(393832580, data2[4])
	callback4(393832580, data2[21])
	callback4(393832580, data3[46])
	callback4(393832580, data3[23])
	callback4(393832580, data2[10])
	callback4(393832580, data2[7])
	callback4(393832580, data3[19])
	callback4(393832580, data2[11])
	callback4(393832580, data3[71])
	callback4(393832580, data3[62])
	callback4(393832580, data3[39])
	callback4(393832580, data3[1])
	callback4(393832580, data2[26])
	callback4(393832580, data3[52])
	callback4(393832580, data2[22])
	callback4(393832580, data3[65])
	callback4(393832580, data3[22])
	callback4(393832580, data3[26])
	callback4(393832580, data3[13])
	callback4(393832580, data2[1])
	callback4(393832580, data3[36])
	callback4(393832580, data2[6])
	callback4(393832580, data3[70])
	callback4(393832580, data3[63])
	callback4(393832580, data3[16])
	callback4(393832580, data3[47])
		local number10 = bit32.bxor(number9, 133)
	callback4(393832580, data2[12])
	callback4(393832580, data2[27])
	callback4(393832580, data3[55])
	callback4(393832580, data3[2])
	callback4(393832580, data3[9])
	callback4(393832580, data3[37])
	callback4(393832580, data3[54])
	callback12(new4, "new")
	callback13(new4, nil)
		local ScreenGui = new("ScreenGui")
	local Path2D

	do
		local Frame = new("Frame")
		Frame.Position = uDim2New(0, 0, 0, 0)
		Frame.Size = uDim2New(0, 153, 0, 285)
		Frame.Parent = ScreenGui
		local Path2D2 = new("Path2D")
		Path2D2.Parent = Frame
		Path2D = Path2D2
	end

	do
		local setControlPoints = Path2D.SetControlPoints
		local data4 = {}
		local value13 = new4(uDim2New(0, 4, 0, -8), uDim2New(-0.125, 6, 0, 3), uDim2New(0, 4, 0, 1))
		local value14 = new4(uDim2New(0.125, 2, 0.5, -8), uDim2New(0, 0, 0, 0), uDim2New(0, -3, 0, 2))
		local value15 = new4(uDim2New(0.5, -6, 0, -8), uDim2New(0, -4, 0, 5), uDim2New(0, -4, 0.125, -5))
		local value16 = new4(uDim2New(0, 0, 0.5, 1), uDim2New(0, 0, 0, 0), uDim2New(0, 0, 0, 0))
		local value17 = uDim2New(0.25, -3, 0.4375, 1)
		local value18 = uDim2New(0, -7, 0, 1)
		data4[1] = value13
		data4[2] = value14
		data4[3] = value15
		data4[4] = value16
		do
			local values = table.pack(new4(value17, value18, uDim2New(0.125, 1, 0, 4)))
			table.move(values, 1, values.n, 5, data4)
		end
		setControlPoints(Path2D, data4)
	end

	local length = Path2D:GetLength()
	callback5(string.unpack(">I4", string.pack(">f", length)), 4)
	local positionOnCurve = Path2D:GetPositionOnCurve(0.4285714328289032)
	callback5(string.unpack(">I4", string.pack("<f", positionOnCurve.X.Scale)), 4)
	callback5(string.unpack(">I4", string.pack("<f", positionOnCurve.Y.Scale)), 4)
	local number11

	do
		local positionOnCurve2 = Path2D:GetPositionOnCurve(0.20000000298023224)
		local scale = positionOnCurve2.X.Scale
		callback5(string.unpack(">I4", string.pack("<f", scale)), 4)
		local number12 = bit32.bxor(number10, 132)
		callback5(string.unpack(">I4", string.pack("<f", positionOnCurve2.Y.Scale)), 4)
		local positionOnCurve3 = Path2D:GetPositionOnCurve(0.2142857164144516)
		callback5(string.unpack("<I4", string.pack(">f", positionOnCurve3.X.Scale)), 4)
		callback5(string.unpack(">I4", string.pack(">f", positionOnCurve3.Y.Scale)), 4)
		local tangentOnCurve = Path2D:GetTangentOnCurve(0.3333333432674408)
		callback5(string.unpack("<I4", string.pack(">f", tangentOnCurve.X)), 4)
		callback5(string.unpack(">I4", string.pack(">f", tangentOnCurve.Y)), 4)
		local tangentOnCurve2 = Path2D:GetTangentOnCurve(0.69230771064758301)
		callback5(string.unpack("<I4", string.pack("<f", tangentOnCurve2.X)), 4)
		local y = tangentOnCurve2.Y
		callback5(string.unpack("<I4", string.pack("<f", y)), 4)
		local tangentOnCurve3 = Path2D:GetTangentOnCurve(0.9375)
		local number13 = bit32.bxor(number12, 179)
		local x = tangentOnCurve3.X
		callback5(string.unpack(">I4", string.pack("<f", x)), 4)
		local y = tangentOnCurve3.Y
		callback5(string.unpack(">I4", string.pack("<f", y)), 4)
		local positionOnCurveArcLength = Path2D:GetPositionOnCurveArcLength(0.71428573131561279)
		local scale = positionOnCurveArcLength.X.Scale
		callback5(string.unpack("<I4", string.pack(">f", scale)), 4)
		local scale = positionOnCurveArcLength.Y.Scale
		callback5(string.unpack(">I4", string.pack("<f", scale)), 4)
		local positionOnCurveArcLength2 = Path2D:GetPositionOnCurveArcLength(0.80000001192092896)
		local scale = positionOnCurveArcLength2.X.Scale
		callback5(string.unpack(">I4", string.pack(">f", scale)), 4)
		local scale = positionOnCurveArcLength2.Y.Scale
		callback5(string.unpack(">I4", string.pack(">f", scale)), 4)
		local positionOnCurveArcLength3 = Path2D:GetPositionOnCurveArcLength(0.1428571492433548)
		callback5(string.unpack("<I4", string.pack(">f", positionOnCurveArcLength3.X.Scale)), 4)
		callback5(string.unpack("<I4", string.pack(">f", positionOnCurveArcLength3.Y.Scale)), 4)
		local tangentOnCurveArcLength = Path2D:GetTangentOnCurveArcLength(0.18181818723678589)
		callback5(string.unpack(">I4", string.pack("<f", tangentOnCurveArcLength.X)), 4)
		callback5(string.unpack("<I4", string.pack(">f", tangentOnCurveArcLength.Y)), 4)
		local tangentOnCurveArcLength2 = Path2D:GetTangentOnCurveArcLength(0.125)
		local x = tangentOnCurveArcLength2.X
		callback5(string.unpack(">I4", string.pack(">f", x)), 4)
		callback5(string.unpack(">I4", string.pack(">f", tangentOnCurveArcLength2.Y)), 4)
		number11 = bit32.bxor(number13, 237)
	end

	do
		local tangentOnCurveArcLength = Path2D:GetTangentOnCurveArcLength(0.375)
		local x = tangentOnCurveArcLength.X
		callback5(string.unpack("<I4", string.pack("<f", x)), 4)
		local y = tangentOnCurveArcLength.Y
		callback5(string.unpack("<I4", string.pack(">f", y)), 4)
	end

	ScreenGui:Destroy()
	callback11(math, { [3972242161] = 764503636, [2078034755] = 115597407, [2070071277] = 104406278 })

	callback11(value8, {
		[1657654899] = 1126782580,
		[1443956399] = 218653934,
		[1039942384] = 2129148707,
		[3369142728] = 197675286,
		[3376658140] = 373355162,
	})

	callback11(value2, { [592917670] = 942283227, [2451088563] = 540738008 })
		local gameRef = game
	local callback14
	local workspaceRef = workspace

	callback14 = function(argument, argument2, argument3)
		local number12 = 3013350959
		local number13 = 435524012
		local valueType = type(argument)
		callback8("userdata", valueType)
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		local valueType2 = typeof(argument)
		callback8("Instance", valueType2)
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		local parent = argument.Parent
		local parent2 = argument.Parent
		local number14 = bit32.band(number12, argument2)

		if data[not parent] then
			callback8(parent, parent2)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
		end

		local name = argument.Name
		local name2 = argument.Name
		local valueType3 = type(name)
		callback8("string", valueType3)
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		callback8(name, name2)

		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			local number15 = argument2 + number13
			callback6()
			argument2 = number15 - 435524012
		end

		callback8(#name, #name2)
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		callback8(tostring(argument), name)
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		callback8(argument3, argument.ClassName)
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		local childRemoved = argument.ChildRemoved
		callback8(childRemoved, argument.ChildRemoved)
		if nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		local connect = childRemoved.Connect
		local connect2 = childRemoved.Connect
		local argument3 = argument2
		callback12(connect, "Connect")
		local callback = callback12
		callback12(connect2, "Connect")
		callback8(connect, connect2)
		if nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		local condition = false
		local childRemoved2 = argument.ChildRemoved
		local childRemoved3 = childRemoved2
		local connect = childRemoved2.Connect
		local number15 = 473857566

		local function callback15()
			condition = true
			if nil then
				number15 = bit32.bxor(number15, 3856656247)
				return
			end
		end

		number15 = 131331620
		local value13 = connect(childRemoved3, callback15)
		if nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
			argument2 = argument2 + argument3 - 149812691
		end
		local disconnect = value13.Disconnect
		callback12(disconnect, "Disconnect")
		callback13(disconnect, nil)
		disconnect(value13)

		if nil then
			local number16 = bit32.lshift(number14, 31)
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
			number14 = number16 + 2156663811
		end

		local wait = childRemoved.Wait
		callback12(wait, "Wait")
		local number16 = number14 + 494618597

		local function callback16()
			local wait = wait
			if nil then
				number16 = bit32.bxor(number16, 1103643771)
			end
			return (wait(childRemoved))
		end

		number16 = 232188607
		local thread = coroutine.create(callback16)
		local thread2, value14 = coroutine.resume(thread)
		local value15 = data[not thread2]
		local condition2 = not value15
		local condition3
		if value15 then
			condition3 = data[not value14]
		else
			condition3 = condition2
		end
		if not condition3 then
			local thread3 = coroutine.status(thread)
			condition3 = not callback8("suspended", thread3)
		end
		if condition3 then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		local ok, response = pcall(coroutine.close, thread)
		local value16 = data[not ok]
		local condition4 = not value16
		local condition5
		if value16 then
			condition5 = not data[not response]
		else
			condition5 = condition4
		end
		if not condition5 then
			local thread3 = coroutine.status(thread)
			condition5 = not callback8("dead", thread3)
		end

		if condition5 then
			local callback2
			repeat
				callback2 = callback5
			until callback
			callback2(503354784, 4)
			number2 = 35521203
			callback6()
			argument3 = argument3 * 27 + 399837330
		end

		local value17 = getmetatable(argument)
		callback8("The metatable is locked", value17)
		if not nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
	end

	callback14(gameRef, 149812691, "DataModel")
	callback14(workspaceRef, 149812691, "Workspace")

	if callback8(gameRef, workspaceRef.Parent) then
		callback4(393832580, 179)
		number2 = number4
	else
		callback5(503354784, 4)
		number2 = 35521203
		callback6()
	end

	local number, value13

	do
		local Folder = new("Folder")
		callback14(Folder, 149812691, "Folder")
		local ok, response = pcall(Folder.RemoveTag, Rect.new(-578.74749755859375, -920.60675048828125, -42.39080810546875, 694.2255859375), 713679949)
		local condition = not ok
		if not data[condition] then
			callback5(callback10(response, 335884524), 4)
		end
		local number3 = number2

		if data[condition] then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		else
			callback4(393832580, 45)
			number2 = number3
		end

		local children, value14, value15 = Folder:GetChildren()
		for k in value14, value15 do
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		Folder:Destroy()
		local number3 = number2
		local Folder = Folder
		local Folder2 = new("Folder", Folder)
		callback14(Folder2, 149812691, "Folder")
		local number4

		if callback8(Folder, Folder2.Parent) then
			number4 = number3
			callback4(393832580, 147)
			number2 = number4
		else
			number4 = number3
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(Folder2.Parent, Folder2.Parent) then
			callback4(393832580, 184)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local waitForChild = Folder.WaitForChild
		callback12(waitForChild, "WaitForChild")
		callback13(waitForChild, nil)
		local name = tostring(1711918440)
		Folder2.Name = name
		local value16 = waitForChild(Folder, name)

		if callback8(Folder2, value16) then
			callback4(393832580, 57)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		Folder:Destroy()
		Folder2:Destroy()

		if data[not Folder2.Parent] then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		else
			callback4(393832580, 0)
		end

		local value17 = data[not pcall(function()
			Folder2.Parent = Folder
		end)]
		local number12 = bit32.bxor(number11, 133) + 4192209715
		local condition2 = bit32.band(condition9, 4294967295)
		local condition3 = bit32.band(condition2, 65535)
		local value18 = bit32.band(2867 * condition3 + bit32.lshift(bit32.band(2867 * bit32.rshift(condition2, 16) + 63968 * condition3, 65535), 16), 4294967295)
		local condition4 = bit32.bnot(condition9)
		local condition5 = bit32.band(condition4, 65535)
		local number13 = number12 + value18 + bit32.band(2867 * condition5 + bit32.lshift(bit32.band(2867 * bit32.rshift(condition4, 16) + 63968 * condition5, 65535), 16), 4294967295)

		if value17 then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		else
			callback4(393832580, 56)
		end

		number2 = number4
		local HttpService = gameRef:GetService("HttpService")
		callback14(HttpService, 149812691, "HttpService")
		local number3 = number2
		local number4

		if callback8(gameRef, HttpService.Parent) then
			callback4(393832580, 237)
			number2 = number3
			number4 = number3
		else
			number4 = number3
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if not value6 then
			callback12(HttpService.GetAsync, "GetAsync")
			callback12(HttpService.PostAsync, "PostAsync")
			callback12(HttpService.RequestAsync, "RequestAsync")
		end
		local RunService = gameRef:GetService("RunService")
		callback14(RunService, 149812691, "RunService")

		if callback8(gameRef, RunService.Parent) then
			callback4(393832580, 214)
			number2 = number4
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		callback12(RunService.IsStudio, "IsStudio")
		callback12(RunService.IsClient, "IsClient")
		callback12(RunService.IsServer, "IsServer")
		local number14 = bit32.bxor(number13, 132)
		callback13(RunService.IsStudio)
		callback13(RunService.IsClient)
		callback13(RunService.IsServer)
		RunService:IsServer()

		if nil then
			local StarterPlayer = gameRef:GetService("StarterPlayer")
			callback14(StarterPlayer, 149812691, "StarterPlayer")
			callback8(gameRef, StarterPlayer.Parent)
			local StarterPlayer2

			if nil then
				StarterPlayer2 = StarterPlayer
			else
				StarterPlayer2 = StarterPlayer
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end

			local children2, value19, value20 = StarterPlayer2:GetChildren()
			for k in value19, value20 do
			end
			if nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
		end

		if data[not pcall(gameRef.GetChildren)] then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		else
			callback4(393832580, 94)
			number2 = number4
		end

		local value = Enum
		local number3 = number2

		if callback8(type(value), "userdata") then
			callback4(393832580, 7)
			number2 = number3
			number = number3
		else
			number = number3
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(typeof(value), "Enums") then
			callback4(393832580, 160)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local value19 = getmetatable(value)

		if callback8("The metatable is locked", value19) then
			callback4(393832580, 246)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local viewer = value.HumanoidDisplayDistanceType.Viewer.EnumType.Viewer

		if callback8(type(viewer), "userdata") then
			callback4(393832580, 246)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local number15 = bit32.bxor(number14, 148)

		if callback8(typeof(viewer), "EnumItem") then
			callback4(393832580, 8)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local value20 = getmetatable(viewer)

		if callback8("The metatable is locked", value20) then
			callback4(393832580, 250)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		callback12(viewer.IsA, "IsA")
		callback13(viewer.IsA)
		local name = viewer.Name
		local value = viewer.Value

		if callback8(type(name), "string") then
			callback4(393832580, 206)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(type(value), "number") then
			callback4(393832580, 243)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local enumType = viewer.EnumType

		if callback8(viewer, enumType[name]) then
			callback4(393832580, 100)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(type(enumType), "userdata") then
			callback4(393832580, 39)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(typeof(enumType), "Enum") then
			callback4(393832580, 94)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local value21 = getmetatable(enumType)

		if callback8("The metatable is locked", value21) then
			callback4(393832580, 90)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		callback12(enumType.FromName, "FromName")
		callback12(enumType.FromValue, "FromValue")
		callback13(enumType.FromName)
		callback13(enumType.FromValue)
		local value22 = enumType:FromName(name)

		if callback8(viewer, value22) then
			callback4(393832580, 103)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local value23 = enumType:FromValue(value)
		value13 = bit32.bxor(number15, 225)

		if callback8(viewer, value23) then
			callback4(393832580, 19)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
	end

	local value14

	do
		local new = value5.new
		callback12(new, "new")
		callback13(new, {})
		local value15 = new(1855281556)

		if callback8(type(value15), "userdata") then
			callback4(393832580, 133)
			number2 = number
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(typeof(value15), "Random") then
			callback4(393832580, 82)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		callback12(value15.NextUnitVector, "NextUnitVector")
		callback12(value15.NextInteger, "NextInteger")
		callback12(value15.NextNumber, "NextNumber")
		callback12(value15.Shuffle, "Shuffle")
		callback12(value15.Clone, "Clone")
		value14 = new(1879341664)
	end

	callback5(value14:NextInteger(757, 873), 4)
	do
		local unpack_ = string.unpack
		local pack = string.pack
		local randNum = value14:NextNumber()
		callback5(unpack_(">I4", pack(">f", randNum)), 4)
	end
	do
		local unpack_ = string.unpack
		local pack = string.pack
		local randNum = value14:NextNumber()
		callback5(unpack_("<I4", pack(">f", randNum)), 4)
	end
	do
		local unpack_ = string.unpack
		local pack = string.pack
		local randNum = value14:NextNumber()
		callback5(unpack_("<I4", pack("<f", randNum)), 4)
	end
	do
		local unpack_ = string.unpack
		local pack = string.pack
		local randNum = value14:NextNumber()
		callback5(unpack_("<I4", pack("<f", randNum)), 4)
	end
	do
		local unpack_ = string.unpack
		local pack = string.pack
		local randNum = value14:NextNumber()
		callback5(unpack_("<I4", pack("<f", randNum)), 4)
	end
	callback5(value14:NextInteger(989, 1740), 4)

	do
		local clone = value14:Clone()
		local unpack_ = string.unpack
		local pack = string.pack
		local randNum = value14:NextNumber()
		callback5(unpack_(">I4", pack(">f", randNum)), 4)
		local unpack_ = string.unpack
		local pack = string.pack
		local randNum2 = value14:NextNumber()
		callback5(unpack_("<I4", pack("<f", randNum2)), 4)
		callback5(clone:NextInteger(385, 1091), 4)
		value14:Clone()
		callback5(clone:NextInteger(14, 815), 4)
	end

	do
		local unpack_ = string.unpack
		local pack = string.pack
		local randNum = value14:NextNumber()
		callback5(unpack_(">I4", pack(">f", randNum)), 4)
	end
		local number12 = bit32.bxor(value13, 174)

	do
		local number13 = 24

		local data4 = {
			[1016736547] = 12,
			[2693073350] = 6,
			[1224871389] = 24,
			[2663729603] = 6,
			[3142871885] = 6,
			[3725696325] = 24,
			[3984386647] = 6,
			[1081748772] = 6,
			[2877625027] = 6,
			[4018728689] = number13,
			[2911200381] = 6,
			[220060289] = number13,
			[528858135] = number13,
			[3377380232] = 6,
			[3609654548] = number13,
			[2971156251] = number13,
			[1603403483] = number13,
			[3830516021] = number13,
			[1916228571] = 12,
			[1710546075] = 6,
			[1552596886] = 6,
			[385305274] = number13,
			[90777649] = number13,
			[1576158841] = number13,
			[1411601351] = number13,
			[275147556] = 6,
			[3993608199] = number13,
			[3208301543] = number13,
			[3787312583] = number13,
			[3218009230] = number13,
			[1980091963] = number13,
			[2592174623] = 6,
		}

		local env = getfenv()
		local envMap = {}
		local data5 = {}
		local number14 = 0
		local data6 = { value, 3, nil, 0, 1 }

		while true do
			local value15 = data6[5]
			local value16 = data6[2]
			local number15 = data6[4] + value15
			data6[4] = number15

			if number15 <= value16 then
				if not nil and not nil then
					envMap[env] = true
					local number16 = 0

					for k in nil, nil do
						number16 += 1
						local valueType = type(k)

						if callback8("string", valueType) then
							if #k < 20 then
								local value17 = callback10(k, 335884524)

								if data5[value17] then
									if not (number16 > 50) then
										continue
									end
								else
									local number17 = data4[value17] or 0
									number14 += number17
									data5[value17] = true
									if not (number16 > 50) then
										continue
									end
								end
							elseif not (number16 > 50) then
								continue
							end
						elseif not (number16 > 50) then
							continue
						end

						break
					end

					local number = number14
					local value17 = getmetatable(env)
					local number17 = bit32.bxor(number12, 136)
					local condition = type(value17) == "table"
					local number2, value18

					if condition then
						number2 = number
						value18 = rawget(value17, "__index")
					else
						number2 = number
						value18 = condition
					end

					value18 = value18 or nil
					number12 = bit32.bxor(number17, 136)
					local number = number2
					env = value18
					number14 = number
					continue
				end

				break
			else
				break
			end
		end

		local value15 = data6[1]
		local number15 = number14 < number13 and 139 or 97
		callback4(393832580, number15)
		if nil then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		local ok, response = pcall(assert, false)
		local response = response
		local ok2 = ok or not response or type(response) ~= "string"
		if ok2 then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end
		local ok3, response2 = pcall(function(argument, ...)
		(...)[...] = nil
	end)
		local ok4, response3 = pcall(function(argument, ...)
		return (...)[...]
	end)
		local response = response3
		local ok5, response4 = pcall(function(argument, ...)
		return (...)()
	end)
		local ok = ok5
		local response3 = response4
		local response4
		if ok3 then
			response4 = response2
		else
			ok3 = ok4
			response4 = response2
		end
		if ok3 or ok then
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local function callback15(argument, argument2)
			local number16 = 3818661702
			local pos, value16, number17 = string.find(argument, "%:(%d%d*)[^%x%X]-[%:\n\r]")
			local condition = not pos
			local condition2
			if pos then
				condition2 = not value16
			else
				condition2 = condition
			end
			if condition2 then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			callback5(pos, 2)
			callback5(value16, 2)
			local match = string.match(argument, "%:[^%l%L]?([0-9]+)[^%s%S]*[\r:\n]")
			local callback = callback5
			local match2
			if number17 then
				match2 = match
			else
				match2 = match
				number17 = 0
			end
			callback(number17 + 0, 2)
			callback5((match2 or 0) + 0, 2)
			local argument3 = string.gmatch(argument, "%:[^%p%P]-([%d]+)[\r\n%:][^%x%X]*")
			local number18 = argument3()
			callback8(argument3(), nil)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			local callback = callback5
			local callback2
			if number18 then
				callback2 = callback
			else
				callback2 = callback
				number18 = 0
			end
			callback2(number18 + 0, 2)
			local text = string.sub(argument, pos + 1, value16 - 1)
			local argument4 = string.char(string.byte(argument, pos + 1, value16 - 1))
			local argument5 = string.byte(argument, pos + 1, pos + 1)
			callback5(text + 0, 2)
			callback5(argument4 + 0, 2)
			callback4(393832580, argument5)
			local data7 = { nil, value16 - 1 + 0, pos + 1 - 1, 1, nil }
			local number19 = 0
			local data = data7

			while true do
				local value17 = data[4]
				local value18 = data[2]
				local number20 = data[3] + value17
				data[3] = number20
				if number20 <= value18 then
					number19 = number19 * 10 + string.byte(argument, number20, number20) - 48
				else
					break
				end
			end

			callback5(number19, 2)
			local argument7 = nil
			local number20 = 0
			local number21 = 196372590

			local function callback16(argument6)
				argument7 = argument6
				number20 += 1
				if nil then
					number21 = bit32.bxor(number21, 1027305649)
				end
			end

			number21 = 494819285
			local text2, value17 = string.gsub(argument, "[:][^%x%X]*([%d]%d*)[\r\n:][^%l%L]-", callback16, 1)
			callback8(number20, 1)
			if not (nil) then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			callback8(value17, 1)

			if nil then
				callback5((argument7 or 0) + 0, 2)
				callback8(string.sub(argument, 2, 2), argument2)
				if not nil then
					callback5(503354784, 4)
					number2 = 35521203
					callback6()
				end
				local callback = callback4
				local argument6 = string.byte(argument, 2, 2)
				callback(393832580, argument6)
				return
			end

			callback5(503354784, 4)
			-- 			
		end

		callback15("input.lua:179: attempt to perform arithmetic (mod) on boolean and boolean", "n")
		callback15("source.lua:19: attempt to perform arithmetic (sub) on number and number", "o")
		callback15("LocalScript:56: attempt to index function with number", "o")

		callback3 = function(argument)
			local number16 = 4216081537
			local callback16 = nil
			local match = string.match(argument, ":[^%c%C]-([%d]%d*)[\r\n%:][^%d%D]*")
			local value16 = string.gmatch(argument, "[%:](%d%d*)[^%a%A]*[:\n\r][^%c%C]*")()
			local pos, value17 = string.find(argument, "[:][^%l%L]*([0-9]+)[:\r\n]")
			local pos = pos
			local value = value17
			local condition = not pos
			local condition2
			if pos then
				condition2 = not value
			else
				condition2 = condition
			end
			if condition2 then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			local stringSub = string.sub
			local char = string.char
			local byte = string.byte
			local number17 = pos + 1
			local value18 = stringSub(argument, pos + 1, value - 1)
			local value19 = char(byte(argument, number17, value - 1))
			local argument3 = nil
			local number18 = 0
			local number19 = number16 - 3687146838

			callback16 = function(argument2)
				callback8(info(1, "f"), callback16)
				local gsub, value20

				if nil then
					gsub = string.gsub
					value20 = callback8(info(2, "f"), gsub)
					if nil then
						number19 = bit32.bxor(number19, 3021916639)
					end
					if not value20 then
						callback5(503354784, 4)
						number2 = 35521203
						callback6()
					end

					while true do
						callback8(info(3, "f"), callback3)
						callback5(503354784, 4)
						number2 = 35521203
						callback6()
						if number19 == 133796186 then
							callback5(503354784, 4)
							number2 = 35521203
							callback6()
							continue
						end
						break
					end
				else
					local callback = callback5

					if number19 + 239476575 == 510137545 then
						callback(503354784, 4)
						number2 = 35521203
						callback6()
						gsub = string.gsub
						value20 = callback8(info(2, "f"), gsub)
						if nil then
							number19 = bit32.bxor(number19, 3021916639)
						end
						if not value20 then
							callback5(503354784, 4)
							number2 = 35521203
							callback6()
						end

						while true do
							callback8(info(3, "f"), callback3)
							callback5(503354784, 4)
							number2 = 35521203
							callback6()
							if number19 == 133796186 then
								callback5(503354784, 4)
								number2 = 35521203
								callback6()
								continue
							end
							break
						end
					end
				end

				argument3 = argument2
				number18 += 1
			end

			number19 = 270660970
			local text, value20 = string.gsub(argument, ":(%d%d*)[^%d%D]-[:\n\r][^%c%C]-", callback16, 1)
			callback8(number18, 1)
			local value

			if nil then
				value = value19
			else
				value = value19
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end

			callback8(value20, 1)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			local condition3 = not match
			local condition4
			if match then
				condition4 = not value16
			else
				condition4 = condition3
			end
			if condition4 or not value18 or not value or not argument3 then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			local number20 = match + 0
			local number21 = value16 + 0
			local number22 = value18 + 0
			local number23 = value + 0
			local number24 = argument3 + 0
			callback8(match, value16)
			local number

			if nil then
				number = number20
			else
				number = number20
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end

			callback8(value16, value18)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			callback8(value18, value)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			callback8(value, argument3)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			callback8(number, number21)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			callback8(number21, number22)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			callback8(number22, number23)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			callback8(number23, number24)
			if not nil then
				callback5(503354784, 4)
				number2 = 35521203
				callback6()
			end
			return number
		end

		local value16 = callback3(response4)
		local value17 = callback3(response)
		local value18 = callback3(response3)

		if callback8(value16, value17) then
			callback4(393832580, 221)
			number2 = number
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(value17, value18) then
			callback4(393832580, 182)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(value18, value16) then
			callback4(393832580, 33)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		for _, value19 in nil, nil do
			local valueType = type(value19)
			if callback8("function", valueType) then
				info(value19, "sl")
			end
		end
		callback9(nil --[[ the caller's registers ]])
		setmetatable(nil --[[ the caller's registers ]], nil)
		local data7 = {}
		local data8 = {}
		local number16 = 201
		local number17 = 215
		local data9 = { 255, -1, 1, value15, nil }

		while true do
			local value19 = data9[3]
			local value20 = data9[1]
			local number18 = data9[2] + value19
			data9[2] = number18

			if number18 <= value20 then
				local number = number18
				local number19 = (number16 * number + number17) % 256
				local number20 = bit32.bxor(number12, value12) + 2809519515
				local condition = bit32.band(condition10, 4294967295)
				local condition2 = bit32.band(condition, 65535)
				local value21 = bit32.band(56731 * condition2 + bit32.lshift(bit32.band(56731 * bit32.rshift(condition, 16) + 42869 * condition2, 65535), 16), 4294967295)
				local condition3 = bit32.bnot(condition10)
				local condition4 = bit32.band(condition3, 65535)
				local number21 = number20 + value21 + bit32.band(56731 * condition4 + bit32.lshift(bit32.band(56731 * bit32.rshift(condition3, 16) + 42869 * condition4, 65535), 16), 4294967295)
				local number22 = (number16 * number19 + number17) % 256
				local number23 = (number16 * number22 + number17) % 256
				local number24 = (number16 * number23 + number17) % 256
				data7[number] = number19 + number22 * 256 + number23 * 65536 + number24 * 16777216
				data8[number] = number24
				number12 = bit32.bxor(number21, 178)
			else
				break
			end
		end

		local value19 = data9[4]
		buffer.create(16)

		local function callback16(argument, argument2)
			local number18 = 434853639
			local number19 = 1910914994
			local data10 = {}
			local argument3 = buffer.readu8(argument, argument2)
			local number20

			if nil then
				number20 = argument2 + 1
			else
				local argument4 = buffer.readu8(argument, argument2 + 1)

				if nil then
					argument3 = argument3 - 128 + argument4 * 128
					number20 = argument2 + 2
				else
					local argument5 = buffer.readu8(argument, argument2 + 2)

					if nil then
						argument3 = (argument3 - 128) * 16384 + (argument4 - 128) * 128 + argument5
						number20 = argument2 + 3
						number18 = bit32.bor(number18, number19) + 2684082000
					else
						local number21 = (argument3 - 128) * 16384 + (argument4 - 128) * 128
						local argument6 = buffer.readu8(argument, argument2 + 3)
						argument3 = number21 + (argument5 - 128) * 2097152 + argument6 % 128 + (argument6 - argument6 % 128) * 2097152
						number20 = argument2 + 4
						number19 = number18 - 2818905941
					end
				end
			end

			local number21 = argument3 - 65825
			local argument4 = buffer.readu8(argument, number20)
			local number22 = number20 + 1
			data10[5] = argument4 ~= 0
			local list = table.create(number21)
			local number23 = 1831369132
			data10[7] = list
			local number24 = 1745709237
			local data11 = { nil, 0, nil, 1, number21 + 0 }

			while true do
				local value20 = data11[4]
				local value21 = data11[5]
				local number25 = data11[2] + value20
				data11[2] = number25

				if number25 <= value21 then
					local number = number25
					local argument5 = buffer.readu8(argument, number22)

					if nil then
						number22 += 1
					else
						local argument6 = buffer.readu8(argument, number22 + 1)

						if nil then
							argument5 = argument5 - 128 + argument6 * 128
							number22 += 2
						else
							local argument7 = buffer.readu8(argument, number22 + 2)

							if nil then
								argument5 = (argument5 - 128) * 16384 + (argument6 - 128) * 128 + argument7
								number22 += 3
							else
								local number26 = (argument5 - 128) * 16384 + (argument6 - 128) * 128
								local argument8 = buffer.readu8(argument, number22 + 3)
								argument5 = number26 + (argument7 - 128) * 2097152 + argument8 % 128 + (argument8 - argument8 % 128) * 2097152
								number22 += 4
								number23 = 1831369132
							end
						end
					end

					list[number] = argument5
				else
					break
				end
			end

			local argument5 = buffer.readu8(argument, number22)
			local number25, number26

			if nil then
				number25 = 6
				number26 = number22 + 1
			else
				number25 = 6
				local argument6 = buffer.readu8(argument, number22 + 1)

				if nil then
					argument5 = argument5 - 128 + argument6 * 128
					number26 = number22 + 2
				else
					local argument7 = buffer.readu8(argument, number22 + 2)

					if nil then
						local number27 = bit32.bor(number19, number23)
						argument5 = (argument5 - 128) * 16384 + (argument6 - 128) * 128 + argument7
						number26 = number22 + 3
						number19 = number27 + 4093100020
					else
						local number27 = (argument5 - 128) * 16384 + (argument6 - 128) * 128 + (argument7 - 128) * 2097152
						local argument8 = buffer.readu8(argument, number22 + 3)
						argument5 = number27 + argument8 % 128 + (argument8 - argument8 % 128) * 2097152
						number26 = number22 + 4
						number23 = 1831369132
						number24 = number24 + number19 + 2384052302
					end
				end
			end

			local buf = buffer.create(argument5)
			buffer.copy(buf, 0, argument, number26, argument5)
			local number27 = number26 + argument5
			data10[number25] = buf
			local argument6 = buffer.readu8(argument, number27)

			if not (argument6 < 128) then
				local argument2 = argument6
				local number = number27
				local argument7 = buffer.readu8(argument, number + 1)

				if argument7 < 128 then
					local number28 = bit32.band(number19, 4294967295)
					local number29 = bit32.band(number23, 4294967295)
					local number30 = bit32.band(number28, 65535)
					local number31 = bit32.rshift(number28, 16)
					local number32 = bit32.band(number29, 65535)
					number19 = bit32.band(number30 * number32 + bit32.lshift(bit32.band(number30 * bit32.rshift(number29, 16) + number31 * number32, 65535), 16), 4294967295) - 2797055462
					argument6 = argument2 - 128 + argument7 * 128
				else
					local argument3 = argument7
					local argument8 = buffer.readu8(argument, number + 2)

					if argument8 < 128 then
						argument6 = (argument2 - 128) * 16384 + (argument3 - 128) * 128 + argument8
					else
						local argument4 = argument8
						local argument9 = buffer.readu8(argument, number + 3)
						argument6 = (argument2 - 128) * 16384 + (argument3 - 128) * 128 + (argument4 - 128) * 2097152 + argument9 % 128 + (argument9 - argument9 % 128) * 2097152
					end
				end
			end

			return ((function(...) end)(data10, argument6, 99))
		end

		if data[false] then
			callback4(393832580, 171)
			number2 = number
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		local valueType = type(table.pack(37799, 1076377183, 3545617833, 1824498996, 2106045823, 753027531, 2696587307, 394255810, 2294208935))

		if callback8("table", valueType) then
			callback4(393832580, 130)
		else
			callback5(503354784, 4)
			number2 = 35521203
			callback6()
		end

		if callback8(9, 9) then
			callback4(393832580, 86)
			local data10 = { 1, 0, value19, nil, 9 }

			while true do
				local value20 = data10[1]
				local value21 = data10[5]
				local number18 = data10[2] + value20
				data10[2] = number18

				if number18 <= value21 then
					local valueType2 = type((table.pack(37799, 1076377183, 3545617833, 1824498996, 2106045823, 753027531, 2696587307, 394255810, 2294208935))[number18])
					callback8("number", valueType2)
					if not nil then
						callback5(503354784, 4)
						number2 = 35521203
						callback6()
					end
				else
					break
				end
			end

			local data11 = { 9, nil, 1, data10[3], 0 }

			while true do
				local value20 = data11[3]
				local value21 = data11[1]
				local number18 = data11[5] + value20
				data11[5] = number18

				if number18 <= value21 then
					local number = number18
					local value22 = (table.pack(37799, 1076377183, 3545617833, 1824498996, 2106045823, 753027531, 2696587307, 394255810, 2294208935))[number]
					local value

					if number ~= 1 then
						value = value22
						if nil then
							local number19 = value % 65536
							value = value - number19 + number19
						end
					else
						value = value22
					end

					callback5(value, 4)
				else
					break
				end
			end

			if nil then
				return
			end
			buffer.readi32(nil, 509)
			buffer.readi32(nil, 941)
			local value20 = buffer.readi32(nil, 152)
			buffer.readi32(nil, 114)
			local value21 = callback18(nil, nil, 137959887)
			local value = value20
			local value22 = bit32.band(value, 4294967295)
			local value23 = bit32.band(value22, 65535)
			local value24 = bit32.band(40796 * value23 + bit32.lshift(bit32.band(40796 * bit32.rshift(value22, 16) + 43917 * value23, 65535), 16), 4294967295)
			local value25 = bit32.band(value, 4294967295)
			local value26 = bit32.band(value25, 65535)
			local value27 = bit32.band(0 * value26 + bit32.lshift(bit32.band(0 * bit32.rshift(value25, 16) + 0 * value26, 65535), 16), 4294967295)
			local value28 = bit32.band(value27, 65535)
			local number18 = 2878185492 + value24 + bit32.band(40796 * value28 + bit32.lshift(bit32.band(40796 * bit32.rshift(value27, 16) + 43917 * value28, 65535), 16), 4294967295)
			local value29 = bit32.band(value, 4294967295)
			local value30 = bit32.band(value29, 65535)
			local value31 = bit32.band(value30 * 65535 + bit32.lshift(bit32.band(value30 * 65535 + bit32.rshift(value29, 16) * 65535, 65535), 16), 4294967295)
			local value32 = bit32.band(value31, 65535)
			return callback16(value21, number18 + 0 + 1416781988 + bit32.band(40796 * value32 + bit32.lshift(bit32.band(40796 * bit32.rshift(value31, 16) + 43917 * value32, 65535), 16), 4294967295))(nil, {}, nil)(...)
		end
	end

	callback5(503354784, 4)
	number2 = 35521203
	callback6()
	-- devirt: spin loop left out (it decoded to no statements)
end

-- VM 717700_698577091@0,596615: root proto #30 (1 protos captured; the script)

local function callback()
	local function callback2()
		local genv = (getgenv and getgenv()) or _G
		local color3FromRGB = Color3.fromRGB
		local uDim2FromOffset = UDim2.fromOffset
		local uDim2New = UDim2.new
		genv.ChilliCanvasHold = true
		local CoreGui = game:GetService("CoreGui")
		pcall(function()
			local hui = gethui()
			if typeof(hui) == "Instance" then
				CoreGui = hui
			end
		end)
		local chilliHubLoading = CoreGui:FindFirstChild("ChilliHubLoading")
		if chilliHubLoading then
			chilliHubLoading:Destroy()
		end

		local function callback3(argument, parent, argument2)
			local instance = Instance.new(argument)
			for k, value in next, argument2, nil do
				instance[k] = value
			end
			instance.Parent = parent
			return instance
		end

		local function callback4(argument, argument2)
			callback3("UICorner", argument, {CornerRadius = UDim.new(argument2, ((argument2 == 1) and 0) or 10)})
		end
		local ScreenGui = callback3("ScreenGui", nil, {Name = "ChilliHubLoading", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
		local Frame = callback3("Frame", ScreenGui, {AnchorPoint = Vector2.new(0.5, 0), Position = uDim2New(0.5, 0, 0, 24), Size = uDim2FromOffset(260, 64), BackgroundColor3 = color3FromRGB(18, 18, 22), BackgroundTransparency = 0.05})
		callback4(Frame, 0)
		callback3("UIStroke", Frame, {Color = color3FromRGB(255, 60, 60), Thickness = 1.5, Transparency = 0.2})
		local function getTextLabel(argument, argument2, argument3, argument4, argument5, argument6, argument7)
			return callback3("TextLabel", Frame, {BackgroundTransparency = 1, Position = uDim2FromOffset(12, argument), Size = uDim2New(1, -24, 0, argument2), Font = argument3, TextSize = argument4, TextColor3 = argument5, TextXAlignment = argument6, Text = argument7})
		end
		local gothamBold, left = Enum.Font.GothamBold, Enum.TextXAlignment.Left
		getTextLabel(8, 18, gothamBold, 15, color3FromRGB(255, 255, 255), left, "Chilli Hub")
		local textLabel = getTextLabel(8, 18, gothamBold, 15, color3FromRGB(255, 120, 90), Enum.TextXAlignment.Right, "0%")
		local textLabel2 = getTextLabel(27, 14, Enum.Font.GothamMedium, 12, color3FromRGB(170, 170, 185), left, "Loading part 1 / 10")
		gothamBold = callback3("Frame", Frame, {Position = uDim2FromOffset(12, 46), Size = uDim2New(1, -24, 0, 8), BackgroundColor3 = color3FromRGB(42, 42, 50)})
		callback4(gothamBold, 1)
		local Frame2 = callback3("Frame", gothamBold, {Size = uDim2New(0, 0, 1, 0), BackgroundColor3 = color3FromRGB(255, 255, 255)})
		callback4(Frame2, 1)
		callback3("UIGradient", Frame2, {Color = ColorSequence.new(color3FromRGB(255, 50, 50), color3FromRGB(255, 150, 60))})
		ScreenGui.Parent = CoreGui
		local text = "ChilliLibrary/SAE_LoadProgress.txt"
		local number
		pcall(function()
			if isfile(text) then
				number = tonumber(readfile(text):match("^(%d+)"))
			end
		end)

		local function saveFile(argument)
			pcall(function()
				if not (isfolder("ChilliLibrary")) then
					makefolder("ChilliLibrary")
				end
				writefile(text, argument .. (" " .. os.time()))
			end)
		end

		saveFile(0)
		genv.ChilliHubLoading = os.clock() + 30

		genv.ChilliHubLoadStep = function(argument)
			local number2 = math.clamp(math.floor(tonumber(argument) or 0), 0, 10)
			saveFile(number2)
			pcall(function()
				Frame2.Size, textLabel.Text = uDim2New(number2 / 10, 0, 1, 0), (number2 * 10) .. "%"
				textLabel2.Text = ((number2 >= 10) and "Loaded") or ("Loading part " .. ((number2 + 1) .. " / 10"))
			end)
			task.wait()
			if number2 < 10 then
				return
			end
			genv.ChilliHubLoadStep = nil
			genv.ChilliCanvasHold = nil
			genv.ChilliHubLoading = nil

			if number and (number < 10) then
				pcall(function()
					textLabel2.Text, textLabel2.TextColor3 = "Last load stopped at " .. ((number * 10) .. ("% (part " .. ((number + 1) .. " / 10)"))), color3FromRGB(255, 170, 90)
				end)
				task.delay(8, pcall, ScreenGui.Destroy, ScreenGui)
			else
				pcall(ScreenGui.Destroy, ScreenGui)
			end
		end
	end

	callback2()

	local function createUiLibrary()
		local data = {}

		do
			local function getService(argument)
				return game:GetService(argument)
			end
			local TweenService = getService("TweenService")
			local UserInputService = getService("UserInputService")
			local RunService = getService("RunService")
			local HttpService = getService("HttpService")
			local GuiService, scrollingFrame = getService("GuiService"), Enum
			local color3FromRGB = Color3.fromRGB
			local uDim2New = UDim2.new
			local uDim2FromScale = UDim2.fromScale
			local uDim2FromOffset = UDim2.fromOffset
			local vector2New = Vector2.new
			local uDimNew = UDim.new
			local value = color3FromRGB(255, 255, 255)
			local value2 = color3FromRGB(0, 0, 0)
			local value3 = color3FromRGB(58, 255, 55)
			local value4 = vector2New(0.5, 0.5)
			local value5 = vector2New(0, 0.5)
			local value6 = vector2New(1, 0.5)
			local value7 = vector2New(0.5, 0)
			local value8 = uDim2FromScale(0.5, 0.5)
			local value9 = uDim2FromScale(0.5, 0)
			local value10 = uDim2FromScale(1, 1)
			local value11 = vector2New(1280, 720)
			local floor = math.floor
			local clamp = math.clamp
			local max = math.max
			local min = math.min
			local abs = math.abs
			local ceil, value12 = math.ceil, tostring
			local layoutOrder, text = scrollingFrame.SortOrder.LayoutOrder, "rbxasset://fonts/families/GothamSSm.json"
			local font = Font.new(text, scrollingFrame.FontWeight.ExtraBold, scrollingFrame.FontStyle.Normal)
			local font2 = Font.new(text, scrollingFrame.FontWeight.ExtraBold, scrollingFrame.FontStyle.Italic)
			local font3 = Font.fromEnum(scrollingFrame.Font.FredokaOne)

			local function callback51(...)
				local iMap, data2 = {}, {...}
				for i, value13 in ipairs(data2) do
					iMap[i] = ColorSequenceKeypoint.new(value13[1], value13[2])
				end
				return ColorSequence.new(iMap)
			end

			local value13 = callback51({0, value}, {0.486159176, value}, {0.519031167, color3FromRGB(221, 221, 221)}, {1, color3FromRGB(236, 236, 236)})
			local value14 = callback51({0, color3FromRGB(0, 36, 84)}, {1, color3FromRGB(0, 31, 54)})
			local value15 = callback51({0, value3}, {1, color3FromRGB(20, 109, 0)})
			local value16 = callback51({0, color3FromRGB(255, 193, 194)}, {0.0570934266, color3FromRGB(255, 132, 123)}, {1, color3FromRGB(239, 28, 28)})
			local value17 = callback51({0, color3FromRGB(255, 193, 194)}, {0.0155709349, color3FromRGB(255, 132, 123)}, {1, color3FromRGB(239, 28, 28)})
			local touchEnabled = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) and not UserInputService.MouseEnabled
			local left = scrollingFrame.TextXAlignment.Left
			local center = scrollingFrame.HorizontalAlignment.Center
			local right = scrollingFrame.TextXAlignment.Right
			local quart = scrollingFrame.EasingStyle.Quart
			local quint = scrollingFrame.EasingStyle.Quint
			local contextual = scrollingFrame.ApplyStrokeMode.Contextual
			local border = scrollingFrame.ApplyStrokeMode.Border
			local userInputType, begin = scrollingFrame.UserInputType, scrollingFrame.UserInputState.Begin
			local mouseButton1 = userInputType.MouseButton1
			local mouseMovement = userInputType.MouseMovement
			local touch, connections = userInputType.Touch, {}
			local function trackConnection(argument, argument2)
				local connection = argument:Connect(argument2)
				connections[#connections + 1] = connection
				return connection
			end
			local function callback3(argument, argument2, argument3)
				return trackConnection(argument:GetPropertyChangedSignal(argument2), argument3)
			end
			local value18, textValues, labelMap = color3FromRGB(198, 198, 198), {TextLabel = 1, TextButton = 1, TextBox = 1}, {n = "Name", A = "AnchorPoint", P = "Position", S = "Size", B = "BackgroundColor3", T = "BackgroundTransparency", Z = "ZIndex", O = "LayoutOrder", X = "TextXAlignment", W = "TextWrapped", V = "Visible", C = "ClipsDescendants", R = "Rotation", H = "HorizontalAlignment", Y = "SortOrder", a = "Active", t = "TextTransparency", y = "TextYAlignment", PH = "PlaceholderText", PC3 = "PlaceholderColor3", G = "Padding", x = "Text"}

			local function number(argument, argument2)
				local instance = Instance.new(argument)
				if textValues[argument] then
					instance.BackgroundTransparency = 1
					instance.Text = ""
				end
				if argument == "TextButton" then
					instance.AutoButtonColor = false
				elseif argument == "ImageButton" then
					instance.AutoButtonColor = false
				end
				if argument == "TextBox" then
					instance.ClearTextOnFocus = false
				end
				if instance:IsA("GuiObject") then
					instance.BorderSizePixel = 0
				end

				for k, value19 in next, argument2, nil do
					if type(k) == "number" then
						value19.Parent = instance
					elseif k ~= "p" then
						if k ~= "Parent" then
							instance[labelMap[k] or k] = value19
						end
					end
				end

				instance.Parent = argument2.p or argument2.Parent
				return instance
			end

			local function getFrame(argument)
				return number("Frame", argument)
			end
			local function toUDim2(argument)
				return uDim2New(1, 0, 0, argument)
			end
			local function getTextButton(argument)
				return number("TextButton", argument)
			end

			local function callback4(argument, argument2, argument3, argument4)
				local UIStroke = number("UIStroke", {Thickness = argument, Color = argument2 or value2, ApplyStrokeMode = (argument3 and contextual) or border, LineJoinMode = scrollingFrame.LineJoinMode.Round, Transparency = argument4 or 0})
				pcall(function()
					UIStroke.BorderOffset = uDimNew(0, 0)
					UIStroke.BorderStrokePosition = scrollingFrame.BorderStrokePosition.Outer
					UIStroke.StrokeSizingMode = scrollingFrame.StrokeSizingMode.ScaledSize
				end)
				return UIStroke
			end

			local function getUIGradient(argument, argument2)
				return number("UIGradient", {Color = argument, R = 90, n = argument2})
			end
			local function getUIAspectRatioConstraint(argument)
				return number("UIAspectRatioConstraint", {DominantAxis = (argument and scrollingFrame.DominantAxis.Height) or scrollingFrame.DominantAxis.Width})
			end

			local function callback5(parent)
				parent.FontFace = font
				parent.TextColor3 = value
				parent.TextScaled = true
				parent.LineHeight = 1
				callback4(0.08, value2, true).Parent = parent
				return parent
			end

			local function callback6(parent, fontFace)
				parent.FontFace = fontFace
				parent.TextColor3 = value
				parent.TextScaled = true
				parent.LineHeight = 1
				getUIGradient(value13, "TextStyleGradient").Parent = parent
				fontFace = callback4(0.065, value, true)
				getUIGradient(value14, "StrokeStyleGradient").Parent = fontFace
				fontFace.Parent = parent
				return parent
			end

			local function callback7(argument, argument2)
				local TextLabel = number("TextLabel", argument)
				if argument2 then
					return callback6(TextLabel, ((argument2 == true) and font) or argument2)
				end
				return callback5(TextLabel)
			end

			local function callback8(argument)
				argument.TextTransparency = 0.32
				local uiStroke = argument:FindFirstChildOfClass("UIStroke")
				uiStroke.Thickness = 0.06
				uiStroke.Transparency = 0.2
				return argument
			end

			local function tw(argument, argument2, argument3, argument4, argument5)
				local tween = TweenService:Create(argument, TweenInfo.new(argument3 or 0.15, argument4 or scrollingFrame.EasingStyle.Quad, argument5 or scrollingFrame.EasingDirection.Out), argument2)
				tween:Play()
				return tween
			end
			local function callback9(argument, argument2, argument3)
				return tw(argument, {BackgroundTransparency = argument2}, argument3)
			end
			local function callback10(argument)
				local userInputType = argument.UserInputType
				return (userInputType == mouseButton1) or (userInputType == touch)
			end
			local function toVector2(argument)
				return vector2New(argument.Position.X, argument.Position.Y)
			end

			local function callback11(argument, argument2, argument3, argument4)
				local condition, input

				for _, value19 in ipairs(argument) do
					trackConnection(value19.InputBegan, function(input2)
						if not (condition) then
							if input2.UserInputState == begin then
								if callback10(input2) then
									if argument2(input2) ~= false then
										local input3
										input3, condition = ((input2.UserInputType == touch) and input2) or nil, true
										input = input3
									end
								end
							end
						end
					end)
				end

				local function callback12()
					condition = false
				end

				local value19, inputEnded = trackConnection(UserInputService.InputChanged, function(input2)
					if condition then
						if input and (input2 == input) then
							argument3(input2)
						elseif not (input) then
							if input2.UserInputType == mouseMovement then
								argument3(input2)
							end
						end
					end
				end), UserInputService.InputEnded

				local function callback13(argument5)
					local condition2 = condition and ((argument5.UserInputType == mouseButton1) or (argument5 == input))
					if condition2 then
						condition, input = false, nil
						if argument4 then
							argument4()
						end
					end
				end

				return callback12, value19, trackConnection(inputEnded, callback13)
			end

			data.errs = {}

			local function callback12(argument, ...)
				if argument then
					local ok, response = pcall(argument, ...)
					if not (ok) then
						warn("[Chilli] " .. value12(response))
						if #data.errs < 50 then
							data.errs[#data.errs + 1] = value12(response)
						end
					end
				end
			end

			local function callback13(argument, argument2, argument3)
				local UIScale, condition, value19 = number("UIScale", {p = argument, n = "InteractionScale"}), false
				local function playTween(argument4, argument5)
					if value19 then
						value19:Cancel()
					end
					value19 = tw(UIScale, {Scale = argument4}, argument5)
				end
				trackConnection(argument.MouseEnter, function()
					condition = true
					playTween(argument2, 0.1)
				end)
				trackConnection(argument.MouseLeave, function()
					condition = false
					playTween(1, 0.1)
				end)
				trackConnection(argument.MouseButton1Down, function()
					playTween(argument3, 0.055)
				end)
				trackConnection(argument.MouseButton1Up, function()
					playTween((condition and argument2) or 1, 0.08)
				end)
			end

			text, userInputType = setmetatable, {__mode = "k"}
			local value19 = text({}, userInputType)
			local function callback14(argument, argument2)
				local absolutePosition, absoluteSize = argument.AbsolutePosition, argument.AbsoluteSize
				return ((((argument.Parent and argument.Visible) and (argument2.X >= absolutePosition.X)) and (argument2.X <= (absolutePosition.X + absoluteSize.X))) and (argument2.Y >= absolutePosition.Y)) and (argument2.Y <= (absolutePosition.Y + absoluteSize.Y))
			end

			trackConnection(UserInputService.InputChanged, function(input)
				local value20 = value19[input]
				if value20 then
					value20.p = toVector2(input)
					if (value20.p - value20.s).Magnitude > 10 then
						value20.x = true
					end
				end
			end)

			local function callback15(argument, argument2)
				argument.Active = true

				trackConnection(argument.InputBegan, function(input)
					if input.UserInputType == touch then
						if input.UserInputState == begin then
							local value20 = toVector2(input)
							value19[input] = {b = argument, s = value20, p = value20}
						end
					end
				end)

				trackConnection(argument.Activated, function(inputObject)
					if inputObject then
						if inputObject.UserInputType == touch then
							local value20 = value19[inputObject]

							if value20 then
								if value20.b ~= argument then
									return
								elseif value20.x then
									return
								elseif not (callback14(argument, value20.p)) then
									return
								end
							else
								return
							end
						end
					end

					callback12(argument2)
				end)
			end

			local data2 = {}

			trackConnection(RunService.Heartbeat, function()
				if #data2 > 0 then
					local data = data2
					data2 = {}
					for _, value20 in ipairs(data) do
						callback12(value20)
					end
				end
			end)

			data.q = function(argument)
				local data = data2
				data[#data + 1] = argument
			end

			local function formatCompact(argument, argument2, argument3, argument4, argument5, argument6)
				local frame, data3 = getFrame({p = argument, n = "Caret", A = value4, P = argument3, S = argument4, T = 1, Z = argument5, getUIAspectRatioConstraint(true)}), {{0.335355, 45}, {0.664645, -45}}
				for _, value20 in ipairs(data3) do
					getFrame({p = frame, n = "Arm", A = value4, P = uDim2FromScale(value20[1], 0.535355), R = value20[2], S = uDim2FromScale(0.6657, argument6 or 0.2), B = argument2, Z = argument5 + 1})
				end
				return frame
			end

			local function formatCompact2(argument)
				local textButton = getTextButton({p = argument.p, n = argument.n, A = value4, P = argument.P or value8, S = argument.S, O = argument.O or 0, Z = argument.Z or 99})
				local frame = getFrame({p = textButton, n = "Main", A = value4, P = value8, S = uDim2FromScale(1, (argument.full and 1) or 0.92), B = color3FromRGB(175, 0, 0), callback4((argument.full and 0.07) or 0.06)})
				local frame2 = getFrame({p = frame, n = "ColorFrame", A = value7, P = value9, S = uDim2FromScale(1, 0.9), B = value, getUIGradient(value16, "RedGradient")})
				local frame3, value20 = getFrame({p = frame2, n = "Transparent", A = value4, P = value8, S = uDim2FromScale(0.965, 0.88), B = value, Z = 2, getUIGradient(value17, "RedGradient")}), callback7({p = frame2, n = "Label", A = value4, P = value8, S = argument.LSize or uDim2FromScale(0.94, 0.72), x = argument.Text, W = argument.wrap == true, Z = 6}, true)
				callback13(textButton, argument.h or 1.035, 0.96)
				return textButton, frame, value20, frame2, frame3
			end

			local function formatCompact3(argument, argument2, argument3, argument4, argument5, argument6)
				local frame = getFrame({p = argument, n = "Switch", A = vector2New(argument2, 0.5), P = uDim2FromScale(argument3, 0.5), S = uDim2FromScale(argument4, argument5), B = value, Z = argument6, callback4(0.06)})
				local UIGradient = number("UIGradient", {p = frame, n = "OFF", Color = ColorSequence.new(value2), R = 90, Transparency = NumberSequence.new(0.6)})
				local uiGradient = getUIGradient(value15, "ON")
				uiGradient.Parent = frame
				local frame2 = getFrame({p = frame, n = "Hold", A = value4, S = uDim2FromScale(0.72, 0.72), B = color3FromRGB(89, 89, 89), Z = argument6 + 2, callback4(0.09), getUIAspectRatioConstraint(), getFrame({n = "Color", A = value7, P = value9, S = uDim2FromScale(1, 0.9), B = value, Z = argument6 + 3})})

				return frame, function(enabled, argument7)
					UIGradient.Enabled = not enabled
					uiGradient.Enabled = enabled
					local value20 = uDim2FromScale((enabled and 0.72) or 0.28, 0.5)
					if argument7 == false then
						frame2.Position = value20
					else
						tw(frame2, {Position = value20}, 0.12)
					end
				end
			end

			data.N = number
			data.tw = tw
			local function getClonedTbl(argument)
				return ((type(argument) == "table") and table.clone(argument)) or argument
			end

			local function callback16(argument, argument2, argument3, argument4)
				local function callback17(argument5)
					callback9(argument2, (argument5 and 0.42) or 0.6, 0.16)
					tw(argument3, {Size = uDim2FromScale((argument5 and 1) or 0, 0.11)}, 0.2, quint)
				end
				trackConnection(argument.Focused, function()
					callback17(true)
				end)
				trackConnection(argument.FocusLost, function()
					callback17(false)
					if argument4 then
						argument4()
					end
				end)
			end

			local function readCachedFile(argument)
				local ok, response = pcall(readfile, argument)
				return (ok and response) or nil
			end
			local function saveFile(argument, argument2)
				pcall(writefile, argument, argument2)
			end

			local function ensureFolder(argument)
				if isfolder then
					if not (isfolder(argument)) then
						pcall(makefolder, argument)
					end
				end
			end

			local function dec(argument)
				if not (argument) then
					return
				end
				local ok, response = pcall(HttpService.JSONDecode, HttpService, argument)
				return (ok and response) or nil
			end

			local function enc(argument)
				local ok, response = pcall(HttpService.JSONEncode, HttpService, argument)
				return (ok and response) or nil
			end
			data.dec = dec
			data.enc = enc
			data.rd = readCachedFile
			data.wr = saveFile
			local number2, number3, number4 = 1000, 3, 12

			local function roundSigFigs(argument)
				if argument <= 0 then
					return 0
				end
				local number5 = 10 ^ (floor(math.log10(argument)) - 2)
				return floor((argument / number5) + 0.5) * number5
			end

			local function toNumberOrDefault(argument)
				argument = clamp(tonumber(argument) or 0, 0, number2)
				return ((argument <= 0) and 0) or roundSigFigs(10 ^ (number3 + (((number4 - number3) * argument) / number2)))
			end

			local function roundSigFigs2(argument)
				argument = tonumber(argument) or 0
				if argument <= 0 then
					return 0
				end
				return clamp(floor(((((math.log10(argument) - number3) / (number4 - number3)) * number2) * 100) + 0.5) / 100, 0, number2)
			end

			local function callback17(argument)
				local stringFormat, condition = string.format, ((argument >= 100) and "%.0f") or ((argument >= 10) and "%.1f")
				local value20 = stringFormat(condition or "%.2f", argument)
				return if value20:find(".", 1, true) then value20:gsub("0+$", ""):gsub("%.$", "") else value20
			end

			local function formatRate(argument)
				local numVal = toNumberOrDefault(argument)

				if numVal <= 0 then
					return "Off"
				elseif numVal < 1000000 then
					return callback17(numVal / 1000) .. " K/s"
				elseif numVal < 1000000000 then
					return callback17(numVal / 1000000) .. " M/s"
				end

				return callback17(numVal / 1000000000) .. " B/s"
			end

			local function formatCompact4(argument)
				local numVal = toNumberOrDefault(argument)
				if numVal <= 0 then
					return "0"
				elseif numVal < 1000000 then
					return callback17(numVal / 1000) .. "k"
				end
				return (string.format("%.3f", numVal / 1000000):gsub("0+$", ""):gsub("%.$", ""))
			end

			local unitMultipliers = {k = 1000, m = 1000000, b = 1000000000, t = 1000000000000}

			local function callback18(argument)
				argument = value12(argument or ""):gsub("[%s,/]", ""):lower():gsub("s$", "")
				if argument == "" then
					return 0
				elseif argument == "off" then
					return 0
				end
				local match, match2 = argument:match("^([%d%.]+)([kmbt]?)$")
				match = tonumber(match)
				return (match and roundSigFigs2(match * (unitMultipliers[match2] or 1000000))) or nil
			end

			data.s2v = toNumberOrDefault
			local function colorizeText(color, argument)
				local value20, value21, value22, text2 = floor((color.R * 255) + 0.5), floor((color.G * 255) + 0.5), floor((color.B * 255) + 0.5), value12(argument):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
				return ("<font color=\"rgb(%d,%d,%d)\">%s</font>"):format(value20, value21, value22, text2)
			end
			local index, index2, widgetSpecs = {}, {}, {}
			index.__index = index
			index2.__index = index2
			widgetSpecs.__index = widgetSpecs
			local number5, number6, arguments = 1, 1, {}
			local function callback19(argument)
				arguments[#arguments + 1] = argument
				argument()
			end
			local function callback20(argument)
				local ScreenGui = number("ScreenGui", argument)
				ScreenGui.Name, ScreenGui.ResetOnSpawn, ScreenGui.IgnoreGuiInset, ScreenGui.ZIndexBehavior = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 12), false, true, scrollingFrame.ZIndexBehavior.Sibling
				ScreenGui:SetAttribute("ChilliRB", true)
				return ScreenGui
			end
			local function callback21()
				local currentCamera = workspace.CurrentCamera
				local viewportSize = (currentCamera and currentCamera.ViewportSize) or value11
				return (((viewportSize.X < 1) or (viewportSize.Y < 1)) and value11) or viewportSize
			end
			local object2

			local function closeDropdown()
				if object2 then
					if object2.closeDD then
						object2.closeDD()
					end
				end
			end

			data.Window = function(argument)
				local object = setmetatable({Tabs = {}, Opts = {}, ByPath = {}, St = {}, open = false, cols = {}, rest = uDim2FromScale(0.5, 0.475)}, index)
				object2 = object
				local hui = (gethui and gethui()) or getService("CoreGui")
				object.par = hui

				for _, child in ipairs(hui:GetChildren()) do
					if child:IsA("ScreenGui") then
						if child:GetAttribute("ChilliRB") then
							child:Destroy()
						elseif (child:GetAttribute("ChilliLibraryOwned") or (child.Name == "Settings")) or (child.Name == "ChilliQuickBar") then
							if child:GetAttribute("ChilliScriptOwner") ~= "Joiner" then
								child:Destroy()
							end
						end
					end
				end

				object.dirP = "ChilliLibrary/Games/" .. argument.Game
				ensureFolder("ChilliLibrary")
				ensureFolder("ChilliLibrary/Games")
				ensureFolder(object.dirP)
				ensureFolder(object.dirP .. "/configs")
				local frame, guiInset = callback21(), vector2New()
				local value20 = vector2New()
				pcall(function()
					guiInset, value20 = GuiService:GetGuiInset()
				end)
				local frame2, frame3 = max((frame.X - guiInset.X) - value20.X, 1), max((frame.Y - guiInset.Y) - value20.Y, 1)
				local number7, number8 = 0.45 * frame2, 0.55 * frame3
				if (number7 / number8) > 1.34 then
					number7 = number8 * 1.34
				else
					number8 = number7 / 1.34
				end
				if touchEnabled then
					frame = min(1.3, (frame2 * 0.98) / max(number7, 1), (frame3 * 0.98) / max(number8, 1))
					number7, number8 = number7 * frame, number8 * frame
				end
				object.base = uDim2FromScale(number7 / frame2, number8 / frame3)
				object.size = object.base
				local value21 = callback20({DisplayOrder = 6, Enabled = false})
				object.gui = value21
				local frame4 = getFrame({p = value21, n = "Frame", A = value4, P = uDim2New(0.5, 0, 1.55, 0), S = object.size, B = value2, T = 0.4, callback4(0.008)})
				object.main = frame4
				local frame5 = getFrame({p = frame4, n = "Top", A = value7, P = value9, S = uDim2FromScale(1, 0.125), B = color3FromRGB(111, 0, 2), callback4(0.06, color3FromRGB(58, 0, 0))})
				frame2 = getFrame({p = frame5, n = "Color", A = value7, P = value9, S = uDim2FromScale(1, 0.88), B = value, getUIGradient(callback51({0, color3FromRGB(253, 86, 89)}, {1, color3FromRGB(255, 11, 15)}))})
				getFrame({p = frame2, n = "Transparent", A = value4, P = value8, S = uDim2FromScale(0.988, 0.87), B = value2, T = 0.9})
				local value22 = callback7({p = frame2, n = "Label", A = value4, x = argument.Title, W = true, X = left, Z = 6}, font2)
				local textButton = getTextButton({p = frame5, n = "Close", A = value4, O = 1, Z = 99, getUIAspectRatioConstraint()})
				frame = getFrame({p = getFrame({p = textButton, n = "Main", A = value4, P = value8, S = value10, B = color3FromRGB(126, 0, 0), callback4(0.09, color3FromRGB(76, 0, 0))}), n = "Color", A = value7, P = value9, S = uDim2FromScale(1, 0.9), B = value, getUIGradient(callback51({0, color3FromRGB(255, 130, 130)}, {1, color3FromRGB(239, 28, 28)}))})
				getFrame({p = frame, n = "Transparent", A = value4, P = value8, S = uDim2FromScale(0.96, 0.88), B = value2, T = 0.9})
				callback7({p = frame, n = "Label", A = value4, P = value8, S = uDim2FromScale(1.14, 0.98), x = "X", W = true, Z = 6}, font3)

				do
					local condition, value23
					local function getUDim2()
						local number9 = 0.06637302041053772 / number5
						return uDim2New(number9, 0, 0.6588137149810791, 0)
					end

					local function playTween(argument2, argument3)
						local uDim = getUDim2()
						if value23 then
							value23:Cancel()
						end
						value23 = tw(textButton, {Size = uDim2New(uDim.X.Scale * argument2, 0, uDim.Y.Scale * argument2, 0)}, argument3)
					end

					trackConnection(textButton.MouseEnter, function()
						condition = true
						playTween(1.04, 0.12)
					end)
					trackConnection(textButton.MouseLeave, function()
						condition = false
						playTween(1, 0.12)
					end)
					trackConnection(textButton.MouseButton1Down, function()
						playTween(0.96, 0.06)
					end)
					trackConnection(textButton.MouseButton1Up, function()
						playTween((condition and 1.04) or 1, 0.09)
					end)
				end

				callback15(textButton, function()
					object:Show(false)
				end)
				frame2 = {{"SideButtons", 1, -1}, {"SideButtonsRight", 0, 1}}
				for i, value23 in ipairs(frame2) do
					frame = getFrame({p = frame4, n = value23[1], A = vector2New(value23[2], 0.5), T = 1, Z = 99})
					object.cols[i] = {f = frame, e = value23[3], ly = number("UIListLayout", {p = frame, n = "TabLayout", H = center, Y = layoutOrder}), pd = number("UIPadding", {p = frame, n = "TabPadding"})}
				end
				local textButton2, frames, data3 = getTextButton({p = frame4, n = "ResizeGrip", A = vector2New(1, 1), Selectable = false, Z = 120, getUIAspectRatioConstraint()}), {}, {{0.5, 0.9}, {0.68, 0.54}, {0.84, 0.22}}
				for _, value23 in ipairs(data3) do
					frames[#frames + 1] = getFrame({p = textButton2, n = "GripBar", A = value4, P = uDim2FromScale(value23[1], value23[1]), S = uDim2FromScale(value23[2], 0.13), R = -45, B = value, T = 0.35, Z = 121})
				end
				local condition, value3, absoluteSize
				local function callback22(argument2)
					for _, frame6 in ipairs(frames) do
						callback9(frame6, (argument2 and 0.05) or 0.35, 0.1)
					end
				end
				trackConnection(textButton2.MouseEnter, function()
					callback22(true)
				end)
				trackConnection(textButton2.MouseLeave, function()
					if not (condition) then
						callback22(false)
					end
				end)

				callback11({textButton2}, function(argument2)
					local value23, absoluteSize2
					value23, absoluteSize2, condition = toVector2(argument2), frame4.AbsoluteSize, true
					value3, absoluteSize = value23, absoluteSize2
					callback22(true)
				end, function(argument2)
					local number9 = toVector2(argument2) - value3
					object:Resize(absoluteSize.X + (number9.X * 2), absoluteSize.Y + (number9.Y * 2))
				end, function()
					condition = false
					callback22(false)
				end)

				do
					local value, value2

					object.dragStop = callback11({frame5}, function(argument2)
						local value23 = toVector2(argument2)

						if object.open then
							if object.anim then
								return false
							elseif callback14(frame5, value23) then
								if callback14(textButton, value23) then
									return false
								end
							else
								return false
							end
						else
							return false
						end

						local absoluteSize, position, value24 = value21.AbsoluteSize, frame4.Position
						value24, value = vector2New(position.X.Scale + (position.X.Offset / absoluteSize.X), position.Y.Scale + (position.Y.Offset / absoluteSize.Y)), value23
						value2 = value24
					end, function(argument2)
						local absoluteSize, number9 = value21.AbsoluteSize, toVector2(argument2) - value
						local number10, number11 = frame4.AbsoluteSize.X / absoluteSize.X, frame4.AbsoluteSize.Y / absoluteSize.Y
						local number12, number13, number14, number15 = number10 * 0.5, 0.998 - (number10 * 0.5), number11 * 0.5, 0.98 + (number11 * 0.5)
						frame4.Position = uDim2FromScale(clamp(value2.X + (number9.X / absoluteSize.X), min(number12, number13), max(number12, number13)), clamp(value2.Y + (number9.Y / absoluteSize.Y), min(number14, number15), max(number14, number15)))
						object.rest = frame4.Position
					end)
				end

				local frame6 = getFrame({p = frame4, n = "SearchBar", A = value7, P = uDim2FromScale(0.5, 1.022), S = uDim2FromScale(1, 0.0749), B = value2, T = 0.4, Z = 6, callback4(0.05)})
				callback7({p = frame6, n = "Caption", A = value5, P = uDim2FromScale(0.02, 0.5), S = uDim2FromScale(0.13, 0.5), x = "Search", X = left, Z = 7})
				frame3 = getFrame({p = frame6, n = "Field", A = value6, P = uDim2FromScale(0.982, 0.5), S = uDim2FromScale(0.82, 0.6), B = value2, T = 0.6, Z = 7, callback4(0.1)})
				local frame7, TextBox = getFrame({p = frame3, n = "Underline", A = vector2New(0.5, 1), P = uDim2FromScale(0.5, 1), S = uDim2FromScale(0, 0.11), B = value, Z = 9}), number("TextBox", {p = frame3, n = "Input", A = value5, P = uDim2FromScale(0.025, 0.5), S = uDim2FromScale(0.9, 0.62), PH = "Filter features...", PC3 = value18, X = left, Z = 8})
				callback5(TextBox)
				local textButton3, data4 = getTextButton({p = frame3, n = "Clear", A = value6, P = uDim2FromScale(0.985, 0.5), S = uDim2FromScale(0.075, 0.74), V = false, Z = 9, getUIAspectRatioConstraint(true)}), {45, -45}
				for _, value23 in ipairs(data4) do
					getFrame({p = textButton3, n = "Arm", A = value4, P = value8, S = uDim2FromScale(0.82, 0.2), R = value23, B = color3FromRGB(255, 72, 72), Z = 10})
				end
				callback13(textButton3, 1.12, 0.9)
				callback15(textButton3, function()
					if TextBox:IsFocused() then
						TextBox:ReleaseFocus()
					end
					TextBox.Text = ""
				end)
				callback16(TextBox, frame3, frame7)

				callback3(TextBox, "Text", function()
					textButton3.Visible = TextBox.Text ~= ""
					if not (object.sbQuiet) then
						if object.Cur then
							object.Cur.q = TextBox.Text
							object:Search(TextBox.Text)
						end
					end
				end)

				object.sbox = TextBox
				local condition

				local function callback23()
					local number9, number10 = 0.0749 / number6, 0.022 / number6
					frame6.Size = uDim2FromScale(1, number9)
					local height = frame4.AbsoluteSize.Y
					local condition2 = ((frame4.AbsolutePosition.Y + height) + ((number9 + number10) * height)) <= value21.AbsoluteSize.Y
					if condition2 == condition then
						return
					end
					condition = condition2
					if condition2 then
						frame6.AnchorPoint, frame6.Position = value7, uDim2FromScale(0.5, 1 + number10)
					else
						frame6.AnchorPoint, frame6.Position = vector2New(0.5, 1), uDim2FromScale(0.5, -number10)
					end
				end

				callback3(frame4, "AbsolutePosition", callback23)
				callback3(frame4, "AbsoluteSize", callback23)

				callback19(function()
					frame5.Size = uDim2New(1, 0, 0.125 / number6, 0)
					value22.Position, value22.Size = uDim2New(0.5687711238861084 / number5, 0, 0.5, 0), uDim2New(0.8620089292526245 / number5, 0, 0.7499999403953552, 0)
					textButton.Position, textButton.Size = uDim2New(1 - (0.04500001668930054 / number5), 0, 0.4339999854564667, 0), uDim2New(0.06637302041053772 / number5, 0, 0.6588137149810791, 0)
					textButton2.Position, textButton2.Size = uDim2FromScale(1 - (0.002 / number5), 1 - (0.005 / number6)), uDim2FromScale(0.05 / number5, 0.05 / number6)
					local value, cols = ipairs, object.cols
					for _, col in value(cols) do
						col.f.Position = uDim2New(((col.e < 0) and (-0.025 / number5)) or (1 + (0.025 / number5)), 0, 0.558, 0)
						col.f.Size = uDim2New(0.2612044513 / number5, 0, 1, 0)
						col.pd.PaddingTop = uDimNew(0.067 / number6, 0)
					end
					condition = nil
					callback23()
					object:Reflow()
				end)

				value21.Parent = hui
				object:Mgr()
				return object
			end

			index.Resize = function(argument, argument2, argument3)
				local absoluteSize = argument.gui.AbsoluteSize
				if absoluteSize.X <= 0 then
					return
				elseif absoluteSize.Y <= 0 then
					return
				end
				argument.size = uDim2FromScale(clamp(argument2 / absoluteSize.X, 0.2, 0.98), clamp(argument3 / absoluteSize.Y, 0.22, 0.98))
				argument.main.Size = argument.size
				argument3, absoluteSize = max(1, argument.size.X.Scale / argument.base.X.Scale), max(1, argument.size.Y.Scale / argument.base.Y.Scale)
				if abs(argument3 - number5) < 0.0001 then
					if abs(absoluteSize - number6) < 0.0001 then
						return
					end
				end
				number5, number6 = argument3, absoluteSize
				for _, argument4 in ipairs(arguments) do
					callback12(argument4)
				end
			end

			index.Scale = function(argument, argument2)
				local absoluteSize = argument.gui.AbsoluteSize
				argument:Resize((argument.base.X.Scale * absoluteSize.X) * argument2, (argument.base.Y.Scale * absoluteSize.Y) * argument2)
			end

			index.Show = function(argument, open)
				open = if open == nil then not argument.open else open
				if argument.open == open then
					return
				end
				argument.open = open
				local main, rest, condition = argument.main, argument.rest, argument.wt ~= nil
				if argument.wt then
					argument.wt:Cancel()
				end
				argument.anim = true

				if open then
					if not (condition) then
						main.Position = uDim2New(rest.X.Scale, rest.X.Offset, rest.Y.Scale + 0.245, rest.Y.Offset)
					end
					main.Size = argument.size
					argument.wt = tw(main, {Position = rest}, 0.34, quart)
				else
					closeDropdown()
					argument.dragStop()
					main.Size = argument.size
					argument.wt = tw(main, {Position = uDim2New(rest.X.Scale, rest.X.Offset, 1.55, 0)}, 0.26, quart, scrollingFrame.EasingDirection.In)
				end

				local wt = argument.wt

				local function callback22(playbackState)
					if argument.wt == wt then
						argument.wt = nil
						if playbackState == scrollingFrame.PlaybackState.Completed then
							argument.anim = false
						end
					end
				end

				wt.Completed:Connect(callback22)
			end

			index.Reflow = function(argument)
				local value, cols = ipairs, argument.cols

				for k, col in value(cols) do
					local tabs = {}
					for _, tab in ipairs(argument.Tabs) do
						if tab.ci == k then
							tabs[#tabs + 1] = tab
						end
					end
					k = #tabs

					if k > 0 then
						local number7 = 0.1769230769230769
						local number8 = min(0.13, (0.895 * number6) / (k + ((k - 1) * number7))) / number6
						col.ly.Padding = uDimNew(number8 * number7, 0)
						for i, tab in ipairs(tabs) do
							tab.btn.LayoutOrder, tab.btn.Size = i, uDim2New(1, 0, number8, 0)
						end
					end
				end
			end

			index.Tab = function(argument, argument2, argument3, argument4)
				local argument = argument
				local object = setmetatable({W = argument, Name = argument2, Disp = argument4 or argument2, Sections = {}, q = "", ci = ((argument3 == "Right") and 2) or 1}, index2)
				object.btn, object.base = formatCompact2({p = argument.cols[object.ci].f, n = argument4 or argument2, S = uDim2New(1, 0, 0.13, 0), O = #argument.Tabs + 1, Text = argument4 or argument2})
				local ScrollingFrame = number("ScrollingFrame", {p = argument.main, n = argument2 .. "Page", a = true, A = value4, T = 1, C = true, Z = 5, CanvasSize = uDim2FromOffset(0, 0), ScrollBarImageColor3 = value, ScrollingDirection = scrollingFrame.ScrollingDirection.Y, VerticalScrollBarInset = scrollingFrame.ScrollBarInset.None, V = false})
				object.page = ScrollingFrame
				object.ly = number("UIListLayout", {p = ScrollingFrame, n = "ContentLayout", H = center, Y = layoutOrder, G = uDimNew(0, 2)})
				number("UIPadding", {p = ScrollingFrame, n = "ContentPadding", PaddingLeft = uDimNew(0.014000000432133675, 0), PaddingRight = uDimNew(0.014000000432133675, 0)})
				local number7 = -1

				object.canvas = function()
					local value20 = ceil(object.ly.AbsoluteContentSize.Y)
					local number8 = ((value20 > 0) and ceil(value20 + max(8, (ScrollingFrame.AbsoluteSize.Y * 0.06) / number6))) or 0
					if abs(number8 - number7) >= 1 then
						number7 = number8
						ScrollingFrame.CanvasSize = uDim2FromOffset(0, number8)
					end
					value20 = max(0, number8 - ScrollingFrame.AbsoluteSize.Y)
					if ScrollingFrame.CanvasPosition.Y > value20 then
						ScrollingFrame.CanvasPosition = vector2New(ScrollingFrame.CanvasPosition.X, value20)
					end
				end

				callback3(object.ly, "AbsoluteContentSize", object.canvas)
				callback3(ScrollingFrame, "AbsoluteSize", function()
					ScrollingFrame.ScrollBarThickness = max(2, floor(((ScrollingFrame.AbsoluteSize.X * 0.006) / number5) + 0.5))
					object.canvas()
				end)
				callback19(function()
					local number8, number9 = 0.1454 / number6, 1 - (0.01500005 / number6)
					ScrollingFrame.Position, ScrollingFrame.Size = uDim2New(0.5000000596046448, 0, (number8 + number9) / 2, 0), uDim2New(0.9900000095367432, 0, number9 - number8, 0)
				end)
				callback15(object.btn, function()
					argument:Select(object)
				end)
				argument.Tabs[#argument.Tabs + 1] = object
				argument:Reflow()
				if not (argument.Cur) then
					argument:Select(object)
				end
				return object
			end

			index.Select = function(argument, cur)
				if type(cur) == "string" then
					local value, tabs = ipairs, argument.Tabs
					for _, tab in value(tabs) do
						if tab.Name == cur then
							cur = tab
						end
					end
				end

				if type(cur) ~= "table" then
					return
				end
				closeDropdown()
				for _, tab in ipairs(argument.Tabs) do
					tab.page.Visible = tab == cur
					local base, data3 = tab.base, {}
					data3.BackgroundColor3 = ((tab == cur) and color3FromRGB(255, 54, 54)) or color3FromRGB(175, 0, 0)
					tw(base, data3, 0.14)
				end
				argument.Cur = cur
				argument.sbQuiet = true
				argument.sbox.Text = cur.q
				argument.sbQuiet = false
				task.defer(function()
					for _, section in ipairs(cur.Sections) do
						section:Fit()
					end
					cur.canvas()
				end)
				callback12(cur.onOpen)
			end

			local number7 = 0.97
			local function toUDim22(argument)
				return uDim2New(number7, 0, 0, argument)
			end
			local number8, number9, number10, number11, number12, number13 = 0.22, 0.09999999633202186, 0.67569, 0.3388905, 0.5388904999999999, 0.6192006943127453

			index2.Section = function(argument, argument2, argument3, argument4)
				local w, argument5 = argument.W, argument
				local object = setmetatable({W = w, t = argument, Name = argument2, Disp = argument4 or argument2, open = argument3 ~= false, rows = {}, n = 0}, widgetSpecs)
				object.f = getFrame({p = argument.page, n = argument2 .. "Section", T = 1, S = toUDim2(0), AutomaticSize = scrollingFrame.AutomaticSize.Y, O = #argument.Sections + 1, Z = 3, number("UIListLayout", {n = "SectionLayout", H = center, Y = layoutOrder, G = uDimNew(0, 2)})})
				local value20 = callback7({p = object.f, n = argument4 or argument2, A = value4, O = 1, S = uDim2New(0.97, 0, 0, 36), x = argument4 or argument2, W = true, Z = 4}, true)
				local frame = getFrame({p = value20, n = "ArrowClip", A = value4, P = uDim2FromScale(0.4, 0.5), S = uDim2FromOffset(1, 1), T = 1, C = true, Z = 6})
				local frame2, value2 = getFrame({p = frame, n = "Arrow", A = value4, P = value8, S = uDim2FromOffset(1, 1), T = 1, Z = 6}), ipairs
				argument2 = {{number8 + (number9 * 2), number10 + (number9 * 2), value14}, {number8, number10, value13}}
				for k, value21 in value2(argument2) do
					argument4, argument3 = ipairs, {{number11, 45}, {1 - number11, -45}}
					for _, value22 in argument4(argument3) do
						getFrame({p = frame2, n = "Arm", A = value4, P = uDim2FromScale(value22[1], number12), R = value22[2], S = uDim2FromScale(value21[2], value21[1]), B = value, Z = 5 + k, getUIGradient(value21[3])})
					end
				end

				local function callback22()
					local width, height = value20.AbsoluteSize.X, value20.AbsoluteSize.Y
					if width <= 0 then
						return
					elseif height <= 0 then
						return
					end
					local number14, number15 = height * 0.65, height * 0.15
					height = number14 * number13
					frame.Size = uDim2FromOffset(number14 * 1.35, number14 * 1.35)
					frame.Position = uDim2New(0, max((((width - min(value20.TextBounds.X, width)) / 2) - number15) - height, height), 0.5, 0)
					frame2.Size = uDim2FromOffset(number14, number14)
				end

				local function callback23()
					local page, y, number14 = argument5.page, frame.AbsolutePosition.Y, frame.AbsolutePosition.Y + frame.AbsoluteSize.Y
					frame.Visible = (y >= page.AbsolutePosition.Y) and (number14 <= (page.AbsolutePosition.Y + page.AbsoluteSize.Y))
				end
				callback3(value20, "TextBounds", callback22)
				callback3(value20, "AbsoluteSize", callback22)
				callback3(value20, "AbsolutePosition", callback23)
				callback3(argument5.page, "CanvasPosition", callback23)
				callback15(getTextButton({p = value20, n = "SectionButton", S = value10, Z = 8}), function()
					object:Expand(not object.open)
				end)
				object.hd = value20
				object.ar = frame2
				object.g = getFrame({p = object.f, n = "CollapsibleContent", T = 1, C = true, O = 2, S = toUDim2(0), Z = 3})
				object.b = getFrame({p = object.g, n = "Content", T = 1, S = toUDim2(0), AutomaticSize = scrollingFrame.AutomaticSize.Y, Z = 3, number("UIListLayout", {n = "OptionLayout", H = center, Y = layoutOrder})})

				callback3(object.b, "AbsoluteSize", function()
					if not (object.tw) then
						object.g.Size = uDim2New(1, 0, 0, (object.open and object.b.AbsoluteSize.Y) or 0)
					end
					if abs(object.b.AbsoluteSize.X - (object.lw or 0)) > 0.5 then
						object.lw = object.b.AbsoluteSize.X
						object:Fit()
					end
				end)

				callback19(function()
					object:Fit()
				end)
				argument.Sections[#argument.Sections + 1] = object
				object:Expand(object.open, false)
				task.defer(function()
					object:Fit()
					callback22()
					callback23()
				end)
				return object
			end

			widgetSpecs.Fit = function(argument)
				local width = argument.f.AbsoluteSize.X
				width = if width <= 0 then argument.t.page.AbsoluteSize.X else width
				if width > 0 then
					argument.hd.Size = uDim2New(0.97, 0, 0, max(1, floor((((width / number5) * 0.97) / 16) + 0.5)))
				end
				for _, row in ipairs(argument.rows) do
					if row.fit then
						row.fit()
					end
				end
			end

			widgetSpecs.Expand = function(argument, open, argument2)
				closeDropdown()
				argument.open = open
				if argument.tw then
					argument.tw:Cancel()
					argument.tw = nil
				end
				local g = argument.g
				local height = (open and argument.b.AbsoluteSize.Y) or 0
				g.ClipsDescendants = true
				if open then
					g.Visible = true
				end
				if argument2 == false then
					g.Size, g.Visible, g.ClipsDescendants, argument.ar.Rotation = toUDim2(height), open, not open, (open and 0) or -90
					return
				end
				local ar, data3 = argument.ar, {}
				data3.Rotation = (open and 0) or -90
				tw(ar, data3, 0.24)
				local value20 = tw(g, {Size = toUDim2(height)}, 0.28, quint)
				argument.tw = value20

				local function callback22()
					if argument.tw == value20 then
						argument.tw = nil
						g.Visible, g.ClipsDescendants = argument.open, not argument.open
						g.Size = uDim2New(1, 0, 0, (argument.open and argument.b.AbsoluteSize.Y) or 0)
					end
				end

				value20.Completed:Connect(callback22)
			end

			local function callback22(argument, argument2, argument3)
				argument.nt = callback8(callback7({p = argument.m, n = "Note", A = value5, P = uDim2FromScale(0.025, 0.755), S = uDim2FromScale(argument2, 0.3), x = argument3, X = left, V = argument3 ~= "", Z = 5}))
			end
			local function callback23(argument, argument2, argument3)
				argument.lb.Position, argument.lb.Size = uDim2FromScale(0.025, (argument3 and 0.34) or 0.5), uDim2FromScale(argument2, (argument3 and 0.432) or 0.64)
				argument.ratio = (argument3 and 7.5) or 10
			end

			widgetSpecs.Row = function(argument, argument2, argument3, argument4, ratio)
				argument.n = argument.n + 1
				local data3 = {name = argument2, sub = argument3}
				data3.ratio = ratio or 10
				data3.hw = (argument3 and 0.9) or 1
				local frame = getFrame({p = argument.b, n = argument2 .. "CollapsibleContent", T = 1, C = true, O = argument.n, S = uDim2New(data3.hw, 0, 0, 1), Z = 3})
				local frame2 = getFrame({p = frame, n = argument2, A = value7, P = value9, S = toUDim22(1), T = 1, Z = 3})
				argument3 = nil
				if argument4 then
					data3.head = getFrame({p = frame2, n = "Head", A = value7, P = value9, S = toUDim2(1), T = 1, Z = 3})
					argument3 = data3.head
				else
					argument3 = frame2
				end
				if not (ratio) then
					data3.m = getFrame({p = argument3, n = "Main", A = value4, P = value8, S = uDim2FromScale(1, 0.85), B = value2, T = 0.5, Z = 3, callback4(0.05)})
					data3.lb = callback7({p = data3.m, n = "Label", A = value5, P = uDim2FromScale(0.025, 0.5), S = uDim2FromScale(0.65, 0.64), x = argument2, W = true, X = left, Z = 5})
				end
				data3.h = frame
				data3.r = frame2

				data3.fit = function()
					local width = argument.b.AbsoluteSize.X
					width = if width <= 0 then argument.t.page.AbsoluteSize.X else width
					if width <= 0 then
						return
					end

					if data3.dd then
						return data3.dd()
					end

					if not (data3.ratio) then
						return
					end
					frame2.Size = uDim2New(number7, 0, 0, max(1, floor(((((width * number7) / number5) / data3.ratio) * (data3.lines or 1)) + 0.5)))
				end

				callback3(frame2, "AbsoluteSize", function()
					if data3.shown ~= false then
						if not (data3.ht) then
							frame.Size = uDim2New(data3.hw, 0, 0, frame2.AbsoluteSize.Y)
						end
					end
				end)

				data3.apply = function(argument5)
					local hide = data3.hide
					local condition = not hide
					local condition2

					if hide then
						condition2 = condition
					else
						local when = data3.when
						local condition3 = not when

						if when then
							local wf = data3.wf and data3.wf(data3.when.Value)
							local wf2
							if wf then
								wf2 = wf
							else
								local wf = data3.wf
								wf2 = if wf then not wf else data3.when.Value == true
							end
							condition2 = wf2 and (data3.when.row.shown ~= false)
						else
							condition2 = condition3
						end
					end

					if data3.q ~= nil then
						data3.qv = condition2
						frame.Visible = data3.q and condition2
						return
					end
					if data3.shown == condition2 then
						return
					end
					data3.shown = condition2
					if not (condition2) then
						if data3.close then
							data3.close()
						end
					end
					if data3.ht then
						data3.ht:Cancel()
						data3.ht = nil
					end
					hide = uDim2New(data3.hw, 0, 0, (condition2 and frame2.AbsoluteSize.Y) or 0)
					if condition2 then
						frame.Visible = true
					end

					if argument5 == false then
						frame.Size = hide
						frame.Visible = condition2
					else
						local value20 = tw(frame, {Size = hide}, 0.28, quint)
						data3.ht = value20

						local function callback24()
							if data3.ht == value20 then
								data3.ht = nil
								frame.Visible = data3.shown
								if data3.shown then
									frame.Size = uDim2New(data3.hw, 0, 0, frame2.AbsoluteSize.Y)
								end
							end
						end

						value20.Completed:Connect(callback24)
					end

					if data3.o and data3.o.kids then
						for _, kid in ipairs(data3.o.kids) do
							kid.apply(argument5)
						end
					end
				end

				argument.rows[#argument.rows + 1] = data3
				task.defer(data3.fit)
				return data3
			end

			widgetSpecs.Reg = function(section, row, o, type_)
				local w = section.W
				o.Name, o.Type, o.row, o.Tab, o.Sec = row.name, type_, row, section.t.Name, section.Name
				o.Section = section
				o.Path = section.t.Name .. (" > " .. (section.Name .. (" > " .. row.name)))
				o.ls = {}
				row.o = o
				if not (section.noReg) then
					w.Opts[#w.Opts + 1] = o
					w.ByPath[o.Path] = o
				end
				local set = o.Set

				o.Set = function(argument, argument2, argument3)
					set(argument, argument2, argument3)
					for _, value20 in ipairs(argument.ls) do
						callback12(value20, argument.Value)
					end
					if argument.kids then
						for _, kid in ipairs(argument.kids) do
							kid.apply()
						end
					end
					if not (argument.Skip) then
						if not (w.busy) then
							w:Dirty()
						end
					end
					callback12(w.qRefresh, argument)
				end

				o.Visible = function(_, argument)
					row.hide = not argument
					row.apply()
				end

				o.When = function(argument, when, wf)
					row.when = when
					row.wf = wf
					when.kids = when.kids or {}
					table.insert(when.kids, row)
					if not (row.sub) then
						row.hw = 0.96
						row.h.Size = uDim2New(0.96, 0, 0, row.h.Size.Y.Offset)
					end
					row.apply(false)
					return argument
				end

				o.Note = function(_, argument)
					if row.setNote then
						row.setNote(argument)
					elseif row.nt then
						row.nt.Text = value12(argument or "")
					end
				end

				o.Title = function(argument, argument2)
					row.lb.Text = value12(argument2)
					argument.Disp = value12(argument2)
				end
				if o.Def == nil then
					o.Def = getClonedTbl(o.Value)
				end
				row.apply(false)
				return o
			end

			widgetSpecs.Toggle = function(argument, argument2, argument3, argument4, argument5, argument6)
				local value20 = argument:Row(argument2, argument6)
				callback23(value20, (argument5 and 0.62) or 0.72, argument5 ~= nil)
				if argument5 then
					callback22(value20, 0.799, argument5)
				end
				local formattedText, value21 = formatCompact3(value20.m, 0.5, 0.915, 0.142, (argument5 and 0.5625) or 0.75, 3)
				local control = {}
				control.Value = argument3 == true

				control.Set = function(argument7, value22, argument8)
					value22 = value22 == true
					argument7 = value22 ~= control.Value
					control.Value = value22
					value21(value22)
					if argument8 then
					elseif argument7 then
						callback12(argument4, value22)
					elseif argument8 == false then
						callback12(argument4, value22)
					end
				end

				callback15(getTextButton({p = formattedText, n = "Button", A = value4, P = value8, S = value10, Z = 99}), function()
					control:Set(not control.Value)
				end)
				value21(control.Value, false)
				argument:Reg(value20, control, "toggle")
				if control.Value then
					callback12(argument4, true)
				end
				return control
			end

			local function callback24(argument)
				argument = tonumber(argument)
				if not (argument) then
					return 0
				end
				for i = 0, 6, 1 do
					local number14 = 10 ^ i
					if abs((argument * number14) - math.round(argument * number14)) < 1e-06 then
						return i
					end
				end
				return 6
			end

			widgetSpecs.Slider = function(argument, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10)
				local condition = argument7 == "log"
				local argument11
				if condition then
					argument8, argument7 = 0.01, nil
					argument3, argument4, argument11 = 0, number2, argument7
				else
					argument11 = argument7
				end
				local value20 = argument:Row(argument2, argument10)
				local value21 = max(callback24(argument8), callback24(argument3), callback24(argument4), callback24(argument5))
				local condition2 = condition or (value21 > 0)
				local condition3 = (condition2 and clamp(max(1, value21), 1, 6)) or 0

				local function roundValue(argument12)
					argument12 = tonumber(argument12) or 0
					if not (condition2) then
						return math.round(argument12)
					end
					local number14 = 10 ^ condition3
					return math.round(argument12 * number14) / number14
				end

				argument3, argument4 = roundValue(argument3), roundValue(argument4)
				local condition4 = (condition2 and max(10 ^ (-condition3), roundValue(abs(tonumber(argument8) or (10 ^ (-condition3)))))) or max(1, math.round(abs(tonumber(argument8) or 1)))
				local m, value22 = value20.m, value12(argument9 or "")
				callback22(value20, 0.48, value22)
				local TextBox = number("TextBox", {p = m, n = "Value", A = value5, P = uDim2FromScale(0.525, 0.5), S = uDim2FromScale(0.095, 0.56), B = value2, T = 0.6, Z = 5, number("UIPadding", {n = "ValuePadding"})})
				callback5(TextBox)
				callback4(0.1).Parent = TextBox
				local frame = getFrame({p = m, n = "Slider", a = true, A = value4, P = uDim2FromScale(0.8075, 0.5), S = uDim2FromScale(0.345, 0.45), B = value2, T = 0.6, Z = 3, callback4(0.1)})
				local frame2 = getFrame({p = frame, n = "Bar", a = true, A = value5, P = uDim2FromScale(0, 0.5), S = uDim2FromScale(0.5, 1), B = value, Z = 4, getUIGradient(value15, "AccentGradient")})
				local frame3, control = getFrame({p = frame, n = "Hold", a = true, A = value4, P = value8, S = uDim2FromScale(0.115, 1.2), B = color3FromRGB(89, 89, 89), T = 1, Z = 5, callback4(0.09, color3FromRGB(39, 39, 39)), getFrame({n = "Color", A = value7, P = value9, S = value10, B = value, Z = 6})}), {Value = argument3, Unit = argument11, Min = argument3, Max = argument4}
				local function roundValue2(argument12)
					if condition then
						return formatRate(argument12)
					end
					return (condition2 and string.format("%." .. (condition3 .. "f"), argument12)) or value12(math.round(argument12))
				end

				local function callback25(argument12)
					local number14, condition5 = #argument12:gsub("<.->", ""), argument11 ~= nil
					argument12 = clamp(((condition5 and 0.125) or 0.095) + (max(0, number14 - ((condition5 and 7) or 5)) * 0.0095), (condition5 and 0.125) or 0.095, (condition5 and 0.195) or 0.175)
					local number15, condition6 = 0.62 - argument12, value22 ~= ""
					number14 = (condition6 and 0.75) or 1
					TextBox.Position, TextBox.Size, frame.Size = uDim2FromScale(number15, 0.5), uDim2FromScale(argument12, 0.56 * number14), uDim2FromScale(0.345, 0.45 * number14)
					callback23(value20, min((condition5 and 0.43) or 0.45, max(0.28, number15 - 0.045)), condition6)
					value20.nt.Size = uDim2FromScale(max(0.2, number15 - 0.045), 0.3)
				end

				local function callback26()
					local value23 = clamp(((control.Max > control.Min) and ((control.Value - control.Min) / (control.Max - control.Min))) or 0, 0.0575, 0.9425)
					frame2.Size, frame3.Position = uDim2FromScale(value23, 1), uDim2FromScale(value23, 0.5)
					if TextBox:IsFocused() then
						return
					end
					local text2 = colorizeText(value, roundValue2(control.Value)) .. ((argument11 and colorizeText(value3, argument11)) or "")
					TextBox.RichText = true
					TextBox.Text = text2
					callback25(text2)
				end

				control.Set = function(argument12, value23, argument13)
					value23 = clamp(tonumber(value23) or control.Value, control.Min, control.Max)
					value23 = if value23 > control.Min then if value23 < control.Max then clamp(roundValue(control.Min + (floor(((value23 - control.Min) / condition4) + 0.5) * condition4)), control.Min, control.Max) else value23 else value23
					argument12 = value23 ~= control.Value
					control.Value = value23
					callback26()
					if argument13 then
					elseif argument12 then
						callback12(argument6, (condition and toNumberOrDefault(value23)) or value23)
					end
				end

				control.Places = function(argument12)
					return condition2, condition3
				end
				local function callback27(argument12)
					control:Set(control.Min + ((control.Max - control.Min) * clamp((argument12.Position.X - frame.AbsolutePosition.X) / max(frame.AbsoluteSize.X, 1), 0, 1)))
				end
				callback11({frame, frame2, frame3}, callback27, callback27)

				trackConnection(TextBox.Focused, function()
					callback9(TextBox, 0.42, 0.16)
					TextBox.RichText, TextBox.Text = false, (condition and formatCompact4(control.Value)) or roundValue2(control.Value)
					callback25(TextBox.Text)
					task.defer(function()
						if TextBox:IsFocused() then
							TextBox.SelectionStart, TextBox.CursorPosition = 1, #TextBox.Text + 1
						end
					end)
				end)

				callback3(TextBox, "Text", function()
					if TextBox:IsFocused() then
						callback25(TextBox.Text)
					end
				end)

				trackConnection(TextBox.FocusLost, function()
					callback9(TextBox, 0.6, 0.16)
					local condition5 = (condition and callback18(TextBox.Text)) or tonumber((TextBox.Text:gsub(",", "."):gsub("[^%d%.%-]", "")))
					if condition5 then
						control:Set(condition5)
					end
					callback26()
				end)

				control.Value = clamp(tonumber(argument5) or argument3, argument3, argument4)
				callback26()
				value20.vb = TextBox
				value20.tr = frame
				argument:Reg(value20, control, "slider")
				return control
			end

			widgetSpecs.Dropdown = function(argument, value20, argument2, argument3, argument4, argument5, argument6, argument7, argument8)
				local w = argument.W
				local value21 = argument:Row(value20, argument7, true)
				local textButton = getTextButton({p = value21.m, n = "Dropdown", A = value4, P = uDim2FromScale(0.845, 0.5), S = uDim2FromScale(0.28, 0.62), B = value2, T = 0.6, Z = 6, callback4(0.1)})
				callback13(textButton, 1.025, 0.975)
				local value22 = value12(argument6 or "")
				callback22(value21, 0.66, value22)
				callback23(value21, 0.65, value22 ~= "")
				if value22 ~= "" then
					textButton.Size = uDim2FromScale(0.28, 0.465)
				end
				local value23 = callback7({p = textButton, n = "Value", A = value4, P = uDim2FromScale(0.405, 0.5), S = uDim2FromScale(0.7, 0.58), W = true, Z = 7})
				getFrame({p = textButton, n = "Divider", A = value4, P = uDim2FromScale(0.8, 0.5), S = uDim2FromScale(0.014, 0.66), B = value2, T = 0.3, Z = 7})
				local formattedText = formatCompact(textButton, value3, uDim2FromScale(0.888, 0.5), uDim2FromScale(0.16, 0.56), 7)
				local frame, control, condition, data3, text2, frame2, value24, value25, formattedText2, value26, data4 = getFrame({p = value21.r, n = "Menu", A = value7, P = uDim2New(0.5, 0, 0, 0), S = toUDim2(0), T = 1, C = true, V = false, Z = 6}), {Multi = argument5, Options = argument2, Empty = "None"}, false, {}, ""
				local number14, number15, number16, number17 = 0, 0, 0, 0

				local function callback25()
					local iMap = {}
					for i, value27 in ipairs(((type(control.Options) == "function") and control.Options()) or control.Options) do
						iMap[i] = value12(value27)
					end
					return iMap
				end

				local function callback26(argument9)
					if argument5 then
						return table.find(control.Value, argument9) ~= nil
					end
					return control.Value == argument9
				end
				local function getArgument()
					return (argument5 and #control.Value) or (((control.Value ~= nil) and 1) or 0)
				end

				local function callback27(textTransparency)
					if argument5 then
						local number18 = #control.Value
						value23.Text = (((number18 == 0) and control.Empty) or ((number18 == 1) and value12(control.Value[1]))) or (number18 .. " selected")
					else
						value23.Text = value12(control.Value or "")
					end
					local data = data3
					for _, value27 in next, data, nil do
						value27.paint(textTransparency)
					end

					if formattedText2 then
						data = getArgument()
						value26.Text = ((argument5 and (data > 0)) and (argument8[2] .. (" (" .. (data .. ")")))) or argument8[2]
						textTransparency = ((data > 0) and 0) or 0.45
						value26.TextTransparency = textTransparency
						value26:FindFirstChildOfClass("UIStroke").Transparency = textTransparency
						for _, value27 in ipairs(data4) do
							value27.BackgroundTransparency = textTransparency
						end
					end
				end

				local function callback28()
					local ks, value, value27 = {}, ipairs, table.pack(callback25())

					for k, value28 in value(table.unpack(value27, 1, value27.n)) do
						k = data3[value28]
						if k then
							k.b.Visible = (text2 == "") or (value28:lower():find(text2, 1, true) ~= nil)
							if k.b.Visible then
								ks[#ks + 1] = k
							end
						end
					end

					if control.empty then
						control.empty.Visible = #ks == 0
					end
					return ks
				end

				local function callback29(argument9)
					local number = number14
					local value27, size, condition2, visible = uDim2New(1, 0, 0, number + ((condition and (number16 + number15)) or 0)), number17 * 2, condition
					if condition2 then
						number = number15
						visible = number + (number17 * 2)
					else
						visible = condition2
					end
					number = uDim2New(1, size, 0, visible or 0)
					if value21.rt then
						value21.rt:Cancel()
						value21.mt:Cancel()
					end
					if condition then
						frame.Visible = true
					end

					if argument9 then
						value21.rt, value21.mt = tw(value21.r, {Size = toUDim22(value27.Y.Offset)}, 0.26, quint), tw(frame, {Size = number}, 0.26, quint)

						if not (condition) then
							value21.mt.Completed:Connect(function(playbackState)
								if playbackState == scrollingFrame.PlaybackState.Completed then
									if not (condition) then
										frame.Visible = false
									end
								end
							end)
						end
					else
						condition2, size, visible = value21.r, toUDim22(value27.Y.Offset), condition
						condition2.Size = size
						frame.Size = number
						frame.Visible = visible
					end
				end

				local function callback30(argument9)
					local width = value21.r.AbsoluteSize.X
					if width <= 0 then
						return
					end
					local number18 = width / number5
					local number19 = number18 / 10
					number14 = ((value22 ~= "") and (number18 / 7.5)) or number19
					number18 = number19 * 0.62
					local number20, number21 = number18 * 0.12, number19 * 0.15
					number17, number16 = number20, number21
					value21.head.Size = toUDim2(number14)
					number19 = number14
					frame.Position = uDim2New(0.5, 0, 0, ((number19 - (number14 * 0.075)) + number16) - number17)
					if condition then
					elseif argument9 then
					else
						return callback29(false)
					end
				end

				value21.dd = function()
					callback30(false)
				end
				local number18 = 0

				callback3(value21.r, "AbsoluteSize", function()
					local width = value21.r.AbsoluteSize.X
					if abs(width - number18) >= 0.5 then
						number18 = width
						callback30(false)
					end
				end)

				local function callback31()
					local data = data3
					for _, value27 in next, data, nil do
						value27.b:Destroy()
					end
					data3 = {}
					data = callback25()

					if #data >= 5 then
						if not (frame2) then
							frame2 = getFrame({p = frame, n = "Search", B = value2, T = 0.6, Z = 7, callback4(0.07)})
							value24 = callback5(number("TextBox", {p = frame2, n = "Input", A = value4, P = value8, S = uDim2FromScale(0.94, 0.56), PH = "Search...", PC3 = value18, Z = 9}))
							callback3(value24, "Text", function()
								text2 = (value24.Text:match("^%s*(.-)%s*$") or ""):lower()
								callback30(true)
							end)
						end
					end

					if not (control.empty) then
						control.empty = callback7({p = frame, n = "Empty", x = "No match", t = 0.4, V = false, Z = 9})
					end

					for i, value27 in ipairs(data) do
						local textButton2 = getTextButton({p = frame, n = "Option" .. i, O = i, B = value2, T = 0.45, Z = 7, callback4(0.07)})
						local data5, condition2, frame3, frame4 = {b = textButton2, aw = 0}, false
						if argument5 then
							frame4 = getFrame({p = getFrame({p = textButton2, n = "Tick", A = value5, P = uDim2FromScale(0.055, 0.5), S = uDim2FromScale(0.16, 0.44), B = value2, T = 0.3, Z = 8, callback4(0.12), getUIAspectRatioConstraint(1, true)}), n = "Fill", A = value4, P = value8, S = uDim2FromScale(0, 0), B = value, Z = 9, getUIGradient(value15, "AccentGradient")})
						else
							frame3 = getFrame({p = textButton2, n = "Accent", A = value5, P = uDim2FromScale(0, 0.5), S = uDim2FromScale(0, 1), B = value, Z = 8, getUIGradient(value15, "AccentGradient")})
						end
						local value28 = callback7({p = textButton2, n = "Label", A = value4, P = uDim2FromScale((argument5 and 0.56) or 0.5, 0.5), S = uDim2FromScale((argument5 and 0.62) or 0.78, 0.56), x = value27, W = true, Z = 9})

						data5.paint = function(argument9)
							local value29 = callback26(value27)
							local number19, condition3 = (value29 and 0.85) or 0, (value29 and 0.2) or ((condition2 and 0.3) or 0.45)
							local frame5 = (frame4 and uDim2FromScale(number19, number19)) or uDim2New(0, (value29 and data5.aw) or 0, 1, 0)
							if argument9 then
								callback9(textButton2, condition3, 0.12)
								tw(frame3 or frame4, {Size = frame5}, 0.12)
							else
								textButton2.BackgroundTransparency, (frame3 or frame4).Size = condition3, frame5
							end
							value28.TextTransparency = (value29 and 0) or 0.15
						end

						trackConnection(textButton2.MouseEnter, function()
							condition2 = true
							data5.paint(true)
						end)
						trackConnection(textButton2.MouseLeave, function()
							condition2 = false
							data5.paint(true)
						end)

						callback15(textButton2, function()
							if argument5 then
								local clonedTbl = table.clone(control.Value)
								local pos = table.find(clonedTbl, value27)
								if pos then
									table.remove(clonedTbl, pos)
								else
									clonedTbl[#clonedTbl + 1] = value27
								end
								if argument8 then
									control.Value = clonedTbl
									callback27(true)
								else
									control:Set(clonedTbl)
								end
							elseif argument8 then
								control.Value = value27
								callback27(true)
							else
								control:Set(value27)
								w.closeDD()
							end
						end)

						data3[value27] = data5
					end
				end

				if argument8 then
					value25 = callback7({p = frame, n = "Hint", x = argument8[1], W = true, t = 0.28, Z = 9})
					argument2, value20, argument7 = nil
					formattedText2, argument2, value26, value20, argument7 = formatCompact2({p = frame, n = "Apply", S = uDim2FromOffset(0, 0), Z = 9, full = true, Text = argument8[2], LSize = uDim2FromScale(0.88, 0.56), wrap = true, h = 1.03})
					data4 = {value20, argument7}

					callback15(formattedText2, function()
						if getArgument() == 0 then
							if argument5 then
								return
							end
						end
						w.closeDD()
						callback12(argument4, control.Value)
					end)
				end

				local function callback32(argument9)
					if condition == argument9 then
						return
					end

					if argument9 then
						closeDropdown()
						callback31()
						text2 = ""
						if value24 then
							value24.Text = ""
						end
						function w.closeDD()
							callback32(false)
						end
					else
						if value24 then
							value24:ReleaseFocus()
						end
						w.closeDD = nil
					end

					condition = argument9
					tw(formattedText, {Rotation = (argument9 and 180) or 0}, 0.22)
					callback9(textButton, (argument9 and 0.42) or 0.6, 0.16)
					callback30(true)
				end

				value21.close = function()
					callback32(false)
				end
				callback15(textButton, function()
					callback32(not condition)
				end)

				control.Set = function(argument, argument9, argument10)
					argument = control.Value

					if argument5 then
						local ks, data5 = {}, {}
						for _, value27 in ipairs(callback25()) do
							data5[value27] = true
						end

						for k, value27 in next, (((type(argument9) == "table") and argument9) or ((argument9 ~= nil) and {argument9})) or {}, nil do
							local k2 = (((type(k) == "string") and (value27 == true)) and k) or value12(value27)
							if data5[k2] or (type(control.Options) == "function") then
								if not (table.find(ks, k2)) then
									ks[#ks + 1] = k2
								end
							end
						end

						control.Value = ks
					else
						local value27, condition2 = callback25(), ((argument9 ~= nil) and value12(argument9)) or nil
						control.Value = ((((condition2 and (table.find(value27, condition2) or (type(control.Options) == "function"))) and condition2) or control.Value) or control.Def) or value27[1]
					end

					callback27(false)
					if (if argument10 then not argument10 else not argument8) and ((argument5 and (enc(argument) ~= enc(control.Value))) or (if argument5 then not argument5 else argument ~= control.Value)) then
						callback12(argument4, control.Value)
					end
				end

				control.Refresh = function(_, options)
					control.Options = options
					if condition then
						callback31()
						callback30(false)
					end
				end

				if argument5 then
					value20 = {}
					for _, value27 in ipairs(((type(argument3) == "table") and argument3) or {}) do
						value20[#value20 + 1] = value12(value27)
					end
					control.Value = value20
				else
					control.Value = ((argument3 ~= nil) and value12(argument3)) or callback25()[1]
				end

				callback27(false)
				argument:Reg(value21, control, (argument5 and "multidropdown") or "dropdown")
				return control
			end

			widgetSpecs.Input = function(argument, argument2, argument3, argument4, argument5, fd)
				local value20 = argument:Row(argument2, fd)
				fd = getFrame({p = value20.m, n = "Field", A = value4, P = uDim2FromScale(0.845, 0.5), S = uDim2FromScale(0.28, 0.62), B = value2, T = 0.6, Z = 4, callback4(0.1)})
				local frame, value21 = getFrame({p = fd, n = "Underline", A = vector2New(0.5, 1), P = uDim2FromScale(0.5, 1), S = uDim2FromScale(0, 0.11), B = value, Z = 6}), callback5(number("TextBox", {p = fd, n = "Input", A = value4, P = value8, S = uDim2FromScale(0.9, 0.56), PH = argument3 or "Type...", PC3 = value18, Z = 5}))
				argument3 = value12(argument5 or "")
				callback22(value20, 0.66, argument3)
				callback23(value20, 0.65, argument3 ~= "")
				if argument3 ~= "" then
					fd.Size = uDim2FromScale(0.28, 0.465)
				end
				local control = {Value = ""}

				control.Set = function(argument6, value22, argument7)
					value22 = value12(value22 or ""):match("^%s*(.-)%s*$")
					argument6 = value22 ~= control.Value
					control.Value = value22
					value21.Text = value22
					if argument7 then
					elseif argument6 then
						callback12(argument4, value22)
					end
				end

				callback16(value21, fd, frame, function()
					control:Set(value21.Text)
				end)
				value20.fd = fd
				argument:Reg(value20, control, "input")
				return control
			end

			widgetSpecs.Button = function(argument, argument2, argument3, argument4, argument5, argument6, argument7)
				local value20, argument8 = argument:Row(argument2, argument7), argument3 or "Click"
				local argument9 = argument6 or "Clicked!"
				local formattedText, value21, value22 = formatCompact2({p = value20.m, n = "Action", P = uDim2FromScale(0.8846889218690012, 0.5), S = uDim2FromScale(0.20062215626239777, (argument5 and 0.51) or 0.68), Z = 6, Text = argument8, LSize = uDim2FromScale(0.9, 0.62), wrap = true})
				if argument5 then
					callback23(value20, 0.62, true)
					callback22(value20, 0.7393778, argument5)
				end
				local data3, condition = {Skip = true}, false
				data3.Set = function(argument10)
				end

				data3.Press = function(argument10)
					local uiScale = formattedText:FindFirstChildOfClass("UIScale")
					tw(uiScale, {Scale = 0.96}, 0.055)
					task.delay(0.07, function()
						if uiScale.Parent then
							tw(uiScale, {Scale = 1}, 0.09)
						end
					end)

					if not (condition) then
						if argument9 ~= "" then
							condition = true
							value22.Text = argument9
							task.delay(0.9, function()
								value22.Text = argument8
								condition = false
							end)
						end
					end

					callback12(argument4)
				end

				callback15(formattedText, function()
					data3:Press()
				end)
				argument:Reg(value20, data3, "button")
				return data3
			end

			widgetSpecs.Text = function(argument, argument2, value20, argument3)
				local value21 = argument:Row(argument2, argument3)
				value21.lb.Size = uDim2FromScale(0.94, 0.64)
				callback22(value21, 0.94, "")
				value21.setNote = function(text2)
					local visible = text2 ~= ""
					value21.nt.Text, value21.nt.Visible = text2, visible
					callback23(value21, 0.94, visible)
					value21.fit()
				end
				local control = {}
				control.Value = value20 or argument2
				control.Skip = true

				control.Set = function(lines, value22)
					value22 = value12(value22 or "")
					if value22 == control.Value then
						if value21.lb.Text == value22 then
							return
						end
					end
					control.Value, value21.lb.Text = value22, value22
					lines = select(2, value22:gsub("\n", "")) + 1
					if lines ~= (value21.lines or 1) then
						value21.lines = lines
						value21.lb.Size = uDim2FromScale(0.94, ((lines > 1) and 0.9) or 0.64)
						value21.fit()
					end
				end

				control:Set(control.Value)
				argument:Reg(value21, control, "text")
				return control
			end

			local widgetSpecs2 = {Toggle = {3, 5}, Slider = {5, 9}, Dropdown = {4, 7}, Input = {3, 5}, Button = {3, 6}, Text = {nil, 3}}

			for k in next, widgetSpecs2, nil do
				local widgetSpec = widgetSpecs[k]
				widgetSpecs[k] = function(argument, ...)
					local value20 = widgetSpec(argument, ...)
					value20.mk, value20.args = k, table.pack(...)
					return value20
				end
			end

			widgetSpecs.Label = function(argument, argument2, argument3, argument4)
				local value20 = argument:Text(argument2, argument3 or argument2, argument4)
				value20.Type = "label"
				return value20
			end
			userInputType, text = setmetatable, {__mode = "k"}
			local value20 = userInputType({}, text)

			local function callback25(argument, argument2)
				if not (argument) then
					return
				end
				local data3 = value20[argument]
				if data3 then
					if argument.Text ~= data3.p then
						value20[argument] = nil
						data3 = nil
					end
				end

				if not (data3) then
					if argument2 == "" then
						return
					elseif argument.RichText then
						return
					end
					data3 = {t = argument.Text}
					value20[argument] = data3
				end

				local pos, value21
				if argument2 ~= "" then
					pos, value21 = data3.t:lower():find(argument2, 1, true)
				end
				if not (pos) then
					argument.RichText, argument.Text = false, data3.t
					value20[argument] = nil
					return
				end
				local function callback26(argument3)
					return (argument3:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
				end
				argument.RichText = true
				argument.Text = callback26(data3.t:sub(1, pos - 1)) .. ("<font color=\"rgb(58,255,55)\">" .. (callback26(data3.t:sub(pos, value21)) .. ("</font>" .. callback26(data3.t:sub(value21 + 1)))))
				data3.p = argument.Text
			end

			local function callback26(argument)
				local value21 = value12(argument.Disp or argument.Name)
				if value21:lower():sub(-4) == " tab" then
					return value21
				elseif value21:lower() == "tab" then
					return value21
				end
				return value21 .. " Tab"
			end

			index.Search = function(argument, argument2)
				local cur = argument.Cur
				if not (cur) then
					return
				end
				local text2 = argument2:match("^%s*(.-)%s*$"):lower()

				for i, section in ipairs(cur.Sections) do
					if not (section.res) then
						argument2 = (text2 == "") or (section.Disp:lower():find(text2, 1, true) ~= nil)
						i = if section.extra then (section.extra(text2) == true) or argument2 else argument2
						callback25(section.hd, text2)

						for i2, row in ipairs(section.rows) do
							i2 = row.o

							if i2 or row.canvas then
								local argument3 = ((text2 == "") or argument2) or (value12((i2 and (i2.Disp or i2.Name)) or row.name):lower():find(text2, 1, true) ~= nil)

								if text2 == "" then
									if row.q ~= nil then
										row.q = nil
										row.shown = nil
										row.apply(false)
									end
								else
									if row.q == nil then
										row.qv = row.shown ~= false
									end
									row.q = argument3
									row.h.Visible = argument3 and row.qv
								end

								if row.lb then
									callback25(row.lb, text2)
								end
								i = if argument3 then true else i
							end
						end

						if text2 == "" then
							section.f.Visible = true
							if section.pre ~= nil then
								section:Expand(section.pre, false)
								section.pre = nil
							end
						else
							if section.pre == nil then
								section.pre = section.open
							end
							section.f.Visible = i
							if i then
								if not (section.open) then
									section:Expand(true, false)
								end
							end
						end
					end
				end

				argument:Cross(cur, text2)
				task.defer(cur.canvas)
			end

			index.Cross = function(argument, argument2, argument3)
				local res = argument2.res
				if argument3 == "" then
					if res then
						res.f.Visible = false
					end
					return
				end
				local list, number14 = {}, 0

				for i, tab in ipairs(argument.Tabs) do
					if tab ~= argument2 then
						if tab.btn.Visible then
							i = number14

							for _, section in ipairs(tab.Sections) do
								if not (section.res) then
									local os_, condition = {}, section.Disp:lower():find(argument3, 1, true) ~= nil

									for i2, row in ipairs(section.rows) do
										i2 = row.o

										if i2 then
											if i2.mk then
												if i < 30 then
													if condition then
														os_[#os_ + 1] = i2
														i += 1
													else
														if value12(i2.Disp or i2.Name):lower():find(argument3, 1, true) then
															os_[#os_ + 1] = i2
															i += 1
														end
													end
												end
											end
										end
									end

									if #os_ > 0 then
										list[#list + 1] = {t = tab, s = section, l = os_}
									end
								end
							end

							number14 = i
						end
					end
				end

				if number14 == 0 then
					if res then
						res.f.Visible = false
					end
					return
				end

				if not (res) then
					res = argument2:Section("__ChilliSearchResults", true, "Other Tabs")
					res.res = true
					res.noReg = true
					res.hdr = {}
					res.mir = {}
					res.f.LayoutOrder = 1000000
					argument2.res = res
				end

				local iMap, pathMap, layoutOrder2 = {}, {}, 0

				for i, value21 in ipairs(list) do
					i = value21.t.Name .. ("\000" .. value21.s.Name)
					local headerEntry = res.hdr[i]

					if not headerEntry then
						argument3 = res:Row("ResultGroup", nil, nil, 22)
						local r = argument3.r
						r.BackgroundColor3 = value2
						r.BackgroundTransparency = 0.58
						local value22 = callback4(0.045, value3, false, 0.62)
						value22.Parent = r
						argument2 = callback7({p = r, n = "Label", A = value5, P = uDim2FromScale(0.025, 0.5), S = uDim2FromScale(0.73, 0.8), TextTruncate = scrollingFrame.TextTruncate.AtEnd, X = left, Z = 5})
						argument2.TextColor3 = value3
						getFrame({p = r, n = "Line", A = value6, P = uDim2FromScale(0.79, 0.5), S = uDim2FromScale(0.055, 0.08), B = value, T = 0.75, Z = 4})
						callback7({p = r, n = "OpenHint", A = value6, P = uDim2FromScale(0.975, 0.5), S = uDim2FromScale(0.16, 0.72), x = "OPEN  >", X = right, Z = 5}).TextColor3 = value3
						local textButton = getTextButton({p = r, n = "OpenTab", S = value10, Z = 6})
						trackConnection(textButton.MouseEnter, function()
							callback9(r, 0.38, 0.12)
							tw(value22, {Transparency = 0.22}, 0.12)
						end)
						trackConnection(textButton.MouseLeave, function()
							callback9(r, 0.58, 0.12)
							tw(value22, {Transparency = 0.62}, 0.12)
						end)
						headerEntry = {x = argument3, lb = argument2}
						callback15(textButton, function()
							if headerEntry.go then
								argument:Goto(headerEntry.go)
							end
						end)
						res.hdr[i] = headerEntry
					end

					layoutOrder2 += 1
					headerEntry.x.h.LayoutOrder, headerEntry.x.h.Visible, headerEntry.go = layoutOrder2, true, value21.l[1]
					headerEntry.lb.Text = "GO TO  " .. (callback26(value21.t) .. ("  >  " .. value21.s.Disp))
					iMap[i] = true
					local value, l = ipairs, value21.l

					for _, value22 in value(l) do
						local value23 = res.mir[value22.Path]

						if not value23 then
							local clonedTbl, widgetSpec, condition = table.clone(value22.args), widgetSpecs2[value22.mk], false
							if widgetSpec[1] then
								clonedTbl[widgetSpec[1]] = ((value22.Type == "button") and (function()
									value22:Press()
								end)) or nil
							end
							clonedTbl[widgetSpec[2]] = nil
							clonedTbl[1] = value22.Disp or value22.Name
							i, value21 = pcall(res[value22.mk], res, table.unpack(clonedTbl, 1, max(clonedTbl.n, widgetSpec[2])))

							if i and value21 then
								value23 = value21
								value23.mirrorOf = value22
								value23.Skip = true

								if (value22.Type ~= "button") and (value22.Type ~= "text") then
									value23.ls[#value23.ls + 1] = function(argument4)
										if not (condition) then
											value22:Set(getClonedTbl(argument4))
										end
									end

									value22.ls[#value22.ls + 1] = function(argument4)
										if value23.row.h.Parent then
											condition = true
											value23:Set(getClonedTbl(argument4), true)
											condition = false
										end
									end

									condition = true
									value23:Set(getClonedTbl(value22.Value), true)
									condition = false
								else
									if value22.Type == "text" then
										value22.ls[#value22.ls + 1] = function(argument4)
											value23:Set(argument4)
										end
									end
								end

								res.mir[value22.Path] = value23
							end
						end

						if value23 then
							layoutOrder2 += 1
							value23.row.h.LayoutOrder = layoutOrder2
							value23.row.h.Visible = true
							pathMap[value22.Path] = true
						end
					end
				end

				for k, value21 in next, res.hdr, nil do
					if not (iMap[k]) then
						value21.x.h.Visible = false
					end
				end
				for k, value21 in next, res.mir, nil do
					if not (pathMap[k]) then
						value21.row.h.Visible = false
					end
				end
				res.f.Visible = true
				if not (res.open) then
					res:Expand(true, false)
				end
				callback12(argument.qChips)
			end

			index.Goto = function(argument, argument2)
				local section = argument2.Section
				local t = argument2.Section.t
				argument.nav = (argument.nav or 0) + 1
				local nav = argument.nav
				argument:Select(t)
				if not (section.open) then
					section:Expand(true)
				end

				task.spawn(function()
					if section.tw then
						pcall(function()
							section.tw.Completed:Wait()
						end)
					else
						RunService.Heartbeat:Wait()
					end

					RunService.Heartbeat:Wait()
					if nav ~= argument.nav then
						return
					elseif argument.Cur ~= t then
						return
					end
					t.canvas()
					RunService.Heartbeat:Wait()
					local page, h = t.page, argument2.row.h
					h = if h.Visible then h else section.hd
					local canvasPosition = page.CanvasPosition
					local value21 = clamp(((h.AbsolutePosition.Y - page.AbsolutePosition.Y) + canvasPosition.Y) - (page.AbsoluteSize.Y * 0.28), 0, max(0, page.AbsoluteCanvasSize.Y - page.AbsoluteSize.Y))
					local value22 = tw(page, {CanvasPosition = vector2New(canvasPosition.X, value21)}, 0.46, quint)
					pcall(function()
						value22.Completed:Wait()
					end)

					if nav ~= argument.nav then
						return
					elseif h.Parent then
						if not (h.Visible) then
							return
						end
					else
						return
					end

					page = h:FindFirstChild("ChilliSearchNavigationHighlight")
					if page then
						page:Destroy()
					end
					local value23 = callback4(0.065, value3, false, 1)
					value23.Name = "ChilliSearchNavigationHighlight"
					value23.Parent = h
					tw(value23, {Transparency = 0.04}, 0.16)

					task.delay(0.5, function()
						if value23.Parent then
							local value24, destroyAll = tw(value23, {Transparency = 1}, 0.28), function()
								value23:Destroy()
							end
							value24.Completed:Connect(destroyAll)
						end
					end)
				end)
			end

			local condition = true
			local frame
			local list, number14 = {}, 0

			local function callback27(argument, argument2)
				if argument.d then
					return
				end
				argument.d = true
				local pos = table.find(list, argument)
				if pos then
					table.remove(list, pos)
				end
				if argument.t then
					pcall(task.cancel, argument.t)
				end
				if argument2 then
					argument.slot:Destroy()
					return
				end
				tw(argument.card, {Position = uDim2FromScale(2.1, 0.5)}, 0.22, quint, scrollingFrame.EasingDirection.In)
				task.delay(0.08, function()
					if argument.slot.Parent then
						tw(argument.slot, {Size = uDim2FromScale(1, 0)}, 0.22, quint, scrollingFrame.EasingDirection.In)
					end
				end)
				task.delay(0.32, function()
					argument.slot:Destroy()
				end)
			end

			local function callback28(argument, argument2, argument3)
				if condition then
					if object2 then
						if object2.gui then
							if not (object2.gui.Parent) then
								return
							end
						else
							return
						end
					else
						return
					end
				else
					return
				end

				if not (frame and frame.Parent) then
					frame = getFrame({p = object2.gui, n = "ChilliNotifyHolder", A = vector2New(1, 1), P = uDim2FromScale(0.988, 0.975), S = uDim2FromScale(0.163, 0.74), T = 1, Z = 100, number("UIListLayout", {n = "Layout", H = scrollingFrame.HorizontalAlignment.Right, VerticalAlignment = scrollingFrame.VerticalAlignment.Bottom, Y = layoutOrder, G = uDimNew(0.015, 0)})})
				end
				while #list >= 6 do
					callback27(list[1], true)
				end
				number14 += 1
				argument3 = max(0, tonumber(argument3) or 3)
				local frame2 = getFrame({p = frame, n = "NotificationSlot", O = number14, S = uDim2FromScale(1, 0), T = 1, Z = 100})
				local frame3 = getFrame({p = frame2, n = "ChilliNotify", A = value6, P = uDim2FromScale(2.1, 0.5), S = value10, B = value2, T = 0.35, C = true, Z = 101, callback4(0.045), getFrame({n = "Accent", S = uDim2FromScale(0.026, 1), B = value, Z = 102, getUIGradient(value16, "RedGradient")})})
				callback7({p = frame3, n = "Title", P = uDim2FromScale(0.07, 0.14), S = uDim2FromScale(0.88, 0.28), x = value12(argument or "Notification"), X = left, Z = 103}, true)
				callback7({p = frame3, n = "Body", P = uDim2FromScale(0.07, 0.48), S = uDim2FromScale(0.86, 0.3), x = value12(argument2 or ""), W = true, X = left, y = scrollingFrame.TextYAlignment.Top, t = 0.28, Z = 103})
				local frame4, data3 = getFrame({p = getFrame({p = frame3, n = "Track", A = vector2New(0.5, 1), P = uDim2FromScale(0.5, 1), S = uDim2FromScale(1, 0.055), B = value2, T = 0.45, V = argument3 > 0, Z = 102}), n = "Fill", A = value5, P = uDim2FromScale(0, 0.5), S = value10, B = color3FromRGB(239, 28, 28), Z = 103}), {slot = frame2, card = frame3}
				list[#list + 1] = data3
				tw(frame2, {Size = uDim2FromScale(1, 0.115)}, 0.3, quint)
				tw(frame3, {Position = uDim2FromScale(1, 0.5)}, 0.3, quint)

				if argument3 > 0 then
					tw(frame4, {Size = uDim2FromScale(0, 1)}, argument3, scrollingFrame.EasingStyle.Linear)
					data3.t = task.delay(argument3, function()
						data3.t = nil
						callback27(data3)
					end)
				end
			end

			data.Notify = function(argument, argument2, argument3)
				data.q(function()
					callback28(argument, argument2, argument3)
				end)
			end

			local function callback29(argument)
				condition = argument
				if not (argument) then
					for i = #list, 1, -1 do
						callback27(list[i], true)
					end
				end
			end

			index.State = function(argument, argument2, argument3)
				local value21 = argument.St[argument2]
				if value21 then
					return value21
				end
				local control, argument3 = {Name = argument2, Value = argument3, Def = argument3, ls = {}}, argument

				control.Set = function(_, value22)
					control.Value = value22
					argument3:Dirty()
					for _, value23 in ipairs(control.ls) do
						callback12(value23, value22)
					end
				end

				control.Get = function(argument4)
					return control.Value
				end
				argument.St[argument2] = control
				return control
			end

			local text2 = "Default"
			local function callback30(argument, argument2)
				return argument.dirP .. ("/configs/" .. (argument2 .. ".json"))
			end

			index.Collect = function(argument)
				local tabMap, kMap = {}, {}

				for i, opt in ipairs(argument.Opts) do
					i = opt.NoSave
					local condition2 = not i
					local condition

					if i then
						condition = condition2
					else
						local condition3 = (opt.Type == "text") or (opt.Type == "label")
						if condition3 then
							condition = condition3
						else
							local skip = opt.Skip
							condition = if skip then not skip else opt.Type ~= "button"
						end
					end

					if condition then
						tabMap[opt.Tab] = tabMap[opt.Tab] or {}
						tabMap[opt.Tab][opt.Sec] = tabMap[opt.Tab][opt.Sec] or {}
						tabMap[opt.Tab][opt.Sec][opt.Name] = {Type = opt.Type, Value = opt.Value, Unit = opt.Unit}
					end
				end

				for k, value21 in next, argument.St, nil do
					kMap[k] = {Value = value21.Value}
				end
				return {Version = 2, Profile = argument.Active, SavedAt = os.time(), States = kMap, Values = tabMap}
			end

			index.Save = function(argument, argument2, argument3)
				if argument.ready then
				elseif argument3 then
				else
					return false
				end
			end

			index.Dirty = function(argument)
				if argument.AutoSave then
					if argument.busy then
						return
					elseif not (argument.ready) then
						return
					end
				else
					return
				end

				argument.saveN = (argument.saveN or 0) + 1
				local saveN = argument.saveN

				task.delay(0.35, function()
					if argument.saveN == saveN then
						if argument.AutoSave then
							argument:Save()
						end
					end
				end)
			end

			local function callback31(argument, argument2, argument3)
				for k, value21 in next, argument, nil do
					k = (type(value21) == "table") and value21[argument2]
					if type(k) == "table" then
						if k[argument3] ~= nil then
							return k[argument3]
						end
					end
				end
			end

			index.Apply = function(argument, argument2)
				if type(argument2) ~= "table" then
					return false
				end
				argument.busy = true
				local values = ((type(argument2.Values) == "table") and argument2.Values) or {}
				if argument.pre then
					callback12(argument.pre, values)
				end

				for i, opt in ipairs(argument.Opts) do
					if not (opt.Skip) then
						if opt.Type ~= "button" then
							if opt.Type ~= "text" then
								i = ((values[opt.Tab] and values[opt.Tab][opt.Sec]) and values[opt.Tab][opt.Sec][opt.Name]) or callback31(values, opt.Sec, opt.Name)
								local value21 = if type(i) == "table" then i.Value else nil
								value21 = if value21 == nil then getClonedTbl(opt.Def) else value21
								if value21 ~= nil then
									pcall(opt.Set, opt, value21)
								end
							end
						end
					end
				end

				for k, value21 in next, ((type(argument2.States) == "table") and argument2.States) or {}, nil do
					values = argument.St[k]

					if (values and (type(value21) == "table")) and (value21.Value ~= nil) then
						values.Value = value21.Value
						for _, value22 in ipairs(values.ls) do
							callback12(value22, value21.Value)
						end
					elseif type(value21) == "table" then
						argument:State(k, value21.Value)
					end
				end

				argument.busy = false
				return true
			end

			index.Find = function(argument, argument2)
				for _, value21 in ipairs(argument:List()) do
					if value21:lower() == value12(argument2):lower() then
						return value21
					end
				end
			end

			index.Load = function(argument, argument2)
				local value21 = argument:Find(argument2)
				if not (value21) then
					return false, "Config does not exist: " .. value12(argument2)
				end
				local function callback32(argument3)
					return (type(argument3) == "table") and ((type(argument3.Values) == "table") or (type(argument3.States) == "table"))
				end
				argument2 = dec(readCachedFile(callback30(argument, value21)))
				if not (callback32(argument2)) then
					argument2 = dec(readCachedFile(callback30(argument, value21) .. ".bak"))
					if callback32(argument2) then
						saveFile(callback30(argument, value21), enc(argument2) or "")
					end
				end
				if not (callback32(argument2)) then
					return false, "Config file is empty or invalid."
				end
				argument.Active = value21
				argument:Apply(argument2)
				if argument.AutoSave then
					if argument.ready then
						argument:Save()
					end
				end
				callback12(argument.cfgNotes)
				return true
			end

			index.List = function(argument)
				local data3, texts, ok, response = {[text2:lower()] = text2}, {}, pcall(listfiles, argument.dirP .. "/configs")

				for _, value21 in ipairs((ok and response) or {}) do
					argument = value12(value21):gsub("\\", "/"):match("([^/]+)%.json$")
					if argument then
						if argument ~= "" then
							data3[argument:lower()] = argument
						end
					end
				end

				for k, value21 in next, data3, nil do
					if k ~= text2:lower() then
						texts[#texts + 1] = value21
					end
				end
				table.sort(texts, function(argument2, argument3)
					return argument2:lower() < argument3:lower()
				end)
				table.insert(texts, 1, text2)
				return texts
			end

			index.Mgr = function(argument, argument2)
				local text3 = argument.dirP .. "/config_state.json"
				if argument2 then
					saveFile(text3, enc({Version = 2, AutoLoad = argument.AutoLoad, AutoSave = argument.AutoSave, StartupConfig = argument.Startup}) or "{}")
					return
				end
				local cachedFile, cachedFile2 = readCachedFile("ChilliLibrary/config_state.json"), readCachedFile(text3)

				if (if cachedFile2 then not cachedFile2 else cachedFile) and (cachedFile ~= "") then
					local ok, response = pcall(listfiles, "ChilliLibrary/configs")

					for i, value21 in ipairs((ok and response) or {}) do
						i = value12(value21):gsub("\\", "/"):match("([^/]+)$")
						argument2 = (i and (i:sub(-5) == ".json")) and readCachedFile(value21)
						if argument2 then
							saveFile(argument.dirP .. ("/configs/" .. i), argument2)
						end
					end

					saveFile(text3, cachedFile)
				end

				argument2 = dec(readCachedFile(text3)) or {}
				argument.AutoLoad, argument.AutoSave, argument.Startup = argument2.AutoLoad ~= false, argument2.AutoSave ~= false, value12(argument2.StartupConfig or text2)
				argument.Active = argument.Startup
			end

			index.Default = function(argument)
				argument.busy = true

				for _, opt in ipairs(argument.Opts) do
					if not (opt.Skip) then
						if opt.Def ~= nil then
							if opt.Tab ~= "Config" then
								pcall(opt.Set, opt, getClonedTbl(opt.Def))
							end
						end
					end
				end

				for _, value21 in next, argument.St, nil do
					if value21.Def ~= nil then
						value21:Set(getClonedTbl(value21.Def))
					end
				end
				argument.busy = false
				argument:Dirty()
			end

			index.Float = function(argument)
				local argument2 = argument
				local value21 = callback20({DisplayOrder = 59})
				argument2.fgui = value21
				local frame2 = getFrame({p = value21, A = value5, P = uDim2New(0, 16, 0.3, 0), S = uDim2FromOffset(56, 56), T = 1})
				local UIScale = number("UIScale", {p = frame2})
				argument = number("ImageButton", {p = frame2, A = value4, P = value8, S = value10, T = 1, Image = "rbxassetid://128961717706452", ScaleType = scrollingFrame.ScaleType.Fit, number("UICorner", {CornerRadius = uDimNew(0.28, 0)})})
				local UIScale2 = number("UIScale", {p = argument})
				local function callback32()
					UIScale.Scale = clamp((callback21().X * 0.035) / 56, 0.7, 1.4)
				end
				callback32()
				if workspace.CurrentCamera then
					callback3(workspace.CurrentCamera, "ViewportSize", callback32)
				end
				local input, value, position, condition2, condition3

				local function callback33(argument3, argument)
					if input == "mouse" then
						return argument3.UserInputType == ((argument and mouseMovement) or mouseButton1)
					end
					argument = input
					return argument3 == argument
				end

				local function callback34()
					tw(UIScale2, {Scale = 1}, 0.14, scrollingFrame.EasingStyle.Back)
				end

				trackConnection(argument.InputBegan, function(input2)
					if callback10(input2) then
						if input2.UserInputState ~= begin then
							return
						elseif input then
							return
						end
					else
						return
					end

					local input3, value22, position2 = ((input2.UserInputType == touch) and input2) or "mouse", toVector2(input2), frame2.Position
					input, value, position, condition2, condition3 = input3, value22, position2, false, false
					tw(UIScale2, {Scale = 0.9}, 0.08)
				end)

				trackConnection(UserInputService.InputChanged, function(input2)
					if input then
						if not (callback33(input2, true)) then
							return
						end
					else
						return
					end

					local number15 = toVector2(input2) - value

					if not (condition2) then
						if number15.Magnitude < 8 then
							return
						end
						condition2, condition3 = true, true
						callback34()
					end

					local absoluteSize, absoluteSize2 = value21.AbsoluteSize, frame2.AbsoluteSize
					local number16, number17 = (position.X.Offset + (position.X.Scale * absoluteSize.X)) + number15.X, (position.Y.Offset + (position.Y.Scale * absoluteSize.Y)) + number15.Y
					frame2.Position = uDim2FromOffset(clamp(number16, 0, max(0, absoluteSize.X - absoluteSize2.X)), clamp(number17, absoluteSize2.Y * 0.5, max(absoluteSize2.Y * 0.5, absoluteSize.Y - (absoluteSize2.Y * 0.5))))
				end)

				trackConnection(UserInputService.InputEnded, function(input2)
					if input then
						if callback33(input2, false) then
							input, condition2 = nil, false
							callback34()
						end
					end
				end)

				trackConnection(argument.Activated, function()
					if condition3 then
						condition3 = false
						return
					end
					argument2:Show(not argument2.open)
				end)

				value21.Parent = argument2.par
			end

			local labelMap2, nameList = {Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift", LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter", Space = "Space", Backspace = "Back"}, {"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"}
			for i, value21 in ipairs(nameList) do
				labelMap2["Keypad" .. value21] = "Num" .. (i - 1)
			end
			local function getEntry(argument)
				return (argument and (labelMap2[argument] or value12(argument))) or nil
			end
			local enabledFlags, enabledFlags2 = {toggle = true, button = true, slider = true, input = true}, {toggle = true, button = true}
			local function getEnabledFlag(argument)
				return (enabledFlags[argument.Type] and (argument.Quick ~= false)) and not argument.mirrorOf
			end
			local function getClonedTbl2(argument)
				return ((type(argument) == "table") and table.clone(argument)) or {}
			end

			index.Quick = function(setTab)
				local setTab2 = setTab
				local quickDefaults = setTab2.QuickDefaults
				local value21 = setTab2:State("Quick Pinned Features", getClonedTbl2(quickDefaults.pins))
				local value22 = setTab2:State("Quick Pin Groups", getClonedTbl2(quickDefaults.groups))
				local value23 = setTab2:State("Quick Keybinds", getClonedTbl2(quickDefaults.keys))
				local value24 = setTab2:State("Quick Panel Position", {})
				local value25 = setTab2:State("Quick Panel Collapsed", {})
				local value26 = setTab2:State("Quick Open Key", "LeftControl")
				setTab2:State("Quick LeftCenter Hidden", quickDefaults.hud == true)
				local function callback32()
					return ((type(value23.Value) == "table") and value23.Value) or {}
				end
				local function callback33()
					return ((type(value21.Value) == "table") and value21.Value) or {}
				end
				local function toNumberOrDefault2(argument)
					return clamp(floor(tonumber((type(value22.Value) == "table") and value22.Value[argument]) or 1), 1, 5)
				end
				local function callback34(argument)
					return table.find(callback33(), argument) ~= nil
				end
				local value27 = callback20({p = setTab2.par, DisplayOrder = 5, Enabled = false})
				setTab2.qgui = value27
				local number15, iMap = ((touchEnabled and 150) or 120) / 100, {true, true, true, true, true}
				local function callback35(argument)
					local number16 = (0.078 * number15) * 0.97
					return clamp(argument, 0, max(0, 0.998 - number16))
				end

				local function callback36(argument)
					local value28, number16 = ((touchEnabled and {0.023, 0.023, 0.42}) or {0.023, 0.303, 0.7})[argument], 0.078 * number15
					if argument == 2 then
						if touchEnabled then
							return (((1 - (number16 * 0.97)) + (number16 * 0.03)) - (number16 * 0.1)) - (number16 * 0.97), value28
						end
					end
					if argument <= 3 then
						return 1, value28
					end

					if argument == 4 then
						return 0.11, 0.5
					end

					if touchEnabled then
						return ((0.11 + (number16 * 0.97)) + (number16 * 0.1)) - (number16 * 0.03), 0.5
					end
					return 0.11, 0.74
				end

				local function toNumberOrDefault3(argument)
					local number16, number17 = callback36(argument)
					local condition2 = (type(value24.Value) == "table") and value24.Value[value12(argument)]
					if type(condition2) == "table" then
						number16, number17 = tonumber(condition2.X or condition2[1]) or number16, tonumber(condition2.Y or condition2[2]) or number17
					end
					return callback35(number16), clamp(number17, 0, 0.98)
				end

				local pathMap, iMap2 = {}, {}
				local function callback37(argument)
					return (type(value25.Value) == "table") and (value25.Value[value12(argument)] == true)
				end
				local function callback38()
					for i, value28 in ipairs(iMap2) do
						value28.col = callback37(i)
					end
				end

				for i = 1, 5, 1 do
					local frame2 = getFrame({p = value27, n = "QuickBar" .. i, T = 1, S = uDim2FromScale(0.078, 0.032), V = false, Z = 2})
					local textButton = getTextButton({p = frame2, n = "Handle", a = true, A = value7, P = value9, S = uDim2FromScale(0.94, 1), B = value2, T = 0.35, Z = 3, callback4(0.06), getFrame({n = "HeaderAccent", A = vector2New(0.5, 1), P = uDim2FromScale(0.5, 1), S = uDim2FromScale(1, 0.07), B = value, T = 0.08, Z = 4})})
					callback7({p = textButton, n = "Title", A = value5, P = uDim2FromScale(0.07, 0.5), S = uDim2FromScale(0.62, 0.55), x = "Quick Bar " .. i, X = left, Z = 4}, true)
					local frame3 = getFrame({p = frame2, n = "Body", A = value7, P = uDim2FromScale(0.5, 1), S = uDim2FromScale(1.32, 0), T = 1, C = true, Z = 2, number("UIPadding", {n = "BodyPadding", PaddingLeft = uDimNew(0.03, 0), PaddingRight = uDimNew(0.03, 0)})})
					local UIListLayout, textButton2 = number("UIListLayout", {p = frame3, n = "BodyLayout", H = center, Y = layoutOrder}), getTextButton({p = textButton, n = "Collapse", a = true, A = value6, P = uDim2FromScale(0.955, 0.5), S = uDim2FromScale(0.17, 0.6), Z = 4})
					local formattedText = formatCompact(textButton2, value, value8, uDim2FromScale(0.85, 0.85), 4)
					local sectionView = {pn = frame2, hd = textButton, body = frame3, bl = UIListLayout, car = formattedText, items = {}, cons = {}, frac = 0}
					sectionView.col = callback37(i)

					local function toggleCol()
						sectionView.col = not sectionView.col
						local clonedTbl = getClonedTbl2(value25.Value)
						clonedTbl[value12(i)] = sectionView.col
						value25:Set(clonedTbl)
						if sectionView.tw then
							sectionView.tw:Cancel()
						end
						sectionView.tw = tw(frame3, {Size = uDim2FromScale(1.32, (sectionView.col and 0) or sectionView.frac)}, 0.26, quint)
						tw(formattedText, {Rotation = (sectionView.col and 180) or 0}, 0.26, quint)
					end

					callback15(textButton2, toggleCol)
					local value, argument2, condition2

					callback11({textButton}, function(argument)
						local value28 = toVector2(argument)

						if callback14(textButton, value28) then
							if callback14(textButton2, value28) then
								return false
							end
						else
							return false
						end

						argument = nil
						argument, value = vector2New(frame2.Position.X.Scale, frame2.Position.Y.Scale), value28
						argument2, condition2 = argument, false
					end, function(argument)
						local absoluteSize = value27.AbsoluteSize
						if absoluteSize.X <= 0 then
							return
						end
						local number16 = toVector2(argument) - value
						if not (condition2) then
							if number16.Magnitude < 6 then
								return
							end
						end
						condition2 = true
						frame2.Position = uDim2FromScale(callback35(argument2.X + (number16.X / absoluteSize.X)), clamp(argument2.Y + (number16.Y / absoluteSize.Y), 0, 0.98))
					end, function()
						if condition2 then
							local clonedTbl = getClonedTbl2(value24.Value)
							for k, value28 in next, clonedTbl, nil do
								if type(value28) ~= "table" then
									clonedTbl[k] = nil
								end
							end
							clonedTbl[value12(i)] = {X = frame2.Position.X.Scale, Y = frame2.Position.Y.Scale}
							value24:Set(clonedTbl)
						else
							toggleCol()
						end
					end)

					iMap2[i] = sectionView
				end

				local function formatCompact5(argument, argument2, argument3, argument4)
					local value28 = number((argument4 and "TextButton") or "Frame", {p = argument.body, n = "Item" .. argument2, a = argument4 == true, O = argument2, S = uDim2FromScale(0.7121, argument3), B = value2, T = 0.4, Z = 3, callback4(0.05)})
					argument.items[#argument.items + 1] = value28
					return value28
				end
				local function callback39(argument, argument2)
					if argument2 then
						callback7({p = argument, n = "BarKeyChip", A = value5, P = uDim2FromScale(0.025, 0.485), S = uDim2FromScale(0.153, 0.612), x = "[" .. (argument2 .. "]"), X = left, Z = 6}).TextColor3 = color3FromRGB(190, 190, 190)
					end
				end
				local interfaceSection, data3 = setmetatable, {__mode = "k"}
				local value28 = interfaceSection({}, data3)

				local function callback40(argument, argument2, argument3)
					value28[argument2] = value28[argument2] or {}
					value28[argument2][argument3] = true
					argument.cons[#argument.cons + 1] = {Disconnect = function()
						if value28[argument2] then
							value28[argument2][argument3] = nil
						end
					end}
				end

				local function callback41(argument, argument2, argument3, argument4, argument5)
					local type_ = argument2.Type

					if type_ == "toggle" then
						local formattedText = formatCompact5(argument, argument4, argument5, true)
						callback7({p = formattedText, n = "Label", A = value5, P = uDim2FromScale((argument3 and 0.19) or 0.03, 0.5), S = uDim2FromScale((argument3 and 0.52) or 0.68, 0.72), x = argument2.Disp or argument2.Name, Z = 4})
						callback39(formattedText, argument3)
						local formattedText2, value29 = formatCompact3(formattedText, 1, 0.955, 0.23, 0.56, 6)
						value29(argument2.Value == true, false)
						callback40(argument, argument2, function()
							value29(argument2.Value == true)
						end)
						callback15(formattedText, function()
							argument2:Set(not argument2.Value)
						end)
						pathMap[argument2.Path] = formattedText
					elseif type_ == "button" then
						local formattedText, value29, value30 = formatCompact2({p = argument.body, n = "Item" .. argument4, O = argument4, S = uDim2FromScale(0.7121, argument5), Z = 3, Text = argument2.Disp or argument2.Name})
						value30.Position, value30.Size = uDim2FromScale((argument3 and 0.58) or 0.5, 0.5), uDim2FromScale((argument3 and 0.78) or 0.94, 0.68)
						callback39(formattedText, argument3)
						argument.items[#argument.items + 1] = formattedText
						callback15(formattedText, function()
							argument2:Press()
						end)
						pathMap[argument2.Path] = formattedText
					elseif type_ == "slider" then
						local formattedText = formatCompact5(argument, argument4, argument5)
						callback7({p = formattedText, n = "Label", A = value5, P = uDim2FromScale(0.035, 0.255), S = uDim2FromScale(0.67, 0.34), x = argument2.Disp or argument2.Name, X = left, y = scrollingFrame.TextYAlignment.Center, Z = 4})
						local clone = argument2.row.vb:Clone()
						local clone2 = argument2.row.tr:Clone()
						clone.AnchorPoint, clone.Position, clone.Size = value4, uDim2FromScale(0.84, 0.255), uDim2FromScale(0.25, 0.34)
						clone.ZIndex = 5
						clone.Parent = formattedText
						clone2.Position, clone2.Size = uDim2FromScale(0.5, 0.735), uDim2FromScale(0.92, 0.24)
						clone2.ZIndex = 4
						clone2.Parent = formattedText
						local bar = clone2.Bar
						local hold = clone2.Hold
						local function callback42()
							hold.Size = uDim2FromOffset(max(1, clone2.AbsoluteSize.Y * 1.38), max(1, clone2.AbsoluteSize.Y * 1.38))
						end
						callback42()
						argument.cons[#argument.cons + 1] = callback3(clone2, "AbsoluteSize", callback42)
						local value29, value30 = argument2:Places()

						local function callback43()
							local value31 = clamp(((argument2.Max > argument2.Min) and clamp((argument2.Value - argument2.Min) / (argument2.Max - argument2.Min), 0, 1)) or 0, 0.0575, 0.9425)
							bar.Size, hold.Position = uDim2FromScale(value31, 1), uDim2FromScale(value31, 0.5)
							if not (clone:IsFocused()) then
								clone.RichText, clone.Text = false, (value29 and string.format("%." .. (value30 .. "f"), argument2.Value)) or value12(math.round(argument2.Value))
							end
						end

						callback43()
						callback40(argument, argument2, callback43)

						trackConnection(clone.FocusLost, function()
							local number16 = tonumber(clone.Text)
							if number16 then
								argument2:Set(number16)
							end
							callback43()
						end)

						local function callback44(argument6)
							argument2:Set(argument2.Min + ((argument2.Max - argument2.Min) * clamp((argument6.Position.X - clone2.AbsolutePosition.X) / max(clone2.AbsoluteSize.X, 1), 0, 1)))
							callback43()
						end
						local value31, value32, value33 = callback11({clone2, bar, hold}, callback44, callback44)
						argument.cons[#argument.cons + 1] = value32
						argument.cons[#argument.cons + 1] = value33
					elseif type_ == "input" then
						local formattedText = formatCompact5(argument, argument4, argument5)
						callback7({p = formattedText, n = "Label", A = value5, P = uDim2FromScale(0.035, 0.5), S = uDim2FromScale(0.43, 0.7), x = argument2.Disp or argument2.Name, X = left, Z = 4})
						local clone = argument2.row.fd:Clone()
						clone.AnchorPoint, clone.Position, clone.Size = value4, uDim2FromScale(0.72, 0.5), uDim2FromScale(0.48, 0.62)
						clone.ZIndex = 4
						clone.Parent = formattedText
						local input = clone.Input
						formattedText = clone.Underline
						input.Text = value12(argument2.Value or "")
						callback16(input, clone, formattedText, function()
							argument2:Set(input.Text)
							input.Text = value12(argument2.Value or "")
						end)
						callback40(argument, argument2, function()
							if not (input:IsFocused()) then
								input.Text = value12(argument2.Value or "")
							end
						end)
					end
				end

				local function callback42()
					table.clear(pathMap)
					local number16, iMap3 = callback32(), {}
					for i = 1, 5, 1 do
						iMap3[i] = {}
					end

					for i, value29 in ipairs(callback33()) do
						i = setTab2.ByPath[value29]

						if i then
							if getEnabledFlag(i) then
								local insert, iEntry, data4 = table.insert, iMap3[toNumberOrDefault2(value29)], {o = i}
								data4.k = (UserInputService.KeyboardEnabled and getEntry(number16[value29])) or nil
								insert(iEntry, data4)
							end
						end
					end

					for i, value29 in ipairs(iMap2) do
						for _, con in ipairs(value29.cons) do
							con:Disconnect()
						end
						for _, entry in ipairs(value29.items) do
							entry:Destroy()
						end
						table.clear(value29.cons)
						table.clear(value29.items)
						local iEntry, iEntry2 = iMap3[i], iMap[i]

						if if iEntry2 then #iEntry == 0 else not iEntry2 then
							value29.pn.Visible = false
						else
							local number17, number18, number19 = 0.032 * number15, 0.022 * number15, 0.005 * number15
							number16 = ((#iEntry - 1) * number19) + (#iEntry * number17)
							local number20 = (number18 + number19) + number16
							value29.frac = number16 / number20
							if value29.tw then
								value29.tw:Cancel()
								value29.tw = nil
							end
							value29.pn.Size = uDim2FromScale(0.078 * number15, number20)
							value29.hd.Size = uDim2FromScale(0.94, number18 / number20)
							value29.body.Position, value29.body.Size = uDim2FromScale(0.5, (number18 + number19) / number20), uDim2FromScale(1.32, (value29.col and 0) or value29.frac)
							value29.bl.Padding = uDimNew(number19 / number16, 0)
							value29.car.Rotation = (value29.col and 180) or 0
							for i2, value30 in ipairs(iEntry) do
								callback41(value29, value30.o, value30.k, i2, number17 / number16)
							end
							value29.pn.Position = uDim2FromScale(toNumberOrDefault3(i))
							value29.pn.Visible = true
						end
					end
				end

				setTab2.qRefresh = function(argument)
					local value29 = value28[argument]
					if value29 then
						for k in next, value29, nil do
							callback12(k)
						end
					end
				end

				local function callback43(argument)
					local pathEntry = pathMap[argument]
					local uiScale = pathEntry and (pathEntry:FindFirstChildOfClass("UIScale") or number("UIScale", {p = pathEntry}))
					if not uiScale then
						return
					end
					tw(uiScale, {Scale = 0.94}, 0.055)
					task.delay(0.07, function()
						if uiScale.Parent then
							tw(uiScale, {Scale = 1}, 0.09)
						end
					end)
				end

				data3, setTab = setTab2:Tab("Quick", "Right", "Quick & Keys"), setTab2:Tab("Settings", "Right")
				setTab2.setTab = setTab
				interfaceSection = setTab:Section("Interface", true)
				setTab2.sizeOpt = interfaceSection:Slider("UI Size", 60, 160, 100, function(argument)
					setTab2:Scale(argument / 100)
				end, "%", 1, "Scales the main window; the corner grip does the same by hand")
				setTab2.sizeOpt.Quick = false
				local pinPadSection, section = data3:Section("Pin Pad", true, "Quick Access"), data3:Section("Pin & Key List", true, "Quick Bar & Keybinds")
				local function callback44()
					value21:Set(getClonedTbl2(quickDefaults.pins))
					value22:Set(getClonedTbl2(quickDefaults.groups))
					value24:Set({})
				end
				setTab = section:Button("Reset Pins", "Reset", callback44, "Restore default items, bars and positions", "Done!")
				setTab:Title("Reset Quick Access")
				setTab.Quick = false
				section:Button("Reset Keybinds", "Reset", function()
					value23:Set(getClonedTbl2(quickDefaults.keys))
				end, "Restore the defaults set in code", "Done!").Quick = false
				local value29 = pinPadSection:Toggle("Enable Keybinds", true, nil, "Turn off to disable every feature hotkey")
				local callback44_2 = pinPadSection:Toggle("Show Pin Pads", true, function(enabled)
					value27.Enabled = enabled
				end, "Floating quick bars; drag a header to move one")
				callback44_2:Title("Show Quick Bars")

				local value30, value31 = pinPadSection:Dropdown("Visible Quick Bars", {"Quick Bar 1", "Quick Bar 2", "Quick Bar 3", "Quick Bar 4", "Quick Bar 5"}, {"Quick Bar 1", "Quick Bar 2", "Quick Bar 3", "Quick Bar 4", "Quick Bar 5"}, function(argument)
					iMap = {}
					for i, value30 in ipairs(argument) do
						i = tonumber(value12(value30):match("(%d+)$"))
						if i then
							iMap[i] = true
						end
					end
					callback42()
				end, true, nil, callback44_2), pinPadSection:Slider("Pad Size", 60, 200, (touchEnabled and 150) or 120, function(argument)
					number15 = argument / 100
					callback42()
				end, "%", 1)

				value31:Title("Quick Bar Size")
				setTab = {value29, callback44_2, value30, value31}
				for _, value32 in ipairs(setTab) do
					value32.Quick = false
				end
				value27.Enabled = callback44_2.Value
				local Notifications = setTab2:State("Notifications", true)
				local value32 = setTab2:State("Open On Launch", true)
				local Notifications2 = interfaceSection:Toggle("Notifications", true, function(argument)
					Notifications:Set(argument)
				end, "Show notification cards; turning this off hides every notify")
				local value33 = interfaceSection:Toggle("Open On Launch", true, function(argument)
					value32:Set(argument)
				end, "Open the UI automatically when the script starts")
				Notifications2.Skip = true
				value33.Skip = true
				Notifications2.Quick = false
				value33.Quick = false
				Notifications.ls[#Notifications.ls + 1] = function(argument)
					Notifications2:Set(argument ~= false, true)
					callback29(argument ~= false)
				end
				value32.ls[#value32.ls + 1] = function(argument)
					value33:Set(argument ~= false, true)
				end
								local value34 = interfaceSection:Button("UI Toggle Key", "Rebind", function()
					setTab2.cap = "__OPEN__"
					callback29:Note("Press any key...")
				end, "Current: " .. value12(getEntry(value26.Value)), "")
				value34.Quick = false
				local function callback45()
					value34:Note("Current: " .. value12(getEntry(value26.Value)))
				end
				value26.ls[#value26.ls + 1] = callback45
				if not (UserInputService.KeyboardEnabled) then
					value29:Visible(false)
					value34:Visible(false)
				end
				local formattedTexts, condition2 = {}, false
				local function callback46(argument)
					local textButton = getTextButton({p = argument, n = "QuickAccessToggle", A = value6, P = uDim2FromScale(0.985, 0.5), S = uDim2FromScale(0.115, 0.74), Z = 6})
					local formattedText, value35 = formatCompact3(textButton, 0.5, 0.5, 0.95, 0.78, 6)
					return textButton, value35
				end
				local value35

				local function callback47()
					for _, formattedText in ipairs(formattedTexts) do
						if formattedText.pt then
							formattedText.pt()
						end
					end
				end

				local function callback48(argument, argument2)
					local path = argument.Path
					local enabledFlag, QuickRow = UserInputService.KeyboardEnabled and enabledFlags2[argument.Type], section:Row("QuickRow", nil)
					QuickRow.lb.Text = argument.Disp or argument.Name
					QuickRow.lb.Size = uDim2FromScale((enabledFlag and 0.47) or 0.63, 0.64)
					local m = QuickRow.m
					local textButton = getTextButton({p = m, n = "BarPicker", A = value6, P = uDim2FromScale(0.858, 0.5), S = uDim2FromScale(0.062, 0.55), B = value2, T = 0.5, Z = 6, callback4(0.1)})
					callback5(textButton)
					callback13(textButton, 1.04, 0.96)
					local formattedText = formatCompact(textButton, value, uDim2FromScale(0.99, 0.01), uDim2FromScale(0.44, 0.44), 8, 0.22)
					formattedText.AnchorPoint = vector2New(1, 0)
					local textButton2, textButton3

					if enabledFlag then
						textButton2 = getTextButton({p = m, n = "KeyChip", A = value6, P = uDim2FromScale(0.775, 0.5), S = uDim2FromScale(0.125, 0.5), B = value2, T = 0.35, Z = 6, callback4(0.1)})
						callback5(textButton2)
						callback13(textButton2, 1.04, 0.96)
						textButton3 = textButton2
					else
						textButton3 = textButton2
					end

					local value36, value37 = callback46(m)
					local frame2, iMap3 = getFrame({p = QuickRow.r, n = "BarMenu", A = value6, P = uDim2FromScale(0.985, 0.755), S = uDim2FromScale(0.4, 0), T = 1, V = false, Z = 5, number("UIListLayout", {n = "MenuLayout", FillDirection = scrollingFrame.FillDirection.Horizontal, H = scrollingFrame.HorizontalAlignment.Right, VerticalAlignment = scrollingFrame.VerticalAlignment.Center, Y = layoutOrder, G = uDimNew(0.024, 0)})}), {}
					for i = 1, 5, 1 do
						enabledFlag = getTextButton({p = frame2, n = "Bar" .. i, O = i, S = uDim2FromScale(0.176, 1), x = value12(i), B = value2, T = 0.4, Z = 6, callback4(0.09)})
						callback5(enabledFlag)
						callback13(enabledFlag, 1.06, 0.94)
						iMap3[i] = enabledFlag
					end

					local function pt()
						local value38 = callback34(path)
						value37(value38, false)
						textButton.Text, textButton.TextTransparency = value12(toNumberOrDefault2(path)), (value38 and 0) or 0.5
						for i, value39 in ipairs(iMap3) do
							value39.BackgroundTransparency, value39.TextTransparency = ((i == toNumberOrDefault2(path)) and 0.15) or 0.4, ((i == toNumberOrDefault2(path)) and 0) or 0.2
						end
						if textButton3 then
							textButton3.Text = (((setTab2.cap == path) and "?") or getEntry(callback32()[path])) or "-"
						end
					end

					local NumberValue, condition3, value38 = number("NumberValue", {p = QuickRow.r, n = "BarMenuAlpha"}), false

					local function callback49(argument3)
						local ratio = 10 + (-3.8 * argument3)
						local number16 = 10 / ratio
						QuickRow.ratio = ratio
						m.Size, m.Position = uDim2FromScale(1, 0.85 / number16), uDim2FromScale(0.5, 0.5 / number16)
						ratio = 0.925 / number16
						number16 = max(0, 1 - ratio)
						frame2.Size, frame2.Position, frame2.Visible = uDim2FromScale(0.4, number16 * 0.66), uDim2FromScale(0.985, ratio + (number16 * 0.5)), argument3 > 0.01
						formattedText.Rotation = 180 * argument3
						QuickRow.fit()
					end

					trackConnection(NumberValue.Changed, callback49)

					local function callback50(argument3)
						if condition3 == argument3 then
							return
						end
						condition3 = argument3

						if argument3 then
							closeDropdown()
							if value35 then
								value35()
							end
							function value35()
								callback50(false)
							end
							setTab2.closeDD = value35
						else
							if setTab2.closeDD == value35 then
								setTab2.closeDD = nil
							end
							value35 = nil
						end

						if value38 then
							value38:Cancel()
						end
						value38 = tw(NumberValue, {Value = (argument3 and 1) or 0}, 0.26, quint)
					end

					for i, value39 in ipairs(iMap3) do
						callback15(value39, function()
							local clonedTbl = getClonedTbl2(value22.Value)
							clonedTbl[path] = i
							value22:Set(clonedTbl)
							callback50(false)
							pt()
						end)
					end

					callback15(textButton, function()
						callback50(not condition3)
					end)

					callback15(value36, function()
						local clonedTbl = getClonedTbl2(value21.Value)
						local pos = table.find(clonedTbl, path)
						if pos then
							table.remove(clonedTbl, pos)
						else
							clonedTbl[#clonedTbl + 1] = path
						end
						value21:Set(clonedTbl)
						pt()
					end)

					if textButton3 then
						callback15(textButton3, function()
							setTab2.cap = path
							callback47()
						end)
					end
					QuickRow.pt, QuickRow.s = pt, ((argument.Disp or argument.Name) .. (" " .. argument2)):lower()
					pt()
					return QuickRow
				end

				local function formatCompact6(argument)
					local QuickGroup = section:Row("QuickGroup", nil, nil, 22)
					local value36 = callback7({p = QuickGroup.r, n = "Label", A = value5, P = uDim2FromScale(0.025, 0.5), S = uDim2FromScale(0.6, 0.8), x = argument, X = left, Z = 5})
					value36.TextColor3 = value3
					getFrame({p = QuickGroup.r, n = "Line", A = value6, P = uDim2FromScale(0.985, 0.5), S = uDim2FromScale(0.34, 0.08), B = value, T = 0.75, Z = 4})
					QuickGroup.lb2 = value36
					QuickGroup.hdr = true
					return QuickGroup
				end

				local function onOpen()
					if condition2 then
						return
					end
					condition2 = true
					local row, formattedText

					for i, tab in ipairs(setTab2.Tabs) do
						for i2, section2 in ipairs(tab.Sections) do
							for i3, row2 in ipairs(section2.rows) do
								i3 = row2.o

								if i3 then
									if not (section2.noReg) then
										if getEnabledFlag(i3) then
											row2, i2 = callback26(i3.Section.t) .. ("  >  " .. i3.Section.Disp)

											if row2 ~= row then
												i2 = formatCompact6(row2)
												formattedTexts[#formattedTexts + 1] = i2
												row = row2
											else
												i2 = formattedText
											end

											i = callback48(i3, row2)
											i.hx = i2
											formattedTexts[#formattedTexts + 1] = i
											formattedText = i2
										end
									end
								end
							end
						end
					end
				end

				data3.onOpen = onOpen

				section.extra = function(argument)
					local hxMap, condition3 = {}, false

					for i, formattedText in ipairs(formattedTexts) do
						if not (formattedText.hdr) then
							i = (argument == "") or (formattedText.s:find(argument, 1, true) ~= nil)
							formattedText.h.Visible = i
							callback25(formattedText.lb, argument)
							if i then
								hxMap[formattedText.hx] = true
								condition3 = true
							end
						end
					end

					for _, formattedText in ipairs(formattedTexts) do
						if formattedText.hdr then
							formattedText.h.Visible = (argument == "") or (hxMap[formattedText] == true)
							callback25(formattedText.lb2, argument)
						end
					end
					return condition3
				end

				local function qChips()
					local value36 = callback32()

					for i, opt in ipairs(setTab2.Opts) do
						local mirrorOf = opt.mirrorOf or opt
						i = opt.row

						if (((enabledFlags2[mirrorOf.Type] and i) and i.m) and (opt.Quick ~= false)) and (mirrorOf.Quick ~= false) then
							local entry, optionKeyChip = (UserInputService.KeyboardEnabled and getEntry(value36[mirrorOf.Path])) or nil, i.m:FindFirstChild("OptionKeyChip")

							if entry then
								local number16, visible = ((mirrorOf.Type == "button") and 0.772) or 0.822, i.nt and i.nt.Visible

								if not optionKeyChip then
									optionKeyChip = getTextButton({p = i.m, n = "OptionKeyChip", a = true, A = value6, B = value2, T = 0.35, Z = 7, callback4(0.1)})
									callback5(optionKeyChip)
									callback13(optionKeyChip, 1.06, 0.94)
									callback15(optionKeyChip, function()
										setTab2.cap = mirrorOf.Path
										optionKeyChip.Text = "?"
									end)
								end

								optionKeyChip.Position, optionKeyChip.Size = uDim2FromScale(number16, 0.5), uDim2FromScale(0.082, (visible and 0.315) or 0.42)
								optionKeyChip.Text = entry
								visible = (number16 - 0.082) - 0.015
								i.lbS = i.lbS or i.lb.Size
								i.lb.Size = uDim2New(min(i.lbS.X.Scale, max(0.12, visible - i.lb.Position.X.Scale)), 0, i.lbS.Y.Scale, 0)
								if i.nt then
									i.ntS = i.ntS or i.nt.Size
									i.nt.Size = uDim2New(min(i.ntS.X.Scale, max(0.12, visible - i.nt.Position.X.Scale)), 0, i.ntS.Y.Scale, 0)
								end
							else
								if optionKeyChip then
									optionKeyChip:Destroy()
								end
								if i.lbS then
									i.lb.Size = i.lbS
									i.lbS = nil
								end
								if i.ntS then
									if i.nt then
										i.nt.Size = i.ntS
										i.ntS = nil
									end
								end
							end
						end
					end
				end

				setTab2.qChips = qChips

				trackConnection(UserInputService.InputBegan, function(input, gameProcessed)
					if input.UserInputType ~= scrollingFrame.UserInputType.Keyboard then
						return
					elseif UserInputService:GetFocusedTextBox() then
						return
					end

					if setTab2.cap then
						local cap = setTab2.cap
						setTab2.cap = nil

						if cap == "__OPEN__" then
							if input.KeyCode ~= scrollingFrame.KeyCode.Escape then
								value26:Set(input.KeyCode.Name)
							else
								callback45()
							end
						else
							local clonedTbl = getClonedTbl2(value23.Value)
							clonedTbl[cap] = ((input.KeyCode ~= scrollingFrame.KeyCode.Escape) and input.KeyCode.Name) or nil
							value23:Set(clonedTbl)
							callback47()
						end

						return
					end

					if gameProcessed then
						return
					end

					if input.KeyCode.Name == value12(value26.Value) then
						gameProcessed = not setTab2.open
						return setTab2:Show(gameProcessed)
					end

					if not (value29.Value) then
						return
					end
					local value, value36, value37 = next, callback32()

					for k, value38 in value, value36, value37 do
						if value38 == input.KeyCode.Name then
							gameProcessed = setTab2.ByPath[k]

							if gameProcessed then
								if enabledFlags2[gameProcessed.Type] then
									if gameProcessed.Type == "toggle" then
										gameProcessed:Set(not gameProcessed.Value)
									else
										gameProcessed:Press()
									end
									callback43(k)
								end
							end
						end
					end
				end)

				value21.ls[#value21.ls + 1] = function()
					callback42()
					callback47()
				end
				value22.ls[#value22.ls + 1] = function()
					callback42()
					callback47()
				end
				value23.ls[#value23.ls + 1] = function()
					callback42()
					qChips()
					callback47()
				end
				value24.ls[#value24.ls + 1] = function()
					for i, value36 in ipairs(iMap2) do
						value36.pn.Position = uDim2FromScale(toNumberOrDefault3(i))
					end
				end
				value25.ls[#value25.ls + 1] = callback38

				setTab2.qSync = function()
					callback38()
					callback42()
					qChips()
					callback47()
					callback45()
				end

				return data3
			end

			index.ConfigTab = function(argument)
				local argument2 = argument
				argument = argument2.setTab:Section("Defaults", true)
				argument:Button("Reset to Defaults", "Reset", function()
					argument2:Default()
				end, "Reset every feature to its built-in default", "Done!").Quick = false

				argument:Button("Turn Off All Toggles", "Turn Off", function()
					for _, opt in ipairs(argument2.Opts) do
						if opt.Type == "toggle" then
							if opt.Value then
								if opt.Tab ~= "Settings" then
									if opt.Tab ~= "Config" then
										if opt.Tab ~= "Quick" then
											opt:Set(false)
										end
									end
								end
							end
						end
					end
				end, "Switch off every enabled toggle in the feature tabs", "Done!")

				local configTab, value21 = argument2:Tab("Config", "Right"), argument2:List()
				local configSection, text3 = configTab:Section("Config", true), "This config loads next time; use Load Config to load now"
				local value22 = configSection:Text("Startup Config", "Startup Config: " .. argument2.Startup)
				value22.NoSave = true

				local value23 = configSection:Toggle("Auto Save Config", argument2.AutoSave, function(autoSave)
					if not (argument2.ready) then
						return
					end
					argument2.AutoSave = autoSave
					argument2:Mgr(true)
					if autoSave then
						argument2:Save()
					end
				end, "Auto save: " .. argument2.Active)

				local value24 = configSection:Toggle("Auto Load Config", argument2.AutoLoad, function(autoLoad)
					if not (argument2.ready) then
						return
					end
					argument2.AutoLoad = autoLoad
					argument2:Mgr(true)
					if autoLoad then
						argument2:Load(argument2.Startup)
					end
				end, "Auto load: " .. argument2.Startup)

				value23.Skip = true
				value24.Skip = true
				argument = configTab:Section("Profiles", true)
				local value25 = argument:Input("New Config Name", "New config name...")
				value25.Skip = true
				local data3 = {}
				local value26

				local function cfgNotes()
					value22:Set("Startup Config: " .. argument2.Startup)
					value22:Note(((argument2.Startup:lower() ~= argument2.Active:lower()) and text3) or "")
					value23:Note("Auto save: " .. argument2.Active)
					value24:Note("Auto load: " .. argument2.Startup)
					if value26 then
						value26:Note("Save: " .. argument2.Active)
					end
				end

				argument2.cfgNotes = cfgNotes
				local function callback32()
					for _, value27 in ipairs(data3) do
						value27:Refresh(argument2:List())
					end
					cfgNotes()
				end
				local function callback33(argument3)
					for i = 2, #data3, 1 do
						data3[i]:Set(argument3, true)
					end
				end

				local function callback34(argument3)
					argument3 = argument3:match("^%s*(.-)%s*$")

					if argument3 == "" then
						return
					elseif #argument3 > 48 then
						return
					elseif argument3:find("[<>:\"/\\|%?%*%c]") then
						return
					elseif argument3:find("[%. ]$") then
						return
					end

					local text4 = argument3:upper():gsub("%..*$", "")

					if text4 == "CON" then
						return
					elseif text4 == "PRN" then
						return
					elseif text4 == "AUX" then
						return
					elseif text4 == "NUL" then
						return
					elseif text4 == "CLOCK$" then
						return
					elseif text4:match("^COM%d$") then
						return
					elseif text4:match("^LPT%d$") then
						return
					end

					return argument3
				end

				argument:Button("Create New Config", "Create New", function()
					local value = value25.Value
					local text4

					if value:match("^%s*$") then
						local number15 = 1
						text4 = "Default " .. number15
						while argument2:Find(text4) do
							number15 += 1
							text4 = "Default " .. number15
						end
					else
						text4 = callback34(value)

						if text4 then
							if argument2:Find(text4) then
								return
							end
						else
							return
						end
					end

					value = table.pack(argument2:Collect())
					if argument2:Save(text4, table.unpack(value, 1, value.n)) then
						value25:Set("", true)
						callback32()
						callback33(text4)
					end
				end, "New config copies current settings", "")

				local callback35, deleteList = function(argument3)
					local condition2 = false

					for i, value27 in ipairs(argument3) do
						i = argument2:Find(value27)

						if i then
							if i:lower() ~= "default" then
								pcall(delfile, argument2.dirP .. ("/configs/" .. (i .. ".json")))
								pcall(delfile, argument2.dirP .. ("/configs/" .. (i .. ".json.bak")))
								condition2 = if i:lower() == argument2.Active:lower() then true else condition2
								if i:lower() == argument2.Startup:lower() then
									argument2.Startup = "Default"
								end
							end
						end
					end

					if condition2 then
						if not (argument2:Load("Default")) then
							argument2.Active = "Default"
							argument2:Save("Default", argument2:Collect())
						end
					end
					argument2:Mgr(true)
					callback32()
					data3[1]:Set({}, true)
				end, {"Tick the configs to remove, then press Delete", "Delete"}

				data3[2] = argument:Dropdown("Delete Config", value21, {}, callback35, true, nil, nil, deleteList)

				data3[3] = argument:Dropdown("Set Startup Config", value21, argument2.Startup, function(argument3)
					local value27 = argument2:Find(argument3)
					if not (value27) then
						return callback32()
					end
					argument2.Startup = value27
					argument2:Mgr(true)
					cfgNotes()
				end, false, nil, nil, {"Pick a config to auto load next time, then press Set", "Set Startup"})

				data3[4] = argument:Dropdown("Load Config", value21, argument2.Active, function(argument3)
					argument2:Load(argument3)
				end, false, nil, nil, {"Pick a config, then press Load to apply it now", "Load"})
				value26 = argument:Button("Save Config", "Save", function()
					argument2:Save()
				end, "Save: " .. argument2.Active, "")
				configSection = configTab:Section("Import / Export", true)

				data3[5] = configSection:Dropdown("Export Config", value21, argument2:Find(argument2.Active) or "Default", function(profile)
					profile = (argument2:Find(profile) or argument2:Find(argument2.Active)) or "Default"
					local value27 = dec(readCachedFile(callback30(argument2, profile)))
					if type(value27) ~= "table" then
						return data.Notify("Export Failed", "Selected config does not exist.")
					end
					value27.Profile = profile
					local value28 = enc({Format = "ChilliLibraryConfig", ExportVersion = 1, Name = profile, Config = value27})
					if value28 and pcall(setclipboard, value28) then
						data.Notify("Config Exported", profile .. " was copied to the clipboard.")
					else
						data.Notify("Export Failed", "Clipboard is not available in this executor.")
					end
				end, false, nil, nil, {"Pick a config, then press Export to copy its text", "Export"})

				local value27 = configSection:Input("Import Config Text", "Paste exported config JSON...")
				value27.Skip = true

				configSection:Button("Import Config", "Import", function()
					local match = value27.Value:match("^%s*(.-)%s*$")
					local condition2 = (#match < 1048576) and dec(match)
					if ((type(condition2) ~= "table") or (condition2.Format ~= "ChilliLibraryConfig")) or (type(condition2.Config) ~= "table") then
						return data.Notify("Import Failed", "Paste exported config JSON first.")
					end
					match = callback34(value12(condition2.Name or "Imported"):sub(1, 40)) or "Imported"
					local match2, number15 = match, 1
					while argument2:Find(match2) do
						number15 += 1
						match2 = match .. (" " .. number15)
					end
					condition2.Config.Profile = match2
					argument2:Save(match2, condition2.Config)
					value27:Set("", true)
					callback32()
					callback33(match2)
					data.Notify("Config Imported", "Imported: " .. (match2 .. ". Open Load Config to apply, or Set Startup Config for Auto Load."), 5)
				end, "Creates a config only; use Load Config or Set Startup after", "").Quick = false

				argument = data3
				data3 = {argument[2], argument[3], argument[4], argument[5]}
				for _, value28 in ipairs(data3) do
					value28.Skip = true
				end
				cfgNotes()
				return configTab
			end

			index.Finish = function(argument)
				local argument = argument
				argument.ready = true

				callback12(function()
					if not (isfile and isfile(callback30(argument, "Default"))) then
						argument:Save("Default", argument:Collect())
					end
					local startup = argument.Startup
					if not (argument:Find(startup)) then
						argument.Startup = "Default"
					end
					argument.Active = argument.Startup
				end)

				if argument.AutoLoad then
					callback12(function()
						for i = 1, 6, 1 do
							i = argument.Startup
							if argument:Load(i) then
								break
							end
							task.wait(0.4)
						end
					end)
				end

				argument.busy = false
				callback12(argument.qSync)
				callback12(argument.cfgNotes)
				callback12(function()
					if argument.sizeOpt.Value ~= 100 then
						argument:Scale(argument.sizeOpt.Value / 100)
					end
				end)
				callback12(function()
					argument:Select(argument.Tabs[1])
				end)
				argument.gui.Enabled = true

				task.spawn(function()
					for i = 1, 5, 1 do
						RunService.Heartbeat:Wait()
					end
					local openOnLaunch = argument.St["Open On Launch"]

					if openOnLaunch then
						if openOnLaunch.Value ~= false then
							argument:Show(true)
						end
					else
						argument:Show(true)
					end
				end)
			end

			index.Destroy = function(argument)
				for _, connection in ipairs(connections) do
					pcall(connection.Disconnect, connection)
				end
				table.clear(connections)
				local value, data3 = ipairs, {argument.gui, argument.qgui, argument.fgui, argument.dlg}
				for _, value21 in value(data3) do
					if value21 then
						pcall(value21.Destroy, value21)
					end
				end
			end

			index.Dialog = function(argument, argument2)
				local argument3 = argument
				argument = callback51({0, color3FromRGB(92, 94, 106)}, {0.057, color3FromRGB(70, 71, 82)}, {1, color3FromRGB(38, 39, 46)})
				if argument3.dlg then
					argument3.dlg:Destroy()
				end
				local function getUIStroke(argument4, argument5, argument6)
					return number("UIStroke", {p = argument4, ApplyStrokeMode = (argument6 and contextual) or border, Color = value2, LineJoinMode = scrollingFrame.LineJoinMode.Round, Thickness = argument5})
				end
				local function getUIGradient2(argument4, argument5)
					return number("UIGradient", {p = argument4, Color = argument5, R = 90})
				end

				local function callback32(argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12)
					local TextLabel = number("TextLabel", {p = argument4, P = uDim2FromOffset(argument6, argument7), S = uDim2FromOffset(argument8, argument9), FontFace = font, TextColor3 = value, TextSize = argument5, X = left, Text = argument10 or "", Z = 12})
					for k, value21 in next, argument12 or {}, nil do
						TextLabel[k] = value21
					end
					argument7 = getUIStroke(TextLabel, max(1, argument5 * ((argument11 and 0.065) or 0.08)), true)
					if argument11 then
						getUIGradient2(argument7, value14)
						getUIGradient2(TextLabel, value13)
					end
					return TextLabel
				end

				local ScreenGui = number("ScreenGui", {p = argument3.par, DisplayOrder = 2000000000, IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = scrollingFrame.ZIndexBehavior.Sibling})
				argument3.dlg = ScreenGui
				getTextButton({p = ScreenGui, B = value2, T = 0.45, Modal = true, S = value10, Z = 1})
				local frame2 = getFrame({p = ScreenGui, a = true, A = value4, B = value2, T = 0.18, P = value8, S = uDim2FromOffset(430, 316), Z = 10})
				local UIScale = number("UIScale", {p = frame2})
				local function callback33()
					local value21 = callback21()
					UIScale.Scale = clamp(min(value21.X / 1280, value21.Y / 720), 0.72, 1.35)
				end
				callback33()

				if workspace.CurrentCamera then
					local connection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(callback33)
					local function callback34()
						connection:Disconnect()
					end
					ScreenGui.Destroying:Connect(callback34)
				end

				getUIStroke(frame2, 2)
				local callback33_2 = getFrame({p = frame2, B = value, P = uDim2FromOffset(22, 22), S = uDim2FromOffset(5, 26), Z = 12})
				getUIGradient2(callback33_2, value16)
				getUIStroke(callback33_2, 1.4)
				callback32(frame2, 21, 38, 20, 370, 30, argument2.Title, true)
				getFrame({p = frame2, B = value, T = 0.82, P = uDim2FromOffset(22, 58), S = uDim2FromOffset(386, 1), Z = 12})
				getUIGradient2(callback32(frame2, 17, 22, 68, 386, 24, argument2.Warn, false, {TextColor3 = color3FromRGB(255, 72, 72)}), ColorSequence.new(color3FromRGB(255, 132, 123), color3FromRGB(239, 28, 28)))
				local body, data3 = argument2.Body, {TextWrapped = true}
				data3.TextYAlignment, data3.LineHeight, data3.TextTransparency = scrollingFrame.TextYAlignment.Top, 1.14, 0.12
				callback32(frame2, 15, 22, 98, 386, 74, body, false, data3)
				callback32(frame2, 14, 22, 176, 386, 46, argument2.Tip, false, {TextWrapped = true, TextYAlignment = scrollingFrame.TextYAlignment.Top, LineHeight = 1.12, TextColor3 = color3FromRGB(255, 176, 120), RichText = true})

				local function destroyAll(argument4)
					ScreenGui:Destroy()
					if argument3.dlg == ScreenGui then
						argument3.dlg = nil
					end
					callback12(argument4)
				end

				body, callback33_2 = ipairs, {{22, argument2.Cancel or "Cancel", argument2.no}, {224, argument2.Accept or "OK", argument2.ok}}

				for k, value21 in body(callback33_2) do
					argument2, data3 = k == 2, getTextButton({p = frame2, a = true, T = 1, P = uDim2FromOffset(value21[1], 244), S = uDim2FromOffset(184, 46), Z = 14})
					k = getFrame({p = data3, A = value4, B = (argument2 and color3FromRGB(175, 0, 0)) or color3FromRGB(24, 25, 30), P = value8, S = uDim2FromScale(1, 0.92), Z = 12})
					getUIStroke(k, 1.6)
					local frame3 = getFrame({p = k, A = value7, B = value, P = value9, S = uDim2FromScale(1, 0.9), Z = 12})
					getUIGradient2(frame3, (argument2 and value16) or argument)
					getUIGradient2(getFrame({p = frame3, A = value4, B = value, P = value8, S = uDim2FromScale(0.965, 0.88), Z = 13}), (argument2 and value17) or argument)
					k, frame3 = value21[2], {AnchorPoint = value4, Position = value8, Size = uDim2FromScale(0.9, 0.6), TextWrapped = true}
					frame3.TextXAlignment, frame3.ZIndex = scrollingFrame.TextXAlignment.Center, 15
					callback32(data3, 17, 0, 0, 0, 0, k, true, frame3)
					local function callback34()
						destroyAll(value21[3])
					end
					data3.MouseButton1Click:Connect(callback34)
				end
			end

			local font4, data3 = Font.new("rbxasset://fonts/families/RobotoMono.json", scrollingFrame.FontWeight.Bold), {}
			data3.Center = scrollingFrame.TextXAlignment.Center
			data3.Right = right
			local index3 = {}
			index3.__index = index3
			local function getFont(argument)
				return (((argument == "code") and font4) or argument) or font
			end
			local function callback32(argument, argument2)
				if type(argument) == "string" then
					return Color3.fromHex(argument)
				end
				return argument or argument2
			end
			local function callback33(argument, argument2)
				return clamp(argument or argument2, 0, 1)
			end

			local function callback34(parent, color, rotation)
				local valueType, chilliCanvasGradient = typeof(color), parent:FindFirstChild("ChilliCanvasGradient")

				if (valueType == "Instance") and color:IsA("UIGradient") then
					if chilliCanvasGradient then
						chilliCanvasGradient:Destroy()
					end
					chilliCanvasGradient = color:Clone()
					chilliCanvasGradient.Name = "ChilliCanvasGradient"
					chilliCanvasGradient.Parent = parent
				else
					if valueType == "ColorSequence" then
						chilliCanvasGradient = chilliCanvasGradient or number("UIGradient", {n = "ChilliCanvasGradient", p = parent})
						chilliCanvasGradient.Color = color
					else
						return
					end
				end

				if rotation ~= nil then
					chilliCanvasGradient.Rotation = rotation
				end
			end

			local function destroyAll(argument, argument2)
				local uiCorner = argument:FindFirstChildOfClass("UICorner")
				if argument2 <= 0 then
					if uiCorner then
						uiCorner:Destroy()
					end
					return
				end;
				(uiCorner or number("UICorner", {p = argument})).CornerRadius = uDimNew(0, floor(argument2 + 0.5))
			end

			local function callback35(argument, argument2, argument3, argument4, argument5, applyStrokeMode, argument6)
				if not (argument6) then
					if argument2.StrokeColor == nil then
						if argument2.StrokeThickness == nil then
							return
						end
					end
				end

				local uiStroke, number15 = argument:FindFirstChildOfClass("UIStroke"), (argument2.StrokeThickness or argument4) * argument5
				if number15 <= 0 then
					if uiStroke then
						uiStroke:Destroy()
					end
					return
				end
				uiStroke = uiStroke or number("UIStroke", {LineJoinMode = scrollingFrame.LineJoinMode.Round, p = argument})
				uiStroke.ApplyStrokeMode, uiStroke.Color, uiStroke.Thickness, uiStroke.Transparency = applyStrokeMode, callback32(argument2.StrokeColor, argument3), max(0.01, number15), callback33(argument2.StrokeTransparency, 0)
			end

			local function callback36(argument, argument2)
				return floor((argument * argument2) + 0.5)
			end
			local function callback37(argument, argument2, argument3)
				local width = argument2.Width
				argument.Size, argument.Position = uDim2New((width and 0) or 1, (width and callback36(width, argument3)) or 0, 0, callback36(argument2.Height or 1, argument3)), uDim2FromOffset(callback36(argument2.X or 0, argument3), callback36(argument2.Y or 0, argument3))
			end

			local function callback38(argument, argument2, argument3)
				callback37(argument2, argument3, argument.u)
				if argument3.Visible ~= nil then
					argument2.Visible = argument3.Visible ~= false
				end
				local value21 = callback32(argument3.Background)
				if value21 then
					argument2.BackgroundColor3, argument2.BackgroundTransparency = value21, callback33(argument3.BackgroundTransparency, 0)
				elseif argument3.BackgroundTransparency ~= nil then
					argument2.BackgroundTransparency = callback33(argument3.BackgroundTransparency, 1)
				end
				if argument3.Corner ~= nil then
					destroyAll(argument2, argument3.Corner * argument.u)
				end
			end

			local function callback39(argument, argument2)
				argument.pa[#argument.pa + 1] = argument2
				argument.dirty = true
			end
			local function attach(argument, argument2, argument3)
				argument3 = if type(argument3) == "table" then argument3.Get() else argument3
				argument.pp[#argument.pp + 1] = {argument2, argument3 or argument.root}
				argument.dirty = true
			end

			local function callback40(argument, argument2, argument3, argument4)
				attach(argument, argument2, argument3.Parent)
				local data4 = {Spec = argument3, Apply = argument4, Get = function()
					return argument2
				end}

				data4.Set = function(argument5)
					for k, value21 in next, argument5, nil do
						argument3[k] = value21
					end
					callback39(argument, data4)
					return data4
				end

				argument.el[#argument.el + 1] = data4
				callback39(argument, data4)
				return data4
			end

			local function callback41(argument, argument2, argument3, argument4)
				argument2.Text, argument2.FontFace, argument2.TextSize, argument2.TextColor3 = value12(argument3.Text or ""), getFont(argument3.Font), max(6, floor((argument.ts * (argument3.Scale or 1)) + 0.5)), callback32(argument3.Color, argument4)
			end

			index3.Frame = function(argument, argument2)
				local frame2 = getFrame({n = argument2.Name or "Panel", B = value2, T = 1, Z = 6})
				return callback40(argument, frame2, argument2, function()
					callback38(argument, frame2, argument2)
					callback35(frame2, argument2, value2, 0.06, argument.u, border)
					callback34(frame2, argument2.Gradient, argument2.GradientRotation)
				end)
			end

			index3.Text = function(argument, argument2)
				local TextLabel = number("TextLabel", {n = argument2.Name or "Text", RichText = true, Z = argument2.ZIndex or 7})

				return callback40(argument, TextLabel, argument2, function()
					callback41(argument, TextLabel, argument2, argument.sty.TextColor)
					TextLabel.TextWrapped, TextLabel.LineHeight, TextLabel.TextStrokeTransparency, TextLabel.TextXAlignment, TextLabel.TextYAlignment = argument2.Wrap ~= false, argument.lh, callback33(argument2.TextStrokeTransparency, argument.sty.TextStrokeTransparency), data3[argument2.Align] or left, ((argument2.VAlign == "center") and scrollingFrame.TextYAlignment.Center) or scrollingFrame.TextYAlignment.Top
					callback34(TextLabel, argument2.Gradient, argument2.GradientRotation)
					callback35(TextLabel, argument2, value2, 0.1, TextLabel.TextSize, contextual)
					callback38(argument, TextLabel, argument2)
				end)
			end

			index3.Button = function(argument, argument2)
				local textButton, condition2, condition3 = getTextButton({n = "Button", B = callback32(argument2.Background, value2), RichText = true, Z = 8}), false, false
				local function callback42()
					local value21 = callback33(argument2.BackgroundTransparency, 0.35)
					local condition4 = (condition3 and callback33(argument2.PressTransparency, value21 - 0.18)) or (condition2 and callback33(argument2.HoverTransparency, value21 - 0.12))
					textButton.BackgroundTransparency = condition4 or value21
				end

				local value21 = callback40(argument, textButton, argument2, function()
					callback41(argument, textButton, argument2, value)
					callback35(textButton, argument2, value2, 0.05, argument.u, border, true)
					destroyAll(textButton, (argument2.Corner or 0.3) * argument.u)
					callback37(textButton, argument2, argument.u)
					callback42()
				end)

				trackConnection(textButton.MouseEnter, function()
					condition2 = true
					callback42()
				end)
				trackConnection(textButton.MouseLeave, function()
					condition2, condition3 = false, false
					callback42()
				end)
				trackConnection(textButton.MouseButton1Down, function()
					condition3 = true
					callback42()
				end)
				trackConnection(textButton.MouseButton1Up, function()
					condition3 = false
					callback42()
				end)
				trackConnection(textButton.Activated, function()
					pcall(argument2.Callback, value21)
				end)
				return value21
			end

			index3.Image = function(argument, argument2)
				local ImageLabel = number("ImageLabel", {n = "Image", B = value2, T = 1, ScaleType = scrollingFrame.ScaleType.Fit, Z = argument2.ZIndex or 7})
				return callback40(argument, ImageLabel, argument2, function()
					ImageLabel.Image = value12(argument2.Image or "")
					callback38(argument, ImageLabel, argument2)
					callback35(ImageLabel, argument2, value, 0.08, argument.u, border)
					destroyAll(ImageLabel, (argument2.Corner or 0.3) * argument.u)
				end)
			end

			index3.Bar = function(argument, argument2)
				local frame2 = getFrame({n = "Bar", C = true, Z = 7})
				local frame3 = getFrame({p = frame2, n = "Fill", S = uDim2FromScale(0, 1), Z = 8})

				return callback40(argument, frame2, argument2, function()
					callback38(argument, frame2, argument2)
					frame3.BackgroundColor3, frame3.Size = callback32(argument2.FillColor, value3), uDim2FromScale(callback33(argument2.Alpha, 0), 1)
					local number15 = (argument2.Corner or 0.16) * argument.u
					destroyAll(frame2, number15)
					destroyAll(frame3, number15)
				end)
			end

			index3.Root = function(argument)
				return argument.root
			end
			index3.Dock = function(argument)
				return argument.dock
			end
			index3.Unit = function(argument)
				return argument.u
			end
			index3.Width = function(argument)
				return argument.w
			end
			index3.TextSize = function(argument)
				return argument.ts
			end
			index3.Query = function(argument)
				return argument.query
			end

			index3.SetDock = function(argument, argument2, argument3)
				argument.du, argument.dg = max(0, argument2), argument3.Gap
				argument.dirty = true
				if argument3.Divider ~= nil then
					argument.dr = argument3.Divider ~= false
				end
			end

			index3.SetContentLines = function(argument, argument2)
				argument.ch = ceil(argument2 * argument.u)
				argument.dirty = true
			end
			index3.OnResize = function(argument, argument2)
				argument.rh[#argument.rh + 1] = argument2
			end
			index3.Attach = attach

			local function callback42(argument)
				for i = #argument.pp, 1, -1 do
					local value21 = argument.pp[i]
					if value21[1].Parent == nil then
						if value21[2].Parent ~= nil then
							value21[1].Parent = value21[2]
						end
					end
					if value21[1].Parent ~= nil then
						table.remove(argument.pp, i)
					end
				end
			end

			local function callback43(argument)
				local gameRef = game
				if not (argument:IsDescendantOf(gameRef)) then
					return false
				end

				while argument do
					if argument:IsA("GuiObject") then
						if not (argument.Visible) then
							return false
						end
					end
					if argument:IsA("LayerCollector") then
						return argument.Enabled
					end
					argument = argument.Parent
				end

				return false
			end

			widgetSpecs.Surface = function(argument, argument2)
				local style = argument2.Style
				local visible = argument2.ShowTitle ~= false
				local condition2 = argument2.Search == true
				local value21 = argument:Row(argument2.Name)
				value21.canvas = true
				value21.ratio = nil
				local r = value21.r
				local m = value21.m
				local lb = value21.lb
				local uiStroke = m:FindFirstChildOfClass("UIStroke")
				m.ClipsDescendants, m.BackgroundTransparency, uiStroke.Transparency, lb.AnchorPoint = true, style.BackgroundTransparency, style.StrokeTransparency or 0, vector2New(0, 0)
				lb.Visible = visible
				pcall(function()
					uiStroke.StrokeSizingMode = scrollingFrame.StrokeSizingMode.FixedSize
				end)
				local frame2 = getFrame({p = m, n = "SearchField", A = value4, B = value2, T = 0.6, V = condition2, Z = 4, callback4(0.1)})
				local value22 = callback5(number("TextBox", {p = frame2, n = "SearchInput", A = value4, P = value8, S = uDim2FromScale(0.9, 0.56), PH = argument2.SearchPlaceholder or "Search...", PC3 = value18, Z = 5}))
				local ScrollingFrame = number("ScrollingFrame", {p = m, n = "CanvasScroll", a = true, T = 1, CanvasSize = uDim2New(), ElasticBehavior = scrollingFrame.ElasticBehavior.Never, ScrollBarImageColor3 = style.ScrollBarColor or value, ScrollingDirection = scrollingFrame.ScrollingDirection.Y, Z = 5})
				local frame3 = getFrame({p = m, n = "CanvasDock", T = 1, V = false, Z = 7})
				local frame4 = getFrame({p = m, n = "CanvasDockRule", B = color3FromRGB(170, 174, 184), V = false, Z = 7})
				local frame5 = getFrame({p = ScrollingFrame, n = "CanvasRoot", AutomaticSize = scrollingFrame.AutomaticSize.Y, T = 1, S = toUDim2(0), Z = 6})
				local object = setmetatable({sty = style, root = frame5, dock = frame3, el = {}, pp = {}, pa = {}, rh = {}, b = argument2.Build, u = 16, ts = 13, lh = style.LineHeight, w = 0, query = "", du = 0, dr = true, dirty = true}, index3)

				local function callback44()
					local parent, width = r.Parent, r.AbsoluteSize.X

					if parent then
						if width <= 0 then
							return
						end
					else
						return
					end

					local number15 = (parent.AbsoluteSize.X * number7) / number5
					local number16, number17 = (number15 / 10) * 0.85, width * 0.025
					local number18, value23 = (number16 * 0.2) * (style.Padding or 1), max(8, floor(((number15 * 0.026) * style.TextScale) + 0.5))
					local u, value24 = value23 * style.LineHeight, max(1, width - (number17 * 2))
					object.ts = value23
					object.u = u
					object.w = value24
					uiStroke.Thickness = max(1, number16 * 0.05)
					local number19, number20 = width * 0.28, width * 0.845
					if condition2 then
						frame2.Size, frame2.Position = uDim2FromOffset(number19, number16 * 0.62), uDim2FromOffset(number20, number16 / 2)
					end
					parent = number16 * 0.64
					lb.Position, lb.Size = uDim2FromOffset(number17, (number16 - parent) / 2), uDim2FromOffset(max(1, ((condition2 and ((number20 - (number19 / 2)) - number17)) or (width - number17)) - number17), parent)
					parent = ((visible or condition2) and number16) or number18

					if object.du > 0 then
						width, number19, number20 = callback36(object.du, u), callback36(object.dg, u), (object.dr and max(1, floor((value23 * 0.12) + 0.5))) or 0
						frame3.Visible, frame3.Position, frame3.Size = true, uDim2FromOffset(number17, parent), uDim2FromOffset(value24, width)
						frame4.Visible = number20 > 0
						if number20 > 0 then
							frame4.Position, frame4.Size = uDim2FromOffset(number17, (parent + width) + number19), uDim2FromOffset(value24, number20)
							parent += (width + (number19 * 2)) + number20
						else
							parent += width + number19
						end
					else
						frame3.Visible = false
						frame4.Visible = false
					end

					callback42(object)
					number20 = object.b
					if number20 then
						object.b = nil
						callback12(number20, object, value24, u)
					end
					for _, value25 in ipairs(object.rh) do
						callback12(value25, object, value24, u)
					end
					callback42(object)
					for _, value25 in ipairs(object.el) do
						pcall(value25.Apply)
					end
					number19 = max(object.ch or ceil(frame5.AbsoluteSize.Y), ceil(u * style.MinLines), 1)
					number20 = min(number19, ceil(u * floor(style.MaxLines)))
					width = number19 > (number20 + 0.5)
					ScrollingFrame.Position, ScrollingFrame.Size, ScrollingFrame.CanvasSize = uDim2FromOffset(number17, parent), uDim2FromOffset(value24, number20), uDim2FromOffset(0, number19)
					ScrollingFrame.ScrollBarThickness = (width and max(2, floor((number15 * 0.006) + 0.5))) or 0
					ScrollingFrame.ScrollingEnabled = width
					value23 = max(1, ceil((parent + number20) + number18))
					m.Size = toUDim2(value23)
					r.Size = uDim2New(number7, 0, 0, value23 + ceil((number16 * 0.15) / 0.85))
				end

				value21.fit = function()
					object.dirty = true
				end
				local number15 = -1
				local number16 = -1
				callback3(r, "AbsoluteSize", function()
					if abs(r.AbsoluteSize.X - number15) >= 0.5 then
						number15 = r.AbsoluteSize.X
						object.dirty = true
					end
				end)
				callback3(frame5, "AbsoluteSize", function()
					if abs(frame5.AbsoluteSize.Y - number16) >= 0.5 then
						number16 = frame5.AbsoluteSize.Y
						object.dirty = true
					end
				end)
				callback19(value21.fit)

				callback3(value22, "Text", function()
					if object.query ~= value22.Text then
						object.query = value22.Text
						object.dirty = true
						pcall(argument2.OnSearch, object, object.query)
					end
				end)

				trackConnection(value22.Focused, function()
					callback9(frame2, 0.42, 0.16)
				end)
				trackConnection(value22.FocusLost, function()
					callback9(frame2, 0.6, 0.16)
				end)
				local number17, condition3, number18 = 0.2, true, 0

				trackConnection(RunService.Heartbeat, function(deltaTime)
					if r.Parent == nil then
						return
					end
					number17 += deltaTime
					if number17 >= 0.2 then
						number17 = 0
						condition3 = callback43(r)
					end
					if #object.pp > 0 then
						callback42(object)
						object.dirty = true
					end

					if #object.pa > 0 then
						for _, value23 in ipairs(object.pa) do
							pcall(value23.Apply)
						end
						table.clear(object.pa)
						object.dirty = true
					end

					if object.dirty then
						if condition3 then
							if (os.clock() - number18) >= 0.1 then
								deltaTime = os.clock()
								object.dirty = false
								number18 = deltaTime
								local ok, response = pcall(callback44)

								if not (ok) then
									object.dirty = true
									if not (object.warned) then
										object.warned = true
										warn("[Chilli] canvas " .. value12(response))
										data.errs[#data.errs + 1] = "canvas " .. value12(response)
									end
								end
							end
						end
					end
				end)
			end

			widgetSpecs.CreateCanvas = widgetSpecs.Surface
			widgetSpecs.CreateText = function(argument, argument2)
				return argument:Text(argument2.Name, argument2.Text)
			end
			widgetSpecs.CreateToggle = function(argument, argument2)
				return argument:Toggle(argument2.Name, argument2.Default, argument2.Callback, argument2.Note)
			end
			widgetSpecs.CreateDropdown = function(argument, argument2)
				return argument:Dropdown(argument2.Name, argument2.Options, argument2.Default, argument2.Callback, argument2.Multi, argument2.Note)
			end
		end

		return data
	end

	createUiLibrary()
	pcall(getgenv().ChilliHubLoadStep, 1)
	local function callback3(...) end
	callback3()

	local function callback4()
		game:GetService("HttpService")
		local localPlayer = game:GetService("Players").LocalPlayer

		if getgenv then
			local genv = getgenv()
			if genv then
				if not genv.StopChilliLink then
					return nil, nil
				end
				-- devirt: spin loop left out (it decoded to no statements)
			end
		end
		-- devirt: spin loop left out (it decoded to no statements)
	end

	callback4(60703121)
end

callback(467999930)

print("Deobf By Zed")
