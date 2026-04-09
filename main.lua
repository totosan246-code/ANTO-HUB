-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_GOD_V17" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_GOD_V17"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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

Estilo(btn1, "1. IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(150, 0, 0))
Estilo(btn2, "2. ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 200))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(40, 40, 40))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- DETECTA TU BASE AUTOMÁTICAMENTE AL INICIO
local MiBasePos = root.CFrame

-- FUNCIÓN DEFINITIVA: CAMINATA FORZADA
local function CorrerDuro(objetivo)
    -- 1. No morirse por el camino (Quitar colisiones temporales)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    -- 2. El truco: Caminar a súper velocidad (85 es el límite seguro)
    local tiempoCaminata = (objetivo.Position - root.Position).Magnitude / 85
    
    -- Usamos un BodyPosition para arrastrarte al suelo, no al aire
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1000000, 0, 1000000) -- Solo fuerza horizontal
    bp.P = 15000
    bp.D = 800
    bp.Position = objetivo.Position
    bp.Parent = root

    -- Mientras corre, forzamos a que esté en el suelo
    local start = tick()
    while tick() - start < tiempoCaminata do
        root.Velocity = Vector3.new(root.Velocity.X, -20, root.Velocity.Z)
        task.wait()
    end

    -- 3. Llegada y fijación
    bp:Destroy()
    root.Anchored = true
    task.wait(0.3)
    root.Anchored = false
    
    -- 4. Reset colisiones y confirmar punto
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
end

-- LÓGICA DE BOTONES
btn1.MouseButton1Click:Connect(function()
    local destino = nil
    local distMax = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("deliver")) then
            local d = (v.Position - MiBasePos.Position).Magnitude
            if d > distMax then distMax = d; destino = v.CFrame end
        end
    end
    if destino then CorrerDuro(destino) end
end)

btn2.MouseButton1Click:Connect(function()
    CorrerDuro(MiBasePos)
end)

-- SALTO INFINITO
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 40)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- AUTO-PICKUP
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
