-- ============================================
-- NullHub Main.lua - Entry Point Launcher
-- Created by Debbhai
-- Version: 1.0.0
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
local Players = game:GetService("Players")

-- Utility Functions
local function safeHttpGet(url, timeout)
    timeout = timeout or CONFIG.TIMEOUT
    local success, result
    
    for attempt = 1, CONFIG.RETRY_ATTEMPTS do
        success, result = pcall(function()
            return game:HttpGet(url, true)
        end)
        
        if success then
            return result
        else
            if attempt < CONFIG.RETRY_ATTEMPTS then
                warn(string.format("[NullHub] Attempt %d/%d failed, retrying...", attempt, CONFIG.RETRY_ATTEMPTS))
                task.wait(1)
            end
        end
    end
    
    return nil
end

local function checkVersion()
    if not CONFIG.ENABLE_AUTO_UPDATE then
        return CONFIG.DEFAULT_VERSION
    end
    
    print("[NullHub] Checking for latest version...")
    
    local versionUrl = CONFIG.BASE_URL .. "version.txt"
    local versionData = safeHttpGet(versionUrl)
    
    if versionData then
        local version = versionData:match("V%d+%.lua")
        if version then
            print("[NullHub] ✅ Latest version: " .. version)
            return version
        end
    end
    
    print("[NullHub] ℹ️ Using default version: " .. CONFIG.DEFAULT_VERSION)
    return CONFIG.DEFAULT_VERSION
end

local function validateEnvironment()
    -- Check if executor supports required functions
    local required = {
        {name = "game:HttpGet", func = function() return game.HttpGet end},
        {name = "loadstring", func = loadstring},
        {name = "getgenv", func = getgenv}
    }
    
    for _, check in pairs(required) do
        if not check.func then
            warn("[NullHub] ❌ Your executor doesn't support: " .. check.name)
            return false
        end
    end
    
    return true
end

local function loadScript(version)
    local scriptUrl = CONFIG.BASE_URL .. "Version/" .. version
    
    print("[NullHub] 📥 Downloading " .. version .. "...")
    
    local scriptData = safeHttpGet(scriptUrl)
    
    if not scriptData then
        error("[NullHub] ❌ Failed to download script after " .. CONFIG.RETRY_ATTEMPTS .. " attempts")
        return false
    end
    
    print("[NullHub] ✅ Download complete")
    print("[NullHub] 🔄 Executing script...")
    
    local success, result = pcall(function()
        return loadstring(scriptData)()
    end)
    
    if success then
        print("[NullHub] ✅ Script loaded successfully!")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        return true
    else
        error("[NullHub] ❌ Execution failed: " .. tostring(result))
        return false
    end
end

-- Anti-Duplicate Check
if getgenv().NullHubLoaded then
    warn("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    warn("⚠️ NullHub is already running!")
    warn("Please don't execute the script twice.")
    warn("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    return
end

-- Main Execution
local function main()
    -- Validate environment
    if not validateEnvironment() then
        error("[NullHub] ❌ Executor not compatible")
        return
    end
    
    -- Get latest version
    local version = checkVersion()
    
    -- Load the script
    local success = loadScript(version)
    
    if success then
        -- Mark as loaded
        getgenv().NullHubLoaded = true
        getgenv().NullHubVersion = version
        
        print("🎉 Enjoy using NullHub!")
        print("💬 Join our Discord for support")
        print("⭐ Star us on GitHub: Debbhai/NullHub")
    else
        warn("[NullHub] ❌ Failed to initialize")
        warn("[NullHub] Please contact support or check GitHub issues")
    end
end

-- Execute with error handling
local executionSuccess, executionError = pcall(main)

if not executionSuccess then
    warn("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    warn("❌ NullHub Fatal Error:")
    warn(tostring(executionError))
    warn("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    warn("📧 Report this error:")
    warn("1. Take a screenshot of this error")
    warn("2. Join our Discord")
    warn("3. Send the screenshot in #support")
    warn("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end
