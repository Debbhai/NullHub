-- NullHub V2.lua 
-- Created by Debbhai

-- ============================================
-- LOAD THEME (ADD THIS NEW SECTION)
-- ============================================
local Theme
local themeLoaded = false

pcall(function()
    Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/Debbhai/NullHub/main/Theme.lua"))()
    themeLoaded = true
    print("[NullHub] Theme loaded successfully!")
end)

-- Fallback if theme fails to load
if not themeLoaded then
    warn("[NullHub] Theme failed to load, using defaults")
    Theme = {
        Colors = {
            MainBackground = Color3.fromRGB(15, 15, 20),
            HeaderBackground = Color3.fromRGB(20, 20, 28),
            -- ... add fallback colors
        }
    }
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = Workspace.CurrentCamera

-- ============================================
-- CONFIG
-- ============================================
local CONFIG = {
    AIMBOT_KEY = Enum.KeyCode.E,
    AIMBOT_FOV = 200,
    AIMBOT_SMOOTHNESS = 0.2,
    
    ESP_KEY = Enum.KeyCode.T,
    ESP_COLOR = Color3.fromRGB(255, 0, 0),
    ESP_SHOW_DISTANCE = true,
    
    NOCLIP_KEY = Enum.KeyCode.N,
    INFJUMP_KEY = Enum.KeyCode.J,
    SPEED_KEY = Enum.KeyCode.X,
    SPEED_VALUE = 100,
    MIN_SPEED = 1,
    MAX_SPEED = 500,
    FULLBRIGHT_KEY = Enum.KeyCode.B,
    GODMODE_KEY = Enum.KeyCode.V,
    TELEPORT_KEY = Enum.KeyCode.Z,
    TELEPORT_SPEED = 80,
    
    KILLAURA_KEY = Enum.KeyCode.K,
    KILLAURA_RANGE = 20,
    KILLAURA_DELAY = 0.15,
    
    FASTM1_KEY = Enum.KeyCode.M,
    FASTM1_DELAY = 0.05,
    
    FLY_KEY = Enum.KeyCode.F,
    FLY_SPEED = 50,
    
    -- NEW: GUI Toggle Key
    GUI_TOGGLE_KEY = Enum.KeyCode.Insert,
}

-- ============================================
-- STATE VARIABLES
-- ============================================
local state = {
    aimbot = false,
    esp = false,
    noclip = false,
    infjump = false,
    speed = false,
    fullbright = false,
    godmode = false,
    killaura = false,
    fastm1 = false,
    fly = false,
}

local espObjects = {}
local originalSpeed = 16
local originalLightingSettings = {}
local godmodeConnection = nil
local isTeleporting = false
local selectedTeleportPlayer = nil
local killAuraConnection = nil
local fastM1Connection = nil
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

-- NEW: GUI Visibility State
local guiVisible = true
local mainFrameRef = nil
local toggleBtnRef = nil

-- ============================================
-- MODERN GUI CREATION
-- ============================================
local function createModernGUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NullHubGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    
    -- Toggle Button (to show/hide GUI)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    toggleBtn.BackgroundTransparency = 0.3
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "N"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 24
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = screenGui
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.5, 0)
    toggleCorner.Parent = toggleBtn
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Color3.fromRGB(100, 100, 255)
    toggleStroke.Thickness = 2
    toggleStroke.Transparency = 0.5
    toggleStroke.Parent = toggleBtn
    
    -- Keybind hint on toggle button
    local keybindHint = Instance.new("TextLabel")
    keybindHint.Size = UDim2.new(0, 80, 0, 20)
    keybindHint.Position = UDim2.new(0, -15, 1, 5)
    keybindHint.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    keybindHint.BackgroundTransparency = 0.3
    keybindHint.BorderSizePixel = 0
    keybindHint.Text = "[Insert]"
    keybindHint.TextColor3 = Color3.fromRGB(200, 200, 200)
    keybindHint.TextSize = 11
    keybindHint.Font = Enum.Font.Gotham
    keybindHint.Parent = toggleBtn
    
    local hintCorner = Instance.new("UICorner")
    hintCorner.CornerRadius = UDim.new(0, 6)
    hintCorner.Parent = keybindHint
    
    -- Main Frame (Modern Black Translucent)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 480, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(60, 60, 80)
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.6
    mainStroke.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header
    
    -- Header Bottom Bar
    local headerBar = Instance.new("Frame")
    headerBar.Size = UDim2.new(1, 0, 0, 2)
    headerBar.Position = UDim2.new(0, 0, 1, -2)
    headerBar.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    headerBar.BackgroundTransparency = 0.3
    headerBar.BorderSizePixel = 0
    headerBar.Parent = header
    
    -- Title with icon
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -110, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ NullHub V2"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -110, 0, 16)
    subtitle.Position = UDim2.new(0, 20, 1, -20)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Advanced Features Hub"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
    subtitle.TextSize = 12
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 45, 0, 45)
    closeBtn.Position = UDim2.new(1, -55, 0, 7.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 28
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 10)
    closeBtnCorner.Parent = closeBtn
    
    -- Scrolling Frame (for content)
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -80)
    scrollFrame.Position = UDim2.new(0, 10, 0, 70)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    scrollFrame.ScrollBarImageTransparency = 0.5
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = mainFrame
    
    local scrollPadding = Instance.new("UIPadding")
    scrollPadding.PaddingLeft = UDim.new(0, 5)
    scrollPadding.PaddingRight = UDim.new(0, 5)
    scrollPadding.Parent = scrollFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollFrame
    
    -- Feature buttons data
    local features = {
        {name = "Aimbot", key = "E", state = "aimbot", icon = "🎯"},
        {name = "ESP", key = "T", state = "esp", icon = "👁️"},
        {name = "KillAura", key = "K", state = "killaura", icon = "⚔️"},
        {name = "Fast M1", key = "M", state = "fastm1", icon = "👊"},
        {name = "Fly", key = "F", state = "fly", icon = "🕊️"},
        {name = "NoClip", key = "N", state = "noclip", icon = "👻"},
        {name = "Infinite Jump", key = "J", state = "infjump", icon = "🦘"},
        {name = "Speed Hack", key = "X", state = "speed", icon = "⚡", hasInput = true},
        {name = "Full Bright", key = "B", state = "fullbright", icon = "💡"},
        {name = "God Mode", key = "V", state = "godmode", icon = "🛡️"},
        {name = "Teleport", key = "Z", state = "teleport", icon = "🚀", isAction = true, hasDropdown = true},
    }
    
    local buttons = {}
    
    -- Create feature buttons
    for i, feature in ipairs(features) do
        local containerHeight = 48
        if feature.hasInput then
            containerHeight = 98
        elseif feature.hasDropdown then
            containerHeight = 115
        end
        
        local container = Instance.new("Frame")
        container.Name = feature.state .. "Container"
        container.Size = UDim2.new(1, 0, 0, containerHeight)
        container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        container.BackgroundTransparency = 0.3
        container.BorderSizePixel = 0
        container.LayoutOrder = i
        container.Parent = scrollFrame
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 10)
        containerCorner.Parent = container
        
        local containerStroke = Instance.new("UIStroke")
        containerStroke.Color = Color3.fromRGB(60, 60, 80)
        containerStroke.Thickness = 1
        containerStroke.Transparency = 0.7
        containerStroke.Parent = container
        
        -- Feature Button
        local featureBtn = Instance.new("TextButton")
        featureBtn.Name = feature.state .. "Btn"
        featureBtn.Size = UDim2.new(1, -10, 0, 40)
        featureBtn.Position = UDim2.new(0, 5, 0, 2.5)
        featureBtn.BackgroundTransparency = 1
        featureBtn.Text = "  " .. feature.icon .. "  " .. feature.name .. "  [" .. feature.key .. "]"
        featureBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        featureBtn.TextSize = 15
        featureBtn.Font = Enum.Font.GothamSemibold
        featureBtn.TextXAlignment = Enum.TextXAlignment.Left
        featureBtn.Parent = container
        
        local btnPadding = Instance.new("UIPadding")
        btnPadding.PaddingLeft = UDim.new(0, 10)
        btnPadding.Parent = featureBtn
        
        -- Status indicator
        local statusIndicator = Instance.new("Frame")
        statusIndicator.Name = "StatusIndicator"
        statusIndicator.Size = UDim2.new(0, 12, 0, 12)
        statusIndicator.Position = UDim2.new(1, -25, 0, 14)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusIndicator.BackgroundTransparency = 0.2
        statusIndicator.BorderSizePixel = 0
        statusIndicator.Parent = featureBtn
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = statusIndicator
        
        buttons[feature.state] = {
            button = featureBtn,
            indicator = statusIndicator,
            container = container,
            isAction = feature.isAction or false
        }
        
        -- Speed input box
        if feature.hasInput then
            local speedInput = Instance.new("TextBox")
            speedInput.Name = "SpeedInput"
            speedInput.Size = UDim2.new(1, -20, 0, 42)
            speedInput.Position = UDim2.new(0, 10, 0, 52)
            speedInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            speedInput.BackgroundTransparency = 0.3
            speedInput.BorderSizePixel = 0
            speedInput.Text = tostring(CONFIG.SPEED_VALUE)
            speedInput.PlaceholderText = "Enter speed (1-500)"
            speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            speedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            speedInput.TextSize = 14
            speedInput.Font = Enum.Font.Gotham
            speedInput.ClearTextOnFocus = false
            speedInput.Parent = container
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 8)
            inputCorner.Parent = speedInput
            
            local inputPadding = Instance.new("UIPadding")
            inputPadding.PaddingLeft = UDim.new(0, 8)
            inputPadding.Parent = speedInput
            
            buttons[feature.state].input = speedInput
        end
        
        -- Teleport dropdown
        if feature.hasDropdown then
            local dropdown = Instance.new("ScrollingFrame")
            dropdown.Name = "PlayerDropdown"
            dropdown.Size = UDim2.new(1, -20, 0, 58)
            dropdown.Position = UDim2.new(0, 10, 0, 52)
            dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            dropdown.BackgroundTransparency = 0.3
            dropdown.BorderSizePixel = 0
            dropdown.ScrollBarThickness = 4
            dropdown.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
            dropdown.ScrollBarImageTransparency = 0.5
            dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
            dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
            dropdown.Parent = container
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 8)
            dropCorner.Parent = dropdown
            
            local placeholderLabel = Instance.new("TextLabel")
            placeholderLabel.Name = "PlaceholderText"
            placeholderLabel.Size = UDim2.new(1, 0, 1, 0)
            placeholderLabel.BackgroundTransparency = 1
            placeholderLabel.Text = "Select a player..."
            placeholderLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            placeholderLabel.TextSize = 13
            placeholderLabel.Font = Enum.Font.Gotham
            placeholderLabel.Parent = dropdown
            
            buttons[feature.state].dropdown = dropdown
            buttons[feature.state].placeholder = placeholderLabel
        end
    end
    
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    return mainFrame, toggleBtn, closeBtn, buttons
end

-- ============================================
-- PLAYER DROPDOWN UPDATE
-- ============================================
local function updatePlayerDropdown(dropdown)
    if not dropdown then return end
    
    for _, child in pairs(dropdown:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        elseif child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 3)
    layout.SortOrder = Enum.SortOrder.Name
    layout.Parent = dropdown
    
    local hasPlayers = false
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            hasPlayers = true
            
            local playerBtn = Instance.new("TextButton")
            playerBtn.Name = otherPlayer.Name
            playerBtn.Size = UDim2.new(1, -6, 0, 26)
            playerBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            playerBtn.BackgroundTransparency = 0.4
            playerBtn.BorderSizePixel = 0
            playerBtn.Text = otherPlayer.Name
            playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerBtn.TextSize = 13
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.Parent = dropdown
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = playerBtn
            
            playerBtn.MouseButton1Click:Connect(function()
                selectedTeleportPlayer = otherPlayer
                print("[NullHub] Selected player:", otherPlayer.Name)
                
                for _, btn in pairs(dropdown:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundTransparency = 0.4
                    end
                end
                playerBtn.BackgroundTransparency = 0.2
            end)
            
            playerBtn.MouseEnter:Connect(function()
                if playerBtn.BackgroundTransparency > 0.2 then
                    TweenService:Create(playerBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
                end
            end)
            
            playerBtn.MouseLeave:Connect(function()
                if selectedTeleportPlayer ~= otherPlayer then
                    TweenService:Create(playerBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
                end
            end)
        end
    end
    
    local placeholder = dropdown:FindFirstChild("PlaceholderText")
    if placeholder then
        placeholder.Visible = not hasPlayers
    end
end

-- ============================================
-- FEATURE FUNCTIONS
-- ============================================
local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = CONFIG.AIMBOT_FOV
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            local otherHead = otherPlayer.Character:FindFirstChild("Head")
            
            if otherHumanoid and otherHead and otherHumanoid.Health > 0 then
                local screenPos, onScreen = camera:WorldToScreenPoint(otherHead.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function getClosestPlayerInRange(range)
    local closestPlayer = nil
    local shortestDistance = range
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if otherHumanoid and otherRoot and otherHumanoid.Health > 0 and rootPart then
                local distance = (rootPart.Position - otherRoot.Position).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAtTarget(target)
    if not target or not target.Character then return end
    local targetHead = target.Character:FindFirstChild("Head")
    if not targetHead then return end
    
    local targetPos = targetHead.Position
    local cameraPos = camera.CFrame.Position
    local newCFrame = CFrame.new(cameraPos, targetPos)
    camera.CFrame = camera.CFrame:Lerp(newCFrame, CONFIG.AIMBOT_SMOOTHNESS)
end

local function performKillAura()
    if not state.killaura or not character or not humanoid then return end
    
    local target = getClosestPlayerInRange(CONFIG.KILLAURA_RANGE)
    if target and target.Character then
        local targetHumanoid = target.Character:FindFirstChild("Humanoid")
        if targetHumanoid and targetHumanoid.Health > 0 then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                for _, descendant in pairs(tool:GetDescendants()) do
                    if descendant:IsA("RemoteEvent") then
                        pcall(function()
                            descendant:FireServer()
                        end)
                    elseif descendant:IsA("RemoteFunction") then
                        pcall(function()
                            descendant:InvokeServer()
                        end)
                    end
                end
            end
            
            if humanoid and not tool then
                humanoid:ChangeState(Enum.HumanoidStateType.Attacking)
            end
        end
    end
end

local function performFastM1()
    if not state.fastm1 then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        
        for _, descendant in pairs(tool:GetDescendants()) do
            if descendant:IsA("RemoteEvent") then
                pcall(function()
                    descendant:FireServer()
                end)
            elseif descendant:IsA("RemoteFunction") then
                pcall(function()
                    descendant:InvokeServer()
                end)
            end
        end
    end
end

local function updateFly()
    if not state.fly or not rootPart then return end
    
    local moveDirection = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + (camera.CFrame.LookVector * CONFIG.FLY_SPEED)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - (camera.CFrame.LookVector * CONFIG.FLY_SPEED)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - (camera.CFrame.RightVector * CONFIG.FLY_SPEED)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + (camera.CFrame.RightVector * CONFIG.FLY_SPEED)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, CONFIG.FLY_SPEED, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection - Vector3.new(0, CONFIG.FLY_SPEED, 0)
    end
    
    if flyBodyVelocity then
        flyBodyVelocity.Velocity = moveDirection
    end
    
    if flyBodyGyro then
        flyBodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
    end
end

local function createESP(targetPlayer)
    if espObjects[targetPlayer] or not targetPlayer.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = targetPlayer.Character
    highlight.FillColor = CONFIG.ESP_COLOR
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = targetPlayer.Character
    
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_Billboard"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = CONFIG.ESP_COLOR
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = billboardGui
    
    espObjects[targetPlayer] = {highlight = highlight, billboard = billboardGui, label = textLabel}
    
    local updateConnection
    updateConnection = RunService.RenderStepped:Connect(function()
        if not state.esp or not targetPlayer.Character or not rootPart then
            updateConnection:Disconnect()
            return
        end
        
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and CONFIG.ESP_SHOW_DISTANCE then
            local distance = (rootPart.Position - targetRoot.Position).Magnitude
            textLabel.Text = targetPlayer.Name .. "\n[" .. math.floor(distance) .. " studs]"
        else
            textLabel.Text = targetPlayer.Name
        end
    end)
end

local function removeESP(targetPlayer)
    if espObjects[targetPlayer] then
        if espObjects[targetPlayer].highlight then
            pcall(function() espObjects[targetPlayer].highlight:Destroy() end)
        end
        if espObjects[targetPlayer].billboard then
            pcall(function() espObjects[targetPlayer].billboard:Destroy() end)
        end
        espObjects[targetPlayer] = nil
    end
end

local function updateESP()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            if state.esp then
                createESP(otherPlayer)
            else
                removeESP(otherPlayer)
            end
        end
    end
end

local function updateNoClip()
    if not state.noclip or not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function onJumpRequest()
    if state.infjump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

local function updateSpeed()
    if humanoid then
        humanoid.WalkSpeed = state.speed and CONFIG.SPEED_VALUE or originalSpeed
    end
end

local function saveOriginalLighting()
    originalLightingSettings = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
    }
end

local function enableFullBright()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.ClockTime = 12
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
end

local function disableFullBright()
    for setting, value in pairs(originalLightingSettings) do
        pcall(function()
            Lighting[setting] = value
        end)
    end
end

local function updateGodMode()
    if state.godmode then
        if humanoid then
            if godmodeConnection then
                godmodeConnection:Disconnect()
            end
            godmodeConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
            humanoid.Health = humanoid.MaxHealth
        end
    else
        if godmodeConnection then
            godmodeConnection:Disconnect()
            godmodeConnection = nil
        end
    end
end

local function teleportToPlayer()
    if isTeleporting then
        warn("[NullHub] Already teleporting!")
        return
    end
    
    if not selectedTeleportPlayer or not selectedTeleportPlayer.Character then
        warn("[NullHub] No player selected! Select from dropdown.")
        return
    end
    
    local targetRoot = selectedTeleportPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not rootPart then
        warn("[NullHub] Target unavailable!")
        return
    end
    
    isTeleporting = true
    print("[NullHub] Teleporting to:", selectedTeleportPlayer.Name)
    
    local targetCFrame = targetRoot.CFrame * CFrame.new(0, 3, 3)
    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local duration = distance / CONFIG.TELEPORT_SPEED
    
    local tween = TweenService:Create(
        rootPart,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )
    
    tween:Play()
    tween.Completed:Connect(function()
        isTeleporting = false
        print("[NullHub] Teleport complete!")
    end)
end

-- ============================================
-- TOGGLE FUNCTIONS WITH GUI UPDATE
-- ============================================
local guiButtons = {}

local function updateButtonVisual(stateName)
    if guiButtons[stateName] and not guiButtons[stateName].isAction then
        local btn = guiButtons[stateName]
        local isEnabled = state[stateName]
        
        TweenService:Create(btn.indicator, TweenInfo.new(0.3), {
            BackgroundColor3 = isEnabled and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(200, 50, 50)
        }):Play()
        
        TweenService:Create(btn.container, TweenInfo.new(0.3), {
            BackgroundColor3 = isEnabled and Color3.fromRGB(30, 35, 50) or Color3.fromRGB(25, 25, 35)
        }):Play()
    end
end

local function toggleAimbot()
    state.aimbot = not state.aimbot
    updateButtonVisual("aimbot")
    print("[NullHub] Aimbot:", state.aimbot and "ON" or "OFF")
end

local function toggleESP()
    state.esp = not state.esp
    updateESP()
    updateButtonVisual("esp")
    print("[NullHub] ESP:", state.esp and "ON" or "OFF")
end

local function toggleKillAura()
    state.killaura = not state.killaura
    
    if state.killaura then
        if killAuraConnection then
            killAuraConnection:Disconnect()
        end
        
        local lastHit = tick()
        killAuraConnection = RunService.Heartbeat:Connect(function()
            if tick() - lastHit >= CONFIG.KILLAURA_DELAY then
                performKillAura()
                lastHit = tick()
            end
        end)
    else
        if killAuraConnection then
            killAuraConnection:Disconnect()
            killAuraConnection = nil
        end
    end
    
    updateButtonVisual("killaura")
    print("[NullHub] KillAura:", state.killaura and "ON" or "OFF")
end

local function toggleFastM1()
    state.fastm1 = not state.fastm1
    
    if state.fastm1 then
        if fastM1Connection then
            fastM1Connection:Disconnect()
        end
        
        local lastClick = tick()
        fastM1Connection = RunService.Heartbeat:Connect(function()
            if tick() - lastClick >= CONFIG.FASTM1_DELAY then
                performFastM1()
                lastClick = tick()
            end
        end)
    else
        if fastM1Connection then
            fastM1Connection:Disconnect()
            fastM1Connection = nil
        end
    end
    
    updateButtonVisual("fastm1")
    print("[NullHub] Fast M1:", state.fastm1 and "ON" or "OFF")
end

local function toggleFly()
    state.fly = not state.fly
    
    if state.fly then
        if not flyBodyVelocity then
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.Parent = rootPart
        end
        
        if not flyBodyGyro then
            flyBodyGyro = Instance.new("BodyGyro")
            flyBodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
            flyBodyGyro.P = 10000
            flyBodyGyro.Parent = rootPart
        end
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        flyConnection = RunService.RenderStepped:Connect(updateFly)
        
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        
        if flyBodyGyro then
            flyBodyGyro:Destroy()
            flyBodyGyro = nil
        end
        
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end
    
    updateButtonVisual("fly")
    print("[NullHub] Fly:", state.fly and "ON" or "OFF")
end

local function toggleNoClip()
    state.noclip = not state.noclip
    updateButtonVisual("noclip")
    print("[NullHub] NoClip:", state.noclip and "ON" or "OFF")
end

local function toggleInfJump()
    state.infjump = not state.infjump
    updateButtonVisual("infjump")
    print("[NullHub] Infinite Jump:", state.infjump and "ON" or "OFF")
end

local function toggleSpeed()
    state.speed = not state.speed
    updateSpeed()
    updateButtonVisual("speed")
    print("[NullHub] Speed:", state.speed and "ON" or "OFF", "- Value:", CONFIG.SPEED_VALUE)
end

local function toggleFullBright()
    state.fullbright = not state.fullbright
    if state.fullbright then
        enableFullBright()
    else
        disableFullBright()
    end
    updateButtonVisual("fullbright")
    print("[NullHub] Full Bright:", state.fullbright and "ON" or "OFF")
end

local function toggleGodMode()
    state.godmode = not state.godmode
    updateGodMode()
    updateButtonVisual("godmode")
    print("[NullHub] God Mode:", state.godmode and "ON" or "OFF")
end

-- NEW: GUI Toggle Function
local function toggleGUI()
    guiVisible = not guiVisible
    if mainFrameRef then
        mainFrameRef.Visible = guiVisible
    end
    if toggleBtnRef then
        TweenService:Create(toggleBtnRef, TweenInfo.new(0.3), {
            Rotation = guiVisible and 0 or 180
        }):Play()
    end
    print("[NullHub] GUI:", guiVisible and "VISIBLE" or "HIDDEN")
end

-- ============================================
-- GUI INITIALIZATION
-- ============================================
local mainFrame, toggleBtn, closeBtn, buttons = createModernGUI()
guiButtons = buttons
mainFrameRef = mainFrame
toggleBtnRef = toggleBtn

-- Toggle button functionality
toggleBtn.MouseButton1Click:Connect(toggleGUI)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    guiVisible = false
    mainFrame.Visible = false
end)

-- Button click handlers
buttons.aimbot.button.MouseButton1Click:Connect(toggleAimbot)
buttons.esp.button.MouseButton1Click:Connect(toggleESP)
buttons.killaura.button.MouseButton1Click:Connect(toggleKillAura)
buttons.fastm1.button.MouseButton1Click:Connect(toggleFastM1)
buttons.fly.button.MouseButton1Click:Connect(toggleFly)
buttons.noclip.button.MouseButton1Click:Connect(toggleNoClip)
buttons.infjump.button.MouseButton1Click:Connect(toggleInfJump)
buttons.speed.button.MouseButton1Click:Connect(toggleSpeed)
buttons.fullbright.button.MouseButton1Click:Connect(toggleFullBright)
buttons.godmode.button.MouseButton1Click:Connect(toggleGodMode)
buttons.teleport.button.MouseButton1Click:Connect(teleportToPlayer)

-- Speed input handler
if buttons.speed.input then
    buttons.speed.input.FocusLost:Connect(function(enterPressed)
        local value = tonumber(buttons.speed.input.Text)
        if value and value >= CONFIG.MIN_SPEED and value <= CONFIG.MAX_SPEED then
            CONFIG.SPEED_VALUE = value
            if state.speed then
                updateSpeed()
            end
            print("[NullHub] Speed set to:", value)
        else
            buttons.speed.input.Text = tostring(CONFIG.SPEED_VALUE)
            warn("[NullHub] Invalid speed! Use 1-500")
        end
    end)
end

-- Initialize teleport dropdown
if buttons.teleport.dropdown then
    updatePlayerDropdown(buttons.teleport.dropdown)
    
    Players.PlayerAdded:Connect(function()
        task.wait(0.5)
        updatePlayerDropdown(buttons.teleport.dropdown)
    end)
    
    Players.PlayerRemoving:Connect(function()
        updatePlayerDropdown(buttons.teleport.dropdown)
    end)
end

-- ============================================
-- KEYBIND INPUT HANDLING (ADDED INSERT KEY)
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- NEW: Insert key to toggle GUI visibility
    if input.KeyCode == CONFIG.GUI_TOGGLE_KEY then
        toggleGUI()
    elseif input.KeyCode == CONFIG.AIMBOT_KEY then
        toggleAimbot()
    elseif input.KeyCode == CONFIG.ESP_KEY then
        toggleESP()
    elseif input.KeyCode == CONFIG.KILLAURA_KEY then
        toggleKillAura()
    elseif input.KeyCode == CONFIG.FASTM1_KEY then
        toggleFastM1()
    elseif input.KeyCode == CONFIG.FLY_KEY then
        toggleFly()
    elseif input.KeyCode == CONFIG.NOCLIP_KEY then
        toggleNoClip()
    elseif input.KeyCode == CONFIG.INFJUMP_KEY then
        toggleInfJump()
    elseif input.KeyCode == CONFIG.SPEED_KEY then
        toggleSpeed()
    elseif input.KeyCode == CONFIG.FULLBRIGHT_KEY then
        toggleFullBright()
    elseif input.KeyCode == CONFIG.GODMODE_KEY then
        toggleGodMode()
    elseif input.KeyCode == CONFIG.TELEPORT_KEY then
        teleportToPlayer()
    elseif input.KeyCode == Enum.KeyCode.Space and not state.fly then
        onJumpRequest()
    end
end)

-- ============================================
-- MAIN UPDATE LOOPS
-- ============================================
RunService.RenderStepped:Connect(function()
    if state.aimbot then
        local target = getClosestPlayerToMouse()
        if target then
            aimAtTarget(target)
        end
    end
    
    if state.noclip then
        updateNoClip()
    end
end)

-- ============================================
-- PLAYER EVENTS
-- ============================================
Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if state.esp then
            createESP(newPlayer)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(removedPlayer)
    removeESP(removedPlayer)
    if selectedTeleportPlayer == removedPlayer then
        selectedTeleportPlayer = nil
    end
end)

-- ============================================
-- RESPAWN HANDLING
-- ============================================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    task.wait(0.2)
    originalSpeed = humanoid.WalkSpeed
    
    if state.speed then
        updateSpeed()
    end
    
    if state.godmode then
        updateGodMode()
    end
    
    if state.esp then
        task.wait(0.5)
        updateESP()
    end
    
    if state.killaura then
        local wasEnabled = state.killaura
        state.killaura = false
        task.wait(0.3)
        state.killaura = wasEnabled
        toggleKillAura()
        toggleKillAura()
    end
    
    if state.fastm1 then
        local wasEnabled = state.fastm1
        state.fastm1 = false
        task.wait(0.3)
        state.fastm1 = wasEnabled
        toggleFastM1()
        toggleFastM1()
    end
    
    if state.fly then
        local wasEnabled = state.fly
        state.fly = false
        task.wait(0.3)
        state.fly = wasEnabled
        toggleFly()
        toggleFly()
    end
    
    print("[NullHub] Character respawned - features reapplied")
end)

-- ============================================
-- INITIALIZATION
-- ============================================
saveOriginalLighting()
originalSpeed = humanoid.WalkSpeed

print("========================================")
print("⚡ NullHub V2 Loaded Successfully!")
print("========================================")
print("📱 GUI: Press [INSERT] to toggle visibility")
print("   • Click 'N' button or press Insert")
print("   • Drag header to reposition")
print("🎯 COMBAT:")
print("  • Aimbot [E] | ESP [T]")
print("  • KillAura [K] - Auto attack nearby")
print("  • Fast M1 [M] - Rapid clicking")
print("🏃 MOVEMENT:")
print("  • Fly [F] - WASD to move, Space/Shift up/down")
print("  • NoClip [N] | Infinite Jump [J]")
print("  • Speed [X] (1-500) | Teleport [Z]")
print("✨ EXTRAS:")
print("  • Full Bright [B] | God Mode [V]")
print("========================================")
