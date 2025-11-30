-- ============================================
-- NullHub Fly.lua - Flight System with Slider
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- ============================================

local Fly = {
    Version = "1.0.0",
    Enabled = false,
    CurrentSpeed = 120,
    MinSpeed = 10,
    MaxSpeed = 300
}

-- Dependencies
local UserInputService, RunService
local Player, Character, RootPart, Camera
local Config, Notifications

-- Internal State
local BodyVelocity = nil
local Connection = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function Fly:Initialize(player, character, rootPart, camera, config, notifications)
    UserInputService = game:GetService("UserInputService")
    RunService = game:GetService("RunService")
    
    Player = player
    Character = character
    RootPart = rootPart
    Camera = camera
    Config = config
    Notifications = notifications
    
    self.CurrentSpeed = Config.Movement.FLY.SPEED or 120
    self.MinSpeed = Config.Movement.FLY.MIN_SPEED or 10
    self.MaxSpeed = Config.Movement.FLY.MAX_SPEED or 300
    
    print("[Fly] ✅ Initialized")
    return true
end

-- ============================================
-- UPDATE MOVEMENT
-- ============================================
function Fly:UpdateMovement()
    if not self.Enabled or not RootPart or not BodyVelocity then return end
    
    local moveDirection = Vector3.new(0, 0, 0)
    
    -- WASD Controls
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + Camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - Camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - Camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + Camera.CFrame.RightVector
    end
    
    -- Vertical Controls
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end
    
    -- Apply speed
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * self.CurrentSpeed
    end
    
    -- Update velocity
    if Config.Movement.FLY.SMOOTH_MOVEMENT then
        BodyVelocity.Velocity = BodyVelocity.Velocity:Lerp(moveDirection, 0.3)
    else
        BodyVelocity.Velocity = moveDirection
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function Fly:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    if Notifications then
        Notifications:Show("Fly", self.Enabled, "Speed: " .. self.CurrentSpeed, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function Fly:Enable()
    if not RootPart then return end
    
    -- Clean up existing
    if BodyVelocity then
        BodyVelocity:Destroy()
    end
    
    -- Create BodyVelocity
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = RootPart
    
    -- Connect update loop
    if Connection then
        Connection:Disconnect()
    end
    Connection = RunService.Heartbeat:Connect(function()
        self:UpdateMovement()
    end)
    
    print("[Fly] 🕊️ Enabled (Speed: " .. self.CurrentSpeed .. ")")
end

-- ============================================
-- DISABLE
-- ============================================
function Fly:Disable()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    
    print("[Fly] ❌ Disabled")
end

-- ============================================
-- SET SPEED
-- ============================================
function Fly:SetSpeed(speed)
    speed = tonumber(speed)
    if not speed then return false end
    
    speed = math.clamp(speed, self.MinSpeed, self.MaxSpeed)
    self.CurrentSpeed = speed
    Config.Movement.FLY.SPEED = speed
    
    if Notifications then
        Notifications:Show("Fly Speed", true, tostring(speed), 1.5)
    end
    
    return true
end

function Fly:GetSpeed()
    return self.CurrentSpeed
end

function Fly:GetSpeedRange()
    return self.MinSpeed, self.MaxSpeed
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function Fly:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    self:Disable()
    Character = newCharacter
    RootPart = newRootPart
    
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[Fly] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function Fly:Destroy()
    self:Disable()
    print("[Fly] ✅ Destroyed")
end

print("[Fly] Module loaded v" .. Fly.Version)
return Fly
