local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TortuguitaHub V4😈",
   Icon = 127258061389157, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "TortuguitaHub 🐢",
   LoadingSubtitle = "by TortuguitaXP_ofc",
   ShowText = "TortugaHub 🐢", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "TortugaHub😈🐢"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-- ESP Settings Table
local ESPSettings = {
    Enabled = false,
    Boxes = true,
    Names = true,
    Tracers = false,
    Distance = false,
    TeamCheck = false,
    HealthBar = false,
    Thickness = 2,
    Range = 3000,
    Mode = "All",
    Color = Color3.fromRGB(0, 170, 255)
}

-- ESP Tab
local ESPtab = Window:CreateTab("📦 ESP", 4483362458)

-- SECTION: Main ESP Features
ESPtab:CreateSection("Main Features")

ESPtab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = ESPSettings.Enabled,
    Callback = function(val)
        ESPSettings.Enabled = val
        -- Hook your ESP logic toggle here
    end
})

ESPtab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = ESPSettings.Boxes,
    Callback = function(val)
        ESPSettings.Boxes = val
    end
})

ESPtab:CreateToggle({
    Name = "Name Tags",
    CurrentValue = ESPSettings.Names,
    Callback = function(val)
        ESPSettings.Names = val
    end
})

ESPtab:CreateToggle({
    Name = "Tracers",
    CurrentValue = ESPSettings.Tracers,
    Callback = function(val)
        ESPSettings.Tracers = val
    end
})

ESPtab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = ESPSettings.Distance,
    Callback = function(val)
        ESPSettings.Distance = val
    end
})

ESPtab:CreateToggle({
    Name = "Health Bar",
    CurrentValue = ESPSettings.HealthBar,
    Callback = function(val)
        ESPSettings.HealthBar = val
    end
})

-- SECTION: Visual Config
ESPtab:CreateSection("Visual Configuration")

ESPtab:CreateColorPicker({
    Name = "ESP Color",
    Color = ESPSettings.Color,
    Callback = function(color)
        ESPSettings.Color = color
    end
})

ESPtab:CreateSlider({
    Name = "Box Thickness",
    Range = {1, 5},
    Increment = 1,
    Suffix = "px",
    CurrentValue = ESPSettings.Thickness,
    Callback = function(value)
        ESPSettings.Thickness = value
    end
})

ESPtab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 5000},
    Increment = 100,
    Suffix = " studs",
    CurrentValue = ESPSettings.Range,
    Callback = function(value)
        ESPSettings.Range = value
    end
})

-- SECTION: Filters & Logic
ESPtab:CreateSection("Target Filters")

ESPtab:CreateToggle({
    Name = "Team Check",
    CurrentValue = ESPSettings.TeamCheck,
    Callback = function(val)
        ESPSettings.TeamCheck = val
    end
})

ESPtab:CreateDropdown({
    Name = "Target Mode",
    Options = {"All", "Players", "NPCs"},
    CurrentOption = ESPSettings.Mode,
    Callback = function(opt)
        ESPSettings.Mode = opt
    end
})

-- SECTION: Utility
ESPtab:CreateSection("Utilities")

ESPtab:CreateButton({
    Name = "Force ESP Refresh",
    Callback = function()
        -- You can link to your ESP update function here
        print("ESP manually refreshed.")
    end
})

ESPtab:CreateButton({
    Name = "Clear ESP Objects",
    Callback = function()
        -- Clear your ESP visuals (Drawing or BillboardGui)
        print("ESP visuals cleared.")
    end
})

ESPtab:CreateSection("Inventory")

ESPtab:CreateButton({
    Name = "Open Inventory",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local gui = plr:WaitForChild("PlayerGui")

        if gui:FindFirstChild("TortugaInventory") then
            gui.TortugaInventory.Enabled = true
            return
        end

        local invGui = Instance.new("ScreenGui", gui)
        invGui.Name = "TortugaInventory"
        invGui.ResetOnSpawn = false
        invGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local frame = Instance.new("Frame", invGui)
        frame.Size = UDim2.new(0, 500, 0, 350)
        frame.Position = UDim2.new(0.5, -250, 0.5, -175)
        frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        frame.BorderSizePixel = 0
        frame.Name = "InventoryFrame"

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Text = "🐢 Tortuga Inventory"
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Font = Enum.Font.GothamBold
        title.TextScaled = true

        local closeBtn = Instance.new("TextButton", frame)
        closeBtn.Size = UDim2.new(0, 50, 0, 30)
        closeBtn.Position = UDim2.new(1, -55, 0, 5)
        closeBtn.Text = "X"
        closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
        closeBtn.Font = Enum.Font.Gotham
        closeBtn.TextScaled = true
        closeBtn.MouseButton1Click:Connect(function()
            invGui.Enabled = false
        end)

        local refreshBtn = Instance.new("TextButton", frame)
        refreshBtn.Size = UDim2.new(0, 100, 0, 25)
        refreshBtn.Position = UDim2.new(0, 10, 0, 45)
        refreshBtn.Text = "Refresh 🔄"
        refreshBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        refreshBtn.TextColor3 = Color3.new(1, 1, 1)
        refreshBtn.Font = Enum.Font.Gotham
        refreshBtn.TextScaled = true

        local scroll = Instance.new("ScrollingFrame", frame)
        scroll.Size = UDim2.new(1, -20, 1, -85)
        scroll.Position = UDim2.new(0, 10, 0, 80)
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.BackgroundTransparency = 1
        scroll.ScrollBarThickness = 6
        scroll.BorderSizePixel = 0

        local UIGrid = Instance.new("UIGridLayout", scroll)
        UIGrid.CellSize = UDim2.new(0, 150, 0, 80)
        UIGrid.CellPadding = UDim2.new(0, 10, 0, 10)

        local function refreshInventory()
            scroll:ClearAllChildren()
            UIGrid.Parent = scroll -- reanexar layout

            for _, tool in pairs(plr.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local itemFrame = Instance.new("Frame", scroll)
                    itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                    itemFrame.BorderSizePixel = 0

                    local nameLabel = Instance.new("TextLabel", itemFrame)
                    nameLabel.Size = UDim2.new(1, -10, 0, 20)
                    nameLabel.Position = UDim2.new(0, 5, 0, 5)
                    nameLabel.Text = tool.Name
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.TextColor3 = Color3.new(1, 1, 1)
                    nameLabel.Font = Enum.Font.Gotham
                    nameLabel.TextScaled = true

                    local icon = Instance.new("ImageLabel", itemFrame)
                    icon.Size = UDim2.new(0, 40, 0, 40)
                    icon.Position = UDim2.new(0, 5, 0, 30)
                    icon.BackgroundTransparency = 1
                    icon.Image = tool.TextureId or "rbxassetid://4458901886" -- fallback image

                    local equipBtn = Instance.new("TextButton", itemFrame)
                    equipBtn.Size = UDim2.new(0, 50, 0, 20)
                    equipBtn.Position = UDim2.new(1, -55, 1, -25)
                    equipBtn.Text = "Equip"
                    equipBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 180)
                    equipBtn.TextColor3 = Color3.new(1, 1, 1)
                    equipBtn.Font = Enum.Font.Gotham
                    equipBtn.TextScaled = true

                    equipBtn.MouseButton1Click:Connect(function()
                        tool.Parent = plr.Character
                    end)

                    local dropBtn = Instance.new("TextButton", itemFrame)
                    dropBtn.Size = UDim2.new(0, 50, 0, 20)
                    dropBtn.Position = UDim2.new(0, 60, 1, -25)
                    dropBtn.Text = "Drop"
                    dropBtn.BackgroundColor3 = Color3.fromRGB(160, 60, 60)
                    dropBtn.TextColor3 = Color3.new(1, 1, 1)
                    dropBtn.Font = Enum.Font.Gotham
                    dropBtn.TextScaled = true

                    dropBtn.MouseButton1Click:Connect(function()
                        tool.Parent = workspace
                        tool.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    end)
                end
            end

            wait()
            scroll.CanvasSize = UDim2.new(0, 0, 0, UIGrid.AbsoluteContentSize.Y + 10)
        end

        refreshBtn.MouseButton1Click:Connect(refreshInventory)
        refreshInventory()
    end
})
