-- LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_CAMINANTE_V27" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_CAMINANTE_V27"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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

Estilo(btn1, "CAMINAR A ENEMIGO", UDim2.new(0, 10, 0, 10), Color3.fromRGB(130, 0, 0))
Estilo(btn2, "CAMINAR A MI BASE", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 100, 180))
Estilo(btn3, "SALTO LARGO: OFF", UDim2.new(0, 10, 0, 160), Color3.fromRGB(70, 70, 70))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local MiBasePos = root.Position

-- FUNCIÓN DE CAMINAR DE VERDAD (NO FLOTA)
local function CaminarADestino(targetPos)
    local originalSpeed = hum.WalkSpeed
    hum.WalkSpeed = 45 -- Velocidad rápida pero con animación de caminar
    
    local llegando = false
    while not llegando do
        local distancia = (root.Position - targetPos).Magnitude
        if distancia > 4 then
            -- Esto hace que el personaje camine hacia el punto usando el sistema del juego
            hum:MoveTo(targetPos) 
        else
            llegando = true
        end
        task.wait(0.1)
    end
    
    hum.WalkSpeed = originalSpeed
    hum:Move(Vector3.new(0,0,0)) -- Detenerse
    
    -- Pequeña pausa de seguridad para que el servidor registre que llegaste caminando
    root.Anchored = true
    task.wait(0.5)
    root.Anchored = false
    hum.Jump = true
end

-- SALTO LARGO (MODERADO)
local SaltoLargoActivo = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if SaltoLargoActivo and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
        -- Un impulso corto para no activar el detector de vuelo
        root.AssemblyLinearVelocity = root.CFrame.LookVector * 60 + Vector3.new(0, 30, 0)
    end
end)

-- BOTONES
btn1.MouseButton1Click:Connect(function()
    local target = nil
    local maxDist = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("goal") or v.Name:lower():find("deliver")) then
            local d = (v.Position - MiBasePos).Magnitude
