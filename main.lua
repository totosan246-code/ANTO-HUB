-- LIMPIEZA DE INTERFAZ
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_FINAL_V14" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_FINAL_V14"
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

Estilo(btn1, "1. IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(180, 0, 0))
Estilo(btn2, "2. ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 120, 255))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- DETECCIÓN AUTOMÁTICA DE TU LADO ACTUAL
-- El script guarda la posición de donde estás parado AHORA mismo como "Mi Base"
local MiBasePos = root.CFrame

local function ViajeDefinitivo(objetivo)
    -- 1. Seguridad: Desactivar colisiones y limpiar fuerzas
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    root.Velocity = Vector3.new(0,0,0)
    root.RotVelocity = Vector3.new(0,0,0)

    -- 2. Movimiento en 8 micro-etapas (Anti-Regreso y Anti-Muerte)
    local etapas = 8
    for i = 1, etapas do
        local meta = root.CFrame:Lerp(objetivo * CFrame.new(0, 0.5, 0), i/etapas)
        local tw = game:GetService("TweenService"):Create(root, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = meta})
        tw:Play()
        tw.Completed:Wait()
        -- Pequeño pulso para confirmar posición al server
        task.wait(0.02)
    end

    -- 3. Frenado en seco antes de tocar suelo
    root.Anchored = true
    root.Velocity = Vector3.new(0,0,0)
    task.wait(0.4) 
    root.Anchored = false
    
    -- 4. Reactivar personaje
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end

    -- 5. Forzar la anotación del punto
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    task.wait(0.1)
    root.CFrame = objetivo
end

-- 1. LÓGICA PARA IR A LA BASE DEL FRENTE (NO IMPORTA EL LADO)
btn1.MouseButton1Click:Connect(function()
    local destinoEnemigo = nil
    local mayorDistancia = 0
    
    -- Buscamos el punto de entrega más lejano (esa es la base enemiga)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("deliver") or v.Name:lower():find("spawn")) then
            local distancia = (v.Position - MiBasePos.Position).Magnitude
            if distancia > mayorDistancia then
                mayorDistancia = distancia
                destinoEnemigo = v.CFrame
            end
        end
    end
    
    if destinoEnemigo then
        ViajeDefinitivo(destinoEnemigo * CFrame.new(0, 2, 0))
    else
        -- Si no encuentra la base, va al oponente más lejano
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                ViajeDefinitivo(p.Character.HumanoidRootPart.CFrame)
                break
            end
        end
    end
end)

-- 2. VOLVER A MI LADO ACTUAL
btn2.MouseButton1Click:Connect(function()
    ViajeDefinitivo(MiBasePos)
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

-- RECOGER AUTOMÁTICO
task.spawn(function()
    while true do
        task.wait(0.1)
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                if (root.Position - p.Parent.Position).Magnitude < 18 then
                    fireproximityprompt(p)
                end
            end
        end
    end
end)
