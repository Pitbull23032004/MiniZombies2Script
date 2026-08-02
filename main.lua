-- Painel Flutuante v4.5 - Versão Apelona + Bypass & Voo Corrigido
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Sistema de Bypass / Ocultação básica para CoreGui / Logs
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
end)

if game.CoreGui:FindFirstChild("DK_PainelApelao") then
    game.CoreGui.DK_PainelApelao:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DK_PainelApelao"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -150)
MainFrame.Size = UDim2.new(0, 440, 0, 300)
MainFrame.Visible = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Borda RGB Animada
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 0)

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local TopBarCover = Instance.new("Frame")
TopBarCover.Parent = TopBar
TopBarCover.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TopBarCover.BorderSizePixel = 0
TopBarCover.Position = UDim2.new(0, 0, 1, -5)
TopBarCover.Size = UDim2.new(1, 0, 0, 5)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 370, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "DK PAINEL <font color='#FF0000'>APELONA v4.5 + BYPASS</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Sistema de Arrastar Janela
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Botão de Minimizar (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -35, 0.5, -12)
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeBtn

-- Botão Flutuante Reabrir (Ícone Caveira)
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenButton.Position = UDim2.new(0, 20, 0.5, -25)
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Image = "rbxassetid://7072718362"
OpenButton.ImageColor3 = Color3.fromRGB(255, 0, 0)
OpenButton.Visible = false

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Parent = OpenButton
OpenStroke.Thickness = 2
OpenStroke.Color = Color3.fromRGB(255, 0, 0)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- Arrastar Botão Flutuante
local openDragging, openDragStart, openStartPos
OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDragging = true
        openDragStart = input.Position
        openStartPos = OpenButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if openDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - openDragStart
        OpenButton.Position = UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset + delta.X, openStartPos.Y.Scale, openStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDragging = false
    end
end)

-- Animação RGB da Borda
task.spawn(function()
    local hue = 0
    while true do
        hue = (hue + 1) % 360
        UIStroke.Color = Color3.fromHSV(hue / 360, 1, 1)
        task.wait(0.03)
    end
end)

-- Sistema de Abas
local TabButtonsContainer = Instance.new("ScrollingFrame")
TabButtonsContainer.Parent = MainFrame
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Position = UDim2.new(0, 0, 0, 45)
TabButtonsContainer.Size = UDim2.new(0, 110, 1, -45)
TabButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabButtonsContainer.ScrollBarThickness = 2

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabButtonsContainer
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 120, 0, 50)
ContentContainer.Size = UDim2.new(1, -130, 1, -60)

local tabs = {}
local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = TabButtonsContainer
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    tabBtn.BorderSizePixel = 0
    tabBtn.Size = UDim2.new(0, 95, 0, 32)
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.TextSize = 12

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Parent = ContentContainer
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 3

    local layout = Instance.new("UIListLayout")
    layout.Parent = tabContent
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.content.Visible = false
            t.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        end
        tabContent.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    table.insert(tabs, {btn = tabBtn, content = tabContent})
    if #tabs == 1 then
        tabContent.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end

    return tabContent
end

local TabESP = createTab("Visual ESP")
local TabPlayer = createTab("Player / Mov")
local TabCombat = createTab("Apelão")

local function createToggle(parent, text, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text .. ": [ OFF ]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 11
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = text .. ": [ ON ]"
            btn.TextColor3 = Color3.fromRGB(255, 0, 0)
            btn.BackgroundColor3 = Color3.fromRGB(45, 30, 30)
        else
            btn.Text = text .. ": [ OFF ]"
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        end
        callback(state)
    end)
    return btn
end

-- ==========================================
-- 1. SISTEMA ESP (Apenas Nome, Distância, Holograma)
-- ==========================================
local espConfig = {Name = false, Dist = false, Holo = false}

local function updateESPForTarget(obj)
    if obj == LocalPlayer.Character then return end
    local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
    if not hrp then return end

    local hl = obj:FindFirstChild("DK_Holo")
    if espConfig.Holo then
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "DK_Holo"
            hl.Adornee = obj
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = obj
        end
    else
        if hl then hl:Destroy() end
    end

    local billboard = hrp:FindFirstChild("DK_InfoTag")
    if espConfig.Name or espConfig.Dist then
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "DK_InfoTag"
            billboard.Size = UDim2.new(0, 150, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = hrp

            local txt = Instance.new("TextLabel")
            txt.Name = "Text"
            txt.Parent = billboard
            txt.BackgroundTransparency = 1
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 12
            txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            txt.TextStrokeTransparency = 0
        end
        local txt = billboard:FindFirstChild("Text")
        if txt then
            local str = ""
            if espConfig.Name then str = str .. obj.Name end
            if espConfig.Dist and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                str = str .. "\n[" .. dist .. "m]"
            end
            txt.Text = str
        end
    else
        if billboard then billboard:Destroy() end
    end
end

RunService.RenderStepped:Connect(function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj:FindFirstChildOfClass("Humanoid") or obj:FindFirstChild("HumanoidRootPart")) then
            updateESPForTarget(obj)
        end
    end
end)

createToggle(TabESP, "Esp Nome", function(state) espConfig.Name = state end)
createToggle(TabESP, "Esp Holograma", function(state) espConfig.Holo = state end)
createToggle(TabESP, "Esp Distância", function(state) espConfig.Dist = state end)


-- ==========================================
-- 2. PLAYER & MOVIMENTAÇÃO (Speed 5x, Voo com Espaço, NoClip)
-- ==========================================

-- Speed 5x (80 de WalkSpeed)
local speedActive = false
RunService.Heartbeat:Connect(function()
    if speedActive then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = 80
        end
    end
end)
createToggle(TabPlayer, "Speed Velocidade 5x", function(state)
    speedActive = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

-- Voo com tecla Espaço (Mantém pressionado para subir / controlar)
local flying = false
local flySpeed = 50
local bv
RunService.Heartbeat:Connect(function()
    if flying then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local camVector = Camera.CFrame.LookVector
            local moveVel = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVel = moveVel + (camVector * flySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVel = moveVel - (camVector * flySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVel = moveVel + Vector3.new(0, flySpeed, 0) end
            
            hrp.Velocity = moveVel
        end
    end
end)

createToggle(TabPlayer, "Voa com tecla Espaço", function(state)
    flying = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = state
        end
    end
end)

-- Atravessar paredes (NoClip)
local noclipConn
createToggle(TabPlayer, "Atravessar as paredes", function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end)


-- ==========================================
-- 3. COMBATE & APELÃO (Auto-KILL Boss Supremo, Teleport Amigos com Seletor)
-- ==========================================

-- Auto-KILL BOSS-SUPREMO
local bossKillActive = false
RunService.Heartbeat:Connect(function()
    if bossKillActive then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local nameL = obj.Name:lower()
                    if nameL:find("boss") or nameL:find("supremo") or nameL:find("goliath") or hum.MaxHealth > 300 then
                        hum.Health = 0
                    end
                end
            end
        end
    end
end)
createToggle(TabCombat, "Auto-KILL BOSS-SUPREMO", function(state)
    bossKillActive = state
end)

-- Seletor de Amigos para Teleport
local selectedFriendName = nil
local selectorBtn = Instance.new("TextButton")
selectorBtn.Parent = TabCombat
selectorBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
selectorBtn.Size = UDim2.new(1, -10, 0, 36)
selectorBtn.Font = Enum.Font.GothamMedium
selectorBtn.Text = "Alvo TP: [ Nenhum ]"
selectorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectorBtn.TextSize = 11

local scCorner = Instance.new("UICorner")
scCorner.CornerRadius = UDim.new(0, 6)
scCorner.Parent = selectorBtn

selectorBtn.MouseButton1Click:Connect(function()
    local plist = Players:GetPlayers()
    local currentIndex = 0
    for i, p in ipairs(plist) do
        if p.Name == selectedFriendName then
            currentIndex = i
            break
        end
    end
    
    local nextIndex = (currentIndex % #plist) + 1
    local targetP = plist[nextIndex]
    if targetP == LocalPlayer then
        nextIndex = (nextIndex % #plist) + 1
        targetP = plist[nextIndex]
    end
    
    if targetP and targetP ~= LocalPlayer then
        selectedFriendName = targetP.Name
        selectorBtn.Text = "Alvo TP: " .. selectedFriendName
        selectorBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        selectedFriendName = nil
        selectorBtn.Text = "Alvo TP: [ Nenhum ]"
        selectorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Botão de Executar Teleport no Amigo Selecionado
local tpBtn = Instance.new("TextButton")
tpBtn.Parent = TabCombat
tpBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
tpBtn.Size = UDim2.new(1, -10, 0, 36)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.Text = "🚀 Teleportar para o Alvo"
tpBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
tpBtn.TextSize = 11

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 6)
tpCorner.Parent = tpBtn

tpBtn.MouseButton1Click:Connect(function()
    if selectedFriendName then
        local target = Players:FindFirstChild(selectedFriendName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                myRoot.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
end)
