-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_EXTREMO_V21" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_EXTREMO_V21"
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

Estilo(btn1, "1. BASE ENEMIGA (MAX)", UDim2.new(0, 10, 0, 10), Color3.fromRGB(255, 0, 0))
Estilo(btn2, "2. ANOTAR (INSTANT)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 255))
Estilo(btn3, "SALTO LARGO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(150, 0, 255))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local MiBasePos = root.CFrame

-- FUNCIÓN VELOCIDAD RAYO (250 - SUPER RÁPIDO)
local function ViajeRayo(destino)
    -- Quitamos colisiones para no explotar al chocar
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    -- Usamos un BodyVelocity para potencia máxima
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = (destino.Position - root.Position).Unit * 250 -- VELOCIDAD 250
    bv.Parent = root

    local dist = (destino.Position - root.Position).Magnitude
    task.wait(dist / 250) -- Tiempo de llegada exacto

    bv:Destroy()
    root.Velocity = Vector3.new(0,0,0)
    root.CFrame = destino -- Ajuste final

    task.wait(0.1)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
end

-- SALTO LARGO (DASH DE PODER)
local SaltoLargoActivo = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoLargoActivo then
        -- Te da un impulso hacia adelante y un poco arriba
        root.Velocity = root.CFrame.LookVector * 180 + Vector3.new(0, 45, 0)
        -- Pequeña protección para que el server no te mate por la velocidad del salto
        task.wait(0.1)
        root.Velocity = root.Velocity * 0.8
    end
end)

-- BOTONES
btn1.MouseButton1Click:Connect(function()
    local destino = nil
    local maxDist = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("deliver")) then
            local d = (v.Position - MiBasePos.Position).Magnitude
            if d > maxDist then maxDist = d; destino = v.CFrame end
        end
    end
    if destino then ViajeRayo(destino * CFrame.new(0, 2, 0)) end
end)

btn2.MouseButton1Click:Connect(function()
    ViajeRayo(MiBasePos)
end)

btn3.MouseButton1Click:Connect(function()
    SaltoLargoActivo = not SaltoLargoActivo
    btn3.Text = SaltoLargoActivo and "SALTO LARGO: ON" or "SALTO LARGO: OFF"
    btn3.BackgroundColor3 = SaltoLargoActivo and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 0, 255)
end)

-- AUTO-RECOGER
task.spawn(function()
    while true do
        task.wait(0.1)
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                if (root.Position - p.Parent.Position).Magnitude < 25 then
                    fireproximityprompt(p)
                end
            end
        end
    end
end)
