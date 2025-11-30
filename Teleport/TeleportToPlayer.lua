-- ============================================
-- NullHub TeleportToPlayer.lua - Player Teleport System
-- Created by Debbhai
-- Version: 1.0.0
-- Smooth tween-based teleportation with player selection
-- ============================================

local TeleportToPlayer = {
    Version = "1.0.0",
    SelectedPlayer = nil,
    IsTeleporting = false,
    CurrentTween = nil,
    PlayerList = {}
}

-- Dependencies
local Players, TweenService, RunService
local Player, Character, RootPart
local Config, Notifications

-- Internal State
local PlayerDropdownRef = nil
local PlayerDropdownUpdateCallback = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function TeleportToPlayer:Initialize(player, rootPart, config, notifications)
    -- Store dependencies
    Players = game:GetService("Players")
    TweenService = game:GetService("TweenService")
    RunService = game:GetService("RunService")
    
    Player = player
    RootPart = rootPart
    Character = player.Character or player.CharacterAdded:Wait()
    Config = config
    Notifications = notifications
    
    -- Monitor player changes
    self:SetupPlayerMonitoring()
    
    print("[TeleportToPlayer] ✅ Initialized")
    return true
end

-- ============================================
-- SETUP PLAYER MONITORING
-- ============================================
function TeleportToPlayer:SetupPlayerMonitoring()
    -- Monitor players joining
    Players.PlayerAdded:Connect(function(newPlayer)
        self:UpdatePlayerList()
        
        -- Wait for character
        newPlayer.CharacterAdded:Connect(function()
            task.wait(1)
            self:UpdatePlayerList()
        end)
    end)
    
    -- Monitor players leaving
    Players.PlayerRemoving:Connect(function(removedPlayer)
        -- Clear selection if they leave
        if self.SelectedPlayer == removedPlayer then
            self.SelectedPlayer = nil
            
            if Notifications then
                Notifications:Show("Teleport", false, "Selected player left", 2)
            end
        end
        
        self:UpdatePlayerList()
    end)
end

-- ============================================
-- UPDATE PLAYER LIST
-- ============================================
function TeleportToPlayer:UpdatePlayerList()
    self.PlayerList = {}
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= Player then
            table.insert(self.PlayerList, {
                Player = otherPlayer,
                DisplayName = otherPlayer.DisplayName or otherPlayer.Name,
                Username = otherPlayer.Name,
                HasCharacter = otherPlayer.Character ~= nil,
                Distance = self:GetDistanceToPlayer(otherPlayer)
            })
        end
    end
    
    -- Sort by distance
    table.sort(self.PlayerList, function(a, b)
        if a.Distance and b.Distance then
            return a.Distance < b.Distance
        end
        return false
    end)
    
    -- Call update callback if exists
    if PlayerDropdownUpdateCallback then
        PlayerDropdownUpdateCallback(self.PlayerList)
    end
    
    return self.PlayerList
end

-- ============================================
-- GET DISTANCE TO PLAYER
-- ============================================
function TeleportToPlayer:GetDistanceToPlayer(targetPlayer)
    if not RootPart or not targetPlayer.Character then
        return nil
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        return nil
    end
    
    return (RootPart.Position - targetRoot.Position).Magnitude
end

-- ============================================
-- SELECT PLAYER
-- ============================================
function TeleportToPlayer:SelectPlayer(targetPlayer)
    if not targetPlayer or not Players:FindFirstChild(targetPlayer.Name) then
        warn("[TeleportToPlayer] Invalid player")
        return false
    end
    
    self.SelectedPlayer = targetPlayer
    
    if Notifications then
        Notifications:Show(
            "Teleport", 
            true, 
            "Selected: " .. targetPlayer.Name, 
            2
        )
    end
    
    print("[TeleportToPlayer] Selected: " .. targetPlayer.Name)
    return true
end

-- ============================================
-- TELEPORT TO SELECTED PLAYER
-- ============================================
function TeleportToPlayer:Teleport()
    -- Check if already teleporting
    if self.IsTeleporting then
        warn("[TeleportToPlayer] Already teleporting!")
        return false
    end
    
    -- Validate selected player
    if not self.SelectedPlayer then
        if Notifications then
            Notifications:Show("Teleport", false, "No player selected!", 2)
        end
        return false
    end
    
    -- Check if player still exists
    if not Players:FindFirstChild(self.SelectedPlayer.Name) then
        self.SelectedPlayer = nil
        if Notifications then
            Notifications:Show("Teleport", false, "Player left the game!", 2)
        end
        return false
    end
    
    -- Validate player character
    if not self.SelectedPlayer.Character then
        if Notifications then
            Notifications:Show("Teleport", false, "Player has no character!", 2)
        end
        return false
    end
    
    local targetRoot = self.SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not RootPart then
        if Notifications then
            Notifications:Show("Teleport", false, "Target unavailable!", 2)
        end
        return false
    end
    
    -- Start teleport
    self.IsTeleporting = true
    
    if Notifications then
        Notifications:Show(
            "Teleport", 
            true, 
            "Teleporting to " .. self.SelectedPlayer.Name, 
            3
        )
    end
    
    -- Calculate teleport properties
    local offsetDistance = Config.Teleport.OFFSET_DISTANCE or 3
    local offsetHeight = Config.Teleport.OFFSET_HEIGHT or 3
    
    local targetCFrame = targetRoot.CFrame * CFrame.new(0, offsetHeight, offsetDistance)
    local distance = (RootPart.Position - targetCFrame.Position).Magnitude
    local speed = Config.Teleport.SPEED or 150
    local duration = distance / speed
    
    -- Clamp duration
    local minDuration = Config.Teleport.MIN_DURATION or 0.5
    local maxDuration = Config.Teleport.MAX_DURATION or 10
    duration = math.clamp(duration, minDuration, maxDuration)
    
    -- Create tween
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )
    
    self.CurrentTween = TweenService:Create(
        RootPart,
        tweenInfo,
        {CFrame = targetCFrame}
    )
    
    -- Play tween
    self.CurrentTween:Play()
    
    -- Handle completion
    self.CurrentTween.Completed:Connect(function(playbackState)
        if playbackState == Enum.PlaybackState.Completed then
            if Notifications then
                Notifications:Show("Teleport", true, "Teleport complete!", 2)
            end
        elseif playbackState == Enum.PlaybackState.Cancelled then
            if Notifications then
                Notifications:Show("Teleport", false, "Teleport cancelled!", 2)
            end
        end
        
        self.IsTeleporting = false
        self.CurrentTween = nil
    end)
    
    print("[TeleportToPlayer] 🚀 Teleporting to: " .. self.SelectedPlayer.Name)
    return true
end

-- ============================================
-- INSTANT TELEPORT (No Tween)
-- ============================================
function TeleportToPlayer:InstantTeleport()
    -- Validate
    if not self.SelectedPlayer or not self.SelectedPlayer.Character then
        if Notifications then
            Notifications:Show("Teleport", false, "No player selected!", 2)
        end
        return false
    end
    
    local targetRoot = self.SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not RootPart then
        if Notifications then
            Notifications:Show("Teleport", false, "Target unavailable!", 2)
        end
        return false
    end
    
    -- Instant teleport
    local offsetDistance = Config.Teleport.OFFSET_DISTANCE or 3
    local offsetHeight = Config.Teleport.OFFSET_HEIGHT or 3
    
    RootPart.CFrame = targetRoot.CFrame * CFrame.new(0, offsetHeight, offsetDistance)
    
    if Notifications then
        Notifications:Show("Teleport", true, "Instant teleport to " .. self.SelectedPlayer.Name, 2)
    end
    
    print("[TeleportToPlayer] ⚡ Instant teleport to: " .. self.SelectedPlayer.Name)
    return true
end

-- ============================================
-- STOP TELEPORT
-- ============================================
function TeleportToPlayer:Stop()
    if not self.IsTeleporting then
        return false
    end
    
    if self.CurrentTween then
        self.CurrentTween:Cancel()
        self.CurrentTween = nil
    end
    
    self.IsTeleporting = false
    
    if Notifications then
        Notifications:Show("Teleport", false, "Teleport stopped!", 2)
    end
    
    print("[TeleportToPlayer] ⏹ Teleport stopped")
    return true
end

-- ============================================
-- TELEPORT TO PLAYER BY NAME
-- ============================================
function TeleportToPlayer:TeleportToPlayerName(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    
    if not targetPlayer then
        if Notifications then
            Notifications:Show("Teleport", false, "Player not found: " .. playerName, 2)
        end
        return false
    end
    
    self:SelectPlayer(targetPlayer)
    return self:Teleport()
end

-- ============================================
-- TELEPORT TO CLOSEST PLAYER
-- ============================================
function TeleportToPlayer:TeleportToClosest()
    self:UpdatePlayerList()
    
    if #self.PlayerList == 0 then
        if Notifications then
            Notifications:Show("Teleport", false, "No players available!", 2)
        end
        return false
    end
    
    -- Get closest player
    local closestPlayer = self.PlayerList[1].Player
    
    self:SelectPlayer(closestPlayer)
    return self:Teleport()
end

-- ============================================
-- CREATE PLAYER DROPDOWN (For GUI Integration)
-- ============================================
function TeleportToPlayer:CreatePlayerDropdown(parent, theme)
    local dropdown = Instance.new("ScrollingFrame")
    dropdown.Name = "PlayerDropdown"
    dropdown.Size = UDim2.new(1, -16, 0, 90)
    dropdown.Position = UDim2.new(0, 8, 0, 46)
    dropdown.BackgroundColor3 = theme.Colors.DropdownBackground
    dropdown.BackgroundTransparency = theme.Transparency.Dropdown
    dropdown.BorderSizePixel = 0
    dropdown.ScrollBarThickness = 4
    dropdown.ScrollBarImageColor3 = theme.Colors.ScrollBarColor
    dropdown.ScrollBarImageTransparency = theme.Transparency.ScrollBar
    dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropdown.Parent = parent
    
    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 7)
    
    -- List layout
    local listLayout = Instance.new("UIListLayout", dropdown)
    listLayout.Padding = UDim.new(0, 4)
    
    -- Padding
    local padding = Instance.new("UIPadding", dropdown)
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 6)
    
    -- Placeholder
    local placeholder = Instance.new("TextLabel")
    placeholder.Name = "PlaceholderText"
    placeholder.Size = UDim2.new(1, -16, 0, 30)
    placeholder.Position = UDim2.new(0, 8, 0, 8)
    placeholder.BackgroundTransparency = 1
    placeholder.Text = "Select a player..."
    placeholder.TextColor3 = theme.Colors.TextPlaceholder
    placeholder.TextSize = 13
    placeholder.Font = Enum.Font.Gotham
    placeholder.TextXAlignment = Enum.TextXAlignment.Left
    placeholder.Parent = dropdown
    
    -- Update function
    local function updateDropdown(playerList)
        -- Clear existing buttons
        for _, child in pairs(dropdown:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local hasPlayers = #playerList > 0
        placeholder.Visible = not hasPlayers
        
        -- Create player buttons
        for _, playerData in pairs(playerList) do
            local playerBtn = Instance.new("TextButton")
            playerBtn.Name = playerData.Username
            playerBtn.Size = UDim2.new(1, -8, 0, 28)
            playerBtn.BackgroundColor3 = theme.Colors.PlayerButtonBg
            playerBtn.BackgroundTransparency = theme.Transparency.PlayerButton
            playerBtn.BorderSizePixel = 0
            
            -- Display name with distance
            local displayText = playerData.DisplayName
            if playerData.Distance then
                displayText = displayText .. " (" .. math.floor(playerData.Distance) .. " studs)"
            end
            
            playerBtn.Text = displayText
            playerBtn.TextColor3 = theme.Colors.TextPrimary
            playerBtn.TextSize = 13
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.TextXAlignment = Enum.TextXAlignment.Left
            playerBtn.Parent = dropdown
            
            Instance.new("UICorner", playerBtn).CornerRadius = UDim.new(0, 5)
            
            local padding = Instance.new("UIPadding", playerBtn)
            padding.PaddingLeft = UDim.new(0, 10)
            
            -- Click to select
            playerBtn.MouseButton1Click:Connect(function()
                self:SelectPlayer(playerData.Player)
                
                -- Highlight selected
                for _, btn in pairs(dropdown:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundTransparency = theme.Transparency.PlayerButton
                    end
                end
                
                playerBtn.BackgroundTransparency = 0.15
            end)
        end
    end
    
    -- Register callback
    PlayerDropdownUpdateCallback = updateDropdown
    PlayerDropdownRef = dropdown
    
    -- Initial update
    self:UpdatePlayerList()
    
    return dropdown
end

-- ============================================
-- REFRESH DROPDOWN
-- ============================================
function TeleportToPlayer:RefreshDropdown()
    self:UpdatePlayerList()
end

-- ============================================
-- GET SELECTED PLAYER
-- ============================================
function TeleportToPlayer:GetSelectedPlayer()
    return self.SelectedPlayer
end

function TeleportToPlayer:GetSelectedPlayerName()
    if self.SelectedPlayer then
        return self.SelectedPlayer.Name
    end
    return nil
end

-- ============================================
-- GET TELEPORT STATUS
-- ============================================
function TeleportToPlayer:IsTeleporting()
    return self.IsTeleporting
end

function TeleportToPlayer:GetStatus()
    return {
        IsTeleporting = self.IsTeleporting,
        SelectedPlayer = self.SelectedPlayer and self.SelectedPlayer.Name or nil,
        PlayerCount = #self.PlayerList,
        HasTween = self.CurrentTween ~= nil
    }
end

-- ============================================
-- UPDATE SETTINGS
-- ============================================
function TeleportToPlayer:SetSpeed(speed)
    Config.Teleport.SPEED = math.clamp(speed, 10, 1000)
    print("[TeleportToPlayer] Speed set to: " .. speed)
end

function TeleportToPlayer:SetOffset(distance, height)
    Config.Teleport.OFFSET_DISTANCE = distance or 3
    Config.Teleport.OFFSET_HEIGHT = height or 3
    print(string.format("[TeleportToPlayer] Offset set to: %d studs, %d height", distance, height))
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function TeleportToPlayer:OnRespawn(newCharacter, newHumanoid, newRootPart)
    -- Stop any ongoing teleport
    self:Stop()
    
    -- Update references
    Character = newCharacter
    RootPart = newRootPart
    
    -- Update player list
    task.wait(1)
    self:UpdatePlayerList()
    
    print("[TeleportToPlayer] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function TeleportToPlayer:Destroy()
    self:Stop()
    
    self.SelectedPlayer = nil
    self.PlayerList = {}
    PlayerDropdownUpdateCallback = nil
    PlayerDropdownRef = nil
    
    print("[TeleportToPlayer] ✅ Destroyed")
end

-- Export
print("[TeleportToPlayer] Module loaded v" .. TeleportToPlayer.Version)
return TeleportToPlayer
