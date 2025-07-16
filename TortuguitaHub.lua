local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/AbstractPoo/MainFluent/main/source.lua"))()
local Window = Fluent:CreateWindow({
    Title = "TortugaHub V5 🐢",
    SubTitle = "ESP Module",
    TabWidth = 160,
    Size = UDim2.fromOffset(540, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.K
})

-- ABA PRINCIPAL
local ESPTab = Window:AddTab({ Title = "ESP", Icon = "eye" })

-- VARIÁVEIS GLOBAIS
local ESPEnabled = false
local ShowName = false
local ShowBox = false
local ShowTracer = false
local ShowHealth = false
local ShowDistance = false
local ESPColor = Color3.fromRGB(0, 150, 255)
local Transparency = 0.5
local ActiveESP = {}

-- SEÇÃO: JOGADORES
local PlayerSection = ESPTab:AddSection("Player ESP")

PlayerSection:AddToggle({
    Title = "Enable Player ESP",
    Default = false,
    Callback = function(val)
        ESPEnabled = val
    end
})

PlayerSection:AddToggle({ Title = "Show Name", Default = false, Callback = function(v) ShowName = v end })
PlayerSection:AddToggle({ Title = "Show Box", Default = false, Callback = function(v) ShowBox = v end })
PlayerSection:AddToggle({ Title = "Show Tracer", Default = false, Callback = function(v) ShowTracer = v end })
PlayerSection:AddToggle({ Title = "Show HealthBar", Default = false, Callback = function(v) ShowHealth = v end })
PlayerSection:AddToggle({ Title = "Show Distance", Default = false, Callback = function(v) ShowDistance = v end })

PlayerSection:AddDropdown({
    Title = "ESP Color",
    Values = { "Blue", "Red", "Green", "Yellow", "White" },
    Default = "Blue",
    Multi = false,
    Callback = function(color)
        local map = {
            Blue = Color3.fromRGB(0, 150, 255),
            Red = Color3.fromRGB(255, 50, 50),
            Green = Color3.fromRGB(50, 255, 100),
            Yellow = Color3.fromRGB(255, 255, 0),
            White = Color3.fromRGB(255, 255, 255)
        }
        ESPColor = map[color]
    end
})

PlayerSection:AddSlider({
    Title = "ESP Transparency",
    Description = "Adjust highlight transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Decimals = 1,
    Callback = function(val)
        Transparency = val
    end
})

-- SEÇÃO: INVENTORY
local InventorySection = ESPTab:AddSection("Inventory ESP")

InventorySection:AddToggle({
    Title = "Enable Inventory ESP",
    Default = false,
    Callback = function(val)
        -- Lógica do inventory
        print("Inventory ESP: ", val)
    end
})

InventorySection:AddButton({
    Title = "Refresh Inventory ESP",
    Callback = function()
        -- Lógica de atualização
        print("Inventory ESP Refreshed!")
    end
})

-- FUNCIONALIDADE SIMPLES DE HIGHLIGHT (SAFE)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function ClearESP()
    for _, obj in pairs(ActiveESP) do
        if obj and obj:IsA("Highlight") then
            obj:Destroy()
        end
    end
    ActiveESP = {}
end

function ApplyHighlight(target)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = target
    highlight.FillColor = ESPColor
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = Transparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = target
    table.insert(ActiveESP, highlight)
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        ClearESP()
        if not ESPEnabled then return end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                ApplyHighlight(player.Character)
            end
        end
    end)
end)
