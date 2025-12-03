-- ============================================
-- NullHub Speed.lua - Walk Speed Modifier
-- Created by Debbhai
-- Version: 1.0.0 FINAL OPTIMIZED
-- Adjustable walk speed (Default: 50)
-- ============================================

local Speed = {
    Version = "1.0.0",
    Enabled = false,
    CurrentSpeed = 50,
    MinSpeed = 0,
    MaxSpeed = 1000000,
    OriginalSpeed = 16
}

-- Dependencies
local Player, Humanoid
local Config, AntiDetection, Notifications

-- Internal State
local Connection = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function Speed:Initialize(player, humanoid, config, antiDetection, notifications)
    Player = player
    Humanoid = humanoid
    Config = config
    AntiDetection = antiDetection
    Notifications = notifications
    
    -- Save original speed
    self.OriginalSpeed = Humanoid.WalkSpeed
    
    -- Get from config or use default
    self.CurrentSpeed = Config.Movement.SPEED.VALUE or 50
    self.MinSpeed = Config.Movement.SPEED.MIN_VALUE or 0
    self.MaxSpeed = Config.Movement.SPEED.MAX_VALUE or 1000000
    
    print("[Speed] ✅ Initialized (Default: " .. self.CurrentSpeed .. ")")
    return true
end

-- ============================================
-- APPLY SPEED
-- ============================================
function Speed:ApplySpeed()
    if not Humanoid then return end
    
    if self.Enabled then
        -- Apply smooth transition if enabled
        if Config.Movement.SPEED.SMOOTH_TRANSITION and AntiDetection then
            local targetSpeed = self.CurrentSpeed
            Humanoid.WalkSpeed = AntiDetection:SmoothTransition(
                targetSpeed,
                Humanoid.WalkSpeed,
                0.2,
                Config.AntiDetection.STEALTH_MODE
            )  -- ✅ FIXED: Added missing closing parenthesis here
        else
            Humanoid.WalkSpeed = self.CurrentSpeed
        end
    else
        Humanoid.WalkSpeed = self.OriginalSpeed
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function Speed:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    if Notifications then
        Notifications:Show("Speed", self.Enabled, "Speed: " .. self.CurrentSpeed, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function Speed:Enable()
    if Connection then return end
    
    -- Apply speed immediately
    self:ApplySpeed()
    
    -- Monitor for external changes (anti-cheat resets)
    Connection = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if self.Enabled and Humanoid.WalkSpeed ~= self.CurrentSpeed then
            -- Reapply if externally changed
            task.wait(0.1)
            if self.Enabled then
                self:ApplySpeed()
            end
        end
    end)
    
    print("[Speed] ⚡ Enabled (Speed: " .. self.CurrentSpeed .. ")")
end

-- ============================================
-- DISABLE
-- ============================================
function Speed:Disable()
    -- Disconnect property monitor
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    -- Restore original speed
    if Humanoid then
        Humanoid.WalkSpeed = self.OriginalSpeed
    end
    
    print("[Speed] ❌ Disabled")
end

-- ============================================
-- SET SPEED (For Slider - Silent)
-- ============================================
function Speed:SetSpeed(speed)
    speed = tonumber(speed)
    if not speed then return false end
    
    -- Clamp to range
    speed = math.clamp(speed, self.MinSpeed, self.MaxSpeed)
    self.CurrentSpeed = speed
    
    -- Update config
    Config.Movement.SPEED.VALUE = speed
    
    -- Apply if enabled
    if self.Enabled then
        self:ApplySpeed()
    end
    
    -- Silent update (no notification spam during slider drag)
    return true
end

-- ============================================
-- NOTIFY SPEED CHANGE (For Manual Input)
-- ============================================
function Speed:NotifySpeedChange(speed)
    if Notifications then
        Notifications:Show("Walk Speed", true, tostring(speed), 1.5)
    end
    print("[Speed] Speed set to: " .. speed)
end

-- ============================================
-- GET SPEED (For Slider Display)
-- ============================================
function Speed:GetSpeed()
    return self.CurrentSpeed
end

function Speed:GetSpeedRange()
    return self.MinSpeed, self.MaxSpeed
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function Speed:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    -- Disable and update references
    self:Disable()
    Humanoid = newHumanoid
    self.OriginalSpeed = Humanoid.WalkSpeed
    
    -- Re-enable if was enabled
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[Speed] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function Speed:Destroy()
    self:Disable()
    print("[Speed] ✅ Destroyed")
end

print("[Speed] Module loaded v" .. Speed.Version)
return Speed
