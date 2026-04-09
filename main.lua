-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_FINAL_V13" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_FINAL_V13"
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

Estilo(btn1, "1. IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(150, 0, 0))
Estilo(btn2, "2. ANOTAR (PUNTO REAL)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 180, 50))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE
local MiBasePos = root.CFrame

-- FUNCIÓN DE CAMINATA ULTRA RÁPIDA (SOLUCIONA EL BUGEO)
local function ViajeSinBugeo(objetivo)
    -- 1. Quitar colisiones con jugadores para que no te traben
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    -- 2. Limpiar velocidades
    root.Velocity = Vector3.new(0,0,0)

    -- 3. MODO CAMINATA FORZADA (Divide el trayecto en 10 partes para que el server lo vea legal)
    local pasos = 10
    for i = 1, pasos do
        local meta = root.CFrame:Lerp(objetivo, i/pasos)
        
        -- Usamos Tween corto pero PEGADO al suelo
        local tw = game:GetService("TweenService"):Create(root, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {CFrame = meta})
        tw:Play()
        tw.Completed:Wait()
        
        -- "Pisar" el suelo para el servidor
        root.Velocity = Vector3.new(0, -50, 0) 
        task.wait(0.02)
    end

    -- 4. CONFIRMACIÓN FINAL
    root.Anchored = true
    task.wait(0.5) -- Pausa necesaria para que el servidor guarde tu posición
    root.Anchored = false
    
    -- 5. RE-ACTIVAR FÍSICAS
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end

    -- 6. FORZAR PUNTO (Doble salto y caminata corta)
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    task.wait(0.1)
    hum:Move(Vector3.new(0,0,1), true)
    task.wait(0.1)
    hum:Move(Vector3.new(0,0,0), true)
end

-- 1. BASE ENEMIGA
btn1.MouseButton1Click:Connect(function()
    local destino = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("base")) then
            if (v.Position - MiBasePos.Position).Magnitude > 60 then
                destino = v.CFrame
                break
            end
        end
    end
    if destino then ViajeSinBugeo(destino) end
end)

-- 2. MI BASE
btn2.MouseButton1Click:Connect(function()
    ViajeSinBugeo(MiBasePos)
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
