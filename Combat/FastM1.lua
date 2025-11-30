-- ============================================
-- NullHub FastM1.lua - Rapid Click System
-- Created by Debbhai
-- Version: 1.0.0
-- Auto-clicker for tool/weapon activation
-- ============================================

local FastM1 = {
    Version = "1.0.0",
    Enabled = false,
    LastClick = 0
}

-- Dependencies
local RunService
local Player, Character
local Config, Notifications

-- Internal State
local Connection = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function FastM1:Initialize(player, character, config, notifications)
    -- Store dependencies
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
function FastM1:Click()
    if not self.Enabled or not Character then return end
    
    -- Rate limiting
    local currentTime = tick()
    local delay = Config.Combat.FASTM1.DELAY
    
    -- Randomize delay if enabled
    if Config.Combat.FASTM1.RANDOMIZE_DELAY then
        delay = math.random(
            Config.Combat.FASTM1.MIN_DELAY * 1000,
            Config.Combat.FASTM1.MAX_DELAY * 1000
        ) / 1000
    end
    
    if currentTime - self.LastClick < delay then return end
    
    -- Method 1: Tool activation
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
    
    -- Method 2: Mouse click simulation (if available)
    pcall(function()
        if mouse1press and mouse1release then
            mouse1press()
            task.wait(0.01)
            mouse1release()
        end
    end)
    
    -- Update last click time
    self.LastClick = currentTime
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
    
    -- Notify user
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
        self:Click()
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
-- UPDATE SETTINGS
-- ============================================
function FastM1:SetDelay(delay)
    Config.Combat.FASTM1.DELAY = math.clamp(delay, 0.01, 0.5)
    print("[FastM1] Delay set to: " .. delay)
end

function FastM1:SetRandomDelay(minDelay, maxDelay)
    Config.Combat.FASTM1.RANDOMIZE_DELAY = true
    Config.Combat.FASTM1.MIN_DELAY = math.clamp(minDelay, 0.01, 0.2)
    Config.Combat.FASTM1.MAX_DELAY = math.clamp(maxDelay, 0.02, 0.5)
    print(string.format("[FastM1] Random delay: %.3f - %.3f", minDelay, maxDelay))
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function FastM1:OnRespawn(newCharacter, newHumanoid, newRootPart)
    Character = newCharacter
    self.LastClick = 0
    print("[FastM1] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function FastM1:Destroy()
    self:Disable()
    print("[FastM1] ✅ Destroyed")
end

-- Export
print("[FastM1] Module loaded v" .. FastM1.Version)
return FastM1
