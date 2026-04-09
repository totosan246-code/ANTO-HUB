-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_V7" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_V7"
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

Estilo(btn1, "1. IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(180, 0, 0))
Estilo(btn2, "2. ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 150, 255))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(50, 50, 50))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE (PARADO EN EL CENTRO)
local MiBasePos = root.CFrame

-- FUNCIÓN QUE ELIMINA LA VELOCIDAD DE MUERTE
local function ViajeLimpio(objetivo)
    -- 1. Detener movimiento actual
    root.Velocity = Vector3.new(0,0,0)
    root.RotVelocity = Vector3.new(0,0,0)
    
    -- 2. Movimiento rápido pero controlado
    local info = TweenInfo.new(0.6, Enum.EasingStyle.Linear)
    local tw = game:GetService("TweenService"):Create(root, info, {CFrame = objetivo * CFrame.new(0, 1.5, 0)})
    tw:Play()
    tw.Completed:Wait()
    
    -- 3. EL TRUCO FINAL: Resetear el cuerpo antes de tocar el suelo
    root.Anchored = true -- Te congela en el aire 
    root.Velocity = Vector3.new(0,0,0) -- Borra la velocidad de impacto
    task.wait(0.2) -- Tiempo para que el servidor se calme
    root.Anchored = false -- Te suelta
    
    -- 4. Toque suave para anotar
    root.CFrame = objetivo
    hum:ChangeState(Enum.HumanoidStateType.Jumping) -- Salta para activar el sensor
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
    if destino then ViajeLimpio(destino) end
end)

-- 2. MI BASE
btn2.MouseButton1Click:Connect(function()
    ViajeLimpio(MiBasePos)
end)

-- 3. SALTO INFINITO
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
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
