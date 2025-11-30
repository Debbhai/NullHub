-- ============================================
-- NullHub Theme.lua - Theme Management System
-- Created by Debbhai
-- Version: 1.0.0 FINAL
-- 11 Themes - Optimized & Compressed
-- ============================================

local Theme = {
    Version = "1.0.0",
    CurrentTheme = "Dark",
    ThemeCount = 11
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
    
    -- DARK THEME (Default)
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
    
    -- LIGHT THEME
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
    
    -- NEON THEME
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
    },
    
    -- GRAYISH THEME
    Grayish = {
        Description = "Professional gray theme",
        Colors = {
            MainBackground = Color3.fromRGB(45, 45, 48),
            HeaderBackground = Color3.fromRGB(55, 55, 58),
            SidebarBackground = Color3.fromRGB(50, 50, 53),
            ContainerBackground = Color3.fromRGB(60, 60, 65),
            InputBackground = Color3.fromRGB(65, 65, 70),
            DropdownBackground = Color3.fromRGB(68, 68, 73),
            PlayerButtonBg = Color3.fromRGB(70, 70, 75),
            TabNormal = Color3.fromRGB(55, 55, 60),
            TabSelected = Color3.fromRGB(75, 75, 85),
            AccentBar = Color3.fromRGB(180, 180, 190),
            ScrollBarColor = Color3.fromRGB(160, 160, 170),
            StatusOff = Color3.fromRGB(200, 80, 80),
            StatusOn = Color3.fromRGB(100, 200, 120),
            ContainerOff = Color3.fromRGB(60, 60, 65),
            ContainerOn = Color3.fromRGB(80, 85, 95),
            TextPrimary = Color3.fromRGB(230, 230, 235),
            TextSecondary = Color3.fromRGB(180, 180, 190),
            TextPlaceholder = Color3.fromRGB(130, 130, 140),
            BorderColor = Color3.fromRGB(80, 80, 85),
            CloseButton = Color3.fromRGB(200, 70, 80),
            MinimizeButton = Color3.fromRGB(220, 180, 50),
            ToggleButton = Color3.fromRGB(180, 180, 190),
            NotificationBg = Color3.fromRGB(50, 50, 53)
        },
        Transparency = {
            MainBackground = 0.1, Header = 0.05, Sidebar = 0.12, Container = 0.15,
            Input = 0.18, Dropdown = 0.15, PlayerButton = 0.22, CloseButton = 0.1,
            Stroke = 0.4, AccentBar = 0.15, StatusIndicator = 0, ScrollBar = 0.35,
            Tab = 0.18, ToggleButton = 0.12, Notification = 0.1
        }
    },
    
    -- ONYX THEME
    Onyx = {
        Description = "Deep black theme with subtle highlights",
        Colors = {
            MainBackground = Color3.fromRGB(15, 15, 17),
            HeaderBackground = Color3.fromRGB(20, 20, 23),
            SidebarBackground = Color3.fromRGB(18, 18, 20),
            ContainerBackground = Color3.fromRGB(25, 25, 28),
            InputBackground = Color3.fromRGB(30, 30, 33),
            DropdownBackground = Color3.fromRGB(32, 32, 35),
            PlayerButtonBg = Color3.fromRGB(35, 35, 38),
            TabNormal = Color3.fromRGB(22, 22, 25),
            TabSelected = Color3.fromRGB(40, 40, 45),
            AccentBar = Color3.fromRGB(200, 200, 210),
            ScrollBarColor = Color3.fromRGB(180, 180, 190),
            StatusOff = Color3.fromRGB(180, 60, 60),
            StatusOn = Color3.fromRGB(80, 200, 120),
            ContainerOff = Color3.fromRGB(25, 25, 28),
            ContainerOn = Color3.fromRGB(40, 42, 48),
            TextPrimary = Color3.fromRGB(240, 240, 245),
            TextSecondary = Color3.fromRGB(170, 170, 180),
            TextPlaceholder = Color3.fromRGB(120, 120, 130),
            BorderColor = Color3.fromRGB(50, 50, 55),
            CloseButton = Color3.fromRGB(200, 65, 75),
            MinimizeButton = Color3.fromRGB(230, 190, 60),
            ToggleButton = Color3.fromRGB(200, 200, 210),
            NotificationBg = Color3.fromRGB(20, 20, 23)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.14,
            Input = 0.18, Dropdown = 0.14, PlayerButton = 0.23, CloseButton = 0.1,
            Stroke = 0.45, AccentBar = 0.18, StatusIndicator = 0, ScrollBar = 0.38,
            Tab = 0.18, ToggleButton = 0.1, Notification = 0.1
        }
    },
    
    -- OCEAN THEME
    Ocean = {
        Description = "Cool blue ocean theme",
        Colors = {
            MainBackground = Color3.fromRGB(10, 25, 40),
            HeaderBackground = Color3.fromRGB(15, 35, 55),
            SidebarBackground = Color3.fromRGB(12, 30, 48),
            ContainerBackground = Color3.fromRGB(18, 40, 60),
            InputBackground = Color3.fromRGB(22, 45, 68),
            DropdownBackground = Color3.fromRGB(25, 48, 72),
            PlayerButtonBg = Color3.fromRGB(28, 52, 78),
            TabNormal = Color3.fromRGB(15, 35, 55),
            TabSelected = Color3.fromRGB(30, 60, 90),
            AccentBar = Color3.fromRGB(50, 150, 255),
            ScrollBarColor = Color3.fromRGB(70, 170, 255),
            StatusOff = Color3.fromRGB(200, 80, 100),
            StatusOn = Color3.fromRGB(80, 220, 180),
            ContainerOff = Color3.fromRGB(18, 40, 60),
            ContainerOn = Color3.fromRGB(30, 55, 85),
            TextPrimary = Color3.fromRGB(230, 245, 255),
            TextSecondary = Color3.fromRGB(150, 190, 220),
            TextPlaceholder = Color3.fromRGB(100, 140, 180),
            BorderColor = Color3.fromRGB(40, 80, 120),
            CloseButton = Color3.fromRGB(220, 80, 100),
            MinimizeButton = Color3.fromRGB(255, 200, 80),
            ToggleButton = Color3.fromRGB(50, 150, 255),
            NotificationBg = Color3.fromRGB(15, 35, 55)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    },
    
    -- SUNSET THEME
    Sunset = {
        Description = "Warm sunset theme with orange accents",
        Colors = {
            MainBackground = Color3.fromRGB(40, 20, 35),
            HeaderBackground = Color3.fromRGB(55, 30, 50),
            SidebarBackground = Color3.fromRGB(48, 25, 43),
            ContainerBackground = Color3.fromRGB(60, 35, 55),
            InputBackground = Color3.fromRGB(68, 40, 63),
            DropdownBackground = Color3.fromRGB(72, 43, 67),
            PlayerButtonBg = Color3.fromRGB(78, 48, 73),
            TabNormal = Color3.fromRGB(55, 30, 50),
            TabSelected = Color3.fromRGB(90, 50, 80),
            AccentBar = Color3.fromRGB(255, 120, 80),
            ScrollBarColor = Color3.fromRGB(255, 140, 100),
            StatusOff = Color3.fromRGB(220, 80, 100),
            StatusOn = Color3.fromRGB(120, 220, 150),
            ContainerOff = Color3.fromRGB(60, 35, 55),
            ContainerOn = Color3.fromRGB(85, 50, 75),
            TextPrimary = Color3.fromRGB(255, 230, 240),
            TextSecondary = Color3.fromRGB(220, 180, 200),
            TextPlaceholder = Color3.fromRGB(160, 130, 150),
            BorderColor = Color3.fromRGB(100, 60, 90),
            CloseButton = Color3.fromRGB(255, 80, 100),
            MinimizeButton = Color3.fromRGB(255, 180, 100),
            ToggleButton = Color3.fromRGB(255, 120, 80),
            NotificationBg = Color3.fromRGB(55, 30, 50)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    },
    
    -- FOREST THEME
    Forest = {
        Description = "Natural green forest theme",
        Colors = {
            MainBackground = Color3.fromRGB(20, 35, 25),
            HeaderBackground = Color3.fromRGB(30, 50, 35),
            SidebarBackground = Color3.fromRGB(25, 43, 30),
            ContainerBackground = Color3.fromRGB(35, 55, 40),
            InputBackground = Color3.fromRGB(40, 63, 48),
            DropdownBackground = Color3.fromRGB(43, 67, 52),
            PlayerButtonBg = Color3.fromRGB(48, 73, 58),
            TabNormal = Color3.fromRGB(30, 50, 35),
            TabSelected = Color3.fromRGB(50, 80, 60),
            AccentBar = Color3.fromRGB(100, 220, 120),
            ScrollBarColor = Color3.fromRGB(120, 230, 140),
            StatusOff = Color3.fromRGB(200, 100, 80),
            StatusOn = Color3.fromRGB(100, 230, 120),
            ContainerOff = Color3.fromRGB(35, 55, 40),
            ContainerOn = Color3.fromRGB(50, 75, 60),
            TextPrimary = Color3.fromRGB(230, 255, 240),
            TextSecondary = Color3.fromRGB(180, 220, 190),
            TextPlaceholder = Color3.fromRGB(130, 170, 140),
            BorderColor = Color3.fromRGB(60, 90, 70),
            CloseButton = Color3.fromRGB(220, 100, 80),
            MinimizeButton = Color3.fromRGB(255, 200, 100),
            ToggleButton = Color3.fromRGB(100, 220, 120),
            NotificationBg = Color3.fromRGB(30, 50, 35)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    },
    
    -- PURPLE THEME
    Purple = {
        Description = "Royal purple theme",
        Colors = {
            MainBackground = Color3.fromRGB(25, 15, 40),
            HeaderBackground = Color3.fromRGB(35, 20, 55),
            SidebarBackground = Color3.fromRGB(30, 18, 48),
            ContainerBackground = Color3.fromRGB(40, 25, 60),
            InputBackground = Color3.fromRGB(48, 30, 70),
            DropdownBackground = Color3.fromRGB(52, 33, 75),
            PlayerButtonBg = Color3.fromRGB(58, 38, 82),
            TabNormal = Color3.fromRGB(35, 20, 55),
            TabSelected = Color3.fromRGB(60, 35, 90),
            AccentBar = Color3.fromRGB(180, 100, 255),
            ScrollBarColor = Color3.fromRGB(200, 120, 255),
            StatusOff = Color3.fromRGB(220, 80, 120),
            StatusOn = Color3.fromRGB(150, 100, 255),
            ContainerOff = Color3.fromRGB(40, 25, 60),
            ContainerOn = Color3.fromRGB(60, 40, 85),
            TextPrimary = Color3.fromRGB(245, 235, 255),
            TextSecondary = Color3.fromRGB(200, 180, 220),
            TextPlaceholder = Color3.fromRGB(150, 130, 170),
            BorderColor = Color3.fromRGB(80, 50, 110),
            CloseButton = Color3.fromRGB(220, 80, 120),
            MinimizeButton = Color3.fromRGB(255, 180, 100),
            ToggleButton = Color3.fromRGB(180, 100, 255),
            NotificationBg = Color3.fromRGB(35, 20, 55)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    },
    
    -- CRIMSON THEME
    Crimson = {
        Description = "Bold red crimson theme",
        Colors = {
            MainBackground = Color3.fromRGB(35, 10, 15),
            HeaderBackground = Color3.fromRGB(50, 15, 20),
            SidebarBackground = Color3.fromRGB(43, 12, 18),
            ContainerBackground = Color3.fromRGB(55, 18, 25),
            InputBackground = Color3.fromRGB(63, 22, 30),
            DropdownBackground = Color3.fromRGB(67, 25, 33),
            PlayerButtonBg = Color3.fromRGB(73, 28, 38),
            TabNormal = Color3.fromRGB(50, 15, 20),
            TabSelected = Color3.fromRGB(80, 25, 35),
            AccentBar = Color3.fromRGB(255, 50, 80),
            ScrollBarColor = Color3.fromRGB(255, 80, 100),
            StatusOff = Color3.fromRGB(180, 60, 80),
            StatusOn = Color3.fromRGB(100, 220, 150),
            ContainerOff = Color3.fromRGB(55, 18, 25),
            ContainerOn = Color3.fromRGB(75, 30, 42),
            TextPrimary = Color3.fromRGB(255, 240, 245),
            TextSecondary = Color3.fromRGB(220, 180, 190),
            TextPlaceholder = Color3.fromRGB(170, 130, 140),
            BorderColor = Color3.fromRGB(100, 40, 50),
            CloseButton = Color3.fromRGB(255, 50, 80),
            MinimizeButton = Color3.fromRGB(255, 180, 100),
            ToggleButton = Color3.fromRGB(255, 50, 80),
            NotificationBg = Color3.fromRGB(50, 15, 20)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    },
    
    -- MIDNIGHT THEME
    Midnight = {
        Description = "Deep midnight blue theme",
        Colors = {
            MainBackground = Color3.fromRGB(8, 12, 25),
            HeaderBackground = Color3.fromRGB(12, 18, 35),
            SidebarBackground = Color3.fromRGB(10, 15, 30),
            ContainerBackground = Color3.fromRGB(15, 22, 40),
            InputBackground = Color3.fromRGB(18, 26, 48),
            DropdownBackground = Color3.fromRGB(20, 28, 52),
            PlayerButtonBg = Color3.fromRGB(24, 32, 58),
            TabNormal = Color3.fromRGB(12, 18, 35),
            TabSelected = Color3.fromRGB(25, 38, 65),
            AccentBar = Color3.fromRGB(80, 150, 255),
            ScrollBarColor = Color3.fromRGB(100, 170, 255),
            StatusOff = Color3.fromRGB(200, 80, 100),
            StatusOn = Color3.fromRGB(80, 200, 255),
            ContainerOff = Color3.fromRGB(15, 22, 40),
            ContainerOn = Color3.fromRGB(28, 42, 70),
            TextPrimary = Color3.fromRGB(230, 240, 255),
            TextSecondary = Color3.fromRGB(160, 180, 220),
            TextPlaceholder = Color3.fromRGB(110, 130, 170),
            BorderColor = Color3.fromRGB(35, 55, 90),
            CloseButton = Color3.fromRGB(220, 80, 100),
            MinimizeButton = Color3.fromRGB(255, 200, 80),
            ToggleButton = Color3.fromRGB(80, 150, 255),
            NotificationBg = Color3.fromRGB(12, 18, 35)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    }
}

-- ============================================
-- THEME FUNCTIONS
-- ============================================

-- Get current theme
function Theme:GetTheme()
    return self.Themes[self.CurrentTheme] or self.Themes.Dark
end

-- Set theme
function Theme:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = themeName
        print("[Theme] ✅ Theme changed to: " .. themeName)
        return true
    else
        warn("[Theme] ❌ Theme not found: " .. themeName)
        return false
    end
end

-- Get all theme names
function Theme:GetAllThemeNames()
    local names = {}
    for name, _ in pairs(self.Themes) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

-- Get accent color
function Theme:GetAccentColor(themeName)
    themeName = themeName or self.CurrentTheme
    local theme = self.Themes[themeName]
    return theme and theme.Colors.AccentBar or Color3.fromRGB(255, 215, 0)
end

-- Print theme info
function Theme:PrintInfo()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🎨 NullHub Theme System v" .. self.Version)
    print("Current: " .. self.CurrentTheme .. " | Total: " .. self.ThemeCount)
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

print("[Theme] ✅ Loaded " .. Theme.ThemeCount .. " themes")
return Theme
