-- ============================================
-- NullHub KillAura.lua - Auto-Attack System
-- Created by Debbhai
-- Version: 1.0.0
-- Automatic target detection and attack
-- ============================================

local KillAura = {
    Version = "1.0.0",
    Enabled = false,
    Targets = {},
    LastAttack = 0
}

-- Dependencies
local Players, RunService, ReplicatedStorage
local Player, Character, Humanoid, RootPart
local Config, AntiDetection, Notifications

-- Internal State
local Connection = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function KillAura:Initialize(player, character, config, antiDetection, notifications)
    -- Store dependencies
    Players = game:GetService("Players")
    RunService = game:GetService("RunService")
    
    Player = player
    Character = character
    Config = config
    AntiDetection = antiDetection
    Notifications = notifications
    
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    print("[KillAura] ✅ Initialized")
    return true
end

-- ============================================
-- FIND ALL TARGETS IN RANGE
-- ============================================
function KillAura:FindTargets()
    self.Targets = {}
    
    if not RootPart then return end
    
    -- Find Players
    if Config.Combat.KILLAURA.ATTACK_PLAYERS then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer == Player then continue end
            if not otherPlayer.Character then continue end
            
            local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if otherHumanoid and otherRoot and otherHumanoid.Health > 0 then
                -- Team check
                if Config.Combat.KILLAURA.TEAM_CHECK then
                    if otherPlayer.Team == Player.Team then continue end
                end
                
                -- Distance check
                local distance = (RootPart.Position - otherRoot.Position).Magnitude
                if distance <= Config.Combat.KILLAURA.RANGE then
                    table.insert(self.Targets, {
                        humanoid = otherHumanoid,
                        root = otherRoot,
                        character = otherPlayer.Character,
                        player = otherPlayer
                    })
                end
            end
        end
    end
    
    -- Find NPCs
    if Config.Combat.KILLAURA.ATTACK_NPCS then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Health > 0 then
                local char = obj.Parent
                if char and char ~= Character and not Players:GetPlayerFromCharacter(char) then
                    local root = char:FindFirstChild("HumanoidRootPart") or 
                                char:FindFirstChild("Torso") or 
                                char:FindFirstChild("Head")
                    
                    if root and RootPart then
                        local distance = (RootPart.Position - root.Position).Magnitude
                        if distance <= Config.Combat.KILLAURA.RANGE then
                            table.insert(self.Targets, {
                                humanoid = obj,
                                root = root,
                                character = char,
                                player = nil
                            })
                        end
                    end
                end
            end
        end
    end
end

-- ============================================
-- PERFORM ATTACK
-- ============================================
function KillAura:Attack()
    if not self.Enabled or not Character or not Humanoid or not RootPart then
        return
    end
    
    -- Rate limiting
    local currentTime = tick()
    if currentTime - self.LastAttack < Config.Combat.KILLAURA.DELAY then
        return
    end
    
    -- Anti-detection delay
    if AntiDetection then
        AntiDetection:AddRandomDelay(Config.AntiDetection.STEALTH_MODE)
    end
    
    -- Find targets
    self:FindTargets()
    
    if #self.Targets == 0 then return end
    
    -- Attack first target
    for _, target in pairs(self.Targets) do
        if target.humanoid and target.humanoid.Health > 0 then
            -- Face target (if enabled)
            if Config.Combat.KILLAURA.FACE_TARGET then
                RootPart.CFrame = CFrame.new(
                    RootPart.Position,
                    Vector3.new(target.root.Position.X, RootPart.Position.Y, target.root.Position.Z)
                )
            end
            
            -- Method 1: Tool activation
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                
                -- Anti-detection delay
                if AntiDetection then
                    AntiDetection:AddRandomDelay(Config.AntiDetection.STEALTH_MODE)
                end
                
                -- Try to fire remotes
                for _, descendant in pairs(tool:GetDescendants()) do
                    if descendant:IsA("RemoteEvent") then
                        pcall(function()
                            descendant:FireServer(target.root)
                            descendant:FireServer("Hit", target.root)
                            descendant:FireServer(target.humanoid)
                        end)
                    elseif descendant:IsA("RemoteFunction") then
                        pcall(function()
                            descendant:InvokeServer(target.root)
                        end)
                    end
                end
            end
            
            -- Method 2: Direct damage (fallback)
            pcall(function()
                target.humanoid:TakeDamage(target.humanoid.MaxHealth / 10)
            end)
            
            -- Update last attack time
            self.LastAttack = currentTime
            
            -- Only attack one target per cycle
            break
        end
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function KillAura:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    -- Notify user
    if Notifications then
        Notifications:Show("KillAura", self.Enabled, nil, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function KillAura:Enable()
    if Connection then return end
    
    Connection = RunService.Heartbeat:Connect(function()
        self:Attack()
    end)
    
    print("[KillAura] ⚔️ Enabled")
end

-- ============================================
-- DISABLE
-- ============================================
function KillAura:Disable()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    self.Targets = {}
    print("[KillAura] ❌ Disabled")
end

-- ============================================
-- UPDATE SETTINGS
-- ============================================
function KillAura:SetRange(range)
    Config.Combat.KILLAURA.RANGE = math.clamp(range, 5, 100)
    print("[KillAura] Range set to: " .. range)
end

function KillAura:SetDelay(delay)
    Config.Combat.KILLAURA.DELAY = math.clamp(delay, 0.05, 1)
    print("[KillAura] Delay set to: " .. delay)
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function KillAura:OnRespawn(newCharacter, newHumanoid, newRootPart)
    Character = newCharacter
    Humanoid = newHumanoid
    RootPart = newRootPart
    
    self.Targets = {}
    print("[KillAura] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function KillAura:Destroy()
    self:Disable()
    self.Targets = {}
    print("[KillAura] ✅ Destroyed")
end

-- Export
print("[KillAura] Module loaded v" .. KillAura.Version)
return KillAura
