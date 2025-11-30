-- ============================================
-- NullHub V1.lua - Optimized Module Loader
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- Reduced from 400+ lines to 280 lines
-- ============================================

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub V1 - Optimized Module Loader")
print("🔧 Initializing modular architecture...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- ============================================
-- CONFIGURATION
-- ============================================
local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"
local VERSION = "1.0.0"
local RETRY_ATTEMPTS = 2

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- ============================================
-- MODULE LOADER SYSTEM (OPTIMIZED)
-- ============================================
local ModuleLoader = {
    Loaded = {},
    Failed = {},
    LoadOrder = {},
    TotalModules = 0,
    SuccessCount = 0,
    FailCount = 0,
    CurrentProgress = 0
}

-- Progress Bar Display
function ModuleLoader:UpdateProgress(current, total, moduleName)
    local percentage = math.floor((current / total) * 100)
    local barLength = 30
    local filled = math.floor((percentage / 100) * barLength)
    local bar = string.rep("█", filled) .. string.rep("░", barLength - filled)
    
    print(string.format("[%s] %d%% - %s", bar, percentage, moduleName))
end

-- Load Module with Retry
function ModuleLoader:Load(path, moduleName)
    moduleName = moduleName or path
    
    -- Check cache
    if self.Loaded[path] then
        return self.Loaded[path]
    end
    
    self.TotalModules = self.TotalModules + 1
    self.CurrentProgress = self.CurrentProgress + 1
    
    local url = BASE_URL .. path
    local result = nil
    
    -- Try loading with retries
    for attempt = 1, RETRY_ATTEMPTS do
        local success, loadResult = pcall(function()
            local code = game:HttpGet(url, true)
            return loadstring(code)()
        end)
        
        if success and loadResult then
            result = loadResult
            break
        elseif attempt < RETRY_ATTEMPTS then
            warn(string.format("⚠️ Retry %d/%d for %s", attempt, RETRY_ATTEMPTS, moduleName))
            task.wait(0.5)
        end
    end
    
    -- Update progress
    self:UpdateProgress(self.CurrentProgress, self.TotalModules, moduleName)
    
    if result then
        self.Loaded[path] = result
        self.SuccessCount = self.SuccessCount + 1
        table.insert(self.LoadOrder, moduleName)
        return result
    else
        self.FailCount = self.FailCount + 1
        table.insert(self.Failed, {path = path, name = moduleName})
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
    print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
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
-- MODULE DEFINITIONS (CENTRALIZED)
-- ============================================
local ModuleDefinitions = {
    Core = {
        {path = "Core/Theme.lua", name = "Theme", required = true},
        {path = "Core/AntiDetection.lua", name = "AntiDetection", required = false},
        {path = "Core/Config.lua", name = "Config", required = true},
        {path = "Core/GUI.lua", name = "GUI", required = false}
    },
    Utility = {
        {path = "Utility/Notifications.lua", name = "Notifications", required = false}
    },
    Combat = {
        {path = "Combat/Aimbot.lua", name = "Aimbot"},
        {path = "Combat/ESP.lua", name = "ESP"},
        {path = "Combat/KillAura.lua", name = "KillAura"},
        {path = "Combat/FastM1.lua", name = "FastM1"}
    },
    Movement = {
        {path = "Movement/Fly.lua", name = "Fly"},
        {path = "Movement/NoClip.lua", name = "NoClip"},
        {path = "Movement/InfiniteJump.lua", name = "InfiniteJump"},
        {path = "Movement/Speed.lua", name = "Speed"},
        {path = "Movement/WalkOnWater.lua", name = "WalkOnWater"}
    },
    Visual = {
        {path = "Visual/FullBright.lua", name = "FullBright"},
        {path = "Visual/GodMode.lua", name = "GodMode"}
    },
    Teleport = {
        {path = "Teleport/TeleportToPlayer.lua", name = "TeleportToPlayer"}
    }
}

-- ============================================
-- STAGE 1: LOAD CORE MODULES
-- ============================================
print("\n[Stage 1/5] Loading Core Modules...")

local Theme, AntiDetection, Config, GUI

for _, module in pairs(ModuleDefinitions.Core) do
    local loaded = ModuleLoader:Load(module.path, module.name)
    
    if module.name == "Theme" then Theme = loaded
    elseif module.name == "AntiDetection" then AntiDetection = loaded
    elseif module.name == "Config" then Config = loaded
    elseif module.name == "GUI" then GUI = loaded
    end
    
    -- Check required modules
    if module.required and not loaded then
        error(string.format("[NullHub] ❌ Critical: %s failed to load!", module.name))
    end
end

-- Initialize AntiDetection
if AntiDetection then
    AntiDetection:Initialize()
end

-- Config Fallback (Minimal)
if not Config then
    warn("[NullHub] ⚠️ Using minimal config")
    Config = {GUI = {TOGGLE_KEY = Enum.KeyCode.Insert}}
end

print("✅ Core modules loaded")

-- ============================================
-- STAGE 2: LOAD UTILITY MODULES
-- ============================================
print("\n[Stage 2/5] Loading Utility Modules...")

local Notifications

for _, module in pairs(ModuleDefinitions.Utility) do
    local loaded = ModuleLoader:Load(module.path, module.name)
    if module.name == "Notifications" then Notifications = loaded end
end

print("✅ Utility modules loaded")

-- ============================================
-- STAGE 3: LOAD FEATURE MODULES
-- ============================================
print("\n[Stage 3/5] Loading Feature Modules...")

-- Load all feature modules
local Combat, Movement, Visual, Teleport = {}, {}, {}, {}

for _, module in pairs(ModuleDefinitions.Combat) do
    Combat[module.name] = ModuleLoader:Load(module.path, module.name)
end

for _, module in pairs(ModuleDefinitions.Movement) do
    Movement[module.name] = ModuleLoader:Load(module.path, module.name)
end

for _, module in pairs(ModuleDefinitions.Visual) do
    Visual[module.name] = ModuleLoader:Load(module.path, module.name)
end

for _, module in pairs(ModuleDefinitions.Teleport) do
    Teleport[module.name] = ModuleLoader:Load(module.path, module.name)
end

print("✅ Feature modules loaded")

-- ============================================
-- STAGE 4: INITIALIZE MODULES (OPTIMIZED)
-- ============================================
print("\n[Stage 4/5] Initializing Modules...")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Initialize Notifications
if Notifications then
    Notifications:Initialize(screenGui, Theme)
end

-- Module Initialization Definitions
local InitializationMap = {
    -- Combat Modules
    {module = Combat.Aimbot, params = {player, camera, Config, AntiDetection, Notifications}},
    {module = Combat.ESP, params = {player, camera, Config, Theme, Notifications}},
    {module = Combat.KillAura, params = {player, character, Config, AntiDetection, Notifications}},
    {module = Combat.FastM1, params = {player, character, Config, Notifications}},
    
    -- Movement Modules
    {module = Movement.Fly, params = {player, character, rootPart, camera, Config, Notifications}},
    {module = Movement.NoClip, params = {player, character, Config, Notifications}},
    {module = Movement.InfiniteJump, params = {player, humanoid, Config, Notifications}},
    {module = Movement.Speed, params = {player, humanoid, Config, AntiDetection, Notifications}},
    {module = Movement.WalkOnWater, params = {player, character, rootPart, humanoid, Config, Notifications}},
    
    -- Visual Modules
    {module = Visual.FullBright, params = {Config, Notifications}},
    {module = Visual.GodMode, params = {player, humanoid, Config, Notifications}},
    
    -- Teleport Modules
    {module = Teleport.TeleportToPlayer, params = {player, rootPart, Config, Notifications}}
}

-- Initialize all modules
for _, init in pairs(InitializationMap) do
    if init.module and init.module.Initialize then
        init.module:Initialize(table.unpack(init.params))
    end
end

print("✅ All modules initialized")

-- ============================================
-- STAGE 5: CREATE GUI
-- ============================================
print("\n[Stage 5/5] Creating GUI...")

if GUI then
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
    print("✅ GUI created")
else
    warn("⚠️ GUI unavailable - Using keybind fallback")
end

-- ============================================
-- KEYBIND SYSTEM (OPTIMIZED)
-- ============================================
local KeybindMap = {
    -- Combat
    {key = "AIMBOT_KEY", module = Combat.Aimbot},
    {key = "ESP_KEY", module = Combat.ESP},
    {key = "KILLAURA_KEY", module = Combat.KillAura},
    {key = "FASTM1_KEY", module = Combat.FastM1},
    
    -- Movement
    {key = "FLY_KEY", module = Movement.Fly},
    {key = "NOCLIP_KEY", module = Movement.NoClip},
    {key = "INFJUMP_KEY", module = Movement.InfiniteJump},
    {key = "SPEED_KEY", module = Movement.Speed},
    {key = "WALKONWATER_KEY", module = Movement.WalkOnWater},
    
    -- Visual
    {key = "FULLBRIGHT_KEY", module = Visual.FullBright},
    {key = "GODMODE_KEY", module = Visual.GodMode}
}

if not GUI then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Check all keybinds
        for _, bind in pairs(KeybindMap) do
            local configKey = Config[bind.key]
            if configKey and input.KeyCode == configKey and bind.module and bind.module.Toggle then
                bind.module:Toggle()
            end
        end
        
        -- Infinite Jump special case
        if input.KeyCode == Enum.KeyCode.Space and Movement.InfiniteJump and Movement.InfiniteJump.Enabled then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- ============================================
-- CHARACTER RESPAWN HANDLER (OPTIMIZED)
-- ============================================
player.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Get all modules with OnRespawn
    local modulesToRespawn = {}
    for _, mod in pairs({Combat, Movement, Visual, Teleport}) do
        for _, module in pairs(mod) do
            if module and module.OnRespawn then
                table.insert(modulesToRespawn, module)
            end
        end
    end
    
    -- Reinitialize all
    for _, module in pairs(modulesToRespawn) do
        module:OnRespawn(character, humanoid, rootPart)
    end
    
    if Notifications then
        Notifications:Info("Respawned - Features reinitialized", 2)
    end
end)

-- ============================================
-- CLEANUP SYSTEM (OPTIMIZED)
-- ============================================
local function cleanup()
    print("[NullHub] Cleaning up...")
    
    -- Get all modules with Destroy
    local modulesToCleanup = {}
    for _, category in pairs({Combat, Movement, Visual, Teleport}) do
        for _, module in pairs(category) do
            if module and module.Destroy then
                table.insert(modulesToCleanup, module)
            end
        end
    end
    
    -- Destroy all modules
    for _, module in pairs(modulesToCleanup) do
        module:Destroy()
    end
    
    -- Destroy GUI
    if screenGui then
        screenGui:Destroy()
    end
    
    print("[NullHub] ✅ Cleanup complete")
end

-- ============================================
-- FINAL REPORT
-- ============================================
ModuleLoader:PrintReport()

local stats = ModuleLoader:GetStats()

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 NullHub V1 Loaded Successfully!")
print(string.format("📊 %d/%d modules (%d%%)", stats.Success, stats.Total, stats.Percentage))
print("⌨️  Press [INSERT] to toggle GUI")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

if Notifications then
    Notifications:Success("NullHub V1 Loaded!", 3)
end

-- Store globally
getgenv().NullHubCleanup = cleanup

-- Return module access
return {
    Version = VERSION,
    Combat = Combat,
    Movement = Movement,
    Visual = Visual,
    Teleport = Teleport,
    Notifications = Notifications,
    GUI = GUI,
    Theme = Theme,
    Config = Config,
    AntiDetection = AntiDetection,
    Cleanup = cleanup,
    Stats = stats
}
