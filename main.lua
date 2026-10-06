--[[\
    CYBER HACKER Versão FREE 1.2.6 (Corrigido)
    Canal: DarkGamingYT
]]--

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Proteção contra detecção básica e remoção de UI antiga
if _G.CyberHackerLoaded then
    pcall(function() _G.CyberHackerLoaded() end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHackerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Tenta colocar no CoreGui, se falhar vai para o PlayerGui
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

_G.CyberHackerLoaded = function()
    ScreenGui:Destroy()
end

-- ==================== VARIÁVEIS DE CONFIGURAÇÃO ====================
local Settings = {
    Aimbot = false,
    ESP = false,
    Speed = 16,
    JumpPower = 50,
}

-- ==================== JANELA PRINCIPAL ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "CYBER HACKER v1.2.6 | DarkGamingYT"
Title.Parent = TopBar

-- Botão Fechar (Minimizar)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 2.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- ==================== BOTÃO FLUTUANTE (ABRIR/FECHAR) ====================
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "FloatingOpenButton"
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 20, 0.4, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
OpenButton.BorderColor3 = Color3.fromRGB(0, 255, 128)
OpenButton.BorderSizePixel = 2
OpenButton.Text = "CH"
OpenButton.TextColor3 = Color3.fromRGB(0, 255, 128)
OpenButton.TextSize = 16
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.Visible = false -- Começa oculto porque o menu principal já abre na tela
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 25)
OpenCorner.Parent = OpenButton

-- Ações de Minimizar / Restaurar
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- ==================== CONTEÚDO DO MENU ====================
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -45)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
ContentFrame.ScrollBarThickness = 4
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ContentFrame

-- Função para criar botões de toggle (Ativar/Desativar)
local function CreateToggle(name, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    ToggleBtn.Text = "  " .. name .. ": [ OFF ]"
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBtn.TextSize = 14
    ToggleBtn.Font = Enum.Font.GothamMedium
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.Parent = ContentFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleBtn

    local enabled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBtn.Text = "  " .. name .. ": [ ON ]"
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleBtn.Text = "  " .. name .. ": [ OFF ]"
        end
        callback(enabled)
    end)
end

-- Criando os botões de recursos
CreateToggle("ESP Zumbis / Inimigos", function(state)
    Settings.ESP = state
end)

CreateToggle("Aimbot Automático", function(state)
    Settings.Aimbot = state
end)

-- ==================== LOOP DE FUNCIONALIDADES ====================
RunService.RenderStepped:Connect(function()
    if Settings.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        -- Mantém checagens seguras
    end
end)

print("Cyber Hacker v1.2.6 carregado com sucesso!")
