-- NullHub Theme.lua
-- Dark Geometric with Gold Accents
-- By Debbhai

return {
    -- Background Image Settings
    BackgroundImage = "rbxassetid://YOUR_ASSET_ID", -- Replace after uploading your geometric image
    BackgroundTransparency = 0.3,
    BackgroundTileSize = UDim2.new(0, 300, 0, 300),
    
    -- Colors (Dark + Gold matching your geometric image)
    Colors = {
        -- Main backgrounds (Dark)
        MainBackground = Color3.fromRGB(18, 18, 20),
        HeaderBackground = Color3.fromRGB(22, 22, 25),
        ContainerBackground = Color3.fromRGB(28, 28, 32),
        InputBackground = Color3.fromRGB(25, 25, 28),
        ToggleButtonBg = Color3.fromRGB(20, 20, 25),
        DropdownBackground = Color3.fromRGB(35, 35, 45),
        PlayerButtonBg = Color3.fromRGB(45, 45, 55),
        
        -- Gold accents (from your geometric pattern)
        AccentPrimary = Color3.fromRGB(218, 165, 32),      -- Dark gold
        AccentSecondary = Color3.fromRGB(255, 215, 0),     -- Bright gold
        AccentBar = Color3.fromRGB(255, 215, 0),           -- Header bar gold
        ScrollBarColor = Color3.fromRGB(218, 165, 32),     -- Gold scrollbar
        
        -- Button colors
        ButtonNormal = Color3.fromRGB(35, 35, 40),
        ButtonActive = Color3.fromRGB(50, 50, 55),
        
        -- Status indicators
        StatusOff = Color3.fromRGB(200, 50, 50),           -- Red when OFF
        StatusOn = Color3.fromRGB(218, 165, 32),           -- Gold when ON!
        
        -- Container active state
        ContainerOff = Color3.fromRGB(25, 25, 35),
        ContainerOn = Color3.fromRGB(30, 35, 50),
        
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
        Dropdown = 0.3,
        PlayerButton = 0.4,
        CloseButton = 0.2,
        Stroke = 0.6,
        StrokeGold = 0.5,
        AccentBar = 0.3,
        BackgroundImage = 0.3,
        StatusIndicator = 0.2,
        ScrollBar = 0.5,
    },
    
    -- Sizes
    Sizes = {
        MainFrameWidth = 480,
        MainFrameHeight = 600,
        ToggleButton = 50,
        HeaderHeight = 60,
        CloseButton = 45,
        ButtonHeight = 40,
        StatusIndicator = 12,
        ContainerHeight = 48,
        ContainerHeightInput = 98,
        ContainerHeightDropdown = 115,
        InputHeight = 42,
        DropdownHeight = 58,
        PlayerButtonHeight = 26,
        ScrollBarThickness = 6,
        HintWidth = 80,
        HintHeight = 20,
    },
    
    -- Corner radius
    CornerRadius = {
        Large = 16,
        Medium = 10,
        Small = 8,
        Circle = 0.5,
        Tiny = 6,
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
        PlayerButton = 13,
    },
    
    -- Padding/spacing
    Padding = {
        ButtonLeft = 10,
        InputLeft = 8,
        ScrollFrame = 5,
        List = 10,
        DropdownList = 3,
    },
}
