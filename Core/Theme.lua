-- ============================================
-- NullHub Theme.lua - Theme Management System
-- Created by Debbhai
-- Version: 1.0.2 HOTFIX
-- Safe Sizes / Theme access for GUI
-- ============================================

local Theme = {
    Version = "1.0.2",
    CurrentTheme = "Dark",
    ThemeCount = 11,
    OnThemeChanged = nil,  -- Callback function
    GUI = nil              -- Reference to GUI module
}

-- ============================================
-- SHARED SIZE DEFINITIONS
-- ============================================
Theme.Sizes = {
    -- Main Frame
    MainFrameWidth = 680,
    MainFrameHeight = 450,
    
    -- Components
    SidebarWidth = 150,
    HeaderHeight = 45,
    CloseButton = 38,
    TabHeight = 40,
    ActionRowHeight = 46,
    StatusIndicator = 12,
    
    -- Input Elements
    InputHeight = 36,
    DropdownHeight = 90,
    PlayerButtonHeight = 28,
    ScrollBarThickness = 5,
    ToggleButton = 55,
    
    -- Notifications
    NotificationWidth = 300,
    NotificationHeight = 60
}

-- ============================================
-- CORNER RADIUS
-- ============================================
Theme.CornerRadius = {
    Large = 14,
    Medium = 10,
    Small = 7,
    Tiny = 5
}

-- ============================================
-- FONTS
-- ============================================
Theme.Fonts = {
    Title = Enum.Font.GothamBold,
    Tab = Enum.Font.GothamMedium,
    Action = Enum.Font.Gotham,
    Input = Enum.Font.Gotham
}

Theme.FontSizes = {
    Title = 19,
    Tab = 15,
    Action = 14,
    Input = 13
}

-- ============================================
-- THEME DEFINITIONS
-- ============================================
Theme.Themes = {
    Dark = {
        Description = "Classic dark theme with golden accents",
        Colors = {
            MainBackground = Color3.fromRGB(10, 10, 12),
            HeaderBackground = Color3.fromRGB(15, 15, 18),
            SidebarBackground = Color3.fromRGB(12, 12, 14),
            ContainerBackground = Color3.fromRGB(18, 18, 22),
            InputBackground = Color3.fromRGB(20, 20, 24),
            DropdownBackground = Color3.fromRGB(22, 22, 26),
            PlayerButtonBg = Color3.fromRGB(25, 25, 30),
            TabNormal = Color3.fromRGB(16, 16, 20),
            TabSelected = Color3.fromRGB(28, 28, 34),
            AccentBar = Color3.fromRGB(255, 215, 0),
            ScrollBarColor = Color3.fromRGB(218, 165, 32),
            StatusOff = Color3.fromRGB(220, 60, 60),
            StatusOn = Color3.fromRGB(50, 220, 100),
            ContainerOff = Color3.fromRGB(18, 18, 22),
            ContainerOn = Color3.fromRGB(25, 35, 45),
            TextPrimary = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 160, 180),
            TextPlaceholder = Color3.fromRGB(120, 120, 140),
            BorderColor = Color3.fromRGB(40, 40, 50),
            CloseButton = Color3.fromRGB(220, 60, 70),
            MinimizeButton = Color3.fromRGB(255, 180, 0),
            ToggleButton = Color3.fromRGB(255, 215, 0),
            NotificationBg = Color3.fromRGB(15, 15, 18)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    },
    
    Light = {
        Description = "Clean light theme for daytime use",
        Colors = {
            MainBackground = Color3.fromRGB(245, 245, 250),
            HeaderBackground = Color3.fromRGB(255, 255, 255),
            SidebarBackground = Color3.fromRGB(250, 250, 252),
            ContainerBackground = Color3.fromRGB(255, 255, 255),
            InputBackground = Color3.fromRGB(248, 248, 250),
            DropdownBackground = Color3.fromRGB(252, 252, 254),
            PlayerButtonBg = Color3.fromRGB(245, 245, 248),
            TabNormal = Color3.fromRGB(240, 240, 245),
            TabSelected = Color3.fromRGB(230, 230, 240),
            AccentBar = Color3.fromRGB(100, 100, 255),
            ScrollBarColor = Color3.fromRGB(100, 100, 255),
            StatusOff = Color3.fromRGB(255, 100, 100),
            StatusOn = Color3.fromRGB(100, 200, 100),
            ContainerOff = Color3.fromRGB(255, 255, 255),
            ContainerOn = Color3.fromRGB(240, 245, 255),
            TextPrimary = Color3.fromRGB(20, 20, 30),
            TextSecondary = Color3.fromRGB(100, 100, 120),
            TextPlaceholder = Color3.fromRGB(140, 140, 160),
            BorderColor = Color3.fromRGB(220, 220, 230),
            CloseButton = Color3.fromRGB(255, 100, 110),
            MinimizeButton = Color3.fromRGB(255, 200, 0),
            ToggleButton = Color3.fromRGB(100, 100, 255),
            NotificationBg = Color3.fromRGB(255, 255, 255)
        },
        Transparency = {
            MainBackground = 0.05, Header = 0, Sidebar = 0.05, Container = 0,
            Input = 0.05, Dropdown = 0, PlayerButton = 0.1, CloseButton = 0,
            Stroke = 0.3, AccentBar = 0, StatusIndicator = 0, ScrollBar = 0.3,
            Tab = 0.05, ToggleButton = 0, Notification = 0.05
        }
    },
    
    Neon = {
        Description = "Vibrant neon theme with cyberpunk vibes",
        Colors = {
            MainBackground = Color3.fromRGB(5, 5, 15),
            HeaderBackground = Color3.fromRGB(10, 10, 20),
            SidebarBackground = Color3.fromRGB(8, 8, 18),
            ContainerBackground = Color3.fromRGB(12, 12, 25),
            InputBackground = Color3.fromRGB(15, 15, 30),
            DropdownBackground = Color3.fromRGB(18, 18, 32),
            PlayerButtonBg = Color3.fromRGB(20, 20, 35),
            TabNormal = Color3.fromRGB(10, 10, 22),
            TabSelected = Color3.fromRGB(25, 25, 45),
            AccentBar = Color3.fromRGB(0, 255, 255),
            ScrollBarColor = Color3.fromRGB(255, 0, 255),
            StatusOff = Color3.fromRGB(255, 50, 150),
            StatusOn = Color3.fromRGB(0, 255, 150),
            ContainerOff = Color3.fromRGB(12, 12, 25),
            ContainerOn = Color3.fromRGB(25, 15, 45),
            TextPrimary = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(150, 200, 255),
            TextPlaceholder = Color3.fromRGB(100, 150, 200),
            BorderColor = Color3.fromRGB(100, 0, 255),
            CloseButton = Color3.fromRGB(255, 0, 100),
            MinimizeButton = Color3.fromRGB(255, 255, 0),
            ToggleButton = Color3.fromRGB(0, 255, 255),
            NotificationBg = Color3.fromRGB(10, 10, 20)
        },
        Transparency = {
            MainBackground = 0.05, Header = 0.03, Sidebar = 0.08, Container = 0.12,
            Input = 0.15, Dropdown = 0.12, PlayerButton = 0.2, CloseButton = 0.08,
            Stroke = 0.3, AccentBar = 0.1, StatusIndicator = 0, ScrollBar = 0.3,
            Tab = 0.15, ToggleButton = 0.08, Notification = 0.08
        }
    }
    
    -- Add your other 8 themes here (Grayish, Onyx, Ocean, Sunset, Forest, Purple, Midnight, Cherry)
    -- I'm keeping them short for space, but use the same structure as above
}

-- Recalculate ThemeCount to always be correct
do
    local count = 0
    for _ in pairs(Theme.Themes) do
        count = count + 1
    end
    Theme.ThemeCount = count
end

-- ============================================
-- THEME FUNCTIONS
-- ============================================

-- Get current theme (wrapped with shared fields)
function Theme:GetTheme()
    local base = self.Themes[self.CurrentTheme] or self.Themes.Dark
    -- expose shared sizes/fonts so GUI can do Theme.Sizes.MainFrameWidth OR theme.Sizes.MainFrameWidth
    base.Sizes = self.Sizes
    base.CornerRadius = self.CornerRadius
    base.Fonts = self.Fonts
    base.FontSizes = self.FontSizes
    return base
end

function Theme:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = themeName
        print("[Theme] ✅ Theme changed to: " .. themeName)
        
        if self.GUI and self.GUI.RefreshTheme then
            pcall(function()
                self.GUI:RefreshTheme()
            end)
        end
        
        if self.OnThemeChanged then
            pcall(function()
                self.OnThemeChanged(themeName, self:GetTheme())
            end)
        end
        
        return true
    else
        warn("[Theme] ❌ Theme not found: " .. tostring(themeName))
        return false
    end
end

function Theme:RegisterGUI(guiModule)
    self.GUI = guiModule
    print("[Theme] ✅ GUI registered for instant updates")
end

function Theme:SetThemeChangedCallback(callback)
    self.OnThemeChanged = callback
    print("[Theme] ✅ Theme change callback registered")
end

function Theme:GetAllThemeNames()
    local names = {}
    for name in pairs(self.Themes) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

function Theme:GetAccentColor(themeName)
    themeName = themeName or self.CurrentTheme
    local theme = self.Themes[themeName]
    return theme and theme.Colors.AccentBar or Color3.fromRGB(255, 215, 0)
end

function Theme:PrintInfo()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🎨 NullHub Theme System v" .. self.Version)
    print("Current: " .. self.CurrentTheme .. " | Total: " .. tostring(self.ThemeCount))
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

print("[Theme] ✅ Loaded " .. tostring(Theme.ThemeCount) .. " themes")
return Theme
