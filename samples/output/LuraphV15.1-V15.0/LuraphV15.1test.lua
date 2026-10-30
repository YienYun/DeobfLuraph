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

local tbl
tbl = {}
local v
v = nil
local fn
fn = nil
local fn2
fn2 = nil
local fn3
fn3 = nil
local v2
v2 = task
local cancel
cancel = v2.cancel
local spawn
spawn = v2.spawn
local defer
defer = v2.defer
local delay
delay = v2.delay
local wait
wait = v2.wait
local v3, v4, v5, v6, v7, fn4, fn5, v8, info, traceback
local n, fn6, fn7, tbl2, fn8, fn9, new, new2, new3, color3New
local rectNew, uDim2New, uDimNew, new4, v9, v10

do
	local v11 = Instance
	v3 = Vector3
	local v12 = Vector2
	v4 = CFrame
	v5 = Random
	v6 = identifyexecutor
	v7 = loadstring
	local tbl3 = {}
	local n2 = 0

	fn4 = function(arg, arg2)
		n2 += 1
		tbl3[n2] = arg2 % 256
	end

	local n3 = 340174802

	fn5 = function(arg, arg2)
		local n4, n5

		if nil then
			n4 = 1
			n5 = 1
			n3 = bit32.bxor(n3, 434455141)
		else
			n4 = 1
			n5 = 1
		end

		local n6 = n5 + 0
		local tbl4 = { n6, arg2 + 0, nil, n4 - n6, nil }

		while true do
			local v13 = tbl4[1]
			local v14 = tbl4[2]
			local n7 = tbl4[4] + v13
			tbl4[4] = n7

			if n7 <= v14 then
				local n8 = arg % 256
				arg = (arg - n8) / 256
				n2 += 1
				tbl3[n2] = n8
			else
				break
			end
		end
	end

	v8 = assert(debug, "The debug library is required on Luau platforms. Please open a support ticket.")
	info = v8.info
	traceback = v8.traceback
	n3 = 513275866
	n = 126460705

	fn6 = function()
		local function fn10(arg, arg2, arg3, arg4, arg5)
			local n4 = 471997619
			local tbl4 = { nil, 0, 4, 1, nil }
			local tbl5 = { arg2, arg3, arg4, arg5 }
			local v13, n5, n6, n7, n8, v132, v133, v134, v14, v135, v142, v136

			while true do
				local v15 = tbl4[4]
				local v16 = tbl4[3]
				local n9 = tbl4[2] + v15
				local flag = v15 <= 0
				local flag2 = not flag
				local flag3 = n9 >= v16
				local flag4 = n9 <= v16
				local v17, tbl6, v18, v19, n10, n102, n42, v20, n43, n11, n44, v21, n12, n45, n13, v22, v23, v232, v24, n14, n15, n16, v25, n17, v26, n152, n18, n19, n162, v27, n153, n20, v28, v252, n21, n192, n154, n22, v29, n23, n232, n233, n24, v30, n234, n25, n26, v31, v32, n235, n236, n27, v33, n28, v34

				if flag then
					if flag2 then
						if flag3 then
							tbl4[2] = n9

							if flag3 then
								v17 = tbl5[n9]
								tbl6 = { tbl4, #v17 + 0, 1, 0, nil }

								while true do
									v18 = tbl6[3]
									v19 = tbl6[2]
									n10 = tbl6[4] + v18
									tbl6[4] = n10

									if n10 <= v19 then
										n102 = n10
										n42 = bit32.lshift(bit32.band(n4, n102), 1)
										local n103 = table.pack(bit32.band(n102, 4294967295))
										local v35 = table.pack(bit32.band(n103[1], 65535))
										v20 = bit32.band(8595 * v35[1] + bit32.lshift(bit32.band(8595 * bit32.rshift(n103[1], 16) + 12253 * v35[1], 65535), 16), 4294967295)
										n43 = bit32.bnot(n42)
										local n46 = table.pack(bit32.band(n42, 4294967295))
										local v36 = table.pack(bit32.band(n46[1], 65535))
										n11 = n4 + 4294967294 + v20 + 2781148632 + bit32.band(65535 * v36[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n46[1], 16) + 65535 * v36[1], 65535), 16), 4294967295)
										n44 = bit32.bor(n42, n102)
										local n47 = table.pack(bit32.band(bit32.bnot(n44), 4294967295))
										local v37 = table.pack(bit32.band(n47[1], 65535))
										v21 = bit32.band(8594 * v37[1] + bit32.lshift(bit32.band(8594 * bit32.rshift(n47[1], 16) + 12253 * v37[1], 65535), 16), 4294967295)
										local n48 = table.pack(bit32.band(bit32.bor(n43, n102), 4294967295))
										local v38 = table.pack(bit32.band(n48[1], 65535))
										n12 = v21 + bit32.band(56938 * v38[1] + bit32.lshift(bit32.band(56938 * bit32.rshift(n48[1], 16) + 53282 * v38[1], 65535), 16), 4294967295)
										n45 = bit32.bnot(n4)
										local n104 = table.pack(bit32.band(bit32.band(bit32.band(n102, n42), n45), 4294967295))
										local v39 = table.pack(bit32.band(n104[1], 65535))
										n13 = n11 + n12 + 3720420700 + bit32.band(4 * v39[1] + bit32.lshift(bit32.band(4 * bit32.rshift(n104[1], 16) + 0 * v39[1], 65535), 16), 4294967295) + 2088365252
										local n132 = table.pack(bit32.band(n13, 4294967295))
										local v40 = table.pack(bit32.band(n132[1], 65535))
										v22 = bit32.band(46383 * v40[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(n132[1], 16) + 61184 * v40[1], 65535), 16), 4294967295)
										v23 = bit32.band(411217669, n13)
										v232 = bit32.bnot(v23)
										local v233 = table.pack(bit32.band(v232, 4294967295))
										local v41 = table.pack(bit32.band(v233[1], 65535))
										local v42 = table.pack(bit32.band(4372607921 - 4087441632 + v22 + bit32.band(46383 * v41[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(v233[1], 16) + 61184 * v41[1], 65535), 16), 4294967295) + 1112571824, 4294967295))
										local v43 = table.pack(bit32.band(v42[1], 65535))
										v24 = bit32.band(7235 * v43[1] + bit32.lshift(bit32.band(7235 * bit32.rshift(v42[1], 16) + 1792 * v43[1], 65535), 16), 4294967295)
										local v234 = table.pack(bit32.band(v232, 4294967295))
										local v44 = table.pack(bit32.band(v234[1], 65535))
										local v45 = table.pack(bit32.band(bit32.band(v44[1] * 20730 + bit32.lshift(bit32.band(v44[1] * 59261 + bit32.rshift(v234[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
										local v46 = table.pack(bit32.band(v45[1], 65535))
										n14 = 3150102558 + 2289729476 + bit32.band(33210 * v46[1] + bit32.lshift(bit32.band(33210 * bit32.rshift(v45[1], 16) + 53983 * v46[1], 65535), 16), 4294967295)
										local n133 = table.pack(bit32.band(bit32.bor(bit32.bnot(n13), 3883749626), 4294967295))
										local v47 = table.pack(bit32.band(n133[1], 65535))
										local v48 = table.pack(bit32.band(bit32.band(v47[1] * 20730 + bit32.lshift(bit32.band(v47[1] * 59261 + bit32.rshift(n133[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
										local v49 = table.pack(bit32.band(v48[1], 65535))
										n15 = v24 + n14 + 3645010203 + bit32.band(32326 * v49[1] + bit32.lshift(bit32.band(32326 * bit32.rshift(v48[1], 16) + 11552 * v49[1], 65535), 16), 4294967295) + 3877700276
										v17[n102] = bit32.bxor(v17[n102], 77640625)
										n16 = n4 + 143406633
										local n105 = table.pack(bit32.band(n102, 4294967295))
										local v50 = table.pack(bit32.band(n105[1], 65535))
										v25 = bit32.band(v50[1] * 35941 + bit32.lshift(bit32.band(v50[1] * 13292 + bit32.rshift(n105[1], 16) * 35941, 65535), 16), 4294967295)
										local n155 = table.pack(bit32.band(n15, 4294967295))
										local v51 = table.pack(bit32.band(n155[1], 65535))
										n17 = 3363122404 + bit32.band(54046 * v51[1] + bit32.lshift(bit32.band(54046 * bit32.rshift(n155[1], 16) + 14218 * v51[1], 65535), 16), 4294967295)
										local v253 = table.pack(bit32.band(v25, 4294967295))
										local v52 = table.pack(bit32.band(v253[1], 65535))
										v26 = bit32.band(22979 * v52[1] + bit32.lshift(bit32.band(22979 * bit32.rshift(v253[1], 16) + 37098 * v52[1], 65535), 16), 4294967295)
										n152 = bit32.band(n15, 411217669)
										local n163 = table.pack(bit32.band(n16, 4294967295))
										local n156 = table.pack(bit32.band(n152, 4294967295))
										local v53 = table.pack(bit32.band(n163[1], 65535))
										local v54 = table.pack(bit32.rshift(n163[1], 16))
										local v55 = table.pack(bit32.band(n156[1], 65535))
										local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n156[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
										local v57 = table.pack(bit32.band(v56[1], 65535))
										n18 = n17 + v26 + bit32.band(33587 * v57[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v56[1], 16) + 36601 * v57[1], 65535), 16), 4294967295)
										local n164 = table.pack(bit32.band(n16, 4294967295))
										local v58 = table.pack(bit32.band(n164[1], 65535))
										n19 = n18 + 4252548308 + bit32.band(22096 * v58[1] + bit32.lshift(bit32.band(22096 * bit32.rshift(n164[1], 16) + 50820 * v58[1], 65535), 16), 4294967295) + n152 + 3542608668
										n162 = bit32.band(n16, 411217669)
										local n165 = table.pack(bit32.band(bit32.bnot(n162), 4294967295))
										local v59 = table.pack(bit32.band(n165[1], 65535))
										v27 = bit32.band(42554 * v59[1] + bit32.lshift(bit32.band(42554 * bit32.rshift(n165[1], 16) + 28437 * v59[1], 65535), 16), 4294967295)
										n153 = bit32.bnot(n152)
										local n166 = table.pack(bit32.band(n16, 4294967295))
										local n157 = table.pack(bit32.band(n153, 4294967295))
										local v60 = table.pack(bit32.band(n166[1], 65535))
										local v61 = table.pack(bit32.rshift(n166[1], 16))
										local v62 = table.pack(bit32.band(n157[1], 65535))
										local v63 = table.pack(bit32.band(bit32.band(v60[1] * v62[1] + bit32.lshift(bit32.band(v60[1] * bit32.rshift(n157[1], 16) + v61[1] * v62[1], 65535), 16), 4294967295), 4294967295))
										local v64 = table.pack(bit32.band(v63[1], 65535))
										n20 = v27 + bit32.band(33587 * v64[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v63[1], 16) + 36601 * v64[1], 65535), 16), 4294967295)
										local v254 = table.pack(bit32.band(bit32.band(bit32.bnot(v25), 1009581529), 4294967295))
										local v65 = table.pack(bit32.band(v254[1], 65535))
										v28 = bit32.band(45962 * v65[1] + bit32.lshift(bit32.band(45962 * bit32.rshift(v254[1], 16) + 8660 * v65[1], 65535), 16), 4294967295)
										v252 = bit32.bor(v25, n16)
										local v66 = table.pack(bit32.band(bit32.bor(3883749626, v252), 4294967295))
										local v67 = table.pack(bit32.band(v66[1], 65535))
										n21 = n20 + v28 + bit32.band(45964 * v67[1] + bit32.lshift(bit32.band(45964 * bit32.rshift(v66[1], 16) + 8660 * v67[1], 65535), 16), 4294967295)
										n192 = n19
										n154 = bit32.bnot(n15)
										local v68 = table.pack(bit32.band(bit32.band(390258361, n154), 4294967295))
										local v69 = table.pack(bit32.band(v68[1], 65535))
										n22 = bit32.band(42556 * v69[1] + bit32.lshift(bit32.band(42556 * bit32.rshift(v68[1], 16) + 28437 * v69[1], 65535), 16), 4294967295) + 1993956034
										v29 = bit32.band(411217669, v25)
										local n158 = table.pack(bit32.band(bit32.band(bit32.bor(n15, n16), v29), 4294967295))
										local v70 = table.pack(bit32.band(n158[1], 65535))
										n23 = n192 + n21 + n22 + 1041196816 + bit32.band(19576 * v70[1] + bit32.lshift(bit32.band(19576 * bit32.rshift(n158[1], 16) + 56875 * v70[1], 65535), 16), 4294967295)
										n232 = bit32.band(n23, 2147483647)
										n233 = bit32.bnot(n232)
										local n237 = table.pack(bit32.band(n233, 4294967295))
										local v71 = table.pack(bit32.band(n237[1], 65535))
										n24 = 1067535265 + bit32.band(19361 * v71[1] + bit32.lshift(bit32.band(19361 * bit32.rshift(n237[1], 16) + 16289 * v71[1], 65535), 16), 4294967295)
										local n238 = table.pack(bit32.band(n23, 4294967295))
										local v72 = table.pack(bit32.band(n238[1], 65535))
										v30 = bit32.band(19362 * v72[1] + bit32.lshift(bit32.band(19362 * bit32.rshift(n238[1], 16) + 16289 * v72[1], 65535), 16), 4294967295)
										n234 = bit32.band(n23, 2147483648)
										local n239 = table.pack(bit32.band(n234, 4294967295))
										local v73 = table.pack(bit32.band(n239[1], 65535))
										n25 = n24 + v30 + bit32.band(46174 * v73[1] + bit32.lshift(bit32.band(46174 * bit32.rshift(n239[1], 16) + 49246 * v73[1], 65535), 16), 4294967295)
										local n2310 = table.pack(bit32.band(n233, 4294967295))
										local v74 = table.pack(bit32.band(n2310[1], 65535))
										n26 = 4270564234 + bit32.band(41866 * v74[1] + bit32.lshift(bit32.band(41866 * bit32.rshift(n2310[1], 16) + 65163 * v74[1], 65535), 16), 4294967295)
										local n2311 = table.pack(bit32.band(n23, 4294967295))
										local v75 = table.pack(bit32.band(n2311[1], 65535))
										v31 = bit32.band(41867 * v75[1] + bit32.lshift(bit32.band(41867 * bit32.rshift(n2311[1], 16) + 65163 * v75[1], 65535), 16), 4294967295)
										local n2312 = table.pack(bit32.band(n234, 4294967295))
										local v76 = table.pack(bit32.band(n2312[1], 65535))
										local v77 = table.pack(bit32.band(n25 - n26 + v31 + bit32.band(23669 * v76[1] + bit32.lshift(bit32.band(23669 * bit32.rshift(n2312[1], 16) + 372 * v76[1], 65535), 16), 4294967295), 4294967295))
										local v78 = table.pack(bit32.band(v77[1], 65535))
										v32 = bit32.band(32588 * v78[1] + bit32.lshift(bit32.band(32588 * bit32.rshift(v77[1], 16) + 60585 * v78[1], 65535), 16), 4294967295)
										n235 = n233
										n236 = bit32.bor(n23, 2147483647)
										local n2313 = table.pack(bit32.band(n23, 4294967295))
										local v79 = table.pack(bit32.band(n2313[1], 65535))
										local v80 = table.pack(bit32.band(bit32.band(v79[1] * 33210 + bit32.lshift(bit32.band(v79[1] * 38851 + bit32.rshift(n2313[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
										local v81 = table.pack(bit32.band(v80[1], 65535))
										n27 = 3529912362 + 314747904 + bit32.band(33465 * v81[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v80[1], 16) + 64846 * v81[1], 65535), 16), 4294967295)
										local n2314 = table.pack(bit32.band(n235, 4294967295))
										local v82 = table.pack(bit32.band(n2314[1], 65535))
										v33 = bit32.band(22897 * v82[1] + bit32.lshift(bit32.band(22897 * bit32.rshift(n2314[1], 16) + 59354 * v82[1], 65535), 16), 4294967295)
										local n2315 = table.pack(bit32.band(n235, 4294967295))
										local v83 = table.pack(bit32.band(n2315[1], 65535))
										local v84 = table.pack(bit32.band(bit32.band(65535 * v83[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n2315[1], 16) + 32767 * v83[1], 65535), 16), 4294967295), 4294967295))
										local v85 = table.pack(bit32.band(v84[1], 65535))
										n28 = v33 + bit32.band(32071 * v85[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v84[1], 16) + 689 * v85[1], 65535), 16), 4294967295)
										local n2316 = table.pack(bit32.band(n236, 4294967295))
										local v86 = table.pack(bit32.band(n2316[1], 65535))
										local v87 = table.pack(bit32.band(bit32.band(v86[1] * 33210 + bit32.lshift(bit32.band(v86[1] * 38851 + bit32.rshift(n2316[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
										local v88 = table.pack(bit32.band(v87[1], 65535))
										v34 = bit32.band(32071 * v88[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v87[1], 16) + 689 * v88[1], 65535), 16), 4294967295)
										local n2317 = table.pack(bit32.band(n235, 4294967295))
										local v89 = table.pack(bit32.band(n2317[1], 65535))
										local v90 = table.pack(bit32.band(bit32.band(v89[1] * 33210 + bit32.lshift(bit32.band(v89[1] * 38851 + bit32.rshift(n2317[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
										local v91 = table.pack(bit32.band(v90[1], 65535))
										n4 = v32 + n27 + n28 + 677552702 + v34 + bit32.band(33465 * v91[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v90[1], 16) + 64846 * v91[1], 65535), 16), 4294967295)
									else
										break
									end
								end

								tbl4 = tbl6[1]
								continue
							end

							v13 = arg[7]
							n5 = 24
							n6 = buffer.len(v13) - 24 - 23
							n7 = n5 + 199005006 % n6

							while true do
								n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
								v132 = buffer.readu16(v13, n7)
								v133 = buffer.readi16(v13, n8)
								v134 = bit32.lshift(bit32.band(v133, 255), 3)
								v14 = bit32.band(bit32.bxor(bit32.bxor(471997619, v132) + v134 + 143406633, n7), 2147483647)
								v135 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v132, v133), v14), 2147483647), 983120128)
								buffer.writei32(v13, n7, v135)
								v142 = bit32.rshift(v14, 8)
								v136 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v133, v142), n7), 2147483647), 741008640)
								buffer.writei16(v13, n8, v136)
								n4 = v14
								n7 = n5 + (n7 + bit32.band(v14, 63) + 1) % n6
							end
						else
							flag3 = flag4
							tbl4[2] = n9

							if flag3 then
								v17 = tbl5[n9]
								tbl6 = { tbl4, #v17 + 0, 1, 0, nil }

								while true do
									v18 = tbl6[3]
									v19 = tbl6[2]
									n10 = tbl6[4] + v18
									tbl6[4] = n10

									if n10 <= v19 then
										n102 = n10
										n42 = bit32.lshift(bit32.band(n4, n102), 1)
										local n103 = table.pack(bit32.band(n102, 4294967295))
										local v35 = table.pack(bit32.band(n103[1], 65535))
										v20 = bit32.band(8595 * v35[1] + bit32.lshift(bit32.band(8595 * bit32.rshift(n103[1], 16) + 12253 * v35[1], 65535), 16), 4294967295)
										n43 = bit32.bnot(n42)
										local v143 = table.pack(bit32.band(n42, 4294967295))
										local v36 = table.pack(bit32.band(v143[1], 65535))
										n11 = n4 + 4294967294 + v20 + 2781148632 + bit32.band(65535 * v36[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(v143[1], 16) + 65535 * v36[1], 65535), 16), 4294967295)
										n44 = bit32.bor(n42, n102)
										local v144 = table.pack(bit32.band(bit32.bnot(n44), 4294967295))
										local v37 = table.pack(bit32.band(v144[1], 65535))
										v21 = bit32.band(8594 * v37[1] + bit32.lshift(bit32.band(8594 * bit32.rshift(v144[1], 16) + 12253 * v37[1], 65535), 16), 4294967295)
										local v145 = table.pack(bit32.band(bit32.bor(n43, n102), 4294967295))
										local v38 = table.pack(bit32.band(v145[1], 65535))
										n12 = v21 + bit32.band(56938 * v38[1] + bit32.lshift(bit32.band(56938 * bit32.rshift(v145[1], 16) + 53282 * v38[1], 65535), 16), 4294967295)
										n45 = bit32.bnot(n4)
										local n104 = table.pack(bit32.band(bit32.band(bit32.band(n102, n42), n45), 4294967295))
										local v39 = table.pack(bit32.band(n104[1], 65535))
										n13 = n11 + n12 + 3720420700 + bit32.band(4 * v39[1] + bit32.lshift(bit32.band(4 * bit32.rshift(n104[1], 16) + 0 * v39[1], 65535), 16), 4294967295) + 2088365252
										local n132 = table.pack(bit32.band(n13, 4294967295))
										local v40 = table.pack(bit32.band(n132[1], 65535))
										v22 = bit32.band(46383 * v40[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(n132[1], 16) + 61184 * v40[1], 65535), 16), 4294967295)
										v23 = bit32.band(411217669, n13)
										v232 = bit32.bnot(v23)
										local v233 = table.pack(bit32.band(v232, 4294967295))
										local v41 = table.pack(bit32.band(v233[1], 65535))
										local v42 = table.pack(bit32.band(4372607921 - 4087441632 + v22 + bit32.band(46383 * v41[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(v233[1], 16) + 61184 * v41[1], 65535), 16), 4294967295) + 1112571824, 4294967295))
										local v43 = table.pack(bit32.band(v42[1], 65535))
										v24 = bit32.band(7235 * v43[1] + bit32.lshift(bit32.band(7235 * bit32.rshift(v42[1], 16) + 1792 * v43[1], 65535), 16), 4294967295)
										local v234 = table.pack(bit32.band(v232, 4294967295))
										local v44 = table.pack(bit32.band(v234[1], 65535))
										local v45 = table.pack(bit32.band(bit32.band(v44[1] * 20730 + bit32.lshift(bit32.band(v44[1] * 59261 + bit32.rshift(v234[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
										local v46 = table.pack(bit32.band(v45[1], 65535))
										n14 = 3150102558 + 2289729476 + bit32.band(33210 * v46[1] + bit32.lshift(bit32.band(33210 * bit32.rshift(v45[1], 16) + 53983 * v46[1], 65535), 16), 4294967295)
										local n133 = table.pack(bit32.band(bit32.bor(bit32.bnot(n13), 3883749626), 4294967295))
										local v47 = table.pack(bit32.band(n133[1], 65535))
										local v48 = table.pack(bit32.band(bit32.band(v47[1] * 20730 + bit32.lshift(bit32.band(v47[1] * 59261 + bit32.rshift(n133[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
										local v49 = table.pack(bit32.band(v48[1], 65535))
										n15 = v24 + n14 + 3645010203 + bit32.band(32326 * v49[1] + bit32.lshift(bit32.band(32326 * bit32.rshift(v48[1], 16) + 11552 * v49[1], 65535), 16), 4294967295) + 3877700276
										v17[n102] = bit32.bxor(v17[n102], 77640625)
										n16 = n4 + 143406633
										local n105 = table.pack(bit32.band(n102, 4294967295))
										local v50 = table.pack(bit32.band(n105[1], 65535))
										v25 = bit32.band(v50[1] * 35941 + bit32.lshift(bit32.band(v50[1] * 13292 + bit32.rshift(n105[1], 16) * 35941, 65535), 16), 4294967295)
										local n155 = table.pack(bit32.band(n15, 4294967295))
										local v51 = table.pack(bit32.band(n155[1], 65535))
										n17 = 3363122404 + bit32.band(54046 * v51[1] + bit32.lshift(bit32.band(54046 * bit32.rshift(n155[1], 16) + 14218 * v51[1], 65535), 16), 4294967295)
										local v253 = table.pack(bit32.band(v25, 4294967295))
										local v52 = table.pack(bit32.band(v253[1], 65535))
										v26 = bit32.band(22979 * v52[1] + bit32.lshift(bit32.band(22979 * bit32.rshift(v253[1], 16) + 37098 * v52[1], 65535), 16), 4294967295)
										n152 = bit32.band(n15, 411217669)
										local n163 = table.pack(bit32.band(n16, 4294967295))
										local n156 = table.pack(bit32.band(n152, 4294967295))
										local v53 = table.pack(bit32.band(n163[1], 65535))
										local v54 = table.pack(bit32.rshift(n163[1], 16))
										local v55 = table.pack(bit32.band(n156[1], 65535))
										local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n156[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
										local v57 = table.pack(bit32.band(v56[1], 65535))
										n18 = n17 + v26 + bit32.band(33587 * v57[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v56[1], 16) + 36601 * v57[1], 65535), 16), 4294967295)
										local n164 = table.pack(bit32.band(n16, 4294967295))
										local v58 = table.pack(bit32.band(n164[1], 65535))
										n19 = n18 + 4252548308 + bit32.band(22096 * v58[1] + bit32.lshift(bit32.band(22096 * bit32.rshift(n164[1], 16) + 50820 * v58[1], 65535), 16), 4294967295) + n152 + 3542608668
										n162 = bit32.band(n16, 411217669)
										local n165 = table.pack(bit32.band(bit32.bnot(n162), 4294967295))
										local v59 = table.pack(bit32.band(n165[1], 65535))
										v27 = bit32.band(42554 * v59[1] + bit32.lshift(bit32.band(42554 * bit32.rshift(n165[1], 16) + 28437 * v59[1], 65535), 16), 4294967295)
										n153 = bit32.bnot(n152)
										local n166 = table.pack(bit32.band(n16, 4294967295))
										local n157 = table.pack(bit32.band(n153, 4294967295))
										local v60 = table.pack(bit32.band(n166[1], 65535))
										local v61 = table.pack(bit32.rshift(n166[1], 16))
										local v62 = table.pack(bit32.band(n157[1], 65535))
										local v63 = table.pack(bit32.band(bit32.band(v60[1] * v62[1] + bit32.lshift(bit32.band(v60[1] * bit32.rshift(n157[1], 16) + v61[1] * v62[1], 65535), 16), 4294967295), 4294967295))
										local v64 = table.pack(bit32.band(v63[1], 65535))
										n20 = v27 + bit32.band(33587 * v64[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v63[1], 16) + 36601 * v64[1], 65535), 16), 4294967295)
										local v254 = table.pack(bit32.band(bit32.band(bit32.bnot(v25), 1009581529), 4294967295))
										local v65 = table.pack(bit32.band(v254[1], 65535))
										v28 = bit32.band(45962 * v65[1] + bit32.lshift(bit32.band(45962 * bit32.rshift(v254[1], 16) + 8660 * v65[1], 65535), 16), 4294967295)
										v252 = bit32.bor(v25, n16)
										local v66 = table.pack(bit32.band(bit32.bor(3883749626, v252), 4294967295))
										local v67 = table.pack(bit32.band(v66[1], 65535))
										n21 = n20 + v28 + bit32.band(45964 * v67[1] + bit32.lshift(bit32.band(45964 * bit32.rshift(v66[1], 16) + 8660 * v67[1], 65535), 16), 4294967295)
										n192 = n19
										n154 = bit32.bnot(n15)
										local v68 = table.pack(bit32.band(bit32.band(390258361, n154), 4294967295))
										local v69 = table.pack(bit32.band(v68[1], 65535))
										n22 = bit32.band(42556 * v69[1] + bit32.lshift(bit32.band(42556 * bit32.rshift(v68[1], 16) + 28437 * v69[1], 65535), 16), 4294967295) + 1993956034
										v29 = bit32.band(411217669, v25)
										local n158 = table.pack(bit32.band(bit32.band(bit32.bor(n15, n16), v29), 4294967295))
										local v70 = table.pack(bit32.band(n158[1], 65535))
										n23 = n192 + n21 + n22 + 1041196816 + bit32.band(19576 * v70[1] + bit32.lshift(bit32.band(19576 * bit32.rshift(n158[1], 16) + 56875 * v70[1], 65535), 16), 4294967295)
										n232 = bit32.band(n23, 2147483647)
										n233 = bit32.bnot(n232)
										local n237 = table.pack(bit32.band(n233, 4294967295))
										local v71 = table.pack(bit32.band(n237[1], 65535))
										n24 = 1067535265 + bit32.band(19361 * v71[1] + bit32.lshift(bit32.band(19361 * bit32.rshift(n237[1], 16) + 16289 * v71[1], 65535), 16), 4294967295)
										local n238 = table.pack(bit32.band(n23, 4294967295))
										local v72 = table.pack(bit32.band(n238[1], 65535))
										v30 = bit32.band(19362 * v72[1] + bit32.lshift(bit32.band(19362 * bit32.rshift(n238[1], 16) + 16289 * v72[1], 65535), 16), 4294967295)
										n234 = bit32.band(n23, 2147483648)
										local n239 = table.pack(bit32.band(n234, 4294967295))
										local v73 = table.pack(bit32.band(n239[1], 65535))
										n25 = n24 + v30 + bit32.band(46174 * v73[1] + bit32.lshift(bit32.band(46174 * bit32.rshift(n239[1], 16) + 49246 * v73[1], 65535), 16), 4294967295)
										local n2310 = table.pack(bit32.band(n233, 4294967295))
										local v74 = table.pack(bit32.band(n2310[1], 65535))
										n26 = 4270564234 + bit32.band(41866 * v74[1] + bit32.lshift(bit32.band(41866 * bit32.rshift(n2310[1], 16) + 65163 * v74[1], 65535), 16), 4294967295)
										local n2311 = table.pack(bit32.band(n23, 4294967295))
										local v75 = table.pack(bit32.band(n2311[1], 65535))
										v31 = bit32.band(41867 * v75[1] + bit32.lshift(bit32.band(41867 * bit32.rshift(n2311[1], 16) + 65163 * v75[1], 65535), 16), 4294967295)
										local n2312 = table.pack(bit32.band(n234, 4294967295))
										local v76 = table.pack(bit32.band(n2312[1], 65535))
										local v77 = table.pack(bit32.band(n25 - n26 + v31 + bit32.band(23669 * v76[1] + bit32.lshift(bit32.band(23669 * bit32.rshift(n2312[1], 16) + 372 * v76[1], 65535), 16), 4294967295), 4294967295))
										local v78 = table.pack(bit32.band(v77[1], 65535))
										v32 = bit32.band(32588 * v78[1] + bit32.lshift(bit32.band(32588 * bit32.rshift(v77[1], 16) + 60585 * v78[1], 65535), 16), 4294967295)
										n235 = n233
										n236 = bit32.bor(n23, 2147483647)
										local n2313 = table.pack(bit32.band(n23, 4294967295))
										local v79 = table.pack(bit32.band(n2313[1], 65535))
										local v80 = table.pack(bit32.band(bit32.band(v79[1] * 33210 + bit32.lshift(bit32.band(v79[1] * 38851 + bit32.rshift(n2313[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
										local v81 = table.pack(bit32.band(v80[1], 65535))
										n27 = 3529912362 + 314747904 + bit32.band(33465 * v81[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v80[1], 16) + 64846 * v81[1], 65535), 16), 4294967295)
										local n2314 = table.pack(bit32.band(n235, 4294967295))
										local v82 = table.pack(bit32.band(n2314[1], 65535))
										v33 = bit32.band(22897 * v82[1] + bit32.lshift(bit32.band(22897 * bit32.rshift(n2314[1], 16) + 59354 * v82[1], 65535), 16), 4294967295)
										local n2315 = table.pack(bit32.band(n235, 4294967295))
										local v83 = table.pack(bit32.band(n2315[1], 65535))
										local v84 = table.pack(bit32.band(bit32.band(65535 * v83[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n2315[1], 16) + 32767 * v83[1], 65535), 16), 4294967295), 4294967295))
										local v85 = table.pack(bit32.band(v84[1], 65535))
										n28 = v33 + bit32.band(32071 * v85[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v84[1], 16) + 689 * v85[1], 65535), 16), 4294967295)
										local n2316 = table.pack(bit32.band(n236, 4294967295))
										local v86 = table.pack(bit32.band(n2316[1], 65535))
										local v87 = table.pack(bit32.band(bit32.band(v86[1] * 33210 + bit32.lshift(bit32.band(v86[1] * 38851 + bit32.rshift(n2316[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
										local v88 = table.pack(bit32.band(v87[1], 65535))
										v34 = bit32.band(32071 * v88[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v87[1], 16) + 689 * v88[1], 65535), 16), 4294967295)
										local n2317 = table.pack(bit32.band(n235, 4294967295))
										local v89 = table.pack(bit32.band(n2317[1], 65535))
										local v90 = table.pack(bit32.band(bit32.band(v89[1] * 33210 + bit32.lshift(bit32.band(v89[1] * 38851 + bit32.rshift(n2317[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
										local v91 = table.pack(bit32.band(v90[1], 65535))
										n4 = v32 + n27 + n28 + 677552702 + v34 + bit32.band(33465 * v91[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v90[1], 16) + 64846 * v91[1], 65535), 16), 4294967295)
									else
										break
									end
								end

								tbl4 = tbl6[1]
								continue
							end

							v13 = arg[7]
							n5 = 24
							n6 = buffer.len(v13) - 24 - 23
							n7 = n5 + 199005006 % n6

							while true do
								n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
								v132 = buffer.readu16(v13, n7)
								v133 = buffer.readi16(v13, n8)
								v134 = bit32.lshift(bit32.band(v133, 255), 3)
								v14 = bit32.band(bit32.bxor(bit32.bxor(471997619, v132) + v134 + 143406633, n7), 2147483647)
								v135 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v132, v133), v14), 2147483647), 983120128)
								buffer.writei32(v13, n7, v135)
								v142 = bit32.rshift(v14, 8)
								v136 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v133, v142), n7), 2147483647), 741008640)
								buffer.writei16(v13, n8, v136)
								n4 = v14
								n7 = n5 + (n7 + bit32.band(v14, 63) + 1) % n6
							end
						end
					end
				else
					flag3 = flag

					if flag2 then
						if not flag3 then
							flag3 = flag4
							tbl4[2] = n9

							if flag3 then
								v17 = tbl5[n9]
								tbl6 = { tbl4, #v17 + 0, 1, 0, nil }

								while true do
									v18 = tbl6[3]
									v19 = tbl6[2]
									n10 = tbl6[4] + v18
									tbl6[4] = n10

									if n10 <= v19 then
										n102 = n10
										n42 = bit32.lshift(bit32.band(n4, n102), 1)
										local n103 = table.pack(bit32.band(n102, 4294967295))
										local v35 = table.pack(bit32.band(n103[1], 65535))
										v20 = bit32.band(8595 * v35[1] + bit32.lshift(bit32.band(8595 * bit32.rshift(n103[1], 16) + 12253 * v35[1], 65535), 16), 4294967295)
										n43 = bit32.bnot(n42)
										local v143 = table.pack(bit32.band(n42, 4294967295))
										local v36 = table.pack(bit32.band(v143[1], 65535))
										n11 = n4 + 4294967294 + v20 + 2781148632 + bit32.band(65535 * v36[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(v143[1], 16) + 65535 * v36[1], 65535), 16), 4294967295)
										n44 = bit32.bor(n42, n102)
										local v144 = table.pack(bit32.band(bit32.bnot(n44), 4294967295))
										local v37 = table.pack(bit32.band(v144[1], 65535))
										v21 = bit32.band(8594 * v37[1] + bit32.lshift(bit32.band(8594 * bit32.rshift(v144[1], 16) + 12253 * v37[1], 65535), 16), 4294967295)
										local v145 = table.pack(bit32.band(bit32.bor(n43, n102), 4294967295))
										local v38 = table.pack(bit32.band(v145[1], 65535))
										n12 = v21 + bit32.band(56938 * v38[1] + bit32.lshift(bit32.band(56938 * bit32.rshift(v145[1], 16) + 53282 * v38[1], 65535), 16), 4294967295)
										n45 = bit32.bnot(n4)
										local n104 = table.pack(bit32.band(bit32.band(bit32.band(n102, n42), n45), 4294967295))
										local v39 = table.pack(bit32.band(n104[1], 65535))
										n13 = n11 + n12 + 3720420700 + bit32.band(4 * v39[1] + bit32.lshift(bit32.band(4 * bit32.rshift(n104[1], 16) + 0 * v39[1], 65535), 16), 4294967295) + 2088365252
										local n132 = table.pack(bit32.band(n13, 4294967295))
										local v40 = table.pack(bit32.band(n132[1], 65535))
										v22 = bit32.band(46383 * v40[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(n132[1], 16) + 61184 * v40[1], 65535), 16), 4294967295)
										v23 = bit32.band(411217669, n13)
										v232 = bit32.bnot(v23)
										local v233 = table.pack(bit32.band(v232, 4294967295))
										local v41 = table.pack(bit32.band(v233[1], 65535))
										local v42 = table.pack(bit32.band(4372607921 - 4087441632 + v22 + bit32.band(46383 * v41[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(v233[1], 16) + 61184 * v41[1], 65535), 16), 4294967295) + 1112571824, 4294967295))
										local v43 = table.pack(bit32.band(v42[1], 65535))
										v24 = bit32.band(7235 * v43[1] + bit32.lshift(bit32.band(7235 * bit32.rshift(v42[1], 16) + 1792 * v43[1], 65535), 16), 4294967295)
										local v234 = table.pack(bit32.band(v232, 4294967295))
										local v44 = table.pack(bit32.band(v234[1], 65535))
										local v45 = table.pack(bit32.band(bit32.band(v44[1] * 20730 + bit32.lshift(bit32.band(v44[1] * 59261 + bit32.rshift(v234[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
										local v46 = table.pack(bit32.band(v45[1], 65535))
										n14 = 3150102558 + 2289729476 + bit32.band(33210 * v46[1] + bit32.lshift(bit32.band(33210 * bit32.rshift(v45[1], 16) + 53983 * v46[1], 65535), 16), 4294967295)
										local n133 = table.pack(bit32.band(bit32.bor(bit32.bnot(n13), 3883749626), 4294967295))
										local v47 = table.pack(bit32.band(n133[1], 65535))
										local v48 = table.pack(bit32.band(bit32.band(v47[1] * 20730 + bit32.lshift(bit32.band(v47[1] * 59261 + bit32.rshift(n133[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
										local v49 = table.pack(bit32.band(v48[1], 65535))
										n15 = v24 + n14 + 3645010203 + bit32.band(32326 * v49[1] + bit32.lshift(bit32.band(32326 * bit32.rshift(v48[1], 16) + 11552 * v49[1], 65535), 16), 4294967295) + 3877700276
										v17[n102] = bit32.bxor(v17[n102], 77640625)
										n16 = n4 + 143406633
										local n105 = table.pack(bit32.band(n102, 4294967295))
										local v50 = table.pack(bit32.band(n105[1], 65535))
										v25 = bit32.band(v50[1] * 35941 + bit32.lshift(bit32.band(v50[1] * 13292 + bit32.rshift(n105[1], 16) * 35941, 65535), 16), 4294967295)
										local n155 = table.pack(bit32.band(n15, 4294967295))
										local v51 = table.pack(bit32.band(n155[1], 65535))
										n17 = 3363122404 + bit32.band(54046 * v51[1] + bit32.lshift(bit32.band(54046 * bit32.rshift(n155[1], 16) + 14218 * v51[1], 65535), 16), 4294967295)
										local v253 = table.pack(bit32.band(v25, 4294967295))
										local v52 = table.pack(bit32.band(v253[1], 65535))
										v26 = bit32.band(22979 * v52[1] + bit32.lshift(bit32.band(22979 * bit32.rshift(v253[1], 16) + 37098 * v52[1], 65535), 16), 4294967295)
										n152 = bit32.band(n15, 411217669)
										local n163 = table.pack(bit32.band(n16, 4294967295))
										local n156 = table.pack(bit32.band(n152, 4294967295))
										local v53 = table.pack(bit32.band(n163[1], 65535))
										local v54 = table.pack(bit32.rshift(n163[1], 16))
										local v55 = table.pack(bit32.band(n156[1], 65535))
										local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n156[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
										local v57 = table.pack(bit32.band(v56[1], 65535))
										n18 = n17 + v26 + bit32.band(33587 * v57[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v56[1], 16) + 36601 * v57[1], 65535), 16), 4294967295)
										local n164 = table.pack(bit32.band(n16, 4294967295))
										local v58 = table.pack(bit32.band(n164[1], 65535))
										n19 = n18 + 4252548308 + bit32.band(22096 * v58[1] + bit32.lshift(bit32.band(22096 * bit32.rshift(n164[1], 16) + 50820 * v58[1], 65535), 16), 4294967295) + n152 + 3542608668
										n162 = bit32.band(n16, 411217669)
										local n165 = table.pack(bit32.band(bit32.bnot(n162), 4294967295))
										local v59 = table.pack(bit32.band(n165[1], 65535))
										v27 = bit32.band(42554 * v59[1] + bit32.lshift(bit32.band(42554 * bit32.rshift(n165[1], 16) + 28437 * v59[1], 65535), 16), 4294967295)
										n153 = bit32.bnot(n152)
										local n166 = table.pack(bit32.band(n16, 4294967295))
										local n157 = table.pack(bit32.band(n153, 4294967295))
										local v60 = table.pack(bit32.band(n166[1], 65535))
										local v61 = table.pack(bit32.rshift(n166[1], 16))
										local v62 = table.pack(bit32.band(n157[1], 65535))
										local v63 = table.pack(bit32.band(bit32.band(v60[1] * v62[1] + bit32.lshift(bit32.band(v60[1] * bit32.rshift(n157[1], 16) + v61[1] * v62[1], 65535), 16), 4294967295), 4294967295))
										local v64 = table.pack(bit32.band(v63[1], 65535))
										n20 = v27 + bit32.band(33587 * v64[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v63[1], 16) + 36601 * v64[1], 65535), 16), 4294967295)
										local v254 = table.pack(bit32.band(bit32.band(bit32.bnot(v25), 1009581529), 4294967295))
										local v65 = table.pack(bit32.band(v254[1], 65535))
										v28 = bit32.band(45962 * v65[1] + bit32.lshift(bit32.band(45962 * bit32.rshift(v254[1], 16) + 8660 * v65[1], 65535), 16), 4294967295)
										v252 = bit32.bor(v25, n16)
										local v66 = table.pack(bit32.band(bit32.bor(3883749626, v252), 4294967295))
										local v67 = table.pack(bit32.band(v66[1], 65535))
										n21 = n20 + v28 + bit32.band(45964 * v67[1] + bit32.lshift(bit32.band(45964 * bit32.rshift(v66[1], 16) + 8660 * v67[1], 65535), 16), 4294967295)
										n192 = n19
										n154 = bit32.bnot(n15)
										local v68 = table.pack(bit32.band(bit32.band(390258361, n154), 4294967295))
										local v69 = table.pack(bit32.band(v68[1], 65535))
										n22 = bit32.band(42556 * v69[1] + bit32.lshift(bit32.band(42556 * bit32.rshift(v68[1], 16) + 28437 * v69[1], 65535), 16), 4294967295) + 1993956034
										v29 = bit32.band(411217669, v25)
										local n158 = table.pack(bit32.band(bit32.band(bit32.bor(n15, n16), v29), 4294967295))
										local v70 = table.pack(bit32.band(n158[1], 65535))
										n23 = n192 + n21 + n22 + 1041196816 + bit32.band(19576 * v70[1] + bit32.lshift(bit32.band(19576 * bit32.rshift(n158[1], 16) + 56875 * v70[1], 65535), 16), 4294967295)
										n232 = bit32.band(n23, 2147483647)
										n233 = bit32.bnot(n232)
										local n237 = table.pack(bit32.band(n233, 4294967295))
										local v71 = table.pack(bit32.band(n237[1], 65535))
										n24 = 1067535265 + bit32.band(19361 * v71[1] + bit32.lshift(bit32.band(19361 * bit32.rshift(n237[1], 16) + 16289 * v71[1], 65535), 16), 4294967295)
										local n238 = table.pack(bit32.band(n23, 4294967295))
										local v72 = table.pack(bit32.band(n238[1], 65535))
										v30 = bit32.band(19362 * v72[1] + bit32.lshift(bit32.band(19362 * bit32.rshift(n238[1], 16) + 16289 * v72[1], 65535), 16), 4294967295)
										n234 = bit32.band(n23, 2147483648)
										local n239 = table.pack(bit32.band(n234, 4294967295))
										local v73 = table.pack(bit32.band(n239[1], 65535))
										n25 = n24 + v30 + bit32.band(46174 * v73[1] + bit32.lshift(bit32.band(46174 * bit32.rshift(n239[1], 16) + 49246 * v73[1], 65535), 16), 4294967295)
										local n2310 = table.pack(bit32.band(n233, 4294967295))
										local v74 = table.pack(bit32.band(n2310[1], 65535))
										n26 = 4270564234 + bit32.band(41866 * v74[1] + bit32.lshift(bit32.band(41866 * bit32.rshift(n2310[1], 16) + 65163 * v74[1], 65535), 16), 4294967295)
										local n2311 = table.pack(bit32.band(n23, 4294967295))
										local v75 = table.pack(bit32.band(n2311[1], 65535))
										v31 = bit32.band(41867 * v75[1] + bit32.lshift(bit32.band(41867 * bit32.rshift(n2311[1], 16) + 65163 * v75[1], 65535), 16), 4294967295)
										local n2312 = table.pack(bit32.band(n234, 4294967295))
										local v76 = table.pack(bit32.band(n2312[1], 65535))
										local v77 = table.pack(bit32.band(n25 - n26 + v31 + bit32.band(23669 * v76[1] + bit32.lshift(bit32.band(23669 * bit32.rshift(n2312[1], 16) + 372 * v76[1], 65535), 16), 4294967295), 4294967295))
										local v78 = table.pack(bit32.band(v77[1], 65535))
										v32 = bit32.band(32588 * v78[1] + bit32.lshift(bit32.band(32588 * bit32.rshift(v77[1], 16) + 60585 * v78[1], 65535), 16), 4294967295)
										n235 = n233
										n236 = bit32.bor(n23, 2147483647)
										local n2313 = table.pack(bit32.band(n23, 4294967295))
										local v79 = table.pack(bit32.band(n2313[1], 65535))
										local v80 = table.pack(bit32.band(bit32.band(v79[1] * 33210 + bit32.lshift(bit32.band(v79[1] * 38851 + bit32.rshift(n2313[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
										local v81 = table.pack(bit32.band(v80[1], 65535))
										n27 = 3529912362 + 314747904 + bit32.band(33465 * v81[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v80[1], 16) + 64846 * v81[1], 65535), 16), 4294967295)
										local n2314 = table.pack(bit32.band(n235, 4294967295))
										local v82 = table.pack(bit32.band(n2314[1], 65535))
										v33 = bit32.band(22897 * v82[1] + bit32.lshift(bit32.band(22897 * bit32.rshift(n2314[1], 16) + 59354 * v82[1], 65535), 16), 4294967295)
										local n2315 = table.pack(bit32.band(n235, 4294967295))
										local v83 = table.pack(bit32.band(n2315[1], 65535))
										local v84 = table.pack(bit32.band(bit32.band(65535 * v83[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n2315[1], 16) + 32767 * v83[1], 65535), 16), 4294967295), 4294967295))
										local v85 = table.pack(bit32.band(v84[1], 65535))
										n28 = v33 + bit32.band(32071 * v85[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v84[1], 16) + 689 * v85[1], 65535), 16), 4294967295)
										local n2316 = table.pack(bit32.band(n236, 4294967295))
										local v86 = table.pack(bit32.band(n2316[1], 65535))
										local v87 = table.pack(bit32.band(bit32.band(v86[1] * 33210 + bit32.lshift(bit32.band(v86[1] * 38851 + bit32.rshift(n2316[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
										local v88 = table.pack(bit32.band(v87[1], 65535))
										v34 = bit32.band(32071 * v88[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v87[1], 16) + 689 * v88[1], 65535), 16), 4294967295)
										local n2317 = table.pack(bit32.band(n235, 4294967295))
										local v89 = table.pack(bit32.band(n2317[1], 65535))
										local v90 = table.pack(bit32.band(bit32.band(v89[1] * 33210 + bit32.lshift(bit32.band(v89[1] * 38851 + bit32.rshift(n2317[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
										local v91 = table.pack(bit32.band(v90[1], 65535))
										n4 = v32 + n27 + n28 + 677552702 + v34 + bit32.band(33465 * v91[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v90[1], 16) + 64846 * v91[1], 65535), 16), 4294967295)
									else
										break
									end
								end

								tbl4 = tbl6[1]
								continue
							end

							break
						end

						tbl4[2] = n9

						if flag3 then
							v17 = tbl5[n9]
							tbl6 = { tbl4, #v17 + 0, 1, 0, nil }

							while true do
								v18 = tbl6[3]
								v19 = tbl6[2]
								n10 = tbl6[4] + v18
								tbl6[4] = n10

								if n10 <= v19 then
									n102 = n10
									n42 = bit32.lshift(bit32.band(n4, n102), 1)
									local n103 = table.pack(bit32.band(n102, 4294967295))
									local v35 = table.pack(bit32.band(n103[1], 65535))
									v20 = bit32.band(8595 * v35[1] + bit32.lshift(bit32.band(8595 * bit32.rshift(n103[1], 16) + 12253 * v35[1], 65535), 16), 4294967295)
									n43 = bit32.bnot(n42)
									local n46 = table.pack(bit32.band(n42, 4294967295))
									local v36 = table.pack(bit32.band(n46[1], 65535))
									n11 = n4 + 4294967294 + v20 + 2781148632 + bit32.band(65535 * v36[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n46[1], 16) + 65535 * v36[1], 65535), 16), 4294967295)
									n44 = bit32.bor(n42, n102)
									local n47 = table.pack(bit32.band(bit32.bnot(n44), 4294967295))
									local v37 = table.pack(bit32.band(n47[1], 65535))
									v21 = bit32.band(8594 * v37[1] + bit32.lshift(bit32.band(8594 * bit32.rshift(n47[1], 16) + 12253 * v37[1], 65535), 16), 4294967295)
									local n48 = table.pack(bit32.band(bit32.bor(n43, n102), 4294967295))
									local v38 = table.pack(bit32.band(n48[1], 65535))
									n12 = v21 + bit32.band(56938 * v38[1] + bit32.lshift(bit32.band(56938 * bit32.rshift(n48[1], 16) + 53282 * v38[1], 65535), 16), 4294967295)
									n45 = bit32.bnot(n4)
									local n104 = table.pack(bit32.band(bit32.band(bit32.band(n102, n42), n45), 4294967295))
									local v39 = table.pack(bit32.band(n104[1], 65535))
									n13 = n11 + n12 + 3720420700 + bit32.band(4 * v39[1] + bit32.lshift(bit32.band(4 * bit32.rshift(n104[1], 16) + 0 * v39[1], 65535), 16), 4294967295) + 2088365252
									local n132 = table.pack(bit32.band(n13, 4294967295))
									local v40 = table.pack(bit32.band(n132[1], 65535))
									v22 = bit32.band(46383 * v40[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(n132[1], 16) + 61184 * v40[1], 65535), 16), 4294967295)
									v23 = bit32.band(411217669, n13)
									v232 = bit32.bnot(v23)
									local v233 = table.pack(bit32.band(v232, 4294967295))
									local v41 = table.pack(bit32.band(v233[1], 65535))
									local v42 = table.pack(bit32.band(4372607921 - 4087441632 + v22 + bit32.band(46383 * v41[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(v233[1], 16) + 61184 * v41[1], 65535), 16), 4294967295) + 1112571824, 4294967295))
									local v43 = table.pack(bit32.band(v42[1], 65535))
									v24 = bit32.band(7235 * v43[1] + bit32.lshift(bit32.band(7235 * bit32.rshift(v42[1], 16) + 1792 * v43[1], 65535), 16), 4294967295)
									local v234 = table.pack(bit32.band(v232, 4294967295))
									local v44 = table.pack(bit32.band(v234[1], 65535))
									local v45 = table.pack(bit32.band(bit32.band(v44[1] * 20730 + bit32.lshift(bit32.band(v44[1] * 59261 + bit32.rshift(v234[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
									local v46 = table.pack(bit32.band(v45[1], 65535))
									n14 = 3150102558 + 2289729476 + bit32.band(33210 * v46[1] + bit32.lshift(bit32.band(33210 * bit32.rshift(v45[1], 16) + 53983 * v46[1], 65535), 16), 4294967295)
									local n133 = table.pack(bit32.band(bit32.bor(bit32.bnot(n13), 3883749626), 4294967295))
									local v47 = table.pack(bit32.band(n133[1], 65535))
									local v48 = table.pack(bit32.band(bit32.band(v47[1] * 20730 + bit32.lshift(bit32.band(v47[1] * 59261 + bit32.rshift(n133[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
									local v49 = table.pack(bit32.band(v48[1], 65535))
									n15 = v24 + n14 + 3645010203 + bit32.band(32326 * v49[1] + bit32.lshift(bit32.band(32326 * bit32.rshift(v48[1], 16) + 11552 * v49[1], 65535), 16), 4294967295) + 3877700276
									v17[n102] = bit32.bxor(v17[n102], 77640625)
									n16 = n4 + 143406633
									local n105 = table.pack(bit32.band(n102, 4294967295))
									local v50 = table.pack(bit32.band(n105[1], 65535))
									v25 = bit32.band(v50[1] * 35941 + bit32.lshift(bit32.band(v50[1] * 13292 + bit32.rshift(n105[1], 16) * 35941, 65535), 16), 4294967295)
									local n155 = table.pack(bit32.band(n15, 4294967295))
									local v51 = table.pack(bit32.band(n155[1], 65535))
									n17 = 3363122404 + bit32.band(54046 * v51[1] + bit32.lshift(bit32.band(54046 * bit32.rshift(n155[1], 16) + 14218 * v51[1], 65535), 16), 4294967295)
									local v253 = table.pack(bit32.band(v25, 4294967295))
									local v52 = table.pack(bit32.band(v253[1], 65535))
									v26 = bit32.band(22979 * v52[1] + bit32.lshift(bit32.band(22979 * bit32.rshift(v253[1], 16) + 37098 * v52[1], 65535), 16), 4294967295)
									n152 = bit32.band(n15, 411217669)
									local n163 = table.pack(bit32.band(n16, 4294967295))
									local n156 = table.pack(bit32.band(n152, 4294967295))
									local v53 = table.pack(bit32.band(n163[1], 65535))
									local v54 = table.pack(bit32.rshift(n163[1], 16))
									local v55 = table.pack(bit32.band(n156[1], 65535))
									local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n156[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
									local v57 = table.pack(bit32.band(v56[1], 65535))
									n18 = n17 + v26 + bit32.band(33587 * v57[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v56[1], 16) + 36601 * v57[1], 65535), 16), 4294967295)
									local n164 = table.pack(bit32.band(n16, 4294967295))
									local v58 = table.pack(bit32.band(n164[1], 65535))
									n19 = n18 + 4252548308 + bit32.band(22096 * v58[1] + bit32.lshift(bit32.band(22096 * bit32.rshift(n164[1], 16) + 50820 * v58[1], 65535), 16), 4294967295) + n152 + 3542608668
									n162 = bit32.band(n16, 411217669)
									local n165 = table.pack(bit32.band(bit32.bnot(n162), 4294967295))
									local v59 = table.pack(bit32.band(n165[1], 65535))
									v27 = bit32.band(42554 * v59[1] + bit32.lshift(bit32.band(42554 * bit32.rshift(n165[1], 16) + 28437 * v59[1], 65535), 16), 4294967295)
									n153 = bit32.bnot(n152)
									local n166 = table.pack(bit32.band(n16, 4294967295))
									local n157 = table.pack(bit32.band(n153, 4294967295))
									local v60 = table.pack(bit32.band(n166[1], 65535))
									local v61 = table.pack(bit32.rshift(n166[1], 16))
									local v62 = table.pack(bit32.band(n157[1], 65535))
									local v63 = table.pack(bit32.band(bit32.band(v60[1] * v62[1] + bit32.lshift(bit32.band(v60[1] * bit32.rshift(n157[1], 16) + v61[1] * v62[1], 65535), 16), 4294967295), 4294967295))
									local v64 = table.pack(bit32.band(v63[1], 65535))
									n20 = v27 + bit32.band(33587 * v64[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v63[1], 16) + 36601 * v64[1], 65535), 16), 4294967295)
									local v254 = table.pack(bit32.band(bit32.band(bit32.bnot(v25), 1009581529), 4294967295))
									local v65 = table.pack(bit32.band(v254[1], 65535))
									v28 = bit32.band(45962 * v65[1] + bit32.lshift(bit32.band(45962 * bit32.rshift(v254[1], 16) + 8660 * v65[1], 65535), 16), 4294967295)
									v252 = bit32.bor(v25, n16)
									local v66 = table.pack(bit32.band(bit32.bor(3883749626, v252), 4294967295))
									local v67 = table.pack(bit32.band(v66[1], 65535))
									n21 = n20 + v28 + bit32.band(45964 * v67[1] + bit32.lshift(bit32.band(45964 * bit32.rshift(v66[1], 16) + 8660 * v67[1], 65535), 16), 4294967295)
									n192 = n19
									n154 = bit32.bnot(n15)
									local v68 = table.pack(bit32.band(bit32.band(390258361, n154), 4294967295))
									local v69 = table.pack(bit32.band(v68[1], 65535))
									n22 = bit32.band(42556 * v69[1] + bit32.lshift(bit32.band(42556 * bit32.rshift(v68[1], 16) + 28437 * v69[1], 65535), 16), 4294967295) + 1993956034
									v29 = bit32.band(411217669, v25)
									local n158 = table.pack(bit32.band(bit32.band(bit32.bor(n15, n16), v29), 4294967295))
									local v70 = table.pack(bit32.band(n158[1], 65535))
									n23 = n192 + n21 + n22 + 1041196816 + bit32.band(19576 * v70[1] + bit32.lshift(bit32.band(19576 * bit32.rshift(n158[1], 16) + 56875 * v70[1], 65535), 16), 4294967295)
									n232 = bit32.band(n23, 2147483647)
									n233 = bit32.bnot(n232)
									local n237 = table.pack(bit32.band(n233, 4294967295))
									local v71 = table.pack(bit32.band(n237[1], 65535))
									n24 = 1067535265 + bit32.band(19361 * v71[1] + bit32.lshift(bit32.band(19361 * bit32.rshift(n237[1], 16) + 16289 * v71[1], 65535), 16), 4294967295)
									local n238 = table.pack(bit32.band(n23, 4294967295))
									local v72 = table.pack(bit32.band(n238[1], 65535))
									v30 = bit32.band(19362 * v72[1] + bit32.lshift(bit32.band(19362 * bit32.rshift(n238[1], 16) + 16289 * v72[1], 65535), 16), 4294967295)
									n234 = bit32.band(n23, 2147483648)
									local n239 = table.pack(bit32.band(n234, 4294967295))
									local v73 = table.pack(bit32.band(n239[1], 65535))
									n25 = n24 + v30 + bit32.band(46174 * v73[1] + bit32.lshift(bit32.band(46174 * bit32.rshift(n239[1], 16) + 49246 * v73[1], 65535), 16), 4294967295)
									local n2310 = table.pack(bit32.band(n233, 4294967295))
									local v74 = table.pack(bit32.band(n2310[1], 65535))
									n26 = 4270564234 + bit32.band(41866 * v74[1] + bit32.lshift(bit32.band(41866 * bit32.rshift(n2310[1], 16) + 65163 * v74[1], 65535), 16), 4294967295)
									local n2311 = table.pack(bit32.band(n23, 4294967295))
									local v75 = table.pack(bit32.band(n2311[1], 65535))
									v31 = bit32.band(41867 * v75[1] + bit32.lshift(bit32.band(41867 * bit32.rshift(n2311[1], 16) + 65163 * v75[1], 65535), 16), 4294967295)
									local n2312 = table.pack(bit32.band(n234, 4294967295))
									local v76 = table.pack(bit32.band(n2312[1], 65535))
									local v77 = table.pack(bit32.band(n25 - n26 + v31 + bit32.band(23669 * v76[1] + bit32.lshift(bit32.band(23669 * bit32.rshift(n2312[1], 16) + 372 * v76[1], 65535), 16), 4294967295), 4294967295))
									local v78 = table.pack(bit32.band(v77[1], 65535))
									v32 = bit32.band(32588 * v78[1] + bit32.lshift(bit32.band(32588 * bit32.rshift(v77[1], 16) + 60585 * v78[1], 65535), 16), 4294967295)
									n235 = n233
									n236 = bit32.bor(n23, 2147483647)
									local n2313 = table.pack(bit32.band(n23, 4294967295))
									local v79 = table.pack(bit32.band(n2313[1], 65535))
									local v80 = table.pack(bit32.band(bit32.band(v79[1] * 33210 + bit32.lshift(bit32.band(v79[1] * 38851 + bit32.rshift(n2313[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
									local v81 = table.pack(bit32.band(v80[1], 65535))
									n27 = 3529912362 + 314747904 + bit32.band(33465 * v81[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v80[1], 16) + 64846 * v81[1], 65535), 16), 4294967295)
									local n2314 = table.pack(bit32.band(n235, 4294967295))
									local v82 = table.pack(bit32.band(n2314[1], 65535))
									v33 = bit32.band(22897 * v82[1] + bit32.lshift(bit32.band(22897 * bit32.rshift(n2314[1], 16) + 59354 * v82[1], 65535), 16), 4294967295)
									local n2315 = table.pack(bit32.band(n235, 4294967295))
									local v83 = table.pack(bit32.band(n2315[1], 65535))
									local v84 = table.pack(bit32.band(bit32.band(65535 * v83[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n2315[1], 16) + 32767 * v83[1], 65535), 16), 4294967295), 4294967295))
									local v85 = table.pack(bit32.band(v84[1], 65535))
									n28 = v33 + bit32.band(32071 * v85[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v84[1], 16) + 689 * v85[1], 65535), 16), 4294967295)
									local n2316 = table.pack(bit32.band(n236, 4294967295))
									local v86 = table.pack(bit32.band(n2316[1], 65535))
									local v87 = table.pack(bit32.band(bit32.band(v86[1] * 33210 + bit32.lshift(bit32.band(v86[1] * 38851 + bit32.rshift(n2316[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
									local v88 = table.pack(bit32.band(v87[1], 65535))
									v34 = bit32.band(32071 * v88[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v87[1], 16) + 689 * v88[1], 65535), 16), 4294967295)
									local n2317 = table.pack(bit32.band(n235, 4294967295))
									local v89 = table.pack(bit32.band(n2317[1], 65535))
									local v90 = table.pack(bit32.band(bit32.band(v89[1] * 33210 + bit32.lshift(bit32.band(v89[1] * 38851 + bit32.rshift(n2317[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
									local v91 = table.pack(bit32.band(v90[1], 65535))
									n4 = v32 + n27 + n28 + 677552702 + v34 + bit32.band(33465 * v91[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v90[1], 16) + 64846 * v91[1], 65535), 16), 4294967295)
								else
									break
								end
							end

							tbl4 = tbl6[1]
							continue
						end

						v13 = arg[7]
						n5 = 24
						n6 = buffer.len(v13) - 24 - 23
						n7 = n5 + 199005006 % n6

						while true do
							n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
							v132 = buffer.readu16(v13, n7)
							v133 = buffer.readi16(v13, n8)
							v134 = bit32.lshift(bit32.band(v133, 255), 3)
							v14 = bit32.band(bit32.bxor(bit32.bxor(471997619, v132) + v134 + 143406633, n7), 2147483647)
							v135 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v132, v133), v14), 2147483647), 983120128)
							buffer.writei32(v13, n7, v135)
							v142 = bit32.rshift(v14, 8)
							v136 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v133, v142), n7), 2147483647), 741008640)
							buffer.writei16(v13, n8, v136)
							n4 = v14
							n7 = n5 + (n7 + bit32.band(v14, 63) + 1) % n6
						end
					end
				end

				flag4 = flag2

				if flag3 then
					tbl4[2] = n9

					if flag3 then
						v17 = tbl5[n9]
						tbl6 = { tbl4, #v17 + 0, 1, 0, nil }

						while true do
							v18 = tbl6[3]
							v19 = tbl6[2]
							n10 = tbl6[4] + v18
							tbl6[4] = n10

							if n10 <= v19 then
								n102 = n10
								n42 = bit32.lshift(bit32.band(n4, n102), 1)
								local n103 = table.pack(bit32.band(n102, 4294967295))
								local v35 = table.pack(bit32.band(n103[1], 65535))
								v20 = bit32.band(8595 * v35[1] + bit32.lshift(bit32.band(8595 * bit32.rshift(n103[1], 16) + 12253 * v35[1], 65535), 16), 4294967295)
								n43 = bit32.bnot(n42)
								local v143 = table.pack(bit32.band(n42, 4294967295))
								local v36 = table.pack(bit32.band(v143[1], 65535))
								n11 = n4 + 4294967294 + v20 + 2781148632 + bit32.band(65535 * v36[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(v143[1], 16) + 65535 * v36[1], 65535), 16), 4294967295)
								n44 = bit32.bor(n42, n102)
								local v144 = table.pack(bit32.band(bit32.bnot(n44), 4294967295))
								local v37 = table.pack(bit32.band(v144[1], 65535))
								v21 = bit32.band(8594 * v37[1] + bit32.lshift(bit32.band(8594 * bit32.rshift(v144[1], 16) + 12253 * v37[1], 65535), 16), 4294967295)
								local v145 = table.pack(bit32.band(bit32.bor(n43, n102), 4294967295))
								local v38 = table.pack(bit32.band(v145[1], 65535))
								n12 = v21 + bit32.band(56938 * v38[1] + bit32.lshift(bit32.band(56938 * bit32.rshift(v145[1], 16) + 53282 * v38[1], 65535), 16), 4294967295)
								n45 = bit32.bnot(n4)
								local n104 = table.pack(bit32.band(bit32.band(bit32.band(n102, n42), n45), 4294967295))
								local v39 = table.pack(bit32.band(n104[1], 65535))
								n13 = n11 + n12 + 3720420700 + bit32.band(4 * v39[1] + bit32.lshift(bit32.band(4 * bit32.rshift(n104[1], 16) + 0 * v39[1], 65535), 16), 4294967295) + 2088365252
								local n132 = table.pack(bit32.band(n13, 4294967295))
								local v40 = table.pack(bit32.band(n132[1], 65535))
								v22 = bit32.band(46383 * v40[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(n132[1], 16) + 61184 * v40[1], 65535), 16), 4294967295)
								v23 = bit32.band(411217669, n13)
								v232 = bit32.bnot(v23)
								local v233 = table.pack(bit32.band(v232, 4294967295))
								local v41 = table.pack(bit32.band(v233[1], 65535))
								local v42 = table.pack(bit32.band(4372607921 - 4087441632 + v22 + bit32.band(46383 * v41[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(v233[1], 16) + 61184 * v41[1], 65535), 16), 4294967295) + 1112571824, 4294967295))
								local v43 = table.pack(bit32.band(v42[1], 65535))
								v24 = bit32.band(7235 * v43[1] + bit32.lshift(bit32.band(7235 * bit32.rshift(v42[1], 16) + 1792 * v43[1], 65535), 16), 4294967295)
								local v234 = table.pack(bit32.band(v232, 4294967295))
								local v44 = table.pack(bit32.band(v234[1], 65535))
								local v45 = table.pack(bit32.band(bit32.band(v44[1] * 20730 + bit32.lshift(bit32.band(v44[1] * 59261 + bit32.rshift(v234[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
								local v46 = table.pack(bit32.band(v45[1], 65535))
								n14 = 3150102558 + 2289729476 + bit32.band(33210 * v46[1] + bit32.lshift(bit32.band(33210 * bit32.rshift(v45[1], 16) + 53983 * v46[1], 65535), 16), 4294967295)
								local n133 = table.pack(bit32.band(bit32.bor(bit32.bnot(n13), 3883749626), 4294967295))
								local v47 = table.pack(bit32.band(n133[1], 65535))
								local v48 = table.pack(bit32.band(bit32.band(v47[1] * 20730 + bit32.lshift(bit32.band(v47[1] * 59261 + bit32.rshift(n133[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
								local v49 = table.pack(bit32.band(v48[1], 65535))
								n15 = v24 + n14 + 3645010203 + bit32.band(32326 * v49[1] + bit32.lshift(bit32.band(32326 * bit32.rshift(v48[1], 16) + 11552 * v49[1], 65535), 16), 4294967295) + 3877700276
								v17[n102] = bit32.bxor(v17[n102], 77640625)
								n16 = n4 + 143406633
								local n105 = table.pack(bit32.band(n102, 4294967295))
								local v50 = table.pack(bit32.band(n105[1], 65535))
								v25 = bit32.band(v50[1] * 35941 + bit32.lshift(bit32.band(v50[1] * 13292 + bit32.rshift(n105[1], 16) * 35941, 65535), 16), 4294967295)
								local n155 = table.pack(bit32.band(n15, 4294967295))
								local v51 = table.pack(bit32.band(n155[1], 65535))
								n17 = 3363122404 + bit32.band(54046 * v51[1] + bit32.lshift(bit32.band(54046 * bit32.rshift(n155[1], 16) + 14218 * v51[1], 65535), 16), 4294967295)
								local v253 = table.pack(bit32.band(v25, 4294967295))
								local v52 = table.pack(bit32.band(v253[1], 65535))
								v26 = bit32.band(22979 * v52[1] + bit32.lshift(bit32.band(22979 * bit32.rshift(v253[1], 16) + 37098 * v52[1], 65535), 16), 4294967295)
								n152 = bit32.band(n15, 411217669)
								local n163 = table.pack(bit32.band(n16, 4294967295))
								local n156 = table.pack(bit32.band(n152, 4294967295))
								local v53 = table.pack(bit32.band(n163[1], 65535))
								local v54 = table.pack(bit32.rshift(n163[1], 16))
								local v55 = table.pack(bit32.band(n156[1], 65535))
								local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n156[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
								local v57 = table.pack(bit32.band(v56[1], 65535))
								n18 = n17 + v26 + bit32.band(33587 * v57[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v56[1], 16) + 36601 * v57[1], 65535), 16), 4294967295)
								local n164 = table.pack(bit32.band(n16, 4294967295))
								local v58 = table.pack(bit32.band(n164[1], 65535))
								n19 = n18 + 4252548308 + bit32.band(22096 * v58[1] + bit32.lshift(bit32.band(22096 * bit32.rshift(n164[1], 16) + 50820 * v58[1], 65535), 16), 4294967295) + n152 + 3542608668
								n162 = bit32.band(n16, 411217669)
								local n165 = table.pack(bit32.band(bit32.bnot(n162), 4294967295))
								local v59 = table.pack(bit32.band(n165[1], 65535))
								v27 = bit32.band(42554 * v59[1] + bit32.lshift(bit32.band(42554 * bit32.rshift(n165[1], 16) + 28437 * v59[1], 65535), 16), 4294967295)
								n153 = bit32.bnot(n152)
								local n166 = table.pack(bit32.band(n16, 4294967295))
								local n157 = table.pack(bit32.band(n153, 4294967295))
								local v60 = table.pack(bit32.band(n166[1], 65535))
								local v61 = table.pack(bit32.rshift(n166[1], 16))
								local v62 = table.pack(bit32.band(n157[1], 65535))
								local v63 = table.pack(bit32.band(bit32.band(v60[1] * v62[1] + bit32.lshift(bit32.band(v60[1] * bit32.rshift(n157[1], 16) + v61[1] * v62[1], 65535), 16), 4294967295), 4294967295))
								local v64 = table.pack(bit32.band(v63[1], 65535))
								n20 = v27 + bit32.band(33587 * v64[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v63[1], 16) + 36601 * v64[1], 65535), 16), 4294967295)
								local v254 = table.pack(bit32.band(bit32.band(bit32.bnot(v25), 1009581529), 4294967295))
								local v65 = table.pack(bit32.band(v254[1], 65535))
								v28 = bit32.band(45962 * v65[1] + bit32.lshift(bit32.band(45962 * bit32.rshift(v254[1], 16) + 8660 * v65[1], 65535), 16), 4294967295)
								v252 = bit32.bor(v25, n16)
								local v66 = table.pack(bit32.band(bit32.bor(3883749626, v252), 4294967295))
								local v67 = table.pack(bit32.band(v66[1], 65535))
								n21 = n20 + v28 + bit32.band(45964 * v67[1] + bit32.lshift(bit32.band(45964 * bit32.rshift(v66[1], 16) + 8660 * v67[1], 65535), 16), 4294967295)
								n192 = n19
								n154 = bit32.bnot(n15)
								local v68 = table.pack(bit32.band(bit32.band(390258361, n154), 4294967295))
								local v69 = table.pack(bit32.band(v68[1], 65535))
								n22 = bit32.band(42556 * v69[1] + bit32.lshift(bit32.band(42556 * bit32.rshift(v68[1], 16) + 28437 * v69[1], 65535), 16), 4294967295) + 1993956034
								v29 = bit32.band(411217669, v25)
								local n158 = table.pack(bit32.band(bit32.band(bit32.bor(n15, n16), v29), 4294967295))
								local v70 = table.pack(bit32.band(n158[1], 65535))
								n23 = n192 + n21 + n22 + 1041196816 + bit32.band(19576 * v70[1] + bit32.lshift(bit32.band(19576 * bit32.rshift(n158[1], 16) + 56875 * v70[1], 65535), 16), 4294967295)
								n232 = bit32.band(n23, 2147483647)
								n233 = bit32.bnot(n232)
								local n237 = table.pack(bit32.band(n233, 4294967295))
								local v71 = table.pack(bit32.band(n237[1], 65535))
								n24 = 1067535265 + bit32.band(19361 * v71[1] + bit32.lshift(bit32.band(19361 * bit32.rshift(n237[1], 16) + 16289 * v71[1], 65535), 16), 4294967295)
								local n238 = table.pack(bit32.band(n23, 4294967295))
								local v72 = table.pack(bit32.band(n238[1], 65535))
								v30 = bit32.band(19362 * v72[1] + bit32.lshift(bit32.band(19362 * bit32.rshift(n238[1], 16) + 16289 * v72[1], 65535), 16), 4294967295)
								n234 = bit32.band(n23, 2147483648)
								local n239 = table.pack(bit32.band(n234, 4294967295))
								local v73 = table.pack(bit32.band(n239[1], 65535))
								n25 = n24 + v30 + bit32.band(46174 * v73[1] + bit32.lshift(bit32.band(46174 * bit32.rshift(n239[1], 16) + 49246 * v73[1], 65535), 16), 4294967295)
								local n2310 = table.pack(bit32.band(n233, 4294967295))
								local v74 = table.pack(bit32.band(n2310[1], 65535))
								n26 = 4270564234 + bit32.band(41866 * v74[1] + bit32.lshift(bit32.band(41866 * bit32.rshift(n2310[1], 16) + 65163 * v74[1], 65535), 16), 4294967295)
								local n2311 = table.pack(bit32.band(n23, 4294967295))
								local v75 = table.pack(bit32.band(n2311[1], 65535))
								v31 = bit32.band(41867 * v75[1] + bit32.lshift(bit32.band(41867 * bit32.rshift(n2311[1], 16) + 65163 * v75[1], 65535), 16), 4294967295)
								local n2312 = table.pack(bit32.band(n234, 4294967295))
								local v76 = table.pack(bit32.band(n2312[1], 65535))
								local v77 = table.pack(bit32.band(n25 - n26 + v31 + bit32.band(23669 * v76[1] + bit32.lshift(bit32.band(23669 * bit32.rshift(n2312[1], 16) + 372 * v76[1], 65535), 16), 4294967295), 4294967295))
								local v78 = table.pack(bit32.band(v77[1], 65535))
								v32 = bit32.band(32588 * v78[1] + bit32.lshift(bit32.band(32588 * bit32.rshift(v77[1], 16) + 60585 * v78[1], 65535), 16), 4294967295)
								n235 = n233
								n236 = bit32.bor(n23, 2147483647)
								local n2313 = table.pack(bit32.band(n23, 4294967295))
								local v79 = table.pack(bit32.band(n2313[1], 65535))
								local v80 = table.pack(bit32.band(bit32.band(v79[1] * 33210 + bit32.lshift(bit32.band(v79[1] * 38851 + bit32.rshift(n2313[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
								local v81 = table.pack(bit32.band(v80[1], 65535))
								n27 = 3529912362 + 314747904 + bit32.band(33465 * v81[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v80[1], 16) + 64846 * v81[1], 65535), 16), 4294967295)
								local n2314 = table.pack(bit32.band(n235, 4294967295))
								local v82 = table.pack(bit32.band(n2314[1], 65535))
								v33 = bit32.band(22897 * v82[1] + bit32.lshift(bit32.band(22897 * bit32.rshift(n2314[1], 16) + 59354 * v82[1], 65535), 16), 4294967295)
								local n2315 = table.pack(bit32.band(n235, 4294967295))
								local v83 = table.pack(bit32.band(n2315[1], 65535))
								local v84 = table.pack(bit32.band(bit32.band(65535 * v83[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n2315[1], 16) + 32767 * v83[1], 65535), 16), 4294967295), 4294967295))
								local v85 = table.pack(bit32.band(v84[1], 65535))
								n28 = v33 + bit32.band(32071 * v85[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v84[1], 16) + 689 * v85[1], 65535), 16), 4294967295)
								local n2316 = table.pack(bit32.band(n236, 4294967295))
								local v86 = table.pack(bit32.band(n2316[1], 65535))
								local v87 = table.pack(bit32.band(bit32.band(v86[1] * 33210 + bit32.lshift(bit32.band(v86[1] * 38851 + bit32.rshift(n2316[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
								local v88 = table.pack(bit32.band(v87[1], 65535))
								v34 = bit32.band(32071 * v88[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v87[1], 16) + 689 * v88[1], 65535), 16), 4294967295)
								local n2317 = table.pack(bit32.band(n235, 4294967295))
								local v89 = table.pack(bit32.band(n2317[1], 65535))
								local v90 = table.pack(bit32.band(bit32.band(v89[1] * 33210 + bit32.lshift(bit32.band(v89[1] * 38851 + bit32.rshift(n2317[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
								local v91 = table.pack(bit32.band(v90[1], 65535))
								n4 = v32 + n27 + n28 + 677552702 + v34 + bit32.band(33465 * v91[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v90[1], 16) + 64846 * v91[1], 65535), 16), 4294967295)
							else
								break
							end
						end

						tbl4 = tbl6[1]
						continue
					end

					v13 = arg[7]
					n5 = 24
					n6 = buffer.len(v13) - 24 - 23
					n7 = n5 + 199005006 % n6

					while true do
						n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
						v132 = buffer.readu16(v13, n7)
						v133 = buffer.readi16(v13, n8)
						v134 = bit32.lshift(bit32.band(v133, 255), 3)
						v14 = bit32.band(bit32.bxor(bit32.bxor(471997619, v132) + v134 + 143406633, n7), 2147483647)
						v135 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v132, v133), v14), 2147483647), 983120128)
						buffer.writei32(v13, n7, v135)
						v142 = bit32.rshift(v14, 8)
						v136 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v133, v142), n7), 2147483647), 741008640)
						buffer.writei16(v13, n8, v136)
						n4 = v14
						n7 = n5 + (n7 + bit32.band(v14, 63) + 1) % n6
					end
				else
					flag3 = flag4
					tbl4[2] = n9

					if flag3 then
						v17 = tbl5[n9]
						tbl6 = { tbl4, #v17 + 0, 1, 0, nil }

						while true do
							v18 = tbl6[3]
							v19 = tbl6[2]
							n10 = tbl6[4] + v18
							tbl6[4] = n10

							if n10 <= v19 then
								n102 = n10
								n42 = bit32.lshift(bit32.band(n4, n102), 1)
								local n103 = table.pack(bit32.band(n102, 4294967295))
								local v35 = table.pack(bit32.band(n103[1], 65535))
								v20 = bit32.band(8595 * v35[1] + bit32.lshift(bit32.band(8595 * bit32.rshift(n103[1], 16) + 12253 * v35[1], 65535), 16), 4294967295)
								n43 = bit32.bnot(n42)
								local v143 = table.pack(bit32.band(n42, 4294967295))
								local v36 = table.pack(bit32.band(v143[1], 65535))
								n11 = n4 + 4294967294 + v20 + 2781148632 + bit32.band(65535 * v36[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(v143[1], 16) + 65535 * v36[1], 65535), 16), 4294967295)
								n44 = bit32.bor(n42, n102)
								local v144 = table.pack(bit32.band(bit32.bnot(n44), 4294967295))
								local v37 = table.pack(bit32.band(v144[1], 65535))
								v21 = bit32.band(8594 * v37[1] + bit32.lshift(bit32.band(8594 * bit32.rshift(v144[1], 16) + 12253 * v37[1], 65535), 16), 4294967295)
								local v145 = table.pack(bit32.band(bit32.bor(n43, n102), 4294967295))
								local v38 = table.pack(bit32.band(v145[1], 65535))
								n12 = v21 + bit32.band(56938 * v38[1] + bit32.lshift(bit32.band(56938 * bit32.rshift(v145[1], 16) + 53282 * v38[1], 65535), 16), 4294967295)
								n45 = bit32.bnot(n4)
								local n104 = table.pack(bit32.band(bit32.band(bit32.band(n102, n42), n45), 4294967295))
								local v39 = table.pack(bit32.band(n104[1], 65535))
								n13 = n11 + n12 + 3720420700 + bit32.band(4 * v39[1] + bit32.lshift(bit32.band(4 * bit32.rshift(n104[1], 16) + 0 * v39[1], 65535), 16), 4294967295) + 2088365252
								local n132 = table.pack(bit32.band(n13, 4294967295))
								local v40 = table.pack(bit32.band(n132[1], 65535))
								v22 = bit32.band(46383 * v40[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(n132[1], 16) + 61184 * v40[1], 65535), 16), 4294967295)
								v23 = bit32.band(411217669, n13)
								v232 = bit32.bnot(v23)
								local v233 = table.pack(bit32.band(v232, 4294967295))
								local v41 = table.pack(bit32.band(v233[1], 65535))
								local v42 = table.pack(bit32.band(4372607921 - 4087441632 + v22 + bit32.band(46383 * v41[1] + bit32.lshift(bit32.band(46383 * bit32.rshift(v233[1], 16) + 61184 * v41[1], 65535), 16), 4294967295) + 1112571824, 4294967295))
								local v43 = table.pack(bit32.band(v42[1], 65535))
								v24 = bit32.band(7235 * v43[1] + bit32.lshift(bit32.band(7235 * bit32.rshift(v42[1], 16) + 1792 * v43[1], 65535), 16), 4294967295)
								local v234 = table.pack(bit32.band(v232, 4294967295))
								local v44 = table.pack(bit32.band(v234[1], 65535))
								local v45 = table.pack(bit32.band(bit32.band(v44[1] * 20730 + bit32.lshift(bit32.band(v44[1] * 59261 + bit32.rshift(v234[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
								local v46 = table.pack(bit32.band(v45[1], 65535))
								n14 = 3150102558 + 2289729476 + bit32.band(33210 * v46[1] + bit32.lshift(bit32.band(33210 * bit32.rshift(v45[1], 16) + 53983 * v46[1], 65535), 16), 4294967295)
								local n133 = table.pack(bit32.band(bit32.bor(bit32.bnot(n13), 3883749626), 4294967295))
								local v47 = table.pack(bit32.band(n133[1], 65535))
								local v48 = table.pack(bit32.band(bit32.band(v47[1] * 20730 + bit32.lshift(bit32.band(v47[1] * 59261 + bit32.rshift(n133[1], 16) * 20730, 65535), 16), 4294967295), 4294967295))
								local v49 = table.pack(bit32.band(v48[1], 65535))
								n15 = v24 + n14 + 3645010203 + bit32.band(32326 * v49[1] + bit32.lshift(bit32.band(32326 * bit32.rshift(v48[1], 16) + 11552 * v49[1], 65535), 16), 4294967295) + 3877700276
								v17[n102] = bit32.bxor(v17[n102], 77640625)
								n16 = n4 + 143406633
								local n105 = table.pack(bit32.band(n102, 4294967295))
								local v50 = table.pack(bit32.band(n105[1], 65535))
								v25 = bit32.band(v50[1] * 35941 + bit32.lshift(bit32.band(v50[1] * 13292 + bit32.rshift(n105[1], 16) * 35941, 65535), 16), 4294967295)
								local n155 = table.pack(bit32.band(n15, 4294967295))
								local v51 = table.pack(bit32.band(n155[1], 65535))
								n17 = 3363122404 + bit32.band(54046 * v51[1] + bit32.lshift(bit32.band(54046 * bit32.rshift(n155[1], 16) + 14218 * v51[1], 65535), 16), 4294967295)
								local v253 = table.pack(bit32.band(v25, 4294967295))
								local v52 = table.pack(bit32.band(v253[1], 65535))
								v26 = bit32.band(22979 * v52[1] + bit32.lshift(bit32.band(22979 * bit32.rshift(v253[1], 16) + 37098 * v52[1], 65535), 16), 4294967295)
								n152 = bit32.band(n15, 411217669)
								local n163 = table.pack(bit32.band(n16, 4294967295))
								local n156 = table.pack(bit32.band(n152, 4294967295))
								local v53 = table.pack(bit32.band(n163[1], 65535))
								local v54 = table.pack(bit32.rshift(n163[1], 16))
								local v55 = table.pack(bit32.band(n156[1], 65535))
								local v56 = table.pack(bit32.band(bit32.band(v53[1] * v55[1] + bit32.lshift(bit32.band(v53[1] * bit32.rshift(n156[1], 16) + v54[1] * v55[1], 65535), 16), 4294967295), 4294967295))
								local v57 = table.pack(bit32.band(v56[1], 65535))
								n18 = n17 + v26 + bit32.band(33587 * v57[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v56[1], 16) + 36601 * v57[1], 65535), 16), 4294967295)
								local n164 = table.pack(bit32.band(n16, 4294967295))
								local v58 = table.pack(bit32.band(n164[1], 65535))
								n19 = n18 + 4252548308 + bit32.band(22096 * v58[1] + bit32.lshift(bit32.band(22096 * bit32.rshift(n164[1], 16) + 50820 * v58[1], 65535), 16), 4294967295) + n152 + 3542608668
								n162 = bit32.band(n16, 411217669)
								local n165 = table.pack(bit32.band(bit32.bnot(n162), 4294967295))
								local v59 = table.pack(bit32.band(n165[1], 65535))
								v27 = bit32.band(42554 * v59[1] + bit32.lshift(bit32.band(42554 * bit32.rshift(n165[1], 16) + 28437 * v59[1], 65535), 16), 4294967295)
								n153 = bit32.bnot(n152)
								local n166 = table.pack(bit32.band(n16, 4294967295))
								local n157 = table.pack(bit32.band(n153, 4294967295))
								local v60 = table.pack(bit32.band(n166[1], 65535))
								local v61 = table.pack(bit32.rshift(n166[1], 16))
								local v62 = table.pack(bit32.band(n157[1], 65535))
								local v63 = table.pack(bit32.band(bit32.band(v60[1] * v62[1] + bit32.lshift(bit32.band(v60[1] * bit32.rshift(n157[1], 16) + v61[1] * v62[1], 65535), 16), 4294967295), 4294967295))
								local v64 = table.pack(bit32.band(v63[1], 65535))
								n20 = v27 + bit32.band(33587 * v64[1] + bit32.lshift(bit32.band(33587 * bit32.rshift(v63[1], 16) + 36601 * v64[1], 65535), 16), 4294967295)
								local v254 = table.pack(bit32.band(bit32.band(bit32.bnot(v25), 1009581529), 4294967295))
								local v65 = table.pack(bit32.band(v254[1], 65535))
								v28 = bit32.band(45962 * v65[1] + bit32.lshift(bit32.band(45962 * bit32.rshift(v254[1], 16) + 8660 * v65[1], 65535), 16), 4294967295)
								v252 = bit32.bor(v25, n16)
								local v66 = table.pack(bit32.band(bit32.bor(3883749626, v252), 4294967295))
								local v67 = table.pack(bit32.band(v66[1], 65535))
								n21 = n20 + v28 + bit32.band(45964 * v67[1] + bit32.lshift(bit32.band(45964 * bit32.rshift(v66[1], 16) + 8660 * v67[1], 65535), 16), 4294967295)
								n192 = n19
								n154 = bit32.bnot(n15)
								local v68 = table.pack(bit32.band(bit32.band(390258361, n154), 4294967295))
								local v69 = table.pack(bit32.band(v68[1], 65535))
								n22 = bit32.band(42556 * v69[1] + bit32.lshift(bit32.band(42556 * bit32.rshift(v68[1], 16) + 28437 * v69[1], 65535), 16), 4294967295) + 1993956034
								v29 = bit32.band(411217669, v25)
								local n158 = table.pack(bit32.band(bit32.band(bit32.bor(n15, n16), v29), 4294967295))
								local v70 = table.pack(bit32.band(n158[1], 65535))
								n23 = n192 + n21 + n22 + 1041196816 + bit32.band(19576 * v70[1] + bit32.lshift(bit32.band(19576 * bit32.rshift(n158[1], 16) + 56875 * v70[1], 65535), 16), 4294967295)
								n232 = bit32.band(n23, 2147483647)
								n233 = bit32.bnot(n232)
								local n237 = table.pack(bit32.band(n233, 4294967295))
								local v71 = table.pack(bit32.band(n237[1], 65535))
								n24 = 1067535265 + bit32.band(19361 * v71[1] + bit32.lshift(bit32.band(19361 * bit32.rshift(n237[1], 16) + 16289 * v71[1], 65535), 16), 4294967295)
								local n238 = table.pack(bit32.band(n23, 4294967295))
								local v72 = table.pack(bit32.band(n238[1], 65535))
								v30 = bit32.band(19362 * v72[1] + bit32.lshift(bit32.band(19362 * bit32.rshift(n238[1], 16) + 16289 * v72[1], 65535), 16), 4294967295)
								n234 = bit32.band(n23, 2147483648)
								local n239 = table.pack(bit32.band(n234, 4294967295))
								local v73 = table.pack(bit32.band(n239[1], 65535))
								n25 = n24 + v30 + bit32.band(46174 * v73[1] + bit32.lshift(bit32.band(46174 * bit32.rshift(n239[1], 16) + 49246 * v73[1], 65535), 16), 4294967295)
								local n2310 = table.pack(bit32.band(n233, 4294967295))
								local v74 = table.pack(bit32.band(n2310[1], 65535))
								n26 = 4270564234 + bit32.band(41866 * v74[1] + bit32.lshift(bit32.band(41866 * bit32.rshift(n2310[1], 16) + 65163 * v74[1], 65535), 16), 4294967295)
								local n2311 = table.pack(bit32.band(n23, 4294967295))
								local v75 = table.pack(bit32.band(n2311[1], 65535))
								v31 = bit32.band(41867 * v75[1] + bit32.lshift(bit32.band(41867 * bit32.rshift(n2311[1], 16) + 65163 * v75[1], 65535), 16), 4294967295)
								local n2312 = table.pack(bit32.band(n234, 4294967295))
								local v76 = table.pack(bit32.band(n2312[1], 65535))
								local v77 = table.pack(bit32.band(n25 - n26 + v31 + bit32.band(23669 * v76[1] + bit32.lshift(bit32.band(23669 * bit32.rshift(n2312[1], 16) + 372 * v76[1], 65535), 16), 4294967295), 4294967295))
								local v78 = table.pack(bit32.band(v77[1], 65535))
								v32 = bit32.band(32588 * v78[1] + bit32.lshift(bit32.band(32588 * bit32.rshift(v77[1], 16) + 60585 * v78[1], 65535), 16), 4294967295)
								n235 = n233
								n236 = bit32.bor(n23, 2147483647)
								local n2313 = table.pack(bit32.band(n23, 4294967295))
								local v79 = table.pack(bit32.band(n2313[1], 65535))
								local v80 = table.pack(bit32.band(bit32.band(v79[1] * 33210 + bit32.lshift(bit32.band(v79[1] * 38851 + bit32.rshift(n2313[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
								local v81 = table.pack(bit32.band(v80[1], 65535))
								n27 = 3529912362 + 314747904 + bit32.band(33465 * v81[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v80[1], 16) + 64846 * v81[1], 65535), 16), 4294967295)
								local n2314 = table.pack(bit32.band(n235, 4294967295))
								local v82 = table.pack(bit32.band(n2314[1], 65535))
								v33 = bit32.band(22897 * v82[1] + bit32.lshift(bit32.band(22897 * bit32.rshift(n2314[1], 16) + 59354 * v82[1], 65535), 16), 4294967295)
								local n2315 = table.pack(bit32.band(n235, 4294967295))
								local v83 = table.pack(bit32.band(n2315[1], 65535))
								local v84 = table.pack(bit32.band(bit32.band(65535 * v83[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(n2315[1], 16) + 32767 * v83[1], 65535), 16), 4294967295), 4294967295))
								local v85 = table.pack(bit32.band(v84[1], 65535))
								n28 = v33 + bit32.band(32071 * v85[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v84[1], 16) + 689 * v85[1], 65535), 16), 4294967295)
								local n2316 = table.pack(bit32.band(n236, 4294967295))
								local v86 = table.pack(bit32.band(n2316[1], 65535))
								local v87 = table.pack(bit32.band(bit32.band(v86[1] * 33210 + bit32.lshift(bit32.band(v86[1] * 38851 + bit32.rshift(n2316[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
								local v88 = table.pack(bit32.band(v87[1], 65535))
								v34 = bit32.band(32071 * v88[1] + bit32.lshift(bit32.band(32071 * bit32.rshift(v87[1], 16) + 689 * v88[1], 65535), 16), 4294967295)
								local n2317 = table.pack(bit32.band(n235, 4294967295))
								local v89 = table.pack(bit32.band(n2317[1], 65535))
								local v90 = table.pack(bit32.band(bit32.band(v89[1] * 33210 + bit32.lshift(bit32.band(v89[1] * 38851 + bit32.rshift(n2317[1], 16) * 33210, 65535), 16), 4294967295), 4294967295))
								local v91 = table.pack(bit32.band(v90[1], 65535))
								n4 = v32 + n27 + n28 + 677552702 + v34 + bit32.band(33465 * v91[1] + bit32.lshift(bit32.band(33465 * bit32.rshift(v90[1], 16) + 64846 * v91[1], 65535), 16), 4294967295)
							else
								break
							end
						end

						tbl4 = tbl6[1]
						continue
					end

					v13 = arg[7]
					n5 = 24
					n6 = buffer.len(v13) - 24 - 23
					n7 = n5 + 199005006 % n6

					while true do
						n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
						v132 = buffer.readu16(v13, n7)
						v133 = buffer.readi16(v13, n8)
						v134 = bit32.lshift(bit32.band(v133, 255), 3)
						v14 = bit32.band(bit32.bxor(bit32.bxor(471997619, v132) + v134 + 143406633, n7), 2147483647)
						v135 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v132, v133), v14), 2147483647), 983120128)
						buffer.writei32(v13, n7, v135)
						v142 = bit32.rshift(v14, 8)
						v136 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v133, v142), n7), 2147483647), 741008640)
						buffer.writei16(v13, n8, v136)
						n4 = v14
						n7 = n5 + (n7 + bit32.band(v14, 63) + 1) % n6
					end
				end
			end

			v13 = arg[7]
			n5 = 24
			n6 = buffer.len(v13) - 24 - 23
			n7 = n5 + 199005006 % n6

			while true do
				n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
				v132 = buffer.readu16(v13, n7)
				v133 = buffer.readi16(v13, n8)
				v134 = bit32.lshift(bit32.band(v133, 255), 3)
				v14 = bit32.band(bit32.bxor(bit32.bxor(471997619, v132) + v134 + 143406633, n7), 2147483647)
				v135 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v132, v133), v14), 2147483647), 983120128)
				buffer.writei32(v13, n7, v135)
				v142 = bit32.rshift(v14, 8)
				v136 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v133, v142), n7), 2147483647), 741008640)
				buffer.writei16(v13, n8, v136)
				n4 = v14
				n7 = n5 + (n7 + bit32.band(v14, 63) + 1) % n6
			end
		end

		fn10(nil, nil, nil, nil, nil)

		while true do
		end
	end

	fn7 = function()
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	tbl2 = { [false] = true }
	tbl2[true] = false
	local tbl4 = {}
	local n4 = 221475940

	fn8 = function(arg, arg2)
		if not nil and nil then
			if not nil and nil then
				return true
			end
			return false
		end

		tbl4[arg] = true
		local v13 = tbl4[arg2]
		local tbl42 = tbl4

		if nil then
			n4 = bit32.bxor(n4, 1580442503)
		end

		tbl42[arg] = nil
		return v13
	end

	n4 = 249794661

	local function fn10(arg, arg2)
		local exitTo4 = nil
		local exitTo3

		while true do
			exitTo3 = nil

			while true do
				if not nil then
					fn5(456943662, 4)
					n = 171627653
					fn6()
				end

				local exitTo = nil

				while true do
					local kind = type(arg2)
					local fn82 = fn8

					if fn8("table", kind) then
						exitTo = 1
						break
					else
						local fn822 = fn82
						local exitTo2 = nil

						while true do
							fn5(456943662, 4)
							n = 171627653
							fn6()

							if fn822 then
								exitTo2 = 1
								break
							else
								if nil then
									if nil <= 4 then
										exitTo2 = 2
										break
									elseif nil <= 6 then
										exitTo2 = 3
										break
									elseif nil <= 7 then
										continue
									else
										exitTo2 = 4
										break
									end
								end

								break
							end
						end

						if exitTo2 == 1 then
							exitTo = 1
							break
						elseif exitTo2 == 2 then
							if nil <= 1 then
								if not (nil <= 0) then
									continue
								end
							elseif nil <= 2 then
								fn5(456943662, 4)
								n = 171627653
								fn6()
								continue
							else
								exitTo = 4
								break
							end
						elseif exitTo2 == 3 then
							exitTo = 2
							break
						elseif exitTo2 == 4 then
							exitTo = 3
							break
						else
							continue
						end

						break
					end
				end

				if exitTo == 1 then
					exitTo3 = 1
					break
				elseif exitTo == 2 then
					if nil <= 5 then
						exitTo3 = 4
						break
					else
						continue
					end
				elseif exitTo == 3 then
					exitTo3 = 2
					break
				elseif exitTo == 4 then
					if nil <= 3 then
						continue
					else
						exitTo3 = 3
						break
					end
				end

				break
			end

			if exitTo3 == 1 then
				exitTo4 = 1
				break
			elseif exitTo3 == 2 then
				if nil <= 8 then
					exitTo4 = 1
					break
				else
					continue
				end
			end

			break
		end

		if exitTo4 == 1 then
			local v13 = getmetatable(arg2)
			fn8(nil, v13)

			if not nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
			end

			pcall(setmetatable, arg2, nil)
		elseif exitTo3 == 3 then
			fn5(456943662, 4)
			n = 171627653
			fn6()
			pcall(setmetatable, arg2, nil)
			return
		elseif exitTo3 == 4 then
			pcall(setmetatable, arg2, nil)
			return
		end
	end

	fn9 = function(arg)
		local v13 = table.pack(string.byte(arg, 1, -1))
		table.pack(table.unpack(v13, 1, v13.n))
		local tbl5 = { 1 - 1, nil, 1, (table.pack(table.unpack(v13, 1, v13.n))).n + 0, nil }

		while true do
			local v14 = tbl5[3]
			local v15 = tbl5[4]
			local n5 = tbl5[1] + v14
			tbl5[1] = n5

			if n5 <= v15 then
			else
				break
			end
		end

		return 3110647387
	end

	local function fn11(arg, arg2, arg3)
		for k in arg2, nil, nil do
			arg3[fn9(k)] = nil
		end

		for k in arg3, nil, nil do
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end
	end

	new = v11.new
	new2 = v3.new
	new3 = v12.new
	color3New = Color3.new
	rectNew = Rect.new
	uDim2New = UDim2.new
	uDimNew = UDim.new
	new4 = Path2DControlPoint.new
	local tbl5 = {}
	local str = "namewhat"
	v9 = fn10
	v10 = fn11
	tbl5[str] = ""
	tbl5.isvararg = true
	tbl5.nparams = 0
	tbl5.linedefined = -1
	tbl5.currentline = -1
	tbl5.short_src = "[C]"
	tbl5.lastlinedefined = -1
	tbl5.source = "=[C]"
	tbl5.what = "C"
end

local fn10

fn10 = function()
end

fn10(getmetatable, "getmetatable")
fn10(setmetatable, "setmetatable")
fn10(tonumber, "tonumber")
fn10(tostring, "tostring")
fn10(rawset, "rawset")
fn10(rawget, "rawget")
fn10(select, "select")
fn10(xpcall, "xpcall")
fn10(assert, "assert")
fn10(error, "error")
fn10(pcall, "pcall")
fn10(type, "type")
fn10(next, "next")
fn10(getfenv, "getfenv")
fn10(setfenv, "setfenv")
fn10(typeof, "typeof")
fn10(string.gmatch, "gmatch")
fn10(string.format, "format")
fn10(string.match, "match")
fn10(string.find, "find")
fn10(string.char, "char")
fn10(string.byte, "byte")
fn10(string.gsub, "gsub")
fn10(string.sub, "sub")
fn10(string.rep, "rep")
fn10(string.unpack, "unpack")
fn10(string.pack, "pack")
fn10(table.concat, "concat")
fn10(table.insert, "insert")
fn10(table.pack, "pack")
fn10(table.clear, "clear")
fn10(table.create, "create")
fn10(table.move, "move")
fn10(bit32.bor, "bor")
fn10(bit32.bnot, "bnot")
fn10(bit32.bxor, "bxor")
fn10(bit32.band, "band")
fn10(bit32.lshift, "lshift")
fn10(bit32.rshift, "rshift")
fn10(bit32.rrotate, "rrotate")
fn10(bit32.lrotate, "lrotate")
fn10(bit32.countlz, "countlz")
fn10(bit32.countrz, "countrz")
fn10(buffer.len, "len")
fn10(buffer.fill, "fill")
fn10(buffer.copy, "copy")
fn10(buffer.create, "create")
fn10(buffer.tostring, "tostring")
fn10(buffer.fromstring, "fromstring")
fn10(buffer.readstring, "readstring")
fn10(buffer.writestring, "writestring")
fn10(buffer.readi8, "readi8")
fn10(buffer.readu8, "readu8")
fn10(buffer.readi16, "readi16")
fn10(buffer.readu16, "readu16")
fn10(buffer.readi32, "readi32")
local n2, n3, v11, n4, fn11, tbl3, tbl4, v12, n5

do
	local n6 = 3561421725
	fn10(buffer.readu32, "readu32")
	fn10(buffer.readf32, "readf32")
	fn10(buffer.readf64, "readf64")
	fn10(buffer.writei8, "writei8")
	fn10(buffer.writeu8, "writeu8")
	fn10(buffer.writei16, "writei16")
	fn10(buffer.writeu16, "writeu16")
	fn10(buffer.writei32, "writei32")
	n2 = 274204610
	fn10(buffer.writeu32, "writeu32")
	fn10(buffer.writef32, "writef32")
	fn10(buffer.writef64, "writef64")
	fn10(buffer.readbits, "readbits")
	fn10(buffer.writebits, "writebits")
	fn10(coroutine.isyieldable, "isyieldable")
	fn10(coroutine.running, "running")
	fn10(coroutine.create, "create")
	fn10(coroutine.status, "status")
	fn10(coroutine.yield, "yield")
	fn10(coroutine.close, "close")
	fn10(coroutine.resume, "resume")
	fn10(coroutine.wrap, "wrap")
	fn10(cancel, "cancel")
	fn10(spawn, "spawn")
	fn10(defer, "defer")
	n3 = 733545570 // n6
	fn10(delay, "delay")
	fn10(wait, "wait")
	fn10(unpack, "unpack")
	fn10(info, "info")
	fn10(traceback, "traceback")
	fn10(v7)
	local v13 = pcall
	local v14 = xpcall
	local n7 = 9519223
	local n8 = 53182442
	new3(0.64706402847133615, 0.23156912313835987, 0.36451554086440563)
	new("Folder")
	local ScreenGui = new("ScreenGui")
	local Frame = new("Frame")
	local Path2D = new("Path2D")
	Frame.Parent = ScreenGui
	Path2D.Parent = Frame
	vector.create(0.84792132841331369, 0.77266462126029711, 0.98675392241131299)

	local function fn12()
		assert(0.51493601617388141)
		getfenv(0)
		tostring(0.091096157786962673)
		rawequal(scratch, scratch)
		local tbl5 = {}
		next(tbl5)
		pairs(tbl5)(tbl5)
		ipairs(tbl5)(tbl5, 1)
		rawlen(tbl5)
		rawget(tbl5, 0.34283071190590209)
		rawset(tbl5, 0.85985955573402639, 0.83128204481014967)
		getmetatable(tbl5)
		setmetatable(tbl5, tbl5)
		setmetatable(tbl5, nil)
		info(17452, "slnaf")
		local buf = buffer.create(255)
		buffer.len(buf)
		buffer.fromstring("")
		buffer.tostring(buf)
		buffer.readi8(buf, 3)
		buffer.readu8(buf, 31)
		buffer.readi16(buf, 7)
		buffer.readu16(buf, 7)
		buffer.readi32(buf, 11)
		buffer.readu32(buf, 2)
		buffer.readf32(buf, 1)
		buffer.readf64(buf, 1)
		buffer.writei8(buf, 31, -49)
		buffer.writeu8(buf, 28, 181)
		buffer.writei16(buf, 17, -14188)
		buffer.writeu16(buf, 22, 2213)
		buffer.writei32(buf, 14, -1582594783)
		buffer.writeu32(buf, 31, 1741132493)
		buffer.writef32(buf, 20, 59001)
		buffer.writef64(buf, 29, 21506)
		buffer.readstring(buf, 12, 18)
		buffer.writestring(buf, 6, "Luraph", 4)
		buffer.readbits(buf, 196, 29)
		buffer.writebits(buf, 224, 20, 1067390136)
		buffer.copy(buf, 32, buf, 0, 16)
		buffer.fill(buf, 13, 85, 4)
		local v15 = v5.new()
		v15:NextInteger(46, 494)
		v15:NextNumber(21, 294)
		v15:NextUnitVector()
		v15:NextNumber()
		v15:Shuffle({})
		v15:Clone()
		local n9 = Vector3.new(0.3866195, 0.73311484, 0.6473666) + Vector3.new(0.57784736, 0.3652791, 0.80583185)
		local vector_ = Vector3.new(0.3866195, 0.73311484, 0.6473666)
		local vector_2 = Vector3.new(0.57784736, 0.3652791, 0.80583185)
		local vector_3 = Vector3.new(1, 0, 0)
		local vector_4 = Vector3.new(0, 1, 0)
		local v16 = v4.new()
		local vector_5 = v4.new(vector_)
		v4.Angles(0.15807119310973339, 0.75921623710541619, 0.70308776472964452)
		local xyz = Enum.RotationOrder.XYZ
		v4.new(vector_, n9)
		v4.new(vector_.X, vector_.Y, vector_.Z)
		v4.new(vector_.X, vector_.Y, vector_.Z, 0, 0, 0, 1)
		v4.new(vector_.X, vector_.Y, vector_.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		v4.lookAt(vector_, n9, vector_4)
		v4.lookAlong(vector_, vector_2, vector_4)
		v4.fromEulerAnglesXYZ(0.15807119310973339, 0.75921623710541619, 0.70308776472964452)
		v4.fromEulerAnglesYXZ(0.15807119310973339, 0.75921623710541619, 0.70308776472964452)
		v4.fromOrientation(0.15807119310973339, 0.75921623710541619, 0.70308776472964452)
		v4.fromAxisAngle(vector_2.Unit, 0.15807119310973339)
		v4.fromRotationBetweenVectors(vector_3, vector_4)
		v4.fromMatrix(vector_, vector_3, vector_4, Vector3.new(0, 0, 1))
		v4.fromEulerAngles(0.15807119310973339, 0.75921623710541619, 0.70308776472964452, xyz)
		v16:Inverse()
		v16:Orthonormalize()
		v16:Lerp(vector_5, 0.37175420660355185)
		v16:ToWorldSpace(vector_5)
		v16:ToObjectSpace(vector_5)
		v16:ToEulerAnglesXYZ()
		v16:ToEulerAnglesYXZ()
		v16:PointToWorldSpace(vector_)
		v16:PointToObjectSpace(vector_)
		v16:VectorToWorldSpace(vector_2)
		v16:VectorToObjectSpace(vector_2)
		v16:ToEulerAngles(xyz)
		v16:GetComponents()
		v16:ToOrientation()
		v16:ToAxisAngle()
		v16:FuzzyEq(vector_5)
		v16:AngleBetween(vector_5)
		local vector_6 = Vector3.new(0.93817705, 0.3359345, 0.8508741)
		local vector_7 = Vector3.new(0.08775953, 0.020500895, 0.7825082)
		v3.FromAxis(Enum.Axis.X)
		v3.FromNormalId(Enum.NormalId.Top)
		vector_6:Abs()
		vector_6:Ceil()
		vector_6:Floor()
		vector_6:Sign()
		vector_6:Dot(vector_7)
		vector_6:Cross(vector_7)
		vector_6:Angle(vector_7)
		vector_6:FuzzyEq(vector_7)
		vector_6:Lerp(vector_7, 0.35179382980332796)
		vector_6:Max(vector_7)
		vector_6:Min(vector_7)
		local vector2 = Vector2.new(0.660514235496521, 0.92001283168792725)
		vector2:Abs()
		vector2:Ceil()
		vector2:Floor()
		vector2:Sign()
		vector2:Dot(Vector2.new(0.97926443815231323, 0.27542167901992798))
		vector2:Cross(Vector2.new(0.97926443815231323, 0.27542167901992798))
		vector2:Angle(Vector2.new(0.97926443815231323, 0.27542167901992798))
		vector2:FuzzyEq(Vector2.new(0.97926443815231323, 0.27542167901992798))
		vector2:Lerp(Vector2.new(0.97926443815231323, 0.27542167901992798), 0.13903478206429953)
		local vector22 = Vector2.new(0.97926443815231323, 0.27542167901992798)
		vector2:Max(vector22)
		vector2:Min(vector22)
		uDimNew(-0.50611345491918192, 20)
		uDimNew(0.7891247685609073, 121)
		uDim2New(-0.50399555140956154, 109, -0.53489521329059109, -106):Lerp(uDim2New(-0.88045401394042599, 116, 0.40336497238993352, -55), 0.53530959647234566)
		local Ball = Enum.PartType:FromName("CornerWedge").EnumType.Ball.EnumType:FromValue(2).EnumType:FromValue(2).EnumType:FromName("Ball")
		local enumType = Ball.EnumType
		enumType:GetEnumItems()
		enumType:FromName(Ball.Name)
		enumType:FromValue(Ball.Value)
		local v17 = uDim2New(0.02639898181850206, 41, 0.2267014215031237, 11)
		local v18 = uDim2New(0.090765076750997375, 12, 0.065907370491987249, 12)
		local v19 = uDim2New(0.70123768869346725, 137, 0.54989753273166642, 132)
		local v20 = new4(v17, v18, v18)
		new4(v17:Lerp(v19, 0.73560594446000827))
		local ctx = {}
		local v21 = new4(v19)
		ctx.v20 = v20
		ctx.v21 = v21
		local v22 = utf8.char(90, 1603, 455586)
		utf8.codepoint(v22, 1, #v22)
		utf8.len(v22)
		utf8.offset(v22, 2)
		utf8.offset(v22, -1)
		local v222, v23, v24 = utf8.codes(v22)
		v222(v23, v24)
		v222(v23, utf8.offset(v22, 1))
		local v25 = utf8.char(108, 853)
		utf8.nfcnormalize(v25)
		utf8.nfdnormalize(v22)
		utf8.graphemes(v25, 1, #v25)()
		n8 = (1 * n8 + 18061882) % 268435456
		n7 = (403745 * n7 + 158849357) % 268435456
	end

	local fn122 = coroutine.wrap(fn12)
	local tbl5 = {}
	local n9 = 0

	local function fn13()
		n9 += 1

		if nil then
			setmetatable({}, { __index = fn7 })
			local v15 = luraph_runtime6(nil, nil, table.pack(r11, spawn, fn5, n, fn6), nil)
			v13(v15)
			fn5(456943662, 4)
			n = 171627653
			fn6()
			return
		end

		if nil then
			fn122()
		end

		n7 = (30111 * n7 + 248850723) % 268435456
		n8 = (1 * n8 + 24328206) % 268435456
	end

	setmetatable(tbl5, { __index = fn13, __newindex = fn13 })
	local ok, result = pcall(fn13)

	if tbl2[not ok] then
		fn4(307116577, 173)
		n3 = 4294967296
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local n10 = n6 + n3

	if tbl2[not result] then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	else
		fn4(307116577, 78)
	end

	local v15 = luraph_runtime1(nil, nil, table.pack(n7, n8), nil)
	local flag = false
	local v16 = luraph_runtime3(nil, nil, table.pack(v13, r231), nil)

	local function fn14()
		n7 = (308703 * n7 + 257830483) % 268435456
		n8 = (1 * n8 + 70188120) % 268435456
	end

	local v17 = luraph_runtime4(nil, nil, table.pack(n8, n7), nil)

	local function fn15()
		n8 = n8 - n8 % 2 + 1
		n7 = (519097 * n7 + 9710431) % 268435456
	end

	local n11 = 0

	fn = function()
		n11 += 1

		if n11 ~= 2499 then
			if n11 == 2498 then
				fn14()
			end

			n7 = (953605 * n7 + 245430335) % 268435456
			n8 = (1 * n8 + 137045048) % 268435456
			fn()
			return
		end

		v15()
		n8 = (1 * n8 + 73297074) % 268435456
		n7 = (759937 * n7 + 27090035) % 268435456
	end

	fn2 = function(arg)
		if arg ~= 19998 then
			if arg ~= 19997 then
				if arg == 15160 then
					fn12(arg)
				end
			else
				fn12(arg)
			end

			fn2(arg + 1)

			if arg == 19997 then
				if not v14(v15, v17) then
					n8 = n8 - n8 % 2 + 1
					n7 = (291921 * n7 + 170570531) % 268435456
					return
				end

				fn14()

				if not v13(v15) then
					n8 = n8 - n8 % 2 + 1
					n7 = (900221 * n7 + 194311053) % 268435456
					n7 = (724101 * n7 + 264337315) % 268435456
					return
				end

				if v14(fn15, fn) then
					n8 = n8 - n8 % 2 + 1
					n7 = (47623 * n7 + 169714691) % 268435456
					return
				end

				v16()

				if flag then
					n8 = n8 - n8 % 2 + 1
					n7 = (510665 * n7 + 232463191) % 268435456
					n7 = (733401 * n7 + 201407789) % 268435456
					return
				end

				n7 = (54393 * n7 + 228145221) % 268435456
				n8 = (1 * n8 + 211253034) % 268435456
			end

			n7 = (202903 * n7 + 194631791) % 268435456
			n8 = (1 * n8 + 228626242) % 268435456
			return
		end

		v15()
		n8 = (1 * n8 + 73297074) % 268435456
		n7 = (148661 * n7 + 159904179) % 268435456
	end

	coroutine.resume(coroutine.create(fn2), 1)
	ScreenGui:Destroy()
	fn5(n7, 4)
	fn5(n8, 4)
	v11 = n
	n4 = 1434398056
	local n12 = 1200127852

	local v18 = coroutine.wrap(function()
		coroutine.yield(n4)
		coroutine.yield(n12)
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end)

	if fn8(v18(), n4) then
		fn4(307116577, 136)
		n = v11
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(v18(), n12) then
		fn4(n3 - 3987850719, 1)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local thread = coroutine.create(wait)
	coroutine.resume(thread, 0)
	local thread2 = coroutine.status(thread)
	fn8("suspended", thread2)

	if not nil then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	pcall(coroutine.close, thread)
	local v19 = nil
	local flag2 = false

	spawn(function()
		v19 = coroutine.running()
		wait(0)
		flag2 = true
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end)

	local flag3 = not pcall(coroutine.close, v19)

	if not nil then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local close = coroutine.close
	local n13 = n10 + 1047146723

	local function fn16()
		coroutine.yield()
		fn5(456943662, 4)
		n = 171627653

		if nil then
			n13 = bit32.bxor(n13, 4191781949)
		end

		fn6()
	end

	n13 = 160831302
	local v20 = spawn(fn16)
	close(v20)
	local close2 = coroutine.close
	local v21 = defer(fn7)
	close2(v21)
	local close3 = coroutine.close
	local v22 = delay(597, fn7)
	close3(v22)

	fn11 = function()
	end

	fn11(getfenv, -4751)
	local n102 = bit32.bor(n10, n2)
	fn11(setfenv, -17611)
	fn11(getmetatable)
	fn11(setmetatable)
	fn11(tonumber)
	fn11(tostring)
	fn11(rawset)
	fn11(rawget)
	fn11(assert)
	fn11(type)
	fn11(next)
	fn11(typeof)
	fn11(string.gmatch)
	fn11(string.format)
	fn11(string.match)
	fn11(string.find)
	fn11(string.byte)
	fn11(string.gsub)
	fn11(string.sub)
	fn11(string.rep)
	fn11(string.char, nil)
	fn11(string.unpack)
	fn11(string.pack)
	fn11(table.concat)
	fn11(table.insert)
	fn11(table.clear)
	fn11(table.create, nil)
	fn11(table.move)
	fn11(bit32.bor, nil)
	fn11(bit32.bxor, nil)
	fn11(bit32.band, nil)
	fn11(bit32.bnot)
	fn11(bit32.lshift)
	fn11(bit32.rshift)
	fn11(bit32.rrotate)
	fn11(bit32.lrotate)
	fn11(bit32.countlz)
	fn11(bit32.countrz)
	local n14 = n102 - 507532962
	fn11(buffer.len)
	fn11(buffer.fill)
	fn11(buffer.copy)
	fn11(buffer.create, nil)
	fn11(buffer.tostring)
	fn11(buffer.fromstring)
	fn11(buffer.readstring)
	fn11(buffer.writestring)
	fn11(buffer.readi8)
	fn11(buffer.readu8)
	fn11(buffer.readi16)
	fn11(buffer.readu16)
	fn11(buffer.readi32)
	fn11(buffer.readu32)
	fn11(buffer.readf32)
	fn11(buffer.readf64)
	fn11(buffer.writei8)
	fn11(buffer.writeu8)
	fn11(buffer.writei16)
	fn11(buffer.writeu16)
	fn11(buffer.writei32)
	fn11(buffer.writeu32)
	fn11(buffer.writef32)
	fn11(buffer.writef64)
	fn11(buffer.readbits)
	fn11(buffer.writebits)
	fn11(coroutine.create)
	fn11(coroutine.status)
	fn11(coroutine.close)
	fn11(coroutine.resume)
	fn11(coroutine.wrap)
	fn11(cancel)
	fn11(spawn)
	fn11(defer)
	fn11(delay)
	fn11(wait, {})
	fn11(unpack)
	fn11(info)
	fn11(v7)
	fn10(new, "new")
	local n15 = n3 // 507532962 + n14
	fn11(new, nil)
	fn10(new2, "new")
	fn10(new3, "new")
	fn10(color3New, "new")
	fn10(rectNew, "new")
	local fromAxis = v3.FromAxis
	fn10(fromAxis, "FromAxis")
	fn11(fromAxis, nil)
	local vector_ = fromAxis(Enum.Axis.Z)
	local top = v3.FromNormalId(Enum.NormalId.Top)
	local kind = type(vector_)
	local kind2 = type(top)
	fn4(307116577, kind == "vector" and 78 or 144)
	fn4(n14 + 1546621156, kind2 == "vector" and 119 or 67)
	local n16 = n14 // 8
	local y = top.Y
	fn5(vector_.Z * 748214110, 4)
	fn5(y * 1 * 1986920315, 4)

	if fn8("vector", kind) then
		fn4(n15 - 2748346140, 217)
		n = v11
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8("vector", kind2) then
		fn4(307116577, 249)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	fn4(n16 - 74816262, vector_.X == 0 and 63 or 43)
	fn4(n15 - 2748346140, vector_.Y == 0 and 206 or 19)
	fn4(307116577, vector_.Z == 1 and 141 or 135)
	local flag4 = top.X == 0
	local n152 = bit32.rshift(n15, 30)
	fn4(n16 + 4220151034, flag4 and 53 or 168)
	fn4(307116577, top.Y == 1 and 127 or 185)
	fn4(307116577, top.Z == 0 and 241 or 53)
	fn10(uDim2New, "new")
	fn10(uDimNew, "new")
	v10(262099113, utf8, { [3126701751] = 1755716539, [3490318704] = 1309779841, [621048963] = 2119685066 })
	tbl3 = { utf8.nfcnormalize("븼쟣쇻쁵Á댤멛"):byte(1, -1) }
	tbl4 = { utf8.nfdnormalize("밗힐죻묭끍뤈"):byte(1, -1) }
	local v23 = tbl4[33]
	fn4(n16 + 4220151034, v23)
	fn4(307116577, tbl3[18])
	local v24 = tbl3[9]
	local n162 = bit32.bor(n16, v23)
	fn4(307116577, v24)
	local v25 = tbl4[26]
	fn4(307116577, v25)
	local v26 = tbl4[35]
	fn4(307116577, v26)
	fn4(307116577, tbl3[20])
	fn4(n162 + 4220150898, tbl3[12])
	v12 = tbl4[54]
	fn4(307116577, v12)
	fn4(307116577, tbl4[7])
	fn4(307116577, tbl3[2])
	fn4(n152 + 307116575, tbl4[5])
	fn4(307116577, tbl3[14])
	fn4(n162 + 4220150898, tbl4[36])
	fn4(n152 - 3987850721, tbl4[45])
	fn4(307116577, tbl4[30])
	fn4(n162 + 4220150898, tbl4[12])
	fn4(n152 + 307116575, tbl4[11])
	fn4(307116577, tbl4[52])
	fn4(307116577, tbl4[19])
	fn4(n152 - 3987850721, tbl4[21])
	fn4(307116577, tbl3[1])
	local n17 = n152 // v24
	fn4(n162 - 74816398, tbl4[1])
	fn4(n17 - 3987850719, tbl3[17])
	fn4(307116577, tbl4[32])
	fn4(n162 + 4220150898, tbl4[3])
	fn4(n17 - 3987850719, tbl4[9])
	fn4(307116577, tbl4[16])
	fn4(n162 - 74816398, tbl4[28])
	fn4(n17 - 3987850719, tbl3[15])
	fn4(307116577, tbl4[31])
	fn4(n162 + 4220150898, tbl4[6])
	fn4(n17 + 307116577, tbl3[7])
	fn4(307116577, tbl4[37])
	fn4(n162 + 4220150898, tbl3[8])
	fn4(307116577, tbl4[18])
	fn4(307116577, tbl4[50])
	fn4(307116577, tbl4[10])
	n5 = n162 + v25
	fn4(307116577, tbl4[44])
	fn4(307116577, tbl4[23])
	fn4(n5 + 4220150763, tbl3[16])
	fn4(307116577, tbl4[48])
	fn4(307116577, tbl4[46])
	fn4(307116577, tbl4[2])
	fn4(n17 + 307116577, tbl4[27])
	fn4(307116577, tbl4[39])
	fn4(307116577, tbl3[13])
	fn4(307116577, tbl4[47])
	fn4(307116577, tbl3[10])
	fn4(n5 - 74816533, tbl3[11])
	local v27 = tbl4[41]
	local n172 = bit32.bor(n17, v26)
	fn4(n172 - 3987850853, v27)
	fn4(307116577, tbl4[51])
	fn4(307116577, tbl4[15])
	fn4(307116577, tbl4[14])
	fn4(307116577, tbl3[4])
	fn4(n5 - 74816533, tbl4[38])
	fn4(307116577, tbl4[20])
	fn4(307116577, tbl3[6])
	fn4(n5 + 4220150763, tbl4[13])
	fn4(n172 - 3987850853, tbl4[42])
	fn4(307116577, tbl4[22])
	fn4(n5 - 74816533, tbl4[25])
	fn4(n172 + 307116443, tbl4[29])
	fn4(307116577, tbl4[49])
	fn4(n5 + 4220150763, tbl4[17])
	fn4(n172 - 3987850853, tbl4[34])
	fn4(307116577, tbl3[5])
	fn4(n5 - 74816533, tbl4[8])
	fn4(307116577, tbl4[43])
	fn4(307116577, tbl3[19])
	local n1722 = bit32.band(n172, v12)
	fn4(307116577, tbl3[3])
	fn4(n1722 + 307116447, tbl4[53])
end

fn4(307116577, tbl4[24])
fn4(n5 - 74816533, tbl4[40])
fn4(307116577, tbl4[4])
fn10(new4, "new")
fn11(new4, nil)
local ScreenGui
ScreenGui = new("ScreenGui")
local v13, v14, v15, v132, v16, str, tangentOnCurve, tangentOnCurve2, pack, str2
local str3, str4, scale, str5, v17, str6, v18, str7, tangentOnCurveArcLength, tangentOnCurveArcLength2

do
	local Frame = new("Frame")
	Frame.Position = uDim2New(0, 0, 0, 0)
	Frame.Size = uDim2New(0, 120, 0, 281)
	Frame.Parent = ScreenGui
	local Path2D = new("Path2D")
	Path2D.Parent = Frame
	local Path2D2 = Path2D
	local setControlPoints = Path2D2.SetControlPoints
	local tbl5 = {}
	local v19 = new4(uDim2New(0, -4, 0, -4), uDim2New(0, 0, 0, 0), uDim2New(0, 0, 0, 0))
	local v20 = new4(uDim2New(0, 8, 0.5, 4), uDim2New(0, -4, 0.0625, -8), uDim2New(0, 0, 0, 0))
	local v21 = uDim2New(0, -8, 0, 9)
	v13 = uDim2New(0, -6, 0, -3)
	local v22 = table.pack(uDim2New(0.125, 3, 0, -2))
	v14 = table.pack(table.unpack(v22, 1, v22.n))
	v15 = v21
	v132 = v13
	v16 = new4(v15, v132, table.unpack(v22, 1, v22.n))
	local v23 = uDim2New(0.25, 1, 0.375, -7)
	local v24 = uDim2New(0, -4, 0, 6)
	tbl5[1] = v19
	tbl5[2] = v20
	tbl5[3] = v16

	do
		local values = table.pack(new4(v23, v24, uDim2New(0, -5, 0, 6)))
		table.move(values, 1, values.n, 4, tbl5)
	end

	setControlPoints(Path2D2, tbl5)
	local unpack_ = string.unpack
	local length = Path2D2:GetLength()
	fn5(unpack_(">I4", string.pack(">f", length)), 4)
	local positionOnCurve = Path2D2:GetPositionOnCurve(0.60000002384185791)
	fn5(string.unpack("<I4", string.pack("<f", positionOnCurve.X.Scale)), 4)
	fn5(string.unpack("<I4", string.pack(">f", positionOnCurve.Y.Scale)), 4)
	local positionOnCurve2 = Path2D2:GetPositionOnCurve(0.60000002384185791)
	fn5(string.unpack("<I4", string.pack(">f", positionOnCurve2.X.Scale)), 4)
	fn5(string.unpack("<I4", string.pack(">f", positionOnCurve2.Y.Scale)), 4)
	local positionOnCurve3 = Path2D2:GetPositionOnCurve(0.071428574621677399)
	local scale2 = positionOnCurve3.X.Scale
	str = ">I4"
	fn5(string.unpack(str, string.pack("<f", scale2)), 4)
	fn5(string.unpack(">I4", string.pack("<f", positionOnCurve3.Y.Scale)), 4)
	tangentOnCurve = Path2D2:GetTangentOnCurve(0.91666668653488159)
	fn5(string.unpack(">I4", string.pack("<f", tangentOnCurve.X)), 4)
	fn5(string.unpack("<I4", string.pack(">f", tangentOnCurve.Y)), 4)
	tangentOnCurve2 = Path2D2:GetTangentOnCurve(0.8571428656578064)
	fn5(string.unpack(">I4", string.pack("<f", tangentOnCurve2.X)), 4)
	fn5(string.unpack("<I4", string.pack("<f", tangentOnCurve2.Y)), 4)
	local tangentOnCurve3 = Path2D2:GetTangentOnCurve(0.40000000596046448)
	fn5(string.unpack(">I4", string.pack("<f", tangentOnCurve3.X)), 4)
	fn5(string.unpack("<I4", string.pack("<f", tangentOnCurve3.Y)), 4)
	local tangentOnCurve4 = Path2D2:GetTangentOnCurve(0.57142859697341919)
	fn5(string.unpack("<I4", string.pack("<f", tangentOnCurve4.X)), 4)
	fn5(string.unpack("<I4", string.pack(">f", tangentOnCurve4.Y)), 4)
	local positionOnCurveArcLength = Path2D2:GetPositionOnCurveArcLength(0.72727274894714355)
	pack = string.pack
	str2 = "<I4"
	str3 = ">f"
	str4 = "X"
	fn5(string.unpack(str2, pack(str3, positionOnCurveArcLength[str4].Scale)), 4)
	local unpack_2 = string.unpack
	scale = positionOnCurveArcLength.Y.Scale
	str5 = "<f"
	local str52 = table.pack(string.pack(str5, scale))
	v17 = table.pack(table.unpack(str52, 1, str52.n))
	str6 = ">I4"
	v18 = unpack_2(str6, table.unpack(str52, 1, str52.n))
	fn5(v18, 4)
	local positionOnCurveArcLength2 = Path2D2:GetPositionOnCurveArcLength(0.125)
	str7 = "<I4"
	fn5(string.unpack(str7, string.pack(">f", positionOnCurveArcLength2.X.Scale)), 4)
	fn5(string.unpack(">I4", string.pack(">f", positionOnCurveArcLength2.Y.Scale)), 4)
	tangentOnCurveArcLength = Path2D2:GetTangentOnCurveArcLength(0.75)
	fn5(string.unpack(">I4", string.pack("<f", tangentOnCurveArcLength.X)), 4)
	fn5(string.unpack(">I4", string.pack("<f", tangentOnCurveArcLength.Y)), 4)
	local tangentOnCurveArcLength3 = Path2D2:GetTangentOnCurveArcLength(0.5)
	fn5(string.unpack(">I4", string.pack("<f", tangentOnCurveArcLength3.X)), 4)
	fn5(string.unpack("<I4", string.pack("<f", tangentOnCurveArcLength3.Y)), 4)
	tangentOnCurveArcLength2 = Path2D2:GetTangentOnCurveArcLength(0.25)
end

fn5(string.unpack(">I4", string.pack("<f", tangentOnCurveArcLength2.X)), 4)
local y, str8, v19, str9, v20
local unpack_ = string.unpack
y = tangentOnCurveArcLength2.Y
str8 = "<f"
local str82 = table.pack(string.pack(str8, y))
v19 = table.pack(table.unpack(str82, 1, str82.n))
str9 = ">I4"
v20 = unpack_(str9, table.unpack(str82, 1, str82.n))
fn5(v20, 4)
ScreenGui:Destroy()
v10(262099113, math, { [510047976] = 835598790, [2311580660] = 763848409, [517487174] = 726102453 })

v10(262099113, v8, {
	[1492661237] = 1334382860,
	[857044906] = 1521163950,
	[2916448461] = 1942674721,
	[2890385369] = 1654405110,
	[130662262] = 15061270,
})

v10(262099113, v2, { [1179862435] = 1528520637, [4145862070] = 852769769 })
local ok, v21, v22, str10, n6, v23

do
	local gameRef = game
	local workspaceRef = workspace

	local function fn12(arg, arg2, arg3)
		local n7 = 4137930313
		local kind = type(arg)
		fn8("userdata", kind)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
			arg3 = arg3 + n7 + 157036983
		end

		local kind2 = typeof(arg)
		fn8("Instance", kind2)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		local parent = arg.Parent
		local parent2 = arg.Parent

		if tbl2[not parent] then
			fn8(parent, parent2)

			if not nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
			end
		end

		local name = arg.Name
		local name2 = arg.Name
		local kind3 = type(name)
		fn8("string", kind3)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		fn8(name, name2)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		fn8(#name, #name2)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		fn8(tostring(arg), name)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		local fn82 = fn8
		fn82(arg2, arg.ClassName)
		local fn822

		if nil then
			fn822 = fn82
		else
			fn822 = fn82
			fn5(456943662, 4)
			local n72 = table.pack(bit32.band(n7, 4294967295))
			local arg32 = table.pack(bit32.band(arg3, 4294967295))
			local v24 = table.pack(bit32.band(n72[1], 65535))
			local v25 = table.pack(bit32.rshift(n72[1], 16))
			local v26 = table.pack(bit32.band(arg32[1], 65535))
			local v27 = bit32.band(v24[1] * v26[1] + bit32.lshift(bit32.band(v24[1] * bit32.rshift(arg32[1], 16) + v25[1] * v26[1], 65535), 16), 4294967295)
			n = 171627653
			fn6()
			n7 = v27 + 2636276106
		end

		local changed = arg.Changed
		local changed2 = arg.Changed
		fn8(changed, changed2)

		if nil then
			repeat
				(nil)[87] = nil
				;(nil)[88] = nil
				;(nil)[89] = nil
				;(nil)[90] = nil
				;(nil)[91] = nil
				;(nil)[92] = nil
				;(nil)[93] = nil
				;(nil)[94] = nil
				;(nil)[95] = nil
				;(nil)[96] = nil
				table.move(nil, 1, (nil).n, 97, nil)
				upv40 = nil
			until nil
		else
			if not nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
			end

			local connect = changed.Connect
			local connect2 = changed.Connect
			fn10(connect, "Connect")
			fn10(connect2, "Connect")
			fn8(connect, connect2)

			if nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
			end

			local flag = false
			local descendantAdded = arg.DescendantAdded
			local descendantAdded2 = descendantAdded
			local connect3 = descendantAdded.Connect
			local n8 = 246972397

			local function fn13()
				flag = true

				if nil then
					n8 = bit32.bxor(n8, 933768639)
				end
			end

			n8 = 380591252
			local v24 = connect3(descendantAdded2, fn13)

			if nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
				arg3 = arg3 + n7 + 157036983
			else
			end

			if not nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
			end

			local disconnect = v24.Disconnect
			fn10(disconnect, "Disconnect")
			fn11(disconnect, nil)
			disconnect(v24)
			local v25, flag2

			if nil then
				fn5(456943662, 4)
				fn6()
				local wait2 = changed.Wait
				fn10(wait2, "Wait")
				local n9 = 143544833

				local function fn14()
					local wait3 = wait2

					if nil then
						n9 = bit32.bxor(n9, 2697729367)
					end

					return (wait3(changed))
				end

				n9 = 325708453
				fn822 = coroutine.create(fn14)
				local thread
				thread, v25 = coroutine.resume(fn822)
				local v26 = tbl2[not thread]
				flag2 = not v26

				if v26 then
					changed2 = tbl2[not v25]
				else
					changed2 = flag2
				end
			else
				local wait2 = changed.Wait
				fn10(wait2, "Wait")
				local n9 = 143544833

				local function fn14()
					local wait3 = wait2

					if nil then
						n9 = bit32.bxor(n9, 2697729367)
					end

					return (wait3(changed))
				end

				n9 = 325708453
				fn822 = coroutine.create(fn14)
				local thread
				thread, v25 = coroutine.resume(fn822)
				local v26 = tbl2[not thread]
				flag2 = not v26

				if v26 then
					changed2 = tbl2[not v25]
				else
					changed2 = flag2
				end
			end

			if not changed2 then
				local thread = coroutine.status(fn822)
				changed2 = not fn8("suspended", thread)
			end
		end

		if changed2 then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		local ok2, result = pcall(coroutine.close, fn822)
		local v24 = tbl2[not ok2]
		local flag = not v24
		local flag2

		if v24 then
			flag2 = not tbl2[not result]
		else
			flag2 = flag
		end

		if not flag2 then
			local thread = coroutine.status(fn822)
			flag2 = not fn8("dead", thread)
		end

		if flag2 then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		local v25 = getmetatable(arg)
		fn8("The metatable is locked", v25)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end
	end

	fn12(gameRef, "DataModel", 303268551)
	fn12(workspaceRef, "Workspace", 303268551)

	if fn8(gameRef, workspaceRef.Parent) then
		fn4(307116577, 206)
		n = v11
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local Folder = new("Folder")
	fn12(Folder, "Folder", 303268551)
	local result
	ok, result = pcall(Folder.FindFirstChildWhichIsA, UDim.new(0.49088859558105469, 938), 1370449436)
	local flag = not ok

	if not tbl2[flag] then
		fn5(fn9(result), 4)
	end

	local v24 = n

	if tbl2[flag] then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	else
		fn4(307116577, 176)
		n = v24
	end

	local children
	children, v21, v22 = Folder:GetChildren()

	for k in children, v21, v22 do
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	Folder:Destroy()
	local v25 = n
	local Folder2 = Folder
	local Folder3 = new("Folder", Folder2)
	fn12(Folder3, "Folder", 303268551)
	local v252

	if fn8(Folder2, Folder3.Parent) then
		v252 = v25
		fn4(307116577, 35)
		n = v252
	else
		v252 = v25
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(Folder3.Parent, Folder3.Parent) then
		fn4(307116577, 28)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local waitForChild = Folder2.WaitForChild
	fn10(waitForChild, "WaitForChild")
	fn11(waitForChild, nil)
	local name = tostring(1305259675)
	Folder3.Name = name
	local v26 = waitForChild(Folder2, name)

	if fn8(Folder3, v26) then
		fn4(307116577, 71)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	Folder2:Destroy()
	Folder3:Destroy()

	if tbl2[not Folder3.Parent] then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	else
		fn4(307116577, 195)
	end

	if tbl2[not pcall(function()
		Folder3.Parent = Folder2
	end)] then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	else
		fn4(307116577, 17)
	end

	n = v252
	local HttpService = gameRef:GetService("HttpService")
	fn12(HttpService, "HttpService", 303268551)
	local v253 = n
	local v2532

	if fn8(gameRef, HttpService.Parent) then
		fn4(307116577, 188)
		n = v253
		v2532 = v253
	else
		v2532 = v253
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if not v6 then
		fn10(HttpService.GetAsync, "GetAsync")
		fn10(HttpService.PostAsync, "PostAsync")
		fn10(HttpService.RequestAsync, "RequestAsync")
	end

	local RunService = gameRef:GetService("RunService")
	str10 = "RunService"
	n6 = 303268551
	v23 = fn12
	v23(RunService, str10, n6)

	if fn8(gameRef, RunService.Parent) then
		fn4(307116577, 162)
		n = v2532
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	fn10(RunService.IsStudio, "IsStudio")
	fn10(RunService.IsClient, "IsClient")
	fn10(RunService.IsServer, "IsServer")
	fn11(RunService.IsStudio)
	fn11(RunService.IsClient)
	fn11(RunService.IsServer)
	RunService:IsServer()

	if nil then
		local StarterPlayer = gameRef:GetService("StarterPlayer")
		fn12(StarterPlayer, "StarterPlayer", 303268551)
		fn8(gameRef, StarterPlayer.Parent)
		local StarterPlayer2

		if nil then
			StarterPlayer2 = StarterPlayer
		else
			StarterPlayer2 = StarterPlayer
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		for k in StarterPlayer2:GetChildren() do
		end

		if nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end
	end

	if tbl2[not pcall(gameRef.GetChildren)] then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	else
		fn4(307116577, 108)
		n = v2532
	end
end

local v253

do
	local v24 = Enum
	local v2532 = n

	if fn8(type(v24), "userdata") then
		fn4(307116577, 70)
		n = v2532
		v253 = v2532
	else
		v253 = v2532
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(typeof(v24), "Enums") then
		fn4(307116577, 225)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local v25 = getmetatable(v24)

	if fn8("The metatable is locked", v25) then
		fn4(307116577, 242)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local x = v24.Axis.X

	if fn8(type(x), "userdata") then
		fn4(307116577, 36)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(typeof(x), "EnumItem") then
		fn4(307116577, 103)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local v26 = getmetatable(x)

	if fn8("The metatable is locked", v26) then
		fn4(307116577, 158)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	fn10(x.IsA, "IsA")
	fn11(x.IsA)
	local name = x.Name
	local value = x.Value

	if fn8(type(name), "string") then
		fn4(307116577, 130)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(type(value), "number") then
		fn4(307116577, 4)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local enumType = x.EnumType

	if fn8(x, enumType[name]) then
		fn4(307116577, 57)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(type(enumType), "userdata") then
		fn4(307116577, 83)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(typeof(enumType), "Enum") then
		fn4(307116577, 85)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local v27 = getmetatable(enumType)

	if fn8("The metatable is locked", v27) then
		fn4(307116577, 166)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	fn10(enumType.FromName, "FromName")
	fn10(enumType.FromValue, "FromValue")
	fn11(enumType.FromName)
	fn11(enumType.FromValue)
	local v28 = enumType:FromName(name)

	if fn8(x, v28) then
		fn4(307116577, 73)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local v29 = enumType:FromValue(value)

	if fn8(x, v29) then
		fn4(307116577, 238)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end
end

local randNum, str11, v24, str12, v25

do
	local new5 = v5.new
	fn10(new5, "new")
	fn11(new5, {})
	local v26 = new5(768717884)

	if fn8(type(v26), "userdata") then
		fn4(307116577, 182)
		n = v253
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(typeof(v26), "Random") then
		fn4(307116577, 80)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	fn10(v26.NextUnitVector, "NextUnitVector")
	fn10(v26.NextInteger, "NextInteger")
	fn10(v26.NextNumber, "NextNumber")
	fn10(v26.Shuffle, "Shuffle")
	fn10(v26.Clone, "Clone")
	local v27 = new5(1136604554)
	local clone = v27:Clone()
	fn5(clone:NextInteger(624, 1492), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local randNum2 = clone:NextNumber()
	fn5(unpack_2("<I4", pack2(">f", randNum2)), 4)
	fn5(v27:NextInteger(999, 1857), 4)
	fn5(v27:NextInteger(903, 1418), 4)
	local unpack_3 = string.unpack
	local pack3 = string.pack
	local randNum3 = v27:NextNumber()
	fn5(unpack_3(">I4", pack3("<f", randNum3)), 4)
	local clone2 = v27:Clone()
	fn5(v27:NextInteger(105, 321), 4)
	local unpack_4 = string.unpack
	local pack4 = string.pack
	local randNum4 = v27:NextNumber()
	fn5(unpack_4(">I4", pack4(">f", randNum4)), 4)
	fn5(v27:NextInteger(478, 776), 4)
	fn5(clone:NextInteger(174, 532), 4)
	v27:Clone()
	local unpack_5 = string.unpack
	local pack5 = string.pack
	local randNum5 = clone2:NextNumber()
	fn5(unpack_5(">I4", pack5("<f", randNum5)), 4)
	fn5(clone2:NextInteger(916, 964), 4)
	local pack6 = string.pack
	local unpack_6 = string.unpack
	local randNum6 = clone2:NextNumber()
	fn5(unpack_6(">I4", pack6(">f", randNum6)), 4)
	fn5(v27:NextInteger(639, 940), 4)
	local unpack_7 = string.unpack
	local pack7 = string.pack
	randNum = clone:NextNumber()
	str11 = "<f"
	local v28 = table.pack(pack7(str11, randNum))
	v24 = table.pack(table.unpack(v28, 1, v28.n))
	str12 = "<I4"
	v25 = unpack_7(str12, table.unpack(v28, 1, v28.n))
end

fn5(v25, 4)
local fn12, str13, n7, str14, v26

do
	local n8 = 760

	local tbl5 = {
		[2226764994] = n8,
		[318881598] = n8,
		[3661544162] = n8,
		[3363902840] = 190,
		[15773086] = 190,
		[3558624798] = n8,
		[965660307] = 190,
		[1746512772] = n8,
		[2332938498] = n8,
		[2289605458] = 190,
		[629038113] = 190,
		[3729791560] = 190,
		[3313596611] = 190,
		[3138776128] = n8,
		[3670711691] = n8,
		[955660156] = n8,
		[2988606481] = n8,
		[1945320383] = n8,
		[2169862192] = n8,
		[3464586182] = 190,
		[389227230] = 380,
		[1503549990] = 380,
		[4286907162] = 190,
		[738622680] = n8,
		[2324471796] = n8,
		[4223744198] = 190,
		[824648386] = n8,
		[982880222] = n8,
		[2890582669] = 190,
		[1617778996] = n8,
		[1969363489] = 190,
		[2055326994] = n8,
	}

	local env = getfenv()
	local envMap = {}
	local tbl6 = {}
	local n9 = 0
	local tbl7 = { nil, v, 1, 3, 0 }

	while true do
		local v27 = tbl7[3]
		local v28 = tbl7[4]
		local n10 = tbl7[5] + v27
		tbl7[5] = n10

		if n10 <= v28 then
			if not nil and not nil then
				envMap[env] = true
				v132 = nil
				v23 = nil
				local n11 = 0

				for k in env, v132, v23 do
					n11 += 1
					local kind = type(k)

					if fn8("string", kind) then
						if #k < 20 then
							local v29 = fn9(k)

							if tbl6[v29] then
								if not (n11 > 50) then
									continue
								end
							else
								n9 += tbl5[v29] or 0
								tbl6[v29] = true
								if not (n11 > 50) then
									continue
								end
							end
						elseif not (n11 > 50) then
							continue
						end
					elseif not (n11 > 50) then
						continue
					end

					break
				end

				local n92 = n9
				local v29 = getmetatable(env)
				local flag = type(v29) == "table"
				local n922, value

				if flag then
					n922 = n92
					value = rawget(v29, "__index")
				else
					n922 = n92
					value = flag
				end

				if value then
					local n923 = n922
					env = value
					n9 = n923
					continue
				end

				n9 = n922
				env = nil
				continue
			end

			break
		else
			break
		end
	end

	local v27 = tbl7[2]
	fn4(307116577, n9 < n8 and 243 or 42)

	if nil then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local ok2, result = pcall(assert, false)

	if ok2 or not result or type(result) ~= "string" then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	local ok3, result2 = pcall(function(R, ...)
	(...)[...] = nil
end)

	local ok4, result3 = pcall(function(R, ...)
	return (...)[...]
end)

	local ok5, result4 = pcall(function(R, ...)
	return (...)()
end)

	if ok3 or ok4 or ok5 then
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	fn12 = function(arg, arg2, arg3)
		local n10 = 1310134650
		local exitTo26 = nil
		local pos, n11, exitTo13, exitTo10, exitTo9, v28, exitTo6, v29, exitTo, exitTo2, exitTo24, exitTo21, exitTo20, exitTo18, exitTo16, exitTo14, exitTo39, exitTo36, exitTo35, exitTo32, exitTo27, exitTo28, exitTo50, exitTo47, exitTo46, exitTo44, exitTo42, exitTo40

		while true do
			local match
			pos, n11, match = string.find(arg, "[%:]([0-9]+)[^%a%A]*[%:\r\n]")
			local flag = not pos
			local fn52, match2, match3, v30, fn53, n12, v31, tbl8, v32, v33, n13, flag2, flag3, flag4, flag5, n14, gsub, n15, fn13, n16, v34, v35, fn54, n17, fn62

			if not pos then
				fn52 = flag
				exitTo13 = nil

				while true do
					if not fn52 then
						local exitTo12 = nil

						while true do
							fn5(pos, 2)
							fn5(n11, 2)
							match2 = string.match(arg, ":[^%u%U]?(%d+)[^%x%X]?[\n:\r]")
							fn52 = fn5

							if match then
								match3 = match2
							else
								match = match2
								match3 = match
								match = 0
							end

							local exitTo11 = nil

							while true do
								fn52(match + 0, 2)
								match = fn5
								match3 = match3 or 0
								exitTo10 = nil

								while true do
									match(match3 + 0, 2)
									v30 = string.gmatch(arg, "%:[^%s%S]-([0-9]+)[%:\n\r]")
									match = v30()
									fn8(v30(), nil)

									if not nil then
										fn5(456943662, 4)
										n = 171627653
										fn6()
									end

									exitTo9 = nil

									while true do
										fn53 = fn5

										if match then
											fn52 = fn53
										else
											match = fn53
											fn52 = match
											match = 0
										end

										local exitTo8 = nil

										while true do
											fn52(match + 0, 2)
											n10 = bit32.band(n10, 2532609332)
											match = string.sub(arg, pos + 1, n11 - 1)
											fn52 = string.char(string.byte(arg, pos + 1, n11 - 1))
											match3 = string.byte
											n12 = 1
											local exitTo7 = nil

											while true do
												v31 = match3(arg, pos + n12, pos + 1)
												fn5(match + 0, 2)
												fn5(fn52 + 0, 2)
												fn4(307116577, v31)
												tbl8 = { nil, pos + 1 - 1, 1, n11 - 1 + 0, v28 }
												pos = 0
												v28 = tbl8
												exitTo6 = nil

												while true do
													v32 = v28[3]
													v33 = v28[4]
													n13 = v28[2] + v32
													flag2 = v32 <= 0
													flag3 = not flag2
													flag4 = n13 >= v33
													flag5 = n13 <= v33

													if flag2 then
														if flag3 then
															flag4 = flag4 or flag5
														else
															flag5 = flag3
															flag4 = flag4 or flag5
														end
													else
														flag4 = flag2

														if flag3 then
															flag4 = flag4 or flag5
														else
															flag5 = flag3
															flag4 = flag4 or flag5
														end
													end

													v28[2] = n13

													if flag4 then
														n11 = n13
														pos = pos * 10 + string.byte(arg, n11, n11) - 48
														continue
													end

													local exitTo5 = nil

													while true do
														v28 = v28[5]
														fn5(pos, 2)
														v29 = nil
														n14 = 0
														gsub = string.gsub
														n15 = n10 - 4130248912

														fn13 = function(arg4)
															v29 = arg4
															local n18 = n14 + 1

															if nil then
																n15 = bit32.bxor(n15, 2158233785)
															end

															n14 = n18
														end

														n16 = 118666967
														local exitTo4 = nil

														while true do
															n15 = n16
															v34, v35 = gsub(arg, "%:[^%x%X]*([0-9]+)[^%d%D]?[\r\n%:]", fn13, 1)
															pos = v35
															fn8(n14, 1)

															if nil then
															else
																fn5(456943662, 4)
																n = 171627653
																fn6()
															end

															exitTo = nil
															local exitTo3 = nil

															while true do
																fn8(pos, 1)

																if nil then
																	exitTo3 = 1
																	break
																else
																	fn54 = fn5
																	n17 = 3443272525
																	exitTo2 = nil

																	while true do
																		n10 = n17
																		fn54(456943662, 4)
																		n = 171627653
																		fn62 = fn6
																		fn6()

																		if fn62 then
																			exitTo2 = 1
																			break
																		else
																			if nil then
																				if nil <= 13 then
																					exitTo2 = 2
																					break
																				elseif nil <= 20 then
																					exitTo2 = 3
																					break
																				elseif nil <= 23 then
																					exitTo2 = 4
																					break
																				elseif nil <= 25 then
																					exitTo2 = 5
																					break
																				elseif nil <= 26 then
																					exitTo2 = 6
																					break
																				else
																					fn54 = fn5
																					n17 = 101974320
																					continue
																				end
																			end

																			break
																		end
																	end

																	if exitTo2 == 1 then
																		exitTo3 = 2
																		break
																	elseif exitTo2 == 2 then
																		exitTo3 = 3
																		break
																	elseif exitTo2 == 3 then
																		if nil <= 16 then
																			exitTo3 = 5
																			break
																		elseif nil <= 18 then
																			exitTo3 = 6
																			break
																		elseif nil <= 19 then
																			continue
																		else
																			exitTo3 = 1
																			break
																		end
																	elseif exitTo2 == 4 then
																		if nil <= 21 then
																			exitTo3 = 2
																			break
																		elseif nil <= 22 then
																			exitTo3 = 4
																			break
																		else
																			fn5(456943662, 4)
																			n = 171627653
																			fn6()
																			continue
																		end
																	end

																	break
																end
															end

															if exitTo3 == 1 then
																exitTo = 1
															elseif exitTo3 == 2 then
																exitTo = 2
															elseif exitTo3 == 3 then
																exitTo = 3
															elseif exitTo3 == 4 then
																exitTo = 6
															elseif exitTo3 == 5 then
																exitTo = 7
															elseif exitTo3 == 6 then
																exitTo = 8
															elseif exitTo2 == 5 then
																exitTo = 4
															elseif exitTo2 == 6 then
																exitTo = 5
															end

															if exitTo == 1 then
																exitTo4 = 1
																break
															elseif exitTo == 2 then
																exitTo4 = 2
																break
															elseif exitTo == 3 then
																if nil <= 6 then
																	exitTo4 = 3
																	break
																elseif nil <= 9 then
																	if nil <= 7 then
																		exitTo4 = 5
																		break
																	elseif nil <= 8 then
																		exitTo4 = 6
																		break
																	else
																		fn5(pos, 2)
																		v29 = nil
																		n14 = 0
																		gsub = string.gsub
																		n15 = n10 - 4130248912

																		fn13 = function(arg4)
																			v29 = arg4
																			local n18 = n14 + 1

																			if nil then
																				n15 = bit32.bxor(n15, 2158233785)
																			end

																			n14 = n18
																		end

																		n16 = 3757722826
																		continue
																	end
																else
																	exitTo4 = 4
																	break
																end
															end

															break
														end

														if exitTo4 == 1 then
															exitTo5 = 1
															break
														elseif exitTo4 == 2 then
															exitTo5 = 2
															break
														elseif exitTo4 == 3 then
															exitTo5 = 3
															break
														elseif exitTo4 == 4 then
															exitTo5 = 4
															break
														elseif exitTo4 == 5 then
															exitTo5 = 5
															break
														elseif exitTo4 == 6 then
															exitTo5 = 6
															break
														elseif exitTo == 4 then
															exitTo5 = 7
															break
														elseif exitTo == 5 then
															continue
														end

														break
													end

													if exitTo5 == 1 then
														exitTo6 = 1
														break
													elseif exitTo5 == 2 then
														exitTo6 = 2
														break
													elseif exitTo5 == 3 then
														exitTo6 = 3
														break
													elseif exitTo5 == 4 then
														if nil <= 11 then
															exitTo6 = 11
															break
														elseif not (nil <= 12) then
															continue
														end
													elseif exitTo5 == 5 then
														exitTo6 = 4
														break
													elseif exitTo5 == 6 then
														exitTo6 = 5
														break
													elseif exitTo5 == 7 then
														exitTo6 = 6
														break
													elseif exitTo == 6 then
														exitTo6 = 7
														break
													elseif exitTo == 7 then
														exitTo6 = 8
														break
													elseif exitTo == 8 then
														if nil <= 17 then
															exitTo6 = 10
															break
														else
															pos = pos * 10 + string.byte(arg, n11, n11) - 48
															continue
														end
													else
														exitTo6 = 9
														break
													end

													break
												end

												if exitTo6 == 1 then
													exitTo7 = 1
													break
												elseif exitTo6 == 2 then
													exitTo7 = 2
													break
												elseif exitTo6 == 3 then
													if nil <= 2 then
														if nil <= 0 then
															exitTo7 = 4
															break
														elseif nil <= 1 then
															continue
														else
															exitTo7 = 5
															break
														end
													else
														exitTo7 = 3
														break
													end
												end

												break
											end

											if exitTo7 == 1 then
												exitTo8 = 1
												break
											elseif exitTo7 == 2 then
												exitTo8 = 2
												break
											elseif exitTo7 == 3 then
												exitTo8 = 3
												break
											elseif exitTo7 == 4 then
												exitTo8 = 4
												break
											elseif exitTo7 == 5 then
												exitTo8 = 5
												break
											elseif exitTo6 == 4 then
												exitTo8 = 6
												break
											elseif exitTo6 == 5 then
												fn52 = match
												match = 0
												continue
											elseif exitTo6 == 6 then
												exitTo8 = 7
												break
											elseif exitTo6 == 7 then
												exitTo8 = 8
												break
											elseif exitTo6 == 8 then
												if nil <= 14 then
													exitTo8 = 9
													break
												elseif nil <= 15 then
													exitTo8 = 10
													break
												else
													continue
												end
											end

											break
										end

										if exitTo8 == 1 then
											exitTo9 = 1
											break
										elseif exitTo8 == 2 then
											exitTo9 = 2
											break
										elseif exitTo8 == 3 then
											if nil <= 4 then
												exitTo9 = 13
												break
											elseif nil <= 5 then
												exitTo9 = 14
												break
											else
												continue
											end
										elseif exitTo8 == 4 then
											exitTo9 = 3
											break
										elseif exitTo8 == 5 then
											exitTo9 = 4
											break
										elseif exitTo8 == 6 then
											exitTo9 = 5
											break
										elseif exitTo8 == 7 then
											exitTo9 = 6
											break
										elseif exitTo8 == 8 then
											exitTo9 = 7
											break
										elseif exitTo8 == 9 then
											exitTo9 = 8
											break
										elseif exitTo8 == 10 then
											exitTo9 = 9
											break
										elseif exitTo6 == 9 then
											exitTo9 = 10
											break
										elseif exitTo6 == 10 then
											exitTo9 = 11
											break
										elseif exitTo6 == 11 then
											if nil <= 10 then
												fn5(456943662, 4)
												n = 171627653
												fn6()
												continue
											else
												exitTo9 = 12
												break
											end
										end

										break
									end

									if exitTo9 == 1 then
										exitTo10 = 1
										break
									elseif exitTo9 == 2 then
										exitTo10 = 2
										break
									elseif exitTo9 == 3 then
										exitTo10 = 3
										break
									elseif exitTo9 == 4 then
										fn52(match + 0, 2)
										match = fn5
										continue
									elseif exitTo9 == 5 then
										exitTo10 = 4
										break
									elseif exitTo9 == 6 then
										exitTo10 = 5
										break
									elseif exitTo9 == 7 then
										exitTo10 = 6
										break
									elseif exitTo9 == 8 then
										exitTo10 = 7
										break
									elseif exitTo9 == 9 then
										exitTo10 = 8
										break
									elseif exitTo9 == 10 then
										exitTo10 = 9
										break
									elseif exitTo9 == 11 then
										exitTo10 = 10
										break
									elseif exitTo9 == 12 then
										match3 = 0
										continue
									elseif exitTo9 == 13 then
										if not (nil <= 3) then
											continue
										end
									else
										exitTo10 = 11
										break
									end

									break
								end

								if exitTo10 == 1 then
									exitTo11 = 1
									break
								elseif exitTo10 == 2 then
									exitTo11 = 2
									break
								elseif exitTo10 == 3 then
									exitTo11 = 3
									break
								elseif exitTo10 == 4 then
									exitTo11 = 4
									break
								elseif exitTo10 == 5 then
									exitTo11 = 5
									break
								elseif exitTo10 == 6 then
									exitTo11 = 6
									break
								elseif exitTo10 == 7 then
									exitTo11 = 7
									break
								elseif exitTo10 == 8 then
									match3 = match
									match = 0
									continue
								end

								break
							end

							if exitTo11 == 1 then
								exitTo12 = 1
								break
							elseif exitTo11 == 2 then
								exitTo12 = 2
								break
							elseif exitTo11 == 3 then
								exitTo12 = 3
								break
							elseif exitTo11 == 4 then
								exitTo12 = 4
								break
							elseif exitTo11 == 5 then
								if nil <= 24 then
									continue
								end
							elseif exitTo11 == 6 then
								exitTo12 = 5
								break
							elseif exitTo11 == 7 then
								exitTo12 = 6
								break
							elseif exitTo10 == 9 then
								continue
							else
								exitTo12 = 7
								break
							end

							break
						end

						if exitTo12 == 1 then
							exitTo13 = 1
							break
						end

						if exitTo12 == 2 then
							exitTo13 = 2
							break
						end

						if exitTo12 == 3 then
							exitTo13 = 3
							break
						end

						if exitTo12 == 4 then
							exitTo13 = 4
							break
						end

						if exitTo12 ~= 5 then
							if exitTo12 == 6 then
								exitTo13 = 5
								break
							end

							if exitTo12 == 7 then
								exitTo13 = 6
								break
							end
							continue
						end
					end

					local exitTo25 = nil

					while true do
						fn5(456943662, 4)
						n = 171627653
						fn6()
						exitTo24 = nil

						while true do
							fn5(pos, 2)
							fn5(n11, 2)
							match2 = string.match(arg, ":[^%u%U]?(%d+)[^%x%X]?[\n:\r]")
							fn52 = fn5

							if match then
								match3 = match2
							else
								match = match2
								match3 = match
								match = 0
							end

							local exitTo23 = nil

							while true do
								fn52(match + 0, 2)
								match = fn5
								match3 = match3 or 0
								local exitTo22 = nil

								while true do
									match(match3 + 0, 2)
									v30 = string.gmatch(arg, "%:[^%s%S]-([0-9]+)[%:\n\r]")
									match = v30()
									fn8(v30(), nil)

									if not nil then
										fn5(456943662, 4)
										n = 171627653
										fn6()
									end

									exitTo21 = nil

									while true do
										fn53 = fn5

										if match then
											fn52 = fn53
										else
											match = fn53
											fn52 = match
											match = 0
										end

										exitTo20 = nil

										while true do
											fn52(match + 0, 2)
											n10 = bit32.band(n10, 2532609332)
											match = string.sub(arg, pos + 1, n11 - 1)
											fn52 = string.char(string.byte(arg, pos + 1, n11 - 1))
											match3 = string.byte
											n12 = 1
											local exitTo19 = nil

											while true do
												v31 = match3(arg, pos + n12, pos + 1)
												fn5(match + 0, 2)
												fn5(fn52 + 0, 2)
												fn4(307116577, v31)
												tbl8 = { nil, pos + 1 - 1, 1, n11 - 1 + 0, v28 }
												pos = 0
												v28 = tbl8
												exitTo18 = nil

												while true do
													v32 = v28[3]
													v33 = v28[4]
													n13 = v28[2] + v32
													flag2 = v32 <= 0
													flag3 = not flag2
													flag4 = n13 >= v33
													flag5 = n13 <= v33

													if flag2 then
														if flag3 then
															flag4 = flag4 or flag5
														else
															flag5 = flag3
															flag4 = flag4 or flag5
														end
													else
														flag4 = flag2

														if flag3 then
															flag4 = flag4 or flag5
														else
															flag5 = flag3
															flag4 = flag4 or flag5
														end
													end

													v28[2] = n13

													if flag4 then
														n11 = n13
														pos = pos * 10 + string.byte(arg, n11, n11) - 48
														continue
													end

													local exitTo17 = nil

													while true do
														v28 = v28[5]
														fn5(pos, 2)
														v29 = nil
														n14 = 0
														gsub = string.gsub
														n15 = n10 - 4130248912

														fn13 = function(arg4)
															v29 = arg4
															local n18 = n14 + 1

															if nil then
																n15 = bit32.bxor(n15, 2158233785)
															end

															n14 = n18
														end

														n16 = 118666967
														exitTo16 = nil

														while true do
															n15 = n16
															v34, v35 = gsub(arg, "%:[^%x%X]*([0-9]+)[^%d%D]?[\r\n%:]", fn13, 1)
															pos = v35
															fn8(n14, 1)

															if nil then
															else
																fn5(456943662, 4)
																n = 171627653
																fn6()
															end

															exitTo14 = nil

															while true do
																fn8(pos, 1)

																if nil then
																	exitTo14 = 1
																	break
																else
																	fn54 = fn5
																	n17 = 3443272525
																	local exitTo15 = nil

																	while true do
																		n10 = n17
																		fn54(456943662, 4)
																		n = 171627653
																		fn62 = fn6
																		fn6()

																		if fn62 then
																			exitTo15 = 1
																			break
																		else
																			if nil then
																				if nil <= 13 then
																					exitTo15 = 3
																					break
																				end

																				if nil <= 20 then
																					exitTo15 = 4
																					break
																				end

																				if nil <= 23 then
																					exitTo15 = 5
																					break
																				end

																				if nil <= 25 then
																					exitTo15 = 6
																					break
																				end

																				if nil <= 26 then
																					exitTo15 = 7
																					break
																				end
																				fn54 = fn5
																				n17 = 101974320
																				continue
																			end

																			exitTo15 = 2
																			break
																		end
																	end

																	if exitTo15 == 1 then
																		exitTo14 = 2
																		break
																	elseif exitTo15 == 2 then
																		exitTo14 = 3
																		break
																	elseif exitTo15 == 3 then
																		exitTo14 = 4
																		break
																	elseif exitTo15 == 4 then
																		if nil <= 16 then
																			exitTo14 = 7
																			break
																		elseif nil <= 18 then
																			exitTo14 = 8
																			break
																		elseif nil <= 19 then
																			continue
																		else
																			exitTo14 = 1
																			break
																		end
																	elseif exitTo15 == 5 then
																		if nil <= 21 then
																			exitTo14 = 2
																			break
																		elseif not (nil <= 22) then
																			fn5(456943662, 4)
																			n = 171627653
																			fn6()
																			continue
																		end
																	else
																		if exitTo15 == 6 then
																			exitTo14 = 5
																		elseif exitTo15 == 7 then
																			exitTo14 = 6
																		end

																		break
																	end

																	break
																end
															end

															if exitTo14 == 1 then
																exitTo16 = 1
																break
															elseif exitTo14 == 2 then
																exitTo16 = 2
																break
															elseif exitTo14 ~= 3 then
																if exitTo14 == 4 then
																	if nil <= 6 then
																		exitTo16 = 4
																		break
																	elseif nil <= 9 then
																		if nil <= 7 then
																			exitTo16 = 6
																			break
																		elseif nil <= 8 then
																			exitTo16 = 7
																			break
																		else
																			fn5(pos, 2)
																			v29 = nil
																			n14 = 0
																			gsub = string.gsub
																			n15 = n10 - 4130248912

																			fn13 = function(arg4)
																				v29 = arg4
																				local n18 = n14 + 1

																				if nil then
																					n15 = bit32.bxor(n15, 2158233785)
																				end

																				n14 = n18
																			end

																			n16 = 3757722826
																			continue
																		end
																	else
																		exitTo16 = 5
																		break
																	end
																else
																	exitTo16 = 3
																	break
																end
															end

															break
														end

														if exitTo16 == 1 then
															exitTo17 = 1
															break
														elseif exitTo16 == 2 then
															exitTo17 = 2
															break
														elseif exitTo16 == 3 then
															if exitTo14 == 5 then
																exitTo17 = 3
																break
															elseif exitTo14 == 6 then
																continue
															else
																exitTo17 = 4
																break
															end
														end

														break
													end

													if exitTo17 == 1 then
														exitTo18 = 1
														break
													elseif exitTo17 == 2 then
														exitTo18 = 2
														break
													elseif exitTo17 == 3 then
														exitTo18 = 3
														break
													elseif exitTo17 == 4 then
														if exitTo14 == 7 then
															exitTo18 = 8
															break
														elseif exitTo14 == 8 then
															if nil <= 17 then
																exitTo18 = 9
																break
															else
																pos = pos * 10 + string.byte(arg, n11, n11) - 48
																continue
															end
														end
													elseif exitTo16 == 4 then
														exitTo18 = 4
														break
													elseif exitTo16 == 5 then
														if nil <= 11 then
															exitTo18 = 6
															break
														elseif nil <= 12 then
															exitTo18 = 7
															break
														else
															continue
														end
													else
														exitTo18 = 5
														break
													end

													break
												end

												if exitTo18 == 1 then
													exitTo19 = 1
													break
												elseif exitTo18 == 2 then
													exitTo19 = 2
													break
												elseif exitTo18 == 3 then
													exitTo19 = 3
													break
												elseif exitTo18 == 4 then
													if nil <= 2 then
														if nil <= 0 then
															exitTo19 = 5
															break
														elseif nil <= 1 then
															continue
														else
															exitTo19 = 6
															break
														end
													else
														exitTo19 = 4
														break
													end
												end

												break
											end

											if exitTo19 == 1 then
												exitTo20 = 1
												break
											elseif exitTo19 == 2 then
												exitTo20 = 2
												break
											elseif exitTo19 == 3 then
												exitTo20 = 3
												break
											elseif exitTo19 == 4 then
												exitTo20 = 4
												break
											elseif exitTo19 == 5 then
												exitTo20 = 5
												break
											elseif exitTo19 == 6 then
												exitTo20 = 6
												break
											elseif exitTo18 == 5 then
												if exitTo16 == 6 then
													exitTo20 = 12
													break
												elseif exitTo16 == 7 then
													fn52 = match
													match = 0
													continue
												end
											elseif exitTo18 == 6 then
												exitTo20 = 7
												break
											elseif exitTo18 == 7 then
												exitTo20 = 8
												break
											elseif exitTo18 == 8 then
												if nil <= 14 then
													exitTo20 = 10
													break
												elseif nil <= 15 then
													exitTo20 = 11
													break
												else
													continue
												end
											else
												exitTo20 = 9
												break
											end

											break
										end

										if exitTo20 == 1 then
											exitTo21 = 1
											break
										elseif exitTo20 == 2 then
											exitTo21 = 2
											break
										elseif exitTo20 == 3 then
											exitTo21 = 3
											break
										elseif exitTo20 == 4 then
											if nil <= 4 then
												exitTo21 = 7
												break
											elseif nil <= 5 then
												exitTo21 = 8
												break
											else
												continue
											end
										elseif exitTo20 == 5 then
											exitTo21 = 4
											break
										elseif exitTo20 == 6 then
											exitTo21 = 5
											break
										elseif exitTo20 == 7 then
											if nil <= 10 then
												fn5(456943662, 4)
												n = 171627653
												fn6()
												continue
											else
												exitTo21 = 6
												break
											end
										end

										break
									end

									if exitTo21 == 1 then
										exitTo22 = 1
										break
									elseif exitTo21 == 2 then
										exitTo22 = 2
										break
									elseif exitTo21 == 3 then
										exitTo22 = 3
										break
									elseif exitTo21 == 4 then
										exitTo22 = 4
										break
									elseif exitTo21 == 5 then
										fn52(match + 0, 2)
										match = fn5
										continue
									elseif exitTo21 == 6 then
										match3 = 0
										continue
									elseif exitTo21 == 7 then
										if not (nil <= 3) then
											continue
										end
									else
										exitTo22 = 5
										break
									end

									break
								end

								if exitTo22 == 1 then
									exitTo23 = 1
									break
								elseif exitTo22 == 2 then
									exitTo23 = 2
									break
								elseif exitTo22 == 3 then
									exitTo23 = 3
									break
								elseif exitTo22 == 4 then
									exitTo23 = 4
									break
								elseif exitTo22 == 5 then
									if exitTo21 == 8 then
										exitTo23 = 5
										break
									elseif exitTo20 == 8 then
										exitTo23 = 6
										break
									elseif exitTo20 == 9 then
										exitTo23 = 7
										break
									elseif exitTo20 == 10 then
										exitTo23 = 8
										break
									elseif exitTo20 == 11 then
										match3 = match
										match = 0
										continue
									else
										exitTo23 = 9
										break
									end
								end

								break
							end

							if exitTo23 == 1 then
								exitTo24 = 1
								break
							elseif exitTo23 == 2 then
								exitTo24 = 2
								break
							elseif exitTo23 == 3 then
								if nil <= 24 then
									continue
								else
									exitTo24 = 9
									break
								end
							elseif exitTo23 == 4 then
								exitTo24 = 3
								break
							elseif exitTo23 == 5 then
								exitTo24 = 4
								break
							elseif exitTo23 == 6 then
								exitTo24 = 5
								break
							elseif exitTo23 == 7 then
								exitTo24 = 6
								break
							elseif exitTo23 == 8 then
								exitTo24 = 7
								break
							elseif exitTo23 == 9 then
								if exitTo20 == 12 then
									exitTo24 = 8
									break
								else
									continue
								end
							end

							break
						end

						if exitTo24 == 1 then
							exitTo25 = 1
							break
						elseif exitTo24 == 2 then
							exitTo25 = 2
							break
						elseif exitTo24 == 3 then
							exitTo25 = 3
							break
						elseif exitTo24 == 4 then
							exitTo25 = 4
							break
						elseif exitTo24 == 5 then
							exitTo25 = 5
							break
						elseif exitTo24 == 6 then
							if exitTo18 == 9 then
								exitTo25 = 6
								break
							else
								continue
							end
						end

						break
					end

					if exitTo25 == 1 then
						exitTo13 = 1
						break
					elseif exitTo25 == 2 then
						exitTo13 = 2
						break
					elseif exitTo25 == 3 then
						exitTo13 = 3
						break
					elseif exitTo25 == 4 then
						exitTo13 = 9
						break
					elseif exitTo25 == 5 then
						exitTo13 = 8
						break
					elseif exitTo25 == 6 then
						exitTo13 = 7
						break
					elseif exitTo24 == 7 then
						exitTo13 = 5
						break
					elseif exitTo24 == 8 then
						exitTo13 = 4
						break
					elseif exitTo24 == 9 then
						continue
					end

					break
				end

				if exitTo13 == 1 then
					exitTo26 = 1
					break
				end

				if exitTo13 == 2 then
					exitTo26 = 2
					break
				end

				if exitTo13 == 3 then
					exitTo26 = 3
					break
				end

				if exitTo13 == 4 then
					exitTo26 = 4
					break
				end

				if exitTo13 == 5 then
					exitTo26 = 5
					break
				end

				if exitTo13 == 6 then
					if exitTo10 ~= 10 then
						if exitTo10 == 11 then
							if exitTo9 == 14 then
								exitTo26 = 7
								break
							end
							continue
						end

						break
					end
				elseif exitTo13 ~= 7 then
					if exitTo13 == 8 then
						continue
					end
					exitTo26 = 6
					break
				end
			end

			local exitTo52 = nil

			while true do
				fn52 = not n11
				exitTo39 = nil

				while true do
					if not fn52 then
						local exitTo38 = nil

						while true do
							fn5(pos, 2)
							fn5(n11, 2)
							match2 = string.match(arg, ":[^%u%U]?(%d+)[^%x%X]?[\n:\r]")
							fn52 = fn5

							if match then
								match3 = match2
							else
								match = match2
								match3 = match
								match = 0
							end

							local exitTo37 = nil

							while true do
								fn52(match + 0, 2)
								match = fn5
								match3 = match3 or 0
								exitTo36 = nil

								while true do
									match(match3 + 0, 2)
									v30 = string.gmatch(arg, "%:[^%s%S]-([0-9]+)[%:\n\r]")
									match = v30()
									fn8(v30(), nil)

									if not nil then
										fn5(456943662, 4)
										n = 171627653
										fn6()
									end

									exitTo35 = nil

									while true do
										fn53 = fn5

										if match then
											fn52 = fn53
										else
											match = fn53
											fn52 = match
											match = 0
										end

										local exitTo34 = nil

										while true do
											fn52(match + 0, 2)
											n10 = bit32.band(n10, 2532609332)
											match = string.sub(arg, pos + 1, n11 - 1)
											fn52 = string.char(string.byte(arg, pos + 1, n11 - 1))
											match3 = string.byte
											n12 = 1
											local exitTo33 = nil

											while true do
												v31 = match3(arg, pos + n12, pos + 1)
												fn5(match + 0, 2)
												fn5(fn52 + 0, 2)
												fn4(307116577, v31)
												tbl8 = { nil, pos + 1 - 1, 1, n11 - 1 + 0, v28 }
												pos = 0
												v28 = tbl8
												exitTo32 = nil

												while true do
													v32 = v28[3]
													v33 = v28[4]
													n13 = v28[2] + v32
													flag2 = v32 <= 0
													flag3 = not flag2
													flag4 = n13 >= v33
													flag5 = n13 <= v33

													if flag2 then
														if flag3 then
															flag4 = flag4 or flag5
														else
															flag5 = flag3
															flag4 = flag4 or flag5
														end
													else
														flag4 = flag2

														if flag3 then
															flag4 = flag4 or flag5
														else
															flag5 = flag3
															flag4 = flag4 or flag5
														end
													end

													v28[2] = n13

													if flag4 then
														n11 = n13
														pos = pos * 10 + string.byte(arg, n11, n11) - 48
														continue
													end

													local exitTo31 = nil

													while true do
														v28 = v28[5]
														fn5(pos, 2)
														v29 = nil
														n14 = 0
														gsub = string.gsub
														n15 = n10 - 4130248912

														fn13 = function(arg4)
															v29 = arg4
															local n18 = n14 + 1

															if nil then
																n15 = bit32.bxor(n15, 2158233785)
															end

															n14 = n18
														end

														n16 = 118666967
														local exitTo30 = nil

														while true do
															n15 = n16
															v34, v35 = gsub(arg, "%:[^%x%X]*([0-9]+)[^%d%D]?[\r\n%:]", fn13, 1)
															pos = v35
															fn8(n14, 1)

															if nil then
															else
																fn5(456943662, 4)
																n = 171627653
																fn6()
															end

															exitTo27 = nil
															local exitTo29 = nil

															while true do
																fn8(pos, 1)

																if nil then
																	exitTo29 = 1
																	break
																else
																	fn54 = fn5
																	n17 = 3443272525
																	exitTo28 = nil

																	while true do
																		n10 = n17
																		fn54(456943662, 4)
																		n = 171627653
																		fn62 = fn6
																		fn6()

																		if fn62 then
																			exitTo28 = 1
																			break
																		else
																			if nil then
																				if nil <= 13 then
																					exitTo28 = 2
																					break
																				elseif nil <= 20 then
																					exitTo28 = 3
																					break
																				elseif nil <= 23 then
																					exitTo28 = 4
																					break
																				elseif nil <= 25 then
																					exitTo28 = 5
																					break
																				elseif nil <= 26 then
																					exitTo28 = 6
																					break
																				else
																					fn54 = fn5
																					n17 = 101974320
																					continue
																				end
																			end

																			break
																		end
																	end

																	if exitTo28 == 1 then
																		exitTo29 = 2
																		break
																	elseif exitTo28 == 2 then
																		exitTo29 = 3
																		break
																	elseif exitTo28 == 3 then
																		if nil <= 16 then
																			exitTo29 = 5
																			break
																		elseif nil <= 18 then
																			exitTo29 = 6
																			break
																		elseif nil <= 19 then
																			continue
																		else
																			exitTo29 = 1
																			break
																		end
																	elseif exitTo28 == 4 then
																		if nil <= 21 then
																			exitTo29 = 2
																			break
																		elseif nil <= 22 then
																			exitTo29 = 4
																			break
																		else
																			fn5(456943662, 4)
																			n = 171627653
																			fn6()
																			continue
																		end
																	end

																	break
																end
															end

															if exitTo29 == 1 then
																exitTo27 = 1
															elseif exitTo29 == 2 then
																exitTo27 = 2
															elseif exitTo29 == 3 then
																exitTo27 = 3
															elseif exitTo29 == 4 then
																exitTo27 = 6
															elseif exitTo29 == 5 then
																exitTo27 = 7
															elseif exitTo29 == 6 then
																exitTo27 = 8
															elseif exitTo28 == 5 then
																exitTo27 = 4
															elseif exitTo28 == 6 then
																exitTo27 = 5
															end

															if exitTo27 == 1 then
																exitTo30 = 1
																break
															elseif exitTo27 == 2 then
																exitTo30 = 2
																break
															elseif exitTo27 == 3 then
																if nil <= 6 then
																	exitTo30 = 3
																	break
																elseif nil <= 9 then
																	if nil <= 7 then
																		exitTo30 = 5
																		break
																	elseif nil <= 8 then
																		exitTo30 = 6
																		break
																	else
																		fn5(pos, 2)
																		v29 = nil
																		n14 = 0
																		gsub = string.gsub
																		n15 = n10 - 4130248912

																		fn13 = function(arg4)
																			v29 = arg4
																			local n18 = n14 + 1

																			if nil then
																				n15 = bit32.bxor(n15, 2158233785)
																			end

																			n14 = n18
																		end

																		n16 = 3757722826
																		continue
																	end
																else
																	exitTo30 = 4
																	break
																end
															end

															break
														end

														if exitTo30 == 1 then
															exitTo31 = 1
															break
														elseif exitTo30 == 2 then
															exitTo31 = 2
															break
														elseif exitTo30 == 3 then
															exitTo31 = 3
															break
														elseif exitTo30 == 4 then
															exitTo31 = 4
															break
														elseif exitTo30 == 5 then
															exitTo31 = 5
															break
														elseif exitTo30 == 6 then
															exitTo31 = 6
															break
														elseif exitTo27 == 4 then
															exitTo31 = 7
															break
														elseif exitTo27 == 5 then
															continue
														end

														break
													end

													if exitTo31 == 1 then
														exitTo32 = 1
														break
													elseif exitTo31 == 2 then
														exitTo32 = 2
														break
													elseif exitTo31 == 3 then
														exitTo32 = 3
														break
													elseif exitTo31 == 4 then
														if nil <= 11 then
															exitTo32 = 11
															break
														elseif not (nil <= 12) then
															continue
														end
													elseif exitTo31 == 5 then
														exitTo32 = 4
														break
													elseif exitTo31 == 6 then
														exitTo32 = 5
														break
													elseif exitTo31 == 7 then
														exitTo32 = 6
														break
													elseif exitTo27 == 6 then
														exitTo32 = 7
														break
													elseif exitTo27 == 7 then
														exitTo32 = 8
														break
													elseif exitTo27 == 8 then
														if nil <= 17 then
															exitTo32 = 10
															break
														else
															pos = pos * 10 + string.byte(arg, n11, n11) - 48
															continue
														end
													else
														exitTo32 = 9
														break
													end

													break
												end

												if exitTo32 == 1 then
													exitTo33 = 1
													break
												elseif exitTo32 == 2 then
													exitTo33 = 2
													break
												elseif exitTo32 == 3 then
													if nil <= 2 then
														if nil <= 0 then
															exitTo33 = 4
															break
														elseif nil <= 1 then
															continue
														else
															exitTo33 = 5
															break
														end
													else
														exitTo33 = 3
														break
													end
												end

												break
											end

											if exitTo33 == 1 then
												exitTo34 = 1
												break
											elseif exitTo33 == 2 then
												exitTo34 = 2
												break
											elseif exitTo33 == 3 then
												exitTo34 = 3
												break
											elseif exitTo33 == 4 then
												exitTo34 = 4
												break
											elseif exitTo33 == 5 then
												exitTo34 = 5
												break
											elseif exitTo32 == 4 then
												exitTo34 = 6
												break
											elseif exitTo32 == 5 then
												fn52 = match
												match = 0
												continue
											elseif exitTo32 == 6 then
												exitTo34 = 7
												break
											elseif exitTo32 == 7 then
												exitTo34 = 8
												break
											elseif exitTo32 == 8 then
												if nil <= 14 then
													exitTo34 = 9
													break
												elseif nil <= 15 then
													exitTo34 = 10
													break
												else
													continue
												end
											end

											break
										end

										if exitTo34 == 1 then
											exitTo35 = 1
											break
										elseif exitTo34 == 2 then
											exitTo35 = 2
											break
										elseif exitTo34 == 3 then
											if nil <= 4 then
												exitTo35 = 13
												break
											elseif nil <= 5 then
												exitTo35 = 14
												break
											else
												continue
											end
										elseif exitTo34 == 4 then
											exitTo35 = 3
											break
										elseif exitTo34 == 5 then
											exitTo35 = 4
											break
										elseif exitTo34 == 6 then
											exitTo35 = 5
											break
										elseif exitTo34 == 7 then
											exitTo35 = 6
											break
										elseif exitTo34 == 8 then
											exitTo35 = 7
											break
										elseif exitTo34 == 9 then
											exitTo35 = 8
											break
										elseif exitTo34 == 10 then
											exitTo35 = 9
											break
										elseif exitTo32 == 9 then
											exitTo35 = 10
											break
										elseif exitTo32 == 10 then
											exitTo35 = 11
											break
										elseif exitTo32 == 11 then
											if nil <= 10 then
												fn5(456943662, 4)
												n = 171627653
												fn6()
												continue
											else
												exitTo35 = 12
												break
											end
										end

										break
									end

									if exitTo35 == 1 then
										exitTo36 = 1
										break
									elseif exitTo35 == 2 then
										exitTo36 = 2
										break
									elseif exitTo35 == 3 then
										exitTo36 = 3
										break
									elseif exitTo35 == 4 then
										fn52(match + 0, 2)
										match = fn5
										continue
									elseif exitTo35 == 5 then
										exitTo36 = 4
										break
									elseif exitTo35 == 6 then
										exitTo36 = 5
										break
									elseif exitTo35 == 7 then
										exitTo36 = 6
										break
									elseif exitTo35 == 8 then
										exitTo36 = 7
										break
									elseif exitTo35 == 9 then
										exitTo36 = 8
										break
									elseif exitTo35 == 10 then
										exitTo36 = 9
										break
									elseif exitTo35 == 11 then
										exitTo36 = 10
										break
									elseif exitTo35 == 12 then
										match3 = 0
										continue
									elseif exitTo35 == 13 then
										if not (nil <= 3) then
											continue
										end
									else
										exitTo36 = 11
										break
									end

									break
								end

								if exitTo36 == 1 then
									exitTo37 = 1
									break
								elseif exitTo36 == 2 then
									exitTo37 = 2
									break
								elseif exitTo36 == 3 then
									exitTo37 = 3
									break
								elseif exitTo36 == 4 then
									exitTo37 = 4
									break
								elseif exitTo36 == 5 then
									exitTo37 = 5
									break
								elseif exitTo36 == 6 then
									exitTo37 = 6
									break
								elseif exitTo36 == 7 then
									exitTo37 = 7
									break
								elseif exitTo36 == 8 then
									match3 = match
									match = 0
									continue
								end

								break
							end

							if exitTo37 == 1 then
								exitTo38 = 1
								break
							elseif exitTo37 == 2 then
								exitTo38 = 2
								break
							elseif exitTo37 == 3 then
								exitTo38 = 3
								break
							elseif exitTo37 == 4 then
								exitTo38 = 4
								break
							elseif exitTo37 == 5 then
								if nil <= 24 then
									continue
								end
							elseif exitTo37 == 6 then
								exitTo38 = 5
								break
							elseif exitTo37 == 7 then
								exitTo38 = 6
								break
							elseif exitTo36 == 9 then
								continue
							else
								exitTo38 = 7
								break
							end

							break
						end

						if exitTo38 == 1 then
							exitTo39 = 1
							break
						end

						if exitTo38 == 2 then
							exitTo39 = 2
							break
						end

						if exitTo38 == 3 then
							exitTo39 = 3
							break
						end

						if exitTo38 == 4 then
							exitTo39 = 4
							break
						end

						if exitTo38 ~= 5 then
							if exitTo38 == 6 then
								exitTo39 = 5
								break
							end

							if exitTo38 == 7 then
								exitTo39 = 6
								break
							end
							continue
						end
					end

					local exitTo51 = nil

					while true do
						fn5(456943662, 4)
						n = 171627653
						fn6()
						exitTo50 = nil

						while true do
							fn5(pos, 2)
							fn5(n11, 2)
							match2 = string.match(arg, ":[^%u%U]?(%d+)[^%x%X]?[\n:\r]")
							fn52 = fn5

							if match then
								match3 = match2
							else
								match = match2
								match3 = match
								match = 0
							end

							local exitTo49 = nil

							while true do
								fn52(match + 0, 2)
								match = fn5
								match3 = match3 or 0
								local exitTo48 = nil

								while true do
									match(match3 + 0, 2)
									v30 = string.gmatch(arg, "%:[^%s%S]-([0-9]+)[%:\n\r]")
									match = v30()
									fn8(v30(), nil)

									if not nil then
										fn5(456943662, 4)
										n = 171627653
										fn6()
									end

									exitTo47 = nil

									while true do
										fn53 = fn5

										if match then
											fn52 = fn53
										else
											match = fn53
											fn52 = match
											match = 0
										end

										exitTo46 = nil

										while true do
											fn52(match + 0, 2)
											n10 = bit32.band(n10, 2532609332)
											match = string.sub(arg, pos + 1, n11 - 1)
											fn52 = string.char(string.byte(arg, pos + 1, n11 - 1))
											match3 = string.byte
											n12 = 1
											local exitTo45 = nil

											while true do
												v31 = match3(arg, pos + n12, pos + 1)
												fn5(match + 0, 2)
												fn5(fn52 + 0, 2)
												fn4(307116577, v31)
												tbl8 = { nil, pos + 1 - 1, 1, n11 - 1 + 0, v28 }
												pos = 0
												v28 = tbl8
												exitTo44 = nil

												while true do
													v32 = v28[3]
													v33 = v28[4]
													n13 = v28[2] + v32
													flag2 = v32 <= 0
													flag3 = not flag2
													flag4 = n13 >= v33
													flag5 = n13 <= v33

													if flag2 then
														if flag3 then
															flag4 = flag4 or flag5
														else
															flag5 = flag3
															flag4 = flag4 or flag5
														end
													else
														flag4 = flag2

														if flag3 then
															flag4 = flag4 or flag5
														else
															flag5 = flag3
															flag4 = flag4 or flag5
														end
													end

													v28[2] = n13

													if flag4 then
														n11 = n13
														pos = pos * 10 + string.byte(arg, n11, n11) - 48
														continue
													end

													local exitTo43 = nil

													while true do
														v28 = v28[5]
														fn5(pos, 2)
														v29 = nil
														n14 = 0
														gsub = string.gsub
														n15 = n10 - 4130248912

														fn13 = function(arg4)
															v29 = arg4
															local n18 = n14 + 1

															if nil then
																n15 = bit32.bxor(n15, 2158233785)
															end

															n14 = n18
														end

														n16 = 118666967
														exitTo42 = nil

														while true do
															n15 = n16
															v34, v35 = gsub(arg, "%:[^%x%X]*([0-9]+)[^%d%D]?[\r\n%:]", fn13, 1)
															pos = v35
															fn8(n14, 1)

															if nil then
															else
																fn5(456943662, 4)
																n = 171627653
																fn6()
															end

															exitTo40 = nil

															while true do
																fn8(pos, 1)

																if nil then
																	exitTo40 = 1
																	break
																else
																	fn54 = fn5
																	n17 = 3443272525
																	local exitTo41 = nil

																	while true do
																		n10 = n17
																		fn54(456943662, 4)
																		n = 171627653
																		fn62 = fn6
																		fn6()

																		if fn62 then
																			exitTo41 = 1
																			break
																		else
																			if nil then
																				if nil <= 13 then
																					exitTo41 = 3
																					break
																				end

																				if nil <= 20 then
																					exitTo41 = 4
																					break
																				end

																				if nil <= 23 then
																					exitTo41 = 5
																					break
																				end

																				if nil <= 25 then
																					exitTo41 = 6
																					break
																				end

																				if nil <= 26 then
																					exitTo41 = 7
																					break
																				end
																				fn54 = fn5
																				n17 = 101974320
																				continue
																			end

																			exitTo41 = 2
																			break
																		end
																	end

																	if exitTo41 == 1 then
																		exitTo40 = 2
																		break
																	elseif exitTo41 == 2 then
																		exitTo40 = 3
																		break
																	elseif exitTo41 == 3 then
																		exitTo40 = 4
																		break
																	elseif exitTo41 == 4 then
																		if nil <= 16 then
																			exitTo40 = 7
																			break
																		elseif nil <= 18 then
																			exitTo40 = 8
																			break
																		elseif nil <= 19 then
																			continue
																		else
																			exitTo40 = 1
																			break
																		end
																	elseif exitTo41 == 5 then
																		if nil <= 21 then
																			exitTo40 = 2
																			break
																		elseif not (nil <= 22) then
																			fn5(456943662, 4)
																			n = 171627653
																			fn6()
																			continue
																		end
																	else
																		if exitTo41 == 6 then
																			exitTo40 = 5
																		elseif exitTo41 == 7 then
																			exitTo40 = 6
																		end

																		break
																	end

																	break
																end
															end

															if exitTo40 == 1 then
																exitTo42 = 1
																break
															elseif exitTo40 == 2 then
																exitTo42 = 2
																break
															elseif exitTo40 ~= 3 then
																if exitTo40 == 4 then
																	if nil <= 6 then
																		exitTo42 = 4
																		break
																	elseif nil <= 9 then
																		if nil <= 7 then
																			exitTo42 = 6
																			break
																		elseif nil <= 8 then
																			exitTo42 = 7
																			break
																		else
																			fn5(pos, 2)
																			v29 = nil
																			n14 = 0
																			gsub = string.gsub
																			n15 = n10 - 4130248912

																			fn13 = function(arg4)
																				v29 = arg4
																				local n18 = n14 + 1

																				if nil then
																					n15 = bit32.bxor(n15, 2158233785)
																				end

																				n14 = n18
																			end

																			n16 = 3757722826
																			continue
																		end
																	else
																		exitTo42 = 5
																		break
																	end
																else
																	exitTo42 = 3
																	break
																end
															end

															break
														end

														if exitTo42 == 1 then
															exitTo43 = 1
															break
														elseif exitTo42 == 2 then
															exitTo43 = 2
															break
														elseif exitTo42 == 3 then
															if exitTo40 == 5 then
																exitTo43 = 3
																break
															elseif exitTo40 == 6 then
																continue
															else
																exitTo43 = 4
																break
															end
														end

														break
													end

													if exitTo43 == 1 then
														exitTo44 = 1
														break
													elseif exitTo43 == 2 then
														exitTo44 = 2
														break
													elseif exitTo43 == 3 then
														exitTo44 = 3
														break
													elseif exitTo43 == 4 then
														if exitTo40 == 7 then
															exitTo44 = 8
															break
														elseif exitTo40 == 8 then
															if nil <= 17 then
																exitTo44 = 9
																break
															else
																pos = pos * 10 + string.byte(arg, n11, n11) - 48
																continue
															end
														end
													elseif exitTo42 == 4 then
														exitTo44 = 4
														break
													elseif exitTo42 == 5 then
														if nil <= 11 then
															exitTo44 = 6
															break
														elseif nil <= 12 then
															exitTo44 = 7
															break
														else
															continue
														end
													else
														exitTo44 = 5
														break
													end

													break
												end

												if exitTo44 == 1 then
													exitTo45 = 1
													break
												elseif exitTo44 == 2 then
													exitTo45 = 2
													break
												elseif exitTo44 == 3 then
													exitTo45 = 3
													break
												elseif exitTo44 == 4 then
													if nil <= 2 then
														if nil <= 0 then
															exitTo45 = 5
															break
														elseif nil <= 1 then
															continue
														else
															exitTo45 = 6
															break
														end
													else
														exitTo45 = 4
														break
													end
												end

												break
											end

											if exitTo45 == 1 then
												exitTo46 = 1
												break
											elseif exitTo45 == 2 then
												exitTo46 = 2
												break
											elseif exitTo45 == 3 then
												exitTo46 = 3
												break
											elseif exitTo45 == 4 then
												exitTo46 = 4
												break
											elseif exitTo45 == 5 then
												exitTo46 = 5
												break
											elseif exitTo45 == 6 then
												exitTo46 = 6
												break
											elseif exitTo44 == 5 then
												if exitTo42 == 6 then
													exitTo46 = 12
													break
												elseif exitTo42 == 7 then
													fn52 = match
													match = 0
													continue
												end
											elseif exitTo44 == 6 then
												exitTo46 = 7
												break
											elseif exitTo44 == 7 then
												exitTo46 = 8
												break
											elseif exitTo44 == 8 then
												if nil <= 14 then
													exitTo46 = 10
													break
												elseif nil <= 15 then
													exitTo46 = 11
													break
												else
													continue
												end
											else
												exitTo46 = 9
												break
											end

											break
										end

										if exitTo46 == 1 then
											exitTo47 = 1
											break
										elseif exitTo46 == 2 then
											exitTo47 = 2
											break
										elseif exitTo46 == 3 then
											exitTo47 = 3
											break
										elseif exitTo46 == 4 then
											if nil <= 4 then
												exitTo47 = 7
												break
											elseif nil <= 5 then
												exitTo47 = 8
												break
											else
												continue
											end
										elseif exitTo46 == 5 then
											exitTo47 = 4
											break
										elseif exitTo46 == 6 then
											exitTo47 = 5
											break
										elseif exitTo46 == 7 then
											if nil <= 10 then
												fn5(456943662, 4)
												n = 171627653
												fn6()
												continue
											else
												exitTo47 = 6
												break
											end
										end

										break
									end

									if exitTo47 == 1 then
										exitTo48 = 1
										break
									elseif exitTo47 == 2 then
										exitTo48 = 2
										break
									elseif exitTo47 == 3 then
										exitTo48 = 3
										break
									elseif exitTo47 == 4 then
										exitTo48 = 4
										break
									elseif exitTo47 == 5 then
										fn52(match + 0, 2)
										match = fn5
										continue
									elseif exitTo47 == 6 then
										match3 = 0
										continue
									elseif exitTo47 == 7 then
										if not (nil <= 3) then
											continue
										end
									else
										exitTo48 = 5
										break
									end

									break
								end

								if exitTo48 == 1 then
									exitTo49 = 1
									break
								elseif exitTo48 == 2 then
									exitTo49 = 2
									break
								elseif exitTo48 == 3 then
									exitTo49 = 3
									break
								elseif exitTo48 == 4 then
									exitTo49 = 4
									break
								elseif exitTo48 == 5 then
									if exitTo47 == 8 then
										exitTo49 = 5
										break
									elseif exitTo46 == 8 then
										exitTo49 = 6
										break
									elseif exitTo46 == 9 then
										exitTo49 = 7
										break
									elseif exitTo46 == 10 then
										exitTo49 = 8
										break
									elseif exitTo46 == 11 then
										match3 = match
										match = 0
										continue
									else
										exitTo49 = 9
										break
									end
								end

								break
							end

							if exitTo49 == 1 then
								exitTo50 = 1
								break
							elseif exitTo49 == 2 then
								exitTo50 = 2
								break
							elseif exitTo49 == 3 then
								if nil <= 24 then
									continue
								else
									exitTo50 = 9
									break
								end
							elseif exitTo49 == 4 then
								exitTo50 = 3
								break
							elseif exitTo49 == 5 then
								exitTo50 = 4
								break
							elseif exitTo49 == 6 then
								exitTo50 = 5
								break
							elseif exitTo49 == 7 then
								exitTo50 = 6
								break
							elseif exitTo49 == 8 then
								exitTo50 = 7
								break
							elseif exitTo49 == 9 then
								if exitTo46 == 12 then
									exitTo50 = 8
									break
								else
									continue
								end
							end

							break
						end

						if exitTo50 == 1 then
							exitTo51 = 1
							break
						elseif exitTo50 == 2 then
							exitTo51 = 2
							break
						elseif exitTo50 == 3 then
							exitTo51 = 3
							break
						elseif exitTo50 == 4 then
							exitTo51 = 4
							break
						elseif exitTo50 == 5 then
							exitTo51 = 5
							break
						elseif exitTo50 == 6 then
							if exitTo44 == 9 then
								exitTo51 = 6
								break
							else
								continue
							end
						end

						break
					end

					if exitTo51 == 1 then
						exitTo39 = 1
						break
					elseif exitTo51 == 2 then
						exitTo39 = 2
						break
					elseif exitTo51 == 3 then
						exitTo39 = 3
						break
					elseif exitTo51 == 4 then
						exitTo39 = 9
						break
					elseif exitTo51 == 5 then
						exitTo39 = 8
						break
					elseif exitTo51 == 6 then
						exitTo39 = 7
						break
					elseif exitTo50 == 7 then
						exitTo39 = 5
						break
					elseif exitTo50 == 8 then
						exitTo39 = 4
						break
					elseif exitTo50 == 9 then
						continue
					end

					break
				end

				if exitTo39 == 1 then
					exitTo52 = 1
					break
				elseif exitTo39 == 2 then
					exitTo52 = 2
					break
				elseif exitTo39 == 3 then
					exitTo52 = 3
					break
				elseif exitTo39 == 4 then
					exitTo52 = 4
					break
				elseif exitTo39 == 5 then
					exitTo52 = 5
					break
				elseif exitTo39 == 6 then
					if exitTo36 == 10 then
						continue
					else
						exitTo52 = 6
						break
					end
				elseif exitTo39 == 7 then
					continue
				end

				break
			end

			if exitTo52 == 1 then
				exitTo26 = 1
				break
			elseif exitTo52 == 2 then
				exitTo26 = 2
				break
			elseif exitTo52 == 3 then
				exitTo26 = 3
				break
			elseif exitTo52 == 4 then
				exitTo26 = 4
				break
			elseif exitTo52 == 5 then
				exitTo26 = 5
				break
			elseif exitTo52 == 6 then
				if exitTo36 == 11 then
					if exitTo35 == 14 then
						exitTo26 = 7
						break
					else
						continue
					end
				end
			elseif exitTo39 == 8 then
				continue
			else
				if exitTo39 == 9 then
					exitTo26 = 7
				end

				break
			end

			break
		end

		local fn42, v30

		if exitTo26 == 1 then
			pos = fn5

			if v29 then
				n11 = v29
				pos(n11 + 0, 2)
				fn8(string.sub(arg, 2, 2), arg3)

				if not nil then
					fn5(456943662, 4)
					n = 171627653
					fn6()
				end
			else
				n11 = 0
				pos(n11 + 0, 2)
				fn8(string.sub(arg, 2, 2), arg3)

				if not nil then
					fn5(456943662, 4)
					n = 171627653
					fn6()
					fn42 = fn4
					v30 = string.byte(arg, 2, 2)
					fn42(307116577, v30)
					return
				end
			end

			fn42 = fn4
			v30 = string.byte(arg, 2, 2)
			fn42(307116577, v30)
		elseif exitTo26 == 2 then
			pos = fn5

			if v29 then
				n11 = v29
				pos(n11 + 0, 2)
				fn8(string.sub(arg, 2, 2), arg3)

				if not nil then
					fn5(456943662, 4)
					n = 171627653
					fn6()
					fn42 = fn4
					v30 = string.byte(arg, 2, 2)
					fn42(307116577, v30)
					return
				end
			else
				n11 = 0
				pos(n11 + 0, 2)
				fn8(string.sub(arg, 2, 2), arg3)

				if not nil then
					fn5(456943662, 4)
					n = 171627653
					fn6()
					fn42 = fn4
					v30 = string.byte(arg, 2, 2)
					fn42(307116577, v30)
					return
				end
			end

			fn42 = fn4
			v30 = string.byte(arg, 2, 2)
			fn42(307116577, v30)
			return
		elseif exitTo26 == 3 then
			fn5(456943662, 4)
			n = 171627653
			fn6()
			fn42 = fn4
			v30 = string.byte(arg, 2, 2)
			fn42(307116577, v30)
			return
		elseif exitTo26 == 4 then
			pos(n11 + 0, 2)
			fn8(string.sub(arg, 2, 2), arg3)

			if not nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
				fn42 = fn4
				v30 = string.byte(arg, 2, 2)
				fn42(307116577, v30)
				return
			end

			fn42 = fn4
			v30 = string.byte(arg, 2, 2)
			fn42(307116577, v30)
			return
		elseif exitTo26 == 5 then
			fn42 = fn4
			v30 = string.byte(arg, 2, 2)
			fn42(307116577, v30)
			return
		elseif exitTo26 == 6 then
			if exitTo13 == 9 then
				n11 = 0
				pos(n11 + 0, 2)
				fn8(string.sub(arg, 2, 2), arg3)

				if not nil then
					fn5(456943662, 4)
					n = 171627653
					fn6()
					fn42 = fn4
					v30 = string.byte(arg, 2, 2)
					fn42(307116577, v30)
					return
				end

				fn42 = fn4
				v30 = string.byte(arg, 2, 2)
				fn42(307116577, v30)
				return
			end
		elseif exitTo26 == 7 then
			pos(0 + 0, 2)
			fn8(string.sub(arg, 2, 2), arg3)

			if not nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
				fn42 = fn4
				v30 = string.byte(arg, 2, 2)
				fn42(307116577, v30)
				return
			end

			fn42 = fn4
			v30 = string.byte(arg, 2, 2)
			fn42(307116577, v30)
			return
		end
	end

	fn12("main:75: attempt to get length of a number value", 423433443, "a")
	str13 = "module.lua:166: attempt to call a userdata value"
	n7 = 423433443
	str14 = "o"
	fn12(str13, n7, str14)

	fn3 = function(arg)
		local n10 = 721161519
		local n11 = 3027559708
		local fn13 = nil
		local match = string.match(arg, "%:[^%w%W]*([0-9]+)[\n\r:][^%u%U]-")
		local v28 = string.gmatch(arg, ":[^%l%L]?(%d%d*)[:\n\r][^%d%D]-")()
		local pos, v29 = string.find(arg, "[%:][^%u%U]-([%d]%d*)[\r:\n][^%c%C]?")
		local flag = not pos
		local flag2

		if pos then
			flag2 = not v29
		else
			flag2 = flag
		end

		if flag2 then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		local str15 = string.sub(arg, pos + 1, v29 - 1)
		local v30 = string.char(string.byte(arg, pos + 1, v29 - 1))
		local v31 = nil
		local n12 = 0
		local str152 = str15
		local n13 = 381625190

		fn13 = function(arg2)
			fn8(info(1, "f"), fn13)

			if not nil then
				repeat
					fn5(456943662, 4)
					n = 171627653
				until n13 + 331809064 ~= 321086800

				fn6()
			end

			local gsub = string.gsub
			fn8(info(2, "f"), gsub)

			if not nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
			end

			local info2 = info

			if nil then
				n13 = bit32.bxor(n13, 2153107819)
			end

			fn8(info2(3, "f"), fn3)

			if not nil then
				fn5(456943662, 4)
				n = 171627653
				fn6()
			end

			v31 = arg2
			n12 += 1
		end

		n13 = 187005930
		local str16, v32 = string.gsub(arg, ":[^%u%U]?([%d]%d*)[\r\n:]", fn13, 1)
		fn8(n12, 1)

		if nil then
		else
			fn5(456943662, 4)
			local n102 = table.pack(bit32.band(n10, 4294967295))
			local n112 = table.pack(bit32.band(n11, 4294967295))
			local v33 = table.pack(bit32.band(n102[1], 65535))
			local v34 = table.pack(bit32.rshift(n102[1], 16))
			local v35 = table.pack(bit32.band(n112[1], 65535))
			local v36 = bit32.band(v33[1] * v35[1] + bit32.lshift(bit32.band(v33[1] * bit32.rshift(n112[1], 16) + v34[1] * v35[1], 65535), 16), 4294967295)
			n = 171627653
			fn6()
			n10 = v36 - 95186677
		end

		local fn82 = fn8
		fn8(v32, 1)
		local fn822

		if nil then
			fn822 = fn82
		else
			fn822 = fn82
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		local flag3 = not match
		local flag4

		if match then
			flag4 = not v28
		else
			flag4 = flag3
		end

		if flag4 or not str152 or not v30 or not v31 then
			fn5(456943662, 4)
			n = 171627653
			local fn62 = fn6
			local n112 = table.pack(bit32.band(n11, 4294967295))
			local n102 = table.pack(bit32.band(n10, 4294967295))
			local v33 = table.pack(bit32.band(n112[1], 65535))
			local v34 = table.pack(bit32.rshift(n112[1], 16))
			local v35 = table.pack(bit32.band(n102[1], 65535))
			local v36 = bit32.band(v33[1] * v35[1] + bit32.lshift(bit32.band(v33[1] * bit32.rshift(n102[1], 16) + v34[1] * v35[1], 65535), 16), 4294967295)
			fn62()
			n11 = v36 + 2211211512
		end

		local n14 = match + 0
		local n15 = v28 + 0
		local n16 = str152 + 0
		local n17 = v30 + 0
		local n18 = v31 + 0
		fn8(match, v28)
		local n142

		if nil then
			n142 = n14
		else
			n142 = n14
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		fn8(v28, str152)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		fn8(str152, v30)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		fn8(v30, v31)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		local n143 = n142
		fn8(n143, n15)

		if not nil then
			local flag5

			while true do
				fn5(456943662, 4)
				n = 171627653
				flag5 = not fn822
				n143 = n143 == 373582085

				if n143 then
				else
					break
				end
			end

			flag5()
		end

		fn8(n15, n16)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		fn8(n16, n17)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		fn8(n17, n18)

		if not nil then
			fn5(456943662, 4)
			n = 171627653
			fn6()
		end

		return n142
	end

	local v28 = fn3(result2)
	local v29 = fn3(result3)
	local v30 = fn3(result4)

	if fn8(v28, v29) then
		fn4(307116577, 12)
		n = v253
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(v29, v30) then
		fn4(307116577, 203)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	if fn8(v30, v28) then
		fn4(307116577, 194)
	else
		fn5(456943662, 4)
		n = 171627653
		fn6()
	end

	for _, v31 in {}, nil, nil do
		local kind = type(v31)

		if fn8("function", kind) then
			info(v31, "sl")
		end
	end

	v9(174862142, nil --[[ the caller's registers ]])
	setmetatable(nil --[[ the caller's registers ]], nil)
	local tbl8 = {}
	local tbl9 = {}
	local n10 = 113
	local n11 = 173
	local tbl10 = { 255, nil, 1, -1, v27 }

	while true do
		local v31 = tbl10[3]
		local v32 = tbl10[1]
		local n12 = tbl10[4] + v31
		tbl10[4] = n12

		if n12 <= v32 then
			local n122 = n12
			local n13 = (n10 * n122 + n11) % 256
			local n14 = (n10 * n13 + n11) % 256
			local n15 = (n10 * n14 + n11) % 256
			local n16 = (n10 * n15 + n11) % 256
			tbl8[n122] = n13 + n14 * 256 + n15 * 65536 + n16 * 16777216
			tbl9[n122] = n16
		else
			break
		end
	end

	v26 = tbl10[5]
end

buffer.create(16)

do
	local n8 = 5
	local n9 = 6
	local n10 = 7
	local n11 = 8
	tbl[n8] = 2
	tbl[n9] = 6
	tbl[n10] = 10
	tbl[n11] = 14
end

do
	local n8 = 13
	local n9 = 14
	local n10 = 15
	local n11 = 16
	tbl[n8] = 4
	tbl[n9] = 8
	tbl[n10] = 12
	tbl[n11] = 16
end

do
	local n8 = 21
	local n9 = 22
	tbl[n8] = 2
	tbl[n9] = 7
end

do
	local n8 = 29
	local n9 = 30
	local n10 = 31
	local n11 = 32
	tbl[n8] = 4
	tbl[n9] = 5
	tbl[n10] = 10
	tbl[n11] = 15
end

do
	local tbl5 = {}
	local n8 = 16705
	local tbl6 = { 16, 1, -1, v26, nil }

	while true do
		local v27 = tbl6[2]
		local v28 = tbl6[1]
		local n9 = tbl6[3] + v27
		tbl6[3] = n9

		if n9 <= v28 then
			tbl5[{}] = n9 + 1
		else
			break
		end
	end

	local v27 = tbl6[4]

	for _, v28 in tbl5, nil, nil do
		n8 = (n8 * v28 + v28 * 411) % 16776960 + 1
	end

	local n9 = 67108864
	local n10 = (-17179869183 * (1 + (8641262496 * n9 + 4294967296) / 4503599627370496) * 2 ^ 4294967317 + 1) % 16777216
	local tbl7 = {}
	local tbl8 = { nil, v27, 1, 0, 6 }

	while true do
		local v28 = tbl8[3]
		local v29 = tbl8[5]
		local n11 = tbl8[4] + v28
		tbl8[4] = n11

		if n11 <= v29 then
			n10 = (n10 * 1103515245 + 12345) % 16777216
			tbl7[n11] = n10
		else
			break
		end
	end

	local n11 = (n8 + tbl7[1]) % 16777216
	local tbl9 = { 6, 0, 1, nil, tbl8[2] }

	while true do
		local v28 = tbl9[3]
		local v29 = tbl9[1]
		local n12 = tbl9[2] + v28
		tbl9[2] = n12

		if n12 <= v29 then
			local n122 = n12
			local n13 = (n11 * (tbl7[2] * 2 + 1) + tbl7[3]) % 16777216
			n11 = ((n13 % 4096 * 4096 + (n13 - n13 % 4096) // 4096 + tbl7[4]) % 16777216 + n122 * tbl7[5]) % 16777216

			if nil then
				n11 = (n11 + tbl7[6]) % 16777216
			end
		else
			break
		end
	end

	local v28 = tbl9[5]
	fn5((math_floor_precision(n8) - n11) % 16777216, 8)
	local tbl10 = {}
	local n12 = 1
	local n13 = 0 - n12
	local v29 = nil
	local v282 = v28
	local tbl11 = { 16, v29, n12, v282, n13 }

	while true do
		local v30 = tbl11[3]
		local v31 = tbl11[1]
		local n14 = tbl11[5] + v30
		tbl11[5] = n14

		if n14 <= v31 then
			tbl7 = n14
			tbl10[{}] = tbl7 + 1
		else
			break
		end
	end

	local v30 = tbl11[4]

	for k in tbl10, nil, nil do
	end

	str12()
	return n12(v282, n13, r55_2, v21, v22, v13, v14, v16, v15, v132, v23, tbl7, str10, n6, str, tangentOnCurve2, v18, str6, v17, str5, scale, tangentOnCurve, ok, fn12, str13, n7, str14, tangentOnCurveArcLength2, v20, str9, v19, str8, y, tangentOnCurveArcLength, v25, str12, v24, str11, randNum, fn8, n4, pack, str3, n9, str7, str2, v30, str4, fn7)
end
