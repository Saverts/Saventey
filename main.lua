loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local RunService = game:GetService("RunService")

local GUI = Mercury:Create{
    Name = "Mercury",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/deeeity/mercury-lib"
}

local Tab = GUI:Tab{
    Name = "New Tab",
    Icon = "rbxassetid://8569322835"
}

Tab:Button{
    Name = "Toggle AutoFarm",
    Description = nil,
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        -- Function to teleport and freeze the boss
        local function teleportAndFreeze(boss)
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Get the position of the player's HumanoidRootPart
                local targetPosition = hrp.Position

                -- Adjust the boss's position to stand on the same part as the player
                local newCFrame = CFrame.new(targetPosition) * CFrame.new(0, boss.PrimaryPart.Size.Y / 2, 0)

                -- Teleport the Boss dummy to the new position
                boss:SetPrimaryPartCFrame(newCFrame)

                -- Wait 0.02 seconds
                task.wait(0.02)

                -- Freeze the Boss dummy
                for _, part in pairs(boss:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
            else
                warn("HumanoidRootPart not found in the player's character.")
            end
        end

        -- Monitor the workspace for the Boss dummy
        workspace.ChildAdded:Connect(function(child)
            if child.Name == "Boss" and child:IsA("Model") then
                -- Wait for the Boss to fully load
                child:WaitForChild("HumanoidRootPart", 5) -- Adjust timeout as needed
                teleportAndFreeze(child)
            end
        end)

        -- Handle the Boss if it's already in the workspace
        local existingBoss = workspace:FindFirstChild("Boss")
        if existingBoss and existingBoss:IsA("Model") then
            teleportAndFreeze(existingBoss)
        end
    end
}


Tab:Button{
    Name = "Equip items in inv",
    Description = nil,
    Callback = function()
        local player = game.Players.LocalPlayer
        local backpack = player.Backpack

        -- Equip all items in the player's inventory
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                player.Character:FindFirstChild("Humanoid"):EquipTool(item)
                Runservice.HeartBeat:Connect(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Clicked"):FireServer()
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild(item.Name).RemoteClick:FireServer()
                end)
            end
        end
    end
}
