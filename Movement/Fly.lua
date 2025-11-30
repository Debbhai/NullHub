-- ============================================
-- NullHub Fly.lua - Flight System
-- Created by Debbhai
-- Version: 1.0.0
-- WASD flight with adjustable speed slider
-- ============================================

local Fly = {
    Version = "1.0.0",
    Enabled = false,
    CurrentSpeed = 120,
    MinSpeed = 10,
    MaxSpeed = 300
}

-- Dependencies
local UserInputService, RunService
local Player, Character, Humanoid, RootPart, Camera
local Config, Notifications

-- Internal State
local BodyVelocity = nil
local Connection = nil
local SpeedSliderCallback = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function Fly:Initialize(player, character, rootPart, camera, config, notifications)
    -- Store dependencies
    UserInputService = game:GetService("UserInputService")
    RunService = game:GetService("RunService")
    
    Player = player
    Character = character
    RootPart = rootPart
    Camera = camera
    Config = config
    Notifications = notifications
    
    Humanoid = Character:WaitForChild("Humanoid")
    
    -- Set initial speed from config
    self.CurrentSpeed = Config.Movement.FLY.SPEED or 120
    self.MinSpeed = Config.Movement.FLY.MIN_SPEED or 10
    self.MaxSpeed = Config.Movement.FLY.MAX_SPEED or 300
    
    print("[Fly] ✅ Initialized (Speed: " .. self.CurrentSpeed .. ")")
    return true
end

-- ============================================
-- UPDATE MOVEMENT
-- ============================================
function Fly:UpdateMovement()
    if not self.Enabled or not RootPart or not BodyVelocity then return end
    
    local moveDirection = Vector3.new(0, 0, 0)
    
    -- Forward/Backward
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + Camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - Camera.CFrame.LookVector
    end
    
    -- Left/Right
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - Camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + Camera.CFrame.RightVector
    end
    
    -- Up/Down
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end
    
    -- Apply speed
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * self.CurrentSpeed
    end
    
    -- Update velocity
    if Config.Movement.FLY.SMOOTH_MOVEMENT then
        BodyVelocity.Velocity = BodyVelocity.Velocity:Lerp(moveDirection, 0.3)
    else
        BodyVelocity.Velocity = moveDirection
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function Fly:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    -- Notify user
    if Notifications then
        Notifications:Show("Fly", self.Enabled, "Speed: " .. self.CurrentSpeed, 3)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function Fly:Enable()
    if not RootPart then return end
    
    -- Clean up existing
    if BodyVelocity then
        BodyVelocity:Destroy()
    end
    
    -- Create BodyVelocity
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = RootPart
    
    -- Connect update loop
    if Connection then
        Connection:Disconnect()
    end
    Connection = RunService.Heartbeat:Connect(function()
        self:UpdateMovement()
    end)
    
    print("[Fly] 🕊️ Enabled (Speed: " .. self.CurrentSpeed .. ")")
end

-- ============================================
-- DISABLE
-- ============================================
function Fly:Disable()
    -- Disconnect update loop
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    -- Remove BodyVelocity
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    
    print("[Fly] ❌ Disabled")
end

-- ============================================
-- SET SPEED (For Slider/Input)
-- ============================================
function Fly:SetSpeed(speed)
    speed = tonumber(speed)
    if not speed then return false end
    
    -- Clamp to min/max
    speed = math.clamp(speed, self.MinSpeed, self.MaxSpeed)
    self.CurrentSpeed = speed
    
    -- Update config
    Config.Movement.FLY.SPEED = speed
    
    -- Notify user
    if Notifications then
        Notifications:Show("Fly Speed", true, tostring(speed), 2)
    end
    
    -- Call slider callback if exists
    if SpeedSliderCallback then
        SpeedSliderCallback(speed)
    end
    
    print("[Fly] Speed set to: " .. speed)
    return true
end

-- ============================================
-- GET SPEED (For Slider Display)
-- ============================================
function Fly:GetSpeed()
    return self.CurrentSpeed
end

function Fly:GetSpeedRange()
    return self.MinSpeed, self.MaxSpeed
end

-- ============================================
-- REGISTER SLIDER CALLBACK
-- ============================================
function Fly:RegisterSliderCallback(callback)
    SpeedSliderCallback = callback
end

-- ============================================
-- CREATE SLIDER (For GUI Integration)
-- ============================================
function Fly:CreateSlider(parent, theme)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "FlySpeedSlider"
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
    label.Text = "Flight Speed: " .. self.CurrentSpeed
    label.TextColor3 = theme.Colors.TextPrimary
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    -- Input Box
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 80, 0, 24)
    input.Position = UDim2.new(1, -85, 0, 3)
    input.BackgroundColor3 = theme.Colors.ContainerBackground
    input.BackgroundTransparency = 0.5
    input.BorderSizePixel = 0
    input.Text = tostring(self.CurrentSpeed)
    input.TextColor3 = theme.Colors.TextPrimary
    input.PlaceholderText = "Speed"
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
    sliderFill.Size = UDim2.new((self.CurrentSpeed - self.MinSpeed) / (self.MaxSpeed - self.MinSpeed), 0, 1, 0)
    sliderFill.BackgroundColor3 = theme.Colors.AccentBar
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    -- Slider Button
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((self.CurrentSpeed - self.MinSpeed) / (self.MaxSpeed - self.MinSpeed), -10, 0.5, -10)
    sliderButton.BackgroundColor3 = theme.Colors.AccentBar
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = sliderBar
    
    Instance.new("UICorner", sliderButton).CornerRadius = UDim.new(1, 0)
    
    -- Update function
    local function updateSlider(value)
        value = math.clamp(value, self.MinSpeed, self.MaxSpeed)
        self:SetSpeed(value)
        
        local percent = (value - self.MinSpeed) / (self.MaxSpeed - self.MinSpeed)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
        label.Text = "Flight Speed: " .. math.floor(value)
        input.Text = tostring(math.floor(value))
    end
    
    -- Slider dragging
    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
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
            local value = self.MinSpeed + (percent * (self.MaxSpeed - self.MinSpeed))
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
function Fly:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    -- Disable first
    self:Disable()
    
    -- Update references
    Character = newCharacter
    Humanoid = newHumanoid
    RootPart = newRootPart
    
    -- Re-enable if was enabled
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[Fly] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function Fly:Destroy()
    self:Disable()
    SpeedSliderCallback = nil
    print("[Fly] ✅ Destroyed")
end

-- Export
print("[Fly] Module loaded v" .. Fly.Version)
return Fly
