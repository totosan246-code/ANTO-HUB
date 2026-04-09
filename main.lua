-- LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_SUELO_V26" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_SUELO_V26"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

Estilo(btn1, "IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(130, 0, 0))
Estilo(btn2, "ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 80, 130))
Estilo(btn3, "SALTO LARGO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local MiBasePos = root.CFrame

-- MOVIMIENTO PEGADO AL SUELO (EVITA VOLAR)
local function ViajePorTierra(destino)
    -- Bajamos velocidad para que el server lo vea legal
    local velocidadCaminata = 55 
    local dist = (destino.Position - root.Position).Magnitude
    local tiempo = dist / velocidadCaminata

    -- Forzamos que el personaje mire hacia el destino
    root.CFrame = CFrame.new(root.Position, Vector3.new(destino.X, root.Position.Y, destino.Z))

    -- Usamos velocidad constante sin despegar del piso
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(100000, 0, 100000) -- Fuerza CERO en el eje Y (No vuela)
    bv.Velocity = (Vector3.new(destino.X, 0, destino.Z) - Vector3.new(root.Position.X, 0, root.Position.Z)).Unit * velocidadCaminata
    bv.Parent = root

    -- Desactivar colisiones con otros jugadores
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    task.wait(tiempo)
    bv:Destroy()
    
    -- "Clavado" final
    root.Anchored = true
    task.wait(0.5)
    root.Anchored = false

    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    hum.Jump = true
end

-- SALTO LARGO (MODERADO)
local SaltoLargoActivo = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoLargoActivo and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
        -- Salto bajo pero largo
        root.AssemblyLinearVelocity = root.CFrame.LookVector * 65 + Vector3.new(0, 30, 0)
    end
end)

-- BOTONES
btn1.MouseButton1Click:Connect(function()
    local target = nil
    local maxDist = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("deliver")) then
            local d = (v.Position - MiBasePos.Position).Magnitude
            if d > maxDist then maxDist = d; target = v.CFrame end
        end
    end
    if target then ViajePorTierra(target) end
end)

btn2.MouseButton1Click:Connect(function()
    ViajePorTierra(MiBasePos)
end)

btn3.MouseButton1Click:Connect(function()
    SaltoLargoActivo = not SaltoLargoActivo
    btn3.Text = SaltoLargoActivo and "SALTO LARGO: ON" or "SALTO LARGO: OFF"
    btn3.BackgroundColor3 = SaltoLargoActivo and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(60, 60, 60)
end)
