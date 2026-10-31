local function luraph_runtime1(...)
    error('Luraph runtime function, not devirtualized')
end
local function luraph_runtime2(...)
    error('Luraph runtime function, not devirtualized')
end
local function luraph_runtime3(...)
    error('Luraph runtime function, not devirtualized')
end
local function luraph_runtime4(...)
    error('Luraph runtime function, not devirtualized')
end
local function luraph_runtime5(...)
    error('Luraph runtime function, not devirtualized')
end
local function luraph_runtime6(...)
    error('Luraph runtime function, not devirtualized')
end
local function luraph_runtime7(...)
    error('Luraph runtime function, not devirtualized')
end

local n

n = 1139908340

local r__R17

r__R17 = {}

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
local n2, fn6, fn7, tbl, fn8, computeHash, new, new2, new3, color3New
local rectNew, uDim2New, uDimNew, new4, v9, v10

do
    local v11 = Instance

    v3 = Vector3

    local v12 = Vector2

    v4 = CFrame
    v5 = Random
    v6 = identifyexecutor
    v7 = loadstring

    local tbl2 = {}
    local n3 = 0

    fn4 = function(arg)
        n3 += 1

        tbl2[n3] = arg % 256
    end
    fn5 = function(arg, arg2)
        local tbl3 = {
            nil,
            0,
            arg2 + 0,
            1,
            nil,
        }

        while true do
            local v13 = tbl3[4]
            local v14 = tbl3[3]
            local n4 = tbl3[2] + v13

            tbl3[2] = n4

            if n4 <= v14 then
                local n5 = arg % 256

                arg = (arg - n5) / 256

                n3 += 1

                tbl2[n3] = n5
            else
                break
            end
        end
    end

    local v13 = assert

    v8 = v13(debug, 
[[The debug library is required on Luau platforms. Please open a support ticket.]])
    info = v8.info
    traceback = v8.traceback
    n2 = 391995358
    fn6 = function()
        local function fn10(arg, arg2, arg3, arg4, arg5)
            local n4 = 380672267
            local tbl3 = {
                4,
                0,
                nil,
                1,
                nil,
            }
            local tbl4 = {
                arg2,
                arg3,
                arg4,
                arg5,
            }
            local v14, n5, n6, n7, n8, v142, v143, v144, v15, v145, v152, v146

            while true do
                local v16 = tbl3[4]
                local v17 = tbl3[1]
                local n9 = tbl3[2] + v16
                local flag = v16 <= 0
                local flag2 = not flag
                local flag3 = n9 >= v17
                local flag4 = n9 <= v17
                local v18, tbl5, v19, v20, n10, n102, n42, n11, n103, v21, n12, n43, n104, n44, n13, v22, n14, n15, v23, v24, v25, n16, n17, v26, n18, n182, n183, n19, n20, n184, v27, n21, n22

                if flag then
                    if flag2 then
                        if flag3 then
                            tbl3[2] = n9

                            if flag3 then
                                v18 = tbl4[n9]
                                tbl5 = {
                                    1,
                                    tbl3,
                                    nil,
                                    0,
                                    #v18 + 0,
                                }

                                while true do
                                    v19 = tbl5[1]
                                    v20 = tbl5[5]
                                    n10 = tbl5[4] + v19
                                    tbl5[4] = n10

                                    if n10 <= v20 then
                                        n102 = n10
                                        n42 = bit32.lshift(bit32.band(n4, n102), 1)

                                        local n45 = bit32.band(n4, 4294967295)
                                        local n452 = bit32.band(n45, 65535)

                                        n11 = n42 + bit32.band(39632 * n452 + bit32.lshift(bit32.band(39632 * bit32.rshift(n45, 16) + 10195 * n452, 65535), 16), 4294967295)
                                        n103 = bit32.band(n102, n4)

                                        local n105 = bit32.band(n102, 4294967295)
                                        local n106 = bit32.band(n103, 4294967295)
                                        local n1052 = bit32.band(n105, 65535)
                                        local n1053 = bit32.rshift(n105, 16)
                                        local n1062 = bit32.band(n106, 65535)
                                        local v28 = bit32.band(n1052 * n1062 + bit32.lshift(bit32.band(n1052 * bit32.rshift(n106, 16) + n1053 * n1062, 65535), 16), 4294967295)
                                        local v282 = bit32.band(v28, 65535)

                                        v21 = bit32.band(42886 * v282 + bit32.lshift(bit32.band(42886 * bit32.rshift(v28, 16) + 18058 * v282, 65535), 16), 4294967295)

                                        local n107 = bit32.band(n102, 4294967295)
                                        local n1072 = bit32.band(n107, 65535)

                                        n12 = n11 + v21 + bit32.band(42887 * n1072 + bit32.lshift(bit32.band(42887 * bit32.rshift(n107, 16) + 18058 * n1072, 65535), 16), 4294967295)
                                        n43 = bit32.bnot(n4)
                                        n104 = bit32.bnot(n102)
                                        n44 = bit32.bor(n43, n104)

                                        local n108 = bit32.band(n102, 4294967295)
                                        local n46 = bit32.band(n44, 4294967295)
                                        local n1082 = bit32.band(n108, 65535)
                                        local n1083 = bit32.rshift(n108, 16)
                                        local n462 = bit32.band(n46, 65535)
                                        local v29 = bit32.band(n1082 * n462 + bit32.lshift(bit32.band(n1082 * bit32.rshift(n46, 16) + n1083 * n462, 65535), 16), 4294967295)
                                        local v292 = bit32.band(v29, 65535)

                                        n13 = 668179153 + bit32.band(42886 * v292 + bit32.lshift(bit32.band(42886 * bit32.rshift(v29, 16) + 18058 * v292, 65535), 16), 4294967295)

                                        local n47 = bit32.band(n43, 4294967295)
                                        local n472 = bit32.band(n47, 65535)

                                        v22 = bit32.band(39631 * n472 + bit32.lshift(bit32.band(39631 * bit32.rshift(n47, 16) + 10195 * n472, 65535), 16), 4294967295)

                                        local n48 = bit32.band(n44, 4294967295)
                                        local n482 = bit32.band(n48, 65535)

                                        n14 = n12 + n13 + v22 + bit32.band(2 * n482 + bit32.lshift(bit32.band(2 * bit32.rshift(n48, 16) + 0 * n482, 65535), 16), 4294967295)

                                        local n142 = bit32.bor(n14, 2147483648)
                                        local n1422 = bit32.band(n142, 65535)
                                        local v30 = bit32.band(6104547510 + bit32.band(10611 * n1422 + bit32.lshift(bit32.band(10611 * bit32.rshift(n142, 16) + 2346 * n1422, 65535), 16), 4294967295), 4294967295)
                                        local v302 = bit32.band(v30, 65535)

                                        n15 = bit32.band(16295 * v302 + bit32.lshift(bit32.band(16295 * bit32.rshift(v30, 16) + 33254 * v302, 65535), 16), 4294967295) + 22185264754
                                        v18[n102] = bit32.bxor(v18[n102], 710428274)

                                        local n109 = bit32.band(n102, 4294967295)
                                        local n1092 = bit32.band(n109, 65535)

                                        v23 = bit32.band(n1092 * 777 + bit32.lshift(bit32.band(n1092 * 2731 + bit32.rshift(n109, 16) * 777, 65535), 16), 4294967295)

                                        local v232 = bit32.band(v23, 4294967295)
                                        local v2322 = bit32.band(v232, 65535)

                                        v24 = bit32.band(8288 * v2322 + bit32.lshift(bit32.band(8288 * bit32.rshift(v232, 16) + 9269 * v2322, 65535), 16), 4294967295)

                                        local v31 = bit32.band(n4 + 234815797, 4294967295)
                                        local v312 = bit32.band(v31, 65535)

                                        v25 = bit32.band(57248 * v312 + bit32.lshift(bit32.band(57248 * bit32.rshift(v31, 16) + 56266 * v312, 65535), 16), 4294967295)

                                        local n152 = bit32.band(n15, 4294967295)
                                        local n1522 = bit32.band(n152, 65535)
                                        local v32 = bit32.band(n1522 * 39241 + bit32.lshift(bit32.band(n1522 * 11780 + bit32.rshift(n152, 16) * 39241, 65535), 16), 4294967295)
                                        local v322 = bit32.band(v32, 65535)

                                        n16 = v24 + v25 + bit32.band(33441 * v322 + bit32.lshift(bit32.band(33441 * bit32.rshift(v32, 16) + 57687 * v322, 65535), 16), 4294967295)
                                        n17 = bit32.band(n15, 1021894526) + 3767498450

                                        local n153 = bit32.bnot(n15)
                                        local n1532 = bit32.band(n153, 65535)
                                        local v33 = bit32.band(n1532 * 39241 + bit32.lshift(bit32.band(n1532 * 11780 + bit32.rshift(n153, 16) * 39241, 65535), 16), 4294967295)
                                        local v332 = bit32.band(v33, 65535)

                                        v26 = bit32.band(33441 * v332 + bit32.lshift(bit32.band(33441 * bit32.rshift(v33, 16) + 57687 * v332, 65535), 16), 4294967295)

                                        local v233 = bit32.band(bit32.bnot(v23), 772053321)
                                        local v2332 = bit32.band(v233, 65535)

                                        n18 = n16 + n17 + v26 + bit32.band(16576 * v2332 + bit32.lshift(bit32.band(16576 * bit32.rshift(v233, 16) + 18538 * v2332, 65535), 16), 4294967295)
                                        n182 = bit32.band(n18, 2147483647)
                                        n183 = bit32.bnot(n182)

                                        local n185 = bit32.band(n183, 4294967295)
                                        local n1852 = bit32.band(n185, 65535)

                                        n19 = 3182185075 + bit32.band(9529 * n1852 + bit32.lshift(bit32.band(9529 * bit32.rshift(n185, 16) + 57046 * n1852, 65535), 16), 4294967295)

                                        local n186 = bit32.bor(n18, 2147483648)
                                        local n1862 = bit32.band(n186, 65535)

                                        n20 = n19 + 556391110 + bit32.band(9530 * n1862 + bit32.lshift(bit32.band(9530 * bit32.rshift(n186, 16) + 57046 * n1862, 65535), 16), 4294967295)

                                        local n187 = bit32.band(n183, 4294967295)
                                        local n1872 = bit32.band(n187, 65535)

                                        n184 = bit32.bor(n18, 2147483647)

                                        local v34 = bit32.band(n20 - 387049243 + bit32.band(59163 * n1872 + bit32.lshift(bit32.band(59163 * bit32.rshift(n187, 16) + 5905 * n1872, 65535), 16), 4294967295) + 6286554484, 4294967295)
                                        local v342 = bit32.band(v34, 65535)

                                        v27 = bit32.band(23936 * v342 + bit32.lshift(bit32.band(23936 * bit32.rshift(v34, 16) + 6375 * v342, 65535), 16), 4294967295)

                                        local n188 = bit32.band(n18, 4294967295)
                                        local n1882 = bit32.band(n188, 65535)
                                        local v35 = bit32.band(n1882 * 8260 + bit32.lshift(bit32.band(n1882 * 43443 + bit32.rshift(n188, 16) * 8260, 65535), 16), 4294967295)
                                        local v352 = bit32.band(v35, 65535)

                                        n21 = 3914064088 + bit32.band(45814 * v352 + bit32.lshift(bit32.band(45814 * bit32.rshift(v35, 16) + 26517 * v352, 65535), 16), 4294967295) + 1418712528

                                        local n189 = bit32.band(n182, 4294967295)
                                        local n1892 = bit32.band(n189, 65535)
                                        local v36 = bit32.band(n1892 * 8260 + bit32.lshift(bit32.band(n1892 * 43443 + bit32.rshift(n189, 16) * 8260, 65535), 16), 4294967295)
                                        local v362 = bit32.band(v36, 65535)

                                        n22 = n182 + bit32.band(19722 * v362 + bit32.lshift(bit32.band(19722 * bit32.rshift(v36, 16) + 39018 * v362, 65535), 16), 4294967295)

                                        local n1810 = bit32.band(n184, 4294967295)
                                        local n18102 = bit32.band(n1810, 65535)
                                        local v37 = bit32.band(n18102 * 8260 + bit32.lshift(bit32.band(n18102 * 43443 + bit32.rshift(n1810, 16) * 8260, 65535), 16), 4294967295)
                                        local v372 = bit32.band(v37, 65535)

                                        n4 = v27 + n21 + n22 + 0 + bit32.band(19722 * v372 + bit32.lshift(bit32.band(19722 * bit32.rshift(v37, 16) + 39018 * v372, 65535), 16), 4294967295)
                                    else
                                        break
                                    end
                                end

                                tbl3 = tbl5[2]

                                continue
                            end

                            v14 = arg[4]
                            n5 = 31
                            n6 = buffer.len(v14) - 31 - 23
                            n7 = n5 + 937457068 % n6

                            while true do
                                n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
                                v142 = buffer.readu16(v14, n7)
                                v143 = buffer.readi32(v14, n8)
                                v144 = bit32.lshift(bit32.band(v143, 255), 3)
                                v15 = bit32.band(bit32.bxor(bit32.bxor(380672267, v142) + v144 + 234815797, n7), 2147483647)
                                v145 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v142, v143), v15), 2147483647), 410902784)

                                buffer.writeu8(v14, n7, v145)

                                v152 = bit32.rshift(v15, 8)
                                v146 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v143, v152), n7), 2147483647), 1424731392)

                                buffer.writei8(v14, n8, v146)

                                n4 = v15
                                n7 = n5 + (n7 + bit32.band(v15, 63) + 1) % n6
                            end
                        else
                            flag3 = flag4
                            tbl3[2] = n9

                            if flag3 then
                                v18 = tbl4[n9]
                                tbl5 = {
                                    1,
                                    tbl3,
                                    nil,
                                    0,
                                    #v18 + 0,
                                }

                                while true do
                                    v19 = tbl5[1]
                                    v20 = tbl5[5]
                                    n10 = tbl5[4] + v19
                                    tbl5[4] = n10

                                    if n10 <= v20 then
                                        n102 = n10
                                        n42 = bit32.lshift(bit32.band(n4, n102), 1)

                                        local v153 = bit32.band(n4, 4294967295)
                                        local v1532 = bit32.band(v153, 65535)

                                        n11 = n42 + bit32.band(39632 * v1532 + bit32.lshift(bit32.band(39632 * bit32.rshift(v153, 16) + 10195 * v1532, 65535), 16), 4294967295)
                                        n103 = bit32.band(n102, n4)

                                        local n105 = bit32.band(n102, 4294967295)
                                        local n106 = bit32.band(n103, 4294967295)
                                        local n1052 = bit32.band(n105, 65535)
                                        local n1053 = bit32.rshift(n105, 16)
                                        local n1062 = bit32.band(n106, 65535)
                                        local v28 = bit32.band(n1052 * n1062 + bit32.lshift(bit32.band(n1052 * bit32.rshift(n106, 16) + n1053 * n1062, 65535), 16), 4294967295)
                                        local v282 = bit32.band(v28, 65535)

                                        v21 = bit32.band(42886 * v282 + bit32.lshift(bit32.band(42886 * bit32.rshift(v28, 16) + 18058 * v282, 65535), 16), 4294967295)

                                        local n107 = bit32.band(n102, 4294967295)
                                        local n1072 = bit32.band(n107, 65535)

                                        n12 = n11 + v21 + bit32.band(42887 * n1072 + bit32.lshift(bit32.band(42887 * bit32.rshift(n107, 16) + 18058 * n1072, 65535), 16), 4294967295)
                                        n43 = bit32.bnot(n4)
                                        n104 = bit32.bnot(n102)
                                        n44 = bit32.bor(n43, n104)

                                        local n108 = bit32.band(n102, 4294967295)
                                        local v154 = bit32.band(n44, 4294967295)
                                        local n1082 = bit32.band(n108, 65535)
                                        local n1083 = bit32.rshift(n108, 16)
                                        local v1542 = bit32.band(v154, 65535)
                                        local v29 = bit32.band(n1082 * v1542 + bit32.lshift(bit32.band(n1082 * bit32.rshift(v154, 16) + n1083 * v1542, 65535), 16), 4294967295)
                                        local v292 = bit32.band(v29, 65535)

                                        n13 = 668179153 + bit32.band(42886 * v292 + bit32.lshift(bit32.band(42886 * bit32.rshift(v29, 16) + 18058 * v292, 65535), 16), 4294967295)

                                        local v155 = bit32.band(n43, 4294967295)
                                        local v1552 = bit32.band(v155, 65535)

                                        v22 = bit32.band(39631 * v1552 + bit32.lshift(bit32.band(39631 * bit32.rshift(v155, 16) + 10195 * v1552, 65535), 16), 4294967295)

                                        local v156 = bit32.band(n44, 4294967295)
                                        local v1562 = bit32.band(v156, 65535)

                                        n14 = n12 + n13 + v22 + bit32.band(2 * v1562 + bit32.lshift(bit32.band(2 * bit32.rshift(v156, 16) + 0 * v1562, 65535), 16), 4294967295)

                                        local n142 = bit32.bor(n14, 2147483648)
                                        local n1422 = bit32.band(n142, 65535)
                                        local v30 = bit32.band(6104547510 + bit32.band(10611 * n1422 + bit32.lshift(bit32.band(10611 * bit32.rshift(n142, 16) + 2346 * n1422, 65535), 16), 4294967295), 4294967295)
                                        local v302 = bit32.band(v30, 65535)

                                        n15 = bit32.band(16295 * v302 + bit32.lshift(bit32.band(16295 * bit32.rshift(v30, 16) + 33254 * v302, 65535), 16), 4294967295) + 22185264754
                                        v18[n102] = bit32.bxor(v18[n102], 710428274)

                                        local n109 = bit32.band(n102, 4294967295)
                                        local n1092 = bit32.band(n109, 65535)

                                        v23 = bit32.band(n1092 * 777 + bit32.lshift(bit32.band(n1092 * 2731 + bit32.rshift(n109, 16) * 777, 65535), 16), 4294967295)

                                        local v232 = bit32.band(v23, 4294967295)
                                        local v2322 = bit32.band(v232, 65535)

                                        v24 = bit32.band(8288 * v2322 + bit32.lshift(bit32.band(8288 * bit32.rshift(v232, 16) + 9269 * v2322, 65535), 16), 4294967295)

                                        local v31 = bit32.band(n4 + 234815797, 4294967295)
                                        local v312 = bit32.band(v31, 65535)

                                        v25 = bit32.band(57248 * v312 + bit32.lshift(bit32.band(57248 * bit32.rshift(v31, 16) + 56266 * v312, 65535), 16), 4294967295)

                                        local n152 = bit32.band(n15, 4294967295)
                                        local n1522 = bit32.band(n152, 65535)
                                        local v32 = bit32.band(n1522 * 39241 + bit32.lshift(bit32.band(n1522 * 11780 + bit32.rshift(n152, 16) * 39241, 65535), 16), 4294967295)
                                        local v322 = bit32.band(v32, 65535)

                                        n16 = v24 + v25 + bit32.band(33441 * v322 + bit32.lshift(bit32.band(33441 * bit32.rshift(v32, 16) + 57687 * v322, 65535), 16), 4294967295)
                                        n17 = bit32.band(n15, 1021894526) + 3767498450

                                        local n153 = bit32.bnot(n15)
                                        local n1532 = bit32.band(n153, 65535)
                                        local v33 = bit32.band(n1532 * 39241 + bit32.lshift(bit32.band(n1532 * 11780 + bit32.rshift(n153, 16) * 39241, 65535), 16), 4294967295)
                                        local v332 = bit32.band(v33, 65535)

                                        v26 = bit32.band(33441 * v332 + bit32.lshift(bit32.band(33441 * bit32.rshift(v33, 16) + 57687 * v332, 65535), 16), 4294967295)

                                        local v233 = bit32.band(bit32.bnot(v23), 772053321)
                                        local v2332 = bit32.band(v233, 65535)

                                        n18 = n16 + n17 + v26 + bit32.band(16576 * v2332 + bit32.lshift(bit32.band(16576 * bit32.rshift(v233, 16) + 18538 * v2332, 65535), 16), 4294967295)
                                        n182 = bit32.band(n18, 2147483647)
                                        n183 = bit32.bnot(n182)

                                        local n185 = bit32.band(n183, 4294967295)
                                        local n1852 = bit32.band(n185, 65535)

                                        n19 = 3182185075 + bit32.band(9529 * n1852 + bit32.lshift(bit32.band(9529 * bit32.rshift(n185, 16) + 57046 * n1852, 65535), 16), 4294967295)

                                        local n186 = bit32.bor(n18, 2147483648)
                                        local n1862 = bit32.band(n186, 65535)

                                        n20 = n19 + 556391110 + bit32.band(9530 * n1862 + bit32.lshift(bit32.band(9530 * bit32.rshift(n186, 16) + 57046 * n1862, 65535), 16), 4294967295)

                                        local n187 = bit32.band(n183, 4294967295)
                                        local n1872 = bit32.band(n187, 65535)

                                        n184 = bit32.bor(n18, 2147483647)

                                        local v34 = bit32.band(n20 - 387049243 + bit32.band(59163 * n1872 + bit32.lshift(bit32.band(59163 * bit32.rshift(n187, 16) + 5905 * n1872, 65535), 16), 4294967295) + 6286554484, 4294967295)
                                        local v342 = bit32.band(v34, 65535)

                                        v27 = bit32.band(23936 * v342 + bit32.lshift(bit32.band(23936 * bit32.rshift(v34, 16) + 6375 * v342, 65535), 16), 4294967295)

                                        local n188 = bit32.band(n18, 4294967295)
                                        local n1882 = bit32.band(n188, 65535)
                                        local v35 = bit32.band(n1882 * 8260 + bit32.lshift(bit32.band(n1882 * 43443 + bit32.rshift(n188, 16) * 8260, 65535), 16), 4294967295)
                                        local v352 = bit32.band(v35, 65535)

                                        n21 = 3914064088 + bit32.band(45814 * v352 + bit32.lshift(bit32.band(45814 * bit32.rshift(v35, 16) + 26517 * v352, 65535), 16), 4294967295) + 1418712528

                                        local n189 = bit32.band(n182, 4294967295)
                                        local n1892 = bit32.band(n189, 65535)
                                        local v36 = bit32.band(n1892 * 8260 + bit32.lshift(bit32.band(n1892 * 43443 + bit32.rshift(n189, 16) * 8260, 65535), 16), 4294967295)
                                        local v362 = bit32.band(v36, 65535)

                                        n22 = n182 + bit32.band(19722 * v362 + bit32.lshift(bit32.band(19722 * bit32.rshift(v36, 16) + 39018 * v362, 65535), 16), 4294967295)

                                        local n1810 = bit32.band(n184, 4294967295)
                                        local n18102 = bit32.band(n1810, 65535)
                                        local v37 = bit32.band(n18102 * 8260 + bit32.lshift(bit32.band(n18102 * 43443 + bit32.rshift(n1810, 16) * 8260, 65535), 16), 4294967295)
                                        local v372 = bit32.band(v37, 65535)

                                        n4 = v27 + n21 + n22 + 0 + bit32.band(19722 * v372 + bit32.lshift(bit32.band(19722 * bit32.rshift(v37, 16) + 39018 * v372, 65535), 16), 4294967295)
                                    else
                                        break
                                    end
                                end

                                tbl3 = tbl5[2]

                                continue
                            end

                            v14 = arg[4]
                            n5 = 31
                            n6 = buffer.len(v14) - 31 - 23
                            n7 = n5 + 937457068 % n6

                            while true do
                                n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
                                v142 = buffer.readu16(v14, n7)
                                v143 = buffer.readi32(v14, n8)
                                v144 = bit32.lshift(bit32.band(v143, 255), 3)
                                v15 = bit32.band(bit32.bxor(bit32.bxor(380672267, v142) + v144 + 234815797, n7), 2147483647)
                                v145 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v142, v143), v15), 2147483647), 410902784)

                                buffer.writeu8(v14, n7, v145)

                                v152 = bit32.rshift(v15, 8)
                                v146 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v143, v152), n7), 2147483647), 1424731392)

                                buffer.writei8(v14, n8, v146)

                                n4 = v15
                                n7 = n5 + (n7 + bit32.band(v15, 63) + 1) % n6
                            end
                        end
                    end
                else
                    flag3 = flag

                    if flag2 then
                        if not flag3 then
                            flag3 = flag4
                            tbl3[2] = n9

                            if flag3 then
                                v18 = tbl4[n9]
                                tbl5 = {
                                    1,
                                    tbl3,
                                    nil,
                                    0,
                                    #v18 + 0,
                                }

                                while true do
                                    v19 = tbl5[1]
                                    v20 = tbl5[5]
                                    n10 = tbl5[4] + v19
                                    tbl5[4] = n10

                                    if n10 <= v20 then
                                        n102 = n10
                                        n42 = bit32.lshift(bit32.band(n4, n102), 1)

                                        local v153 = bit32.band(n4, 4294967295)
                                        local v1532 = bit32.band(v153, 65535)

                                        n11 = n42 + bit32.band(39632 * v1532 + bit32.lshift(bit32.band(39632 * bit32.rshift(v153, 16) + 10195 * v1532, 65535), 16), 4294967295)
                                        n103 = bit32.band(n102, n4)

                                        local n105 = bit32.band(n102, 4294967295)
                                        local n106 = bit32.band(n103, 4294967295)
                                        local n1052 = bit32.band(n105, 65535)
                                        local n1053 = bit32.rshift(n105, 16)
                                        local n1062 = bit32.band(n106, 65535)
                                        local v28 = bit32.band(n1052 * n1062 + bit32.lshift(bit32.band(n1052 * bit32.rshift(n106, 16) + n1053 * n1062, 65535), 16), 4294967295)
                                        local v282 = bit32.band(v28, 65535)

                                        v21 = bit32.band(42886 * v282 + bit32.lshift(bit32.band(42886 * bit32.rshift(v28, 16) + 18058 * v282, 65535), 16), 4294967295)

                                        local n107 = bit32.band(n102, 4294967295)
                                        local n1072 = bit32.band(n107, 65535)

                                        n12 = n11 + v21 + bit32.band(42887 * n1072 + bit32.lshift(bit32.band(42887 * bit32.rshift(n107, 16) + 18058 * n1072, 65535), 16), 4294967295)
                                        n43 = bit32.bnot(n4)
                                        n104 = bit32.bnot(n102)
                                        n44 = bit32.bor(n43, n104)

                                        local n108 = bit32.band(n102, 4294967295)
                                        local v154 = bit32.band(n44, 4294967295)
                                        local n1082 = bit32.band(n108, 65535)
                                        local n1083 = bit32.rshift(n108, 16)
                                        local v1542 = bit32.band(v154, 65535)
                                        local v29 = bit32.band(n1082 * v1542 + bit32.lshift(bit32.band(n1082 * bit32.rshift(v154, 16) + n1083 * v1542, 65535), 16), 4294967295)
                                        local v292 = bit32.band(v29, 65535)

                                        n13 = 668179153 + bit32.band(42886 * v292 + bit32.lshift(bit32.band(42886 * bit32.rshift(v29, 16) + 18058 * v292, 65535), 16), 4294967295)

                                        local v155 = bit32.band(n43, 4294967295)
                                        local v1552 = bit32.band(v155, 65535)

                                        v22 = bit32.band(39631 * v1552 + bit32.lshift(bit32.band(39631 * bit32.rshift(v155, 16) + 10195 * v1552, 65535), 16), 4294967295)

                                        local v156 = bit32.band(n44, 4294967295)
                                        local v1562 = bit32.band(v156, 65535)

                                        n14 = n12 + n13 + v22 + bit32.band(2 * v1562 + bit32.lshift(bit32.band(2 * bit32.rshift(v156, 16) + 0 * v1562, 65535), 16), 4294967295)

                                        local n142 = bit32.bor(n14, 2147483648)
                                        local n1422 = bit32.band(n142, 65535)
                                        local v30 = bit32.band(6104547510 + bit32.band(10611 * n1422 + bit32.lshift(bit32.band(10611 * bit32.rshift(n142, 16) + 2346 * n1422, 65535), 16), 4294967295), 4294967295)
                                        local v302 = bit32.band(v30, 65535)

                                        n15 = bit32.band(16295 * v302 + bit32.lshift(bit32.band(16295 * bit32.rshift(v30, 16) + 33254 * v302, 65535), 16), 4294967295) + 22185264754
                                        v18[n102] = bit32.bxor(v18[n102], 710428274)

                                        local n109 = bit32.band(n102, 4294967295)
                                        local n1092 = bit32.band(n109, 65535)

                                        v23 = bit32.band(n1092 * 777 + bit32.lshift(bit32.band(n1092 * 2731 + bit32.rshift(n109, 16) * 777, 65535), 16), 4294967295)

                                        local v232 = bit32.band(v23, 4294967295)
                                        local v2322 = bit32.band(v232, 65535)

                                        v24 = bit32.band(8288 * v2322 + bit32.lshift(bit32.band(8288 * bit32.rshift(v232, 16) + 9269 * v2322, 65535), 16), 4294967295)

                                        local v31 = bit32.band(n4 + 234815797, 4294967295)
                                        local v312 = bit32.band(v31, 65535)

                                        v25 = bit32.band(57248 * v312 + bit32.lshift(bit32.band(57248 * bit32.rshift(v31, 16) + 56266 * v312, 65535), 16), 4294967295)

                                        local n152 = bit32.band(n15, 4294967295)
                                        local n1522 = bit32.band(n152, 65535)
                                        local v32 = bit32.band(n1522 * 39241 + bit32.lshift(bit32.band(n1522 * 11780 + bit32.rshift(n152, 16) * 39241, 65535), 16), 4294967295)
                                        local v322 = bit32.band(v32, 65535)

                                        n16 = v24 + v25 + bit32.band(33441 * v322 + bit32.lshift(bit32.band(33441 * bit32.rshift(v32, 16) + 57687 * v322, 65535), 16), 4294967295)
                                        n17 = bit32.band(n15, 1021894526) + 3767498450

                                        local n153 = bit32.bnot(n15)
                                        local n1532 = bit32.band(n153, 65535)
                                        local v33 = bit32.band(n1532 * 39241 + bit32.lshift(bit32.band(n1532 * 11780 + bit32.rshift(n153, 16) * 39241, 65535), 16), 4294967295)
                                        local v332 = bit32.band(v33, 65535)

                                        v26 = bit32.band(33441 * v332 + bit32.lshift(bit32.band(33441 * bit32.rshift(v33, 16) + 57687 * v332, 65535), 16), 4294967295)

                                        local v233 = bit32.band(bit32.bnot(v23), 772053321)
                                        local v2332 = bit32.band(v233, 65535)

                                        n18 = n16 + n17 + v26 + bit32.band(16576 * v2332 + bit32.lshift(bit32.band(16576 * bit32.rshift(v233, 16) + 18538 * v2332, 65535), 16), 4294967295)
                                        n182 = bit32.band(n18, 2147483647)
                                        n183 = bit32.bnot(n182)

                                        local n185 = bit32.band(n183, 4294967295)
                                        local n1852 = bit32.band(n185, 65535)

                                        n19 = 3182185075 + bit32.band(9529 * n1852 + bit32.lshift(bit32.band(9529 * bit32.rshift(n185, 16) + 57046 * n1852, 65535), 16), 4294967295)

                                        local n186 = bit32.bor(n18, 2147483648)
                                        local n1862 = bit32.band(n186, 65535)

                                        n20 = n19 + 556391110 + bit32.band(9530 * n1862 + bit32.lshift(bit32.band(9530 * bit32.rshift(n186, 16) + 57046 * n1862, 65535), 16), 4294967295)

                                        local n187 = bit32.band(n183, 4294967295)
                                        local n1872 = bit32.band(n187, 65535)

                                        n184 = bit32.bor(n18, 2147483647)

                                        local v34 = bit32.band(n20 - 387049243 + bit32.band(59163 * n1872 + bit32.lshift(bit32.band(59163 * bit32.rshift(n187, 16) + 5905 * n1872, 65535), 16), 4294967295) + 6286554484, 4294967295)
                                        local v342 = bit32.band(v34, 65535)

                                        v27 = bit32.band(23936 * v342 + bit32.lshift(bit32.band(23936 * bit32.rshift(v34, 16) + 6375 * v342, 65535), 16), 4294967295)

                                        local n188 = bit32.band(n18, 4294967295)
                                        local n1882 = bit32.band(n188, 65535)
                                        local v35 = bit32.band(n1882 * 8260 + bit32.lshift(bit32.band(n1882 * 43443 + bit32.rshift(n188, 16) * 8260, 65535), 16), 4294967295)
                                        local v352 = bit32.band(v35, 65535)

                                        n21 = 3914064088 + bit32.band(45814 * v352 + bit32.lshift(bit32.band(45814 * bit32.rshift(v35, 16) + 26517 * v352, 65535), 16), 4294967295) + 1418712528

                                        local n189 = bit32.band(n182, 4294967295)
                                        local n1892 = bit32.band(n189, 65535)
                                        local v36 = bit32.band(n1892 * 8260 + bit32.lshift(bit32.band(n1892 * 43443 + bit32.rshift(n189, 16) * 8260, 65535), 16), 4294967295)
                                        local v362 = bit32.band(v36, 65535)

                                        n22 = n182 + bit32.band(19722 * v362 + bit32.lshift(bit32.band(19722 * bit32.rshift(v36, 16) + 39018 * v362, 65535), 16), 4294967295)

                                        local n1810 = bit32.band(n184, 4294967295)
                                        local n18102 = bit32.band(n1810, 65535)
                                        local v37 = bit32.band(n18102 * 8260 + bit32.lshift(bit32.band(n18102 * 43443 + bit32.rshift(n1810, 16) * 8260, 65535), 16), 4294967295)
                                        local v372 = bit32.band(v37, 65535)

                                        n4 = v27 + n21 + n22 + 0 + bit32.band(19722 * v372 + bit32.lshift(bit32.band(19722 * bit32.rshift(v37, 16) + 39018 * v372, 65535), 16), 4294967295)
                                    else
                                        break
                                    end
                                end

                                tbl3 = tbl5[2]

                                continue
                            end

                            break
                        end

                        tbl3[2] = n9

                        if flag3 then
                            v18 = tbl4[n9]
                            tbl5 = {
                                1,
                                tbl3,
                                nil,
                                0,
                                #v18 + 0,
                            }

                            while true do
                                v19 = tbl5[1]
                                v20 = tbl5[5]
                                n10 = tbl5[4] + v19
                                tbl5[4] = n10

                                if n10 <= v20 then
                                    n102 = n10
                                    n42 = bit32.lshift(bit32.band(n4, n102), 1)

                                    local n45 = bit32.band(n4, 4294967295)
                                    local n452 = bit32.band(n45, 65535)

                                    n11 = n42 + bit32.band(39632 * n452 + bit32.lshift(bit32.band(39632 * bit32.rshift(n45, 16) + 10195 * n452, 65535), 16), 4294967295)
                                    n103 = bit32.band(n102, n4)

                                    local n105 = bit32.band(n102, 4294967295)
                                    local n106 = bit32.band(n103, 4294967295)
                                    local n1052 = bit32.band(n105, 65535)
                                    local n1053 = bit32.rshift(n105, 16)
                                    local n1062 = bit32.band(n106, 65535)
                                    local v28 = bit32.band(n1052 * n1062 + bit32.lshift(bit32.band(n1052 * bit32.rshift(n106, 16) + n1053 * n1062, 65535), 16), 4294967295)
                                    local v282 = bit32.band(v28, 65535)

                                    v21 = bit32.band(42886 * v282 + bit32.lshift(bit32.band(42886 * bit32.rshift(v28, 16) + 18058 * v282, 65535), 16), 4294967295)

                                    local n107 = bit32.band(n102, 4294967295)
                                    local n1072 = bit32.band(n107, 65535)

                                    n12 = n11 + v21 + bit32.band(42887 * n1072 + bit32.lshift(bit32.band(42887 * bit32.rshift(n107, 16) + 18058 * n1072, 65535), 16), 4294967295)
                                    n43 = bit32.bnot(n4)
                                    n104 = bit32.bnot(n102)
                                    n44 = bit32.bor(n43, n104)

                                    local n108 = bit32.band(n102, 4294967295)
                                    local n46 = bit32.band(n44, 4294967295)
                                    local n1082 = bit32.band(n108, 65535)
                                    local n1083 = bit32.rshift(n108, 16)
                                    local n462 = bit32.band(n46, 65535)
                                    local v29 = bit32.band(n1082 * n462 + bit32.lshift(bit32.band(n1082 * bit32.rshift(n46, 16) + n1083 * n462, 65535), 16), 4294967295)
                                    local v292 = bit32.band(v29, 65535)

                                    n13 = 668179153 + bit32.band(42886 * v292 + bit32.lshift(bit32.band(42886 * bit32.rshift(v29, 16) + 18058 * v292, 65535), 16), 4294967295)

                                    local n47 = bit32.band(n43, 4294967295)
                                    local n472 = bit32.band(n47, 65535)

                                    v22 = bit32.band(39631 * n472 + bit32.lshift(bit32.band(39631 * bit32.rshift(n47, 16) + 10195 * n472, 65535), 16), 4294967295)

                                    local n48 = bit32.band(n44, 4294967295)
                                    local n482 = bit32.band(n48, 65535)

                                    n14 = n12 + n13 + v22 + bit32.band(2 * n482 + bit32.lshift(bit32.band(2 * bit32.rshift(n48, 16) + 0 * n482, 65535), 16), 4294967295)

                                    local n142 = bit32.bor(n14, 2147483648)
                                    local n1422 = bit32.band(n142, 65535)
                                    local v30 = bit32.band(6104547510 + bit32.band(10611 * n1422 + bit32.lshift(bit32.band(10611 * bit32.rshift(n142, 16) + 2346 * n1422, 65535), 16), 4294967295), 4294967295)
                                    local v302 = bit32.band(v30, 65535)

                                    n15 = bit32.band(16295 * v302 + bit32.lshift(bit32.band(16295 * bit32.rshift(v30, 16) + 33254 * v302, 65535), 16), 4294967295) + 22185264754
                                    v18[n102] = bit32.bxor(v18[n102], 710428274)

                                    local n109 = bit32.band(n102, 4294967295)
                                    local n1092 = bit32.band(n109, 65535)

                                    v23 = bit32.band(n1092 * 777 + bit32.lshift(bit32.band(n1092 * 2731 + bit32.rshift(n109, 16) * 777, 65535), 16), 4294967295)

                                    local v232 = bit32.band(v23, 4294967295)
                                    local v2322 = bit32.band(v232, 65535)

                                    v24 = bit32.band(8288 * v2322 + bit32.lshift(bit32.band(8288 * bit32.rshift(v232, 16) + 9269 * v2322, 65535), 16), 4294967295)

                                    local v31 = bit32.band(n4 + 234815797, 4294967295)
                                    local v312 = bit32.band(v31, 65535)

                                    v25 = bit32.band(57248 * v312 + bit32.lshift(bit32.band(57248 * bit32.rshift(v31, 16) + 56266 * v312, 65535), 16), 4294967295)

                                    local n152 = bit32.band(n15, 4294967295)
                                    local n1522 = bit32.band(n152, 65535)
                                    local v32 = bit32.band(n1522 * 39241 + bit32.lshift(bit32.band(n1522 * 11780 + bit32.rshift(n152, 16) * 39241, 65535), 16), 4294967295)
                                    local v322 = bit32.band(v32, 65535)

                                    n16 = v24 + v25 + bit32.band(33441 * v322 + bit32.lshift(bit32.band(33441 * bit32.rshift(v32, 16) + 57687 * v322, 65535), 16), 4294967295)
                                    n17 = bit32.band(n15, 1021894526) + 3767498450

                                    local n153 = bit32.bnot(n15)
                                    local n1532 = bit32.band(n153, 65535)
                                    local v33 = bit32.band(n1532 * 39241 + bit32.lshift(bit32.band(n1532 * 11780 + bit32.rshift(n153, 16) * 39241, 65535), 16), 4294967295)
                                    local v332 = bit32.band(v33, 65535)

                                    v26 = bit32.band(33441 * v332 + bit32.lshift(bit32.band(33441 * bit32.rshift(v33, 16) + 57687 * v332, 65535), 16), 4294967295)

                                    local v233 = bit32.band(bit32.bnot(v23), 772053321)
                                    local v2332 = bit32.band(v233, 65535)

                                    n18 = n16 + n17 + v26 + bit32.band(16576 * v2332 + bit32.lshift(bit32.band(16576 * bit32.rshift(v233, 16) + 18538 * v2332, 65535), 16), 4294967295)
                                    n182 = bit32.band(n18, 2147483647)
                                    n183 = bit32.bnot(n182)

                                    local n185 = bit32.band(n183, 4294967295)
                                    local n1852 = bit32.band(n185, 65535)

                                    n19 = 3182185075 + bit32.band(9529 * n1852 + bit32.lshift(bit32.band(9529 * bit32.rshift(n185, 16) + 57046 * n1852, 65535), 16), 4294967295)

                                    local n186 = bit32.bor(n18, 2147483648)
                                    local n1862 = bit32.band(n186, 65535)

                                    n20 = n19 + 556391110 + bit32.band(9530 * n1862 + bit32.lshift(bit32.band(9530 * bit32.rshift(n186, 16) + 57046 * n1862, 65535), 16), 4294967295)

                                    local n187 = bit32.band(n183, 4294967295)
                                    local n1872 = bit32.band(n187, 65535)

                                    n184 = bit32.bor(n18, 2147483647)

                                    local v34 = bit32.band(n20 - 387049243 + bit32.band(59163 * n1872 + bit32.lshift(bit32.band(59163 * bit32.rshift(n187, 16) + 5905 * n1872, 65535), 16), 4294967295) + 6286554484, 4294967295)
                                    local v342 = bit32.band(v34, 65535)

                                    v27 = bit32.band(23936 * v342 + bit32.lshift(bit32.band(23936 * bit32.rshift(v34, 16) + 6375 * v342, 65535), 16), 4294967295)

                                    local n188 = bit32.band(n18, 4294967295)
                                    local n1882 = bit32.band(n188, 65535)
                                    local v35 = bit32.band(n1882 * 8260 + bit32.lshift(bit32.band(n1882 * 43443 + bit32.rshift(n188, 16) * 8260, 65535), 16), 4294967295)
                                    local v352 = bit32.band(v35, 65535)

                                    n21 = 3914064088 + bit32.band(45814 * v352 + bit32.lshift(bit32.band(45814 * bit32.rshift(v35, 16) + 26517 * v352, 65535), 16), 4294967295) + 1418712528

                                    local n189 = bit32.band(n182, 4294967295)
                                    local n1892 = bit32.band(n189, 65535)
                                    local v36 = bit32.band(n1892 * 8260 + bit32.lshift(bit32.band(n1892 * 43443 + bit32.rshift(n189, 16) * 8260, 65535), 16), 4294967295)
                                    local v362 = bit32.band(v36, 65535)

                                    n22 = n182 + bit32.band(19722 * v362 + bit32.lshift(bit32.band(19722 * bit32.rshift(v36, 16) + 39018 * v362, 65535), 16), 4294967295)

                                    local n1810 = bit32.band(n184, 4294967295)
                                    local n18102 = bit32.band(n1810, 65535)
                                    local v37 = bit32.band(n18102 * 8260 + bit32.lshift(bit32.band(n18102 * 43443 + bit32.rshift(n1810, 16) * 8260, 65535), 16), 4294967295)
                                    local v372 = bit32.band(v37, 65535)

                                    n4 = v27 + n21 + n22 + 0 + bit32.band(19722 * v372 + bit32.lshift(bit32.band(19722 * bit32.rshift(v37, 16) + 39018 * v372, 65535), 16), 4294967295)
                                else
                                    break
                                end
                            end

                            tbl3 = tbl5[2]

                            continue
                        end

                        v14 = arg[4]
                        n5 = 31
                        n6 = buffer.len(v14) - 31 - 23
                        n7 = n5 + 937457068 % n6

                        while true do
                            n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
                            v142 = buffer.readu16(v14, n7)
                            v143 = buffer.readi32(v14, n8)
                            v144 = bit32.lshift(bit32.band(v143, 255), 3)
                            v15 = bit32.band(bit32.bxor(bit32.bxor(380672267, v142) + v144 + 234815797, n7), 2147483647)
                            v145 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v142, v143), v15), 2147483647), 410902784)

                            buffer.writeu8(v14, n7, v145)

                            v152 = bit32.rshift(v15, 8)
                            v146 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v143, v152), n7), 2147483647), 1424731392)

                            buffer.writei8(v14, n8, v146)

                            n4 = v15
                            n7 = n5 + (n7 + bit32.band(v15, 63) + 1) % n6
                        end
                    end
                end

                flag4 = flag2

                if flag3 then
                    tbl3[2] = n9

                    if flag3 then
                        v18 = tbl4[n9]
                        tbl5 = {
                            1,
                            tbl3,
                            nil,
                            0,
                            #v18 + 0,
                        }

                        while true do
                            v19 = tbl5[1]
                            v20 = tbl5[5]
                            n10 = tbl5[4] + v19
                            tbl5[4] = n10

                            if n10 <= v20 then
                                n102 = n10
                                n42 = bit32.lshift(bit32.band(n4, n102), 1)

                                local v153 = bit32.band(n4, 4294967295)
                                local v1532 = bit32.band(v153, 65535)

                                n11 = n42 + bit32.band(39632 * v1532 + bit32.lshift(bit32.band(39632 * bit32.rshift(v153, 16) + 10195 * v1532, 65535), 16), 4294967295)
                                n103 = bit32.band(n102, n4)

                                local n105 = bit32.band(n102, 4294967295)
                                local n106 = bit32.band(n103, 4294967295)
                                local n1052 = bit32.band(n105, 65535)
                                local n1053 = bit32.rshift(n105, 16)
                                local n1062 = bit32.band(n106, 65535)
                                local v28 = bit32.band(n1052 * n1062 + bit32.lshift(bit32.band(n1052 * bit32.rshift(n106, 16) + n1053 * n1062, 65535), 16), 4294967295)
                                local v282 = bit32.band(v28, 65535)

                                v21 = bit32.band(42886 * v282 + bit32.lshift(bit32.band(42886 * bit32.rshift(v28, 16) + 18058 * v282, 65535), 16), 4294967295)

                                local n107 = bit32.band(n102, 4294967295)
                                local n1072 = bit32.band(n107, 65535)

                                n12 = n11 + v21 + bit32.band(42887 * n1072 + bit32.lshift(bit32.band(42887 * bit32.rshift(n107, 16) + 18058 * n1072, 65535), 16), 4294967295)
                                n43 = bit32.bnot(n4)
                                n104 = bit32.bnot(n102)
                                n44 = bit32.bor(n43, n104)

                                local n108 = bit32.band(n102, 4294967295)
                                local v154 = bit32.band(n44, 4294967295)
                                local n1082 = bit32.band(n108, 65535)
                                local n1083 = bit32.rshift(n108, 16)
                                local v1542 = bit32.band(v154, 65535)
                                local v29 = bit32.band(n1082 * v1542 + bit32.lshift(bit32.band(n1082 * bit32.rshift(v154, 16) + n1083 * v1542, 65535), 16), 4294967295)
                                local v292 = bit32.band(v29, 65535)

                                n13 = 668179153 + bit32.band(42886 * v292 + bit32.lshift(bit32.band(42886 * bit32.rshift(v29, 16) + 18058 * v292, 65535), 16), 4294967295)

                                local v155 = bit32.band(n43, 4294967295)
                                local v1552 = bit32.band(v155, 65535)

                                v22 = bit32.band(39631 * v1552 + bit32.lshift(bit32.band(39631 * bit32.rshift(v155, 16) + 10195 * v1552, 65535), 16), 4294967295)

                                local v156 = bit32.band(n44, 4294967295)
                                local v1562 = bit32.band(v156, 65535)

                                n14 = n12 + n13 + v22 + bit32.band(2 * v1562 + bit32.lshift(bit32.band(2 * bit32.rshift(v156, 16) + 0 * v1562, 65535), 16), 4294967295)

                                local n142 = bit32.bor(n14, 2147483648)
                                local n1422 = bit32.band(n142, 65535)
                                local v30 = bit32.band(6104547510 + bit32.band(10611 * n1422 + bit32.lshift(bit32.band(10611 * bit32.rshift(n142, 16) + 2346 * n1422, 65535), 16), 4294967295), 4294967295)
                                local v302 = bit32.band(v30, 65535)

                                n15 = bit32.band(16295 * v302 + bit32.lshift(bit32.band(16295 * bit32.rshift(v30, 16) + 33254 * v302, 65535), 16), 4294967295) + 22185264754
                                v18[n102] = bit32.bxor(v18[n102], 710428274)

                                local n109 = bit32.band(n102, 4294967295)
                                local n1092 = bit32.band(n109, 65535)

                                v23 = bit32.band(n1092 * 777 + bit32.lshift(bit32.band(n1092 * 2731 + bit32.rshift(n109, 16) * 777, 65535), 16), 4294967295)

                                local v232 = bit32.band(v23, 4294967295)
                                local v2322 = bit32.band(v232, 65535)

                                v24 = bit32.band(8288 * v2322 + bit32.lshift(bit32.band(8288 * bit32.rshift(v232, 16) + 9269 * v2322, 65535), 16), 4294967295)

                                local v31 = bit32.band(n4 + 234815797, 4294967295)
                                local v312 = bit32.band(v31, 65535)

                                v25 = bit32.band(57248 * v312 + bit32.lshift(bit32.band(57248 * bit32.rshift(v31, 16) + 56266 * v312, 65535), 16), 4294967295)

                                local n152 = bit32.band(n15, 4294967295)
                                local n1522 = bit32.band(n152, 65535)
                                local v32 = bit32.band(n1522 * 39241 + bit32.lshift(bit32.band(n1522 * 11780 + bit32.rshift(n152, 16) * 39241, 65535), 16), 4294967295)
                                local v322 = bit32.band(v32, 65535)

                                n16 = v24 + v25 + bit32.band(33441 * v322 + bit32.lshift(bit32.band(33441 * bit32.rshift(v32, 16) + 57687 * v322, 65535), 16), 4294967295)
                                n17 = bit32.band(n15, 1021894526) + 3767498450

                                local n153 = bit32.bnot(n15)
                                local n1532 = bit32.band(n153, 65535)
                                local v33 = bit32.band(n1532 * 39241 + bit32.lshift(bit32.band(n1532 * 11780 + bit32.rshift(n153, 16) * 39241, 65535), 16), 4294967295)
                                local v332 = bit32.band(v33, 65535)

                                v26 = bit32.band(33441 * v332 + bit32.lshift(bit32.band(33441 * bit32.rshift(v33, 16) + 57687 * v332, 65535), 16), 4294967295)

                                local v233 = bit32.band(bit32.bnot(v23), 772053321)
                                local v2332 = bit32.band(v233, 65535)

                                n18 = n16 + n17 + v26 + bit32.band(16576 * v2332 + bit32.lshift(bit32.band(16576 * bit32.rshift(v233, 16) + 18538 * v2332, 65535), 16), 4294967295)
                                n182 = bit32.band(n18, 2147483647)
                                n183 = bit32.bnot(n182)

                                local n185 = bit32.band(n183, 4294967295)
                                local n1852 = bit32.band(n185, 65535)

                                n19 = 3182185075 + bit32.band(9529 * n1852 + bit32.lshift(bit32.band(9529 * bit32.rshift(n185, 16) + 57046 * n1852, 65535), 16), 4294967295)

                                local n186 = bit32.bor(n18, 2147483648)
                                local n1862 = bit32.band(n186, 65535)

                                n20 = n19 + 556391110 + bit32.band(9530 * n1862 + bit32.lshift(bit32.band(9530 * bit32.rshift(n186, 16) + 57046 * n1862, 65535), 16), 4294967295)

                                local n187 = bit32.band(n183, 4294967295)
                                local n1872 = bit32.band(n187, 65535)

                                n184 = bit32.bor(n18, 2147483647)

                                local v34 = bit32.band(n20 - 387049243 + bit32.band(59163 * n1872 + bit32.lshift(bit32.band(59163 * bit32.rshift(n187, 16) + 5905 * n1872, 65535), 16), 4294967295) + 6286554484, 4294967295)
                                local v342 = bit32.band(v34, 65535)

                                v27 = bit32.band(23936 * v342 + bit32.lshift(bit32.band(23936 * bit32.rshift(v34, 16) + 6375 * v342, 65535), 16), 4294967295)

                                local n188 = bit32.band(n18, 4294967295)
                                local n1882 = bit32.band(n188, 65535)
                                local v35 = bit32.band(n1882 * 8260 + bit32.lshift(bit32.band(n1882 * 43443 + bit32.rshift(n188, 16) * 8260, 65535), 16), 4294967295)
                                local v352 = bit32.band(v35, 65535)

                                n21 = 3914064088 + bit32.band(45814 * v352 + bit32.lshift(bit32.band(45814 * bit32.rshift(v35, 16) + 26517 * v352, 65535), 16), 4294967295) + 1418712528

                                local n189 = bit32.band(n182, 4294967295)
                                local n1892 = bit32.band(n189, 65535)
                                local v36 = bit32.band(n1892 * 8260 + bit32.lshift(bit32.band(n1892 * 43443 + bit32.rshift(n189, 16) * 8260, 65535), 16), 4294967295)
                                local v362 = bit32.band(v36, 65535)

                                n22 = n182 + bit32.band(19722 * v362 + bit32.lshift(bit32.band(19722 * bit32.rshift(v36, 16) + 39018 * v362, 65535), 16), 4294967295)

                                local n1810 = bit32.band(n184, 4294967295)
                                local n18102 = bit32.band(n1810, 65535)
                                local v37 = bit32.band(n18102 * 8260 + bit32.lshift(bit32.band(n18102 * 43443 + bit32.rshift(n1810, 16) * 8260, 65535), 16), 4294967295)
                                local v372 = bit32.band(v37, 65535)

                                n4 = v27 + n21 + n22 + 0 + bit32.band(19722 * v372 + bit32.lshift(bit32.band(19722 * bit32.rshift(v37, 16) + 39018 * v372, 65535), 16), 4294967295)
                            else
                                break
                            end
                        end

                        tbl3 = tbl5[2]

                        continue
                    end

                    v14 = arg[4]
                    n5 = 31
                    n6 = buffer.len(v14) - 31 - 23
                    n7 = n5 + 937457068 % n6

                    while true do
                        n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
                        v142 = buffer.readu16(v14, n7)
                        v143 = buffer.readi32(v14, n8)
                        v144 = bit32.lshift(bit32.band(v143, 255), 3)
                        v15 = bit32.band(bit32.bxor(bit32.bxor(380672267, v142) + v144 + 234815797, n7), 2147483647)
                        v145 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v142, v143), v15), 2147483647), 410902784)

                        buffer.writeu8(v14, n7, v145)

                        v152 = bit32.rshift(v15, 8)
                        v146 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v143, v152), n7), 2147483647), 1424731392)

                        buffer.writei8(v14, n8, v146)

                        n4 = v15
                        n7 = n5 + (n7 + bit32.band(v15, 63) + 1) % n6
                    end
                else
                    flag3 = flag4
                    tbl3[2] = n9

                    if flag3 then
                        v18 = tbl4[n9]
                        tbl5 = {
                            1,
                            tbl3,
                            nil,
                            0,
                            #v18 + 0,
                        }

                        while true do
                            v19 = tbl5[1]
                            v20 = tbl5[5]
                            n10 = tbl5[4] + v19
                            tbl5[4] = n10

                            if n10 <= v20 then
                                n102 = n10
                                n42 = bit32.lshift(bit32.band(n4, n102), 1)

                                local v153 = bit32.band(n4, 4294967295)
                                local v1532 = bit32.band(v153, 65535)

                                n11 = n42 + bit32.band(39632 * v1532 + bit32.lshift(bit32.band(39632 * bit32.rshift(v153, 16) + 10195 * v1532, 65535), 16), 4294967295)
                                n103 = bit32.band(n102, n4)

                                local n105 = bit32.band(n102, 4294967295)
                                local n106 = bit32.band(n103, 4294967295)
                                local n1052 = bit32.band(n105, 65535)
                                local n1053 = bit32.rshift(n105, 16)
                                local n1062 = bit32.band(n106, 65535)
                                local v28 = bit32.band(n1052 * n1062 + bit32.lshift(bit32.band(n1052 * bit32.rshift(n106, 16) + n1053 * n1062, 65535), 16), 4294967295)
                                local v282 = bit32.band(v28, 65535)

                                v21 = bit32.band(42886 * v282 + bit32.lshift(bit32.band(42886 * bit32.rshift(v28, 16) + 18058 * v282, 65535), 16), 4294967295)

                                local n107 = bit32.band(n102, 4294967295)
                                local n1072 = bit32.band(n107, 65535)

                                n12 = n11 + v21 + bit32.band(42887 * n1072 + bit32.lshift(bit32.band(42887 * bit32.rshift(n107, 16) + 18058 * n1072, 65535), 16), 4294967295)
                                n43 = bit32.bnot(n4)
                                n104 = bit32.bnot(n102)
                                n44 = bit32.bor(n43, n104)

                                local n108 = bit32.band(n102, 4294967295)
                                local v154 = bit32.band(n44, 4294967295)
                                local n1082 = bit32.band(n108, 65535)
                                local n1083 = bit32.rshift(n108, 16)
                                local v1542 = bit32.band(v154, 65535)
                                local v29 = bit32.band(n1082 * v1542 + bit32.lshift(bit32.band(n1082 * bit32.rshift(v154, 16) + n1083 * v1542, 65535), 16), 4294967295)
                                local v292 = bit32.band(v29, 65535)

                                n13 = 668179153 + bit32.band(42886 * v292 + bit32.lshift(bit32.band(42886 * bit32.rshift(v29, 16) + 18058 * v292, 65535), 16), 4294967295)

                                local v155 = bit32.band(n43, 4294967295)
                                local v1552 = bit32.band(v155, 65535)

                                v22 = bit32.band(39631 * v1552 + bit32.lshift(bit32.band(39631 * bit32.rshift(v155, 16) + 10195 * v1552, 65535), 16), 4294967295)

                                local v156 = bit32.band(n44, 4294967295)
                                local v1562 = bit32.band(v156, 65535)

                                n14 = n12 + n13 + v22 + bit32.band(2 * v1562 + bit32.lshift(bit32.band(2 * bit32.rshift(v156, 16) + 0 * v1562, 65535), 16), 4294967295)

                                local n142 = bit32.bor(n14, 2147483648)
                                local n1422 = bit32.band(n142, 65535)
                                local v30 = bit32.band(6104547510 + bit32.band(10611 * n1422 + bit32.lshift(bit32.band(10611 * bit32.rshift(n142, 16) + 2346 * n1422, 65535), 16), 4294967295), 4294967295)
                                local v302 = bit32.band(v30, 65535)

                                n15 = bit32.band(16295 * v302 + bit32.lshift(bit32.band(16295 * bit32.rshift(v30, 16) + 33254 * v302, 65535), 16), 4294967295) + 22185264754
                                v18[n102] = bit32.bxor(v18[n102], 710428274)

                                local n109 = bit32.band(n102, 4294967295)
                                local n1092 = bit32.band(n109, 65535)

                                v23 = bit32.band(n1092 * 777 + bit32.lshift(bit32.band(n1092 * 2731 + bit32.rshift(n109, 16) * 777, 65535), 16), 4294967295)

                                local v232 = bit32.band(v23, 4294967295)
                                local v2322 = bit32.band(v232, 65535)

                                v24 = bit32.band(8288 * v2322 + bit32.lshift(bit32.band(8288 * bit32.rshift(v232, 16) + 9269 * v2322, 65535), 16), 4294967295)

                                local v31 = bit32.band(n4 + 234815797, 4294967295)
                                local v312 = bit32.band(v31, 65535)

                                v25 = bit32.band(57248 * v312 + bit32.lshift(bit32.band(57248 * bit32.rshift(v31, 16) + 56266 * v312, 65535), 16), 4294967295)

                                local n152 = bit32.band(n15, 4294967295)
                                local n1522 = bit32.band(n152, 65535)
                                local v32 = bit32.band(n1522 * 39241 + bit32.lshift(bit32.band(n1522 * 11780 + bit32.rshift(n152, 16) * 39241, 65535), 16), 4294967295)
                                local v322 = bit32.band(v32, 65535)

                                n16 = v24 + v25 + bit32.band(33441 * v322 + bit32.lshift(bit32.band(33441 * bit32.rshift(v32, 16) + 57687 * v322, 65535), 16), 4294967295)
                                n17 = bit32.band(n15, 1021894526) + 3767498450

                                local n153 = bit32.bnot(n15)
                                local n1532 = bit32.band(n153, 65535)
                                local v33 = bit32.band(n1532 * 39241 + bit32.lshift(bit32.band(n1532 * 11780 + bit32.rshift(n153, 16) * 39241, 65535), 16), 4294967295)
                                local v332 = bit32.band(v33, 65535)

                                v26 = bit32.band(33441 * v332 + bit32.lshift(bit32.band(33441 * bit32.rshift(v33, 16) + 57687 * v332, 65535), 16), 4294967295)

                                local v233 = bit32.band(bit32.bnot(v23), 772053321)
                                local v2332 = bit32.band(v233, 65535)

                                n18 = n16 + n17 + v26 + bit32.band(16576 * v2332 + bit32.lshift(bit32.band(16576 * bit32.rshift(v233, 16) + 18538 * v2332, 65535), 16), 4294967295)
                                n182 = bit32.band(n18, 2147483647)
                                n183 = bit32.bnot(n182)

                                local n185 = bit32.band(n183, 4294967295)
                                local n1852 = bit32.band(n185, 65535)

                                n19 = 3182185075 + bit32.band(9529 * n1852 + bit32.lshift(bit32.band(9529 * bit32.rshift(n185, 16) + 57046 * n1852, 65535), 16), 4294967295)

                                local n186 = bit32.bor(n18, 2147483648)
                                local n1862 = bit32.band(n186, 65535)

                                n20 = n19 + 556391110 + bit32.band(9530 * n1862 + bit32.lshift(bit32.band(9530 * bit32.rshift(n186, 16) + 57046 * n1862, 65535), 16), 4294967295)

                                local n187 = bit32.band(n183, 4294967295)
                                local n1872 = bit32.band(n187, 65535)

                                n184 = bit32.bor(n18, 2147483647)

                                local v34 = bit32.band(n20 - 387049243 + bit32.band(59163 * n1872 + bit32.lshift(bit32.band(59163 * bit32.rshift(n187, 16) + 5905 * n1872, 65535), 16), 4294967295) + 6286554484, 4294967295)
                                local v342 = bit32.band(v34, 65535)

                                v27 = bit32.band(23936 * v342 + bit32.lshift(bit32.band(23936 * bit32.rshift(v34, 16) + 6375 * v342, 65535), 16), 4294967295)

                                local n188 = bit32.band(n18, 4294967295)
                                local n1882 = bit32.band(n188, 65535)
                                local v35 = bit32.band(n1882 * 8260 + bit32.lshift(bit32.band(n1882 * 43443 + bit32.rshift(n188, 16) * 8260, 65535), 16), 4294967295)
                                local v352 = bit32.band(v35, 65535)

                                n21 = 3914064088 + bit32.band(45814 * v352 + bit32.lshift(bit32.band(45814 * bit32.rshift(v35, 16) + 26517 * v352, 65535), 16), 4294967295) + 1418712528

                                local n189 = bit32.band(n182, 4294967295)
                                local n1892 = bit32.band(n189, 65535)
                                local v36 = bit32.band(n1892 * 8260 + bit32.lshift(bit32.band(n1892 * 43443 + bit32.rshift(n189, 16) * 8260, 65535), 16), 4294967295)
                                local v362 = bit32.band(v36, 65535)

                                n22 = n182 + bit32.band(19722 * v362 + bit32.lshift(bit32.band(19722 * bit32.rshift(v36, 16) + 39018 * v362, 65535), 16), 4294967295)

                                local n1810 = bit32.band(n184, 4294967295)
                                local n18102 = bit32.band(n1810, 65535)
                                local v37 = bit32.band(n18102 * 8260 + bit32.lshift(bit32.band(n18102 * 43443 + bit32.rshift(n1810, 16) * 8260, 65535), 16), 4294967295)
                                local v372 = bit32.band(v37, 65535)

                                n4 = v27 + n21 + n22 + 0 + bit32.band(19722 * v372 + bit32.lshift(bit32.band(19722 * bit32.rshift(v37, 16) + 39018 * v372, 65535), 16), 4294967295)
                            else
                                break
                            end
                        end

                        tbl3 = tbl5[2]

                        continue
                    end

                    v14 = arg[4]
                    n5 = 31
                    n6 = buffer.len(v14) - 31 - 23
                    n7 = n5 + 937457068 % n6

                    while true do
                        n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
                        v142 = buffer.readu16(v14, n7)
                        v143 = buffer.readi32(v14, n8)
                        v144 = bit32.lshift(bit32.band(v143, 255), 3)
                        v15 = bit32.band(bit32.bxor(bit32.bxor(380672267, v142) + v144 + 234815797, n7), 2147483647)
                        v145 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v142, v143), v15), 2147483647), 410902784)

                        buffer.writeu8(v14, n7, v145)

                        v152 = bit32.rshift(v15, 8)
                        v146 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v143, v152), n7), 2147483647), 1424731392)

                        buffer.writei8(v14, n8, v146)

                        n4 = v15
                        n7 = n5 + (n7 + bit32.band(v15, 63) + 1) % n6
                    end
                end
            end

            v14 = arg[4]
            n5 = 31
            n6 = buffer.len(v14) - 31 - 23
            n7 = n5 + 937457068 % n6

            while true do
                n8 = n5 + (n7 + bit32.band(n4, 255) + 1) % n6
                v142 = buffer.readu16(v14, n7)
                v143 = buffer.readi32(v14, n8)
                v144 = bit32.lshift(bit32.band(v143, 255), 3)
                v15 = bit32.band(bit32.bxor(bit32.bxor(380672267, v142) + v144 + 234815797, n7), 2147483647)
                v145 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v142, v143), v15), 2147483647), 410902784)

                buffer.writeu8(v14, n7, v145)

                v152 = bit32.rshift(v15, 8)
                v146 = bit32.bor(bit32.band(bit32.bxor(bit32.bxor(v143, v152), n7), 2147483647), 1424731392)

                buffer.writei8(v14, n8, v146)

                n4 = v15
                n7 = n5 + (n7 + bit32.band(v15, 63) + 1) % n6
            end
        end

        fn10(nil, nil, nil, nil, nil)

        local n4 = 300060823

        while true do
            n4 += 590403
        end
    end
    fn7 = function()
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end
    tbl = {}
    tbl[false] = true
    tbl[true] = false

    local tbl3 = {}

    fn8 = function(key, key3)
        tbl3[key] = true

        local v14 = tbl3[key3]

        tbl3[key] = nil

        return v14
    end

    local function fn10(arg)
        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local kind = type(arg)

        fn8('table', kind)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local metatable = getmetatable(arg)

        fn8(nil, metatable)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        pcall(setmetatable, arg, nil)
    end

    computeHash = function(arg, ...)
        local byte = string.byte
        local n4 = 1
        local tbl4 = {
            nil,
            0,
            select('#', table.unpack(t95_46_1, 1, t95_46_1.n)) + 0,
            1,
            nil,
        }

        table.pack(byte(arg, n4, -1))

        while true do
            local v14 = tbl4[4]
            local v15 = tbl4[3]
            local n5 = tbl4[2] + v14

            tbl4[2] = n5

            if n5 <= v15 then
            else
                break
            end
        end

        return 3858602740
    end

    local function fn11(arg, arg2)
        for k in arg, nil, nil do
            arg2[computeHash(k, 100007034)] = nil
        end
        for k in arg2, nil, nil do
            fn5(249019387, 4)

            n2 = 97478268

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

    local tbl4 = {
        namewhat = '',
    }
    local str = 'linedefined'

    v9 = fn10
    v10 = fn11
    tbl4[str] = -1
    tbl4.source = '=[C]'
    tbl4.isvararg = true
    tbl4.lastlinedefined = -1
    tbl4.what = 'C'
    tbl4.currentline = -1
    tbl4.short_src = '[C]'
    tbl4.nparams = 0
end

local fn10

fn10 = function() end

fn10(getmetatable, 'getmetatable')
fn10(setmetatable, 'setmetatable')
fn10(tonumber, 'tonumber')
fn10(tostring, 'tostring')
fn10(rawset, 'rawset')
fn10(rawget, 'rawget')
fn10(select, 'select')
fn10(xpcall, 'xpcall')
fn10(assert, 'assert')
fn10(error, 'error')
fn10(pcall, 'pcall')
fn10(type, 'type')
fn10(next, 'next')
fn10(getfenv, 'getfenv')
fn10(setfenv, 'setfenv')
fn10(typeof, 'typeof')
fn10(string.gmatch, 'gmatch')
fn10(string.format, 'format')
fn10(string.match, 'match')
fn10(string.find, 'find')
fn10(string.char, 'char')
fn10(string.byte, 'byte')
fn10(string.gsub, 'gsub')
fn10(string.sub, 'sub')
fn10(string.rep, 'rep')
fn10(string.unpack, 'unpack')
fn10(string.pack, 'pack')
fn10(table.concat, 'concat')
fn10(table.insert, 'insert')
fn10(table.pack, 'pack')
fn10(table.clear, 'clear')
fn10(table.create, 'create')
fn10(table.move, 'move')
fn10(bit32.bor, 'bor')
fn10(bit32.bnot, 'bnot')
fn10(bit32.bxor, 'bxor')
fn10(bit32.band, 'band')
fn10(bit32.lshift, 'lshift')
fn10(bit32.rshift, 'rshift')
fn10(bit32.rrotate, 'rrotate')
fn10(bit32.lrotate, 'lrotate')
fn10(bit32.countlz, 'countlz')
fn10(bit32.countrz, 'countrz')
fn10(buffer.len, 'len')
fn10(buffer.fill, 'fill')
fn10(buffer.copy, 'copy')
fn10(buffer.create, 'create')
fn10(buffer.tostring, 'tostring')
fn10(buffer.fromstring, 'fromstring')
fn10(buffer.readstring, 'readstring')
fn10(buffer.writestring, 'writestring')
fn10(buffer.readi8, 'readi8')
fn10(buffer.readu8, 'readu8')
fn10(buffer.readi16, 'readi16')
fn10(buffer.readu16, 'readu16')
fn10(buffer.readi32, 'readi32')
fn10(buffer.readu32, 'readu32')
fn10(buffer.readf32, 'readf32')
fn10(buffer.readf64, 'readf64')
fn10(buffer.writei8, 'writei8')
fn10(buffer.writeu8, 'writeu8')
fn10(buffer.writei16, 'writei16')
fn10(buffer.writeu16, 'writeu16')
fn10(buffer.writei32, 'writei32')
fn10(buffer.writeu32, 'writeu32')
fn10(buffer.writef32, 'writef32')
fn10(buffer.writef64, 'writef64')
fn10(buffer.readbits, 'readbits')
fn10(buffer.writebits, 'writebits')
fn10(coroutine.isyieldable, 'isyieldable')
fn10(coroutine.running, 'running')
fn10(coroutine.create, 'create')
fn10(coroutine.status, 'status')
fn10(coroutine.yield, 'yield')
fn10(coroutine.close, 'close')
fn10(coroutine.resume, 'resume')
fn10(coroutine.wrap, 'wrap')
fn10(cancel, 'cancel')
fn10(spawn, 'spawn')
fn10(defer, 'defer')
fn10(delay, 'delay')
fn10(wait, 'wait')
fn10(unpack, 'unpack')
fn10(info, 'info')
fn10(traceback, 'traceback')
fn10(v7)

do
    local pcallFn = pcall
    local xpcallFn = xpcall
    local n3 = 184873197
    local n4 = 151588276

    new3(0.34711605612868546, 0.584201461813715, 0.6300675079210925)
    new('Folder')

    local ScreenGui = new('ScreenGui')
    local Frame = new('Frame')
    local Path2D = new('Path2D')

    Frame.Parent = ScreenGui
    Path2D.Parent = Frame

    vector.create(0.9291473495182592, 0.9179748922370194, 0.16459847040358777)

    local function fn11()
        assert(0.4348423620364117)
        getfenv(0)
        tostring(0.6309225837889741)
        rawequal(scratch, scratch)

        local tbl2 = {}

        next(tbl2)
        pairs(tbl2)(tbl2)
        ipairs(tbl2)(tbl2, 1)
        rawlen(tbl2)
        rawget(tbl2, 0.6470322933716517)
        rawset(tbl2, 0.7458644073183036, 0.9368059975469019)
        getmetatable(tbl2)
        setmetatable(tbl2, tbl2)
        setmetatable(tbl2, nil)
        info(19421, 'slnaf')

        local buf = buffer.create(113)

        buffer.len(buf)
        buffer.fromstring('')
        buffer.tostring(buf)
        buffer.readi8(buf, 25)
        buffer.readu8(buf, 16)
        buffer.readi16(buf, 30)
        buffer.readu16(buf, 19)
        buffer.readi32(buf, 0)
        buffer.readu32(buf, 18)
        buffer.readf32(buf, 26)
        buffer.readf64(buf, 30)
        buffer.writei8(buf, 31, -56)
        buffer.writeu8(buf, 5, 112)
        buffer.writei16(buf, 29, -15021)
        buffer.writeu16(buf, 18, 31306)
        buffer.writei32(buf, 27, -1739461197)
        buffer.writeu32(buf, 8, 795506854)
        buffer.writef32(buf, 13, 44046)
        buffer.writef64(buf, 21, 46352)
        buffer.readstring(buf, 4, 29)
        buffer.writestring(buf, 6, 'Luraph', 1)
        buffer.readbits(buf, 185, 11)
        buffer.writebits(buf, 225, 31, 1429259045)
        buffer.copy(buf, 32, buf, 0, 16)
        buffer.fill(buf, 25, 58, 7)

        local v13 = v5.new()

        v13:NextInteger(21, 689)
        v13:NextNumber(38, 915)
        v13:NextUnitVector()
        v13:NextNumber()
        v13:Shuffle({})
        v13:Clone()

        local n5 = Vector3.new(0.8849529, 0.6939018, 0.06419493) + Vector3.new(0.81551516, 0.1366219, 0.6699149)
        local vector_ = Vector3.new(0.8849529, 0.6939018, 0.06419493)
        local vector_2 = Vector3.new(0.81551516, 0.1366219, 0.6699149)
        local vector_3 = Vector3.new(1, 0, 0)
        local vector_4 = Vector3.new(0, 1, 0)
        local v14 = v4.new()
        local vector_5 = v4.new(vector_)

        v4.Angles(0.4799440877442479, 0.1465036106474712, 0.43392283729337267)

        local xyz = Enum.RotationOrder.XYZ

        v4.new(vector_, n5)
        v4.new(vector_.X, vector_.Y, vector_.Z)
        v4.new(vector_.X, vector_.Y, vector_.Z, 0, 0, 0, 1)
        v4.new(vector_.X, vector_.Y, vector_.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        v4.lookAt(vector_, n5, vector_4)
        v4.lookAlong(vector_, vector_2, vector_4)
        v4.fromEulerAnglesXYZ(0.4799440877442479, 0.1465036106474712, 0.43392283729337267)
        v4.fromEulerAnglesYXZ(0.4799440877442479, 0.1465036106474712, 0.43392283729337267)
        v4.fromOrientation(0.4799440877442479, 0.1465036106474712, 0.43392283729337267)
        v4.fromAxisAngle(vector_2.Unit, 0.4799440877442479)
        v4.fromRotationBetweenVectors(vector_3, vector_4)
        v4.fromMatrix(vector_, vector_3, vector_4, Vector3.new(0, 0, 1))
        v4.fromEulerAngles(0.4799440877442479, 0.1465036106474712, 0.43392283729337267, xyz)
        v14:Inverse()
        v14:Orthonormalize()
        v14:Lerp(vector_5, 0.08237496241424991)
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

        local vector_6 = Vector3.new(0.9213257, 0.5664093, 0.056607734)
        local vector_7 = Vector3.new(0.3778307, 0.6873858, 0.6619551)

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
        vector_6:Lerp(vector_7, 0.14425163344846836)
        vector_6:Max(vector_7)
        vector_6:Min(vector_7)

        local vector2 = Vector2.new(0.6715107560157776, 0.3338163197040558)

        vector2:Abs()
        -- This Source Was Generated by discord.gg/c3xVMnUUBv
        vector2:Ceil()
        vector2:Floor()
        vector2:Sign()
        vector2:Dot(Vector2.new(0.5651227235794067, 0.2693881094455719))
        vector2:Cross(Vector2.new(0.5651227235794067, 0.2693881094455719))
        vector2:Angle(Vector2.new(0.5651227235794067, 0.2693881094455719))
        vector2:FuzzyEq(Vector2.new(0.5651227235794067, 0.2693881094455719))
        vector2:Lerp(Vector2.new(0.5651227235794067, 0.2693881094455719), 0.34068004985484457)
        vector2:Max(Vector2.new(0.5651227235794067, 0.2693881094455719))
        vector2:Min(Vector2.new(0.5651227235794067, 0.2693881094455719))
        uDimNew(0.31052587708916235, 125)
        uDimNew(-0.21296701351404135, 57)
        uDim2New(0.3444541087586064, -79, -0.18907374620979334, 16):Lerp(uDim2New(0.9184222478118369, 
-124, 0.5315045975233543, -127), 0.719551911657581)

        local v15 = Enum.NormalId:FromName('Left').EnumType:FromValue(3).EnumType.Bottom.EnumType:FromName('Back').EnumType:FromName('Top').EnumType:FromValue(5)
        local enumType = v15.EnumType

        enumType:GetEnumItems()
        enumType:FromName(v15.Name)
        enumType:FromValue(v15.Value)

        local v16 = uDim2New(0.03076454376424001, 7, 0.2018064349182753, 19)
        local v17 = uDim2New(0.07034867772517299, 20, 0.09541849669774173, 24)
        local v18 = uDim2New(0.9565637139906759, 187, 0.7528951840038052, 181)
        local v19 = new4(v16, v17, v17)

        new4(v16:Lerp(v18, 0.31216855462129056))

        local ctx = {}
        local v20 = new4(v18)

        ctx.v19 = v19
        ctx.v20 = v20

        local v21 = utf8.char(113, 537, 1091712)

        utf8.codepoint(v21, 1, #v21)
        utf8.len(v21)
        utf8.offset(v21, 1)
        utf8.offset(v21, -3)

        local v212, v22, v23 = utf8.codes(v21)

        v212(v22, v23)
        v212(v22, utf8.offset(v21, 2))

        local v24 = utf8.char(110, 831)

        utf8.nfcnormalize(v24)
        utf8.nfdnormalize(v21)
        utf8.graphemes(v24, 1, #v24)()

        n4 = (1 * n4 + 202848080) % 268435456
        n3 = (161969 * n3 + 146486517) % 268435456
    end

    local fn112 = coroutine.wrap(fn11)
    local tbl2 = {}
    local n5 = 0

    local function fn12()
        n5 += 1

        n4 = (1 * n4 + 178666768) % 268435456
        n3 = (419979 * n3 + 65859695) % 268435456
    end

    setmetatable(tbl2, {
        __index = fn12,
        __newindex = fn12,
    })

    local ok, result = pcall(fn12)
    local result = result

    if tbl[not ok] then
        fn4(216, n + 3383312519)
    else
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end
    if tbl[not result] then
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    else
        fn4(213, 228253563)
    end

    local v14 = luraph_runtime1(table.pack(n3, n4))
    local flag = false
    local v15
    local v16 = luraph_runtime3(table.pack(pcallFn, v15))

    local function fn13()
        n3 = (281701 * n3 + 71765243) % 268435456
        n4 = (1 * n4 + 165749242) % 268435456
    end

    local v17 = luraph_runtime4(table.pack(n4, n3))

    local function fn14()
        n4 = n4 - n4 % 2 + 1
        n3 = (476183 * n3 + 69143931) % 268435456
        n3 = (145463 * n3 + 183664677) % 268435456
    end

    local n6 = 0

    fn = function()
        n6 += 1

        if n6 ~= 2499 then
            if n6 == 2498 then
                fn13()
            end

            n4 = (1 * n4 + 79633786) % 268435456
            n3 = (268047 * n3 + 133456383) % 268435456

            fn()

            return
        end

        v14()

        n4 = (1 * n4 + 242208838) % 268435456
        n3 = (687679 * n3 + 105248913) % 268435456
    end
    fn2 = function(arg)
        if arg ~= 19998 then
            if arg ~= 19997 then
                if arg == 5459 then
                    fn11(arg)
                end
            else
                fn11(arg)
            end

            fn2(arg + 1)

            if arg == 19997 then
                if not xpcallFn(v14, v17) then
                    n4 = n4 - n4 % 2 + 1
                    n3 = (997435 * n3 + 82365707) % 268435456

                    return
                end

                fn13()

                if not pcallFn(v14) then
                    n4 = n4 - n4 % 2 + 1
                    n3 = (725635 * n3 + 254164521) % 268435456

                    return
                end
                if xpcallFn(fn14, fn) then
                    n4 = n4 - n4 % 2 + 1
                    n3 = (53969 * n3 + 95448641) % 268435456
                    n3 = (625389 * n3 + 33102249) % 268435456

                    return
                end

                v16()

                if flag then
                    n4 = n4 - n4 % 2 + 1
                    n3 = (803455 * n3 + 146780051) % 268435456
                    n3 = (110551 * n3 + 205859495) % 268435456

                    return
                end

                n3 = (259351 * n3 + 169539933) % 268435456
                n4 = (1 * n4 + 152354058) % 268435456
            end

            n4 = (1 * n4 + 158355302) % 268435456
            n3 = (305877 * n3 + 118186651) % 268435456

            return
        end

        v14()

        n4 = (1 * n4 + 14482406) % 268435456
        n3 = (812439 * n3 + 181050335) % 268435456
    end

    coroutine.resume(coroutine.create(fn2), 1)
    ScreenGui:Destroy()
    fn5(n3, 4)
    fn5(n4, 4)
end

local n22

n22 = n2

do
    local n3 = 406455007
    local n4 = 628427608
    local v11 = coroutine.wrap(function()
        coroutine.yield(n3)
        coroutine.yield(n4)
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end)
    local fn82 = fn8

    if fn82(v11(), n3) then
        fn4(95, 228253563)

        n2 = n22
    else
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end

    local fn83 = fn8

    if fn83(v11(), n4) then
        fn4(64, 228253563)
    else
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end
end
do
    local thread = coroutine.create(wait)

    coroutine.resume(thread, 0)

    local thread2 = coroutine.status(thread)

    fn8('suspended', thread2)

    do
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end

    pcall(coroutine.close, thread)
end

local n3

do
    local v11 = nil
    local flag = false

    spawn(function()
        v11 = coroutine.running()

        wait(0)

        flag = true

        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end)

    local pcallFn = pcall

    n3 = 1139908340

    local flag2 = not pcallFn(coroutine.close, v11)
end
do
    fn5(249019387, 4)

    n2 = 97478268

    fn6()
end
do
    local close = coroutine.close
    local v11 = spawn(function()
        coroutine.yield()
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end)

    close(v11)
end
do
    local close = coroutine.close
    local v11 = defer(fn7)

    close(v11)
end
do
    local close = coroutine.close
    local v11 = delay(352, fn7)

    close(v11)
end

local fn11

fn11 = function() end

fn11(getfenv, -9670)
fn11(setfenv, -21336)
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
fn10(new, 'new')
fn11(new, nil)
fn10(new2, 'new')
fn10(new3, 'new')

local n32 = n3
local n322 = bit32.band(n32, 65535)
local tbl2, tbl3, v11, v12, v13

do
    local v14 = bit32.band(n322 * 57850 + bit32.lshift(bit32.band(n322 * 0 + bit32.rshift(n32, 16) * 57850, 65535), 16), 4294967295)

    fn10(color3New, 'new')
    fn10(rectNew, 'new')

    local fromAxis = v3.FromAxis

    fn10(fromAxis, 'FromAxis')

    local v142 = bit32.band(v14, 89010684)

    fn11(fromAxis, nil)

    local vector_ = fromAxis(Enum.Axis.Z)
    local left = v3.FromNormalId(Enum.NormalId.Left)
    local kind = type(vector_)
    local kind2 = type(left)
    local n4

    if kind == 'vector' then
        fn4(232, 228253563)
        fn4(kind2 == 'vector' and 123 or 15, 228253563)

        local x = left.X

        fn5(vector_.Z * 615186414, 4)
        fn5(x * -1 * 1554597823, 4)

        if fn8('vector', kind) then
            fn4(106, 228253563)

            n2 = n22
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end
        if fn8('vector', kind2) then
            fn4(252, 228253563)
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn4(vector_.X == 0 and 232 or 146, 228253563)
        fn4(vector_.Y == 0 and 194 or 95, 228253563)
        fn4(vector_.Z == 1 and 106 or 95, v142 + 160612147)
        fn4(left.X == -1 and 90 or 24, 228253563)

        n4 = left.Y == 0 and 94 or 186
    else
        fn4(19, 228253563)
        fn4(kind2 == 'vector' and 123 or 15, 228253563)

        local x = left.X

        fn5(vector_.Z * 615186414, 4)
        fn5(x * -1 * 1554597823, 4)

        if fn8('vector', kind) then
            fn4(106, 228253563)

            n2 = n22
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end
        if fn8('vector', kind2) then
            fn4(252, 228253563)
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn4(vector_.X == 0 and 232 or 146, 228253563)
        fn4(vector_.Y == 0 and 194 or 95, 228253563)
        fn4(vector_.Z == 1 and 106 or 95, v142 + 160612147)
        fn4(left.X == -1 and 90 or 24, 228253563)

        n4 = left.Y == 0 and 94 or 186
    end

    fn4(n4, n + 139242879)
    fn4(left.Z == 0 and 222 or 231, v142 - 4134355149)
    fn10(uDim2New, 'new')
    fn10(uDimNew, 'new')
    v10(utf8, {
        [2359240159] = 1705287463,
        [2039568428] = 1685667766,
        [3871900184] = 287444720,
    }, 220652318)

    tbl2 = {}

    local v15 = utf8.nfcnormalize('\u{110a}\u{1164}\u{11b2}\u{110c}\u{1165}\u{11b1}\u{1103}\u{1172}\u{11bd}\u{1111}\u{1173}\u{11b9}\u{1112}\u{1168}\u{11ac}\u{110d}\u{1171}\u{11b8}\u{110d}\u{1173}\u{11ba}\u{110a}\u{1166}')

    do
        local values = table.pack(v15:byte(1, -1))

        table.move(values, 1, values.n, 1, tbl2)
    end

    tbl3 = {}

    local v16 = utf8.nfdnormalize('\u{b11c}\u{bd50}\u{ca4c}\u{ccfb}\u{cc67}\u{ba23}\u{d3bd}\u{c86d}\u{cb7f}')

    do
        local values = table.pack(v16:byte(1, -1))

        table.move(values, 1, values.n, 1, tbl3)
    end

    fn4(tbl2[24], 228253563)

    local v17 = tbl3[78]

    fn4(v17, n + 160612147)
    fn4(tbl3[39], v142 - 4134355149)
    fn4(tbl3[77], 228253563)

    v11 = tbl3[12]

    fn4(v11, n - 4134355149)
    fn4(tbl2[23], v142 + 160612147)
    fn4(tbl3[14], 228253563)
    fn4(tbl3[63], n - 4134355149)
    fn4(tbl3[44], v142 + 160612147)
    fn4(tbl3[17], 228253563)
    fn4(tbl3[65], 228253563)
    fn4(tbl3[19], 228253563)
    fn4(tbl2[13], 228253563)
    fn4(tbl3[41], n + 228253563)
    fn4(tbl2[7], 228253563)

    local v18 = tbl3[59]
    local v172 = v17

    fn4(v18, 228253563)
    fn4(tbl3[8], n + 228253563)
    fn4(tbl3[53], 228253563)
    fn4(tbl3[67], 228253563)
    fn4(tbl3[76], n + 228253563)
    fn4(tbl3[36], 228253563)
    fn4(tbl2[20], 228253563)
    fn4(tbl3[49], 228253563)
    fn4(tbl3[55], v172 - 4066713863)
    fn4(tbl2[19], 228253563)
    fn4(tbl2[16], 228253563)
    fn4(tbl2[9], v172 + 228253433)
    fn4(tbl3[56], 228253563)
    fn4(tbl3[15], 228253563)
    fn4(tbl3[7], 228253563)
    fn4(tbl3[3], 228253563)
    fn4(tbl3[48], 228253563)
    fn4(tbl3[61], v172 - 4066713863)
    fn4(tbl2[22], 228253563)
    fn4(tbl3[75], n + 228253428)
    fn4(tbl3[11], 228253563)
    fn4(tbl3[51], 228253563)
    fn4(tbl3[47], 228253563)
    fn4(tbl3[29], 228253563)
    fn4(tbl3[20], 228253563)

    v12 = tbl3[32]

    fn4(v12, n - 4066713868)
    fn4(tbl3[37], v172 - 4066713863)

    v13 = tbl3[33]

    fn4(v13, 228253563)
    fn4(tbl3[4], 228253563)
    fn4(tbl3[16], v172 - 4066713863)
    fn4(tbl3[72], 228253563)
    fn4(tbl3[18], n + 228253428)

    local n5 = v172 + v11

    fn4(tbl3[22], n5 + 228253298)
    fn4(tbl3[58], 228253563)
    fn4(tbl3[34], n + 228253428)
    fn4(tbl3[46], n5 + 228253298)
    fn4(tbl3[54], 228253563)
    fn4(tbl2[15], n - 4066713868)
    fn4(tbl3[10], n5 - 4066713998)
    fn4(tbl3[52], 228253563)
    fn4(tbl3[60], 228253563)
    fn4(tbl3[24], 228253563)
    fn4(tbl3[70], 228253563)
    fn4(tbl3[40], 228253563)
    fn4(tbl2[8], n5 - 4066713998)
    fn4(tbl2[1], 228253563)
    fn4(tbl2[14], 228253563)
    fn4(tbl2[18], n5 + 228253298)
end

fn4(tbl2[10], 228253563)
fn4(tbl3[5], 228253563)
fn4(tbl2[4], 228253563)
fn4(tbl2[11], 228253563)
fn4(tbl3[38], 228253563)

local v14 = tbl3[26]

fn4(v14, 228253563)
fn4(tbl3[43], 228253563)
fn4(tbl3[42], 228253563)
fn4(tbl2[2], 228253563)
fn4(tbl3[45], 228253563)
fn4(tbl2[6], 228253563)
fn4(tbl3[23], 228253563)
fn4(tbl3[9], 228253563)
fn4(tbl3[31], 228253563)

local v15

v15 = tbl3[30]

fn4(v15, 228253563)
fn4(tbl3[71], 228253563)
fn4(tbl2[5], 228253563)
fn4(tbl3[74], 228253563)
fn4(tbl3[62], 228253563)
fn4(tbl3[69], 228253563)
fn4(tbl2[12], 228253563)
fn4(tbl3[28], 228253563)
fn4(tbl3[68], 228253563)
fn4(tbl3[2], 228253563)
fn4(tbl3[57], 228253563)
fn4(tbl2[21], 228253563)
fn4(tbl3[64], 228253563)
fn4(tbl3[6], 228253563)
fn4(tbl3[1], 228253563)
fn4(tbl3[35], 228253563)
fn4(tbl3[66], 228253563)
fn4(tbl3[13], 228253563)
fn4(tbl3[25], 228253563)
fn4(tbl3[21], 228253563)
fn4(tbl2[3], 228253563)
fn4(tbl3[50], 228253563)
fn4(tbl3[27], 228253563)
fn4(tbl3[73], 228253563)
fn4(tbl2[17], 228253563)
fn10(new4, 'new')
fn11(new4, nil)

local ScreenGui

ScreenGui = new('ScreenGui')

local Path2D

do
    local Frame = new('Frame')

    Frame.Position = uDim2New(0, 0, 0, 0)
    Frame.Size = uDim2New(0, 284, 0, 106)
    Frame.Parent = ScreenGui

    local Path2D2 = new('Path2D')

    Path2D2.Parent = Frame
    Path2D = Path2D2
end

local packedValues

do
    local setControlPoints = Path2D.SetControlPoints
    local tbl4 = {}
    local v17 = new4(uDim2New(0.125, -4, 0.5, -7), uDim2New(0, 2, 0, -5), uDim2New(0, 0, 0, 0))
    local v18 = new4(uDim2New(0.0625, -7, 0, -1), uDim2New(0, -8, 0, 0), uDim2New(-0.125, -2, 0, 0))
    local v19 = new4(uDim2New(0.125, -9, 0.25, -4), uDim2New(0, -5, 0, -2), uDim2New(0, -7, 0.0625, 5))
    local v20 = uDim2New(0, 6, 0, 2)
    local v21 = uDim2New(0, 0, 0, 0)
    local packedValues2 = table.pack(uDim2New(0, 0, 0, 0))

    packedValues = table.pack(table.unpack(packedValues2, 1, packedValues2.n))
    tbl4[1] = v17
    tbl4[2] = v18
    tbl4[3] = v19

    do
        local values = table.pack(new4(v20, v21, table.unpack(packedValues2, 1, packedValues2.n)))

        table.move(values, 1, values.n, 4, tbl4)
    end

    setControlPoints(Path2D, tbl4)
end

local length = Path2D:GetLength()

fn5(string.unpack('<I4', string.pack('>f', length)), 4)

local str

do
    local positionOnCurve = Path2D:GetPositionOnCurve(0.1428571492433548)
    local scale = positionOnCurve.X.Scale

    str = '<f'

    fn5(string.unpack('>I4', string.pack(str, scale)), 4)
    fn5(string.unpack('>I4', string.pack('>f', positionOnCurve.Y.Scale)), 4)
end

local positionOnCurve = Path2D:GetPositionOnCurve(0.9230769276618958)

fn5(string.unpack('>I4', string.pack('>f', positionOnCurve.X.Scale)), 4)
fn5(string.unpack('<I4', string.pack('<f', positionOnCurve.Y.Scale)), 4)

local positionOnCurve2 = Path2D:GetPositionOnCurve(0.25)

fn5(string.unpack('>I4', string.pack('>f', positionOnCurve2.X.Scale)), 4)
fn5(string.unpack('>I4', string.pack('>f', positionOnCurve2.Y.Scale)), 4)

local tangentOnCurve = Path2D:GetTangentOnCurve(0.2142857164144516)

fn5(string.unpack('<I4', string.pack('<f', tangentOnCurve.X)), 4)
fn5(string.unpack('>I4', string.pack('>f', tangentOnCurve.Y)), 4)

local tangentOnCurve2 = Path2D:GetTangentOnCurve(0.6000000238418579)

fn5(string.unpack('<I4', string.pack('<f', tangentOnCurve2.X)), 4)
fn5(string.unpack('>I4', string.pack('<f', tangentOnCurve2.Y)), 4)

local positionOnCurveArcLength = Path2D:GetPositionOnCurveArcLength(0.6875)

fn5(string.unpack('<I4', string.pack('<f', positionOnCurveArcLength.X.Scale)), 4)
fn5(string.unpack('<I4', string.pack('>f', positionOnCurveArcLength.Y.Scale)), 4)

local positionOnCurveArcLength2 = Path2D:GetPositionOnCurveArcLength(0.20000000298023224)

fn5(string.unpack('>I4', string.pack('<f', positionOnCurveArcLength2.X.Scale)), 4)
fn5(string.unpack('>I4', string.pack('<f', positionOnCurveArcLength2.Y.Scale)), 4)

local tangentOnCurveArcLength = Path2D:GetTangentOnCurveArcLength(0.8666666746139526)

fn5(string.unpack('>I4', string.pack('<f', tangentOnCurveArcLength.X)), 4)
fn5(string.unpack('>I4', string.pack('<f', tangentOnCurveArcLength.Y)), 4)

local tangentOnCurveArcLength2 = Path2D:GetTangentOnCurveArcLength(0.9230769276618958)

fn5(string.unpack('<I4', string.pack('>f', tangentOnCurveArcLength2.X)), 4)
fn5(string.unpack('<I4', string.pack('>f', tangentOnCurveArcLength2.Y)), 4)

local tangentOnCurveArcLength3 = Path2D:GetTangentOnCurveArcLength(0.8571428656578064)

fn5(string.unpack('>I4', string.pack('<f', tangentOnCurveArcLength3.X)), 4)
fn5(string.unpack('>I4', string.pack('<f', tangentOnCurveArcLength3.Y)), 4)
ScreenGui:Destroy()
v10(math, {
    [1123260999] = 191829566,
    [3578971995] = 642332677,
    [1112348393] = 1372585086,
}, 220652318)
v10(v8, {
    [4040354678] = 1519020839,
    [1870682885] = 2043789030,
    [4047524962] = 2070941320,
    [1532793817] = 37626200,
    [74260314] = 1023590517,
}, 220652318)
v10(v2, {
    [449210636] = 836490693,
    [2877946137] = 2083307449,
}, 220652318)

local iter_G_1, n23, v17

do
    local gameRef = game
    local workspaceRef = workspace

    local function fn12(arg, arg2, arg3)
        local n4 = 3135251660
        local n5 = 3714248221
        local kind = type(arg)

        fn8('userdata', kind)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local kind2 = typeof(arg)

        fn8('Instance', kind2)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()

            n4 = -1159715636
        end

        local parent = arg.Parent
        local parent2 = arg.Parent
        local n6 = arg3 + n4

        if tbl[not parent] then
            fn8(parent, parent2)

            do
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end
        end

        local name = arg.Name
        local name2 = arg.Name
        local kind3 = type(name)

        fn8('string', kind3)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(name, name2)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local n7 = n5 + n6

        fn8(#name, #name2)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(tostring(arg), name)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(arg2, arg.ClassName)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local descendantRemoving = arg.DescendantRemoving

        fn8(descendantRemoving, arg.DescendantRemoving)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local connect = descendantRemoving.Connect
        local connect2 = descendantRemoving.Connect

        fn10(connect, 'Connect')
        fn10(connect2, 'Connect')
        fn8(connect, connect2)

        local flag = false
        local descendantRemoving2 = arg.DescendantRemoving
        local descendantRemoving3 = descendantRemoving2
        local connect3 = descendantRemoving2.Connect
        local n8 = 412204119

        local function fn13()
            local flag2, flag3

            while true do
                flag2 = n8 ~= 334670485 and 1
                flag3 = true

                if flag2 then
                    if flag2 <= 1 then
                        if flag2 <= 0 then
                            continue
                        else
                            n8 = bit32.bxor(n8, 1122820133)
                            flag2 = 3

                            break
                        end
                    end
                else
                    flag2 = 3

                    break
                end

                break
            end
            while not (flag2 <= 2) do
                flag = flag3
                flag2 = 2
            end
        end

        n8 = 334670485

        local v18 = connect3(descendantRemoving3, fn13)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local disconnect = v18.Disconnect

        fn10(disconnect, 'Disconnect')
        fn11(disconnect, nil)
        disconnect(v18)

        local wait2 = descendantRemoving.Wait

        fn10(wait2, 'Wait')

        local n9 = 269746282

        local function fn14()
            local wait3 = wait2

            return (wait3(descendantRemoving))
        end

        n9 = 42543288

        local thread = coroutine.create(fn14)
        local thread2, v19 = coroutine.resume(thread)
        local v20 = tbl[not thread2]
        local flag2 = not v20
        local n72 = bit32.bor(n7, n6)
        local flag22

        if v20 then
            flag22 = tbl[not v19]
        else
            flag22 = flag2
        end
        if not flag22 then
            local thread3 = coroutine.status(thread)

            flag22 = not fn8('suspended', thread3)
        end
        if flag22 then
            fn5(249019387, 4)

            n2 = 97478268

            fn6()

            n6 = n6 + n72 + 289440029
        end

        local ok, result = pcall(coroutine.close, thread)
        local v21 = tbl[not ok]
        local flag3 = not v21
        local flag4

        if v21 then
            flag4 = not tbl[not result]
        else
            flag4 = flag3
        end
        if not flag4 then
            local thread3 = coroutine.status(thread)

            flag4 = not fn8('dead', thread3)
        end
        if flag4 then
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local metatable = getmetatable(arg)

        fn8('The metatable is locked', metatable)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end
    end

    fn12(gameRef, 'DataModel', 332880279)
    fn12(workspaceRef, 'Workspace', 332880279)

    if fn8(gameRef, workspaceRef.Parent) then
        fn4(35, 228253563)

        n2 = n22
    else
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end

    local Folder = new('Folder')

    fn12(Folder, 'Folder', 332880279)

    local ok, result = pcall(Folder.Clone, UDim.new(0.7166752815246582, 560), 2139543573)
    local flag = not ok

    if not tbl[flag] then
        fn5(computeHash(result, 100007034), 4)
    end

    local n24 = n2

    if tbl[flag] then
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    else
        fn4(98, 228253563)

        n2 = n24
    end

    local children, v18, v19 = Folder:GetChildren()

    iter_G_1 = (function(f, s, var)
        local co = coroutine.wrap(function()
            coroutine.yield()

            for k, v20, v32, v42, v52, v62, v72, v82, v92, v102 in f, s, var do
                coroutine.yield(true, k, v20, v32, v42, v52, v62, v72, v82, v92, v102)
            end
        end)

        co()

        return co
    end)(children, v18, v19)

    local packedValues = table.pack(iter_G_1())

    if packedValues[1] then
        repeat
            fn5(249019387, 4)

            n2 = 97478268

            fn6()

            local packedValues = table.pack(iter_G_1())
        until not packedValues[1]
    end

    Folder:Destroy()

    local n25 = n2
    local Folder2 = Folder
    local Folder3 = new('Folder', Folder2)

    fn12(Folder3, 'Folder', 332880279)

    local fn82 = fn8
    local n252

    if fn82(Folder2, Folder3.Parent) then
        n252 = n25

        fn4(189, 228253563)

        n2 = n252

        if fn8(Folder3.Parent, Folder3.Parent) then
            fn4(115, 228253563)
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local waitForChild = Folder2.WaitForChild

        fn10(waitForChild, 'WaitForChild')
        fn11(waitForChild, nil)

        local name = tostring(181115897)

        Folder3.Name = name

        local v21 = waitForChild(Folder2, name)
        local fn83 = fn8

        if fn83(Folder3, v21) then
            fn4(197, 228253563)
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        Folder2:Destroy()
        Folder3:Destroy()

        if tbl[not Folder3.Parent] then
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        else
            fn4(46, 228253563)
        end
    else
        n252 = n25

        fn5(249019387, 4)

        n2 = 97478268

        fn6()

        if fn8(Folder3.Parent, Folder3.Parent) then
            fn4(115, 228253563)
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local waitForChild = Folder2.WaitForChild

        fn10(waitForChild, 'WaitForChild')
        fn11(waitForChild, nil)

        local name = tostring(181115897)

        Folder3.Name = name

        local v21 = waitForChild(Folder2, name)

        if fn8(Folder3, v21) then
            fn4(197, 228253563)
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        Folder2:Destroy()
        Folder3:Destroy()

        if tbl[not Folder3.Parent] then
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        else
            fn4(46, 228253563)
        end
    end
    if tbl[not pcall(function()
        Folder3.Parent = Folder2
    end)] then
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    else
        fn4(26, 228253563)
    end

    n2 = n252

    local HttpService = gameRef:GetService('HttpService')

    fn12(HttpService, 'HttpService', 332880279)

    local fn83 = fn8
    local n253 = n2
    local n2532

    if fn83(gameRef, HttpService.Parent) then
        fn4(181, 228253563)

        n2 = n253
        n2532 = n253
    else
        n2532 = n253

        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end
    if not v6 then
        fn10(HttpService.GetAsync, 'GetAsync')
        fn10(HttpService.PostAsync, 'PostAsync')
        fn10(HttpService.RequestAsync, 'RequestAsync')
    end

    local RunService = gameRef:GetService('RunService')

    fn12(RunService, 'RunService', 332880279)

    local starterPlayer, starterPlayer2, children2, v21, v22, v23, fn84, n2533, fn85, metatable, fn86, bottom, fn87, fn88, metatable3, fn89, name, value, fn810, fn811, enumType, fn812, n4, fn813, fn814, metatable2, fn815, fromName, v27, fn816, fromValue, v28, fn817, new5, v29, fn818, fn819, fn820, fn821

    if fn8(gameRef, RunService.Parent) then
        fn4(152, 228253563)

        n2 = n2532

        fn10(RunService.IsStudio, 'IsStudio')
        fn10(RunService.IsClient, 'IsClient')
        fn10(RunService.IsServer, 'IsServer')
        fn11(RunService.IsStudio)
        fn11(RunService.IsClient)
        fn11(RunService.IsServer)
        RunService:IsServer()

        do
            if tbl[not pcall(gameRef.GetChildren)] then
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            else
                fn4(255, 228253563)

                n2 = n2532
            end

            v23 = Enum
            fn84 = fn8
            n2533 = n2

            if fn84(type(v23), 'userdata') then
                fn4(210, 228253563)

                n2 = n2533
                n23 = n2533
            else
                n23 = n2533

                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            fn85 = fn8

            if fn85(typeof(v23), 'Enums') then
                fn4(158, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            metatable = getmetatable(v23)
            fn86 = fn8

            if fn86('The metatable is locked', metatable) then
                fn4(216, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            bottom = v23.NormalId.Bottom
            fn87 = fn8

            if fn87(type(bottom), 'userdata') then
                fn4(2, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            fn88 = fn8

            if fn88(typeof(bottom), 'EnumItem') then
                fn4(201, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            metatable3 = getmetatable(bottom)
            fn89 = fn8

            if fn89('The metatable is locked', metatable3) then
                fn4(186, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            fn10(bottom.IsA, 'IsA')
            fn11(bottom.IsA)

            name = bottom.Name
            value = bottom.Value
            fn810 = fn8

            if fn810(type(name), 'string') then
                fn4(109, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            fn811 = fn8

            if fn811(type(value), 'number') then
                fn4(52, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            enumType = bottom.EnumType
            fn812 = fn8

            if fn812(bottom, enumType[name]) then
                fn4(195, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            n4 = 465306189
            fn813 = fn8

            if fn813(type(enumType), 'userdata') then
                fn4(190, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            fn814 = fn8

            if fn814(typeof(enumType), 'Enum') then
                fn4(105, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            metatable2 = getmetatable(enumType)
            fn815 = fn8

            if fn815('The metatable is locked', metatable2) then
                fn4(241, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            fn10(enumType.FromName, 'FromName')
            fn10(enumType.FromValue, 'FromValue')
            fn11(enumType.FromName)
            fn11(enumType.FromValue)

            fromName = enumType.FromName
            v27 = fromName(enumType, name)
            fn816 = fn8

            if fn816(bottom, v27) then
                fn4(2, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            fromValue = enumType.FromValue
            v28 = fromValue(enumType, value)
            fn817 = fn8

            if fn817(bottom, v28) then
                fn4(73, 228253563)

                new5 = v5.new

                fn10(new5, 'new')
                fn11(new5, {})

                v29 = new5(1504210447)
                fn818 = fn8

                if fn818(type(v29), 'userdata') then
                    fn4(213, 228253563)

                    n2 = n23
                else
                    fn5(249019387, 4)

                    n2 = 97478268

                    fn6()
                end

                fn819 = fn8

                if fn819(typeof(v29), 'Random') then
                    fn4(42, 228253563)
                else
                    fn5(249019387, 4)

                    n2 = 97478268

                    fn6()
                end
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()

                new5 = v5.new

                fn10(new5, 'new')
                fn11(new5, {})

                v29 = new5(1504210447)
                fn820 = fn8

                if fn820(type(v29), 'userdata') then
                    fn4(213, 228253563)

                    n2 = n23
                else
                    fn5(249019387, 4)

                    n2 = 97478268

                    fn6()
                end

                fn821 = fn8

                if fn821(typeof(v29), 'Random') then
                    fn4(42, 228253563)
                else
                    fn5(249019387, 4)

                    n2 = 97478268

                    fn6()
                end
            end
        end
    else
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
        fn10(RunService.IsStudio, 'IsStudio')
        fn10(RunService.IsClient, 'IsClient')
        fn10(RunService.IsServer, 'IsServer')
        fn11(RunService.IsStudio)
        fn11(RunService.IsClient)
        fn11(RunService.IsServer)
        RunService:IsServer()

        do
            if tbl[not pcall(gameRef.GetChildren)] then
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            else
                fn4(255, 228253563)

                n2 = n2532
            end

            local v30 = Enum
            local fn822 = fn8
            local n2534 = n2

            if fn822(type(v30), 'userdata') then
                fn4(210, 228253563)

                n2 = n2534
                n23 = n2534
            else
                n23 = n2534

                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end
            if fn8(typeof(v30), 'Enums') then
                fn4(158, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            local metatable = getmetatable(v30)

            if fn8('The metatable is locked', metatable) then
                fn4(216, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            local bottom2 = v30.NormalId.Bottom

            if fn8(type(bottom2), 'userdata') then
                fn4(2, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end
            if fn8(typeof(bottom2), 'EnumItem') then
                fn4(201, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            local metatable = getmetatable(bottom2)

            if fn8('The metatable is locked', metatable) then
                fn4(186, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            fn10(bottom2.IsA, 'IsA')
            fn11(bottom2.IsA)

            local name2 = bottom2.Name
            local value = bottom2.Value

            if fn8(type(name2), 'string') then
                fn4(109, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end
            if fn8(type(value), 'number') then
                fn4(52, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            local enumType2 = bottom2.EnumType

            if fn8(bottom2, enumType2[name2]) then
                fn4(195, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end
            if fn8(type(enumType2), 'userdata') then
                fn4(190, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end
            if fn8(typeof(enumType2), 'Enum') then
                fn4(105, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            local metatable = getmetatable(enumType2)

            if fn8('The metatable is locked', metatable) then
                fn4(241, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            fn10(enumType2.FromName, 'FromName')
            fn10(enumType2.FromValue, 'FromValue')
            fn11(enumType2.FromName)
            fn11(enumType2.FromValue)

            local v34 = enumType2:FromName(name2)

            if fn8(bottom2, v34) then
                fn4(2, 228253563)
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            local v35 = enumType2:FromValue(value)

            if fn8(bottom2, v35) then
                fn4(73, 228253563)

                new5 = v5.new

                fn10(new5, 'new')
                fn11(new5, {})

                v29 = new5(1504210447)
                fn820 = fn8

                if fn820(type(v29), 'userdata') then
                    fn4(213, 228253563)

                    n2 = n23
                else
                    fn5(249019387, 4)

                    n2 = 97478268

                    fn6()
                end

                fn821 = fn8

                if fn821(typeof(v29), 'Random') then
                    fn4(42, 228253563)
                else
                    fn5(249019387, 4)

                    n2 = 97478268

                    fn6()
                end
            else
                fn5(249019387, 4)

                n2 = 97478268

                fn6()

                new5 = v5.new

                fn10(new5, 'new')
                fn11(new5, {})

                v29 = new5(1504210447)

                if fn8(type(v29), 'userdata') then
                    fn4(213, 228253563)

                    n2 = n23
                else
                    fn5(249019387, 4)

                    n2 = 97478268

                    fn6()
                end
                if fn8(typeof(v29), 'Random') then
                    fn4(42, 228253563)
                else
                    fn5(249019387, 4)

                    n2 = 97478268

                    fn6()
                end
            end
        end
    end

    fn10(v29.NextUnitVector, 'NextUnitVector')
    fn10(v29.NextInteger, 'NextInteger')
    fn10(v29.NextNumber, 'NextNumber')
    fn10(v29.Shuffle, 'Shuffle')
    fn10(v29.Clone, 'Clone')

    v17 = new5(1975086640)
end
do
    local unpack_ = string.unpack
    local pack = string.pack
    local randNum = v17:NextNumber()

    fn5(unpack_('<I4', pack('<f', randNum)), 4)
end
do
    local clone = v17:Clone()
    local unpack_ = string.unpack
    local pack = string.pack
    local randNum = clone:NextNumber()

    fn5(unpack_('<I4', pack('<f', randNum)), 4)

    local clone2 = clone:Clone()
    local unpack_2 = string.unpack
    local pack2 = string.pack
    local randNum2 = v17:NextNumber()

    fn5(unpack_2('<I4', pack2('<f', randNum2)), 4)
    fn5(clone:NextInteger(892, 1035), 4)

    local clone3 = clone:Clone()
    local unpack_3 = string.unpack
    local pack3 = string.pack
    local randNum3 = clone3:NextNumber()

    fn5(unpack_3('<I4', pack3('>f', randNum3)), 4)

    local unpack_4 = string.unpack
    local pack4 = string.pack
    local randNum4 = v17:NextNumber()

    fn5(unpack_4('<I4', pack4('>f', randNum4)), 4)
    fn5(clone2:NextInteger(530, 1256), 4)
    fn5(clone3:NextInteger(366, 408), 4)
    clone3:Clone()

    local randInt = v17:NextInteger(36, 63)

    fn5(randInt, 4)

    local unpack_5 = string.unpack
    local pack5 = string.pack
    local randNum5 = clone3:NextNumber()

    fn5(unpack_5('>I4', pack5('<f', randNum5)), 4)

    local n4 = 68
    local tbl4 = {
        [3572348925] = 17,
        [1550156081] = 17,
        [3883974895] = 68,
        [2259392077] = 68,
        [2290705073] = 68,
        [638902717] = 68,
        [1335137169] = 68,
        [704067214] = 17,
        [4005013694] = n4,
        [3617127853] = n4,
        [1269173873] = 34,
        [1840385645] = n4,
        [1888702583] = n4,
        [2735746997] = 17,
        [2484353495] = 17,
        [2045472910] = 17,
        [3626799213] = n4,
        [2807305321] = 17,
        [3720369311] = n4,
        [1711317873] = n4,
        [881624875] = n4,
        [1696326204] = 17,
        [795219728] = n4,
        [1684216787] = n4,
        [1022915995] = n4,
        [2568246380] = 17,
        [84637321] = 34,
        [2193962727] = 17,
        [2254418212] = n4,
        [2450804585] = 17,
        [3592008539] = n4,
        [4041205282] = 17,
    }
    local env = getfenv()
    local envMap = {}
    local tbl5 = {}
    local n5 = 0
    local tbl6 = {
        nil,
        3,
        v,
        0,
        1,
    }

    while true do
        local v18 = tbl6[5]
        local v19 = tbl6[2]
        local n6 = tbl6[4] + v18

        tbl6[4] = n6

        if n6 <= v19 then
            n22 = n6

            do
                envMap[env] = true

                local n7 = 0

                iter_G_1 = (function(f, s, var)
                    local co = coroutine.wrap(function()
                        coroutine.yield()

                        for k, v20, v32, v42, v52, v62, v72, v82, v92, v102 in f, s, var do
                            coroutine.yield(true, k, v20, v32, v42, v52, v62, v72, v82, v92, v102)
                        end
                    end)

                    co()

                    return co
                end)(env, nil, nil)

                local exitTo = nil

                for k in env, nil, nil do
                    n7 += 1

                    local kind = type(k)

                    if fn8('string', kind) then
                        if #k < 20 then
                            local hash = computeHash(k, 100007034)

                            if tbl5[hash] then
                                if n7 > 50 then
                                    exitTo = 1

                                    break
                                end
                            else
                                n5 += tbl4[hash] or 0

                                tbl5[hash] = true

                                if n7 > 50 then
                                    exitTo = 1

                                    break
                                end
                            end
                        elseif n7 > 50 then
                            exitTo = 1

                            break
                        end
                    elseif n7 > 50 then
                        exitTo = 1

                        break
                    end
                end

                local n52 = n5
                local metatable = getmetatable(env)
                local flag = type(metatable) == 'table'
                local n522, value

                if flag then
                    n522 = n52
                    value = rawget(metatable, '__index')
                else
                    n522 = n52
                    value = flag
                end
                if value then
                    local n523 = n522

                    env = value
                    n5 = n523

                    continue
                end

                n5 = n522
                env = nil

                continue
            end

            break
        else
            break
        end
    end

    local v18 = tbl6[3]

    fn4(n5 < n4 and 198 or 23, 228253563)

    local ok, result = pcall(assert, false)
    local result = result

    if ok or not result or type(result) ~= 'string' then
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end

    local ok, result = pcall(function(r, ...)
        (...)[...] = nil
    end)
    local ok = ok
    local result = result
    local ok3, result3 = pcall(function(r, ...)
        return (...)[...]
    end)
    local ok2, result2 = pcall(function(r, ...)
        return (...)()
    end)

    if ok or ok3 or ok2 then
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end

    local function computeHash(arg, arg2, arg3)
        local pos, v20, v21 = string.find(arg, '[%:][^%d%D]?([%d]+)[^%a%A]*[\r\n:]')
        local pos2 = pos
        local v202 = v20
        local v212 = v21
        local n6 = 3760939418 - arg2
        local flag = not pos2
        local flag2

        if pos2 then
            flag2 = not v202
        else
            flag2 = flag
        end
        if flag2 then
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn5(pos2, 2)
        fn5(v202, 2)

        local match = string.match(arg, '[%:][^%s%S]*([%d]+)[^%d%D]*[\r:\n][^%a%A]?')
        local fn52 = fn5
        local match2

        if v212 then
            match2 = match
        else
            match2 = match
            v212 = 0
        end

        fn52(v212 + 0, 2)

        local fn53 = fn5

        match2 = match2 or 0

        fn53(match2 + 0, 2)

        local v22 = string.gmatch(arg, '%:([0-9][0-9]*)[^%u%U]?[\r\n:]')
        local n7 = v22()

        fn8(v22(), nil)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local fn54 = fn5
        local fn542

        if n7 then
            fn542 = fn54
        else
            fn542 = fn54
            n7 = 0
        end

        fn542(n7 + 0, 2)

        local text = string.sub(arg, pos2 + 1, v202 - 1)
        local v23 = string.char(string.byte(arg, pos2 + 1, v202 - 1))
        local v24 = string.byte(arg, pos2 + 1, pos2 + 1)

        fn5(text + 0, 2)
        fn5(v23 + 0, 2)
        fn4(v24, 228253563)

        local tbl7 = {
            v202 - 1 + 0,
            nil,
            1,
            pos2 + 1 - 1,
            nil,
        }
        local n8 = 0
        local tbl72 = tbl7

        while true do
            local v25 = tbl72[3]
            local v26 = tbl72[1]
            local n9 = tbl72[4] + v25

            tbl72[4] = n9

            if n9 <= v26 then
                n8 = n8 * 10 + string.byte(arg, n9, n9) - 48
            else
                break
            end
        end

        fn5(n8, 2)

        local v25 = nil
        local n9 = 0
        local n10 = n6 + 919516719

        local function fn13(arg4)
            local exitTo = nil
            local flag3, n11

            while true do
                v25 = arg4
                arg4 = n9
                flag3 = bit32.bxor(n10, 273050582) == 515176668 and 3
                n11 = 1

                if flag3 then
                    if flag3 <= 1 then
                        if flag3 <= 0 then
                            continue
                        else
                            exitTo = 2

                            break
                        end
                    else
                        exitTo = 1

                        break
                    end
                end

                break
            end

            if exitTo == 1 then
                if not (flag3 <= 2) then
                    n10 = bit32.bxor(n10, 2207559349)

                    while true do
                        n9 = arg4 + n11
                        flag3 = 2

                        if not (flag3 <= 2) then
                            n10 = bit32.bxor(n10, 2207559349)

                            continue
                        end

                        break
                    end
                end
            else
                while true do
                    n9 = arg4 + n11

                    break
                end
            end
        end

        n10 = 90483163

        local text, v26 = string.gsub(arg, '%:[^%a%A]*(%d+)[\n\r:]', fn13, 1)

        fn8(n9, 1)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(v26, 1)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn5((v25 or 0) + 0, 2)
        fn8(string.sub(arg, 2, 2), arg3)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn4(string.byte(arg, 2, 2), 228253563)
    end

    computeHash('main:90: attempt to call a string value', 66164433, 'a')
    computeHash('source.lua:133: attempt to get length of a string value', 66164433, 'o')
    computeHash('ModuleScript:38: attempt to get length of a string value', 66164433, 'o')
    computeHash('main:150: attempt to index nil with nil', 66164433, 'a')

    fn3 = function(arg)
        local n6 = 4232362991
        local n7 = 180001447
        local fn13 = nil
        local match = string.match(arg, '[%:][^%l%L]?([%d]%d*)[^%p%P]?[\r\n%:][^%a%A]?')
        local v20 = string.gmatch(arg, '[%:][^%l%L]*(%d%d*)[\r:\n]')()
        local pos, v21 = string.find(arg, '[%:][^%p%P]*([0-9]+)[^%s%S]-[\n\r:]')
        local flag = not pos
        local flag2

        if pos then
            flag2 = not v21
        else
            flag2 = flag
        end
        if flag2 then
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local text = string.sub(arg, pos + 1, v21 - 1)
        local v22 = string.char(string.byte(arg, pos + 1, v21 - 1))
        local v23 = nil
        local n8 = 0
        local text = text
        local n9 = n6 + 1393240

        fn13 = function(arg2)
            fn8(info(1, 'f'), fn13)

            do
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            local gsub = string.gsub
            local v24 = info(2, 'f')

            fn8(v24, gsub)

            do
                fn5(249019387, 4)

                n2 = 97478268

                fn6()
            end

            local info2 = info
            local n10

            do
                n10 = 3
            end

            while true do
                fn8(info2(n10, 'f'), fn3)

                if n9 ~= 439560367 then
                    continue
                end

                break
            end

            v23 = arg2

            n8 += 1
        end
        n9 = 439560367

        local text2, v24 = string.gsub(arg, ':[^%p%P]-([%d]+)[^%s%S]-[:\n\r]', fn13, 1)

        fn8(n8, 1)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(v24, 1)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local flag3 = not match
        local flag4

        if match then
            flag4 = not v20
        else
            flag4 = flag3
        end
        if flag4 or not text or not v22 or not v23 then
            fn5(249019387, 4)

            n2 = 97478268

            fn6()

            n7 = n7 - 1410191313 - 2884775983
        end

        local n10 = match + 0
        local n11 = v20 + 0
        local n12 = text + 0
        local n13 = v22 + 0
        local n14 = v23 + 0

        fn8(match, v20)

        local n112

        do
            n112 = n11

            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(v20, text)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(text, v22)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local fn82 = fn8

        fn82(v22, v23)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(n10, n112)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(n112, n12)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(n12, n13)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        fn8(n13, n14)

        do
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        return n10
    end

    local v20 = fn3(result)
    local v21 = fn3(result3)
    local v22 = fn3(result2)

    if fn8(v20, v21) then
        fn4(67, 228253563)

        n2 = n23
    else
        fn5(249019387, 4)

        n2 = 97478268

        fn6()
    end
    if fn8(v21, v22) then
        fn4(63, 228253563)

        if fn8(v22, v20) then
            fn4(196, 228253563)
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local tbl7 = {}

        iter_G_1 = (function(f, s, var)
            local co = coroutine.wrap(function()
                coroutine.yield()

                for k, v23, v32, v42, v52, v62, v72, v82, v92, v102 in f, s, var do
                    coroutine.yield(true, k, v23, v32, v42, v52, v62, v72, v82, v92, v102)
                end
            end)

            co()

            return co
        end)(tbl7, nil, nil)

        for _, v23 in tbl7, nil, nil do
            local exitTo2 = nil

            while true do
                local kind = type(v23)

                if fn8('function', kind) then
                    info(v23, 'sl')

                    local packedValues = table.pack(iter_G_1())

                    if packedValues[1] then
                        v23 = packedValues[3]
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

        v9(nil, 138973782)
        setmetatable(nil, nil)

        local tbl8 = {}
        local tbl9 = {}
        local n6 = 225
        local n7 = 129
        local tbl10 = {
            255,
            nil,
            1,
            -1,
            v18,
        }

        while true do
            local v23 = tbl10[3]
            local v24 = tbl10[1]
            local n8 = tbl10[4] + v23

            tbl10[4] = n8

            if n8 <= v24 then
                local n82 = n8
                local n9 = (n6 * n82 + n7) % 256
                local n10 = (n6 * n9 + n7) % 256
                local n11 = (n6 * n10 + n7) % 256
                local n12 = (n6 * n11 + n7) % 256

                tbl8[n82] = n9 + n10 * 256 + n11 * 65536 + n12 * 16777216
                tbl9[n82] = n12
            else
                break
            end
        end

        local v23 = tbl10[5]

        buffer.create(16)

        local v24 = nil
        local v25 = nil
        local n8 = 5
        local n9 = 6

        r__R17[n8] = 2
        r__R17[n9] = 6

        local n10 = 13
        local n11 = 14

        r__R17[n10] = 4
        r__R17[n11] = 8

        local n12 = 21
        local n13 = 22
        local n14 = 23
        local n15 = 24

        r__R17[n12] = 2
        r__R17[n13] = 7
        r__R17[n14] = 12
        r__R17[n15] = 13

        local n16 = 29
        local n17 = 30
        local n18 = 31

        r__R17[n16] = 4
        r__R17[n17] = 5
        r__R17[n18] = 10

        local tbl11 = {}
        local tbl12 = {
            v23,
            nil,
            1,
            -1,
            16,
        }

        while true do
            local v26 = tbl12[3]
            local v27 = tbl12[5]
            local n19 = tbl12[4] + v26

            tbl12[4] = n19

            if n19 <= v27 then
                tbl11[{}] = n19 + 1
            else
                break
            end
        end

        local v26 = tbl12[1]

        iter_G_1 = (function(f, s, var)
            local co = coroutine.wrap(function()
                coroutine.yield()

                for k, v27, v32, v42, v52, v62, v72, v82, v92, v102 in f, s, var do
                    coroutine.yield(true, k, v27, v32, v42, v52, v62, v72, v82, v92, v102)
                end
            end)

            co()

            return co
        end)(tbl11, nil, nil)

        local packedValues3 = table.pack(iter_G_1())

        if packedValues3[1] then
            while true do
                local packedValues = table.pack(iter_G_1())

                if packedValues[1] then
                else
                    break
                end
            end
        end

        local n19 = 0 / 0
        local tbl13 = {}
        local tbl14 = {
            1,
            nil,
            6,
            0,
            v26,
        }

        while true do
            local v28 = tbl14[1]
            local v29 = tbl14[3]
            local n20 = tbl14[4] + v28

            tbl14[4] = n20

            if n20 <= v29 then
                n19 = (n19 * 1103515245 + 12345) % 16777216
                tbl13[n20] = n19
            else
                break
            end
        end

        local tbl15 = {
            6,
            1,
            0,
            tbl14[5],
            nil,
        }

        while true do
            local v28 = tbl15[2]
            local v29 = tbl15[1]
            local n20 = tbl15[3] + v28

            tbl15[3] = n20

            if n20 <= v29 then
            else
                break
            end
        end
        while true do
            local exitTo3 = nil

            while true do
                packedValues();

                (nil)[v25] = v24
                uDim2New = str.wait

                if randInt < 245 then
                    if not (nil < 92) then
                        continue
                    end

                    break
                else
                    exitTo3 = 1

                    break
                end
            end

            if exitTo3 == 1 then
                n2 = n22

                continue
            end

            break
        end
    else
        fn5(249019387, 4)

        n2 = 97478268

        fn6()

        if fn8(v22, v20) then
            fn4(196, 228253563)
        else
            fn5(249019387, 4)

            n2 = 97478268

            fn6()
        end

        local tbl7 = {}

        iter_G_1 = (function(f, s, var)
            local co = coroutine.wrap(function()
                coroutine.yield()

                for k, v23, v32, v42, v52, v62, v72, v82, v92, v102 in f, s, var do
                    coroutine.yield(true, k, v23, v32, v42, v52, v62, v72, v82, v92, v102)
                end
            end)

            co()

            return co
        end)(tbl7, nil, nil)

        for _, v23 in tbl7, nil, nil do
            local exitTo4 = nil

            while true do
                local kind = type(v23)

                if fn8('function', kind) then
                    info(v23, 'sl')

                    local packedValues = table.pack(iter_G_1())

                    if packedValues[1] then
                        v23 = packedValues[3]
                    else
                        exitTo4 = 1

                        break
                    end
                else
                    break
                end
            end

            if exitTo4 == 1 then
                break
            end
        end

        v9(nil, 138973782)
        setmetatable(nil, nil)

        local tbl8 = {}
        local tbl9 = {}
        local n6 = 225
        local n7 = 129
        local tbl10 = {
            255,
            nil,
            1,
            -1,
            v18,
        }

        while true do
            local v23 = tbl10[3]
            local v24 = tbl10[1]
            local n8 = tbl10[4] + v23

            tbl10[4] = n8

            if n8 <= v24 then
                local n82 = n8
                local n9 = (n6 * n82 + n7) % 256
                local n10 = (n6 * n9 + n7) % 256
                local n11 = (n6 * n10 + n7) % 256
                local n12 = (n6 * n11 + n7) % 256

                tbl8[n82] = n9 + n10 * 256 + n11 * 65536 + n12 * 16777216
                tbl9[n82] = n12
            else
                break
            end
        end

        local v23 = tbl10[5]

        buffer.create(16)

        local v24 = nil
        local v25 = nil
        local n8 = 5
        local n9 = 6

        r__R17[n8] = 2
        r__R17[n9] = 6

        local n10 = 13
        local n11 = 14

        r__R17[n10] = 4
        r__R17[n11] = 8

        local n12 = 21
        local n13 = 22
        local n14 = 23
        local n15 = 24

        r__R17[n12] = 2
        r__R17[n13] = 7
        r__R17[n14] = 12
        r__R17[n15] = 13

        local n16 = 29
        local n17 = 30
        local n18 = 31

        r__R17[n16] = 4
        r__R17[n17] = 5
        r__R17[n18] = 10

        local tbl11 = {}
        local tbl12 = {
            v23,
            nil,
            1,
            -1,
            16,
        }

        while true do
            local v26 = tbl12[3]
            local v27 = tbl12[5]
            local n19 = tbl12[4] + v26

            tbl12[4] = n19

            if n19 <= v27 then
                tbl11[{}] = n19 + 1
            else
                break
            end
        end

        local v26 = tbl12[1]

        iter_G_1 = (function(f, s, var)
            local co = coroutine.wrap(function()
                coroutine.yield()

                for k, v27, v32, v42, v52, v62, v72, v82, v92, v102 in f, s, var do
                    coroutine.yield(true, k, v27, v32, v42, v52, v62, v72, v82, v92, v102)
                end
            end)

            co()

            return co
        end)(tbl11, nil, nil)

        local packedValues4 = table.pack(iter_G_1())

        if packedValues4[1] then
            while true do
                local packedValues = table.pack(iter_G_1())

                if packedValues[1] then
                else
                    break
                end
            end
        end

        local n19 = 0 / 0
        local tbl13 = {}
        local tbl14 = {
            1,
            nil,
            6,
            0,
            v26,
        }

        while true do
            local v28 = tbl14[1]
            local v29 = tbl14[3]
            local n20 = tbl14[4] + v28

            tbl14[4] = n20

            if n20 <= v29 then
                n19 = (n19 * 1103515245 + 12345) % 16777216
                tbl13[n20] = n19
            else
                break
            end
        end

        local tbl15 = {
            6,
            1,
            0,
            tbl14[5],
            nil,
        }

        while true do
            local v28 = tbl15[2]
            local v29 = tbl15[1]
            local n20 = tbl15[3] + v28

            tbl15[3] = n20

            if n20 <= v29 then
            else
                break
            end
        end
        while true do
            if v15 == 168.00000000000844 then
            end

            local exitTo5 = nil

            while true do
                packedValues();

                (nil)[v25] = v24
                uDim2New = str.wait

                if randInt < 245 then
                    if not (nil < 92) then
                        continue
                    end

                    break
                else
                    exitTo5 = 1

                    break
                end
            end

            if exitTo5 == 1 then
                n2 = n22

                continue
            end

            break
        end
    end
end

print('Deobf By Zed')

return 0.9230769276618958, nil
