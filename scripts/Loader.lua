-- ============================================================
-- Script hosting statistics
-- Add additional provider snippets in this section.
-- Each snippet should use its own pcall so errors cannot stop the loader.
-- ============================================================
pcall(function()
    loadstring(game:HttpGet("https://scriptblox.com/ingest/clientv2.lua"))("proj_33f3c8be56e7", "1.0.0", false)
end)

-- ============================================================
-- Game scripts: insert a RAW Lua/Luau URL for each game here.
-- Leave an empty string when no script is available yet.
-- Optional: getgenv().MULTI_HUB_URLS can override these URLs.
-- ============================================================
local SCRIPT_URLS = {
    PS99 = "https://raw.githubusercontent.com/levox00/ps/main/scripts/Petals_Hub.lua",
    MurderMystery2 = "",
    BloxFruits = "",
    AdoptMe = "",
    Nights99 = "",
    Rivals = "",
    BladeBall = "",
}

-- Place and universe routing; edit SCRIPT_URLS above to change scripts.
local ROUTES = {
    PS99 = {
        places = {
            [8737899170] = true, [8737899175] = true, -- World 1 / legacy
            [16498369169] = true, -- World 2
            [17503543197] = true, -- World 3
            [140403681187145] = true, -- World 4
            [131952481663528] = true, [110305397892295] = true, -- Halloween event
            [140030158342766] = true, [87249772665589] = true, -- Halloween lobby
            [93869716229773] = true, [82075097396409] = true, -- Halloween minigames
        },
    },
    MurderMystery2 = { places = { [142823291] = true }, universes = { [66654135] = true } },
    BloxFruits = { places = { [2753915549] = true, [4442272183] = true, [7449423635] = true }, universes = { [994732206] = true } },
    AdoptMe = { places = { [920587237] = true }, universes = { [383310974] = true } },
    Nights99 = { places = { [79546208627805] = true }, universes = { [7326934954] = true } },
    Rivals = { places = { [17625359962] = true }, universes = { [6035872082] = true } },
    BladeBall = { places = { [13772394625] = true }, universes = { [4777817887] = true } },
}

if not game:IsLoaded() then game.Loaded:Wait() end
local placeId = game.PlaceId
local universeId = game.GameId
local routeName, route
for name, candidate in pairs(ROUTES) do
    if candidate.places[placeId] or (candidate.universes and candidate.universes[universeId]) then
        if route then error("[Multi Loader] PlaceId is assigned to multiple games: " .. tostring(placeId), 0) end
        routeName, route = name, candidate
    end
end
if not route then
    warn("[Multi Loader] No script configured for PlaceId " .. tostring(placeId))
    return
end

local env = type(getgenv) == "function" and getgenv() or _G
local urls = type(env.MULTI_HUB_URLS) == "table" and env.MULTI_HUB_URLS or {}
local url = urls[routeName] or SCRIPT_URLS[routeName] or route.url
local source
if type(url) == "string" and url ~= "" then
    local ok, result = pcall(function() return game:HttpGet(url) end)
    if not ok then error("[Multi Loader] Could not download " .. routeName .. ": " .. tostring(result), 0) end
    source = result
elseif route.file and type(readfile) == "function" then
    local ok, result = pcall(readfile, route.file)
    if not ok then error("[Multi Loader] Put " .. route.file .. " in the executor workspace, or configure MULTI_HUB_URLS." , 0) end
    source = result
else
    warn("[Multi Loader] " .. routeName .. " was recognized, but no script URL is configured yet. Set it in SCRIPT_URLS at the top of Loader.lua." )
    return
end
if type(source) ~= "string" or source:match("^%s*$") then
    error("[Multi Loader] Empty or invalid source for " .. routeName, 0)
end
if type(loadstring) ~= "function" then error("[Multi Loader] This executor does not support loadstring.", 0) end
local scriptFunction, compileError = loadstring(source, "MultiHub_" .. routeName)
if not scriptFunction then error("[Multi Loader] Invalid " .. routeName .. " script: " .. tostring(compileError), 0) end
return scriptFunction()
