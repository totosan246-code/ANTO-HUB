-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_GOD_V20" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_GOD_V20"
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
    btn.TextSize = 12
end

Estilo(btn1, "1. BASE ENEMIGA (FLASH)", UDim2.new(0, 10, 0, 10), Color3.fromRGB(200, 0, 0))
Estilo(btn2, "2. ANOTAR (NO REGRESO)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 120, 255))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(80, 80, 80))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local MiBasePos = root.Position

-- FUNCIÓN VELOCIDAD MÁXIMA (135 - LÍMITE ABSOLUTO)
local function ViajeVeloz(destinoPos)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    local speedOriginal = hum.WalkSpeed
    hum.WalkSpeed = 135 -- VELOCIDAD EXTREMA
    
    hum:MoveTo(destinoPos)
    
    local start = tick()
    while (root.Position - destinoPos).Magnitude > 5 and tick() - start < 8 do
        hum:MoveTo(destinoPos)
        -- Mini-salto durante el viaje para que el server no te trabe
        if math.random(1,20) == 10 then hum.Jump = true end 
        task.wait(0.02)
    end

    hum.WalkSpeed = speedOriginal
    -- Anclaje ultra corto para confirmar posición sin que te maten
    root.Anchored = true
    task.wait(0.15)
    root.Anchored = false
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    hum.Jump = true
end

-- SALTO INFINITO ANTI-MUERTE
local SaltoActivo = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then
        -- En lugar de volar, forzamos un estado de salto constante
        -- Esto evita que el server detecte "FlyHack"
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
    end
end)

-- BOTONES
btn1.MouseButton1Click:Connect(function()
    local destino = nil
    local maxDist = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("deliver")) then
            local d = (v.Position - MiBasePos).Magnitude
            if d > maxDist then maxDist = d; destino = v.Position end
        end
    end
    if destino then ViajeVeloz(destino) end
end)

btn2.MouseButton1Click:Connect(function()
    ViajeVeloz(MiBasePos)
end)

btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
end)

-- AUTO-RECOGER (RANGO MÁXIMO)
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
