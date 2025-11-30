-- ============================================
-- NullHub Config.lua - Configuration Manager  
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- Optimized & Fixed
-- ============================================

local Config = {
    Version = "1.0.0",
    Author = "Debbhai"
}

-- ============================================
-- GUI SETTINGS
-- ============================================
Config.GUI = {
    TOGGLE_KEY = Enum.KeyCode.Insert,
    START_VISIBLE = true,
    DRAGGABLE = true,
    DEFAULT_THEME = "Dark"
}

-- ============================================
-- COMBAT SETTINGS
-- ============================================
Config.Combat = {
    AIMBOT = {
        KEY = Enum.KeyCode.E,
        FOV = 250,
        SMOOTHNESS = 0.15,
        PREDICT_MOVEMENT = true,
        PREDICTION_FACTOR = 0.1,
        TEAM_CHECK = false,
        VISIBLE_CHECK = false
    },
    ESP = {
        KEY = Enum.KeyCode.T,
        COLOR = Color3.fromRGB(255, 80, 80),
        SHOW_DISTANCE = true,
        SHOW_NAME = true,
        SHOW_HEALTH = false,
        TEAM_CHECK = false,
        MAX_DISTANCE = 1000
    },
    KILLAURA = {
        KEY = Enum.KeyCode.K,
        RANGE = 25,
        DELAY = 0.15,
        ATTACK_PLAYERS = true,
        ATTACK_NPCS = true,
        TEAM_CHECK = false,
        FACE_TARGET = false
    },
    FASTM1 = {
        KEY = Enum.KeyCode.M,
        DELAY = 0.05,
        RANDOMIZE_DELAY = false,
        MIN_DELAY = 0.03,
        MAX_DELAY = 0.08
    }
}

-- ============================================
-- MOVEMENT SETTINGS (FIXED)
-- ============================================
Config.Movement = {
    FLY = {
        KEY = Enum.KeyCode.F,
        SPEED = 120,
        MIN_SPEED = 10,
        MAX_SPEED = 300,
        SMOOTH_MOVEMENT = true
    },
    NOCLIP = {
        KEY = Enum.KeyCode.N
    },
    INFJUMP = {
        KEY = Enum.KeyCode.J,
        JUMP_POWER = 50,
        AUTO_JUMP = false
    },
    SPEED = {
        KEY = Enum.KeyCode.X,
        VALUE = 50, -- FIXED: Changed from 100 to 50
        MIN_VALUE = 0,
        MAX_VALUE = 1000000,
        DEFAULT_VALUE = 16,
        SMOOTH_TRANSITION = true
    },
    WALKONWATER = {
        KEY = Enum.KeyCode.U,
        PLATFORM_SIZE = Vector3.new(10, 0.8, 10),
        PLATFORM_TRANSPARENCY = 0.5,
        PLATFORM_COLOR = Color3.fromRGB(100, 200, 255),
        HEIGHT_OFFSET = 1,
        BLOX_FRUITS_MODE = true
    }
}

-- ============================================
-- VISUAL SETTINGS
-- ============================================
Config.Visual = {
    FULLBRIGHT = {
        KEY = Enum.KeyCode.B,
        BRIGHTNESS = 2,
        AMBIENT = Color3.fromRGB(255, 255, 255),
        COLOR_SHIFT = Color3.fromRGB(255, 255, 255),
        OUTDOOR_AMBIENT = Color3.fromRGB(255, 255, 255),
        CLOCK_TIME = 12,
        FOG_END = 100000,
        FOG_START = 0,
        GLOBAL_SHADOWS = false,
        ENHANCED_MODE = true
    },
    GODMODE = {
        KEY = Enum.KeyCode.V,
        AUTO_RESPAWN = false,
        CONTINUOUS_UPDATE = false,
        PREVENT_RAGDOLL = false,
        SHOW_FORCEFIELD = false
    }
}

-- ============================================
-- TELEPORT SETTINGS (FIXED)
-- ============================================
Config.Teleport = {
    TELEPORT_TO_PLAYER = {
        KEY = Enum.KeyCode.Z,
        SPEED = 150,
        MIN_SPEED = 50,
        MAX_SPEED = 500,
        OFFSET_DISTANCE = 3, -- FIXED: Separated from vector
        OFFSET_HEIGHT = 3,   -- FIXED: Separated from vector
        MIN_DURATION = 0.5,
        MAX_DURATION = 10,
        SMOOTH_TWEEN = true
    }
}

-- ============================================
-- ANTI-DETECTION SETTINGS
-- ============================================
Config.AntiDetection = {
    STEALTH_MODE = true,
    RANDOMIZE_DELAYS = true,
    HUMANIZE_MOVEMENTS = true,
    VARIABLE_SMOOTHNESS = true,
    HIDE_FROM_LOGS = true
}

-- ============================================
-- NOTIFICATION SETTINGS
-- ============================================
Config.Notifications = {
    ENABLED = true,
    DURATION = 3,
    POSITION = "TopRight",
    SHOW_ICONS = true,
    ANIMATION_SPEED = 0.5,
    MAX_QUEUE = 5
}

-- ============================================
-- GAME-SPECIFIC SETTINGS
-- ============================================
Config.GameSpecific = {
    BLOX_FRUITS = {
        ENABLED = true,
        WATER_DETECTION_ENHANCED = true,
        FAST_ATTACK_COMPATIBLE = true
    },
    AUTO_DETECT_GAME = true
}

-- ============================================
-- PRESETS (OPTIMIZED)
-- ============================================
Config.Presets = {
    Legit = {
        Combat = {AIMBOT = {SMOOTHNESS = 0.3, FOV = 100}, KILLAURA = {RANGE = 15, DELAY = 0.25}},
        Movement = {SPEED = {VALUE = 25}, FLY = {SPEED = 50}}
    },
    Rage = {
        Combat = {AIMBOT = {SMOOTHNESS = 0.05, FOV = 360}, KILLAURA = {RANGE = 50, DELAY = 0.05}},
        Movement = {SPEED = {VALUE = 1000000}, FLY = {SPEED = 300}}
    },
    Balanced = {} -- Uses current config values
}

-- ============================================
-- UTILITY FUNCTIONS (OPTIMIZED)
-- ============================================

-- Get config value by path
function Config:Get(path)
    local value = self
    for key in path:gmatch("[^.]+") do
        value = type(value) == "table" and value[key] or nil
        if not value then return nil end
    end
    return value
end

-- Set config value by path
function Config:Set(path, newValue)
    local keys, current = {}, self
    for key in path:gmatch("[^.]+") do
        table.insert(keys, key)
    end
    
    for i = 1, #keys - 1 do
        current[keys[i]] = current[keys[i]] or {}
        current = current[keys[i]]
    end
    
    current[keys[#keys]] = newValue
    return true
end

-- Validate config value
function Config:Validate(category, setting, value)
    if category == "Movement" and setting == "SPEED" and type(value) == "number" then
        return value >= self.Movement.SPEED.MIN_VALUE and value <= self.Movement.SPEED.MAX_VALUE
    end
    if category == "Combat" and setting == "AIMBOT" and type(value) == "table" and value.FOV then
        return value.FOV >= 10 and value.FOV <= 360
    end
    return true
end

-- Apply preset (OPTIMIZED)
function Config:ApplyPreset(presetName)
    local preset = self.Presets[presetName]
    if not preset then return false end
    
    for category, features in pairs(preset) do
        if self[category] then
            for feature, settings in pairs(features) do
                if self[category][feature] then
                    for key, value in pairs(settings) do
                        self[category][feature][key] = value
                    end
                end
            end
        end
    end
    
    print("[Config] ✅ Preset applied: " .. presetName)
    return true
end

-- Get all keybinds (OPTIMIZED)
function Config:GetAllKeybinds()
    local keybinds = {}
    local definitions = {
        {category = "GUI", name = "Toggle GUI", key = "TOGGLE_KEY"},
        {category = "Combat.AIMBOT", name = "Aimbot"},
        {category = "Combat.ESP", name = "ESP"},
        {category = "Combat.KILLAURA", name = "Kill Aura"},
        {category = "Combat.FASTM1", name = "Fast M1"},
        {category = "Movement.FLY", name = "Fly"},
        {category = "Movement.NOCLIP", name = "NoClip"},
        {category = "Movement.INFJUMP", name = "Infinite Jump"},
        {category = "Movement.SPEED", name = "Speed"},
        {category = "Movement.WALKONWATER", name = "Walk on Water"},
        {category = "Visual.FULLBRIGHT", name = "Full Bright"},
        {category = "Visual.GODMODE", name = "God Mode"},
        {category = "Teleport.TELEPORT_TO_PLAYER", name = "Teleport"}
    }
    
    for _, def in pairs(definitions) do
        local key = self:Get(def.category .. "." .. (def.key or "KEY"))
        if key then
            table.insert(keybinds, {name = def.name, key = key})
        end
    end
    
    return keybinds
end

-- Export/Import
function Config:Export()
    return {
        GUI = self.GUI,
        Combat = self.Combat,
        Movement = self.Movement,
        Visual = self.Visual,
        Teleport = self.Teleport,
        AntiDetection = self.AntiDetection,
        Notifications = self.Notifications
    }
end

function Config:Import(data)
    if not data then return false end
    
    for category, settings in pairs(data) do
        if self[category] then
            for key, value in pairs(settings) do
                if self[category][key] then
                    self[category][key] = value
                end
            end
        end
    end
    return true
end

print("[Config] ✅ Configuration loaded v" .. Config.Version)
return Config
