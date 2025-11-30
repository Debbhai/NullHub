-- ============================================
-- NullHub InfiniteJump.lua - Unlimited Jumping
-- Created by Debbhai
-- Version: 1.0.0
-- Jump infinitely with adjustable height slider
-- ============================================

local InfiniteJump = {
    Version = "1.0.0",
    Enabled = false,
    CurrentJumpHeight = 50,
    MinJumpHeight = 10,
    MaxJumpHeight = 200
}

-- Dependencies
local UserInputService
local Player, Character, Humanoid
local Config, Notifications

-- Internal State
local Connection = nil
local JumpHeightSliderCallback = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function InfiniteJump:Initialize(player, humanoid, config, notifications)
    -- Store dependencies
    UserInputService = game:GetService("UserInputService")
    
    Player = player
    Character = player.Character or player.CharacterAdded:Wait()
    Humanoid = humanoid
    Config = config
    Notifications = notifications
    
    -- Set initial jump height from config
    self.CurrentJumpHeight = Config.Movement.INFJUMP.JUMP_POWER or 50
    self.MinJumpHeight = 10
    self.MaxJumpHeight = 200
    
    print("[InfiniteJump] ✅ Initialized (Height: " .. self.CurrentJumpHeight .. ")")
    return true
end

-- ============================================
-- PERFORM JUMP
-- ============================================
function InfiniteJump:PerformJump()
    if not self.Enabled or not Humanoid then return end
    
    -- Change to jumping state
    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    
    -- Apply custom jump power
    if Humanoid.UseJumpPower then
        Humanoid.JumpPower = self.CurrentJumpHeight
    else
        Humanoid.JumpHeight = self.CurrentJumpHeight / 10 -- Convert to JumpHeight
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function InfiniteJump:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    -- Notify user
    if Notifications then
        Notifications:Show("Infinite Jump", self.Enabled, "Height: " .. self.CurrentJumpHeight, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function InfiniteJump:Enable()
    if Connection then return end
    
    -- Listen for space bar
    Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            self:PerformJump()
        end
    end)
    
    -- Auto jump mode (if enabled)
    if Config.Movement.INFJUMP.AUTO_JUMP then
        task.spawn(function()
            while self.Enabled do
                self:PerformJump()
                task.wait(0.5)
            end
        end)
    end
    
    print("[InfiniteJump] 🦘 Enabled (Height: " .. self.CurrentJumpHeight .. ")")
end

-- ============================================
-- DISABLE
-- ============================================
function InfiniteJump:Disable()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    -- Reset to default jump power
    if Humanoid then
        if Humanoid.UseJumpPower then
            Humanoid.JumpPower = 50
        else
            Humanoid.JumpHeight = 7.2
        end
    end
    
    print("[InfiniteJump] ❌ Disabled")
end

-- ============================================
-- SET JUMP HEIGHT (For Slider/Input)
-- ============================================
function InfiniteJump:SetJumpHeight(height)
    height = tonumber(height)
    if not height then return false end
    
    -- Clamp to min/max
    height = math.clamp(height, self.MinJumpHeight, self.MaxJumpHeight)
    self.CurrentJumpHeight = height
    
    -- Update config
    Config.Movement.INFJUMP.JUMP_POWER = height
    
    -- Notify user
    if Notifications then
        Notifications:Show("Jump Height", true, tostring(height), 2)
    end
    
    -- Call slider callback if exists
    if JumpHeightSliderCallback then
        JumpHeightSliderCallback(height)
    end
    
    print("[InfiniteJump] Height set to: " .. height)
    return true
end

-- ============================================
-- GET JUMP HEIGHT (For Slider Display)
-- ============================================
function InfiniteJump:GetJumpHeight()
    return self.CurrentJumpHeight
end

function InfiniteJump:GetJumpHeightRange()
    return self.MinJumpHeight, self.MaxJumpHeight
end

-- ============================================
-- REGISTER SLIDER CALLBACK
-- ============================================
function InfiniteJump:RegisterSliderCallback(callback)
    JumpHeightSliderCallback = callback
end

-- ============================================
-- CREATE SLIDER (For GUI Integration)
-- ============================================
function InfiniteJump:CreateSlider(parent, theme)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "JumpHeightSlider"
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
    label.Text = "Jump Height: " .. self.CurrentJumpHeight
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
    input.Text = tostring(self.CurrentJumpHeight)
    input.TextColor3 = theme.Colors.TextPrimary
    input.PlaceholderText = "Height"
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
    sliderFill.Size = UDim2.new((self.CurrentJumpHeight - self.MinJumpHeight) / (self.MaxJumpHeight - self.MinJumpHeight), 0, 1, 0)
    sliderFill.BackgroundColor3 = theme.Colors.AccentBar
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    -- Slider Button
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((self.CurrentJumpHeight - self.MinJumpHeight) / (self.MaxJumpHeight - self.MinJumpHeight), -10, 0.5, -10)
    sliderButton.BackgroundColor3 = theme.Colors.AccentBar
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = sliderBar
    
    Instance.new("UICorner", sliderButton).CornerRadius = UDim.new(1, 0)
    
    -- Update function
    local function updateSlider(value)
        value = math.clamp(value, self.MinJumpHeight, self.MaxJumpHeight)
        self:SetJumpHeight(value)
        
        local percent = (value - self.MinJumpHeight) / (self.MaxJumpHeight - self.MinJumpHeight)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
        label.Text = "Jump Height: " .. math.floor(value)
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
            local value = self.MinJumpHeight + (percent * (self.MaxJumpHeight - self.MinJumpHeight))
            updateSlider(value)
        end
    end)
    
    -- Input box
    input.FocusLost:Connect(function()
        local value = tonumber(input.Text)
        if value then
            updateSlider(value)
        else
            input.Text = tostring(self.CurrentJumpHeight)
        end
    end)
    
    return sliderFrame
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function InfiniteJump:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    -- Disable first
    self:Disable()
    
    -- Update references
    Character = newCharacter
    Humanoid = newHumanoid
    
    -- Re-enable if was enabled
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[InfiniteJump] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function InfiniteJump:Destroy()
    self:Disable()
    JumpHeightSliderCallback = nil
    print("[InfiniteJump] ✅ Destroyed")
end

-- Export
print("[InfiniteJump] Module loaded v" .. InfiniteJump.Version)
return InfiniteJump
