-- ============================================
-- NullHub NoClip.lua - Walk Through Walls
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- ============================================

local NoClip = {
    Version = "1.0.0",
    Enabled = false
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
function NoClip:Initialize(player, character, config, notifications)
    RunService = game:GetService("RunService")
    
    Player = player
    Character = character
    Config = config
    Notifications = notifications
    
    print("[NoClip] ✅ Initialized")
    return true
end

-- ============================================
-- UPDATE NOCLIP
-- ============================================
function NoClip:Update()
    if not self.Enabled or not Character then return end
    
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function NoClip:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    if Notifications then
        Notifications:Show("NoClip", self.Enabled, nil, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function NoClip:Enable()
    if Connection then return end
    
    Connection = RunService.Stepped:Connect(function()
        self:Update()
    end)
    
    print("[NoClip] 👻 Enabled")
end

-- ============================================
-- DISABLE
-- ============================================
function NoClip:Disable()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    -- Restore collision
    if Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    print("[NoClip] ❌ Disabled")
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function NoClip:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    self:Disable()
    Character = newCharacter
    
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[NoClip] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function NoClip:Destroy()
    self:Disable()
    print("[NoClip] ✅ Destroyed")
end

print("[NoClip] Module loaded v" .. NoClip.Version)
return NoClip
