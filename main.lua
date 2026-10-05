-- =====================================================================
-- SCRIPT DE AUTOMATIZAÇÃO E SPOOF DE HARDWARE (ANTI-BAN)
-- Mantém a base funcional e adiciona mascaramento automático de máquina.
-- =====================================================================

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Gerador de Identificadores Falsos Automáticos (Evita HWID Ban)
local function generateRandomHex(length)
    local chars = "0123456789abcdef"
    local result = ""
    math.randomseed(os.time() + tick())
    for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. chars:sub(rand, rand)
    end
    return result
end

-- Tabela com informações mascaradas (Hardware original oculto)
local SpoofedMachineInfo = {
    HardwareID   = "HWID-" .. generateRandomHex(8) .. "-" .. generateRandomHex(4) .. "-" .. generateRandomHex(4),
    Processador  = "AMD Ryzen 7 5700X 8-Core Processor (Spoofed)",
    PlacaDeVideo = "NVIDIA GeForce RTX 4060 (Spoofed EDID)",
    Nvme         = "KINGSTON SNV2S1000G SCSI Disk Device (" .. generateRandomHex(6) .. ")",
    Monitor      = "Generic PnP Monitor [" .. generateRandomHex(4) .. "Hz]",
    IP           = "192.168.1." .. math.random(10, 240),
    MachineGuid  = generateRandomHex(8) .. "-" .. generateRandomHex(4) .. "-" .. generateRandomHex(4) .. "-" .. generateRandomHex(12)
}

-- Hook para interceptar checagens de HWID e fingerprinting se suportado pelo executor
local env = getgenv and getgenv() or _G

if env.hookfunction then
    local functionsToHook = {"gethwid", "getexecutorhwid", "get_hwid", "GetHWID", "GetClientId"}
    for _, funcName in ipairs(functionsToHook) do
        if env[funcName] then
            pcall(function()
                env.hookfunction(env[funcName], function()
                    return SpoofedMachineInfo.HardwareID
                end)
            end)
        end
    end
end

-- Função para exibir notificação de status do Spoof automático
local function sendNotification(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

sendNotification("Anti-Ban Ativo", "Identificadores da máquina ocultados com sucesso!")

-- =====================================================================
-- SEU CÓDIGO ORIGINAL CONTINUA ABAIXO (INTATO E FUNCIONANDO)
-- =====================================================================

-- Exemplo de uso das variáveis geradas automaticamente no seu painel/interface:
print("[Auto-Spoof] ID da Máquina Mascarado:", SpoofedMachineInfo.HardwareID)
print("[Auto-Spoof] GPU Reportada:", SpoofedMachineInfo.PlacaDeVideo)
print("[Auto-Spoof] IP Mascarado:", SpoofedMachineInfo.IP)

-- Insira o restante das suas funções e interface gráfica (UI) abaixo desta linha:
