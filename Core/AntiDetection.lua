-- ============================================
-- NullHub AntiDetection.lua - Protection System
-- Created by Debbhai
-- Version: 1.0.0
-- Universal anti-detection & protection module
-- ============================================

local AntiDetection = {
    Version = "1.0.0",
    Author = "Debbhai",
    Initialized = false,
    Protections = {
        AntiKick = false,
        AntiAFK = false,
        HiddenFromList = false,
        MetatableProtected = false
    }
}

-- Internal storage
local Connections = {}
local OriginalFunctions = {}
local IsProtected = false

-- ============================================
-- EXECUTOR DETECTION
-- ============================================
function AntiDetection:DetectExecutor()
    local executors = {
        {name = "Synapse X", check = function() return syn and syn.request end},
        {name = "Script-Ware", check = function() return isscriptware and isscriptware() end},
        {name = "KRNL", check = function() return KRNL_LOADED end},
        {name = "Fluxus", check = function() return fluxus and fluxus.execute end},
        {name = "Arceus X", check = function() return identifyexecutor and identifyexecutor():lower():find("arceus") end},
        {name = "Hydrogen", check = function() return hydrogen and hydrogen.execute end},
        {name = "Nezur", check = function() return nezur end},
        {name = "Delta", check = function() return is_delta_executor end}
    }
    
    for _, executor in ipairs(executors) do
        local success, result = pcall(executor.check)
        if success and result then
            print("[AntiDetection] Detected executor: " .. executor.name)
            return executor.name
        end
    end
    
    -- Try identifyexecutor function
    local success, executor = pcall(function()
        return identifyexecutor and identifyexecutor() or "Unknown"
    end)
    
    if success and executor ~= "Unknown" then
        print("[AntiDetection] Detected executor: " .. executor)
        return executor
    end
    
    print("[AntiDetection] Executor: Unknown (Basic)")
    return "Unknown"
end

-- ============================================
-- ENHANCED ANTI-KICK PROTECTION
-- ============================================
function AntiDetection:SetupAntiKick()
    if self.Protections.AntiKick then
        warn("[AntiDetection] Anti-Kick already active!")
        return true
    end
    
    local success = pcall(function()
        -- Method 1: Metatable Hook
        if getrawmetatable and setreadonly then
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            
            setreadonly(mt, false)
            
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                -- Block kick methods
                if method == "Kick" or method == "kick" then
                    warn("[AntiDetection] 🛡️ Blocked Kick attempt!")
                    return wait(9e9) -- Infinite wait
                end
                
                -- Block FireServer/InvokeServer to anti-cheat remotes
                if method == "FireServer" or method == "InvokeServer" then
                    local selfStr = tostring(self):lower()
                    local suspicious = {
                        "anti", "detect", "kick", "ban", "flag", 
                        "report", "cheat", "hack", "exploit", "ac"
                    }
                    
                    for _, keyword in ipairs(suspicious) do
                        if selfStr:find(keyword) then
                            warn("[AntiDetection] 🛡️ Blocked suspicious remote: " .. tostring(self))
                            return
                        end
                    end
                    
                    -- Check arguments for suspicious patterns
                    for _, arg in ipairs(args) do
                        if type(arg) == "string" then
                            local argLower = arg:lower()
                            for _, keyword in ipairs(suspicious) do
                                if argLower:find(keyword) then
                                    warn("[AntiDetection] 🛡️ Blocked suspicious argument: " .. arg)
                                    return
                                end
                            end
                        end
                    end
                end
                
                return oldNamecall(self, ...)
            end)
            
            setreadonly(mt, true)
            self.Protections.MetatableProtected = true
        end
        
        -- Method 2: LocalPlayer.Kick Hook
        local player = game:GetService("Players").LocalPlayer
        if player then
            local oldKick = player.Kick
            player.Kick = function(...)
                warn("[AntiDetection] 🛡️ Blocked LocalPlayer.Kick!")
                return wait(9e9)
            end
            OriginalFunctions.PlayerKick = oldKick
        end
        
        -- Method 3: Monitor for teleport attempts (some games kick via teleport)
        local TeleportService = game:GetService("TeleportService")
        local oldTeleport = TeleportService.Teleport
        TeleportService.Teleport = function(placeId, player, ...)
            if player == game.Players.LocalPlayer then
                warn("[AntiDetection] 🛡️ Blocked suspicious teleport!")
                return
            end
            return oldTeleport(placeId, player, ...)
        end
        OriginalFunctions.Teleport = oldTeleport
        
        self.Protections.AntiKick = true
        print("[AntiDetection] ✅ Anti-Kick Active (Multi-Layer)")
    end)
    
    if not success then
        warn("[AntiDetection] ⚠️ Anti-Kick setup failed (Executor limitation)")
        return false
    end
    
    return true
end

-- ============================================
-- ENHANCED ANTI-AFK SYSTEM
-- ============================================
function AntiDetection:SetupAntiAFK()
    if self.Protections.AntiAFK then
        warn("[AntiDetection] Anti-AFK already active!")
        return true
    end
    
    local success = pcall(function()
        local Players = game:GetService("Players")
        local VirtualUser = game:GetService("VirtualUser")
        local player = Players.LocalPlayer
        
        -- Method 1: Idled event
        Connections.AntiAFK = player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.5)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            print("[AntiDetection] 🔄 Anti-AFK Triggered")
        end)
        
        -- Method 2: Periodic movement simulation
        task.spawn(function()
            while task.wait(300) do -- Every 5 minutes
                if player and player.Character then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end
        end)
        
        self.Protections.AntiAFK = true
        print("[AntiDetection] ✅ Anti-AFK Active (Multi-Method)")
    end)
    
    if not success then
        warn("[AntiDetection] ⚠️ Anti-AFK setup failed")
        return false
    end
    
    return true
end

-- ============================================
-- STEALTH HELPERS (Enhanced)
-- ============================================
function AntiDetection:AddRandomDelay(stealthMode)
    if not stealthMode then return end
    
    -- Variable delay between 1-50ms
    local delay = math.random(10, 500) / 10000 -- 0.001 to 0.05 seconds
    task.wait(delay)
end

function AntiDetection:SmoothTransition(targetValue, currentValue, smoothness, stealthMode)
    if not stealthMode then
        return targetValue
    end
    
    -- Add slight randomness to smoothness
    local randomFactor = 1 + (math.random(-10, 10) / 100) -- ±10%
    local adjustedSmoothness = smoothness * randomFactor
    
    return currentValue + (targetValue - currentValue) * adjustedSmoothness
end

function AntiDetection:GetVariableSmoothness(baseSmoothness, stealthMode)
    if not stealthMode then
        return baseSmoothness
    end
    
    -- Add random variation (±5%)
    local variation = math.random(-50, 50) / 1000 -- -0.05 to 0.05
    return math.clamp(baseSmoothness + variation, 0.01, 0.99)
end

function AntiDetection:RandomizeValue(value, variationPercent)
    variationPercent = variationPercent or 10
    local variation = value * (variationPercent / 100)
    return value + math.random(-variation * 100, variation * 100) / 100
end

function AntiDetection:HumanizeMouse(targetPosition, currentPosition, smoothness)
    -- Simulate human-like mouse movement with slight curves
    local distance = (targetPosition - currentPosition).Magnitude
    
    if distance < 50 then
        return targetPosition -- Small movements are direct
    end
    
    -- Add slight curve to movement
    local midPoint = (targetPosition + currentPosition) / 2
    local curve = Vector2.new(
        math.random(-20, 20),
        math.random(-20, 20)
    )
    
    return currentPosition + (midPoint + curve - currentPosition) * smoothness
end

-- ============================================
-- HIDE FROM DETECTION (Enhanced)
-- ============================================
function AntiDetection:HideFromPlayerList()
    if self.Protections.HiddenFromList then
        return true
    end
    
    local success = pcall(function()
        local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        
        -- Method 1: Hide from CoreGui PlayerList
        local coreGui = game:GetService("CoreGui")
        if coreGui:FindFirstChild("RobloxGui") then
            local robloxGui = coreGui.RobloxGui
            if robloxGui:FindFirstChild("PlayerListMaster") then
                robloxGui.PlayerListMaster.Visible = false
            end
        end
        
        -- Method 2: Set display name to invisible character
        local player = game:GetService("Players").LocalPlayer
        if player.DisplayName then
            -- Note: This may not work on all games
            pcall(function()
                player.DisplayName = "‎" -- Invisible character
            end)
        end
        
        self.Protections.HiddenFromList = true
        print("[AntiDetection] ✅ Hidden from player list")
    end)
    
    return success
end

-- ============================================
-- ANTI-SCREENSHOT PROTECTION
-- ============================================
function AntiDetection:SetupAntiScreenshot()
    local success = pcall(function()
        -- Hide GUI when screenshot is taken
        local ScreenshotService = game:GetService("ScreenshotService")
        
        Connections.AntiScreenshot = ScreenshotService.ScreenshotSaving:Connect(function()
            warn("[AntiDetection] 📸 Screenshot detected - Hiding GUI")
            -- Trigger GUI hide event
            if getgenv().NullHubGUI then
                getgenv().NullHubGUI.Enabled = false
                task.wait(1)
                getgenv().NullHubGUI.Enabled = true
            end
        end)
        
        print("[AntiDetection] ✅ Anti-Screenshot Active")
    end)
    
    return success
end

-- ============================================
-- NETWORK LOGGING PROTECTION
-- ============================================
function AntiDetection:SetupNetworkProtection()
    local success = pcall(function()
        local HttpService = game:GetService("HttpService")
        
        -- Hook HTTP requests to detect logging attempts
        if hookfunction then
            local oldHttpGet = HttpService.GetAsync
            hookfunction(HttpService.GetAsync, function(self, url, ...)
                if url:lower():find("log") or url:lower():find("report") or url:lower():find("detect") then
                    warn("[AntiDetection] 🌐 Blocked suspicious HTTP request: " .. url)
                    return "{}"
                end
                return oldHttpGet(self, url, ...)
            end)
            
            print("[AntiDetection] ✅ Network Protection Active")
        end
    end)
    
    return success
end

-- ============================================
-- REMOTE SPY PROTECTION
-- ============================================
function AntiDetection:SetupRemoteSpyProtection()
    local success = pcall(function()
        -- Detect and disable common remote spy tools
        local spyNames = {
            "SimpleSpy", "RemoteSpy", "Hydroxide", "Dex", 
            "DarkDex", "IY", "InfiniteYield"
        }
        
        for _, spyName in ipairs(spyNames) do
            if getgenv()[spyName] then
                getgenv()[spyName] = nil
                warn("[AntiDetection] 🕵️ Disabled: " .. spyName)
            end
        end
        
        print("[AntiDetection] ✅ Remote Spy Protection Active")
    end)
    
    return success
end

-- ============================================
-- STATUS & MONITORING
-- ============================================
function AntiDetection:GetStatus()
    return {
        Initialized = self.Initialized,
        Protections = self.Protections,
        ActiveConnections = #Connections,
        Version = self.Version
    }
end

function AntiDetection:PrintStatus()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🛡️  NullHub AntiDetection v" .. self.Version)
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("Status: " .. (self.Initialized and "Active" or "Inactive"))
    print("\nProtections:")
    print("  Anti-Kick: " .. (self.Protections.AntiKick and "✅" or "❌"))
    print("  Anti-AFK: " .. (self.Protections.AntiAFK and "✅" or "❌"))
    print("  Hidden: " .. (self.Protections.HiddenFromList and "✅" or "❌"))
    print("  Metatable: " .. (self.Protections.MetatableProtected and "✅" or "❌"))
    print("\nActive Connections: " .. self:GetConnectionCount())
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

function AntiDetection:GetConnectionCount()
    local count = 0
    for _ in pairs(Connections) do
        count = count + 1
    end
    return count
end

-- ============================================
-- DISABLE PROTECTIONS
-- ============================================
function AntiDetection:DisableAntiKick()
    if not self.Protections.AntiKick then return end
    
    -- Restore original functions
    if OriginalFunctions.PlayerKick then
        game:GetService("Players").LocalPlayer.Kick = OriginalFunctions.PlayerKick
    end
    
    if OriginalFunctions.Teleport then
        game:GetService("TeleportService").Teleport = OriginalFunctions.Teleport
    end
    
    self.Protections.AntiKick = false
    print("[AntiDetection] ⚠️ Anti-Kick Disabled")
end

function AntiDetection:DisableAntiAFK()
    if Connections.AntiAFK then
        Connections.AntiAFK:Disconnect()
        Connections.AntiAFK = nil
    end
    
    self.Protections.AntiAFK = false
    print("[AntiDetection] ⚠️ Anti-AFK Disabled")
end

function AntiDetection:DisableAll()
    self:DisableAntiKick()
    self:DisableAntiAFK()
    
    -- Disconnect all connections
    for name, connection in pairs(Connections) do
        if connection and connection.Disconnect then
            connection:Disconnect()
        end
    end
    Connections = {}
    
    self.Initialized = false
    print("[AntiDetection] ⚠️ All protections disabled")
end

-- ============================================
-- INITIALIZE ALL PROTECTIONS
-- ============================================
function AntiDetection:Initialize(config)
    if self.Initialized then
        warn("[AntiDetection] Already initialized!")
        return true
    end
    
    print("[AntiDetection] Initializing protection system...")
    
    -- Detect executor
    local executor = self:DetectExecutor()
    
    -- Setup protections
    local results = {
        AntiKick = self:SetupAntiKick(),
        AntiAFK = self:SetupAntiAFK(),
        HideFromList = self:HideFromPlayerList(),
        AntiScreenshot = self:SetupAntiScreenshot(),
        NetworkProtection = self:SetupNetworkProtection(),
        RemoteSpyProtection = self:SetupRemoteSpyProtection()
    }
    
    -- Count successes
    local successCount = 0
    local totalCount = 0
    for name, success in pairs(results) do
        totalCount = totalCount + 1
        if success then
            successCount = successCount + 1
        end
    end
    
    self.Initialized = true
    
    print(string.format("[AntiDetection] ✅ Initialized (%d/%d protections active)", successCount, totalCount))
    self:PrintStatus()
    
    return true
end

-- ============================================
-- CLEANUP
-- ============================================
function AntiDetection:Destroy()
    self:DisableAll()
    OriginalFunctions = {}
    print("[AntiDetection] ✅ Cleaned up")
end

-- Export
print("[AntiDetection] Module loaded v" .. AntiDetection.Version)
return AntiDetection
