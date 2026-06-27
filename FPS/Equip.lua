-- Advanced, Optimized Auto-Equip Drink Script
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Configuration Table (Ordered lowest max-drink limit to highest)
local DRINK_TIERS = {
    { max = 150,        name = "Starter Drink" },
    { max = 500,        name = "Second Drink" },
    { max = 1600,       name = "Third Drink" },
    { max = 3500,       name = "Fourth Drink" },
    { max = 10000,      name = "Fifth Drink" },
    { max = 25000,      name = "Sixth Drink" },
    { max = 60000,      name = "Seventh Drink" },
    { max = 150000,     name = "Eighth Drink" },
    { max = 230000,     name = "Ninth Drink" },
    { max = 500000,     name = "Tenth Drink" },
    { max = 1000000,    name = "Eleventh Drink" },
    { max = 2000000,    name = "Twelfth Drink" },
    { max = 5000000,    name = "Third Drink" }, -- Reused name from original code
    { max = 10000000,   name = "Fourth Drink" },
    { max = 20000000,   name = "Fifth Drink" },
    { max = 50000000,   name = "Sixth Drink" },
    { max = 100000000,  name = "Ninth Drink" },
    { max = 250000000,  name = "Atomic Drink" },
    { max = 500000000,  name = "Omega Burp Juice" },
    { max = 1000000000, name = "Thunder Fizz" },
    { max = math.huge,  name = "Garlic Juice" } -- math.huge covers everything above the last tier
}

local function getTargetDrinkName(currentDrinks)
    for _, tier in ipairs(DRINK_TIERS) do
        if currentDrinks <= tier.max then
            return tier.name
        end
    end
    return "Starter Drink" -- Fallback safely
end

local function manageAutoEquip()
    while true do
        task.wait(0.5) -- Throttled loop checks twice per second (low CPU overhead)
        
        local character = localPlayer.Character
        local backpack = localPlayer:FindFirstChild("Backpack")
        local leaderstats = localPlayer:FindFirstChild("leaderstats")
        
        if character and backpack and leaderstats then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local drinksStat = leaderstats:FindFirstChild("Drinks")
            
            -- Check if health is valid to avoid equipping errors mid-death
            if humanoid and humanoid.Health > 0 and drinksStat then
                local currentDrinks = drinksStat.Value
                local targetDrinkName = getTargetDrinkName(currentDrinks)
                
                -- Anti-Softlock check: Reset character if the foundational tool is totally missing
                if not backpack:FindFirstChild("Starter Drink") and not character:FindFirstChild("Starter Drink") then
                    character:BreakJoints()
                    task.wait(2) -- Wait for respawn
                else
                    -- Check if the correct tool is already equipped
                    local equippedTool = character:FindFirstChildOfClass("Tool")
                    if not equippedTool or equippedTool.Name ~= targetDrinkName then
                        
                        -- Find the tool in the backpack
                        local targetTool = backpack:FindFirstChild(targetDrinkName)
                        if targetTool then
                            humanoid:EquipTool(targetTool)
                        end
                    end
                end
            end
        end
    end
end

-- Run in a safe thread context
task.spawn(manageAutoEquip)
