-- ============================================
-- NullHub ESP.lua - Player Highlighting System
-- Created by Debbhai
-- Version: 1.0.0
-- Wallhack-style player visualization
-- ============================================

local ESP = {
    Version = "1.0.0",
    Enabled = false,
    ESPObjects = {}
}

-- Dependencies
local Players, RunService
local Player, Camera, Character, RootPart
local Config, Theme, Notifications

-- ============================================
-- INITIALIZATION
-- ============================================
function ESP:Initialize(player, camera, config, theme, notifications)
    -- Store dependencies
    Players = game:GetService("Players")
    RunService = game:GetService("RunService")
    
    Player = player
    Camera = camera
    Config = config
    Theme = theme
    Notifications = notifications
    
    Character = Player.Character or Player.CharacterAdded:Wait()
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    print("[ESP] ✅ Initialized")
    return true
end

-- ============================================
-- CREATE ESP FOR PLAYER
-- ============================================
function ESP:CreateESP(targetPlayer)
    -- Check if ESP already exists
    if self.ESPObjects[targetPlayer] then return end
    if not targetPlayer.Character then return end
    
    -- Create Highlight (Modern ESP)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = targetPlayer.Character
    highlight.FillColor = Config.Combat.ESP.COLOR
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = targetPlayer.Character
    
    -- Create Billboard GUI for name/distance
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then
        highlight:Destroy()
        return
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_Billboard"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Config.Combat.ESP.COLOR
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 16
    textLabel.Text = targetPlayer.Name
    textLabel.Parent = billboardGui
    
    -- Store ESP objects
    self.ESPObjects[targetPlayer] = {
        highlight = highlight,
        billboard = billboardGui,
        label = textLabel
    }
    
    -- Update connection for distance
    local updateConnection
    updateConnection = RunService.RenderStepped:Connect(function()
        if not self.Enabled or not targetPlayer.Character or not RootPart then
            updateConnection:Disconnect()
            return
        end
        
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and Config.Combat.ESP.SHOW_DISTANCE then
            local distance = (RootPart.Position - targetRoot.Position).Magnitude
            textLabel.Text = targetPlayer.Name .. "\n" .. math.floor(distance) .. " studs"
        else
            textLabel.Text = targetPlayer.Name
        end
        
        -- Health bar (if enabled)
        if Config.Combat.ESP.SHOW_HEALTH then
            local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                textLabel.Text = textLabel.Text .. "\n[" .. healthPercent .. "%]"
            end
        end
    end)
    
    self.ESPObjects[targetPlayer].connection = updateConnection
end

-- ============================================
-- REMOVE ESP FROM PLAYER
-- ============================================
function ESP:RemoveESP(targetPlayer)
    if not self.ESPObjects[targetPlayer] then return end
    
    local espData = self.ESPObjects[targetPlayer]
    
    -- Destroy objects safely
    pcall(function()
        if espData.highlight then
            espData.highlight:Destroy()
        end
        if espData.billboard then
            espData.billboard:Destroy()
        end
        if espData.connection then
            espData.connection:Disconnect()
        end
    end)
    
    self.ESPObjects[targetPlayer] = nil
end

-- ============================================
-- UPDATE ALL ESP
-- ============================================
function ESP:UpdateAll()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer == Player then continue end
        if not otherPlayer.Character then continue end
        
        -- Team check
        if Config.Combat.ESP.TEAM_CHECK then
            if otherPlayer.Team == Player.Team then
                self:RemoveESP(otherPlayer)
                continue
            end
        end
        
        -- Distance check
        if Config.Combat.ESP.MAX_DISTANCE then
            local targetRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot and RootPart then
                local distance = (RootPart.Position - targetRoot.Position).Magnitude
                if distance > Config.Combat.ESP.MAX_DISTANCE then
                    self:RemoveESP(otherPlayer)
                    continue
                end
            end
        end
        
        -- Create or keep ESP
        if self.Enabled then
            self:CreateESP(otherPlayer)
        else
            self:RemoveESP(otherPlayer)
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
    
    -- Notify user
    if Notifications then
        Notifications:Show("ESP", self.Enabled, nil, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function ESP:Enable()
    self:UpdateAll()
    
    -- Monitor new players
    self.PlayerAddedConnection = Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.CharacterAdded:Connect(function()
            task.wait(1)
            if self.Enabled then
                self:CreateESP(newPlayer)
            end
        end)
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
    if self.PlayerAddedConnection then
        self.PlayerAddedConnection:Disconnect()
        self.PlayerAddedConnection = nil
    end
    
    print("[ESP] ❌ Disabled")
end

-- ============================================
-- UPDATE COLOR
-- ============================================
function ESP:SetColor(color)
    Config.Combat.ESP.COLOR = color
    
    -- Update existing ESP
    for _, espData in pairs(self.ESPObjects) do
        if espData.highlight then
            espData.highlight.FillColor = color
        end
        if espData.label then
            espData.label.TextColor3 = color
        end
    end
    
    print("[ESP] Color updated")
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function ESP:OnRespawn(newCharacter, newHumanoid, newRootPart)
    Character = newCharacter
    RootPart = newRootPart
    
    -- Refresh ESP after respawn
    if self.Enabled then
        task.wait(0.5)
        self:UpdateAll()
    end
    
    print("[ESP] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function ESP:Destroy()
    self:Disable()
    self.ESPObjects = {}
    print("[ESP] ✅ Destroyed")
end

-- Export
print("[ESP] Module loaded v" .. ESP.Version)
return ESP
