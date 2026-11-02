-- Fake an Egg: standalone blue Petals UI foundation.
-- No game automation or gameplay features are included.
local env = (type(getgenv) == "function" and getgenv()) or _G
local key = "FAKE_AN_EGG_UI_STATE"
local previous = env[key]
if type(previous) == "table" and type(previous.Stop) == "function" then
    pcall(previous.Stop)
end
local state = { Alive = true }
env[key] = state
local library, window
local connections = {}
local ownedGuis = {}
local function active()
    return state.Alive and env[key] == state
end
local function cleanup(fromWindow)
    if not state.Alive then return end
    state.Alive = false
    for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
    if window and not fromWindow and not window.Destroyed then pcall(function() window:Destroy() end) end
    for _, gui in ipairs(ownedGuis) do pcall(function() gui:Destroy() end) end
    if env[key] == state then env[key] = nil end
end
state.Stop = cleanup

if not game:IsLoaded() then game.Loaded:Wait() end
if not active() then return end
local base = "https://raw.githubusercontent.com/levox00/ps/facacf80db4b1a75eb37a546c0824b5286241ab4/assets/fake-an-egg/"
local uiUrl = "https://raw.githubusercontent.com/levox00/silk-windui/c753080cbcf10e5a491304843c5ad35f719e7d05/dist/SilkWindUI.luau"
local function loadAsset(name)
    local register = (type(getcustomasset) == "function" and getcustomasset) or (type(getsynasset) == "function" and getsynasset)
    if not register or type(writefile) ~= "function" then return nil, "custom assets are unavailable" end
    local filename = "FakeAnEgg_Blue_" .. name
    local function valid(data)
        return type(data) == "string" and #data >= 128 and #data <= 8 * 1024 * 1024 and data:sub(1, 8) == "\137PNG\13\10\26\10"
    end
    local ok, data = pcall(function() return game:HttpGet(base .. name) end)
    if not active() then return nil, "closed" end
    if ok and valid(data) then
        local saved, err = pcall(writefile, filename, data)
        if not saved then return nil, tostring(err) end
    else
        local cachedOk, cached = false, nil
        if type(readfile) == "function" then cachedOk, cached = pcall(readfile, filename) end
        if not cachedOk or not valid(cached) then return nil, "download failed and no cached image exists" end
    end
    local loaded, asset = pcall(register, filename)
    if not loaded or type(asset) ~= "string" or asset == "" then return nil, tostring(asset) end
    return asset
end
local function assetOrWarn(name)
    local asset, err = loadAsset(name)
    if not asset and active() then warn("[Fake an Egg] " .. name .. ": " .. tostring(err)) end
    return asset
end
local background = assetOrWarn("background.png")
if not active() then return end
local overlay = assetOrWarn("petals-overlay.png")
if not active() then return end
local logo = assetOrWarn("logo.png")
if not active() then return end
local ok, result = pcall(function()
    local source = game:HttpGet(uiUrl)
    assert(type(source) == "string" and #source > 10000, "UI library download failed")
    local factory, err = loadstring(source, "FakeAnEgg_SilkUI")
    assert(factory, err)
    return factory()
end)
if not ok then warn("[Fake an Egg] UI library: " .. tostring(result)); cleanup(); return end
library = result
local function destroyLibrary()
    if type(library) ~= "table" then return end
    for _, name in ipairs({"ScreenGui", "NotificationGui", "DropdownGui", "TooltipGui"}) do
        local gui = library[name]
        if gui then pcall(function() gui:Destroy() end) end
    end
end
if not active() then destroyLibrary(); return end
for _, name in ipairs({"ScreenGui", "NotificationGui", "DropdownGui", "TooltipGui"}) do
    local gui = library[name]
    if gui then table.insert(ownedGuis, gui) end
end
local root = library.ScreenGui
if root then
    local parent = root.Parent
    if parent then
        for _, gui in ipairs(parent:GetChildren()) do
            if gui ~= root and gui:GetAttribute("FakeAnEggUIOwned") == true then
                pcall(function() gui:Destroy() end)
            end
        end
    end
    for _, gui in ipairs(ownedGuis) do gui:SetAttribute("FakeAnEggUIOwned", true) end
end
local blue = {
    Name="Blue Petals", Accent=Color3.fromHex("#DBEEFF"), Dialog=Color3.fromHex("#F6FBFF"),
    Outline=Color3.fromHex("#5C94C6"), Text=Color3.fromHex("#15344D"),
    TabBackground=Color3.fromHex("#E3F1FA"), TabBackgroundHover=Color3.fromHex("#C6E4F8"),
    TabBackgroundHoverTransparency=0.15, TabBackgroundActive=Color3.fromHex("#176DA6"), TabBackgroundActiveTransparency=0,
    TabTextColor=Color3.fromHex("#15344D"), TabTextColorActive=Color3.fromHex("#FFFFFF"),
    TabIconColor=Color3.fromHex("#1E5E8B"), TabIconColorActive=Color3.fromHex("#FFFFFF"),
    TabBorder=Color3.fromHex("#5C94C6"), TabBorderTransparencyActive=0.12,
    Placeholder=Color3.fromHex("#5A7893"), Background=Color3.fromHex("#EAF6FE"),
    Button=Color3.fromHex("#CFE6F6"), Icon=Color3.fromHex("#1E5E8B"),
    DropdownBackground=Color3.fromHex("#F5FBFF"), DropdownTabBackground=Color3.fromHex("#E5F3FD"),
    DropdownTabBorder=Color3.fromHex("#8EBAD8"), Toggle=Color3.fromHex("#176DA6"),
    Slider=Color3.fromHex("#176DA6"), Checkbox=Color3.fromHex("#176DA6"), Primary=Color3.fromHex("#176DA6"),
    PanelBackground=Color3.fromHex("#F5FBFF"), PanelBackgroundTransparency=0.35,
    SliderIcon=Color3.fromHex("#FFFFFF"), LabelBackground=Color3.fromHex("#F5FBFF"),
    LabelBackgroundTransparency=0.2, ElementBackground=Color3.fromHex("#E7F3FB"),
    ElementBackgroundTransparency=0.2, SectionBoxBackground=Color3.fromHex("#E7F3FB"),
    SectionBoxBackgroundTransparency=0.2, SectionBoxBorder=Color3.fromHex("#E7F3FB"), SectionBoxBorderTransparency=1,
}
library:AddTheme(blue)
library:SetTheme("Blue Petals")
local created, problem = pcall(function()
    window = library:CreateWindow({
        Title="Fake an Egg", Author="PETALS UI", Icon=logo or "sparkles", IconSize=35, IconRadius=0, IconThemed=false,
        Size=UDim2.fromOffset(800,580), MinSize=Vector2.new(580,360), MaxSize=Vector2.new(1020,780),
        SideBarWidth=200, Theme="Blue Petals", Background=background, BackgroundImageTransparency=0.18,
        Transparent=true, Acrylic=false, Radius=14, ElementsRadius=10, AutoScale=true, Resizable=true,
        DragHandleOffset=Vector2.new(0,4), ResizeHandleOffset=Vector2.new(0,0),
        ScrollBarEnabled=true, NewElements=true, Topbar={Height=52,ButtonsType="Default"},
        OpenButton={Title="Fake an Egg",Icon=logo or "sparkles",OnlyMobile=false,Enabled=true,Draggable=true,
            StrokeThickness=1,Color=ColorSequence.new(Color3.fromHex("#176DA6"))},
    })
    assert(window, "window creation failed")
    if overlay then window:SetImageLayer("BluePetals", {Image=overlay,Layer="Above",Transparency=0.08}) end
    local tab=window:Tab({Title="Overview",Icon="layout-dashboard",CustomEmptyPage={Title="Fake an Egg"}})
    tab:Select()
    window:OnClose(function()
        task.delay(0.45,function()
            if active() and not window.Destroyed and window.Closed and window.IsOpenButtonEnabled and window.OpenButtonMain then
                window.OpenButtonMain:Visible(true)
            end
        end)
    end)
    window:OnDestroy(function() cleanup(true) end)
    window:Open()
end)
if not created then warn("[Fake an Egg] UI: " .. tostring(problem)); cleanup(); return end
if not active() then cleanup(); return end
