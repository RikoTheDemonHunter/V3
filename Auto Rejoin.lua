-- Ultra-Fast Auto-Rejoin
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

GuiService.ErrorMessageChanged:Connect(function()
    -- Instant check when the error overlay pops up
    if GuiService:GetErrorMessage() ~= "" then
        -- 0.5 second delay just to let the engine clear the routing state, then teleport
        task.wait(0.5) 
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end
end)
