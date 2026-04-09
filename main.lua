-- LIMPIEZA DE SCRIPTS ANTERIORES
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_FINAL_V5" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_FINAL_V5"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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

Estilo(btn1, "1. IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(180, 0, 0))
Estilo(btn2, "2. ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 180))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE (PARADO EN EL CENTRO DE ENTREGA)
local MiBasePos = root.CFrame

-- FUNCIÓN DE MOVIMIENTO INTELIGENTE (NO MÁS MUERTES)
local function ViajeSeguro(objetivo)
    root.Velocity = Vector3.new(0,0,0)
    
    -- Tween con frenado suave (OutQuad)
    -- Esto hace que empieces rápido pero llegues despacio para que el server no te mate
    local info = TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = game:GetService("TweenService"):Create(root, info, {CFrame = objetivo})
    
    tw:Play()
    tw.Completed:Wait()
    
    -- Al llegar, hacemos un pequeño movimiento para asegurar el punto
    task.wait(0.1)
    hum:Move(Vector3.new(0, 0, -1), true)
    root.Velocity = Vector3.new(0, -10, 0) -- Empujón al suelo
end

-- 1. BUSCAR BASE ENEMIGA
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
    
    if destino then
        ViajeSeguro(destino * CFrame.new(0, 2, 0))
    else
        -- Si no encuentra la base, va al oponente
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character then
                ViajeSeguro(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4))
                break
            end
        end
    end
end)

-- 2. VOLVER A MI BASE PARA ANOTAR
btn2.MouseButton1Click:Connect(function()
    ViajeSeguro(MiBasePos)
end)

-- 3. SALTO INFINITO (PARA EVITAR QUE TE PEGUEN)
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- AUTO-RECOGER (SIEMPRE ENCENDIDO)
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
