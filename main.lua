-- LIMPIEZA DE INTERFAZ
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_GOD_MODE" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_GOD_MODE"
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

Estilo(btn1, "1. IR AL BRAINROT\n(POR EL CIELO)", UDim2.new(0, 10, 0, 10), Color3.fromRGB(180, 0, 0))
Estilo(btn2, "2. ANOTAR PUNTO\n(VUELO SEGURO)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 80, 200))
Estilo(btn3, "SALTO INFINITO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local TweenService = game:GetService("TweenService")

-- GUARDA TU BASE
local MiBasePos = root.CFrame

-- FUNCIÓN PARA VOLAR RÁPIDO Y SEGURO (NADIE TE TOCA)
local function VueloSeguro(objetivo)
    root.Velocity = Vector3.new(0,0,0)
    
    -- Subimos primero para que no nos peguen
    local posicionCielo = root.CFrame * CFrame.new(0, 30, 0)
    root.CFrame = posicionCielo
    task.wait(0.05)
    
    -- Nos movemos por el aire hasta estar encima del objetivo
    local destinoArriba = CFrame.new(objetivo.Position.X, posicionCielo.Position.Y, objetivo.Position.Z)
    local info = TweenInfo.new(1.2, Enum.EasingStyle.Linear)
    local tw = TweenService:Create(root, info, {CFrame = destinoArriba})
    tw:Play()
    tw.Completed:Wait()
    
    -- Bajamos en picada para tocar el suelo y anotar
    root.CFrame = objetivo
    task.wait(0.1)
    hum.Jump = true -- Salto final para asegurar el punto
end

-- 1. IR AL BRAINROT POR ARRIBA
btn1.MouseButton1Click:Connect(function()
    local target = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            if (v.Parent.Position - MiBasePos.Position).Magnitude > 30 then
                target = v.Parent
                break
            end
        end
    end
    if target then
        VueloSeguro(target.CFrame * CFrame.new(0, 2, 0))
    end
end)

-- 2. ANOTAR PUNTO (NADIE TE ALCANZA)
btn2.MouseButton1Click:Connect(function()
    VueloSeguro(MiBasePos)
end)

-- 3. SALTO INFINITO (VOLAR MANUAL)
local SaltoActivo = false
btn3.MouseButton1Click:Connect(function()
    SaltoActivo = not SaltoActivo
    btn3.Text = SaltoActivo and "SALTO INFINITO: ON" or "SALTO INFINITO: OFF"
    btn3.BackgroundColor3 = SaltoActivo and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoActivo then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- AUTO-RECOGER (ULTRA RÁPIDO)
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
