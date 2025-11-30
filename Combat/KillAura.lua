-- ============================================
-- NullHub KillAura.lua - Auto Attack System
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- ============================================

local KillAura = {
    Version = "1.0.0",
    Enabled = false,
    Targets = {}
}

-- Dependencies
local Players, RunService
local Player, Character
local Config, AntiDetection, Notifications

-- Internal State
local Connection = nil
local LastHit = 0

-- ============================================
-- INITIALIZATION
-- ============================================
function KillAura:Initialize(player, character, config, antiDetection, notifications)
    Players = game:GetService("Players")
    RunService = game:GetService("RunService")
    
    Player = player
    Character = character
    Config = config
    AntiDetection = antiDetection
    Notifications = notifications
    
    print("[KillAura] ✅ Initialized")
    return true
end

-- ============================================
-- FIND ALL TARGETS
-- ============================================
function KillAura:FindTargets()
    self.Targets = {}
    
    local rootPart = Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Find players
    if Config.Combat.KILLAURA.ATTACK_PLAYERS then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= Player and otherPlayer.Character then
                local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and otherRoot and humanoid.Health > 0 then
                    -- Team check
                    if Config.Combat.KILLAURA.TEAM_CHECK and otherPlayer.Team == Player.Team then
                        continue
                    end
                    
                    local distance = (rootPart.Position - otherRoot.Position).Magnitude
                    
                    if distance <= Config.Combat.KILLAURA.RANGE then
                        table.insert(self.Targets, {
                            humanoid = humanoid,
                            root = otherRoot,
                            character = otherPlayer.Character
                        })
                    end
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
                    local npcRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
                    
                    if npcRoot then
                        local distance = (rootPart.Position - npcRoot.Position).Magnitude
                        
                        if distance <= Config.Combat.KILLAURA.RANGE then
                            table.insert(self.Targets, {
                                humanoid = obj,
                                root = npcRoot,
                                character = char
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
function KillAura:PerformAttack()
    if not self.Enabled or not Character then return end
    
    local currentTime = tick()
    if currentTime - LastHit < Config.Combat.KILLAURA.DELAY then
        return
    end
    
    -- Add stealth delay
    if AntiDetection then
        AntiDetection:AddRandomDelay(Config.AntiDetection.STEALTH_MODE)
    end
    
    -- Find targets
    self:FindTargets()
    
    if #self.Targets == 0 then return end
    
    -- Attack first target
    for _, target in pairs(self.Targets) do
        if target.humanoid and target.humanoid.Health > 0 then
            -- Face target (optional)
            if Config.Combat.KILLAURA.FACE_TARGET then
                local rootPart = Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CFrame = CFrame.new(rootPart.Position, target.root.Position)
                end
            end
            
            -- Activate tool
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                
                -- Fire remotes
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
            
            -- Damage target (fallback)
            pcall(function()
                target.humanoid:TakeDamage(target.humanoid.MaxHealth / 10)
            end)
            
            LastHit = currentTime
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
        self:PerformAttack()
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
-- CHARACTER RESPAWN
-- ============================================
function KillAura:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    self:Disable()
    Character = newCharacter
    
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[KillAura] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function KillAura:Destroy()
    self:Disable()
    print("[KillAura] ✅ Destroyed")
end

print("[KillAura] Module loaded v" .. KillAura.Version)
return KillAura
