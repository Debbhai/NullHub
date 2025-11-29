-- AntiDetection.lua - NullHub Anti-Detection Module
-- Save this file separately in your GitHub repo

local AntiDetection = {}

-- ============================================
-- ANTI-KICK PROTECTION
-- ============================================
function AntiDetection:SetupAntiKick()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Block common kick methods
        if method == "Kick" or method == "kick" then
            warn("[AntiDetection] Blocked Kick attempt!")
            return
        end
        
        -- Block anti-cheat detection
        if method == "FireServer" or method == "InvokeServer" then
            if tostring(self):lower():find("anti") or 
               tostring(self):lower():find("detect") or 
               tostring(self):lower():find("kick") or
               tostring(self):lower():find("ban") then
                warn("[AntiDetection] Blocked suspicious remote call!")
                return
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("[AntiDetection] ✅ Anti-Kick Active")
end

-- ============================================
-- ANTI-AFK SYSTEM
-- ============================================
function AntiDetection:SetupAntiAFK()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    print("[AntiDetection] ✅ Anti-AFK Active")
end

-- ============================================
-- STEALTH HELPERS
-- ============================================
function AntiDetection:AddRandomDelay(stealthMode)
    if stealthMode then
        task.wait(math.random(1, 50) / 1000) -- Random 1-50ms delay
    end
end

function AntiDetection:SmoothTransition(targetValue, currentValue, smoothness, stealthMode)
    if stealthMode then
        return currentValue + (targetValue - currentValue) * smoothness
    end
    return targetValue
end

function AntiDetection:GetVariableSmoothness(baseSmoothness, stealthMode)
    if stealthMode then
        return baseSmoothness + math.random(1, 5) / 100 -- Add 0.01-0.05 variation
    end
    return baseSmoothness
end

-- ============================================
-- HIDE FROM DETECTION
-- ============================================
function AntiDetection:HideFromPlayerList()
    pcall(function()
        local success = pcall(function()
            game:GetService("CoreGui").RobloxGui.PlayerListMaster.Visible = false
        end)
        if success then
            print("[AntiDetection] ✅ Hidden from player list")
        end
    end)
end

-- ============================================
-- INITIALIZE ALL PROTECTIONS
-- ============================================
function AntiDetection:Initialize()
    print("[AntiDetection] Initializing protections...")
    self:SetupAntiKick()
    self:SetupAntiAFK()
    self:HideFromPlayerList()
    print("[AntiDetection] ✅ All protections active!")
    return true
end

-- Return the module
return AntiDetection
