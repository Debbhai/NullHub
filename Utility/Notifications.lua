-- ============================================
-- NullHub Notifications.lua - FINAL OPTIMIZED
-- Created by Debbhai
-- Version: 1.0.2 FINAL
-- Fixed theme handling & optimized performance
-- ============================================

local Notifications = {
    Version = "1.0.2",
    Queue = {},
    CurrentNotification = nil,
    Initialized = false
}

-- Services
local TweenService = game:GetService("TweenService")

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
    Enable = "✅", 
    Disable = "❌", 
    Success = "✅", 
    Error = "⚠️",
    Info = "ℹ️", 
    Warning = "⚠️", 
    Loading = "⏳", 
    Update = "🔄"
}

-- Feature Icons
local FeatureIcons = {
    Aimbot = "🎯", 
    ESP = "👁️", 
    KillAura = "⚔️", 
    FastM1 = "👊",
    Fly = "🕊️", 
    NoClip = "👻", 
    InfiniteJump = "🦘", 
    Speed = "⚡", 
    WalkOnWater = "🌊",
    FullBright = "💡", 
    GodMode = "🛡️",
    TeleportToPlayer = "🚀",
    Theme = "🎨", 
    Config = "⚙️"
}

-- ============================================
-- DEFAULT THEME (SAFE FALLBACK)
-- ============================================
local DefaultTheme = {
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

-- ============================================
-- SAFE THEME ACCESS
-- ============================================
local function SafeGetValue(table, path, default)
    if not table then return default end
    
    local current = table
    for key in string.gmatch(path, "[^.]+") do
        if type(current) == "table" and current[key] ~= nil then
            current = current[key]
        else
            return default
        end
    end
    
    return current
end

-- ============================================
-- EXTRACT THEME DATA (SMART)
-- ============================================
local function ExtractTheme(themeInput)
    if not themeInput then
        return DefaultTheme
    end
    
    -- If theme has GetTheme method, it's a Theme module
    if type(themeInput) == "table" and themeInput.GetTheme then
        local success, themeData = pcall(function()
            return themeInput:GetTheme()
        end)
        
        if success and themeData then
            -- Validate extracted theme
            if themeData.Colors and themeData.Colors.NotificationBg then
                return themeData
            end
        end
    end
    
    -- If theme is already extracted data
    if type(themeInput) == "table" and themeInput.Colors and themeInput.Colors.NotificationBg then
        return themeInput
    end
    
    -- Fallback to default
    return DefaultTheme
end

-- ============================================
-- INITIALIZATION (BULLETPROOF)
-- ============================================
function Notifications:Initialize(screenGui, theme)
    if not screenGui then
        warn("[Notifications] ❌ No ScreenGui provided!")
        return false
    end
    
    self.ScreenGui = screenGui
    
    -- Smart theme extraction
    local extractedTheme = ExtractTheme(theme)
    self.Theme = extractedTheme
    
    -- Validate theme
    local isValid = extractedTheme.Colors and 
                    extractedTheme.Colors.NotificationBg and
                    extractedTheme.Colors.AccentBar and
                    extractedTheme.Colors.TextPrimary
    
    if isValid then
        print("[Notifications] ✅ Initialized with theme: " .. (theme and theme.CurrentTheme or "Default"))
    else
        warn("[Notifications] ⚠️ Theme validation failed, using defaults")
        self.Theme = DefaultTheme
    end
    
    self.Initialized = true
    return true
end

-- ============================================
-- SHOW NOTIFICATION (MAIN METHOD)
-- ============================================
function Notifications:Show(featureName, isEnabled, customMessage, duration)
    if not self.Initialized then
        warn("[Notifications] ❌ Not initialized!")
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
    
    -- Limit queue size
    if #self.Queue >= Config.MaxQueue then
        table.remove(self.Queue, 1)
    end
    
    table.insert(self.Queue, notificationData)
    
    -- Process if no current notification
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
-- CREATE NOTIFICATION (OPTIMIZED)
-- ============================================
function Notifications:CreateNotification(message, duration)
    local theme = self.Theme or DefaultTheme
    
    -- Extract theme values with defaults
    local bgColor = SafeGetValue(theme, "Colors.NotificationBg", DefaultTheme.Colors.NotificationBg)
    local accentColor = SafeGetValue(theme, "Colors.AccentBar", DefaultTheme.Colors.AccentBar)
    local textColor = SafeGetValue(theme, "Colors.TextPrimary", DefaultTheme.Colors.TextPrimary)
    local bgTrans = SafeGetValue(theme, "Transparency.Notification", DefaultTheme.Transparency.Notification)
    local width = SafeGetValue(theme, "Sizes.NotificationWidth", DefaultTheme.Sizes.NotificationWidth)
    local height = SafeGetValue(theme, "Sizes.NotificationHeight", DefaultTheme.Sizes.NotificationHeight)
    local cornerRadius = SafeGetValue(theme, "CornerRadius.Medium", DefaultTheme.CornerRadius.Medium)
    local fontSize = SafeGetValue(theme, "FontSizes.Action", DefaultTheme.FontSizes.Action)
    local font = SafeGetValue(theme, "Fonts.Action", DefaultTheme.Fonts.Action)
    
    -- Create main frame
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
    local corner = Instance.new("UICorner", notification)
    corner.CornerRadius = UDim.new(0, cornerRadius)
    
    -- Border stroke
    local stroke = Instance.new("UIStroke", notification)
    stroke.Color = accentColor
    stroke.Thickness = 2
    stroke.Transparency = 1
    
    -- Accent bar (left side)
    local accentBar = Instance.new("Frame", notification)
    accentBar.Name = "AccentBar"
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = accentColor
    accentBar.BorderSizePixel = 0
    accentBar.BackgroundTransparency = 1
    
    local accentCorner = Instance.new("UICorner", accentBar)
    accentCorner.CornerRadius = UDim.new(0, cornerRadius)
    
    -- Text label
    local text = Instance.new("TextLabel", notification)
    text.Name = "Text"
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
    
    -- Store current notification
    self.CurrentNotification = notification
    
    -- Animate in
    local speed = Config.AnimationSpeed
    
    local slideIn = TweenService:Create(notification, 
        TweenInfo.new(speed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), 
        {Position = endPos, BackgroundTransparency = bgTrans}
    )
    
    local strokeIn = TweenService:Create(stroke, 
        TweenInfo.new(speed), 
        {Transparency = 0.3}
    )
    
    local textIn = TweenService:Create(text, 
        TweenInfo.new(speed), 
        {TextTransparency = 0}
    )
    
    local accentIn = TweenService:Create(accentBar, 
        TweenInfo.new(speed), 
        {BackgroundTransparency = 0}
    )
    
    -- Play animations
    slideIn:Play()
    strokeIn:Play()
    textIn:Play()
    accentIn:Play()
    
    -- Wait then animate out
    task.delay(duration, function()
        if notification and notification.Parent then
            self:AnimateOut(notification, stroke, text, accentBar, width, height)
        end
    end)
end

-- ============================================
-- GET POSITIONS (OPTIMIZED)
-- ============================================
function Notifications:GetPositions(width, height)
    local margin = 10
    
    local positions = {
        TopRight = {
            start = UDim2.new(1, width + 20, 0, margin),
            finish = UDim2.new(1, -width - margin, 0, margin)
        },
        TopLeft = {
            start = UDim2.new(0, -width - 20, 0, margin),
            finish = UDim2.new(0, margin, 0, margin)
        },
        BottomRight = {
            start = UDim2.new(1, width + 20, 1, -height - margin),
            finish = UDim2.new(1, -width - margin, 1, -height - margin)
        },
        BottomLeft = {
            start = UDim2.new(0, -width - 20, 1, -height - margin),
            finish = UDim2.new(0, margin, 1, -height - margin)
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
-- ANIMATE OUT (OPTIMIZED)
-- ============================================
function Notifications:AnimateOut(notification, stroke, text, accentBar, width, height)
    local speed = Config.AnimationSpeed
    
    -- Calculate exit position
    local exitPos
    if Config.Position == "TopRight" or Config.Position == "BottomRight" then
        exitPos = UDim2.new(1, width + 20, notification.Position.Y.Scale, notification.Position.Y.Offset)
    elseif Config.Position == "TopLeft" or Config.Position == "BottomLeft" then
        exitPos = UDim2.new(0, -width - 20, notification.Position.Y.Scale, notification.Position.Y.Offset)
    else
        exitPos = UDim2.new(0.5, -width/2, 0.5, -height/2 - 50)
    end
    
    -- Create exit animations
    local slideOut = TweenService:Create(notification, 
        TweenInfo.new(speed, Enum.EasingStyle.Quint, Enum.EasingDirection.In), 
        {Position = exitPos, BackgroundTransparency = 1}
    )
    
    local strokeOut = TweenService:Create(stroke, 
        TweenInfo.new(speed), 
        {Transparency = 1}
    )
    
    local textOut = TweenService:Create(text, 
        TweenInfo.new(speed), 
        {TextTransparency = 1}
    )
    
    local accentOut = TweenService:Create(accentBar, 
        TweenInfo.new(speed), 
        {BackgroundTransparency = 1}
    )
    
    -- Play exit animations
    slideOut:Play()
    strokeOut:Play()
    textOut:Play()
    accentOut:Play()
    
    -- Cleanup after animation
    task.delay(speed + 0.1, function()
        if notification and notification.Parent then
            notification:Destroy()
        end
        self.CurrentNotification = nil
        self:ProcessQueue()
    end)
end

-- ============================================
-- QUICK METHODS (CONVENIENT)
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

function Notifications:Loading(message, duration)
    self:Show("Loading", true, Icons.Loading .. " " .. message, duration or 2)
end

-- ============================================
-- SETTINGS (CONFIGURATION)
-- ============================================
function Notifications:SetPosition(position)
    local validPositions = {"TopRight", "TopLeft", "BottomRight", "BottomLeft", "Center"}
    for _, v in ipairs(validPositions) do
        if position == v then
            Config.Position = position
            print("[Notifications] Position set to: " .. position)
            return true
        end
    end
    warn("[Notifications] Invalid position: " .. tostring(position))
    return false
end

function Notifications:SetDuration(seconds)
    if type(seconds) == "number" and seconds > 0 and seconds <= 10 then
        Config.Duration = seconds
        print("[Notifications] Duration set to: " .. seconds .. "s")
        return true
    end
    warn("[Notifications] Invalid duration: " .. tostring(seconds))
    return false
end

function Notifications:SetAnimationSpeed(speed)
    if type(speed) == "number" and speed > 0 and speed <= 2 then
        Config.AnimationSpeed = speed
        print("[Notifications] Animation speed set to: " .. speed .. "s")
        return true
    end
    warn("[Notifications] Invalid animation speed: " .. tostring(speed))
    return false
end

function Notifications:ToggleIcons(enabled)
    Config.ShowIcon = enabled
    print("[Notifications] Icons " .. (enabled and "enabled" or "disabled"))
end

function Notifications:ClearQueue()
    self.Queue = {}
    print("[Notifications] Queue cleared")
end

function Notifications:GetQueueSize()
    return #self.Queue
end

-- ============================================
-- DESTROY (CLEANUP)
-- ============================================
function Notifications:Destroy()
    -- Clear queue
    self.Queue = {}
    
    -- Destroy current notification
    if self.CurrentNotification and self.CurrentNotification.Parent then
        self.CurrentNotification:Destroy()
    end
    
    self.CurrentNotification = nil
    self.Initialized = false
    
    print("[Notifications] ✅ Destroyed")
end

-- ============================================
-- MODULE INFO
-- ============================================
function Notifications:PrintInfo()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🔔 NullHub Notifications v" .. self.Version)
    print("Position: " .. Config.Position)
    print("Duration: " .. Config.Duration .. "s")
    print("Queue: " .. #self.Queue .. "/" .. Config.MaxQueue)
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- Export for global access
getgenv().NullHub_Notifications = Notifications

print("[Notifications] ✅ Module loaded v" .. Notifications.Version)
return Notifications
