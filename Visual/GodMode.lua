-- ============================================
-- NullHub GodMode.lua - Invincibility System
-- Created by Debbhai
-- Version: 1.0.0
-- Prevent health from decreasing
-- ============================================

local GodMode = {
    Version = "1.0.0",
    Enabled = false,
    OriginalHealth = 100,
    HealthConnection = nil,
    DiedConnection = nil
}

-- Dependencies
local RunService
local Player, Character, Humanoid
local Config, Notifications

-- Internal State
local LastHealthUpdate = 0
local UpdateDelay = 0.1 -- Prevent spam

-- ============================================
-- INITIALIZATION
-- ============================================
function GodMode:Initialize(player, humanoid, config, notifications)
    -- Store dependencies
    RunService = game:GetService("RunService")
    
    Player = player
    Character = player.Character or player.CharacterAdded:Wait()
    Humanoid = humanoid
    Config = config
    Notifications = notifications
    
    -- Save original health
    self.OriginalHealth = Humanoid.Health
    
    print("[GodMode] ✅ Initialized")
    return true
end

-- ============================================
-- ENABLE GOD MODE
-- ============================================
function GodMode:EnableGodMode()
    if not Humanoid then return false end
    
    -- Disconnect existing connections
    if self.HealthConnection then
        self.HealthConnection:Disconnect()
    end
    if self.DiedConnection then
        self.DiedConnection:Disconnect()
    end
    
    -- Set to max health
    Humanoid.Health = Humanoid.MaxHealth
    
    -- Method 1: Monitor Health Property Changes
    self.HealthConnection = Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        local currentTime = tick()
        if currentTime - LastHealthUpdate < UpdateDelay then return end
        LastHealthUpdate = currentTime
        
        -- Restore health if decreased
        if Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)
    
    -- Method 2: Prevent Death
    self.DiedConnection = Humanoid.Died:Connect(function()
        -- Respawn character
        if Config.Visual.GODMODE.AUTO_RESPAWN then
            task.wait(0.1)
            Player:LoadCharacter()
        else
            -- Try to restore health before death
            pcall(function()
                Humanoid.Health = Humanoid.MaxHealth
            end)
        end
    end)
    
    -- Method 3: Continuous Health Update (Extra protection)
    if Config.Visual.GODMODE.CONTINUOUS_UPDATE then
        task.spawn(function()
            while self.Enabled do
                pcall(function()
                    if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
                        Humanoid.Health = Humanoid.MaxHealth
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
    
    print("[GodMode] 🛡️ God mode active")
    return true
end

-- ============================================
-- DISABLE GOD MODE
-- ============================================
function GodMode:DisableGodMode()
    -- Disconnect connections
    if self.HealthConnection then
        self.HealthConnection:Disconnect()
        self.HealthConnection = nil
    end
    
    if self.DiedConnection then
        self.DiedConnection:Disconnect()
        self.DiedConnection = nil
    end
    
    print("[GodMode] ⚠️ God mode disabled")
    return true
end

-- ============================================
-- TOGGLE
-- ============================================
function GodMode:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    -- Notify user
    if Notifications then
        Notifications:Show("God Mode", self.Enabled, nil, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function GodMode:Enable()
    self:EnableGodMode()
    print("[GodMode] 🛡️ Enabled")
end

-- ============================================
-- DISABLE
-- ============================================
function GodMode:Disable()
    self:DisableGodMode()
    print("[GodMode] ❌ Disabled")
end

-- ============================================
-- HEAL TO FULL
-- ============================================
function GodMode:HealFull()
    if not Humanoid then return false end
    
    Humanoid.Health = Humanoid.MaxHealth
    
    if Notifications then
        Notifications:Show("God Mode", true, "Healed to full!", 2)
    end
    
    print("[GodMode] ❤️ Healed to full")
    return true
end

-- ============================================
-- SET MAX HEALTH
-- ============================================
function GodMode:SetMaxHealth(maxHealth)
    if not Humanoid then return false end
    
    maxHealth = math.clamp(maxHealth, 1, 999999)
    Humanoid.MaxHealth = maxHealth
    
    if self.Enabled then
        Humanoid.Health = maxHealth
    end
    
    if Notifications then
        Notifications:Show("God Mode", true, "Max Health: " .. maxHealth, 2)
    end
    
    print("[GodMode] Max health set to: " .. maxHealth)
    return true
end

-- ============================================
-- INVINCIBILITY MODES
-- ============================================
function GodMode:SetMode(mode)
    local modes = {
        -- Standard: Health monitoring
        Standard = {
            AUTO_RESPAWN = false,
            CONTINUOUS_UPDATE = false,
            PREVENT_RAGDOLL = false
        },
        
        -- Advanced: Extra protection
        Advanced = {
            AUTO_RESPAWN = false,
            CONTINUOUS_UPDATE = true,
            PREVENT_RAGDOLL = true
        },
        
        -- Extreme: Maximum protection
        Extreme = {
            AUTO_RESPAWN = true,
            CONTINUOUS_UPDATE = true,
            PREVENT_RAGDOLL = true,
            REMOVE_HUMANOID_STATE = true
        }
    }
    
    local modeConfig = modes[mode]
    if not modeConfig then
        warn("[GodMode] Unknown mode: " .. mode)
        return false
    end
    
    -- Update config
    for key, value in pairs(modeConfig) do
        Config.Visual.GODMODE[key] = value
    end
    
    -- Reapply if enabled
    if self.Enabled then
        self:DisableGodMode()
        self:EnableGodMode()
    end
    
    if Notifications then
        Notifications:Show("God Mode", true, "Mode: " .. mode, 2)
    end
    
    print("[GodMode] Mode set to: " .. mode)
    return true
end

-- ============================================
-- ANTI-RAGDOLL
-- ============================================
function GodMode:EnableAntiRagdoll()
    if not Humanoid then return false end
    
    -- Prevent ragdoll states
    local antiRagdollStates = {
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.PlatformStanding
    }
    
    for _, state in pairs(antiRagdollStates) do
        Humanoid:SetStateEnabled(state, false)
    end
    
    print("[GodMode] 🚫 Anti-ragdoll enabled")
    return true
end

function GodMode:DisableAntiRagdoll()
    if not Humanoid then return false end
    
    -- Re-enable states
    local states = {
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.PlatformStanding
    }
    
    for _, state in pairs(states) do
        Humanoid:SetStateEnabled(state, true)
    end
    
    print("[GodMode] ✅ Anti-ragdoll disabled")
    return true
end

-- ============================================
-- FORCE FIELD (Visual Effect)
-- ============================================
function GodMode:AddForceField()
    if not Character then return false end
    
    -- Remove existing force field
    local existingFF = Character:FindFirstChildOfClass("ForceField")
    if existingFF then
        existingFF:Destroy()
    end
    
    -- Create force field
    local forceField = Instance.new("ForceField")
    forceField.Visible = Config.Visual.GODMODE.SHOW_FORCEFIELD or true
    forceField.Parent = Character
    
    print("[GodMode] ⚡ Force field added")
    return true
end

function GodMode:RemoveForceField()
    if not Character then return false end
    
    local forceField = Character:FindFirstChildOfClass("ForceField")
    if forceField then
        forceField:Destroy()
        print("[GodMode] ⚡ Force field removed")
        return true
    end
    
    return false
end

-- ============================================
-- GET STATUS
-- ============================================
function GodMode:GetStatus()
    return {
        Enabled = self.Enabled,
        CurrentHealth = Humanoid and Humanoid.Health or 0,
        MaxHealth = Humanoid and Humanoid.MaxHealth or 100,
        HasHealthConnection = self.HealthConnection ~= nil,
        HasDiedConnection = self.DiedConnection ~= nil
    }
end

function GodMode:GetHealthPercentage()
    if not Humanoid then return 0 end
    return (Humanoid.Health / Humanoid.MaxHealth) * 100
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function GodMode:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    -- Disable first
    self:DisableGodMode()
    
    -- Update references
    Character = newCharacter
    Humanoid = newHumanoid
    self.OriginalHealth = Humanoid.Health
    
    -- Re-enable if was enabled
    if wasEnabled then
        task.wait(0.5)
        self:EnableGodMode()
        
        -- Apply extra protections
        if Config.Visual.GODMODE.PREVENT_RAGDOLL then
            self:EnableAntiRagdoll()
        end
        
        if Config.Visual.GODMODE.SHOW_FORCEFIELD then
            self:AddForceField()
        end
    end
    
    print("[GodMode] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function GodMode:Destroy()
    self:DisableGodMode()
    self:RemoveForceField()
    
    print("[GodMode] ✅ Destroyed")
end

-- Export
print("[GodMode] Module loaded v" .. GodMode.Version)
return GodMode
