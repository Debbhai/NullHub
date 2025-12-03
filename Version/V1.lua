-- ============================================
-- NullHub V1.lua - COMPLETE STANDALONE
-- No GUI.lua dependency
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("NullHubGUI") then
    warn("[NullHub] Already running!")
    return
end

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub - Professional Script Hub")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Module Loader
local function LoadModule(path, name)
    print(string.format("📥 Loading %s...", name))
    local ok, result = pcall(function()
        local code = game:HttpGet(BASE_URL .. path, true)
        if #code < 10 then error("Empty file") end
        local fn = loadstring(code)
        if not fn then error("Loadstring failed") end
        return fn()
    end)
    if ok and result then
        print(string.format("✅ %s loaded", name))
        return result
    else
        warn(string.format("❌ %s failed: %s", name, tostring(result)))
        return nil
    end
end

-- Load modules
print("\n📦 Loading Modules...")
local Theme = LoadModule("Core/Theme.lua", "Theme")
local Config = LoadModule("Core/Config.lua", "Config")
local Notifications = LoadModule("Utility/Notifications.lua", "Notifications")
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

-- Fallback theme/config
if not Theme then
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
    Config = {GUI_TOGGLE_KEY=Enum.KeyCode.Insert,AIMBOT_KEY=Enum.KeyCode.E,ESP_KEY=Enum.KeyCode.T,KILLAURA_KEY=Enum.KeyCode.K,FASTM1_KEY=Enum.KeyCode.M,FLY_KEY=Enum.KeyCode.F,NOCLIP_KEY=Enum.KeyCode.N,INFJUMP_KEY=Enum.KeyCode.J,SPEED_KEY=Enum.KeyCode.X,FULLBRIGHT_KEY=Enum.KeyCode.B,GODMODE_KEY=Enum.KeyCode.V}
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player.PlayerGui

-- Initialize modules
local function Init(mod, ...)
    if mod and mod.Initialize then pcall(function() mod:Initialize(...) end) end
end
Init(Notifications, screenGui, Theme)
Init(Combat.Aimbot, player, camera, Config, nil, Notifications)
Init(Combat.ESP, player, camera, Config, Theme, Notifications)
Init(Combat.KillAura, player, character, Config, nil, Notifications)
Init(Combat.FastM1, player, character, Config, Notifications)
Init(Movement.Fly, player, character, rootPart, camera, Config, Notifications)
Init(Movement.NoClip, player, character, Config, Notifications)
Init(Movement.InfiniteJump, player, humanoid, Config, Notifications)
Init(Movement.Speed, player, humanoid, Config, nil, Notifications)
Init(Movement.WalkOnWater, player, character, rootPart, humanoid, Config, Notifications)
Init(Visual.FullBright, Config, Notifications)
Init(Visual.GodMode, player, humanoid, Config, Notifications)

-- Build GUI
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
title.Text = "⚡ NullHub V1"
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

-- Features
local features = {
    {"Aimbot", "E", "🎯", Combat.Aimbot},
    {"ESP", "T", "👁️", Combat.ESP},
    {"KillAura", "K", "⚔️", Combat.KillAura},
    {"Fast M1", "M", "👊", Combat.FastM1},
    {"Fly", "F", "🕊️", Movement.Fly},
    {"NoClip", "N", "👻", Movement.NoClip},
    {"Infinite Jump", "J", "🦘", Movement.InfiniteJump},
    {"Speed", "X", "⚡", Movement.Speed},
    {"Walk on Water", "U", "🌊", Movement.WalkOnWater},
    {"Full Bright", "B", "💡", Visual.FullBright},
    {"God Mode", "V", "🛡️", Visual.GodMode}
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
            local on = data[4].Enabled or false
            indicator.BackgroundColor3 = on and theme.Colors.StatusOn or theme.Colors.StatusOff
        end)
    else
        label.Text = label.Text .. " [BROKEN]"
    end
end

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Toggle GUI
local vis = true
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        vis = not vis
        local pos = vis and UDim2.new(0.5, -sizes.MainFrameWidth/2, 0.5, -sizes.MainFrameHeight/2) or UDim2.new(0.5, -sizes.MainFrameWidth/2, -1, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Position = pos}):Play()
    end
end)

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 NullHub V1 Loaded!")
print("⌨️ Press [INSERT] to toggle")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
