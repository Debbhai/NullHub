-- ============================================
-- NullHub FullBright.lua - Lighting Enhancement
-- Created by Debbhai
-- Version: 1.0.0
-- Remove darkness and see everything clearly
-- ============================================

local FullBright = {
    Version = "1.0.0",
    Enabled = false,
    OriginalSettings = {},
    IsRestored = false
}

-- Dependencies
local Lighting
local Config, Notifications

-- Internal State
local SavedSettings = {}

-- ============================================
-- INITIALIZATION
-- ============================================
function FullBright:Initialize(config, notifications)
    -- Store dependencies
    Lighting = game:GetService("Lighting")
    Config = config
    Notifications = notifications
    
    -- Save original lighting settings
    self:SaveOriginalLighting()
    
    print("[FullBright] ✅ Initialized")
    return true
end

-- ============================================
-- SAVE ORIGINAL LIGHTING
-- ============================================
function FullBright:SaveOriginalLighting()
    if self.IsRestored then
        -- Already have saved settings
        return
    end
    
    SavedSettings = {
        -- Ambient & Brightness
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        
        -- Color Shifts
        ColorShiftBottom = Lighting.ColorShiftBottom,
        ColorShiftTop = Lighting.ColorShiftTop,
        
        -- Outdoor
        OutdoorAmbient = Lighting.OutdoorAmbient,
        
        -- Time
        ClockTime = Lighting.ClockTime,
        TimeOfDay = Lighting.TimeOfDay,
        
        -- Fog
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor,
        
        -- Effects
        GlobalShadows = Lighting.GlobalShadows,
        
        -- Atmosphere (if exists)
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        
        -- Exposure
        ExposureCompensation = Lighting.ExposureCompensation
    }
    
    self.OriginalSettings = SavedSettings
    self.IsRestored = true
    
    print("[FullBright] 💾 Original lighting saved")
end

-- ============================================
-- APPLY FULL BRIGHT
-- ============================================
function FullBright:ApplyFullBright()
    if not Lighting then return false end
    
    -- Basic Lighting
    Lighting.Ambient = Config.Visual.FULLBRIGHT.AMBIENT or Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = Config.Visual.FULLBRIGHT.BRIGHTNESS or 2
    
    -- Color Shifts (make everything bright)
    Lighting.ColorShiftBottom = Config.Visual.FULLBRIGHT.COLOR_SHIFT or Color3.fromRGB(255, 255, 255)
    Lighting.ColorShiftTop = Config.Visual.FULLBRIGHT.COLOR_SHIFT or Color3.fromRGB(255, 255, 255)
    
    -- Outdoor Lighting
    Lighting.OutdoorAmbient = Config.Visual.FULLBRIGHT.OUTDOOR_AMBIENT or Color3.fromRGB(255, 255, 255)
    
    -- Set time to noon
    Lighting.ClockTime = Config.Visual.FULLBRIGHT.CLOCK_TIME or 12
    
    -- Remove fog
    Lighting.FogEnd = Config.Visual.FULLBRIGHT.FOG_END or 100000
    Lighting.FogStart = Config.Visual.FULLBRIGHT.FOG_START or 0
    
    -- Disable shadows
    Lighting.GlobalShadows = Config.Visual.FULLBRIGHT.GLOBAL_SHADOWS or false
    
    -- Enhanced brightness (if supported)
    if Config.Visual.FULLBRIGHT.ENHANCED_MODE then
        pcall(function()
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            Lighting.ExposureCompensation = 0.5
        end)
    end
    
    print("[FullBright] 💡 Full bright applied")
    return true
end

-- ============================================
-- RESTORE ORIGINAL LIGHTING
-- ============================================
function FullBright:RestoreLighting()
    if not Lighting or not self.IsRestored then return false end
    
    -- Restore all saved settings
    for setting, value in pairs(SavedSettings) do
        pcall(function()
            Lighting[setting] = value
        end)
    end
    
    print("[FullBright] 🌙 Original lighting restored")
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
    
    -- Notify user
    if Notifications then
        Notifications:Show("Full Bright", self.Enabled, nil, 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function FullBright:Enable()
    -- Save settings if not already saved
    if not self.IsRestored then
        self:SaveOriginalLighting()
    end
    
    -- Apply full bright
    self:ApplyFullBright()
    
    print("[FullBright] 💡 Enabled")
end

-- ============================================
-- DISABLE
-- ============================================
function FullBright:Disable()
    -- Restore original lighting
    self:RestoreLighting()
    
    print("[FullBright] ❌ Disabled")
end

-- ============================================
-- PRESET MODES
-- ============================================
function FullBright:SetPreset(presetName)
    local presets = {
        -- Ultra Bright (Maximum visibility)
        UltraBright = {
            AMBIENT = Color3.fromRGB(255, 255, 255),
            BRIGHTNESS = 3,
            COLOR_SHIFT = Color3.fromRGB(255, 255, 255),
            OUTDOOR_AMBIENT = Color3.fromRGB(255, 255, 255),
            CLOCK_TIME = 12,
            FOG_END = 100000,
            GLOBAL_SHADOWS = false,
            ENHANCED_MODE = true
        },
        
        -- Soft Bright (Less harsh)
        SoftBright = {
            AMBIENT = Color3.fromRGB(200, 200, 200),
            BRIGHTNESS = 2,
            COLOR_SHIFT = Color3.fromRGB(220, 220, 220),
            OUTDOOR_AMBIENT = Color3.fromRGB(220, 220, 220),
            CLOCK_TIME = 12,
            FOG_END = 50000,
            GLOBAL_SHADOWS = false,
            ENHANCED_MODE = false
        },
        
        -- Neon Bright (Colorful)
        NeonBright = {
            AMBIENT = Color3.fromRGB(180, 200, 255),
            BRIGHTNESS = 2.5,
            COLOR_SHIFT = Color3.fromRGB(200, 220, 255),
            OUTDOOR_AMBIENT = Color3.fromRGB(200, 220, 255),
            CLOCK_TIME = 14,
            FOG_END = 75000,
            GLOBAL_SHADOWS = false,
            ENHANCED_MODE = true
        },
        
        -- Warm Bright (Sunset vibes)
        WarmBright = {
            AMBIENT = Color3.fromRGB(255, 220, 180),
            BRIGHTNESS = 2,
            COLOR_SHIFT = Color3.fromRGB(255, 230, 200),
            OUTDOOR_AMBIENT = Color3.fromRGB(255, 230, 200),
            CLOCK_TIME = 16,
            FOG_END = 60000,
            GLOBAL_SHADOWS = false,
            ENHANCED_MODE = false
        }
    }
    
    local preset = presets[presetName]
    if not preset then
        warn("[FullBright] Unknown preset: " .. presetName)
        return false
    end
    
    -- Update config
    Config.Visual.FULLBRIGHT = preset
    
    -- Reapply if enabled
    if self.Enabled then
        self:ApplyFullBright()
    end
    
    if Notifications then
        Notifications:Show("Full Bright", true, "Preset: " .. presetName, 2)
    end
    
    print("[FullBright] Preset applied: " .. presetName)
    return true
end

-- ============================================
-- CUSTOM BRIGHTNESS
-- ============================================
function FullBright:SetBrightness(brightness)
    brightness = math.clamp(brightness, 0, 5)
    Config.Visual.FULLBRIGHT.BRIGHTNESS = brightness
    
    if self.Enabled then
        Lighting.Brightness = brightness
    end
    
    print("[FullBright] Brightness set to: " .. brightness)
end

function FullBright:SetAmbient(color)
    Config.Visual.FULLBRIGHT.AMBIENT = color
    
    if self.Enabled then
        Lighting.Ambient = color
    end
    
    print("[FullBright] Ambient color updated")
end

-- ============================================
-- GET SETTINGS
-- ============================================
function FullBright:GetCurrentSettings()
    return {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ColorShiftBottom = Lighting.ColorShiftBottom,
        ColorShiftTop = Lighting.ColorShiftTop,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows
    }
end

function FullBright:GetOriginalSettings()
    return SavedSettings
end

-- ============================================
-- RESET TO DEFAULTS
-- ============================================
function FullBright:ResetToDefaults()
    Config.Visual.FULLBRIGHT = {
        AMBIENT = Color3.fromRGB(255, 255, 255),
        BRIGHTNESS = 2,
        COLOR_SHIFT = Color3.fromRGB(255, 255, 255),
        OUTDOOR_AMBIENT = Color3.fromRGB(255, 255, 255),
        CLOCK_TIME = 12,
        FOG_END = 100000,
        FOG_START = 0,
        GLOBAL_SHADOWS = false,
        ENHANCED_MODE = true
    }
    
    if self.Enabled then
        self:ApplyFullBright()
    end
    
    print("[FullBright] Reset to defaults")
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function FullBright:OnRespawn(newCharacter, newHumanoid, newRootPart)
    -- Full bright persists across respawns
    if self.Enabled then
        task.wait(0.5)
        self:ApplyFullBright()
    end
    
    print("[FullBright] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function FullBright:Destroy()
    self:Disable()
    SavedSettings = {}
    self.IsRestored = false
    
    print("[FullBright] ✅ Destroyed")
end

-- Export
print("[FullBright] Module loaded v" .. FullBright.Version)
return FullBright
