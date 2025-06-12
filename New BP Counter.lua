local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


if get_hidden_gui or gethui then
	local hiddenUI = get_hidden_gui or gethui
	for i,v in pairs(hiddenUI():GetChildren()) do
		if v:IsA(uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('rmQunSIfGMSASDEkKTUuDbZRpoFOaUCgCaWBIHnuLnXOPTdcDYzMrhGU2NyZWVuR3Vp')) and v.Name == uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('RfVPRUTNvKDFfFzDnDLAEyGgpwtgxzOoNwmqBaJmmhXeFjgBkjTrmhGR2FpblVJ') then
			v:Destroy()
		end
	end
elseif syn and syn.protect_gui then
	for i,v in pairs(game.CoreGui:GetChildren()) do
		if v:IsA(uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('MgRjEPUhmALaKyCWieNVKEtNGhFjOLpipyrljNdnVKaaGpGxKxOAnGIU2NyZWVuR3Vp')) and v.Name == uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('WJHaRYTQahAeCPsKyhLFvbztGpPvcUtlIasDyYHbnnRCDtunULQdqrtR2FpblVJ') then
			syn.unprotect_gui(v)
			v:Destroy()
		end
	end
else
	for i,v in pairs(game.CoreGui:GetChildren()) do
		if v:IsA(uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('eYZEKMRDYMansfPCYnyQZAAqLuoZySODYznSkEudHhrZVOVutSxuORHU2NyZWVuR3Vp')) and v.Name == uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('KeakOkUmfYBNjuFiryhshIDQmypqIPUzmhdCAXgIAVQnyrlwoubFjAyR2FpblVJ') then
			v:Destroy()
		end
	end
end

local GainUI = Instance.new(uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('uCpDqfevelEnLRLIaMdDlBJUJJbysmXxuobKPHAWTDTRVqjTQwzHVcJU2NyZWVuR3Vp'))
local BpGain = Instance.new(uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('rVyTZZwsQltXUHuDPBYgiipkAlLnDUTjPjtQEmBVrvJPZRXQQWhikepVGV4dExhYmVs'))
local PrestigeGain = Instance.new(uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('FUtNIjIAbXsPOavLiMqkINdyLxZvreoXvxZVzdtizLAIGtiKlElLypkVGV4dExhYmVs'))

GainUI.Name = uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('koMXvkakKVPsKwAwyhSAMJHrNAgHhHfyFIxkEMmuaTEiTtmBjlbhEHmR2FpblVJ')
GainUI.Parent = game.CoreGui

local plr = game.Players.LocalPlayer

local bp = plr.leaderstats[uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('ZjgZVGYxEgtDKjoqRbwwxdegfSGjXfOLJImCbzIJYHLVgRAwfObLWtSQnVycCBwb2ludHM=')]
local prestige = plr.leaderstats[uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('blrodJbHhmiXfjDZYMWShvXmJHuuQXLtqXGDtqoCxbTkQvFTBnlnlSXUHJlc3RpZ2U=')]

PrestigeGain.Name = uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('kZqLmzxcLJbIvIeYYPeKEQeYeGfSNlwHEcgEtDNrXyMcVmUyDaAfDwEUHJlc3RpZ2VHYWlu')
PrestigeGain.Parent = GainUI
PrestigeGain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PrestigeGain.BackgroundTransparency = 1.000
PrestigeGain.BorderColor3 = Color3.fromRGB(0, 0, 0)
PrestigeGain.BorderSizePixel = 0
PrestigeGain.Position = UDim2.new(0.029, 0,0.144, 0)
PrestigeGain.Size = UDim2.new(0, 185, 0, 50)
PrestigeGain.Font = Enum.Font.SourceSansBold
PrestigeGain.TextColor3 = Color3.fromRGB(255, 0, 0)
PrestigeGain.TextScaled = true
PrestigeGain.TextSize = 14.000
PrestigeGain.TextWrapped = true

BpGain.Name = uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('YstESNyUEMvbzPoiVsdKFKJqwrNIqftGKOTqoTGJMSBsDAgqqOwfeHjQnBHYWlu')
BpGain.Parent = GainUI
BpGain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BpGain.BackgroundTransparency = 1.000
BpGain.BorderColor3 = Color3.fromRGB(0, 0, 0)
BpGain.BorderSizePixel = 0
BpGain.Position = UDim2.new(0.029, 0,0.230, 0)
BpGain.Size = UDim2.new(0, 185, 0, 50)
BpGain.Font = Enum.Font.SourceSansBold
BpGain.TextColor3 = Color3.fromRGB(255, 0, 0)
BpGain.TextScaled = true
BpGain.TextSize = 14.000
BpGain.TextWrapped = true

cp = 0

while wait() do
	PrestigeGain.Text = uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('luXqAidyzYIIbLxGtYmRTrOOlCnFCrwteNxnlwOAbGMGBKMBtMPGMJUUHJlc3RpZ2U6IA==')..prestige.Value
        if cp ~= bp.Value then
	BpGain.Text = uttWGYUTxhasNlWoKmleGnnglpoaVwMGMIXUHKdwtFnaMmoZhdCtbAEdWmiyJBvJUR('DhVbiHFNxEZaaUFCPFJYoURHFVMKmldBuDKBgdVlSfGndvxcQTJdbdFQnA6IA==')..bp.Value - cp
        cp = bp.Value
end
end    
