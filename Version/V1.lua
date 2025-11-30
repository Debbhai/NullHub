-- ============================================
-- NullHub V1.lua - Module Loader FINAL
-- Created by Debbhai
-- Version: 1.0.3 FINAL
-- With Theme-GUI instant refresh integration
-- ============================================

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub V1 - Module Loader")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"
local VERSION = "1.0.3"

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Module Loader System
local ModuleLoader = {
    Loaded = {},
    Failed = {},
    TotalModules = 0,
    SuccessCount = 0
}

function ModuleLoader:Load(path, name)
    if self.Loaded[path] then
        return self.Loaded[path]
    end
    
    self.TotalModules = self.TotalModules + 1
    print(string.format("📥 Loading %s...", name))
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BASE_URL .. path, true))()
    end)
    
    if success and result then
        self.Loaded[path] = result
        self.SuccessCount = self.SuccessCount + 1
        print(string.format("✅ %s loaded", name))
        return result
    else
        table.insert(self.Failed, {name = name, error = tostring(result)})
        warn(string.format("❌ %s failed: %s", name, tostring(result)))
        return nil
    end
end

function ModuleLoader:PrintReport()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print(string.format("✅ Loaded: %d/%d modules", self.SuccessCount, self.TotalModules))
    if #self.Failed > 0 then
        warn("❌ Failed modules:")
        for _, fail in pairs(self.Failed) do
            warn(" - " .. fail.name)
        end
    end
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- STAGE 1: Load Core Modules
print("\n[1/5] Loading Core...")
local Theme = ModuleLoader:Load("Core/Theme.lua", "Theme")
local AntiDetection = ModuleLoader:Load("Core/AntiDetection.lua", "AntiDetection")
local Config = ModuleLoader:Load("Core/Config.lua", "Config")
local GUI = ModuleLoader:Load("Core/GUI.lua", "GUI")

if AntiDetection then
    AntiDetection:Initialize()
end

-- CRITICAL: Check Theme
if not Theme then
    warn("[V1] Theme failed - creating fallback")
    Theme = {
        CurrentTheme = "Dark",
        Colors = {
            NotificationBg = Color3.fromRGB(15, 15, 18),
            AccentBar = Color3.fromRGB(255, 215, 0),
            TextPrimary = Color3.fromRGB(255, 255, 255)
        },
        Transparency = {Notification = 0.1},
        Sizes = {NotificationWidth = 300, NotificationHeight = 60},
        CornerRadius = {Medium = 10},
        FontSizes = {Action = 14},
        Fonts = {Action = Enum.Font.Gotham},
        GetTheme = function(self) return self end,
        SetTheme = function(self, name) return false end,
        RegisterGUI = function(self, gui) end
    }
end

-- CRITICAL: Check Config
if not Config then
    warn("[V1] Config failed - creating fallback")
    Config = {
        Combat = {}, Movement = {}, Visual = {}, Teleport = {},
        AntiDetection = {STEALTH_MODE = true}
    }
end

-- STAGE 2: Load Utilities
print("\n[2/5] Loading Utilities...")
local Notifications = ModuleLoader:Load("Utility/Notifications.lua", "Notifications")

-- STAGE 3: Load Features
print("\n[3/5] Loading Features...")

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

-- STAGE 4: Initialize
print("\n[4/5] Initializing...")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Initialize Notifications with safe Theme
if Notifications then
    local success = pcall(function()
        Notifications:Initialize(screenGui, Theme)
    end)
    if not success then
        warn("[V1] Notifications initialization failed")
    end
end

-- Initialize Combat
if Combat.Aimbot then 
    pcall(function() Combat.Aimbot:Initialize(player, camera, Config, AntiDetection, Notifications) end)
end
if Combat.ESP then 
    pcall(function() Combat.ESP:Initialize(player, camera, Config, Theme, Notifications) end)
end
if Combat.KillAura then 
    pcall(function() Combat.KillAura:Initialize(player, character, Config, AntiDetection, Notifications) end)
end
if Combat.FastM1 then 
    pcall(function() Combat.FastM1:Initialize(player, character, Config, Notifications) end)
end

-- Initialize Movement
if Movement.Fly then 
    pcall(function() Movement.Fly:Initialize(player, character, rootPart, camera, Config, Notifications) end)
end
if Movement.NoClip then 
    pcall(function() Movement.NoClip:Initialize(player, character, Config, Notifications) end)
end
if Movement.InfiniteJump then 
    pcall(function() Movement.InfiniteJump:Initialize(player, humanoid, Config, Notifications) end)
end
if Movement.Speed then 
    pcall(function() Movement.Speed:Initialize(player, humanoid, Config, AntiDetection, Notifications) end)
end
if Movement.WalkOnWater then 
    pcall(function() Movement.WalkOnWater:Initialize(player, character, rootPart, humanoid, Config, Notifications) end)
end

-- Initialize Visual
if Visual.FullBright then 
    pcall(function() Visual.FullBright:Initialize(Config, Notifications) end)
end
if Visual.GodMode then 
    pcall(function() Visual.GodMode:Initialize(player, humanoid, Config, Notifications) end)
end

-- Initialize Teleport
if Teleport.TeleportToPlayer then 
    pcall(function() Teleport.TeleportToPlayer:Initialize(player, rootPart, Config, Notifications) end)
end

print("✅ All modules initialized")

-- STAGE 5: Create GUI
print("\n[5/5] Creating GUI...")

-- Store modules globally for debugging
getgenv().NullHub_Combat = Combat
getgenv().NullHub_Movement = Movement
getgenv().NullHub_Visual = Visual
getgenv().NullHub_Teleport = Teleport
getgenv().NullHub_Theme = Theme
getgenv().NullHub_GUI = GUI

if GUI then
    local guiSuccess = pcall(function()
        -- Initialize GUI
        GUI:Initialize(screenGui, Theme, Config)
        
        -- ✅ REGISTER GUI WITH THEME FOR INSTANT REFRESH
        if Theme and Theme.RegisterGUI then
            Theme:RegisterGUI(GUI)
            print("[V1] ✅ Theme-GUI connection established")
        end
        
        -- Prepare modules
        local modules = {
            Combat = Combat,
            Movement = Movement,
            Visual = Visual,
            Teleport = Teleport,
            Notifications = Notifications
        }
        
        print("[V1] Registering modules with GUI...")
        print("  Combat modules: " .. (Combat.Aimbot and "✅" or "❌"))
        print("  Movement modules: " .. (Movement.Fly and "✅" or "❌"))
        print("  Visual modules: " .. (Visual.FullBright and "✅" or "❌"))
        print("  Teleport modules: " .. (Teleport.TeleportToPlayer and "✅" or "❌"))
        
        -- Register modules
        GUI:RegisterModules(modules)
        
        -- Create GUI
        GUI:Create()
        
        -- Connect buttons and keybinds
        GUI:ConnectButtons()
        GUI:ConnectKeybinds()
    end)
    
    if guiSuccess then
        print("✅ GUI created and connected")
    else
        warn("❌ GUI creation failed")
    end
else
    warn("❌ GUI module failed to load")
end

-- Character Respawn Handler
player.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    character, humanoid, rootPart = newChar, newChar:WaitForChild("Humanoid"), newChar:WaitForChild("HumanoidRootPart")
    
    -- Update all feature modules
    local allModules = {
        Combat.Aimbot, Combat.ESP, Combat.KillAura, Combat.FastM1,
        Movement.Fly, Movement.NoClip, Movement.InfiniteJump, Movement.Speed, Movement.WalkOnWater,
        Visual.GodMode,
        Teleport.TeleportToPlayer
    }
    
    for _, module in pairs(allModules) do
        if module and module.OnRespawn then
            pcall(function() 
                module:OnRespawn(character, humanoid, rootPart) 
            end)
        end
    end
    
    print("[V1] 🔄 All modules updated for respawn")
end)

-- Cleanup Function
local function cleanup()
    print("[V1] 🧹 Cleaning up...")
    
    -- Destroy all modules
    for _, category in pairs({Combat, Movement, Visual, Teleport}) do
        for _, module in pairs(category) do
            if module and module.Destroy then
                pcall(function() module:Destroy() end)
            end
        end
    end
    
    -- Destroy GUI
    if screenGui then
        screenGui:Destroy()
    end
    
    -- Clear global references
    getgenv().NullHub_Combat = nil
    getgenv().NullHub_Movement = nil
    getgenv().NullHub_Visual = nil
    getgenv().NullHub_Teleport = nil
    getgenv().NullHub_Theme = nil
    getgenv().NullHub_GUI = nil
    getgenv().NullHubCleanup = nil
    
    print("[V1] ✅ Cleanup complete")
end

-- Print Module Load Report
ModuleLoader:PrintReport()

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 NullHub V1 Loaded!")
print("⌨️  Press INSERT to toggle GUI")
print("🎨 Theme-GUI connection: " .. (Theme and Theme.GUI and "✅" or "❌"))
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Show success notification
if Notifications then
    pcall(function()
        Notifications:Success("NullHub Loaded!", 3)
    end)
end

-- Store cleanup function globally
getgenv().NullHubCleanup = cleanup

-- Return module table
return {
    Version = VERSION,
    Combat = Combat,
    Movement = Movement,
    Visual = Visual,
    Teleport = Teleport,
    Notifications = Notifications,
    GUI = GUI,
    Theme = Theme,
    Cleanup = cleanup
}
