local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NEW DUELOS V1.1 🔴", "BloodTheme")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local Tab = Window:NewTab("MODO DUELOS")
local Section = Tab:NewSection("Controles de Victoria")

-- 1. TELEPORT AL BRAINROT (BUSQUEDA AGRESIVA)
Section:NewButton("1. IR AL BRAINROT", "Te lleva frente al objetivo", function()
    root.Velocity = Vector3.new(0,0,0)
    local encontrado = false
    
    -- Busca cualquier letra E en el mapa
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            root.CFrame = obj.Parent.CFrame * CFrame.new(0, 2, 0)
            encontrado = true
            break
        end
    end
    
    -- Si no hay E, busca cualquier objeto que se mueva (el Brainrot que lleva el otro)
    if not encontrado then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                -- Si el enemigo tiene una herramienta (el brainrot)
                if p.Character:FindFirstChildOfClass("Tool") then
                    root.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end
end)

-- 2. ROBAR AHORA (PRESIONAR E)
Section:NewButton("2. ROBAR (PRESIONAR E)", "Presiona la letra E instantáneo", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            fireproximityprompt(obj) -- Fuerza la letra E
        end
    end
end)

-- 3. IR A MI BASE (PUNTO)
Section:NewButton("3. IR A MI BASE", "Vuelve al spawn para anotar", function()
    root.Velocity = Vector3.new(0,0,0)
    -- Teleport al SpawnPoint del jugador
    local spawn = player.RespawnLocation
    if spawn then
        root.CFrame = spawn.CFrame * CFrame.new(0, 4, 0)
    else
        -- Si no hay spawn, busca la zona de entrega
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:find("Goal") or v.Name:find("Base") then
                root.CFrame = v.CFrame * CFrame.new(0, 4, 0)
                break
            end
        end
    end
end)

-- EXTRA PARA QUE NO TE MATEN
local Section2 = Tab:NewSection("Ajustes")
Section2:NewSlider("VELOCIDAD", "Corre mas", 150, 16, function(s)
    char.Humanoid.WalkSpeed = s
end)
