local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NEW DUELOS V1.1 🔴", "BloodTheme")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- PESTAÑA PRINCIPAL
local Tab1 = Window:NewTab("DUELOS PVP")
local Section1 = Tab1:NewSection("Funciones de Robo")

-- 1. BOTÓN MAESTRO: TP + RECOGER (Todo en uno)
Section1:NewButton("AUTO-ROBO INSTANTÁNEO", "Busca la E, va y la presiona", function()
    local encontrado = false
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            encontrado = true
            -- 1. Detener velocidad para evitar el bug de regreso
            root.Velocity = Vector3.new(0,0,0)
            -- 2. Teleport directo al objeto que tiene la E
            root.CFrame = obj.Parent.CFrame * CFrame.new(0, 2, 0)
            -- 3. Forzar el uso de la letra E
            task.wait(0.1)
            fireproximityprompt(obj)
            break
        end
    end
    if not encontrado then
        -- Si no hay E, busca por nombre como plan B
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:find("Brain") or v.Name == "Object") then
                root.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                break
            end
        end
    end
end)

-- 2. IR A MI BASE (CORREGIDO)
Section1:NewButton("REGRESAR A MI BASE", "Te lleva al Spawn", function()
    local spawn = player.RespawnLocation
    if spawn then
        root.Velocity = Vector3.new(0,0,0)
        root.CFrame = spawn.CFrame * CFrame.new(0, 4, 0)
    else
        -- Si no hay spawn definido, busca la base por color
        for _, b in pairs(workspace:GetDescendants()) do
            if b.Name:find("Base") and b:IsA("BasePart") then
                root.CFrame = b.CFrame * CFrame.new(0, 4, 0)
                break
            end
        end
    end
end)

-- 3. VOLAR (FLOAT)
Section1:NewToggle("VOLAR (ESPACIO)", "Mantén presionado para subir", function(state)
    _G.Volar = state
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.Volar and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            root.Velocity = Vector3.new(root.Velocity.X, 45, root.Velocity.Z)
        end
    end)
end)

-- PESTAÑA MEJORAS
local Tab2 = Window:NewTab("MEJORAS")
local Section2 = Tab2:NewSection("Físicas")

Section2:NewSlider("VELOCIDAD", "Usa 60 para evitar lag", 150, 16, function(s)
    hum.WalkSpeed = s
end)

Section2:NewToggle("ANTI RAGDOLL", "No te quedes tirado", function(state)
    _G.AntiRagdoll = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.AntiRagdoll then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end)
