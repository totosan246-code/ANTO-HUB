-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_WINNER" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_WINNER"
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

Estilo(btn1, "1. IR AL BRAINROT", UDim2.new(0, 10, 0, 10), Color3.fromRGB(180, 0, 0))
Estilo(btn2, "2. CORRER A BASE\n(ANOTAR)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 80, 200))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUARDA TU BASE (PARADO EN EL CENTRO)
local MiBasePos = root.CFrame

-- 1. IR AL BRAINROT (TELEPORT CORTO PARA QUE NO HAGA ROLLBACK)
btn1.MouseButton1Click:Connect(function()
    local target = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if (v.Parent.Position - MiBasePos.Position).Magnitude > 30 then
                target = v.Parent
                break
            end
        end
    end
    if target then
        -- Teleport más cerca, no encima, para que no salte el anti-cheat
        root.CFrame = target.CFrame * CFrame.new(0, 0, 3)
    end
end)

-- 2. CORRER A BASE (EL MÉTODO QUE SÍ ANOTA)
btn2.MouseButton1Click:Connect(function()
    -- Subimos la velocidad al máximo permitido para que sea "caminar rápido"
    hum.WalkSpeed = 100 
    -- MoveTo es detectado como movimiento legítimo por el servidor
    hum:MoveTo(MiBasePos.Position)
    -- El servidor no te regresará porque no es un teleport, es una caminata rápida
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
        task.wait(0.05)
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                if (root.Position - p.Parent.Position).Magnitude < 15 then
                    fireproximityprompt(p)
                end
            end
        end
    end
end)
