local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NEW DUELOS V1.1 🔴",
   LoadingTitle = "CARGANDO SISTEMA DE ROBO...",
   LoadingSubtitle = "by Anto",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- 🔍 BUSCADOR AVANZADO DE BRAINROT
local function findBrainrot()
    for _, v in pairs(workspace:GetDescendants()) do
        -- Busca cualquier objeto que tenga "Brain" en el nombre o que sea el objetivo del juego
        if v:IsA("BasePart") and (v.Name:find("Brain") or v:FindFirstChild("TouchInterest") or v.Name == "Object") then
            -- Verificamos que no sea una parte del mapa común
            if v.Parent:IsA("Model") or v.Size.Magnitude < 10 then 
                return v
            end
        end
    end
    return nil
end

local Tab = Window:CreateTab("AUTOFARM", 4483362458)

-- 1. TELEPORT AL BRAINROT (Corregido)
Tab:CreateButton({
   Name = "TELEPORT AL BRAINROT",
   Callback = function()
       local target = findBrainrot()
       if target then
           root.Velocity = Vector3.new(0,0,0)
           root.CFrame = target.CFrame * CFrame.new(0, 2, 0)
       else
           Rayfield:Notify({Title = "Error", Content = "No se vio el Brainrot en el mapa", Duration = 2})
       end
   end,
})

-- 2. AUTO GRAB (LO ROBA POR TI)
Tab:CreateToggle({
   Name = "AUTO GRAB (RECOGER)",
   CurrentValue = false,
   Flag = "AutoGrab",
   Callback = function(Value)
       _G.AutoGrab = Value
       while _G.AutoGrab do
           task.wait(0.1)
           local target = findBrainrot()
           if target then
               local dist = (root.Position - target.Position).Magnitude
               if dist < 10 then
                   -- Intenta tocarlo y activar la herramienta
                   firetouchinterest(root, target, 0)
                   firetouchinterest(root, target, 1)
                   local tool = char:FindFirstChildOfClass("Tool")
                   if tool then tool:Activate() end
               end
           end
       end
   end,
})

-- 3. IR A MI BASE AUTOMÁTICO (CORREGIDO)
Tab:CreateButton({
   Name = "IR A MI BASE (INSTANT)",
   Callback = function()
       -- Busca tu zona de entrega por color o por nombre de tu equipo
       local base = workspace:FindFirstChild(player.TeamColor.Name .. " Base") or workspace:FindFirstChild("Base" .. player.Name)
       
       if not base then
           -- Si no encuentra base por nombre, busca el Spawn directo
           base = player.RespawnLocation
       end

       if base then
           root.Velocity = Vector3.new(0,0,0)
           root.CFrame = base.CFrame * CFrame.new(0, 5, 0)
       else
           -- Si todo falla, te lleva a una posición segura del mapa (coordenadas comunes de bases)
           root.CFrame = CFrame.new(0, 100, 0) 
           Rayfield:Notify({Title = "Aviso", Content = "Base no encontrada, buscando zona segura", Duration = 2})
       end
   end,
})

local Tab2 = Window:NewTab("MEJORAS", 4483362458)

-- 4. FLOAT (SALTO MEJORADO)
Tab:CreateToggle({
   Name = "FLOAT (MEJORADO)",
   CurrentValue = false,
   Flag = "FloatFix",
   Callback = function(Value)
       _G.Float = Value
       game:GetService("RunService").RenderStepped:Connect(function()
           if _G.Float and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
               root.Velocity = Vector3.new(root.Velocity.X, 35, root.Velocity.Z)
           end
       end)
   end,
})

-- 5. VELOCIDAD
Tab:CreateSlider({
   Name = "VELOCIDAD",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       char.Humanoid.WalkSpeed = Value
   end,
})
