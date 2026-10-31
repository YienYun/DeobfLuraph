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
local tbl = nil
local v = nil
local v2 = nil
local fn = nil
local fn2 = v
local v22 = v2
local v3 = task
local cancel = v3.cancel
local spawn = v3.spawn
local defer = v3.defer
local delay = v3.delay
local wait = v3.wait
local v4 = Instance
local v5 = Vector3
local v6 = Vector2
local v7 = CFrame
local v8 = Random
local n = identifyexecutor
local v9 = loadstring
local tbl2 = { 218, 28, 16, 96, 36, 87, 244, 124, 145, 187, 228, 126 }
local tbl3 = {}
local n2 = 0

local function fn3(arg)
	n2 += 1
	tbl3[n2] = arg % 256
end

local n3 = 343609641

local function fn4(arg, arg2)
	local n4, n5

	if nil then
		n4 = 1
		n5 = 1
		n3 = bit32.bxor(n3, 3784272397)
	else
		n4 = 1
		n5 = 1
	end

	local n6 = n5 + 0
	local tbl4 = { n4 - n6, nil, arg2 + 0, n6, nil }

	while true do
		local v10 = tbl4[4]
		local v11 = tbl4[3]
		local n7 = tbl4[1] + v10
		tbl4[1] = n7

		if n7 <= v11 then
			local n8 = arg % 256
			arg = (arg - n8) / 256
			n2 += 1
			tbl3[n2] = n8
		else
			break
		end
	end
end

local v10 = assert(debug, "The debug library is required on Luau platforms. Please open a support ticket.")
local info = v10.info
local traceback = v10.traceback
local n4 = 77215353
n3 = 319702956

local function fn5()
	local function fn6(arg, arg2, arg3, arg4, arg5)
		local tbl4 = { arg2, arg3, arg4, arg5 }
		local n5 = 54517094
		local tbl5 = { 1, 4, nil, 0, nil }
		local v11, n6, n7, n8, n9, v112, v113, v114, v12, v115, v122, v116

		while true do
			local v13 = tbl5[1]
			local v14 = tbl5[2]
			local n10 = tbl5[4] + v13
			local flag = v13 <= 0
			local flag2 = not flag
			local flag3 = n10 >= v14
			local flag4 = n10 <= v14
			local v15, tbl6, v16, v17, n11, n112, n52, n53, n54, v18, n12, n55, n56, n13, v19, n14, n15, v20, n16, n142, n17, n18, n19, v21, n182, v23, n20, n172, n183, n21, n184, n22, n222, n223, v24, v25, n224, n23, v26, v27, n24, n225, n226, n25, v28, n26, v29

			if flag then
				if flag2 then
					if flag3 then
						tbl5[4] = n10

						if flag3 then
							v15 = tbl4[n10]
							tbl6 = { 0, #v15 + 0, nil, tbl5, 1 }

							while true do
								v16 = tbl6[5]
								v17 = tbl6[2]
								n11 = tbl6[1] + v16
								tbl6[1] = n11

								if n11 <= v17 then
									n112 = n11
									n52 = bit32.lshift(bit32.band(n5, n112), 1)
									n53 = bit32.band(n52, n5)
									n54 = bit32.bnot(n53)
									local n57 = table.pack(bit32.band(n52, 4294967295))
									local n58 = table.pack(bit32.band(n54, 4294967295))
									local v30 = table.pack(bit32.band(n57[1], 65535))
									local v31 = table.pack(bit32.rshift(n57[1], 16))
									local v32 = table.pack(bit32.band(n58[1], 65535))
									local v33 = table.pack(bit32.band(bit32.band(v30[1] * v32[1] + bit32.lshift(bit32.band(v30[1] * bit32.rshift(n58[1], 16) + v31[1] * v32[1], 65535), 16), 4294967295), 4294967295))
									local v34 = table.pack(bit32.band(v33[1], 65535))
									v18 = bit32.band(19474 * v34[1] + bit32.lshift(bit32.band(19474 * bit32.rshift(v33[1], 16) + 39469 * v34[1], 65535), 16), 4294967295)
									local n59 = table.pack(bit32.band(n52, 4294967295))
									local v35 = table.pack(bit32.band(n59[1], 65535))
									n12 = n112 + n5 + v18 + bit32.band(23587 * v35[1] + bit32.lshift(bit32.band(23587 * bit32.rshift(n59[1], 16) + 21404 * v35[1], 65535), 16), 4294967295)
									n55 = bit32.bnot(n5)
									n56 = bit32.bor(n55, 54517094)
									local n510 = table.pack(bit32.band(n52, 4294967295))
									local n511 = table.pack(bit32.band(n56, 4294967295))
									local v36 = table.pack(bit32.band(n510[1], 65535))
									local v37 = table.pack(bit32.rshift(n510[1], 16))
									local v38 = table.pack(bit32.band(n511[1], 65535))
									local v39 = table.pack(bit32.band(bit32.band(v36[1] * v38[1] + bit32.lshift(bit32.band(v36[1] * bit32.rshift(n511[1], 16) + v37[1] * v38[1], 65535), 16), 4294967295), 4294967295))
									local v40 = table.pack(bit32.band(v39[1], 65535))
									n13 = 1402756132 + bit32.band(46062 * v40[1] + bit32.lshift(bit32.band(46062 * bit32.rshift(v39[1], 16) + 26066 * v40[1], 65535), 16), 4294967295)
									local n512 = table.pack(bit32.band(bit32.bnot(n52), 4294967295))
									local v41 = table.pack(bit32.band(n512[1], 65535))
									v19 = bit32.band(23586 * v41[1] + bit32.lshift(bit32.band(23586 * bit32.rshift(n512[1], 16) + 21404 * v41[1], 65535), 16), 4294967295)
									local v42 = table.pack(bit32.band(bit32.bor(54517095, n55), 4294967295))
									local v43 = table.pack(bit32.band(v42[1], 65535))
									n14 = n12 + n13 + v19 + bit32.band(2 * v43[1] + bit32.lshift(bit32.band(2 * bit32.rshift(v42[1], 16) + 0 * v43[1], 65535), 16), 4294967295)
									local n143 = table.pack(bit32.band(n14, 4294967295))
									local v44 = table.pack(bit32.band(n143[1], 65535))
									n15 = 327058238 + 3859571462 + bit32.band(25350 * v44[1] + bit32.lshift(bit32.band(25350 * bit32.rshift(n143[1], 16) + 58892 * v44[1], 65535), 16), 4294967295)
									v20 = bit32.bor(2147483647, n14)
									local v45 = table.pack(bit32.band(bit32.band(272719449, v20), 4294967295))
									local v46 = table.pack(bit32.band(v45[1], 65535))
									n16 = n15 + 375472684 + bit32.band(14836 * v46[1] + bit32.lshift(bit32.band(14836 * bit32.rshift(v45[1], 16) + 13287 * v46[1], 65535), 16), 4294967295) + 1761712016
									n142 = bit32.bnot(n14)
									local v47 = table.pack(bit32.band(bit32.bor(2092966552, n142), 4294967295))
									local v48 = table.pack(bit32.band(v47[1], 65535))
									local v49 = table.pack(bit32.band(n16 - 4564062016 + 28981759 + bit32.band(50689 * v48[1] + bit32.lshift(bit32.band(50689 * bit32.rshift(v47[1], 16) + 32325 * v48[1], 65535), 16), 4294967295) + 1195411303, 4294967295))
									local v50 = table.pack(bit32.band(v49[1], 65535))
									n17 = bit32.band(31367 * v50[1] + bit32.lshift(bit32.band(31367 * bit32.rshift(v49[1], 16) + 21986 * v50[1], 65535), 16), 4294967295) + 21801894718
									v15[n112] = bit32.bxor(v15[n112], 327058238)
									n18 = n5 + 584826193
									local n185 = table.pack(bit32.band(n18, 4294967295))
									local v51 = table.pack(bit32.band(n185[1], 65535))
									n19 = bit32.band(43296 * v51[1] + bit32.lshift(bit32.band(43296 * bit32.rshift(n185[1], 16) + 12122 * v51[1], 65535), 16), 4294967295) + 1588941376
									local n113 = table.pack(bit32.band(n112, 4294967295))
									local v52 = table.pack(bit32.band(n113[1], 65535))
									v21 = bit32.band(v52[1] * 62187 + bit32.lshift(bit32.band(v52[1] * 8557 + bit32.rshift(n113[1], 16) * 62187, 65535), 16), 4294967295)
									n182 = bit32.band(n18, n17)
									local v212 = table.pack(bit32.band(v21, 4294967295))
									local n186 = table.pack(bit32.band(n182, 4294967295))
									local v53 = table.pack(bit32.band(v212[1], 65535))
									local v54 = table.pack(bit32.rshift(v212[1], 16))
									local v55 = table.pack(bit32.band(n186[1], 65535))
									local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n186[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
									local v57 = table.pack(bit32.band(v56[1], 65535))
									v23 = bit32.band(51485 * v57[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v56[1], 16) + 39315 * v57[1], 65535), 16), 4294967295)
									local v213 = table.pack(bit32.band(v21, 4294967295))
									local v58 = table.pack(bit32.band(v213[1], 65535))
									n20 = n19 + v23 + bit32.band(29245 * v58[1] + bit32.lshift(bit32.band(29245 * bit32.rshift(v213[1], 16) + 51438 * v58[1], 65535), 16), 4294967295)
									n172 = bit32.band(n17, 272719449)
									n183 = bit32.bnot(n182)
									local v214 = table.pack(bit32.band(v21, 4294967295))
									local n187 = table.pack(bit32.band(n183, 4294967295))
									local v59 = table.pack(bit32.band(v214[1], 65535))
									local v60 = table.pack(bit32.rshift(v214[1], 16))
									local v61 = table.pack(bit32.band(n187[1], 65535))
									local v62 = table.pack(bit32.band(bit32.band(v59[1] * v61[1] + bit32.lshift(bit32.band(v59[1] * bit32.rshift(n187[1], 16) + v60[1] * v61[1], 65535), 16), 4294967295), 4294967295))
									local v63 = table.pack(bit32.band(v62[1], 65535))
									n21 = n172 + bit32.band(51485 * v63[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v62[1], 16) + 39315 * v63[1], 65535), 16), 4294967295)
									n184 = bit32.bor(n18, v21)
									local n188 = table.pack(bit32.band(bit32.bnot(n184), 4294967295))
									local v64 = table.pack(bit32.band(n188[1], 65535))
									n22 = n20 + n21 + 3045076956 + bit32.band(21056 * v64[1] + bit32.lshift(bit32.band(21056 * bit32.rshift(n188[1], 16) + 24245 * v64[1], 65535), 16), 4294967295)
									n222 = bit32.band(n22, 2147483647)
									n223 = bit32.bnot(n222)
									local n227 = table.pack(bit32.band(n223, 4294967295))
									local v65 = table.pack(bit32.band(n227[1], 65535))
									v24 = bit32.band(65535 * v65[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n227[1], 16) + 65535 * v65[1], 65535), 16), 4294967295)
									local n228 = table.pack(bit32.band(n22, 4294967295))
									local v66 = table.pack(bit32.band(n228[1], 65535))
									v25 = bit32.band(46641 * v66[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n228[1], 16) + 36583 * v66[1], 65535), 16), 4294967295)
									n224 = bit32.bnot(n22)
									local n229 = table.pack(bit32.band(n224, 4294967295))
									local v67 = table.pack(bit32.band(n229[1], 65535))
									n23 = 2397550128 + v24 + v25 + bit32.band(46641 * v67[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n229[1], 16) + 36583 * v67[1], 65535), 16), 4294967295)
									local n2210 = table.pack(bit32.band(n22, 4294967295))
									local v68 = table.pack(bit32.band(n2210[1], 65535))
									v26 = bit32.band(1004 * v68[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2210[1], 16) + 49886 * v68[1], 65535), 16), 4294967295)
									local n2211 = table.pack(bit32.band(n224, 4294967295))
									local v69 = table.pack(bit32.band(n2211[1], 65535))
									local v70 = table.pack(bit32.band(n23 - 3269329899 + v24 + v26 + bit32.band(1004 * v69[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2211[1], 16) + 49886 * v69[1], 65535), 16), 4294967295), 4294967295))
									local v71 = table.pack(bit32.band(v70[1], 65535))
									v27 = bit32.band(21218 * v71[1] + bit32.lshift(bit32.band(21218 * bit32.rshift(v70[1], 16) + 47856 * v71[1], 65535), 16), 4294967295)
									local n2212 = table.pack(bit32.band(n22, 4294967295))
									local n2213 = table.pack(bit32.band(n223, 4294967295))
									local v72 = table.pack(bit32.band(n2212[1], 65535))
									local v73 = table.pack(bit32.rshift(n2212[1], 16))
									local v74 = table.pack(bit32.band(n2213[1], 65535))
									local v75 = table.pack(bit32.band(bit32.band(v72[1] * v74[1] + bit32.lshift(bit32.band(v72[1] * bit32.rshift(n2213[1], 16) + v73[1] * v74[1], 65535), 16), 4294967295), 4294967295))
									local v76 = table.pack(bit32.band(v75[1], 65535))
									n24 = 2669559910 + bit32.band(64492 * v76[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v75[1], 16) + 27898 * v76[1], 65535), 16), 4294967295)
									local n2214 = table.pack(bit32.band(n22, 4294967295))
									local v77 = table.pack(bit32.band(n2214[1], 65535))
									n225 = n223
									n226 = bit32.bor(n22, 2147483647)
									n25 = n24 + bit32.band(16487 * v77[1] + bit32.lshift(bit32.band(16487 * bit32.rshift(n2214[1], 16) + 40734 * v77[1], 65535), 16), 4294967295) + 0
									local n2215 = table.pack(bit32.band(n225, 4294967295))
									local v78 = table.pack(bit32.band(n2215[1], 65535))
									v28 = bit32.band(15442 * v78[1] + bit32.lshift(bit32.band(15442 * bit32.rshift(n2215[1], 16) + 3097 * v78[1], 65535), 16), 4294967295)
									local n2216 = table.pack(bit32.band(n225, 4294967295))
									local n2217 = table.pack(bit32.band(n225, 4294967295))
									local v79 = table.pack(bit32.band(n2216[1], 65535))
									local v80 = table.pack(bit32.rshift(n2216[1], 16))
									local v81 = table.pack(bit32.band(n2217[1], 65535))
									local v82 = table.pack(bit32.band(bit32.band(v79[1] * v81[1] + bit32.lshift(bit32.band(v79[1] * bit32.rshift(n2217[1], 16) + v80[1] * v81[1], 65535), 16), 4294967295), 4294967295))
									local v83 = table.pack(bit32.band(v82[1], 65535))
									n26 = v28 + bit32.band(64492 * v83[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v82[1], 16) + 27898 * v83[1], 65535), 16), 4294967295)
									local n2218 = table.pack(bit32.band(n22, 4294967295))
									local v84 = table.pack(bit32.band(n2218[1], 65535))
									local v85 = table.pack(bit32.band(bit32.band(v84[1] * 0 + bit32.lshift(bit32.band(v84[1] * 0 + bit32.rshift(n2218[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
									local v86 = table.pack(bit32.band(v85[1], 65535))
									v29 = bit32.band(64492 * v86[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v85[1], 16) + 27898 * v86[1], 65535), 16), 4294967295)
									local n2219 = table.pack(bit32.band(n226, 4294967295))
									local v87 = table.pack(bit32.band(n2219[1], 65535))
									local v88 = table.pack(bit32.band(bit32.band(v87[1] * 0 + bit32.lshift(bit32.band(v87[1] * 0 + bit32.rshift(n2219[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
									local v89 = table.pack(bit32.band(v88[1], 65535))
									n5 = v27 + n25 + n26 + 0 + v29 + bit32.band(1044 * v89[1] + bit32.lshift(bit32.band(1044 * bit32.rshift(v88[1], 16) + 37637 * v89[1], 65535), 16), 4294967295)
								else
									break
								end
							end

							tbl5 = tbl6[4]
							continue
						end

						v11 = arg[6]
						n6 = buffer.len(v11) - 32 - 19
						n7 = 32 + 888971832 % n6
						n8 = 32

						while true do
							n9 = n8 + (n7 + bit32.band(n5, 255) + 1) % n6
							v112 = buffer.readi8(v11, n7)
							v113 = buffer.readu8(v11, n9)
							v114 = bit32.lshift(bit32.band(v113, 255), 3)
							v12 = bit32.band(bit32.bxor(bit32.bxor(54517094, v112) + v114 + 584826193, n7), 2147483647)
							v115 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v112, v113), v12), 2147483647), 205469696)
							buffer.writeu32(v11, n7, v115)
							v122 = bit32.rshift(v12, 8)
							v116 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v113, v122), n7), 2147483647), 327527424)
							buffer.writeu8(v11, n9, v116)
							n5 = v12
							n7 = n8 + (n7 + bit32.band(v12, 63) + 1) % n6
						end
					else
						flag3 = flag4
						tbl5[4] = n10

						if flag3 then
							v15 = tbl4[n10]
							tbl6 = { 0, #v15 + 0, nil, tbl5, 1 }

							while true do
								v16 = tbl6[5]
								v17 = tbl6[2]
								n11 = tbl6[1] + v16
								tbl6[1] = n11

								if n11 <= v17 then
									n112 = n11
									n52 = bit32.lshift(bit32.band(n5, n112), 1)
									n53 = bit32.band(n52, n5)
									n54 = bit32.bnot(n53)
									local v123 = table.pack(bit32.band(n52, 4294967295))
									local v124 = table.pack(bit32.band(n54, 4294967295))
									local v30 = table.pack(bit32.band(v123[1], 65535))
									local v31 = table.pack(bit32.rshift(v123[1], 16))
									local v32 = table.pack(bit32.band(v124[1], 65535))
									local v33 = table.pack(bit32.band(bit32.band(v30[1] * v32[1] + bit32.lshift(bit32.band(v30[1] * bit32.rshift(v124[1], 16) + v31[1] * v32[1], 65535), 16), 4294967295), 4294967295))
									local v34 = table.pack(bit32.band(v33[1], 65535))
									v18 = bit32.band(19474 * v34[1] + bit32.lshift(bit32.band(19474 * bit32.rshift(v33[1], 16) + 39469 * v34[1], 65535), 16), 4294967295)
									local v125 = table.pack(bit32.band(n52, 4294967295))
									local v35 = table.pack(bit32.band(v125[1], 65535))
									n12 = n112 + n5 + v18 + bit32.band(23587 * v35[1] + bit32.lshift(bit32.band(23587 * bit32.rshift(v125[1], 16) + 21404 * v35[1], 65535), 16), 4294967295)
									n55 = bit32.bnot(n5)
									n56 = bit32.bor(n55, 54517094)
									local v126 = table.pack(bit32.band(n52, 4294967295))
									local v127 = table.pack(bit32.band(n56, 4294967295))
									local v36 = table.pack(bit32.band(v126[1], 65535))
									local v37 = table.pack(bit32.rshift(v126[1], 16))
									local v38 = table.pack(bit32.band(v127[1], 65535))
									local v39 = table.pack(bit32.band(bit32.band(v36[1] * v38[1] + bit32.lshift(bit32.band(v36[1] * bit32.rshift(v127[1], 16) + v37[1] * v38[1], 65535), 16), 4294967295), 4294967295))
									local v40 = table.pack(bit32.band(v39[1], 65535))
									n13 = 1402756132 + bit32.band(46062 * v40[1] + bit32.lshift(bit32.band(46062 * bit32.rshift(v39[1], 16) + 26066 * v40[1], 65535), 16), 4294967295)
									local v128 = table.pack(bit32.band(bit32.bnot(n52), 4294967295))
									local v41 = table.pack(bit32.band(v128[1], 65535))
									v19 = bit32.band(23586 * v41[1] + bit32.lshift(bit32.band(23586 * bit32.rshift(v128[1], 16) + 21404 * v41[1], 65535), 16), 4294967295)
									local v42 = table.pack(bit32.band(bit32.bor(54517095, n55), 4294967295))
									local v43 = table.pack(bit32.band(v42[1], 65535))
									n14 = n12 + n13 + v19 + bit32.band(2 * v43[1] + bit32.lshift(bit32.band(2 * bit32.rshift(v42[1], 16) + 0 * v43[1], 65535), 16), 4294967295)
									local n143 = table.pack(bit32.band(n14, 4294967295))
									local v44 = table.pack(bit32.band(n143[1], 65535))
									n15 = 327058238 + 3859571462 + bit32.band(25350 * v44[1] + bit32.lshift(bit32.band(25350 * bit32.rshift(n143[1], 16) + 58892 * v44[1], 65535), 16), 4294967295)
									v20 = bit32.bor(2147483647, n14)
									local v45 = table.pack(bit32.band(bit32.band(272719449, v20), 4294967295))
									local v46 = table.pack(bit32.band(v45[1], 65535))
									n16 = n15 + 375472684 + bit32.band(14836 * v46[1] + bit32.lshift(bit32.band(14836 * bit32.rshift(v45[1], 16) + 13287 * v46[1], 65535), 16), 4294967295) + 1761712016
									n142 = bit32.bnot(n14)
									local v47 = table.pack(bit32.band(bit32.bor(2092966552, n142), 4294967295))
									local v48 = table.pack(bit32.band(v47[1], 65535))
									local v49 = table.pack(bit32.band(n16 - 4564062016 + 28981759 + bit32.band(50689 * v48[1] + bit32.lshift(bit32.band(50689 * bit32.rshift(v47[1], 16) + 32325 * v48[1], 65535), 16), 4294967295) + 1195411303, 4294967295))
									local v50 = table.pack(bit32.band(v49[1], 65535))
									n17 = bit32.band(31367 * v50[1] + bit32.lshift(bit32.band(31367 * bit32.rshift(v49[1], 16) + 21986 * v50[1], 65535), 16), 4294967295) + 21801894718
									v15[n112] = bit32.bxor(v15[n112], 327058238)
									n18 = n5 + 584826193
									local n185 = table.pack(bit32.band(n18, 4294967295))
									local v51 = table.pack(bit32.band(n185[1], 65535))
									n19 = bit32.band(43296 * v51[1] + bit32.lshift(bit32.band(43296 * bit32.rshift(n185[1], 16) + 12122 * v51[1], 65535), 16), 4294967295) + 1588941376
									local n113 = table.pack(bit32.band(n112, 4294967295))
									local v52 = table.pack(bit32.band(n113[1], 65535))
									v21 = bit32.band(v52[1] * 62187 + bit32.lshift(bit32.band(v52[1] * 8557 + bit32.rshift(n113[1], 16) * 62187, 65535), 16), 4294967295)
									n182 = bit32.band(n18, n17)
									local v212 = table.pack(bit32.band(v21, 4294967295))
									local n186 = table.pack(bit32.band(n182, 4294967295))
									local v53 = table.pack(bit32.band(v212[1], 65535))
									local v54 = table.pack(bit32.rshift(v212[1], 16))
									local v55 = table.pack(bit32.band(n186[1], 65535))
									local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n186[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
									local v57 = table.pack(bit32.band(v56[1], 65535))
									v23 = bit32.band(51485 * v57[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v56[1], 16) + 39315 * v57[1], 65535), 16), 4294967295)
									local v213 = table.pack(bit32.band(v21, 4294967295))
									local v58 = table.pack(bit32.band(v213[1], 65535))
									n20 = n19 + v23 + bit32.band(29245 * v58[1] + bit32.lshift(bit32.band(29245 * bit32.rshift(v213[1], 16) + 51438 * v58[1], 65535), 16), 4294967295)
									n172 = bit32.band(n17, 272719449)
									n183 = bit32.bnot(n182)
									local v214 = table.pack(bit32.band(v21, 4294967295))
									local n187 = table.pack(bit32.band(n183, 4294967295))
									local v59 = table.pack(bit32.band(v214[1], 65535))
									local v60 = table.pack(bit32.rshift(v214[1], 16))
									local v61 = table.pack(bit32.band(n187[1], 65535))
									local v62 = table.pack(bit32.band(bit32.band(v59[1] * v61[1] + bit32.lshift(bit32.band(v59[1] * bit32.rshift(n187[1], 16) + v60[1] * v61[1], 65535), 16), 4294967295), 4294967295))
									local v63 = table.pack(bit32.band(v62[1], 65535))
									n21 = n172 + bit32.band(51485 * v63[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v62[1], 16) + 39315 * v63[1], 65535), 16), 4294967295)
									n184 = bit32.bor(n18, v21)
									local n188 = table.pack(bit32.band(bit32.bnot(n184), 4294967295))
									local v64 = table.pack(bit32.band(n188[1], 65535))
									n22 = n20 + n21 + 3045076956 + bit32.band(21056 * v64[1] + bit32.lshift(bit32.band(21056 * bit32.rshift(n188[1], 16) + 24245 * v64[1], 65535), 16), 4294967295)
									n222 = bit32.band(n22, 2147483647)
									n223 = bit32.bnot(n222)
									local n227 = table.pack(bit32.band(n223, 4294967295))
									local v65 = table.pack(bit32.band(n227[1], 65535))
									v24 = bit32.band(65535 * v65[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n227[1], 16) + 65535 * v65[1], 65535), 16), 4294967295)
									local n228 = table.pack(bit32.band(n22, 4294967295))
									local v66 = table.pack(bit32.band(n228[1], 65535))
									v25 = bit32.band(46641 * v66[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n228[1], 16) + 36583 * v66[1], 65535), 16), 4294967295)
									n224 = bit32.bnot(n22)
									local n229 = table.pack(bit32.band(n224, 4294967295))
									local v67 = table.pack(bit32.band(n229[1], 65535))
									n23 = 2397550128 + v24 + v25 + bit32.band(46641 * v67[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n229[1], 16) + 36583 * v67[1], 65535), 16), 4294967295)
									local n2210 = table.pack(bit32.band(n22, 4294967295))
									local v68 = table.pack(bit32.band(n2210[1], 65535))
									v26 = bit32.band(1004 * v68[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2210[1], 16) + 49886 * v68[1], 65535), 16), 4294967295)
									local n2211 = table.pack(bit32.band(n224, 4294967295))
									local v69 = table.pack(bit32.band(n2211[1], 65535))
									local v70 = table.pack(bit32.band(n23 - 3269329899 + v24 + v26 + bit32.band(1004 * v69[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2211[1], 16) + 49886 * v69[1], 65535), 16), 4294967295), 4294967295))
									local v71 = table.pack(bit32.band(v70[1], 65535))
									v27 = bit32.band(21218 * v71[1] + bit32.lshift(bit32.band(21218 * bit32.rshift(v70[1], 16) + 47856 * v71[1], 65535), 16), 4294967295)
									local n2212 = table.pack(bit32.band(n22, 4294967295))
									local n2213 = table.pack(bit32.band(n223, 4294967295))
									local v72 = table.pack(bit32.band(n2212[1], 65535))
									local v73 = table.pack(bit32.rshift(n2212[1], 16))
									local v74 = table.pack(bit32.band(n2213[1], 65535))
									local v75 = table.pack(bit32.band(bit32.band(v72[1] * v74[1] + bit32.lshift(bit32.band(v72[1] * bit32.rshift(n2213[1], 16) + v73[1] * v74[1], 65535), 16), 4294967295), 4294967295))
									local v76 = table.pack(bit32.band(v75[1], 65535))
									n24 = 2669559910 + bit32.band(64492 * v76[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v75[1], 16) + 27898 * v76[1], 65535), 16), 4294967295)
									local n2214 = table.pack(bit32.band(n22, 4294967295))
									local v77 = table.pack(bit32.band(n2214[1], 65535))
									n225 = n223
									n226 = bit32.bor(n22, 2147483647)
									n25 = n24 + bit32.band(16487 * v77[1] + bit32.lshift(bit32.band(16487 * bit32.rshift(n2214[1], 16) + 40734 * v77[1], 65535), 16), 4294967295) + 0
									local n2215 = table.pack(bit32.band(n225, 4294967295))
									local v78 = table.pack(bit32.band(n2215[1], 65535))
									v28 = bit32.band(15442 * v78[1] + bit32.lshift(bit32.band(15442 * bit32.rshift(n2215[1], 16) + 3097 * v78[1], 65535), 16), 4294967295)
									local n2216 = table.pack(bit32.band(n225, 4294967295))
									local n2217 = table.pack(bit32.band(n225, 4294967295))
									local v79 = table.pack(bit32.band(n2216[1], 65535))
									local v80 = table.pack(bit32.rshift(n2216[1], 16))
									local v81 = table.pack(bit32.band(n2217[1], 65535))
									local v82 = table.pack(bit32.band(bit32.band(v79[1] * v81[1] + bit32.lshift(bit32.band(v79[1] * bit32.rshift(n2217[1], 16) + v80[1] * v81[1], 65535), 16), 4294967295), 4294967295))
									local v83 = table.pack(bit32.band(v82[1], 65535))
									n26 = v28 + bit32.band(64492 * v83[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v82[1], 16) + 27898 * v83[1], 65535), 16), 4294967295)
									local n2218 = table.pack(bit32.band(n22, 4294967295))
									local v84 = table.pack(bit32.band(n2218[1], 65535))
									local v85 = table.pack(bit32.band(bit32.band(v84[1] * 0 + bit32.lshift(bit32.band(v84[1] * 0 + bit32.rshift(n2218[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
									local v86 = table.pack(bit32.band(v85[1], 65535))
									v29 = bit32.band(64492 * v86[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v85[1], 16) + 27898 * v86[1], 65535), 16), 4294967295)
									local n2219 = table.pack(bit32.band(n226, 4294967295))
									local v87 = table.pack(bit32.band(n2219[1], 65535))
									local v88 = table.pack(bit32.band(bit32.band(v87[1] * 0 + bit32.lshift(bit32.band(v87[1] * 0 + bit32.rshift(n2219[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
									local v89 = table.pack(bit32.band(v88[1], 65535))
									n5 = v27 + n25 + n26 + 0 + v29 + bit32.band(1044 * v89[1] + bit32.lshift(bit32.band(1044 * bit32.rshift(v88[1], 16) + 37637 * v89[1], 65535), 16), 4294967295)
								else
									break
								end
							end

							tbl5 = tbl6[4]
							continue
						end

						v11 = arg[6]
						n6 = buffer.len(v11) - 32 - 19
						n7 = 32 + 888971832 % n6
						n8 = 32

						while true do
							n9 = n8 + (n7 + bit32.band(n5, 255) + 1) % n6
							v112 = buffer.readi8(v11, n7)
							v113 = buffer.readu8(v11, n9)
							v114 = bit32.lshift(bit32.band(v113, 255), 3)
							v12 = bit32.band(bit32.bxor(bit32.bxor(54517094, v112) + v114 + 584826193, n7), 2147483647)
							v115 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v112, v113), v12), 2147483647), 205469696)
							buffer.writeu32(v11, n7, v115)
							v122 = bit32.rshift(v12, 8)
							v116 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v113, v122), n7), 2147483647), 327527424)
							buffer.writeu8(v11, n9, v116)
							n5 = v12
							n7 = n8 + (n7 + bit32.band(v12, 63) + 1) % n6
						end
					end
				end
			else
				flag3 = flag

				if flag2 then
					if not flag3 then
						flag3 = flag4
						tbl5[4] = n10

						if flag3 then
							v15 = tbl4[n10]
							tbl6 = { 0, #v15 + 0, nil, tbl5, 1 }

							while true do
								v16 = tbl6[5]
								v17 = tbl6[2]
								n11 = tbl6[1] + v16
								tbl6[1] = n11

								if n11 <= v17 then
									n112 = n11
									n52 = bit32.lshift(bit32.band(n5, n112), 1)
									n53 = bit32.band(n52, n5)
									n54 = bit32.bnot(n53)
									local v123 = table.pack(bit32.band(n52, 4294967295))
									local v124 = table.pack(bit32.band(n54, 4294967295))
									local v30 = table.pack(bit32.band(v123[1], 65535))
									local v31 = table.pack(bit32.rshift(v123[1], 16))
									local v32 = table.pack(bit32.band(v124[1], 65535))
									local v33 = table.pack(bit32.band(bit32.band(v30[1] * v32[1] + bit32.lshift(bit32.band(v30[1] * bit32.rshift(v124[1], 16) + v31[1] * v32[1], 65535), 16), 4294967295), 4294967295))
									local v34 = table.pack(bit32.band(v33[1], 65535))
									v18 = bit32.band(19474 * v34[1] + bit32.lshift(bit32.band(19474 * bit32.rshift(v33[1], 16) + 39469 * v34[1], 65535), 16), 4294967295)
									local v125 = table.pack(bit32.band(n52, 4294967295))
									local v35 = table.pack(bit32.band(v125[1], 65535))
									n12 = n112 + n5 + v18 + bit32.band(23587 * v35[1] + bit32.lshift(bit32.band(23587 * bit32.rshift(v125[1], 16) + 21404 * v35[1], 65535), 16), 4294967295)
									n55 = bit32.bnot(n5)
									n56 = bit32.bor(n55, 54517094)
									local v126 = table.pack(bit32.band(n52, 4294967295))
									local v127 = table.pack(bit32.band(n56, 4294967295))
									local v36 = table.pack(bit32.band(v126[1], 65535))
									local v37 = table.pack(bit32.rshift(v126[1], 16))
									local v38 = table.pack(bit32.band(v127[1], 65535))
									local v39 = table.pack(bit32.band(bit32.band(v36[1] * v38[1] + bit32.lshift(bit32.band(v36[1] * bit32.rshift(v127[1], 16) + v37[1] * v38[1], 65535), 16), 4294967295), 4294967295))
									local v40 = table.pack(bit32.band(v39[1], 65535))
									n13 = 1402756132 + bit32.band(46062 * v40[1] + bit32.lshift(bit32.band(46062 * bit32.rshift(v39[1], 16) + 26066 * v40[1], 65535), 16), 4294967295)
									local v128 = table.pack(bit32.band(bit32.bnot(n52), 4294967295))
									local v41 = table.pack(bit32.band(v128[1], 65535))
									v19 = bit32.band(23586 * v41[1] + bit32.lshift(bit32.band(23586 * bit32.rshift(v128[1], 16) + 21404 * v41[1], 65535), 16), 4294967295)
									local v42 = table.pack(bit32.band(bit32.bor(54517095, n55), 4294967295))
									local v43 = table.pack(bit32.band(v42[1], 65535))
									n14 = n12 + n13 + v19 + bit32.band(2 * v43[1] + bit32.lshift(bit32.band(2 * bit32.rshift(v42[1], 16) + 0 * v43[1], 65535), 16), 4294967295)
									local n143 = table.pack(bit32.band(n14, 4294967295))
									local v44 = table.pack(bit32.band(n143[1], 65535))
									n15 = 327058238 + 3859571462 + bit32.band(25350 * v44[1] + bit32.lshift(bit32.band(25350 * bit32.rshift(n143[1], 16) + 58892 * v44[1], 65535), 16), 4294967295)
									v20 = bit32.bor(2147483647, n14)
									local v45 = table.pack(bit32.band(bit32.band(272719449, v20), 4294967295))
									local v46 = table.pack(bit32.band(v45[1], 65535))
									n16 = n15 + 375472684 + bit32.band(14836 * v46[1] + bit32.lshift(bit32.band(14836 * bit32.rshift(v45[1], 16) + 13287 * v46[1], 65535), 16), 4294967295) + 1761712016
									n142 = bit32.bnot(n14)
									local v47 = table.pack(bit32.band(bit32.bor(2092966552, n142), 4294967295))
									local v48 = table.pack(bit32.band(v47[1], 65535))
									local v49 = table.pack(bit32.band(n16 - 4564062016 + 28981759 + bit32.band(50689 * v48[1] + bit32.lshift(bit32.band(50689 * bit32.rshift(v47[1], 16) + 32325 * v48[1], 65535), 16), 4294967295) + 1195411303, 4294967295))
									local v50 = table.pack(bit32.band(v49[1], 65535))
									n17 = bit32.band(31367 * v50[1] + bit32.lshift(bit32.band(31367 * bit32.rshift(v49[1], 16) + 21986 * v50[1], 65535), 16), 4294967295) + 21801894718
									v15[n112] = bit32.bxor(v15[n112], 327058238)
									n18 = n5 + 584826193
									local n185 = table.pack(bit32.band(n18, 4294967295))
									local v51 = table.pack(bit32.band(n185[1], 65535))
									n19 = bit32.band(43296 * v51[1] + bit32.lshift(bit32.band(43296 * bit32.rshift(n185[1], 16) + 12122 * v51[1], 65535), 16), 4294967295) + 1588941376
									local n113 = table.pack(bit32.band(n112, 4294967295))
									local v52 = table.pack(bit32.band(n113[1], 65535))
									v21 = bit32.band(v52[1] * 62187 + bit32.lshift(bit32.band(v52[1] * 8557 + bit32.rshift(n113[1], 16) * 62187, 65535), 16), 4294967295)
									n182 = bit32.band(n18, n17)
									local v212 = table.pack(bit32.band(v21, 4294967295))
									local n186 = table.pack(bit32.band(n182, 4294967295))
									local v53 = table.pack(bit32.band(v212[1], 65535))
									local v54 = table.pack(bit32.rshift(v212[1], 16))
									local v55 = table.pack(bit32.band(n186[1], 65535))
									local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n186[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
									local v57 = table.pack(bit32.band(v56[1], 65535))
									v23 = bit32.band(51485 * v57[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v56[1], 16) + 39315 * v57[1], 65535), 16), 4294967295)
									local v213 = table.pack(bit32.band(v21, 4294967295))
									local v58 = table.pack(bit32.band(v213[1], 65535))
									n20 = n19 + v23 + bit32.band(29245 * v58[1] + bit32.lshift(bit32.band(29245 * bit32.rshift(v213[1], 16) + 51438 * v58[1], 65535), 16), 4294967295)
									n172 = bit32.band(n17, 272719449)
									n183 = bit32.bnot(n182)
									local v214 = table.pack(bit32.band(v21, 4294967295))
									local n187 = table.pack(bit32.band(n183, 4294967295))
									local v59 = table.pack(bit32.band(v214[1], 65535))
									local v60 = table.pack(bit32.rshift(v214[1], 16))
									local v61 = table.pack(bit32.band(n187[1], 65535))
									local v62 = table.pack(bit32.band(bit32.band(v59[1] * v61[1] + bit32.lshift(bit32.band(v59[1] * bit32.rshift(n187[1], 16) + v60[1] * v61[1], 65535), 16), 4294967295), 4294967295))
									local v63 = table.pack(bit32.band(v62[1], 65535))
									n21 = n172 + bit32.band(51485 * v63[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v62[1], 16) + 39315 * v63[1], 65535), 16), 4294967295)
									n184 = bit32.bor(n18, v21)
									local n188 = table.pack(bit32.band(bit32.bnot(n184), 4294967295))
									local v64 = table.pack(bit32.band(n188[1], 65535))
									n22 = n20 + n21 + 3045076956 + bit32.band(21056 * v64[1] + bit32.lshift(bit32.band(21056 * bit32.rshift(n188[1], 16) + 24245 * v64[1], 65535), 16), 4294967295)
									n222 = bit32.band(n22, 2147483647)
									n223 = bit32.bnot(n222)
									local n227 = table.pack(bit32.band(n223, 4294967295))
									local v65 = table.pack(bit32.band(n227[1], 65535))
									v24 = bit32.band(65535 * v65[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n227[1], 16) + 65535 * v65[1], 65535), 16), 4294967295)
									local n228 = table.pack(bit32.band(n22, 4294967295))
									local v66 = table.pack(bit32.band(n228[1], 65535))
									v25 = bit32.band(46641 * v66[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n228[1], 16) + 36583 * v66[1], 65535), 16), 4294967295)
									n224 = bit32.bnot(n22)
									local n229 = table.pack(bit32.band(n224, 4294967295))
									local v67 = table.pack(bit32.band(n229[1], 65535))
									n23 = 2397550128 + v24 + v25 + bit32.band(46641 * v67[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n229[1], 16) + 36583 * v67[1], 65535), 16), 4294967295)
									local n2210 = table.pack(bit32.band(n22, 4294967295))
									local v68 = table.pack(bit32.band(n2210[1], 65535))
									v26 = bit32.band(1004 * v68[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2210[1], 16) + 49886 * v68[1], 65535), 16), 4294967295)
									local n2211 = table.pack(bit32.band(n224, 4294967295))
									local v69 = table.pack(bit32.band(n2211[1], 65535))
									local v70 = table.pack(bit32.band(n23 - 3269329899 + v24 + v26 + bit32.band(1004 * v69[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2211[1], 16) + 49886 * v69[1], 65535), 16), 4294967295), 4294967295))
									local v71 = table.pack(bit32.band(v70[1], 65535))
									v27 = bit32.band(21218 * v71[1] + bit32.lshift(bit32.band(21218 * bit32.rshift(v70[1], 16) + 47856 * v71[1], 65535), 16), 4294967295)
									local n2212 = table.pack(bit32.band(n22, 4294967295))
									local n2213 = table.pack(bit32.band(n223, 4294967295))
									local v72 = table.pack(bit32.band(n2212[1], 65535))
									local v73 = table.pack(bit32.rshift(n2212[1], 16))
									local v74 = table.pack(bit32.band(n2213[1], 65535))
									local v75 = table.pack(bit32.band(bit32.band(v72[1] * v74[1] + bit32.lshift(bit32.band(v72[1] * bit32.rshift(n2213[1], 16) + v73[1] * v74[1], 65535), 16), 4294967295), 4294967295))
									local v76 = table.pack(bit32.band(v75[1], 65535))
									n24 = 2669559910 + bit32.band(64492 * v76[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v75[1], 16) + 27898 * v76[1], 65535), 16), 4294967295)
									local n2214 = table.pack(bit32.band(n22, 4294967295))
									local v77 = table.pack(bit32.band(n2214[1], 65535))
									n225 = n223
									n226 = bit32.bor(n22, 2147483647)
									n25 = n24 + bit32.band(16487 * v77[1] + bit32.lshift(bit32.band(16487 * bit32.rshift(n2214[1], 16) + 40734 * v77[1], 65535), 16), 4294967295) + 0
									local n2215 = table.pack(bit32.band(n225, 4294967295))
									local v78 = table.pack(bit32.band(n2215[1], 65535))
									v28 = bit32.band(15442 * v78[1] + bit32.lshift(bit32.band(15442 * bit32.rshift(n2215[1], 16) + 3097 * v78[1], 65535), 16), 4294967295)
									local n2216 = table.pack(bit32.band(n225, 4294967295))
									local n2217 = table.pack(bit32.band(n225, 4294967295))
									local v79 = table.pack(bit32.band(n2216[1], 65535))
									local v80 = table.pack(bit32.rshift(n2216[1], 16))
									local v81 = table.pack(bit32.band(n2217[1], 65535))
									local v82 = table.pack(bit32.band(bit32.band(v79[1] * v81[1] + bit32.lshift(bit32.band(v79[1] * bit32.rshift(n2217[1], 16) + v80[1] * v81[1], 65535), 16), 4294967295), 4294967295))
									local v83 = table.pack(bit32.band(v82[1], 65535))
									n26 = v28 + bit32.band(64492 * v83[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v82[1], 16) + 27898 * v83[1], 65535), 16), 4294967295)
									local n2218 = table.pack(bit32.band(n22, 4294967295))
									local v84 = table.pack(bit32.band(n2218[1], 65535))
									local v85 = table.pack(bit32.band(bit32.band(v84[1] * 0 + bit32.lshift(bit32.band(v84[1] * 0 + bit32.rshift(n2218[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
									local v86 = table.pack(bit32.band(v85[1], 65535))
									v29 = bit32.band(64492 * v86[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v85[1], 16) + 27898 * v86[1], 65535), 16), 4294967295)
									local n2219 = table.pack(bit32.band(n226, 4294967295))
									local v87 = table.pack(bit32.band(n2219[1], 65535))
									local v88 = table.pack(bit32.band(bit32.band(v87[1] * 0 + bit32.lshift(bit32.band(v87[1] * 0 + bit32.rshift(n2219[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
									local v89 = table.pack(bit32.band(v88[1], 65535))
									n5 = v27 + n25 + n26 + 0 + v29 + bit32.band(1044 * v89[1] + bit32.lshift(bit32.band(1044 * bit32.rshift(v88[1], 16) + 37637 * v89[1], 65535), 16), 4294967295)
								else
									break
								end
							end

							tbl5 = tbl6[4]
							continue
						end

						break
					end

					tbl5[4] = n10

					if flag3 then
						v15 = tbl4[n10]
						tbl6 = { 0, #v15 + 0, nil, tbl5, 1 }

						while true do
							v16 = tbl6[5]
							v17 = tbl6[2]
							n11 = tbl6[1] + v16
							tbl6[1] = n11

							if n11 <= v17 then
								n112 = n11
								n52 = bit32.lshift(bit32.band(n5, n112), 1)
								n53 = bit32.band(n52, n5)
								n54 = bit32.bnot(n53)
								local n57 = table.pack(bit32.band(n52, 4294967295))
								local n58 = table.pack(bit32.band(n54, 4294967295))
								local v30 = table.pack(bit32.band(n57[1], 65535))
								local v31 = table.pack(bit32.rshift(n57[1], 16))
								local v32 = table.pack(bit32.band(n58[1], 65535))
								local v33 = table.pack(bit32.band(bit32.band(v30[1] * v32[1] + bit32.lshift(bit32.band(v30[1] * bit32.rshift(n58[1], 16) + v31[1] * v32[1], 65535), 16), 4294967295), 4294967295))
								local v34 = table.pack(bit32.band(v33[1], 65535))
								v18 = bit32.band(19474 * v34[1] + bit32.lshift(bit32.band(19474 * bit32.rshift(v33[1], 16) + 39469 * v34[1], 65535), 16), 4294967295)
								local n59 = table.pack(bit32.band(n52, 4294967295))
								local v35 = table.pack(bit32.band(n59[1], 65535))
								n12 = n112 + n5 + v18 + bit32.band(23587 * v35[1] + bit32.lshift(bit32.band(23587 * bit32.rshift(n59[1], 16) + 21404 * v35[1], 65535), 16), 4294967295)
								n55 = bit32.bnot(n5)
								n56 = bit32.bor(n55, 54517094)
								local n510 = table.pack(bit32.band(n52, 4294967295))
								local n511 = table.pack(bit32.band(n56, 4294967295))
								local v36 = table.pack(bit32.band(n510[1], 65535))
								local v37 = table.pack(bit32.rshift(n510[1], 16))
								local v38 = table.pack(bit32.band(n511[1], 65535))
								local v39 = table.pack(bit32.band(bit32.band(v36[1] * v38[1] + bit32.lshift(bit32.band(v36[1] * bit32.rshift(n511[1], 16) + v37[1] * v38[1], 65535), 16), 4294967295), 4294967295))
								local v40 = table.pack(bit32.band(v39[1], 65535))
								n13 = 1402756132 + bit32.band(46062 * v40[1] + bit32.lshift(bit32.band(46062 * bit32.rshift(v39[1], 16) + 26066 * v40[1], 65535), 16), 4294967295)
								local n512 = table.pack(bit32.band(bit32.bnot(n52), 4294967295))
								local v41 = table.pack(bit32.band(n512[1], 65535))
								v19 = bit32.band(23586 * v41[1] + bit32.lshift(bit32.band(23586 * bit32.rshift(n512[1], 16) + 21404 * v41[1], 65535), 16), 4294967295)
								local v42 = table.pack(bit32.band(bit32.bor(54517095, n55), 4294967295))
								local v43 = table.pack(bit32.band(v42[1], 65535))
								n14 = n12 + n13 + v19 + bit32.band(2 * v43[1] + bit32.lshift(bit32.band(2 * bit32.rshift(v42[1], 16) + 0 * v43[1], 65535), 16), 4294967295)
								local n143 = table.pack(bit32.band(n14, 4294967295))
								local v44 = table.pack(bit32.band(n143[1], 65535))
								n15 = 327058238 + 3859571462 + bit32.band(25350 * v44[1] + bit32.lshift(bit32.band(25350 * bit32.rshift(n143[1], 16) + 58892 * v44[1], 65535), 16), 4294967295)
								v20 = bit32.bor(2147483647, n14)
								local v45 = table.pack(bit32.band(bit32.band(272719449, v20), 4294967295))
								local v46 = table.pack(bit32.band(v45[1], 65535))
								n16 = n15 + 375472684 + bit32.band(14836 * v46[1] + bit32.lshift(bit32.band(14836 * bit32.rshift(v45[1], 16) + 13287 * v46[1], 65535), 16), 4294967295) + 1761712016
								n142 = bit32.bnot(n14)
								local v47 = table.pack(bit32.band(bit32.bor(2092966552, n142), 4294967295))
								local v48 = table.pack(bit32.band(v47[1], 65535))
								local v49 = table.pack(bit32.band(n16 - 4564062016 + 28981759 + bit32.band(50689 * v48[1] + bit32.lshift(bit32.band(50689 * bit32.rshift(v47[1], 16) + 32325 * v48[1], 65535), 16), 4294967295) + 1195411303, 4294967295))
								local v50 = table.pack(bit32.band(v49[1], 65535))
								n17 = bit32.band(31367 * v50[1] + bit32.lshift(bit32.band(31367 * bit32.rshift(v49[1], 16) + 21986 * v50[1], 65535), 16), 4294967295) + 21801894718
								v15[n112] = bit32.bxor(v15[n112], 327058238)
								n18 = n5 + 584826193
								local n185 = table.pack(bit32.band(n18, 4294967295))
								local v51 = table.pack(bit32.band(n185[1], 65535))
								n19 = bit32.band(43296 * v51[1] + bit32.lshift(bit32.band(43296 * bit32.rshift(n185[1], 16) + 12122 * v51[1], 65535), 16), 4294967295) + 1588941376
								local n113 = table.pack(bit32.band(n112, 4294967295))
								local v52 = table.pack(bit32.band(n113[1], 65535))
								v21 = bit32.band(v52[1] * 62187 + bit32.lshift(bit32.band(v52[1] * 8557 + bit32.rshift(n113[1], 16) * 62187, 65535), 16), 4294967295)
								n182 = bit32.band(n18, n17)
								local v212 = table.pack(bit32.band(v21, 4294967295))
								local n186 = table.pack(bit32.band(n182, 4294967295))
								local v53 = table.pack(bit32.band(v212[1], 65535))
								local v54 = table.pack(bit32.rshift(v212[1], 16))
								local v55 = table.pack(bit32.band(n186[1], 65535))
								local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n186[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
								local v57 = table.pack(bit32.band(v56[1], 65535))
								v23 = bit32.band(51485 * v57[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v56[1], 16) + 39315 * v57[1], 65535), 16), 4294967295)
								local v213 = table.pack(bit32.band(v21, 4294967295))
								local v58 = table.pack(bit32.band(v213[1], 65535))
								n20 = n19 + v23 + bit32.band(29245 * v58[1] + bit32.lshift(bit32.band(29245 * bit32.rshift(v213[1], 16) + 51438 * v58[1], 65535), 16), 4294967295)
								n172 = bit32.band(n17, 272719449)
								n183 = bit32.bnot(n182)
								local v214 = table.pack(bit32.band(v21, 4294967295))
								local n187 = table.pack(bit32.band(n183, 4294967295))
								local v59 = table.pack(bit32.band(v214[1], 65535))
								local v60 = table.pack(bit32.rshift(v214[1], 16))
								local v61 = table.pack(bit32.band(n187[1], 65535))
								local v62 = table.pack(bit32.band(bit32.band(v59[1] * v61[1] + bit32.lshift(bit32.band(v59[1] * bit32.rshift(n187[1], 16) + v60[1] * v61[1], 65535), 16), 4294967295), 4294967295))
								local v63 = table.pack(bit32.band(v62[1], 65535))
								n21 = n172 + bit32.band(51485 * v63[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v62[1], 16) + 39315 * v63[1], 65535), 16), 4294967295)
								n184 = bit32.bor(n18, v21)
								local n188 = table.pack(bit32.band(bit32.bnot(n184), 4294967295))
								local v64 = table.pack(bit32.band(n188[1], 65535))
								n22 = n20 + n21 + 3045076956 + bit32.band(21056 * v64[1] + bit32.lshift(bit32.band(21056 * bit32.rshift(n188[1], 16) + 24245 * v64[1], 65535), 16), 4294967295)
								n222 = bit32.band(n22, 2147483647)
								n223 = bit32.bnot(n222)
								local n227 = table.pack(bit32.band(n223, 4294967295))
								local v65 = table.pack(bit32.band(n227[1], 65535))
								v24 = bit32.band(65535 * v65[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n227[1], 16) + 65535 * v65[1], 65535), 16), 4294967295)
								local n228 = table.pack(bit32.band(n22, 4294967295))
								local v66 = table.pack(bit32.band(n228[1], 65535))
								v25 = bit32.band(46641 * v66[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n228[1], 16) + 36583 * v66[1], 65535), 16), 4294967295)
								n224 = bit32.bnot(n22)
								local n229 = table.pack(bit32.band(n224, 4294967295))
								local v67 = table.pack(bit32.band(n229[1], 65535))
								n23 = 2397550128 + v24 + v25 + bit32.band(46641 * v67[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n229[1], 16) + 36583 * v67[1], 65535), 16), 4294967295)
								local n2210 = table.pack(bit32.band(n22, 4294967295))
								local v68 = table.pack(bit32.band(n2210[1], 65535))
								v26 = bit32.band(1004 * v68[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2210[1], 16) + 49886 * v68[1], 65535), 16), 4294967295)
								local n2211 = table.pack(bit32.band(n224, 4294967295))
								local v69 = table.pack(bit32.band(n2211[1], 65535))
								local v70 = table.pack(bit32.band(n23 - 3269329899 + v24 + v26 + bit32.band(1004 * v69[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2211[1], 16) + 49886 * v69[1], 65535), 16), 4294967295), 4294967295))
								local v71 = table.pack(bit32.band(v70[1], 65535))
								v27 = bit32.band(21218 * v71[1] + bit32.lshift(bit32.band(21218 * bit32.rshift(v70[1], 16) + 47856 * v71[1], 65535), 16), 4294967295)
								local n2212 = table.pack(bit32.band(n22, 4294967295))
								local n2213 = table.pack(bit32.band(n223, 4294967295))
								local v72 = table.pack(bit32.band(n2212[1], 65535))
								local v73 = table.pack(bit32.rshift(n2212[1], 16))
								local v74 = table.pack(bit32.band(n2213[1], 65535))
								local v75 = table.pack(bit32.band(bit32.band(v72[1] * v74[1] + bit32.lshift(bit32.band(v72[1] * bit32.rshift(n2213[1], 16) + v73[1] * v74[1], 65535), 16), 4294967295), 4294967295))
								local v76 = table.pack(bit32.band(v75[1], 65535))
								n24 = 2669559910 + bit32.band(64492 * v76[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v75[1], 16) + 27898 * v76[1], 65535), 16), 4294967295)
								local n2214 = table.pack(bit32.band(n22, 4294967295))
								local v77 = table.pack(bit32.band(n2214[1], 65535))
								n225 = n223
								n226 = bit32.bor(n22, 2147483647)
								n25 = n24 + bit32.band(16487 * v77[1] + bit32.lshift(bit32.band(16487 * bit32.rshift(n2214[1], 16) + 40734 * v77[1], 65535), 16), 4294967295) + 0
								local n2215 = table.pack(bit32.band(n225, 4294967295))
								local v78 = table.pack(bit32.band(n2215[1], 65535))
								v28 = bit32.band(15442 * v78[1] + bit32.lshift(bit32.band(15442 * bit32.rshift(n2215[1], 16) + 3097 * v78[1], 65535), 16), 4294967295)
								local n2216 = table.pack(bit32.band(n225, 4294967295))
								local n2217 = table.pack(bit32.band(n225, 4294967295))
								local v79 = table.pack(bit32.band(n2216[1], 65535))
								local v80 = table.pack(bit32.rshift(n2216[1], 16))
								local v81 = table.pack(bit32.band(n2217[1], 65535))
								local v82 = table.pack(bit32.band(bit32.band(v79[1] * v81[1] + bit32.lshift(bit32.band(v79[1] * bit32.rshift(n2217[1], 16) + v80[1] * v81[1], 65535), 16), 4294967295), 4294967295))
								local v83 = table.pack(bit32.band(v82[1], 65535))
								n26 = v28 + bit32.band(64492 * v83[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v82[1], 16) + 27898 * v83[1], 65535), 16), 4294967295)
								local n2218 = table.pack(bit32.band(n22, 4294967295))
								local v84 = table.pack(bit32.band(n2218[1], 65535))
								local v85 = table.pack(bit32.band(bit32.band(v84[1] * 0 + bit32.lshift(bit32.band(v84[1] * 0 + bit32.rshift(n2218[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
								local v86 = table.pack(bit32.band(v85[1], 65535))
								v29 = bit32.band(64492 * v86[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v85[1], 16) + 27898 * v86[1], 65535), 16), 4294967295)
								local n2219 = table.pack(bit32.band(n226, 4294967295))
								local v87 = table.pack(bit32.band(n2219[1], 65535))
								local v88 = table.pack(bit32.band(bit32.band(v87[1] * 0 + bit32.lshift(bit32.band(v87[1] * 0 + bit32.rshift(n2219[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
								local v89 = table.pack(bit32.band(v88[1], 65535))
								n5 = v27 + n25 + n26 + 0 + v29 + bit32.band(1044 * v89[1] + bit32.lshift(bit32.band(1044 * bit32.rshift(v88[1], 16) + 37637 * v89[1], 65535), 16), 4294967295)
							else
								break
							end
						end

						tbl5 = tbl6[4]
						continue
					end

					v11 = arg[6]
					n6 = buffer.len(v11) - 32 - 19
					n7 = 32 + 888971832 % n6
					n8 = 32

					while true do
						n9 = n8 + (n7 + bit32.band(n5, 255) + 1) % n6
						v112 = buffer.readi8(v11, n7)
						v113 = buffer.readu8(v11, n9)
						v114 = bit32.lshift(bit32.band(v113, 255), 3)
						v12 = bit32.band(bit32.bxor(bit32.bxor(54517094, v112) + v114 + 584826193, n7), 2147483647)
						v115 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v112, v113), v12), 2147483647), 205469696)
						buffer.writeu32(v11, n7, v115)
						v122 = bit32.rshift(v12, 8)
						v116 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v113, v122), n7), 2147483647), 327527424)
						buffer.writeu8(v11, n9, v116)
						n5 = v12
						n7 = n8 + (n7 + bit32.band(v12, 63) + 1) % n6
					end
				end
			end

			flag4 = flag2

			if flag3 then
				tbl5[4] = n10

				if flag3 then
					v15 = tbl4[n10]
					tbl6 = { 0, #v15 + 0, nil, tbl5, 1 }

					while true do
						v16 = tbl6[5]
						v17 = tbl6[2]
						n11 = tbl6[1] + v16
						tbl6[1] = n11

						if n11 <= v17 then
							n112 = n11
							n52 = bit32.lshift(bit32.band(n5, n112), 1)
							n53 = bit32.band(n52, n5)
							n54 = bit32.bnot(n53)
							local v123 = table.pack(bit32.band(n52, 4294967295))
							local v124 = table.pack(bit32.band(n54, 4294967295))
							local v30 = table.pack(bit32.band(v123[1], 65535))
							local v31 = table.pack(bit32.rshift(v123[1], 16))
							local v32 = table.pack(bit32.band(v124[1], 65535))
							local v33 = table.pack(bit32.band(bit32.band(v30[1] * v32[1] + bit32.lshift(bit32.band(v30[1] * bit32.rshift(v124[1], 16) + v31[1] * v32[1], 65535), 16), 4294967295), 4294967295))
							local v34 = table.pack(bit32.band(v33[1], 65535))
							v18 = bit32.band(19474 * v34[1] + bit32.lshift(bit32.band(19474 * bit32.rshift(v33[1], 16) + 39469 * v34[1], 65535), 16), 4294967295)
							local v125 = table.pack(bit32.band(n52, 4294967295))
							local v35 = table.pack(bit32.band(v125[1], 65535))
							n12 = n112 + n5 + v18 + bit32.band(23587 * v35[1] + bit32.lshift(bit32.band(23587 * bit32.rshift(v125[1], 16) + 21404 * v35[1], 65535), 16), 4294967295)
							n55 = bit32.bnot(n5)
							n56 = bit32.bor(n55, 54517094)
							local v126 = table.pack(bit32.band(n52, 4294967295))
							local v127 = table.pack(bit32.band(n56, 4294967295))
							local v36 = table.pack(bit32.band(v126[1], 65535))
							local v37 = table.pack(bit32.rshift(v126[1], 16))
							local v38 = table.pack(bit32.band(v127[1], 65535))
							local v39 = table.pack(bit32.band(bit32.band(v36[1] * v38[1] + bit32.lshift(bit32.band(v36[1] * bit32.rshift(v127[1], 16) + v37[1] * v38[1], 65535), 16), 4294967295), 4294967295))
							local v40 = table.pack(bit32.band(v39[1], 65535))
							n13 = 1402756132 + bit32.band(46062 * v40[1] + bit32.lshift(bit32.band(46062 * bit32.rshift(v39[1], 16) + 26066 * v40[1], 65535), 16), 4294967295)
							local v128 = table.pack(bit32.band(bit32.bnot(n52), 4294967295))
							local v41 = table.pack(bit32.band(v128[1], 65535))
							v19 = bit32.band(23586 * v41[1] + bit32.lshift(bit32.band(23586 * bit32.rshift(v128[1], 16) + 21404 * v41[1], 65535), 16), 4294967295)
							local v42 = table.pack(bit32.band(bit32.bor(54517095, n55), 4294967295))
							local v43 = table.pack(bit32.band(v42[1], 65535))
							n14 = n12 + n13 + v19 + bit32.band(2 * v43[1] + bit32.lshift(bit32.band(2 * bit32.rshift(v42[1], 16) + 0 * v43[1], 65535), 16), 4294967295)
							local n143 = table.pack(bit32.band(n14, 4294967295))
							local v44 = table.pack(bit32.band(n143[1], 65535))
							n15 = 327058238 + 3859571462 + bit32.band(25350 * v44[1] + bit32.lshift(bit32.band(25350 * bit32.rshift(n143[1], 16) + 58892 * v44[1], 65535), 16), 4294967295)
							v20 = bit32.bor(2147483647, n14)
							local v45 = table.pack(bit32.band(bit32.band(272719449, v20), 4294967295))
							local v46 = table.pack(bit32.band(v45[1], 65535))
							n16 = n15 + 375472684 + bit32.band(14836 * v46[1] + bit32.lshift(bit32.band(14836 * bit32.rshift(v45[1], 16) + 13287 * v46[1], 65535), 16), 4294967295) + 1761712016
							n142 = bit32.bnot(n14)
							local v47 = table.pack(bit32.band(bit32.bor(2092966552, n142), 4294967295))
							local v48 = table.pack(bit32.band(v47[1], 65535))
							local v49 = table.pack(bit32.band(n16 - 4564062016 + 28981759 + bit32.band(50689 * v48[1] + bit32.lshift(bit32.band(50689 * bit32.rshift(v47[1], 16) + 32325 * v48[1], 65535), 16), 4294967295) + 1195411303, 4294967295))
							local v50 = table.pack(bit32.band(v49[1], 65535))
							n17 = bit32.band(31367 * v50[1] + bit32.lshift(bit32.band(31367 * bit32.rshift(v49[1], 16) + 21986 * v50[1], 65535), 16), 4294967295) + 21801894718
							v15[n112] = bit32.bxor(v15[n112], 327058238)
							n18 = n5 + 584826193
							local n185 = table.pack(bit32.band(n18, 4294967295))
							local v51 = table.pack(bit32.band(n185[1], 65535))
							n19 = bit32.band(43296 * v51[1] + bit32.lshift(bit32.band(43296 * bit32.rshift(n185[1], 16) + 12122 * v51[1], 65535), 16), 4294967295) + 1588941376
							local n113 = table.pack(bit32.band(n112, 4294967295))
							local v52 = table.pack(bit32.band(n113[1], 65535))
							v21 = bit32.band(v52[1] * 62187 + bit32.lshift(bit32.band(v52[1] * 8557 + bit32.rshift(n113[1], 16) * 62187, 65535), 16), 4294967295)
							n182 = bit32.band(n18, n17)
							local v212 = table.pack(bit32.band(v21, 4294967295))
							local n186 = table.pack(bit32.band(n182, 4294967295))
							local v53 = table.pack(bit32.band(v212[1], 65535))
							local v54 = table.pack(bit32.rshift(v212[1], 16))
							local v55 = table.pack(bit32.band(n186[1], 65535))
							local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n186[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
							local v57 = table.pack(bit32.band(v56[1], 65535))
							v23 = bit32.band(51485 * v57[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v56[1], 16) + 39315 * v57[1], 65535), 16), 4294967295)
							local v213 = table.pack(bit32.band(v21, 4294967295))
							local v58 = table.pack(bit32.band(v213[1], 65535))
							n20 = n19 + v23 + bit32.band(29245 * v58[1] + bit32.lshift(bit32.band(29245 * bit32.rshift(v213[1], 16) + 51438 * v58[1], 65535), 16), 4294967295)
							n172 = bit32.band(n17, 272719449)
							n183 = bit32.bnot(n182)
							local v214 = table.pack(bit32.band(v21, 4294967295))
							local n187 = table.pack(bit32.band(n183, 4294967295))
							local v59 = table.pack(bit32.band(v214[1], 65535))
							local v60 = table.pack(bit32.rshift(v214[1], 16))
							local v61 = table.pack(bit32.band(n187[1], 65535))
							local v62 = table.pack(bit32.band(bit32.band(v59[1] * v61[1] + bit32.lshift(bit32.band(v59[1] * bit32.rshift(n187[1], 16) + v60[1] * v61[1], 65535), 16), 4294967295), 4294967295))
							local v63 = table.pack(bit32.band(v62[1], 65535))
							n21 = n172 + bit32.band(51485 * v63[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v62[1], 16) + 39315 * v63[1], 65535), 16), 4294967295)
							n184 = bit32.bor(n18, v21)
							local n188 = table.pack(bit32.band(bit32.bnot(n184), 4294967295))
							local v64 = table.pack(bit32.band(n188[1], 65535))
							n22 = n20 + n21 + 3045076956 + bit32.band(21056 * v64[1] + bit32.lshift(bit32.band(21056 * bit32.rshift(n188[1], 16) + 24245 * v64[1], 65535), 16), 4294967295)
							n222 = bit32.band(n22, 2147483647)
							n223 = bit32.bnot(n222)
							local n227 = table.pack(bit32.band(n223, 4294967295))
							local v65 = table.pack(bit32.band(n227[1], 65535))
							v24 = bit32.band(65535 * v65[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n227[1], 16) + 65535 * v65[1], 65535), 16), 4294967295)
							local n228 = table.pack(bit32.band(n22, 4294967295))
							local v66 = table.pack(bit32.band(n228[1], 65535))
							v25 = bit32.band(46641 * v66[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n228[1], 16) + 36583 * v66[1], 65535), 16), 4294967295)
							n224 = bit32.bnot(n22)
							local n229 = table.pack(bit32.band(n224, 4294967295))
							local v67 = table.pack(bit32.band(n229[1], 65535))
							n23 = 2397550128 + v24 + v25 + bit32.band(46641 * v67[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n229[1], 16) + 36583 * v67[1], 65535), 16), 4294967295)
							local n2210 = table.pack(bit32.band(n22, 4294967295))
							local v68 = table.pack(bit32.band(n2210[1], 65535))
							v26 = bit32.band(1004 * v68[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2210[1], 16) + 49886 * v68[1], 65535), 16), 4294967295)
							local n2211 = table.pack(bit32.band(n224, 4294967295))
							local v69 = table.pack(bit32.band(n2211[1], 65535))
							local v70 = table.pack(bit32.band(n23 - 3269329899 + v24 + v26 + bit32.band(1004 * v69[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2211[1], 16) + 49886 * v69[1], 65535), 16), 4294967295), 4294967295))
							local v71 = table.pack(bit32.band(v70[1], 65535))
							v27 = bit32.band(21218 * v71[1] + bit32.lshift(bit32.band(21218 * bit32.rshift(v70[1], 16) + 47856 * v71[1], 65535), 16), 4294967295)
							local n2212 = table.pack(bit32.band(n22, 4294967295))
							local n2213 = table.pack(bit32.band(n223, 4294967295))
							local v72 = table.pack(bit32.band(n2212[1], 65535))
							local v73 = table.pack(bit32.rshift(n2212[1], 16))
							local v74 = table.pack(bit32.band(n2213[1], 65535))
							local v75 = table.pack(bit32.band(bit32.band(v72[1] * v74[1] + bit32.lshift(bit32.band(v72[1] * bit32.rshift(n2213[1], 16) + v73[1] * v74[1], 65535), 16), 4294967295), 4294967295))
							local v76 = table.pack(bit32.band(v75[1], 65535))
							n24 = 2669559910 + bit32.band(64492 * v76[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v75[1], 16) + 27898 * v76[1], 65535), 16), 4294967295)
							local n2214 = table.pack(bit32.band(n22, 4294967295))
							local v77 = table.pack(bit32.band(n2214[1], 65535))
							n225 = n223
							n226 = bit32.bor(n22, 2147483647)
							n25 = n24 + bit32.band(16487 * v77[1] + bit32.lshift(bit32.band(16487 * bit32.rshift(n2214[1], 16) + 40734 * v77[1], 65535), 16), 4294967295) + 0
							local n2215 = table.pack(bit32.band(n225, 4294967295))
							local v78 = table.pack(bit32.band(n2215[1], 65535))
							v28 = bit32.band(15442 * v78[1] + bit32.lshift(bit32.band(15442 * bit32.rshift(n2215[1], 16) + 3097 * v78[1], 65535), 16), 4294967295)
							local n2216 = table.pack(bit32.band(n225, 4294967295))
							local n2217 = table.pack(bit32.band(n225, 4294967295))
							local v79 = table.pack(bit32.band(n2216[1], 65535))
							local v80 = table.pack(bit32.rshift(n2216[1], 16))
							local v81 = table.pack(bit32.band(n2217[1], 65535))
							local v82 = table.pack(bit32.band(bit32.band(v79[1] * v81[1] + bit32.lshift(bit32.band(v79[1] * bit32.rshift(n2217[1], 16) + v80[1] * v81[1], 65535), 16), 4294967295), 4294967295))
							local v83 = table.pack(bit32.band(v82[1], 65535))
							n26 = v28 + bit32.band(64492 * v83[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v82[1], 16) + 27898 * v83[1], 65535), 16), 4294967295)
							local n2218 = table.pack(bit32.band(n22, 4294967295))
							local v84 = table.pack(bit32.band(n2218[1], 65535))
							local v85 = table.pack(bit32.band(bit32.band(v84[1] * 0 + bit32.lshift(bit32.band(v84[1] * 0 + bit32.rshift(n2218[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
							local v86 = table.pack(bit32.band(v85[1], 65535))
							v29 = bit32.band(64492 * v86[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v85[1], 16) + 27898 * v86[1], 65535), 16), 4294967295)
							local n2219 = table.pack(bit32.band(n226, 4294967295))
							local v87 = table.pack(bit32.band(n2219[1], 65535))
							local v88 = table.pack(bit32.band(bit32.band(v87[1] * 0 + bit32.lshift(bit32.band(v87[1] * 0 + bit32.rshift(n2219[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
							local v89 = table.pack(bit32.band(v88[1], 65535))
							n5 = v27 + n25 + n26 + 0 + v29 + bit32.band(1044 * v89[1] + bit32.lshift(bit32.band(1044 * bit32.rshift(v88[1], 16) + 37637 * v89[1], 65535), 16), 4294967295)
						else
							break
						end
					end

					tbl5 = tbl6[4]
					continue
				end

				v11 = arg[6]
				n6 = buffer.len(v11) - 32 - 19
				n7 = 32 + 888971832 % n6
				n8 = 32

				while true do
					n9 = n8 + (n7 + bit32.band(n5, 255) + 1) % n6
					v112 = buffer.readi8(v11, n7)
					v113 = buffer.readu8(v11, n9)
					v114 = bit32.lshift(bit32.band(v113, 255), 3)
					v12 = bit32.band(bit32.bxor(bit32.bxor(54517094, v112) + v114 + 584826193, n7), 2147483647)
					v115 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v112, v113), v12), 2147483647), 205469696)
					buffer.writeu32(v11, n7, v115)
					v122 = bit32.rshift(v12, 8)
					v116 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v113, v122), n7), 2147483647), 327527424)
					buffer.writeu8(v11, n9, v116)
					n5 = v12
					n7 = n8 + (n7 + bit32.band(v12, 63) + 1) % n6
				end
			else
				flag3 = flag4
				tbl5[4] = n10

				if flag3 then
					v15 = tbl4[n10]
					tbl6 = { 0, #v15 + 0, nil, tbl5, 1 }

					while true do
						v16 = tbl6[5]
						v17 = tbl6[2]
						n11 = tbl6[1] + v16
						tbl6[1] = n11

						if n11 <= v17 then
							n112 = n11
							n52 = bit32.lshift(bit32.band(n5, n112), 1)
							n53 = bit32.band(n52, n5)
							n54 = bit32.bnot(n53)
							local v123 = table.pack(bit32.band(n52, 4294967295))
							local v124 = table.pack(bit32.band(n54, 4294967295))
							local v30 = table.pack(bit32.band(v123[1], 65535))
							local v31 = table.pack(bit32.rshift(v123[1], 16))
							local v32 = table.pack(bit32.band(v124[1], 65535))
							local v33 = table.pack(bit32.band(bit32.band(v30[1] * v32[1] + bit32.lshift(bit32.band(v30[1] * bit32.rshift(v124[1], 16) + v31[1] * v32[1], 65535), 16), 4294967295), 4294967295))
							local v34 = table.pack(bit32.band(v33[1], 65535))
							v18 = bit32.band(19474 * v34[1] + bit32.lshift(bit32.band(19474 * bit32.rshift(v33[1], 16) + 39469 * v34[1], 65535), 16), 4294967295)
							local v125 = table.pack(bit32.band(n52, 4294967295))
							local v35 = table.pack(bit32.band(v125[1], 65535))
							n12 = n112 + n5 + v18 + bit32.band(23587 * v35[1] + bit32.lshift(bit32.band(23587 * bit32.rshift(v125[1], 16) + 21404 * v35[1], 65535), 16), 4294967295)
							n55 = bit32.bnot(n5)
							n56 = bit32.bor(n55, 54517094)
							local v126 = table.pack(bit32.band(n52, 4294967295))
							local v127 = table.pack(bit32.band(n56, 4294967295))
							local v36 = table.pack(bit32.band(v126[1], 65535))
							local v37 = table.pack(bit32.rshift(v126[1], 16))
							local v38 = table.pack(bit32.band(v127[1], 65535))
							local v39 = table.pack(bit32.band(bit32.band(v36[1] * v38[1] + bit32.lshift(bit32.band(v36[1] * bit32.rshift(v127[1], 16) + v37[1] * v38[1], 65535), 16), 4294967295), 4294967295))
							local v40 = table.pack(bit32.band(v39[1], 65535))
							n13 = 1402756132 + bit32.band(46062 * v40[1] + bit32.lshift(bit32.band(46062 * bit32.rshift(v39[1], 16) + 26066 * v40[1], 65535), 16), 4294967295)
							local v128 = table.pack(bit32.band(bit32.bnot(n52), 4294967295))
							local v41 = table.pack(bit32.band(v128[1], 65535))
							v19 = bit32.band(23586 * v41[1] + bit32.lshift(bit32.band(23586 * bit32.rshift(v128[1], 16) + 21404 * v41[1], 65535), 16), 4294967295)
							local v42 = table.pack(bit32.band(bit32.bor(54517095, n55), 4294967295))
							local v43 = table.pack(bit32.band(v42[1], 65535))
							n14 = n12 + n13 + v19 + bit32.band(2 * v43[1] + bit32.lshift(bit32.band(2 * bit32.rshift(v42[1], 16) + 0 * v43[1], 65535), 16), 4294967295)
							local n143 = table.pack(bit32.band(n14, 4294967295))
							local v44 = table.pack(bit32.band(n143[1], 65535))
							n15 = 327058238 + 3859571462 + bit32.band(25350 * v44[1] + bit32.lshift(bit32.band(25350 * bit32.rshift(n143[1], 16) + 58892 * v44[1], 65535), 16), 4294967295)
							v20 = bit32.bor(2147483647, n14)
							local v45 = table.pack(bit32.band(bit32.band(272719449, v20), 4294967295))
							local v46 = table.pack(bit32.band(v45[1], 65535))
							n16 = n15 + 375472684 + bit32.band(14836 * v46[1] + bit32.lshift(bit32.band(14836 * bit32.rshift(v45[1], 16) + 13287 * v46[1], 65535), 16), 4294967295) + 1761712016
							n142 = bit32.bnot(n14)
							local v47 = table.pack(bit32.band(bit32.bor(2092966552, n142), 4294967295))
							local v48 = table.pack(bit32.band(v47[1], 65535))
							local v49 = table.pack(bit32.band(n16 - 4564062016 + 28981759 + bit32.band(50689 * v48[1] + bit32.lshift(bit32.band(50689 * bit32.rshift(v47[1], 16) + 32325 * v48[1], 65535), 16), 4294967295) + 1195411303, 4294967295))
							local v50 = table.pack(bit32.band(v49[1], 65535))
							n17 = bit32.band(31367 * v50[1] + bit32.lshift(bit32.band(31367 * bit32.rshift(v49[1], 16) + 21986 * v50[1], 65535), 16), 4294967295) + 21801894718
							v15[n112] = bit32.bxor(v15[n112], 327058238)
							n18 = n5 + 584826193
							local n185 = table.pack(bit32.band(n18, 4294967295))
							local v51 = table.pack(bit32.band(n185[1], 65535))
							n19 = bit32.band(43296 * v51[1] + bit32.lshift(bit32.band(43296 * bit32.rshift(n185[1], 16) + 12122 * v51[1], 65535), 16), 4294967295) + 1588941376
							local n113 = table.pack(bit32.band(n112, 4294967295))
							local v52 = table.pack(bit32.band(n113[1], 65535))
							v21 = bit32.band(v52[1] * 62187 + bit32.lshift(bit32.band(v52[1] * 8557 + bit32.rshift(n113[1], 16) * 62187, 65535), 16), 4294967295)
							n182 = bit32.band(n18, n17)
							local v212 = table.pack(bit32.band(v21, 4294967295))
							local n186 = table.pack(bit32.band(n182, 4294967295))
							local v53 = table.pack(bit32.band(v212[1], 65535))
							local v54 = table.pack(bit32.rshift(v212[1], 16))
							local v55 = table.pack(bit32.band(n186[1], 65535))
							local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n186[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
							local v57 = table.pack(bit32.band(v56[1], 65535))
							v23 = bit32.band(51485 * v57[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v56[1], 16) + 39315 * v57[1], 65535), 16), 4294967295)
							local v213 = table.pack(bit32.band(v21, 4294967295))
							local v58 = table.pack(bit32.band(v213[1], 65535))
							n20 = n19 + v23 + bit32.band(29245 * v58[1] + bit32.lshift(bit32.band(29245 * bit32.rshift(v213[1], 16) + 51438 * v58[1], 65535), 16), 4294967295)
							n172 = bit32.band(n17, 272719449)
							n183 = bit32.bnot(n182)
							local v214 = table.pack(bit32.band(v21, 4294967295))
							local n187 = table.pack(bit32.band(n183, 4294967295))
							local v59 = table.pack(bit32.band(v214[1], 65535))
							local v60 = table.pack(bit32.rshift(v214[1], 16))
							local v61 = table.pack(bit32.band(n187[1], 65535))
							local v62 = table.pack(bit32.band(bit32.band(v59[1] * v61[1] + bit32.lshift(bit32.band(v59[1] * bit32.rshift(n187[1], 16) + v60[1] * v61[1], 65535), 16), 4294967295), 4294967295))
							local v63 = table.pack(bit32.band(v62[1], 65535))
							n21 = n172 + bit32.band(51485 * v63[1] + bit32.lshift(bit32.band(51485 * bit32.rshift(v62[1], 16) + 39315 * v63[1], 65535), 16), 4294967295)
							n184 = bit32.bor(n18, v21)
							local n188 = table.pack(bit32.band(bit32.bnot(n184), 4294967295))
							local v64 = table.pack(bit32.band(n188[1], 65535))
							n22 = n20 + n21 + 3045076956 + bit32.band(21056 * v64[1] + bit32.lshift(bit32.band(21056 * bit32.rshift(n188[1], 16) + 24245 * v64[1], 65535), 16), 4294967295)
							n222 = bit32.band(n22, 2147483647)
							n223 = bit32.bnot(n222)
							local n227 = table.pack(bit32.band(n223, 4294967295))
							local v65 = table.pack(bit32.band(n227[1], 65535))
							v24 = bit32.band(65535 * v65[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n227[1], 16) + 65535 * v65[1], 65535), 16), 4294967295)
							local n228 = table.pack(bit32.band(n22, 4294967295))
							local v66 = table.pack(bit32.band(n228[1], 65535))
							v25 = bit32.band(46641 * v66[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n228[1], 16) + 36583 * v66[1], 65535), 16), 4294967295)
							n224 = bit32.bnot(n22)
							local n229 = table.pack(bit32.band(n224, 4294967295))
							local v67 = table.pack(bit32.band(n229[1], 65535))
							n23 = 2397550128 + v24 + v25 + bit32.band(46641 * v67[1] + bit32.lshift(bit32.band(46641 * bit32.rshift(n229[1], 16) + 36583 * v67[1], 65535), 16), 4294967295)
							local n2210 = table.pack(bit32.band(n22, 4294967295))
							local v68 = table.pack(bit32.band(n2210[1], 65535))
							v26 = bit32.band(1004 * v68[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2210[1], 16) + 49886 * v68[1], 65535), 16), 4294967295)
							local n2211 = table.pack(bit32.band(n224, 4294967295))
							local v69 = table.pack(bit32.band(n2211[1], 65535))
							local v70 = table.pack(bit32.band(n23 - 3269329899 + v24 + v26 + bit32.band(1004 * v69[1] + bit32.lshift(bit32.band(1004 * bit32.rshift(n2211[1], 16) + 49886 * v69[1], 65535), 16), 4294967295), 4294967295))
							local v71 = table.pack(bit32.band(v70[1], 65535))
							v27 = bit32.band(21218 * v71[1] + bit32.lshift(bit32.band(21218 * bit32.rshift(v70[1], 16) + 47856 * v71[1], 65535), 16), 4294967295)
							local n2212 = table.pack(bit32.band(n22, 4294967295))
							local n2213 = table.pack(bit32.band(n223, 4294967295))
							local v72 = table.pack(bit32.band(n2212[1], 65535))
							local v73 = table.pack(bit32.rshift(n2212[1], 16))
							local v74 = table.pack(bit32.band(n2213[1], 65535))
							local v75 = table.pack(bit32.band(bit32.band(v72[1] * v74[1] + bit32.lshift(bit32.band(v72[1] * bit32.rshift(n2213[1], 16) + v73[1] * v74[1], 65535), 16), 4294967295), 4294967295))
							local v76 = table.pack(bit32.band(v75[1], 65535))
							n24 = 2669559910 + bit32.band(64492 * v76[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v75[1], 16) + 27898 * v76[1], 65535), 16), 4294967295)
							local n2214 = table.pack(bit32.band(n22, 4294967295))
							local v77 = table.pack(bit32.band(n2214[1], 65535))
							n225 = n223
							n226 = bit32.bor(n22, 2147483647)
							n25 = n24 + bit32.band(16487 * v77[1] + bit32.lshift(bit32.band(16487 * bit32.rshift(n2214[1], 16) + 40734 * v77[1], 65535), 16), 4294967295) + 0
							local n2215 = table.pack(bit32.band(n225, 4294967295))
							local v78 = table.pack(bit32.band(n2215[1], 65535))
							v28 = bit32.band(15442 * v78[1] + bit32.lshift(bit32.band(15442 * bit32.rshift(n2215[1], 16) + 3097 * v78[1], 65535), 16), 4294967295)
							local n2216 = table.pack(bit32.band(n225, 4294967295))
							local n2217 = table.pack(bit32.band(n225, 4294967295))
							local v79 = table.pack(bit32.band(n2216[1], 65535))
							local v80 = table.pack(bit32.rshift(n2216[1], 16))
							local v81 = table.pack(bit32.band(n2217[1], 65535))
							local v82 = table.pack(bit32.band(bit32.band(v79[1] * v81[1] + bit32.lshift(bit32.band(v79[1] * bit32.rshift(n2217[1], 16) + v80[1] * v81[1], 65535), 16), 4294967295), 4294967295))
							local v83 = table.pack(bit32.band(v82[1], 65535))
							n26 = v28 + bit32.band(64492 * v83[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v82[1], 16) + 27898 * v83[1], 65535), 16), 4294967295)
							local n2218 = table.pack(bit32.band(n22, 4294967295))
							local v84 = table.pack(bit32.band(n2218[1], 65535))
							local v85 = table.pack(bit32.band(bit32.band(v84[1] * 0 + bit32.lshift(bit32.band(v84[1] * 0 + bit32.rshift(n2218[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
							local v86 = table.pack(bit32.band(v85[1], 65535))
							v29 = bit32.band(64492 * v86[1] + bit32.lshift(bit32.band(64492 * bit32.rshift(v85[1], 16) + 27898 * v86[1], 65535), 16), 4294967295)
							local n2219 = table.pack(bit32.band(n226, 4294967295))
							local v87 = table.pack(bit32.band(n2219[1], 65535))
							local v88 = table.pack(bit32.band(bit32.band(v87[1] * 0 + bit32.lshift(bit32.band(v87[1] * 0 + bit32.rshift(n2219[1], 16) * 0, 65535), 16), 4294967295), 4294967295))
							local v89 = table.pack(bit32.band(v88[1], 65535))
							n5 = v27 + n25 + n26 + 0 + v29 + bit32.band(1044 * v89[1] + bit32.lshift(bit32.band(1044 * bit32.rshift(v88[1], 16) + 37637 * v89[1], 65535), 16), 4294967295)
						else
							break
						end
					end

					tbl5 = tbl6[4]
					continue
				end

				v11 = arg[6]
				n6 = buffer.len(v11) - 32 - 19
				n7 = 32 + 888971832 % n6
				n8 = 32

				while true do
					n9 = n8 + (n7 + bit32.band(n5, 255) + 1) % n6
					v112 = buffer.readi8(v11, n7)
					v113 = buffer.readu8(v11, n9)
					v114 = bit32.lshift(bit32.band(v113, 255), 3)
					v12 = bit32.band(bit32.bxor(bit32.bxor(54517094, v112) + v114 + 584826193, n7), 2147483647)
					v115 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v112, v113), v12), 2147483647), 205469696)
					buffer.writeu32(v11, n7, v115)
					v122 = bit32.rshift(v12, 8)
					v116 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v113, v122), n7), 2147483647), 327527424)
					buffer.writeu8(v11, n9, v116)
					n5 = v12
					n7 = n8 + (n7 + bit32.band(v12, 63) + 1) % n6
				end
			end
		end

		v11 = arg[6]
		n6 = buffer.len(v11) - 32 - 19
		n7 = 32 + 888971832 % n6
		n8 = 32

		while true do
			n9 = n8 + (n7 + bit32.band(n5, 255) + 1) % n6
			v112 = buffer.readi8(v11, n7)
			v113 = buffer.readu8(v11, n9)
			v114 = bit32.lshift(bit32.band(v113, 255), 3)
			v12 = bit32.band(bit32.bxor(bit32.bxor(54517094, v112) + v114 + 584826193, n7), 2147483647)
			v115 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v112, v113), v12), 2147483647), 205469696)
			buffer.writeu32(v11, n7, v115)
			v122 = bit32.rshift(v12, 8)
			v116 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v113, v122), n7), 2147483647), 327527424)
			buffer.writeu8(v11, n9, v116)
			n5 = v12
			n7 = n8 + (n7 + bit32.band(v12, 63) + 1) % n6
		end
	end

	fn6(nil, nil, nil, nil, nil)
	local n5 = 132035500
	local n6 = 779964

	while true do
		n5 += n6
	end
end

local function fn6()
	fn4(372868618, 4)
	n4 = 43031001
	fn5()
end

local tbl4 = { [false] = true }
tbl4[true] = false
local tbl5 = {}

local function fn7(arg, arg2)
	if not nil and nil then
		if not nil and nil then
			return true
		end
		return false
	end

	tbl5[arg] = true
	local v11 = tbl5[arg2]
	tbl5[arg] = nil
	return v11
end

local function fn8(arg)
	if not nil then
		fn4(372868618, 4)
		n4 = 43031001
		fn5()
	end

	local kind = type(arg)
	fn7("table", kind)

	if not nil then
		fn4(372868618, 4)
		n4 = 43031001
		fn5()
	end

	local v11 = getmetatable(arg)
	fn7(nil, v11)

	if not nil then
		fn4(372868618, 4)
		n4 = 43031001
		fn5()
	end

	pcall(setmetatable, arg, nil)
end

local function fn9(arg, ...)
	table.pack(string.byte(arg, 1, -1))
	local tbl6 = { nil, 1, 0, select("#", table.unpack(t183_23_1, 1, t183_23_1.n)) + 0, nil }

	while true do
		local v11 = tbl6[2]
		local v12 = tbl6[4]
		local n5 = tbl6[3] + v11
		tbl6[3] = n5

		if n5 <= v12 then
		else
			break
		end
	end

	return 3926377405
end

local function fn10(arg, arg2, arg3)
	for k in arg, nil, nil do
		arg3[fn9(k, 51052561)] = nil
	end

	for k in arg3, nil, nil do
		fn4(372868618, 4)
		n4 = 43031001
		fn5()
	end
end

local new = v4.new
local new2 = v5.new
local new3 = v6.new
local color3New = Color3.new
local rectNew = Rect.new
local uDim2New = UDim2.new
local uDimNew = UDim.new
local new4 = Path2DControlPoint.new
local tbl6 = { what = "C", currentline = -1, short_src = "[C]" }
local str = "linedefined"
local fn82 = fn8
local fn102 = fn10
tbl6[str] = -1
tbl6.isvararg = true
tbl6.namewhat = ""
tbl6.nparams = 0
tbl6.lastlinedefined = -1
tbl6.source = "=[C]"

local function fn11()
end

fn11(getmetatable, "getmetatable")
fn11(setmetatable, "setmetatable")
fn11(tonumber, "tonumber")
fn11(tostring, "tostring")
fn11(rawset, "rawset")
fn11(rawget, "rawget")
fn11(select, "select")
fn11(xpcall, "xpcall")
fn11(assert, "assert")
fn11(error, "error")
fn11(pcall, "pcall")
fn11(type, "type")
fn11(next, "next")
fn11(getfenv, "getfenv")
fn11(setfenv, "setfenv")
fn11(typeof, "typeof")
fn11(string.gmatch, "gmatch")
fn11(string.format, "format")
fn11(string.match, "match")
fn11(string.find, "find")
fn11(string.char, "char")
fn11(string.byte, "byte")
fn11(string.gsub, "gsub")
fn11(string.sub, "sub")
fn11(string.rep, "rep")
fn11(string.unpack, "unpack")
fn11(string.pack, "pack")
fn11(table.concat, "concat")
fn11(table.insert, "insert")
fn11(table.pack, "pack")
fn11(table.clear, "clear")
fn11(table.create, "create")
fn11(table.move, "move")
fn11(bit32.bor, "bor")
fn11(bit32.bnot, "bnot")
fn11(bit32.bxor, "bxor")
fn11(bit32.band, "band")
fn11(bit32.lshift, "lshift")
fn11(bit32.rshift, "rshift")
fn11(bit32.rrotate, "rrotate")
fn11(bit32.lrotate, "lrotate")
fn11(bit32.countlz, "countlz")
fn11(bit32.countrz, "countrz")
fn11(buffer.len, "len")
fn11(buffer.fill, "fill")
fn11(buffer.copy, "copy")
fn11(buffer.create, "create")
fn11(buffer.tostring, "tostring")
fn11(buffer.fromstring, "fromstring")
fn11(buffer.readstring, "readstring")
fn11(buffer.writestring, "writestring")
fn11(buffer.readi8, "readi8")
fn11(buffer.readu8, "readu8")
fn11(buffer.readi16, "readi16")
fn11(buffer.readu16, "readu16")
fn11(buffer.readi32, "readi32")
fn11(buffer.readu32, "readu32")
fn11(buffer.readf32, "readf32")
fn11(buffer.readf64, "readf64")
fn11(buffer.writei8, "writei8")
fn11(buffer.writeu8, "writeu8")
local n5 = 3848217230
fn11(buffer.writei16, "writei16")
fn11(buffer.writeu16, "writeu16")
fn11(buffer.writei32, "writei32")
fn11(buffer.writeu32, "writeu32")
fn11(buffer.writef32, "writef32")
fn11(buffer.writef64, "writef64")
fn11(buffer.readbits, "readbits")
fn11(buffer.writebits, "writebits")
fn11(coroutine.isyieldable, "isyieldable")
fn11(coroutine.running, "running")
fn11(coroutine.create, "create")
fn11(coroutine.status, "status")
fn11(coroutine.yield, "yield")
fn11(coroutine.close, "close")
fn11(coroutine.resume, "resume")
fn11(coroutine.wrap, "wrap")
fn11(cancel, "cancel")
fn11(spawn, "spawn")
fn11(defer, "defer")
fn11(delay, "delay")
fn11(wait, "wait")
fn11(unpack, "unpack")
fn11(info, "info")
fn11(traceback, "traceback")
fn11(v9)
local v11 = pcall
local v12 = xpcall
local n6 = 147701733
local n7 = 109385640
new3(0.56970392783537138, 0.7177542450144142, 0.50622845078979106)
local n8 = 472605665
new("Folder")
local ScreenGui = new("ScreenGui")
local Frame = new("Frame")
local Path2D = new("Path2D")
Frame.Parent = ScreenGui
Path2D.Parent = Frame
vector.create(0.07370192571826828, 0.34066822994289736, 0.14330319227652777)

local function fn12()
	assert(0.86649202372180822)
	getfenv(0)
	tostring(0.55580137640567118)
	rawequal(scratch, scratch)
	local tbl7 = {}
	next(tbl7)
	pairs(tbl7)(tbl7)
	ipairs(tbl7)(tbl7, 1)
	rawlen(tbl7)
	rawget(tbl7, 0.83036873334365979)
	rawset(tbl7, 0.23222585532335926, 0.20233684500220273)
	getmetatable(tbl7)
	setmetatable(tbl7, tbl7)
	setmetatable(tbl7, nil)
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
	local v13 = v8.new()
	v13:NextInteger(45, 248)
	v13:NextNumber(35, 980)
	v13:NextUnitVector()
	v13:NextNumber()
	v13:Shuffle({})
	v13:Clone()
	local n9 = Vector3.new(0.8674313, 0.86681885, 0.26933977) + Vector3.new(0.38818195, 0.7251892, 0.52870774)
	local vector_ = Vector3.new(0.8674313, 0.86681885, 0.26933977)
	local vector_2 = Vector3.new(0.38818195, 0.7251892, 0.52870774)
	local vector_3 = Vector3.new(1, 0, 0)
	local vector_4 = Vector3.new(0, 1, 0)
	local v14 = v7.new()
	local vector_5 = v7.new(vector_)
	v7.Angles(0.79328950042823942, 0.38704401201925887, 0.96996322323574924)
	local xyz = Enum.RotationOrder.XYZ
	v7.new(vector_, n9)
	v7.new(vector_.X, vector_.Y, vector_.Z)
	v7.new(vector_.X, vector_.Y, vector_.Z, 0, 0, 0, 1)
	v7.new(vector_.X, vector_.Y, vector_.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	v7.lookAt(vector_, n9, vector_4)
	v7.lookAlong(vector_, vector_2, vector_4)
	v7.fromEulerAnglesXYZ(0.79328950042823942, 0.38704401201925887, 0.96996322323574924)
	v7.fromEulerAnglesYXZ(0.79328950042823942, 0.38704401201925887, 0.96996322323574924)
	v7.fromOrientation(0.79328950042823942, 0.38704401201925887, 0.96996322323574924)
	v7.fromAxisAngle(vector_2.Unit, 0.79328950042823942)
	v7.fromRotationBetweenVectors(vector_3, vector_4)
	v7.fromMatrix(vector_, vector_3, vector_4, Vector3.new(0, 0, 1))
	v7.fromEulerAngles(0.79328950042823942, 0.38704401201925887, 0.96996322323574924, xyz)
	v14:Inverse()
	v14:Orthonormalize()
	v14:Lerp(vector_5, 0.33319114787106874)
	v14:ToWorldSpace(vector_5)
	v14:ToObjectSpace(vector_5)
	v14:ToEulerAnglesXYZ()
	v14:ToEulerAnglesYXZ()
	v14:PointToWorldSpace(vector_)
	v14:PointToObjectSpace(vector_)
	v14:VectorToWorldSpace(vector_2)
	v14:VectorToObjectSpace(vector_2)
	v14:ToEulerAngles(xyz)
	v14:GetComponents()
	v14:ToOrientation()
	v14:ToAxisAngle()
	v14:FuzzyEq(vector_5)
	v14:AngleBetween(vector_5)
	local vector_6 = Vector3.new(0.49828404, 0.9437861, 0.78076863)
	local vector_7 = Vector3.new(0.31593144, 0.20840542, 0.2626367)
	v5.FromAxis(Enum.Axis.X)
	v5.FromNormalId(Enum.NormalId.Top)
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
	local v15 = uDim2New(0.07719390615672328, 3, 0.21000489770270028, 59)
	local v16 = uDim2New(0.017163361164568458, 24, 0.059917917968274143, 29)
	local v17 = uDim2New(0.81556951795012611, 185, 0.81958095395152064, 178)
	local v18 = new4(v15, v16, v16)
	new4(v15:Lerp(v17, 0.55103166017453975))
	local ctx = {}
	local v19 = new4(v17)
	ctx.v18 = v18
	ctx.v19 = v19
	local v20 = utf8.char(46, 766, 83725)
	utf8.codepoint(v20, 1, #v20)
	utf8.len(v20)
	utf8.offset(v20, 2)
	utf8.offset(v20, -3)
	local v202, v21, v23 = utf8.codes(v20)
	v202(v21, v23)
	v202(v21, utf8.offset(v20, 2))
	local v24 = utf8.char(119, 816)
	utf8.nfcnormalize(v24)
	utf8.nfdnormalize(v20)
	utf8.graphemes(v24, 1, #v24)()
	n7 = (1 * n7 + 39391802) % 268435456
	n6 = (287503 * n6 + 111439069) % 268435456
end

local fn122 = coroutine.wrap(fn12)
local tbl7 = {}
local n9 = 0

local function fn13()
	n9 += 1

	if nil then
		setmetatable({}, { __index = fn6 })
		fn4(372868618, 4)
		n4 = 43031001
		fn5()
		return
	end

	if nil then
		fn122()
	end

	n7 = (1 * n7 + 11083120) % 268435456
	n6 = (327527 * n6 + 64474745) % 268435456
end

setmetatable(tbl7, { __index = fn13, __newindex = fn13 })
local ok, result = pcall(fn13)
local v13 = result

if tbl4[not ok] then
	fn3(12, n5 + 595343517)
else
	fn4(372868618, 4)
	n4 = 43031001
	fn5()
end

if tbl4[not v13] then
	fn4(372868618, 4)
	n4 = 43031001
	fn5()
else
	fn3(81, 148593451)
end

local v14 = luraph_runtime1(table.pack(n6, n7), nil)
local flag = false
local v15
local v16 = luraph_runtime3(table.pack(v11, v15), nil)

local function fn14()
	n6 = (960585 * n6 + 108601139) % 268435456
	n7 = (1 * n7 + 129196086) % 268435456
end

local v17 = luraph_runtime4(table.pack(n7, n6), nil)

local function fn15()
	n7 = n7 - n7 % 2 + 1
	n6 = (502183 * n6 + 4932131) % 268435456
	n6 = (381055 * n6 + 150663887) % 268435456
end

local n10 = 0

fn = function()
	n10 += 1

	if n10 ~= 2499 then
		if n10 == 2498 then
			fn14()
		end

		n6 = (825767 * n6 + 76028495) % 268435456
		n7 = (1 * n7 + 199303012) % 268435456
		fn()
		return
	end

	v14()
	n6 = (633301 * n6 + 118839319) % 268435456
	n7 = (1 * n7 + 227384412) % 268435456
end

fn2 = function(arg)
	if arg ~= 19998 then
		if arg ~= 19997 then
			if arg == 13996 then
				fn12(arg)
			end
		else
			fn12(arg)
		end

		fn2(arg + 1)

		if arg == 19997 then
			if not v12(v14, v17) then
				n7 = n7 - n7 % 2 + 1
				n6 = (109841 * n6 + 221830637) % 268435456
				return
			end

			fn14()

			if not v11(v14) then
				n7 = n7 - n7 % 2 + 1
				n6 = (966177 * n6 + 48847249) % 268435456
				return
			end

			if v12(fn15, fn) then
				n7 = n7 - n7 % 2 + 1
				n6 = (661433 * n6 + 251353109) % 268435456
				return
			end

			v16()

			if flag then
				n7 = n7 - n7 % 2 + 1
				n6 = (82419 * n6 + 130934173) % 268435456
				n6 = (993143 * n6 + 258571403) % 268435456
				return
			end

			n7 = (1 * n7 + 182108670) % 268435456
			n6 = (661321 * n6 + 188621803) % 268435456
		end

		n7 = (1 * n7 + 39749792) % 268435456
		n6 = (573121 * n6 + 248614455) % 268435456
		return
	end

	v14()
	n6 = (96561 * n6 + 140826197) % 268435456
	n7 = (1 * n7 + 2468882) % 268435456
end

local n11 = n5 // 248
coroutine.resume(coroutine.create(fn2), 1)
ScreenGui:Destroy()
local n12 = n8 + 415518735
fn4(n6, 4)
fn4(n7, 4)
local n42 = n4
local n13 = 481860382
local n14 = 1863024894

local v18 = coroutine.wrap(function()
	coroutine.yield(n13)
	coroutine.yield(n14)
	fn4(372868618, 4)
	n4 = 43031001
	fn5()
end)

if fn7(v18(), n13) then
	fn3(1, 148593451)
	n4 = n42
else
	fn4(372868618, 4)
	n4 = 43031001
	fn5()
end

if fn7(v18(), n14) then
	fn3(37, n11 + 133076447)
else
	fn4(372868618, 4)
	n4 = 43031001
	fn5()
end

local thread = coroutine.create(wait)
coroutine.resume(thread, 0)
local n15 = 2681509769
local thread2 = coroutine.status(thread)
fn7("suspended", thread2)

if nil then
	pcall(coroutine.close, thread)
	local v19 = nil
	local flag2 = false

	spawn(function()
		v19 = coroutine.running()
		wait(0)
		flag2 = true
		fn4(372868618, 4)
		n4 = 43031001
		fn5()
	end)

	local flag3 = not pcall(coroutine.close, v19)

	if not nil then
		fn4(372868618, 4)
		n4 = 43031001
		fn5()
	end

	local close = coroutine.close

	local v20 = spawn(function()
		coroutine.yield()
		fn4(372868618, 4)
		n4 = 43031001
		fn5()
	end)

	close(v20)
	local close2 = coroutine.close
	local v21 = defer(fn6)
	close2(v21)
	local close3 = coroutine.close
	local v23 = delay(616, fn6)
	close3(v23)

	local function fn16()
	end

	fn16(getfenv, -4747)
	fn16(setfenv, -31460)
	fn16(getmetatable)
	fn16(setmetatable)
	fn16(tonumber)
	fn16(tostring)
	fn16(rawset)
	local n112 = bit32.band(n11, n15)
	fn16(rawget)
	fn16(assert)
	fn16(type)
	fn16(next)
	fn16(typeof)
	fn16(string.gmatch)
	fn16(string.format)
	local n16 = n12 + n112
	fn16(string.match)
	fn16(string.find)
	fn16(string.byte)
	fn16(string.gsub)
	fn16(string.sub)
	fn16(string.rep)
	fn16(string.char, nil)
	fn16(string.unpack)
	fn16(string.pack)
	fn16(table.concat)
	fn16(table.insert)
	fn16(table.clear)
	fn16(table.create, nil)
	fn16(table.move)
	-- This Source Was Generated by discord.gg/c3xVMnUUBv
	fn16(bit32.bor, nil)
	fn16(bit32.bxor, nil)
	fn16(bit32.band, nil)
	fn16(bit32.bnot)
	fn16(bit32.lshift)
	fn16(bit32.rshift)
	fn16(bit32.rrotate)
	fn16(bit32.lrotate)
	fn16(bit32.countlz)
	fn16(bit32.countrz)
	fn16(buffer.len)
	fn16(buffer.fill)
	local n17 = n112 - n15
	fn16(buffer.copy)
	fn16(buffer.create, nil)
	fn16(buffer.tostring)
	fn16(buffer.fromstring)
	fn16(buffer.readstring)
	fn16(buffer.writestring)
	fn16(buffer.readi8)
	fn16(buffer.readu8)
	fn16(buffer.readi16)
	fn16(buffer.readu16)
	fn16(buffer.readi32)
	fn16(buffer.readu32)
	fn16(buffer.readf32)
	fn16(buffer.readf64)
	fn16(buffer.writei8)
	fn16(buffer.writeu8)
	fn16(buffer.writei16)
	fn16(buffer.writeu16)
	fn16(buffer.writei32)
	fn16(buffer.writeu32)
	fn16(buffer.writef32)
	fn16(buffer.writef64)
	fn16(buffer.readbits)
	fn16(buffer.writebits)
	fn16(coroutine.create)
	fn16(coroutine.status)
	fn16(coroutine.close)
	fn16(coroutine.resume)
	fn16(coroutine.wrap)
	fn16(cancel)
	fn16(spawn)
	fn16(defer)
	fn16(delay)
	fn16(wait, {})
	fn16(unpack)
	fn16(info)
	fn16(v9)
	fn11(new, "new")
	fn16(new, nil)
	fn11(new2, "new")
	fn11(new3, "new")
	fn11(color3New, "new")
	fn11(rectNew, "new")
	local fromAxis = v5.FromAxis
	local n18 = 2899954607
	fn11(fromAxis, "FromAxis")
	fn16(fromAxis, nil)
	local vector_ = fromAxis(Enum.Axis.Y)
	local bottom = v5.FromNormalId(Enum.NormalId.Bottom)
	local kind = type(vector_)
	local kind2 = type(bottom)

	if kind == "vector" then
		fn3(222, 148593451)
		local n19 = kind2 == "vector" and 111 or 129
		fn3(n19, 148593451)
		local y = bottom.Y
		fn4(vector_.Y * 953604573, 4)
		local n20 = n16 + n18
		fn4(y * -1 * 741150457, 4)

		if fn7("vector", kind) then
			fn3(229, n17 - 1477743188)
			n4 = n42

			if fn7("vector", kind2) then
				fn3(243, 148593451)
			else
				fn4(372868618, 4)
				n4 = 43031001
				fn5()
			end

			fn3(vector_.X == 0 and 15 or 161, 148593451)
			fn3(vector_.Y == 1 and 129 or 72, n17 - 1477743188)
			fn3(vector_.Z == 0 and 184 or 200, n18 - 2751361156)
			fn3(bottom.X == 0 and 165 or 240, 148593451)
			fn3(bottom.Y == -1 and 168 or 210, n17 + 2817224108)
			local n21
			n21 = bottom.Z == 0 and 13 or 156
			fn3(n21, n18 + 1543606140)
			local n172
			n172 = bit32.bor(n17, n18)
			fn11(uDim2New, "new")
			fn11(uDimNew, "new")
			fn102(utf8, 218723579, { [1986724197] = 1631743329, [3912424273] = 733687465, [2204466326] = 1503519080 })
			local tbl8
			tbl8 = {}
			local v24 = utf8.nfcnormalize("뫂춥퉐릻켙냖")

			do
				local values = table.pack(v24:byte(1, -1))
				table.move(values, 1, values.n, 1, tbl8)
			end

			local tbl9
			tbl9 = {}
			local n22
			local v25 = utf8.nfdnormalize("뿇듧죝떠ō뵗덑")
			n22 = n18 - n20

			do
				local values = table.pack(v25:byte(1, -1))
				table.move(values, 1, values.n, 1, tbl9)
			end

			local v26, v27, v28, v29, v30, v31, v32, v33, v34, v35
			local v36, n23, v37, tbl10, v38

			do
				local v39 = tbl9[22]
				fn3(v39, 148593451)
				local v40 = tbl8[16]
				fn3(v40, n172 + 467364652)
				v26 = tbl9[12]
				fn3(v26, 148593451)
				v27 = tbl8[17]
				fn3(v27, 148593451)
				v28 = tbl9[16]
				fn3(v28, n172 + 467364652)
				v29 = tbl9[35]
				fn3(v29, n22 + 1049596963)
				v30 = tbl9[39]
				fn3(v30, 148593451)
				v31 = tbl9[18]
				fn3(v31, n172 - 3827602644)
				fn3(tbl8[10], 148593451)
				v32 = tbl9[17]
				fn3(v32, 148593451)
				fn3(tbl9[33], n172 - 3827602644)
				v33 = tbl9[8]
				fn3(v33, n22 - 3245370333)
				fn3(tbl8[15], 148593451)
				fn3(tbl9[15], n172 - 3827602644)
				v34 = tbl9[23]
				fn3(v34, 148593451)
				fn3(tbl8[18], 148593451)
				v35 = tbl9[24]
				v36 = v39
				fn3(v35, v36 - 4146374070)
				fn3(tbl9[13], n22 + 1049596963)
				fn3(tbl8[1], 148593451)
				local v41 = tbl9[2]
				n23 = n20 + v40
				fn3(v41, 148593451)
				local v42 = tbl8[11]
				fn3(v42, n22 + 1049596963)
				fn3(tbl9[38], 148593451)
				v37 = tbl9[5]
				fn3(v37, v36 + 148593226)
				local v43 = tbl8[6]
				tbl10 = v41
				v38 = v42
				fn3(v43, n22 + 1049596963)
			end

			local v39
			v39 = tbl9[29]
			fn3(v39, 148593451)
			fn3(tbl8[3], v36 - 4146374070)
			fn3(tbl9[36], n22 + 1049596963)
			fn3(tbl9[32], 148593451)
			local v40
			v40 = tbl9[4]
			fn3(v40, v36 - 4146374070)
			fn3(tbl9[52], n22 + 1049596963)
			fn3(tbl9[40], 148593451)
			local v41
			v41 = tbl8[8]
			fn3(v41, v36 + 148593226)
			local n222, v42, v43, n24
			local v44 = tbl9[49]
			fn3(v44, n22 - 3245370333)
			n222 = bit32.bor(n22, v26)
			fn3(tbl9[37], 148593451)
			v42 = tbl9[30]
			fn3(v42, v36 + 148593226)
			v43 = tbl9[54]
			fn3(v43, n222 - 3245370464)
			n24 = v44
			local v45
			v45 = tbl9[19]
			fn3(v45, 148593451)
			local v46
			v46 = tbl8[5]
			fn3(v46, v36 - 4146374070)
			fn3(tbl9[34], n222 - 3245370464)
			fn3(tbl8[2], 148593451)
			local v47
			v47 = tbl9[43]
			fn3(v47, v36 + 148593226)
			local v48
			v48 = tbl9[45]
			fn3(v48, 148593451)
			fn3(tbl9[27], 148593451)
			local v49
			v49 = tbl9[21]
			fn3(v49, v36 + 148593226)
			local v50
			v50 = tbl8[7]
			fn3(v50, 148593451)
			local v51
			v51 = tbl9[1]
			fn3(v51, 148593451)
			fn3(tbl9[20], 148593451)
			fn3(tbl9[11], n222 + 1049596832)
			local v52
			v52 = tbl8[4]
			fn3(v52, 148593451)
			fn3(tbl9[9], v36 + 148593226)
			local n25, v53, v54

			do
				local v55 = tbl9[26]
				local v392 = bit32.band(v36, v27)
				fn3(v55, n222 - 3245370464)
				fn3(tbl9[7], 148593451)
				fn3(tbl8[13], 148593451)
				fn3(tbl9[25], n222 + 1049596832)
				fn3(tbl9[10], 148593451)
				fn3(tbl9[44], v392 + 148593322)
				n25 = n23 + v28
				fn3(tbl9[42], n222 + 1049596832)
				fn3(tbl9[48], 148593451)
				fn3(tbl9[51], 148593451)
				fn3(tbl9[41], n222 + 1049596832)
				fn3(tbl8[9], 148593451)
				fn3(tbl8[14], v392 + 148593322)
				local v56 = tbl9[53]
				local n26 = v392 // v29
				fn3(v56, n222 + 1049596832)
				fn3(tbl9[50], 148593451)
				v53 = tbl9[3]
				fn3(v53, n26 - 4146373845)
				fn3(tbl9[28], n222 - 3245370464)
				v54 = tbl9[14]
				fn3(v54, 148593451)
				fn3(tbl9[31], n26 + 148593451)
				fn3(tbl9[6], 148593451)
				fn3(tbl9[47], 148593451)
				fn3(tbl8[12], n26 - 4146373845)
			end

			fn3(tbl9[46], 148593451)
			fn11(new4, "new")
			fn16(new4, nil)
			local ScreenGui2
			ScreenGui2 = new("ScreenGui")
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
				local tbl11 = {}
				local v55 = new4(uDim2New(0, -4, 0, -6), uDim2New(0, -1, 0, 7), uDim2New(0, 6, 0, -1))
				local v56 = new4(uDim2New(0, -10, 0.25, -9), uDim2New(0.0625, -4, -0.125, 6), uDim2New(0, 5, 0, -8))
				local v57 = uDim2New(0.5, -8, 0.25, 2)
				local v58 = uDim2New(0.125, 7, -0.0625, -1)
				tbl11[1] = v55
				tbl11[2] = v56

				do
					local values = table.pack(new4(v57, v58, uDim2New(0, 0, 0, 0)))
					table.move(values, 1, values.n, 3, tbl11)
				end

				setControlPoints(Path2D2, tbl11)
			end

			do
				local n26 = n25 + v30
				local length = Path2D2:GetLength()
				fn4(string.unpack(">I4", string.pack(">f", length)), 4)
				local positionOnCurve = Path2D2:GetPositionOnCurve(0.5)
				fn4(string.unpack(">I4", string.pack(">f", positionOnCurve.X.Scale)), 4)
				local unpack_ = string.unpack
				fn4(unpack_(">I4", string.pack(">f", positionOnCurve.Y.Scale)), 4)
				local positionOnCurve2 = Path2D2:GetPositionOnCurve(0.46666666865348816)
				fn4(string.unpack(">I4", string.pack(">f", positionOnCurve2.X.Scale)), 4)
				fn4(string.unpack(">I4", string.pack(">f", positionOnCurve2.Y.Scale)), 4)
				local tangentOnCurve = Path2D2:GetTangentOnCurve(0.25)
				fn4(string.unpack("<I4", string.pack(">f", tangentOnCurve.X)), 4)
				fn4(string.unpack("<I4", string.pack(">f", tangentOnCurve.Y)), 4)
				local tangentOnCurve2 = Path2D2:GetTangentOnCurve(0.75)
				fn4(string.unpack("<I4", string.pack("<f", tangentOnCurve2.X)), 4)
				fn4(string.unpack(">I4", string.pack("<f", tangentOnCurve2.Y)), 4)
				local positionOnCurveArcLength = Path2D2:GetPositionOnCurveArcLength(0.625)
				fn4(string.unpack(">I4", string.pack("<f", positionOnCurveArcLength.X.Scale)), 4)
				fn4(string.unpack("<I4", string.pack(">f", positionOnCurveArcLength.Y.Scale)), 4)
				local positionOnCurveArcLength2 = Path2D2:GetPositionOnCurveArcLength(0.5)
				fn4(string.unpack(">I4", string.pack(">f", positionOnCurveArcLength2.X.Scale)), 4)
				fn4(string.unpack("<I4", string.pack(">f", positionOnCurveArcLength2.Y.Scale)), 4)
				local positionOnCurveArcLength3 = Path2D2:GetPositionOnCurveArcLength(0.083333335816860199)
				fn4(string.unpack("<I4", string.pack("<f", positionOnCurveArcLength3.X.Scale)), 4)
				local n27 = n26 + v33
				fn4(string.unpack("<I4", string.pack("<f", positionOnCurveArcLength3.Y.Scale)), 4)
				local tangentOnCurveArcLength = Path2D2:GetTangentOnCurveArcLength(0.15384615957736969)
				fn4(string.unpack("<I4", string.pack("<f", tangentOnCurveArcLength.X)), 4)
				fn4(string.unpack("<I4", string.pack(">f", tangentOnCurveArcLength.Y)), 4)
				local tangentOnCurveArcLength2 = Path2D2:GetTangentOnCurveArcLength(0.375)
				fn4(string.unpack(">I4", string.pack(">f", tangentOnCurveArcLength2.X)), 4)
				fn4(string.unpack(">I4", string.pack(">f", tangentOnCurveArcLength2.Y)), 4)
				local tangentOnCurveArcLength3 = Path2D2:GetTangentOnCurveArcLength(0.53846156597137451)
				fn4(string.unpack(">I4", string.pack("<f", tangentOnCurveArcLength3.X)), 4)
				fn4(string.unpack("<I4", string.pack(">f", tangentOnCurveArcLength3.Y)), 4)
				ScreenGui2:Destroy()
				fn102(math, 218723579, { [3668483602] = 331635280, [1303859104] = 1381494275, [1292485390] = 1059621379 })

				fn102(v10, 218723579, {
					[1420216976] = 752316410,
					[194463251] = 1377272538,
					[4280857151] = 1916921198,
					[4273605931] = 2077633238,
					[1618608716] = 1869670192,
				})

				fn102(v3, 218723579, { [2759041104] = 1297627627, [356266053] = 2063474335 })
				local gameRef = game
				local workspaceRef = workspace

				local function fn17(arg, arg2, arg3)
					local state = 1
					local n28, n29, n30, arg22, arg32, parent, parent2, name, name2, ancestryChanged, resume, parent3, parent4, v55, parent5, fn42, flag4, resume2, flag5, v56, flag6, flag7, parent6, parent7, v57, fn43, flag8, flag82, v58, v59, flag9

					while true do
						local n31

						if state <= 112 then
							if state <= 56 then
								if state <= 28 then
									if state <= 14 then
										if state == 1 then
											n28 = 1983948755
											n29 = 1107289406
											n30 = arg
											arg22 = arg2
											arg32 = arg3
											local kind3 = type(arg22)
											fn7("userdata", kind3)

											if nil then
												state = 3
											else
												state = 2
											end
										elseif state == 2 then
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
											state = 3
										elseif state == 3 then
											local kind3 = typeof(arg22)
											fn7("Instance", kind3)

											if nil then
												state = 5
											else
												state = 4
											end
										elseif state == 4 then
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
											state = 5
										elseif state == 5 then
											parent = arg22.Parent
											parent2 = arg22.Parent

											if tbl4[not parent] then
												state = 6
											else
												state = 9
											end
										elseif state == 6 then
											fn7(parent, parent2)

											if nil then
												state = 8
											else
												state = 7
											end
										elseif state == 7 then
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
											state = 8
										elseif state == 8 then
											state = 9
										elseif state == 9 then
											name = arg22.Name
											name2 = arg22.Name
											local kind3 = type(name)
											fn7("string", kind3)

											if nil then
												state = 11
											else
												state = 10
											end
										elseif state == 10 then
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
											state = 11
										elseif state == 11 then
											fn7(name, name2)

											if nil then
												state = 13
											else
												state = 12
											end
										elseif state == 12 then
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
											state = 13
										elseif state == 13 then
											local n32 = #name
											local n33 = #name2
											local fn72 = fn7
											local n332 = table.pack(bit32.band(n33, 4294967295))
											local v60 = table.pack(bit32.band(n332[1], 65535))
											local v61 = bit32.band(54259 * v60[1] + bit32.lshift(bit32.band(54259 * bit32.rshift(n332[1], 16) + 37619 * v60[1], 65535), 16), 4294967295)
											local n333 = table.pack(bit32.band(bit32.bnot(n33), 4294967295))
											local v62 = table.pack(bit32.band(n333[1], 65535))
											n30 = 2629977780 + n30 + v61 + bit32.band(54259 * v62[1] + bit32.lshift(bit32.band(54259 * bit32.rshift(n333[1], 16) + 37619 * v62[1], 65535), 16), 4294967295)
											fn72(n32, n33)

											if nil then
												state = 15
											else
												state = 14
											end
										elseif state == 14 then
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
											state = 15
										end
									elseif state == 15 then
										fn7(tostring(arg22), name)

										if nil then
											state = 17
										else
											state = 16
										end
									elseif state == 16 then
										state = 35
									elseif state == 17 then
										fn7(arg32, arg22.ClassName)

										if nil then
											state = 19
										else
											state = 18
										end
									elseif state == 18 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 19
									elseif state == 19 then
										ancestryChanged = arg22.AncestryChanged
										arg32 = arg22.AncestryChanged
										n29 = bit32.band(n29, n30)
										fn7(ancestryChanged, arg32)

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
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 22
									elseif state == 22 then
										local connect = ancestryChanged.Connect
										local connect2 = ancestryChanged.Connect
										fn11(connect, "Connect")
										fn11(connect2, "Connect")
										fn7(connect, connect2)

										if nil then
											state = 23
										else
											state = 24
										end
									elseif state == 23 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 24
									elseif state == 24 then
										local flag10 = false
										local destroying = arg22.Destroying
										local destroying2 = destroying
										local connect = destroying.Connect
										local n302 = bit32.bxor(n30, 280525953)

										local function fn18()
											flag10 = true

											if nil then
												n302 = bit32.bxor(n302, 3235034115)
											end
										end

										n302 = bit32.bxor(n302, 148119644)
										arg32 = connect(destroying2, fn18)

										if nil then
											state = 26
										else
											state = 25
										end
									elseif state == 25 then
										state = 27
									elseif state == 26 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 27
									elseif state == 27 then
										if nil then
											state = 28
										else
											state = 42
										end
									elseif state == 28 then
										local disconnect = arg32.Disconnect
										fn11(disconnect, "Disconnect")
										fn16(disconnect, nil)
										disconnect(arg32)
										n29 = bit32.bxor(n29, n30)

										if n30 + 1906447 == 365670673 then
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
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 48
									elseif state == 35 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 17
									elseif state == 36 then
										local v60 = getmetatable(arg22)
										fn7("The metatable is locked", v60)

										if nil then
											state = 38
										else
											state = 37
										end
									elseif state == 37 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 38
									elseif state == 38 then
										if n30 + 501065228 ~= 361643982 then
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
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
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
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 47
								elseif state == 47 then
									local wait2 = ancestryChanged.Wait
									n30 += 76178503
									fn11(wait2, "Wait")
									n31 = 12478618

									local function fn18()
										local wait3 = wait2

										if nil then
											n31 = bit32.bxor(n31, 1430127237)
										end

										return (wait3(ancestryChanged))
									end

									n31 = bit32.bxor(12478618, n29 - 4246385089)
									arg32 = coroutine.create(fn18)
									resume = coroutine.resume
									state = 145
								elseif state == 48 then
									local kind3 = typeof(arg22)
									fn7("Instance", kind3)

									if nil then
										state = 50
									else
										state = 49
									end
								elseif state == 49 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 50
								elseif state == 50 then
									parent3 = arg22.Parent
									parent4 = arg22.Parent
									v55 = tbl4[not parent3]
									state = 51
								elseif state == 51 then
									if v55 then
										state = 52
									else
										state = 59
									end
								elseif state == 52 then
									parent5 = parent3
									fn7(parent5, parent4)

									if nil then
										state = 58
									else
										state = 53
									end
								elseif state == 53 then
									fn42 = fn4

									if n28 == 369465669 then
										state = 55
									else
										state = 54
									end
								elseif state == 54 then
									fn42(372868618, 4)
									n4 = 43031001
									fn5()
									state = 58
								elseif state == 55 then
									local n292 = bit32.band(n29, 3464781827)
									local thread3 = coroutine.status(arg32)
									flag4 = not fn7("dead", thread3)
									n29 = n292 - 4294960640

									if flag4 then
										state = 56
									else
										state = 85
									end
								elseif state == 56 then
									fn4(372868618, 4)

									if n28 == 282554691 then
										state = 76
									else
										state = 57
									end
								end
							elseif state <= 84 then
								if state <= 70 then
									if state == 57 then
										n4 = 43031001
										fn5()
										state = 85
									elseif state == 58 then
										state = 59
									elseif state == 59 then
										flag4 = arg22.Name
										parent5 = arg22.Name
										local kind3 = type(flag4)
										fn7("string", kind3)

										if nil then
											state = 61
										else
											state = 60
										end
									elseif state == 60 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 61
									elseif state == 61 then
										fn7(flag4, parent5)

										if nil then
											state = 63
										else
											state = 62
										end
									elseif state == 62 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 63
									elseif state == 63 then
										local n32 = #flag4
										local n33 = #parent5
										local fn72 = fn7
										local n332 = table.pack(bit32.band(n33, 4294967295))
										local v60 = table.pack(bit32.band(n332[1], 65535))
										local v61 = bit32.band(54259 * v60[1] + bit32.lshift(bit32.band(54259 * bit32.rshift(n332[1], 16) + 37619 * v60[1], 65535), 16), 4294967295)
										local n333 = table.pack(bit32.band(bit32.bnot(n33), 4294967295))
										local v62 = table.pack(bit32.band(n333[1], 65535))
										n30 = 2629977780 + n30 + v61 + bit32.band(54259 * v62[1] + bit32.lshift(bit32.band(54259 * bit32.rshift(n333[1], 16) + 37619 * v62[1], 65535), 16), 4294967295)
										fn72(n32, n33)

										if nil then
											state = 65
										else
											state = 64
										end
									elseif state == 64 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 65
									elseif state == 65 then
										fn7(tostring(arg22), flag4)

										if nil then
											state = 66
										else
											state = 84
										end
									elseif state == 66 then
										fn7(arg32, arg22.ClassName)

										if nil then
											state = 68
										else
											state = 67
										end
									elseif state == 67 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 68
									elseif state == 68 then
										ancestryChanged = arg22.AncestryChanged
										arg32 = arg22.AncestryChanged
										n29 = bit32.band(n29, n30)
										fn7(ancestryChanged, arg32)

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
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 71
									end
								elseif state == 71 then
									local connect = ancestryChanged.Connect
									local connect2 = ancestryChanged.Connect
									fn11(connect, "Connect")
									fn11(connect2, "Connect")
									fn7(connect, connect2)

									if nil then
										state = 72
									else
										state = 73
									end
								elseif state == 72 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 73
								elseif state == 73 then
									local flag10 = false
									local destroying = arg22.Destroying
									local connect = destroying.Connect
									local n302 = bit32.bxor(n30, 280525953)

									local function fn18()
										flag10 = true

										if nil then
											n302 = bit32.bxor(n302, 3235034115)
										end
									end

									n302 = bit32.bxor(n302, n28 - 787161745)
									arg32 = connect(destroying, fn18)

									if nil then
										state = 75
									else
										state = 74
									end
								elseif state == 74 then
									state = 76
								elseif state == 75 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 76
								elseif state == 76 then
									if nil then
										state = 77
									else
										state = 90
									end
								elseif state == 77 then
									local disconnect = arg32.Disconnect
									fn11(disconnect, "Disconnect")
									fn16(disconnect, nil)
									disconnect(arg32)
									n29 = bit32.bxor(n29, n30)

									if n30 + 1906447 == 365670673 then
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
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 97
								elseif state == 84 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 66
								end
							elseif state <= 98 then
								if state == 85 then
									local v60 = getmetatable(arg22)
									fn7("The metatable is locked", v60)

									if nil then
										state = 87
									else
										state = 86
									end
								elseif state == 86 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 87
								elseif state == 87 then
									if n30 + 501065228 ~= 361643982 then
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
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
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
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 95
								elseif state == 95 then
									local wait2 = ancestryChanged.Wait
									n30 += 76178503
									fn11(wait2, "Wait")
									n31 = bit32.bxor(n28, 922823287)

									local function fn18()
										local wait3 = wait2

										if nil then
											n31 = bit32.bxor(n31, 1430127237)
										end

										return (wait3(ancestryChanged))
									end

									n31 = bit32.bxor(n31, n29 - 4246385089)
									arg32 = coroutine.create(fn18)
									resume2 = coroutine.resume

									if n28 + 535532559 == 397500711 then
										state = 96
									else
										state = 195
									end
								elseif state == 96 then
									state = 195
								elseif state == 97 then
									local kind3 = typeof(arg22)
									fn7("Instance", kind3)

									if nil then
										state = 99
									else
										state = 98
									end
								elseif state == 98 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 99
								end
							elseif state == 99 then
								parent3 = arg22.Parent
								parent4 = arg22.Parent
								v55 = tbl4[not parent3]
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
								flag5 = tbl4[not name]
								state = 103
							elseif state == 103 then
								if flag5 then
									state = 105
								else
									state = 104
								end
							elseif state == 104 then
								local thread3 = coroutine.status(arg32)
								flag5 = not fn7("suspended", thread3)
								state = 105
							elseif state == 105 then
								if flag5 then
									state = 106
								else
									state = 107
								end
							elseif state == 106 then
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
								state = 107
							elseif state == 107 then
								local ok2, result2 = pcall(coroutine.close, arg32)
								v56 = result2
								local v60 = tbl4[not ok2]
								flag6 = not v60

								if v60 then
									state = 109
								else
									state = 108
								end
							elseif state == 108 then
								name = flag6
								state = 110
							elseif state == 109 then
								name = not tbl4[not v56]
								state = 110
							elseif state == 110 then
								if name then
									state = 112
								else
									state = 111
								end
							elseif state == 111 then
								local n292 = bit32.band(n29, 3464781827)
								local thread3 = coroutine.status(arg32)
								name = not fn7("dead", thread3)
								n29 = n292 - 4294960640
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
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 114
									elseif state == 114 then
										local v60 = getmetatable(arg22)
										fn7("The metatable is locked", v60)

										if nil then
											state = 116
										else
											state = 115
										end
									elseif state == 115 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 116
									elseif state == 116 then
										if n30 + 501065228 ~= 361643982 then
											state = 221
										else
											state = 117
										end
									elseif state == 117 then
										ancestryChanged = arg22.AncestryChanged
										arg32 = arg22.AncestryChanged
										n29 = bit32.band(n29, n30)
										fn7(ancestryChanged, arg32)

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
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 120
									elseif state == 120 then
										local connect = ancestryChanged.Connect
										local connect2 = ancestryChanged.Connect
										fn11(connect, "Connect")
										fn11(connect2, "Connect")
										fn7(connect, connect2)

										if nil then
											state = 121
										else
											state = 122
										end
									elseif state == 121 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 122
									elseif state == 122 then
										local flag10 = false
										local destroying = arg22.Destroying
										local destroying2 = destroying
										local connect = destroying.Connect
										local n302 = bit32.bxor(n30, 280525953)

										local function fn18()
											flag10 = true

											if nil then
												n302 = bit32.bxor(n302, 3235034115)
											end
										end

										n302 = bit32.bxor(n302, 148119644)
										arg32 = connect(destroying2, fn18)

										if nil then
											state = 124
										else
											state = 123
										end
									elseif state == 123 then
										state = 125
									elseif state == 124 then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
										state = 125
									elseif state == 125 then
										if nil then
											state = 126
										else
											state = 139
										end
									elseif state == 126 then
										local disconnect = arg32.Disconnect
										fn11(disconnect, "Disconnect")
										fn16(disconnect, nil)
										disconnect(arg32)
										n29 = bit32.bxor(n29, n30)

										if n30 + 1906447 == 365670673 then
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
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
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
									name = arg22.Name
									name2 = arg22.Name
									local kind3 = type(name)
									fn7("string", kind3)

									if nil then
										state = 137
									else
										state = 136
									end
								elseif state == 136 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 137
								elseif state == 137 then
									fn7(name, name2)

									if nil then
										state = 147
									else
										state = 138
									end
								elseif state == 138 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 147
								elseif state == 139 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
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
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 144
								elseif state == 144 then
									local wait2 = ancestryChanged.Wait
									n30 += 76178503
									fn11(wait2, "Wait")
									n31 = 12478618

									local function fn18()
										local wait3 = wait2

										if nil then
											n31 = bit32.bxor(n31, 1430127237)
										end

										return (wait3(ancestryChanged))
									end

									n31 = bit32.bxor(12478618, n29 - 4246385089)
									arg32 = coroutine.create(fn18)
									resume = coroutine.resume
									state = 145
								elseif state == 145 then
									local v60, v61 = resume(arg32)
									name = v61
									local v62 = tbl4[not v60]
									flag7 = not v62

									if v62 then
										state = 102
									else
										state = 146
									end
								elseif state == 146 then
									flag5 = flag7
									state = 103
								elseif state == 147 then
									local n32 = #name
									local n33 = #name2
									local fn72 = fn7
									local n332 = table.pack(bit32.band(n33, 4294967295))
									local v60 = table.pack(bit32.band(n332[1], 65535))
									local v61 = bit32.band(54259 * v60[1] + bit32.lshift(bit32.band(54259 * bit32.rshift(n332[1], 16) + 37619 * v60[1], 65535), 16), 4294967295)
									local n333 = table.pack(bit32.band(bit32.bnot(n33), 4294967295))
									local v62 = table.pack(bit32.band(n333[1], 65535))
									n30 = 2629977780 + n30 + v61 + bit32.band(54259 * v62[1] + bit32.lshift(bit32.band(54259 * bit32.rshift(n333[1], 16) + 37619 * v62[1], 65535), 16), 4294967295)
									fn72(n32, n33)

									if nil then
										state = 149
									else
										state = 148
									end
								elseif state == 148 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 149
								elseif state == 149 then
									fn7(tostring(arg22), name)

									if nil then
										state = 151
									else
										state = 150
									end
								elseif state == 150 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 151
								elseif state == 151 then
									fn7(arg32, arg22.ClassName)

									if nil then
										state = 117
									else
										state = 152
									end
								elseif state == 152 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 117
								elseif state == 153 then
									local kind3 = typeof(arg22)
									fn7("Instance", kind3)

									if nil then
										state = 155
									else
										state = 154
									end
								elseif state == 154 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 155
								end
							elseif state == 155 then
								parent6 = arg22.Parent
								parent7 = arg22.Parent
								v57 = tbl4[not parent6]
								state = 156
							elseif state == 156 then
								if v57 then
									state = 157
								else
									state = 161
								end
							elseif state == 157 then
								parent5 = parent6
								fn7(parent5, parent7)

								if nil then
									state = 160
								else
									state = 158
								end
							elseif state == 158 then
								fn43 = fn4

								if n28 == 369465669 then
									state = 212
								else
									state = 159
								end
							elseif state == 159 then
								fn43(372868618, 4)
								n4 = 43031001
								fn5()
								state = 160
							elseif state == 160 then
								state = 161
							elseif state == 161 then
								flag4 = arg22.Name
								parent5 = arg22.Name
								local kind3 = type(flag4)
								fn7("string", kind3)

								if nil then
									state = 163
								else
									state = 162
								end
							elseif state == 162 then
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
								state = 163
							elseif state == 163 then
								fn7(flag4, parent5)

								if nil then
									state = 165
								else
									state = 164
								end
							elseif state == 164 then
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
								state = 165
							elseif state == 165 then
								local n32 = #flag4
								local n33 = #parent5
								local fn72 = fn7
								local n332 = table.pack(bit32.band(n33, 4294967295))
								local v60 = table.pack(bit32.band(n332[1], 65535))
								local v61 = bit32.band(54259 * v60[1] + bit32.lshift(bit32.band(54259 * bit32.rshift(n332[1], 16) + 37619 * v60[1], 65535), 16), 4294967295)
								local n333 = table.pack(bit32.band(bit32.bnot(n33), 4294967295))
								local v62 = table.pack(bit32.band(n333[1], 65535))
								n30 = 2629977780 + n30 + v61 + bit32.band(54259 * v62[1] + bit32.lshift(bit32.band(54259 * bit32.rshift(n333[1], 16) + 37619 * v62[1], 65535), 16), 4294967295)
								fn72(n32, n33)

								if nil then
									state = 167
								else
									state = 166
								end
							elseif state == 166 then
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
								state = 167
							elseif state == 167 then
								fn7(tostring(arg22), flag4)

								if nil then
									state = 168
								else
									state = 186
								end
							elseif state == 168 then
								fn7(arg32, arg22.ClassName)

								if nil then
									state = 170
								else
									state = 169
								end
							end
						elseif state <= 196 then
							if state <= 182 then
								if state == 169 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 170
								elseif state == 170 then
									ancestryChanged = arg22.AncestryChanged
									arg32 = arg22.AncestryChanged
									n29 = bit32.band(n29, n30)
									fn7(ancestryChanged, arg32)

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
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 173
								elseif state == 173 then
									local connect = ancestryChanged.Connect
									local connect2 = ancestryChanged.Connect
									fn11(connect, "Connect")
									fn11(connect2, "Connect")
									fn7(connect, connect2)

									if nil then
										state = 174
									else
										state = 175
									end
								elseif state == 174 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 175
								elseif state == 175 then
									local flag10 = false
									local destroying = arg22.Destroying
									local connect = destroying.Connect
									local n302 = bit32.bxor(n30, 280525953)

									local function fn18()
										flag10 = true

										if nil then
											n302 = bit32.bxor(n302, 3235034115)
										end
									end

									n302 = bit32.bxor(n302, n28 - 787161745)
									arg32 = connect(destroying, fn18)

									if nil then
										state = 177
									else
										state = 176
									end
								elseif state == 176 then
									state = 178
								elseif state == 177 then
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									state = 178
								elseif state == 178 then
									if nil then
										state = 179
									else
										state = 189
									end
								elseif state == 179 then
									local disconnect = arg32.Disconnect
									fn11(disconnect, "Disconnect")
									fn16(disconnect, nil)
									disconnect(arg32)
									n29 = bit32.bxor(n29, n30)

									if n30 + 1906447 == 365670673 then
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
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
								state = 197
							elseif state == 186 then
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
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
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
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
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
								state = 194
							elseif state == 194 then
								local wait2 = ancestryChanged.Wait
								n30 += 76178503
								fn11(wait2, "Wait")
								n31 = bit32.bxor(n28, 922823287)

								local function fn18()
									local wait3 = wait2

									if nil then
										n31 = bit32.bxor(n31, 1430127237)
									end

									return (wait3(ancestryChanged))
								end

								n31 = bit32.bxor(n31, n29 - 4246385089)
								arg32 = coroutine.create(fn18)
								resume2 = coroutine.resume
								state = 195
							elseif state == 195 then
								local v60, v61 = resume2(arg32)
								flag4 = v61
								local v62 = tbl4[not v60]
								flag8 = not v62

								if v62 then
									state = 201
								else
									state = 196
								end
							elseif state == 196 then
								flag82 = flag8
								state = 202
							end
						elseif state <= 210 then
							if state == 197 then
								local kind3 = typeof(arg22)
								fn7("Instance", kind3)

								if nil then
									state = 199
								else
									state = 198
								end
							elseif state == 198 then
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
								state = 199
							elseif state == 199 then
								parent6 = arg22.Parent
								parent7 = arg22.Parent
								v57 = tbl4[not parent6]
								state = 156
							elseif state == 200 then
								if nil <= 0 then
									state = 171
								else
									state = 201
								end
							elseif state == 201 then
								flag82 = tbl4[not flag4]
								state = 202
							elseif state == 202 then
								if flag82 then
									state = 204
								else
									state = 203
								end
							elseif state == 203 then
								local thread3 = coroutine.status(arg32)
								flag82 = not fn7("suspended", thread3)
								state = 204
							elseif state == 204 then
								if flag82 then
									state = 205
								else
									state = 206
								end
							elseif state == 205 then
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
								state = 206
							elseif state == 206 then
								local ok2, result2 = pcall(coroutine.close, arg32)
								v58 = result2
								v59 = tbl4[not ok2]
								flag9 = n28 ~= 195444195

								if flag9 then
									state = 208
								else
									state = 207
								end
							elseif state == 207 then
								state = 208
							elseif state == 208 then
								if v59 then
									state = 210
								else
									state = 209
								end
							elseif state == 209 then
								flag4 = flag9
								state = 211
							elseif state == 210 then
								flag4 = not tbl4[not v58]
								state = 211
							end
						elseif state == 211 then
							if flag4 then
								state = 213
							else
								state = 212
							end
						elseif state == 212 then
							local n292 = bit32.band(n29, 3464781827)
							local thread3 = coroutine.status(arg32)
							flag4 = not fn7("dead", thread3)
							n29 = n292 - 4294960640
							state = 213
						elseif state == 213 then
							if flag4 then
								state = 214
							else
								state = 216
							end
						elseif state == 214 then
							fn4(372868618, 4)

							if n28 == 282554691 then
								state = 178
							else
								state = 215
							end
						elseif state == 215 then
							n4 = 43031001
							fn5()
							state = 216
						elseif state == 216 then
							local v60 = getmetatable(arg22)
							fn7("The metatable is locked", v60)

							if nil then
								state = 218
							else
								state = 217
							end
						elseif state == 217 then
							fn4(372868618, 4)
							n4 = 43031001
							fn5()
							state = 218
						elseif state == 218 then
							if n30 + 501065228 ~= 361643982 then
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
							fn4(372868618, 4)
							state = 225
						elseif state == 221 then
							return
						elseif state == 222 then
							fn4(372868618, 4)

							if n29 + 37915839 == 12018273 then
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

				fn17(12486496, gameRef, "DataModel")
				fn17(12486496, workspaceRef, "Workspace")

				if fn7(gameRef, workspaceRef.Parent) then
					fn3(150, 148593451)
					n4 = n42
				else
					fn4(372868618, 4)
					n4 = 43031001
					fn5()
				end

				local Folder = new("Folder")
				fn17(12486496, Folder, "Folder")
				local n28 = n27 + v34
				local ok2, result2 = pcall(Folder.GetChildren, Vector3.new(-66.08093, -84.9317, 763.03735), 1824775727)
				local flag4 = not ok2

				if tbl4[flag4] then
					while true do
					end
				else
					local iter_f_1, Folder2, Folder3, n43

					do
						do
							do
								fn4(fn9(result2, 51052561), 4)

								do
									local n44 = n4

									if tbl4[flag4] then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
									else
										fn3(126, 148593451)
										n4 = n44
									end
								end
							end

							do
								local children, v55, v56 = Folder:GetChildren()
								iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v57, v310, v410, v58, v62, v72, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v57, v310, v410, v58, v62, v72, v82, v92, v102) end end); co(); return co end)(children, v55, v56)
							end
						end

						do
							local v55 = table.pack(iter_f_1())

							if v55[1] then
								repeat
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
									local v56 = table.pack(iter_f_1())
								until not v56[1]
							end

							Folder:Destroy()

							do
								local n44 = n4
								Folder2 = Folder
								Folder3 = new("Folder", Folder2)
								fn17(12486496, Folder3, "Folder")

								if fn7(Folder2, Folder3.Parent) then
									n43 = n44
									fn3(77, 148593451)
									n4 = n43
								else
									n43 = n44
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
								end
							end
						end

						if fn7(Folder3.Parent, Folder3.Parent) then
							fn3(194, 148593451)
						else
							fn4(372868618, 4)
							n4 = 43031001
							fn5()
						end

						do
							local waitForChild = Folder2.WaitForChild
							fn11(waitForChild, "WaitForChild")
							fn16(waitForChild, nil)
							local name = tostring(1264550249)
							Folder3.Name = name
							local v55 = waitForChild(Folder2, name)

							if fn7(Folder3, v55) then
								fn3(121, 148593451)
							else
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
							end
						end
					end

					Folder2:Destroy()
					Folder3:Destroy()

					do
						local n29 = n28 + v35
						local n30 = 4062162997
						local n212 = n21
						local str2 = "Parent"
						local n31 = 4062162997
						local flag5

						while true do
							local n32

							do
								do
									local n312 = table.pack(bit32.band(n31, 4294967295))
									local n213 = table.pack(bit32.band(n212, 4294967295))
									local v55 = table.pack(bit32.band(n312[1], 65535))
									local v56 = table.pack(bit32.rshift(n312[1], 16))
									local v57 = table.pack(bit32.band(n213[1], 65535))

									do
										local v58 = bit32.band(v55[1] * v57[1] + bit32.lshift(bit32.band(v55[1] * bit32.rshift(n213[1], 16) + v56[1] * v57[1], 65535), 16), 4294967295)
										local n214 = table.pack(bit32.band(bit32.bnot(n212), 4294967295))
										local v59 = table.pack(bit32.band(n214[1], 65535))
										n32 = n29 + n30 + v58 + bit32.band(45109 * v59[1] + bit32.lshift(bit32.band(45109 * bit32.rshift(n214[1], 16) + 61983 * v59[1], 65535), 16), 4294967295)
									end
								end

								do
									local n44

									do
										if tbl4[not Folder3[str2]] then
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
										else
											fn3(32, 148593451)
										end

										if tbl4[not pcall(function()
											Folder3.Parent = Folder2
										end)] then
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
										else
											fn3(141, 148593451)
										end

										n4 = n43

										do
											local HttpService = gameRef:GetService("HttpService")
											fn17(12486496, HttpService, "HttpService")
											local fn72 = fn7
											local n442 = n4

											if fn72(gameRef, HttpService.Parent) then
												n43 = n442
												fn3(66, 148593451)
												n4 = n43
												n44 = n43
											else
												n44 = n442
												fn4(372868618, 4)
												n4 = 43031001
												fn5()
											end

											if not n then
												fn11(HttpService.GetAsync, "GetAsync")
												fn11(HttpService.PostAsync, "PostAsync")
												fn11(HttpService.RequestAsync, "RequestAsync")
											end
										end
									end

									do
										local RunService = gameRef:GetService("RunService")
										fn17(12486496, RunService, "RunService")

										if fn7(gameRef, RunService.Parent) then
											n = 161
											fn3(n, 148593451)
											n4 = n44
										else
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
										end

										fn11(RunService.IsStudio, "IsStudio")
										fn11(RunService.IsClient, "IsClient")
										fn11(RunService.IsServer, "IsServer")
										fn16(RunService.IsStudio)
										fn16(RunService.IsClient)
										fn16(RunService.IsServer)
										RunService:IsServer()
									end

									if nil then
										do
											local StarterPlayer = gameRef:GetService("StarterPlayer")
											fn17(12486496, StarterPlayer, "StarterPlayer")
											fn7(gameRef, StarterPlayer.Parent)
											if not nil then
												break
											end
											local children, v55, v56 = StarterPlayer:GetChildren()
											iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v57, v310, v410, v58, v62, v72, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v57, v310, v410, v58, v62, v72, v82, v92, v102) end end); co(); return co end)(children, v55, v56)
										end

										local v55 = table.pack(iter_f_1())

										if v55[1] then
											repeat
												local v56 = table.pack(iter_f_1())
											until not v56[1]
										end

										if nil then
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
										end
									end

									if tbl4[not pcall(gameRef.GetChildren)] then
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
									else
										fn3(217, 148593451)
										n4 = n44
									end
								end
							end

							local n33, v55, v56, v57, tbl11, n34, tbl12, n35, tbl13, v58
							local v59, v60, v61, v62, tbl14, v63, tbl12Map, v64, n36, v65
							local tbl15, n37, n38, v66, n39, tbl16, v67, v68, v69, n392
							local tbl17, v70, tbl18, n40, n41, v71, n44, n45, v72

							do
								n33 = Enum

								do
									local fn72 = fn7
									local n442 = n4

									if fn72(type(n33), "userdata") then
										fn3(205, 148593451)
										n4 = n442
										str2 = n442
									else
										str2 = n442
										fn4(372868618, 4)

										if v47 == 225.0000000000241 then
											n41 = (n33 + tbl10[1]) % 16777216
											tbl14 = { nil, 1, 6, 0, tbl[3] }

											while true do
												v69 = tbl14[2]
												v61 = tbl14[3]
												n39 = tbl14[4] + v69
												tbl14[4] = n39

												if n39 <= v61 then
													n392 = n39
													n34 = (n41 * (tbl10[2] * 2 + 1) + tbl10[3]) % 16777216
													n24 = n34 % 4096
													n41 = ((n24 * 4096 + (n34 - n34 % 4096) // 4096 + tbl10[4]) % 16777216 + n392 * tbl10[5]) % 16777216

													if nil then
														n41 = (n41 + tbl10[6]) % 16777216
													end
												else
													break
												end
											end

											v67 = tbl14[5]
											fn4((math_floor_precision(n33) - n41) % 16777216, 8)
											tbl12Map = {}
											gameRef = 16705
											tbl18 = { 16, 1, -1, v67, nil }

											while true do
												v60 = tbl18[2]
												v72 = tbl18[1]
												n37 = tbl18[3] + v60
												tbl18[3] = n37

												if n37 <= v72 then
													v59 = n37
													tbl12 = {}
													tbl12Map[tbl12] = v59 + 1
												else
													break
												end
											end

											v55 = tbl18[4]
											iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v73, v310, v410, v510, v610, v74, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v73, v310, v410, v510, v610, v74, v82, v92, v102) end end); co(); return co end)(tbl12Map, nil, nil)
											local v73 = table.pack(iter_f_1())

											if v73[1] then
												v68 = v73[3]

												while true do
													gameRef = (gameRef * v68 + v68 * 411) % 16776960 + 1
													local v74 = table.pack(iter_f_1())

													if v74[1] then
														v68 = v74[3]
													else
														break
													end
												end
											end

											n35 = n32 + v52
											n30 = 20084442667
											local n302 = table.pack(bit32.band(n30, 4294967295))
											local v74 = table.pack(bit32.band(n302[1], 65535))
											n31 = 1595630789 + bit32.band(31223 * v74[1] + bit32.lshift(bit32.band(31223 * bit32.rshift(n302[1], 16) + 5879 * v74[1], 65535), 16), 4294967295)
											n212 = 3524332562
											v56 = bit32.bor(2931427363, n30)
											local n2122 = table.pack(bit32.band(n212, 4294967295))
											local v562 = table.pack(bit32.band(v56, 4294967295))
											local v75 = table.pack(bit32.band(n2122[1], 65535))
											local v76 = table.pack(bit32.rshift(n2122[1], 16))
											local v77 = table.pack(bit32.band(v562[1], 65535))
											n29 = 12884901888
											n36 = (-8589934591 * (1 + ((n31 + bit32.band(v75[1] * v77[1] + bit32.lshift(bit32.band(v75[1] * bit32.rshift(v562[1], 16) + v76[1] * v77[1], 65535), 16), 4294967295) + 1712676800) * 67108864 + n29) / 4503599627370496) * 2 ^ 12884901911 + 1) % 16777216
											tbl10 = {}
											tbl13 = { 0, 6, 1, nil, v55 }

											while true do
												v70 = tbl13[3]
												v64 = tbl13[2]
												n44 = tbl13[1] + v70
												tbl13[1] = n44

												if n44 <= v64 then
													n36 = (n36 * 1103515245 + 12345) % 16777216
													tbl10[n44] = n36
												else
													break
												end
											end

											fn82 = (gameRef + tbl10[1]) % 16777216
											tbl15 = { tbl13[5], 1, nil, 6, 0 }

											while true do
												v62 = tbl15[2]
												v57 = tbl15[4]
												n40 = tbl15[5] + v62
												tbl15[5] = n40

												if n40 <= v57 then
													v66 = n40
													n38 = (fn82 * (tbl10[2] * 2 + 1) + tbl10[3]) % 16777216
													n24 = n38 % 4096
													fn82 = ((n24 * 4096 + (n38 - n38 % 4096) // 4096 + tbl10[4]) % 16777216 + v66 * tbl10[5]) % 16777216

													if nil then
														fn82 = (fn82 + tbl10[6]) % 16777216
													end
												else
													break
												end
											end

											tbl = tbl15[1]
											v63 = math_floor_precision

											if v32 ~= 134.00000000001432 then
												fn4((v63(gameRef) - fn82) % 16777216, 8)
												tbl16 = {}
												tbl11 = { tbl, 1, nil, -1, 16 }

												while true do
													v71 = tbl11[2]
													v65 = tbl11[5]
													n45 = tbl11[4] + v71
													tbl11[4] = n45

													if n45 <= v65 then
														v58 = n45
														tbl17 = {}
														tbl16[tbl17] = v58 + 1
													else
														break
													end
												end

												iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v78, v310, v410, v510, v610, v79, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v78, v310, v410, v510, v610, v79, v82, v92, v102) end end); co(); return co end)(tbl16, nil, nil)
												local v78 = table.pack(iter_f_1())

												if v78[1] then
													while true do
														local v79 = table.pack(iter_f_1())

														if v79[1] then
														else
															break
														end
													end
												end

												if v54 ~= 133 then
												end

												return tbl2()
											end

											continue
										end

										if v53 == 136.00000000002433 then
										end

										n4 = 43031001
										fn5()
									end
								end
							end

							local n46

							do
								if fn7(typeof(n33), "Enums") then
									fn3(65, 148593451)
								else
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
								end

								n46 = n32 + v38

								do
									local v73 = getmetatable(n33)

									if fn7("The metatable is locked", v73) then
										fn3(191, 148593451)
									else
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
									end
								end
							end

							local wedge = n33.PartType.Wedge

							if fn7(type(wedge), "userdata") then
								fn3(197, 148593451)
							else
								fn4(372868618, 4)
								n4 = 43031001
								fn5()
							end

							if fn7(typeof(wedge), "EnumItem") then
								do
									fn3(53, 148593451)

									do
										local v73 = getmetatable(wedge)

										if fn7("The metatable is locked", v73) then
											fn3(243, 148593451)
										else
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
										end
									end
								end

								local v372 = v37
								fn11(wedge.IsA, "IsA")
								fn16(wedge.IsA)
								local name = wedge.Name
								local value = wedge.Value

								if fn7(type(name), "string") then
									fn3(136, 148593451)
								else
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
								end

								if fn7(type(value), "number") then
									fn3(154, 148593451)
								else
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
								end

								local enumType = wedge.EnumType

								if fn7(wedge, enumType[name]) then
									fn3(201, 148593451)
								else
									fn4(372868618, 4)
									n4 = 43031001
									fn5()
								end

								if fn7(type(enumType), "userdata") then
									do
										do
											fn3(96, 148593451)

											if fn7(typeof(enumType), "Enum") then
												fn3(231, 148593451)
											else
												fn4(372868618, 4)
												n4 = 43031001
												fn5()
												n46 = n46 + v39 - 132
											end

											do
												local v73 = getmetatable(enumType)

												if fn7("The metatable is locked", v73) then
													fn3(147, 148593451)
												else
													fn4(372868618, 4)
													n4 = 43031001
													fn5()
												end
											end
										end

										fn11(enumType.FromName, "FromName")
										fn11(enumType.FromValue, "FromValue")
										fn16(enumType.FromName)
										fn16(enumType.FromValue)

										do
											local v73 = enumType:FromName(name)

											if fn7(wedge, v73) then
												fn3(170, 148593451)
											else
												fn4(372868618, 4)
												n4 = 43031001
												fn5()
											end
										end
									end

									do
										local v73 = enumType:FromValue(value)

										if fn7(wedge, v73) then
											fn3(70, 148593451)
										else
											fn4(372868618, 4)
											n4 = 43031001
											fn5()
										end
									end

									local new5 = v8.new
									fn11(new5, "new")
									fn16(new5, {})
									local v73 = new5(1902607061)

									if fn7(type(v73), "userdata") then
										fn3(177, 148593451)
										n4 = str2
									else
										fn4(372868618, 4)
										n4 = 43031001
										fn5()
									end

									if fn7(typeof(v73), "Random") then
										local clone, clone2, clone3

										do
											local clone4, clone5

											do
												do
													local v74

													do
														fn3(61, 148593451)
														fn11(v73.NextUnitVector, "NextUnitVector")
														fn11(v73.NextInteger, "NextInteger")
														fn11(v73.NextNumber, "NextNumber")
														fn11(v73.Shuffle, "Shuffle")
														fn11(v73.Clone, "Clone")
														v74 = new5(1542707265)

														do
															local unpack_2 = string.unpack
															local pack = string.pack
															local randNum = v74:NextNumber()
															fn4(unpack_2("<I4", pack("<f", randNum)), 4)
														end
													end

													do
														local clone6 = v74:Clone()
														fn4(v74:NextInteger(379, 733), 4)
														clone4 = v74:Clone()
														n = v74:NextInteger(6, 885)
														fn4(n, 4)
														clone = v74:Clone()
														clone5 = clone6
													end
												end

												n43 = clone:NextInteger(667, 1468)
												fn4(n43, 4)

												do
													local unpack_2 = string.unpack
													local pack = string.pack
													local randNum = clone:NextNumber()
													fn4(unpack_2(">I4", pack(">f", randNum)), 4)
												end
											end

											local clone6

											do
												clone2 = clone4:Clone()

												do
													local randInt = clone4:NextInteger(345, 719)
													fn4(randInt, 4)
													clone6 = clone2:Clone()
													fn4(clone:NextInteger(996, 1063), 4)
													local unpack_2 = string.unpack
													local pack = string.pack
													local randNum = clone4:NextNumber()
													fn4(unpack_2(">I4", pack(">f", randNum)), 4)
													fn17 = randInt
												end
											end

											clone3 = clone:Clone()

											do
												local unpack_2 = string.unpack
												local pack = string.pack
												local randNum = clone2:NextNumber()
												fn4(unpack_2("<I4", pack(">f", randNum)), 4)
											end

											fn4(clone6:NextInteger(417, 1147), 4)
											fn4(clone5:NextInteger(760, 1646), 4)
										end

										do
											local unpack_2 = string.unpack
											local pack = string.pack
											local randNum = clone3:NextNumber()
											fn4(unpack_2("<I4", pack("<f", randNum)), 4)
										end

										local n47, n48, n49, n50, tbl19

										do
											fn4(clone2:NextInteger(978, 1747), 4)
											fn4(clone:NextInteger(385, 609), 4)
											n47 = 316
											n48 = v372 + v40 + v41
											n49 = n46 + n24

											do
												local tbl20 = {
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
													[2303840004] = n47,
													[3630343396] = n47,
													[4280663915] = 79,
													[183578560] = 158,
													[3675778740] = 79,
													[703510772] = n47,
													[2829995296] = 79,
													[2369744814] = 79,
													[1793178485] = 79,
													[1805206170] = n47,
													[2309351533] = n47,
													[1081002712] = n47,
													[3900348838] = n47,
													[1980836295] = 79,
													[2616090782] = 79,
													[547114585] = n47,
													[1778055736] = n47,
													[1146902328] = 158,
													[855780562] = n47,
													[2901047036] = 79,
													[2137590078] = n47,
												}

												local env = getfenv()
												local envMap = {}
												local tbl21 = {}
												n50 = 0
												tbl19 = { nil, 0, 1, 3, tbl }

												while true do
													local v74 = tbl19[3]
													local v75 = tbl19[4]
													local n51 = tbl19[2] + v74
													tbl19[2] = n51

													if n51 <= v75 then
														if not nil and not nil then
															do
																envMap[env] = true

																do
																	local n52 = 0
																	iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v76, v310, v410, v510, v610, v77, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v76, v310, v410, v510, v610, v77, v82, v92, v102) end end); co(); return co end)(env, nil, nil)

																	for k in env, nil, nil do
																		n52 += 1

																		do
																			local kind3 = type(k)

																			if fn7("string", kind3) then
																				if #k < 20 then
																					local v76 = fn9(k, 51052561)

																					if tbl21[v76] then
																						if n52 > 50 then
																							break
																						end
																					else
																						n50 += tbl20[v76] or 0
																						tbl21[v76] = true
																						if n52 > 50 then
																							break
																						end
																					end
																				elseif n52 > 50 then
																					break
																				end
																			elseif n52 > 50 then
																				break
																			end
																		end
																	end
																end
															end

															do
																local n502 = n50
																local v76 = getmetatable(env)
																local flag6 = type(v76) == "table"
																local n5022, value2

																if flag6 then
																	n5022 = n502
																	value2 = rawget(v76, "__index")
																else
																	n5022 = n502
																	value2 = flag6
																end

																if value2 then
																	do
																		local n5023 = n5022
																		env = value2
																		n50 = n5023
																	end

																	continue
																end

																n50 = n5022
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
											local v74 = tbl19[5]
											local n51 = n50 < n47 and 219 or 243
											fn3(n51, 148593451)

											if not nil then
												local n52, n53, v75

												do
													do
														local result3, result4, v76

														do
															do
																local ok3, v77

																do
																	local result5
																	ok3, result5 = pcall(assert, false)
																	v77 = result5
																end

																local ok4 = ok3 or not v77 or type(v77) ~= "string"

																if ok4 then
																	fn4(372868618, 4)
																	n4 = 43031001
																	fn5()
																end
															end

															do
																local ok3, v77

																do
																	local ok4, result5 = pcall(function(w, ...)
	(...)[...] = nil
end)

																	ok3 = ok4
																	v77 = result5
																end

																do
																	local ok4

																	ok4, result3 = pcall(function(w, ...)
	return (...)[...]
end)

																	local ok5

																	ok5, result4 = pcall(function(w, ...)
	return (...)()
end)

																	if ok3 or ok4 or ok5 then
																		fn4(372868618, 4)
																		n4 = 43031001
																		fn5()
																	end
																end

																do
																	local function fn18(arg, arg2)
																		local pos, v78, n54 = string.find(arg, ":[^%a%A]-([0-9][0-9]*)[\n:\r]")
																		local flag6 = not pos
																		local flag7

																		if pos then
																			flag7 = not v78
																		else
																			flag7 = flag6
																		end

																		if flag7 then
																			fn4(372868618, 4)
																			n4 = 43031001
																			fn5()
																		end

																		fn4(pos, 2)
																		fn4(v78, 2)
																		local match = string.match(arg, ":([%d]%d*)[^%l%L]-[\n\r%:]")
																		local fn42 = fn4
																		local match2

																		if n54 then
																			match2 = match
																		else
																			match2 = match
																			n54 = 0
																		end

																		fn42(n54 + 0, 2)
																		fn4((match2 or 0) + 0, 2)
																		local v79 = string.gmatch(arg, "%:([%d]%d*)[^%p%P]*[\r:\n]")
																		local n55 = v79()
																		local fn72 = fn7

																		if not fn7(v79(), nil) then
																			fn4(372868618, 4)
																			n4 = 43031001
																			fn5()

																			if type(fn72) == "userdata" then
																				fn4(372868618, 4)

																				n4 = 43031001
																				;(nil)[">f"] = 100

																				while true do
																					while not (nil <= nil) do
																					end

																					fn4(372868618, 4)

																					n4 = 43031001
																					;(nil)[">f"] = 100
																				end
																			end
																		end

																		local fn43 = fn4
																		local fn432

																		if n55 then
																			fn432 = fn43
																		else
																			fn432 = fn43
																			n55 = 0
																		end

																		fn432(n55 + 0, 2)
																		local str3 = string.sub(arg, pos + 1, v78 - 1)
																		local v80 = string.char(string.byte(arg, pos + 1, v78 - 1))
																		local v81 = string.byte(arg, pos + 1, pos + 1)
																		fn4(str3 + 0, 2)
																		fn4(v80 + 0, 2)
																		fn3(v81, 148593451)
																		local tbl20 = { v78 - 1 + 0, nil, pos + 1 - 1, 1, nil }
																		local n56 = 0
																		local tbl202 = tbl20

																		while true do
																			local v82 = tbl202[4]
																			local v83 = tbl202[1]
																			local n57 = tbl202[3] + v82
																			tbl202[3] = n57

																			if n57 <= v83 then
																				n56 = n56 * 10 + string.byte(arg, n57, n57) - 48
																			else
																				break
																			end
																		end

																		fn4(n56, 2)
																		local v82 = nil
																		local n57 = 0
																		local n58 = 99901787

																		local function fn19(arg3)
																			v82 = arg3
																			local n572 = n57

																			if nil then
																				n58 = bit32.bxor(n58, 2666527995)
																			end

																			n57 = n572 + 1
																		end

																		n58 = 264577875
																		local str4, v83 = string.gsub(arg, "[%:][^%d%D]?([%d]+)[%:\n\r][^%u%U]*", fn19, 1)
																		fn7(n57, 1)

																		if nil then
																		else
																			fn4(372868618, 4)
																			n4 = 43031001
																			fn5()
																		end

																		fn7(v83, 1)

																		if not nil then
																			fn4(372868618, 4)
																			n4 = 43031001
																			fn5()
																		end

																		fn4((v82 or 0) + 0, 2)
																		fn7(string.sub(arg, 2, 2), arg2)
																		if nil then
																			fn3(string.byte(arg, 2, 2), 148593451)
																			return
																		end

																		while true do
																			fn4(372868618, 4)

																			n4 = 43031001
																			;(nil)[">f"] = 100

																			while not (nil <= nil) do
																			end
																		end
																	end

																	fn18("xisbLUyDc:111: attempt to call a userdata value", "i", 413312038)
																	fn18("LocalScript:101: attempt to index string with function", "o", 413312038)
																	fn18("LocalScript:132: attempt to index nil with string", "o", 413312038)
																	fn18("source.lua:110: attempt to index userdata with boolean", "o", 413312038)
																end

																v22 = function(arg)
																	local state = 1
																	local flag6, fn18, match, v78, pos, flag62, flag7, flag72, v79, n54, n55, gsub, n56, flag8, n57, n58, n59, n60, fn72

																	while true do
																		if state <= 40 then
																			if state <= 20 then
																				if state == 1 then
																					flag6 = arg
																					fn18 = nil
																					state = 2
																				elseif state == 2 then
																					match = string.match(flag6, "%:([0-9][0-9]*)[\n:\r]")
																					v78 = string.gmatch(flag6, "[%:](%d%d*)[^%w%W]*[\r%:\n]")()
																					local v80
																					pos, v80 = string.find(flag6, "[:][^%w%W]?(%d+)[%:\r\n]")
																					flag62 = v80
																					flag7 = not pos

																					if pos then
																						state = 4
																					else
																						state = 3
																					end
																				elseif state == 3 then
																					flag72 = flag7
																					state = 5
																				elseif state == 4 then
																					flag72 = not flag62
																					state = 5
																				elseif state == 5 then
																					if flag72 then
																						state = 6
																					else
																						state = 7
																					end
																				elseif state == 6 then
																					fn4(372868618, 4)
																					n4 = 43031001
																					fn5()
																					state = 7
																				elseif state == 7 then
																					local str3 = string.sub(flag6, pos + 1, flag62 - 1)
																					flag62 = string.char(string.byte(flag6, pos + 1, flag62 - 1))
																					v79 = nil
																					n54 = 0
																					n55 = 515348854
																					pos = str3

																					fn18 = function(arg2)
																						local info2 = info
																						local n61

																						if nil then
																							n61 = 1
																							n55 = bit32.bxor(n55, 2255202949)
																						else
																							n61 = 1
																						end

																						local v80 = info2(n61, "f")
																						fn7(v80, fn18)

																						if not nil then
																							fn4(372868618, 4)
																							n4 = 43031001
																							fn5()
																						end

																						local v81 = info(2, "f")
																						fn7(v81, string.gsub)

																						if not nil then
																							fn4(372868618, 4)
																							n4 = 43031001
																							fn5()
																						end

																						local v82 = info(3, "f")
																						fn7(v82, v22)

																						if not nil then
																							fn4(372868618, 4)
																							n4 = 43031001
																							fn5()
																						end

																						v79 = arg2
																						n54 = (n55 == 480569521) + 1
																					end

																					gsub = string.gsub
																					n56 = 480569521
																					state = 8
																				elseif state == 8 then
																					n55 = n56
																					local v80
																					v80, flag6 = gsub(flag6, "%:([%d]%d*)[^%s%S]-[:\n\r][^%u%U]*", fn18, 1)
																					fn7(n54, 1)

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
																					fn7(flag6, 1)

																					if nil then
																						state = 12
																					else
																						state = 67
																					end
																				elseif state == 12 then
																					flag8 = not match

																					if match then
																						state = 14
																					else
																						state = 13
																					end
																				elseif state == 13 then
																					flag6 = flag8
																					state = 15
																				elseif state == 14 then
																					flag6 = not v78
																					state = 15
																				elseif state == 15 then
																					if flag6 then
																						state = 16
																					else
																						state = 74
																					end
																				elseif state == 16 then
																					if flag6 then
																						state = 17
																					else
																						state = 46
																					end
																				elseif state == 17 then
																					if flag6 then
																						state = 18
																					else
																						state = 72
																					end
																				elseif state == 18 then
																					if flag6 then
																						state = 19
																					else
																						state = 20
																					end
																				elseif state == 19 then
																					fn4(372868618, 4)
																					n4 = 43031001
																					fn5()
																					state = 20
																				elseif state == 20 then
																					flag6 = match + 0
																					n57 = v78 + 0
																					n58 = pos + 0
																					n59 = flag62 + 0
																					n60 = v79 + 0
																					fn72 = fn7
																					fn7(match, v78)

																					if nil then
																						state = 22
																					else
																						state = 21
																					end
																				end
																			elseif state == 21 then
																				match = n57
																				state = 58
																			elseif state == 22 then
																				match = n57
																				state = 23
																			elseif state == 23 then
																				fn7(v78, pos)

																				if nil then
																					state = 24
																				else
																					state = 69
																				end
																			elseif state == 24 then
																				fn7(pos, flag62)

																				if nil then
																					state = 25
																				else
																					state = 41
																				end
																			elseif state == 25 then
																				fn7(flag62, v79)

																				if nil then
																					state = 26
																				else
																					state = 38
																				end
																			elseif state == 26 then
																				fn7(flag6, match)

																				if nil then
																					state = 75
																				else
																					state = 27
																				end
																			elseif state == 27 then
																				fn4(372868618, 4)
																				n4 = 43031001
																				fn5()

																				if fn72 then
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
																				fn4(372868618, 4)
																				n4 = 43031001
																				fn5()
																				state = 26
																			elseif state == 39 then
																				fn4(372868618, 4)
																				n4 = 43031001
																				fn5()
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
																				fn4(372868618, 4)
																				n4 = 43031001
																				fn5()
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
																				flag6 = not flag62
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
																				fn18 = function(arg2)
																					local info2 = info
																					local n61

																					if nil then
																						n61 = 1
																						n55 = bit32.bxor(n55, 2255202949)
																					else
																						n61 = 1
																					end

																					local v80 = info2(n61, "f")
																					fn7(v80, fn18)

																					if not nil then
																						fn4(372868618, 4)
																						n4 = 43031001
																						fn5()
																					end

																					local v81 = info(2, "f")
																					fn7(v81, string.gsub)

																					if not nil then
																						fn4(372868618, 4)
																						n4 = 43031001
																						fn5()
																					end

																					local v82 = info(3, "f")
																					fn7(v82, v22)

																					if not nil then
																						fn4(372868618, 4)
																						n4 = 43031001
																						fn5()
																					end

																					v79 = arg2
																					n54 = (n55 == 480569521) + 1
																				end

																				gsub = string.gsub
																				n56 = bit32.bxor(n55, 34828743)
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
																				fn4(372868618, 4)
																				n4 = 43031001
																				fn5()
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
																			fn4(372868618, 4)
																			n4 = 43031001
																			fn5()
																			state = 12
																		elseif state == 68 then
																			if nil <= 4 then
																				state = 25
																			else
																				state = 69
																			end
																		elseif state == 69 then
																			fn4(372868618, 4)
																			n4 = 43031001
																			fn5()
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
																			flag6 = not v79
																			state = 18
																		elseif state == 73 then
																			if nil <= 0 then
																				state = 4
																			else
																				state = 74
																			end
																		elseif state == 74 then
																			flag6 = not pos
																			state = 16
																		elseif state == 75 then
																			fn7(match, n58)

																			if nil then
																				state = 77
																			else
																				state = 76
																			end
																		elseif state == 76 then
																			fn4(372868618, 4)
																			n4 = 43031001
																			fn5()
																			state = 77
																		elseif state == 77 then
																			fn7(n58, n59)

																			if nil then
																				state = 79
																			else
																				state = 78
																			end
																		elseif state == 78 then
																			fn4(372868618, 4)
																			n4 = 43031001
																			fn5()
																			state = 79
																		elseif state == 79 then
																			fn7(n59, n60)

																			if nil then
																				state = 81
																			else
																				state = 80
																			end
																		elseif state == 80 then
																			fn4(372868618, 4)
																			n4 = 43031001
																			fn5()
																			state = 81
																		elseif state == 81 then
																			return flag6
																		end
																	end
																end

																v76 = v22(v77)
															end
														end

														do
															do
																do
																	local v77 = v22(result3)
																	local v78 = v22(result4)

																	if fn7(v76, v77) then
																		fn3(165, 148593451)
																		n4 = str2
																	else
																		fn4(372868618, 4)
																		n4 = 43031001
																		fn5()
																	end

																	if fn7(v77, v78) then
																		fn3(183, 148593451)
																	else
																		fn4(372868618, 4)
																		n4 = 43031001
																		fn5()
																	end

																	n52 = n49 + v42

																	if fn7(v78, v76) then
																		fn3(114, 148593451)
																	else
																		fn4(372868618, 4)
																		n4 = 43031001
																		fn5()
																	end
																end

																n53 = n48 + v43

																do
																	local tbl20 = {}
																	iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v77, v310, v410, v510, v610, v78, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v77, v310, v410, v510, v610, v78, v82, v92, v102) end end); co(); return co end)(tbl20, nil, nil)

																	for _, v77 in tbl20, nil, nil do
																		do
																			local exitTo2 = nil

																			while true do
																				local kind3 = type(v77)

																				if fn7("function", kind3) then
																					info(v77, "sl")
																					local v78 = table.pack(iter_f_1())

																					if v78[1] then
																						v77 = v78[3]
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

															fn82(nil --[[ the caller's registers ]], 505483899)
															setmetatable(nil --[[ the caller's registers ]], nil)

															do
																local tbl20 = {}
																local tbl21 = {}
																local n54 = 73
																local n55 = 71
																local tbl22 = { v74, 1, 255, nil, -1 }

																while true do
																	local v77 = tbl22[2]
																	local v78 = tbl22[3]
																	local n56 = tbl22[5] + v77
																	tbl22[5] = n56

																	if n56 <= v78 then
																		local n562 = n56
																		local n57 = (n54 * n562 + n55) % 256
																		local n58 = (n54 * n57 + n55) % 256
																		local n59 = (n54 * n58 + n55) % 256
																		local n60 = (n54 * n59 + n55) % 256
																		tbl20[n562] = n57 + n58 * 256 + n59 * 65536 + n60 * 16777216
																		tbl21[n562] = n60
																	else
																		break
																	end
																end

																v75 = tbl22[1]
															end
														end
													end

													buffer.create(16)

													do
														local n54 = 5
														local n55 = 6
														local n56 = 7
														local n57 = 8
														r__R3[n54] = 2
														r__R3[n55] = 6
														r__R3[n56] = 10
														r__R3[n57] = 14
													end
												end

												local n54, v76, n55, n56

												do
													local n57

													do
														do
															do
																local n58 = 15
																local n59 = 16
																r__R3[n58] = 12
																r__R3[n59] = 16
															end
														end

														n57 = n53 // v45

														do
															local n58 = 21
															local n59 = 22
															local n60 = 23
															local n61 = 24
															r__R3[n58] = 2
															r__R3[n59] = 7
															r__R3[n60] = 12
															r__R3[n61] = 13
														end
													end

													r__R3[32] = 15

													do
														local tbl20 = {}
														local n58 = n52 + v46
														n54 = 16705
														local tbl21 = { nil, v75, 16, -1, 1 }

														while true do
															local v77 = tbl21[5]
															local v78 = tbl21[3]
															local n59 = tbl21[4] + v77
															tbl21[4] = n59

															if n59 <= v78 then
																local n592 = n59
																tbl20[{}] = n592 + 1
															else
																break
															end
														end

														v76 = tbl21[2]
														iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v77, v310, v410, v510, v610, v78, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v77, v310, v410, v510, v610, v78, v82, v92, v102) end end); co(); return co end)(tbl20, nil, nil)
														local v77 = table.pack(iter_f_1())

														if v77[1] then
															local v78 = v77[3]

															while true do
																n54 = (n54 * v78 + v78 * 411) % 16776960 + 1
																local v79 = table.pack(iter_f_1())

																if v79[1] then
																	v78 = v79[3]
																else
																	break
																end
															end
														end

														n55 = n58 + v47
													end

													n56 = n57 - v48
												end

												local v77, n57, tbl20

												do
													local n58 = (-8589934591 * (1 + (8636599760 * 67108864 + 4294967296) / 4503599627370496) * 2 ^ 8589934615 + 1) % 16777216
													local tbl21 = {}
													local tbl22 = { 1, v76, 6, nil, 0 }

													while true do
														local v78 = tbl22[1]
														local v79 = tbl22[3]
														local n59 = tbl22[5] + v78
														tbl22[5] = n59

														if n59 <= v79 then
															n58 = (n58 * 1103515245 + 12345) % 16777216
															tbl21[n59] = n58
														else
															break
														end
													end

													v77 = tbl22[2]
													n57 = (n54 + tbl21[1]) % 16777216
													tbl20 = { nil, 6, 0, 1, v77 }

													while true do
														local v78 = tbl20[4]
														local v79 = tbl20[2]
														local n59 = tbl20[3] + v78
														flag5 = not (v78 <= 0)
														tbl20[3] = n59

														if n59 <= v79 then
															do
																local n592 = n59
																local n60 = (n57 * (tbl21[2] * 2 + 1) + tbl21[3]) % 16777216
																n57 = ((n60 % 4096 * 4096 + (n60 - n60 % 4096) // 4096 + tbl21[4]) % 16777216 + n592 * tbl21[5]) % 16777216
															end

															if nil then
																n57 = (n57 + tbl21[6]) % 16777216
															end
														else
															break
														end
													end
												end

												local tbl21

												do
													local v78 = tbl20[5]

													while true do
														fn4((math_floor_precision(n54) - n57) % 16777216, 8)

														if n56 == 339374311 then
														end

														if not (fn17 >= "function") then
															continue
														end
														break
													end

													Folder3 = "f"
													n33 = 16705
													tbl21 = { nil, 16, flag5, v78, v77 }
												end

												while true do
													local v78, n58, flag6

													do
														local v79 = tbl21[5]
														v78 = tbl21[2]
														n58 = tbl21[3] + v79
														flag6 = v79 <= 0
													end

													do
														local flag7 = not flag6
														local flag8 = n58 >= v78
														local flag9 = n58 <= v78

														if flag6 then
															if flag7 then
																flag8 = flag8 or flag9
															else
																flag9 = flag7
																flag8 = flag8 or flag9
															end
														else
															flag8 = flag6

															if flag7 then
																flag8 = flag8 or flag9
															else
																flag8 = flag8 or flag7
															end
														end

														tbl21[3] = n58

														if flag8 then
															do
																local n582 = n58
																n57[{}] = n582 + 1
															end

															continue
														end
													end

													break
												end

												do
													local v78 = tbl21[4]
													iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v79, v310, v410, v510, v610, v710, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v79, v310, v410, v510, v610, v710, v82, v92, v102) end end); co(); return co end)(n57, nil, nil)
													local v79 = table.pack(iter_f_1())

													if v79[1] then
														local v80 = v79[3]

														while true do
															n33 = (n33 * v80 + v80 * 411) % 16776960 + 1
															local v81 = table.pack(iter_f_1())

															if v81[1] then
																v80 = v81[3]
															else
																break
															end
														end
													end

													n24 = 8589934592
													local n58 = (-17179869183 * (1 + (8627448832 * 67108864 + n24) / 4503599627370496) * 2 ^ 4294967319 + 1) % 16777216
													n32 = n55 + v49 + v51
													tbl10 = {}
													tbl = { nil, 1, v78, 0, 6 }

													while true do
														local v80 = tbl[2]
														local v81 = tbl[5]
														local n59 = tbl[4] + v80
														tbl[4] = n59

														if n59 <= v81 then
															n58 = (n58 * 1103515245 + 12345) % 16777216
															tbl10[n59] = n58
														else
															break
														end
													end
												end

												n41 = (n33 + tbl10[1]) % 16777216
												tbl14 = { nil, 1, 6, 0, tbl[3] }

												while true do
													v69 = tbl14[2]
													v61 = tbl14[3]
													n39 = tbl14[4] + v69
													tbl14[4] = n39

													if n39 <= v61 then
														n392 = n39
														n34 = (n41 * (tbl10[2] * 2 + 1) + tbl10[3]) % 16777216
														n24 = n34 % 4096
														n41 = ((n24 * 4096 + (n34 - n34 % 4096) // 4096 + tbl10[4]) % 16777216 + n392 * tbl10[5]) % 16777216

														if nil then
															n41 = (n41 + tbl10[6]) % 16777216
														end
													else
														break
													end
												end

												v67 = tbl14[5]
												fn4((math_floor_precision(n33) - n41) % 16777216, 8)
												tbl12Map = {}
												gameRef = 16705
												tbl18 = { 16, 1, -1, v67, nil }

												while true do
													v60 = tbl18[2]
													v72 = tbl18[1]
													n37 = tbl18[3] + v60
													tbl18[3] = n37

													if n37 <= v72 then
														v59 = n37
														tbl12 = {}
														tbl12Map[tbl12] = v59 + 1
													else
														break
													end
												end

												v55 = tbl18[4]
												iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v78, v310, v410, v510, v610, v79, v82, v92, v102 in f, s, var do coroutine.yield(true, k, v78, v310, v410, v510, v610, v79, v82, v92, v102) end end); co(); return co end)(tbl12Map, nil, nil)
												local v78 = table.pack(iter_f_1())

												if v78[1] then
													v68 = v78[3]

													while true do
														gameRef = (gameRef * v68 + v68 * 411) % 16776960 + 1
														local v79 = table.pack(iter_f_1())

														if v79[1] then
															v68 = v79[3]
														else
															break
														end
													end
												end

												n35 = n32 + v52
												n30 = 20084442667
												local n302 = table.pack(bit32.band(n30, 4294967295))
												local v79 = table.pack(bit32.band(n302[1], 65535))
												n31 = 1595630789 + bit32.band(31223 * v79[1] + bit32.lshift(bit32.band(31223 * bit32.rshift(n302[1], 16) + 5879 * v79[1], 65535), 16), 4294967295)
												n212 = 3524332562
												v56 = bit32.bor(2931427363, n30)
												local n2122 = table.pack(bit32.band(n212, 4294967295))
												local v562 = table.pack(bit32.band(v56, 4294967295))
												local v80 = table.pack(bit32.band(n2122[1], 65535))
												local v81 = table.pack(bit32.rshift(n2122[1], 16))
												local v82 = table.pack(bit32.band(v562[1], 65535))
												n29 = 12884901888
												n36 = (-8589934591 * (1 + ((n31 + bit32.band(v80[1] * v82[1] + bit32.lshift(bit32.band(v80[1] * bit32.rshift(v562[1], 16) + v81[1] * v82[1], 65535), 16), 4294967295) + 1712676800) * 67108864 + n29) / 4503599627370496) * 2 ^ 12884901911 + 1) % 16777216
												tbl10 = {}
												tbl13 = { 0, 6, 1, nil, v55 }

												while true do
													v70 = tbl13[3]
													v64 = tbl13[2]
													n44 = tbl13[1] + v70
													tbl13[1] = n44

													if n44 <= v64 then
														n36 = (n36 * 1103515245 + 12345) % 16777216
														tbl10[n44] = n36
													else
														break
													end
												end

												fn82 = (gameRef + tbl10[1]) % 16777216
												tbl15 = { tbl13[5], 1, nil, 6, 0 }

												while true do
													v62 = tbl15[2]
													v57 = tbl15[4]
													n40 = tbl15[5] + v62
													tbl15[5] = n40

													if n40 <= v57 then
														v66 = n40
														n38 = (fn82 * (tbl10[2] * 2 + 1) + tbl10[3]) % 16777216
														n24 = n38 % 4096
														fn82 = ((n24 * 4096 + (n38 - n38 % 4096) // 4096 + tbl10[4]) % 16777216 + v66 * tbl10[5]) % 16777216

														if nil then
															fn82 = (fn82 + tbl10[6]) % 16777216
														end
													else
														break
													end
												end

												tbl = tbl15[1]
												v63 = math_floor_precision

												if v32 ~= 134.00000000001432 then
													fn4((v63(gameRef) - fn82) % 16777216, 8)
													tbl16 = {}
													tbl11 = { tbl, 1, nil, -1, 16 }

													while true do
														v71 = tbl11[2]
														v65 = tbl11[5]
														n45 = tbl11[4] + v71
														tbl11[4] = n45

														if n45 <= v65 then
															v58 = n45
															tbl17 = {}
															tbl16[tbl17] = v58 + 1
														else
															break
														end
													end

													iter_f_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v83, v310, v410, v510, v610, v710, v84, v92, v102 in f, s, var do coroutine.yield(true, k, v83, v310, v410, v510, v610, v710, v84, v92, v102) end end); co(); return co end)(tbl16, nil, nil)
													local v83 = table.pack(iter_f_1())

													if v83[1] then
														while true do
															local v84 = table.pack(iter_f_1())

															if v84[1] then
															else
																break
															end
														end
													end

													if v54 ~= 133 then
													end

													return tbl2()
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
									fn4(372868618, 4)
									n4 = 43031001
									fn5()

									while true do
									end
								end
							else
								while true do
								end
							end
						end
					end

					fn4(372868618, 4)
					n4 = 43031001
					fn5()

					while true do
					end
				end
			end
		else
			fn4(372868618, 4)
			n4 = 43031001
			fn5()

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
