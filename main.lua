-- LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_PERFECT_V23" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_PERFECT_V23"
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

Estilo(btn1, "IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(180, 0, 0))
Estilo(btn2, "ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 200))
Estilo(btn3, "SALTO LARGO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(100, 0, 150))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local MiBasePos = root.CFrame

-- VIAJE FLUIDO (VELOCIDAD REVISADA PARA NO MORIR)
local function ViajeSeguro(destino)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    
    -- Movimiento fluido en 0.8 segundos (Velocidad ideal)
    local info = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tw = game:GetService("TweenService"):Create(root, info, {CFrame = destino * CFrame.new(0, 2, 0)})
    tw:Play()
    tw.Completed:Wait()
    
    root.Velocity = Vector3.new(0,0,0)
    task.wait(0.1)
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    hum.Jump = true
end

-- SALTO LARGO (DASH EQUILIBRADO)
local SaltoLargoActivo = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoLargoActivo and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
        -- Impulso de 130: Largo pero el server lo acepta bien
        root.AssemblyLinearVelocity = root.CFrame.LookVector * 130 + Vector3.new(0, 45, 0)
    end
end)

-- BOTONES
btn1.MouseButton1Click:Connect(function()
    local destino = nil
    local distMax = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("deliver")) then
            local d = (v.Position - MiBasePos.Position).Magnitude
            if d > distMax then distMax = d; destino = v.CFrame end
        end
    end
    if destino then ViajeSeguro(destino) end
end)

btn2.MouseButton1Click:Connect(function()
    ViajeSeguro(MiBasePos)
end)

btn3.MouseButton1Click:Connect(function()
    SaltoLargoActivo = not SaltoLargoActivo
    btn3.Text = SaltoLargoActivo and "SALTO LARGO: ON" or "SALTO LARGO: OFF"
    btn3.BackgroundColor3 = SaltoLargoActivo and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(100, 0, 150)
end)

-- AUTO-RECOGER
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
