-- LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_INMORTAL_V15" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_INMORTAL_V15"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
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

Estilo(btn1, "1. IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(200, 0, 0))
Estilo(btn2, "2. ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 200))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(50, 50, 50))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE DONDE ESTÉS PARADO
local MiBasePos = root.CFrame

-- FUNCIÓN DE MOVIMIENTO LEGAL (EVITA EL KILL-SCRIPT)
local function ViajeLegal(objetivo)
    -- 1. Desactivamos colisiones para no morir por impacto
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    -- 2. En lugar de Tween, usamos un BodyVelocity (Fuerza Física)
    -- Esto hace que el personaje "vuela" pero para el juego está "corriendo"
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(100000, 100000, 100000)
    bv.Velocity = (objetivo.Position - root.Position).Unit * 80 -- Velocidad de 80 (Rápida pero segura)
    bv.Parent = root

    -- Esperamos a llegar (calculando la distancia)
    local distancia = (objetivo.Position - root.Position).Magnitude
    task.wait(distancia / 80)

    -- 3. Frenado suave
    bv:Destroy()
    root.Velocity = Vector3.new(0,0,0)
    root.CFrame = objetivo -- Ajuste final milimétrico

    -- 4. Reactivar físicas
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    
    -- Salto de confirmación
    hum.Jump = true
end

-- 1. BASE ENEMIGA (POR DISTANCIA)
btn1.MouseButton1Click:Connect(function()
    local destino = nil
    local distMax = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("deliver")) then
            local d = (v.Position - MiBasePos.Position).Magnitude
            if d > distMax then
                distMax = d
                destino = v.CFrame
            end
        end
    end
    if destino then ViajeLegal(destino * CFrame.new(0, 2, 0)) end
end)

-- 2. MI BASE
btn2.MouseButton1Click:Connect(function()
    ViajeLegal(MiBasePos)
end)

-- 3. SALTO INFINITO
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 50)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- RECOGER AUTO
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
