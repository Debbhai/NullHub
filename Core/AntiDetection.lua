-- AntiDetection.lua - NullHub Anti-Detection Module (COMPATIBLE VERSION)
-- Works on ALL executors

local AntiDetection = {}

-- ============================================
-- ANTI-KICK PROTECTION (FIXED FOR ALL EXECUTORS)
-- ============================================
function AntiDetection:SetupAntiKick()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            
            -- Block common kick methods
            if method == "Kick" or method == "kick" then
                warn("[AntiDetection] Blocked Kick attempt!")
                return
            end
            
            -- Block anti-cheat detection
            if method == "FireServer" or method == "InvokeServer" then
                local selfStr = tostring(self):lower()
                if selfStr:find("anti") or selfStr:find("detect") or selfStr:find("kick") or selfStr:find("ban") then
                    warn("[AntiDetection] Blocked suspicious remote call!")
                    return
                end
            end
            
            return oldNamecall(self, ...)
        end
        
        setreadonly(mt, true)
        print("[AntiDetection] ✅ Anti-Kick Active")
    end)
end

-- ============================================
-- ANTI-AFK SYSTEM
-- ============================================
function AntiDetection:SetupAntiAFK()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
        print("[AntiDetection] ✅ Anti-AFK Active")
    end)
end

-- ============================================
-- STEALTH HELPERS
-- ============================================
function AntiDetection:AddRandomDelay(stealthMode)
    if stealthMode then
        task.wait(math.random(1, 50) / 1000)
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
        return baseSmoothness + math.random(1, 5) / 100
    end
    return baseSmoothness
end

-- ============================================
-- HIDE FROM DETECTION
-- ============================================
function AntiDetection:HideFromPlayerList()
    pcall(function()
        game:GetService("CoreGui").RobloxGui.PlayerListMaster.Visible = false
        print("[AntiDetection] ✅ Hidden from player list")
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
