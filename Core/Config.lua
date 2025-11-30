-- ============================================
-- NullHub Config.lua - Configuration Manager
-- Created by Debbhai
-- Version: 1.0.0
-- Centralized configuration for all NullHub features
-- ============================================

local Config = {
    Version = "1.0.0",
    Author = "Debbhai",
    LastModified = "2025-11-30"
}

-- ============================================
-- GUI SETTINGS
-- ============================================
Config.GUI = {
    -- Main Toggle
    TOGGLE_KEY = Enum.KeyCode.Insert,
    
    -- Window Settings
    START_VISIBLE = true,
    DRAGGABLE = true,
    SAVE_POSITION = false, -- Future: remember window position
    
    -- Size Settings (Extracted from Theme)
    WIDTH = 680,
    HEIGHT = 450,
    
    -- Default Theme
    DEFAULT_THEME = "Dark"
}

-- ============================================
-- COMBAT SETTINGS
-- ============================================
Config.Combat = {
    -- Aimbot
    AIMBOT = {
        KEY = Enum.KeyCode.E,
        FOV = 250,
        SMOOTHNESS = 0.15,
        PREDICT_MOVEMENT = true,
        PREDICTION_FACTOR = 0.1,
        TEAM_CHECK = false,
        VISIBLE_CHECK = false,
        STICK_TO_TARGET = false
    },
    
    -- ESP (Wallhack)
    ESP = {
        KEY = Enum.KeyCode.T,
        COLOR = Color3.fromRGB(255, 80, 80),
        SHOW_DISTANCE = true,
        SHOW_NAME = true,
        SHOW_HEALTH = false,
        BOX_ESP = false,
        TEAM_CHECK = false,
        MAX_DISTANCE = 1000
    },
    
    -- Kill Aura
    KILLAURA = {
        KEY = Enum.KeyCode.K,
        RANGE = 25,
        DELAY = 0.15,
        ATTACK_PLAYERS = true,
        ATTACK_NPCS = true,
        TEAM_CHECK = false,
        FACE_TARGET = false,
        AUTO_BLOCK = false
    },
    
    -- Fast M1 (Auto Click)
    FASTM1 = {
        KEY = Enum.KeyCode.M,
        DELAY = 0.05,
        RANDOMIZE_DELAY = false,
        MIN_DELAY = 0.03,
        MAX_DELAY = 0.08
    }
}

-- ============================================
-- MOVEMENT SETTINGS
-- ============================================
Config.Movement = {
    -- Fly
    FLY = {
        KEY = Enum.KeyCode.F,
        SPEED = 120,
        MIN_SPEED = 10,
        MAX_SPEED = 300,
        VERTICAL_SPEED = 120,
        SMOOTH_MOVEMENT = true
    },
    
    -- NoClip
    NOCLIP = {
        KEY = Enum.KeyCode.N,
        AUTO_DISABLE_ON_DEATH = true
    },
    
    -- Infinite Jump
    INFJUMP = {
        KEY = Enum.KeyCode.J,
        JUMP_POWER = 50,
        AUTO_JUMP = false
    },
    
    -- Speed Hack
    SPEED = {
        KEY = Enum.KeyCode.X,
        VALUE = 100,
        MIN_VALUE = 0,
        MAX_VALUE = 1000000,
        DEFAULT_VALUE = 16,
        SMOOTH_TRANSITION = true
    },
    
    -- Walk on Water
    WALKONWATER = {
        KEY = Enum.KeyCode.U,
        PLATFORM_SIZE = Vector3.new(10, 0.8, 10),
        PLATFORM_TRANSPARENCY = 0.5,
        PLATFORM_COLOR = Color3.fromRGB(100, 200, 255),
        HEIGHT_OFFSET = 1,
        AUTO_DETECT = true,
        BLOX_FRUITS_MODE = true
    }
}

-- ============================================
-- VISUAL SETTINGS
-- ============================================
Config.Visual = {
    -- Full Bright
    FULLBRIGHT = {
        KEY = Enum.KeyCode.B,
        BRIGHTNESS = 2,
        AMBIENT = Color3.fromRGB(255, 255, 255),
        CLOCK_TIME = 12,
        FOG_END = 100000,
        DISABLE_SHADOWS = true
    },
    
    -- God Mode
    GODMODE = {
        KEY = Enum.KeyCode.V,
        AUTO_HEAL = true,
        MAX_HEALTH_ONLY = false,
        REMOVE_DEATH_BARRIERS = false
    }
}

-- ============================================
-- TELEPORT SETTINGS
-- ============================================
Config.Teleport = {
    TELEPORT_TO_PLAYER = {
        KEY = Enum.KeyCode.Z,
        SPEED = 150,
        MIN_SPEED = 50,
        MAX_SPEED = 500,
        OFFSET = Vector3.new(0, 3, 3),
        SMOOTH_TWEEN = true,
        TWEEN_STYLE = Enum.EasingStyle.Quint
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
    ANTI_SCREENSHOT = false,
    HIDE_FROM_LOGS = true
}

-- ============================================
-- NOTIFICATION SETTINGS
-- ============================================
Config.Notifications = {
    ENABLED = true,
    DURATION = 3,
    POSITION = "TopRight", -- TopRight, TopLeft, BottomRight, BottomLeft, Center
    SHOW_ICONS = true,
    ANIMATION_SPEED = 0.5,
    MAX_QUEUE = 5,
    SOUND_ENABLED = false
}

-- ============================================
-- GAME-SPECIFIC SETTINGS
-- ============================================
Config.GameSpecific = {
    -- Blox Fruits Optimizations
    BLOX_FRUITS = {
        ENABLED = true,
        WATER_DETECTION_ENHANCED = true,
        AUTO_FARM_COMPATIBLE = false,
        FAST_ATTACK_COMPATIBLE = true
    },
    
    -- Auto-detect game
    AUTO_DETECT_GAME = true
}

-- ============================================
-- ADVANCED SETTINGS
-- ============================================
Config.Advanced = {
    -- Performance
    PERFORMANCE = {
        MAX_FPS = 60,
        REDUCE_LAG = true,
        CACHE_MODULES = true,
        LAZY_LOADING = false
    },
    
    -- Debug
    DEBUG = {
        ENABLED = false,
        VERBOSE_LOGGING = false,
        SHOW_ERRORS = true,
        LOG_FEATURE_USAGE = false
    },
    
    -- Update Settings
    AUTO_UPDATE = {
        ENABLED = true,
        CHECK_ON_LOAD = true,
        NOTIFY_UPDATES = true
    }
}

-- ============================================
-- PRESET CONFIGURATIONS
-- ============================================
Config.Presets = {
    Legit = {
        Description = "Legit settings - hard to detect",
        Combat = {
            AIMBOT = {SMOOTHNESS = 0.3, FOV = 100},
            KILLAURA = {RANGE = 15, DELAY = 0.25}
        },
        Movement = {
            SPEED = {VALUE = 25},
            FLY = {SPEED = 50}
        }
    },
    
    Rage = {
        Description = "Maximum performance - easily detected",
        Combat = {
            AIMBOT = {SMOOTHNESS = 0.05, FOV = 360},
            KILLAURA = {RANGE = 50, DELAY = 0.05}
        },
        Movement = {
            SPEED = {VALUE = 1000000},
            FLY = {SPEED = 300}
        }
    },
    
    Balanced = {
        Description = "Default balanced settings",
        -- Uses current config values
    }
}

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

-- Get a config value by path
function Config:Get(path)
    local keys = {}
    for key in path:gmatch("[^.]+") do
        table.insert(keys, key)
    end
    
    local value = self
    for _, key in ipairs(keys) do
        if type(value) == "table" then
            value = value[key]
        else
            return nil
        end
    end
    
    return value
end

-- Set a config value by path
function Config:Set(path, newValue)
    local keys = {}
    for key in path:gmatch("[^.]+") do
        table.insert(keys, key)
    end
    
    local current = self
    for i = 1, #keys - 1 do
        local key = keys[i]
        if type(current[key]) ~= "table" then
            current[key] = {}
        end
        current = current[key]
    end
    
    current[keys[#keys]] = newValue
    return true
end

-- Validate a config value
function Config:Validate(category, setting, value)
    -- Speed validation
    if category == "Movement" and setting == "SPEED" then
        if type(value) == "number" then
            return value >= self.Movement.SPEED.MIN_VALUE and value <= self.Movement.SPEED.MAX_VALUE
        end
        return false
    end
    
    -- FOV validation
    if category == "Combat" and setting == "AIMBOT" and type(value) == "table" and value.FOV then
        return value.FOV >= 10 and value.FOV <= 360
    end
    
    -- Generic validation
    return true
end

-- Apply a preset configuration
function Config:ApplyPreset(presetName)
    local preset = self.Presets[presetName]
    if not preset then
        warn("[Config] Preset not found: " .. presetName)
        return false
    end
    
    print("[Config] Applying preset: " .. presetName)
    
    -- Apply Combat settings
    if preset.Combat then
        for feature, settings in pairs(preset.Combat) do
            if self.Combat[feature] then
                for key, value in pairs(settings) do
                    self.Combat[feature][key] = value
                end
            end
        end
    end
    
    -- Apply Movement settings
    if preset.Movement then
        for feature, settings in pairs(preset.Movement) do
            if self.Movement[feature] then
                for key, value in pairs(settings) do
                    self.Movement[feature][key] = value
                end
            end
        end
    end
    
    print("[Config] ✅ Preset applied: " .. presetName)
    return true
end

-- Get all keybinds
function Config:GetAllKeybinds()
    local keybinds = {}
    
    -- GUI
    table.insert(keybinds, {name = "Toggle GUI", key = self.GUI.TOGGLE_KEY})
    
    -- Combat
    table.insert(keybinds, {name = "Aimbot", key = self.Combat.AIMBOT.KEY})
    table.insert(keybinds, {name = "ESP", key = self.Combat.ESP.KEY})
    table.insert(keybinds, {name = "Kill Aura", key = self.Combat.KILLAURA.KEY})
    table.insert(keybinds, {name = "Fast M1", key = self.Combat.FASTM1.KEY})
    
    -- Movement
    table.insert(keybinds, {name = "Fly", key = self.Movement.FLY.KEY})
    table.insert(keybinds, {name = "NoClip", key = self.Movement.NOCLIP.KEY})
    table.insert(keybinds, {name = "Infinite Jump", key = self.Movement.INFJUMP.KEY})
    table.insert(keybinds, {name = "Speed", key = self.Movement.SPEED.KEY})
    table.insert(keybinds, {name = "Walk on Water", key = self.Movement.WALKONWATER.KEY})
    
    -- Visual
    table.insert(keybinds, {name = "Full Bright", key = self.Visual.FULLBRIGHT.KEY})
    table.insert(keybinds, {name = "God Mode", key = self.Visual.GODMODE.KEY})
    
    -- Teleport
    table.insert(keybinds, {name = "Teleport to Player", key = self.Teleport.TELEPORT_TO_PLAYER.KEY})
    
    return keybinds
end

-- Export config as table (for saving)
function Config:Export()
    return {
        GUI = self.GUI,
        Combat = self.Combat,
        Movement = self.Movement,
        Visual = self.Visual,
        Teleport = self.Teleport,
        AntiDetection = self.AntiDetection,
        Notifications = self.Notifications,
        GameSpecific = self.GameSpecific,
        Advanced = self.Advanced
    }
end

-- Import config from table (for loading)
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

-- Reset to default values
function Config:Reset()
    print("[Config] Resetting to default values...")
    self:ApplyPreset("Balanced")
    print("[Config] ✅ Reset complete")
end

-- Print current configuration
function Config:Print()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("⚙️  NullHub Configuration v" .. self.Version)
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    print("\n[Combat Settings]")
    print("  Aimbot FOV: " .. self.Combat.AIMBOT.FOV)
    print("  Aimbot Smoothness: " .. self.Combat.AIMBOT.SMOOTHNESS)
    print("  Kill Aura Range: " .. self.Combat.KILLAURA.RANGE)
    
    print("\n[Movement Settings]")
    print("  Fly Speed: " .. self.Movement.FLY.SPEED)
    print("  Speed Value: " .. self.Movement.SPEED.VALUE)
    
    print("\n[Anti-Detection]")
    print("  Stealth Mode: " .. tostring(self.AntiDetection.STEALTH_MODE))
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- Initialize
print("[Config] ✅ Configuration loaded")

return Config
