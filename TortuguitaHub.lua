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
      Enabled = false,
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

-- Assume que 'Window' já existe (criado antes)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Estados
local ESPEnabled = false
local HighlightEnabled = false
local BoxEnabled = false
local TracerEnabled = false
local DistanceEnabled = false
local HealthBarEnabled = false
local NameEnabled = false
local InventoryEnabled = false

local HighlightColor = Color3.fromRGB(0, 150, 255)
local HighlightTransparency = 0.5

local BoxColor = Color3.fromRGB(0, 150, 255)
local TracerColor = Color3.fromRGB(0, 150, 255)
local DistanceColor = Color3.new(1,1,1)
local HealthBarColor = Color3.fromRGB(0, 255, 0)
local NameColor = Color3.new(1,1,1)
local InventoryColor = Color3.new(1,1,1)

-- Tabelas para armazenar instâncias ESP
local Highlights = {}
local Boxes = {}
local Tracers = {}
local Distances = {}
local HealthBars = {}
local Names = {}
local Inventories = {}

-- Função auxiliar para criar BillboardGui
local function CreateBillboard(parent, name, size, offset)
    local gui = Instance.new("BillboardGui")
    gui.Name = name or "ESPGui"
    gui.Adornee = parent
    gui.AlwaysOnTop = true
    gui.Size = size or UDim2.new(0, 100, 0, 40)
    gui.StudsOffset = offset or Vector3.new(0, 3, 0)
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")
    return gui
end

-- Criar caixa (Frame) para Box ESP
local function CreateBoxGui(parent)
    local boxGui = CreateBillboard(parent, "BoxESP", UDim2.new(0, 120, 0, 60), Vector3.new(0, 3, 0))
    local frame = Instance.new("Frame", boxGui)
    frame.Name = "BoxFrame"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = BoxColor
    frame.BackgroundTransparency = 0.7
    frame.BorderColor3 = BoxColor
    frame.BorderSizePixel = 2
    frame.Parent = boxGui
    return boxGui
end

-- Criar texto label para Nome, Distância, Inventory e HealthBar
local function CreateTextLabel(parentGui, text, color, textSize)
    local label = Instance.new("TextLabel", parentGui)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = color
    label.TextStrokeColor3 = Color3.new(0,0,0)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = textSize or 16
    label.Text = text or ""
    label.TextWrapped = true
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextXAlignment = Enum.TextXAlignment.Center
    return label
end

-- Criar HealthBar GUI
local function CreateHealthBarGui(parent)
    local gui = CreateBillboard(parent, "HealthBarESP", UDim2.new(0, 80, 0, 10), Vector3.new(0, 2, 0))
    local bg = Instance.new("Frame", gui)
    bg.Name = "Background"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.new(0, 0, 0)
    bg.BackgroundTransparency = 0.7
    bg.BorderSizePixel = 0

    local bar = Instance.new("Frame", bg)
    bar.Name = "Bar"
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = HealthBarColor
    bar.BorderSizePixel = 0

    return gui, bar
end

-- Criar Tracer (linha da base da tela até jogador)
local function CreateTracer()
    local line = Instance.new("Frame")
    line.Name = "TracerLine"
    line.AnchorPoint = Vector2.new(0.5, 1)
    line.Size = UDim2.new(0, 2, 0, 0)
    line.BackgroundColor3 = TracerColor
    line.BorderSizePixel = 0
    line.Visible = false
    line.Parent = game:GetService("CoreGui")
    return line
end

-- Limpar ESP para um jogador
local function ClearPlayerESP(player)
    if Highlights[player] then Highlights[player]:Destroy() Highlights[player] = nil end
    if Boxes[player] then Boxes[player]:Destroy() Boxes[player] = nil end
    if Tracers[player] then Tracers[player]:Destroy() Tracers[player] = nil end
    if Distances[player] then Distances[player]:Destroy() Distances[player] = nil end
    if HealthBars[player] then HealthBars[player].Gui:Destroy() HealthBars[player] = nil end
    if Names[player] then Names[player]:Destroy() Names[player] = nil end
    if Inventories[player] then Inventories[player]:Destroy() Inventories[player] = nil end
end

-- Limpar tudo
local function ClearAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        ClearPlayerESP(player)
    end
end

-- Atualizar Inventory Text (simples: lista ferramentas do backpack e character)
local function UpdateInventory(player)
    local invGui = Inventories[player]
    if not invGui then return end
    local label = invGui:FindFirstChild("InventoryLabel")
    if not label then return end

    local items = {}
    local backpack = player:FindFirstChildOfClass("Backpack")
    local char = player.Character
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then table.insert(items, tool.Name) end
        end
    end
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then table.insert(items, tool.Name) end
        end
    end

    if #items == 0 then
        label.Text = "Inventory: Empty"
    else
        label.Text = "Inventory: "..table.concat(items, ", ")
    end
end

-- Criar aba ESP
local ESPTab = Window:CreateTab("ESP", 6023426915)

-- Section toggles
local GeneralSection = ESPTab:CreateSection("Configurações Gerais")

-- Toggle ESP geral
ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ToggleESP",
    Callback = function(value)
        ESPEnabled = value
        if not ESPEnabled then
            ClearAllESP()
        end
    end
})

-- Highlight toggle e configuração
ESPTab:CreateToggle({
    Name = "Highlights",
    CurrentValue = false,
    Flag = "ToggleHighlights",
    Callback = function(value)
        HighlightEnabled = value
        if not ESPEnabled then return end
        if not value then
            for _, hl in pairs(Highlights) do
                hl:Destroy()
            end
            Highlights = {}
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "Highlight Color",
    Default = HighlightColor,
    Flag = "HighlightColor",
    Callback = function(color)
        HighlightColor = color
    end
})

ESPTab:CreateSlider({
    Name = "Highlight Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = HighlightTransparency,
    Flag = "HighlightTransparency",
    Callback = function(value)
        HighlightTransparency = value
    end
})

-- Box ESP
ESPTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "ToggleBox",
    Callback = function(value)
        BoxEnabled = value
        if not BoxEnabled then
            for _, box in pairs(Boxes) do
                box:Destroy()
            end
            Boxes = {}
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "Box Color",
    Default = BoxColor,
    Flag = "BoxColor",
    Callback = function(color)
        BoxColor = color
    end
})

-- Tracer ESP
ESPTab:CreateToggle({
    Name = "Tracer ESP",
    CurrentValue = false,
    Flag = "ToggleTracer",
    Callback = function(value)
        TracerEnabled = value
        if not TracerEnabled then
            for _, tracer in pairs(Tracers) do
                tracer:Destroy()
            end
            Tracers = {}
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "Tracer Color",
    Default = TracerColor,
    Flag = "TracerColor",
    Callback = function(color)
        TracerColor = color
         end
})

-- Distance ESP toggle e cor
ESPTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = false,
    Flag = "ToggleDistance",
    Callback = function(value)
        DistanceEnabled = value
        if not DistanceEnabled then
            for _, dist in pairs(Distances) do
                dist:Destroy()
            end
            Distances = {}
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "Distance Color",
    Default = DistanceColor,
    Flag = "DistanceColor",
    Callback = function(color)
        DistanceColor = color
    end
})

-- HealthBar ESP toggle e cor
ESPTab:CreateToggle({
    Name = "HealthBar",
    CurrentValue = false,
    Flag = "ToggleHealthBar",
    Callback = function(value)
        HealthBarEnabled = value
        if not HealthBarEnabled then
            for _, hb in pairs(HealthBars) do
                hb.Gui:Destroy()
            end
            HealthBars = {}
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "HealthBar Color",
    Default = HealthBarColor,
    Flag = "HealthBarColor",
    Callback = function(color)
        HealthBarColor = color
    end
})

-- Name ESP toggle e cor
ESPTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = false,
    Flag = "ToggleName",
    Callback = function(value)
        NameEnabled = value
        if not NameEnabled then
            for _, nameGui in pairs(Names) do
                nameGui:Destroy()
            end
            Names = {}
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "Name Color",
    Default = NameColor,
    Flag = "NameColor",
    Callback = function(color)
        NameColor = color
    end
})

-- Inventory ESP toggle e cor
ESPTab:CreateToggle({
    Name = "Show Inventory",
    CurrentValue = false,
    Flag = "ToggleInventory",
    Callback = function(value)
        InventoryEnabled = value
        if not InventoryEnabled then
            for _, invGui in pairs(Inventories) do
                invGui:Destroy()
            end
            Inventories = {}
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "Inventory Color",
    Default = InventoryColor,
    Flag = "InventoryColor",
    Callback = function(color)
        InventoryColor = color
    end
})

-- Função principal de update ESP por frame
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
            local char = player.Character
            local hrp = char.HumanoidRootPart
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            -- Highlight
            if HighlightEnabled then
                if not Highlights[player] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESPHighlight"
                    hl.Adornee = char
                    hl.FillColor = HighlightColor
                    hl.OutlineTransparency = HighlightTransparency
                    hl.Parent = game:GetService("CoreGui")
                    Highlights[player] = hl
                else
                    Highlights[player].FillColor = HighlightColor
                    Highlights[player].OutlineTransparency = HighlightTransparency
                    Highlights[player].Enabled = onScreen
                end
            elseif Highlights[player] then
                Highlights[player]:Destroy()
                Highlights[player] = nil
            end

            -- Box ESP
            if BoxEnabled then
                if not Boxes[player] then
                    Boxes[player] = CreateBoxGui(hrp)
                end
                local boxGui = Boxes[player]
                boxGui.Frame.BackgroundColor3 = BoxColor
                boxGui.Adornee = hrp
                boxGui.Enabled = onScreen
            elseif Boxes[player] then
                Boxes[player]:Destroy()
                Boxes[player] = nil
            end

            -- Tracer ESP
            if TracerEnabled then
                if not Tracers[player] then
                    local line = CreateTracer()
                    Tracers[player] = line
                end
                local tracer = Tracers[player]
                tracer.BackgroundColor3 = TracerColor
                tracer.Visible = onScreen

                if onScreen then
                    local screenPos = Vector2.new(rootPos.X, rootPos.Y)
                    local bottomCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    local distance = (screenPos - bottomCenter).Magnitude
                    tracer.Size = UDim2.new(0, 2, 0, distance)
                    tracer.Position = UDim2.new(0, bottomCenter.X, 0, bottomCenter.Y)
                    local direction = (screenPos - bottomCenter).Unit
                    local angle = math.deg(math.atan2(direction.Y, direction.X)) - 90
                    tracer.Rotation = angle
                end
            elseif Tracers[player] then
                Tracers[player]:Destroy()
                Tracers[player] = nil
            end

            -- Distance ESP
            if DistanceEnabled then
                if not Distances[player] then
                    local distGui = CreateBillboard(hrp, "DistanceESP", UDim2.new(0, 100, 0, 20), Vector3.new(0, 5, 0))
                    local distLabel = CreateTextLabel(distGui, "", DistanceColor, 14)
                    distLabel.Name = "DistanceLabel"
                    Distances[player] = distGui
                end
                local distGui = Distances[player]
                local distLabel = distGui:FindFirstChild("DistanceLabel")
                local distText = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                distLabel.Text = distText .. "m"
                distLabel.TextColor3 = DistanceColor
                distGui.Enabled = onScreen
            elseif Distances[player] then
                Distances[player]:Destroy()
                Distances[player] = nil
            end

            -- HealthBar ESP
            if HealthBarEnabled then
                if not HealthBars[player] then
                    local gui, bar = CreateHealthBarGui(hrp)
                    HealthBars[player] = {Gui = gui, Bar = bar}
                end
                local hb = HealthBars[player]
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                hb.Bar.Size = UDim2.new(healthPercent, 0, 1, 0)
                hb.Bar.BackgroundColor3 = HealthBarColor
                hb.Gui.Enabled = onScreen
            elseif HealthBars[player] then
                HealthBars[player].Gui:Destroy()
                HealthBars[player] = nil
            end

            -- Name ESP
            if NameEnabled then
                if not Names[player] then
                    local nameGui = CreateBillboard(hrp, "NameESP", UDim2.new(0, 120, 0, 20), Vector3.new(0, 4, 0))
                    local nameLabel = CreateTextLabel(nameGui, player.Name, NameColor, 16)
                    nameLabel.Name = "NameLabel"
                    Names[player] = nameGui
                end
                local nameGui = Names[player]
                local nameLabel = nameGui:FindFirstChild("NameLabel")
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = NameColor
                nameGui.Enabled = onScreen
            elseif Names[player] then
                Names[player]:Destroy()
                Names[player] = nil
            end

            -- Inventory ESP
            if InventoryEnabled then
                if not Inventories[player] then
                    local invGui = CreateBillboard(hrp, "InventoryESP", UDim2.new(0, 200, 0, 40), Vector3.new(0, 6, 0))
                    local invLabel = CreateTextLabel(invGui, "", InventoryColor, 14)
                    invLabel.Name = "InventoryLabel"
                    Inventories[player] = invGui
                end
                UpdateInventory(player)
                local invGui = Inventories[player]
                local invLabel = invGui:FindFirstChild("InventoryLabel")
                invLabel.TextColor3 = InventoryColor
                invGui.Enabled = onScreen
            elseif Inventories[player] then
                Inventories[player]:Destroy()
                Inventories[player] = nil
            end

        else
            ClearPlayerESP(player)
        end
    end
end)

-- Limpar ESP ao sair do jogo ou reiniciar personagem
Players.PlayerRemoving:Connect(function(player)
    ClearPlayerESP(player)
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if ESPEnabled then
            -- ESP vai ser criado no RenderStepped automaticamente
        end
    end)
end)
