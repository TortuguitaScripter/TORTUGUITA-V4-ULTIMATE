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


-- Config tables globais
local espConfig = {
    playerESPEnabled = true,
    showName = true,
    showHealth = true,
    showDistance = true,
    teamCheck = true,
    highlightColor = Color3.fromRGB(0, 255, 255),

    itemESPEnabled = true,
    itemFilter = "All",
    itemMaxDistance = 150,

    soundESPEnabled = false,
    soundDuration = 3,

    lineOfSightESP = false,
    losMaxDistance = 30,
}

local inventoryConfig = {
    showBackpack = true,
    showEquipped = true,
    maxItems = 30,
    filterType = "All",
}

-- Serviço e variáveis
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Rayfield = --[[ Sua inicialização da Rayfield aqui ]]--

-- Aba ESP
local ESPtab = Rayfield:CreateTab({
    Name = "ESP",
    Icon = 5012544693, -- Icon Roblox
    PremiumOnly = false
})

-- === Section: Player ESP ===
local playerESPSection = ESPtab:CreateSection("Player ESP")

local playerESPEnabledToggle = playerESPSection:CreateToggle({
    Name = "Enable Player ESP",
    CurrentValue = espConfig.playerESPEnabled,
    Flag = "PlayerESPEnabled",
    Callback = function(value)
        espConfig.playerESPEnabled = value
        if not value then
            ClearPlayerESP()
        end
    end,
})

playerESPSection:CreateToggle({
    Name = "Show Names",
    CurrentValue = espConfig.showName,
    Flag = "ShowPlayerNames",
    Callback = function(value) espConfig.showName = value end,
})

playerESPSection:CreateToggle({
    Name = "Show Health",
    CurrentValue = espConfig.showHealth,
    Flag = "ShowPlayerHealth",
    Callback = function(value) espConfig.showHealth = value end,
})

playerESPSection:CreateToggle({
    Name = "Show Distance",
    CurrentValue = espConfig.showDistance,
    Flag = "ShowPlayerDistance",
    Callback = function(value) espConfig.showDistance = value end,
})

playerESPSection:CreateToggle({
    Name = "Team Check",
    CurrentValue = espConfig.teamCheck,
    Flag = "TeamCheck",
    Callback = function(value) espConfig.teamCheck = value end,
})

playerESPSection:CreateDropdown({
    Name = "ESP Color",
    Options = {"Cyan", "Red", "Green", "Yellow", "White"},
    CurrentOption = "Cyan",
    Flag = "ESPColor",
    Callback = function(option)
        local colors = {
            Cyan = Color3.fromRGB(0, 255, 255),
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Yellow = Color3.fromRGB(255, 255, 0),
            White = Color3.fromRGB(255, 255, 255),
        }
        espConfig.highlightColor = colors[option] or Color3.fromRGB(0, 255, 255)
    end,
})

-- === Section: Item ESP ===
local itemESPSection = ESPtab:CreateSection("Item ESP")

itemESPSection:CreateToggle({
    Name = "Enable Item ESP",
    CurrentValue = espConfig.itemESPEnabled,
    Flag = "ItemESPEnabled",
    Callback = function(value)
        espConfig.itemESPEnabled = value
        if not value then
            ClearItemESP()
        end
    end,
})

itemESPSection:CreateDropdown({
    Name = "Item Type Filter",
    Options = {"All", "Weapons", "Tools", "Consumables"},
    CurrentOption = espConfig.itemFilter,
    Flag = "ItemTypeFilter",
    Callback = function(option) espConfig.itemFilter = option end,
})

itemESPSection:CreateSlider({
    Name = "Item ESP Max Distance",
    Min = 10,
    Max = 500,
    Default = espConfig.itemMaxDistance,
    Flag = "ItemMaxDistance",
    Callback = function(value) espConfig.itemMaxDistance = value end,
})

-- === Section: Sound ESP ===
local soundESPSection = ESPtab:CreateSection("Sound ESP")

soundESPSection:CreateToggle({
    Name = "Enable Sound ESP",
    CurrentValue = espConfig.soundESPEnabled,
    Flag = "SoundESPEnabled",
    Callback = function(value) espConfig.soundESPEnabled = value end,
})

soundESPSection:CreateSlider({
    Name = "Sound Indicator Duration",
    Min = 1,
    Max = 10,
    Default = espConfig.soundDuration,
    Flag = "SoundDuration",
    Callback = function(value) espConfig.soundDuration = value end,
})

-- === Section: Line of Sight ESP ===
local losESPSection = ESPtab:CreateSection("Line of Sight ESP")

losESPSection:CreateToggle({
    Name = "Enable LoS ESP",
    CurrentValue = espConfig.lineOfSightESP,
    Flag = "LoSESPEnabled",
    Callback = function(value) espConfig.lineOfSightESP = value end,
})

losESPSection:CreateSlider({
    Name = "LoS Max Distance",
    Min = 5,
    Max = 100,
    Default = espConfig.losMaxDistance,
    Flag = "LoSMaxDistance",
    Callback = function(value) espConfig.losMaxDistance = value end,
})

-- === Section: Inventory ===
local inventorySection = ESPtab:CreateSection("Inventory")

inventorySection:CreateToggle({
    Name = "Show Backpack Items",
    CurrentValue = inventoryConfig.showBackpack,
    Flag = "ShowBackpack",
    Callback = function(value) inventoryConfig.showBackpack = value end,
})

inventorySection:CreateToggle({
    Name = "Show Equipped Items",
    CurrentValue = inventoryConfig.showEquipped,
    Flag = "ShowEquipped",
    Callback = function(value) inventoryConfig.showEquipped = value end,
})

inventorySection:CreateButton({
    Name = "Open Inventory UI",
    Callback = function()
        print("Inventory UI Opened")
        -- Insira aqui o código para abrir seu GUI
    end,
})

inventorySection:CreateSlider({
    Name = "Max Items Displayed",
    Min = 1,
    Max = 100,
    Default = inventoryConfig.maxItems,
    Flag = "MaxItemsDisplayed",
    Callback = function(value) inventoryConfig.maxItems = value end,
})

inventorySection:CreateDropdown({
    Name = "Filter Item Type",
    Options = {"All", "Weapons", "Consumables", "Tools"},
    CurrentOption = inventoryConfig.filterType,
    Flag = "FilterItemType",
    Callback = function(option) inventoryConfig.filterType = option end,
})

-- === Código ESP funcional básico ===
local playerESPObjects = {}
local itemESPObjects = {}

-- Helpers
local function IsEnemy(player)
    if not espConfig.teamCheck then return true end
    if not player.Team or not LocalPlayer.Team then return true end
    return player.Team ~= LocalPlayer.Team
end

local function CreateHighlight(parent)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = parent
    highlight.FillColor = espConfig.highlightColor
    highlight.OutlineColor = Color3.new(0,0,0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = parent
    return highlight
end

local function CreateBillboard(parent, text)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = parent
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = parent

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,0,1,0)
    label.Text = text
    label.TextColor3 = espConfig.highlightColor
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.ArialBold
    label.TextScaled = true
    label.Parent = billboard

    return billboard, label
end

-- Limpeza
function ClearPlayerESP()
    for _, data in pairs(playerESPObjects) do
        if data.Highlight then data.Highlight:Destroy() end
        if data.Billboard then data.Billboard:Destroy() end
    end
    playerESPObjects = {}
end

function ClearItemESP()
    for _, data in pairs(itemESPObjects) do
        if data.Highlight then data.Highlight:Destroy() end
        if data.Billboard then data.Billboard:Destroy() end
    end
    itemESPObjects = {}
end

-- Atualiza ESP players
local function UpdatePlayerESP()
    if not espConfig.playerESPEnabled then
        ClearPlayerESP()
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
            if espConfig.teamCheck and not IsEnemy(player) then
                -- não mostra aliado se team check ativo
                if playerESPObjects[player] then
                    if playerESPObjects[player].Highlight then playerESPObjects[player].Highlight.Enabled = false end
                    if playerESPObjects[player].Billboard then playerESPObjects[player].Billboard.Enabled = false end
                end
            else
                local char = player.Character
                local hrp = char.HumanoidRootPart
                local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

                -- Cria se não existir
                if not playerESPObjects[player] then
                    local highlight = CreateHighlight(char)
                    local billboard, label = CreateBillboard(hrp, "")
                    playerESPObjects[player] = {Highlight = highlight, Billboard = billboard, Label = label}
                end

                -- Atualiza cor
                playerESPObjects[player].Highlight.FillColor = espConfig.highlightColor
                playerESPObjects[player].Label.TextColor3 = espConfig.highlightColor

                -- Atualiza texto
                local textLines = {}
                if espConfig.showName then
                    table.insert(textLines, player.Name)
                end
                if espConfig.showHealth then
                    local health = char.Humanoid.Health
                    local maxHealth = char.Humanoid.MaxHealth
                    table.insert(textLines, ("Health: %d/%d"):format(health, maxHealth))
                end
                if espConfig.showDistance then
                    table.insert(textLines, ("Dist: %.1f"):format(dist))
                end

                playerESPObjects[player].Label.Text = table.concat(textLines, "\n")

                -- Ativa objetos
                playerESPObjects[player].Highlight.Enabled = true
                playerESPObjects[player].Billboard.Enabled = true
            end
        else
            if playerESPObjects[player] then
                playerESPObjects[player].Highlight:Destroy()
                playerESPObjects[player].Billboard:Destroy()
                playerESPObjects[player] = nil
            end
        end
    end
end

-- Atualiza ESP itens
local function UpdateItemESP()
    if not espConfig.itemESPEnabled then
        ClearItemESP()
        return
    end

    -- Exemplo genérico, ajuste de acordo com seu jogo (ex: Workspace.Items)
    local itemsFolder = Workspace:FindFirstChild("Items") or Workspace:FindFirstChild("Pickups")
    if not itemsFolder then return end

    for _, item in pairs(itemsFolder:GetChildren()) do
        if item:IsA("BasePart") then
            local dist = (item.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

            -- Filtro item (simples, só pelo nome, ajuste para seu jogo)
            local passesFilter = false
            if espConfig.itemFilter == "All" then
                passesFilter = true
            elseif espConfig.itemFilter == "Weapons" and string.find(item.Name:lower(), "weapon") then
                passesFilter = true
            elseif espConfig.itemFilter == "Tools" and string.find(item.Name:lower(), "tool") then
                passesFilter = true
            elseif espConfig.itemFilter == "Consumables" and (string.find(item.Name:lower(), "potion") or string.find(item.Name:lower(), "food")) then
                passesFilter = true
            end

            if passesFilter and dist <= espConfig.itemMaxDistance then
                if not itemESPObjects[item] then
                    local highlight = CreateHighlight(item)
                    local billboard, label = CreateBillboard(item, item.Name)
                    itemESPObjects[item] = {Highlight = highlight, Billboard = billboard, Label = label}
                end

                itemESPObjects[item].Highlight.FillColor = espConfig.highlightColor
                itemESPObjects[item].Label.TextColor3 = espConfig.highlightColor
                itemESPObjects[item].Highlight.Enabled = true
                itemESPObjects[item].Billboard.Enabled = true
            else
                if itemESPObjects[item] then
                    itemESPObjects[item].Highlight:Destroy()
                    itemESPObjects[item].Billboard:Destroy()
                    itemESPObjects[item] = nil
                end
            end
        else
            if itemESPObjects[item] then
                itemESPObjects[item].Highlight:Destroy()
                itemESPObjects[item].Billboard:Destroy()
                itemESPObjects[item] = nil
            end
        end
    end
end

-- Atualiza ESP geral
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        UpdatePlayerESP()
        UpdateItemESP()
        -- Aqui vc pode adicionar atualizações de Sound ESP e LoS ESP
    end
end)

-- Você pode adicionar aqui os códigos de Sound ESP e LoS ESP se quiser
-- Também pode adicionar Inventory GUI funcional aqui

print("ESP tab and core functionality loaded!")

return ESPtab
