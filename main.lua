-- ANTO-HUB V2: ANTI-LAG & AUTO-STEAL
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local hum = character:WaitForChild("Humanoid")

-- CONFIGURACIÓN
local rangoAtaque = 15
local velocidadVuelo = 50

-- 1. TELEPORT AL BRAINROT (PARA ROBAR)
-- El script busca objetos que se llamen "Brainrot" en el mapa
local function irPorBrainrot()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name == "Brainrot" and obj:IsA("BasePart") then
            -- Te lleva justo encima del Brainrot para cogerlo
            root.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
            break
        end
    end
end

-- 2. KILL AURA + TP AL ENEMIGO (Si tienes el arma en mano)
task.spawn(function()
    while task.wait(0.1) do
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            for _, enemigo in pairs(game.Players:GetPlayers()) do
                if enemigo ~= player and enemigo.Character and enemigo.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (root.Position - enemigo.Character.HumanoidRootPart.Position).Magnitude
                    if dist < rangoAtaque then
                        -- Te pega al enemigo para que no falle el bate
                        root.CFrame = enemigo.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                        tool:Activate()
                        -- Daño directo
                        if tool:FindFirstChild("Handle") then
                            firetouchinterest(enemigo.Character.Head, tool.Handle, 0)
                            firetouchinterest(enemigo.Character.Head, tool.Handle, 1)
                        end
                    end
                end
            end
        end
    end
end)

-- 3. FLOTAR (Mantener Espacio)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        local bV = Instance.new("BodyVelocity", root)
        bV.Velocity = Vector3.new(0, velocidadVuelo, 0)
        bV.MaxForce = Vector3.new(0, math.huge, 0)
        bV.Name = "FloatForce"
        
        repeat task.wait() until not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space)
        if root:FindFirstChild("FloatForce") then root.FloatForce:Destroy() end
    end
end)

-- 4. ANTI-GOLPE (No te caes)
hum.StateChanged:Connect(function(_, nuevoEstado)
    if nuevoEstado == Enum.HumanoidStateType.FallingDown or nuevoEstado == Enum.HumanoidStateType.PlatformStanding then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end)

-- TECLA PARA IR AL BRAINROT (Presiona "Q" o un botón en pantalla)
-- Como estás en móvil con Delta, te he puesto este comando para que lo actives:
print("ANTO-HUB: Presiona el botón de 'Robar' en tu menú")

-- Función para que lo actives cuando quieras
_G.RobarAhora = irPorBrainrot
