--[[OS-V3B,Beta,(+20xSec)"LVL5",Api:Soon]]
-- Avery's Obfuscator for Delta Executor

local function randomVar(len)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local name = ""
    for i = 1, len do
        local rand = math.random(1, #chars)
        name = name .. string.sub(chars, rand, rand)
    end
    return name
end

local function encodeString(str)
    local bytes = {}
    for i = 1, #str do
        table.insert(bytes, string.byte(string.sub(str, i, i)))
    end
    return "string.char(" .. table.concat(bytes, ",") .. ")"
end

-- 🟢 Replace with your own script or use game:HttpGet()
local source = [[
local Players = game:GetService("Players")
local player = Players.LocalPlayer
print("Hello Avery!")
]]

-- Rename vars
local renames = { "Players", "player" }
for _, word in ipairs(renames) do
    local newName = randomVar(6)
    source = source:gsub(word, newName)
end

-- Encode strings
source = source:gsub('"(.-)"', function(s)
    return encodeString(s)
end)

-- Wrap
local final = "--[[OS-V3B,LVL5]]\ndo\n" .. source .. "\nend"

-- 🟢 Save to file in Delta workspace
writefile("Obfuscated.lua", final)
print("✅ Saved obfuscated script as Obfuscated.lua in your Delta folder")
