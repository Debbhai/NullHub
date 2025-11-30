-- ============================================
-- NullHub Speed.lua - Walk Speed Modifier
-- Created by Debbhai
-- Version: 1.0.0
-- Adjustable walk speed with slider (Default: 50)
-- ============================================

local Speed = {
    Version = "1.0.0",
    Enabled = false,
    CurrentSpeed = 50, -- Default value
    MinSpeed = 0,
    MaxSpeed = 1000000, -- Keep original max cap
    OriginalSpeed = 16
}

-- Dependencies
local RunService
local Player, Character, Humanoid
local Config, AntiDetection, Notifications

-- Internal State
local Connection = nil
local SpeedSliderCallback = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function Speed:Initialize(player, humanoid, config, antiDetection, notifications)
    -- Store dependencies
    RunService = game:GetService("RunService")
    
    Player = player
    Character = player.Character or player.CharacterAdded:Wait()
    Humanoid = humanoid
    Config = config
    AntiDetection = antiDetection
    Notifications = notifications
    
    -- Save original speed
    self.OriginalSpeed = Humanoid.WalkSpeed
    
    -- Set default speed to 50
    self.CurrentSpeed = 50
    self.MinSpeed = Config.Movement.SPEED.MIN_VALUE or 0
    self.MaxSpeed = Config.Movement.SPEED.MAX_VALUE or 1000000
    
    print("[Speed] ✅ Initialized (Default: " .. self.CurrentSpeed .. ")")
    return true
end

-- ============================================
-- UPDATE SPEED
-- ============================================
function Speed:Update()
    if not self.Enabled or not Humanoid then return end
    
    local targetSpeed = self.CurrentSpeed
    
    -- Smooth transition (if anti-detection enabled)
    if Config.Movement.SPEED.SMOOTH_TRANSITION and AntiDetection then
        Humanoid.WalkSpeed = AntiDetection:SmoothTransition(
            targetSpeed,
            Humanoid.WalkSpeed,
            0.1,
            Config.AntiDetection.STEALTH_MODE
        )
    else
        Humanoid.WalkSpeed = targetSpeed
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function Speed:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    -- Notify user
    if Notifications then
        Notifications:Show("Speed", self.Enabled, "Speed: " .. self.CurrentSpeed, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function Speed:Enable()
    if Connection then return end
    
    Connection = RunService.Heartbeat:Connect(function()
        self:Update()
    end)
    
    print("[Speed] ⚡ Enabled (Speed: " .. self.CurrentSpeed .. ")")
end

-- ============================================
-- DISABLE
-- ============================================
function Speed:Disable()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    -- Reset to original speed
    if Humanoid then
        Humanoid.WalkSpeed = self.OriginalSpeed
    end
    
    print("[Speed] ❌ Disabled")
end

-- ============================================
-- SET SPEED (For Slider/Input)
-- ============================================
function Speed:SetSpeed(speed)
    speed = tonumber(speed)
    if not speed then return false end
    
    -- Clamp to min/max (keep original max cap)
    speed = math.clamp(speed, self.MinSpeed, self.MaxSpeed)
    self.CurrentSpeed = speed
    
    -- Update config
    Config.Movement.SPEED.VALUE = speed
    
    -- Notify user
    if Notifications then
        Notifications:Show("Walk Speed", true, tostring(speed), 2)
    end
    
    -- Call slider callback if exists
    if SpeedSliderCallback then
        SpeedSliderCallback(speed)
    end
    
    print("[Speed] Speed set to: " .. speed)
    return true
end

-- ============================================
-- GET SPEED (For Slider Display)
-- ============================================
function Speed:GetSpeed()
    return self.CurrentSpeed
end

function Speed:GetSpeedRange()
    return self.MinSpeed, self.MaxSpeed
end

-- ============================================
-- REGISTER SLIDER CALLBACK
-- ============================================
function Speed:RegisterSliderCallback(callback)
    SpeedSliderCallback = callback
end

-- ============================================
-- CREATE SLIDER (For GUI Integration)
-- ============================================
function Speed:CreateSlider(parent, theme)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "WalkSpeedSlider"
    sliderFrame.Size = UDim2.new(1, -16, 0, 60)
    sliderFrame.Position = UDim2.new(0, 8, 0, 46)
    sliderFrame.BackgroundColor3 = theme.Colors.InputBackground
    sliderFrame.BackgroundTransparency = theme.Transparency.Input
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 7)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = "Walk Speed: " .. self.CurrentSpeed
    label.TextColor3 = theme.Colors.TextPrimary
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    -- Input Box
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 100, 0, 24)
    input.Position = UDim2.new(1, -105, 0, 3)
    input.BackgroundColor3 = theme.Colors.ContainerBackground
    input.BackgroundTransparency = 0.5
    input.BorderSizePixel = 0
    input.Text = tostring(self.CurrentSpeed)
    input.TextColor3 = theme.Colors.TextPrimary
    input.PlaceholderText = "0-1000000"
    input.TextSize = 13
    input.Font = Enum.Font.Gotham
    input.ClearTextOnFocus = false
    input.Parent = sliderFrame
    
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 5)
    
    -- Slider Bar
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -10, 0, 6)
    sliderBar.Position = UDim2.new(0, 5, 1, -12)
    sliderBar.BackgroundColor3 = theme.Colors.ContainerBackground
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)
    
    -- Slider Fill
    local sliderFill = Instance.new("Frame")
    -- Use logarithmic scale for better control (since max is 1,000,000)
    local percent = math.log(self.CurrentSpeed + 1) / math.log(self.MaxSpeed + 1)
    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    sliderFill.BackgroundColor3 = theme.Colors.AccentBar
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    -- Slider Button
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
    sliderButton.BackgroundColor3 = theme.Colors.AccentBar
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = sliderBar
    
    Instance.new("UICorner", sliderButton).CornerRadius = UDim.new(1, 0)
    
    -- Update function (with logarithmic scale)
    local function updateSlider(value)
        value = math.clamp(value, self.MinSpeed, self.MaxSpeed)
        self:SetSpeed(value)
        
        -- Logarithmic scale for better control
        local percent = math.log(value + 1) / math.log(self.MaxSpeed + 1)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
        label.Text = "Walk Speed: " .. math.floor(value)
        input.Text = tostring(math.floor(value))
    end
    
    -- Slider dragging
    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = sliderBar.AbsolutePosition.X
            local barSize = sliderBar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            
            -- Convert logarithmic back to linear
            local value = math.exp(percent * math.log(self.MaxSpeed + 1)) - 1
            updateSlider(value)
        end
    end)
    
    -- Input box
    input.FocusLost:Connect(function()
        local value = tonumber(input.Text)
        if value then
            updateSlider(value)
        else
            input.Text = tostring(self.CurrentSpeed)
        end
    end)
    
    return sliderFrame
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function Speed:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    -- Disable first
    self:Disable()
    
    -- Update references
    Character = newCharacter
    Humanoid = newHumanoid
    self.OriginalSpeed = Humanoid.WalkSpeed
    
    -- Re-enable if was enabled
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[Speed] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function Speed:Destroy()
    self:Disable()
    SpeedSliderCallback = nil
    print("[Speed] ✅ Destroyed")
end

-- Export
print("[Speed] Module loaded v" .. Speed.Version)
return Speed
