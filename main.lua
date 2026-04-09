-- LIMPIEZA DE INTERFAZ
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_SAFE_GOD" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")
local btn4 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_SAFE_GOD"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.Position = UDim2.new(0.5, -90, 0.25, 0)
Frame.Size = UDim2.new(0, 180, 0, 310) -- Un poco más largo para el nuevo botón
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

-- BOTONES
Estilo(btn1, "1. IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(150, 0, 0))
Estilo(btn2, "2. ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 200))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(70, 70, 70))
Estilo(btn4, "IR AL BRAINROT (SOLO)", UDim2.new(0, 10, 0, 235), Color3.fromRGB(100, 0, 150))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local TweenService = game:GetService("TweenService")

-- GUARDA TU BASE (Ejecuta parado en tu zona de entrega)
local MiBasePos = root.CFrame

-- FUNCIÓN DE VUELO SEGURO (ALTURA AJUSTADA PARA NO MORIR)
local function VueloSeguro(objetivo)
    root.Velocity = Vector3.new(0,0,0)
    
    -- ALTURA SEGURA: 12 metros (evita la Kill-Zone y los bates)
    local posicionCielo = root.CFrame * CFrame.new(0, 12, 0)
    root.CFrame = posicionCielo
    task.wait(0.05)
    
    -- Movimiento horizontal
    local destinoArriba = CFrame.new(objetivo.Position.X, posicionCielo.Position.Y, objetivo.Position.Z)
    local info = TweenInfo.new(1, Enum.EasingStyle.Linear) -- 1 segundo de viaje
    local tw = TweenService:Create(root, info, {CFrame = destinoArriba})
    tw:Play()
    tw.Completed:Wait()
    
    -- Bajada rápida para anotar
    root.CFrame = objetivo
    task.wait(0.1)
    hum.Jump = true 
end

-- 1. IR A LA BASE ENEMIGA (BUSCA LA OTRA BASE)
btn1.MouseButton1Click:Connect(function()
    local baseEnemiga = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if (v.Name:find("Goal") or v.Name:find("Base") or v.Name:find("Deliver")) and v:IsA("BasePart") then
            if (v.Position - MiBasePos.Position).Magnitude > 50 then
                baseEnemiga = v.CFrame
                break
            end
        end
    end
    if baseEnemiga then
        VueloSeguro(baseEnemiga * CFrame.new(0, 3, 0))
    else
        -- Si no encuentra la base por nombre, busca al enemigo y va a él
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                VueloSeguro(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                break
            end
        end
    end
end)

-- 2. ANOTAR EN MI BASE
btn2.MouseButton1Click:Connect(function()
    VueloSeguro(MiBasePos)
end)

-- 3. SALTO INFINITO
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- 4. IR AL BRAINROT DIRECTO (POR SI ESTÁ SUELTO)
btn4.MouseButton1Click:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            VueloSeguro(v.Parent.CFrame * CFrame.new(0, 2, 0))
            break
        end
    end
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
