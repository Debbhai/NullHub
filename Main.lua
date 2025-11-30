-- ============================================
-- NullHub Main.lua - Entry Point Launcher
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- ============================================

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("⚡ NullHub - Professional Script Hub")
print("🔧 Loading modules...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Configuration
local CONFIG = {
    BASE_URL = "https://raw.githubusercontent.com/Debbhai/NullHub/main/",
    DEFAULT_VERSION = "V1.lua",
    ENABLE_AUTO_UPDATE = true,
    RETRY_ATTEMPTS = 3,
    TIMEOUT = 30
}

-- Services
local HttpService = game:GetService("HttpService")

-- Utility: Safe HTTP Get with Retry
local function safeHttpGet(url)
    for attempt = 1, CONFIG.RETRY_ATTEMPTS do
        local success, result = pcall(function()
            return game:HttpGet(url, true)
        end)
        
        if success then
            return result
        elseif attempt < CONFIG.RETRY_ATTEMPTS then
            warn(string.format("[NullHub] Retry %d/%d...", attempt, CONFIG.RETRY_ATTEMPTS))
            task.wait(1)
        end
    end
    return nil
end

-- Validate Executor Environment
local function validateEnvironment()
    local required = {
        {name = "game:HttpGet", func = function() return game.HttpGet end},
        {name = "loadstring", func = loadstring},
        {name = "getgenv", func = getgenv}
    }
    
    for _, check in pairs(required) do
        if not check.func then
            warn("[NullHub] ❌ Missing: " .. check.name)
            return false
        end
    end
    return true
end

-- Check Latest Version
local function checkVersion()
    if not CONFIG.ENABLE_AUTO_UPDATE then
        return CONFIG.DEFAULT_VERSION
    end
    
    print("[NullHub] Checking version...")
    local versionData = safeHttpGet(CONFIG.BASE_URL .. "version.txt")
    
    if versionData then
        local version = versionData:match("V%d+%.lua")
        if version then
            print("[NullHub] ✅ Latest: " .. version)
            return version
        end
    end
    
    print("[NullHub] Using default: " .. CONFIG.DEFAULT_VERSION)
    return CONFIG.DEFAULT_VERSION
end

-- Load and Execute Script
local function loadScript(version)
    print("[NullHub] 📥 Downloading " .. version .. "...")
    
    local scriptData = safeHttpGet(CONFIG.BASE_URL .. "Version/" .. version)
    if not scriptData then
        error("[NullHub] ❌ Download failed")
    end
    
    print("[NullHub] ✅ Download complete")
    print("[NullHub] 🔄 Executing...")
    
    local success, result = pcall(function()
        return loadstring(scriptData)()
    end)
    
    if success then
        print("[NullHub] ✅ Loaded successfully!")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        return true
    else
        error("[NullHub] ❌ Execution failed: " .. tostring(result))
    end
end

-- Anti-Duplicate Check
if getgenv().NullHubLoaded then
    warn("⚠️ NullHub is already running!")
    return
end

-- Main Execution
local function main()
    if not validateEnvironment() then
        error("[NullHub] ❌ Executor not compatible")
    end
    
    local version = checkVersion()
    local success = loadScript(version)
    
    if success then
        getgenv().NullHubLoaded = true
        getgenv().NullHubVersion = version
        print("🎉 Enjoy using NullHub!")
    end
end

-- Execute with Error Handling
local success, err = pcall(main)
if not success then
    warn("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    warn("❌ NullHub Fatal Error:")
    warn(tostring(err))
    warn("📧 Report: Discord #support")
    warn("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end
