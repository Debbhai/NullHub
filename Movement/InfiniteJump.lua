-- ============================================
-- NullHub InfiniteJump.lua - Unlimited Jumping
-- Created by Debbhai
-- Version: 1.0.0 FINAL OPTIMIZED
-- Jump infinitely with adjustable height
-- ============================================

local InfiniteJump = {
    Version = "1.0.0",
    Enabled = false,
    CurrentJumpHeight = 50,
    MinJumpHeight = 10,
    MaxJumpHeight = 200,
    OriginalJumpPower = 50,
    OriginalJumpHeight = 7.2,
    UseJumpPower = true
}

-- Dependencies
local UserInputService
local Player, Character, Humanoid
local Config, Notifications

-- Internal State
local Connection = nil
local AutoJumpConnection = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function InfiniteJump:Initialize(player, humanoid, config, notifications)
    UserInputService = game:GetService("UserInputService")
    
    Player = player
    Character = player.Character or player.CharacterAdded:Wait()
    Humanoid = humanoid
    Config = config
    Notifications = notifications
    
    -- Save original values
    self.UseJumpPower = Humanoid.UseJumpPower
    if self.UseJumpPower then
        self.OriginalJumpPower = Humanoid.JumpPower
    else
        self.OriginalJumpHeight = Humanoid.JumpHeight
    end
    
    -- Set from config
    self.CurrentJumpHeight = Config.Movement.INFJUMP.JUMP_POWER or 50
    
    print("[InfiniteJump] ✅ Initialized (Height: " .. self.CurrentJumpHeight .. ")")
    return true
end

-- ============================================
-- PERFORM JUMP
-- ============================================
function InfiniteJump:PerformJump()
    if not self.Enabled or not Humanoid then return end
    
    -- Change to jumping state
    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    
    -- Apply custom jump height
    if self.UseJumpPower then
        Humanoid.JumpPower = self.CurrentJumpHeight
    else
        Humanoid.JumpHeight = self.CurrentJumpHeight / 10
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function InfiniteJump:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    if Notifications then
        Notifications:Show("InfiniteJump", self.Enabled, "Height: " .. self.CurrentJumpHeight, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function InfiniteJump:Enable()
    if Connection then return end
    
    -- Use JumpRequest (more efficient than InputBegan)
    Connection = UserInputService.JumpRequest:Connect(function()
        self:PerformJump()
    end)
    
    -- Auto jump mode (if enabled in config)
    if Config.Movement.INFJUMP.AUTO_JUMP then
        AutoJumpConnection = task.spawn(function()
            while self.Enabled and task.wait(0.5) do
                self:PerformJump()
            end
        end)
    end
    
    print("[InfiniteJump] 🦘 Enabled (Height: " .. self.CurrentJumpHeight .. ")")
end

-- ============================================
-- DISABLE
-- ============================================
function InfiniteJump:Disable()
    -- Disconnect jump connection
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    -- Stop auto jump
    if AutoJumpConnection then
        task.cancel(AutoJumpConnection)
        AutoJumpConnection = nil
    end
    
    -- Restore original jump values
    if Humanoid then
        if self.UseJumpPower then
            Humanoid.JumpPower = self.OriginalJumpPower
        else
            Humanoid.JumpHeight = self.OriginalJumpHeight
        end
    end
    
    print("[InfiniteJump] ❌ Disabled")
end

-- ============================================
-- SET JUMP HEIGHT (For Slider)
-- ============================================
function InfiniteJump:SetJumpHeight(height)
    height = tonumber(height)
    if not height then return false end
    
    -- Clamp to range
    height = math.clamp(height, self.MinJumpHeight, self.MaxJumpHeight)
    self.CurrentJumpHeight = height
    
    -- Update config
    Config.Movement.INFJUMP.JUMP_POWER = height
    
    -- Silent update (no notification spam during slider drag)
    return true
end

-- ============================================
-- GET JUMP HEIGHT (For Slider Display)
-- ============================================
function InfiniteJump:GetJumpHeight()
    return self.CurrentJumpHeight
end

function InfiniteJump:GetJumpHeightRange()
    return self.MinJumpHeight, self.MaxJumpHeight
end

-- ============================================
-- NOTIFY HEIGHT CHANGE (For Manual Input)
-- ============================================
function InfiniteJump:NotifyHeightChange(height)
    if Notifications then
        Notifications:Show("Jump Height", true, tostring(height), 1.5)
    end
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function InfiniteJump:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    -- Disable and update references
    self:Disable()
    Character = newCharacter
    Humanoid = newHumanoid
    
    -- Save new original values
    self.UseJumpPower = Humanoid.UseJumpPower
    if self.UseJumpPower then
        self.OriginalJumpPower = Humanoid.JumpPower
    else
        self.OriginalJumpHeight = Humanoid.JumpHeight
    end
    
    -- Re-enable if was enabled
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[InfiniteJump] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function InfiniteJump:Destroy()
    self:Disable()
    print("[InfiniteJump] ✅ Destroyed")
end

print("[InfiniteJump] Module loaded v" .. InfiniteJump.Version)
return InfiniteJump
