-- ============================================
-- NullHub Aimbot.lua - Auto Aim System
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- ============================================

local Aimbot = {
    Version = "1.0.0",
    Enabled = false,
    CurrentTarget = nil
}

-- Dependencies
local Players, UserInputService, RunService
local Player, Camera
local Config, AntiDetection, Notifications

-- Internal State
local Connection = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function Aimbot:Initialize(player, camera, config, antiDetection, notifications)
    Players = game:GetService("Players")
    UserInputService = game:GetService("UserInputService")
    RunService = game:GetService("RunService")
    
    Player = player
    Camera = camera
    Config = config
    AntiDetection = antiDetection
    Notifications = notifications
    
    print("[Aimbot] ✅ Initialized")
    return true
end

-- ============================================
-- GET CLOSEST PLAYER
-- ============================================
function Aimbot:GetClosestPlayer()
    local closestPlayer, shortestDistance = nil, Config.Combat.AIMBOT.FOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character then
            local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            local otherHead = otherPlayer.Character:FindFirstChild("Head")
            
            if otherHumanoid and otherHead and otherHumanoid.Health > 0 then
                -- Team check
                if Config.Combat.AIMBOT.TEAM_CHECK and otherPlayer.Team == Player.Team then
                    continue
                end
                
                local screenPos, onScreen = Camera:WorldToScreenPoint(otherHead.Position)
                
                if onScreen then
                    -- Visibility check
                    if Config.Combat.AIMBOT.VISIBLE_CHECK then
                        local ray = Ray.new(Camera.CFrame.Position, (otherHead.Position - Camera.CFrame.Position).Unit * 500)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {Player.Character})
                        
                        if hit and hit.Parent ~= otherPlayer.Character then
                            continue
                        end
                    end
                    
                    local distance = Vector2.new(screenPos.X, screenPos.Y) - mousePos
                    local magnitude = distance.Magnitude
                    
                    if magnitude < shortestDistance then
                        shortestDistance = magnitude
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- ============================================
-- AIM AT TARGET
-- ============================================
function Aimbot:AimAtTarget(target)
    if not target or not target.Character then return end
    
    local targetHead = target.Character:FindFirstChild("Head")
    if not targetHead then return end
    
    -- Add random delay for stealth
    if AntiDetection then
        AntiDetection:AddRandomDelay(Config.AntiDetection.STEALTH_MODE)
    end
    
    -- Calculate target position with prediction
    local targetPos = targetHead.Position
    
    if Config.Combat.AIMBOT.PREDICT_MOVEMENT then
        local velocity = targetHead.AssemblyLinearVelocity
        targetPos = targetPos + (velocity * Config.Combat.AIMBOT.PREDICTION_FACTOR)
    end
    
    -- Calculate new camera CFrame
    local cameraPos = Camera.CFrame.Position
    local newCFrame = CFrame.new(cameraPos, targetPos)
    
    -- Apply smoothness
    local smoothness = Config.Combat.AIMBOT.SMOOTHNESS
    
    if AntiDetection then
        smoothness = AntiDetection:GetVariableSmoothness(smoothness, Config.AntiDetection.STEALTH_MODE)
    end
    
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, smoothness)
end

-- ============================================
-- UPDATE AIMBOT
-- ============================================
function Aimbot:Update()
    if not self.Enabled then return end
    
    -- Check if aim key is held
    local aimKeyHeld = UserInputService:IsKeyDown(Config.Combat.AIMBOT.KEY) or
                       UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    
    if aimKeyHeld then
        -- Get or update target
        if not self.CurrentTarget or not Config.Combat.AIMBOT.STICK_TO_TARGET then
            self.CurrentTarget = self:GetClosestPlayer()
        end
        
        -- Aim at target
        if self.CurrentTarget then
            self:AimAtTarget(self.CurrentTarget)
        end
    else
        self.CurrentTarget = nil
    end
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
        self:Update()
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
-- CHARACTER RESPAWN
-- ============================================
function Aimbot:OnRespawn(newCharacter, newHumanoid, newRootPart)
    self.CurrentTarget = nil
    print("[Aimbot] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function Aimbot:Destroy()
    self:Disable()
    print("[Aimbot] ✅ Destroyed")
end

print("[Aimbot] Module loaded v" .. Aimbot.Version)
return Aimbot
