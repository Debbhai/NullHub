-- NullHub V3 - Main Script (WITH AUTO-OBBY SYSTEM)
-- Created by Debbhai
-- Loads Theme.lua + AntiDetection.lua from GitHub

print("[NullHub] Loading...")

-- ============================================
-- LOAD ANTI-DETECTION MODULE
-- ============================================
local AntiDetection
local ANTIDETECT_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/AntiDetection.lua"

local success1, result1 = pcall(function()
    return loadstring(game:HttpGet(ANTIDETECT_URL))()
end)

if success1 and result1 then
    AntiDetection = result1
    AntiDetection:Initialize()
    print("[NullHub] ✅ Anti-Detection loaded from GitHub")
else
    print("[NullHub] ⚠️ Anti-Detection failed to load - Using fallback")
    AntiDetection = {
        AddRandomDelay = function(self, s) end,
        SmoothTransition = function(self, t, c, s, m) return t end,
        GetVariableSmoothness = function(self, b, s) return b end,
    }
end

-- ============================================
-- LOAD THEME MODULE
-- ============================================
local Theme
local THEME_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/Theme.lua"

local success2, result2 = pcall(function()
    return loadstring(game:HttpGet(THEME_URL))()
end)

if success2 and result2 then
    Theme = result2
    print("[NullHub] ✅ Theme loaded from GitHub")
else
    print("[NullHub] ⚠️ Loading fallback theme (embedded)")
    Theme = {
        Themes = {Dark = {Colors = {MainBackground = Color3.fromRGB(10, 10, 12), HeaderBackground = Color3.fromRGB(15, 15, 18), SidebarBackground = Color3.fromRGB(12, 12, 14), ContainerBackground = Color3.fromRGB(18, 18, 22), InputBackground = Color3.fromRGB(20, 20, 24), DropdownBackground = Color3.fromRGB(22, 22, 26), PlayerButtonBg = Color3.fromRGB(25, 25, 30), TabNormal = Color3.fromRGB(16, 16, 20), TabSelected = Color3.fromRGB(28, 28, 34), AccentBar = Color3.fromRGB(255, 215, 0), ScrollBarColor = Color3.fromRGB(218, 165, 32), StatusOff = Color3.fromRGB(220, 60, 60), StatusOn = Color3.fromRGB(50, 220, 100), ContainerOff = Color3.fromRGB(18, 18, 22), ContainerOn = Color3.fromRGB(25, 35, 45), TextPrimary = Color3.fromRGB(255, 255, 255), TextSecondary = Color3.fromRGB(160, 160, 180), TextPlaceholder = Color3.fromRGB(120, 120, 140), BorderColor = Color3.fromRGB(40, 40, 50), CloseButton = Color3.fromRGB(220, 60, 70), MinimizeButton = Color3.fromRGB(255, 180, 0), ToggleButton = Color3.fromRGB(255, 215, 0), NotificationBg = Color3.fromRGB(15, 15, 18)}, Transparency = {MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15, Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1, Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4, Tab = 0.2, ToggleButton = 0.1, Notification = 0.1}}, Light = {Colors = {MainBackground = Color3.fromRGB(245, 245, 250), HeaderBackground = Color3.fromRGB(255, 255, 255), SidebarBackground = Color3.fromRGB(250, 250, 252), ContainerBackground = Color3.fromRGB(255, 255, 255), InputBackground = Color3.fromRGB(248, 248, 250), DropdownBackground = Color3.fromRGB(252, 252, 254), PlayerButtonBg = Color3.fromRGB(245, 245, 248), TabNormal = Color3.fromRGB(240, 240, 245), TabSelected = Color3.fromRGB(230, 230, 240), AccentBar = Color3.fromRGB(100, 100, 255), ScrollBarColor = Color3.fromRGB(100, 100, 255), StatusOff = Color3.fromRGB(255, 100, 100), StatusOn = Color3.fromRGB(100, 200, 100), ContainerOff = Color3.fromRGB(255, 255, 255), ContainerOn = Color3.fromRGB(240, 245, 255), TextPrimary = Color3.fromRGB(20, 20, 30), TextSecondary = Color3.fromRGB(100, 100, 120), TextPlaceholder = Color3.fromRGB(140, 140, 160), BorderColor = Color3.fromRGB(220, 220, 230), CloseButton = Color3.fromRGB(255, 100, 110), MinimizeButton = Color3.fromRGB(255, 200, 0), ToggleButton = Color3.fromRGB(100, 100, 255), NotificationBg = Color3.fromRGB(255, 255, 255)}, Transparency = {MainBackground = 0.05, Header = 0, Sidebar = 0.05, Container = 0, Input = 0.05, Dropdown = 0, PlayerButton = 0.1, CloseButton = 0, Stroke = 0.3, AccentBar = 0, StatusIndicator = 0, ScrollBar = 0.3, Tab = 0.05, ToggleButton = 0, Notification = 0.05}}, Neon = {Colors = {MainBackground = Color3.fromRGB(5, 5, 15), HeaderBackground = Color3.fromRGB(10, 10, 20), SidebarBackground = Color3.fromRGB(8, 8, 18), ContainerBackground = Color3.fromRGB(12, 12, 25), InputBackground = Color3.fromRGB(15, 15, 30), DropdownBackground = Color3.fromRGB(18, 18, 32), PlayerButtonBg = Color3.fromRGB(20, 20, 35), TabNormal = Color3.fromRGB(10, 10, 22), TabSelected = Color3.fromRGB(25, 25, 45), AccentBar = Color3.fromRGB(0, 255, 255), ScrollBarColor = Color3.fromRGB(255, 0, 255), StatusOff = Color3.fromRGB(255, 50, 150), StatusOn = Color3.fromRGB(0, 255, 150), ContainerOff = Color3.fromRGB(12, 12, 25), ContainerOn = Color3.fromRGB(25, 15, 45), TextPrimary = Color3.fromRGB(255, 255, 255), TextSecondary = Color3.fromRGB(150, 200, 255), TextPlaceholder = Color3.fromRGB(100, 150, 200), BorderColor = Color3.fromRGB(100, 0, 255), CloseButton = Color3.fromRGB(255, 0, 100), MinimizeButton = Color3.fromRGB(255, 255, 0), ToggleButton = Color3.fromRGB(0, 255, 255), NotificationBg = Color3.fromRGB(10, 10, 20)}, Transparency = {MainBackground = 0.05, Header = 0.03, Sidebar = 0.08, Container = 0.12, Input = 0.15, Dropdown = 0.12, PlayerButton = 0.2, CloseButton = 0.08, Stroke = 0.3, AccentBar = 0.1, StatusIndicator = 0, ScrollBar = 0.3, Tab = 0.15, ToggleButton = 0.08, Notification = 0.08}}},
        CurrentTheme = "Dark",
        Sizes = {MainFrameWidth = 680, MainFrameHeight = 450, SidebarWidth = 150, HeaderHeight = 45, CloseButton = 38, TabHeight = 40, ActionRowHeight = 46, StatusIndicator = 12, InputHeight = 36, DropdownHeight = 90, PlayerButtonHeight = 28, ScrollBarThickness = 5, ToggleButton = 55, NotificationWidth = 300, NotificationHeight = 60},
        CornerRadius = {Large = 14, Medium = 10, Small = 7, Tiny = 5},
        Fonts = {Title = Enum.Font.GothamBold, Tab = Enum.Font.GothamMedium, Action = Enum.Font.Gotham, Input = Enum.Font.Gotham},
        FontSizes = {Title = 19, Tab = 15, Action = 14, Input = 13},
    }
    function Theme:GetTheme() return self.Themes[self.CurrentTheme] or self.Themes.Dark end
    function Theme:SetTheme(themeName) if self.Themes[themeName] then self.CurrentTheme = themeName return true end return false end
    function Theme:GetAllThemeNames() local names = {} for name, _ in pairs(self.Themes) do table.insert(names, name) end return names end
end

print("[NullHub] Current Theme: " .. Theme.CurrentTheme)

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- ============================================
-- CONFIG
-- ============================================
local CONFIG = {
    GUI_TOGGLE_KEY = Enum.KeyCode.Insert, AIMBOT_KEY = Enum.KeyCode.E, AIMBOT_FOV = 250, AIMBOT_SMOOTHNESS = 0.15,
    ESP_KEY = Enum.KeyCode.T, ESP_COLOR = Color3.fromRGB(255, 80, 80), ESP_SHOW_DISTANCE = true,
    KILLAURA_KEY = Enum.KeyCode.K, KILLAURA_RANGE = 25, KILLAURA_DELAY = 0.15,
    FASTM1_KEY = Enum.KeyCode.M, FASTM1_DELAY = 0.05, 
    FLY_KEY = Enum.KeyCode.F, FLY_SPEED = 120,
    NOCLIP_KEY = Enum.KeyCode.N, INFJUMP_KEY = Enum.KeyCode.J, SPEED_KEY = Enum.KeyCode.X,
    SPEED_VALUE = 500000, MIN_SPEED = 0, MAX_SPEED = 1000000,
    FULLBRIGHT_KEY = Enum.KeyCode.B, GODMODE_KEY = Enum.KeyCode.V, 
    TELEPORT_KEY = Enum.KeyCode.Z, TELEPORT_SPEED = 150,
    WALKONWATER_KEY = Enum.KeyCode.U,
    STEALTH_MODE = true,
    AUTO_OBBY_SPEED = 150,
    AUTO_OBBY_HEIGHT = 7,
    CHECKPOINT_REACH_DISTANCE = 8,
    OBSTACLE_AVOIDANCE_HEIGHT = 10,
}

-- ============================================
-- STATE
-- ============================================
local state = {aimbot = false, esp = false, noclip = false, infjump = false, speed = false, fullbright = false, godmode = false, killaura = false, fastm1 = false, fly = false, walkonwater = false, autoObby = false}
local espObjects, connections, killAuraTargets = {}, {}, {}
local originalSpeed, originalLightingSettings = 16, {}
local selectedTeleportPlayer, isTeleporting, currentTeleportTween = nil, false, nil
local selectedCheckpoint, currentCheckpointIndex, isAutoObby = nil, 1, false
local allCheckpoints = {}
local guiVisible, mainFrameRef, guiButtons, contentScroll, pageTitle, screenGuiRef = true, nil, {}, nil, nil, nil
local waterPlatform = nil

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================
local function showNotification(message, duration)
    duration = duration or 3
    if not screenGuiRef then return end
    local currentTheme = Theme:GetTheme()
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, Theme.Sizes.NotificationWidth, 0, Theme.Sizes.NotificationHeight)
    notification.Position = UDim2.new(1, Theme.Sizes.NotificationWidth + 20, 1, -Theme.Sizes.NotificationHeight - 10)
    notification.BackgroundColor3 = currentTheme.Colors.NotificationBg
    notification.BackgroundTransparency = 1
    notification.BorderSizePixel = 0
    notification.ZIndex = 10000
    notification.Parent = screenGuiRef
    Instance.new("UICorner", notification).CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
    local stroke = Instance.new("UIStroke", notification)
    stroke.Color = currentTheme.Colors.AccentBar
    stroke.Thickness = 2
    stroke.Transparency = 1
    local text = Instance.new("TextLabel", notification)
    text.Size = UDim2.new(1, -20, 1, 0)
    text.Position = UDim2.new(0, 10, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = currentTheme.Colors.TextPrimary
    text.TextSize = Theme.FontSizes.Action
    text.Font = Theme.Fonts.Action
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextYAlignment = Enum.TextYAlignment.Center
    text.TextTransparency = 1
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -Theme.Sizes.NotificationWidth - 10, 1, -Theme.Sizes.NotificationHeight - 10), BackgroundTransparency = currentTheme.Transparency.Notification}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.5), {Transparency = 0.3}):Play()
    TweenService:Create(text, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    task.delay(duration, function()
        TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, Theme.Sizes.NotificationWidth + 20, 1, -Theme.Sizes.NotificationHeight - 10), BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
        TweenService:Create(text, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.delay(0.6, function() notification:Destroy() end)
    end)
end

-- ============================================
-- THEME APPLICATION
-- ============================================
local function applyThemeToElement(element, elementType)
    local currentTheme = Theme:GetTheme()
    if elementType == "MainFrame" then
        element.BackgroundColor3 = currentTheme.Colors.MainBackground
        element.BackgroundTransparency = currentTheme.Transparency.MainBackground
        element:FindFirstChild("UIStroke").Color = currentTheme.Colors.BorderColor
    elseif elementType == "TopBar" then
        element.BackgroundColor3 = currentTheme.Colors.HeaderBackground
        element.BackgroundTransparency = currentTheme.Transparency.Header
        element:FindFirstChild("AccentLine").BackgroundColor3 = currentTheme.Colors.AccentBar
    elseif elementType == "Sidebar" then
        element.BackgroundColor3 = currentTheme.Colors.SidebarBackground
        element.BackgroundTransparency = currentTheme.Transparency.Sidebar
    elseif elementType == "Tab" then
        element.BackgroundColor3 = currentTheme.Colors.TabNormal
        element.BackgroundTransparency = currentTheme.Transparency.Tab
    elseif elementType == "Container" then
        element.BackgroundColor3 = currentTheme.Colors.ContainerBackground
        element.BackgroundTransparency = currentTheme.Transparency.Container
    elseif elementType == "Input" then
        element.BackgroundColor3 = currentTheme.Colors.InputBackground
        element.BackgroundTransparency = currentTheme.Transparency.Input
        element.TextColor3 = currentTheme.Colors.TextPrimary
        element.PlaceholderColor3 = currentTheme.Colors.TextPlaceholder
    end
end

local function refreshGUITheme()
    if not mainFrameRef then return end
    local currentTheme = Theme:GetTheme()
    applyThemeToElement(mainFrameRef, "MainFrame")
    local topBar = mainFrameRef:FindFirstChild("TopBar")
    if topBar then
        applyThemeToElement(topBar, "TopBar")
        topBar:FindFirstChild("Title").TextColor3 = currentTheme.Colors.TextPrimary
        topBar:FindFirstChild("CloseButton").BackgroundColor3 = currentTheme.Colors.CloseButton
    end
    local sidebar = mainFrameRef:FindFirstChild("Sidebar")
    if sidebar then
        applyThemeToElement(sidebar, "Sidebar")
        for _, tab in pairs(sidebar:GetChildren()) do
            if tab:IsA("TextButton") then
                applyThemeToElement(tab, "Tab")
                tab.TextColor3 = currentTheme.Colors.TextPrimary
            end
        end
    end
    if contentScroll then
        for _, child in pairs(contentScroll:GetChildren()) do
            if child:IsA("Frame") then
                applyThemeToElement(child, "Container")
                local input = child:FindFirstChild("SpeedInput")
                if input then applyThemeToElement(input, "Input") end
                for _, label in pairs(child:GetChildren()) do
                    if label:IsA("TextLabel") then label.TextColor3 = currentTheme.Colors.TextPrimary end
                end
            end
        end
    end
    showNotification("Theme changed to " .. Theme.CurrentTheme, 2)
end

-- ============================================
-- TOGGLE BUTTON
-- ============================================
local function createToggleButton(screenGui)
    local currentTheme = Theme:GetTheme()
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, Theme.Sizes.ToggleButton, 0, Theme.Sizes.ToggleButton)
    toggleBtn.Position = UDim2.new(0, 15, 0.5, -Theme.Sizes.ToggleButton/2)
    toggleBtn.BackgroundColor3 = currentTheme.Colors.ToggleButton
    toggleBtn.BackgroundTransparency = currentTheme.Transparency.ToggleButton
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "N"
    toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggleBtn.TextSize = 28
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.ZIndex = 1000
    toggleBtn.Parent = screenGui
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.5, 0)
    local stroke = Instance.new("UIStroke", toggleBtn)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 3
    stroke.Transparency = 0.3
    local dragging, dragStart, startPos, dragDistance = false, nil, nil, 0
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = toggleBtn.Position
            dragDistance = 0
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            dragDistance = delta.Magnitude
            toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    toggleBtn.MouseButton1Click:Connect(function()
        if dragDistance < 5 then
            local targetPos = guiVisible and UDim2.new(0.5, -Theme.Sizes.MainFrameWidth/2, -1, 0) or UDim2.new(0.5, -Theme.Sizes.MainFrameWidth/2, 0.5, -Theme.Sizes.MainFrameHeight/2)
            guiVisible = not guiVisible
            TweenService:Create(mainFrameRef, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = targetPos}):Play()
        end
    end)
    return toggleBtn
end

-- ============================================
-- CLOSE PROMPT
-- ============================================
local function createClosePrompt(screenGui)
    local currentTheme = Theme:GetTheme()
    local prompt = Instance.new("Frame")
    prompt.Size = UDim2.new(0, 320, 0, 160)
    prompt.Position = UDim2.new(0.5, -160, 0.5, -80)
    prompt.BackgroundColor3 = currentTheme.Colors.MainBackground
    prompt.BackgroundTransparency = currentTheme.Transparency.MainBackground
    prompt.BorderSizePixel = 0
    prompt.Visible = false
    prompt.ZIndex = 2000
    prompt.Parent = screenGui
    Instance.new("UICorner", prompt).CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
    local stroke = Instance.new("UIStroke", prompt)
    stroke.Color = currentTheme.Colors.AccentBar
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    local title = Instance.new("TextLabel", prompt)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Close NullHub?"
    title.TextColor3 = currentTheme.Colors.TextPrimary
    title.TextSize = Theme.FontSizes.Title
    title.Font = Theme.Fonts.Title
    local desc = Instance.new("TextLabel", prompt)
    desc.Size = UDim2.new(1, -20, 0, 30)
    desc.Position = UDim2.new(0, 10, 0, 45)
    desc.BackgroundTransparency = 1
    desc.Text = "Choose an action:"
    desc.TextColor3 = currentTheme.Colors.TextSecondary
    desc.TextSize = 13
    desc.Font = Theme.Fonts.Action
    desc.TextXAlignment = Enum.TextXAlignment.Left
    local minimizeBtn = Instance.new("TextButton", prompt)
    minimizeBtn.Size = UDim2.new(0, 140, 0, 38)
    minimizeBtn.Position = UDim2.new(0, 10, 1, -48)
    minimizeBtn.BackgroundColor3 = currentTheme.Colors.MinimizeButton
    minimizeBtn.BackgroundTransparency = 0.1
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "Minimize"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 15
    minimizeBtn.Font = Theme.Fonts.Tab
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    local closeBtn = Instance.new("TextButton", prompt)
    closeBtn.Size = UDim2.new(0, 140, 0, 38)
    closeBtn.Position = UDim2.new(1, -150, 1, -48)
    closeBtn.BackgroundColor3 = currentTheme.Colors.CloseButton
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Close & Destroy"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 15
    closeBtn.Font = Theme.Fonts.Tab
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    return prompt, minimizeBtn, closeBtn
end

-- ============================================
-- GUI CREATION
-- ============================================
local function createModernGUI()
    local currentTheme = Theme:GetTheme()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NullHubGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    screenGui.Parent = player:WaitForChild("PlayerGui")
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, Theme.Sizes.MainFrameWidth, 0, Theme.Sizes.MainFrameHeight)
    mainFrame.Position = UDim2.new(0.5, -Theme.Sizes.MainFrameWidth/2, 0.5, -Theme.Sizes.MainFrameHeight/2)
    mainFrame.BackgroundColor3 = currentTheme.Colors.MainBackground
    mainFrame.BackgroundTransparency = currentTheme.Transparency.MainBackground
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, Theme.CornerRadius.Large)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = currentTheme.Colors.BorderColor
    mainStroke.Thickness = 1
    mainStroke.Transparency = currentTheme.Transparency.Stroke
    local topBar = Instance.new("Frame", mainFrame)
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, Theme.Sizes.HeaderHeight)
    topBar.BackgroundColor3 = currentTheme.Colors.HeaderBackground
    topBar.BackgroundTransparency = currentTheme.Transparency.Header
    topBar.BorderSizePixel = 0
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, Theme.CornerRadius.Large)
    local accentLine = Instance.new("Frame", topBar)
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = currentTheme.Colors.AccentBar
    accentLine.BackgroundTransparency = currentTheme.Transparency.AccentBar
    accentLine.BorderSizePixel = 0
    local title = Instance.new("TextLabel", topBar)
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 18, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ NullHub | Protected"
    title.TextColor3 = currentTheme.Colors.TextPrimary
    title.TextSize = Theme.FontSizes.Title
    title.Font = Theme.Fonts.Title
    title.TextXAlignment = Enum.TextXAlignment.Left
    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, Theme.Sizes.CloseButton, 0, Theme.Sizes.CloseButton)
    closeBtn.Position = UDim2.new(1, -Theme.Sizes.CloseButton - 6, 0, 3.5)
    closeBtn.BackgroundColor3 = currentTheme.Colors.CloseButton
    closeBtn.BackgroundTransparency = currentTheme.Transparency.CloseButton
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = currentTheme.Colors.TextPrimary
    closeBtn.TextSize = 26
    closeBtn.Font = Theme.Fonts.Title
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
    local sidebar = Instance.new("Frame", mainFrame)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - 8)
    sidebar.Position = UDim2.new(0, 6, 0, Theme.Sizes.HeaderHeight + 6)
    sidebar.BackgroundColor3 = currentTheme.Colors.SidebarBackground
    sidebar.BackgroundTransparency = currentTheme.Transparency.Sidebar
    sidebar.BorderSizePixel = 0
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
    local sidebarStroke = Instance.new("UIStroke", sidebar)
    sidebarStroke.Color = currentTheme.Colors.BorderColor
    sidebarStroke.Thickness = 1
    sidebarStroke.Transparency = currentTheme.Transparency.Stroke
    local sidebarList = Instance.new("UIListLayout", sidebar)
    sidebarList.Padding = UDim.new(0, 6)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    local sidebarPadding = Instance.new("UIPadding", sidebar)
    sidebarPadding.PaddingTop = UDim.new(0, 8)
    sidebarPadding.PaddingLeft = UDim.new(0, 8)
    sidebarPadding.PaddingRight = UDim.new(0, 8)
    sidebarPadding.PaddingBottom = UDim.new(0, 8)
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -Theme.Sizes.SidebarWidth - 18, 1, -Theme.Sizes.HeaderHeight - 14)
    contentFrame.Position = UDim2.new(0, Theme.Sizes.SidebarWidth + 12, 0, Theme.Sizes.HeaderHeight + 8)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    local pageTitleLabel = Instance.new("TextLabel", contentFrame)
    pageTitleLabel.Name = "PageTitle"
    pageTitleLabel.Size = UDim2.new(1, 0, 0, 32)
    pageTitleLabel.BackgroundTransparency = 1
    pageTitleLabel.Text = "Combat"
    pageTitleLabel.TextColor3 = currentTheme.Colors.TextPrimary
    pageTitleLabel.TextSize = Theme.FontSizes.Title
    pageTitleLabel.Font = Theme.Fonts.Title
    pageTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    local actionScroll = Instance.new("ScrollingFrame", contentFrame)
    actionScroll.Name = "ActionScroll"
    actionScroll.Size = UDim2.new(1, -8, 1, -40)
    actionScroll.Position = UDim2.new(0, 0, 0, 38)
    actionScroll.BackgroundTransparency = 1
    actionScroll.BorderSizePixel = 0
    actionScroll.ScrollBarThickness = Theme.Sizes.ScrollBarThickness
    actionScroll.ScrollBarImageColor3 = currentTheme.Colors.ScrollBarColor
    actionScroll.ScrollBarImageTransparency = currentTheme.Transparency.ScrollBar
    actionScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    actionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", actionScroll).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", actionScroll).PaddingRight = UDim.new(0, 4)
    return mainFrame, closeBtn, sidebar, contentFrame, pageTitleLabel, actionScroll, screenGui
end

local function createTabButton(parent, tabName, icon, index)
    local currentTheme = Theme:GetTheme()
    local tabBtn = Instance.new("TextButton", parent)
    tabBtn.Name = "Tab_" .. tabName
    tabBtn.Size = UDim2.new(1, 0, 0, Theme.Sizes.TabHeight)
    tabBtn.BackgroundColor3 = currentTheme.Colors.TabNormal
    tabBtn.BackgroundTransparency = currentTheme.Transparency.Tab
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = "  " .. icon .. "  " .. tabName
    tabBtn.TextColor3 = currentTheme.Colors.TextPrimary
    tabBtn.TextSize = Theme.FontSizes.Tab
    tabBtn.Font = Theme.Fonts.Tab
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.LayoutOrder = index
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    local tabStroke = Instance.new("UIStroke", tabBtn)
    tabStroke.Color = currentTheme.Colors.BorderColor
    tabStroke.Thickness = 1
    tabStroke.Transparency = 0.7
    return tabBtn
end

local function createActionRow(parent, actionData, index)
    local currentTheme = Theme:GetTheme()
    local rowHeight = Theme.Sizes.ActionRowHeight
    if actionData.hasInput then rowHeight = Theme.Sizes.ActionRowHeight + Theme.Sizes.InputHeight + 12
    elseif actionData.hasDropdown then rowHeight = Theme.Sizes.ActionRowHeight + Theme.Sizes.DropdownHeight + 12
    elseif actionData.hasCheckpointDropdown then rowHeight = Theme.Sizes.ActionRowHeight + Theme.Sizes.DropdownHeight + 12
    elseif actionData.hasStopButton then rowHeight = Theme.Sizes.ActionRowHeight * 2 + 12 end
    local actionFrame = Instance.new("Frame", parent)
    actionFrame.Name = actionData.name .. "Row"
    actionFrame.Size = UDim2.new(1, -4, 0, rowHeight)
    actionFrame.BackgroundColor3 = currentTheme.Colors.ContainerBackground
    actionFrame.BackgroundTransparency = currentTheme.Transparency.Container
    actionFrame.BorderSizePixel = 0
    actionFrame.LayoutOrder = index
    Instance.new("UICorner", actionFrame).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    local rowStroke = Instance.new("UIStroke", actionFrame)
    rowStroke.Color = currentTheme.Colors.BorderColor
    rowStroke.Thickness = 1
    rowStroke.Transparency = currentTheme.Transparency.Stroke
    local actionBtn = Instance.new("TextButton", actionFrame)
    actionBtn.Name = actionData.state .. "Btn"
    actionBtn.Size = UDim2.new(1, 0, 0, Theme.Sizes.ActionRowHeight)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Text = ""
    local icon = Instance.new("TextLabel", actionFrame)
    icon.Size = UDim2.new(0, 32, 0, Theme.Sizes.ActionRowHeight)
    icon.Position = UDim2.new(0, 8, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = actionData.icon
    icon.TextSize = 20
    local nameLabel = Instance.new("TextLabel", actionFrame)
    nameLabel.Size = UDim2.new(1, -90, 0, Theme.Sizes.ActionRowHeight)
    nameLabel.Position = UDim2.new(0, 42, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = actionData.name .. " [" .. actionData.key .. "]"
    nameLabel.TextColor3 = currentTheme.Colors.TextPrimary
    nameLabel.TextSize = Theme.FontSizes.Action
    nameLabel.Font = Theme.Fonts.Action
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    local statusIndicator = Instance.new("Frame", actionFrame)
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, Theme.Sizes.StatusIndicator, 0, Theme.Sizes.StatusIndicator)
    statusIndicator.Position = UDim2.new(1, -24, 0, (Theme.Sizes.ActionRowHeight - Theme.Sizes.StatusIndicator) / 2)
    statusIndicator.BackgroundColor3 = currentTheme.Colors.StatusOff
    statusIndicator.BackgroundTransparency = currentTheme.Transparency.StatusIndicator
    statusIndicator.BorderSizePixel = 0
    Instance.new("UICorner", statusIndicator).CornerRadius = UDim.new(1, 0)
    if actionData.hasInput then
        local speedInput = Instance.new("TextBox", actionFrame)
        speedInput.Name = "SpeedInput"
        speedInput.Size = UDim2.new(1, -16, 0, Theme.Sizes.InputHeight)
        speedInput.Position = UDim2.new(0, 8, 0, Theme.Sizes.ActionRowHeight + 6)
        speedInput.BackgroundColor3 = currentTheme.Colors.InputBackground
        speedInput.BackgroundTransparency = currentTheme.Transparency.Input
        speedInput.BorderSizePixel = 0
        speedInput.Text = tostring(CONFIG.SPEED_VALUE)
        speedInput.PlaceholderText = "Speed (0-1000000)"
        speedInput.TextColor3 = currentTheme.Colors.TextPrimary
        speedInput.PlaceholderColor3 = currentTheme.Colors.TextPlaceholder
        speedInput.TextSize = Theme.FontSizes.Input
        speedInput.Font = Theme.Fonts.Input
        speedInput.ClearTextOnFocus = false
        Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, Theme.CornerRadius.Tiny)
        Instance.new("UIPadding", speedInput).PaddingLeft = UDim.new(0, 10)
        return actionFrame, actionBtn, statusIndicator, speedInput
    end
    if actionData.hasDropdown then
        local dropdown = Instance.new("ScrollingFrame", actionFrame)
        dropdown.Name = "PlayerDropdown"
        dropdown.Size = UDim2.new(1, -16, 0, Theme.Sizes.DropdownHeight)
        dropdown.Position = UDim2.new(0, 8, 0, Theme.Sizes.ActionRowHeight + 6)
        dropdown.BackgroundColor3 = currentTheme.Colors.DropdownBackground
        dropdown.BackgroundTransparency = currentTheme.Transparency.Dropdown
        dropdown.BorderSizePixel = 0
        dropdown.ScrollBarThickness = 4
        dropdown.ScrollBarImageColor3 = currentTheme.Colors.ScrollBarColor
        dropdown.ScrollBarImageTransparency = currentTheme.Transparency.ScrollBar
        dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
        dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, Theme.CornerRadius.Tiny)
        local placeholderLabel = Instance.new("TextLabel", dropdown)
        placeholderLabel.Name = "PlaceholderText"
        placeholderLabel.Size = UDim2.new(1, -16, 0, 30)
        placeholderLabel.Position = UDim2.new(0, 8, 0, 8)
        placeholderLabel.BackgroundTransparency = 1
        placeholderLabel.Text = "Select a player..."
        placeholderLabel.TextColor3 = currentTheme.Colors.TextPlaceholder
        placeholderLabel.TextSize = Theme.FontSizes.Input
        placeholderLabel.Font = Theme.Fonts.Input
        placeholderLabel.TextXAlignment = Enum.TextXAlignment.Left
        return actionFrame, actionBtn, statusIndicator, nil, dropdown, placeholderLabel
    end
    if actionData.hasStopButton then
        local stopBtn = Instance.new("TextButton", actionFrame)
        stopBtn.Name = "StopTweenBtn"
        stopBtn.Size = UDim2.new(1, -16, 0, Theme.Sizes.ActionRowHeight)
        stopBtn.Position = UDim2.new(0, 8, 0, Theme.Sizes.ActionRowHeight + 6)
        stopBtn.BackgroundColor3 = currentTheme.Colors.CloseButton
        stopBtn.BackgroundTransparency = 0.1
        stopBtn.BorderSizePixel = 0
        stopBtn.Text = "⏹ Stop Tween"
        stopBtn.TextColor3 = currentTheme.Colors.TextPrimary
        stopBtn.TextSize = Theme.FontSizes.Action
        stopBtn.Font = Theme.Fonts.Tab
        Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
        return actionFrame, actionBtn, statusIndicator, nil, nil, nil, stopBtn
    end
    return actionFrame, actionBtn, statusIndicator
end

local function createThemeButton(parent, themeName, index)
    local currentTheme = Theme:GetTheme()
    local themeBtn = Instance.new("TextButton", parent)
    themeBtn.Name = "Theme_" .. themeName
    themeBtn.Size = UDim2.new(1, -16, 0, Theme.Sizes.ActionRowHeight)
    themeBtn.Position = UDim2.new(0, 8, 0, (index - 1) * (Theme.Sizes.ActionRowHeight + 6) + 6)
    themeBtn.BackgroundColor3 = currentTheme.Colors.ContainerBackground
    themeBtn.BackgroundTransparency = currentTheme.Transparency.Container
    themeBtn.BorderSizePixel = 0
    themeBtn.Text = "  ●  " .. themeName
    themeBtn.TextColor3 = currentTheme.Colors.TextPrimary
    themeBtn.TextSize = Theme.FontSizes.Action
    themeBtn.Font = Theme.Fonts.Action
    themeBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    local btnStroke = Instance.new("UIStroke", themeBtn)
    btnStroke.Color = currentTheme.Colors.BorderColor
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.7
    return themeBtn
end

local featuresByTab = {
    Combat = {
        {name = "Aimbot", key = "E", state = "aimbot", icon = "🎯"},
        {name = "ESP", key = "T", state = "esp", icon = "👁️"},
        {name = "KillAura", key = "K", state = "killaura", icon = "⚔️"},
        {name = "Fast M1", key = "M", state = "fastm1", icon = "👊"},
    },
    Movement = {
        {name = "Fly", key = "F", state = "fly", icon = "🕊️"},
        {name = "NoClip", key = "N", state = "noclip", icon = "👻"},
        {name = "Infinite Jump", key = "J", state = "infjump", icon = "🦘"},
        {name = "Speed Hack", key = "X", state = "speed", icon = "⚡", hasInput = true},
        {name = "Walk on Water", key = "U", state = "walkonwater", icon = "🌊"},
    },
    Visual = {
        {name = "Full Bright", key = "B", state = "fullbright", icon = "💡"},
        {name = "God Mode", key = "V", state = "godmode", icon = "🛡️"},
    },
    Teleport = {
        {name = "Teleport To Player", key = "Z", state = "teleport", icon = "🚀", isAction = true, hasDropdown = true},
        {name = "Auto-Complete Obby", key = "", state = "autoObby", icon = "🎯"},
        {name = "Stop Teleport", key = "", state = "stop_tween", icon = "⏹", isAction = true, hasStopButton = true},
    },
    Themes = {},
}

local function updateContentPage(tabName)
    if not contentScroll then return end
    for _, child in pairs(contentScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
    end
    if pageTitle then pageTitle.Text = tabName end
    if tabName == "Themes" then
        local themeNames = Theme:GetAllThemeNames()
        for i, themeName in ipairs(themeNames) do
            local themeBtn = createThemeButton(contentScroll, themeName, i)
            themeBtn.MouseButton1Click:Connect(function()
                if Theme:SetTheme(themeName) then refreshGUITheme() end
            end)
        end
        return
    end
    local features = featuresByTab[tabName] or {}
    for i, feature in ipairs(features) do
        local frame, btn, indicator, input, dropdown, placeholder, stopBtn = createActionRow(contentScroll, feature, i)
        guiButtons[feature.state] = {button = btn, indicator = indicator, container = frame, isAction = feature.isAction or false, input = input, dropdown = dropdown, placeholder = placeholder, stopBtn = stopBtn}
    end
end

-- ============================================
-- ADVANCED AUTO-OBBY SYSTEM
-- ============================================
local function findAllCheckpoints()
    local checkpoints = {}
    local checkpointNames = {"CheckpointArrow", "Checkpoint", "checkpoint", "CheckPoint", "Stage", "stage", "Spawn", "spawn", "SpawnLocation", "Respawn"}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("SpawnLocation") then
            local objName = obj.Name
            for _, keyword in pairs(checkpointNames) do
                if objName:find(keyword) then
                    local stageNum = tonumber(objName:match("%d+")) or 0
                    local position = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
                    table.insert(checkpoints, {part = obj, name = objName, stage = stageNum, position = position})
                    break
                end
            end
            local stageValue = obj:FindFirstChild("Stage") or obj:FindFirstChild("Checkpoint")
            if stageValue and stageValue:IsA("NumberValue") then
                local position = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
                table.insert(checkpoints, {part = obj, name = obj.Name .. " (Stage " .. stageValue.Value .. ")", stage = stageValue.Value, position = position})
            end
        end
    end
    
    table.sort(checkpoints, function(a, b) return a.stage < b.stage end)
    return checkpoints
end

local function isObstacle(part)
    if not part or not part:IsA("BasePart") then return false end
    local partName = part.Name:lower()
    local obstacleKeywords = {"kill", "lava", "spike", "trap", "death", "damage", "hurt", "void"}
    for _, keyword in pairs(obstacleKeywords) do
        if partName:find(keyword) then return true end
    end
    if part.Color == Color3.fromRGB(255, 0, 0) or part.Color == Color3.fromRGB(255, 100, 100) then return true end
    if part.Material == Enum.Material.Neon and (part.Color.R > 0.8 and part.Color.G < 0.3) then return true end
    return false
end

local function getSafePathToCheckpoint(targetPos)
    if not rootPart then return targetPos end
    local startPos = rootPart.Position
    local direction = (targetPos - startPos).Unit
    local distance = (targetPos - startPos).Magnitude
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    for i = 1, math.floor(distance / 5) do
        local checkPos = startPos + (direction * (i * 5))
        local rayResult = workspace:Raycast(checkPos, Vector3.new(0, -20, 0), rayParams)
        
        if rayResult and rayResult.Instance then
            if isObstacle(rayResult.Instance) then
                return Vector3.new(checkPos.X, checkPos.Y + CONFIG.OBSTACLE_AVOIDANCE_HEIGHT, checkPos.Z)
            end
        end
    end
    
    return Vector3.new(targetPos.X, targetPos.Y + CONFIG.AUTO_OBBY_HEIGHT, targetPos.Z)
end

local function autoCompleteObby()
    if not isAutoObby or not rootPart then return end
    
    allCheckpoints = findAllCheckpoints()
    
    if #allCheckpoints == 0 then
        showNotification("No checkpoints found!", 3)
        state.autoObby = false
        isAutoObby = false
        updateButtonVisual("autoObby")
        return
    end
    
    showNotification("Starting Auto-Obby: " .. #allCheckpoints .. " checkpoints", 3)
    currentCheckpointIndex = 1
    
    while isAutoObby and currentCheckpointIndex <= #allCheckpoints do
        if not rootPart or not rootPart.Parent then
            showNotification("Character lost!", 2)
            break
        end
        
        local checkpoint = allCheckpoints[currentCheckpointIndex]
        
        if not checkpoint.part or not checkpoint.part.Parent then
            currentCheckpointIndex = currentCheckpointIndex + 1
            task.wait(0.1)
            continue
        end
        
        local targetPos = getSafePathToCheckpoint(checkpoint.position)
        local distance = (rootPart.Position - targetPos).Magnitude
        
        if distance > CONFIG.CHECKPOINT_REACH_DISTANCE then
            showNotification("Going to: " .. checkpoint.name .. " (" .. currentCheckpointIndex .. "/" .. #allCheckpoints .. ")", 2)
            
            local duration = distance / CONFIG.AUTO_OBBY_SPEED
            currentTeleportTween = TweenService:Create(
                rootPart,
                TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
                {CFrame = CFrame.new(targetPos)}
            )
            
            local tweenCompleted = false
            currentTeleportTween:Play()
            currentTeleportTween.Completed:Connect(function(playbackState)
                tweenCompleted = true
            end)
            
            local checkInterval = 0.1
            local maxWaitTime = duration + 2
            local waitedTime = 0
            
            while not tweenCompleted and waitedTime < maxWaitTime and isAutoObby do
                task.wait(checkInterval)
                waitedTime = waitedTime + checkInterval
                
                if rootPart and rootPart.Parent then
                    local currentDistance = (rootPart.Position - checkpoint.position).Magnitude
                    if currentDistance < CONFIG.CHECKPOINT_REACH_DISTANCE then
                        break
                    end
                end
            end
            
            task.wait(0.3)
        end
        
        currentCheckpointIndex = currentCheckpointIndex + 1
        task.wait(0.2)
    end
    
    if isAutoObby then
        showNotification("🎉 Obby Complete! All checkpoints reached!", 4)
        isAutoObby = false
        state.autoObby = false
        updateButtonVisual("autoObby")
    end
end

local function updatePlayerDropdown(dropdown)
    if not dropdown then return end
    local currentTheme = Theme:GetTheme()
    for _, child in pairs(dropdown:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("UIListLayout") or child:IsA("UIPadding") then child:Destroy() end
    end
    Instance.new("UIListLayout", dropdown).Padding = UDim.new(0, 4)
    local padding = Instance.new("UIPadding", dropdown)
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 6)
    local hasPlayers = false
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            hasPlayers = true
            local playerBtn = Instance.new("TextButton", dropdown)
            playerBtn.Name = otherPlayer.Name
            playerBtn.Size = UDim2.new(1, -8, 0, Theme.Sizes.PlayerButtonHeight)
            playerBtn.BackgroundColor3 = currentTheme.Colors.PlayerButtonBg
            playerBtn.BackgroundTransparency = currentTheme.Transparency.PlayerButton
            playerBtn.BorderSizePixel = 0
            playerBtn.Text = otherPlayer.Name
            playerBtn.TextColor3 = currentTheme.Colors.TextPrimary
            playerBtn.TextSize = Theme.FontSizes.Input
            playerBtn.Font = Theme.Fonts.Input
            Instance.new("UICorner", playerBtn).CornerRadius = UDim.new(0, Theme.CornerRadius.Tiny)
            playerBtn.MouseButton1Click:Connect(function()
                selectedTeleportPlayer = otherPlayer
                for _, btn in pairs(dropdown:GetChildren()) do
                    if btn:IsA("TextButton") then btn.BackgroundTransparency = currentTheme.Transparency.PlayerButton end
                end
                playerBtn.BackgroundTransparency = 0.15
            end)
        end
    end
    local placeholder = dropdown:FindFirstChild("PlaceholderText")
    if placeholder then placeholder.Visible = not hasPlayers end
end

-- ============================================
-- AIMBOT (USING ANTIDETECTION)
-- ============================================
local function getClosestPlayerForAimbot()
    local closestPlayer, shortestDistance = nil, CONFIG.AIMBOT_FOV
    local mousePos = UserInputService:GetMouseLocation()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            local otherHead = otherPlayer.Character:FindFirstChild("Head")
            if otherHumanoid and otherHead and otherHumanoid.Health > 0 then
                local screenPos, onScreen = camera:WorldToScreenPoint(otherHead.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function aimAtTarget(target)
    if not target or not target.Character then return end
    local targetHead = target.Character:FindFirstChild("Head")
    if not targetHead then return end
    AntiDetection:AddRandomDelay(CONFIG.STEALTH_MODE)
    local targetPos = targetHead.Position + (targetHead.AssemblyLinearVelocity * 0.1)
    local cameraPos = camera.CFrame.Position
    local newCFrame = CFrame.new(cameraPos, targetPos)
    local smoothness = AntiDetection:GetVariableSmoothness(CONFIG.AIMBOT_SMOOTHNESS, CONFIG.STEALTH_MODE)
    camera.CFrame = camera.CFrame:Lerp(newCFrame, smoothness)
end

-- ============================================
-- KILLAURA (USING ANTIDETECTION)
-- ============================================
local function findAllTargets()
    killAuraTargets = {}
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local hum = otherPlayer.Character:FindFirstChild("Humanoid")
            local root = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 and rootPart then
                local distance = (rootPart.Position - root.Position).Magnitude
                if distance <= CONFIG.KILLAURA_RANGE then
                    table.insert(killAuraTargets, {humanoid = hum, root = root, character = otherPlayer.Character})
                end
            end
        end
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Health > 0 then
            local char = obj.Parent
            if char and char ~= character and not Players:GetPlayerFromCharacter(char) then
                local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
                if root and rootPart then
                    local distance = (rootPart.Position - root.Position).Magnitude
                    if distance <= CONFIG.KILLAURA_RANGE then
                        table.insert(killAuraTargets, {humanoid = obj, root = root, character = char})
                    end
                end
            end
        end
    end
end

local function performKillAura()
    if not state.killaura or not character or not humanoid or not rootPart then return end
    AntiDetection:AddRandomDelay(CONFIG.STEALTH_MODE)
    findAllTargets()
    if #killAuraTargets == 0 then return end
    for _, target in pairs(killAuraTargets) do
        if target.humanoid and target.humanoid.Health > 0 then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                AntiDetection:AddRandomDelay(CONFIG.STEALTH_MODE)
                for _, descendant in pairs(tool:GetDescendants()) do
                    if descendant:IsA("RemoteEvent") then
                        pcall(function()
                            descendant:FireServer(target.root)
                            descendant:FireServer({Hit = target.root})
                            descendant:FireServer(target.humanoid)
                        end)
                    elseif descendant:IsA("RemoteFunction") then
                        pcall(function() descendant:InvokeServer(target.root) end)
                    end
                end
            end
            pcall(function() target.humanoid:TakeDamage(target.humanoid.MaxHealth / 10) end)
            break
        end
    end
end

local function performFastM1()
    if not state.fastm1 then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
    pcall(function()
        mouse1press()
        task.wait(0.01)
        mouse1release()
    end)
end

local function updateFly()
    if not state.fly or not rootPart then return end
    local moveDirection = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection -= Vector3.new(0, 1, 0) end
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * CONFIG.FLY_SPEED
    end
    if connections.flyBodyVelocity then 
        connections.flyBodyVelocity.Velocity = moveDirection 
    end
end

local function updateWalkOnWater()
    if not state.walkonwater or not rootPart then return end
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -10, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if rayResult and rayResult.Instance then
        if rayResult.Instance:IsA("Terrain") then
            local region = game.Workspace.Terrain:ReadVoxels(Region3.new(rayResult.Position - Vector3.new(2,2,2), rayResult.Position + Vector3.new(2,2,2)), 4)
            local size = region.Size
            for x = 1, size.X do
                for y = 1, size.Y do
                    for z = 1, size.Z do
                        if region[x][y][z] == Enum.Material.Water then
                            if not waterPlatform then
                                waterPlatform = Instance.new("Part")
                                waterPlatform.Name = "WaterPlatform"
                                waterPlatform.Size = Vector3.new(10, 0.5, 10)
                                waterPlatform.Anchored = true
                                waterPlatform.CanCollide = true
                                waterPlatform.Transparency = 0.8
                                waterPlatform.Material = Enum.Material.SmoothPlastic
                                waterPlatform.Color = Color3.fromRGB(0, 170, 255)
                                waterPlatform.Parent = workspace
                            end
                            waterPlatform.CFrame = CFrame.new(rootPart.Position.X, rayResult.Position.Y + 0.5, rootPart.Position.Z)
                            return
                        end
                    end
                end
            end
        end
    end
    if waterPlatform then
        waterPlatform:Destroy()
        waterPlatform = nil
    end
end

local function createESP(targetPlayer)
    if espObjects[targetPlayer] or not targetPlayer.Character then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = targetPlayer.Character
    highlight.FillColor = CONFIG.ESP_COLOR
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = targetPlayer.Character
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then return end
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_Billboard"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head
    local textLabel = Instance.new("TextLabel", billboardGui)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = CONFIG.ESP_COLOR
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    espObjects[targetPlayer] = {highlight = highlight, billboard = billboardGui, label = textLabel}
    local updateConnection
    updateConnection = RunService.RenderStepped:Connect(function()
        if not state.esp or not targetPlayer.Character or not rootPart then
            updateConnection:Disconnect()
            return
        end
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and CONFIG.ESP_SHOW_DISTANCE then
            local distance = (rootPart.Position - targetRoot.Position).Magnitude
            textLabel.Text = targetPlayer.Name .. "\n[" .. math.floor(distance) .. " studs]"
        else
            textLabel.Text = targetPlayer.Name
        end
    end)
end

local function removeESP(targetPlayer)
    if espObjects[targetPlayer] then
        pcall(function()
            if espObjects[targetPlayer].highlight then espObjects[targetPlayer].highlight:Destroy() end
            if espObjects[targetPlayer].billboard then espObjects[targetPlayer].billboard:Destroy() end
        end)
        espObjects[targetPlayer] = nil
    end
end

local function updateESP()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            if state.esp then createESP(otherPlayer) else removeESP(otherPlayer) end
        end
    end
end

local function updateNoClip()
    if not state.noclip or not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end

local function updateSpeed()
    if humanoid then
        if state.speed then
            local targetSpeed = CONFIG.SPEED_VALUE
            humanoid.WalkSpeed = AntiDetection:SmoothTransition(targetSpeed, humanoid.WalkSpeed, 0.1, CONFIG.STEALTH_MODE)
        else
            humanoid.WalkSpeed = originalSpeed
        end
    end
end

local function saveOriginalLighting()
    originalLightingSettings = {
        Ambient = Lighting.Ambient, Brightness = Lighting.Brightness,
        ColorShift_Bottom = Lighting.ColorShift_Bottom, ColorShift_Top = Lighting.ColorShift_Top,
        OutdoorAmbient = Lighting.OutdoorAmbient, ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows,
    }
end

local function enableFullBright()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.ClockTime = 12
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
end

local function disableFullBright()
    for setting, value in pairs(originalLightingSettings) do
        pcall(function() Lighting[setting] = value end)
    end
end

local function updateGodMode()
    if state.godmode then
        if humanoid then
            if connections.godmode then connections.godmode:Disconnect() end
            connections.godmode = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end
            end)
            humanoid.Health = humanoid.MaxHealth
        end
    else
        if connections.godmode then connections.godmode:Disconnect(); connections.godmode = nil end
    end
end

local function stopTeleportTween()
    if currentTeleportTween then
        currentTeleportTween:Cancel()
        currentTeleportTween = nil
    end
    isTeleporting = false
    isAutoObby = false
    state.autoObby = false
    updateButtonVisual("autoObby")
    showNotification("Teleport stopped", 2)
end

local function teleportToPlayer()
    if isTeleporting then return end
    if not selectedTeleportPlayer or not selectedTeleportPlayer.Character then
        showNotification("No player selected!", 2)
        return
    end
    local targetRoot = selectedTeleportPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not rootPart then
        showNotification("Target unavailable!", 2)
        return
    end
    isTeleporting = true
    showNotification("Teleporting to " .. selectedTeleportPlayer.Name, 3)
    local targetCFrame = targetRoot.CFrame * CFrame.new(0, 3, 3)
    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local duration = distance / CONFIG.TELEPORT_SPEED
    currentTeleportTween = TweenService:Create(rootPart, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {CFrame = targetCFrame})
    currentTeleportTween:Play()
    currentTeleportTween.Completed:Connect(function(playbackState)
        if playbackState == Enum.PlaybackState.Completed then showNotification("Teleport complete!", 2) end
        isTeleporting = false
        currentTeleportTween = nil
    end)
end

local function updateButtonVisual(stateName)
    if guiButtons[stateName] and not guiButtons[stateName].isAction then
        local btn = guiButtons[stateName]
        local isEnabled = state[stateName]
        local currentTheme = Theme:GetTheme()
        TweenService:Create(btn.indicator, TweenInfo.new(0.3), {BackgroundColor3 = isEnabled and currentTheme.Colors.StatusOn or currentTheme.Colors.StatusOff}):Play()
        TweenService:Create(btn.container, TweenInfo.new(0.3), {BackgroundColor3 = isEnabled and currentTheme.Colors.ContainerOn or currentTheme.Colors.ContainerOff}):Play()
    end
end

local function toggleAimbot() state.aimbot = not state.aimbot updateButtonVisual("aimbot") showNotification("Aimbot " .. (state.aimbot and "ON" or "OFF"), 2) end
local function toggleESP() state.esp = not state.esp updateESP() updateButtonVisual("esp") showNotification("ESP " .. (state.esp and "ON" or "OFF"), 2) end
local function toggleKillAura() state.killaura = not state.killaura if state.killaura then showNotification("Kill Aura ON", 2) if connections.killaura then connections.killaura:Disconnect() end local lastHit = tick() connections.killaura = RunService.Heartbeat:Connect(function() if tick() - lastHit >= CONFIG.KILLAURA_DELAY then performKillAura() lastHit = tick() end end) else if connections.killaura then connections.killaura:Disconnect() connections.killaura = nil end showNotification("Kill Aura OFF", 2) end updateButtonVisual("killaura") end
local function toggleFastM1() state.fastm1 = not state.fastm1 if state.fastm1 then if connections.fastm1 then connections.fastm1:Disconnect() end local lastClick = tick() connections.fastm1 = RunService.Heartbeat:Connect(function() if tick() - lastClick >= CONFIG.FASTM1_DELAY then performFastM1() lastClick = tick() end end) showNotification("Fast M1 ON", 2) else if connections.fastm1 then connections.fastm1:Disconnect() connections.fastm1 = nil end showNotification("Fast M1 OFF", 2) end updateButtonVisual("fastm1") end
local function toggleFly() state.fly = not state.fly if state.fly then if connections.flyBodyVelocity then connections.flyBodyVelocity:Destroy() end connections.flyBodyVelocity = Instance.new("BodyVelocity") connections.flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge) connections.flyBodyVelocity.Velocity = Vector3.new(0, 0, 0) connections.flyBodyVelocity.Parent = rootPart if connections.fly then connections.fly:Disconnect() end connections.fly = RunService.Heartbeat:Connect(updateFly) showNotification("Fly ON", 3) else if connections.fly then connections.fly:Disconnect() connections.fly = nil end if connections.flyBodyVelocity then connections.flyBodyVelocity:Destroy() connections.flyBodyVelocity = nil end showNotification("Fly OFF", 2) end updateButtonVisual("fly") end
local function toggleNoClip() state.noclip = not state.noclip updateButtonVisual("noclip") showNotification("NoClip " .. (state.noclip and "ON" or "OFF"), 2) end
local function toggleInfJump() state.infjump = not state.infjump updateButtonVisual("infjump") showNotification("Infinite Jump " .. (state.infjump and "ON" or "OFF"), 2) end
local function toggleSpeed() state.speed = not state.speed updateSpeed() updateButtonVisual("speed") showNotification("Speed " .. (state.speed and "ON - " .. CONFIG.SPEED_VALUE or "OFF"), 2) end
local function toggleFullBright() state.fullbright = not state.fullbright if state.fullbright then enableFullBright() else disableFullBright() end updateButtonVisual("fullbright") showNotification("Full Bright " .. (state.fullbright and "ON" or "OFF"), 2) end
local function toggleGodMode() state.godmode = not state.godmode updateGodMode() updateButtonVisual("godmode") showNotification("God Mode " .. (state.godmode and "ON" or "OFF"), 2) end
local function toggleWalkOnWater() state.walkonwater = not state.walkonwater if state.walkonwater then if connections.walkonwater then connections.walkonwater:Disconnect() end connections.walkonwater = RunService.Heartbeat:Connect(updateWalkOnWater) showNotification("Walk on Water ON", 2) else if connections.walkonwater then connections.walkonwater:Disconnect() connections.walkonwater = nil end if waterPlatform then waterPlatform:Destroy() waterPlatform = nil end showNotification("Walk on Water OFF", 2) end updateButtonVisual("walkonwater") end

local function toggleAutoObby()
    state.autoObby = not state.autoObby
    isAutoObby = state.autoObby
    updateButtonVisual("autoObby")
    
    if isAutoObby then
        showNotification("Auto-Obby: Starting...", 2)
        task.spawn(autoCompleteObby)
    else
        if currentTeleportTween then
            currentTeleportTween:Cancel()
            currentTeleportTween = nil
        end
        showNotification("Auto-Obby: Stopped", 2)
    end
end

local function connectButtons()
    task.wait(0.1)
    local buttonMap = {aimbot = toggleAimbot, esp = toggleESP, killaura = toggleKillAura, fastm1 = toggleFastM1, fly = toggleFly, noclip = toggleNoClip, infjump = toggleInfJump, speed = toggleSpeed, fullbright = toggleFullBright, godmode = toggleGodMode, teleport = teleportToPlayer, autoObby = toggleAutoObby, walkonwater = toggleWalkOnWater}
    for stateName, toggleFunc in pairs(buttonMap) do
        if guiButtons[stateName] and guiButtons[stateName].button then
            guiButtons[stateName].button.MouseButton1Click:Connect(toggleFunc)
            if stateName == "speed" and guiButtons[stateName].input then
                guiButtons[stateName].input.FocusLost:Connect(function()
                    local value = tonumber(guiButtons[stateName].input.Text)
                    if value then
                        if value < CONFIG.MIN_SPEED then value = CONFIG.MIN_SPEED end
                        if value > CONFIG.MAX_SPEED then value = CONFIG.MAX_SPEED end
                        CONFIG.SPEED_VALUE = value
                        guiButtons[stateName].input.Text = tostring(value)
                        if state.speed then updateSpeed() end
                        showNotification("Speed set to " .. value, 2)
                    else
                        guiButtons[stateName].input.Text = tostring(CONFIG.SPEED_VALUE)
                    end
                end)
            end
            if stateName == "teleport" and guiButtons[stateName].dropdown then
                updatePlayerDropdown(guiButtons[stateName].dropdown)
                Players.PlayerAdded:Connect(function()
                    task.wait(0.5)
                    updatePlayerDropdown(guiButtons[stateName].dropdown)
                end)
                Players.PlayerRemoving:Connect(function()
                    updatePlayerDropdown(guiButtons[stateName].dropdown)
                end)
            end
        end
    end
    if guiButtons["stop_tween"] and guiButtons["stop_tween"].stopBtn then
        guiButtons["stop_tween"].stopBtn.MouseButton1Click:Connect(stopTeleportTween)
    end
end

local mainFrame, closeBtn, sidebar, contentFrame, pageTitleRef, actionScrollRef, screenGui = createModernGUI()
mainFrameRef = mainFrame contentScroll = actionScrollRef pageTitle = pageTitleRef screenGuiRef = screenGui
local toggleBtn = createToggleButton(screenGui)
local closePrompt, minimizeBtn, destroyBtn = createClosePrompt(screenGui)
closeBtn.MouseButton1Click:Connect(function() closePrompt.Visible = true end)
minimizeBtn.MouseButton1Click:Connect(function() closePrompt.Visible = false guiVisible = false TweenService:Create(mainFrameRef, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -Theme.Sizes.MainFrameWidth/2, -1, 0)}):Play() end)
destroyBtn.MouseButton1Click:Connect(function() screenGui:Destroy() for _, conn in pairs(connections) do if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() elseif typeof(conn) == "Instance" then conn:Destroy() end end end)

local tabs = {{name = "Combat", icon = "⚔️"}, {name = "Movement", icon = "🏃"}, {name = "Visual", icon = "👁️"}, {name = "Teleport", icon = "📍"}, {name = "Themes", icon = "🎨"}}
local tabButtons = {}
for i, tab in ipairs(tabs) do local tabBtn = createTabButton(sidebar, tab.name, tab.icon, i) tabButtons[tab.name] = tabBtn tabBtn.MouseButton1Click:Connect(function() for _, otherTab in pairs(tabButtons) do otherTab.BackgroundColor3 = Theme:GetTheme().Colors.TabNormal end tabBtn.BackgroundColor3 = Theme:GetTheme().Colors.TabSelected updateContentPage(tab.name) connectButtons() end) end
if tabButtons["Combat"] then tabButtons["Combat"].BackgroundColor3 = Theme:GetTheme().Colors.TabSelected end
updateContentPage("Combat") connectButtons()

UserInputService.InputBegan:Connect(function(input, gameProcessed) if gameProcessed then return end if input.KeyCode == CONFIG.GUI_TOGGLE_KEY then local targetPos = guiVisible and UDim2.new(0.5, -Theme.Sizes.MainFrameWidth/2, -1, 0) or UDim2.new(0.5, -Theme.Sizes.MainFrameWidth/2, 0.5, -Theme.Sizes.MainFrameHeight/2) guiVisible = not guiVisible TweenService:Create(mainFrameRef, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = targetPos}):Play() return end local keyMap = {[CONFIG.AIMBOT_KEY] = toggleAimbot, [CONFIG.ESP_KEY] = toggleESP, [CONFIG.KILLAURA_KEY] = toggleKillAura, [CONFIG.FASTM1_KEY] = toggleFastM1, [CONFIG.FLY_KEY] = toggleFly, [CONFIG.NOCLIP_KEY] = toggleNoClip, [CONFIG.INFJUMP_KEY] = toggleInfJump, [CONFIG.SPEED_KEY] = toggleSpeed, [CONFIG.FULLBRIGHT_KEY] = toggleFullBright, [CONFIG.GODMODE_KEY] = toggleGodMode, [CONFIG.TELEPORT_KEY] = teleportToPlayer, [CONFIG.WALKONWATER_KEY] = toggleWalkOnWater} local action = keyMap[input.KeyCode] if action then action() elseif input.KeyCode == Enum.KeyCode.Space and state.infjump and not state.fly and humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)

RunService.RenderStepped:Connect(function() if state.aimbot then local target = getClosestPlayerForAimbot() if target then aimAtTarget(target) end end if state.noclip then updateNoClip() end if state.speed then updateSpeed() end end)

Players.PlayerAdded:Connect(function(newPlayer) newPlayer.CharacterAdded:Connect(function() task.wait(1) if state.esp then createESP(newPlayer) end end) end)
Players.PlayerRemoving:Connect(function(removedPlayer) removeESP(removedPlayer) if selectedTeleportPlayer == removedPlayer then selectedTeleportPlayer = nil end end)

player.CharacterAdded:Connect(function(newChar) character = newChar humanoid = character:WaitForChild("Humanoid") rootPart = character:WaitForChild("HumanoidRootPart") task.wait(0.2) originalSpeed = humanoid.WalkSpeed if state.speed then updateSpeed() end if state.godmode then updateGodMode() end if state.esp then task.wait(0.5) updateESP() end if state.fly then toggleFly() toggleFly() end if state.walkonwater then toggleWalkOnWater() toggleWalkOnWater() end if isAutoObby then isAutoObby = false state.autoObby = false updateButtonVisual("autoObby") end end)

saveOriginalLighting() originalSpeed = humanoid.WalkSpeed
showNotification("🛡️ NullHub V3 Protected - Loaded!", 3)
print("========================================")
print("⚡ NullHub V3 - WITH AUTO-OBBY SYSTEM ⚡")
print("✅ Anti-Detection Module Active")
print("✅ Theme Module Active")
print("✅ All Features Active")
print("✅ Auto-Obby System Active")
print("✅ Obstacle Avoidance Active")
print("✅ Speed: 500k (1M in 2s)")
print("========================================")
