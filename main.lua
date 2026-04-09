-- LIMPIEZA PARA EVITAR LAG
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ULTRA_FIX" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ULTRA_FIX"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.5, -90, 0.4, 0)
Frame.Size = UDim2.new(0, 180, 0, 160)
Frame.Active = true
Frame.Draggable = true

local function Estilo(btn, texto, pos, color)
    btn.Parent = Frame
    btn.Text = texto
    btn.Size = UDim2.new(0, 160, 0, 65)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
end

Estilo(btn1, "1. IR AL BRAINROT\n(ENEMIGO)", UDim2.new(0, 10, 0, 10), Color3.fromRGB(200, 0, 0))
Estilo(btn2, "2. IR A MI BASE\n(ANOTAR PUNTO)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 120, 255))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- IMPORTANTE: Ejecuta esto parado justo donde se entregan los puntos
local MiBasePos = root.CFrame

-- 1. IR AL BRAINROT ENEMIGO (MÁS RÁPIDO)
btn1.MouseButton1Click:Connect(function()
    root.Velocity = Vector3.new(0,0,0)
    local target = nil
    local maxDist = 0
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local dist = (v.Parent.Position - MiBasePos.Position).Magnitude
            if dist > maxDist then
                maxDist = dist
                target = v
            end
        end
    end
    
    if target then
        root.CFrame = target.Parent.CFrame * CFrame.new(0, 2, 0)
        task.wait(0.1)
        fireproximityprompt(target)
    end
end)

-- 2. IR A MI BASE Y MOVERSE PARA ANOTAR
btn2.MouseButton1Click:Connect(function()
    root.Velocity = Vector3.new(0,0,0)
    root.CFrame = MiBasePos
    
    -- TRUCO PARA ANOTAR: Movimiento vibratorio para activar el sensor
    local startTick = tick()
    while tick() - startTick < 1.2 do
        root.CFrame = MiBasePos * CFrame.new(math.sin(tick()*20)*1.5, 0, math.cos(tick()*20)*1.5)
        task.wait()
    end
    root.CFrame = MiBasePos
end)

-- AUTO-RECOGER OPTIMIZADO (MENOS LAG)
task.spawn(function()
    while true do
        task.wait(0.2)
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                local dist = (root.Position - prompt.Parent.Position).Magnitude
                if dist < 12 then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end)
