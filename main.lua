local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NEW DUELOS V1.1 🔴", "BloodTheme")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- PESTAÑA PRINCIPAL
local Tab1 = Window:NewTab("PRINCIPAL")
local Section1 = Tab1:NewSection("Robo Instantáneo")

-- 1. AUTO INTERACT (LA LETRA "E" AUTOMÁTICA)
Section1:NewToggle("AUTO RECOGER (LETRA E)", "Presiona E automáticamente", function(state)
    _G.AutoE = state
    task.spawn(function()
        while _G.AutoE do
            task.wait() -- Ultra rápido
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    -- Si estás cerca del objeto, lo activa al instante
                    local dist = (root.Position - prompt.Parent.Position).Magnitude
                    if dist < 20 then -- Distancia de detección
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end)
end)

-- 2. TP AL BRAINROT (MODO FUERZA)
Section1:NewButton("TP AL BRAINROT", "Te lleva y lo ancla un segundo", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:find("Brain") or v.Name == "Object") then
            root.Velocity = Vector3.new(0,0,0)
            root.CFrame = v.CFrame * CFrame.new(0, 2, 0)
            break
        end
    end
end)

-- 3. IR A MI BASE
Section1:NewButton("IR A MI BASE", "Regresa al Spawn", function()
    local spawn = player.RespawnLocation
    if spawn then
        root.CFrame = spawn.CFrame * CFrame.new(0, 5, 0)
    end
end)

-- 4. VOLAR (FLOAT)
Section1:NewToggle("VOLAR (FLOAT)", "Manten espacio", function(state)
    _G.Volar = state
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.Volar and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            root.Velocity = Vector3.new(root.Velocity.X, 45, root.Velocity.Z)
        end
    end)
end)

-- PESTAÑA AJUSTES
local Tab2 = Window:NewTab("MEJORAS")
local Section2 = Tab2:NewSection("Físicas")

Section2:NewSlider("VELOCIDAD", "Sin Lag", 150, 16, function(s)
    hum.WalkSpeed = s
end)

Section2:NewToggle("ANTI RAGDOLL", "No te caigas", function(state)
    _G.AntiRagdoll = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.AntiRagdoll then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end)
