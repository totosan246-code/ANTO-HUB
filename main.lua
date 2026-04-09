-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_FIX_V4" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_FIX_V4"
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

Estilo(btn1, "1. IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(180, 0, 0))
Estilo(btn2, "2. IR A MI BASE\n(ANOTAR)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 180))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE (IMPORTANTE: Hazlo parado donde se entregan los puntos)
local MiBasePos = root.CFrame

-- FUNCIÓN DE DESLIZAMIENTO POR EL SUELO (PARA NO MORIR)
local function IrSeguro(objetivo)
    root.Velocity = Vector3.new(0,0,0)
    
    -- Nos deslizamos pegados al piso (Y = 3 es la altura del suelo normal)
    local destinoSuelo = CFrame.new(objetivo.Position.X, root.Position.Y, objetivo.Position.Z)
    
    local info = TweenInfo.new(0.6, Enum.EasingStyle.Sine) -- Viaje muy rápido de 0.6 segundos
    local tw = game:GetService("TweenService"):Create(root, info, {CFrame = destinoSuelo})
    tw:Play()
    tw.Completed:Wait()
    
    -- Al llegar, forzamos la posición final para anotar
    root.CFrame = objetivo
    task.wait(0.1)
    hum.Jump = true -- Salto pequeño para activar el sensor
end

-- 1. IR A LA BASE ENEMIGA (CORREGIDO)
btn1.MouseButton1Click:Connect(function()
    local destino = nil
    -- Busca la zona que esté más lejos de tu base inicial
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("spawn") or v.Name:lower():find("deliver")) then
            local dist = (v.Position - MiBasePos.Position).Magnitude
            if dist > 60 then -- Si está a más de 60 studs, es la del enemigo
                destino = v.CFrame
                break
            end
        end
    end
    
    if destino then
        IrSeguro(destino * CFrame.new(0, 2, 0))
    else
        -- Si no encuentra la base, va al jugador enemigo
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character then
                IrSeguro(p.Character.HumanoidRootPart.CFrame)
                break
            end
        end
    end
end)

-- 2. IR A MI BASE
btn2.MouseButton1Click:Connect(function()
    IrSeguro(MiBasePos)
end)

-- 3. SALTO INFINITO
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- AUTO-RECOGER
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
