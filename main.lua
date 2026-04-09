-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_V3" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton") -- Nuevo botón para el Salto

ScreenGui.Name = "ANTO_ULTRA_V3"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
Estilo(btn2, "2. IR A MI BASE\n(CAÍDA PARA PUNTO)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 200))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(100, 100, 100))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- IMPORTANTE: Ejecuta esto parado justo en el centro de tu base
local MiBasePos = root.CFrame

-- 1. IR AL BRAINROT (TELEPORT DIRECTO)
btn1.MouseButton1Click:Connect(function()
    local target = nil
    local maxDist = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (v.Parent.Position - MiBasePos.Position).Magnitude
            if dist > maxDist then
                maxDist = dist
                target = v
            end
        end
    end
    if target then
        root.Velocity = Vector3.new(0,0,0)
        root.CFrame = target.Parent.CFrame * CFrame.new(0, 2, 0)
    end
end)

-- 2. IR A MI BASE (MÉTODO CAÍDA LIBRE PARA ANOTAR)
btn2.MouseButton1Click:Connect(function()
    root.Velocity = Vector3.new(0,0,0)
    -- Te manda 4 metros arriba de tu base para que caigas y el sensor te detecte
    root.CFrame = MiBasePos * CFrame.new(0, 6, 0)
    
    -- Esperamos un poco para que el servidor registre la caída
    task.wait(0.1)
    root.Velocity = Vector3.new(0, -50, 0) -- Empujón hacia abajo
end)

-- 3. SALTO INFINITO (VOLAR)
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    if SaltoActivo then
        btn3.Text = "SALTO INFINITO: ON"
        btn3.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        btn3.Text = "SALTO INFINITO: OFF"
        btn3.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- AUTO-RECOGER AUTOMÁTICO
task.spawn(function()
    while true do
        task.wait(0.1)
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                local dist = (root.Position - prompt.Parent.Position).Magnitude
                if dist < 15 then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end)
