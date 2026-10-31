-- Base64 utility functions
local base64 = {}

local base64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function base64.encode(data)
    local result = ""
    local i = 1
    while i <= #data do
        local a = string.byte(data, i)
        local b = i < #data and string.byte(data, i + 1) or 0
        local c = i < #data - 1 and string.byte(data, i + 2) or 0
        
        local n = (a * 0x10000 + b * 0x100 + c)
        
        if i == #data then
            result = result .. string.sub(base64chars, math.floor(n / 262144) + 1, math.floor(n / 262144) + 1)
            result = result .. string.sub(base64chars, math.floor(n / 4096) % 64 + 1, math.floor(n / 4096) % 64 + 1)
            result = result .. string.sub(base64chars, math.floor(n / 64) % 64 + 1, math.floor(n / 64) % 64 + 1)
            result = result .. "="
            break
        elseif i == #data - 1 then
            result = result .. string.sub(base64chars, math.floor(n / 16384) + 1, math.floor(n / 16384) + 1)
            result = result .. string.sub(base64chars, math.floor(n / 256) % 64 + 1, math.floor(n / 256) % 64 + 1)
            result = result .. string.sub(base64chars, math.floor(n / 4) % 64 + 1, math.floor(n / 4) % 64 + 1)
            result = result .. "=="
            i = i + 2
        else
            result = result .. string.sub(base64chars, math.floor(n / 262144) + 1, math.floor(n / 262144) + 1)
            result = result .. string.sub(base64chars, math.floor(n / 4096) % 64 + 1, math.floor(n / 4096) % 64 + 1)
            result = result .. string.sub(base64chars, math.floor(n / 64) % 64 + 1, math.floor(n / 64) % 64 + 1)
            result = result .. string.sub(base64chars, math.floor(n / 1) % 64 + 1, math.floor(n / 1) % 64 + 1)
            i = i + 3
        end
    end
    return result
end

function base64.decode(data)
    local result = ""
    local i = 1
    while i <= #data do
        local n = 0
        local j = i
        while j < i + 4 and j <= #data do
            local c = string.find(base64chars, string.sub(data, j, j))
            if c then
                n = n * 64 + c - 1
            end
            j = j + 1
        end
        
        if n == 0 then break end
        
        local a = math.floor(n / 65536)
        local b = math.floor(n / 256) % 256
        local c = n % 256
        
        result = result .. string.char(a)
        result = result .. string.char(b)
        result = result .. string.char(c)
        
        if string.sub(data, i + 3, i + 3) == "=" then
            if string.sub(data, i + 2, i + 2) == "=" then
                result = result:sub(1, #result - 1)
            else
                result = result:sub(1, #result - 2)
            end
            break
        end
        
        i = i + 4
    end
    return result
end

return base64
