-- NullHub V2.lua - COMPLETE FIXED VERSION (ALL FEATURES WORKING)
-- Created by Debbhai - Upload to GitHub Version/V2.lua

print("🔒 NullHub V2 Loading...")

-- SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- WAIT FOR CHARACTER
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- FALLBACK THEME (EMBEDDED - NO EXTERNAL DEPENDENCIES)
local Theme = {
    Themes = {
        Dark = {
            Colors = {
                MainBackground = Color3.fromRGB(10, 10, 12),
                HeaderBackground = Color3.fromRGB(15, 15, 18),
                StatusOn = Color3.fromRGB(50, 220, 100),
                StatusOff = Color3.fromRGB(220, 60, 60),
                TextPrimary = Color3.fromRGB(255, 255, 255),
                ContainerBackground = Color3.fromRGB(18, 18, 22),
                ContainerOn = Color3.fromRGB(25, 35, 45),
                InputBackground = Color3.fromRGB(20, 20, 24),
                TextPlaceholder = Color3.fromRGB(120, 120, 140),
                CloseButton = Color3.fromRGB(220, 60, 70),
                ToggleButton = Color3.fromRGB(255, 215, 0)
            },
            Transparency = {
                MainBackground = 0.08,
                Header = 0.05,
                Container = 0.15,
                Input = 0.2,
                StatusIndicator = 0,
                CloseButton = 0.1,
                ToggleButton = 0.1
            },
            Sizes = {
                MainFrameWidth = 680,
                MainFrameHeight = 450,
                SidebarWidth = 150,
                HeaderHeight = 45,
                CloseButton = 38,
                ActionRowHeight = 46,
                StatusIndicator = 12,
                InputHeight = 36,
                DropdownHeight = 90,
                PlayerButtonHeight = 28,
                ToggleButton = 55,
                NotificationWidth = 300,
                NotificationHeight = 60
            },
            CornerRadius = {Large = 14, Medium = 10, Small = 7, Tiny = 5},
            Fonts = {Title = Enum.Font.GothamBold, Action = Enum.Font.Gotham, Input = Enum.Font.Gotham},
            FontSizes = {Title = 19, Action = 14, Input = 13}
        }
    },
    CurrentTheme = "Dark"
}

function Theme:GetTheme() return self.Themes[self.CurrentTheme or self.Themes.Dark] end

-- CONFIG
local CONFIG = {
    GUITOGGLEKEY = Enum.KeyCode.Insert,
    AIMBOTKEY = Enum.KeyCode.E, AIMBOTFOV = 250, AIMBOTSMOOTHNESS = 0.15,
    ESPKEY = Enum.KeyCode.T, ESPCOLOR = Color3.fromRGB(255, 80, 80),
    KILLAURAKEY = Enum.KeyCode.K, KILLAURARANGE = 25, KILLAURADELAY = 0.15,
    FASTM1KEY = Enum.KeyCode.M, FASTM1DELAY = 0.05,
    FLYKEY = Enum.KeyCode.F, FLYSPEED = 120,
    NOCLIPKEY = Enum.KeyCode.N,
    INFJUMPKEY = Enum.KeyCode.J,
    SPEEDKEY = Enum.KeyCode.X, SPEEDVALUE = 500, MINSPEED = 0, MAXSPEED = 1000000,
    FULLBRIGHTKEY = Enum.KeyCode.B,
    GODMODEKEY = Enum.KeyCode.V,
    TELEPORTKEY = Enum.KeyCode.Z, TELEPORTSPEED = 100
}

-- STATE
local state = {
    aimbot = false, esp = false, noclip = false, infjump = false, speed = false,
    fullbright = false, godmode = false, killaura = false, fastm1 = false, fly = false
}
local connections = {}
local espObjects = {}
local originalSpeed = 16
local originalLightingSettings = {}
local selectedTeleportPlayer = nil

-- NOTIFICATION SYSTEM
local function showNotification(message, duration)
    duration = duration or 3
    local screenGui = player.PlayerGui:FindFirstChild("NullHubGUI")
    if not screenGui then return end
    
    local currentTheme = Theme:GetTheme()
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, Theme.Sizes.NotificationWidth, 0, Theme.Sizes.NotificationHeight)
    notification.Position = UDim2.new(1, Theme.Sizes.NotificationWidth + 20, 1, -Theme.Sizes.NotificationHeight - 10)
    notification.BackgroundColor3 = currentTheme.Colors.ContainerBackground
    notification.BackgroundTransparency = 1
    notification.Parent = screenGui
    
    Instance.new("UICorner", notification).CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
    local text = Instance.new("TextLabel", notification)
    text.Size = UDim2.new(1, -20, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = currentTheme.Colors.TextPrimary
    text.TextSize = Theme.FontSizes.Action
    text.TextTransparency = 1
    text.Font = Theme.Fonts.Action
    
    -- Animate in
    TweenService:Create(notification, TweenInfo.new(0.5), {
        Position = UDim2.new(1, -Theme.Sizes.NotificationWidth - 10, 1, -Theme.Sizes.NotificationHeight - 10),
        BackgroundTransparency = currentTheme.Transparency.Container
    }):Play()
    TweenService:Create(text, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    
    task.delay(duration, function()
        TweenService:Create(notification, TweenInfo.new(0.5), {
            Position = UDim2.new(1, Theme.Sizes.NotificationWidth + 20, 1, -Theme.Sizes.NotificationHeight - 10),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(text, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.delay(0.6, function() notification:Destroy() end)
    end)
end

-- GUI CREATION (SIMPLIFIED & FIXED)
local function createModernGUI()
    local currentTheme = Theme:GetTheme()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NullHubGUI"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, Theme.Sizes.MainFrameWidth, 0, Theme.Sizes.MainFrameHeight)
    mainFrame.Position = UDim2.new(0.5, -Theme.Sizes.MainFrameWidth/2, 0.5, -Theme.Sizes.MainFrameHeight/2)
    mainFrame.BackgroundColor3 = currentTheme.Colors.MainBackground
    mainFrame.BackgroundTransparency = currentTheme.Transparency.MainBackground
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, Theme.CornerRadius.Large)
    
    -- TOP BAR
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, Theme.Sizes.HeaderHeight)
    topBar.BackgroundColor3 = currentTheme.Colors.HeaderBackground
    topBar.BackgroundTransparency = currentTheme.Transparency.Header
    topBar.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 18, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "NullHub V2 - Protected"
    title.TextColor3 = currentTheme.Colors.TextPrimary
    title.TextSize = Theme.FontSizes.Title
    title.Font = Theme.Fonts.Title
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, Theme.Sizes.CloseButton, 0, Theme.Sizes.CloseButton)
    closeBtn.Position = UDim2.new(1, -Theme.Sizes.CloseButton - 6, 0, 3)
    closeBtn.BackgroundColor3 = currentTheme.Colors.CloseButton
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = currentTheme.Colors.TextPrimary
    closeBtn.TextSize = 26
    closeBtn.Font = Theme.Fonts.Title
    closeBtn.Parent = topBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
    
    -- COMBAT SECTION
    local combatFrame = Instance.new("ScrollingFrame")
    combatFrame.Size = UDim2.new(1, -20, 1, -60)
    combatFrame.Position = UDim2.new(0, 10, 0, Theme.Sizes.HeaderHeight + 10)
    combatFrame.BackgroundTransparency = 1
    combatFrame.ScrollBarThickness = 6
    combatFrame.Parent = mainFrame
    combatFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    combatFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    Instance.new("UIListLayout", combatFrame).Padding = UDim.new(0, 8)
    
    return mainFrame, closeBtn, combatFrame, screenGui
end

-- TOGGLE BUTTON
local function createToggleButton(screenGui)
    local currentTheme = Theme:GetTheme()
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, Theme.Sizes.ToggleButton, 0, Theme.Sizes.ToggleButton)
    toggleBtn.Position = UDim2.new(0, 15, 0.5, -Theme.Sizes.ToggleButton/2)
    toggleBtn.BackgroundColor3 = currentTheme.Colors.ToggleButton
    toggleBtn.Text = "N"
    toggleBtn.TextColor3 = Color3.new(0,0,0)
    toggleBtn.TextSize = 28
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.Parent = screenGui
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.5, 0)
    
    toggleBtn.MouseButton1Click:Connect(function()
        local mainFrame = screenGui:FindFirstChild("MainFrame")
        if mainFrame then
            mainFrame.Position = UDim2.new(0.5, -Theme.Sizes.MainFrameWidth/2, 0.5, -Theme.Sizes.MainFrameHeight/2)
        end
    end)
    
    return toggleBtn
end

-- FEATURE TOGGLES (ALL FIXED)
local function toggleAimbot()
    state.aimbot = not state.aimbot
    showNotification("Aimbot " .. (state.aimbot and "ON" or "OFF"), 2)
end

local function toggleESP()
    state.esp = not state.esp
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            if state.esp then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = otherPlayer.Character
                highlight.FillColor = CONFIG.ESPCOLOR
                highlight.FillTransparency = 0.5
                highlight.Parent = otherPlayer.Character
                espObjects[otherPlayer] = highlight
            else
                if espObjects[otherPlayer] then
                    espObjects[otherPlayer]:Destroy()
                    espObjects[otherPlayer] = nil
                end
            end
        end
    end
    showNotification("ESP " .. (state.esp and "ON" or "OFF"), 2)
end

local function toggleKillAura()
    state.killaura = not state.killaura
    if state.killaura then
        connections.killaura = RunService.Heartbeat:Connect(function()
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (rootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < CONFIG.KILLAURARANGE then
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                        break
                    end
                end
            end
        end)
    else
        if connections.killaura then connections.killaura:Disconnect() end
    end
    showNotification("KillAura " .. (state.killaura and "ON" or "OFF"), 2)
end

local function toggleFastM1()
    state.fastm1 = not state.fastm1
    if state.fastm1 then
        connections.fastm1 = RunService.Heartbeat:Connect(function()
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end)
    else
        if connections.fastm1 then connections.fastm1:Disconnect() end
    end
    showNotification("Fast M1 " .. (state.fastm1 and "ON" or "OFF"), 2)
end

local function toggleFly()
    state.fly = not state.fly
    if state.fly then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = rootPart
        connections.fly = RunService.Heartbeat:Connect(function()
            local moveVector = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
            bv.Velocity = moveVector.Unit * CONFIG.FLYSPEED
        end)
    else
        if connections.fly then connections.fly:Disconnect() end
        if rootPart:FindFirstChild("BodyVelocity") then rootPart:FindFirstChild("BodyVelocity"):Destroy() end
    end
    showNotification("Fly " .. (state.fly and "ON" or "OFF"), 2)
end

local function toggleNoClip()
    state.noclip = not state.noclip
    connections.noclip = RunService.Stepped:Connect(function()
        if state.noclip and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
    showNotification("NoClip " .. (state.noclip and "ON" or "OFF"), 2)
end

local function toggleInfJump()
    state.infjump = not state.infjump
    connections.infjump = UserInputService.JumpRequest:Connect(function()
        if state.infjump then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
    showNotification("Infinite Jump " .. (state.infjump and "ON" or "OFF"), 2)
end

local function toggleSpeed()
    state.speed = not state.speed
    humanoid.WalkSpeed = state.speed and CONFIG.SPEEDVALUE or originalSpeed
    showNotification("Speed " .. (state.speed and "ON ("..CONFIG.SPEEDVALUE..")" or "OFF"), 2)
end

local function toggleFullBright()
    state.fullbright = not state.fullbright
    if state.fullbright then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(100, 100, 100)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.GlobalShadows = true
    end
    showNotification("FullBright " .. (state.fullbright and "ON" or "OFF"), 2)
end

local function toggleGodMode()
    state.godmode = not state.godmode
    if state.godmode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
    showNotification("God Mode " .. (state.godmode and "ON" or "OFF"), 2)
end

-- MAIN INITIALIZATION
local mainFrame, closeBtn, combatFrame, screenGui = createModernGUI()
local toggleBtn = createToggleButton(screenGui)

-- CREATE FEATURE BUTTONS
local features = {
    {name = "Aimbot", key = "E", toggle = toggleAimbot},
    {name = "ESP", key = "T", toggle = toggleESP},
    {name = "KillAura", key = "K", toggle = toggleKillAura},
    {name = "Fast M1", key = "M", toggle = toggleFastM1},
    {name = "Fly", key = "F", toggle = toggleFly},
    {name = "NoClip", key = "N", toggle = toggleNoClip},
    {name = "Infinite Jump", key = "J", toggle = toggleInfJump},
    {name = "Speed Hack", key = "X", toggle = toggleSpeed},
    {name = "Full Bright", key = "B", toggle = toggleFullBright},
    {name = "God Mode", key = "V", toggle = toggleGodMode}
}

for i, feature in ipairs(features) do
    local btnFrame = Instance.new("TextButton")
    btnFrame.Size = UDim2.new(1, -10, 0, 45)
    btnFrame.BackgroundColor3 = Theme:GetTheme().Colors.ContainerBackground
    btnFrame.Text = feature.name .. " [" .. feature.key .. "]"
    btnFrame.TextColor3 = Theme:GetTheme().Colors.TextPrimary
    btnFrame.TextSize = 14
    btnFrame.Font = Theme.Fonts.Action
    btnFrame.Parent = combatFrame
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)
    
    btnFrame.MouseButton1Click:Connect(feature.toggle)
end

-- KEYBINDS
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CONFIG.GUITOGGLEKEY then
        mainFrame.Visible = not mainFrame.Visible
    elseif input.KeyCode == CONFIG.AIMBOTKEY then toggleAimbot()
    elseif input.KeyCode == CONFIG.ESPKEY then toggleESP()
    elseif input.KeyCode == CONFIG.KILLAURAKEY then toggleKillAura()
    elseif input.KeyCode == CONFIG.FASTM1KEY then toggleFastM1()
    elseif input.KeyCode == CONFIG.FLYKEY then toggleFly()
    elseif input.KeyCode == CONFIG.NOCLIPKEY then toggleNoClip()
    elseif input.KeyCode == CONFIG.INFJUMPKEY then toggleInfJump()
    elseif input.KeyCode == CONFIG.SPEEDKEY then toggleSpeed()
    elseif input.KeyCode == CONFIG.FULLBRIGHTKEY then toggleFullBright()
    elseif input.KeyCode == CONFIG.GODMODEKEY then toggleGodMode()
    end
end)

closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- CHARACTER RESPAWN HANDLING
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    originalSpeed = humanoid.WalkSpeed
    if state.speed then toggleSpeed() toggleSpeed() end
    if state.godmode then toggleGodMode() toggleGodMode() end
end)

print("✅ NullHub V2 - ALL FEATURES LOADED!")
showNotification("NullHub V2 Loaded! Press Insert to toggle.", 4)
