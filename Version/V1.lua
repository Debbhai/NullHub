-- ============================================
-- NullHub V1.lua - FULL DEBUG VERSION
-- Created by Debbhai
-- Version: 1.0.6 (Maximum Error Detection)
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ============================================
-- ANTI-DUPLICATE CHECK
-- ============================================
local function isRunning()
    local gui = player.PlayerGui:FindFirstChild("NullHubGUI")
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
print("⚡ NullHub V1.0.6 - Debug Mode")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- ============================================
-- CONFIG
-- ============================================
local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"
local VERSION = "1.0.6"

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
-- ADVANCED DEBUG LOADER
-- ============================================
local function DebugLoadModule(path, name)
    print(string.format("📥 [DEBUG] Loading %s from %s...", name, path))
    
    -- Step 1: Download
    local downloadSuccess, code = pcall(function()
        return game:HttpGet(BASE_URL .. path, true)
    end)
    
    if not downloadSuccess then
        warn(string.format("❌ [%s] Download failed: %s", name, tostring(code)))
        return nil
    end
    
    print(string.format("   [%s] Downloaded %d bytes", name, #code))
    
    if not code or #code < 10 then
        warn(string.format("❌ [%s] File is empty or too small", name))
        return nil
    end
    
    -- Step 2: Loadstring
    local loadSuccess, loadResult = pcall(function()
        return loadstring(code)
    end)
    
    if not loadSuccess or not loadResult then
        warn(string.format("❌ [%s] Loadstring failed: %s", name, tostring(loadResult)))
        warn(string.format("   First 200 chars of code: %s", code:sub(1, 200)))
        return nil
    end
    
    print(string.format("   [%s] Loadstring successful", name))
    
    -- Step 3: Execute the loaded function
    local execSuccess, module = pcall(loadResult)
    
    if not execSuccess then
        warn(string.format("❌ [%s] Execution failed: %s", name, tostring(module)))
        warn(string.format("   This means the module has a runtime error!"))
        
        -- Try to extract error line
        local errorMsg = tostring(module)
        local lineNum = errorMsg:match(":(%d+):")
        if lineNum then
            warn(string.format("   ERROR AT LINE: %s", lineNum))
        end
        
        return nil
    end
    
    -- Step 4: Validate module
    if type(module) ~= "table" then
        warn(string.format("❌ [%s] Module didn't return a table (got %s)", name, type(module)))
        return nil
    end
    
    print(string.format("✅ [%s] Loaded successfully", name))
    
    -- Debug: Print module functions
    local funcCount = 0
    for key, value in pairs(module) do
        if type(value) == "function" then
            funcCount = funcCount + 1
        end
    end
    print(string.format("   [%s] Has %d functions", name, funcCount))
    
    return module
end

-- ============================================
-- LOAD CORE MODULES WITH DEBUG
-- ============================================
print("\n📦 Loading Core Modules...")

local Theme = DebugLoadModule("Core/Theme.lua", "Theme")
local Config = DebugLoadModule("Core/Config.lua", "Config")
local AntiDetection = DebugLoadModule("Core/AntiDetection.lua", "AntiDetection")
local Notifications = DebugLoadModule("Utility/Notifications.lua", "Notifications")

-- ============================================
-- FALLBACKS
-- ============================================
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
-- LOAD FEATURE MODULES WITH DEBUG
-- ============================================
print("\n📦 Loading Feature Modules...")

local Combat = {
    Aimbot = DebugLoadModule("Combat/Aimbot.lua", "Aimbot"),
    ESP = DebugLoadModule("Combat/ESP.lua", "ESP"),
    KillAura = DebugLoadModule("Combat/KillAura.lua", "KillAura"),
    FastM1 = DebugLoadModule("Combat/FastM1.lua", "FastM1")
}

local Movement = {
    Fly = DebugLoadModule("Movement/Fly.lua", "Fly"),
    NoClip = DebugLoadModule("Movement/NoClip.lua", "NoClip"),
    InfiniteJump = DebugLoadModule("Movement/InfiniteJump.lua", "InfiniteJump"),
    Speed = DebugLoadModule("Movement/Speed.lua", "Speed"),
    WalkOnWater = DebugLoadModule("Movement/WalkOnWater.lua", "WalkOnWater")
}

local Visual = {
    FullBright = DebugLoadModule("Visual/FullBright.lua", "FullBright"),
    GodMode = DebugLoadModule("Visual/GodMode.lua", "GodMode")
}

-- ============================================
-- CREATE GUI
-- ============================================
print("\n🎨 Creating GUI...")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player.PlayerGui

-- Initialize modules safely
local function SafeInit(module, name, ...)
    if not module then
        warn(string.format("[%s] Skipped - module is nil", name))
        return
    end
    
    if type(module.Initialize) ~= "function" then
        warn(string.format("[%s] Skipped - no Initialize function", name))
        return
    end
    
    local success, err = pcall(function()
        module:Initialize(...)
    end)
    
    if success then
        print(string.format("✅ [%s] Initialized", name))
    else
        warn(string.format("❌ [%s] Init failed: %s", name, tostring(err)))
    end
end

print("\n🔧 Initializing Modules...")

SafeInit(Notifications, "Notifications", screenGui, Theme)
SafeInit(AntiDetection, "AntiDetection")
SafeInit(Combat.Aimbot, "Aimbot", player, camera, Config, AntiDetection, Notifications)
SafeInit(Combat.ESP, "ESP", player, camera, Config, Theme, Notifications)
SafeInit(Combat.KillAura, "KillAura", player, character, Config, AntiDetection, Notifications)
SafeInit(Combat.FastM1, "FastM1", player, character, Config, Notifications)
SafeInit(Movement.Fly, "Fly", player, character, rootPart, camera, Config, Notifications)
SafeInit(Movement.NoClip, "NoClip", player, character, Config, Notifications)
SafeInit(Movement.InfiniteJump, "InfiniteJump", player, humanoid, Config, Notifications)
SafeInit(Movement.Speed, "Speed", player, humanoid, Config, AntiDetection, Notifications)
SafeInit(Movement.WalkOnWater, "WalkOnWater", player, character, rootPart, humanoid, Config, Notifications)
SafeInit(Visual.FullBright, "FullBright", Config, Notifications)
SafeInit(Visual.GodMode, "GodMode", player, humanoid, Config, Notifications)

-- ============================================
-- BUILD SIMPLE GUI
-- ============================================
local theme = Theme:GetTheme()
local sizes = Theme.Sizes

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

local topBar = Instance.new("Frame", MainFrame)
topBar.Size = UDim2.new(1, 0, 0, sizes.HeaderHeight)
topBar.BackgroundColor3 = theme.Colors.HeaderBackground
topBar.BackgroundTransparency = theme.Transparency.Header
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, Theme.CornerRadius.Large)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ NullHub V1.0.6 [DEBUG]"
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

local content = Instance.new("ScrollingFrame", MainFrame)
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", content).Padding = UDim.new(0, 6)

-- Create feature buttons
local features = {
    {"Aimbot", "E", "🎯", Combat.Aimbot},
    {"ESP", "T", "👁️", Combat.ESP},
    {"KillAura", "K", "⚔️", Combat.KillAura},
    {"Fast M1", "M", "👊", Combat.FastM1},
    {"Fly", "F", "🕊️", Movement.Fly},
    {"NoClip", "N", "👻", Movement.NoClip},
    {"Inf Jump", "J", "🦘", Movement.InfiniteJump},
    {"Speed", "X", "⚡", Movement.Speed},
    {"Walk Water", "U", "🌊", Movement.WalkOnWater},
    {"FullBright", "B", "💡", Visual.FullBright},
    {"GodMode", "V", "🛡️", Visual.GodMode}
}

for i, data in ipairs(features) do
    local row = Instance.new("Frame", content)
    row.Size = UDim2.new(1, -8, 0, sizes.ActionRowHeight)
    row.BackgroundColor3 = theme.Colors.ContainerBackground
    row.BackgroundTransparency = theme.Transparency.Container
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, Theme.CornerRadius.Small)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = data[3] .. " " .. data[1] .. " [" .. data[2] .. "]"
    label.TextColor3 = theme.Colors.TextPrimary
    label.TextSize = Theme.FontSizes.Action
    label.Font = Theme.Fonts.Action
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local indicator = Instance.new("Frame", row)
    indicator.Size = UDim2.new(0, sizes.StatusIndicator, 0, sizes.StatusIndicator)
    indicator.Position = UDim2.new(1, -22, 0.5, -sizes.StatusIndicator/2)
    indicator.BackgroundColor3 = theme.Colors.StatusOff
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    if data[4] and type(data[4].Toggle) == "function" then
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        
        btn.MouseButton1Click:Connect(function()
            pcall(function() data[4]:Toggle() end)
            local enabled = data[4].Enabled or false
            indicator.BackgroundColor3 = enabled and theme.Colors.StatusOn or theme.Colors.StatusOff
        end)
    else
        label.Text = label.Text .. " [BROKEN]"
        label.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    pcall(function() screenGui:Destroy() end)
    getgenv().NullHubLoaded = nil
    getgenv().NullHubCleanup = nil
end)

-- Toggle GUI
local IsVisible = true
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        IsVisible = not IsVisible
        local pos = IsVisible and 
            UDim2.new(0.5, -sizes.MainFrameWidth/2, 0.5, -sizes.MainFrameHeight/2) or
            UDim2.new(0.5, -sizes.MainFrameWidth/2, -1, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Position = pos}):Play()
    end
end)

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 NullHub V1.0.6 Loaded!")
print("📋 Check console for module errors")
print("⌨️ Press [INSERT] to toggle")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
