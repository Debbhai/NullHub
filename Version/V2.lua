-- NullHub V2.lua - FULLY FIXED & WORKING
-- Created by Debbhai

-- ============================================
-- COMPLETE THEME FALLBACK (NO NIL VALUES)
-- ============================================
local Theme = {
    -- Colors (Complete, no nil values)
    Colors = {
        MainBackground = Color3.fromRGB(15, 15, 20),
        HeaderBackground = Color3.fromRGB(20, 20, 28),
        SidebarBackground = Color3.fromRGB(18, 18, 22),
        ContainerBackground = Color3.fromRGB(25, 25, 35),
        InputBackground = Color3.fromRGB(35, 35, 45),
        DropdownBackground = Color3.fromRGB(35, 35, 45),
        PlayerButtonBg = Color3.fromRGB(45, 45, 55),
        TabNormal = Color3.fromRGB(25, 25, 30),
        TabSelected = Color3.fromRGB(35, 35, 45),
        AccentBar = Color3.fromRGB(255, 215, 0),
        ScrollBarColor = Color3.fromRGB(218, 165, 32),
        StatusOff = Color3.fromRGB(200, 50, 50),
        StatusOn = Color3.fromRGB(218, 165, 32),
        ContainerOff = Color3.fromRGB(25, 25, 35),
        ContainerOn = Color3.fromRGB(30, 35, 50),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 180),
        TextPlaceholder = Color3.fromRGB(150, 150, 150),
        BorderColor = Color3.fromRGB(60, 60, 80),
        CloseButton = Color3.fromRGB(200, 50, 60),
    },
    -- Transparency (Complete)
    Transparency = {
        MainBackground = 0.15,
        Header = 0.2,
        Sidebar = 0.2,
        Container = 0.3,
        Input = 0.3,
        Dropdown = 0.3,
        PlayerButton = 0.4,
        CloseButton = 0.2,
        Stroke = 0.6,
        AccentBar = 0.3,
        StatusIndicator = 0.2,
        ScrollBar = 0.5,
        Tab = 0.3,
    },
    -- Sizes (Complete)
    Sizes = {
        MainFrameWidth = 650,
        MainFrameHeight = 420,
        SidebarWidth = 140,
        HeaderHeight = 40,
        CloseButton = 35,
        TabHeight = 36,
        ActionRowHeight = 40,
        StatusIndicator = 10,
        InputHeight = 42,
        DropdownHeight = 58,
        PlayerButtonHeight = 26,
        ScrollBarThickness = 4,
    },
    -- CornerRadius (Complete)
    CornerRadius = {
        Large = 12,
        Medium = 8,
        Small = 6,
        Tiny = 4,
    },
    -- Fonts (Complete)
    Fonts = {
        Title = Enum.Font.GothamBold,
        Tab = Enum.Font.Gotham,
        Action = Enum.Font.Gotham,
        Input = Enum.Font.Gotham,
    },
    -- FontSizes (Complete)
    FontSizes = {
        Title = 18,
        Tab = 14,
        Action = 14,
        Input = 14,
    },
}

-- Try to load external theme (optional)
pcall(function()
    local externalTheme = loadstring(game:HttpGet("https://raw.githubusercontent.com/Debbhai/NullHub/main/Theme.lua"))()
    if externalTheme and externalTheme.Colors then
        for k, v in pairs(externalTheme.Colors) do
            Theme.Colors[k] = Theme.Colors[k] or v
        end
        for k, v in pairs(externalTheme.Transparency) do
            Theme.Transparency[k] = Theme.Transparency[k] or v
        end
        print("[NullHub] ✅ External theme loaded!")
    end
end)

print("[NullHub] ✅ Theme initialized successfully!")

-- Services
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
    -- Combat
    AIMBOT_KEY = Enum.KeyCode.E,
    AIMBOT_FOV = 200,
    AIMBOT_SMOOTHNESS = 0.2,
    ESP_KEY = Enum.KeyCode.T,
    ESP_COLOR = Color3.fromRGB(255, 0, 0),
    ESP_SHOW_DISTANCE = true,
    KILLAURA_KEY = Enum.KeyCode.K,
    KILLAURA_RANGE = 20,
    KILLAURA_DELAY = 0.15,
    FASTM1_KEY = Enum.KeyCode.M,
    FASTM1_DELAY = 0.05,
    
    -- Movement
    FLY_KEY = Enum.KeyCode.F,
    FLY_SPEED = 50,
    NOCLIP_KEY = Enum.KeyCode.N,
    INFJUMP_KEY = Enum.KeyCode.J,
    SPEED_KEY = Enum.KeyCode.X,
    SPEED_VALUE = 100,
    MIN_SPEED = 1,
    MAX_SPEED = 500,
    
    -- Visual
    FULLBRIGHT_KEY = Enum.KeyCode.B,
    GODMODE_KEY = Enum.KeyCode.V,
    
    -- Teleport
    TELEPORT_KEY = Enum.KeyCode.Z,
    TELEPORT_SPEED = 80,
    
    -- GUI Toggle
    GUI_TOGGLE_KEY = Enum.KeyCode.Insert,
}

-- ============================================
-- STATE
-- ============================================
local state = {
    aimbot = false,
    esp = false,
    noclip = false,
    infjump = false,
    speed = false,
    fullbright = false,
    godmode = false,
    killaura = false,
    fastm1 = false,
    fly = false,
}

local espObjects = {}
local originalSpeed = 16
local originalLightingSettings = {}
local connections = {}
local selectedTeleportPlayer = nil
local isTeleporting = false

local guiVisible = true
local mainFrameRef = nil
local guiButtons = {}
local contentScroll, pageTitle

-- ============================================
-- GUI CREATION
-- ============================================
local function createSidebarGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NullHubGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, Theme.Sizes.MainFrameWidth, 0, Theme.Sizes.MainFrameHeight)
    mainFrame.Position = UDim2.new(0.5, -Theme.Sizes.MainFrameWidth/2, 0.5, -Theme.Sizes.MainFrameHeight/2)
    mainFrame.BackgroundColor3 = Theme.Colors.MainBackground
    mainFrame.BackgroundTransparency = Theme.Transparency.MainBackground
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, Theme.CornerRadius.Large)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.Colors.BorderColor
    mainStroke.Thickness = 1
    mainStroke.Transparency = Theme.Transparency.Stroke
    mainStroke.Parent = mainFrame
    
    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, Theme.Sizes.HeaderHeight)
    topBar.BackgroundColor3 = Theme.Colors.HeaderBackground
    topBar.BackgroundTransparency = Theme.Transparency.Header
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, Theme.CornerRadius.Large)
    topCorner.Parent = topBar
    
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 1)
    accentLine.Position = UDim2.new(0, 0, 1, -1)
    accentLine.BackgroundColor3 = Theme.Colors.AccentBar
    accentLine.BackgroundTransparency = Theme.Transparency.AccentBar
    accentLine.BorderSizePixel = 0
    accentLine.Parent = topBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "NullHub V2 [Insert]"
    title.TextColor3 = Theme.Colors.TextPrimary
    title.TextSize = Theme.FontSizes.Title
    title.Font = Theme.Fonts.Title
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, Theme.Sizes.CloseButton, 0, Theme.Sizes.CloseButton)
    closeBtn.Position = UDim2.new(1, -Theme.Sizes.CloseButton - 5, 0, 2.5)
    closeBtn.BackgroundColor3 = Theme.Colors.CloseButton
    closeBtn.BackgroundTransparency = Theme.Transparency.CloseButton
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.Colors.TextPrimary
    closeBtn.TextSize = 24
    closeBtn.Font = Theme.Fonts.Title
    closeBtn.Parent = topBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
    closeBtnCorner.Parent = closeBtn
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - 5)
    sidebar.Position = UDim2.new(0, 5, 0, Theme.Sizes.HeaderHeight + 5)
    sidebar.BackgroundColor3 = Theme.Colors.SidebarBackground
    sidebar.BackgroundTransparency = Theme.Transparency.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
    sidebarCorner.Parent = sidebar
    
    local sidebarStroke = Instance.new("UIStroke")
    sidebarStroke.Color = Theme.Colors.BorderColor
    sidebarStroke.Thickness = 1
    sidebarStroke.Transparency = Theme.Transparency.Stroke
    sidebarStroke.Parent = sidebar
    
    local sidebarList = Instance.new("UIListLayout")
    sidebarList.Padding = UDim.new(0, 4)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 6)
    sidebarPadding.PaddingLeft = UDim.new(0, 6)
    sidebarPadding.PaddingRight = UDim.new(0, 6)
    sidebarPadding.PaddingBottom = UDim.new(0, 6)
    sidebarPadding.Parent = sidebar
    
    -- Content Area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -Theme.Sizes.SidebarWidth - 15, 1, -Theme.Sizes.HeaderHeight - 10)
    contentFrame.Position = UDim2.new(0, Theme.Sizes.SidebarWidth + 10, 0, Theme.Sizes.HeaderHeight + 5)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    local pageTitleLabel = Instance.new("TextLabel")
    pageTitleLabel.Name = "PageTitle"
    pageTitleLabel.Size = UDim2.new(1, 0, 0, 30)
    pageTitleLabel.BackgroundTransparency = 1
    pageTitleLabel.Text = "Combat"
    pageTitleLabel.TextColor3 = Theme.Colors.TextPrimary
    pageTitleLabel.TextSize = Theme.FontSizes.Title
    pageTitleLabel.Font = Theme.Fonts.Title
    pageTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    pageTitleLabel.Parent = contentFrame
    
    local actionScroll = Instance.new("ScrollingFrame")
    actionScroll.Name = "ActionScroll"
    actionScroll.Size = UDim2.new(1, 0, 1, -35)
    actionScroll.Position = UDim2.new(0, 0, 0, 35)
    actionScroll.BackgroundTransparency = 1
    actionScroll.BorderSizePixel = 0
    actionScroll.ScrollBarThickness = Theme.Sizes.ScrollBarThickness
    actionScroll.ScrollBarImageColor3 = Theme.Colors.ScrollBarColor
    actionScroll.ScrollBarImageTransparency = Theme.Transparency.ScrollBar
    actionScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    actionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    actionScroll.Parent = contentFrame
    
    local actionList = Instance.new("UIListLayout")
    actionList.Padding = UDim.new(0, 4)
    actionList.SortOrder = Enum.SortOrder.LayoutOrder
    actionList.Parent = actionScroll
    
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    return mainFrame, closeBtn, sidebar, contentFrame, pageTitleLabel, actionScroll
end

-- ============================================
-- CREATE TAB
-- ============================================
local function createTabButton(parent, tabName, icon, index)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. tabName
    tabBtn.Size = UDim2.new(1, 0, 0, Theme.Sizes.TabHeight)
    tabBtn.BackgroundColor3 = Theme.Colors.TabNormal
    tabBtn.BackgroundTransparency = Theme.Transparency.Tab
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = "  " .. icon .. "  " .. tabName
    tabBtn.TextColor3 = Theme.Colors.TextPrimary
    tabBtn.TextSize = Theme.FontSizes.Tab
    tabBtn.Font = Theme.Fonts.Tab
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.LayoutOrder = index
    tabBtn.Parent = parent
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    tabCorner.Parent = tabBtn
    
    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = Theme.Colors.BorderColor
    tabStroke.Thickness = 1
    tabStroke.Transparency = 0.8
    tabStroke.Parent = tabBtn
    
    return tabBtn
end

-- ============================================
-- CREATE ACTION ROW
-- ============================================
local function createActionRow(parent, actionData, index)
    local actionFrame = Instance.new("Frame")
    actionFrame.Name = actionData.name .. "Row"
    actionFrame.Size = UDim2.new(1, 0, 0, Theme.Sizes.ActionRowHeight)
    actionFrame.BackgroundColor3 = Theme.Colors.ContainerBackground
    actionFrame.BackgroundTransparency = Theme.Transparency.Container
    actionFrame.BorderSizePixel = 0
    actionFrame.LayoutOrder = index
    actionFrame.Parent = parent
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    rowCorner.Parent = actionFrame
    
    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = Theme.Colors.BorderColor
    rowStroke.Thickness = 1
    rowStroke.Transparency = Theme.Transparency.Stroke
    rowStroke.Parent = actionFrame
    
    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = actionData.state .. "Btn"
    actionBtn.Size = UDim2.new(1, 0, 1, 0)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Text = ""
    actionBtn.Parent = actionFrame
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = actionData.icon
    icon.TextSize = 18
    icon.Parent = actionFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -70, 1, 0)
    nameLabel.Position = UDim2.new(0, 35, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = actionData.name .. " [" .. actionData.key .. "]"
    nameLabel.TextColor3 = Theme.Colors.TextPrimary
    nameLabel.TextSize = Theme.FontSizes.Action
    nameLabel.Font = Theme.Fonts.Action
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = actionFrame
    
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, Theme.Sizes.StatusIndicator, 0, Theme.Sizes.StatusIndicator)
    statusIndicator.Position = UDim2.new(1, -20, 0.5, -Theme.Sizes.StatusIndicator/2)
    statusIndicator.BackgroundColor3 = Theme.Colors.StatusOff
    statusIndicator.BackgroundTransparency = Theme.Transparency.StatusIndicator
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = actionFrame
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = statusIndicator
    
    if actionData.hasInput then
        actionFrame.Size = UDim2.new(1, 0, 0, Theme.Sizes.ActionRowHeight + Theme.Sizes.InputHeight + 8)
        
        local speedInput = Instance.new("TextBox")
        speedInput.Name = "SpeedInput"
        speedInput.Size = UDim2.new(1, -10, 0, Theme.Sizes.InputHeight)
        speedInput.Position = UDim2.new(0, 5, 0, Theme.Sizes.ActionRowHeight + 4)
        speedInput.BackgroundColor3 = Theme.Colors.InputBackground
        speedInput.BackgroundTransparency = Theme.Transparency.Input
        speedInput.BorderSizePixel = 0
        speedInput.Text = tostring(CONFIG.SPEED_VALUE)
        speedInput.PlaceholderText = "Enter speed (1-500)"
        speedInput.TextColor3 = Theme.Colors.TextPrimary
        speedInput.PlaceholderColor3 = Theme.Colors.TextPlaceholder
        speedInput.TextSize = Theme.FontSizes.Input
        speedInput.Font = Theme.Fonts.Input
        speedInput.ClearTextOnFocus = false
        speedInput.Parent = actionFrame
        
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, Theme.CornerRadius.Tiny)
        inputCorner.Parent = speedInput
        
        return actionFrame, actionBtn, statusIndicator, speedInput
    end
    
    if actionData.hasDropdown then
        actionFrame.Size = UDim2.new(1, 0, 0, Theme.Sizes.ActionRowHeight + Theme.Sizes.DropdownHeight + 8)
        
        local dropdown = Instance.new("ScrollingFrame")
        dropdown.Name = "PlayerDropdown"
        dropdown.Size = UDim2.new(1, -10, 0, Theme.Sizes.DropdownHeight)
        dropdown.Position = UDim2.new(0, 5, 0, Theme.Sizes.ActionRowHeight + 4)
        dropdown.BackgroundColor3 = Theme.Colors.DropdownBackground
        dropdown.BackgroundTransparency = Theme.Transparency.Dropdown
        dropdown.BorderSizePixel = 0
        dropdown.ScrollBarThickness = 3
        dropdown.ScrollBarImageColor3 = Theme.Colors.ScrollBarColor
        dropdown.ScrollBarImageTransparency = Theme.Transparency.ScrollBar
        dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
        dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
        dropdown.Parent = actionFrame
        
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, Theme.CornerRadius.Tiny)
        dropCorner.Parent = dropdown
        
        local placeholderLabel = Instance.new("TextLabel")
        placeholderLabel.Name = "PlaceholderText"
        placeholderLabel.Size = UDim2.new(1, 0, 1, 0)
        placeholderLabel.BackgroundTransparency = 1
        placeholderLabel.Text = "Select a player..."
        placeholderLabel.TextColor3 = Theme.Colors.TextPlaceholder
        placeholderLabel.TextSize = Theme.FontSizes.Input
        placeholderLabel.Font = Theme.Fonts.Input
        placeholderLabel.Parent = dropdown
        
        return actionFrame, actionBtn, statusIndicator, nil, dropdown, placeholderLabel
    end
    
    return actionFrame, actionBtn, statusIndicator
end

-- ============================================
-- FEATURES BY TAB
-- ============================================
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
    },
    Visual = {
        {name = "Full Bright", key = "B", state = "fullbright", icon = "💡"},
        {name = "God Mode", key = "V", state = "godmode", icon = "🛡️"},
    },
    Teleport = {
        {name = "Teleport To Player", key = "Z", state = "teleport", icon = "🚀", isAction = true, hasDropdown = true},
    },
}

-- ============================================
-- UPDATE CONTENT PAGE
-- ============================================
local function updateContentPage(tabName)
    if not contentScroll then return end
    
    for _, child in pairs(contentScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if pageTitle then
        pageTitle.Text = tabName
    end
    
    local features = featuresByTab[tabName] or {}
    for i, feature in ipairs(features) do
        local frame, btn, indicator, input, dropdown, placeholder = createActionRow(contentScroll, feature, i)
        
        guiButtons[feature.state] = {
            button = btn,
            indicator = indicator,
            container = frame,
            isAction = feature.isAction or false,
            input = input,
            dropdown = dropdown,
            placeholder = placeholder
        }
    end
end

-- ============================================
-- PLAYER DROPDOWN
-- ============================================
local function updatePlayerDropdown(dropdown)
    if not dropdown then return end
    
    for _, child in pairs(dropdown:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.Name
    layout.Parent = dropdown
    
    local hasPlayers = false
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            hasPlayers = true
            
            local playerBtn = Instance.new("TextButton")
            playerBtn.Name = otherPlayer.Name
            playerBtn.Size = UDim2.new(1, -4, 0, Theme.Sizes.PlayerButtonHeight)
            playerBtn.BackgroundColor3 = Theme.Colors.PlayerButtonBg
            playerBtn.BackgroundTransparency = Theme.Transparency.PlayerButton
            playerBtn.BorderSizePixel = 0
            playerBtn.Text = otherPlayer.Name
            playerBtn.TextColor3 = Theme.Colors.TextPrimary
            playerBtn.TextSize = Theme.FontSizes.Input
            playerBtn.Font = Theme.Fonts.Input
            playerBtn.Parent = dropdown
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, Theme.CornerRadius.Tiny)
            btnCorner.Parent = playerBtn
            
            playerBtn.MouseButton1Click:Connect(function()
                selectedTeleportPlayer = otherPlayer
                print("[NullHub] Selected player:", otherPlayer.Name)
                
                for _, btn in pairs(dropdown:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundTransparency = Theme.Transparency.PlayerButton
                    end
                end
                playerBtn.BackgroundTransparency = 0.2
            end)
            
            playerBtn.MouseEnter:Connect(function()
                if playerBtn.BackgroundTransparency > 0.2 then
                    TweenService:Create(playerBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
                end
            end)
            
            playerBtn.MouseLeave:Connect(function()
                if selectedTeleportPlayer ~= otherPlayer then
                    TweenService:Create(playerBtn, TweenInfo.new(0.2), {BackgroundTransparency = Theme.Transparency.PlayerButton}):Play()
                end
            end)
        end
    end
    
    local placeholder = dropdown:FindFirstChild("PlaceholderText")
    if placeholder then
        placeholder.Visible = not hasPlayers
    end
end

-- ============================================
-- FEATURE FUNCTIONS
-- ============================================
local function getClosestPlayer(range, checkMouse)
    local closestPlayer = nil
    local shortestDistance = range or math.huge
    local mousePos = checkMouse and UserInputService:GetMouseLocation()
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            local target = checkMouse and otherPlayer.Character:FindFirstChild("Head") or otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if otherHumanoid and target and otherHumanoid.Health > 0 then
                local distance
                
                if checkMouse then
                    local screenPos, onScreen = camera:WorldToScreenPoint(target.Position)
                    if onScreen then
                        distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    end
                else
                    if rootPart then
                        distance = (rootPart.Position - target.Position).Magnitude
                    end
                end
                
                if distance and distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = otherPlayer
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
    
    local targetPos = targetHead.Position
    local cameraPos = camera.CFrame.Position
    local newCFrame = CFrame.new(cameraPos, targetPos)
    camera.CFrame = camera.CFrame:Lerp(newCFrame, CONFIG.AIMBOT_SMOOTHNESS)
end

local function performKillAura()
    if not state.killaura or not character or not humanoid then return end
    
    local target = getClosestPlayer(CONFIG.KILLAURA_RANGE)
    if target and target.Character then
        local targetHumanoid = target.Character:FindFirstChild("Humanoid")
        if targetHumanoid and targetHumanoid.Health > 0 then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                for _, descendant in pairs(tool:GetDescendants()) do
                    if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                        pcall(function()
                            if descendant:IsA("RemoteEvent") then
                                descendant:FireServer()
                            else
                                descendant:InvokeServer()
                            end
                        end)
                    end
                end
            elseif humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Attacking)
            end
        end
    end
end

local function performFastM1()
    if not state.fastm1 then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        
        for _, descendant in pairs(tool:GetDescendants()) do
            if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                pcall(function()
                    if descendant:IsA("RemoteEvent") then
                        descendant:FireServer()
                    else
                        descendant:InvokeServer()
                    end
                end)
            end
        end
    end
end

local function updateFly()
    if not state.fly or not rootPart then return end
    
    local moveDirection = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + (camera.CFrame.LookVector * CONFIG.FLY_SPEED)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - (camera.CFrame.LookVector * CONFIG.FLY_SPEED)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - (camera.CFrame.RightVector * CONFIG.FLY_SPEED)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + (camera.CFrame.RightVector * CONFIG.FLY_SPEED)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, CONFIG.FLY_SPEED, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection - Vector3.new(0, CONFIG.FLY_SPEED, 0)
    end
    
    if connections.flyBodyVelocity then
        connections.flyBodyVelocity.Velocity = moveDirection
    end
    
    if connections.flyBodyGyro then
        connections.flyBodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
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
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = CONFIG.ESP_COLOR
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = billboardGui
    
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
        if espObjects[targetPlayer].highlight then
            pcall(function() espObjects[targetPlayer].highlight:Destroy() end)
        end
        if espObjects[targetPlayer].billboard then
            pcall(function() espObjects[targetPlayer].billboard:Destroy() end)
        end
        espObjects[targetPlayer] = nil
    end
end

local function updateESP()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            if state.esp then
                createESP(otherPlayer)
            else
                removeESP(otherPlayer)
            end
        end
    end
end

local function updateNoClip()
    if not state.noclip or not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function updateSpeed()
    if humanoid then
        humanoid.WalkSpeed = state.speed and CONFIG.SPEED_VALUE or originalSpeed
    end
end

local function saveOriginalLighting()
    originalLightingSettings = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
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
        pcall(function()
            Lighting[setting] = value
        end)
    end
end

local function updateGodMode()
    if state.godmode then
        if humanoid then
            if connections.godmode then
                connections.godmode:Disconnect()
            end
            connections.godmode = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
            humanoid.Health = humanoid.MaxHealth
        end
    else
        if connections.godmode then
            connections.godmode:Disconnect()
            connections.godmode = nil
        end
    end
end

local function teleportToPlayer()
    if isTeleporting then
        warn("[NullHub] Already teleporting!")
        return
    end
    
    if not selectedTeleportPlayer or not selectedTeleportPlayer.Character then
        warn("[NullHub] No player selected! Select from dropdown.")
        return
    end
    
    local targetRoot = selectedTeleportPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not rootPart then
        warn("[NullHub] Target unavailable!")
        return
    end
    
    isTeleporting = true
    print("[NullHub] Teleporting to:", selectedTeleportPlayer.Name)
    
    local targetCFrame = targetRoot.CFrame * CFrame.new(0, 3, 3)
    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local duration = distance / CONFIG.TELEPORT_SPEED
    
    local tween = TweenService:Create(rootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    
    tween:Play()
    tween.Completed:Connect(function()
        isTeleporting = false
        print("[NullHub] Teleport complete!")
    end)
end

-- ============================================
-- TOGGLE FUNCTIONS
-- ============================================
local function updateButtonVisual(stateName)
    if guiButtons[stateName] and not guiButtons[stateName].isAction then
        local btn = guiButtons[stateName]
        local isEnabled = state[stateName]
        
        TweenService:Create(btn.indicator, TweenInfo.new(0.3), {
            BackgroundColor3 = isEnabled and Theme.Colors.StatusOn or Theme.Colors.StatusOff
        }):Play()
        
        TweenService:Create(btn.container, TweenInfo.new(0.3), {
            BackgroundColor3 = isEnabled and Theme.Colors.ContainerOn or Theme.Colors.ContainerOff
        }):Play()
    end
end

local function toggleAimbot()
    state.aimbot = not state.aimbot
    updateButtonVisual("aimbot")
    print("[NullHub] Aimbot:", state.aimbot and "ON" or "OFF")
end

local function toggleESP()
    state.esp = not state.esp
    updateESP()
    updateButtonVisual("esp")
    print("[NullHub] ESP:", state.esp and "ON" or "OFF")
end

local function toggleKillAura()
    state.killaura = not state.killaura
    
    if state.killaura then
        if connections.killaura then
            connections.killaura:Disconnect()
        end
        
        local lastHit = tick()
        connections.killaura = RunService.Heartbeat:Connect(function()
            if tick() - lastHit >= CONFIG.KILLAURA_DELAY then
                performKillAura()
                lastHit = tick()
            end
        end)
    else
        if connections.killaura then
            connections.killaura:Disconnect()
            connections.killaura = nil
        end
    end
    
    updateButtonVisual("killaura")
    print("[NullHub] KillAura:", state.killaura and "ON" or "OFF")
end

local function toggleFastM1()
    state.fastm1 = not state.fastm1
    
    if state.fastm1 then
        if connections.fastm1 then
            connections.fastm1:Disconnect()
        end
        
        local lastClick = tick()
        connections.fastm1 = RunService.Heartbeat:Connect(function()
            if tick() - lastClick >= CONFIG.FASTM1_DELAY then
                performFastM1()
                lastClick = tick()
            end
        end)
    else
        if connections.fastm1 then
            connections.fastm1:Disconnect()
            connections.fastm1 = nil
        end
    end
    
    updateButtonVisual("fastm1")
    print("[NullHub] Fast M1:", state.fastm1 and "ON" or "OFF")
end

local function toggleFly()
    state.fly = not state.fly
    
    if state.fly then
        if not connections.flyBodyVelocity then
            connections.flyBodyVelocity = Instance.new("BodyVelocity")
            connections.flyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            connections.flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            connections.flyBodyVelocity.Parent = rootPart
        end
        
        if not connections.flyBodyGyro then
            connections.flyBodyGyro = Instance.new("BodyGyro")
            connections.flyBodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
            connections.flyBodyGyro.P = 10000
            connections.flyBodyGyro.Parent = rootPart
        end
        
        if connections.fly then
            connections.fly:Disconnect()
        end
        
        connections.fly = RunService.RenderStepped:Connect(updateFly)
        
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        end
    else
        if connections.fly then
            connections.fly:Disconnect()
            connections.fly = nil
        end
        
        if connections.flyBodyVelocity then
            connections.flyBodyVelocity:Destroy()
            connections.flyBodyVelocity = nil
        end
        
        if connections.flyBodyGyro then
            connections.flyBodyGyro:Destroy()
            connections.flyBodyGyro = nil
        end
        
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end
    
    updateButtonVisual("fly")
    print("[NullHub] Fly:", state.fly and "ON" or "OFF")
end

local function toggleNoClip()
    state.noclip = not state.noclip
    updateButtonVisual("noclip")
    print("[NullHub] NoClip:", state.noclip and "ON" or "OFF")
end

local function toggleInfJump()
    state.infjump = not state.infjump
    updateButtonVisual("infjump")
    print("[NullHub] Infinite Jump:", state.infjump and "ON" or "OFF")
end

local function toggleSpeed()
    state.speed = not state.speed
    updateSpeed()
    updateButtonVisual("speed")
    print("[NullHub] Speed:", state.speed and "ON" or "OFF", "- Value:", CONFIG.SPEED_VALUE)
end

local function toggleFullBright()
    state.fullbright = not state.fullbright
    if state.fullbright then
        enableFullBright()
    else
        disableFullBright()
    end
    updateButtonVisual("fullbright")
    print("[NullHub] Full Bright:", state.fullbright and "ON" or "OFF")
end

local function toggleGodMode()
    state.godmode = not state.godmode
    updateGodMode()
    updateButtonVisual("godmode")
    print("[NullHub] God Mode:", state.godmode and "ON" or "OFF")
end

local function toggleGUI()
    guiVisible = not guiVisible
    if mainFrameRef then
        mainFrameRef.Visible = guiVisible
    end
    print("[NullHub] GUI:", guiVisible and "VISIBLE" or "HIDDEN")
end

-- ============================================
-- CONNECT BUTTONS
-- ============================================
local function connectButtons()
    task.wait(0.1)
    
    local buttonMap = {
        aimbot = toggleAimbot,
        esp = toggleESP,
        killaura = toggleKillAura,
        fastm1 = toggleFastM1,
        fly = toggleFly,
        noclip = toggleNoClip,
        infjump = toggleInfJump,
        speed = toggleSpeed,
        fullbright = toggleFullBright,
        godmode = toggleGodMode,
        teleport = teleportToPlayer,
    }
    
    for stateName, toggleFunc in pairs(buttonMap) do
        if guiButtons[stateName] and guiButtons[stateName].button then
            guiButtons[stateName].button.MouseButton1Click:Connect(toggleFunc)
            
            if stateName == "speed" and guiButtons[stateName].input then
                guiButtons[stateName].input.FocusLost:Connect(function()
                    local value = tonumber(guiButtons[stateName].input.Text)
                    if value and value >= CONFIG.MIN_SPEED and value <= CONFIG.MAX_SPEED then
                        CONFIG.SPEED_VALUE = value
                        if state.speed then
                            updateSpeed()
                        end
                        print("[NullHub] Speed set to:", value)
                    else
                        guiButtons[stateName].input.Text = tostring(CONFIG.SPEED_VALUE)
                        warn("[NullHub] Invalid speed! Use 1-500")
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
end

-- ============================================
-- GUI INITIALIZATION
-- ============================================
local mainFrame, closeBtn, sidebar, contentFrame, pageTitleRef, actionScrollRef = createSidebarGUI()
mainFrameRef = mainFrame
contentScroll = actionScrollRef
pageTitle = pageTitleRef

local tabs = {
    {name = "Combat", icon = "⚔️"},
    {name = "Movement", icon = "🏃"},
    {name = "Visual", icon = "👁️"},
    {name = "Teleport", icon = "📍"},
}

local tabButtons = {}
for i, tab in ipairs(tabs) do
    local tabBtn = createTabButton(sidebar, tab.name, tab.icon, i)
    tabButtons[tab.name] = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(tabButtons) do
            otherTab.BackgroundColor3 = Theme.Colors.TabNormal
        end
        tabBtn.BackgroundColor3 = Theme.Colors.TabSelected
        
        updateContentPage(tab.name)
        connectButtons()
    end)
end

if tabButtons["Combat"] then
    tabButtons["Combat"].BackgroundColor3 = Theme.Colors.TabSelected
end
updateContentPage("Combat")
connectButtons()

closeBtn.MouseButton1Click:Connect(function()
    guiVisible = false
    mainFrame.Visible = false
end)

-- ============================================
-- KEYBIND INPUT
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local keyMap = {
        [CONFIG.GUI_TOGGLE_KEY] = toggleGUI,
        [CONFIG.AIMBOT_KEY] = toggleAimbot,
        [CONFIG.ESP_KEY] = toggleESP,
        [CONFIG.KILLAURA_KEY] = toggleKillAura,
        [CONFIG.FASTM1_KEY] = toggleFastM1,
        [CONFIG.FLY_KEY] = toggleFly,
        [CONFIG.NOCLIP_KEY] = toggleNoClip,
        [CONFIG.INFJUMP_KEY] = toggleInfJump,
        [CONFIG.SPEED_KEY] = toggleSpeed,
        [CONFIG.FULLBRIGHT_KEY] = toggleFullBright,
        [CONFIG.GODMODE_KEY] = toggleGodMode,
        [CONFIG.TELEPORT_KEY] = teleportToPlayer,
    }
    
    local action = keyMap[input.KeyCode]
    if action then
        action()
    elseif input.KeyCode == Enum.KeyCode.Space and state.infjump and not state.fly and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ============================================
-- MAIN UPDATE LOOPS
-- ============================================
RunService.RenderStepped:Connect(function()
    if state.aimbot then
        local target = getClosestPlayer(CONFIG.AIMBOT_FOV, true)
        if target then
            aimAtTarget(target)
        end
    end
    
    if state.noclip then
        updateNoClip()
    end
end)

-- ============================================
-- PLAYER EVENTS
-- ============================================
Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if state.esp then
            createESP(newPlayer)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(removedPlayer)
    removeESP(removedPlayer)
    if selectedTeleportPlayer == removedPlayer then
        selectedTeleportPlayer = nil
    end
end)

-- ============================================
-- RESPAWN HANDLING
-- ============================================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    task.wait(0.2)
    originalSpeed = humanoid.WalkSpeed
    
    if state.speed then updateSpeed() end
    if state.godmode then updateGodMode() end
    if state.esp then task.wait(0.5); updateESP() end
    
    print("[NullHub] Character respawned - features reapplied")
end)

-- ============================================
-- INITIALIZATION
-- ============================================
saveOriginalLighting()
originalSpeed = humanoid.WalkSpeed

print("========================================")
print("⚡ NullHub V2 - FULLY FIXED & WORKING ⚡")
print("========================================")
print("📱 GUI: Press [INSERT] to toggle")
print("🎯 FEATURES:")
print("  • Combat: Aimbot, ESP, KillAura, Fast M1")
print("  • Movement: Fly, NoClip, Speed, Inf Jump")
print("  • Visual: Full Bright, God Mode")
print("  • Teleport: Player teleportation")
print("✅ NO ERRORS - FULLY OPTIMIZED")
print("========================================")
