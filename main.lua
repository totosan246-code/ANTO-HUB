-- LIMPIEZA TOTAL DE INTERFACES
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "ANTO_PVP_FIX" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btn1 = Instance.new("TextButton")
local btn2 = Instance.new("TextButton")
local btn3 = Instance.new("TextButton")

ScreenGui.Name = "ANTO_PVP_FIX"
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
    btn.TextSize = 16
    btn.BorderSizePixel = 2
end

Estilo(btn1, "1. IR AL BRAINROT", UDim2.new(0, 10, 0, 10), Color3.fromRGB(180, 0, 0))
Estilo(btn2, "2. AUTO E (ROBAR)", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 130, 0))
Estilo(btn3, "3. IR A MI BASE", UDim2.new(0, 10, 0, 160), Color3.fromRGB(0, 80, 180))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- FUNCIÓN PARA MOVERSE SIN QUE EL JUEGO TE REGRESE (ANTI-RUBBERBAND)
local function IrA(posicion)
    root.Velocity = Vector3.new(0,0,0)
    -- Pequeño salto antes de ir para "despegar" del suelo
    root.CFrame = root.CFrame * CFrame.new(0, 2, 0)
    task.wait(0.05)
    root.CFrame = posicion
    -- Congelar 0.2 segundos para que el servidor acepte la posición
    root.Anchored = true
    task.wait(0.2)
    root.Anchored = false
end

-- 1. IR AL BRAINROT (BUSCAR LA E DEL OTRO)
btn1.MouseButton1Click:Connect(function()
    local encontrado = false
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            IrA(v.Parent.CFrame * CFrame.new(0, 2, 0))
            encontrado = true
            break
        end
    end
    if not encontrado then
        -- Si el enemigo ya lo tiene
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if p.Character:FindFirstChildOfClass("Tool") then
                    IrA(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                end
            end
        end
    end
end)

-- 2. AUTO E (PRESIONAR AL INSTANTE)
btn2.MouseButton1Click:Connect(function()
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            fireproximityprompt(p)
        end
    end
end)

-- 3. IR A MI BASE (DIRECTO AL SPAWN DEFINIDO)
btn3.MouseButton1Click:Connect(function()
    local spawn = player.RespawnLocation
    if spawn then
        IrA(spawn.CFrame * CFrame.new(0, 4, 0))
    else
        -- Si no hay spawn, busca la zona de entrega lejos del enemigo
        for _, g in pairs(workspace:GetDescendants()) do
            if (g.Name:find("Goal") or g.Name:find("Deliver")) and g:IsA("BasePart") then
                IrA(g.CFrame * CFrame.new(0, 4, 0))
                break
            end
        end
    end
end)
