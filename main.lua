-- CREAR INTERFAZ SIMPLE (SIN LIBRERÍAS FALLIDAS)
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local btnRobar = Instance.new("TextButton")
local btnBase = Instance.new("TextButton")
local btnE = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 200, 0, 250)
Frame.Active = true
Frame.Draggable = true

local function Estilo(btn, texto, pos, color)
    btn.Parent = Frame
    btn.Text = texto
    btn.Size = UDim2.new(0, 180, 0, 60)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
end

Estilo(btnRobar, "1. IR AL BRAINROT", UDim2.new(0, 10, 0, 10), Color3.fromRGB(200, 0, 0))
Estilo(btnE, "2. AGARRAR (LETRA E)", UDim2.new(0, 10, 0, 80), Color3.fromRGB(0, 150, 0))
Estilo(btnBase, "3. IR A MI BASE", UDim2.new(0, 10, 0, 150), Color3.fromRGB(0, 0, 200))

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- 1. TELEPORT AL BRAINROT (BUSCANDO EL MODELO)
btnRobar.MouseButton1Click:Connect(function()
    root.Velocity = Vector3.new(0,0,0)
    local encontrado = false
    -- Escanea el mapa buscando el objeto
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:find("Brain") or v.Name == "Object" or v:IsA("ProximityPrompt") then
            local pos = v:IsA("ProximityPrompt") and v.Parent.CFrame or v.CFrame
            root.CFrame = pos * CFrame.new(0, 2, 0)
            encontrado = true
            break
        end
    end
end)

-- 2. PRESIONAR E (INSTANTÁNEO)
btnE.MouseButton1Click:Connect(function()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            fireproximityprompt(prompt)
        end
    end
end)

-- 3. IR A MI BASE (DIRECTO AL SPAWN)
btnBase.MouseButton1Click:Connect(function()
    root.Velocity = Vector3.new(0,0,0)
    -- En Duelos, el spawn es la base. 
    local spawn = player.RespawnLocation
    if spawn then
        root.CFrame = spawn.CFrame * CFrame.new(0, 4, 0)
    else
        -- Si no detecta spawn, busca la parte que se llame 'Goal'
        for _, g in pairs(workspace:GetDescendants()) do
            if g.Name:find("Goal") or g.Name:find("Base") then
                root.CFrame = g.CFrame * CFrame.new(0, 4, 0)
                break
            end
        end
    end
end)
