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
Estilo(btn2, "2. IR A MI BASE\n(ANOTAR)", UDim2.new(0, 10, 0, 90), Color3.fromRGB(0, 120, 255))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- GUARDAR MI BASE AL INICIO (Para no ir a la del enemigo)
local MiBasePos = root.CFrame

-- FUNCIÓN DE TELEPORT SIN ERRORES
local function IrA(posicion)
    root.Velocity = Vector3.new(0,0,0)
    root.CFrame = posicion
    root.Anchored = true -- Te congela para que el server acepte que estás ahí
    task.wait(0.3) -- Tiempo suficiente para que cuente el punto
    root.Anchored = false
end

-- 1. IR AL BRAINROT ENEMIGO
btn1.MouseButton1Click:Connect(function()
    local target = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            -- Solo va si el objeto está lejos de nuestra base (es decir, es del enemigo)
            local distABase = (v.Parent.Position - MiBasePos.Position).Magnitude
            if distABase > 50 then
                target = v.Parent
                break
            end
        end
    end
    
    if target then
        IrA(target.CFrame * CFrame.new(0, 2, 0))
    else
        -- Si no hay objeto con E, busca al jugador enemigo que lo cargue
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if p.Character:FindFirstChildOfClass("Tool") then
                    IrA(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    break
                end
            end
        end
    end
end)

-- 2. IR A MI BASE (LA QUE GUARDAMOS AL EMPEZAR)
btn2.MouseButton1Click:Connect(function()
    IrA(MiBasePos * CFrame.new(0, 2, 0))
end)

-- AUTO-RECOGER (Solo si estás muy cerca, para no abrir tiendas)
game:GetService("RunService").Heartbeat:Connect(function()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local dist = (root.Position - prompt.Parent.Position).Magnitude
            if dist < 12 then -- Solo lo activa si estás pegado al objeto
                fireproximityprompt(prompt)
            end
        end
    end
end)
