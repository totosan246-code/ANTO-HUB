local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ANTO-HUB 🚀 (FIXED)", "BloodTheme")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- FUNCION PARA BUSCAR EL BRAINROT (Busca nombres parecidos)
local function getBrainrot()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("brain") or obj.Name:lower():find("rot")) then
            return obj
        end
    end
    return nil
end

local Tab1 = Window:NewTab("ROBAR")
local Section1 = Tab1:NewSection("Teleports")

Section1:NewButton("Ir frente al Brainrot", "TP rápido", function()
    local target = getBrainrot()
    if target then
        root.CFrame = target.CFrame * CFrame.new(0, 0, 3)
    else
        print("No se encontró el Brainrot")
    end
end)

Section1:NewButton("Robo Instantaneo (Encima)", "TP directo", function()
    local target = getBrainrot()
    if target then
        root.CFrame = target.CFrame
    end
end)

local Tab2 = Window:NewTab("VENGANZA")
local Section2 = Tab2:NewSection("PVP")

Section2:NewButton("TP al Ladrón (Enemigo)", "Te lleva al que lo tiene", function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            -- Si el enemigo tiene el objeto (generalmente lo llevan en la mano)
            if v.Character:FindFirstChildOfClass("Tool") or v.Character:FindFirstChild("Brainrot") then
                root.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                break
            end
        end
    end
end)

local Tab3 = Window:NewTab("AJUSTES")
local Section3 = Tab3:NewSection("Movimiento")

Section3:NewSlider("Velocidad", "Si te da lag, baja a 50", 250, 16, function(s)
    char.Humanoid.WalkSpeed = s
end)

-- FLOTAR (ESPACIO) - MEJORADO
game:GetService("UserInputService").JumpRequest:Connect(function()
    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
