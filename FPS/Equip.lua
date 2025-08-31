-- Auto Equip Drink Script (Complete Unobfuscated)

function AutoEquipDrink()
    spawn(function()
        local player = game.Players.LocalPlayer
        local backpack = player.Backpack
        local character = player.Character
        local leaderstats = player.leaderstats

        -- If no Starter Drink is found, reset the character
        if backpack:FindFirstChild("Starter Drink") == nil 
        and character:FindFirstChild("Starter Drink") == nil then
            character:BreakJoints()
        end

        -- Drink count
        local drinks = leaderstats["Drinks"].Value
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if drinks == 0 then
                local tool = backpack:FindFirstChild("Starter Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 150 then
                local tool = backpack:FindFirstChild("Starter Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 500 then
                local tool = backpack:FindFirstChild("Second Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 1600 then
                local tool = backpack:FindFirstChild("Third Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 3500 then
                local tool = backpack:FindFirstChild("Fourth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 10000 then
                local tool = backpack:FindFirstChild("Fifth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 25000 then
                local tool = backpack:FindFirstChild("Sixth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 60000 then
                local tool = backpack:FindFirstChild("Seventh Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 150000 then
                local tool = backpack:FindFirstChild("Eighth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 230000 then
                local tool = backpack:FindFirstChild("Ninth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 500000 then
                local tool = backpack:FindFirstChild("Tenth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 1000000 then
                local tool = backpack:FindFirstChild("Eleventh Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 2000000 then
                local tool = backpack:FindFirstChild("Twelfth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 5000000 then
                local tool = backpack:FindFirstChild("Third Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 10000000 then
                local tool = backpack:FindFirstChild("Fourth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 20000000 then
                local tool = backpack:FindFirstChild("Fifth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 50000000 then
                local tool = backpack:FindFirstChild("Sixth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 100000000 then
                local tool = backpack:FindFirstChild("Ninth Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 250000000 then
                local tool = backpack:FindFirstChild("Atomic Drink")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 500000000 then
                local tool = backpack:FindFirstChild("Omega Burp Juice")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 1000000000 then
                local tool = backpack:FindFirstChild("Thunder Fizz")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 2000000000 then
                local tool = backpack:FindFirstChild("Garlic Juice")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks <= 1000000000 then
                local tool = backpack:FindFirstChild("Thunder Fizz")
                if tool then humanoid:EquipTool(tool) end

            elseif drinks >= 2000000000 then
                local tool = backpack:FindFirstChild("Garlic Juice")
                if tool then humanoid:EquipTool(tool) end
            end
        end
    end)
end
