-- ==========================================================================
-- CYBER HACKER | Versão FREE 1.0 (Com Login, Presença Avançada & Métricas Pro)
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

-- URL DO SEU FIREBASE CONFIGURADA
local FIREBASE_URL = "https://darkgamingyt-1c438-default-rtdb.firebaseio.com"

-- Identificação única baseada no UserId do Roblox
local userId = LocalPlayer.UserId
local userName = LocalPlayer.Name
local displayName = LocalPlayer.DisplayName
local playerSessionId = "user_" .. tostring(userId)

-- Limpeza de instâncias anteriores
pcall(function()
	if CoreGui:FindFirstChild("CyberHacker_FREE_1_0") then
		CoreGui.CyberHacker_FREE_1_0:Destroy()
	end
	if LocalPlayer.PlayerGui:FindFirstChild("CyberHacker_FREE_1_0") then
		LocalPlayer.PlayerGui.CyberHacker_FREE_1_0:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHacker_FREE_1_0"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local successParent = pcall(function() ScreenGui.Parent = CoreGui end)
if not successParent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- ==========================================================================
-- TELA DE LOGIN CYBERPUNK (Usuário: FREE / Senha: FREE)
-- ==========================================================================
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 320, 0, 240)
LoginFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
LoginFrame.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
LoginFrame.BorderSizePixel = 0
LoginFrame.ZIndex = 20
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 12)

local LoginStroke = Instance.new("UIStroke", LoginFrame)
LoginStroke.Thickness = 2.5
LoginStroke.Color = Color3.fromRGB(0, 255, 128)

task.spawn(function()
	while LoginFrame and LoginFrame.Parent do
		for i = 0, 1, 0.01 do
			if not LoginStroke or not LoginStroke.Parent then break end
			LoginStroke.Color = Color3.fromHSV(i, 1, 1)
			task.wait(0.05)
		end
	end
end)

local LoginTitle = Instance.new("TextLabel", LoginFrame)
LoginTitle.Size = UDim2.new(1, 0, 0, 35)
LoginTitle.Position = UDim2.new(0, 0, 0, 10)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "🔒 AUTENTICAÇÃO FIREBASE"
LoginTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
LoginTitle.TextSize = 14
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.ZIndex = 21

local function createTextBox(posY, placeholder)
	local box = Instance.new("TextBox", LoginFrame)
	box.Size = UDim2.new(0.85, 0, 0, 38)
	box.Position = UDim2.new(0.075, 0, 0, posY)
	box.BackgroundColor3 = Color3.fromRGB(14, 18, 24)
	box.BorderSizePixel = 0
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(100, 130, 110)
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(0, 255, 128)
	box.TextSize = 12
	box.Font = Enum.Font.GothamMedium
	box.ZIndex = 21
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", box)
	stroke.Color = Color3.fromRGB(25, 45, 35)
	stroke.Thickness = 1.5
	return box
end

local UserBox = createTextBox(55, "Usuário (Digite FREE)")
local PassBox = createTextBox(105, "Senha (Digite FREE)")
PassBox.TextWrapped = true

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0.85, 0, 0, 38)
LoginBtn.Position = UDim2.new(0.075, 0, 0, 155)
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
LoginBtn.Text = "ENTRAR NO SISTEMA"
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.TextSize = 12
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.ZIndex = 21
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 8)

local ErrorLabel = Instance.new("TextLabel", LoginFrame)
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0, 0, 0, 202)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
ErrorLabel.TextSize = 11
ErrorLabel.Font = Enum.Font.GothamMedium
ErrorLabel.ZIndex = 21

local loggedIn = false
local statsLabelReference = nil

-- ==========================================================================
-- PAINEL PRINCIPAL
-- ==========================================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 340, 0, 420)
MainFrame.Position = UDim2.new(0, 98, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.ZIndex = 4

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2.5
MainStroke.Color = Color3.fromRGB(0, 255, 128)

task.spawn(function()
	while MainFrame and MainFrame.Parent do
		for i = 0, 1, 0.01 do
			if not MainStroke or not MainStroke.Parent then break end
			MainStroke.Color = Color3.fromHSV(i, 1, 1)
			task.wait(0.05)
		end
	end
end)

-- ==========================================================================
-- BOTÃO FLUTUANTE
-- ==========================================================================
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.fromOffset(55, 55)
FloatBtn.Position = UDim2.new(0, 35, 0.35, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
FloatBtn.BorderSizePixel = 0
FloatBtn.Text = "LOCKED"
FloatBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
FloatBtn.TextSize = 9
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.Active = true
FloatBtn.Draggable = true
FloatBtn.ZIndex = 5
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 12)

local FloatStroke = Instance.new("UIStroke", FloatBtn)
FloatStroke.Thickness = 2.5
FloatStroke.Color = Color3.fromRGB(220, 80, 80)

-- Função de Presença Atualizada com Dados Avançados e JobId
local function iniciarSistemaPresenca()
	task.spawn(function()
		local dispositivoDetectado = UserInputService.TouchEnabled and "Mobile / Celular" | "PC / Computador"
		
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
				request({
					Url = FIREBASE_URL .. "/usuarios_online/" .. playerSessionId .. ".json",
					Method = "PUT",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode({
						-- Dados de Identificação
						nome = userName,
						nomeExibicao = displayName,
						id = userId,
						dispositivo = dispositivoDetectado,
						
						-- Dados de Jogo e Servidor
						placeIdAtual = game.PlaceId,
						jobIdServidor = game.JobId,
						jogadoresNoServidor = #Players:GetPlayers(),
						
						-- Dados Técnicos e de Hardware
						executor = executorNome,
						idadeContaDias = LocalPlayer.AccountAge,
						possuiRobloxPremium = tostring(LocalPlayer.MembershipType),
						pingMS = math.floor((LocalPlayer:GetNetworkPing() * 1000) or 0),
						memoriaUtilizadaMB = math.floor(collectgarbage("count") / 1024),
						qualidadeGrafica = tostring(UserSettings():GetService("UserGameSettings").SavedQualityLevel),
						
						-- Controle
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
		
		FloatBtn.Text = "CYBER"
		FloatBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
		FloatStroke.Color = Color3.fromRGB(0, 255, 128)
		
		task.spawn(function()
			while FloatBtn and FloatBtn.Parent and loggedIn do
				for i = 0, 1, 0.01 do
					if not FloatStroke or not FloatStroke.Parent then break end
					FloatStroke.Color = Color3.fromHSV(i, 1, 1)
					task.wait(0.05)
				end
			end
		end)
		
		task.wait(0.8)
		LoginFrame:Destroy()
	else
		ErrorLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
		ErrorLabel.Text = "Usuário ou Senha incorretos! (Use FREE)"
	end
end)

-- ==========================================================================
-- CONTADOR DE FPS
-- ==========================================================================
local FpsLabel = Instance.new("TextLabel", ScreenGui)
FpsLabel.Size = UDim2.fromOffset(55, 20)
FpsLabel.Position = UDim2.new(0, 35, 0.35, -22)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 0"
FpsLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
FpsLabel.TextSize = 11
FpsLabel.Font = Enum.Font.GothamBold
FpsLabel.TextXAlignment = Enum.TextXAlignment.Center
FpsLabel.ZIndex = 5

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
	FpsLabel.Position = UDim2.new(FloatBtn.Position.X.Scale, FloatBtn.Position.X.Offset, FloatBtn.Position.Y.Scale, FloatBtn.Position.Y.Offset - 22)
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 24)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 4
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "CYBER HACKER | FREE 1.0"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
TitleLabel.TextSize = 12
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 4

FloatBtn.MouseButton1Click:Connect(function()
	if not loggedIn then return end
	MainFrame.Visible = not MainFrame.Visible
	if MainFrame.Visible then
		MainFrame.Position = UDim2.new(0, FloatBtn.AbsolutePosition.X + 65, 0, FloatBtn.AbsolutePosition.Y)
	end
end)

-- ==========================================================================
-- SISTEMA DE ABAS
-- ==========================================================================
local TabHeader = Instance.new("Frame", MainFrame)
TabHeader.Size = UDim2.new(1, -20, 0, 34)
TabHeader.Position = UDim2.new(0, 10, 0, 48)
TabHeader.BackgroundTransparency = 1
TabHeader.ZIndex = 4

local function createTabBtn(name, posX, active)
	local btn = Instance.new("TextButton", TabHeader)
	btn.Size = UDim2.new(0.23, 0, 1, 0)
	btn.Position = UDim2.new(posX, 0, 0, 0)
	btn.BackgroundColor3 = active and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(14, 18, 24)
	btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 180, 150)
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.Text = name
	btn.ZIndex = 4
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local btnVisual = createTabBtn("VISUAL", 0, true)
local btnMove = createTabBtn("MOV", 0.25, false)
local btnBoss = createTabBtn("COMBATE", 0.50, false)
local btnChannel = createTabBtn("CANAL", 0.75, false)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -20, 1, -95)
ContentContainer.Position = UDim2.new(0, 10, 0, 88)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 4

local function createScroll()
	local scroll = Instance.new("ScrollingFrame", ContentContainer)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.Visible = false
	scroll.ZIndex = 4
	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0, 8)
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
	
	btnVisual.BackgroundColor3 = (selected == panelVisual) and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(14, 18, 24)
	btnMove.BackgroundColor3 = (selected == panelMove) and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(14, 18, 24)
	btnBoss.BackgroundColor3 = (selected == panelBoss) and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(14, 18, 24)
	btnChannel.BackgroundColor3 = (selected == panelChannel) and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(14, 18, 24)
	
	btnVisual.TextColor3 = (selected == panelVisual) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 180, 150)
	btnMove.TextColor3 = (selected == panelMove) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 180, 150)
	btnBoss.TextColor3 = (selected == panelBoss) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 180, 150)
	btnChannel.TextColor3 = (selected == panelChannel) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 180, 150)
end

btnVisual.MouseButton1Click:Connect(function() selectTab(panelVisual) end)
btnMove.MouseButton1Click:Connect(function() selectTab(panelMove) end)
btnBoss.MouseButton1Click:Connect(function() selectTab(panelBoss) end)
btnChannel.MouseButton1Click:Connect(function() selectTab(panelChannel) end)

local function createToggle(parent, name, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 38)
	row.BackgroundColor3 = Color3.fromRGB(14, 18, 24)
	row.ZIndex = 4
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
	
	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.68, 0, 1, 0)
	label.Position = UDim2.new(0.05, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(230, 240, 230)
	label.TextSize = 12
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 4
	
	local statusBtn = Instance.new("TextButton", row)
	statusBtn.Size = UDim2.new(0, 56, 0, 24)
	statusBtn.Position = UDim2.new(0.75, 0, 0.18, 0)
	statusBtn.BackgroundColor3 = Color3.fromRGB(25, 32, 42)
	statusBtn.Text = "OFF"
	statusBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
	statusBtn.TextSize = 11
	statusBtn.Font = Enum.Font.GothamBold
	statusBtn.ZIndex = 4
	Instance.new("UICorner", statusBtn).CornerRadius = UDim.new(0, 6)
	
	local state = false
	statusBtn.MouseButton1Click:Connect(function()
		state = not state
		if state then
			statusBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
			statusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			statusBtn.Text = "ON"
		else
			statusBtn.BackgroundColor3 = Color3.fromRGB(25, 32, 42)
			statusBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
			statusBtn.Text = "OFF"
		end
		callback(state)
	end)
end

local function createSlider(parent, name, min, max, default, callback)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 55)
	row.BackgroundColor3 = Color3.fromRGB(14, 18, 24)
	row.ZIndex = 4
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.7, 0, 0, 24)
	label.Position = UDim2.new(0.05, 0, 0, 4)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(230, 240, 230)
	label.TextSize = 12
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 4

	local valLabel = Instance.new("TextLabel", row)
	valLabel.Size = UDim2.new(0.2, 0, 0, 24)
	valLabel.Position = UDim2.new(0.75, 0, 0, 4)
	valLabel.BackgroundTransparency = 1
	valLabel.Text = tostring(default)
	valLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
	valLabel.TextSize = 12
	valLabel.Font = Enum.Font.GothamBold
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	valLabel.ZIndex = 4

	local sliderBg = Instance.new("Frame", row)
	sliderBg.Size = UDim2.new(0.9, 0, 0, 6)
	sliderBg.Position = UDim2.new(0.05, 0, 0, 36)
	sliderBg.BackgroundColor3 = Color3.fromRGB(25, 32, 42)
	sliderBg.BorderSizePixel = 0
	sliderBg.ZIndex = 4
	Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

	local sliderFill = Instance.new("Frame", sliderBg)
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 4
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
-- CONTEÚDO DA ABA 4: CANAL & USUÁRIOS ONLINE
-- ==========================================================================
local ChannelCard = Instance.new("Frame", panelChannel)
ChannelCard.Size = UDim2.new(1, 0, 0, 255)
ChannelCard.BackgroundColor3 = Color3.fromRGB(14, 18, 24)
ChannelCard.ZIndex = 4
Instance.new("UICorner", ChannelCard).CornerRadius = UDim.new(0, 8)

local CardTitle = Instance.new("TextLabel", ChannelCard)
CardTitle.Size = UDim2.new(1, 0, 0, 30)
CardTitle.Position = UDim2.new(0, 0, 0, 8)
CardTitle.BackgroundTransparency = 1
CardTitle.Text = "DARK GAMING YT"
CardTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
CardTitle.TextSize = 14
CardTitle.Font = Enum.Font.GothamBold
CardTitle.ZIndex = 4

local CardDesc = Instance.new("TextLabel", ChannelCard)
CardDesc.Size = UDim2.new(0.9, 0, 0, 40)
CardDesc.Position = UDim2.new(0.05, 0, 0, 38)
CardDesc.BackgroundTransparency = 1
CardDesc.Text = "Inscreva-se no canal oficial para acompanhar novos scripts, tutoriais e atualizações!"
CardDesc.TextColor3 = Color3.fromRGB(180, 200, 190)
CardDesc.TextSize = 10
CardDesc.Font = Enum.Font.GothamMedium
CardDesc.TextWrapped = true
CardDesc.ZIndex = 4

local CopyChannelBtn = Instance.new("TextButton", ChannelCard)
CopyChannelBtn.Size = UDim2.new(0.9, 0, 0, 34)
CopyChannelBtn.Position = UDim2.new(0.05, 0, 0, 82)
CopyChannelBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
CopyChannelBtn.Text = "📺 Copiar Link do Canal"
CopyChannelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyChannelBtn.TextSize = 11
CopyChannelBtn.Font = Enum.Font.GothamBold
CopyChannelBtn.ZIndex = 4
Instance.new("UICorner", CopyChannelBtn).CornerRadius = UDim.new(0, 8)

CopyChannelBtn.MouseButton1Click:Connect(function()
	pcall(function()
		setclipboard("https://youtu.be/D2Iqev9FHyA?si=GAnnU5ckAE_rzOOq")
	end)
	CopyChannelBtn.Text = "✅ Link Copiado com Sucesso!"
	task.wait(2)
	CopyChannelBtn.Text = "📺 Copiar Link do Canal"
end)

local StatsBox = Instance.new("Frame", ChannelCard)
StatsBox.Size = UDim2.new(0.9, 0, 0, 34)
StatsBox.Position = UDim2.new(0.05, 0, 0, 124)
StatsBox.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
StatsBox.ZIndex = 4
Instance.new("UICorner", StatsBox).CornerRadius = UDim.new(0, 8)
local StatsStroke = Instance.new("UIStroke", StatsBox)
StatsStroke.Color = Color3.fromRGB(0, 255, 128)
StatsStroke.Thickness = 1

local StatsLabel = Instance.new("TextLabel", StatsBox)
StatsLabel.Size = UDim2.new(1, 0, 1, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "👥 Pessoas Usando Agora: Conectando..."
StatsLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
StatsLabel.TextSize = 11
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.ZIndex = 4

statsLabelReference = StatsLabel

local CreditFooter = Instance.new("TextLabel", ChannelCard)
CreditFooter.Size = UDim2.new(1, 0, 0, 25)
CreditFooter.Position = UDim2.new(0, 0, 0, 168)
CreditFooter.BackgroundTransparency = 1
CreditFooter.Text = "Desenvolvido por DarkGamingYT"
CreditFooter.TextColor3 = Color3.fromRGB(0, 255, 128)
CreditFooter.TextSize = 11
CreditFooter.Font = Enum.Font.GothamBold
CreditFooter.ZIndex = 4

-- ==========================================================================
-- FUNÇÕES DE SUPORTE E CHEATS
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

createToggle(panelVisual, "ESP Craft", function(enabled)
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

createToggle(panelVisual, "ESP Name & HP", function(enabled)
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

_G.SurrealFloor_Color = Color3.fromRGB(0, 255, 128)
_G.SurrealFloor_RGB = false

createToggle(panelVisual, "Efeito Surreal (Pés)", function(enabled)
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
					if _G.SurrealFloor_RGB then
						aura.Color = ColorSequence.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
					else
						aura.Color = ColorSequence.new(_G.SurrealFloor_Color)
					end
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

createToggle(panelVisual, "Efeito Pés RGB Automático", function(enabled)
	_G.SurrealFloor_RGB = enabled
end)

createToggle(panelMove, "Speed 3x", function(enabled)
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

createToggle(panelMove, "Wall Hack (NoClip)", function(enabled)
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
createToggle(panelMove, "Fly ( Beta )", function(enabled)
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

createToggle(panelBoss, "Aim Lock (Foco na Cabeça / HS)", function(enabled)
	_G.Free_AimLock = enabled
	task.spawn(function()
		while _G.Free_AimLock do
			pcall(function()
				local closestTarget = nil
				local shortestDist = math.huge
				local lRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				
				if lRoot then
					for _, enemy in ipairs(getZombies()) do
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
			task.wait(0.03)
		end
	end)
end)

createSlider(panelBoss, "Suavidade Headshot (Aimbot)", 1, 10, 5, function(val)
	_G.Free_AimSmooth = val
end)

print("[CYBER HACKER FREE 1.0] Sistema Pro com JobId e Métricas ativado! - Canal: https://youtu.be/D2Iqev9FHyA?si=GAnnU5ckAE_rzOOq | Créditos: DarkGamingYT")
