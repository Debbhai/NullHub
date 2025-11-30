--============================================
-- CONNECT BUTTONS (FIXED - COMPLETE VERSION)
--============================================
function GUI:ConnectButtons()
    if not self.Modules then
        warn("[GUI] No modules registered!")
        return
    end
    
    print("[GUI] Connecting buttons to modules...")
    
    local Combat = self.Modules.Combat or {}
    local Movement = self.Modules.Movement or {}
    local Visual = self.Modules.Visual or {}
    local Teleport = self.Modules.Teleport or {}
    local Notifications = self.Modules.Notifications
    
    -- Helper function to connect a button
    local function connectButton(stateName, module, moduleName)
        local btnData = GuiButtons[stateName]
        if not btnData or not btnData.button or not module then
            return
        end
        
        local isEnabled = false
        
        btnData.button.MouseButton1Click:Connect(function()
            -- For action buttons (like Teleport)
            if btnData.isAction then
                if stateName == "teleport" and Teleport.TeleportToPlayer then
                    local selectedPlayer = btnData.dropdown and btnData.dropdown:FindFirstChild("SelectedPlayer")
                    if selectedPlayer and selectedPlayer.Value then
                        pcall(function()
                            Teleport.TeleportToPlayer:TeleportTo(selectedPlayer.Value)
                        end)
                    else
                        if Notifications then
                            Notifications:Warning("Select a player first!", 2)
                        end
                    end
                elseif stateName == "stop_tween" and Teleport.TeleportToPlayer then
                    pcall(function()
                        Teleport.TeleportToPlayer:StopTween()
                    end)
                end
                return
            end
            
            -- Toggle features
            local success, newState = pcall(function()
                return module:Toggle()
            end)
            
            if success then
                isEnabled = newState
                
                -- Update indicator
                if btnData.indicator then
                    btnData.indicator.BackgroundColor3 = isEnabled and 
                        self.Theme:GetTheme().Colors.StatusOn or 
                        self.Theme:GetTheme().Colors.StatusOff
                end
                
                -- Update container
                if btnData.container then
                    btnData.container.BackgroundColor3 = isEnabled and 
                        self.Theme:GetTheme().Colors.ContainerOn or 
                        self.Theme:GetTheme().Colors.ContainerOff
                end
                
                print("[GUI] " .. moduleName .. ": " .. (isEnabled and "ON" or "OFF"))
            else
                warn("[GUI] Failed to toggle " .. moduleName)
            end
        end)
        
        -- Connect input field (for Speed)
        if btnData.input and stateName == "speed" then
            btnData.input.FocusLost:Connect(function()
                local value = tonumber(btnData.input.Text)
                if value and module.SetSpeed then
                    pcall(function()
                        module:SetSpeed(value)
                        if Notifications then
                            Notifications:Show("Speed", true, "Speed: " .. value, 1.5)
                        end
                    end)
                end
            end)
        end
        
        print("[GUI] ✅ Connected: " .. moduleName)
    end
    
    -- Connect Combat buttons
    connectButton("aimbot", Combat.Aimbot, "Aimbot")
    connectButton("esp", Combat.ESP, "ESP")
    connectButton("killaura", Combat.KillAura, "KillAura")
    connectButton("fastm1", Combat.FastM1, "FastM1")
    
    -- Connect Movement buttons
    connectButton("fly", Movement.Fly, "Fly")
    connectButton("noclip", Movement.NoClip, "NoClip")
    connectButton("infjump", Movement.InfiniteJump, "InfiniteJump")
    connectButton("speed", Movement.Speed, "Speed")
    connectButton("walkonwater", Movement.WalkOnWater, "WalkOnWater")
    
    -- Connect Visual buttons
    connectButton("fullbright", Visual.FullBright, "FullBright")
    connectButton("godmode", Visual.GodMode, "GodMode")
    
    -- Connect Teleport buttons
    if Teleport.TeleportToPlayer then
        connectButton("teleport", Teleport.TeleportToPlayer, "TeleportToPlayer")
        connectButton("stop_tween", Teleport.TeleportToPlayer, "StopTween")
        
        -- Populate player dropdown
        self:PopulatePlayerDropdown()
    end
    
    print("[GUI] ✅ All buttons connected")
end

--============================================
-- POPULATE PLAYER DROPDOWN (NEW FUNCTION)
--============================================
function GUI:PopulatePlayerDropdown()
    local btnData = GuiButtons["teleport"]
    if not btnData or not btnData.dropdown then return end
    
    local dropdown = btnData.dropdown
    
    -- Clear existing
    for _, child in pairs(dropdown:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Hide placeholder
    local placeholder = dropdown:FindFirstChild("PlaceholderText")
    if placeholder then
        placeholder.Visible = false
    end
    
    -- Add selected player value
    local selectedPlayer = dropdown:FindFirstChild("SelectedPlayer")
    if not selectedPlayer then
        selectedPlayer = Instance.new("StringValue")
        selectedPlayer.Name = "SelectedPlayer"
        selectedPlayer.Parent = dropdown
    end
    
    -- Create list layout
    if not dropdown:FindFirstChild("UIListLayout") then
        local listLayout = Instance.new("UIListLayout", dropdown)
        listLayout.Padding = UDim.new(0, 4)
    end
    
    -- Add players
    local players = game:GetService("Players"):GetPlayers()
    for i, otherPlayer in ipairs(players) do
        if otherPlayer ~= player then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Name = otherPlayer.Name
            playerBtn.Size = UDim2.new(1, -8, 0, self.Theme.Sizes.PlayerButtonHeight)
            playerBtn.BackgroundColor3 = self.Theme:GetTheme().Colors.PlayerButtonBg
            playerBtn.BackgroundTransparency = self.Theme:GetTheme().Transparency.PlayerButton
            playerBtn.BorderSizePixel = 0
            playerBtn.Text = "  " .. otherPlayer.Name
            playerBtn.TextColor3 = self.Theme:GetTheme().Colors.TextPrimary
            playerBtn.TextSize = self.Theme.FontSizes.Input
            playerBtn.Font = self.Theme.Fonts.Input
            playerBtn.TextXAlignment = Enum.TextXAlignment.Left
            playerBtn.Parent = dropdown
            
            Instance.new("UICorner", playerBtn).CornerRadius = UDim.new(0, self.Theme.CornerRadius.Tiny)
            
            playerBtn.MouseButton1Click:Connect(function()
                selectedPlayer.Value = otherPlayer.Name
                
                -- Highlight selected
                for _, btn in pairs(dropdown:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundTransparency = 0.25
                    end
                end
                playerBtn.BackgroundTransparency = 0
                
                if self.Modules.Notifications then
                    self.Modules.Notifications:Show("Player Selected", true, otherPlayer.Name, 1.5)
                end
            end)
        end
    end
    
    -- Auto-refresh when players join/leave
    game:GetService("Players").PlayerAdded:Connect(function()
        task.wait(0.5)
        self:PopulatePlayerDropdown()
    end)
    
    game:GetService("Players").PlayerRemoving:Connect(function()
        task.wait(0.5)
        self:PopulatePlayerDropdown()
    end)
end

--============================================
-- CONNECT KEYBINDS (FIXED - COMPLETE VERSION)
--============================================
function GUI:ConnectKeybinds()
    if not self.Modules then
        warn("[GUI] No modules registered!")
        return
    end
    
    print("[GUI] Connecting keybinds...")
    
    local Combat = self.Modules.Combat or {}
    local Movement = self.Modules.Movement or {}
    local Visual = self.Modules.Visual or {}
    local Teleport = self.Modules.Teleport or {}
    
    -- GUI Toggle (INSERT key)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Insert then
            self:ToggleVisibility()
        end
    end)
    
    -- Helper function to connect a keybind
    local function connectKeybind(keyCode, module, moduleName)
        if not module then return end
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == keyCode then
                pcall(function()
                    module:Toggle()
                end)
            end
        end)
        
        print("[GUI] ✅ Keybind: " .. moduleName .. " [" .. keyCode.Name .. "]")
    end
    
    -- Combat keybinds
    if self.Config and self.Config.Combat then
        connectKeybind(self.Config.Combat.AIMBOT.KEY, Combat.Aimbot, "Aimbot")
        connectKeybind(self.Config.Combat.ESP.KEY, Combat.ESP, "ESP")
        connectKeybind(self.Config.Combat.KILLAURA.KEY, Combat.KillAura, "KillAura")
        connectKeybind(self.Config.Combat.FASTM1.KEY, Combat.FastM1, "FastM1")
    end
    
    -- Movement keybinds
    if self.Config and self.Config.Movement then
        connectKeybind(self.Config.Movement.FLY.KEY, Movement.Fly, "Fly")
        connectKeybind(self.Config.Movement.NOCLIP.KEY, Movement.NoClip, "NoClip")
        connectKeybind(self.Config.Movement.INFJUMP.KEY, Movement.InfiniteJump, "InfiniteJump")
        connectKeybind(self.Config.Movement.SPEED.KEY, Movement.Speed, "Speed")
        connectKeybind(self.Config.Movement.WALKONWATER.KEY, Movement.WalkOnWater, "WalkOnWater")
    end
    
    -- Visual keybinds
    if self.Config and self.Config.Visual then
        connectKeybind(self.Config.Visual.FULLBRIGHT.KEY, Visual.FullBright, "FullBright")
        connectKeybind(self.Config.Visual.GODMODE.KEY, Visual.GodMode, "GodMode")
    end
    
    -- Teleport keybind
    if self.Config and self.Config.Teleport then
        connectKeybind(self.Config.Teleport.TELEPORT_TO_PLAYER.KEY, Teleport.TeleportToPlayer, "TeleportToPlayer")
    end
    
    print("[GUI] ✅ All keybinds connected")
end
