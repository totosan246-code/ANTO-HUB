local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NEW DUELOS V1.1 🔴",
   LoadingTitle = "CARGANDO SISTEMA ANTIBAN...",
   LoadingSubtitle = "by Anto",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- 🔍 BUSCADOR DE OBJETOS MEJORADO
local function findBrainrot()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:find("Brain") or v.Name == "Object" or v.Name == "Goal") then
            if not v:IsDescendantOf(char) then return v end
        end
    end
    return nil
end

local Tab = Window:CreateTab("PRINCIPAL", 4483362458)

-- 1. TELEPORT AL BRAINROT (CON ANCLA PARA QUE NO TE REGRESE)
Tab:CreateButton({
   Name = "TELEPORT AL BRAINROT",
   Callback = function()
       local target = findBrainrot()
       if target then
           root.Velocity = Vector3.new(0,0,0)
           root.CFrame = target.CFrame * CFrame.new(0, 2, 0)
           -- Pequeño truco para que el servidor acepte la posición
           task.wait(0.1)
           root.Anchored = true
           task.wait(0.1)
           root.Anchored = false
       end
   end,
})

-- 2. AUTO GRAB (RECOGER REAL)
Tab:CreateToggle({
   Name = "RECOGER AUTOMATICO",
   CurrentValue = false,
   Flag = "AutoGrab",
   Callback = function(Value)
       _G.AutoGrab = Value
       spawn(function()
           while _G.AutoGrab do
               task.wait(0.1)
               local target = findBrainrot()
               if target and (root.Position - target.Position).Magnitude < 15 then
                   -- Forzamos el toque
                   firetouchinterest(root, target, 0)
                   firetouchinterest(root, target, 1)
                   -- Intentamos equipar herramienta si hay
                   local tool = player.Backpack:FindFirstChildOfClass("Tool")
                   if tool then hum:EquipTool(tool) end
                   if char:FindFirstChildOfClass("Tool") then
                       char:FindFirstChildOfClass("Tool"):Activate()
                   end
               end
           end
       end)
   end,
})

-- 3. IR A MI BASE (BUSCADOR DE SPAWN)
Tab:CreateButton({
   Name = "IR A MI BASE",
   Callback = function()
       -- Busca la parte más cercana al inicio que no sea la del enemigo
       local mySpawn = player.RespawnLocation
       if mySpawn then
           root.Velocity = Vector3.new(0,0,0)
           root.CFrame = mySpawn.CFrame * CFrame.new(0, 5, 0)
           task.wait(0.1)
           root.Anchored = true
           task.wait(0.1)
           root.Anchored = false
       else
           Rayfield:Notify({Title = "Error", Content = "No detecto tu base, camina a ella y usa 'Set Base'", Duration = 3})
       end
   end,
})

local Tab2 = Window:NewTab("MEJORAS", 4483362458)

-- 4. FLOAT (VOLAR)
Tab2:CreateToggle({
   Name = "VOLAR (FLOAT)",
   CurrentValue = false,
   Flag = "Volar",
   Callback = function(Value)
       _G.Volar = Value
       spawn(function()
           while _G.Volar do
               task.wait()
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                   root.Velocity = Vector3.new(root.Velocity.X, 45, root.Velocity.Z)
               end
           end
       end)
   end,
})

-- 5. ANTI RAGDOLL
Tab2:CreateToggle({
   Name = "ANTI RAGDOLL",
   CurrentValue = true,
   Callback = function(v) _G.AntiRagdoll = v end
})

-- 6. VELOCIDAD
Tab2:CreateSlider({
   Name = "VELOCIDAD",
   Range = {16, 150},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) char.Humanoid.WalkSpeed = v end,
})

-- Bucle para AntiRagdoll constante
game:GetService("RunService").Stepped:Connect(function()
    if _G.AntiRagdoll and char:FindFirstChild("Humanoid") then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end)
