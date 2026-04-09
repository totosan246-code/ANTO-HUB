-- LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_CONTROL_V25" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_CONTROL_V25"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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

Estilo(btn1, "IR A BASE ENEMIGA", UDim2.new(0, 10, 0, 10), Color3.fromRGB(130, 0, 0))
Estilo(btn2, "ANOTAR EN MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 80, 130))
Estilo(btn3, "SALTO LARGO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(60, 60, 60))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local MiBasePos = root.CFrame

-- VIAJE SUAVE Y SEGURO (2.5 segundos para evitar que el server te regrese)
local function ViajeSuave(destino)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    
    -- Movimiento moderado (2.5 segundos es perfecto para estabilidad)
    local tw = game:GetService("TweenService"):Create(root, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {CFrame = destino * CFrame.new(0, 2, 0)})
    tw:Play()
    tw.Completed:Wait()
    
    -- EL "CLAVO": Anclamos 0.7 segundos para asegurar la posición en el server
    root.Anchored = true
    root.Velocity = Vector3.new(0,0,0)
    task.wait(0.7) 
    root.Anchored = false
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    
    hum.Jump = true
end

-- SALTO LARGO SUAVE (Potencia de 70 - Impulso natural)
local SaltoLargoActivo = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoLargoActivo and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
        -- Un impulso de 70 es como una carrera rápida, muy difícil de detectar
        root.AssemblyLinearVelocity = root.CFrame.LookVector * 70 + Vector3.new(0, 35, 0)
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
    if destino then ViajeSuave(destino) end
end)

btn2.MouseButton1Click:Connect(function()
    ViajeSuave(MiBasePos)
end)

btn3.MouseButton1Click:Connect(function()
    SaltoLargoActivo = not SaltoLargoActivo
    btn3.Text = SaltoLargoActivo and "SALTO LARGO: ON" or "SALTO LARGO: OFF"
    btn3.BackgroundColor3 = SaltoLargoActivo and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(60, 60, 60)
end)

-- AUTO-RECOGER (Distancia moderada)
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
