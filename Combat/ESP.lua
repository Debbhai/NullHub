-- ============================================
-- NullHub ESP.lua - Player ESP System
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- ============================================

local ESP = {
    Version = "1.0.0",
    Enabled = false,
    ESPObjects = {}
}

-- Dependencies
local Players, RunService
local Player, Camera
local Config, Theme, Notifications

-- Internal State
local Connections = {}

-- ============================================
-- INITIALIZATION
-- ============================================
function ESP:Initialize(player, camera, config, theme, notifications)
    Players = game:GetService("Players")
    RunService = game:GetService("RunService")
    
    Player = player
    Camera = camera
    Config = config
    Theme = theme
    Notifications = notifications
    
    print("[ESP] ✅ Initialized")
    return true
end

-- ============================================
-- CREATE ESP FOR PLAYER
-- ============================================
function ESP:CreateESP(targetPlayer)
    if self.ESPObjects[targetPlayer] or not targetPlayer.Character then
        return
    end
    
    -- Create highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = targetPlayer.Character
    highlight.FillColor = Config.Combat.ESP.COLOR
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = targetPlayer.Character
    
    -- Create billboard GUI
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESPBillboard"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head
    
    local textLabel = Instance.new("TextLabel", billboardGui)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Config.Combat.ESP.COLOR
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    
    self.ESPObjects[targetPlayer] = {
        highlight = highlight,
        billboard = billboardGui,
        label = textLabel
    }
    
    -- Update connection
    local updateConnection
    updateConnection = RunService.RenderStepped:Connect(function()
        if not self.Enabled or not targetPlayer.Character or not Player.Character then
            updateConnection:Disconnect()
            return
        end
        
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local playerRoot = Player.Character:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and playerRoot then
            local distance = (playerRoot.Position - targetRoot.Position).Magnitude
            
            -- Max distance check
            if distance > Config.Combat.ESP.MAX_DISTANCE then
                textLabel.Text = ""
                highlight.Enabled = false
                return
            end
            
            highlight.Enabled = true
            
            -- Build text
            local text = ""
            
            if Config.Combat.ESP.SHOW_NAME then
                text = targetPlayer.Name
            end
            
            if Config.Combat.ESP.SHOW_DISTANCE then
                text = text .. " [" .. math.floor(distance) .. " studs]"
            end
            
            if Config.Combat.ESP.SHOW_HEALTH then
                local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    text = text .. " (" .. math.floor(humanoid.Health) .. "HP)"
                end
            end
            
            textLabel.Text = text
        end
    end)
end

-- ============================================
-- REMOVE ESP FROM PLAYER
-- ============================================
function ESP:RemoveESP(targetPlayer)
    if self.ESPObjects[targetPlayer] then
        pcall(function()
            if self.ESPObjects[targetPlayer].highlight then
                self.ESPObjects[targetPlayer].highlight:Destroy()
            end
            if self.ESPObjects[targetPlayer].billboard then
                self.ESPObjects[targetPlayer].billboard:Destroy()
            end
        end)
        
        self.ESPObjects[targetPlayer] = nil
    end
end

-- ============================================
-- UPDATE ESP
-- ============================================
function ESP:UpdateESP()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character then
            -- Team check
            if Config.Combat.ESP.TEAM_CHECK and otherPlayer.Team == Player.Team then
                self:RemoveESP(otherPlayer)
                continue
            end
            
            if self.Enabled then
                self:CreateESP(otherPlayer)
            else
                self:RemoveESP(otherPlayer)
            end
        end
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function ESP:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    if Notifications then
        Notifications:Show("ESP", self.Enabled, nil, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function ESP:Enable()
    self:UpdateESP()
    
    -- Monitor new players
    Connections.PlayerAdded = Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.CharacterAdded:Connect(function()
            task.wait(1)
            if self.Enabled then
                self:CreateESP(newPlayer)
            end
        end)
    end)
    
    -- Monitor leaving players
    Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(removedPlayer)
        self:RemoveESP(removedPlayer)
    end)
    
    print("[ESP] 👁️ Enabled")
end

-- ============================================
-- DISABLE
-- ============================================
function ESP:Disable()
    -- Remove all ESP
    for player, _ in pairs(self.ESPObjects) do
        self:RemoveESP(player)
    end
    
    -- Disconnect connections
    for name, connection in pairs(Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    Connections = {}
    
    print("[ESP] ❌ Disabled")
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function ESP:OnRespawn(newCharacter, newHumanoid, newRootPart)
    if self.Enabled then
        task.wait(1)
        self:UpdateESP()
    end
    
    print("[ESP] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function ESP:Destroy()
    self:Disable()
    print("[ESP] ✅ Destroyed")
end

print("[ESP] Module loaded v" .. ESP.Version)
return ESP
