-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_V22" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_V22"
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

Estilo(btn1, "1. TELEPORT BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(200, 0, 0))
Estilo(btn2, "2. TELEPORT MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 120, 255))
Estilo(btn3, "SALTO LARGO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(80, 0, 150))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local MiBasePos = root.CFrame

-- VELOCIDAD DE VIAJE (POTENCIA PURA)
local function ViajeInstantaneo(destino)
    -- Desactivamos colisiones para no morir por el impacto de alta velocidad
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    
    -- Teleport segmentado ultra rápido (Para evitar el Rubberband)
    local dist = (destino.Position - root.Position).Magnitude
    local pasos = 10
    for i = 1, pasos do
        root.CFrame = root.CFrame:Lerp(destino, i/pasos)
        root.AssemblyLinearVelocity = Vector3.new(0,0,0) -- Limpia velocidad para que el server no te jale
        task.wait(0.01)
    end
    
    task.wait(0.1)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    hum.Jump = true
end

-- SALTO LARGO (IMPULSO HACIA ADELANTE)
local SaltoLargoActivo = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoLargoActivo then
        -- Te lanza hacia adelante con mucha fuerza y solo un poco hacia arriba
        root.AssemblyLinearVelocity = root.CFrame.LookVector * 220 + Vector3.new(0, 40, 0)
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
    if destino then ViajeInstantaneo(destino * CFrame.new(0, 3, 0)) end
end)

btn2.MouseButton1Click:Connect(function()
    ViajeInstantaneo(MiBasePos)
end)

btn3.MouseButton1Click:Connect(function()
    SaltoLargoActivo = not SaltoLargoActivo
    btn3.Text = SaltoLargoActivo and "SALTO LARGO: ON" or "SALTO LARGO: OFF"
    btn3.BackgroundColor3 = SaltoLargoActivo and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 0, 150)
end)

-- RECOGER AUTO
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
