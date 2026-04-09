local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NEW DUELOS V1.1 🔴", "BloodTheme")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local Tab = Window:NewTab("MODO DUELOS")
local Section = Tab:NewSection("Ciclo de Victoria Rápida")

-- 1. IR Y ROBAR (TP + AUTO-E)
Section:NewButton("🚀 IR Y ROBAR BRAINROT", "TP directo + Agarre instantáneo", function()
    -- Detener inercia para evitar lag/rubberband
    root.Velocity = Vector3.new(0,0,0)
    
    local target = nil
    -- Buscamos el Brainrot por su ProximityPrompt (la letra E)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            target = obj
            break
        end
    end
    
    if target then
        -- Teleport exacto
        root.CFrame = target.Parent.CFrame * CFrame.new(0, 2, 0)
        
        -- Truco Anti-Bug: Anclar un milisegundo para que el server no te jale
        root.Anchored = true
        task.wait(0.1)
        root.Anchored = false
        
        -- Robo automático (Presiona la E por ti)
        fireproximityprompt(target)
    else
        print("Esperando a que aparezca el Brainrot...")
    end
end)

-- 2. IR A MI BASE (TP PARA PUNTO)
Section:NewButton("🏠 IR A MI BASE (PUNTO)", "Regresa al spawn para anotar", function()
    root.Velocity = Vector3.new(0,0,0)
    
    -- En Duelos, tu base es tu punto de aparición
    local mySpawn = player.RespawnLocation
    if mySpawn then
        root.CFrame = mySpawn.CFrame * CFrame.new(0, 4, 0)
        
        -- Anclamos para confirmar posición
        root.Anchored = true
        task.wait(0.1)
        root.Anchored = false
    end
end)

-- 3. MEJORAS DE COMBATE
local Section2 = Tab:NewSection("Configuración")

Section2:NewToggle("ANTI RAGDOLL", "Levantarse al instante", function(state)
    _G.Anti = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Anti and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end)

Section2:NewSlider("VELOCIDAD", "Velocidad recomendada: 80", 150, 16, function(s)
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = s
    end
end)
