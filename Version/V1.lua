-- ============================================
-- NullHub V1.lua - Module Loader & Orchestrator
-- Created by Debbhai
-- Version: 1.0.3 (BULLETPROOF FIX)
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
        -- Check if it has the MainFrame (meaning it's fully loaded)
        local mainFrame = gui:FindFirstChild("MainFrame")
        if mainFrame then
            return true
        else
            -- GUI exists but incomplete, destroy it
            gui:Destroy()
            return false
        end
    end
    return false
end

-- Always clear flags first, then check if actually running
if isNullHubRunning() then
    warn("[NullHub] ⚠️ NullHub is already running!")
    return
end

-- Clear any stale flags (this is the key fix)
getgenv().NullHubLoaded = nil
getgenv().NullHubCleanup = nil

-- Now set loaded flag
getgenv().NullHubLoaded = true

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub - Professional Script Hub")
print("🔧 Loading modules...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- ============================================
-- CONFIGURATION
-- ============================================
local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"
local VERSION = "1.0.3"

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
    local total = self.TotalModules
    if total == 0 then total = 1 end
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

if AntiDetection and AntiDetection.Initialize then
    pcall(function() AntiDetection:Initialize() end)
end

if not Theme then
    getgenv().NullHubLoaded = nil
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
        Movement = { SPEED = { VALUE = 50 } }
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
-- STAGE 4: INITIALIZE MODULES
-- ============================================
print("\n[Stage 4/5] Initializing Modules...")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Store reference globally for cleanup check
getgenv().NullHubScreenGui = screenGui

if Notifications and Notifications.Initialize then
    pcall(function() Notifications:Initialize(screenGui, Theme) end)
    print("✅ Notifications initialized")
end

-- Initialize all modules safely
local function safeInit(module, ...)
    if module and module.Initialize then
        pcall(function() module:Initialize(...) end)
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
-- STAGE 5: CREATE GUI & CONNECT EVERYTHING
-- ============================================
print("\n[Stage 5/5] Creating GUI...")

if GUI and GUI.Initialize then
    pcall(function()
        GUI:Initialize(screenGui, Theme, Config)
        GUI:RegisterModules({
            Combat = Combat,
            Movement = Movement,
            Visual = Visual,
            Teleport = Teleport,
            Notifications = Notifications
        })
        GUI:Create()
        GUI:ConnectButtons()
        GUI:ConnectKeybinds()
    end)
    print("✅ GUI created and connected")
else
    warn("❌ GUI module failed to load")
end

-- ============================================
-- KEYBIND FALLBACK
-- ============================================
if not GUI then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Config.AIMBOT_KEY and Combat.Aimbot then pcall(function() Combat.Aimbot:Toggle() end) end
        if input.KeyCode == Config.ESP_KEY and Combat.ESP then pcall(function() Combat.ESP:Toggle() end) end
        if input.KeyCode == Config.KILLAURA_KEY and Combat.KillAura then pcall(function() Combat.KillAura:Toggle() end) end
        if input.KeyCode == Config.FASTM1_KEY and Combat.FastM1 then pcall(function() Combat.FastM1:Toggle() end) end
        if input.KeyCode == Config.FLY_KEY and Movement.Fly then pcall(function() Movement.Fly:Toggle() end) end
        if input.KeyCode == Config.NOCLIP_KEY and Movement.NoClip then pcall(function() Movement.NoClip:Toggle() end) end
        if input.KeyCode == Config.INFJUMP_KEY and Movement.InfiniteJump then pcall(function() Movement.InfiniteJump:Toggle() end) end
        if input.KeyCode == Config.SPEED_KEY and Movement.Speed then pcall(function() Movement.Speed:Toggle() end) end
        if input.KeyCode == Config.WALKONWATER_KEY and Movement.WalkOnWater then pcall(function() Movement.WalkOnWater:Toggle() end) end
        if input.KeyCode == Config.FULLBRIGHT_KEY and Visual.FullBright then pcall(function() Visual.FullBright:Toggle() end) end
        if input.KeyCode == Config.GODMODE_KEY and Visual.GodMode then pcall(function() Visual.GodMode:Toggle() end) end
    end)
end

-- ============================================
-- CHARACTER RESPAWN HANDLER
-- ============================================
player.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    local function safeRespawn(module)
        if module and module.OnRespawn then
            pcall(function() module:OnRespawn(character, humanoid, rootPart) end)
        end
    end
    
    safeRespawn(Combat.Aimbot)
    safeRespawn(Combat.ESP)
    safeRespawn(Combat.KillAura)
    safeRespawn(Combat.FastM1)
    safeRespawn(Movement.Fly)
    safeRespawn(Movement.NoClip)
    safeRespawn(Movement.InfiniteJump)
    safeRespawn(Movement.Speed)
    safeRespawn(Movement.WalkOnWater)
    safeRespawn(Visual.GodMode)
    safeRespawn(Teleport.TeleportToPlayer)
    
    if Notifications and Notifications.Info then
        pcall(function() Notifications:Info("Respawned - Features reinitialized", 2) end)
    end
end)

-- ============================================
-- CLEANUP FUNCTION
-- ============================================
local function cleanup()
    print("[NullHub] 🧹 Cleaning up...")
    
    local function safeDestroy(module)
        if module and module.Destroy then
            pcall(function() module:Destroy() end)
        end
    end
    
    safeDestroy(Combat.Aimbot)
    safeDestroy(Combat.ESP)
    safeDestroy(Combat.KillAura)
    safeDestroy(Combat.FastM1)
    safeDestroy(Movement.Fly)
    safeDestroy(Movement.NoClip)
    safeDestroy(Movement.InfiniteJump)
    safeDestroy(Movement.Speed)
    safeDestroy(Movement.WalkOnWater)
    safeDestroy(Visual.FullBright)
    safeDestroy(Visual.GodMode)
    safeDestroy(Teleport.TeleportToPlayer)
    safeDestroy(GUI)
    
    if screenGui then
        pcall(function() screenGui:Destroy() end)
    end
    
    -- Clear ALL global flags
    getgenv().NullHubLoaded = nil
    getgenv().NullHubCleanup = nil
    getgenv().NullHubScreenGui = nil
    
    print("[NullHub] ✅ Cleanup complete - You can re-execute now")
end

-- ============================================
-- FINAL REPORT
-- ============================================
ModuleLoader:PrintReport()

local stats = ModuleLoader:GetStats()
print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 NullHub V1 Loaded Successfully!")
print(string.format("📊 %d/%d modules loaded (%d%%)", stats.Success, stats.Total, stats.Percentage))
print("⌨️ Press [INSERT] to toggle GUI")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

if Notifications and Notifications.Success then
    pcall(function() Notifications:Success("NullHub V1 Loaded!", 3) end)
end

getgenv().NullHubCleanup = cleanup

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
