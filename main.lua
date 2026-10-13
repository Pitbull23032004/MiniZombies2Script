-- ==========================================================================
-- CYBER HACKER | Versão FREE 1.4.0 (8-Bit Edition - ESP Box & Line)
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
local Camera = workspace.CurrentCamera

local SCRIPT_VERSION = "FREE 1.4.0 [8-BIT]"
local FIREBASE_URL = "https://darkgamingyt-1c438-default-rtdb.firebaseio.com"

local userId = LocalPlayer.UserId
local userName = LocalPlayer.Name
local displayName = LocalPlayer.DisplayName
local playerSessionId = "user_" .. tostring(userId)
local tempoInicioSessao = tick()

local paisUsuario = "Desconhecido"
local cidadeUsuario = "Desconhecida"

-- Fonte limpa, nítida e estritamente sem negrito
local FONT_MAIN = Enum.Font.Code
local FONT_CLEAN = Enum.Font.Gotham

-- Paleta de Cores 8-Bit Profissional
local COLOR_BG = Color3.fromRGB(12, 13, 18)
local COLOR_PANEL = Color3.fromRGB(18, 20, 28)
local COLOR_ITEM = Color3.fromRGB(24, 27, 38)
local COLOR_ACCENT = Color3.fromRGB(255, 140, 0)
local COLOR_TEXT = Color3.fromRGB(235, 240, 245)
local COLOR_SUBTEXT = Color3.fromRGB(145, 155, 170)
local COLOR_OFF = Color3.fromRGB(235, 75, 75)
local COLOR_ON = Color3.fromRGB(60, 230, 130)

task.spawn(function()
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

pcall(function()
	if CoreGui:FindFirstChild("CyberHacker_FREE_1_3_6") then
		CoreGui.CyberHacker_FREE_1_3_6:Destroy()
	end
	if LocalPlayer.PlayerGui:FindFirstChild("CyberHacker_FREE_1_3_6") then
		LocalPlayer.PlayerGui.CyberHacker_FREE_1_3_6:Destroy()
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
	if gethui then
		ScreenGui.Parent = gethui()
	end
end)

-- Pasta dedicada para renderizar ESP Box 2D e ESP Line sem lag
local EspCanvas = Instance.new("Folder", ScreenGui)
EspCanvas.Name = "EspCanvas8Bit"

-- Função auxiliar para criar bordas 8-Bit (cantos retos de 90 graus)
local function apply8BitStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = color or COLOR_ACCENT
	stroke.Thickness = thickness or 1.5
	stroke.LineJoinMode = Enum.LineJoinMode.Miter
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return stroke
end

-- ==========================================================================
-- BOTÃO FLUTUANTE 8-BIT
-- ==========================================================================
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.fromOffset(52, 52)
FloatBtn.Position = UDim2.new(0, 35, 0.35, 0)
FloatBtn.BackgroundColor3 = COLOR_BG
FloatBtn.BorderSizePixel = 0
FloatBtn.Text = "[8B]"
FloatBtn.TextColor3 = COLOR_ACCENT
FloatBtn.TextSize = 16
FloatBtn.Font = FONT_MAIN
FloatBtn.Active = true
FloatBtn.Draggable = true
FloatBtn.Visible = true
FloatBtn.ZIndex = 50

local FloatStroke = apply8BitStroke(FloatBtn, COLOR_ACCENT, 2)

-- ==========================================================================
-- PAINEL DE LOGIN SIMPLES, PROFISSIONAL E SEM NEGRITO
-- ==========================================================================
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 320, 0, 260)
LoginFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
LoginFrame.BackgroundColor3 = COLOR_BG
LoginFrame.BorderSizePixel = 0
LoginFrame.ZIndex = 60

local LoginStroke = apply8BitStroke(LoginFrame, COLOR_ACCENT, 2)

local LoginTopBar = Instance.new("Frame", LoginFrame)
LoginTopBar.Size = UDim2.new(1, 0, 0, 34)
LoginTopBar.BackgroundColor3 = COLOR_PANEL
LoginTopBar.BorderSizePixel = 0
LoginTopBar.ZIndex = 61
apply8BitStroke(LoginTopBar, Color3.fromRGB(40, 45, 60), 1)

local LoginHeader = Instance.new("TextLabel", LoginTopBar)
LoginHeader.Size = UDim2.new(1, -20, 1, 0)
LoginHeader.Position = UDim2.new(0, 10, 0, 0)
LoginHeader.BackgroundTransparency = 1
LoginHeader.Text = "DARKGAMINGYT // ACESSO"
LoginHeader.TextColor3 = COLOR_TEXT
LoginHeader.TextSize = 13
LoginHeader.Font = FONT_MAIN
LoginHeader.TextXAlignment = Enum.TextXAlignment.Left
LoginHeader.ZIndex = 62

local LoginVersionTag = Instance.new("TextLabel", LoginTopBar)
LoginVersionTag.Size = UDim2.new(0, 100, 1, 0)
LoginVersionTag.Position = UDim2.new(1, -110, 0, 0)
LoginVersionTag.BackgroundTransparency = 1
LoginVersionTag.Text = "v1.4.0"
LoginVersionTag.TextColor3 = COLOR_ACCENT
LoginVersionTag.TextSize = 12
LoginVersionTag.Font = FONT_MAIN
LoginVersionTag.TextXAlignment = Enum.TextXAlignment.Right
LoginVersionTag.ZIndex = 62

local LoginSubHeader = Instance.new("TextLabel", LoginFrame)
LoginSubHeader.Size = UDim2.new(0.88, 0, 0, 20)
LoginSubHeader.Position = UDim2.new(0.06, 0, 0, 44)
LoginSubHeader.BackgroundTransparency = 1
LoginSubHeader.Text = "Insira as credenciais para liberar o painel"
LoginSubHeader.TextColor3 = COLOR_SUBTEXT
LoginSubHeader.TextSize = 11
LoginSubHeader.Font = FONT_CLEAN
LoginSubHeader.TextXAlignment = Enum.TextXAlignment.Left
LoginSubHeader.ZIndex = 61

local function createLoginInput(posY, placeholder)
	local box = Instance.new("TextBox", LoginFrame)
	box.Size = UDim2.new(0.88, 0, 0, 38)
	box.Position = UDim2.new(0.06, 0, 0, posY)
	box.BackgroundColor3 = COLOR_PANEL
	box.BorderSizePixel = 0
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(100, 110, 125)
	box.Text = ""
	box.TextColor3 = COLOR_TEXT
	box.TextSize = 13
	box.Font = FONT_MAIN
	box.ClearTextOnFocus = false
	box.ZIndex = 61
	
	local stroke = apply8BitStroke(box, Color3.fromRGB(45, 50, 68), 1)
	
	box.Focused:Connect(function()
		stroke.Color = COLOR_ACCENT
	end)
	box.FocusLost:Connect(function()
		stroke.Color = Color3.fromRGB(45, 50, 68)
	end)
	
	return box
end

local UserBox = createLoginInput(72, "Usuario: FREE")
local PassBox = createLoginInput(120, "Senha: FREE")

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0.88, 0, 0, 38)
LoginBtn.Position = UDim2.new(0.06, 0, 0, 172)
LoginBtn.BackgroundColor3 = COLOR_ACCENT
LoginBtn.BorderSizePixel = 0
LoginBtn.Text = "[ ENTRAR NO SISTEMA ]"
LoginBtn.TextColor3 = COLOR_BG
LoginBtn.TextSize = 13
LoginBtn.Font = FONT_MAIN
LoginBtn.ZIndex = 61
apply8BitStroke(LoginBtn, Color3.fromRGB(255, 180, 80), 1)

local ErrorLabel = Instance.new("TextLabel", LoginFrame)
ErrorLabel.Size = UDim2.new(0.88, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0.06, 0, 0, 222)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = "Status: Aguardando login..."
ErrorLabel.TextColor3 = COLOR_SUBTEXT
ErrorLabel.TextSize = 11
ErrorLabel.Font = FONT_MAIN
ErrorLabel.TextXAlignment = Enum.TextXAlignment.Center
ErrorLabel.ZIndex = 61

local loggedIn = false
local statsLabelReference = nil

-- ==========================================================================
-- PAINEL PRINCIPAL 8-BIT
-- ==========================================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 440)
MainFrame.Position = UDim2.new(0, 105, 0.35, 0)
MainFrame.BackgroundColor3 = COLOR_BG
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.ZIndex = 30

local MainStroke = apply8BitStroke(MainFrame, COLOR_ACCENT, 2)

task.spawn(function()
	while MainFrame and MainFrame.Parent do
		for i = 0, 1, 0.008 do
			if not MainStroke or not MainStroke.Parent then break end
			MainStroke.Color = Color3.fromHSV(i * 0.12 + 0.04, 0.85, 1)
			task.wait(0.05)
		end
	end
end)

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
		
		while loggedIn do
			pcall(function()
				local segundosJogando = math.floor(tick() - tempoInicioSessao)
				local horasJogandoFormatado = string.format("%d:%02d:%02d", math.floor(segundosJogando / 3600), math.floor((segundosJogando % 3600) / 60), segundosJogando % 60)

				request({
					Url = FIREBASE_URL .. "/usuarios_online/" .. playerSessionId .. ".json",
					Method = "PUT",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode({
						nome = userName,
						nomeExibicao = displayName,
						id = userId,
						versaoScript = SCRIPT_VERSION,
						statusLogin = "Autenticado",
						dispositivo = dispositivoDetectado,
						pais = paisUsuario,
						cidade = cidadeUsuario,
						idadeContaDias = LocalPlayer.AccountAge,
						tempoSessaoSegundos = segundosJogando,
						tempoJogadoFormatado = horasJogandoFormatado,
						placeIdAtual = game.PlaceId,
						jobIdServidor = game.JobId,
						jogadoresNoServidor = #Players:GetPlayers(),
						executor = executorNome,
						pingMS = math.floor((LocalPlayer:GetNetworkPing() * 1000) or 0),
						tempo = tick()
					})
				})

				local response = game:HttpGet(FIREBASE_URL .. "/usuarios_online.json")
				if response and response ~= "null" then
					local data = HttpService:JSONDecode(response)
					local ativos = 0
					local agora = tick()

					for id, info in pairs(data) do
						if type(info) == "table" and info.tempo and (agora - info.tempo < 15) then
							ativos = ativos + 1
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
	if plr == LocalPlayer then
		pcall(function()
			request({
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
		ErrorLabel.TextColor3 = COLOR_ON
		ErrorLabel.Text = "Acesso liberado. Inicializando..."
		
		iniciarSistemaPresenca()
		
		task.spawn(function()
			while FloatBtn and FloatBtn.Parent and loggedIn do
				for i = 0, 1, 0.008 do
					if not FloatStroke or not FloatStroke.Parent then break end
					FloatStroke.Color = Color3.fromHSV(i * 0.12 + 0.04, 0.85, 1)
					task.wait(0.05)
				end
			end
		end)
		
		task.wait(0.5)
		LoginFrame:Destroy()
		MainFrame.Visible = true
	else
		ErrorLabel.TextColor3 = COLOR_OFF
		ErrorLabel.Text = "Credenciais invalidas (Use: FREE)"
	end
end)

-- ==========================================================================
-- CONTADOR DE FPS 8-BIT
-- ==========================================================================
local FpsLabel = Instance.new("TextLabel", ScreenGui)
FpsLabel.Size = UDim2.fromOffset(52, 18)
FpsLabel.Position = UDim2.new(0, 35, 0.35, -22)
FpsLabel.BackgroundColor3 = COLOR_BG
FpsLabel.BorderSizePixel = 0
FpsLabel.Text = "FPS:00"
FpsLabel.TextColor3 = COLOR_ACCENT
FpsLabel.TextSize = 11
FpsLabel.Font = FONT_MAIN
FpsLabel.TextXAlignment = Enum.TextXAlignment.Center
FpsLabel.ZIndex = 50
apply8BitStroke(FpsLabel, COLOR_ACCENT, 1)

local fpsLastTick = tick()
local fpsFrames = 0
RunService.RenderStepped:Connect(function()
	fpsFrames = fpsFrames + 1
	local now = tick()
	if now - fpsLastTick >= 1 then
		local fps = math.floor(fpsFrames / (now - fpsLastTick))
		FpsLabel.Text = "FPS:" .. tostring(fps)
		fpsFrames = 0
		fpsLastTick = now
	end
end)

FloatBtn:GetPropertyChangedSignal("Position"):Connect(function()
	FpsLabel.Position = UDim2.new(FloatBtn.Position.X.Scale, FloatBtn.Position.X.Offset, FloatBtn.Position.Y.Scale, FloatBtn.Position.Y.Offset - 22)
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = COLOR_PANEL
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 31
apply8BitStroke(TopBar, Color3.fromRGB(40, 45, 60), 1)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -24, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = ":: DARK HACKER // " .. SCRIPT_VERSION
TitleLabel.TextColor3 = COLOR_TEXT
TitleLabel.TextSize = 13
TitleLabel.Font = FONT_MAIN
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 32

FloatBtn.MouseButton1Click:Connect(function()
	if not loggedIn then return end
	MainFrame.Visible = not MainFrame.Visible
	if MainFrame.Visible then
		MainFrame.Position = UDim2.new(0, FloatBtn.AbsolutePosition.X + 64, 0, FloatBtn.AbsolutePosition.Y)
	end
end)

-- ==========================================================================
-- SISTEMA DE ABAS 8-BIT (4 ABAS)
-- ==========================================================================
local TabHeader = Instance.new("Frame", MainFrame)
TabHeader.Size = UDim2.new(1, -20, 0, 36)
TabHeader.Position = UDim2.new(0, 10, 0, 48)
TabHeader.BackgroundColor3 = COLOR_PANEL
TabHeader.BorderSizePixel = 0
TabHeader.ZIndex = 31
apply8BitStroke(TabHeader, Color3.fromRGB(40, 45, 60), 1)

local function createTabBtn(name, posX, active)
	local btn = Instance.new("TextButton", TabHeader)
	btn.Size = UDim2.new(0.24, 0, 0.78, 0)
	btn.Position = UDim2.new(posX, 0, 0.11, 0)
	btn.BackgroundColor3 = active and COLOR_ACCENT or COLOR_ITEM
	btn.BorderSizePixel = 0
	btn.TextColor3 = active and COLOR_BG or COLOR_SUBTEXT
	btn.TextSize = 12
	btn.Font = FONT_MAIN
	btn.Text = name
	btn.ZIndex = 32
	apply8BitStroke(btn, Color3.fromRGB(55, 60, 80), 1)
	return btn
end

local btnVisual = createTabBtn("VISUAL", 0.01, true)
local btnMove = createTabBtn("MOVIM", 0.26, false)
local btnBoss = createTabBtn("COMBATE", 0.51, false)
local btnChannel = createTabBtn("CANAL", 0.75, false)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -20, 1, -102)
ContentContainer.Position = UDim2.new(0, 10, 0, 94)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 31

local function createScroll()
	local scroll = Instance.new("ScrollingFrame", ContentContainer)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = COLOR_ACCENT
	scroll.Visible = false
	scroll.ZIndex = 31
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
		t.btn.BackgroundColor3 = isSel and COLOR_ACCENT or COLOR_ITEM
		t.btn.TextColor3 = isSel and COLOR_BG or COLOR_SUBTEXT
	end
end

btnVisual.MouseButton1Click:Connect(function() selectTab(panelVisual) end)
btnMove.MouseButton1Click:Connect(function() selectTab(panelMove) end)
btnBoss.MouseButton1Click:Connect(function() selectTab(panelBoss) end)
btnChannel.MouseButton1Click:Connect(function() selectTab(panelChannel) end)

-- ==========================================================================
-- COMPONENTES 8-BIT (TOGGLE E SLIDER SEM NEGRITO)
-- ==========================================================================
local function createToggle(parent, name, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundColor3 = COLOR_PANEL
	row.BorderSizePixel = 0
	row.ZIndex = 31
	local rowStroke = apply8BitStroke(row, Color3.fromRGB(40, 45, 60), 1)
	
	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.68, 0, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = "> " .. name
	label.TextColor3 = COLOR_TEXT
	label.TextSize = 12
	label.Font = FONT_MAIN
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 32
	
	local statusBtn = Instance.new("TextButton", row)
	statusBtn.Size = UDim2.new(0, 72, 0, 26)
	statusBtn.Position = UDim2.new(1, -80, 0.5, -13)
	statusBtn.BackgroundColor3 = COLOR_ITEM
	statusBtn.BorderSizePixel = 0
	statusBtn.Text = "[ OFF ]"
	statusBtn.TextColor3 = COLOR_OFF
	statusBtn.TextSize = 11
	statusBtn.Font = FONT_MAIN
	statusBtn.ZIndex = 32
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
			rowStroke.Color = Color3.fromRGB(40, 45, 60)
		end
		callback(state)
	end)
end

local function createSlider(parent, name, min, max, default, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 56)
	row.BackgroundColor3 = COLOR_PANEL
	row.BorderSizePixel = 0
	row.ZIndex = 31
	apply8BitStroke(row, Color3.fromRGB(40, 45, 60), 1)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.7, 0, 0, 22)
	label.Position = UDim2.new(0, 10, 0, 6)
	label.BackgroundTransparency = 1
	label.Text = "> " .. name
	label.TextColor3 = COLOR_TEXT
	label.TextSize = 12
	label.Font = FONT_MAIN
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 32

	local valLabel = Instance.new("TextLabel", row)
	valLabel.Size = UDim2.new(0.25, 0, 0, 22)
	valLabel.Position = UDim2.new(0.75, -10, 0, 6)
	valLabel.BackgroundTransparency = 1
	valLabel.Text = "[" .. tostring(default) .. "]"
	valLabel.TextColor3 = COLOR_ACCENT
	valLabel.TextSize = 12
	valLabel.Font = FONT_MAIN
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	valLabel.ZIndex = 32

	local sliderBg = Instance.new("Frame", row)
	sliderBg.Size = UDim2.new(1, -20, 0, 10)
	sliderBg.Position = UDim2.new(0, 10, 0, 36)
	sliderBg.BackgroundColor3 = COLOR_BG
	sliderBg.BorderSizePixel = 0
	sliderBg.ZIndex = 32
	apply8BitStroke(sliderBg, Color3.fromRGB(55, 60, 80), 1)

	local sliderFill = Instance.new("Frame", sliderBg)
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = COLOR_ACCENT
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 33

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
-- ABA CANAL, PERFIL & ESTATÍSTICAS (VISUAL 8-BIT)
-- ==========================================================================
local ChannelCard = Instance.new("Frame", panelChannel)
ChannelCard.Size = UDim2.new(1, 0, 0, 290)
ChannelCard.BackgroundColor3 = COLOR_PANEL
ChannelCard.BorderSizePixel = 0
ChannelCard.ZIndex = 31
apply8BitStroke(ChannelCard, COLOR_ACCENT, 1)

local CardTitle = Instance.new("TextLabel", ChannelCard)
CardTitle.Size = UDim2.new(1, 0, 0, 30)
CardTitle.Position = UDim2.new(0, 0, 0, 8)
CardTitle.BackgroundTransparency = 1
CardTitle.Text = ":: PERFIL & SISTEMA ::"
CardTitle.TextColor3 = COLOR_ACCENT
CardTitle.TextSize = 13
CardTitle.Font = FONT_MAIN
CardTitle.ZIndex = 32

local ProfileBox = Instance.new("Frame", ChannelCard)
ProfileBox.Size = UDim2.new(0.92, 0, 0, 74)
ProfileBox.Position = UDim2.new(0.04, 0, 0, 42)
ProfileBox.BackgroundColor3 = COLOR_BG
ProfileBox.BorderSizePixel = 0
ProfileBox.ZIndex = 32
apply8BitStroke(ProfileBox, Color3.fromRGB(45, 50, 68), 1)

local ProfileLabel = Instance.new("TextLabel", ProfileBox)
ProfileLabel.Size = UDim2.new(1, -16, 1, 0)
ProfileLabel.Position = UDim2.new(0, 8, 0, 0)
ProfileLabel.BackgroundTransparency = 1
ProfileLabel.Text = string.format("Usuario : %s\nUser ID : %d\nConta   : %d dias", userName, userId, LocalPlayer.AccountAge)
ProfileLabel.TextColor3 = COLOR_TEXT
ProfileLabel.TextSize = 12
ProfileLabel.Font = FONT_MAIN
ProfileLabel.TextXAlignment = Enum.TextXAlignment.Left
ProfileLabel.ZIndex = 33

local CopyChannelBtn = Instance.new("TextButton", ChannelCard)
CopyChannelBtn.Size = UDim2.new(0.92, 0, 0, 36)
CopyChannelBtn.Position = UDim2.new(0.04, 0, 0, 128)
CopyChannelBtn.BackgroundColor3 = COLOR_ACCENT
CopyChannelBtn.BorderSizePixel = 0
CopyChannelBtn.Text = "[ COPIAR LINK DO CANAL ]"
CopyChannelBtn.TextColor3 = COLOR_BG
CopyChannelBtn.TextSize = 12
CopyChannelBtn.Font = FONT_MAIN
CopyChannelBtn.ZIndex = 32
apply8BitStroke(CopyChannelBtn, Color3.fromRGB(255, 180, 80), 1)

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
StatsBox.Position = UDim2.new(0.04, 0, 0, 176)
StatsBox.BackgroundColor3 = COLOR_BG
StatsBox.BorderSizePixel = 0
StatsBox.ZIndex = 32
apply8BitStroke(StatsBox, Color3.fromRGB(45, 50, 68), 1)

local StatsLabel = Instance.new("TextLabel", StatsBox)
StatsLabel.Size = UDim2.new(1, 0, 1, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Online Agora: Conectando..."
StatsLabel.TextColor3 = COLOR_ON
StatsLabel.TextSize = 12
StatsLabel.Font = FONT_MAIN
StatsLabel.ZIndex = 33

statsLabelReference = StatsLabel

local ClearCacheBtn = Instance.new("TextButton", ChannelCard)
ClearCacheBtn.Size = UDim2.new(0.92, 0, 0, 36)
ClearCacheBtn.Position = UDim2.new(0.04, 0, 0, 222)
ClearCacheBtn.BackgroundColor3 = COLOR_ITEM
ClearCacheBtn.BorderSizePixel = 0
ClearCacheBtn.Text = "[ LIMPAR CACHE & OTIMIZAR ]"
ClearCacheBtn.TextColor3 = COLOR_TEXT
ClearCacheBtn.TextSize = 12
ClearCacheBtn.Font = FONT_MAIN
ClearCacheBtn.ZIndex = 32
apply8BitStroke(ClearCacheBtn, COLOR_ACCENT, 1)

ClearCacheBtn.MouseButton1Click:Connect(function()
	pcall(function()
		EspCanvas:ClearAllChildren()
		for _, v in ipairs(workspace:GetDescendants()) do
			if v.Name == "FreeHighlight" or v.Name == "FreeNameTag" or v.Name == "SurrealAuraParticles" then
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
-- DETECÇÃO OTIMIZADA DE ZUMBIS / INIMIGOS
-- ==========================================================================
local cachedZombies = {}

task.spawn(function()
	while task.wait(0.4) do
		local list = {}
		pcall(function()
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and obj ~= LocalPlayer.Character then
					local hum = obj:FindFirstChildOfClass("Humanoid")
					local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
					if root and hum and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
						table.insert(list, obj)
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
-- ABA VISUAL: ESP BOX 2D, ESP LINE, ESP CHAMS, ESP NAME/HP & AURA 8-BIT
-- ==========================================================================
_G.Free_ESP_Box2D = false
_G.Free_ESP_Line = false
_G.Free_ESP_Highlight = false
_G.Free_ESP_Name = false
_G.SurrealFloor_On = false

createToggle(panelVisual, "ESP Box 2D (Caixa 8-Bit)", function(enabled)
	_G.Free_ESP_Box2D = enabled
	if not enabled then
		for _, child in ipairs(EspCanvas:GetChildren()) do
			if string.sub(child.Name, 1, 4) == "Box_" then child:Destroy() end
		end
	end
end)

createToggle(panelVisual, "ESP Line (Linha Tracante)", function(enabled)
	_G.Free_ESP_Line = enabled
	if not enabled then
		for _, child in ipairs(EspCanvas:GetChildren()) do
			if string.sub(child.Name, 1, 5) == "Line_" then child:Destroy() end
		end
	end
end)

-- Renderizador em Tempo Real (60+ FPS) para ESP Box 2D e ESP Line
RunService.RenderStepped:Connect(function()
	if not _G.Free_ESP_Box2D and not _G.Free_ESP_Line then
		if #EspCanvas:GetChildren() > 0 then
			EspCanvas:ClearAllChildren()
		end
		return
	end

	EspCanvas:ClearAllChildren()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local viewportSize = cam.ViewportSize
	local originBottom = Vector2.new(viewportSize.X / 2, viewportSize.Y - 10)

	for idx, enemy in ipairs(getZombies()) do
		local root = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Head")
		local hum = enemy:FindFirstChildOfClass("Humanoid")
		if root and hum and hum.Health > 0 then
			local rootPos, onScreen = cam:WorldToViewportPoint(root.Position)
			if onScreen and rootPos.Z > 0 then
				-- Renderização ESP BOX 2D (8-Bit)
				if _G.Free_ESP_Box2D then
					local topPos = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
					local bottomPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.6, 0))
					local boxHeight = math.clamp(math.abs(bottomPos.Y - topPos.Y), 12, viewportSize.Y)
					local boxWidth = math.clamp(boxHeight * 0.62, 8, viewportSize.X)

					local boxFrame = Instance.new("Frame", EspCanvas)
					boxFrame.Name = "Box_" .. tostring(idx)
					boxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
					boxFrame.Position = UDim2.fromOffset(rootPos.X, rootPos.Y)
					boxFrame.Size = UDim2.fromOffset(boxWidth, boxHeight)
					boxFrame.BackgroundTransparency = 1
					boxFrame.BorderSizePixel = 0
					boxFrame.ZIndex = 5
					apply8BitStroke(boxFrame, COLOR_ACCENT, 1.5)
				end

				-- Renderização ESP LINE (Tracer 8-Bit)
				if _G.Free_ESP_Line then
					local targetPt = Vector2.new(rootPos.X, rootPos.Y)
					local delta = targetPt - originBottom
					local dist = delta.Magnitude
					local center = (originBottom + targetPt) / 2
					local angle = math.deg(math.atan2(delta.Y, delta.X))

					local lineFrame = Instance.new("Frame", EspCanvas)
					lineFrame.Name = "Line_" .. tostring(idx)
					lineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
					lineFrame.Position = UDim2.fromOffset(center.X, center.Y)
					lineFrame.Size = UDim2.fromOffset(dist, 1.5)
					lineFrame.Rotation = angle
					lineFrame.BackgroundColor3 = COLOR_ACCENT
					lineFrame.BorderSizePixel = 0
					lineFrame.ZIndex = 4
				end
			end
		end
	end
end)

createToggle(panelVisual, "ESP Chams (Highlight)", function(enabled)
	_G.Free_ESP_Highlight = enabled
	task.spawn(function()
		while _G.Free_ESP_Highlight do
			pcall(function()
				for _, enemy in ipairs(getZombies()) do
					if not enemy:FindFirstChild("FreeHighlight") then
						local hl = Instance.new("Highlight", enemy)
						hl.Name = "FreeHighlight"
						hl.FillTransparency = 0.65
						hl.FillColor = COLOR_ACCENT
						hl.OutlineColor = COLOR_TEXT
					end
				end
			end)
			task.wait(0.8)
		end
		pcall(function()
			for _, v in ipairs(workspace:GetDescendants()) do
				if v.Name == "FreeHighlight" then v:Destroy() end
			end
		end)
	end)
end)

createToggle(panelVisual, "ESP Name & Barra HP (8-Bit)", function(enabled)
	_G.Free_ESP_Name = enabled
	task.spawn(function()
		while _G.Free_ESP_Name do
			pcall(function()
				for _, enemy in ipairs(getZombies()) do
					local head = enemy:FindFirstChild("Head") or enemy:FindFirstChild("HumanoidRootPart")
					local hum = enemy:FindFirstChildOfClass("Humanoid")
					if head and hum then
						local bg = head:FindFirstChild("FreeNameTag")
						if not bg then
							bg = Instance.new("BillboardGui", head)
							bg.Name = "FreeNameTag"
							bg.Size = UDim2.new(0, 120, 0, 34)
							bg.StudsOffset = Vector3.new(0, 2.8, 0)
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
							apply8BitStroke(barBg, Color3.fromRGB(45, 50, 68), 1)

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
end)

createToggle(panelVisual, "Aura 8-Bit (Pixels nos Pes)", function(enabled)
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
					aura.Color = ColorSequence.new(COLOR_ACCENT)
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
end)

-- ==========================================================================
-- ABA MOVIMENTO ATUALIZADA (SPEED CONFIGURÁVEL, NOCLIP & FLY PC/MOBILE)
-- ==========================================================================
_G.Free_Speed = false
_G.Free_SpeedVal = 48
_G.Free_Noclip = false

createToggle(panelMove, "Speed Hack (Velocidade)", function(enabled)
	_G.Free_Speed = enabled
	if not enabled then
		pcall(function()
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = 16 end
		end)
	end
end)

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
end)

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

createToggle(panelMove, "Fly 8-Bit (Voo PC & Mobile)", function(enabled)
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
		bg.CFrame = Camera.CFrame
		
		flyConn = RunService.RenderStepped:Connect(function()
			pcall(function()
				local cam = workspace.CurrentCamera
				local move = Vector3.zero
				local spd = _G.Free_FlySpeed

				-- Suporte ao Analógico Mobile + Teclado PC
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
end)

createSlider(panelMove, "Velocidade do Fly", 20, 140, 55, function(val)
	_G.Free_FlySpeed = val
end)

-- ==========================================================================
-- ABA COMBATE ATUALIZADA: AIMBOT MULTI-ALVO + FOV 8-BIT
-- ==========================================================================
_G.Free_AimLock = false
_G.Free_AimSmooth = 6
_G.Free_AimFOV = 140
_G.Free_ShowFOV = false
_G.Free_AimPart = "Head"

local FovFrame = Instance.new("Frame", ScreenGui)
FovFrame.Name = "Fov8Bit"
FovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FovFrame.Size = UDim2.fromOffset(_G.Free_AimFOV * 2, _G.Free_AimFOV * 2)
FovFrame.BackgroundTransparency = 1
FovFrame.Visible = false
FovFrame.ZIndex = 10
apply8BitStroke(FovFrame, COLOR_ACCENT, 1.2)

createToggle(panelBoss, "Aimbot Multi-Alvo (Ativo)", function(enabled)
	_G.Free_AimLock = enabled
end)

createToggle(panelBoss, "Mostrar Area FOV (Mira 8-Bit)", function(enabled)
	_G.Free_ShowFOV = enabled
	FovFrame.Visible = enabled
end)

createSlider(panelBoss, "Suavidade do Aimbot", 1, 10, 6, function(val)
	_G.Free_AimSmooth = val
end)

createSlider(panelBoss, "Tamanho da Area FOV", 40, 260, 140, function(val)
	_G.Free_AimFOV = val
	FovFrame.Size = UDim2.fromOffset(val * 2, val * 2)
end)

RunService.RenderStepped:Connect(function()
	if not _G.Free_AimLock then return end
	pcall(function()
		local cam = workspace.CurrentCamera
		local centerScreen = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
		local closestTarget = nil
		local shortestScreenDist = _G.Free_AimFOV

		for _, enemy in ipairs(getZombies()) do
			local hum = enemy:FindFirstChildOfClass("Humanoid")
			local targetPart = enemy:FindFirstChild(_G.Free_AimPart) or enemy:FindFirstChild("Head") or enemy:FindFirstChild("HumanoidRootPart")
			if hum and hum.Health > 0 and targetPart then
				local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
				if onScreen and screenPos.Z > 0 then
					local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
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
AimPartRow.BorderSizePixel = 0
AimPartRow.ZIndex = 31
apply8BitStroke(AimPartRow, Color3.fromRGB(40, 45, 60), 1)

local AimPartLabel = Instance.new("TextLabel", AimPartRow)
AimPartLabel.Size = UDim2.new(0.55, 0, 1, 0)
AimPartLabel.Position = UDim2.new(0, 10, 0, 0)
AimPartLabel.BackgroundTransparency = 1
AimPartLabel.Text = "> Alvo: Cabeca"
AimPartLabel.TextColor3 = COLOR_TEXT
AimPartLabel.TextSize = 12
AimPartLabel.Font = FONT_MAIN
AimPartLabel.TextXAlignment = Enum.TextXAlignment.Left
AimPartLabel.ZIndex = 32

local partsList = {"Head", "UpperTorso", "HumanoidRootPart", "RightFoot"}
local partsNames = {"Cabeca", "Quadril", "Barra", "Pe"}
local currentPartIndex = 1

local ChangePartBtn = Instance.new("TextButton", AimPartRow)
ChangePartBtn.Size = UDim2.new(0, 110, 0, 26)
ChangePartBtn.Position = UDim2.new(1, -118, 0.5, -13)
ChangePartBtn.BackgroundColor3 = COLOR_ACCENT
ChangePartBtn.BorderSizePixel = 0
ChangePartBtn.Text = "[ MUDAR ALVO ]"
ChangePartBtn.TextColor3 = COLOR_BG
ChangePartBtn.TextSize = 11
ChangePartBtn.Font = FONT_MAIN
ChangePartBtn.ZIndex = 32
apply8BitStroke(ChangePartBtn, Color3.fromRGB(255, 180, 80), 1)

ChangePartBtn.MouseButton1Click:Connect(function()
	currentPartIndex = currentPartIndex + 1
	if currentPartIndex > #partsList then
		currentPartIndex = 1
	end
	_G.Free_AimPart = partsList[currentPartIndex]
	AimPartLabel.Text = "> Alvo: " .. partsNames[currentPartIndex]
end)

print("[DARK HACKER " .. SCRIPT_VERSION .. "] Carregado com Sucesso! | Creditos: DarkGamingYT")
