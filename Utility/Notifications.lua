-- Utility/Notifications.lua
-- Centralized notification system for NullHub
-- Handles all feature toggle notifications

local Notifications = {
    Version = "1.0.0",
    Author = "Debbhai",
    Queue = {},
    CurrentNotification = nil,
    Config = {
        Duration = 3,           -- Default duration in seconds
        Position = "TopRight",  -- TopRight, TopLeft, BottomRight, BottomLeft, Center
        AnimationSpeed = 0.5,   -- Slide-in animation speed
        MaxQueue = 5,           -- Maximum queued notifications
        ShowIcon = true,        -- Show emoji icons
        PlaySound = false       -- Future: notification sounds
    }
}

-- Icons for different notification types
local Icons = {
    Enable = "✅",
    Disable = "❌",
    Success = "✅",
    Error = "⚠️",
    Info = "ℹ️",
    Warning = "⚠️",
    Loading = "⏳",
    Update = "🔄"
}

-- Feature-specific icons
local FeatureIcons = {
    -- Combat
    Aimbot = "🎯",
    ESP = "👁️",
    KillAura = "⚔️",
    FastM1 = "👊",
    
    -- Movement
    Fly = "🕊️",
    NoClip = "👻",
    InfiniteJump = "🦘",
    Speed = "⚡",
    WalkOnWater = "🌊",
    
    -- Visual
    FullBright = "💡",
    GodMode = "🛡️",
    
    -- Teleport
    TeleportToPlayer = "🚀",
    
    -- System
    Theme = "🎨",
    Config = "⚙️"
}

-- Initialize notification system
function Notifications:Initialize(screenGui, theme)
    if not screenGui then
        warn("[Notifications] No ScreenGui provided!")
        return false
    end
    
    self.ScreenGui = screenGui
    self.Theme = theme or self:GetDefaultTheme()
    self.Initialized = true
    
    print("[Notifications] ✅ Initialized")
    return true
end

-- Get default theme if Theme module not loaded
function Notifications:GetDefaultTheme()
    return {
        Colors = {
            NotificationBg = Color3.fromRGB(15, 15, 18),
            AccentBar = Color3.fromRGB(255, 215, 0),
            TextPrimary = Color3.fromRGB(255, 255, 255)
        },
        Transparency = {
            Notification = 0.1
        },
        Sizes = {
            NotificationWidth = 300,
            NotificationHeight = 60
        },
        CornerRadius = {
            Medium = 10
        },
        FontSizes = {
            Action = 14
        },
        Fonts = {
            Action = Enum.Font.Gotham
        }
    }
end

-- Main notification function
function Notifications:Show(featureName, isEnabled, customMessage, duration)
    if not self.Initialized then
        warn("[Notifications] Not initialized!")
        return
    end
    
    -- Build message
    local message
    if customMessage then
        message = customMessage
    else
        local statusText = isEnabled and "ON" or "OFF"
        local statusIcon = isEnabled and Icons.Enable or Icons.Disable
        local featureIcon = FeatureIcons[featureName] or "🔧"
        
        if self.Config.ShowIcon then
            message = string.format("%s %s %s", featureIcon, featureName, statusText)
        else
            message = string.format("%s %s", featureName, statusText)
        end
    end
    
    -- Add to queue
    local notificationData = {
        message = message,
        duration = duration or self.Config.Duration,
        timestamp = tick()
    }
    
    -- Check queue limit
    if #self.Queue >= self.Config.MaxQueue then
        table.remove(self.Queue, 1) -- Remove oldest
    end
    
    table.insert(self.Queue, notificationData)
    
    -- Process queue if no notification is showing
    if not self.CurrentNotification then
        self:ProcessQueue()
    end
end

-- Process notification queue
function Notifications:ProcessQueue()
    if #self.Queue == 0 then
        self.CurrentNotification = nil
        return
    end
    
    local notifData = table.remove(self.Queue, 1)
    self:CreateNotification(notifData.message, notifData.duration)
end

-- Create notification UI
function Notifications:CreateNotification(message, duration)
    local theme = self.Theme
    
    -- Create notification frame
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, theme.Sizes.NotificationWidth, 0, theme.Sizes.NotificationHeight)
    notification.BackgroundColor3 = theme.Colors.NotificationBg
    notification.BackgroundTransparency = 1
    notification.BorderSizePixel = 0
    notification.ZIndex = 10000
    notification.Parent = self.ScreenGui
    
    -- Position based on config
    local startPos, endPos = self:GetPositions(theme)
    notification.Position = startPos
    
    -- Rounded corners
    local corner = Instance.new("UICorner", notification)
    corner.CornerRadius = UDim.new(0, theme.CornerRadius.Medium)
    
    -- Border stroke
    local stroke = Instance.new("UIStroke", notification)
    stroke.Color = theme.Colors.AccentBar
    stroke.Thickness = 2
    stroke.Transparency = 1
    
    -- Accent bar (left side)
    local accentBar = Instance.new("Frame", notification)
    accentBar.Name = "AccentBar"
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = theme.Colors.AccentBar
    accentBar.BorderSizePixel = 0
    accentBar.BackgroundTransparency = 1
    
    local accentCorner = Instance.new("UICorner", accentBar)
    accentCorner.CornerRadius = UDim.new(0, theme.CornerRadius.Medium)
    
    -- Text label
    local text = Instance.new("TextLabel", notification)
    text.Name = "Text"
    text.Size = UDim2.new(1, -20, 1, 0)
    text.Position = UDim2.new(0, 10, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = theme.Colors.TextPrimary
    text.TextSize = theme.FontSizes.Action
    text.Font = theme.Fonts.Action
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextYAlignment = Enum.TextYAlignment.Center
    text.TextTransparency = 1
    text.TextWrapped = true
    
    self.CurrentNotification = notification
    
    -- Animate in
    self:AnimateIn(notification, stroke, text, accentBar, endPos, duration)
end

-- Get positions based on config
function Notifications:GetPositions(theme)
    local w = theme.Sizes.NotificationWidth
    local h = theme.Sizes.NotificationHeight
    local margin = 10
    
    local positions = {
        TopRight = {
            start = UDim2.new(1, w + 20, 0, margin),
            finish = UDim2.new(1, -w - margin, 0, margin)
        },
        TopLeft = {
            start = UDim2.new(0, -w - 20, 0, margin),
            finish = UDim2.new(0, margin, 0, margin)
        },
        BottomRight = {
            start = UDim2.new(1, w + 20, 1, -h - margin),
            finish = UDim2.new(1, -w - margin, 1, -h - margin)
        },
        BottomLeft = {
            start = UDim2.new(0, -w - 20, 1, -h - margin),
            finish = UDim2.new(0, margin, 1, -h - margin)
        },
        Center = {
            start = UDim2.new(0.5, -w/2, 0.5, -h/2 - 50),
            finish = UDim2.new(0.5, -w/2, 0.5, -h/2)
        }
    }
    
    local pos = positions[self.Config.Position] or positions.TopRight
    return pos.start, pos.finish
end

-- Animate notification in
function Notifications:AnimateIn(notification, stroke, text, accentBar, endPos, duration)
    local TweenService = game:GetService("TweenService")
    local speed = self.Config.AnimationSpeed
    
    -- Slide in
    TweenService:Create(notification, TweenInfo.new(speed, Enum.EasingStyle.Quint), {
        Position = endPos,
        BackgroundTransparency = self.Theme.Transparency.Notification
    }):Play()
    
    TweenService:Create(stroke, TweenInfo.new(speed), {
        Transparency = 0.3
    }):Play()
    
    TweenService:Create(text, TweenInfo.new(speed), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(accentBar, TweenInfo.new(speed), {
        BackgroundTransparency = 0
    }):Play()
    
    -- Wait then slide out
    task.delay(duration, function()
        self:AnimateOut(notification, stroke, text, accentBar)
    end)
end

-- Animate notification out
function Notifications:AnimateOut(notification, stroke, text, accentBar)
    local TweenService = game:GetService("TweenService")
    local speed = self.Config.AnimationSpeed
    local theme = self.Theme
    
    -- Get exit position (opposite of entry)
    local exitPos
    if self.Config.Position == "TopRight" or self.Config.Position == "BottomRight" then
        exitPos = UDim2.new(1, theme.Sizes.NotificationWidth + 20, notification.Position.Y.Scale, notification.Position.Y.Offset)
    elseif self.Config.Position == "TopLeft" or self.Config.Position == "BottomLeft" then
        exitPos = UDim2.new(0, -theme.Sizes.NotificationWidth - 20, notification.Position.Y.Scale, notification.Position.Y.Offset)
    else
        exitPos = UDim2.new(0.5, -theme.Sizes.NotificationWidth/2, 0.5, -theme.Sizes.NotificationHeight/2 - 50)
    end
    
    TweenService:Create(notification, TweenInfo.new(speed, Enum.EasingStyle.Quint), {
        Position = exitPos,
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(stroke, TweenInfo.new(speed), {
        Transparency = 1
    }):Play()
    
    TweenService:Create(text, TweenInfo.new(speed), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(accentBar, TweenInfo.new(speed), {
        BackgroundTransparency = 1
    }):Play()
    
    task.delay(speed + 0.1, function()
        notification:Destroy()
        self.CurrentNotification = nil
        self:ProcessQueue() -- Process next in queue
    end)
end

-- Quick notification methods
function Notifications:Success(message, duration)
    self:Show("Success", true, Icons.Success .. " " .. message, duration)
end

function Notifications:Error(message, duration)
    self:Show("Error", false, Icons.Error .. " " .. message, duration)
end

function Notifications:Info(message, duration)
    self:Show("Info", true, Icons.Info .. " " .. message, duration)
end

function Notifications:Warning(message, duration)
    self:Show("Warning", false, Icons.Warning .. " " .. message, duration)
end

-- Feature toggle notification
function Notifications:FeatureToggle(featureName, isEnabled)
    self:Show(featureName, isEnabled)
end

-- Change notification position
function Notifications:SetPosition(position)
    if position == "TopRight" or position == "TopLeft" or 
       position == "BottomRight" or position == "BottomLeft" or 
       position == "Center" then
        self.Config.Position = position
        return true
    end
    return false
end

-- Change notification duration
function Notifications:SetDuration(seconds)
    if seconds > 0 and seconds <= 10 then
        self.Config.Duration = seconds
        return true
    end
    return false
end

-- Clear notification queue
function Notifications:ClearQueue()
    self.Queue = {}
end

return Notifications
