-- ============================================
-- NullHub GUI.lua - Interface Module FINAL
-- Created by Debbhai
-- Version: 1.0.2 FINAL
-- Complete working version with instant theme refresh
-- ============================================

local GUI = {
    Version = "1.0.2",
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
    print("[GUI] Combat:", modules.Combat and "✅" or "❌")
    print("[GUI] Movement:", modules.Movement and "✅" or "❌")
    print("[GUI] Visual:", modules.Visual and "✅" or "❌")
    print("[GUI] Teleport:", modules.Teleport and "✅" or "❌")
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
                    -- Theme will auto-refresh GUI via registered callback
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
    themeBtn.BackgroundColor3 = currentTheme.Colors.ContainerBackground
    themeBtn.BackgroundTransparency = currentTheme.Transparency.Container
    themeBtn.BorderSizePixel = 0
    themeBtn.Text = "  ●  " .. themeName
    themeBtn.TextColor3 = currentTheme.Colors.TextPrimary
    themeBtn.TextSize = self.Theme.FontSizes.Action
    themeBtn.Font = self.Theme.Fonts.Action
    themeBtn.TextXAlignment = Enum.TextXAlignment.Left
    themeBtn.LayoutOrder = index
    themeBtn.Parent = parent
    
    Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Small)
    
    local btnStroke = Instance.new("UIStroke", themeBtn)
    btnStroke.Color = currentTheme.Colors.BorderColor
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.7
    
    return themeBtn
end

--============================================
-- CONNECT BUTTONS (COMPLETE - FIXED)
--============================================
function GUI:ConnectButtons()
    if not self.Modules then
        warn("[GUI] No modules registered!")
        return
    end
    
    print("[GUI] Connecting buttons to modules...")
    
    local Combat = self.Modules.Combat or {}
    local Movement = self.Modules.Movement or {}
    local Visual = self.Modules.Visual or {}
    local Teleport = self.Modules.Teleport or {}
    local Notifications = self.Modules.Notifications
    
    -- Helper function to connect a button
    local function connectButton(stateName, module, moduleName)
        local btnData = GuiButtons[stateName]
        if not btnData or not btnData.button or not module then
            return
        end
        
        local isEnabled = false
        
        btnData.button.MouseButton1Click:Connect(function()
            -- For action buttons (like Teleport)
            if btnData.isAction then
                if stateName == "teleport" and Teleport.TeleportToPlayer then
                    local selectedPlayer = btnData.dropdown and btnData.dropdown:FindFirstChild("SelectedPlayer")
                    if selectedPlayer and selectedPlayer.Value then
                        pcall(function()
                            Teleport.TeleportToPlayer:TeleportTo(selectedPlayer.Value)
                        end)
                    else
                        if Notifications then
                            Notifications:Warning("Select a player first!", 2)
                        end
                    end
                elseif stateName == "stop_tween" and Teleport.TeleportToPlayer then
                    pcall(function()
                        Teleport.TeleportToPlayer:StopTween()
                    end)
                end
                return
            end
            
            -- Toggle features
            local success, newState = pcall(function()
                return module:Toggle()
            end)
            
            if success then
                isEnabled = newState
                
                -- Update indicator
                if btnData.indicator then
                    btnData.indicator.BackgroundColor3 = isEnabled and 
                        self.Theme:GetTheme().Colors.StatusOn or 
                        self.Theme:GetTheme().Colors.StatusOff
                end
                
                -- Update container
                if btnData.container then
                    btnData.container.BackgroundColor3 = isEnabled and 
                        self.Theme:GetTheme().Colors.ContainerOn or 
                        self.Theme:GetTheme().Colors.ContainerOff
                end
                
                print("[GUI] " .. moduleName .. ": " .. (isEnabled and "ON" or "OFF"))
            else
                warn("[GUI] Failed to toggle " .. moduleName)
            end
        end)
        
        -- Connect input field (for Speed)
        if btnData.input and stateName == "speed" then
            btnData.input.FocusLost:Connect(function()
                local value = tonumber(btnData.input.Text)
                if value and module.SetSpeed then
                    pcall(function()
                        module:SetSpeed(value)
                        if Notifications then
                            Notifications:Show("Speed", true, "Speed: " .. value, 1.5)
                        end
                    end)
                end
            end)
        end
        
        print("[GUI] ✅ Connected: " .. moduleName)
    end
    
    -- Connect Combat buttons
    connectButton("aimbot", Combat.Aimbot, "Aimbot")
    connectButton("esp", Combat.ESP, "ESP")
    connectButton("killaura", Combat.KillAura, "KillAura")
    connectButton("fastm1", Combat.FastM1, "FastM1")
    
    -- Connect Movement buttons
    connectButton("fly", Movement.Fly, "Fly")
    connectButton("noclip", Movement.NoClip, "NoClip")
    connectButton("infjump", Movement.InfiniteJump, "InfiniteJump")
    connectButton("speed", Movement.Speed, "Speed")
    connectButton("walkonwater", Movement.WalkOnWater, "WalkOnWater")
    
    -- Connect Visual buttons
    connectButton("fullbright", Visual.FullBright, "FullBright")
    connectButton("godmode", Visual.GodMode, "GodMode")
    
    -- Connect Teleport buttons
    if Teleport.TeleportToPlayer then
        connectButton("teleport", Teleport.TeleportToPlayer, "TeleportToPlayer")
        connectButton("stop_tween", Teleport.TeleportToPlayer, "StopTween")
        
        -- Populate player dropdown
        self:PopulatePlayerDropdown()
    end
    
    print("[GUI] ✅ All buttons connected")
end

--============================================
-- POPULATE PLAYER DROPDOWN (NEW FUNCTION)
--============================================
function GUI:PopulatePlayerDropdown()
    local btnData = GuiButtons["teleport"]
    if not btnData or not btnData.dropdown then return end
    
    local dropdown = btnData.dropdown
    
    -- Clear existing
    for _, child in pairs(dropdown:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Hide placeholder
    local placeholder = dropdown:FindFirstChild("PlaceholderText")
    if placeholder then
        placeholder.Visible = false
    end
    
    -- Add selected player value
    local selectedPlayer = dropdown:FindFirstChild("SelectedPlayer")
    if not selectedPlayer then
        selectedPlayer = Instance.new("StringValue")
        selectedPlayer.Name = "SelectedPlayer"
        selectedPlayer.Parent = dropdown
    end
    
    -- Create list layout
    if not dropdown:FindFirstChild("UIListLayout") then
        local listLayout = Instance.new("UIListLayout", dropdown)
        listLayout.Padding = UDim.new(0, 4)
    end
    
    -- Add players
    local players = Players:GetPlayers()
    for i, otherPlayer in ipairs(players) do
        if otherPlayer ~= player then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Name = otherPlayer.Name
            playerBtn.Size = UDim2.new(1, -8, 0, self.Theme.Sizes.PlayerButtonHeight)
            playerBtn.BackgroundColor3 = self.Theme:GetTheme().Colors.PlayerButtonBg
            playerBtn.BackgroundTransparency = self.Theme:GetTheme().Transparency.PlayerButton
            playerBtn.BorderSizePixel = 0
            playerBtn.Text = "  " .. otherPlayer.Name
            playerBtn.TextColor3 = self.Theme:GetTheme().Colors.TextPrimary
            playerBtn.TextSize = self.Theme.FontSizes.Input
            playerBtn.Font = self.Theme.Fonts.Input
            playerBtn.TextXAlignment = Enum.TextXAlignment.Left
            playerBtn.Parent = dropdown
            
            Instance.new("UICorner", playerBtn).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Tiny)
            
            playerBtn.MouseButton1Click:Connect(function()
                selectedPlayer.Value = otherPlayer.Name
                
                -- Highlight selected
                for _, btn in pairs(dropdown:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundTransparency = 0.25
                    end
                end
                playerBtn.BackgroundTransparency = 0
                
                if self.Modules.Notifications then
                    self.Modules.Notifications:Show("Player Selected", true, otherPlayer.Name, 1.5)
                end
            end)
        end
    end
    
    -- Auto-refresh when players join/leave
    Players.PlayerAdded:Connect(function()
        task.wait(0.5)
        self:PopulatePlayerDropdown()
    end)
    
    Players.PlayerRemoving:Connect(function()
        task.wait(0.5)
        self:PopulatePlayerDropdown()
    end)
end

--============================================
-- CONNECT KEYBINDS (COMPLETE - FIXED)
--============================================
function GUI:ConnectKeybinds()
    if not self.Modules then
        warn("[GUI] No modules registered!")
        return
    end
    
    print("[GUI] Connecting keybinds...")
    
    local Combat = self.Modules.Combat or {}
    local Movement = self.Modules.Movement or {}
    local Visual = self.Modules.Visual or {}
    local Teleport = self.Modules.Teleport or {}
    
    -- GUI Toggle (INSERT key)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Insert then
            self:ToggleVisibility()
        end
    end)
    
    -- Helper function to connect a keybind
    local function connectKeybind(keyCode, module, moduleName)
        if not module then return end
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == keyCode then
                pcall(function()
                    module:Toggle()
                end)
            end
        end)
        
        print("[GUI] ✅ Keybind: " .. moduleName .. " [" .. keyCode.Name .. "]")
    end
    
    -- Combat keybinds
    if self.Config and self.Config.Combat then
        connectKeybind(self.Config.Combat.AIMBOT.KEY, Combat.Aimbot, "Aimbot")
        connectKeybind(self.Config.Combat.ESP.KEY, Combat.ESP, "ESP")
        connectKeybind(self.Config.Combat.KILLAURA.KEY, Combat.KillAura, "KillAura")
        connectKeybind(self.Config.Combat.FASTM1.KEY, Combat.FastM1, "FastM1")
    end
    
    -- Movement keybinds
    if self.Config and self.Config.Movement then
        connectKeybind(self.Config.Movement.FLY.KEY, Movement.Fly, "Fly")
        connectKeybind(self.Config.Movement.NOCLIP.KEY, Movement.NoClip, "NoClip")
        connectKeybind(self.Config.Movement.INFJUMP.KEY, Movement.InfiniteJump, "InfiniteJump")
        connectKeybind(self.Config.Movement.SPEED.KEY, Movement.Speed, "Speed")
        connectKeybind(self.Config.Movement.WALKONWATER.KEY, Movement.WalkOnWater, "WalkOnWater")
    end
    
    -- Visual keybinds
    if self.Config and self.Config.Visual then
        connectKeybind(self.Config.Visual.FULLBRIGHT.KEY, Visual.FullBright, "FullBright")
        connectKeybind(self.Config.Visual.GODMODE.KEY, Visual.GodMode, "GodMode")
    end
    
    -- Teleport keybind
    if self.Config and self.Config.Teleport then
        connectKeybind(self.Config.Teleport.TELEPORT_TO_PLAYER.KEY, Teleport.TeleportToPlayer, "TeleportToPlayer")
    end
    
    print("[GUI] ✅ All keybinds connected")
end

--============================================
-- REFRESH THEME (COMPLETE - INSTANT UPDATE)
--============================================
function GUI:RefreshTheme()
    if not MainFrame then 
        warn("[GUI] RefreshTheme called but MainFrame doesn't exist")
        return 
    end
    
    local currentTheme = self.Theme:GetTheme()
    print("[GUI] 🎨 Refreshing theme to: " .. self.Theme.CurrentTheme)
    
    -- Refresh Main Frame
    MainFrame.BackgroundColor3 = currentTheme.Colors.MainBackground
    MainFrame.BackgroundTransparency = currentTheme.Transparency.MainBackground
    
    local mainStroke = MainFrame:FindFirstChildOfClass("UIStroke")
    if mainStroke then
        mainStroke.Color = currentTheme.Colors.BorderColor
        mainStroke.Transparency = currentTheme.Transparency.Stroke
    end
    
    -- Refresh Top Bar
    if TopBar then
        TopBar.BackgroundColor3 = currentTheme.Colors.HeaderBackground
        TopBar.BackgroundTransparency = currentTheme.Transparency.Header
        
        -- Refresh accent line
        local accentLine = TopBar:FindFirstChild("AccentLine")
        if accentLine then
            accentLine.BackgroundColor3 = currentTheme.Colors.AccentBar
            accentLine.BackgroundTransparency = currentTheme.Transparency.AccentBar
        end
        
        -- Refresh title text
        local title = TopBar:FindFirstChild("Title")
        if title then
            title.TextColor3 = currentTheme.Colors.TextPrimary
        end
        
        -- Refresh close button
        local closeBtn = TopBar:FindFirstChild("CloseButton")
        if closeBtn then
            closeBtn.BackgroundColor3 = currentTheme.Colors.CloseButton
            closeBtn.BackgroundTransparency = currentTheme.Transparency.CloseButton
            closeBtn.TextColor3 = currentTheme.Colors.TextPrimary
        end
    end
    
    -- Refresh Sidebar
    if Sidebar then
        Sidebar.BackgroundColor3 = currentTheme.Colors.SidebarBackground
        Sidebar.BackgroundTransparency = currentTheme.Transparency.Sidebar
        
        local sidebarStroke = Sidebar:FindFirstChildOfClass("UIStroke")
        if sidebarStroke then
            sidebarStroke.Color = currentTheme.Colors.BorderColor
            sidebarStroke.Transparency = currentTheme.Transparency.Stroke
        end
        
        -- ✅ REFRESH ALL TAB BUTTONS (FIX FOR INSTANT UPDATE)
        if self.TabButtons then
            for tabName, tabBtn in pairs(self.TabButtons) do
                if tabBtn and tabBtn.Parent then
                    -- Check if this tab is currently selected
                    local isSelected = (CurrentPage == tabName)
                    tabBtn.BackgroundColor3 = isSelected and 
                        currentTheme.Colors.TabSelected or 
                        currentTheme.Colors.TabNormal
                    tabBtn.BackgroundTransparency = currentTheme.Transparency.Tab
                    tabBtn.TextColor3 = currentTheme.Colors.TextPrimary
                    
                    -- Update stroke
                    local tabStroke = tabBtn:FindFirstChildOfClass("UIStroke")
                    if tabStroke then
                        tabStroke.Color = currentTheme.Colors.BorderColor
                    end
                end
            end
            print("[GUI] ✅ Sidebar tabs refreshed")
        end
    end
    
    -- Refresh Page Title
    if PageTitle then
        PageTitle.TextColor3 = currentTheme.Colors.TextPrimary
    end
    
    -- Refresh Content Scroll
    if ContentScroll then
        ContentScroll.ScrollBarImageColor3 = currentTheme.Colors.ScrollBarColor
        ContentScroll.ScrollBarImageTransparency = currentTheme.Transparency.ScrollBar
    end
    
    -- Refresh all action rows and their children
    if ContentScroll then
        for _, child in pairs(ContentScroll:GetChildren()) do
            if child:IsA("Frame") then
                -- Container
                child.BackgroundColor3 = currentTheme.Colors.ContainerBackground
                child.BackgroundTransparency = currentTheme.Transparency.Container
                
                local rowStroke = child:FindFirstChildOfClass("UIStroke")
                if rowStroke then
                    rowStroke.Color = currentTheme.Colors.BorderColor
                    rowStroke.Transparency = currentTheme.Transparency.Stroke
                end
                
                -- Update all text labels
                for _, subChild in pairs(child:GetChildren()) do
                    if subChild:IsA("TextLabel") or subChild:IsA("TextButton") then
                        subChild.TextColor3 = currentTheme.Colors.TextPrimary
                    end
                    
                    -- Update inputs
                    if subChild:IsA("TextBox") then
                        subChild.BackgroundColor3 = currentTheme.Colors.InputBackground
                        subChild.BackgroundTransparency = currentTheme.Transparency.Input
                        subChild.TextColor3 = currentTheme.Colors.TextPrimary
                        subChild.PlaceholderColor3 = currentTheme.Colors.TextPlaceholder
                    end
                    
                    -- Update dropdowns
                    if subChild:IsA("ScrollingFrame") then
                        subChild.BackgroundColor3 = currentTheme.Colors.DropdownBackground
                        subChild.BackgroundTransparency = currentTheme.Transparency.Dropdown
                        subChild.ScrollBarImageColor3 = currentTheme.Colors.ScrollBarColor
                        subChild.ScrollBarImageTransparency = currentTheme.Transparency.ScrollBar
                        
                        -- Update dropdown items
                        for _, dropdownItem in pairs(subChild:GetChildren()) do
                            if dropdownItem:IsA("TextButton") then
                                dropdownItem.BackgroundColor3 = currentTheme.Colors.PlayerButtonBg
                                dropdownItem.BackgroundTransparency = currentTheme.Transparency.PlayerButton
                                dropdownItem.TextColor3 = currentTheme.Colors.TextPrimary
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Refresh Toggle Button
    if ToggleButton then
        ToggleButton.BackgroundColor3 = currentTheme.Colors.ToggleButton
        ToggleButton.BackgroundTransparency = currentTheme.Transparency.ToggleButton
    end
    
    -- Refresh Close Prompt if it exists
    if ClosePrompt then
        ClosePrompt.BackgroundColor3 = currentTheme.Colors.MainBackground
        ClosePrompt.BackgroundTransparency = currentTheme.Transparency.MainBackground
        
        local promptStroke = ClosePrompt:FindFirstChildOfClass("UIStroke")
        if promptStroke then
            promptStroke.Color = currentTheme.Colors.AccentBar
        end
    end
    
    -- Show notification
    if self.Modules and self.Modules.Notifications then
        self.Modules.Notifications:Show("Theme", true, self.Theme.CurrentTheme, 2)
    end
    
    print("[GUI] ✅ Theme refreshed successfully")
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

-- Export for global access
getgenv().NullHub_GUI = GUI

print("[GUI] Module loaded v" .. GUI.Version)
return GUI
