-- ============================================
-- NullHub Theme.lua - Theme Management System
-- Created by Debbhai
-- Version: 1.0.3 COMPLETE FIX
-- All 11 themes + Instant refresh support
-- ============================================

local Theme = {
    Version = "1.0.3",
    CurrentTheme = "Dark",
    ThemeCount = 11,
    OnThemeChanged = nil,
    GUI = nil
}

-- ============================================
-- SHARED SIZE DEFINITIONS
-- ============================================
Theme.Sizes = {
    MainFrameWidth = 680,
    MainFrameHeight = 450,
    SidebarWidth = 150,
    HeaderHeight = 45,
    CloseButton = 38,
    TabHeight = 40,
    ActionRowHeight = 46,
    StatusIndicator = 12,
    InputHeight = 36,
    DropdownHeight = 90,
    PlayerButtonHeight = 28,
    ScrollBarThickness = 5,
    ToggleButton = 55,
    NotificationWidth = 300,
    NotificationHeight = 60
}

Theme.CornerRadius = {
    Large = 14,
    Medium = 10,
    Small = 7,
    Tiny = 5
}

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
-- ALL 11 THEME DEFINITIONS
-- ============================================
Theme.Themes = {
    -- ==========================================
    -- 1. DARK THEME (Default)
    -- ==========================================
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

    -- ==========================================
    -- 2. LIGHT THEME
    -- ==========================================
    Light = {
        Description = "Clean light theme for daytime use",
        Colors = {
            MainBackground = Color3.fromRGB(245, 245, 250),
            HeaderBackground = Color3.fromRGB(255, 255, 255),
            SidebarBackground = Color3.fromRGB(240, 240, 245),
            ContainerBackground = Color3.fromRGB(255, 255, 255),
            InputBackground = Color3.fromRGB(248, 248, 250),
            DropdownBackground = Color3.fromRGB(252, 252, 254),
            PlayerButtonBg = Color3.fromRGB(245, 245, 248),
            TabNormal = Color3.fromRGB(235, 235, 240),
            TabSelected = Color3.fromRGB(220, 220, 230),
            AccentBar = Color3.fromRGB(100, 100, 255),
            ScrollBarColor = Color3.fromRGB(100, 100, 255),
            StatusOff = Color3.fromRGB(255, 100, 100),
            StatusOn = Color3.fromRGB(100, 200, 100),
            ContainerOff = Color3.fromRGB(255, 255, 255),
            ContainerOn = Color3.fromRGB(230, 240, 255),
            TextPrimary = Color3.fromRGB(20, 20, 30),
            TextSecondary = Color3.fromRGB(80, 80, 100),
            TextPlaceholder = Color3.fromRGB(140, 140, 160),
            BorderColor = Color3.fromRGB(200, 200, 210),
            CloseButton = Color3.fromRGB(255, 100, 110),
            MinimizeButton = Color3.fromRGB(255, 200, 0),
            ToggleButton = Color3.fromRGB(100, 100, 255),
            NotificationBg = Color3.fromRGB(255, 255, 255)
        },
        Transparency = {
            MainBackground = 0.02, Header = 0, Sidebar = 0.02, Container = 0,
            Input = 0.02, Dropdown = 0, PlayerButton = 0.05, CloseButton = 0,
            Stroke = 0.3, AccentBar = 0, StatusIndicator = 0, ScrollBar = 0.3,
            Tab = 0.02, ToggleButton = 0, Notification = 0.02
        }
    },

    -- ==========================================
    -- 3. NEON THEME
    -- ==========================================
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

    -- ==========================================
    -- 4. OCEAN THEME
    -- ==========================================
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

    -- ==========================================
    -- 5. SUNSET THEME
    -- ==========================================
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

    -- ==========================================
    -- 6. FOREST THEME
    -- ==========================================
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
            MinimizeButton = Color3.fromRGB(255, 200, 80),
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

    -- ==========================================
    -- 7. PURPLE THEME
    -- ==========================================
    Purple = {
        Description = "Royal purple theme with mystical vibes",
        Colors = {
            MainBackground = Color3.fromRGB(25, 15, 40),
            HeaderBackground = Color3.fromRGB(35, 20, 55),
            SidebarBackground = Color3.fromRGB(30, 18, 48),
            ContainerBackground = Color3.fromRGB(40, 25, 60),
            InputBackground = Color3.fromRGB(48, 30, 70),
            DropdownBackground = Color3.fromRGB(52, 33, 75),
            PlayerButtonBg = Color3.fromRGB(58, 38, 82),
            TabNormal = Color3.fromRGB(35, 20, 55),
            TabSelected = Color3.fromRGB(60, 40, 90),
            AccentBar = Color3.fromRGB(180, 100, 255),
            ScrollBarColor = Color3.fromRGB(200, 120, 255),
            StatusOff = Color3.fromRGB(220, 80, 120),
            StatusOn = Color3.fromRGB(150, 220, 180),
            ContainerOff = Color3.fromRGB(40, 25, 60),
            ContainerOn = Color3.fromRGB(60, 40, 85),
            TextPrimary = Color3.fromRGB(240, 230, 255),
            TextSecondary = Color3.fromRGB(200, 180, 230),
            TextPlaceholder = Color3.fromRGB(150, 130, 180),
            BorderColor = Color3.fromRGB(80, 50, 120),
            CloseButton = Color3.fromRGB(220, 80, 120),
            MinimizeButton = Color3.fromRGB(255, 180, 120),
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

    -- ==========================================
    -- 8. MIDNIGHT THEME
    -- ==========================================
    Midnight = {
        Description = "Deep blue midnight theme",
        Colors = {
            MainBackground = Color3.fromRGB(8, 8, 20),
            HeaderBackground = Color3.fromRGB(12, 12, 28),
            SidebarBackground = Color3.fromRGB(10, 10, 24),
            ContainerBackground = Color3.fromRGB(15, 15, 32),
            InputBackground = Color3.fromRGB(18, 18, 38),
            DropdownBackground = Color3.fromRGB(20, 20, 42),
            PlayerButtonBg = Color3.fromRGB(23, 23, 48),
            TabNormal = Color3.fromRGB(12, 12, 28),
            TabSelected = Color3.fromRGB(25, 25, 55),
            AccentBar = Color3.fromRGB(100, 150, 255),
            ScrollBarColor = Color3.fromRGB(120, 170, 255),
            StatusOff = Color3.fromRGB(200, 70, 90),
            StatusOn = Color3.fromRGB(100, 220, 170),
            ContainerOff = Color3.fromRGB(15, 15, 32),
            ContainerOn = Color3.fromRGB(30, 35, 60),
            TextPrimary = Color3.fromRGB(230, 240, 255),
            TextSecondary = Color3.fromRGB(160, 180, 220),
            TextPlaceholder = Color3.fromRGB(110, 130, 170),
            BorderColor = Color3.fromRGB(40, 45, 80),
            CloseButton = Color3.fromRGB(200, 70, 90),
            MinimizeButton = Color3.fromRGB(240, 190, 80),
            ToggleButton = Color3.fromRGB(100, 150, 255),
            NotificationBg = Color3.fromRGB(12, 12, 28)
        },
        Transparency = {
            MainBackground = 0.05, Header = 0.03, Sidebar = 0.08, Container = 0.12,
            Input = 0.15, Dropdown = 0.12, PlayerButton = 0.2, CloseButton = 0.08,
            Stroke = 0.4, AccentBar = 0.15, StatusIndicator = 0, ScrollBar = 0.35,
            Tab = 0.15, ToggleButton = 0.08, Notification = 0.08
        }
    },

    -- ==========================================
    -- 9. CHERRY THEME
    -- ==========================================
    Cherry = {
        Description = "Sweet cherry red theme",
        Colors = {
            MainBackground = Color3.fromRGB(35, 15, 20),
            HeaderBackground = Color3.fromRGB(50, 20, 30),
            SidebarBackground = Color3.fromRGB(43, 18, 25),
            ContainerBackground = Color3.fromRGB(55, 25, 35),
            InputBackground = Color3.fromRGB(63, 30, 43),
            DropdownBackground = Color3.fromRGB(67, 33, 47),
            PlayerButtonBg = Color3.fromRGB(73, 38, 53),
            TabNormal = Color3.fromRGB(50, 20, 30),
            TabSelected = Color3.fromRGB(80, 35, 50),
            AccentBar = Color3.fromRGB(255, 80, 120),
            ScrollBarColor = Color3.fromRGB(255, 100, 140),
            StatusOff = Color3.fromRGB(220, 80, 80),
            StatusOn = Color3.fromRGB(120, 220, 150),
            ContainerOff = Color3.fromRGB(55, 25, 35),
            ContainerOn = Color3.fromRGB(75, 40, 55),
            TextPrimary = Color3.fromRGB(255, 230, 240),
            TextSecondary = Color3.fromRGB(220, 180, 200),
            TextPlaceholder = Color3.fromRGB(160, 130, 150),
            BorderColor = Color3.fromRGB(100, 50, 70),
            CloseButton = Color3.fromRGB(255, 80, 100),
            MinimizeButton = Color3.fromRGB(255, 180, 120),
            ToggleButton = Color3.fromRGB(255, 80, 120),
            NotificationBg = Color3.fromRGB(50, 20, 30)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    },

    -- ==========================================
    -- 10. AQUA THEME
    -- ==========================================
    Aqua = {
        Description = "Fresh aqua teal theme",
        Colors = {
            MainBackground = Color3.fromRGB(15, 30, 35),
            HeaderBackground = Color3.fromRGB(20, 45, 50),
            SidebarBackground = Color3.fromRGB(18, 38, 43),
            ContainerBackground = Color3.fromRGB(25, 50, 58),
            InputBackground = Color3.fromRGB(30, 58, 65),
            DropdownBackground = Color3.fromRGB(33, 62, 70),
            PlayerButtonBg = Color3.fromRGB(38, 68, 78),
            TabNormal = Color3.fromRGB(20, 45, 50),
            TabSelected = Color3.fromRGB(35, 70, 80),
            AccentBar = Color3.fromRGB(0, 220, 200),
            ScrollBarColor = Color3.fromRGB(50, 230, 210),
            StatusOff = Color3.fromRGB(220, 90, 90),
            StatusOn = Color3.fromRGB(80, 230, 180),
            ContainerOff = Color3.fromRGB(25, 50, 58),
            ContainerOn = Color3.fromRGB(40, 70, 80),
            TextPrimary = Color3.fromRGB(230, 255, 250),
            TextSecondary = Color3.fromRGB(170, 220, 210),
            TextPlaceholder = Color3.fromRGB(120, 170, 165),
            BorderColor = Color3.fromRGB(50, 90, 100),
            CloseButton = Color3.fromRGB(220, 90, 90),
            MinimizeButton = Color3.fromRGB(255, 200, 80),
            ToggleButton = Color3.fromRGB(0, 220, 200),
            NotificationBg = Color3.fromRGB(20, 45, 50)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    },

    -- ==========================================
    -- 11. ROSE THEME
    -- ==========================================
    Rose = {
        Description = "Soft rose pink theme",
        Colors = {
            MainBackground = Color3.fromRGB(40, 25, 35),
            HeaderBackground = Color3.fromRGB(55, 35, 48),
            SidebarBackground = Color3.fromRGB(48, 30, 42),
            ContainerBackground = Color3.fromRGB(60, 40, 52),
            InputBackground = Color3.fromRGB(68, 48, 60),
            DropdownBackground = Color3.fromRGB(72, 52, 64),
            PlayerButtonBg = Color3.fromRGB(78, 58, 70),
            TabNormal = Color3.fromRGB(55, 35, 48),
            TabSelected = Color3.fromRGB(85, 55, 72),
            AccentBar = Color3.fromRGB(255, 150, 180),
            ScrollBarColor = Color3.fromRGB(255, 170, 195),
            StatusOff = Color3.fromRGB(220, 80, 80),
            StatusOn = Color3.fromRGB(150, 220, 150),
            ContainerOff = Color3.fromRGB(60, 40, 52),
            ContainerOn = Color3.fromRGB(80, 55, 70),
            TextPrimary = Color3.fromRGB(255, 240, 245),
            TextSecondary = Color3.fromRGB(220, 190, 205),
            TextPlaceholder = Color3.fromRGB(170, 145, 160),
            BorderColor = Color3.fromRGB(100, 70, 88),
            CloseButton = Color3.fromRGB(255, 100, 120),
            MinimizeButton = Color3.fromRGB(255, 200, 150),
            ToggleButton = Color3.fromRGB(255, 150, 180),
            NotificationBg = Color3.fromRGB(55, 35, 48)
        },
        Transparency = {
            MainBackground = 0.08, Header = 0.05, Sidebar = 0.1, Container = 0.15,
            Input = 0.2, Dropdown = 0.15, PlayerButton = 0.25, CloseButton = 0.1,
            Stroke = 0.5, AccentBar = 0.2, StatusIndicator = 0, ScrollBar = 0.4,
            Tab = 0.2, ToggleButton = 0.1, Notification = 0.1
        }
    }
}

-- Recalculate ThemeCount
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

function Theme:GetTheme()
    local base = self.Themes[self.CurrentTheme] or self.Themes.Dark
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
        
        -- Immediately refresh GUI
        if self.GUI and self.GUI.RefreshTheme then
            self.GUI:RefreshTheme()
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

print("[Theme] ✅ Loaded " .. tostring(Theme.ThemeCount) .. " themes")
return Theme
