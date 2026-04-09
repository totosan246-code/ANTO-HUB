-- LIMPIEZA TOTAL DE VERSIONES FALLIDAS
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_MASTER_V18" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_MASTER_V18"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
Estilo(btn2, "2. ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 150, 80))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE AL EJECUTAR
local MiBasePos = root.Position

-- FUNCIÓN DE MOVIMIENTO LEGÍTIMO A ALTA VELOCIDAD
local function ViajePerfecto(destinoPos)
    -- 1. Desactivamos colisiones para que no te trabes con nada
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    -- 2. El TRUCO: Aumentar WalkSpeed al límite justo antes de que el Anti-Cheat actúe
    local speedOriginal = hum.WalkSpeed
    hum.WalkSpeed = 95 -- Velocidad súper rápida pero "procesable" por el server
    
    -- 3. Usamos MoveTo para que el servidor vea que CAMINASTE el trayecto
    hum:MoveTo(destinoPos)
    
    -- Esperamos a que llegue o que esté muy cerca
    while (root.Position - destinoPos).Magnitude > 4 do
        -- Forzamos que no se detenga si algo lo empuja
        hum:MoveTo(destinoPos)
        task.wait(0.05)
    end

    -- 4. Al llegar, frenado y confirmación
    hum.WalkSpeed = speedOriginal
    root.Anchored = true
    task.wait(0.3)
    root.Anchored = false
    
    -- 5. Reactivamos colisiones
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end

    -- 6. Salto para asegurar que el sensor de puntos te detecte
    hum.Jump = true
end

-- BOTÓN 1: BUSCAR BASE ENEMIGA
btn1.MouseButton1Click:Connect(function()
    local destino = nil
    local maxDist = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("deliver")) then
            local d = (v.Position - MiBasePos).Magnitude
            if d > maxDist then
                maxDist = d
                destino = v.Position
            end
        end
    end
    if destino then ViajePerfecto(destino) end
end)

-- BOTÓN 2: VOLVER A MI BASE
btn2.MouseButton1Click:Connect(function()
    ViajePerfecto(MiBasePos)
end)

-- BOTÓN 3: SALTO INFINITO
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- AUTO-RECOGER OBJETOS (Brainrot)
task.spawn(function()
    while true do
        task.wait(0.1)
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                if (root.Position - p.Parent.Position).Magnitude < 20 then
                    fireproximityprompt(p)
                end
            end
        end
    end
end)
