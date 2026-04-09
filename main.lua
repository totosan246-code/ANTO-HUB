-- LIMPIEZA DE INTERFACES VIEJAS
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and (v.Name == "ScreenGui" or v:FindFirstChild("Frame")) then
        v:Destroy()
    end
end

-- INTERFAZ NUEVA Y LIMPIA
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btnRobar = Instance.new("TextButton")
local btnBase = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_V1"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.5, -100, 0.4, 0)
Frame.Size = UDim2.new(0, 200, 0, 180)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true

local function Estilo(btn, texto, pos, color)
    btn.Parent = Frame
    btn.Text = texto
    btn.Size = UDim2.new(0, 180, 0, 70)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.BorderSizePixel = 0
end

Estilo(btnRobar, "1. IR AL BRAINROT\n(TP + AUTO-E)", UDim2.new(0, 10, 0, 10), Color3.fromRGB(200, 0, 0))
Estilo(btnBase, "2. IR A MI BASE\n(ANOTAR)", UDim2.new(0, 10, 0, 100), Color3.fromRGB(0, 100, 200))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- FUNCIÓN PARA MOVERSE SIN QUE EL JUEGO TE REGRESE
local function safeTeleport(cframe)
    root.Velocity = Vector3.new(0,0,0)
    root.CFrame = cframe
    -- Congelar un instante para engañar al Anti-Cheat
    root.Anchored = true
    task.wait(0.15)
    root.Anchored = false
end

-- 1. IR AL BRAINROT DEL ENEMIGO + AUTO AGARRAR
btnRobar.MouseButton1Click:Connect(function()
    local target = nil
    for _, v in pairs(workspace:GetDescendants()) do
        -- Busca el Brainrot que NO sea el nuestro (el que tenga la letra E)
        if v:IsA("ProximityPrompt") then
            target = v
            break
        end
    end

    if target then
        -- Ir al objeto
        safeTeleport(target.Parent.CFrame * CFrame.new(0, 2, 0))
        -- Agarrar automáticamente
        task.wait(0.05)
        fireproximityprompt(target)
    else
        -- Si el enemigo ya lo tiene, vamos a su posición
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if p.Character:FindFirstChildOfClass("Tool") then
                    safeTeleport(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    break
                end
            end
        end
    end
end)

-- 2. IR A MI BASE (PUNTO SEGURO)
btnBase.MouseButton1Click:Connect(function()
    -- En Duelos, el spawn es la base. 
    local spawn = player.RespawnLocation
    if spawn then
        safeTeleport(spawn.CFrame * CFrame.new(0, 4, 0))
    else
        -- Si no detecta spawn, busca la zona de entrega por nombre común
        for _, g in pairs(workspace:GetDescendants()) do
            if g.Name:find("Goal") or g.Name:find("Base") or g.Name:find("Deliver") then
                if (g.Position - root.Position).Magnitude > 50 then -- Para no ir a la base enemiga
                    safeTeleport(g.CFrame * CFrame.new(0, 4, 0))
                    break
                end
            end
        end
    end
end)

-- AUTO-INTERACT SIEMPRE ACTIVO (Si estás cerca, pulsa E solo)
game:GetService("RunService").Stepped:Connect(function()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local dist = (root.Position - prompt.Parent.Position).Magnitude
            if dist < 15 then
                fireproximityprompt(prompt)
            end
        end
    end
end)
