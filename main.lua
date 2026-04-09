-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_ALPHA_V19" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_ALPHA_V19"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
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
Estilo(btn2, "2. ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 120, 255))
Estilo(btn3, "SALTO LARGO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(100, 0, 200))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local MiBasePos = root.Position

-- FUNCIÓN DE VIAJE ULTRA RÁPIDO (LÍMITE 115)
local function ViajeAlpha(destinoPos)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    local speedOriginal = hum.WalkSpeed
    hum.WalkSpeed = 115 -- VELOCIDAD MÁXIMA SEGURA
    
    hum:MoveTo(destinoPos)
    
    local timeout = 0
    while (root.Position - destinoPos).Magnitude > 4 and timeout < 100 do
        hum:MoveTo(destinoPos)
        task.wait(0.05)
        timeout = timeout + 1
    end

    hum.WalkSpeed = speedOriginal
    root.Anchored = true
    task.wait(0.2) -- Frenado más rápido
    root.Anchored = false
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    hum.Jump = true
end

-- LÓGICA DE SALTO LARGO (IMPULSO)
local SaltoLargoActivo = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoLargoActivo then
        -- Nos aseguramos de que solo lo haga si está en el suelo o saltando
        if hum:GetState() ~= Enum.HumanoidStateType.Freefall then
            root:ApplyImpulse(root.CFrame.LookVector * 150 + Vector3.new(0, 50, 0))
        end
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
    if destino then ViajeAlpha(destino) end
end)

btn2.MouseButton1Click:Connect(function()
    ViajeAlpha(MiBasePos)
end)

btn3.MouseButton1Click:Connect(function()
    SaltoLargoActivo = not SaltoLargoActivo
    btn3.Text = SaltoLargoActivo and "SALTO LARGO: ON" or "SALTO LARGO: OFF"
    btn3.BackgroundColor3 = SaltoLargoActivo and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 0, 200)
end)

-- AUTO-RECOGER
task.spawn(function()
    while true do
        task.wait(0.1)
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                if (root.Position - p.Parent.Position).Magnitude < 22 then
                    fireproximityprompt(p)
                end
            end
        end
    end
end)
