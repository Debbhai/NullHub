-- ============================================
-- NullHub V1.lua - Module Loader & Orchestrator
-- Created by Debbhai
-- Version: 1.0.1
-- This file loads and connects all NullHub modules
-- ============================================

-- ============================================
-- ANTI-DUPLICATE CHECK (FIXED)
-- ============================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if getgenv().NullHubLoaded then
    local oldGui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("NullHubGUI")
    
    if oldGui then
        warn("[NullHub] ⚠️ NullHub is already running!")
        return
    else
        getgenv().NullHubLoaded = false
        getgenv().NullHubCleanup = nil
        print("[NullHub] 🔄 Previous instance was destroyed, starting fresh...")
    end
end

getgenv().NullHubLoaded = true

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub V1 - Module Loader")
print("🔧 Initializing modular architecture...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- ============================================
-- CONFIGURATION
-- ============================================
local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"
local VERSION = "1.0.1"

-- ============================================
-- SERVICES
-- ============================================
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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
    LoadOrder = {},
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
        return loadstring(code)()
    end)
    
    if success and result then
        self.Loaded[path] = result
        self.SuccessCount = self.SuccessCount + 1
        table.insert(self.LoadOrder, moduleName)
        print(string.format("✅ %s loaded", moduleName))
        return result
    else
        self.FailCount = self.FailCount + 1
        table.insert(self.Failed, {path = path, name = moduleName, error = tostring(result)})
        warn(string.format("❌ Failed to load %s: %s", moduleName, tostring(result)))
        return nil
    end
end

function ModuleLoader:GetStats()
    return {
        Total = self.TotalModules,
        Success = self.SuccessCount,
        Failed = self.FailCount,
        Percentage = self.TotalModules > 0 and math.floor((self.SuccessCount / self.TotalModules) * 100) or 0
    }
end

function ModuleLoader:PrintReport()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("📊 Module Loading Report:")
    print(string.format("✅ Loaded: %d/%d modules", self.SuccessCount, self.TotalModules))
    if self.FailCount > 0 then
        warn(string.format("❌ Failed: %d modules", self.FailCount))
        for _, fail in pairs(self.Failed) do
            warn(string.format("   - %s", fail.name))
        end
    end
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- ============================================
-- STAGE 1: LOAD CORE MODULES
-- ============================================
print("\n[Stage 1/5] Loading Core Modules...")

local Theme = ModuleLoader:Load("Core/Theme.lua", "Theme")
local AntiDetection = ModuleLoader:Load("Core/AntiDetection.lua", "AntiDetection")
local Config = ModuleLoader:Load("Core/Config.lua", "Config")
local GUI = ModuleLoader:Load("Core/GUI.lua", "GUI")

-- Initialize AntiDetection if loaded
if AntiDetection then
    AntiDetection:Initialize()
end

-- Fallback if core modules fail
if not Theme then
    error("[NullHub] ❌ Critical: Theme.lua failed to load!")
end

if not Config then
    warn("[NullHub] ⚠️ Config.lua failed, using defaults")
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
        Movement = {
            SPEED = {VALUE = 50}
        }
    }
end

print("✅ Core modules loaded")

-- ============================================
-- STAGE 2: LOAD UTILITY MODULES
-- ============================================
print("\n[Stage 2/5] Loading Utility Modules...")

local Notifications = ModuleLoader:Load("Utility/Notifications.lua", "Notifications")

print("✅ Utility modules loaded")

-- ============================================
-- STAGE 3: LOAD FEATURE MODULES
-- ============================================
print("\n[Stage 3/5] Loading Feature Modules...")

-- Combat modules
local Combat = {}
Combat.Aimbot = ModuleLoader:Load("Combat/Aimbot.lua", "Aimbot")
Combat.ESP = ModuleLoader:Load("Combat/ESP.lua", "ESP")
Combat.KillAura = ModuleLoader:Load("Combat/KillAura.lua", "KillAura")
Combat.FastM1 = ModuleLoader:Load("Combat/FastM1.lua", "FastM1")

-- Movement modules
local Movement = {}
Movement.Fly = ModuleLoader:Load("Movement/Fly.lua", "Fly")
Movement.NoClip = ModuleLoader:Load("Movement/NoClip.lua", "NoClip")
Movement.InfiniteJump = ModuleLoader:Load("Movement/InfiniteJump.lua", "InfiniteJump")
Movement.Speed = ModuleLoader:Load("Movement/Speed.lua", "Speed")
Movement.WalkOnWater = ModuleLoader:Load("Movement/WalkOnWater.lua", "WalkOnWater")

-- Visual modules
local Visual = {}
Visual.FullBright = ModuleLoader:Load("Visual/FullBright.lua", "FullBright")
Visual.GodMode = ModuleLoader:Load("Visual/GodMode.lua", "GodMode")

-- Teleport modules
local Teleport = {}
Teleport.TeleportToPlayer = ModuleLoader:Load("Teleport/TeleportToPlayer.lua", "TeleportToPlayer")

print("✅ Feature modules loaded")

-- ============================================
-- STAGE 4: INITIALIZE MODULES
-- ============================================
print("\n[Stage 4/5] Initializing Modules...")

-- Create ScreenGui for GUI and Notifications
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Initialize Notifications
if Notifications then
    Notifications:Initialize(screenGui, Theme)
    print("✅ Notifications initialized")
else
    warn("⚠️ Notifications not available")
end

-- Initialize Combat modules
if Combat.Aimbot then
    Combat.Aimbot:Initialize(player, camera, Config, AntiDetection, Notifications)
    print("✅ Aimbot initialized")
end

if Combat.ESP then
    Combat.ESP:Initialize(player, camera, Config, Theme, Notifications)
    print("✅ ESP initialized")
end

if Combat.KillAura then
    Combat.KillAura:Initialize(player, character, Config, AntiDetection, Notifications)
    print("✅ KillAura initialized")
end

if Combat.FastM1 then
    Combat.FastM1:Initialize(player, character, Config, Notifications)
    print("✅ FastM1 initialized")
end

-- Initialize Movement modules
if Movement.Fly then
    Movement.Fly:Initialize(player, character, rootPart, camera, Config, Notifications)
    print("✅ Fly initialized")
end

if Movement.NoClip then
    Movement.NoClip:Initialize(player, character, Config, Notifications)
    print("✅ NoClip initialized")
end

if Movement.InfiniteJump then
    Movement.InfiniteJump:Initialize(player, humanoid, Config, Notifications)
    print("✅ InfiniteJump initialized")
end

if Movement.Speed then
    Movement.Speed:Initialize(player, humanoid, Config, AntiDetection, Notifications)
    print("✅ Speed initialized")
end

if Movement.WalkOnWater then
    Movement.WalkOnWater:Initialize(player, character, rootPart, humanoid, Config, Notifications)
    print("✅ WalkOnWater initialized")
end

-- Initialize Visual modules
if Visual.FullBright then
    Visual.FullBright:Initialize(Config, Notifications)
    print("✅ FullBright initialized")
end

if Visual.GodMode then
    Visual.GodMode:Initialize(player, humanoid, Config, Notifications)
    print("✅ GodMode initialized")
end

-- Initialize Teleport modules
if Teleport.TeleportToPlayer then
    Teleport.TeleportToPlayer:Initialize(player, rootPart, Config, Notifications)
    print("✅ TeleportToPlayer initialized")
end

print("✅ All modules initialized")

-- ============================================
-- STAGE 5: CREATE GUI & CONNECT EVERYTHING
-- ============================================
print("\n[Stage 5/5] Creating GUI...")

if GUI then
    -- Create the main GUI
    GUI:Initialize(screenGui, Theme, Config)
    
    -- Register all modules with GUI
    GUI:RegisterModules({
        Combat = Combat,
        Movement = Movement,
        Visual = Visual,
        Teleport = Teleport,
        Notifications = Notifications
    })
    
    -- Create the interface
    GUI:Create()
    
    -- Connect all buttons and keybinds
    GUI:ConnectButtons()
    GUI:ConnectKeybinds()
    
    print("✅ GUI created and connected")
else
    warn("❌ GUI module failed to load - No interface available")
    warn("Features can still be toggled via keybinds")
end

-- ============================================
-- KEYBIND FALLBACK (If GUI fails)
-- ============================================
if not GUI then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Combat keybinds
        if input.KeyCode == Config.AIMBOT_KEY and Combat.Aimbot then Combat.Aimbot:Toggle() end
        if input.KeyCode == Config.ESP_KEY and Combat.ESP then Combat.ESP:Toggle() end
        if input.KeyCode == Config.KILLAURA_KEY and Combat.KillAura then Combat.KillAura:Toggle() end
        if input.KeyCode == Config.FASTM1_KEY and Combat.FastM1 then Combat.FastM1:Toggle() end
        
        -- Movement keybinds
        if input.KeyCode == Config.FLY_KEY and Movement.Fly then Movement.Fly:Toggle() end
        if input.KeyCode == Config.NOCLIP_KEY and Movement.NoClip then Movement.NoClip:Toggle() end
        if input.KeyCode == Config.INFJUMP_KEY and Movement.InfiniteJump then Movement.InfiniteJump:Toggle() end
        if input.KeyCode == Config.SPEED_KEY and Movement.Speed then Movement.Speed:Toggle() end
        if input.KeyCode == Config.WALKONWATER_KEY and Movement.WalkOnWater then Movement.WalkOnWater:Toggle() end
        
        -- Visual keybinds
        if input.KeyCode == Config.FULLBRIGHT_KEY and Visual.FullBright then Visual.FullBright:Toggle() end
        if input.KeyCode == Config.GODMODE_KEY and Visual.GodMode then Visual.GodMode:Toggle() end
        
        -- Infinite Jump special handling
        if input.KeyCode == Enum.KeyCode.Space and Movement.InfiniteJump and Movement.InfiniteJump.Enabled then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    
    print("✅ Keybind fallback active")
end

-- ============================================
-- CHARACTER RESPAWN HANDLER
-- ============================================
player.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    print("[NullHub] Character respawned - Reinitializing features...")
    
    -- Reinitialize all modules with new character
    if Combat.Aimbot and Combat.Aimbot.OnRespawn then Combat.Aimbot:OnRespawn(character, humanoid, rootPart) end
    if Combat.ESP and Combat.ESP.OnRespawn then Combat.ESP:OnRespawn(character, humanoid, rootPart) end
    if Combat.KillAura and Combat.KillAura.OnRespawn then Combat.KillAura:OnRespawn(character, humanoid, rootPart) end
    if Combat.FastM1 and Combat.FastM1.OnRespawn then Combat.FastM1:OnRespawn(character, humanoid, rootPart) end
    
    if Movement.Fly and Movement.Fly.OnRespawn then Movement.Fly:OnRespawn(character, humanoid, rootPart) end
    if Movement.NoClip and Movement.NoClip.OnRespawn then Movement.NoClip:OnRespawn(character, humanoid, rootPart) end
    if Movement.InfiniteJump and Movement.InfiniteJump.OnRespawn then Movement.InfiniteJump:OnRespawn(character, humanoid, rootPart) end
    if Movement.Speed and Movement.Speed.OnRespawn then Movement.Speed:OnRespawn(character, humanoid, rootPart) end
    if Movement.WalkOnWater and Movement.WalkOnWater.OnRespawn then Movement.WalkOnWater:OnRespawn(character, humanoid, rootPart) end
    
    if Visual.GodMode and Visual.GodMode.OnRespawn then Visual.GodMode:OnRespawn(character, humanoid, rootPart) end
    if Teleport.TeleportToPlayer and Teleport.TeleportToPlayer.OnRespawn then Teleport.TeleportToPlayer:OnRespawn(character, humanoid, rootPart) end
    
    if Notifications then
        Notifications:Info("Respawned - Features reinitialized", 2)
    end
end)

-- ============================================
-- CLEANUP ON SCRIPT UNLOAD (FIXED)
-- ============================================
local function cleanup()
    print("[NullHub] Cleaning up...")
    
    -- Disconnect all modules safely
    if Combat.Aimbot and Combat.Aimbot.Destroy then pcall(function() Combat.Aimbot:Destroy() end) end
    if Combat.ESP and Combat.ESP.Destroy then pcall(function() Combat.ESP:Destroy() end) end
    if Combat.KillAura and Combat.KillAura.Destroy then pcall(function() Combat.KillAura:Destroy() end) end
    if Combat.FastM1 and Combat.FastM1.Destroy then pcall(function() Combat.FastM1:Destroy() end) end
    
    if Movement.Fly and Movement.Fly.Destroy then pcall(function() Movement.Fly:Destroy() end) end
    if Movement.NoClip and Movement.NoClip.Destroy then pcall(function() Movement.NoClip:Destroy() end) end
    if Movement.InfiniteJump and Movement.InfiniteJump.Destroy then pcall(function() Movement.InfiniteJump:Destroy() end) end
    if Movement.Speed and Movement.Speed.Destroy then pcall(function() Movement.Speed:Destroy() end) end
    if Movement.WalkOnWater and Movement.WalkOnWater.Destroy then pcall(function() Movement.WalkOnWater:Destroy() end) end
    
    if Visual.FullBright and Visual.FullBright.Destroy then pcall(function() Visual.FullBright:Destroy() end) end
    if Visual.GodMode and Visual.GodMode.Destroy then pcall(function() Visual.GodMode:Destroy() end) end
    
    if Teleport.TeleportToPlayer and Teleport.TeleportToPlayer.Destroy then pcall(function() Teleport.TeleportToPlayer:Destroy() end) end
    
    -- Destroy GUI
    if GUI and GUI.Destroy then
        pcall(function() GUI:Destroy() end)
    end
    
    -- Destroy ScreenGui
    if screenGui then
        screenGui:Destroy()
    end
    
    -- IMPORTANT: Clear global flags so script can be executed again
    getgenv().NullHubLoaded = false
    getgenv().NullHubCleanup = nil
    
    print("[NullHub] ✅ Cleanup complete - You can now re-execute the script")
end

-- ============================================
-- FINAL REPORT & COMPLETION
-- ============================================
ModuleLoader:PrintReport()

local stats = ModuleLoader:GetStats()

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 NullHub V1 Loaded Successfully!")
print(string.format("📊 %d/%d modules loaded (%d%%)", stats.Success, stats.Total, stats.Percentage))
print("⌨️ Press [" .. (Config.GUI_TOGGLE_KEY and Config.GUI_TOGGLE_KEY.Name or "INSERT") .. "] to toggle GUI")
print("📖 Check keybinds in the GUI settings")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

if Notifications then
    Notifications:Success("NullHub V1 Loaded!", 3)
end

-- Store cleanup function globally
getgenv().NullHubCleanup = cleanup

-- Return module loader for external access
return {
    Version = VERSION,
    Combat = Combat,
    Movement = Movement,
    Visual = Visual,
    Teleport = Teleport,
    Notifications = Notifications,
    GUI = GUI,
    Cleanup = cleanup,
    Stats = ModuleLoader:GetStats()
}
