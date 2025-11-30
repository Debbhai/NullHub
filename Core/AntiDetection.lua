-- ============================================
-- NullHub AntiDetection.lua - Protection System
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- Optimized & Enhanced
-- ============================================

local AntiDetection = {
    Version = "1.0.0",
    Initialized = false,
    Executor = "Unknown",
    Protections = {
        AntiKick = false,
        AntiAFK = false,
        HiddenFromList = false,
        MetatableProtected = false,
        NetworkProtected = false
    }
}

-- Internal Storage
local Connections = {}
local OriginalFunctions = {}

-- ============================================
-- EXECUTOR DETECTION (OPTIMIZED)
-- ============================================
function AntiDetection:DetectExecutor()
    local executors = {
        {name = "Synapse X", check = function() return syn and syn.request end},
        {name = "Script-Ware", check = function() return isscriptware and isscriptware() end},
        {name = "KRNL", check = function() return KRNL_LOADED end},
        {name = "Fluxus", check = function() return fluxus end},
        {name = "Arceus X", check = function() return identifyexecutor and identifyexecutor():lower():find("arceus") end},
        {name = "Solara", check = function() return identifyexecutor and identifyexecutor():lower():find("solara") end},
        {name = "Wave", check = function() return identifyexecutor and identifyexecutor():lower():find("wave") end}
    }
    
    for _, executor in ipairs(executors) do
        local success, result = pcall(executor.check)
        if success and result then
            self.Executor = executor.name
            print("[AntiDetection] Detected: " .. executor.name)
            return executor.name
        end
    end
    
    -- Fallback to identifyexecutor
    local success, executor = pcall(function()
        return identifyexecutor and identifyexecutor() or "Unknown"
    end)
    
    if success and executor ~= "Unknown" then
        self.Executor = executor
        print("[AntiDetection] Detected: " .. executor)
        return executor
    end
    
    print("[AntiDetection] Executor: Unknown")
    return "Unknown"
end

-- ============================================
-- ANTI-KICK PROTECTION (ENHANCED)
-- ============================================
function AntiDetection:SetupAntiKick()
    if self.Protections.AntiKick then
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
                
                -- Block Kick
                if method == "Kick" or method == "kick" then
                    warn("[AntiDetection] 🛡️ Blocked Kick!")
                    return wait(9e9)
                end
                
                -- Block suspicious remotes
                if method == "FireServer" or method == "InvokeServer" then
                    local selfStr = tostring(self):lower()
                    local suspicious = {"anti", "detect", "kick", "ban", "flag", "report", "cheat", "ac"}
                    
                    for _, keyword in ipairs(suspicious) do
                        if selfStr:find(keyword) then
                            warn("[AntiDetection] 🛡️ Blocked: " .. tostring(self))
                            return
                        end
                    end
                    
                    -- Check arguments
                    for _, arg in ipairs(args) do
                        if type(arg) == "string" then
                            for _, keyword in ipairs(suspicious) do
                                if arg:lower():find(keyword) then
                                    warn("[AntiDetection] 🛡️ Blocked arg: " .. arg)
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
        
        -- Method 3: Block Teleport Kicks
        local TeleportService = game:GetService("TeleportService")
        local oldTeleport = TeleportService.Teleport
        TeleportService.Teleport = function(placeId, player, ...)
            if player == game.Players.LocalPlayer then
                warn("[AntiDetection] 🛡️ Blocked teleport kick!")
                return
            end
            return oldTeleport(placeId, player, ...)
        end
        OriginalFunctions.Teleport = oldTeleport
        
        self.Protections.AntiKick = true
        print("[AntiDetection] ✅ Anti-Kick Active (3 Layers)")
    end)
    
    return success
end

-- ============================================
-- ANTI-AFK SYSTEM (ENHANCED)
-- ============================================
function AntiDetection:SetupAntiAFK()
    if self.Protections.AntiAFK then
        return true
    end
    
    local success = pcall(function()
        local Players = game:GetService("Players")
        local VirtualUser = game:GetService("VirtualUser")
        local player = Players.LocalPlayer
        
        -- Method 1: Idled Event
        Connections.AntiAFK = player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
        
        -- Method 2: Periodic Simulation
        task.spawn(function()
            while task.wait(300) do -- Every 5 minutes
                if player and player.Character then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end
        end)
        
        self.Protections.AntiAFK = true
        print("[AntiDetection] ✅ Anti-AFK Active")
    end)
    
    return success
end

-- ============================================
-- STEALTH HELPERS (ENHANCED)
-- ============================================
function AntiDetection:AddRandomDelay(stealthMode)
    if not stealthMode then return end
    local delay = math.random(10, 500) / 10000 -- 1-50ms
    task.wait(delay)
end

function AntiDetection:SmoothTransition(targetValue, currentValue, smoothness, stealthMode)
    if not stealthMode then
        return targetValue
    end
    
    -- Add randomness (±10%)
    local randomFactor = 1 + (math.random(-10, 10) / 100)
    local adjustedSmoothness = smoothness * randomFactor
    
    return currentValue + (targetValue - currentValue) * adjustedSmoothness
end

function AntiDetection:GetVariableSmoothness(baseSmoothness, stealthMode)
    if not stealthMode then
        return baseSmoothness
    end
    
    -- Add variation (±5%)
    local variation = math.random(-50, 50) / 1000
    return math.clamp(baseSmoothness + variation, 0.01, 0.99)
end

function AntiDetection:RandomizeValue(value, variationPercent)
    variationPercent = variationPercent or 10
    local variation = value * (variationPercent / 100)
    return value + math.random(-variation * 100, variation * 100) / 100
end

function AntiDetection:HumanizeMouse(targetPosition, currentPosition, smoothness)
    local distance = (targetPosition - currentPosition).Magnitude
    if distance < 50 then
        return targetPosition
    end
    
    -- Add curve to movement
    local midPoint = (targetPosition + currentPosition) / 2
    local curve = Vector2.new(math.random(-20, 20), math.random(-20, 20))
    
    return currentPosition + (midPoint + curve - currentPosition) * smoothness
end

-- ============================================
-- HIDE FROM PLAYER LIST
-- ============================================
function AntiDetection:HideFromPlayerList()
    if self.Protections.HiddenFromList then
        return true
    end
    
    local success = pcall(function()
        -- Hide from CoreGui PlayerList
        local coreGui = game:GetService("CoreGui")
        if coreGui:FindFirstChild("RobloxGui") then
            local robloxGui = coreGui.RobloxGui
            if robloxGui:FindFirstChild("PlayerListMaster") then
                robloxGui.PlayerListMaster.Visible = false
            end
        end
        
        self.Protections.HiddenFromList = true
        print("[AntiDetection] ✅ Hidden from list")
    end)
    
    return success
end

-- ============================================
-- NETWORK PROTECTION
-- ============================================
function AntiDetection:SetupNetworkProtection()
    local success = pcall(function()
        if not hookfunction then return end
        
        local HttpService = game:GetService("HttpService")
        local oldHttpGet = HttpService.GetAsync
        
        hookfunction(HttpService.GetAsync, function(self, url, ...)
            if url:lower():find("log") or url:lower():find("report") or url:lower():find("detect") then
                warn("[AntiDetection] 🌐 Blocked HTTP: " .. url)
                return "{}"
            end
            return oldHttpGet(self, url, ...)
        end)
        
        self.Protections.NetworkProtected = true
        print("[AntiDetection] ✅ Network Protection Active")
    end)
    
    return success
end

-- ============================================
-- REMOTE SPY PROTECTION
-- ============================================
function AntiDetection:SetupRemoteSpyProtection()
    local success = pcall(function()
        local spyNames = {
            "SimpleSpy", "RemoteSpy", "Hydroxide", 
            "Dex", "DarkDex", "IY", "InfiniteYield"
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
        Executor = self.Executor,
        Protections = self.Protections,
        ActiveConnections = self:GetConnectionCount(),
        Version = self.Version
    }
end

function AntiDetection:GetConnectionCount()
    local count = 0
    for _ in pairs(Connections) do
        count = count + 1
    end
    return count
end

function AntiDetection:PrintStatus()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🛡️ NullHub AntiDetection v" .. self.Version)
    print("Executor: " .. self.Executor)
    print("Status: " .. (self.Initialized and "Active" or "Inactive"))
    print("\nProtections:")
    for name, status in pairs(self.Protections) do
        print(string.format("  %s: %s", name, status and "✅" or "❌"))
    end
    print("Active Connections: " .. self:GetConnectionCount())
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- ============================================
-- DISABLE PROTECTIONS
-- ============================================
function AntiDetection:DisableAntiKick()
    if not self.Protections.AntiKick then return end
    
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
-- INITIALIZE (OPTIMIZED)
-- ============================================
function AntiDetection:Initialize()
    if self.Initialized then
        return true
    end
    
    print("[AntiDetection] Initializing...")
    
    -- Detect executor
    self:DetectExecutor()
    
    -- Setup protections
    local results = {
        self:SetupAntiKick(),
        self:SetupAntiAFK(),
        self:HideFromPlayerList(),
        self:SetupNetworkProtection(),
        self:SetupRemoteSpyProtection()
    }
    
    -- Count successes
    local successCount = 0
    for _, success in pairs(results) do
        if success then successCount = successCount + 1 end
    end
    
    self.Initialized = true
    print(string.format("[AntiDetection] ✅ Initialized (%d/5 protections)", successCount))
    
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

print("[AntiDetection] Module loaded v" .. AntiDetection.Version)
return AntiDetection
