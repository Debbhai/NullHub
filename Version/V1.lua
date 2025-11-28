-- NullHub V1.lua - Complete Script with GUI
-- Created by Debbhai

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
    FULLBRIGHT_KEY = Enum.KeyCode.B,
    GODMODE_KEY = Enum.KeyCode.V,
    TELEPORT_TO_PLAYER_KEY = Enum.KeyCode.Z,
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
}

local espObjects = {}
local originalSpeed = 16
local noclipConnection = nil
local originalLightingSettings = {}
local godmodeConnection = nil

-- ============================================
-- GUI CREATION
-- ============================================
local function createGUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NullHubGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎯 NullHub V1"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 24
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = contentFrame
    
    -- Feature buttons data
    local features = {
        {name = "Aimbot", key = "E", state = "aimbot"},
        {name = "ESP", key = "T", state = "esp"},
        {name = "NoClip", key = "N", state = "noclip"},
        {name = "Infinite Jump", key = "J", state = "infjump"},
        {name = "Speed Hack", key = "X", state = "speed"},
        {name = "Full Bright", key = "B", state = "fullbright"},
        {name = "God Mode", key = "V", state = "godmode"},
        {name = "Teleport", key = "Z", state = "teleport", isAction = true},
    }
    
    local buttons = {}
    
    -- Create feature buttons
    for i, feature in ipairs(features) do
        local featureBtn = Instance.new("TextButton")
        featureBtn.Name = feature.state .. "Btn"
        featureBtn.Size = UDim2.new(1, 0, 0, 35)
        featureBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        featureBtn.BorderSizePixel = 0
        featureBtn.Text = "  " .. feature.name .. " [" .. feature.key .. "]"
        featureBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        featureBtn.TextSize = 16
        featureBtn.Font = Enum.Font.Gotham
        featureBtn.TextXAlignment = Enum.TextXAlignment.Left
        featureBtn.Parent = contentFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = featureBtn
        
        -- Status indicator
        local statusIndicator = Instance.new("Frame")
        statusIndicator.Name = "StatusIndicator"
        statusIndicator.Size = UDim2.new(0, 10, 0, 10)
        statusIndicator.Position = UDim2.new(1, -20, 0.5, -5)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusIndicator.BorderSizePixel = 0
        statusIndicator.Parent = featureBtn
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = statusIndicator
        
        buttons[feature.state] = {
            button = featureBtn,
            indicator = statusIndicator,
            isAction = feature.isAction or false
        }
    end
    
    -- Attach to player
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    return mainFrame, closeBtn, buttons
end

-- ============================================
-- FEATURE FUNCTIONS (Same as your original)
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

local function aimAtTarget(target)
    if not target or not target.Character then return end
    local targetHead = target.Character:FindFirstChild("Head")
    if not targetHead then return end
    
    local targetPos = targetHead.Position
    local cameraPos = camera.CFrame.Position
    local direction = (targetPos - cameraPos).Unit
    local newCFrame = CFrame.new(cameraPos, targetPos)
    camera.CFrame = camera.CFrame:Lerp(newCFrame, CONFIG.AIMBOT_SMOOTHNESS)
end

local function createESP(targetPlayer)
    if espObjects[targetPlayer] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = targetPlayer.Character
    highlight.FillColor = CONFIG.ESP_COLOR
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = targetPlayer.Character
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_Billboard"
    billboardGui.Adornee = targetPlayer.Character:FindFirstChild("Head")
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = targetPlayer.Character:FindFirstChild("Head")
    
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
            espObjects[targetPlayer].highlight:Destroy()
        end
        if espObjects[targetPlayer].billboard then
            espObjects[targetPlayer].billboard:Destroy()
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
    if not state.noclip then return end
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
        if state.speed then
            humanoid.WalkSpeed = CONFIG.SPEED_VALUE
        else
            humanoid.WalkSpeed = originalSpeed
        end
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
        Lighting[setting] = value
    end
end

local function updateGodMode()
    if state.godmode then
        if humanoid then
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
    local target = getClosestPlayerToMouse()
    if target and target.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and rootPart then
            rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 3, 3)
            print("Teleported to:", target.Name)
        end
    else
        print("No target found near mouse!")
    end
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
            BackgroundColor3 = isEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        }):Play()
        
        TweenService:Create(btn.button, TweenInfo.new(0.3), {
            BackgroundColor3 = isEnabled and Color3.fromRGB(55, 55, 60) or Color3.fromRGB(45, 45, 50)
        }):Play()
    end
end

local function toggleAimbot()
    state.aimbot = not state.aimbot
    updateButtonVisual("aimbot")
    print("Aimbot:", state.aimbot and "ENABLED" or "DISABLED")
end

local function toggleESP()
    state.esp = not state.esp
    updateESP()
    updateButtonVisual("esp")
    print("ESP:", state.esp and "ENABLED" or "DISABLED")
end

local function toggleNoClip()
    state.noclip = not state.noclip
    updateButtonVisual("noclip")
    print("NoClip:", state.noclip and "ENABLED" or "DISABLED")
end

local function toggleInfJump()
    state.infjump = not state.infjump
    updateButtonVisual("infjump")
    print("Infinite Jump:", state.infjump and "ENABLED" or "DISABLED")
end

local function toggleSpeed()
    state.speed = not state.speed
    updateSpeed()
    updateButtonVisual("speed")
    print("Speed Hack:", state.speed and "ENABLED" or "DISABLED")
end

local function toggleFullBright()
    state.fullbright = not state.fullbright
    if state.fullbright then
        enableFullBright()
    else
        disableFullBright()
    end
    updateButtonVisual("fullbright")
    print("Full Bright:", state.fullbright and "ENABLED" or "DISABLED")
end

local function toggleGodMode()
    state.godmode = not state.godmode
    updateGodMode()
    updateButtonVisual("godmode")
    print("God Mode:", state.godmode and "ENABLED" or "DISABLED")
end

-- ============================================
-- GUI INITIALIZATION
-- ============================================
local mainFrame, closeBtn, buttons = createGUI()
guiButtons = buttons

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Parent.Enabled = false
end)

-- Button click handlers
buttons.aimbot.button.MouseButton1Click:Connect(toggleAimbot)
buttons.esp.button.MouseButton1Click:Connect(toggleESP)
buttons.noclip.button.MouseButton1Click:Connect(toggleNoClip)
buttons.infjump.button.MouseButton1Click:Connect(toggleInfJump)
buttons.speed.button.MouseButton1Click:Connect(toggleSpeed)
buttons.fullbright.button.MouseButton1Click:Connect(toggleFullBright)
buttons.godmode.button.MouseButton1Click:Connect(toggleGodMode)
buttons.teleport.button.MouseButton1Click:Connect(teleportToPlayer)

-- ============================================
-- KEYBIND INPUT HANDLING
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == CONFIG.AIMBOT_KEY then
        toggleAimbot()
    elseif input.KeyCode == CONFIG.ESP_KEY then
        toggleESP()
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
    elseif input.KeyCode == CONFIG.TELEPORT_TO_PLAYER_KEY then
        teleportToPlayer()
    elseif input.KeyCode == Enum.KeyCode.Space then
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
    if state.esp then
        task.wait(1)
        newPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            if state.esp then
                createESP(newPlayer)
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(removedPlayer)
    removeESP(removedPlayer)
end)

-- ============================================
-- RESPAWN HANDLING
-- ============================================
player.CharacterAdded:Connect(function(newChar)
    task.wait(0.1)
    
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    originalSpeed = humanoid.WalkSpeed
    
    if state.speed then
        task.wait(0.2)
        updateSpeed()
    end
    
    if state.godmode then
        task.wait(0.2)
        updateGodMode()
    end
    
    if state.esp then
        task.wait(0.5)
        updateESP()
    end
end)

-- ============================================
-- INITIALIZATION
-- ============================================
saveOriginalLighting()
originalSpeed = humanoid.WalkSpeed

print("========================================")
print("🎯 NullHub V1 LOADED 🎯")
print("========================================")
print("GUI: Drag to move | Click features to toggle")
print("AIMBOT    [E] | ESP       [T]")
print("NOCLIP    [N] | INF JUMP  [J]")
print("SPEED     [X] | FULLBRIGHT[B]")
print("GODMODE   [V] | TELEPORT  [Z]")
print("========================================")

