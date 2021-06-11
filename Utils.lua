local addonName = "KillOnSight"
local KillOnSight = LibStub("AceAddon-3.0"):GetAddon(addonName)
local LibST = LibStub("ScrollingTable")


-- Credits to https://gist.github.com/yuhanz/6688d474a3c391daa6d6

function KillOnSight:tableToString(table)
	return KillOnSight:serializeTable(table)
end

function KillOnSight:stringToTable(str)
	local f = loadstring("return "..str)
    if f == nil then
        return nil
    end
	return f()
end

function KillOnSight:serializeTable(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..KillOnSight:serializeTable(v, endkey)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "{" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end


-- Credits to https://github.com/toastdriven/lua-base64/blob/master/base64.lua

local index_table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function KillOnSight:ToBinary(integer)
    local remaining = tonumber(integer)
    local bin_bits = ''

    for i = 7, 0, -1 do
        local current_power = 2 ^ i

        if remaining >= current_power then
            bin_bits = bin_bits .. '1'
            remaining = remaining - current_power
        else
            bin_bits = bin_bits .. '0'
        end
    end

    return bin_bits
end

function KillOnSight:FromBinary(bin_bits)
    return tonumber(bin_bits, 2)
end

function KillOnSight:ToBase64(to_encode)
    local bit_pattern = ''
    local encoded = ''
    local trailing = ''

    for i = 1, string.len(to_encode) do
        bit_pattern = bit_pattern .. KillOnSight:ToBinary(string.byte(string.sub(to_encode, i, i)))
    end

    -- Check the number of bytes. If it's not evenly divisible by three,
    -- zero-pad the ending & append on the correct number of ``=``s.
    if string.len(bit_pattern) % 3 == 2 then
        trailing = '=='
        bit_pattern = bit_pattern .. '0000000000000000'
    elseif string.len(bit_pattern) % 3 == 1 then
        trailing = '='
        bit_pattern = bit_pattern .. '00000000'
    end

    for i = 1, string.len(bit_pattern), 6 do
        local byte = string.sub(bit_pattern, i, i+5)
        local offset = tonumber(KillOnSight:FromBinary(byte))
        encoded = encoded .. string.sub(index_table, offset+1, offset+1)
    end

    return string.sub(encoded, 1, -1 - string.len(trailing)) .. trailing
end

function KillOnSight:FromBase64(to_decode)
    local padded = to_decode:gsub("%s", "")
    local unpadded = padded:gsub("=", "")
    local bit_pattern = ''
    local decoded = ''

    for i = 1, string.len(unpadded) do
        local char = string.sub(to_decode, i, i)
        local offset, _ = string.find(index_table, char)
        if offset == nil then
             error("Invalid character '" .. char .. "' found.")
        end

        bit_pattern = bit_pattern .. string.sub(KillOnSight:ToBinary(offset-1), 3)
    end

    for i = 1, string.len(bit_pattern), 8 do
        local byte = string.sub(bit_pattern, i, i+7)
        decoded = decoded .. string.char(KillOnSight:FromBinary(byte))
    end

    local padding_length = padded:len()-unpadded:len()

    if (padding_length == 1 or padding_length == 2) then
        decoded = decoded:sub(1,-2)
    end
    return decoded
end

function KillOnSight:PrettyPrint(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. KillOnSight:PrettyPrint(v) .. ','
       end
       return s .. '} '
    else
       print(tostring(o))
    end
 end

 function KillOnSight:Sort(obj, rowa, rowb, sortbycol, columnID)
    local column = obj.cols[sortbycol]
    local direction = column.sort or column.defaultsort or LibST.SORT_ASC
    local rowA = tostring(obj.data[rowa]["cols"][columnID]["value"])
    local rowB = tostring(obj.data[rowb]["cols"][columnID]["value"])

    if direction == LibST.SORT_ASC then
        return rowA > rowB
    else
        return rowA < rowB
    end
end