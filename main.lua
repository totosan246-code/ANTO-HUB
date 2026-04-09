-- LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_PVP_ULTRA" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_PVP_ULTRA"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.Position = UDim2.new(0.5, -90, 0.4, 0)
Frame.Size = UDim2.new(0, 180, 0, 160)
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
    btn.TextSize = 14
    btn.BorderSizePixel = 0
end

Estilo(btn1, "1. IR AL BRAINROT\n(ENEMIGO)", UDim2.new(0, 10, 0, 10), Color3.fromRGB(200, 0, 0))
Estilo(btn2, "2. IR A MI BASE\n(ENTREGAR)", UDim2.new(0, 10, 0, 90), Color3.fromRGB(0, 120, 255))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- IMPORTANTE: Ejecuta esto parado en el centro de tu base
local MiBasePos = root.CFrame

-- FUNCIÓN DE MOVIMIENTO FORZADO (SIN REGRESO)
local function IrA(posicion, espera)
    root.Velocity = Vector3.new(0,0,0)
    -- Teleport instantáneo
    root.CFrame = posicion
    -- Congelamos al personaje para que el server registre la posición
    root.Anchored = true
    task.wait(espera) -- Espera larga para que el punto cuente
    root.Anchored = false
    -- Pequeño impulso hacia abajo para asegurar contacto con la base
    root.Velocity = Vector3.new(0, -10, 0)
end

-- 1. BUSCAR EL BRAINROT CORRECTO (EL MÁS LEJANO)
btn1.MouseButton1Click:Connect(function()
    local target = nil
    local maxDist = 0
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Parent:IsA("BasePart") then
            local dist = (v.Parent.Position - MiBasePos.Position).Magnitude
            -- Si es el objeto más lejano de nuestra base, es el del enemigo
            if dist > maxDist then
                maxDist = dist
                target = v
            end
        end
    end
    
    if target then
        IrA(target.Parent.CFrame * CFrame.new(0, 3, 0), 0.3)
        fireproximityprompt(target)
    else
        -- Si no hay objeto suelto, busca al enemigo
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if p.Character:FindFirstChildOfClass("Tool") then
                    IrA(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3), 0.3)
                    break
                end
            end
        end
    end
end)

-- 2. IR A MI BASE Y ENTREGAR (TIEMPO EXTRA)
btn2.MouseButton1Click:Connect(function()
    -- Te deja 1 segundo entero anclado para que el punto suba sí o sí
    IrA(MiBasePos, 1.2) 
end)

-- AUTO-RECOGER SIEMPRE ACTIVO (Detección muy corta para no buguear)
game:GetService("RunService").Heartbeat:Connect(function()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local dist = (root.Position - prompt.Parent.Position).Magnitude
            if dist < 10 then
                fireproximityprompt(prompt)
            end
        end
    end
end)
