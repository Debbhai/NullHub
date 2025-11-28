-- null Main loader
local _ENV = (getgenv and getgenv()) or _G
local CURRENT_VERSION = _ENV.Version or "V1"

local Versions = {
    V1 = "https://raw.githubusercontent.com/Debbhai/NullHub/refs/heads/main/Version/V1.lua",
    V2 = "https://raw.githubusercontent.com/Debbhai/NullHub/refs/heads/main/Version/V2.lua",
}

-- simple anti-spam
do
    local last_exec = _ENV.null_execute_debounce
    if last_exec and (tick() - last_exec) <= 5 then
        return nil
    end
    _ENV.null_execute_debounce = tick()
end

local function CreateMessageError(text)
    if _ENV.null_error_message then
        _ENV.null_error_message:Destroy()
    end
    local Message = Instance.new("Message", workspace)
    Message.Text = text
    _ENV.null_error_message = Message
    error(text, 2)
end

local function http_get(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then
        CreateMessageError("[null Fetch Error] " .. tostring(result))
    end
    return result
end

local function load_from(url)
    local source = http_get(url)
    local func, err = loadstring(source)
    if not func then
        CreateMessageError("[null Load Error] " .. tostring(err))
    end
    return func()
end

local versionUrl = Versions[CURRENT_VERSION] or Versions.V1
return load_from(versionUrl)
