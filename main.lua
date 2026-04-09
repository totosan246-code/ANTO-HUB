local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NEW DUELOS V1.1 🔴",
   LoadingTitle = "OPTIMIZANDO CONEXIÓN...",
   LoadingSubtitle = "by Anto",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- FUNCIÓN PARA TELEPORT SIN BUGUEO (CFrame Directo)
local function safeTeleport(targetCFrame)
    root.Velocity = Vector3.new(0,0,0) -- Detiene el impulso para que no te jale el server
    root.CFrame = targetCFrame
end

local Tab = Window:CreateTab("PVP & ROBO", 4483362458)
local Section = Tab:CreateSection("Controles de Victoria")

-- 1. AUTO GRAB MEJORADO (MÁS RÁPIDO)
Tab:CreateButton({
   Name = "AUTO GRAB (INSTANT)",
   Callback = function()
       for _, obj in pairs(workspace:GetDescendants()) do
           if obj.Name == "Brainrot" and obj:IsA("BasePart") then
               -- Teleport exacto al centro del objeto
               safeTeleport(obj.CFrame)
               task.wait(0.05)
               -- Fuerza el agarre
               local tool = char:FindFirstChildOfClass("Tool")
               if tool then tool:Activate() end
               break
           end
       end
   end,
})

-- 2. REGRESO A BASE SEGURO (SIN BUG)
Tab:CreateButton({
   Name = "GO TO MY BASE (ANTI-BUG)",
   Callback = function()
       local spawn = player.RespawnLocation
       if spawn then
           -- Elevamos un poquito al personaje antes del TP para que no choque con el piso
           root.CFrame = root.CFrame * CFrame.new(0, 2, 0)
           task.wait(0.05)
           safeTeleport(spawn.CFrame * CFrame.new(0, 3, 0))
       end
   end,
})

-- 3. ANTI RAGDOLL (INSTANTÁNEO)
Tab:CreateToggle({
   Name = "ANTI RAGDOLL",
   CurrentValue = true,
   Flag = "Ragdoll",
   Callback = function(Value)
       _G.AntiRagdoll = Value
       game:GetService("RunService").Stepped:Connect(function()
           if _G.AntiRagdoll then
               char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
           end
       end)
   end,
})

-- 4. FLOAT MEJORADO (MÁS SUAVE)
local flying = false
Tab:CreateToggle({
   Name = "FLOAT (SUPER JUMP)",
   CurrentValue = false,
   Flag = "Float",
   Callback = function(Value)
       flying = Value
       game:GetService("UserInputService").JumpRequest:Connect(function()
           if flying then
               root.Velocity = Vector3.new(root.Velocity.X, 40, root.Velocity.Z)
           end
       end)
   end,
})

-- 5. VELOCIDAD (AJUSTE FINO)
Tab:CreateSlider({
   Name = "SPEED (SEGURA: 60-80)",
   Range = {16, 150},
   Increment = 1,
   Suffix = "Vel",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
       char.Humanoid.WalkSpeed = Value
   end,
})

Rayfield:Notify({
   Title = "ANTO-HUB READY",
   Content = "Configuración cargada sin Lag",
   Duration = 3,
   Image = 4483362458,
})
