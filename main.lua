local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ANTO-HUB 🚀 (MODO DUELOS)", "BloodTheme")

-- PESTAÑA DE ROBO
local Tab1 = Window:NewTab("Robo Instantáneo")
local Section1 = Tab1:NewSection("Teleports de Objetos")

Section1:NewButton("Ir frente al Brainrot", "Te pone cara a cara con el objetivo", function()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if (obj.Name == "Brainrot" or obj:FindFirstChild("Brainrot")) and obj:IsA("BasePart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame * CFrame.new(0, 0, -3)
            break
        end
    end
end)

Section1:NewButton("Robo Instantáneo", "TP + Coger", function()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if (obj.Name == "Brainrot") and obj:IsA("BasePart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
            -- Intenta activar la herramienta si la tienes
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            break
        end
    end
end)

Section1:NewButton("Ir a mi Base (Entrega)", "Vuelve rápido para ganar", function()
    -- Este busca el Spawn de tu equipo
    local player = game.Players.LocalPlayer
    local spawn = player.RespawnLocation
    if spawn then
        player.Character.HumanoidRootPart.CFrame = spawn.CFrame * CFrame.new(0, 3, 0)
    else
        -- Si no hay spawn, intenta buscar una zona llamada 'Base' o 'Delivery'
        print("Buscando zona de entrega...")
    end
end)

-- PESTAÑA DE PVP AGRESIVO
local Tab2 = Window:NewTab("PVP Agresivo")
local Section2 = Tab2:NewSection("Venganza")

Section2:NewButton("TP al Ladrón (Enemigo)", "Te lleva frente al que tiene el Brainrot", function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            -- Si el enemigo tiene algo llamado Brainrot en su mano o espalda
            if v.Character:FindFirstChild("Brainrot") or v.Character:FindFirstChildOfClass("Tool") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                break
            end
        end
    end
end)

-- VELOCIDAD SIN LAG
local Tab3 = Window:NewTab("Ajustes")
local Section3 = Tab3:NewSection("Movimiento")

Section3:NewSlider("Velocidad Pro (Sin Lag)", "Aumenta poco a poco", 200, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- FLOTAR (ESPACIO) - Siempre activo
game:GetService("UserInputService").JumpRequest:Connect(function()
    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
end)
