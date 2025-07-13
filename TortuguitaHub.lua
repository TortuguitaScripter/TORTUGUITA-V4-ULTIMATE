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

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// Vars
local espSettings = {
    Enabled = false,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
    MaxDistance = 300,
    TeamCheck = false,
    Color = Color3.fromRGB(0, 255, 255)
}

local espObjects = {}

--// Create Tabs
local ESPtab = Window:CreateTab("ESP", 4483362458)
local InventoryTab = Window:CreateTab("Inventory", 4483362458)

--// ESP: Sections
local General = ESPtab:CreateSection("General")
local Features = ESPtab:CreateSection("Features")

--// General Options
General:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = function(val)
        espSettings.Enabled = val
        if not val then
            for _, obj in pairs(espObjects) do
                if obj and obj:FindFirstChild("Label") then
                    obj:Destroy()
                end
            end
            espObjects = {}
        end
    end
})

General:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(val)
        espSettings.TeamCheck = val
    end
})

General:CreateSlider({
    Name = "Max Distance",
    Range = {50, 1000},
    Increment = 50,
    CurrentValue = 300,
    Suffix = " studs",
    Callback = function(val)
        espSettings.MaxDistance = val
    end
})

--// Feature Toggles
Features:CreateToggle({
    Name = "Show Name",
    CurrentValue = true,
    Callback = function(val)
        espSettings.ShowName = val
    end
})

Features:CreateToggle({
    Name = "Show Health",
    CurrentValue = true,
    Callback = function(val)
        espSettings.ShowHealth = val
    end
})

Features:CreateToggle({
    Name = "Show Distance",
    CurrentValue = true,
    Callback = function(val)
        espSettings.ShowDistance = val
    end
})

Features:CreateDropdown({
    Name = "Text Color",
    Options = {"Cyan", "Red", "Green", "White"},
    CurrentOption = "Cyan",
    Callback = function(opt)
        local map = {
            Cyan = Color3.fromRGB(0,255,255),
            Red = Color3.fromRGB(255,0,0),
            Green = Color3.fromRGB(0,255,0),
            White = Color3.fromRGB(255,255,255)
        }
        espSettings.Color = map[opt]
    end
})

--// ESP Logic
RunService.RenderStepped:Connect(function()
    if not espSettings.Enabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local teamOK = not espSettings.TeamCheck or (plr.Team ~= LocalPlayer.Team)
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude

            if teamOK and distance <= espSettings.MaxDistance then
                if not espObjects[plr] then
                    local tag = Instance.new("BillboardGui")
                    tag.Name = "ESP"
                    tag.Size = UDim2.new(0, 200, 0, 30)
                    tag.Adornee = plr.Character.Head
                    tag.StudsOffset = Vector3.new(0, 2.5, 0)
                    tag.AlwaysOnTop = true
                    tag.Parent = plr.Character:FindFirstChild("Head")

                    local label = Instance.new("TextLabel")
                    label.Name = "Label"
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Font = Enum.Font.GothamBold
                    label.TextScaled = true
                    label.TextColor3 = espSettings.Color
                    label.Parent = tag

                    espObjects[plr] = tag
                end

                local text = ""
                if espSettings.ShowName then text = text .. plr.Name end
                if espSettings.ShowHealth and plr.Character:FindFirstChildOfClass("Humanoid") then
                    text = text .. " | HP: " .. math.floor(plr.Character:FindFirstChildOfClass("Humanoid").Health)
                end
                if espSettings.ShowDistance then
                    text = text .. " | " .. math.floor(distance) .. " studs"
                end

                if espObjects[plr] and espObjects[plr]:FindFirstChild("Label") then
                    espObjects[plr].Label.Text = text
                    espObjects[plr].Label.TextColor3 = espSettings.Color
                end
            else
                if espObjects[plr] then
                    espObjects[plr]:Destroy()
                    espObjects[plr] = nil
                end
            end
        elseif espObjects[plr] then
            espObjects[plr]:Destroy()
            espObjects[plr] = nil
        end
    end
end)

--// INVENTORY SYSTEM
InventoryTab:CreateSection("Inventory")

InventoryTab:CreateButton({
    Name = "Show Backpack Items",
    Callback = function()
        local items = {}
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(items, tool.Name)
            end
        end
        if #items == 0 then
            Rayfield:Notify({
                Title = "Inventory",
                Content = "You have no items in your backpack.",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Inventory",
                Content = "Tools: " .. table.concat(items, ", "),
                Duration = 6
            })
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local highlights = {}
local espEnabled = false
local teamCheck = false
local highlightColor = Color3.fromRGB(0, 255, 255)

local function createHighlight(plr)
    if highlights[plr] then return end
    local char = plr.Character
    if not char then return end

    local hl = Instance.new("Highlight")
    hl.Name = "ESP_Highlight"
    hl.Adornee = char
    hl.FillColor = highlightColor
    hl.OutlineColor = highlightColor
    hl.FillTransparency = 0.75
    hl.OutlineTransparency = 0
    hl.Parent = char

    highlights[plr] = hl
end

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local sameTeam = (plr.Team == LocalPlayer.Team)
            if not teamCheck or not sameTeam then
                createHighlight(plr)
                if highlights[plr] then
                    highlights[plr].FillColor = highlightColor
                    highlights[plr].OutlineColor = highlightColor
                end
            elseif highlights[plr] then
                highlights[plr]:Destroy()
                highlights[plr] = nil
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if highlights[plr] then
        highlights[plr]:Destroy()
        highlights[plr] = nil
    end
end)

-- 🧩 Section da aba ESP
local Section = ESPtab:CreateSection("Highlight ESP")

Section:CreateToggle({
    Name = "Enable Highlight ESP",
    CurrentValue = false,
    Callback = function(val)
        espEnabled = val
        if not val then
            for _, hl in pairs(highlights) do
                hl:Destroy()
            end
            highlights = {}
        end
    end
})

Section:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(val)
        teamCheck = val
    end
})

Section:CreateDropdown({
    Name = "Highlight Color",
    Options = {"Cyan", "Red", "Green", "Yellow", "White"},
    CurrentOption = "Cyan",
    Callback = function(opt)
        local map = {
            Cyan = Color3.fromRGB(0,255,255),
            Red = Color3.fromRGB(255,0,0),
            Green = Color3.fromRGB(0,255,0),
            Yellow = Color3.fromRGB(255,255,0),
            White = Color3.fromRGB(255,255,255)
        }
        highlightColor = map[opt]
    end
})
