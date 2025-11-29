-- NullHub Main Loader
-- Created by Debbhai
local _ENV = (getgenv and getgenv()) or _G
local CURRENT_VERSION = _ENV.Version or "V2"

local Versions = {
    V1 = "https://raw.githubusercontent.com/Debbhai/NullHub/refs/heads/main/Version/V1.lua",
    V2 = "https://raw.githubusercontent.com/Debbhai/NullHub/refs/heads/main/Version/V2.lua",
    V3 = "https://raw.githubusercontent.com/Debbhai/NullHub/refs/heads/main/Version/V3.lua",
}

-- Anti-spam debounce
do
    local last_exec = _ENV.nullhub_execute_debounce
    if last_exec and (tick() - last_exec) <= 5 then
        return warn("[NullHub] Please wait 5 seconds between executions")
    end
    _ENV.nullhub_execute_debounce = tick()
end

-- Queue on teleport (auto-reexecute when joining new server)
do
    local executor = syn or fluxus
    local queueteleport = queue_on_teleport or (executor and executor.queue_on_teleport)

    if not _ENV.nullhub_teleport_queue and type(queueteleport) == "function" then
        _ENV.nullhub_teleport_queue = true
        local SourceCode = ("loadstring(game:HttpGet('%s'))()"):format(Versions[CURRENT_VERSION] or Versions.V1)
        pcall(queueteleport, SourceCode)
    end
end

local function CreateMessageError(text)
    if _ENV.nullhub_error_message then
        _ENV.nullhub_error_message:Destroy()
    end
    local Message = Instance.new("Message", workspace)
    Message.Text = text
    _ENV.nullhub_error_message = Message
    error(text, 2)
end

local function httpGet(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return response
    else
        CreateMessageError("[NullHub Fetch Error] Failed to get: " .. url)
    end
end

local function loadFromUrl(url)
    local raw = httpGet(url)
    local func, err = loadstring(raw)
    if type(func) ~= "function" then
        CreateMessageError("[NullHub Load Error] Syntax error: " .. tostring(err))
    else
        return func
    end
end

local versionUrl = Versions[CURRENT_VERSION] or Versions.V1
return loadFromUrl(versionUrl)()
