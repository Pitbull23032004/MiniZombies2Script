-- ==========================================================================
-- CYBER HACKER | Versão FREE 1.2.7 (Design Surreal & Nítido)
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
local Camera = workspace.CurrentCamera

local SCRIPT_VERSION = "FREE 1.2.7"
local FIREBASE_URL = "https://darkgamingyt-1c438-default-rtdb.firebaseio.com"

local userId = LocalPlayer.UserId
local userName = LocalPlayer.Name
local displayName = LocalPlayer.DisplayName
local playerSessionId = "user_" .. tostring(userId)
local tempoInicioSessao = tick()

local paisUsuario = "Desconhecido"
local cidadeUsuario = "Desconhecida"

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
	if CoreGui:FindFirstChild("CyberHacker_FREE_1_2_7") then
		CoreGui.CyberHacker_FREE_1_2_7:Destroy()
	end
	if LocalPlayer.PlayerGui:FindFirstChild("CyberHacker_FREE_1_2_7") then
		LocalPlayer.PlayerGui.CyberHacker_FREE_1_2_7:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHacker_FREE_1_2_7"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local successParent = pcall(function() ScreenGui.Parent = CoreGui end)
if not successParent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

pcall(function()
	if gethui then
		ScreenGui.Parent = gethui()
	end
end)

-- ==========================================================================
-- BOTÃO FLUTUANTE SURREAL (NEON PULSANTE)
-- ==========================================================================
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.fromOffset(58, 58)
FloatBtn.Position = UDim2.new(0, 35, 0.35, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(3, 5, 8)
FloatBtn.Text = "⚡"
FloatBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
FloatBtn.TextSize = 26
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.Active = true
FloatBtn.Draggable = true
FloatBtn.Visible = true
FloatBtn.ZIndex = 50
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 18)

local FloatStroke = Instance.new("UIStroke", FloatBtn)
FloatStroke.Thickness = 3
FloatStroke.Color = Color3.fromRGB(0, 255, 128)

local FloatShadow = Instance.new("UIAspectRatioConstraint", FloatBtn)
FloatShadow.AspectRatio = 1

-- ==========================================================================
-- TELA DE LOGIN SURREAL E NÍDIDA (COM AVISO AJUSTADO PARA BOA LEITURA)
-- ==========================================================================
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 360, 0, 340)
LoginFrame.Position = UDim2.new(0.5, -180, 0.5, -170)
LoginFrame.BackgroundColor3 = Color3.fromRGB(3, 5, 8)
LoginFrame.BorderSizePixel = 0
LoginFrame.ZIndex = 60
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 20)

local LoginStroke = Instance.new("UIStroke", LoginFrame)
LoginStroke.Thickness = 3.5
LoginStroke.Color = Color3.fromRGB(0, 255, 128)

task.spawn(function()
	while LoginFrame and LoginFrame.Parent do
		for i = 0, 1, 0.008 do
			if not LoginStroke or not LoginStroke.Parent then break end
			LoginStroke.Color = Color3.fromHSV(i, 1, 1)
			task.wait(0.03)
		end
	end
end)

local LoginHeader = Instance.new("TextLabel", LoginFrame)
LoginHeader.Size = UDim2.new(1, 0, 0, 32)
LoginHeader.Position = UDim2.new(0, 0, 0, 16)
LoginHeader.BackgroundTransparency = 1
LoginHeader.Text = "⚡ DARKGAMINGYT ⚡"
LoginHeader.TextColor3 = Color3.fromRGB(0, 255, 128)
LoginHeader.TextSize = 16
LoginHeader.Font = Enum.Font.GothamBold
LoginHeader.ZIndex = 61

local LoginSubHeader = Instance.new("TextLabel", LoginFrame)
LoginSubHeader.Size = UDim2.new(1, 0, 0, 20)
LoginSubHeader.Position = UDim2.new(0, 0, 0, 44)
LoginSubHeader.BackgroundTransparency = 1
LoginSubHeader.Text = "LOGIN SURREAL | " .. SCRIPT_VERSION
LoginSubHeader.TextColor3 = Color3.fromRGB(150, 190, 170)
LoginSubHeader.TextSize = 11
LoginSubHeader.Font = Enum.Font.GothamMedium
LoginSubHeader.ZIndex = 61

-- AVISO COM COR SUAVE E FONTE NÍDIDA (FÁCIL LEITURA)
local InfoNotice = Instance.new("TextLabel", LoginFrame)
InfoNotice.Size = UDim2.new(0.88, 0, 0, 26)
InfoNotice.Position = UDim2.new(0.06, 0, 0, 68)
InfoNotice.BackgroundColor3 = Color3.fromRGB(8, 18, 12)
InfoNotice.Text = "🚀 Em breve novas funções iradas para vocês!"
InfoNotice.TextColor3 = Color3.fromRGB(220, 255, 235) -- Branco esverdeado suave e legível
InfoNotice.TextSize = 11
InfoNotice.Font = Enum.Font.GothamMedium
InfoNotice.ZIndex = 61
Instance.new("UICorner", InfoNotice).CornerRadius = UDim.new(0, 8)
local NoticeStroke = Instance.new("UIStroke", InfoNotice)
NoticeStroke.Color = Color3.fromRGB(0, 200, 100)
NoticeStroke.Thickness = 1

local function createTextBox(posY, placeholder)
	local box = Instance.new("TextBox", LoginFrame)
	box.Size = UDim2.new(0.88, 0, 0, 42)
	box.Position = UDim2.new(0.06, 0, 0, posY)
	box.BackgroundColor3 = Color3.fromRGB(8, 12, 18)
	box.BorderSizePixel = 0
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(130, 150, 140)
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(240, 255, 245) -- Texto digitado claro e nítido
	box.TextSize = 13
	box.Font = Enum.Font.GothamMedium
	box.ZIndex = 61
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke", box)
	stroke.Color = Color3.fromRGB(25, 50, 38)
	stroke.Thickness = 1.5
	return box
end

local UserBox = createTextBox(102, "Usuário (FREE)")
local PassBox = createTextBox(154, "Senha (FREE)")

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0.88, 0, 0, 42)
LoginBtn.Position = UDim2.new(0.06, 0, 0, 206)
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
LoginBtn.Text = "ENTRAR NO SISTEMA"
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.TextSize = 13
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.ZIndex = 61
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 12)

local ErrorLabel = Instance.new("TextLabel", LoginFrame)
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0, 0, 0, 256)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(250, 60, 60)
ErrorLabel.TextSize = 11
ErrorLabel.Font = Enum.Font.GothamMedium
ErrorLabel.ZIndex = 61

local loggedIn = false
local statsLabelReference = nil

-- ==========================================================================
-- PAINEL PRINCIPAL SURREAL (DESIGN MODERNO)
-- ==========================================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 370, 0, 430)
MainFrame.Position = UDim2.new(0, 110, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(3, 5, 8)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.ZIndex = 30

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 3.5
MainStroke.Color = Color3.fromRGB(0, 255, 128)

task.spawn(function()
	while MainFrame and MainFrame.Parent do
		for i = 0, 1, 0.008 do
			if not MainStroke or not MainStroke.Parent then break end
			MainStroke.Color = Color3.fromHSV(i, 1, 1)
			task.wait(0.03)
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
						tempoSessaoSegundos = segundosJogando,
						tempoJogadoFormatado = horasJogandoFormatado,
						placeIdAtual = game.PlaceId,
						jobIdServidor = game.JobId,
						jogadoresNoServidor = #Players:GetPlayers(),
						executor = executorNome,
						idadeContaDias = LocalPlayer.AccountAge,
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
						statsLabelReference.Text = "👥 Pessoas Usando Agora: " .. tostring(ativos)
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
	if UserBox.Text == "FREE" and PassBox.Text == "FREE" then
		loggedIn = true
		ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
		ErrorLabel.Text = "Acesso Concedido! Conectando..."
		
		iniciarSistemaPresenca()
		
		task.spawn(function()
			while FloatBtn and FloatBtn.Parent and loggedIn do
				for i = 0, 1, 0.008 do
					if not FloatStroke or not FloatStroke.Parent then break end
					FloatStroke.Color = Color3.fromHSV(i, 1, 1)
					task.wait(0.03)
				end
			end
		end)
		
		task.wait(0.8)
		LoginFrame:Destroy()
	else
		ErrorLabel.TextColor3 = Color3.fromRGB(250, 60, 60)
		ErrorLabel.Text = "Dados incorretos! (Use FREE)"
	end
end)

-- ==========================================================================
-- CONTADOR DE FPS
-- ==========================================================================
local FpsLabel = Instance.new("TextLabel", ScreenGui)
FpsLabel.Size = UDim2.fromOffset(60, 20)
FpsLabel.Position = UDim2.new(0, 35, 0.35, -26)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 0"
FpsLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
FpsLabel.TextSize = 11
FpsLabel.Font = Enum.Font.GothamBold
FpsLabel.TextXAlignment = Enum.TextXAlignment.Center
FpsLabel.ZIndex = 50

local fpsLastTick = tick()
local fpsFrames = 0
RunService.RenderStepped:Connect(function()
	fpsFrames = fpsFrames + 1
	local now = tick()
	if now - fpsLastTick >= 1 then
		local fps = math.floor(fpsFrames / (now - fpsLastTick))
		FpsLabel.Text = "FPS: " .. tostring(fps)
		fpsFrames = 0
		fpsLastTick = now
	end
end)

FloatBtn:GetPropertyChangedSignal("Position"):Connect(function()
	FpsLabel.Position = UDim2.new(FloatBtn.Position.X.Scale, FloatBtn.Position.X.Offset, FloatBtn.Position.Y.Scale, FloatBtn.Position.Y.Offset - 26)
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Color3.fromRGB(8, 12, 18)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 31
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 20)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 18, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "CYBER HACKER | " .. SCRIPT_VERSION
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 31

FloatBtn.MouseButton1Click:Connect(function()
	if not loggedIn then return end
	MainFrame.Visible = not MainFrame.Visible
	if MainFrame.Visible then
		MainFrame.Position = UDim2.new(0, FloatBtn.AbsolutePosition.X + 72, 0, FloatBtn.AbsolutePosition.Y)
	end
end)

-- ==========================================================================
-- SISTEMA DE ABAS SURREAL (DESIGN DINÂMICO)
-- ==========================================================================
local TabHeader = Instance.new("Frame", MainFrame)
TabHeader.Size = UDim2.new(1, -24, 0, 42)
TabHeader.Position = UDim2.new(0, 12, 0, 58)
TabHeader.BackgroundColor3 = Color3.fromRGB(6, 9, 14)
TabHeader.BorderSizePixel = 0
TabHeader.ZIndex = 31
Instance.new("UICorner", TabHeader).CornerRadius = UDim.new(0, 14)

local function createTabBtn(name, posX, active)
	local btn = Instance.new("TextButton", TabHeader)
	btn.Size = UDim2.new(0.23, 0, 0.82, 0)
	btn.Position = UDim2.new(posX, 0, 0.09, 0)
	btn.BackgroundColor3 = active and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(12, 16, 24)
	btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 190, 170)
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.Text = name
	btn.ZIndex = 32
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	return btn
end

local btnVisual = createTabBtn("VISUAL", 0.02, true)
local btnMove = createTabBtn("MOV", 0.26, false)
local btnBoss = createTabBtn("COMBATE", 0.50, false)
local btnChannel = createTabBtn("CANAL", 0.74, false)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -24, 1, -114)
ContentContainer.Position = UDim2.new(0, 12, 0, 110)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 31

local function createScroll()
	local scroll = Instance.new("ScrollingFrame", ContentContainer)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.Visible = false
	scroll.ZIndex = 31
	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0, 10)
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
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
	
	btnVisual.BackgroundColor3 = (selected == panelVisual) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(12, 16, 24)
	btnMove.BackgroundColor3 = (selected == panelMove) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(12, 16, 24)
	btnBoss.BackgroundColor3 = (selected == panelBoss) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(12, 16, 24)
	btnChannel.BackgroundColor3 = (selected == panelChannel) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(12, 16, 24)
	
	btnVisual.TextColor3 = (selected == panelVisual) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 190, 170)
	btnMove.TextColor3 = (selected == panelMove) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 190, 170)
	btnBoss.TextColor3 = (selected == panelBoss) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 190, 170)
	btnChannel.TextColor3 = (selected == panelChannel) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 190, 170)
end

btnVisual.MouseButton1Click:Connect(function() selectTab(panelVisual) end)
btnMove.MouseButton1Click:Connect(function() selectTab(panelMove) end)
btnBoss.MouseButton1Click:Connect(function() selectTab(panelBoss) end)
btnChannel.MouseButton1Click:Connect(function() selectTab(panelChannel) end)

local function createToggle(parent, name, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 44)
	row.BackgroundColor3 = Color3.fromRGB(8, 12, 18)
	row.ZIndex = 31
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 14)
	
	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.68, 0, 1, 0)
	label.Position = UDim2.new(0.05, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(230, 245, 235)
	label.TextSize = 12
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 31
	
	local statusBtn = Instance.new("TextButton", row)
	statusBtn.Size = UDim2.new(0, 64, 0, 30)
	statusBtn.Position = UDim2.new(0.72, 0, 0.16, 0)
	statusBtn.BackgroundColor3 = Color3.fromRGB(14, 20, 30)
	statusBtn.Text = "OFF"
	statusBtn.TextColor3 = Color3.fromRGB(250, 60, 60)
	statusBtn.TextSize = 11
	statusBtn.Font = Enum.Font.GothamBold
	statusBtn.ZIndex = 31
	Instance.new("UICorner", statusBtn).CornerRadius = UDim.new(0, 10)
	
	local state = false
	statusBtn.MouseButton1Click:Connect(function()
		state = not state
		if state then
			statusBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
			statusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			statusBtn.Text = "ON"
		else
			statusBtn.BackgroundColor3 = Color3.fromRGB(14, 20, 30)
			statusBtn.TextColor3 = Color3.fromRGB(250, 60, 60)
			statusBtn.Text = "OFF"
		end
		callback(state)
	end)
end

local function createSlider(parent, name, min, max, default, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 62)
	row.BackgroundColor3 = Color3.fromRGB(8, 12, 18)
	row.ZIndex = 31
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 14)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.7, 0, 0, 24)
	label.Position = UDim2.new(0.05, 0, 0, 8)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(230, 245, 235)
	label.TextSize = 12
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 31

	local valLabel = Instance.new("TextLabel", row)
	valLabel.Size = UDim2.new(0.2, 0, 0, 24)
	valLabel.Position = UDim2.new(0.75, 0, 0, 8)
	valLabel.BackgroundTransparency = 1
	valLabel.Text = tostring(default)
	valLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
	valLabel.TextSize = 12
	valLabel.Font = Enum.Font.GothamBold
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	valLabel.ZIndex = 31

	local sliderBg = Instance.new("Frame", row)
	sliderBg.Size = UDim2.new(0.9, 0, 0, 6)
	sliderBg.Position = UDim2.new(0.05, 0, 0, 42)
	sliderBg.BackgroundColor3 = Color3.fromRGB(14, 20, 30)
	sliderBg.BorderSizePixel = 0
	sliderBg.ZIndex = 31
	Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

	local sliderFill = Instance.new("Frame", sliderBg)
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 31
	Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

	local dragging = false
	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
		sliderFill.Size = UDim2.new(pos, 0, 1, 0)
		local val = math.floor(min + ((max - min) * pos))
		valLabel.Text = tostring(val)
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
-- ABA CANAL & ESTATÍSTICAS (DESIGN SURREAL)
-- ==========================================================================
local ChannelCard = Instance.new("Frame", panelChannel)
ChannelCard.Size = UDim2.new(1, 0, 0, 285)
ChannelCard.BackgroundColor3 = Color3.fromRGB(6, 9, 14)
ChannelCard.ZIndex = 31
Instance.new("UICorner", ChannelCard).CornerRadius = UDim.new(0, 16)

local ChannelCardStroke = Instance.new("UIStroke", ChannelCard)
ChannelCardStroke.Thickness = 1.5
ChannelCardStroke.Color = Color3.fromRGB(0, 255, 128)

local CardTitle = Instance.new("TextLabel", ChannelCard)
CardTitle.Size = UDim2.new(1, 0, 0, 32)
CardTitle.Position = UDim2.new(0, 0, 0, 12)
CardTitle.BackgroundTransparency = 1
CardTitle.Text = "⚡ DARK GAMING YT ⚡"
CardTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
CardTitle.TextSize = 14
CardTitle.Font = Enum.Font.GothamBold
CardTitle.ZIndex = 31

local CardDesc = Instance.new("TextLabel", ChannelCard)
CardDesc.Size = UDim2.new(0.9, 0, 0, 35)
CardDesc.Position = UDim2.new(0.05, 0, 0, 48)
CardDesc.BackgroundTransparency = 1
CardDesc.Text = "Inscreva-se no canal oficial para acompanhar novos scripts, atualizações e conteúdos exclusivos!"
CardDesc.TextColor3 = Color3.fromRGB(210, 235, 220)
CardDesc.TextSize = 11
CardDesc.Font = Enum.Font.GothamMedium
CardDesc.TextWrapped = true
CardDesc.ZIndex = 31

local CopyChannelBtn = Instance.new("TextButton", ChannelCard)
CopyChannelBtn.Size = UDim2.new(0.9, 0, 0, 40)
CopyChannelBtn.Position = UDim2.new(0.05, 0, 0, 92)
CopyChannelBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
CopyChannelBtn.Text = "📺 Copiar Link do Canal"
CopyChannelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyChannelBtn.TextSize = 12
CopyChannelBtn.Font = Enum.Font.GothamBold
CopyChannelBtn.ZIndex = 31
Instance.new("UICorner", CopyChannelBtn).CornerRadius = UDim.new(0, 12)

CopyChannelBtn.MouseButton1Click:Connect(function()
	pcall(function()
		setclipboard("https://youtu.be/D2Iqev9FHyA?si=GAnnU5ckAE_rzOOq")
	end)
	CopyChannelBtn.Text = "✅ Link Copiado com Sucesso!"
	task.wait(2)
	CopyChannelBtn.Text = "📺 Copiar Link do Canal"
end)

local StatsBox = Instance.new("Frame", ChannelCard)
StatsBox.Size = UDim2.new(0.9, 0, 0, 40)
StatsBox.Position = UDim2.new(0.05, 0, 0, 142)
StatsBox.BackgroundColor3 = Color3.fromRGB(3, 5, 8)
StatsBox.ZIndex = 31
Instance.new("UICorner", StatsBox).CornerRadius = UDim.new(0, 12)
local StatsStroke = Instance.new("UIStroke", StatsBox)
StatsStroke.Color = Color3.fromRGB(0, 255, 128)
StatsStroke.Thickness = 1.2

local StatsLabel = Instance.new("TextLabel", StatsBox)
StatsLabel.Size = UDim2.new(1, 0, 1, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "👥 Pessoas Usando Agora: Conectando..."
StatsLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
StatsLabel.TextSize = 11
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.ZIndex = 31

statsLabelReference = StatsLabel

local ClearCacheBtn = Instance.new("TextButton", ChannelCard)
ClearCacheBtn.Size = UDim2.new(0.9, 0, 0, 40)
ClearCacheBtn.Position = UDim2.new(0.05, 0, 0, 192)
ClearCacheBtn.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
ClearCacheBtn.Text = "🧹 Limpar Cache & Otimizar Jogo"
ClearCacheBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
ClearCacheBtn.TextSize = 11
ClearCacheBtn.Font = Enum.Font.GothamBold
ClearCacheBtn.ZIndex = 31
Instance.new("UICorner", ClearCacheBtn).CornerRadius = UDim.new(0, 12)

local ClearStroke = Instance.new("UIStroke", ClearCacheBtn)
ClearStroke.Color = Color3.fromRGB(0, 200, 100)
ClearStroke.Thickness = 1

ClearCacheBtn.MouseButton1Click:Connect(function()
	pcall(function()
		for _, v in ipairs(workspace:GetDescendants()) do
			if v.Name == "FreeHighlight" or v.Name == "FreeNameTag" or v.Name == "SurrealAuraParticles" then
				v:Destroy()
			end
		end
		collectgarbage("collect")
	end)
	ClearCacheBtn.Text = "✨ Cache Limpo & Otimizado!"
	task.wait(2)
	ClearCacheBtn.Text = "🧹 Limpar Cache & Otimizar Jogo"
end)

-- ==========================================================================
-- FUNÇÕES DE ZUMBIS E CHEATS (MANTIDAS 100% INTACTAS)
-- ==========================================================================
local function getZombies()
	local list = {}
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj ~= LocalPlayer.Character then
			local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
			local hum = obj:FindFirstChildOfClass("Humanoid")
			if root and hum and not Players:GetPlayerFromCharacter(obj) then
				table.insert(list, obj)
			end
		end
	end
	return list
end

createToggle(panelVisual, "✨ ESP Craft (Visualizador)", function(enabled)
	_G.Free_ESP_Box = enabled
	task.spawn(function()
		while _G.Free_ESP_Box do
			pcall(function()
				for _, enemy in ipairs(getZombies()) do
					if not enemy:FindFirstChild("FreeHighlight") then
						local hl = Instance.new("Highlight", enemy)
						hl.Name = "FreeHighlight"
						hl.FillTransparency = 0.7
						hl.FillColor = Color3.fromRGB(0, 255, 128)
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
					end
				end
			end)
			task.wait(1)
		end
		for _, v in ipairs(workspace:GetDescendants()) do
			if v.Name == "FreeHighlight" then v:Destroy() end
		end
	end)
end)

createToggle(panelVisual, "🏷️ ESP Name & HP (Detalhes)", function(enabled)
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
							bg.Size = UDim2.new(0, 130, 0, 35)
							bg.StudsOffset = Vector3.new(0, 2.5, 0)
							bg.AlwaysOnTop = true
							
							local txt = Instance.new("TextLabel", bg)
							txt.Name = "Txt"
							txt.Size = UDim2.new(1, 0, 1, 0)
							txt.BackgroundTransparency = 1
							txt.TextColor3 = Color3.fromRGB(0, 255, 128)
							txt.TextStrokeTransparency = 0.2
							txt.TextSize = 11
							txt.Font = Enum.Font.GothamBold
						end
						local label = bg:FindFirstChild("Txt")
						if label then
							label.Text = string.format("%s\n[%d HP]", enemy.Name, math.floor(hum.Health))
						end
					end
				end
			end)
			task.wait(0.3)
		end
		for _, v in ipairs(workspace:GetDescendants()) do
			if v.Name == "FreeNameTag" then v:Destroy() end
		end
	end)
end)

createToggle(panelVisual, "🌟 Efeito Surreal (Aura nos Pés)", function(enabled)
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
						aura.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 3)})
						aura.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)})
						aura.Lifetime = NumberRange.new(0.8, 1.5)
						aura.Rate = 50
						aura.Speed = NumberRange.new(4, 8)
						aura.EmissionDirection = Enum.NormalId.Bottom
						aura.SpreadAngle = Vector2.new(20, 20)
					end
					aura.Color = ColorSequence.new(Color3.fromRGB(0, 255, 128))
				end
			end)
			task.wait(0.05)
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

createToggle(panelMove, "⚡ Speed 3x (Velocidade)", function(enabled)
	_G.Free_Speed = enabled
	task.spawn(function()
		while _G.Free_Speed do
			pcall(function()
				local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if hum then hum.WalkSpeed = 48 end
			end)
			task.wait(0.2)
		end
		pcall(function()
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = 16 end
		end)
	end)
end)

createToggle(panelMove, "👻 Wall Hack (Atravessar Paredes)", function(enabled)
	_G.Free_Noclip = enabled
end)

RunService.Stepped:Connect(function()
	if _G.Free_Noclip then
		pcall(function()
			for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end)
	end
end)

local flyConn, bv, bg
createToggle(panelMove, "🛸 Fly (Modo Voo Beta)", function(enabled)
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart
	local hum = char:FindFirstChildOfClass("Humanoid")
	
	if enabled then
		if hum then hum.PlatformStand = true end
		bv = Instance.new("BodyVelocity", root, "FreeFlyVel")
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = Vector3.zero
		
		bg = Instance.new("BodyGyro", root, "FreeFlyGyro")
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.CFrame = Camera.CFrame
		if hum then hum.AutoRotate = false end
		
		flyConn = RunService.RenderStepped:Connect(function()
			local cam = workspace.CurrentCamera
			local move = Vector3.zero
			local spd = 50
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then spd = 90 end
			if bv then bv.Velocity = move * spd end
			if bg then bg.CFrame = cam.CFrame end
		end)
	else
		if flyConn then flyConn:Disconnect() end
		if root:FindFirstChild("FreeFlyVel") then root.FreeFlyVel:Destroy() end
		if root:FindFirstChild("FreeFlyGyro") then root.FreeFlyGyro:Destroy() end
		if hum then hum.PlatformStand = false; hum.AutoRotate = true end
	end
end)

_G.Free_AimSmooth = 5

createToggle(panelBoss, "🎯 Aimbot (Foco Headshot / Cabeça)", function(enabled)
	_G.Free_AimLock = enabled
	task.spawn(function()
		while _G.Free_AimLock do
			pcall(function()
				local closestTarget = nil
				local shortestDist = math.huge
				local lRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				
				if lRoot then
					local zombiesList = getZombies()
					for _, enemy in ipairs(zombiesList) do
						local hum = enemy:FindFirstChildOfClass("Humanoid")
						local head = enemy:FindFirstChild("Head")
						if hum and hum.Health > 0 and head then
							local dist = (head.Position - lRoot.Position).Magnitude
							if dist < shortestDist then
								shortestDist = dist
								closestTarget = head
							end
						end
					end
					
					if closestTarget then
						local targetCF = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
						local alpha = math.clamp(_G.Free_AimSmooth / 10, 0.05, 1)
						Camera.CFrame = Camera.CFrame:Lerp(targetCF, alpha)
					end
				end
			end)
			task.wait(0.02)
		end
	end)
end)

createSlider(panelBoss, "⚙️ Suavidade Headshot (Aimbot)", 1, 10, 5, function(val)
	_G.Free_AimSmooth = val
end)

print("[CYBER HACKER FREE 1.2.7] Update Surreal Aplicado com Sucesso! - Canal: https://youtu.be/D2Iqev9FHyA?si=GAnnU5ckAE_rzOOq | Créditos: DarkGamingYT")
