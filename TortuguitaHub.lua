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

-- Serviços
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Estados Globais ESP
local ESPEnabled = false
local ESPPlayersEnabled = true
local ESPItemsEnabled = false
local ESPSoundsEnabled = false
local ESPVisionEnabled = false

local ESPColor = Color3.fromRGB(0, 150, 255)
local ESPTransparency = 0.5
local ESPLineThickness = 1

local ActiveHighlights = {}
local ActiveItemHighlights = {}
local ActiveSoundIndicators = {}

-- Função pra limpar highlights gerais
local function ClearHighlights()
	for _, h in pairs(ActiveHighlights) do
		if h and h.Parent then h:Destroy() end
	end
	ActiveHighlights = {}
end

local function ClearItemHighlights()
	for _, h in pairs(ActiveItemHighlights) do
		if h and h.Parent then h:Destroy() end
	end
	ActiveItemHighlights = {}
end

local function ClearSoundIndicators()
	for _, s in pairs(ActiveSoundIndicators) do
		if s and s.Parent then s:Destroy() end
	end
	ActiveSoundIndicators = {}
end

-- Cria highlight para personagem
local function CreatePlayerHighlight(character)
	if not character or not character:IsA("Model") then return end
	local highlight = Instance.new("Highlight")
	highlight.Name = "ESPHighlight"
	highlight.Adornee = character
	highlight.FillColor = ESPColor
	highlight.OutlineColor = Color3.new(1, 1, 1)
	highlight.FillTransparency = ESPTransparency
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = character
	table.insert(ActiveHighlights, highlight)
end

-- ESP para itens (exemplo: partes com tag "Item")
local function CreateItemHighlight(item)
	if not item or not item:IsA("BasePart") then return end
	local highlight = Instance.new("Highlight")
	highlight.Name = "ItemHighlight"
	highlight.Adornee = item
	highlight.FillColor = Color3.fromRGB(255, 200, 0) -- amarelo por padrão
	highlight.OutlineColor = Color3.new(1, 1, 1)
	highlight.FillTransparency = 0.6
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = item
	table.insert(ActiveItemHighlights, highlight)
end

-- Placeholder simples para sons (por ex. cria uma esfera no local do som)
local function CreateSoundIndicator(position)
	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255, 0, 0)
	part.Size = Vector3.new(1,1,1)
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 0.5
	part.Position = position
	part.Name = "SoundIndicator"
	part.Parent = workspace
	table.insert(ActiveSoundIndicators, part)

	-- Auto-remove após 3 segundos (exemplo)
	delay(3, function()
		if part and part.Parent then part:Destroy() end
	end)
end

-- Atualiza ESP
local function UpdateESP()
	ClearHighlights()
	if not ESPEnabled or not ESPPlayersEnabled then return end
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			CreatePlayerHighlight(player.Character)
		end
	end
end

-- Atualiza ESP de itens (exemplo simplificado)
local function UpdateItemESP()
	ClearItemHighlights()
	if not ESPEnabled or not ESPItemsEnabled then return end

	-- Exemplo: destacar todos os itens com Tag "Item"
	local CollectionService = game:GetService("CollectionService")
	local items = CollectionService:GetTagged("Item")
	for _, item in pairs(items) do
		CreateItemHighlight(item)
	end
end

-- Atualiza ESP de sons (placeholder)
local function UpdateSoundESP()
	ClearSoundIndicators()
	if not ESPEnabled or not ESPSoundsEnabled then return end

	-- Exemplo: supomos que você tem uma lista de sons (deixe aqui o seu sistema de detecção)
	-- Aqui só um exemplo com um som aleatório
	-- CreateSoundIndicator(Vector3.new(0, 5, 0))
end

-- Atualiza ESP visão (linha de visão)
local function UpdateVisionESP()
	-- Aqui você pode implementar linhas de visão entre players
	-- Por simplicidade, deixei vazio (mas podemos expandir)
end

-- Loop principal ESP
RunService.RenderStepped:Connect(function()
	pcall(function()
		if ESPEnabled then
			UpdateESP()
			UpdateItemESP()
			UpdateSoundESP()
			UpdateVisionESP()
		else
			ClearHighlights()
			ClearItemHighlights()
			ClearSoundIndicators()
		end
	end)
end)

-- UI Rayfield - ESP Tab
local ESPTab = Window:CreateTab("ESP", 6023426915)

-- Section Player ESP
local playerSection = ESPTab:CreateSection("Player ESP")

playerSection:CreateToggle({
	Name = "Enable Player ESP",
	CurrentValue = true,
	Flag = "PlayerESPEnabled",
	Callback = function(value)
		ESPPlayersEnabled = value
	end
})

playerSection:CreateDropdown({
	Name = "ESP Color",
	Options = {"Blue", "Red", "Green", "Yellow"},
	CurrentOption = "Blue",
	Flag = "ESPColor",
	Callback = function(option)
		if option == "Blue" then
			ESPColor = Color3.fromRGB(0, 150, 255)
		elseif option == "Red" then
			ESPColor = Color3.fromRGB(255, 0, 0)
		elseif option == "Green" then
			ESPColor = Color3.fromRGB(0, 255, 0)
		elseif option == "Yellow" then
			ESPColor = Color3.fromRGB(255, 255, 0)
		end
	end
})

playerSection:CreateSlider({
	Name = "ESP Transparency",
	Range = {0, 1},
	Increment = 0.05,
	CurrentValue = 0.5,
	Flag = "ESPTransparency",
	Callback = function(value)
		ESPTransparency = value
	end
})

-- Section Item ESP
local itemSection = ESPTab:CreateSection("Item ESP")

itemSection:CreateToggle({
	Name = "Enable Item ESP",
	CurrentValue = false,
	Flag = "ItemESPEnabled",
	Callback = function(value)
		ESPItemsEnabled = value
	end
})

-- Section Sound ESP
local soundSection = ESPTab:CreateSection("Sound ESP")

soundSection:CreateToggle({
	Name = "Enable Sound ESP",
	CurrentValue = false,
	Flag = "SoundESPEnabled",
	Callback = function(value)
		ESPSoundsEnabled = value
	end
})

-- Section Vision ESP
local visionSection = ESPTab:CreateSection("Vision ESP")

visionSection:CreateToggle({
	Name = "Enable Vision ESP",
	CurrentValue = false,
	Flag = "VisionESPEnabled",
	Callback = function(value)
		ESPVisionEnabled = value
	end
})

-- Toggle global ESP ON/OFF
ESPTab:CreateToggle({
	Name = "Enable All ESP",
	CurrentValue = true,
	Flag = "GlobalESPEnabled",
	Callback = function(value)
		ESPEnabled = value
		if not value then
			ClearHighlights()
			ClearItemHighlights()
			ClearSoundIndicators()
		end
	end
})

-- Botão para limpar tudo
ESPTab:CreateButton({
	Name = "Clear All ESP",
	Callback = function()
		ClearHighlights()
		ClearItemHighlights()
		ClearSoundIndicators()
	end
})
