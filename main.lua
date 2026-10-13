-- ==========================================================================
-- CYBER HACKER | Versão FREE 1.6.0 (DRAGON EDITION - Crosshair, Infinite Ammo & Firebase Pro)
-- Repositório: https://github.com/Pitbull23032004/MiniZombies2Script
-- Canal: https://youtu.be/D2Iqev9FHyA?si=GAnnU5ckAE_rzOOq
-- Créditos: DarkGamingYT
-- ==========================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local StatsService = game:GetService("Stats")
local LocalizationService = game:GetService("LocalizationService")

local SCRIPT_VERSION = "FREE 1.6.0 [DRAGON]"
local FIREBASE_URL = "https://darkgamingyt-1c438-default-rtdb.firebaseio.com"
local SAVE_FILE_NAME = "DarkHacker_Dragon_Login.json"

-- Compatibilidade silenciosa de requisição HTTP para o Firebase em segundo plano
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local userId = LocalPlayer.UserId
local userName = LocalPlayer.Name
local displayName = LocalPlayer.DisplayName
local avatarThumbUrl = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId) .. "&w=150&h=150"
local playerSessionId = "user_" .. tostring(userId)
local tempoInicioSessao = tick()
local fpsAtual = 60

local paisUsuario = "Desconhecido"
local cidadeUsuario = "Desconhecida"
local nomeDoJogo = "Mini Zombies / Roblox"

-- Fonte nítida, alinhada e estritamente SEM NEGRITO
local FONT_MAIN = Enum.Font.Code

-- Paleta de Cores Estilo Dragão (Obsidiana, Carmesim Imperial e Ouro Fogo)
local COLOR_BG = Color3.fromRGB(14, 8, 10)
local COLOR_PANEL = Color3.fromRGB(24, 11, 14)
local COLOR_ITEM = Color3.fromRGB(34, 15, 19)
local COLOR_ACCENT = Color3.fromRGB(255, 155, 25)
local COLOR_DRAGON_RED = Color3.fromRGB(215, 40, 45)
local COLOR_BORDER = Color3.fromRGB(85, 30, 35)
local COLOR_TEXT = Color3.fromRGB(245, 238, 230)
local COLOR_SUBTEXT = Color3.fromRGB(175, 150, 145)
local COLOR_WARN = Color3.fromRGB(255, 195, 65)
local COLOR_OFF = Color3.fromRGB(235, 70, 70)
local COLOR_ON = Color3.fromRGB(65, 230, 130)
local COLOR_CYAN = Color3.fromRGB(0, 235, 255)

task.spawn(function()
	pcall(function()
		local info = MarketplaceService:GetProductInfo(game.PlaceId)
		if info and info.Name then
			nomeDoJogo = info.Name
		end
	end)
	pcall(function()
		local response = game:HttpGet("http://ip-api.com/json/?fields=country,city")
		if response then
			local data = HttpService:JSONDecode(response)
			if data and data.country then
				paisUsuario = data.country
				cidadeUsuario = data.city or "Desconhecida"
			end
		end
	end)
end)

-- Limpeza de versão anterior
pcall(function()
	if CoreGui:FindFirstChild("CyberHacker_FREE_1_3_6") then
		CoreGui.CyberHacker_FREE_1_3_6:Destroy()
	end
	if LocalPlayer.PlayerGui:FindFirstChild("CyberHacker_FREE_1_3_6") then
		LocalPlayer.PlayerGui.CyberHacker_FREE_1_3_6:Destroy()
	end
	if gethui and gethui():FindFirstChild("CyberHacker_FREE_1_3_6") then
		gethui().CyberHacker_FREE_1_3_6:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHacker_FREE_1_3_6"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local successParent = pcall(function() ScreenGui.Parent = CoreGui end)
if not successParent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
pcall(function()
	if gethui then ScreenGui.Parent = gethui() end
end)

-- Pasta dedicada para o Pool de Linhas 2D (ESP Line)
local EspLineFolder = Instance.new("Folder", ScreenGui)
EspLineFolder.Name = "EspLinesPool8Bit"

local function apply8BitStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = color or COLOR_ACCENT
	stroke.Thickness = thickness or 1.5
	stroke.LineJoinMode = Enum.LineJoinMode.Miter
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return stroke
end

-- ==========================================================================
-- DETECTOR EXATO DO CENTRO DA MIRA DO JOGO (CORREÇÃO DO DESLOCAMENTO)
-- ==========================================================================
local cachedGameCrosshair = nil
local lastCrosshairSearch = 0

local function getRealCrosshairCenter()
	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
	local insetTop = Vector2.zero
	pcall(function()
		insetTop = GuiService:GetGuiInset()
	end)

	-- Procura periodicamente o objeto de mira nativo na PlayerGui para travar 100% em cima dele
	local now = tick()
	if (not cachedGameCrosshair or not cachedGameCrosshair.Parent) and (now - lastCrosshairSearch > 2) then
		lastCrosshairSearch = now
		pcall(function()
			local pgui = LocalPlayer:FindFirstChild("PlayerGui")
			if pgui then
				for _, guiObj in ipairs(pgui:GetDescendants()) do
					if guiObj:IsA("GuiObject") and guiObj.Visible then
						local n = string.lower(guiObj.Name)
						if n == "crosshair" or n == "reticle" or n == "aim" or n == "cursor" or n == "center" then
							if guiObj.AbsoluteSize.X < 180 and guiObj.AbsoluteSize.Y < 180 then
								cachedGameCrosshair = guiObj
								break
							end
						end
					end
				end
			end
		end)
	end

	if cachedGameCrosshair and cachedGameCrosshair.Parent and cachedGameCrosshair.Visible then
		local absPos = cachedGameCrosshair.AbsolutePosition
		local absSize = cachedGameCrosshair.AbsoluteSize
		local centerX = absPos.X + (absSize.X / 2)
		local centerY = absPos.Y + (absSize.Y / 2) + insetTop.Y
		-- Valida se está próximo do centro da tela
		if math.abs(centerX - (vp.X / 2)) < 120 and math.abs(centerY - (vp.Y / 2)) < 120 then
			return Vector2.new(centerX, centerY)
		end
	end

	-- Compensação exata da barra superior do Roblox (corrige a diferença de altura da mira azul)
	return Vector2.new(vp.X / 2, (vp.Y / 2) + (insetTop.Y / 2))
end

-- Fundo Estilo Dragão para o Painel de Login e Painel Principal
local function applyDragonBackground(parentFrame, baseZIndex)
	local grad = Instance.new("UIGradient", parentFrame)
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 12, 16)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 8, 11)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 7))
	})
	grad.Rotation = 135

	local pattern = Instance.new("ImageLabel", parentFrame)
	pattern.Name = "DragonScaleBg"
	pattern.Size = UDim2.new(1, 0, 1, 0)
	pattern.BackgroundTransparency = 1
	pattern.Image = "rbxassetid://6071575925"
	pattern.ImageColor3 = COLOR_DRAGON_RED
	pattern.ImageTransparency = 0.91
	pattern.ScaleType = Enum.ScaleType.Tile
	pattern.TileSize = UDim2.new(0, 48, 0, 48)
	pattern.ZIndex = baseZIndex

	local dragonEmblem = Instance.new("TextLabel", parentFrame)
	dragonEmblem.Name = "DragonWatermark"
	dragonEmblem.Size = UDim2.new(1, 0, 1, 0)
	dragonEmblem.BackgroundTransparency = 1
	dragonEmblem.Text = "🐉"
	dragonEmblem.TextColor3 = COLOR_ACCENT
	dragonEmblem.TextTransparency = 0.93
	dragonEmblem.TextSize = 150
	dragonEmblem.Font = FONT_MAIN
	dragonEmblem.ZIndex = baseZIndex

	local topLine = Instance.new("Frame", parentFrame)
	topLine.Size = UDim2.new(1, 0, 0, 2)
	topLine.Position = UDim2.new(0, 0, 0, 0)
	topLine.BackgroundColor3 = COLOR_ACCENT
	topLine.BorderSizePixel = 0
	topLine.ZIndex = baseZIndex + 1
end

-- Sistema de arrastar universal (PC & Mobile)
local function makeDraggable(dragHandle, targetFrame)
	local dragging = false
	local dragInput, dragStart, startPos

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = targetFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			targetFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ==========================================================================
-- SISTEMA DE SALVAR SENHA
-- ==========================================================================
local function loadSavedCredentials()
	local saved = {remember = false, user = "", pass = ""}
	pcall(function()
		if isfile and readfile and isfile(SAVE_FILE_NAME) then
			local decoded = HttpService:JSONDecode(readfile(SAVE_FILE_NAME))
			if type(decoded) == "table" then
				saved.remember = decoded.remember == true
				saved.user = tostring(decoded.user or "")
				saved.pass = tostring(decoded.pass or "")
			end
		elseif _G.DarkHacker_SavedLogin then
			saved = _G.DarkHacker_SavedLogin
		end
	end)
	return saved
end

local function saveCredentials(remember, user, pass)
	local data = {remember = remember, user = remember and user or "", pass = remember and pass or ""}
	_G.DarkHacker_SavedLogin = data
	pcall(function()
		if remember and writefile then
			writefile(SAVE_FILE_NAME, HttpService:JSONEncode(data))
		elseif not remember and isfile and delfile and isfile(SAVE_FILE_NAME) then
			delfile(SAVE_FILE_NAME)
		end
	end)
end

-- ==========================================================================
-- BOTÃO FLUTUANTE ESTILO DRAGÃO (HUD COM FPS, PING E STATUS)
-- ==========================================================================
local FloatContainer = Instance.new("Frame", ScreenGui)
FloatContainer.Size = UDim2.fromOffset(98, 54)
FloatContainer.Position = UDim2.new(0, 28, 0.35, 0)
FloatContainer.BackgroundColor3 = COLOR_BG
FloatContainer.BorderSizePixel = 0
FloatContainer.Visible = false
FloatContainer.ZIndex = 50
local FloatStroke = apply8BitStroke(FloatContainer, COLOR_ACCENT, 2)

local FloatBtn = Instance.new("TextButton", FloatContainer)
FloatBtn.Size = UDim2.new(1, -6, 0, 30)
FloatBtn.Position = UDim2.new(0, 3, 0, 3)
FloatBtn.BackgroundColor3 = COLOR_PANEL
FloatBtn.BorderSizePixel = 0
FloatBtn.Text = "🐉 MENU"
FloatBtn.TextColor3 = COLOR_ACCENT
FloatBtn.TextSize = 12
FloatBtn.Font = FONT_MAIN
FloatBtn.ZIndex = 51
apply8BitStroke(FloatBtn, COLOR_BORDER, 1)

local FpsPingLabel = Instance.new("TextLabel", FloatContainer)
FpsPingLabel.Size = UDim2.new(1, -6, 0, 16)
FpsPingLabel.Position = UDim2.new(0, 3, 0, 35)
FpsPingLabel.BackgroundTransparency = 1
FpsPingLabel.Text = "60FPS | 0ms"
FpsPingLabel.TextColor3 = COLOR_TEXT
FpsPingLabel.TextSize = 10
FpsPingLabel.Font = FONT_MAIN
FpsPingLabel.TextXAlignment = Enum.TextXAlignment.Center
FpsPingLabel.ZIndex = 51

makeDraggable(FloatBtn, FloatContainer)

local fpsLastTick = tick()
local fpsFrames = 0
RunService.RenderStepped:Connect(function()
	fpsFrames = fpsFrames + 1
	local now = tick()
	if now - fpsLastTick >= 1 then
		fpsAtual = math.floor(fpsFrames / (now - fpsLastTick))
		local ping = 0
		pcall(function()
			ping = math.floor((LocalPlayer:GetNetworkPing() * 1000) or 0)
		end)
		FpsPingLabel.Text = string.format("%dFPS|%dms", fpsAtual, ping)
		fpsFrames = 0
		fpsLastTick = now
	end
end)

-- ==========================================================================
-- BARRA DE CARREGAMENTO INICIAL (DRAGON LOADING SCREEN)
-- ==========================================================================
local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Size = UDim2.new(0, 320, 0, 165)
LoadingFrame.Position = UDim2.new(0.5, -160, 0.5, -82)
LoadingFrame.BackgroundColor3 = COLOR_BG
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 80
apply8BitStroke(LoadingFrame, COLOR_ACCENT, 2)
applyDragonBackground(LoadingFrame, 80)

local LoadTitle = Instance.new("TextLabel", LoadingFrame)
LoadTitle.Size = UDim2.new(1, -20, 0, 24)
LoadTitle.Position = UDim2.new(0, 10, 0, 10)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "🐉 DARK HACKER // DRAGON EDITION"
LoadTitle.TextColor3 = COLOR_ACCENT
LoadTitle.TextSize = 13
LoadTitle.Font = FONT_MAIN
LoadTitle.TextXAlignment = Enum.TextXAlignment.Center
LoadTitle.ZIndex = 82

local LoadProfileBox = Instance.new("Frame", LoadingFrame)
LoadProfileBox.Size = UDim2.new(0.88, 0, 0, 48)
LoadProfileBox.Position = UDim2.new(0.06, 0, 0, 40)
LoadProfileBox.BackgroundColor3 = COLOR_PANEL
LoadProfileBox.BorderSizePixel = 0
LoadProfileBox.ZIndex = 82
apply8BitStroke(LoadProfileBox, COLOR_BORDER, 1)

local LoadAvatar = Instance.new("ImageLabel", LoadProfileBox)
LoadAvatar.Size = UDim2.fromOffset(38, 38)
LoadAvatar.Position = UDim2.new(0, 5, 0.5, -19)
LoadAvatar.BackgroundColor3 = COLOR_BG
LoadAvatar.BorderSizePixel = 0
LoadAvatar.Image = avatarThumbUrl
LoadAvatar.ZIndex = 83
apply8BitStroke(LoadAvatar, COLOR_ACCENT, 1)

local LoadUserText = Instance.new("TextLabel", LoadProfileBox)
LoadUserText.Size = UDim2.new(1, -54, 1, 0)
LoadUserText.Position = UDim2.new(0, 50, 0, 0)
LoadUserText.BackgroundTransparency = 1
LoadUserText.Text = string.format("Jogador : %s\nID Conta: %d", userName, userId)
LoadUserText.TextColor3 = COLOR_TEXT
LoadUserText.TextSize = 11
LoadUserText.Font = FONT_MAIN
LoadUserText.TextXAlignment = Enum.TextXAlignment.Left
LoadUserText.ZIndex = 83

local LoadStatusTxt = Instance.new("TextLabel", LoadingFrame)
LoadStatusTxt.Size = UDim2.new(0.88, 0, 0, 18)
LoadStatusTxt.Position = UDim2.new(0.06, 0, 0, 98)
LoadStatusTxt.BackgroundTransparency = 1
LoadStatusTxt.Text = "Iniciando sistema Dragao... [0%]"
LoadStatusTxt.TextColor3 = COLOR_SUBTEXT
LoadStatusTxt.TextSize = 11
LoadStatusTxt.Font = FONT_MAIN
LoadStatusTxt.TextXAlignment = Enum.TextXAlignment.Left
LoadStatusTxt.ZIndex = 82

local LoadBarBg = Instance.new("Frame", LoadingFrame)
LoadBarBg.Size = UDim2.new(0.88, 0, 0, 16)
LoadBarBg.Position = UDim2.new(0.06, 0, 0, 122)
LoadBarBg.BackgroundColor3 = COLOR_PANEL
LoadBarBg.BorderSizePixel = 0
LoadBarBg.ZIndex = 82
apply8BitStroke(LoadBarBg, COLOR_ACCENT, 1)

local LoadBarFill = Instance.new("Frame", LoadBarBg)
LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadBarFill.BackgroundColor3 = COLOR_DRAGON_RED
LoadBarFill.BorderSizePixel = 0
LoadBarFill.ZIndex = 83

local LoadBarGrad = Instance.new("UIGradient", LoadBarFill)
LoadBarGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_DRAGON_RED),
	ColorSequenceKeypoint.new(1, COLOR_ACCENT)
})

-- ==========================================================================
-- PAINEL DE LOGIN DRAGÃO (COM FUNDO, PERFIL ROBLOX & SALVAR SENHA)
-- ==========================================================================
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 340, 0, 355)
LoginFrame.Position = UDim2.new(0.5, -170, 0.5, -177)
LoginFrame.BackgroundColor3 = COLOR_BG
LoginFrame.BorderSizePixel = 0
LoginFrame.Visible = false
LoginFrame.ZIndex = 60
apply8BitStroke(LoginFrame, COLOR_ACCENT, 2)
applyDragonBackground(LoginFrame, 60)

local LoginTopBar = Instance.new("Frame", LoginFrame)
LoginTopBar.Size = UDim2.new(1, 0, 0, 34)
LoginTopBar.BackgroundColor3 = COLOR_PANEL
LoginTopBar.BorderSizePixel = 0
LoginTopBar.ZIndex = 62
apply8BitStroke(LoginTopBar, COLOR_BORDER, 1)
makeDraggable(LoginTopBar, LoginFrame)

local LoginHeader = Instance.new("TextLabel", LoginTopBar)
LoginHeader.Size = UDim2.new(1, -90, 1, 0)
LoginHeader.Position = UDim2.new(0, 10, 0, 0)
LoginHeader.BackgroundTransparency = 1
LoginHeader.Text = "🐉 DARKGAMINGYT // LOGIN"
LoginHeader.TextColor3 = COLOR_TEXT
LoginHeader.TextSize = 13
LoginHeader.Font = FONT_MAIN
LoginHeader.TextXAlignment = Enum.TextXAlignment.Left
LoginHeader.ZIndex = 63

local LoginVersionTag = Instance.new("TextLabel", LoginTopBar)
LoginVersionTag.Size = UDim2.new(0, 80, 1, 0)
LoginVersionTag.Position = UDim2.new(1, -88, 0, 0)
LoginVersionTag.BackgroundTransparency = 1
LoginVersionTag.Text = "v1.6.0"
LoginVersionTag.TextColor3 = COLOR_ACCENT
LoginVersionTag.TextSize = 12
LoginVersionTag.Font = FONT_MAIN
LoginVersionTag.TextXAlignment = Enum.TextXAlignment.Right
LoginVersionTag.ZIndex = 63

local LoginProfileBar = Instance.new("Frame", LoginFrame)
LoginProfileBar.Size = UDim2.new(0.88, 0, 0, 48)
LoginProfileBar.Position = UDim2.new(0.06, 0, 0, 42)
LoginProfileBar.BackgroundColor3 = COLOR_PANEL
LoginProfileBar.BorderSizePixel = 0
LoginProfileBar.ZIndex = 62
apply8BitStroke(LoginProfileBar, COLOR_BORDER, 1)

local LoginAvatar = Instance.new("ImageLabel", LoginProfileBar)
LoginAvatar.Size = UDim2.fromOffset(38, 38)
LoginAvatar.Position = UDim2.new(0, 5, 0.5, -19)
LoginAvatar.BackgroundColor3 = COLOR_BG
LoginAvatar.BorderSizePixel = 0
LoginAvatar.Image = avatarThumbUrl
LoginAvatar.ZIndex = 63
apply8BitStroke(LoginAvatar, COLOR_ACCENT, 1)

local LoginProfileInfo = Instance.new("TextLabel", LoginProfileBar)
LoginProfileInfo.Size = UDim2.new(1, -52, 1, 0)
LoginProfileInfo.Position = UDim2.new(0, 50, 0, 0)
LoginProfileInfo.BackgroundTransparency = 1
LoginProfileInfo.Text = string.format("Perfil : %s\nChave  : Usuario FREE | Senha FREE", displayName)
LoginProfileInfo.TextColor3 = COLOR_SUBTEXT
LoginProfileInfo.TextSize = 11
LoginProfileInfo.Font = FONT_MAIN
LoginProfileInfo.TextXAlignment = Enum.TextXAlignment.Left
LoginProfileInfo.ZIndex = 63

local function createLoginInput(posY, placeholder)
	local box = Instance.new("TextBox", LoginFrame)
	box.Size = UDim2.new(0.88, 0, 0, 36)
	box.Position = UDim2.new(0.06, 0, 0, posY)
	box.BackgroundColor3 = COLOR_PANEL
	box.BorderSizePixel = 0
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(120, 100, 95)
	box.Text = ""
	box.TextColor3 = COLOR_TEXT
	box.TextSize = 13
	box.Font = FONT_MAIN
	box.ClearTextOnFocus = false
	box.ZIndex = 62
	
	local stroke = apply8BitStroke(box, COLOR_BORDER, 1)
	box.Focused:Connect(function() stroke.Color = COLOR_ACCENT end)
	box.FocusLost:Connect(function() stroke.Color = COLOR_BORDER end)
	return box
end

local UserBox = createLoginInput(98, "Usuario: FREE")
local PassBox = createLoginInput(142, "Senha: FREE")

local savedCreds = loadSavedCredentials()
local savePasswordEnabled = savedCreds.remember

local SavePassBtn = Instance.new("TextButton", LoginFrame)
SavePassBtn.Size = UDim2.new(0.88, 0, 0, 28)
SavePassBtn.Position = UDim2.new(0.06, 0, 0, 186)
SavePassBtn.BackgroundColor3 = COLOR_ITEM
SavePassBtn.BorderSizePixel = 0
SavePassBtn.TextColor3 = COLOR_TEXT
SavePassBtn.TextSize = 11
SavePassBtn.Font = FONT_MAIN
SavePassBtn.TextXAlignment = Enum.TextXAlignment.Left
SavePassBtn.ZIndex = 62
local SavePassStroke = apply8BitStroke(SavePassBtn, COLOR_BORDER, 1)

local function updateSavePassVisual()
	if savePasswordEnabled then
		SavePassBtn.Text = "  [ X ] Salvar Senha"
		SavePassBtn.TextColor3 = COLOR_ON
		SavePassStroke.Color = COLOR_ON
	else
		SavePassBtn.Text = "  [   ] Salvar Senha"
		SavePassBtn.TextColor3 = COLOR_SUBTEXT
		SavePassStroke.Color = COLOR_BORDER
	end
end

if savedCreds.remember then
	UserBox.Text = savedCreds.user ~= "" and savedCreds.user or "FREE"
	PassBox.Text = savedCreds.pass ~= "" and savedCreds.pass or "FREE"
end
updateSavePassVisual()

SavePassBtn.MouseButton1Click:Connect(function()
	savePasswordEnabled = not savePasswordEnabled
	updateSavePassVisual()
end)

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0.88, 0, 0, 36)
LoginBtn.Position = UDim2.new(0.06, 0, 0, 222)
LoginBtn.BackgroundColor3 = COLOR_DRAGON_RED
LoginBtn.BorderSizePixel = 0
LoginBtn.Text = "[ ENTRAR NO SISTEMA ]"
LoginBtn.TextColor3 = COLOR_TEXT
LoginBtn.TextSize = 13
LoginBtn.Font = FONT_MAIN
LoginBtn.ZIndex = 62
apply8BitStroke(LoginBtn, COLOR_ACCENT, 1.5)

local ErrorLabel = Instance.new("TextLabel", LoginFrame)
ErrorLabel.Size = UDim2.new(0.88, 0, 0, 18)
ErrorLabel.Position = UDim2.new(0.06, 0, 0, 266)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = savePasswordEnabled and "Status: Senha salva carregada." or "Status: Aguardando login..."
ErrorLabel.TextColor3 = savePasswordEnabled and COLOR_ON or COLOR_SUBTEXT
ErrorLabel.TextSize = 11
ErrorLabel.Font = FONT_MAIN
ErrorLabel.TextXAlignment = Enum.TextXAlignment.Center
ErrorLabel.ZIndex = 62

local LoginDisclaimer = Instance.new("Frame", LoginFrame)
LoginDisclaimer.Size = UDim2.new(0.88, 0, 0, 42)
LoginDisclaimer.Position = UDim2.new(0.06, 0, 0, 292)
LoginDisclaimer.BackgroundColor3 = Color3.fromRGB(22, 12, 12)
LoginDisclaimer.BorderSizePixel = 0
LoginDisclaimer.ZIndex = 62
apply8BitStroke(LoginDisclaimer, COLOR_WARN, 1)

local LoginDisclaimerTxt = Instance.new("TextLabel", LoginDisclaimer)
LoginDisclaimerTxt.Size = UDim2.new(1, -10, 1, 0)
LoginDisclaimerTxt.Position = UDim2.new(0, 5, 0, 0)
LoginDisclaimerTxt.BackgroundTransparency = 1
LoginDisclaimerTxt.TextWrapped = true
LoginDisclaimerTxt.Text = "[!] Aviso: Nao nos responsabilizamos\npelo uso deste script."
LoginDisclaimerTxt.TextColor3 = COLOR_WARN
LoginDisclaimerTxt.TextSize = 11
LoginDisclaimerTxt.Font = FONT_MAIN
LoginDisclaimerTxt.TextXAlignment = Enum.TextXAlignment.Center
LoginDisclaimerTxt.ZIndex = 63

task.spawn(function()
	local stages = {
		{pct = 0.25, txt = "Carregando tema Dragao... [25%]"},
		{pct = 0.55, txt = "Sincronizando perfil Roblox... [55%]"},
		{pct = 0.85, txt = "Alinhando Mira & Municao... [85%]"},
		{pct = 1.00, txt = "Sistema pronto! [100%]"}
	}
	for _, st in ipairs(stages) do
		LoadStatusTxt.Text = st.txt
		TweenService:Create(LoadBarFill, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {
			Size = UDim2.new(st.pct, 0, 1, 0)
		}):Play()
		task.wait(0.32)
	end
	task.wait(0.15)
	LoadingFrame:Destroy()
	LoginFrame.Visible = true
	FloatContainer.Visible = true
end)

local loggedIn = false
local statsLabelReference = nil
local cachedZombies = {}

-- ==========================================================================
-- PAINEL PRINCIPAL ESTILO DRAGÃO
-- ==========================================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 395, 0, 465)
MainFrame.Position = UDim2.new(0, 135, 0.28, 0)
MainFrame.BackgroundColor3 = COLOR_BG
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 30

local MainStroke = apply8BitStroke(MainFrame, COLOR_ACCENT, 2)
applyDragonBackground(MainFrame, 30)

task.spawn(function()
	while MainFrame and MainFrame.Parent do
		for i = 0, 1, 0.01 do
			if not MainStroke or not MainStroke.Parent then break end
			MainStroke.Color = Color3.fromHSV(i * 0.09, 0.9, 1)
			task.wait(0.05)
		end
	end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = COLOR_PANEL
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 32
apply8BitStroke(TopBar, COLOR_BORDER, 1)
makeDraggable(TopBar, MainFrame)

local TopAvatar = Instance.new("ImageLabel", TopBar)
TopAvatar.Size = UDim2.fromOffset(30, 30)
TopAvatar.Position = UDim2.new(0, 8, 0.5, -15)
TopAvatar.BackgroundColor3 = COLOR_BG
TopAvatar.BorderSizePixel = 0
TopAvatar.Image = avatarThumbUrl
TopAvatar.ZIndex = 33
apply8BitStroke(TopAvatar, COLOR_ACCENT, 1)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -50, 0, 20)
TitleLabel.Position = UDim2.new(0, 46, 0, 4)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐉 DARK HACKER // " .. SCRIPT_VERSION
TitleLabel.TextColor3 = COLOR_ACCENT
TitleLabel.TextSize = 12
TitleLabel.Font = FONT_MAIN
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 33

local SubUserLabel = Instance.new("TextLabel", TopBar)
SubUserLabel.Size = UDim2.new(1, -50, 0, 16)
SubUserLabel.Position = UDim2.new(0, 46, 0, 22)
SubUserLabel.BackgroundTransparency = 1
SubUserLabel.Text = "Jogador: " .. userName .. " | ID: " .. tostring(userId)
SubUserLabel.TextColor3 = COLOR_SUBTEXT
SubUserLabel.TextSize = 10
SubUserLabel.Font = FONT_MAIN
SubUserLabel.TextXAlignment = Enum.TextXAlignment.Left
SubUserLabel.ZIndex = 33

FloatBtn.MouseButton1Click:Connect(function()
	if not loggedIn then return end
	MainFrame.Visible = not MainFrame.Visible
	if MainFrame.Visible then
		FloatBtn.Text = "🐉 ABERTO"
		FloatBtn.TextColor3 = COLOR_ON
	else
		FloatBtn.Text = "🐉 MENU"
		FloatBtn.TextColor3 = COLOR_ACCENT
	end
end)

-- ==========================================================================
-- FIREBASE PRO TELEMETRY (OCULTO E DETALHADO PARA O DESENVOLVEDOR)
-- ==========================================================================
local function getActiveFeaturesReport()
	local list = {}
	if _G.Free_ESP_Box2D then table.insert(list, "ESP_Box2D") end
	if _G.Free_ESP_Line then table.insert(list, "ESP_Line") end
	if _G.Free_ESP_Highlight then table.insert(list, "ESP_Chams") end
	if _G.Free_ESP_Name then table.insert(list, "ESP_NameHP") end
	if _G.SurrealFloor_On then table.insert(list, "Aura_Dragao") end
	if _G.Free_Speed then table.insert(list, "Speed(" .. tostring(_G.Free_SpeedVal) .. ")") end
	if _G.Free_Noclip then table.insert(list, "WallHack") end
	if _G.Free_FlyActive then table.insert(list, "Fly(" .. tostring(_G.Free_FlySpeed) .. ")") end
	if _G.Free_AimLock then table.insert(list, "Aimbot(" .. tostring(_G.Free_AimPart) .. ")") end
	if _G.Free_ShowFOV then table.insert(list, "FOV_Area") end
	if _G.Free_CustomCrosshair then table.insert(list, "Crosshair_Design_" .. tostring(_G.Free_CrosshairStyle)) end
	if _G.Free_InfiniteAmmo then table.insert(list, "BETA_MunicaoInfinita") end
	return #list > 0 and table.concat(list, " | ") or "Nenhuma Opcao Ativa"
end

local function getPlayerGameDetails()
	local weapon = "Desarmado"
	local hpStr = "0 / 0"
	local posStr = "0, 0, 0"
	pcall(function()
		local char = LocalPlayer.Character
		if char then
			local tool = char:FindFirstChildOfClass("Tool")
			if tool then
				weapon = tool.Name
			end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hpStr = string.format("%d / %d", math.floor(hum.Health), math.floor(hum.MaxHealth))
			end
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				posStr = string.format("%d, %d, %d", math.floor(root.Position.X), math.floor(root.Position.Y), math.floor(root.Position.Z))
			end
		end
	end)
	return weapon, hpStr, posStr
end

local function iniciarSistemaPresenca()
	task.spawn(function()
		local dispositivoDetectado = UserInputService.TouchEnabled and "Mobile / Celular" or "PC / Computador"
		local executorNome = "Desconhecido"
		pcall(function()
			if identifyexecutor then
				executorNome = select(1, identifyexecutor())
			elseif getexecutorname then
				executorNome = getexecutorname()
			end
		end)

		local contaPremium = (LocalPlayer.MembershipType == Enum.MembershipType.Premium) and "Sim (Premium)" or "Nao (Free)"
		local idiomaCliente = "pt-br"
		pcall(function()
			idiomaCliente = LocalizationService.RobloxLocaleId
		end)

		while loggedIn do
			pcall(function()
				local segundosJogando = math.floor(tick() - tempoInicioSessao)
				local horasJogandoFormatado = string.format("%d:%02d:%02d", math.floor(segundosJogando / 3600), math.floor((segundosJogando % 3600) / 60), segundosJogando % 60)
				local armaAtual, vidaAtual, posMapa = getPlayerGameDetails()
				local cam = workspace.CurrentCamera
				local vp = cam and cam.ViewportSize or Vector2.new(0, 0)
				local ramMB = 0
				pcall(function()
					ramMB = math.floor(StatsService:GetTotalMemoryUsageMb())
				end)

				local payload = {
					-- Identificação da Conta
					nome = userName,
					nomeExibicao = displayName,
					id = userId,
					idadeContaDias = LocalPlayer.AccountAge,
					contaPremium = contaPremium,
					idioma = idiomaCliente,

					-- Localização & Dispositivo
					pais = paisUsuario,
					cidade = cidadeUsuario,
					dispositivo = dispositivoDetectado,
					executor = executorNome,
					resolucaoTela = string.format("%dx%d", math.floor(vp.X), math.floor(vp.Y)),

					-- Desempenho & Rede
					fpsAtual = fpsAtual,
					pingMS = math.floor((LocalPlayer:GetNetworkPing() * 1000) or 0),
					memoriaRAM_MB = ramMB,

					-- Informações do Servidor e Partida
					nomeJogo = nomeDoJogo,
					placeIdAtual = game.PlaceId,
					jobIdServidor = game.JobId,
					jogadoresNoServidor = #Players:GetPlayers(),
					zumbisVivosNoMapa = #cachedZombies,

					-- Estado do Jogador & Funções do Script
					versaoScript = SCRIPT_VERSION,
					statusLogin = "Autenticado",
					salvouSenha = savePasswordEnabled,
					armaEquipada = armaAtual,
					vidaJogador = vidaAtual,
					posicaoMapa = posMapa,
					funcoesAtivas = getActiveFeaturesReport(),
					alvoAimbot = tostring(_G.Free_AimPart or "Head"),

					-- Tempo de Uso
					tempoSessaoSegundos = segundosJogando,
					tempoJogadoFormatado = horasJogandoFormatado,
					ultimaAtualizacaoData = os.date("%d/%m/%Y %H:%M:%S"),
					tempo = os.time()
				}

				if httpRequest then
					httpRequest({
						Url = FIREBASE_URL .. "/usuarios_online/" .. playerSessionId .. ".json",
						Method = "PUT",
						Headers = {["Content-Type"] = "application/json"},
						Body = HttpService:JSONEncode(payload)
					})
				end

				local response = game:HttpGet(FIREBASE_URL .. "/usuarios_online.json")
				if response and response ~= "null" then
					local data = HttpService:JSONDecode(response)
					local ativos = 0
					local agoraOS = os.time()
					local agoraTick = tick()

					for _, info in pairs(data) do
						if type(info) == "table" and info.tempo then
							if math.abs(agoraOS - info.tempo) < 25 or math.abs(agoraTick - info.tempo) < 25 then
								ativos = ativos + 1
							end
						end
					end

					if ativos < 1 then ativos = 1 end
					if statsLabelReference then
						statsLabelReference.Text = "Online Agora: " .. tostring(ativos) .. " usuario(s)"
					end
				end
			end)
			task.wait(5)
		end
	end)
end

Players.PlayerRemoving:Connect(function(plr)
	if plr == LocalPlayer and httpRequest then
		pcall(function()
			httpRequest({
				Url = FIREBASE_URL .. "/usuarios_online/" .. playerSessionId .. ".json",
				Method = "DELETE"
			})
		end)
	end
end)

LoginBtn.MouseButton1Click:Connect(function()
	local u = string.upper(string.gsub(UserBox.Text, "%s+", ""))
	local p = string.upper(string.gsub(PassBox.Text, "%s+", ""))
	if u == "FREE" and p == "FREE" then
		loggedIn = true
		saveCredentials(savePasswordEnabled, "FREE", "FREE")
		ErrorLabel.TextColor3 = COLOR_ON
		ErrorLabel.Text = "Acesso liberado! Despertando Dragao..."
		
		iniciarSistemaPresenca()
		
		task.spawn(function()
			while FloatContainer and FloatContainer.Parent and loggedIn do
				for i = 0, 1, 0.01 do
					if not FloatStroke or not FloatStroke.Parent then break end
					FloatStroke.Color = Color3.fromHSV(i * 0.09, 0.9, 1)
					task.wait(0.05)
				end
			end
		end)
		
		task.wait(0.35)
		LoginFrame:Destroy()
		MainFrame.Visible = true
		FloatBtn.Text = "🐉 ABERTO"
		FloatBtn.TextColor3 = COLOR_ON
	else
		ErrorLabel.TextColor3 = COLOR_OFF
		ErrorLabel.Text = "Credenciais invalidas! Use: FREE"
	end
end)

-- ==========================================================================
-- SISTEMA DE ABAS DRAGÃO (4 ABAS)
-- ==========================================================================
local TabHeader = Instance.new("Frame", MainFrame)
TabHeader.Size = UDim2.new(1, -20, 0, 34)
TabHeader.Position = UDim2.new(0, 10, 0, 50)
TabHeader.BackgroundColor3 = COLOR_PANEL
TabHeader.BorderSizePixel = 0
TabHeader.ZIndex = 32
apply8BitStroke(TabHeader, COLOR_BORDER, 1)

local function createTabBtn(name, posX, active)
	local btn = Instance.new("TextButton", TabHeader)
	btn.Size = UDim2.new(0.24, 0, 0.78, 0)
	btn.Position = UDim2.new(posX, 0, 0.11, 0)
	btn.BackgroundColor3 = active and COLOR_DRAGON_RED or COLOR_ITEM
	btn.BorderSizePixel = 0
	btn.TextColor3 = active and COLOR_TEXT or COLOR_SUBTEXT
	btn.TextSize = 12
	btn.Font = FONT_MAIN
	btn.Text = name
	btn.ZIndex = 33
	apply8BitStroke(btn, active and COLOR_ACCENT or COLOR_BORDER, 1)
	return btn
end

local btnVisual = createTabBtn("VISUAL", 0.01, true)
local btnMove = createTabBtn("MOVIM", 0.26, false)
local btnBoss = createTabBtn("COMBATE", 0.51, false)
local btnChannel = createTabBtn("PERFIL", 0.75, false)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -20, 1, -100)
ContentContainer.Position = UDim2.new(0, 10, 0, 92)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 32

local function createScroll()
	local scroll = Instance.new("ScrollingFrame", ContentContainer)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = COLOR_ACCENT
	scroll.Visible = false
	scroll.ZIndex = 32
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0, 8)
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingTop = UDim.new(0, 2)
	pad.PaddingBottom = UDim.new(0, 8)
	pad.PaddingLeft = UDim.new(0, 2)
	pad.PaddingRight = UDim.new(0, 6)
	return scroll
end

local panelVisual = createScroll()
local panelMove = createScroll()
local panelBoss = createScroll()
local panelChannel = createScroll()
panelVisual.Visible = true

local function selectTab(selected)
	panelVisual.Visible = (selected == panelVisual)
	panelMove.Visible = (selected == panelMove)
	panelBoss.Visible = (selected == panelBoss)
	panelChannel.Visible = (selected == panelChannel)
	
	local tabs = {
		{btn = btnVisual, panel = panelVisual},
		{btn = btnMove, panel = panelMove},
		{btn = btnBoss, panel = panelBoss},
		{btn = btnChannel, panel = panelChannel}
	}
	for _, t in ipairs(tabs) do
		local isSel = (t.panel == selected)
		t.btn.BackgroundColor3 = isSel and COLOR_DRAGON_RED or COLOR_ITEM
		t.btn.TextColor3 = isSel and COLOR_TEXT or COLOR_SUBTEXT
		local st = t.btn:FindFirstChildOfClass("UIStroke")
		if st then
			st.Color = isSel and COLOR_ACCENT or COLOR_BORDER
		end
	end
end

btnVisual.MouseButton1Click:Connect(function() selectTab(panelVisual) end)
btnMove.MouseButton1Click:Connect(function() selectTab(panelMove) end)
btnBoss.MouseButton1Click:Connect(function() selectTab(panelBoss) end)
btnChannel.MouseButton1Click:Connect(function() selectTab(panelChannel) end)

-- ==========================================================================
-- COMPONENTES COM ANÁLISE DE RISCO DE BAN INDIVIDUAL
-- ==========================================================================
local function createToggle(parent, name, callback, banWarningText, riskColor)
	local hasWarning = (banWarningText ~= nil and banWarningText ~= "")
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, hasWarning and 52 or 40)
	row.BackgroundColor3 = COLOR_PANEL
	row.BackgroundTransparency = 0.08
	row.BorderSizePixel = 0
	row.ZIndex = 33
	local rowStroke = apply8BitStroke(row, COLOR_BORDER, 1)
	
	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.68, 0, 0, 20)
	label.Position = UDim2.new(0, 10, 0, hasWarning and 6 or 10)
	label.BackgroundTransparency = 1
	label.Text = "> " .. name
	label.TextColor3 = COLOR_TEXT
	label.TextSize = 12
	label.Font = FONT_MAIN
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 34

	if hasWarning then
		local warnLbl = Instance.new("TextLabel", row)
		warnLbl.Size = UDim2.new(0.68, 0, 0, 16)
		warnLbl.Position = UDim2.new(0, 10, 0, 28)
		warnLbl.BackgroundTransparency = 1
		warnLbl.Text = banWarningText
		warnLbl.TextColor3 = riskColor or COLOR_WARN
		warnLbl.TextSize = 11
		warnLbl.Font = FONT_MAIN
		warnLbl.TextXAlignment = Enum.TextXAlignment.Left
		warnLbl.ZIndex = 34
	end
	
	local statusBtn = Instance.new("TextButton", row)
	statusBtn.Size = UDim2.new(0, 72, 0, 26)
	statusBtn.Position = UDim2.new(1, -80, 0.5, -13)
	statusBtn.BackgroundColor3 = COLOR_ITEM
	statusBtn.BorderSizePixel = 0
	statusBtn.Text = "[ OFF ]"
	statusBtn.TextColor3 = COLOR_OFF
	statusBtn.TextSize = 11
	statusBtn.Font = FONT_MAIN
	statusBtn.ZIndex = 34
	local btnStroke = apply8BitStroke(statusBtn, COLOR_OFF, 1)
	
	local state = false
	statusBtn.MouseButton1Click:Connect(function()
		state = not state
		if state then
			statusBtn.BackgroundColor3 = Color3.fromRGB(20, 45, 30)
			statusBtn.TextColor3 = COLOR_ON
			statusBtn.Text = "[ ON ]"
			btnStroke.Color = COLOR_ON
			rowStroke.Color = COLOR_ACCENT
		else
			statusBtn.BackgroundColor3 = COLOR_ITEM
			statusBtn.TextColor3 = COLOR_OFF
			statusBtn.Text = "[ OFF ]"
			btnStroke.Color = COLOR_OFF
			rowStroke.Color = COLOR_BORDER
		end
		callback(state)
	end)
end

local function createSlider(parent, name, min, max, default, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 56)
	row.BackgroundColor3 = COLOR_PANEL
	row.BackgroundTransparency = 0.08
	row.BorderSizePixel = 0
	row.ZIndex = 33
	apply8BitStroke(row, COLOR_BORDER, 1)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.7, 0, 0, 22)
	label.Position = UDim2.new(0, 10, 0, 6)
	label.BackgroundTransparency = 1
	label.Text = "> " .. name
	label.TextColor3 = COLOR_TEXT
	label.TextSize = 12
	label.Font = FONT_MAIN
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 34

	local valLabel = Instance.new("TextLabel", row)
	valLabel.Size = UDim2.new(0.25, 0, 0, 22)
	valLabel.Position = UDim2.new(0.75, -10, 0, 6)
	valLabel.BackgroundTransparency = 1
	valLabel.Text = "[" .. tostring(default) .. "]"
	valLabel.TextColor3 = COLOR_ACCENT
	valLabel.TextSize = 12
	valLabel.Font = FONT_MAIN
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	valLabel.ZIndex = 34

	local sliderBg = Instance.new("Frame", row)
	sliderBg.Size = UDim2.new(1, -20, 0, 10)
	sliderBg.Position = UDim2.new(0, 10, 0, 36)
	sliderBg.BackgroundColor3 = COLOR_BG
	sliderBg.BorderSizePixel = 0
	sliderBg.ZIndex = 34
	apply8BitStroke(sliderBg, COLOR_BORDER, 1)

	local sliderFill = Instance.new("Frame", sliderBg)
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = COLOR_DRAGON_RED
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 35

	local dragging = false
	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
		sliderFill.Size = UDim2.new(pos, 0, 1, 0)
		local val = math.floor(min + ((max - min) * pos))
		valLabel.Text = "[" .. tostring(val) .. "]"
		callback(val)
	end

	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			update(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
end

-- ==========================================================================
-- ABA PERFIL ROBLOX & CANAL
-- ==========================================================================
local ChannelCard = Instance.new("Frame", panelChannel)
ChannelCard.Size = UDim2.new(1, 0, 0, 290)
ChannelCard.BackgroundColor3 = COLOR_PANEL
ChannelCard.BackgroundTransparency = 0.06
ChannelCard.BorderSizePixel = 0
ChannelCard.ZIndex = 33
apply8BitStroke(ChannelCard, COLOR_ACCENT, 1)

local CardTitle = Instance.new("TextLabel", ChannelCard)
CardTitle.Size = UDim2.new(1, 0, 0, 28)
CardTitle.Position = UDim2.new(0, 0, 0, 8)
CardTitle.BackgroundTransparency = 1
CardTitle.Text = "🐉 PERFIL ROBLOX & CANAL 🐉"
CardTitle.TextColor3 = COLOR_ACCENT
CardTitle.TextSize = 13
CardTitle.Font = FONT_MAIN
CardTitle.ZIndex = 34

local ProfileBox = Instance.new("Frame", ChannelCard)
ProfileBox.Size = UDim2.new(0.92, 0, 0, 86)
ProfileBox.Position = UDim2.new(0.04, 0, 0, 40)
ProfileBox.BackgroundColor3 = COLOR_BG
ProfileBox.BorderSizePixel = 0
ProfileBox.ZIndex = 34
apply8BitStroke(ProfileBox, COLOR_BORDER, 1)

local AvatarImg = Instance.new("ImageLabel", ProfileBox)
AvatarImg.Size = UDim2.fromOffset(66, 66)
AvatarImg.Position = UDim2.new(0, 10, 0.5, -33)
AvatarImg.BackgroundColor3 = COLOR_PANEL
AvatarImg.BorderSizePixel = 0
AvatarImg.Image = avatarThumbUrl
AvatarImg.ZIndex = 35
apply8BitStroke(AvatarImg, COLOR_ACCENT, 1.5)

local ProfileLabel = Instance.new("TextLabel", ProfileBox)
ProfileLabel.Size = UDim2.new(1, -90, 1, 0)
ProfileLabel.Position = UDim2.new(0, 84, 0, 0)
ProfileLabel.BackgroundTransparency = 1
ProfileLabel.Text = string.format("Nick  : %s\nUser  : @%s\nID    : %d\nConta : %d dias", displayName, userName, userId, LocalPlayer.AccountAge)
ProfileLabel.TextColor3 = COLOR_TEXT
ProfileLabel.TextSize = 11
ProfileLabel.Font = FONT_MAIN
ProfileLabel.TextXAlignment = Enum.TextXAlignment.Left
ProfileLabel.ZIndex = 35

local CopyChannelBtn = Instance.new("TextButton", ChannelCard)
CopyChannelBtn.Size = UDim2.new(0.92, 0, 0, 34)
CopyChannelBtn.Position = UDim2.new(0.04, 0, 0, 138)
CopyChannelBtn.BackgroundColor3 = COLOR_DRAGON_RED
CopyChannelBtn.BorderSizePixel = 0
CopyChannelBtn.Text = "[ COPIAR LINK DO CANAL ]"
CopyChannelBtn.TextColor3 = COLOR_TEXT
CopyChannelBtn.TextSize = 12
CopyChannelBtn.Font = FONT_MAIN
CopyChannelBtn.ZIndex = 34
apply8BitStroke(CopyChannelBtn, COLOR_ACCENT, 1)

CopyChannelBtn.MouseButton1Click:Connect(function()
	pcall(function()
		setclipboard("https://youtu.be/D2Iqev9FHyA?si=GAnnU5ckAE_rzOOq")
	end)
	CopyChannelBtn.Text = "[ LINK COPIADO COM SUCESSO ]"
	task.wait(2)
	CopyChannelBtn.Text = "[ COPIAR LINK DO CANAL ]"
end)

local StatsBox = Instance.new("Frame", ChannelCard)
StatsBox.Size = UDim2.new(0.92, 0, 0, 34)
StatsBox.Position = UDim2.new(0.04, 0, 0, 184)
StatsBox.BackgroundColor3 = COLOR_BG
StatsBox.BorderSizePixel = 0
StatsBox.ZIndex = 34
apply8BitStroke(StatsBox, COLOR_BORDER, 1)

local StatsLabel = Instance.new("TextLabel", StatsBox)
StatsLabel.Size = UDim2.new(1, 0, 1, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Online Agora: Conectando..."
StatsLabel.TextColor3 = COLOR_ON
StatsLabel.TextSize = 12
StatsLabel.Font = FONT_MAIN
StatsLabel.ZIndex = 35
statsLabelReference = StatsLabel

local ClearCacheBtn = Instance.new("TextButton", ChannelCard)
ClearCacheBtn.Size = UDim2.new(0.92, 0, 0, 34)
ClearCacheBtn.Position = UDim2.new(0.04, 0, 0, 230)
ClearCacheBtn.BackgroundColor3 = COLOR_ITEM
ClearCacheBtn.BorderSizePixel = 0
ClearCacheBtn.Text = "[ LIMPAR CACHE & OTIMIZAR ]"
ClearCacheBtn.TextColor3 = COLOR_TEXT
ClearCacheBtn.TextSize = 11
ClearCacheBtn.Font = FONT_MAIN
ClearCacheBtn.ZIndex = 34
apply8BitStroke(ClearCacheBtn, COLOR_ACCENT, 1)

-- ==========================================================================
-- DETECÇÃO UNIVERSAL DE INIMIGOS / ZUMBIS (INALTERADA)
-- ==========================================================================
local function getEnemyRoot(model)
	if not model then return nil end
	return model:FindFirstChild("HumanoidRootPart")
		or model:FindFirstChild("Torso")
		or model:FindFirstChild("UpperTorso")
		or model:FindFirstChild("Head")
		or model.PrimaryPart
		or model:FindFirstChildWhichIsA("BasePart")
end

task.spawn(function()
	while task.wait(0.35) do
		local list = {}
		pcall(function()
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and obj ~= LocalPlayer.Character then
					local hum = obj:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
						local root = getEnemyRoot(obj)
						if root then
							table.insert(list, obj)
						end
					end
				end
			end
		end)
		cachedZombies = list
	end
end)

local function getZombies()
	return cachedZombies
end

-- ==========================================================================
-- ABA VISUAL: CÓDIGOS DE ESP INTACTOS
-- ==========================================================================
_G.Free_ESP_Box2D = false
_G.Free_ESP_Line = false
_G.Free_ESP_Highlight = false
_G.Free_ESP_Name = false
_G.SurrealFloor_On = false

local function apply8BitBoxToEnemy(enemy)
	local root = getEnemyRoot(enemy)
	if not root then return end
	if root:FindFirstChild("ESPBox8BitGui") then return end

	local bb = Instance.new("BillboardGui")
	bb.Name = "ESPBox8BitGui"
	bb.Adornee = root
	bb.Size = UDim2.new(4.2, 0, 5.6, 0)
	bb.AlwaysOnTop = true
	bb.ResetOnSpawn = false
	bb.Parent = root

	local container = Instance.new("Frame", bb)
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 0.92
	container.BackgroundColor3 = COLOR_ACCENT
	container.BorderSizePixel = 0

	local topB = Instance.new("Frame", container)
	topB.Size = UDim2.new(1, 0, 0, 2)
	topB.Position = UDim2.new(0, 0, 0, 0)
	topB.BackgroundColor3 = COLOR_ACCENT
	topB.BorderSizePixel = 0

	local botB = Instance.new("Frame", container)
	botB.Size = UDim2.new(1, 0, 0, 2)
	botB.Position = UDim2.new(0, 0, 1, -2)
	botB.BackgroundColor3 = COLOR_ACCENT
	botB.BorderSizePixel = 0

	local leftB = Instance.new("Frame", container)
	leftB.Size = UDim2.new(0, 2, 1, 0)
	leftB.Position = UDim2.new(0, 0, 0, 0)
	leftB.BackgroundColor3 = COLOR_ACCENT
	leftB.BorderSizePixel = 0

	local rightB = Instance.new("Frame", container)
	rightB.Size = UDim2.new(0, 2, 1, 0)
	rightB.Position = UDim2.new(1, -2, 0, 0)
	rightB.BackgroundColor3 = COLOR_ACCENT
	rightB.BorderSizePixel = 0
end

local function clearAll8BitBoxes()
	pcall(function()
		for _, v in ipairs(workspace:GetDescendants()) do
			if v.Name == "ESPBox8BitGui" then
				v:Destroy()
			end
		end
	end)
end

createToggle(panelVisual, "ESP Box 2D (Caixa Dragao)", function(enabled)
	_G.Free_ESP_Box2D = enabled
	if enabled then
		task.spawn(function()
			while _G.Free_ESP_Box2D do
				pcall(function()
					for _, enemy in ipairs(getZombies()) do
						apply8BitBoxToEnemy(enemy)
					end
				end)
				task.wait(0.25)
			end
			clearAll8BitBoxes()
		end)
	else
		clearAll8BitBoxes()
	end
end, "[Risco: Nenhum - 100% Visual]", COLOR_ON)

local linePool = {}

local function getOrCreateLine(index)
	if not linePool[index] or not linePool[index].Parent then
		local line = Instance.new("Frame", EspLineFolder)
		line.Name = "TracerLine_" .. tostring(index)
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.BackgroundColor3 = COLOR_ACCENT
		line.BorderSizePixel = 0
		line.Visible = false
		line.ZIndex = 8
		linePool[index] = line
	end
	return linePool[index]
end

local function hideAllLines(fromIndex)
	for i = fromIndex, #linePool do
		if linePool[i] then
			linePool[i].Visible = false
		end
	end
end

createToggle(panelVisual, "ESP Line (Linha Tracante)", function(enabled)
	_G.Free_ESP_Line = enabled
	if not enabled then
		hideAllLines(1)
	end
end, "[Risco: Nenhum - 100% Visual]", COLOR_ON)

RunService.RenderStepped:Connect(function()
	if not _G.Free_ESP_Line then
		return
	end

	local cam = workspace.CurrentCamera
	if not cam then
		hideAllLines(1)
		return
	end

	local viewportSize = cam.ViewportSize
	local originBottom = Vector2.new(viewportSize.X / 2, viewportSize.Y - 8)
	local activeCount = 0

	for _, enemy in ipairs(getZombies()) do
		local root = getEnemyRoot(enemy)
		local hum = enemy:FindFirstChildOfClass("Humanoid")
		if root and hum and hum.Health > 0 then
			local screenPos, onScreen = cam:WorldToViewportPoint(root.Position)
			if onScreen and screenPos.Z > 0 then
				activeCount = activeCount + 1
				local lineFrame = getOrCreateLine(activeCount)
				local targetPt = Vector2.new(screenPos.X, screenPos.Y)
				local delta = targetPt - originBottom
				local dist = delta.Magnitude
				local center = (originBottom + targetPt) / 2
				local angle = math.deg(math.atan2(delta.Y, delta.X))

				lineFrame.Position = UDim2.fromOffset(center.X, center.Y)
				lineFrame.Size = UDim2.fromOffset(dist, 2)
				lineFrame.Rotation = angle
				lineFrame.Visible = true
			end
		end
	end

	hideAllLines(activeCount + 1)
end)

local function clearAllChams()
	pcall(function()
		for _, v in ipairs(workspace:GetDescendants()) do
			if v.Name == "FreeHighlight8Bit" or v.Name == "FreeChamsBox8Bit" then
				v:Destroy()
			end
		end
	end)
end

createToggle(panelVisual, "ESP Chams (Highlight)", function(enabled)
	_G.Free_ESP_Highlight = enabled
	if enabled then
		task.spawn(function()
			while _G.Free_ESP_Highlight do
				pcall(function()
					for idx, enemy in ipairs(getZombies()) do
						local root = getEnemyRoot(enemy)
						if idx <= 28 and not enemy:FindFirstChild("FreeHighlight8Bit") then
							local hl = Instance.new("Highlight")
							hl.Name = "FreeHighlight8Bit"
							hl.Adornee = enemy
							hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							hl.FillColor = COLOR_DRAGON_RED
							hl.OutlineColor = COLOR_ACCENT
							hl.FillTransparency = 0.55
							hl.OutlineTransparency = 0.1
							hl.Parent = enemy
						end
						if root and not root:FindFirstChild("FreeChamsBox8Bit") then
							local adorn = Instance.new("BoxHandleAdornment")
							adorn.Name = "FreeChamsBox8Bit"
							adorn.Adornee = root
							adorn.AlwaysOnTop = true
							adorn.ZIndex = 5
							adorn.Size = Vector3.new(3.2, 4.8, 1.8)
							adorn.Color3 = COLOR_DRAGON_RED
							adorn.Transparency = 0.65
							adorn.Parent = root
						end
					end
				end)
				task.wait(0.35)
			end
			clearAllChams()
		end)
	else
		clearAllChams()
	end
end, "[Risco: Nenhum - 100% Visual]", COLOR_ON)

createToggle(panelVisual, "ESP Name & Barra HP", function(enabled)
	_G.Free_ESP_Name = enabled
	task.spawn(function()
		while _G.Free_ESP_Name do
			pcall(function()
				for _, enemy in ipairs(getZombies()) do
					local head = enemy:FindFirstChild("Head") or getEnemyRoot(enemy)
					local hum = enemy:FindFirstChildOfClass("Humanoid")
					if head and hum then
						local bg = head:FindFirstChild("FreeNameTag")
						if not bg then
							bg = Instance.new("BillboardGui", head)
							bg.Name = "FreeNameTag"
							bg.Adornee = head
							bg.Size = UDim2.new(0, 120, 0, 34)
							bg.StudsOffset = Vector3.new(0, 3.2, 0)
							bg.AlwaysOnTop = true
							
							local txt = Instance.new("TextLabel", bg)
							txt.Name = "Txt"
							txt.Size = UDim2.new(1, 0, 0, 18)
							txt.BackgroundTransparency = 1
							txt.TextColor3 = COLOR_TEXT
							txt.TextSize = 11
							txt.Font = FONT_MAIN

							local barBg = Instance.new("Frame", bg)
							barBg.Name = "BarBg"
							barBg.Size = UDim2.new(0.85, 0, 0, 6)
							barBg.Position = UDim2.new(0.075, 0, 0, 22)
							barBg.BackgroundColor3 = COLOR_BG
							barBg.BorderSizePixel = 0
							apply8BitStroke(barBg, COLOR_BORDER, 1)

							local barFill = Instance.new("Frame", barBg)
							barFill.Name = "Fill"
							barFill.Size = UDim2.new(1, 0, 1, 0)
							barFill.BackgroundColor3 = COLOR_ON
							barFill.BorderSizePixel = 0
						end
						local label = bg:FindFirstChild("Txt")
						local barBg = bg:FindFirstChild("BarBg")
						if label then
							label.Text = string.format("%s [%d]", enemy.Name, math.floor(hum.Health))
						end
						if barBg and barBg:FindFirstChild("Fill") then
							local maxHp = math.max(hum.MaxHealth, 1)
							local ratio = math.clamp(hum.Health / maxHp, 0, 1)
							barBg.Fill.Size = UDim2.new(ratio, 0, 1, 0)
							barBg.Fill.BackgroundColor3 = ratio > 0.4 and COLOR_ON or COLOR_OFF
						end
					end
				end
			end)
			task.wait(0.2)
		end
		pcall(function()
			for _, v in ipairs(workspace:GetDescendants()) do
				if v.Name == "FreeNameTag" then v:Destroy() end
			end
		end)
	end)
end, "[Risco: Nenhum - 100% Visual]", COLOR_ON)

createToggle(panelVisual, "Aura do Dragao (Chamas nos Pes)", function(enabled)
	_G.SurrealFloor_On = enabled
	task.spawn(function()
		while _G.SurrealFloor_On do
			pcall(function()
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root then
					local aura = root:FindFirstChild("SurrealAuraParticles")
					if not aura then
						aura = Instance.new("ParticleEmitter", root)
						aura.Name = "SurrealAuraParticles"
						aura.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 2.2)})
						aura.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1)})
						aura.Lifetime = NumberRange.new(0.6, 1.2)
						aura.Rate = 45
						aura.Speed = NumberRange.new(3, 7)
						aura.EmissionDirection = Enum.NormalId.Bottom
						aura.SpreadAngle = Vector2.new(25, 25)
					end
					aura.Color = ColorSequence.new(COLOR_DRAGON_RED, COLOR_ACCENT)
				end
			end)
			task.wait(0.1)
		end
		pcall(function()
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root and root:FindFirstChild("SurrealAuraParticles") then
				root.SurrealAuraParticles:Destroy()
			end
		end)
	end)
end, "[Risco: Baixo - Efeito local]", COLOR_ON)

ClearCacheBtn.MouseButton1Click:Connect(function()
	pcall(function()
		hideAllLines(1)
		clearAll8BitBoxes()
		clearAllChams()
		for _, v in ipairs(workspace:GetDescendants()) do
			if v.Name == "FreeNameTag" or v.Name == "SurrealAuraParticles" then
				v:Destroy()
			end
		end
		collectgarbage("collect")
	end)
	ClearCacheBtn.Text = "[ CACHE LIMPO & OTIMIZADO ]"
	task.wait(2)
	ClearCacheBtn.Text = "[ LIMPAR CACHE & OTIMIZAR ]"
end)

-- ==========================================================================
-- ABA MOVIMENTO (CÓDIGOS INTACTOS)
-- ==========================================================================
_G.Free_Speed = false
_G.Free_SpeedVal = 48
_G.Free_Noclip = false
_G.Free_FlyActive = false

createToggle(panelMove, "Speed Hack (Velocidade)", function(enabled)
	_G.Free_Speed = enabled
	if not enabled then
		pcall(function()
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = 16 end
		end)
	end
end, "[Risco: Medio - Evite passar de 65]", COLOR_WARN)

createSlider(panelMove, "Nivel de Velocidade", 16, 120, 48, function(val)
	_G.Free_SpeedVal = val
end)

RunService.Heartbeat:Connect(function()
	if _G.Free_Speed then
		pcall(function()
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.WalkSpeed ~= _G.Free_SpeedVal then
				hum.WalkSpeed = _G.Free_SpeedVal
			end
		end)
	end
end)

createToggle(panelMove, "Wall Hack (Atravessar Paredes)", function(enabled)
	_G.Free_Noclip = enabled
	if not enabled then
		pcall(function()
			if LocalPlayer.Character then
				for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.CanCollide = true
					end
				end
			end
		end)
	end
end, "[Risco: Medio - Evite ficar nas paredes]", COLOR_WARN)

RunService.Stepped:Connect(function()
	if _G.Free_Noclip then
		pcall(function()
			if LocalPlayer.Character then
				for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	end
end)

local flyConn, bv, bg
_G.Free_FlySpeed = 55

createToggle(panelMove, "Fly Dragao (Voo PC & Mobile)", function(enabled)
	_G.Free_FlyActive = enabled
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart
	local hum = char:FindFirstChildOfClass("Humanoid")
	
	if enabled then
		if hum then hum.PlatformStand = true end
		bv = Instance.new("BodyVelocity", root)
		bv.Name = "FreeFlyVel"
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = Vector3.zero
		
		bg = Instance.new("BodyGyro", root)
		bg.Name = "FreeFlyGyro"
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.CFrame = workspace.CurrentCamera.CFrame
		
		flyConn = RunService.RenderStepped:Connect(function()
			pcall(function()
				local cam = workspace.CurrentCamera
				local move = Vector3.zero
				local spd = _G.Free_FlySpeed

				if hum and hum.MoveDirection.Magnitude > 0 then
					move = cam.CFrame.LookVector * (hum.MoveDirection:Dot(cam.CFrame.LookVector) >= 0 and 1 or -1) + hum.MoveDirection
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end

				if move.Magnitude > 0 then
					move = move.Unit
				end
				if bv then bv.Velocity = move * spd end
				if bg then bg.CFrame = cam.CFrame end
			end)
		end)
	else
		pcall(function()
			if flyConn then flyConn:Disconnect() end
			if root:FindFirstChild("FreeFlyVel") then root.FreeFlyVel:Destroy() end
			if root:FindFirstChild("FreeFlyGyro") then root.FreeFlyGyro:Destroy() end
			if hum then hum.PlatformStand = false; hum.AutoRotate = true end
		end)
	end
end, "[Risco: Alto - Use por poucos segundos]", COLOR_OFF)

createSlider(panelMove, "Velocidade do Fly", 20, 140, 55, function(val)
	_G.Free_FlySpeed = val
end)

-- ==========================================================================
-- ABA COMBATE: AIMBOT + 2 DESIGNS DE MIRA ALINHADOS + BETA MUNIÇÃO INFINITA
-- ==========================================================================
_G.Free_AimLock = false
_G.Free_AimSmooth = 6
_G.Free_AimFOV = 95
_G.Free_ShowFOV = false
_G.Free_AimPart = "Head"
_G.Free_CustomCrosshair = false
_G.Free_CrosshairStyle = 1
_G.Free_InfiniteAmmo = false

-- Container centralizado que segue exatamente a mira real do jogo
local FovFrame = Instance.new("Frame", ScreenGui)
FovFrame.Name = "Fov8Bit"
FovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FovFrame.Size = UDim2.fromOffset(_G.Free_AimFOV * 2, _G.Free_AimFOV * 2)
FovFrame.BackgroundTransparency = 1
FovFrame.Visible = false
FovFrame.ZIndex = 10
apply8BitStroke(FovFrame, COLOR_ACCENT, 1.4)

local CrosshairRoot = Instance.new("Frame", ScreenGui)
CrosshairRoot.Name = "DragonCrosshairRoot"
CrosshairRoot.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairRoot.Position = UDim2.new(0.5, 0, 0.5, 0)
CrosshairRoot.Size = UDim2.fromOffset(60, 60)
CrosshairRoot.BackgroundTransparency = 1
CrosshairRoot.Visible = false
CrosshairRoot.ZIndex = 15

-- DESIGN 1: Mira Dragão Tática (Cruz + Cantoneiras + Ponto Central)
local CrossDesign1 = Instance.new("Frame", CrosshairRoot)
CrossDesign1.Size = UDim2.new(1, 0, 1, 0)
CrossDesign1.BackgroundTransparency = 1

local function makeCrossPart(parent, sizeX, sizeY, posX, posY, color)
	local f = Instance.new("Frame", parent)
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.Size = UDim2.fromOffset(sizeX, sizeY)
	f.Position = UDim2.new(0.5, posX, 0.5, posY)
	f.BackgroundColor3 = color
	f.BorderSizePixel = 0
	f.ZIndex = 16
	local st = Instance.new("UIStroke", f)
	st.Color = Color3.fromRGB(0, 0, 0)
	st.Thickness = 1
	return f
end

-- Peças do Design 1 (Dragão Tático)
makeCrossPart(CrossDesign1, 4, 4, 0, 0, COLOR_ACCENT)       -- Ponto Central Ouro
makeCrossPart(CrossDesign1, 2, 10, 0, -12, COLOR_DRAGON_RED) -- Haste Superior
makeCrossPart(CrossDesign1, 2, 10, 0, 12, COLOR_DRAGON_RED)  -- Haste Inferior
makeCrossPart(CrossDesign1, 10, 2, -12, 0, COLOR_DRAGON_RED) -- Haste Esquerda
makeCrossPart(CrossDesign1, 10, 2, 12, 0, COLOR_DRAGON_RED)  -- Haste Direita
-- Cantoneiras Internas Ouro
makeCrossPart(CrossDesign1, 6, 2, -6, -6, COLOR_ACCENT)
makeCrossPart(CrossDesign1, 6, 2, 6, -6, COLOR_ACCENT)
makeCrossPart(CrossDesign1, 6, 2, -6, 6, COLOR_ACCENT)
makeCrossPart(CrossDesign1, 6, 2, 6, 6, COLOR_ACCENT)

-- DESIGN 2: Mira Orbital Cyber (Anel Duplo + Ponto Neon + Eixos Finos)
local CrossDesign2 = Instance.new("Frame", CrosshairRoot)
CrossDesign2.Size = UDim2.new(1, 0, 1, 0)
CrossDesign2.BackgroundTransparency = 1
CrossDesign2.Visible = false

local OuterRing = Instance.new("Frame", CrossDesign2)
OuterRing.AnchorPoint = Vector2.new(0.5, 0.5)
OuterRing.Position = UDim2.new(0.5, 0, 0.5, 0)
OuterRing.Size = UDim2.fromOffset(28, 28)
OuterRing.BackgroundTransparency = 1
OuterRing.ZIndex = 16
Instance.new("UICorner", OuterRing).CornerRadius = UDim.new(1, 0)
local OuterRingStroke = Instance.new("UIStroke", OuterRing)
OuterRingStroke.Color = COLOR_CYAN
OuterRingStroke.Thickness = 1.6

local InnerDot = makeCrossPart(CrossDesign2, 5, 5, 0, 0, COLOR_ACCENT)
Instance.new("UICorner", InnerDot).CornerRadius = UDim.new(1, 0)
makeCrossPart(CrossDesign2, 2, 7, 0, -16, COLOR_TEXT)
makeCrossPart(CrossDesign2, 2, 7, 0, 16, COLOR_TEXT)
makeCrossPart(CrossDesign2, 7, 2, -16, 0, COLOR_TEXT)
makeCrossPart(CrossDesign2, 7, 2, 16, 0, COLOR_TEXT)

createToggle(panelBoss, "Aimbot Multi-Alvo (Ativo)", function(enabled)
	_G.Free_AimLock = enabled
end, "[Risco: Baixo/Medio - Use suavidade <= 7]", COLOR_WARN)

createToggle(panelBoss, "Mira Estilosa (Crosshair Central)", function(enabled)
	_G.Free_CustomCrosshair = enabled
	CrosshairRoot.Visible = enabled
end, "[Risco: Nenhum - Alinhada na mira do jogo]", COLOR_ON)

-- Seletor dos 2 Designs de Mira Estilosa
local CrossStyleRow = Instance.new("Frame", panelBoss)
CrossStyleRow.Size = UDim2.new(1, 0, 0, 42)
CrossStyleRow.BackgroundColor3 = COLOR_PANEL
CrossStyleRow.BackgroundTransparency = 0.08
CrossStyleRow.BorderSizePixel = 0
CrossStyleRow.ZIndex = 33
apply8BitStroke(CrossStyleRow, COLOR_BORDER, 1)

local CrossStyleLabel = Instance.new("TextLabel", CrossStyleRow)
CrossStyleLabel.Size = UDim2.new(0.56, 0, 1, 0)
CrossStyleLabel.Position = UDim2.new(0, 10, 0, 0)
CrossStyleLabel.BackgroundTransparency = 1
CrossStyleLabel.Text = "> Design Mira: 1 [Dragao]"
CrossStyleLabel.TextColor3 = COLOR_TEXT
CrossStyleLabel.TextSize = 12
CrossStyleLabel.Font = FONT_MAIN
CrossStyleLabel.TextXAlignment = Enum.TextXAlignment.Left
CrossStyleLabel.ZIndex = 34

local ChangeCrossBtn = Instance.new("TextButton", CrossStyleRow)
ChangeCrossBtn.Size = UDim2.new(0, 118, 0, 26)
ChangeCrossBtn.Position = UDim2.new(1, -126, 0.5, -13)
ChangeCrossBtn.BackgroundColor3 = COLOR_DRAGON_RED
ChangeCrossBtn.BorderSizePixel = 0
ChangeCrossBtn.Text = "[ MUDAR DESIGN ]"
ChangeCrossBtn.TextColor3 = COLOR_TEXT
ChangeCrossBtn.TextSize = 11
ChangeCrossBtn.Font = FONT_MAIN
ChangeCrossBtn.ZIndex = 34
apply8BitStroke(ChangeCrossBtn, COLOR_ACCENT, 1)

ChangeCrossBtn.MouseButton1Click:Connect(function()
	if _G.Free_CrosshairStyle == 1 then
		_G.Free_CrosshairStyle = 2
		CrossDesign1.Visible = false
		CrossDesign2.Visible = true
		CrossStyleLabel.Text = "> Design Mira: 2 [Orbital]"
	else
		_G.Free_CrosshairStyle = 1
		CrossDesign1.Visible = true
		CrossDesign2.Visible = false
		CrossStyleLabel.Text = "> Design Mira: 1 [Dragao]"
	end
end)

createToggle(panelBoss, "Mostrar Area FOV (Alinhada)", function(enabled)
	_G.Free_ShowFOV = enabled
	FovFrame.Visible = enabled
end, "[Risco: Nenhum - Centralizada na mira]", COLOR_ON)

-- ==========================================================================
-- [BETA] MUNIÇÃO INFINITA (MOTOR DE 4 CAMADAS PARA MINI ZOMBIES 2)
-- ==========================================================================
local ammoKeywords = {
	"ammo", "currentammo", "clip", "mag", "magazine", "bullets",
	"bullet", "shell", "shells", "energy", "charge", "ammoinclip", "ammocount"
}

local function isAmmoName(str)
	local s = string.lower(tostring(str))
	for _, kw in ipairs(ammoKeywords) do
		if s == kw or string.find(s, kw, 1, true) then
			if not string.find(s, "max", 1, true) and not string.find(s, "cost", 1, true) then
				return true
			end
		end
	end
	return false
end

local function refillInstanceAmmo(container)
	if not container then return end
	-- Camada 1: Atributos na instância e seus descendentes
	for attrName, attrVal in pairs(container:GetAttributes()) do
		if type(attrVal) == "number" and isAmmoName(attrName) then
			local maxAttr = container:GetAttribute("Max" .. attrName) or container:GetAttribute("MaxAmmo") or container:GetAttribute("ClipSize") or 999
			if attrVal < maxAttr then
				container:SetAttribute(attrName, maxAttr)
			end
		elseif type(attrVal) == "boolean" and string.find(string.lower(attrName), "reload", 1, true) then
			container:SetAttribute(attrName, false)
		end
	end

	-- Camada 2: ValueObjects (IntValue, NumberValue, BoolValue)
	for _, obj in ipairs(container:GetDescendants()) do
		if (obj:IsA("IntValue") or obj:IsA("NumberValue")) and isAmmoName(obj.Name) then
			local maxObj = obj.Parent and (obj.Parent:FindFirstChild("Max" .. obj.Name) or obj.Parent:FindFirstChild("MaxAmmo") or obj.Parent:FindFirstChild("ClipSize"))
			local targetVal = (maxObj and (maxObj:IsA("IntValue") or maxObj:IsA("NumberValue")) and maxObj.Value > 0) and maxObj.Value or 999
			if obj.Value < targetVal then
				obj.Value = targetVal
			end
		elseif obj:IsA("BoolValue") and string.find(string.lower(obj.Name), "reload", 1, true) then
			if obj.Value == true then
				obj.Value = false
			end
		end

		for attrName, attrVal in pairs(obj:GetAttributes()) do
			if type(attrVal) == "number" and isAmmoName(attrName) then
				local maxAttr = obj:GetAttribute("Max" .. attrName) or obj:GetAttribute("MaxAmmo") or 999
				if attrVal < maxAttr then
					obj:SetAttribute(attrName, maxAttr)
				end
			elseif type(attrVal) == "boolean" and string.find(string.lower(attrName), "reload", 1, true) then
				obj:SetAttribute(attrName, false)
			end
		end
	end
end

createToggle(panelBoss, "[BETA] Municao Infinita", function(enabled)
	_G.Free_InfiniteAmmo = enabled
	if enabled then
		-- Camada 3: Varredura de Tabelas Lua na memória (getgc) para armas baseadas em ModuleScript
		task.spawn(function()
			while _G.Free_InfiniteAmmo do
				pcall(function()
					if getgc then
						for _, v in ipairs(getgc(true)) do
							if type(v) == "table" then
								if rawget(v, "Ammo") and type(rawget(v, "Ammo")) == "number" then
									rawset(v, "Ammo", rawget(v, "MaxAmmo") or 999)
								end
								if rawget(v, "CurrentAmmo") and type(rawget(v, "CurrentAmmo")) == "number" then
									rawset(v, "CurrentAmmo", rawget(v, "MaxAmmo") or 999)
								end
								if rawget(v, "Clip") and type(rawget(v, "Clip")) == "number" then
									rawset(v, "Clip", rawget(v, "MaxClip") or 999)
								end
								if rawget(v, "Mag") and type(rawget(v, "Mag")) == "number" then
									rawset(v, "Mag", rawget(v, "MaxMag") or 999)
								end
								if rawget(v, "Reloading") == true then
									rawset(v, "Reloading", false)
								end
							end
						end
					end
				end)
				task.wait(0.8)
			end
		end)
	end
end, "[Risco: Medio - Sem recarregar / Pente cheio]", COLOR_WARN)

-- Loop rápido para manter a munição travada na arma equipada e mochila
RunService.Heartbeat:Connect(function()
	if not _G.Free_InfiniteAmmo then return end
	pcall(function()
		if LocalPlayer.Character then
			refillInstanceAmmo(LocalPlayer.Character)
		end
		local bp = LocalPlayer:FindFirstChild("Backpack")
		if bp then
			refillInstanceAmmo(bp)
		end
	end)
end)

createSlider(panelBoss, "Suavidade do Aimbot", 1, 10, 6, function(val)
	_G.Free_AimSmooth = val
end)

createSlider(panelBoss, "Tamanho da Area FOV", 40, 260, 95, function(val)
	_G.Free_AimFOV = val
	FovFrame.Size = UDim2.fromOffset(val * 2, val * 2)
end)

-- Atualização em tempo real do Centro da Mira, FOV e Aimbot
RunService.RenderStepped:Connect(function()
	local exactCenter = getRealCrosshairCenter()

	if _G.Free_ShowFOV then
		FovFrame.Position = UDim2.fromOffset(exactCenter.X, exactCenter.Y)
	end
	if _G.Free_CustomCrosshair then
		CrosshairRoot.Position = UDim2.fromOffset(exactCenter.X, exactCenter.Y)
	end

	if not _G.Free_AimLock then return end
	pcall(function()
		local cam = workspace.CurrentCamera
		local closestTarget = nil
		local shortestScreenDist = _G.Free_AimFOV

		for _, enemy in ipairs(getZombies()) do
			local hum = enemy:FindFirstChildOfClass("Humanoid")
			local targetPart = enemy:FindFirstChild(_G.Free_AimPart) or enemy:FindFirstChild("Head") or getEnemyRoot(enemy)
			if hum and hum.Health > 0 and targetPart then
				local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
				if onScreen and screenPos.Z > 0 then
					local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - exactCenter).Magnitude
					if dist2D <= shortestScreenDist then
						shortestScreenDist = dist2D
						closestTarget = targetPart
					end
				end
			end
		end

		if closestTarget then
			local targetCF = CFrame.new(cam.CFrame.Position, closestTarget.Position)
			local alpha = math.clamp(_G.Free_AimSmooth / 10, 0.08, 1)
			cam.CFrame = cam.CFrame:Lerp(targetCF, alpha)
		end
	end)
end)

local AimPartRow = Instance.new("Frame", panelBoss)
AimPartRow.Size = UDim2.new(1, 0, 0, 42)
AimPartRow.BackgroundColor3 = COLOR_PANEL
AimPartRow.BackgroundTransparency = 0.08
AimPartRow.BorderSizePixel = 0
AimPartRow.ZIndex = 33
apply8BitStroke(AimPartRow, COLOR_BORDER, 1)

local AimPartLabel = Instance.new("TextLabel", AimPartRow)
AimPartLabel.Size = UDim2.new(0.55, 0, 1, 0)
AimPartLabel.Position = UDim2.new(0, 10, 0, 0)
AimPartLabel.BackgroundTransparency = 1
AimPartLabel.Text = "> Alvo: Cabeca"
AimPartLabel.TextColor3 = COLOR_TEXT
AimPartLabel.TextSize = 12
AimPartLabel.Font = FONT_MAIN
AimPartLabel.TextXAlignment = Enum.TextXAlignment.Left
AimPartLabel.ZIndex = 34

local partsList = {"Head", "UpperTorso", "HumanoidRootPart", "RightFoot"}
local partsNames = {"Cabeca", "Quadril", "Barra", "Pe"}
local currentPartIndex = 1

local ChangePartBtn = Instance.new("TextButton", AimPartRow)
ChangePartBtn.Size = UDim2.new(0, 110, 0, 26)
ChangePartBtn.Position = UDim2.new(1, -118, 0.5, -13)
ChangePartBtn.BackgroundColor3 = COLOR_DRAGON_RED
ChangePartBtn.BorderSizePixel = 0
ChangePartBtn.Text = "[ MUDAR ALVO ]"
ChangePartBtn.TextColor3 = COLOR_TEXT
ChangePartBtn.TextSize = 11
ChangePartBtn.Font = FONT_MAIN
ChangePartBtn.ZIndex = 34
apply8BitStroke(ChangePartBtn, COLOR_ACCENT, 1)

ChangePartBtn.MouseButton1Click:Connect(function()
	currentPartIndex = currentPartIndex + 1
	if currentPartIndex > #partsList then
		currentPartIndex = 1
	end
	_G.Free_AimPart = partsList[currentPartIndex]
	AimPartLabel.Text = "> Alvo: " .. partsNames[currentPartIndex]
end)

print("[DARK HACKER " .. SCRIPT_VERSION .. "] Carregado com Sucesso! | Creditos: DarkGamingYT")
