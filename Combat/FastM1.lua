-- ============================================
-- NullHub FastM1.lua - Auto Click System
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- ============================================

local FastM1 = {
    Version = "1.0.0",
    Enabled = false
}

-- Dependencies
local RunService
local Player, Character
local Config, Notifications

-- Internal State
local Connection = nil
local LastClick = 0

-- ============================================
-- INITIALIZATION
-- ============================================
function FastM1:Initialize(player, character, config, notifications)
    RunService = game:GetService("RunService")
    
    Player = player
    Character = character
    Config = config
    Notifications = notifications
    
    print("[FastM1] ✅ Initialized")
    return true
end

-- ============================================
-- PERFORM CLICK
-- ============================================
function FastM1:PerformClick()
    if not self.Enabled then return end
    
    local currentTime = tick()
    local delay = Config.Combat.FASTM1.DELAY
    
    -- Randomize delay (optional)
    if Config.Combat.FASTM1.RANDOMIZE_DELAY then
        delay = math.random(
            Config.Combat.FASTM1.MIN_DELAY * 100,
            Config.Combat.FASTM1.MAX_DELAY * 100
        ) / 100
    end
    
    if currentTime - LastClick < delay then
        return
    end
    
    -- Activate tool
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
    
    -- Simulate mouse click
    pcall(function()
        mouse1press()
        task.wait(0.01)
        mouse1release()
    end)
    
    LastClick = currentTime
end

-- ============================================
-- TOGGLE
-- ============================================
function FastM1:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    if Notifications then
        Notifications:Show("FastM1", self.Enabled, nil, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function FastM1:Enable()
    if Connection then return end
    
    Connection = RunService.Heartbeat:Connect(function()
        self:PerformClick()
    end)
    
    print("[FastM1] 👊 Enabled")
end

-- ============================================
-- DISABLE
-- ============================================
function FastM1:Disable()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    print("[FastM1] ❌ Disabled")
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function FastM1:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    self:Disable()
    Character = newCharacter
    
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[FastM1] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function FastM1:Destroy()
    self:Disable()
    print("[FastM1] ✅ Destroyed")
end

print("[FastM1] Module loaded v" .. FastM1.Version)
return FastM1
