local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Estilo: Título Rojo y Fondo Negro (BloodTheme es el más cercano)
local Window = Library.CreateLib("ANTO-HUB 🚀 (LUARMOR STYLE)", "BloodTheme")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- PESTAÑA PRINCIPAL
local Tab1 = Window:NewTab("Main")
local Section1 = Tab1:NewSection("Robo & Teleport")

-- 1. AUTO GRAB (Robo instantáneo)
Section1:NewButton("AUTO GRAB", "Se pega al Brainrot y lo toma", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Brainrot" and obj:IsA("BasePart") then
            root.CFrame = obj.CFrame
            task.wait(0.1)
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            break
        end
    end
end)

-- 2. INSTA DROP BRAINROT (Al frente del objetivo)
Section1:NewButton("INSTA DROP BRAINROT", "Te pone frente al punto de entrega", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Brainrot" and obj:IsA("BasePart") then
            root.CFrame = obj.CFrame * CFrame.new(0, 0, -5)
            break
        end
    end
end)

-- 3. RUTA A MI BASE (Movimiento inteligente)
Section1:NewButton("Regresar a Base (Ruta)", "Recta, Recta y Curva a Puerta", function()
    local spawn = player.RespawnLocation
    if spawn then
        -- Fase 1: Recta hacia afuera (alejarte del peligro)
        root.CFrame = root.CFrame * CFrame.new(0, 0, 20)
        task.wait(0.3)
        -- Fase 2: Recta directo a tu base
        root.CFrame = CFrame.new(root.Position, spawn.Position) * CFrame.new(0, 0, -50)
        task.wait(0.5)
        -- Fase 3: Curva y entrada a puerta
        root.CFrame = spawn.CFrame * CFrame.new(5, 0, 5) -- Curva
        task.wait(0.2)
        root.CFrame = spawn.CFrame -- Adentro
    end
end)

-- PESTAÑA COMBATE
local Tab2 = Window:NewTab("Combat")
local Section2 = Tab2:NewSection("Mejoras")

-- 4. ANTI RAGDOLL (Levantarse rápido)
Section2:NewToggle("ANTI RAGDOLL", "No te quedas tirado si te pegan", function(state)
    _G.AntiRagdoll = state
    hum.StateChanged:Connect(function(_, nuevo)
        if _G.AntiRagdoll and (nuevo == Enum.HumanoidStateType.FallingDown or nuevo == Enum.HumanoidStateType.PlatformStanding) then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            root.Velocity = Vector3.new(0,0,0) -- Quita el impulso del golpe
        end
    end)
end)

-- 5. FLOAT (Volar al saltar)
Section2:NewToggle("FLOAT", "Mantén espacio para flotar", function(state)
    _G.Float = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.Float then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(0.1)
            root.Velocity = Vector3.new(0, 30, 0)
        end
    end)
end)

-- 6. VELOCIDAD PRO
Section2:NewSlider("Velocidad", "Rápido pero sin Lag", 150, 16, function(s)
    hum.WalkSpeed = s
end)
