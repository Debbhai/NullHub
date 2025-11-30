-- ============================================
-- NullHub GUI.lua - Interface Module
-- Created by Debbhai
-- Version: 1.0.0
-- Modular GUI system with theme support
-- ============================================

local GUI = {
    Version = "1.0.0",
    Author = "Debbhai",
    Initialized = false
}

-- Internal references
local MainFrame, ScreenGui, ContentScroll, PageTitle
local Sidebar, TopBar, ClosePrompt, ToggleButton
local GuiButtons = {}
local CurrentPage = "Combat"
local IsVisible = true

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--============================================
-- INITIALIZATION
--============================================
function GUI:Initialize(screenGui, theme, config)
    if self.Initialized then
        warn("[GUI] Already initialized!")
        return false
    end
    
    self.ScreenGui = screenGui
    self.Theme = theme
    self.Config = config
    self.Modules = {}
    
    print("[GUI] ✅ Initialized")
    self.Initialized = true
    return true
end

function GUI:RegisterModules(modules)
    self.Modules = modules
    print("[GUI] ✅ Modules registered")
end

--============================================
-- GUI CREATION
--============================================
function GUI:Create()
    if not self.Initialized then
        error("[GUI] Not initialized! Call GUI:Initialize() first")
        return
    end
    
    print("[GUI] Creating interface...")
    
    -- Create main components
    MainFrame, TopBar, Sidebar, ContentScroll, PageTitle = self:CreateMainWindow()
    ToggleButton = self:CreateToggleButton()
    ClosePrompt = self:CreateClosePrompt()
    
    -- Create tabs
    self:CreateTabs()
    
    -- Set initial page
    self:UpdateContentPage("Combat")
    
    -- Store references
    self.MainFrame = MainFrame
    self.ToggleButton = ToggleButton
    
    print("[GUI] ✅ Interface created")
    return true
end

--============================================
-- MAIN WINDOW CREATION
--============================================
function GUI:CreateMainWindow()
    local currentTheme = self.Theme:GetTheme()
    local sizes = self.Theme.Sizes
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, sizes.MainFrameWidth, 0, sizes.MainFrameHeight)
    mainFrame.Position = UDim2.new(0.5, -sizes.MainFrameWidth/2, 0.5, -sizes.MainFrameHeight/2)
    mainFrame.BackgroundColor3 = currentTheme.Colors.MainBackground
    mainFrame.BackgroundTransparency = currentTheme.Transparency.MainBackground
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = self.ScreenGui
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Large)
    
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = currentTheme.Colors.BorderColor
    mainStroke.Thickness = 1
    mainStroke.Transparency = currentTheme.Transparency.Stroke
    
    -- Top Bar
    local topBar = self:CreateTopBar(mainFrame, currentTheme, sizes)
    
    -- Sidebar
    local sidebar = self:CreateSidebar(mainFrame, currentTheme, sizes)
    
    -- Content Frame
    local contentFrame, contentScroll, pageTitle = self:CreateContentFrame(mainFrame, currentTheme, sizes)
    
    return mainFrame, topBar, sidebar, contentScroll, pageTitle
end

--============================================
-- TOP BAR CREATION
--============================================
function GUI:CreateTopBar(parent, theme, sizes)
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, sizes.HeaderHeight)
    topBar.BackgroundColor3 = theme.Colors.HeaderBackground
    topBar.BackgroundTransparency = theme.Transparency.Header
    topBar.BorderSizePixel = 0
    topBar.Parent = parent
    
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Large)
    
    -- Accent Line
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = theme.Colors.AccentBar
    accentLine.BackgroundTransparency = theme.Transparency.AccentBar
    accentLine.BorderSizePixel = 0
    accentLine.Parent = topBar
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 18, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ NullHub | Protected"
    title.TextColor3 = theme.Colors.TextPrimary
    title.TextSize = self.Theme.FontSizes.Title
    title.Font = self.Theme.Fonts.Title
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, sizes.CloseButton, 0, sizes.CloseButton)
    closeBtn.Position = UDim2.new(1, -sizes.CloseButton - 6, 0, 3.5)
    closeBtn.BackgroundColor3 = theme.Colors.CloseButton
    closeBtn.BackgroundTransparency = theme.Transparency.CloseButton
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = theme.Colors.TextPrimary
    closeBtn.TextSize = 26
    closeBtn.Font = self.Theme.Fonts.Title
    closeBtn.Parent = topBar
    
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Medium)
    
    -- Connect close button
    closeBtn.MouseButton1Click:Connect(function()
        if ClosePrompt then
            ClosePrompt.Visible = true
        end
    end)
    
    return topBar
end

--============================================
-- SIDEBAR CREATION
--============================================
function GUI:CreateSidebar(parent, theme, sizes)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, sizes.SidebarWidth, 1, -sizes.HeaderHeight - 8)
    sidebar.Position = UDim2.new(0, 6, 0, sizes.HeaderHeight + 6)
    sidebar.BackgroundColor3 = theme.Colors.SidebarBackground
    sidebar.BackgroundTransparency = theme.Transparency.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = parent
    
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Medium)
    
    local sidebarStroke = Instance.new("UIStroke", sidebar)
    sidebarStroke.Color = theme.Colors.BorderColor
    sidebarStroke.Thickness = 1
    sidebarStroke.Transparency = theme.Transparency.Stroke
    
    local sidebarList = Instance.new("UIListLayout", sidebar)
    sidebarList.Padding = UDim.new(0, 6)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    
    local sidebarPadding = Instance.new("UIPadding", sidebar)
    sidebarPadding.PaddingTop = UDim.new(0, 8)
    sidebarPadding.PaddingLeft = UDim.new(0, 8)
    sidebarPadding.PaddingRight = UDim.new(0, 8)
    sidebarPadding.PaddingBottom = UDim.new(0, 8)
    
    return sidebar
end

--============================================
-- CONTENT FRAME CREATION
--============================================
function GUI:CreateContentFrame(parent, theme, sizes)
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -sizes.SidebarWidth - 18, 1, -sizes.HeaderHeight - 14)
    contentFrame.Position = UDim2.new(0, sizes.SidebarWidth + 12, 0, sizes.HeaderHeight + 8)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = parent
    
    -- Page Title
    local pageTitle = Instance.new("TextLabel")
    pageTitle.Name = "PageTitle"
    pageTitle.Size = UDim2.new(1, 0, 0, 32)
    pageTitle.BackgroundTransparency = 1
    pageTitle.Text = "Combat"
    pageTitle.TextColor3 = theme.Colors.TextPrimary
    pageTitle.TextSize = self.Theme.FontSizes.Title
    pageTitle.Font = self.Theme.Fonts.Title
    pageTitle.TextXAlignment = Enum.TextXAlignment.Left
    pageTitle.Parent = contentFrame
    
    -- Scrolling Frame
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "ActionScroll"
    contentScroll.Size = UDim2.new(1, -8, 1, -40)
    contentScroll.Position = UDim2.new(0, 0, 0, 38)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = sizes.ScrollBarThickness
    contentScroll.ScrollBarImageColor3 = theme.Colors.ScrollBarColor
    contentScroll.ScrollBarImageTransparency = theme.Transparency.ScrollBar
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.Parent = contentFrame
    
    Instance.new("UIListLayout", contentScroll).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", contentScroll).PaddingRight = UDim.new(0, 4)
    
    return contentFrame, contentScroll, pageTitle
end

--============================================
-- TAB CREATION
--============================================
function GUI:CreateTabs()
    local tabs = {
        {name = "Combat", icon = "⚔️"},
        {name = "Movement", icon = "🏃"},
        {name = "Visual", icon = "👁️"},
        {name = "Teleport", icon = "📍"},
        {name = "Themes", icon = "🎨"}
    }
    
    local tabButtons = {}
    
    for i, tab in ipairs(tabs) do
        local tabBtn = self:CreateTabButton(Sidebar, tab.name, tab.icon, i)
        tabButtons[tab.name] = tabBtn
        
        tabBtn.MouseButton1Click:Connect(function()
            -- Deselect all tabs
            for _, otherTab in pairs(tabButtons) do
                otherTab.BackgroundColor3 = self.Theme:GetTheme().Colors.TabNormal
            end
            
            -- Select this tab
            tabBtn.BackgroundColor3 = self.Theme:GetTheme().Colors.TabSelected
            
            -- Update content
            self:UpdateContentPage(tab.name)
            self:ConnectButtons()
        end)
    end
    
    -- Set initial selection
    if tabButtons["Combat"] then
        tabButtons["Combat"].BackgroundColor3 = self.Theme:GetTheme().Colors.TabSelected
    end
    
    self.TabButtons = tabButtons
end

--============================================
-- TAB BUTTON CREATION
--============================================
function GUI:CreateTabButton(parent, tabName, icon, index)
    local currentTheme = self.Theme:GetTheme()
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. tabName
    tabBtn.Size = UDim2.new(1, 0, 0, self.Theme.Sizes.TabHeight)
    tabBtn.BackgroundColor3 = currentTheme.Colors.TabNormal
    tabBtn.BackgroundTransparency = currentTheme.Transparency.Tab
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = "  " .. icon .. "  " .. tabName
    tabBtn.TextColor3 = currentTheme.Colors.TextPrimary
    tabBtn.TextSize = self.Theme.FontSizes.Tab
    tabBtn.Font = self.Theme.Fonts.Tab
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.LayoutOrder = index
    tabBtn.Parent = parent
    
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Small)
    
    local tabStroke = Instance.new("UIStroke", tabBtn)
    tabStroke.Color = currentTheme.Colors.BorderColor
    tabStroke.Thickness = 1
    tabStroke.Transparency = 0.7
    
    return tabBtn
end

--============================================
-- ACTION ROW CREATION
--============================================
function GUI:CreateActionRow(parent, actionData, index)
    local currentTheme = self.Theme:GetTheme()
    local sizes = self.Theme.Sizes
    
    -- Calculate height
    local rowHeight = sizes.ActionRowHeight
    if actionData.hasInput then
        rowHeight = sizes.ActionRowHeight + sizes.InputHeight + 12
    elseif actionData.hasDropdown then
        rowHeight = sizes.ActionRowHeight + sizes.DropdownHeight + 12
    elseif actionData.hasStopButton then
        rowHeight = sizes.ActionRowHeight * 2 + 12
    end
    
    -- Create container
    local actionFrame = Instance.new("Frame")
    actionFrame.Name = actionData.name .. "Row"
    actionFrame.Size = UDim2.new(1, -4, 0, rowHeight)
    actionFrame.BackgroundColor3 = currentTheme.Colors.ContainerBackground
    actionFrame.BackgroundTransparency = currentTheme.Transparency.Container
    actionFrame.BorderSizePixel = 0
    actionFrame.LayoutOrder = index
    actionFrame.Parent = parent
    
    Instance.new("UICorner", actionFrame).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Small)
    
    local rowStroke = Instance.new("UIStroke", actionFrame)
    rowStroke.Color = currentTheme.Colors.BorderColor
    rowStroke.Thickness = 1
    rowStroke.Transparency = currentTheme.Transparency.Stroke
    
    -- Main button
    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = actionData.state .. "Btn"
    actionBtn.Size = UDim2.new(1, 0, 0, sizes.ActionRowHeight)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Text = ""
    actionBtn.Parent = actionFrame
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 32, 0, sizes.ActionRowHeight)
    icon.Position = UDim2.new(0, 8, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = actionData.icon
    icon.TextSize = 20
    icon.TextColor3 = currentTheme.Colors.TextPrimary
    icon.Parent = actionFrame
    
    -- Name Label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -90, 0, sizes.ActionRowHeight)
    nameLabel.Position = UDim2.new(0, 42, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = actionData.name .. " [" .. actionData.key .. "]"
    nameLabel.TextColor3 = currentTheme.Colors.TextPrimary
    nameLabel.TextSize = self.Theme.FontSizes.Action
    nameLabel.Font = self.Theme.Fonts.Action
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = actionFrame
    
    -- Status Indicator
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, sizes.StatusIndicator, 0, sizes.StatusIndicator)
    statusIndicator.Position = UDim2.new(1, -24, 0, (sizes.ActionRowHeight - sizes.StatusIndicator) / 2)
    statusIndicator.BackgroundColor3 = currentTheme.Colors.StatusOff
    statusIndicator.BackgroundTransparency = currentTheme.Transparency.StatusIndicator
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = actionFrame
    
    Instance.new("UICorner", statusIndicator).CornerRadius = UDim.new(1, 0)
    
    -- Additional components based on type
    local speedInput, dropdown, stopBtn
    
    if actionData.hasInput then
        speedInput = self:CreateSpeedInput(actionFrame, currentTheme, sizes)
    elseif actionData.hasDropdown then
        dropdown = self:CreatePlayerDropdown(actionFrame, currentTheme, sizes)
    elseif actionData.hasStopButton then
        stopBtn = self:CreateStopButton(actionFrame, currentTheme, sizes)
    end
    
    return actionFrame, actionBtn, statusIndicator, speedInput, dropdown, stopBtn
end

--============================================
-- SPEED INPUT CREATION
--============================================
function GUI:CreateSpeedInput(parent, theme, sizes)
    local speedInput = Instance.new("TextBox")
    speedInput.Name = "SpeedInput"
    speedInput.Size = UDim2.new(1, -16, 0, sizes.InputHeight)
    speedInput.Position = UDim2.new(0, 8, 0, sizes.ActionRowHeight + 6)
    speedInput.BackgroundColor3 = theme.Colors.InputBackground
    speedInput.BackgroundTransparency = theme.Transparency.Input
    speedInput.BorderSizePixel = 0
    speedInput.Text = tostring(self.Config.Movement.SPEED.VALUE)
    speedInput.PlaceholderText = "Speed (0-1000000)"
    speedInput.TextColor3 = theme.Colors.TextPrimary
    speedInput.PlaceholderColor3 = theme.Colors.TextPlaceholder
    speedInput.TextSize = self.Theme.FontSizes.Input
    speedInput.Font = self.Theme.Fonts.Input
    speedInput.ClearTextOnFocus = false
    speedInput.Parent = parent
    
    Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Tiny)
    
    local padding = Instance.new("UIPadding", speedInput)
    padding.PaddingLeft = UDim.new(0, 10)
    
    return speedInput
end

--============================================
-- PLAYER DROPDOWN CREATION
--============================================
function GUI:CreatePlayerDropdown(parent, theme, sizes)
    local dropdown = Instance.new("ScrollingFrame")
    dropdown.Name = "PlayerDropdown"
    dropdown.Size = UDim2.new(1, -16, 0, sizes.DropdownHeight)
    dropdown.Position = UDim2.new(0, 8, 0, sizes.ActionRowHeight + 6)
    dropdown.BackgroundColor3 = theme.Colors.DropdownBackground
    dropdown.BackgroundTransparency = theme.Transparency.Dropdown
    dropdown.BorderSizePixel = 0
    dropdown.ScrollBarThickness = 4
    dropdown.ScrollBarImageColor3 = theme.Colors.ScrollBarColor
    dropdown.ScrollBarImageTransparency = theme.Transparency.ScrollBar
    dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropdown.Parent = parent
    
    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Tiny)
    
    local placeholderLabel = Instance.new("TextLabel")
    placeholderLabel.Name = "PlaceholderText"
    placeholderLabel.Size = UDim2.new(1, -16, 0, 30)
    placeholderLabel.Position = UDim2.new(0, 8, 0, 8)
    placeholderLabel.BackgroundTransparency = 1
    placeholderLabel.Text = "Select a player..."
    placeholderLabel.TextColor3 = theme.Colors.TextPlaceholder
    placeholderLabel.TextSize = self.Theme.FontSizes.Input
    placeholderLabel.Font = self.Theme.Fonts.Input
    placeholderLabel.TextXAlignment = Enum.TextXAlignment.Left
    placeholderLabel.Parent = dropdown
    
    return dropdown
end

--============================================
-- STOP BUTTON CREATION
--============================================
function GUI:CreateStopButton(parent, theme, sizes)
    local stopBtn = Instance.new("TextButton")
    stopBtn.Name = "StopTweenBtn"
    stopBtn.Size = UDim2.new(1, -16, 0, sizes.ActionRowHeight)
    stopBtn.Position = UDim2.new(0, 8, 0, sizes.ActionRowHeight + 6)
    stopBtn.BackgroundColor3 = theme.Colors.CloseButton
    stopBtn.BackgroundTransparency = 0.1
    stopBtn.BorderSizePixel = 0
    stopBtn.Text = "⏹ Stop Tween"
    stopBtn.TextColor3 = theme.Colors.TextPrimary
    stopBtn.TextSize = self.Theme.FontSizes.Action
    stopBtn.Font = self.Theme.Fonts.Tab
    stopBtn.Parent = parent
    
    Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Small)
    
    return stopBtn
end

--============================================
-- TOGGLE BUTTON CREATION
--============================================
function GUI:CreateToggleButton()
    local currentTheme = self.Theme:GetTheme()
    local sizes = self.Theme.Sizes
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, sizes.ToggleButton, 0, sizes.ToggleButton)
    toggleBtn.Position = UDim2.new(0, 15, 0.5, -sizes.ToggleButton/2)
    toggleBtn.BackgroundColor3 = currentTheme.Colors.ToggleButton
    toggleBtn.BackgroundTransparency = currentTheme.Transparency.ToggleButton
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "N"
    toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggleBtn.TextSize = 28
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.ZIndex = 1000
    toggleBtn.Parent = self.ScreenGui
    
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.5, 0)
    
    local stroke = Instance.new("UIStroke", toggleBtn)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 3
    stroke.Transparency = 0.3
    
    -- Dragging functionality
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
            toggleBtn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Click to toggle
    toggleBtn.MouseButton1Click:Connect(function()
        if dragDistance < 5 then
            self:ToggleVisibility()
        end
    end)
    
    return toggleBtn
end

--============================================
-- CLOSE PROMPT CREATION
--============================================
function GUI:CreateClosePrompt()
    local currentTheme = self.Theme:GetTheme()
    
    local prompt = Instance.new("Frame")
    prompt.Size = UDim2.new(0, 320, 0, 160)
    prompt.Position = UDim2.new(0.5, -160, 0.5, -80)
    prompt.BackgroundColor3 = currentTheme.Colors.MainBackground
    prompt.BackgroundTransparency = currentTheme.Transparency.MainBackground
    prompt.BorderSizePixel = 0
    prompt.Visible = false
    prompt.ZIndex = 2000
    prompt.Parent = self.ScreenGui
    
    Instance.new("UICorner", prompt).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Medium)
    
    local stroke = Instance.new("UIStroke", prompt)
    stroke.Color = currentTheme.Colors.AccentBar
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Close NullHub?"
    title.TextColor3 = currentTheme.Colors.TextPrimary
    title.TextSize = self.Theme.FontSizes.Title
    title.Font = self.Theme.Fonts.Title
    title.Parent = prompt
    
    -- Description
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 30)
    desc.Position = UDim2.new(0, 10, 0, 45)
    desc.BackgroundTransparency = 1
    desc.Text = "Choose an action:"
    desc.TextColor3 = currentTheme.Colors.TextSecondary
    desc.TextSize = 13
    desc.Font = self.Theme.Fonts.Action
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = prompt
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 140, 0, 38)
    minimizeBtn.Position = UDim2.new(0, 10, 1, -48)
    minimizeBtn.BackgroundColor3 = currentTheme.Colors.MinimizeButton
    minimizeBtn.BackgroundTransparency = 0.1
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "Minimize"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 15
    minimizeBtn.Font = self.Theme.Fonts.Tab
    minimizeBtn.Parent = prompt
    
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Small)
    
    -- Close & Destroy Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 140, 0, 38)
    closeBtn.Position = UDim2.new(1, -150, 1, -48)
    closeBtn.BackgroundColor3 = currentTheme.Colors.CloseButton
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Close & Destroy"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 15
    closeBtn.Font = self.Theme.Fonts.Tab
    closeBtn.Parent = prompt
    
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Small)
    
    -- Connect buttons
    minimizeBtn.MouseButton1Click:Connect(function()
        prompt.Visible = false
        self:ToggleVisibility(false)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    return prompt
end

--============================================
-- CONTENT PAGE UPDATE
--============================================
function GUI:UpdateContentPage(tabName)
    if not ContentScroll then return end
    
    -- Clear existing content
    for _, child in pairs(ContentScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Update title
    if PageTitle then
        PageTitle.Text = tabName
    end
    
    -- Handle Themes page
    if tabName == "Themes" then
        local themeNames = self.Theme:GetAllThemeNames()
        for i, themeName in ipairs(themeNames) do
            local themeBtn = self:CreateThemeButton(ContentScroll, themeName, i)
            themeBtn.MouseButton1Click:Connect(function()
                if self.Theme:SetTheme(themeName) then
                    self:RefreshTheme()
                end
            end)
        end
        return
    end
    
    -- Create feature rows
    local features = self:GetFeaturesForTab(tabName)
    for i, feature in ipairs(features) do
        local frame, btn, indicator, input, dropdown, stopBtn = self:CreateActionRow(ContentScroll, feature, i)
        
        GuiButtons[feature.state] = {
            button = btn,
            indicator = indicator,
            container = frame,
            isAction = feature.isAction or false,
            input = input,
            dropdown = dropdown,
            stopBtn = stopBtn
        }
    end
    
    CurrentPage = tabName
end

--============================================
-- GET FEATURES FOR TAB
--============================================
function GUI:GetFeaturesForTab(tabName)
    local featuresByTab = {
        Combat = {
            {name = "Aimbot", key = "E", state = "aimbot", icon = "🎯"},
            {name = "ESP", key = "T", state = "esp", icon = "👁️"},
            {name = "KillAura", key = "K", state = "killaura", icon = "⚔️"},
            {name = "Fast M1", key = "M", state = "fastm1", icon = "👊"}
        },
        Movement = {
            {name = "Fly", key = "F", state = "fly", icon = "🕊️"},
            {name = "NoClip", key = "N", state = "noclip", icon = "👻"},
            {name = "Infinite Jump", key = "J", state = "infjump", icon = "🦘"},
            {name = "Speed Hack", key = "X", state = "speed", icon = "⚡", hasInput = true},
            {name = "Walk on Water", key = "U", state = "walkonwater", icon = "🌊"}
        },
        Visual = {
            {name = "Full Bright", key = "B", state = "fullbright", icon = "💡"},
            {name = "God Mode", key = "V", state = "godmode", icon = "🛡️"}
        },
        Teleport = {
            {name = "Teleport To Player", key = "Z", state = "teleport", icon = "🚀", isAction = true, hasDropdown = true},
            {name = "Stop Teleport", key = "", state = "stop_tween", icon = "⏹", isAction = true, hasStopButton = true}
        }
    }
    
    return featuresByTab[tabName] or {}
end

--============================================
-- THEME BUTTON CREATION
--============================================
function GUI:CreateThemeButton(parent, themeName, index)
    local currentTheme = self.Theme:GetTheme()
    local sizes = self.Theme.Sizes
    
    local themeBtn = Instance.new("TextButton")
    themeBtn.Name = "Theme_" .. themeName
    themeBtn.Size = UDim2.new(1, -16, 0, sizes.ActionRowHeight)
    themeBtn.Position = UDim2.new(0, 8, 0, (index - 1) * (sizes.ActionRowHeight + 6) + 6)
    themeBtn.BackgroundColor3 = currentTheme.Colors.ContainerBackground
    themeBtn.BackgroundTransparency = currentTheme.Transparency.Container
    themeBtn.BorderSizePixel = 0
    themeBtn.Text = "  ●  " .. themeName
    themeBtn.TextColor3 = currentTheme.Colors.TextPrimary
    themeBtn.TextSize = self.Theme.FontSizes.Action
    themeBtn.Font = self.Theme.Fonts.Action
    themeBtn.TextXAlignment = Enum.TextXAlignment.Left
    themeBtn.Parent = parent
    
    Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Small)
    
    local btnStroke = Instance.new("UIStroke", themeBtn)
    btnStroke.Color = currentTheme.Colors.BorderColor
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.7
    
    return themeBtn
end

--============================================
-- CONNECT BUTTONS
--============================================
function GUI:ConnectButtons()
    -- Will be implemented by V1.lua to connect module functions
    print("[GUI] Buttons ready for connection")
end

function GUI:ConnectKeybinds()
    -- Will be implemented by V1.lua to setup keybinds
    print("[GUI] Keybinds ready for connection")
end

--============================================
-- UTILITY FUNCTIONS
--============================================
function GUI:ToggleVisibility(visible)
    if visible == nil then
        IsVisible = not IsVisible
    else
        IsVisible = visible
    end
    
    local targetPos = IsVisible and
        UDim2.new(0.5, -self.Theme.Sizes.MainFrameWidth/2, 0.5, -self.Theme.Sizes.MainFrameHeight/2) or
        UDim2.new(0.5, -self.Theme.Sizes.MainFrameWidth/2, -1, 0)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = targetPos}):Play()
end

function GUI:RefreshTheme()
    if not MainFrame then return end
    
    -- Refresh all GUI elements with new theme
    local currentTheme = self.Theme:GetTheme()
    
    -- Refresh main frame
    MainFrame.BackgroundColor3 = currentTheme.Colors.MainBackground
    MainFrame.BackgroundTransparency = currentTheme.Transparency.MainBackground
    
    -- Refresh all child elements
    -- (Implementation would refresh all elements recursively)
    
    -- Show notification
    if self.Modules.Notifications then
        self.Modules.Notifications:Show("Theme", true, "Theme changed to " .. self.Theme.CurrentTheme, 2)
    end
    
    print("[GUI] Theme refreshed to: " .. self.Theme.CurrentTheme)
end

function GUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    GuiButtons = {}
    self.Initialized = false
    
    print("[GUI] ✅ Destroyed")
end

function GUI:GetButton(stateName)
    return GuiButtons[stateName]
end

function GUI:GetAllButtons()
    return GuiButtons
end

-- Return module
return GUI
