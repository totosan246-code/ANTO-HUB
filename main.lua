-- LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_FIX_V11" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_FIX_V11"
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

Estilo(btn1, "1. IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(150, 0, 0))
Estilo(btn2, "2. ANOTAR (PUNTO FIJO)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 150, 50))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE
local MiBasePos = root.CFrame

-- FUNCIÓN QUE "CLAVA" TU POSICIÓN EN EL SERVIDOR
local function ViajeFijo(objetivo)
    -- 1. Desactivar colisiones
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    -- 2. RESET de físicas
    root.Velocity = Vector3.new(0,0,0)

    -- 3. VIAJE (Un poco más lento para que el server lo acepte mejor: 1.5s)
    local info = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tw = game:GetService("TweenService"):Create(root, info, {CFrame = objetivo * CFrame.new(0, 1, 0)})
    tw:Play()
    tw.Completed:Wait()

    -- 4. EL TRUCO PARA QUE NO TE REGRESE:
    root.Anchored = true 
    task.wait(0.5) -- Espera medio segundo (crucial para el server)
    root.Anchored = false
    
    -- 5. RE-ACTIVAR COLISIONES
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end

    -- 6. DOBLE SALTO DE CONFIRMACIÓN (Esto evita el Rubberband)
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    task.wait(0.2)
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    
    -- Caminar un poquito para asegurar el sensor
    hum:Move(Vector3.new(0, 0, -1), true)
    task.wait(0.1)
    hum:Move(Vector3.new(0, 0, 0), true)
end

-- 1. BASE ENEMIGA
btn1.MouseButton1Click:Connect(function()
    local destino = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("base") or v.Name:lower():find("deliver")) then
            if (v.Position - MiBasePos.Position).Magnitude > 60 then
                destino = v.CFrame
                break
            end
        end
    end
    if destino then ViajeFijo(destino) end
end)

-- 2. MI BASE
btn2.MouseButton1Click:Connect(function()
    ViajeFijo(MiBasePos)
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
