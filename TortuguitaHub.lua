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

-- ESP TAB

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPTab = Window:CreateTab("ESP", 6023426915)

-- Sections
local PlayerESPSection = ESPTab:CreateSection("Player ESP")
local ItemESPSection = ESPTab:CreateSection("Item ESP")
local SoundESPSection = ESPTab:CreateSection("Sound ESP")
local VisionESPSection = ESPTab:CreateSection("Vision ESP")

-- ESP State
local ESPEnabled = false
local PlayerESPSettings = {
    Boxes = true,
    Names = true,
    Health = true,
    Distance = false,
    Tracers = false,
    Skeleton = false,
    Chams = false,
    Color = Color3.fromRGB(0, 150, 255),
    Transparency = 0.5,
    MaxDistance = 1000,
}

local ItemESPSettings = {
    Enabled = false,
    Filter = {},
    Color = Color3.fromRGB(0, 255, 0),
    Transparency = 0.6,
}

local SoundESPSettings = {
    Enabled = false,
    ShowFootsteps = true,
    Color = Color3.fromRGB(255, 100, 0),
}

local VisionESPSettings = {
    Enabled = false,
    ShowLines = true,
    LineColor = Color3.fromRGB(255, 0, 0),
}

-- Containers for ESP Objects
local PlayerESPObjects = {}
local ItemESPObjects = {}
local SoundESPObjects = {}
local VisionESPObjects = {}

-- Helper: Create Drawing objects safely (avoid detection)
local function CreateDrawing(type)
    local success, drawing = pcall(function() return Drawing.new(type) end)
    if success then return drawing end
    return nil
end

-- Function to create box for player
local function CreatePlayerBox(player)
    local box = CreateDrawing("Square")
    if not box then return nil end
    box.Color = PlayerESPSettings.Color
    box.Transparency = 1 - PlayerESPSettings.Transparency
    box.Thickness = 2
    box.Filled = false
    box.Visible = false
    return box
end

-- Function to create tracer line for player
local function CreateTracer(player)
    local line = CreateDrawing("Line")
    if not line then return nil end
    line.Color = PlayerESPSettings.Color
    line.Transparency = 1 - PlayerESPSettings.Transparency
    line.Thickness = 1.5
    line.Visible = false
    return line
end

-- Function to create name label
local function CreateNameLabel(player)
    local text = CreateDrawing("Text")
    if not text then return nil end
    text.Text = player.Name
    text.Color = PlayerESPSettings.Color
    text.Size = 14
    text.Visible = false
    text.Center = true
    text.Outline = true
    return text
end

-- Clear ESP drawings for players
local function ClearPlayerESP()
    for _, objs in pairs(PlayerESPObjects) do
        if objs.Box then objs.Box:Remove() end
        if objs.Tracer then objs.Tracer:Remove() end
        if objs.NameLabel then objs.NameLabel:Remove() end
    end
    PlayerESPObjects = {}
end

-- Update player ESP each frame
local function UpdatePlayerESP()
    if not ESPEnabled or not PlayerESPSettings.Boxes then
        ClearPlayerESP()
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen and (root.Position - Camera.CFrame.Position).Magnitude <= PlayerESPSettings.MaxDistance then
                local box = PlayerESPObjects[player] and PlayerESPObjects[player].Box or CreatePlayerBox(player)
                local tracer = PlayerESPObjects[player] and PlayerESPObjects[player].Tracer or CreateTracer(player)
                local nameLabel = PlayerESPObjects[player] and PlayerESPObjects[player].NameLabel or CreateNameLabel(player)

                local size = Vector2.new(1000 / screenPos.Z, 1000 / screenPos.Z)
                box.Size = size
                box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                box.Color = PlayerESPSettings.Color
                box.Transparency = 1 - PlayerESPSettings.Transparency
                box.Visible = true

                tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                tracer.Color = PlayerESPSettings.Color
                tracer.Transparency = 1 - PlayerESPSettings.Transparency
                tracer.Visible = PlayerESPSettings.Tracers

                nameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - (size.Y / 2) - 15)
                nameLabel.Color = PlayerESPSettings.Color
                nameLabel.Visible = PlayerESPSettings.Names

                PlayerESPObjects[player] = {
                    Box = box,
                    Tracer = tracer,
                    NameLabel = nameLabel,
                }
            else
                if PlayerESPObjects[player] then
                    if PlayerESPObjects[player].Box then PlayerESPObjects[player].Box.Visible = false end
                    if PlayerESPObjects[player].Tracer then PlayerESPObjects[player].Tracer.Visible = false end
                    if PlayerESPObjects[player].NameLabel then PlayerESPObjects[player].NameLabel.Visible = false end
                end
            end
        end
    end
end

-- Rayfield Controls for Player ESP Section

PlayerESPSection:CreateToggle({
    Name = "Enable Player ESP",
    CurrentValue = false,
    Flag = "PlayerESPEnabled",
    Callback = function(value)
        ESPEnabled = value
        if not value then ClearPlayerESP() end
    end
})

PlayerESPSection:CreateToggle({
    Name = "Show Boxes",
    CurrentValue = true,
    Flag = "PlayerESPBoxes",
    Callback = function(value)
        PlayerESPSettings.Boxes = value
    end
})

PlayerESPSection:CreateToggle({
    Name = "Show Names",
    CurrentValue = true,
    Flag = "PlayerESPNames",
    Callback = function(value)
        PlayerESPSettings.Names = value
    end
})

PlayerESPSection:CreateToggle({
    Name = "Show Health",
    CurrentValue = true,
    Flag = "PlayerESPHealth",
    Callback = function(value)
        PlayerESPSettings.Health = value
    end
})

PlayerESPSection:CreateToggle({
    Name = "Show Distance",
    CurrentValue = false,
    Flag = "PlayerESPDistance",
    Callback = function(value)
        PlayerESPSettings.Distance = value
    end
})

PlayerESPSection:CreateToggle({
    Name = "Show Tracers",
    CurrentValue = false,
    Flag = "PlayerESPTracers",
    Callback = function(value)
        PlayerESPSettings.Tracers = value
    end
})

PlayerESPSection:CreateSlider({
    Name = "Max ESP Distance",
    Range = {100, 5000},
    Increment = 100,
    CurrentValue = 1000,
    Flag = "PlayerESPMaxDistance",
    Callback = function(value)
        PlayerESPSettings.MaxDistance = value
    end
})

PlayerESPSection:CreateColorPicker({
    Name = "ESP Color",
    Default = PlayerESPSettings.Color,
    Flag = "PlayerESPColor",
    Callback = function(color)
        PlayerESPSettings.Color = color
    end
})

PlayerESPSection:CreateSlider({
    Name = "ESP Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = PlayerESPSettings.Transparency,
    Flag = "PlayerESPTransparency",
    Callback = function(value)
        PlayerESPSettings.Transparency = value
    end
})

PlayerESPSection:CreateButton({
    Name = "Clear Player ESP",
    Callback = function()
        ClearPlayerESP()
    end
})

-- You can add similar sections and controls for ItemESPSection, SoundESPSection, VisionESPSection following the same model.

-- Update loop for ESP (basic example)
RunService.RenderStepped:Connect(function()
    pcall(function()
        if ESPEnabled then
            UpdatePlayerESP()
            -- UpdateItemESP()
            -- UpdateSoundESP()
            -- UpdateVisionESP()
        else
            ClearPlayerESP()
            -- ClearItemESP()
            -- ClearSoundESP()
            -- ClearVisionESP()
        end
    end)
end)
