-- ============================================
-- NullHub V1.lua - BULLETPROOF VERSION
-- Created by Debbhai
-- Version: 1.0.5 (FAIL-SAFE)
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ============================================
-- ANTI-DUPLICATE CHECK
-- ============================================
local function isRunning()
    local gui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("NullHubGUI")
    if gui and gui:FindFirstChild("MainFrame") then
        return true
    end
    if gui then pcall(function() gui:Destroy() end) end
    return false
end

if isRunning() then
    warn("[NullHub] ⚠️ Already running!")
    return
end

getgenv().NullHubLoaded = nil
getgenv().NullHubCleanup = nil
getgenv().NullHubLoaded = true

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub - Professional Script Hub")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- ============================================
-- CONFIG
-- ============================================
local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"
local VERSION = "1.0.5"

-- ============================================
-- SERVICES
-- ============================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- ============================================
-- SAFE MODULE LOADER
-- ============================================
local function SafeLoadModule(path, name)
    print(string.format("📥 Loading %s...", name))
    
    local success, result = pcall(function()
        local code = game:HttpGet(BASE_URL .. path, true)
        if not code or #code < 10 then
            error("Empty or invalid response")
        end
        
        local loadFunc, loadErr = loadstring(code)
        if not loadFunc then
            error("Loadstring error: " .. tostring(loadErr))
        end
        
        local module = loadFunc()
        
        -- Validate module is a table
        if type(module) ~= "table" then
            error("Module didn't return a table")
        end
        
        return module
    end)
    
    if success and result then
        print(string.format("✅ %s loaded", name))
        return result
    else
        warn(string.format("❌ %s failed: %s", name, tostring(result)))
        return nil
    end
end

-- ============================================
-- LOAD CORE MODULES (WITH FALLBACKS)
-- ============================================
print("\n📦 Loading Core Modules...")

local Theme = SafeLoadModule("Core/Theme.lua", "Theme")
local Config = SafeLoadModule("Core/Config.lua", "Config")
local AntiDetection = SafeLoadModule("Core/AntiDetection.lua", "AntiDetection")
local Notifications = SafeLoadModule("Utility/Notifications.lua", "Notifications")

-- Fallback Theme
if not Theme then
    warn("⚠️ Using fallback theme")
    Theme = {
        CurrentTheme = "Dark",
        Themes = {
            Dark = {
                Colors = {
                    MainBackground = Color3.fromRGB(15, 15, 20),
                    HeaderBackground = Color3.fromRGB(20, 20, 25),
                    SidebarBackground = Color3.fromRGB(18, 18, 22),
                    ContainerBackground = Color3.fromRGB(25, 25, 30),
                    TextPrimary = Color3.fromRGB(255, 255, 255),
                    StatusOff = Color3.fromRGB(200, 60, 60),
                    StatusOn = Color3.fromRGB(60, 200, 100),
                    BorderColor = Color3.fromRGB(50, 50, 60),
                    CloseButton = Color3.fromRGB(200, 60, 70),
                    TabNormal = Color3.fromRGB(22, 22, 28),
                    TabSelected = Color3.fromRGB(35, 35, 45)
                },
                Transparency = {
                    MainBackground = 0.05,
                    Header = 0.05,
                    Sidebar = 0.1,
                    Container = 0.1
                }
            }
        },
        Sizes = {
            MainFrameWidth = 650,
            MainFrameHeight = 420,
            SidebarWidth = 140,
            HeaderHeight = 42,
            TabHeight = 36,
            ActionRowHeight = 42,
            StatusIndicator = 12
        },
        CornerRadius = { Large = 12, Medium = 8, Small = 6 },
        Fonts = { Title = Enum.Font.GothamBold, Tab = Enum.Font.GothamMedium, Action = Enum.Font.Gotham },
        FontSizes = { Title = 18, Tab = 14, Action = 13 },
        GetTheme = function(self) return self.Themes[self.CurrentTheme] end
    }
end

-- Fallback Config
if not Config then
    warn("⚠️ Using fallback config")
    Config = {
        GUI_TOGGLE_KEY = Enum.KeyCode.Insert,
        AIMBOT_KEY = Enum.KeyCode.E,
        ESP_KEY = Enum.KeyCode.T,
        KILLAURA_KEY = Enum.KeyCode.K,
        FASTM1_KEY = Enum.KeyCode.M,
        FLY_KEY = Enum.KeyCode.F,
        NOCLIP_KEY = Enum.KeyCode.N,
        INFJUMP_KEY = Enum.KeyCode.J,
        SPEED_KEY = Enum.KeyCode.X,
        FULLBRIGHT_KEY = Enum.KeyCode.B,
        GODMODE_KEY = Enum.KeyCode.V,
        TELEPORT_KEY = Enum.KeyCode.Z,
        WALKONWATER_KEY = Enum.KeyCode.U
    }
end

-- ============================================
-- LOAD FEATURE MODULES (SKIP IF BROKEN)
-- ============================================
print("\n📦 Loading Feature Modules...")

local Combat = {
    Aimbot = SafeLoadModule("Combat/Aimbot.lua", "Aimbot"),
    ESP = SafeLoadModule("Combat/ESP.lua", "ESP"),
    KillAura = SafeLoadModule("Combat/KillAura.lua", "KillAura"),
    FastM1 = SafeLoadModule("Combat/FastM1.lua", "FastM1")
}

local Movement = {
    Fly = SafeLoadModule("Movement/Fly.lua", "Fly"),
    NoClip = SafeLoadModule("Movement/NoClip.lua", "NoClip"),
    InfiniteJump = SafeLoadModule("Movement/InfiniteJump.lua", "InfiniteJump"),
    Speed = SafeLoadModule("Movement/Speed.lua", "Speed"),
    WalkOnWater = SafeLoadModule("Movement/WalkOnWater.lua", "WalkOnWater")
}

local Visual = {
    FullBright = SafeLoadModule("Visual/FullBright.lua", "FullBright"),
    GodMode = SafeLoadModule("Visual/GodMode.lua", "GodMode")
}

print("✅ Modules loaded")

-- ============================================
-- CREATE GUI
-- ============================================
print("\n🎨 Creating GUI...")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player.PlayerGui

-- Initialize Notifications
if Notifications and Notifications.Initialize then
    pcall(function() Notifications:Initialize(screenGui, Theme) end)
end

-- Initialize AntiDetection
if AntiDetection and AntiDetection.Initialize then
    pcall(function() AntiDetection:Initialize() end)
end

-- Safe Initialize
local function SafeInit(module, ...)
    if not module or type(module.Initialize) ~= "function" then return end
    local ok, err = pcall(function() module:Initialize(...) end)
    if not ok then warn("Init failed: " .. tostring(err)) end
end

-- Initialize all modules
SafeInit(Combat.Aimbot, player, camera, Config, AntiDetection, Notifications)
SafeInit(Combat.ESP, player, camera, Config, Theme, Notifications)
SafeInit(Combat.KillAura, player, character, Config, AntiDetection, Notifications)
SafeInit(Combat.FastM1, player, character, Config, Notifications)
SafeInit(Movement.Fly, player, character, rootPart, camera, Config, Notifications)
SafeInit(Movement.NoClip, player, character, Config, Notifications)
SafeInit(Movement.InfiniteJump, player, humanoid, Config, Notifications)
SafeInit(Movement.Speed, player, humanoid, Config, AntiDetection, Notifications)
SafeInit(Movement.WalkOnWater, player, character, rootPart, humanoid, Config, Notifications)
SafeInit(Visual.FullBright, Config, Notifications)
SafeInit(Visual.GodMode, player, humanoid, Config, Notifications)

-- ============================================
-- BUILD GUI
-- ============================================
local theme = Theme:GetTheme()
local sizes = Theme.Sizes
local GuiButtons = {}
local IsVisible = true

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, sizes.MainFrameWidth, 0, sizes.MainFrameHeight)
MainFrame.Position = UDim2.new(0.5, -sizes.MainFrameWidth/2, 0.5, -sizes.MainFrameHeight/2)
MainFrame.BackgroundColor3 = theme.Colors.MainBackground
MainFrame.BackgroundTransparency = theme.Transparency.MainBackground
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = screenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, Theme.CornerRadius.Large)
Instance.new("UIStroke", MainFrame).Color = theme.Colors.BorderColor

-- Top Bar
local topBar = Instance.new("Frame", MainFrame)
topBar.Size = UDim2.new(1, 0, 0, sizes.HeaderHeight)
topBar.BackgroundColor3 = theme.Colors.HeaderBackground
topBar.BackgroundTransparency = theme.Transparency.Header
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, Theme.CornerRadius.Large)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ NullHub V1.0.5"
title.TextColor3 = theme.Colors.TextPrimary
title.TextSize = Theme.FontSizes.Title
title.Font = Theme.Fonts.Title
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.BackgroundColor3 = theme.Colors.CloseButton
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Sidebar
local sidebar = Instance.new("Frame", MainFrame)
sidebar.Size = UDim2.new(0, sizes.SidebarWidth, 1, -sizes.HeaderHeight - 10)
sidebar.Position = UDim2.new(0, 5, 0, sizes.HeaderHeight + 5)
sidebar.BackgroundColor3 = theme.Colors.SidebarBackground
sidebar.BackgroundTransparency = theme.Transparency.Sidebar
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 5)
local pad = Instance.new("UIPadding", sidebar)
pad.PaddingTop = UDim.new(0, 8)
pad.PaddingLeft = UDim.new(0, 8)
pad.PaddingRight = UDim.new(0, 8)

-- Content
local contentFrame = Instance.new("Frame", MainFrame)
contentFrame.Size = UDim2.new(1, -sizes.SidebarWidth - 15, 1, -sizes.HeaderHeight - 10)
contentFrame.Position = UDim2.new(0, sizes.SidebarWidth + 10, 0, sizes.HeaderHeight + 5)
contentFrame.BackgroundTransparency = 1

local contentScroll = Instance.new("ScrollingFrame", contentFrame)
contentScroll.Size = UDim2.new(1, 0, 1, 0)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 4
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", contentScroll).Padding = UDim.new(0, 6)

-- Feature rows
local function createRow(parent, name, key, icon, module, index)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -8, 0, sizes.ActionRowHeight)
    row.BackgroundColor3 = theme.Colors.ContainerBackground
    row.BackgroundTransparency = theme.Transparency.Container
    row.LayoutOrder = index
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. name .. " [" .. key .. "]"
    label.TextColor3 = theme.Colors.TextPrimary
    label.TextSize = Theme.FontSizes.Action
    label.Font = Theme.Fonts.Action
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local indicator = Instance.new("Frame", row)
    indicator.Size = UDim2.new(0, sizes.StatusIndicator, 0, sizes.StatusIndicator)
    indicator.Position = UDim2.new(1, -22, 0.5, -sizes.StatusIndicator/2)
    indicator.BackgroundColor3 = theme.Colors.StatusOff
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    -- Only create button if module exists
    if module and type(module.Toggle) == "function" then
        GuiButtons[name] = {btn = btn, ind = indicator, mod = module}
        btn.MouseButton1Click:Connect(function()
            pcall(function() module:Toggle() end)
            local enabled = module.Enabled or false
            indicator.BackgroundColor3 = enabled and theme.Colors.StatusOn or theme.Colors.StatusOff
        end)
    else
        label.Text = label.Text .. " [BROKEN]"
        label.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
    
    return row
end

-- Features
local features = {
    Combat = {
        {"Aimbot", "E", "🎯", Combat.Aimbot},
        {"ESP", "T", "👁️", Combat.ESP},
        {"KillAura", "K", "⚔️", Combat.KillAura},
        {"Fast M1", "M", "👊", Combat.FastM1}
    },
    Movement = {
        {"Fly", "F", "🕊️", Movement.Fly},
        {"NoClip", "N", "👻", Movement.NoClip},
        {"Infinite Jump", "J", "🦘", Movement.InfiniteJump},
        {"Speed", "X", "⚡", Movement.Speed},
        {"Walk on Water", "U", "🌊", Movement.WalkOnWater}
    },
    Visual = {
        {"Full Bright", "B", "💡", Visual.FullBright},
        {"God Mode", "V", "🛡️", Visual.GodMode}
    }
}

local function loadTab(tabName)
    for _, child in pairs(contentScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local list = features[tabName] or {}
    for i, data in ipairs(list) do
        createRow(contentScroll, data[1], data[2], data[3], data[4], i)
    end
end

-- Tab buttons
local tabButtons = {}
for i, tabName in ipairs({"Combat", "Movement", "Visual"}) do
    local tab = Instance.new("TextButton", sidebar)
    tab.Size = UDim2.new(1, -16, 0, sizes.TabHeight)
    tab.BackgroundColor3 = theme.Colors.TabNormal
    tab.Text = tabName
    tab.TextColor3 = theme.Colors.TextPrimary
    tab.TextSize = Theme.FontSizes.Tab
    tab.Font = Theme.Fonts.Tab
    tab.LayoutOrder = i
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    
    tab.MouseButton1Click:Connect(function()
        for _, other in pairs(tabButtons) do
            other.BackgroundColor3 = theme.Colors.TabNormal
        end
        tab.BackgroundColor3 = theme.Colors.TabSelected
        loadTab(tabName)
    end)
    
    tabButtons[tabName] = tab
end

tabButtons["Combat"].BackgroundColor3 = theme.Colors.TabSelected
loadTab("Combat")

-- Toggle GUI
local function toggleGUI()
    IsVisible = not IsVisible
    local pos = IsVisible and 
        UDim2.new(0.5, -sizes.MainFrameWidth/2, 0.5, -sizes.MainFrameHeight/2) or
        UDim2.new(0.5, -sizes.MainFrameWidth/2, -1, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Position = pos}):Play()
end

-- Close
closeBtn.MouseButton1Click:Connect(function()
    pcall(function() screenGui:Destroy() end)
    getgenv().NullHubLoaded = nil
    getgenv().NullHubCleanup = nil
    print("[NullHub] ✅ Destroyed")
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.Insert then toggleGUI() end
    
    for _, data in pairs(GuiButtons) do
        if data.mod and type(data.mod.Toggle) == "function" then
            -- Check each config key
            for cfgKey, keyCode in pairs(Config) do
                if type(keyCode) == "EnumItem" and keyCode == input.KeyCode then
                    pcall(function() data.mod:Toggle() end)
                    local enabled = data.mod.Enabled or false
                    data.ind.BackgroundColor3 = enabled and theme.Colors.StatusOn or theme.Colors.StatusOff
                end
            end
        end
    end
end)

-- Cleanup
getgenv().NullHubCleanup = function()
    pcall(function() screenGui:Destroy() end)
    getgenv().NullHubLoaded = nil
    getgenv().NullHubCleanup = nil
end

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 NullHub V1.0.5 Loaded!")
print("⌨️ Press [INSERT] to toggle")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

if Notifications and Notifications.Success then
    pcall(function() Notifications:Success("NullHub Loaded!", 2) end)
end
