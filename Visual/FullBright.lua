-- ============================================
-- NullHub FullBright.lua - FIXED VERSION
-- Created by Debbhai
-- Version: 1.0.1 HOTFIX
-- Safe property access with pcall
-- ============================================

local FullBright = {
    Version = "1.0.1",
    Enabled = false,
    CurrentPreset = "Standard",
    OriginalSettings = {}
}

-- Dependencies
local Lighting
local Config, Notifications

-- ============================================
-- INITIALIZATION
-- ============================================
function FullBright:Initialize(config, notifications)
    Lighting = game:GetService("Lighting")
    Config = config
    Notifications = notifications
    
    -- Save original settings (with safe access)
    self:SaveOriginalSettings()
    
    print("[FullBright] ✅ Initialized")
    return true
end

-- ============================================
-- SAVE ORIGINAL SETTINGS (SAFE)
-- ============================================
function FullBright:SaveOriginalSettings()
    local properties = {
        "Brightness", "Ambient", "ColorShift_Top", "ColorShift_Bottom",
        "OutdoorAmbient", "ClockTime", "FogEnd", "FogStart", "GlobalShadows",
        "EnvironmentDiffuseScale", "EnvironmentSpecularScale"
    }
    
    for _, prop in pairs(properties) do
        pcall(function()
            self.OriginalSettings[prop] = Lighting[prop]
        end)
    end
    
    print("[FullBright] Original settings saved")
end

-- ============================================
-- PRESETS (SAFE APPLICATION)
-- ============================================
local Presets = {
    Standard = {
        Brightness = 2,
        Ambient = Color3.fromRGB(255, 255, 255),
        ColorShift_Top = Color3.fromRGB(0, 0, 0),
        ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
        OutdoorAmbient = Color3.fromRGB(255, 255, 255),
        ClockTime = 12,
        FogEnd = 100000,
        FogStart = 0,
        GlobalShadows = false
    },
    UltraBright = {
        Brightness = 5,
        Ambient = Color3.fromRGB(255, 255, 255),
        ColorShift_Top = Color3.fromRGB(255, 255, 255),
        ColorShift_Bottom = Color3.fromRGB(255, 255, 255),
        OutdoorAmbient = Color3.fromRGB(255, 255, 255),
        ClockTime = 14,
        FogEnd = 999999,
        FogStart = 0,
        GlobalShadows = false,
        EnvironmentDiffuseScale = 1,
        EnvironmentSpecularScale = 1
    },
    SoftBright = {
        Brightness = 1.5,
        Ambient = Color3.fromRGB(200, 200, 200),
        ColorShift_Top = Color3.fromRGB(0, 0, 0),
        ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
        OutdoorAmbient = Color3.fromRGB(200, 200, 200),
        ClockTime = 13,
        FogEnd = 50000,
        FogStart = 0,
        GlobalShadows = false
    },
    NeonBright = {
        Brightness = 3,
        Ambient = Color3.fromRGB(150, 200, 255),
        ColorShift_Top = Color3.fromRGB(100, 150, 255),
        ColorShift_Bottom = Color3.fromRGB(50, 100, 200),
        OutdoorAmbient = Color3.fromRGB(150, 200, 255),
        ClockTime = 12,
        FogEnd = 100000,
        FogStart = 0,
        GlobalShadows = false
    }
}

-- ============================================
-- APPLY PRESET (WITH SAFE PCALL)
-- ============================================
function FullBright:ApplyPreset(presetName)
    local preset = Presets[presetName]
    if not preset then
        warn("[FullBright] Preset not found: " .. presetName)
        return false
    end
    
    print("[FullBright] Applying preset: " .. presetName)
    
    for property, value in pairs(preset) do
        pcall(function()
            Lighting[property] = value
        end)
    end
    
    self.CurrentPreset = presetName
    return true
end

-- ============================================
-- TOGGLE
-- ============================================
function FullBright:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    if Notifications then
        Notifications:Show("FullBright", self.Enabled, self.CurrentPreset, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function FullBright:Enable()
    self:ApplyPreset(self.CurrentPreset)
    print("[FullBright] 💡 Enabled (" .. self.CurrentPreset .. ")")
end

-- ============================================
-- DISABLE
-- ============================================
function FullBright:Disable()
    -- Restore original settings (with safe access)
    for property, value in pairs(self.OriginalSettings) do
        pcall(function()
            Lighting[property] = value
        end)
    end
    
    print("[FullBright] ❌ Disabled")
end

-- ============================================
-- SET PRESET
-- ============================================
function FullBright:SetPreset(presetName)
    if not Presets[presetName] then
        warn("[FullBright] Invalid preset: " .. presetName)
        return false
    end
    
    self.CurrentPreset = presetName
    
    if self.Enabled then
        self:ApplyPreset(presetName)
    end
    
    if Notifications then
        Notifications:Show("FullBright Preset", true, presetName, 2)
    end
    
    return true
end

-- ============================================
-- GET AVAILABLE PRESETS
-- ============================================
function FullBright:GetPresets()
    local names = {}
    for name, _ in pairs(Presets) do
        table.insert(names, name)
    end
    return names
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function FullBright:OnRespawn(newCharacter, newHumanoid, newRootPart)
    if self.Enabled then
        task.wait(0.5)
        self:ApplyPreset(self.CurrentPreset)
    end
    
    print("[FullBright] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function FullBright:Destroy()
    if self.Enabled then
        self:Disable()
    end
    print("[FullBright] ✅ Destroyed")
end

print("[FullBright] Module loaded v" .. FullBright.Version)
return FullBright
