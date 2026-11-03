-- Mapped games use the URLs below; other scripts can use a first-line
-- `-- PlaceId: <root place id>` header for automatic discovery.
-- Publish this file and the corresponding game scripts to levox00/ps separately.
-- Game name -> script URL. Keep these keys consistent with MAIN_PLACES below.
local SCRIPT_URLS = {
    BladeBall = "https://raw.githubusercontent.com/levox00/ps/main/scripts/BladeBall.luau",
    PetSim99 = "https://raw.githubusercontent.com/levox00/ps/main/scripts/PetSim99.lua",
    FakeAnEgg = "https://raw.githubusercontent.com/levox00/ps/main/scripts/Fake%20and%20Egg.lua",
}

-- Main/root Place ID -> game name. Sub-places are resolved by the Roblox API.
local MAIN_PLACES = {
    [13772394625] = "BladeBall",
    [8737899170] = "PetSim99",
    [97289366402005] = "FakeAnEgg",
}

local GAMES = {}
for placeId, name in pairs(MAIN_PLACES) do
    local url = SCRIPT_URLS[name]
    assert(type(url) == "string" and url ~= "", "[Petals Loader] Missing script URL for " .. tostring(name))
    GAMES[placeId] = url
end

local HttpService = game:GetService("HttpService")
local API = "https://api.github.com/repos/levox00/ps/git/trees/main?recursive=1"
local RAW = "https://raw.githubusercontent.com/levox00/ps/main/"

local function get(url, description)
    local ok, result = pcall(function() return game:HttpGet(url) end)
    if not ok or type(result) ~= "string" or result == "" then
        error("[Petals Loader] Could not fetch " .. description .. ": " .. tostring(result), 0)
    end
    return result
end

local function json(url, description)
    local body = get(url, description)
    local ok, result = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok or type(result) ~= "table" then
        error("[Petals Loader] Invalid response for " .. description, 0)
    end
    return result
end

local function rawUrl(path)
    local pieces = {}
    for part in path:gmatch("[^/]+") do
        table.insert(pieces, HttpService:UrlEncode(part))
    end
    return RAW .. table.concat(pieces, "/")
end

local function execute(source, name)
    if type(loadstring) ~= "function" then
        error("[Petals Loader] This executor does not support loadstring.", 0)
    end
    local fn, compileError = loadstring(source, "@" .. name)
    if not fn then error("[Petals Loader] Invalid script: " .. tostring(compileError), 0) end
    return fn()
end

if not game:IsLoaded() then game.Loaded:Wait() end
local directUrl = GAMES[game.PlaceId]
if directUrl then
    return execute(get(directUrl, "mapped script"), directUrl)
end
local universeId = game.GameId
if type(universeId) ~= "number" or universeId <= 0 then
    error("[Petals Loader] The current game's universe ID is unavailable.", 0)
end
local gameInfo = json("https://games.roblox.com/v1/games?universeIds=" .. tostring(universeId), "Roblox game information")
local info = type(gameInfo.data) == "table" and gameInfo.data[1]
local rootPlaceId = info and tonumber(info.rootPlaceId)
if not rootPlaceId or rootPlaceId <= 0 then
    error("[Petals Loader] Roblox did not return the game's root place ID.", 0)
end

local mappedUrl = GAMES[rootPlaceId]
if mappedUrl then
    return execute(get(mappedUrl, "mapped script"), mappedUrl)
end

local listing = json(API, "GitHub script listing")
if listing.truncated or type(listing.tree) ~= "table" then
    error("[Petals Loader] GitHub returned an incomplete script listing.", 0)
end
local matches = {}
for _, item in ipairs(listing.tree) do
    local path = item.path
    if item.type == "blob" and type(path) == "string"
        and path:match("^scripts/") and path:lower():match("%.luau?$")
        and not path:lower():match("/loader%.luau?$") then
        local source = get(rawUrl(path), path)
        local firstLine = source:match("^([^\r\n]*)") or ""
        local id = firstLine:match("^%s*%-%-%s*PlaceId%s*:%s*(%d+)%s*$")
        if id and tonumber(id) == rootPlaceId then
            table.insert(matches, {path = path, source = source})
        end
    end
end

if #matches == 0 then
    warn("[Petals Loader] No script found for root PlaceId " .. tostring(rootPlaceId) .. ".")
    return
elseif #matches > 1 then
    error("[Petals Loader] Multiple scripts match root PlaceId " .. tostring(rootPlaceId) .. "; keep only one routable version.", 0)
end
return execute(matches[1].source, matches[1].path)
