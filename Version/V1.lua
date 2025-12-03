-- ============================================
-- NullHub V1.lua - DIAGNOSTIC VERSION
-- This will show you EXACTLY which file is broken
-- ============================================

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub - Diagnostic Mode")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("NullHubGUI") then
    warn("Already running!")
    return
end

local BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/"

-- Test each module individually
local function TestModule(path, name)
    print(string.format("\n🔍 Testing %s...", name))
    
    -- Step 1: Download
    print("   [1/4] Downloading...")
    local dlOk, code = pcall(function()
        return game:HttpGet(BASE_URL .. path, true)
    end)
    
    if not dlOk then
        warn(string.format("   ❌ Download failed: %s", tostring(code)))
        return false
    end
    
    print(string.format("   ✅ Downloaded %d bytes", #code))
    
    -- Step 2: Loadstring
    print("   [2/4] Running loadstring...")
    local lsOk, loadFunc = pcall(function()
        return loadstring(code)
    end)
    
    if not lsOk or not loadFunc then
        warn(string.format("   ❌ Loadstring failed: %s", tostring(loadFunc)))
        return false
    end
    
    print("   ✅ Loadstring successful")
    
    -- Step 3: Execute (THIS IS WHERE YOUR ERROR HAPPENS)
    print("   [3/4] Executing module code...")
    local execOk, module = pcall(loadFunc)
    
    if not execOk then
        warn(string.format("   ❌❌❌ EXECUTION FAILED ❌❌❌"))
        warn(string.format("   ERROR: %s", tostring(module)))
        warn(string.format("   THIS MODULE IS BROKEN: %s", name))
        warn(string.format("   Fix this file on GitHub: %s", path))
        return false
    end
    
    print("   ✅ Execution successful")
    
    -- Step 4: Validate
    print("   [4/4] Validating module...")
    if type(module) ~= "table" then
        warn(string.format("   ❌ Module didn't return a table (got %s)", type(module)))
        return false
    end
    
    print(string.format("   ✅✅✅ %s is WORKING! ✅✅✅", name))
    return true
end

-- Test all modules one by one
print("\n" .. "=":rep(50))
print("TESTING CORE MODULES")
print("=":rep(50))

TestModule("Core/Theme.lua", "Theme")
TestModule("Core/Config.lua", "Config")
TestModule("Core/AntiDetection.lua", "AntiDetection")
TestModule("Core/GUI.lua", "GUI")

print("\n" .. "=":rep(50))
print("TESTING UTILITY MODULES")
print("=":rep(50))

TestModule("Utility/Notifications.lua", "Notifications")

print("\n" .. "=":rep(50))
print("TESTING COMBAT MODULES")
print("=":rep(50))

TestModule("Combat/Aimbot.lua", "Aimbot")
TestModule("Combat/ESP.lua", "ESP")
TestModule("Combat/KillAura.lua", "KillAura")
TestModule("Combat/FastM1.lua", "FastM1")

print("\n" .. "=":rep(50))
print("TESTING MOVEMENT MODULES")
print("=":rep(50))

TestModule("Movement/Fly.lua", "Fly")
TestModule("Movement/NoClip.lua", "NoClip")
TestModule("Movement/InfiniteJump.lua", "InfiniteJump")
TestModule("Movement/Speed.lua", "Speed")
TestModule("Movement/WalkOnWater.lua", "WalkOnWater")

print("\n" .. "=":rep(50))
print("TESTING VISUAL MODULES")
print("=":rep(50))

TestModule("Visual/FullBright.lua", "FullBright")
TestModule("Visual/GodMode.lua", "GodMode")

print("\n" .. "=":rep(50))
print("DIAGNOSTIC COMPLETE")
print("=":rep(50))
print("\nCheck console above to see which module failed!")
