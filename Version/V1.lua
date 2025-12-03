-- ============================================
-- NullHub V1.lua - VERBOSE DIAGNOSTIC
-- ============================================

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub V1 - Verbose Mode")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

print("[1] Getting services...")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
print("✅ Player: " .. player.Name)

print("[2] Checking if already running...")
if player.PlayerGui:FindFirstChild("NullHubGUI") then
    warn("Already running!")
    return
end
print("✅ Not running yet")

print("[3] Setting up base URL...")
local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"
print("✅ URL: " .. BASE_URL)

print("[4] Loading services...")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
print("✅ Services loaded")

print("[5] Getting character...")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
print("✅ Character ready")

-- Module Loader
print("[6] Creating module loader...")
local function LoadModule(path, name)
    print(string.format("   📥 Loading %s...", name))
    
    local ok, result = pcall(function()
        print(string.format("      Downloading from: %s", BASE_URL .. path))
        local code = game:HttpGet(BASE_URL .. path, true)
        print(string.format("      Downloaded %d bytes", #code))
        
        if #code < 10 then 
            error("File too small or empty") 
        end
        
        print("      Running loadstring...")
        local fn = loadstring(code)
        if not fn then 
            error("Loadstring returned nil") 
        end
        
        print("      Executing module...")
        return fn()
    end)
    
    if ok and result then
        print(string.format("   ✅ %s loaded successfully", name))
        return result
    else
        warn(string.format("   ❌ %s FAILED: %s", name, tostring(result)))
        return nil
    end
end

-- Load Core Modules
print("\n[7] Loading Theme.lua...")
local Theme = LoadModule("Core/Theme.lua", "Theme")

print("\n[8] Loading Config.lua...")
local Config = LoadModule("Core/Config.lua", "Config")

print("\n[9] Loading Notifications.lua...")
local Notifications = LoadModule("Utility/Notifications.lua", "Notifications")

-- Fallbacks
if not Theme then
    warn("⚠️ Using fallback theme")
    Theme = {
        CurrentTheme = "Dark",
        Themes = {Dark = {Colors = {MainBackground = Color3.fromRGB(15,15,20), HeaderBackground = Color3.fromRGB(20,20,25), SidebarBackground = Color3.fromRGB(18,18,22), ContainerBackground = Color3.fromRGB(25,25,30), TextPrimary = Color3.fromRGB(255,255,255), StatusOff = Color3.fromRGB(200,60,60), StatusOn = Color3.fromRGB(60,200,100), BorderColor = Color3.fromRGB(50,50,60), CloseButton = Color3.fromRGB(200,60,70), TabNormal = Color3.fromRGB(22,22,28), TabSelected = Color3.fromRGB(35,35,45)}, Transparency = {MainBackground = 0.05, Header = 0.05, Sidebar = 0.1, Container = 0.1}}},
        Sizes = {MainFrameWidth = 650, MainFrameHeight = 420, SidebarWidth = 140, HeaderHeight = 42, TabHeight = 36, ActionRowHeight = 42, StatusIndicator = 12},
        CornerRadius = {Large = 12, Medium = 8, Small = 6},
        Fonts = {Title = Enum.Font.GothamBold, Tab = Enum.Font.GothamMedium, Action = Enum.Font.Gotham},
        FontSizes = {Title = 18, Tab = 14, Action = 13},
        GetTheme = function(self) return self.Themes[self.CurrentTheme] end
    }
end

if not Config then
    warn("⚠️ Using fallback config")
    Config = {GUI_TOGGLE_KEY=Enum.KeyCode.Insert}
end

print("\n[10] Loading feature modules...")
local Combat = {
    Aimbot = LoadModule("Combat/Aimbot.lua", "Aimbot"),
    ESP = LoadModule("Combat/ESP.lua", "ESP"),
    KillAura = LoadModule("Combat/KillAura.lua", "KillAura"),
    FastM1 = LoadModule("Combat/FastM1.lua", "FastM1")
}

local Movement = {
    Fly = LoadModule("Movement/Fly.lua", "Fly"),
    NoClip = LoadModule("Movement/NoClip.lua", "NoClip"),
    InfiniteJump = LoadModule("Movement/InfiniteJump.lua", "InfiniteJump"),
    Speed = LoadModule("Movement/Speed.lua", "Speed"),
    WalkOnWater = LoadModule("Movement/WalkOnWater.lua", "WalkOnWater")
}

local Visual = {
    FullBright = LoadModule("Visual/FullBright.lua", "FullBright"),
    GodMode = LoadModule("Visual/GodMode.lua", "GodMode")
}

print("\n[11] Creating ScreenGui...")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player.PlayerGui
print("✅ ScreenGui created")

print("\n[12] Initializing modules...")
local function Init(mod, name, ...)
    if not mod then 
        warn(string.format("   ⏭️ Skipping %s (nil)", name))
        return 
    end
    
    if type(mod.Initialize) ~= "function" then
        warn(string.format("   ⏭️ Skipping %s (no Initialize)", name))
        return
    end
    
    print(string.format("   🔧 Initializing %s...", name))
    local ok, err = pcall(function() mod:Initialize(...) end)
    if ok then
        print(string.format("   ✅ %s initialized", name))
    else
        warn(string.format("   ❌ %s init failed: %s", name, tostring(err)))
    end
end

Init(Notifications, "Notifications", screenGui, Theme)
Init(Combat.Aimbot, "Aimbot", player, camera, Config, nil, Notifications)
Init(Combat.ESP, "ESP", player, camera, Config, Theme, Notifications)
Init(Movement.Fly, "Fly", player, character, rootPart, camera, Config, Notifications)
Init(Movement.Speed, "Speed", player, humanoid, Config, nil, Notifications)
Init(Visual.FullBright, "FullBright", Config, Notifications)

print("\n[13] Building GUI...")
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
print("✅ MainFrame created")

local topBar = Instance.new("Frame", MainFrame)
topBar.Size = UDim2.new(1, 0, 0, sizes.HeaderHeight)
topBar.BackgroundColor3 = theme.Colors.HeaderBackground
topBar.BackgroundTransparency = theme.Transparency.Header

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ NullHub V1 [VERBOSE]"
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

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

print("✅ GUI created")

print("\n[14] Setting up toggle keybind...")
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 NullHub V1 Loaded Successfully!")
print("⌨️ Press [INSERT] to toggle GUI")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
