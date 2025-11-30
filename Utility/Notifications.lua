-- ============================================
-- NullHub Notifications.lua - FIXED VERSION
-- Created by Debbhai
-- Version: 1.0.1 HOTFIX
-- Safe theme access with fallback
-- ============================================

local Notifications = {
    Version = "1.0.1",
    Queue = {},
    CurrentNotification = nil,
    Initialized = false
}

-- Configuration
local Config = {
    Duration = 3,
    Position = "TopRight",
    AnimationSpeed = 0.5,
    MaxQueue = 5,
    ShowIcon = true
}

-- Icons
local Icons = {
    Enable = "✅", Disable = "❌", Success = "✅", Error = "⚠️",
    Info = "ℹ️", Warning = "⚠️", Loading = "⏳", Update = "🔄"
}

-- Feature Icons
local FeatureIcons = {
    Aimbot = "🎯", ESP = "👁️", KillAura = "⚔️", FastM1 = "👊",
    Fly = "🕊️", NoClip = "👻", InfiniteJump = "🦘", Speed = "⚡", WalkOnWater = "🌊",
    FullBright = "💡", GodMode = "🛡️",
    TeleportToPlayer = "🚀",
    Theme = "🎨", Config = "⚙️"
}

-- ============================================
-- DEFAULT THEME (SAFE FALLBACK)
-- ============================================
local function GetDefaultTheme()
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

-- ============================================
-- INITIALIZATION (SAFE)
-- ============================================
function Notifications:Initialize(screenGui, theme)
    if not screenGui then
        warn("[Notifications] No ScreenGui provided!")
        return false
    end
    
    self.ScreenGui = screenGui
    
    -- Safe theme assignment with fallback
    if theme and type(theme) == "table" then
        -- Validate theme has required properties
        if theme.Colors and theme.Colors.NotificationBg then
            self.Theme = theme
        else
            warn("[Notifications] Invalid theme, using default")
            self.Theme = GetDefaultTheme()
        end
    else
        warn("[Notifications] No theme provided, using default")
        self.Theme = GetDefaultTheme()
    end
    
    self.Initialized = true
    print("[Notifications] ✅ Initialized")
    return true
end

-- ============================================
-- SAFE THEME ACCESS
-- ============================================
local function SafeGetThemeValue(theme, path, default)
    local current = theme
    
    for part in string.gmatch(path, "[^.]+") do
        if type(current) == "table" and current[part] ~= nil then
            current = current[part]
        else
            return default
        end
    end
    
    return current
end

-- ============================================
-- SHOW NOTIFICATION
-- ============================================
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
        
        if Config.ShowIcon then
            message = string.format("%s %s %s", featureIcon, featureName, statusText)
        else
            message = string.format("%s %s", featureName, statusText)
        end
    end
    
    -- Add to queue
    local notificationData = {
        message = message,
        duration = duration or Config.Duration,
        timestamp = tick()
    }
    
    if #self.Queue >= Config.MaxQueue then
        table.remove(self.Queue, 1)
    end
    
    table.insert(self.Queue, notificationData)
    
    if not self.CurrentNotification then
        self:ProcessQueue()
    end
end

-- ============================================
-- PROCESS QUEUE
-- ============================================
function Notifications:ProcessQueue()
    if #self.Queue == 0 then
        self.CurrentNotification = nil
        return
    end
    
    local notifData = table.remove(self.Queue, 1)
    self:CreateNotification(notifData.message, notifData.duration)
end

-- ============================================
-- CREATE NOTIFICATION (SAFE)
-- ============================================
function Notifications:CreateNotification(message, duration)
    local theme = self.Theme or GetDefaultTheme()
    local TweenService = game:GetService("TweenService")
    
    -- Safe theme value extraction
    local bgColor = SafeGetThemeValue(theme, "Colors.NotificationBg", Color3.fromRGB(15, 15, 18))
    local accentColor = SafeGetThemeValue(theme, "Colors.AccentBar", Color3.fromRGB(255, 215, 0))
    local textColor = SafeGetThemeValue(theme, "Colors.TextPrimary", Color3.fromRGB(255, 255, 255))
    local bgTrans = SafeGetThemeValue(theme, "Transparency.Notification", 0.1)
    local width = SafeGetThemeValue(theme, "Sizes.NotificationWidth", 300)
    local height = SafeGetThemeValue(theme, "Sizes.NotificationHeight", 60)
    local cornerRadius = SafeGetThemeValue(theme, "CornerRadius.Medium", 10)
    local fontSize = SafeGetThemeValue(theme, "FontSizes.Action", 14)
    local font = SafeGetThemeValue(theme, "Fonts.Action", Enum.Font.Gotham)
    
    -- Create frame
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, width, 0, height)
    notification.BackgroundColor3 = bgColor
    notification.BackgroundTransparency = 1
    notification.BorderSizePixel = 0
    notification.ZIndex = 10000
    notification.Parent = self.ScreenGui
    
    -- Get positions
    local startPos, endPos = self:GetPositions(width, height)
    notification.Position = startPos
    
    -- Rounded corners
    Instance.new("UICorner", notification).CornerRadius = UDim.new(0, cornerRadius)
    
    -- Border stroke
    local stroke = Instance.new("UIStroke", notification)
    stroke.Color = accentColor
    stroke.Thickness = 2
    stroke.Transparency = 1
    
    -- Accent bar
    local accentBar = Instance.new("Frame", notification)
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = accentColor
    accentBar.BorderSizePixel = 0
    accentBar.BackgroundTransparency = 1
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, cornerRadius)
    
    -- Text
    local text = Instance.new("TextLabel", notification)
    text.Size = UDim2.new(1, -20, 1, 0)
    text.Position = UDim2.new(0, 10, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = textColor
    text.TextSize = fontSize
    text.Font = font
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextYAlignment = Enum.TextYAlignment.Center
    text.TextTransparency = 1
    text.TextWrapped = true
    
    self.CurrentNotification = notification
    
    -- Animate in
    local speed = Config.AnimationSpeed
    
    TweenService:Create(notification, TweenInfo.new(speed, Enum.EasingStyle.Quint), {
        Position = endPos,
        BackgroundTransparency = bgTrans
    }):Play()
    
    TweenService:Create(stroke, TweenInfo.new(speed), {Transparency = 0.3}):Play()
    TweenService:Create(text, TweenInfo.new(speed), {TextTransparency = 0}):Play()
    TweenService:Create(accentBar, TweenInfo.new(speed), {BackgroundTransparency = 0}):Play()
    
    -- Wait then animate out
    task.delay(duration, function()
        self:AnimateOut(notification, stroke, text, accentBar, width, height)
    end)
end

-- ============================================
-- GET POSITIONS
-- ============================================
function Notifications:GetPositions(width, height)
    local m = 10
    
    local positions = {
        TopRight = {
            start = UDim2.new(1, width + 20, 0, m),
            finish = UDim2.new(1, -width - m, 0, m)
        },
        TopLeft = {
            start = UDim2.new(0, -width - 20, 0, m),
            finish = UDim2.new(0, m, 0, m)
        },
        BottomRight = {
            start = UDim2.new(1, width + 20, 1, -height - m),
            finish = UDim2.new(1, -width - m, 1, -height - m)
        },
        BottomLeft = {
            start = UDim2.new(0, -width - 20, 1, -height - m),
            finish = UDim2.new(0, m, 1, -height - m)
        },
        Center = {
            start = UDim2.new(0.5, -width/2, 0.5, -height/2 - 50),
            finish = UDim2.new(0.5, -width/2, 0.5, -height/2)
        }
    }
    
    local pos = positions[Config.Position] or positions.TopRight
    return pos.start, pos.finish
end

-- ============================================
-- ANIMATE OUT
-- ============================================
function Notifications:AnimateOut(notification, stroke, text, accentBar, width, height)
    local TweenService = game:GetService("TweenService")
    local speed = Config.AnimationSpeed
    
    local exitPos
    if Config.Position == "TopRight" or Config.Position == "BottomRight" then
        exitPos = UDim2.new(1, width + 20, notification.Position.Y.Scale, notification.Position.Y.Offset)
    elseif Config.Position == "TopLeft" or Config.Position == "BottomLeft" then
        exitPos = UDim2.new(0, -width - 20, notification.Position.Y.Scale, notification.Position.Y.Offset)
    else
        exitPos = UDim2.new(0.5, -width/2, 0.5, -height/2 - 50)
    end
    
    TweenService:Create(notification, TweenInfo.new(speed, Enum.EasingStyle.Quint), {
        Position = exitPos,
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(stroke, TweenInfo.new(speed), {Transparency = 1}):Play()
    TweenService:Create(text, TweenInfo.new(speed), {TextTransparency = 1}):Play()
    TweenService:Create(accentBar, TweenInfo.new(speed), {BackgroundTransparency = 1}):Play()
    
    task.delay(speed + 0.1, function()
        notification:Destroy()
        self.CurrentNotification = nil
        self:ProcessQueue()
    end)
end

-- ============================================
-- QUICK METHODS
-- ============================================
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

-- ============================================
-- SETTINGS
-- ============================================
function Notifications:SetPosition(position)
    local valid = {"TopRight", "TopLeft", "BottomRight", "BottomLeft", "Center"}
    for _, v in pairs(valid) do
        if position == v then
            Config.Position = position
            return true
        end
    end
    return false
end

function Notifications:SetDuration(seconds)
    if seconds > 0 and seconds <= 10 then
        Config.Duration = seconds
        return true
    end
    return false
end

function Notifications:ClearQueue()
    self.Queue = {}
end

print("[Notifications] Module loaded v" .. Notifications.Version)
return Notifications
