-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_FINAL_WINNER" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_FINAL_WINNER"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
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

Estilo(btn1, "1. IR AL BRAINROT", UDim2.new(0, 10, 0, 10), Color3.fromRGB(150, 0, 0))
Estilo(btn2, "2. ANOTAR PUNTO\n(CAMINAR A BASE)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 150))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(70, 70, 70))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE (IMPORTANTE: Hazlo parado en el centro de tu base)
local MiBasePos = root.CFrame

-- 1. IR AL BRAINROT (BUSQUEDA POR PROXIMITY)
btn1.MouseButton1Click:Connect(function()
    local target = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (v.Parent.Position - MiBasePos.Position).Magnitude
            if dist > 30 then target = v.Parent break end
        end
    end
    if target then
        root.Velocity = Vector3.new(0,0,0)
        root.CFrame = target.CFrame * CFrame.new(0, 2, 0)
    end
end)

-- 2. ANOTAR PUNTO (TP CERCA + CAMINATA AUTOMÁTICA)
btn2.MouseButton1Click:Connect(function()
    root.Velocity = Vector3.new(0,0,0)
    
    -- PASO 1: Te teletransporta 5 metros AL LADO de tu base (no encima)
    root.CFrame = MiBasePos * CFrame.new(0, 0, 5) 
    task.wait(0.1)
    
    -- PASO 2: Fuerza al personaje a caminar hacia el centro de la base
    hum:MoveTo(MiBasePos.Position)
    
    -- PASO 3: Espera a que llegues caminando para que el sensor se active
    local llegado = false
    hum.MoveToFinished:Connect(function() llegado = true end)
    
    -- Si tarda mucho, forzamos el fin
    task.wait(1) 
    print("Punto entregado")
end)

-- 3. SALTO INFINITO (PARA VOLAR)
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- AUTO-RECOGER (ULTRA RÁPIDO)
task.spawn(function()
    while true do
        task.wait(0.05)
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                if (root.Position - p.Parent.Position).Magnitude < 15 then
                    fireproximityprompt(p)
                end
            end
        end
    end
end)
