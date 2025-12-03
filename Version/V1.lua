-- ============================================
-- NullHub V1.lua - Module Loader & Orchestrator
-- Created by Debbhai
-- Version: 1.0.4 (ALL ERRORS FIXED)
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ============================================
-- BULLETPROOF ANTI-DUPLICATE CHECK
-- ============================================
local function isNullHubRunning()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    local gui = playerGui:FindFirstChild("NullHubGUI")
    if gui then
        local mainFrame = gui:FindFirstChild("MainFrame")
        if mainFrame then
            return true
        else
            pcall(function() gui:Destroy() end)
            return false
        end
    end
    return false
end

if isNullHubRunning() then
    warn("[NullHub] ⚠️ NullHub is already running!")
    return
end

-- Clear stale flags
getgenv().NullHubLoaded = nil
getgenv().NullHubCleanup = nil
getgenv().NullHubLoaded = true

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub - Professional Script Hub")
print("🔧 Loading modules...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- ============================================
-- CONFIGURATION
-- ============================================
local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"
local VERSION = "1.0.4"

-- ============================================
-- SERVICES
-- ============================================
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- ============================================
-- MODULE LOADER SYSTEM
-- ============================================
local ModuleLoader = {
    Loaded = {},
    Failed = {},
    TotalModules = 0,
    SuccessCount = 0,
    FailCount = 0
}

function ModuleLoader:Load(path, moduleName)
    moduleName = moduleName or path
    
    if self.Loaded[path] then
        return self.Loaded[path]
    end
    
    self.TotalModules = self.TotalModules + 1
    local url = BASE_URL .. path
    
    print(string.format("📥 Loading %s...", moduleName))
    
    local success, result = pcall(function()
        local code = game:HttpGet(url, true)
        if code and #code > 0 then
            local fn, err = loadstring(code)
            if fn then
                return fn()
            else
                error("Loadstring failed: " .. tostring(err))
            end
        else
            error("Empty response from GitHub")
        end
    end)
    
    if success and result then
        self.Loaded[path] = result
        self.SuccessCount = self.SuccessCount + 1
        print(string.format("✅ %s loaded", moduleName))
        return result
    else
        self.FailCount = self.FailCount + 1
        table.insert(self.Failed, {name = moduleName, error = tostring(result)})
        warn(string.format("❌ Failed to load %s: %s", moduleName, tostring(result)))
        return nil
    end
end

function ModuleLoader:GetStats()
    local total = math.max(self.TotalModules, 1)
    return {
        Total = self.TotalModules,
        Success = self.SuccessCount,
        Failed = self.FailCount,
        Percentage = math.floor((self.SuccessCount / total) * 100)
    }
end

function ModuleLoader:PrintReport()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("📊 Module Loading Report:")
    print(string.format("✅ Loaded: %d/%d modules", self.SuccessCount, self.TotalModules))
    if self.FailCount > 0 then
        warn(string.format("❌ Failed: %d modules", self.FailCount))
        for _, fail in pairs(self.Failed) do
            warn(string.format("   - %s: %s", fail.name, fail.error))
        end
    end
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- ============================================
-- LOAD MODULES
-- ============================================
print("\n[Stage 1/5] Loading Core Modules...")

local Theme = ModuleLoader:Load("Core/Theme.lua", "Theme")
local AntiDetection = ModuleLoader:Load("Core/AntiDetection.lua", "AntiDetection")
local Config = ModuleLoader:Load("Core/Config.lua", "Config")

-- Don't load GUI.lua from GitHub - we'll create GUI inline to avoid the nil error
-- local GUI = ModuleLoader:Load("Core/GUI.lua", "GUI")

if AntiDetection and type(AntiDetection.Initialize) == "function" then
    pcall(function() AntiDetection:Initialize() end)
end

-- Fallback Theme if failed
if not Theme then
    warn("[NullHub] Using fallback theme")
    Theme = {
        CurrentTheme = "Dark",
        Themes = {
            Dark = {
                Colors = {
                    MainBackground = Color3.fromRGB(15, 15, 20),
                    HeaderBackground = Color3.fromRGB(20, 20, 25),
                    SidebarBackground = Color3.fromRGB(18, 18, 22),
                    ContainerBackground = Color3.fromRGB(25, 25, 30),
                    AccentBar = Color3.fromRGB(255, 215, 0),
                    TextPrimary = Color3.fromRGB(255, 255, 255),
                    TextSecondary = Color3.fromRGB(150, 150, 160),
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
                    Container = 0.1,
                    Stroke = 0.5
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
        GetTheme = function(self) return self.Themes[self.CurrentTheme] end,
        GetAllThemeNames = function(self) return {"Dark"} end,
        SetTheme = function(self, name) self.CurrentTheme = name return true end
    }
end

-- Fallback Config if failed
if not Config then
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
        WALKONWATER_KEY = Enum.KeyCode.U,
        Movement = { SPEED = { VALUE = 50 } }
    }
end

print("✅ Core modules loaded")

-- ============================================
-- LOAD UTILITY & FEATURE MODULES
-- ============================================
print("\n[Stage 2/5] Loading Feature Modules...")

local Notifications = ModuleLoader:Load("Utility/Notifications.lua", "Notifications")

local Combat = {}
Combat.Aimbot = ModuleLoader:Load("Combat/Aimbot.lua", "Aimbot")
Combat.ESP = ModuleLoader:Load("Combat/ESP.lua", "ESP")
Combat.KillAura = ModuleLoader:Load("Combat/KillAura.lua", "KillAura")
Combat.FastM1 = ModuleLoader:Load("Combat/FastM1.lua", "FastM1")

local Movement = {}
Movement.Fly = ModuleLoader:Load("Movement/Fly.lua", "Fly")
Movement.NoClip = ModuleLoader:Load("Movement/NoClip.lua", "NoClip")
Movement.InfiniteJump = ModuleLoader:Load("Movement/InfiniteJump.lua", "InfiniteJump")
Movement.Speed = ModuleLoader:Load("Movement/Speed.lua", "Speed")
Movement.WalkOnWater = ModuleLoader:Load("Movement/WalkOnWater.lua", "WalkOnWater")

local Visual = {}
Visual.FullBright = ModuleLoader:Load("Visual/FullBright.lua", "FullBright")
Visual.GodMode = ModuleLoader:Load("Visual/GodMode.lua", "GodMode")

local Teleport = {}
Teleport.TeleportToPlayer = ModuleLoader:Load("Teleport/TeleportToPlayer.lua", "TeleportToPlayer")

print("✅ Feature modules loaded")

-- ============================================
-- CREATE SCREEN GUI
-- ============================================
print("\n[Stage 3/5] Creating GUI...")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ============================================
-- INITIALIZE MODULES
-- ============================================
print("\n[Stage 4/5] Initializing Modules...")

if Notifications and type(Notifications.Initialize) == "function" then
    pcall(function() Notifications:Initialize(screenGui, Theme) end)
end

local function safeInit(module, ...)
    if module and type(module.Initialize) == "function" then
        local success, err = pcall(function() module:Initialize(...) end)
        if not success then
            warn("[NullHub] Init error: " .. tostring(err))
        end
    end
end

safeInit(Combat.Aimbot, player, camera, Config, AntiDetection, Notifications)
safeInit(Combat.ESP, player, camera, Config, Theme, Notifications)
safeInit(Combat.KillAura, player, character, Config, AntiDetection, Notifications)
safeInit(Combat.FastM1, player, character, Config, Notifications)
safeInit(Movement.Fly, player, character, rootPart, camera, Config, Notifications)
safeInit(Movement.NoClip, player, character, Config, Notifications)
safeInit(Movement.InfiniteJump, player, humanoid, Config, Notifications)
safeInit(Movement.Speed, player, humanoid, Config, AntiDetection, Notifications)
safeInit(Movement.WalkOnWater, player, character, rootPart, humanoid, Config, Notifications)
safeInit(Visual.FullBright, Config, Notifications)
safeInit(Visual.GodMode, player, humanoid, Config, Notifications)
safeInit(Teleport.TeleportToPlayer, player, rootPart, Config, Notifications)

print("✅ All modules initialized")

-- ============================================
-- BUILD GUI INLINE (AVOIDS NIL ERROR)
-- ============================================
print("\n[Stage 5/5] Building Interface...")

local currentTheme = Theme:GetTheme()
local sizes = Theme.Sizes
local GuiButtons = {}
local MainFrame, IsVisible = nil, true

-- Create Main Frame
MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, sizes.MainFrameWidth, 0, sizes.MainFrameHeight)
MainFrame.Position = UDim2.new(0.5, -sizes.MainFrameWidth/2, 0.5, -sizes.MainFrameHeight/2)
MainFrame.BackgroundColor3 = currentTheme.Colors.MainBackground
MainFrame.BackgroundTransparency = currentTheme.Transparency.MainBackground
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = screenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, Theme.CornerRadius.Large)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = currentTheme.Colors.BorderColor
mainStroke.Thickness = 1

-- Top Bar
local topBar = Instance.new("Frame", MainFrame)
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, sizes.HeaderHeight)
topBar.BackgroundColor3 = currentTheme.Colors.HeaderBackground
topBar.BackgroundTransparency = currentTheme.Transparency.Header
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, Theme.CornerRadius.Large)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ NullHub V1"
title.TextColor3 = currentTheme.Colors.TextPrimary
title.TextSize = Theme.FontSizes.Title
title.Font = Theme.Fonts.Title
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.BackgroundColor3 = currentTheme.Colors.CloseButton
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Sidebar
local sidebar = Instance.new("Frame", MainFrame)
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, sizes.SidebarWidth, 1, -sizes.HeaderHeight - 10)
sidebar.Position = UDim2.new(0, 5, 0, sizes.HeaderHeight + 5)
sidebar.BackgroundColor3 = currentTheme.Colors.SidebarBackground
sidebar.BackgroundTransparency = currentTheme.Transparency.Sidebar
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, Theme.CornerRadius.Medium)
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 5)
Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 8)
Instance.new("UIPadding", sidebar).PaddingLeft = UDim.new(0, 8)

-- Content Area
local contentFrame = Instance.new("Frame", MainFrame)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -sizes.SidebarWidth - 15, 1, -sizes.HeaderHeight - 10)
contentFrame.Position = UDim2.new(0, sizes.SidebarWidth + 10, 0, sizes.HeaderHeight + 5)
contentFrame.BackgroundTransparency = 1

local contentScroll = Instance.new("ScrollingFrame", contentFrame)
contentScroll.Name = "ContentScroll"
contentScroll.Size = UDim2.new(1, 0, 1, 0)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 4
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", contentScroll).Padding = UDim.new(0, 6)

-- Feature definitions
local features = {
    Combat = {
        {name = "Aimbot", key = "E", state = "aimbot", icon = "🎯", module = Combat.Aimbot},
        {name = "ESP", key = "T", state = "esp", icon = "👁️", module = Combat.ESP},
        {name = "KillAura", key = "K", state = "killaura", icon = "⚔️", module = Combat.KillAura},
        {name = "Fast M1", key = "M", state = "fastm1", icon = "👊", module = Combat.FastM1}
    },
    Movement = {
        {name = "Fly", key = "F", state = "fly", icon = "🕊️", module = Movement.Fly},
        {name = "NoClip", key = "N", state = "noclip", icon = "👻", module = Movement.NoClip},
        {name = "Infinite Jump", key = "J", state = "infjump", icon = "🦘", module = Movement.InfiniteJump},
        {name = "Speed", key = "X", state = "speed", icon = "⚡", module = Movement.Speed},
        {name = "Walk on Water", key = "U", state = "walkonwater", icon = "🌊", module = Movement.WalkOnWater}
    },
    Visual = {
        {name = "Full Bright", key = "B", state = "fullbright", icon = "💡", module = Visual.FullBright},
        {name = "God Mode", key = "V", state = "godmode", icon = "🛡️", module = Visual.GodMode}
    }
}

local currentTab = "Combat"

local function createFeatureRow(parent, feature, index)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -8, 0, sizes.ActionRowHeight)
    row.BackgroundColor3 = currentTheme.Colors.ContainerBackground
    row.BackgroundTransparency = currentTheme.Transparency.Container
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
    label.Text = feature.icon .. " " .. feature.name .. " [" .. feature.key .. "]"
    label.TextColor3 = currentTheme.Colors.TextPrimary
    label.TextSize = Theme.FontSizes.Action
    label.Font = Theme.Fonts.Action
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local indicator = Instance.new("Frame", row)
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, sizes.StatusIndicator, 0, sizes.StatusIndicator)
    indicator.Position = UDim2.new(1, -22, 0.5, -sizes.StatusIndicator/2)
    indicator.BackgroundColor3 = currentTheme.Colors.StatusOff
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    GuiButtons[feature.state] = {button = btn, indicator = indicator, module = feature.module, enabled = false}
    
    btn.MouseButton1Click:Connect(function()
        if feature.module and type(feature.module.Toggle) == "function" then
            pcall(function() feature.module:Toggle() end)
            local isEnabled = feature.module.Enabled or false
            GuiButtons[feature.state].enabled = isEnabled
            indicator.BackgroundColor3 = isEnabled and currentTheme.Colors.StatusOn or currentTheme.Colors.StatusOff
        end
    end)
    
    return row
end

local function loadTab(tabName)
    for _, child in pairs(contentScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local tabFeatures = features[tabName] or {}
    for i, feature in ipairs(tabFeatures) do
        createFeatureRow(contentScroll, feature, i)
    end
    currentTab = tabName
end

-- Create tab buttons
local tabs = {"Combat", "Movement", "Visual"}
for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton", sidebar)
    tabBtn.Size = UDim2.new(1, -16, 0, sizes.TabHeight)
    tabBtn.BackgroundColor3 = currentTheme.Colors.TabNormal
    tabBtn.Text = tabName
    tabBtn.TextColor3 = currentTheme.Colors.TextPrimary
    tabBtn.TextSize = Theme.FontSizes.Tab
    tabBtn.Font = Theme.Fonts.Tab
    tabBtn.LayoutOrder = i
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    
    tabBtn.MouseButton1Click:Connect(function()
        loadTab(tabName)
    end)
end

-- Load initial tab
loadTab("Combat")

-- Toggle visibility
local function toggleGUI()
    IsVisible = not IsVisible
    local targetPos = IsVisible and 
        UDim2.new(0.5, -sizes.MainFrameWidth/2, 0.5, -sizes.MainFrameHeight/2) or
        UDim2.new(0.5, -sizes.MainFrameWidth/2, -1, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = targetPos}):Play()
end

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    -- Cleanup
    pcall(function() screenGui:Destroy() end)
    getgenv().NullHubLoaded = nil
    getgenv().NullHubCleanup = nil
    print("[NullHub] ✅ Destroyed - You can re-execute now")
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleGUI()
    end
    
    for state, data in pairs(GuiButtons) do
        if data.module and type(data.module.Toggle) == "function" then
            local keyName = Config[string.upper(state) .. "_KEY"]
            if keyName and input.KeyCode == keyName then
                pcall(function() data.module:Toggle() end)
                local isEnabled = data.module.Enabled or false
                data.indicator.BackgroundColor3 = isEnabled and currentTheme.Colors.StatusOn or currentTheme.Colors.StatusOff
            end
        end
    end
end)

-- ============================================
-- CLEANUP
-- ============================================
local function cleanup()
    print("[NullHub] 🧹 Cleaning up...")
    pcall(function() screenGui:Destroy() end)
    getgenv().NullHubLoaded = nil
    getgenv().NullHubCleanup = nil
    print("[NullHub] ✅ Cleanup complete")
end

getgenv().NullHubCleanup = cleanup

-- ============================================
-- DONE
-- ============================================
ModuleLoader:PrintReport()

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 NullHub V1 Loaded Successfully!")
print("⌨️ Press [INSERT] to toggle GUI")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

if Notifications and type(Notifications.Success) == "function" then
    pcall(function() Notifications:Success("NullHub V1 Loaded!", 3) end)
end

return {Version = VERSION, Cleanup = cleanup}
