-- Theme.lua - NullHub Theme System
-- Created by Debbhai

local ThemeModule = {}

-- ============================================
-- THEME DEFINITIONS
-- ============================================
ThemeModule.Themes = {
    Dark = {
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
            NotificationBg = Color3.fromRGB(15, 15, 18),
        },
        Transparency = {
            MainBackground = 0.08,
            Header = 0.05,
            Sidebar = 0.1,
            Container = 0.15,
            Input = 0.2,
            Dropdown = 0.15,
            PlayerButton = 0.25,
            CloseButton = 0.1,
            Stroke = 0.5,
            AccentBar = 0.2,
            StatusIndicator = 0,
            ScrollBar = 0.4,
            Tab = 0.2,
            ToggleButton = 0.1,
            Notification = 0.1,
        },
    },
    
    Light = {
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
            NotificationBg = Color3.fromRGB(255, 255, 255),
        },
        Transparency = {
            MainBackground = 0.05,
            Header = 0,
            Sidebar = 0.05,
            Container = 0,
            Input = 0.05,
            Dropdown = 0,
            PlayerButton = 0.1,
            CloseButton = 0,
            Stroke = 0.3,
            AccentBar = 0,
            StatusIndicator = 0,
            ScrollBar = 0.3,
            Tab = 0.05,
            ToggleButton = 0,
            Notification = 0.05,
        },
    },
    
    Grayish = {
        Colors = {
            MainBackground = Color3.fromRGB(45, 45, 50),
            HeaderBackground = Color3.fromRGB(50, 50, 55),
            SidebarBackground = Color3.fromRGB(42, 42, 47),
            ContainerBackground = Color3.fromRGB(55, 55, 60),
            InputBackground = Color3.fromRGB(60, 60, 65),
            DropdownBackground = Color3.fromRGB(58, 58, 63),
            PlayerButtonBg = Color3.fromRGB(65, 65, 70),
            TabNormal = Color3.fromRGB(48, 48, 53),
            TabSelected = Color3.fromRGB(65, 65, 72),
            AccentBar = Color3.fromRGB(150, 150, 200),
            ScrollBarColor = Color3.fromRGB(150, 150, 200),
            StatusOff = Color3.fromRGB(200, 80, 80),
            StatusOn = Color3.fromRGB(100, 200, 150),
            ContainerOff = Color3.fromRGB(55, 55, 60),
            ContainerOn = Color3.fromRGB(65, 70, 80),
            TextPrimary = Color3.fromRGB(230, 230, 240),
            TextSecondary = Color3.fromRGB(170, 170, 190),
            TextPlaceholder = Color3.fromRGB(130, 130, 150),
            BorderColor = Color3.fromRGB(80, 80, 90),
            CloseButton = Color3.fromRGB(200, 80, 90),
            MinimizeButton = Color3.fromRGB(200, 160, 0),
            ToggleButton = Color3.fromRGB(150, 150, 200),
            NotificationBg = Color3.fromRGB(50, 50, 55),
        },
        Transparency = {
            MainBackground = 0.1,
            Header = 0.08,
            Sidebar = 0.12,
            Container = 0.15,
            Input = 0.2,
            Dropdown = 0.15,
            PlayerButton = 0.25,
            CloseButton = 0.1,
            Stroke = 0.4,
            AccentBar = 0.15,
            StatusIndicator = 0,
            ScrollBar = 0.35,
            Tab = 0.18,
            ToggleButton = 0.12,
            Notification = 0.1,
        },
    },
    
    Neon = {
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
            NotificationBg = Color3.fromRGB(10, 10, 20),
        },
        Transparency = {
            MainBackground = 0.05,
            Header = 0.03,
            Sidebar = 0.08,
            Container = 0.12,
            Input = 0.15,
            Dropdown = 0.12,
            PlayerButton = 0.2,
            CloseButton = 0.08,
            Stroke = 0.3,
            AccentBar = 0.1,
            StatusIndicator = 0,
            ScrollBar = 0.3,
            Tab = 0.15,
            ToggleButton = 0.08,
            Notification = 0.08,
        },
    },
    
    Onyx = {
        Colors = {
            MainBackground = Color3.fromRGB(0, 0, 0),
            HeaderBackground = Color3.fromRGB(5, 5, 8),
            SidebarBackground = Color3.fromRGB(3, 3, 5),
            ContainerBackground = Color3.fromRGB(8, 8, 12),
            InputBackground = Color3.fromRGB(12, 12, 16),
            DropdownBackground = Color3.fromRGB(10, 10, 14),
            PlayerButtonBg = Color3.fromRGB(15, 15, 20),
            TabNormal = Color3.fromRGB(6, 6, 10),
            TabSelected = Color3.fromRGB(18, 18, 25),
            AccentBar = Color3.fromRGB(200, 200, 200),
            ScrollBarColor = Color3.fromRGB(180, 180, 180),
            StatusOff = Color3.fromRGB(150, 50, 50),
            StatusOn = Color3.fromRGB(200, 200, 200),
            ContainerOff = Color3.fromRGB(8, 8, 12),
            ContainerOn = Color3.fromRGB(20, 20, 28),
            TextPrimary = Color3.fromRGB(240, 240, 245),
            TextSecondary = Color3.fromRGB(140, 140, 160),
            TextPlaceholder = Color3.fromRGB(100, 100, 120),
            BorderColor = Color3.fromRGB(30, 30, 40),
            CloseButton = Color3.fromRGB(180, 50, 60),
            MinimizeButton = Color3.fromRGB(200, 150, 0),
            ToggleButton = Color3.fromRGB(200, 200, 200),
            NotificationBg = Color3.fromRGB(5, 5, 8),
        },
        Transparency = {
            MainBackground = 0.02,
            Header = 0,
            Sidebar = 0.05,
            Container = 0.1,
            Input = 0.15,
            Dropdown = 0.1,
            PlayerButton = 0.2,
            CloseButton = 0.05,
            Stroke = 0.6,
            AccentBar = 0.15,
            StatusIndicator = 0,
            ScrollBar = 0.45,
            Tab = 0.15,
            ToggleButton = 0.05,
            Notification = 0.05,
        },
    },
}

-- ============================================
-- THEME SIZES & FONTS (UNIVERSAL)
-- ============================================
ThemeModule.Sizes = {
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
    NotificationWidth = 320,
    NotificationHeight = 60,
}

ThemeModule.CornerRadius = {
    Large = 14,
    Medium = 10,
    Small = 7,
    Tiny = 5,
}

ThemeModule.Fonts = {
    Title = Enum.Font.GothamBold,
    Tab = Enum.Font.GothamMedium,
    Action = Enum.Font.Gotham,
    Input = Enum.Font.Gotham,
}

ThemeModule.FontSizes = {
    Title = 19,
    Tab = 15,
    Action = 14,
    Input = 13,
}

-- ============================================
-- CURRENT THEME
-- ============================================
ThemeModule.CurrentTheme = "Dark"

function ThemeModule:GetTheme()
    return self.Themes[self.CurrentTheme] or self.Themes.Dark
end

function ThemeModule:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = themeName
        return true
    end
    return false
end

return ThemeModule
