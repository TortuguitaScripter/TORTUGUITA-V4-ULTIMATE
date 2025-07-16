local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "TortuguitaHib V4😈🐢 " .. Fluent.Version,
    SubTitle = "by TortuguitaXP_ofc",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-- Variáveis globais e serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Estados
local ESPEnabled = false
local ShowBoxes = true
local ShowNames = true
local ShowHealth = true
local ShowDistance = true
local ESPColor = Color3.fromRGB(0, 170, 255)
local ESPTransparency = 0.4

-- Tabela pra guardar os Highlights e GUI criados
local ESPObjects = {}

-- Função pra criar Highlight no personagem
local function CreateHighlight(character)
    if ESPObjects[character] and ESPObjects[character].Highlight then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = ESPColor
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.FillTransparency = ESPTransparency
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = workspace

    ESPObjects[character] = ESPObjects[character] or {}
    ESPObjects[character].Highlight = highlight
end

-- Função pra criar Box e Nametag com Health e Distance
local function CreateBillboardGui(character)
    if ESPObjects[character] and ESPObjects[character].Billboard then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBillboard"
    billboard.Adornee = character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1,0,1,0)
    frame.Parent = billboard

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0,5,0,0)
    nameLabel.Size = UDim2.new(1,-10,0,20)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextColor3 = ESPColor
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextScaled = true
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame

    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthBar.BorderSizePixel = 0
    healthBar.Position = UDim2.new(0,5,0,25)
    healthBar.Size = UDim2.new(0.5,0,0,10)
    healthBar.Parent = frame

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Position = UDim2.new(0.6,0,0,25)
    distanceLabel.Size = UDim2.new(0.4, -5, 0, 10)
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.TextColor3 = Color3.fromRGB(255,255,255)
    distanceLabel.TextStrokeTransparency = 0.7
    distanceLabel.TextScaled = true
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Right
    distanceLabel.Parent = frame

    billboard.Parent = workspace

    ESPObjects[character] = ESPObjects[character] or {}
    ESPObjects[character].Billboard = billboard
end

-- Atualiza os textos da BillboardGui
local function UpdateBillboard(character)
    local objs = ESPObjects[character]
    if not objs or not objs.Billboard then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    local nameLabel = objs.Billboard:FindFirstChild("NameLabel", true)
    local healthBar = objs.Billboard.Frame:FindFirstChild("HealthBar")
    local distanceLabel = objs.Billboard.Frame:FindFirstChild("DistanceLabel")

    if ShowNames then
        nameLabel.Text = character.Name
        nameLabel.Visible = true
    else
        nameLabel.Visible = false
    end

    if ShowHealth then
        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        healthBar.Size = UDim2.new(healthPercent * 0.5, 0, 0, 10)
        healthBar.BackgroundColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
        healthBar.Visible = true
    else
        healthBar.Visible = false
    end

    if ShowDistance then
        local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        distanceLabel.Text = string.format("%.1f studs", dist)
        distanceLabel.Visible = true
    else
        distanceLabel.Visible = false
    end
end

-- Remove ESP de um personagem
local function RemoveESP(character)
    local objs = ESPObjects[character]
    if not objs then return end
    if objs.Highlight then
        objs.Highlight:Destroy()
    end
    if objs.Billboard then
        objs.Billboard:Destroy()
    end
    ESPObjects[character] = nil
end

-- Limpa todo ESP
local function ClearAllESP()
    for char, _ in pairs(ESPObjects) do
        RemoveESP(char)
    end
end

-- Atualiza todos os ESPs
local function UpdateAllESP()
    if not ESPEnabled then
        ClearAllESP()
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            CreateHighlight(player.Character)
            CreateBillboardGui(player.Character)
            UpdateBillboard(player.Character)
        elseif ESPObjects[player.Character] then
            RemoveESP(player.Character)
        end
    end
end

-- Conecta o update ao RenderStepped
RunService.RenderStepped:Connect(function()
    pcall(UpdateAllESP)
end)

-- ============== UI Fluent (supondo que Window já existe e é a interface criada) ==============
local ESPTab = Window:AddTab({
    Title = "ESP",
    Icon = "eye"
})

local MainSection = ESPTab:AddSection({
    Title = "Player ESP"
})

MainSection:AddToggle({
    Text = "Enable ESP",
    Default = false,
    Tooltip = "Toggle Player ESP Highlights",
    Callback = function(value)
        ESPEnabled = value
        if not value then
            ClearAllESP()
        end
    end
})

MainSection:AddToggle({
    Text = "Show Boxes (Highlight)",
    Default = true,
    Tooltip = "Show bounding boxes around players",
    Callback = function(value)
        ShowBoxes = value
        -- Highlight visibility control
        for _, objs in pairs(ESPObjects) do
            if objs.Highlight then
                objs.Highlight.Enabled = value
            end
        end
    end
})

MainSection:AddToggle({
    Text = "Show Names",
    Default = true,
    Tooltip = "Show player names",
    Callback = function(value)
        ShowNames = value
    end
})

MainSection:AddToggle({
    Text = "Show Health Bars",
    Default = true,
    Tooltip = "Show health bars below names",
    Callback = function(value)
        ShowHealth = value
    end
})

MainSection:AddToggle({
    Text = "Show Distance",
    Default = true,
    Tooltip = "Show distance to player",
    Callback = function(value)
        ShowDistance = value
    end
})

MainSection:AddDropdown({
    Text = "ESP Color",
    Default = "Blue",
    Options = {"Blue", "Red", "Green", "Yellow", "Purple"},
    Tooltip = "Choose the ESP highlight color",
    Callback = function(option)
        local colors = {
            Blue = Color3.fromRGB(0, 170, 255),
            Red = Color3.fromRGB(255, 50, 50),
            Green = Color3.fromRGB(0, 255, 0),
            Yellow = Color3.fromRGB(255, 255, 0),
            Purple = Color3.fromRGB(180, 0, 255)
        }
        ESPColor = colors[option]

        -- Update all highlight colors immediately
        for _, objs in pairs(ESPObjects) do
            if objs.Highlight then
                objs.Highlight.FillColor = ESPColor
            end
            if objs.Billboard and objs.Billboard:FindFirstChild("NameLabel") then
                objs.Billboard.NameLabel.TextColor3 = ESPColor
            end
        end
    end
})

MainSection:AddSlider({
    Text = "ESP Transparency",
    Default = 0.4,
    Min = 0,
    Max = 1,
    Increment = 0.05,
    Tooltip = "Adjust ESP highlight transparency",
    Callback = function(value)
        ESPTransparency = value
        for _, objs in pairs(ESPObjects) do
            if objs.Highlight then
                objs.Highlight.FillTransparency = ESPTransparency
            end
        end
    end
})

MainSection:AddButton({
    Text = "Clear All ESP",
    Tooltip = "Remove all ESP highlights and GUIs",
    Callback = function()
        ClearAllESP()
    end
})
