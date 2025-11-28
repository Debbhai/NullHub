-- NullHub Theme.lua
-- Dark Geometric with Gold Accents

return {
    -- Background Image Settings
    BackgroundImage = "rbxassetid://110435551666217", -- Replace with your uploaded image ID
    BackgroundTransparency = 0.3,
    BackgroundTileSize = UDim2.new(0, 300, 0, 300),
    
    -- Colors (Dark + Gold matching your image)
    Colors = {
        -- Main backgrounds
        MainBackground = Color3.fromRGB(18, 18, 20),
        HeaderBackground = Color3.fromRGB(22, 22, 25),
        ContainerBackground = Color3.fromRGB(28, 28, 32),
        InputBackground = Color3.fromRGB(25, 25, 28),
        ToggleButtonBg = Color3.fromRGB(20, 20, 25),
        
        -- Gold accents (from your geometric image)
        AccentPrimary = Color3.fromRGB(218, 165, 32),      -- Dark gold
        AccentSecondary = Color3.fromRGB(255, 215, 0),     -- Bright gold
        AccentBar = Color3.fromRGB(255, 215, 0),           -- Header bar
        
        -- Button colors
        ButtonNormal = Color3.fromRGB(35, 35, 40),
        ButtonHover = Color3.fromRGB(45, 45, 50),
        ButtonActive = Color3.fromRGB(50, 50, 55),
        
        -- Status indicators
        StatusOff = Color3.fromRGB(180, 50, 50),
        StatusOn = Color3.fromRGB(218, 165, 32),           -- Gold when ON!
        
        -- Text colors
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 180),
        TextPlaceholder = Color3.fromRGB(150, 150, 150),
        TextHint = Color3.fromRGB(200, 200, 200),
        
        -- Border/Stroke colors (Gold theme!)
        BorderColor = Color3.fromRGB(60, 60, 80),
        StrokeGold = Color3.fromRGB(218, 165, 32),         -- Gold stroke
        StrokeGoldBright = Color3.fromRGB(255, 215, 0),    -- Bright gold
        
        -- Close button
        CloseButton = Color3.fromRGB(200, 50, 60),
    },
    
    -- Transparency values
    Transparency = {
        MainBackground = 0.15,
        ToggleButton = 0.3,
        Header = 0.2,
        Container = 0.3,
        Input = 0.3,
        CloseButton = 0.2,
        Stroke = 0.6,
        AccentBar = 0.3,
        BackgroundImage = 0.3,
    },
    
    -- Sizes
    Sizes = {
        MainFrameWidth = 480,
        MainFrameHeight = 600,
        ToggleButton = 50,
        HeaderHeight = 60,
        CloseButton = 45,
        ButtonHeight = 40,
        ContainerHeight = 48,
        InputHeight = 42,
        DropdownHeight = 58,
    },
    
    -- Corner radius
    CornerRadius = {
        Large = 16,
        Medium = 10,
        Small = 8,
        Circle = 0.5,
    },
    
    -- Fonts
    Fonts = {
        Title = Enum.Font.GothamBold,
        Subtitle = Enum.Font.Gotham,
        Button = Enum.Font.GothamSemibold,
        Input = Enum.Font.Gotham,
        Hint = Enum.Font.Gotham,
    },
    
    -- Font sizes
    FontSizes = {
        Title = 22,
        Subtitle = 12,
        Button = 15,
        Hint = 11,
        Input = 14,
    },
}
