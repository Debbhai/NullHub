-- ============================================
-- NullHub WalkOnWater.lua - Water Platform
-- Created by Debbhai
-- Version: 1.0.0
-- Walk on water surfaces (Blox Fruits optimized)
-- ============================================

local WalkOnWater = {
    Version = "1.0.0",
    Enabled = false,
    WaterPlatform = nil,
    WaterHeight = nil
}

-- Dependencies
local RunService
local Player, Character, Humanoid, RootPart
local Config, Notifications

-- Internal State
local Connection = nil

-- ============================================
-- INITIALIZATION
-- ============================================
function WalkOnWater:Initialize(player, character, rootPart, humanoid, config, notifications)
    -- Store dependencies
    RunService = game:GetService("RunService")
    
    Player = player
    Character = character
    RootPart = rootPart
    Humanoid = humanoid
    Config = config
    Notifications = notifications
    
    print("[WalkOnWater] ✅ Initialized")
    return true
end

-- ============================================
-- SCAN FOR WATER (Blox Fruits Optimized)
-- ============================================
function WalkOnWater:ScanForWater(playerPos)
    -- Check Map folder (common in Blox Fruits)
    local mapFolder = workspace:FindFirstChild("Map") or workspace:FindFirstChild("World")
    if mapFolder then
        for _, obj in pairs(mapFolder:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                
                -- Blox Fruits water detection
                if name:find("water") or name:find("ocean") or name:find("sea") or obj.Material == Enum.Material.Water then
                    local objPos = obj.Position
                    local objSize = obj.Size
                    
                    -- Check if player is above this water horizontally
                    local horizontalDist = math.sqrt((playerPos.X - objPos.X)^2 + (playerPos.Z - objPos.Z)^2)
                    if horizontalDist < (objSize.X / 2) + 20 then
                        local waterTop = objPos.Y + (objSize.Y / 2)
                        if playerPos.Y > waterTop - 5 and playerPos.Y < waterTop + 15 then
                            return true, waterTop
                        end
                    end
                end
            end
        end
    end
    
    return false, nil
end

-- ============================================
-- RAYCAST WATER CHECK
-- ============================================
function WalkOnWater:RaycastWaterCheck(playerPos)
    local rayOrigin = playerPos + Vector3.new(0, 3, 0)
    local rayDirection = Vector3.new(0, -25, 0)
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character, self.WaterPlatform}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)
    
    if rayResult then
        local hit = rayResult.Instance
        local hitPos = rayResult.Position
        
        -- Check if hit part is water
        local isWater = false
        if hit.Name:lower():find("water") or hit.Name:lower():find("ocean") or hit.Name:lower():find("sea") then
            isWater = true
        elseif hit.Material == Enum.Material.Water then
            isWater = true
        elseif hit:IsA("BasePart") and hit.Transparency > 0.3 then
            local color = hit.Color
            if color.B > 0.6 and color.R < 0.5 then
                isWater = true
            end
        end
        
        if isWater then
            return true, hitPos.Y
        end
        
        -- Terrain water check
        if hit:IsA("Terrain") then
            local region = Region3.new(hitPos - Vector3.new(2, 2, 2), hitPos + Vector3.new(2, 2, 2))
            region = region:ExpandToGrid(4)
            
            pcall(function()
                local materials = workspace.Terrain:ReadVoxels(region, 4)
                if materials[1][1][1] == Enum.Material.Water then
                    return true, hitPos.Y
                end
            end)
        end
    end
    
    return false, nil
end

-- ============================================
-- UPDATE PLATFORM
-- ============================================
function WalkOnWater:Update()
    if not self.Enabled or not RootPart or not Humanoid then return end
    
    local playerPos = RootPart.Position
    local isOverWater = false
    local detectedHeight = nil
    
    -- Method 1: Scan for water parts
    if Config.Movement.WALKONWATER.BLOX_FRUITS_MODE then
        isOverWater, detectedHeight = self:ScanForWater(playerPos)
    end
    
    -- Method 2: Raycast downward
    if not isOverWater then
        isOverWater, detectedHeight = self:RaycastWaterCheck(playerPos)
    end
    
    -- Create/Update platform if over water
    if isOverWater and detectedHeight then
        -- Lock water height
        if not self.WaterHeight then
            self.WaterHeight = detectedHeight
        else
            if math.abs(detectedHeight - self.WaterHeight) > 2 then
                self.WaterHeight = detectedHeight
            end
        end
        
        -- Create platform if doesn't exist
        if not self.WaterPlatform then
            self.WaterPlatform = Instance.new("Part")
            self.WaterPlatform.Name = "WaterPlatform"
            self.WaterPlatform.Size = Config.Movement.WALKONWATER.PLATFORM_SIZE or Vector3.new(10, 0.8, 10)
            self.WaterPlatform.Anchored = true
            self.WaterPlatform.CanCollide = true
            self.WaterPlatform.Transparency = Config.Movement.WALKONWATER.PLATFORM_TRANSPARENCY or 0.5
            self.WaterPlatform.Material = Enum.Material.SmoothPlastic
            self.WaterPlatform.Color = Config.Movement.WALKONWATER.PLATFORM_COLOR or Color3.fromRGB(100, 200, 255)
            self.WaterPlatform.TopSurface = Enum.SurfaceType.Smooth
            self.WaterPlatform.BottomSurface = Enum.SurfaceType.Smooth
            self.WaterPlatform.CastShadow = false
            
            -- Anti-detection properties
            self.WaterPlatform.CanQuery = false
            self.WaterPlatform.CanTouch = false
            self.WaterPlatform.Massless = true
            
            self.WaterPlatform.Parent = workspace
        end
        
        -- INSTANT POSITION UPDATE (NO LERP)
        local heightOffset = Config.Movement.WALKONWATER.HEIGHT_OFFSET or 1
        local platformY = self.WaterHeight + heightOffset
        self.WaterPlatform.CFrame = CFrame.new(playerPos.X, platformY, playerPos.Z)
        return
    end
    
    -- Remove platform if not over water
    if self.WaterPlatform then
        local dist = (RootPart.Position - self.WaterPlatform.Position).Magnitude
        if dist > 15 or not isOverWater then
            self.WaterPlatform:Destroy()
            self.WaterPlatform = nil
            self.WaterHeight = nil
        end
    end
end

-- ============================================
-- TOGGLE
-- ============================================
function WalkOnWater:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
    
    -- Notify user
    if Notifications then
        Notifications:Show("Walk on Water", self.Enabled, "Instant Response", 2)
    end
    
    return self.Enabled
end

-- ============================================
-- ENABLE
-- ============================================
function WalkOnWater:Enable()
    if Connection then return end
    
    Connection = RunService.RenderStepped:Connect(function()
        self:Update()
    end)
    
    print("[WalkOnWater] 🌊 Enabled (Instant Response)")
end

-- ============================================
-- DISABLE
-- ============================================
function WalkOnWater:Disable()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    
    -- Remove platform
    if self.WaterPlatform then
        self.WaterPlatform:Destroy()
        self.WaterPlatform = nil
    end
    
    self.WaterHeight = nil
    print("[WalkOnWater] ❌ Disabled")
end

-- ============================================
-- CHARACTER RESPAWN
-- ============================================
function WalkOnWater:OnRespawn(newCharacter, newHumanoid, newRootPart)
    local wasEnabled = self.Enabled
    
    -- Disable first
    self:Disable()
    
    -- Update references
    Character = newCharacter
    Humanoid = newHumanoid
    RootPart = newRootPart
    
    -- Re-enable if was enabled
    if wasEnabled then
        task.wait(0.5)
        self:Enable()
    end
    
    print("[WalkOnWater] 🔄 Character respawned")
end

-- ============================================
-- CLEANUP
-- ============================================
function WalkOnWater:Destroy()
    self:Disable()
    print("[WalkOnWater] ✅ Destroyed")
end

-- Export
print("[WalkOnWater] Module loaded v" .. WalkOnWater.Version)
return WalkOnWater
