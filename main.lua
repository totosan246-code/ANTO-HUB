-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_FINAL" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_FINAL"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.Position = UDim2.new(0.5, -90, 0.3, 0)
Frame.Size = UDim2.new(0, 180, 0, 240)
Frame.Active = true
Frame.Draggable = true

local function Estilo(btn, texto, pos, color)
    btn.Parent = Frame
    btn.Text = texto
    btn.Size = UDim2.new(0, 160, 0, 60)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
end

Estilo(btn1, "1. IR AL BRAINROT", UDim2.new(0, 10, 0, 10), Color3.fromRGB(200, 0, 0))
Estilo(btn2, "2. IR A MI BASE\n(FORZAR PUNTO)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 200))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(80, 80, 80))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE (Ejecuta parado en el centro de tu base)
local MiBasePos = root.CFrame

-- FUNCIÓN PARA MOVERSE SIN QUE EL JUEGO TE CONGELE
local function MoverSuave(targetCFrame)
    local startPos = root.CFrame
    -- Se mueve en 3 pasos rápidos para que el juego no te regrese
    for i = 1, 3 do
        root.CFrame = startPos:Lerp(targetCFrame, i/3)
        task.wait(0.02)
    end
    root.Velocity = Vector3.new(0, -20, 0) -- Empujón final hacia el suelo
end

-- 1. IR AL BRAINROT (PASO A PASO)
btn1.MouseButton1Click:Connect(function()
    local target = nil
    local maxDist = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (v.Parent.Position - MiBasePos.Position).Magnitude
            if dist > maxDist then
                maxDist = dist
                target = v.Parent
            end
        end
    end
    if target then
        MoverSuave(target.CFrame * CFrame.new(0, 2, 0))
    end
end)

-- 2. IR A MI BASE (ESTE NO FALLA)
btn2.MouseButton1Click:Connect(function()
    -- Primero te acerca un poco
    local medioCamino = root.CFrame:Lerp(MiBasePos, 0.5)
    root.CFrame = medioCamino
    task.wait(0.05)
    -- Luego llega a la base y SE QUEDA AHÍ
    root.CFrame = MiBasePos
    
    -- Camina un poquito solo para que el sensor despierte
    task.spawn(function()
        local start = tick()
        while tick() - start < 0.8 do
            hum:Move(Vector3.new(1, 0, 1), true)
            task.wait()
        end
    end)
end)

-- 3. SALTO INFINITO
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- AUTO-RECOGER (SIEMPRE ON)
task.spawn(function()
    while true do
        task.wait(0.1)
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                if (root.Position - p.Parent.Position).Magnitude < 15 then
                    fireproximityprompt(p)
                end
            end
        end
    end
end)
