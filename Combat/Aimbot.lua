-- ============================================
-- NullHub Aimbot.lua - Smart Aim Assistance
-- Created by Debbhai
-- Version: 1.0.0
-- FOV-based aimbot with smooth tracking
-- ============================================

local Aimbot = {
    Version = "1.0.0",
    Enabled = false,
    CurrentTarget = nil
}

-- Dependencies
local Players, UserInputService, RunService, TweenService
local Player, Camera, Character, Humanoid, RootPart
local Config, AntiDetection, Notifications

-- Internal State
local Connection = nil
local LastUpdate = 0
local UpdateRate = 0.016 -- ~60 FPS

-- ============================================
-- INITIALIZATION
-- ============================================
function Aimbot:Initialize(player, camera, config, antiDetection, notifications)
    -- Store dependencies
    Players = game:GetService("Players")
    UserInputService = game:GetService("UserInputService")
    RunService = game:GetService("RunService")
    
    Player = player
    Camera = camera
    Config = config
    AntiDetection = antiDetection
    Notifications = notifications
    
    Character = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    print("[Aimbot] ✅ Initialized")
    return true
end

-- ============================================
-- TARGET FINDING
-- ============================================
function Aimbot:GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Config.Combat.AIMBOT.FOV
    local mousePosition = UserInputService:GetMouseLocation()
    
    -- Iterate through all players
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer == Player then continue end
        if not otherPlayer.Character then continue end
        
        local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
        local otherHead = otherPlayer.Character:FindFirstChild("Head")
        
        -- Validity checks
        if not otherHumanoid or not otherHead then continue end
        if otherHumanoid.Health <= 0 then continue end
        
        -- Team check (if enabled)
        if Config.Combat.AIMBOT.TEAM_CHECK then
            if otherPlayer.Team == Player.Team then continue end
        end
        
        -- Convert world position to screen position
        local screenPosition, onScreen = Camera:WorldToScreenPoint(otherHead.Position)
        
        if onScreen then
            -- Calculate distance from mouse to target
            local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitude
            
            -- Check if within FOV and closer than previous target
            if distance < shortestDistance then
                -- Visible check (if enabled)
                if Config.Combat.AIMBOT.VISIBLE_CHECK then
                    if self:IsVisible(otherHead) then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                else
                    shortestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
        end
    end
    
    return closestPlayer
end

-- ============================================
-- VISIBILITY CHECK
-- ============================================
function Aimbot:IsVisible(targetPart)
    if not RootPart then return false end
    
    local rayOrigin = Camera.CFrame.Position
    local rayDirection = (targetPart.Position - rayOrigin).Unit * 500
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if rayResult then
        local hitPart = rayResult.Instance
        return hitPart:IsDescendantOf(targetPart.Parent)
    end
    
    return false
end

-- ============================================
-- AIM AT TARGET
-- ============================================
function Aimbot:AimAtTarget(target)
    if not target or not target.Character then
        self.CurrentTarget = nil
        return
    end
    
    local targetHead = target.Character:FindFirstChild("Head")
    if not targetHead then
        self.CurrentTarget = nil
        return
    end
    
    -- Anti-detection delay
    if AntiDetection then
        AntiDetection:AddRandomDelay(Config.AntiDetection.STEALTH_MODE)
    end
    
    -- Predict target movement
    local targetPosition = targetHead.Position
    if Config.Combat.AIMBOT.PREDICT_MOVEMENT then
        local velocity = targetHead.AssemblyLinearVelocity
        targetPosition = targetPosition + (velocity * Config.Combat.AIMBOT.PREDICTION_FACTOR)
    end
    
    -- Calculate new camera CFrame
    local cameraPosition = Camera.CFrame.Position
    local newCFrame = CFrame.new(cameraPosition, targetPosition)
    
    -- Get variable smoothness (anti-detection)
    local smoothness = Config.Combat.AIMBOT.SMOOTHNESS
    if AntiDetection then
        smoothness = AntiDetection:GetVariableSmoothness(
            smoothness,
            Config.AntiDetection.STEALTH_MODE
        )
    end
    
    -- Smooth camera lerp
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, smoothness)
    
    -- Store current target
    self.CurrentTarget = target
end

-- ============================================
-- TOGGLE
-- ============================================
function Aimbot:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    -- Notify user
    if Notifications then
        Notifications:Show("Aimbot", self.Enabled, nil, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function Aimbot:Enable()
    if Connection then return end
    
    Connection = RunService.RenderStepped:Connect(function()
        local currentTime = tick()
        if currentTime - LastUpdate < UpdateRate then return end
        LastUpdate = currentTime
        
        -- Find and aim at closest player
        local target = self:GetClosestPlayer()
        if target then
            self:AimAtTarget(target)
        else
            self.CurrentTarget = nil
        end
    end)
    
    print("[Aimbot] 🎯 Enabled")
end

-- ============================================
-- DISABLE
-- ============================================
function Aimbot:Disable()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    self.CurrentTarget = nil
    print("[Aimbot] ❌ Disabled")
end

-- ============================================
-- UPDATE SETTINGS
-- ============================================
function Aimbot:SetFOV(fov)
    Config.Combat.AIMBOT.FOV = math.clamp(fov, 10, 360)
    print("[Aimbot] FOV set to: " .. fov)
end

function Aimbot:SetSmoothness(smoothness)
    Config.Combat.AIMBOT.SMOOTHNESS = math.clamp(smoothness, 0.01, 1)
    print("[Aimbot] Smoothness set to: " .. smoothness)
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function Aimbot:OnRespawn(newCharacter, newHumanoid, newRootPart)
    Character = newCharacter
    Humanoid = newHumanoid
    RootPart = newRootPart
    
    print("[Aimbot] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function Aimbot:Destroy()
    self:Disable()
    self.CurrentTarget = nil
    print("[Aimbot] ✅ Destroyed")
end

-- Export
print("[Aimbot] Module loaded v" .. Aimbot.Version)
return Aimbot
