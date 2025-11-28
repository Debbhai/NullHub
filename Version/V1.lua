-- Ultimate All-in-One Script v1.0
-- Aimbot | ESP | NoClip | InfJump | Speed | FullBright | GodMode | Teleport

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = Workspace.CurrentCamera

-- ============================================
-- CONFIG - CUSTOMIZE HERE
-- ============================================
local CONFIG = {
    -- Aimbot
    AIMBOT_KEY = Enum.KeyCode.E,
    AIMBOT_FOV = 200,
    AIMBOT_SMOOTHNESS = 0.2,
    
    -- ESP
    ESP_KEY = Enum.KeyCode.T,
    ESP_COLOR = Color3.fromRGB(255, 0, 0),
    ESP_SHOW_DISTANCE = true,
    
    -- NoClip
    NOCLIP_KEY = Enum.KeyCode.N,
    
    -- Infinite Jump
    INFJUMP_KEY = Enum.KeyCode.J,
    
    -- Speed Hack
    SPEED_KEY = Enum.KeyCode.X,
    SPEED_VALUE = 100,
    
    -- Full Bright
    FULLBRIGHT_KEY = Enum.KeyCode.B,
    
    -- God Mode
    GODMODE_KEY = Enum.KeyCode.V,
    
    -- Teleport
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

-- ============================================
-- AIMBOT FUNCTIONS
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

-- ============================================
-- ESP FUNCTIONS
-- ============================================
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
    
    -- Update distance
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

-- ============================================
-- NOCLIP FUNCTIONS
-- ============================================
local function updateNoClip()
    if not state.noclip then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- ============================================
-- INFINITE JUMP FUNCTIONS
-- ============================================
local function onJumpRequest()
    if state.infjump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- ============================================
-- SPEED HACK FUNCTIONS
-- ============================================
local function updateSpeed()
    if humanoid then
        if state.speed then
            humanoid.WalkSpeed = CONFIG.SPEED_VALUE
        else
            humanoid.WalkSpeed = originalSpeed
        end
    end
end

-- ============================================
-- FULL BRIGHT FUNCTIONS
-- ============================================
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

-- ============================================
-- GOD MODE FUNCTIONS
-- ============================================
local godmodeConnection = nil

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

-- ============================================
-- TELEPORT FUNCTIONS
-- ============================================
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
-- TOGGLE FUNCTIONS
-- ============================================
local function toggleAimbot()
    state.aimbot = not state.aimbot
    print("Aimbot:", state.aimbot and "ENABLED" or "DISABLED")
end

local function toggleESP()
    state.esp = not state.esp
    updateESP()
    print("ESP:", state.esp and "ENABLED" or "DISABLED")
end

local function toggleNoClip()
    state.noclip = not state.noclip
    print("NoClip:", state.noclip and "ENABLED" or "DISABLED")
end

local function toggleInfJump()
    state.infjump = not state.infjump
    print("Infinite Jump:", state.infjump and "ENABLED" or "DISABLED")
end

local function toggleSpeed()
    state.speed = not state.speed
    updateSpeed()
    print("Speed Hack:", state.speed and "ENABLED" or "DISABLED", "Speed:", CONFIG.SPEED_VALUE)
end

local function toggleFullBright()
    state.fullbright = not state.fullbright
    if state.fullbright then
        enableFullBright()
    else
        disableFullBright()
    end
    print("Full Bright:", state.fullbright and "ENABLED" or "DISABLED")
end

local function toggleGodMode()
    state.godmode = not state.godmode
    updateGodMode()
    print("God Mode:", state.godmode and "ENABLED" or "DISABLED")
end

-- ============================================
-- INPUT HANDLING
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
    -- Aimbot
    if state.aimbot then
        local target = getClosestPlayerToMouse()
        if target then
            aimAtTarget(target)
        end
    end
    
    -- NoClip
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
    
    -- Save original speed
    originalSpeed = humanoid.WalkSpeed
    
    -- Reapply features if enabled
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
print("🎯 ULTIMATE ALL-IN-ONE SCRIPT LOADED 🎯")
print("========================================")
print("AIMBOT    [E] - Auto-aim at enemies")
print("ESP       [T] - See all players")
print("NOCLIP    [N] - Walk through walls")
print("INF JUMP  [J] - Unlimited jumps")
print("SPEED     [X] - Super speed (" .. CONFIG.SPEED_VALUE .. ")")
print("FULLBRIGHT[B] - Maximum brightness")
print("GODMODE   [V] - Invincibility")
print("TELEPORT  [Z] - TP to player (aim at them)")
print("========================================")
print("✅ All systems ready!")
print("========================================")
