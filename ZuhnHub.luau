-- Zuhn Hub (Starlight Interface Suite - Full Custom List & Custom Logo Edition)
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Assets helper
local ASSET_BASE = "https://raw.githubusercontent.com/verroxz/zuhn-hub/main/"
local sfxLogoId = ""
local sfxSwooshId = ""
local ASSET_DIR = "zuhn-hub"

local function fetchAsset(name)
    if not (getcustomasset and writefile and isfile and makefolder and isfolder) then return nil end
    if not isfolder(ASSET_DIR) then pcall(makefolder, ASSET_DIR) end
    local path = ASSET_DIR .. "/" .. name
    if not isfile(path) then
        local ok, data = pcall(function() return game:HttpGet(ASSET_BASE .. name) end)
        if not ok or type(data) ~= "string" or #data < 100 then return nil end
        pcall(writefile, path, data)
    end
    local ok, id = pcall(getcustomasset, path)
    return ok and id or nil
end

sfxLogoId = fetchAsset("sfx_logo.mp3") or sfxLogoId
sfxSwooshId = fetchAsset("sfx_swoosh.mp3") or sfxSwooshId

-- Base64 User Custom Logo embedding
local EMBEDDED_LOGO_B64 = "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"
local userLogoAssetId = ""

local function setupUserLogo()
    if not (getcustomasset and writefile and isfile and makefolder and isfolder) then return nil end
    if not isfolder(ASSET_DIR) then pcall(makefolder, ASSET_DIR) end
    local path = ASSET_DIR .. "/zuhn_logo.png"
    local ok, binary = pcall(function()
        if crypt and crypt.base64decode then
            return crypt.base64decode(EMBEDDED_LOGO_B64)
        elseif syn and syn.crypt and syn.crypt.base64_decode then
            return syn.crypt.base64_decode(EMBEDDED_LOGO_B64)
        elseif base64_decode then
            return base64_decode(EMBEDDED_LOGO_B64)
        end
        return nil
    end)
    if ok and binary and #binary > 100 then
        local current = isfile(path) and readfile(path) or ""
        if current ~= binary then
            pcall(writefile, path, binary)
        end
    end
    if isfile(path) then
        local okAsset, id = pcall(getcustomasset, path)
        if okAsset and id then return id end
    end
    return nil
end

userLogoAssetId = setupUserLogo() or ""

local soundVolume = 0.65
local function playSound(assetId, vol)
    if not assetId or assetId == "" then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = assetId
        s.Volume = (vol or 0.6) * (soundVolume / 0.65)
        s.Parent = game:GetService("SoundService")
        s:Play()
        game:GetService("Debris"):AddItem(s, 10)
    end)
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.1)
    LocalPlayer = Players.LocalPlayer
end

-- State variables
local isSpamming = false
local spamMode = "PM"
local broadcastText = "BJ CANE GO GASWL"
local pmText = "Hello, buy cane here!"
local pmTarget = ""
local spamDelay = 1.0
local autoColorVariation = true
local staffProtection = true
local playerSearchQuery = ""

local itemSearchQuery = ""
local itemSortMode = "Default"

-- Host state variables
local hostDropCommandsEnabled = true
local hostGemsCountEnabled = false
local hostGemsDebounceDelay = 0.35
local hostClickPullEnabled = false
local lastClickPullTick = 0
local hostTaxUnit = "SL"
local hostTaxBet = 10
local hostTaxRateLock = 70
local hostTaxPercent = 10

_G.ZuhnHubToken = (_G.ZuhnHubToken or 0) + 1
local loopToken = _G.ZuhnHubToken

-- Color Pool from BitmapText.COLORS
local COLOR_POOL = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "b", "c", "e", "p", "w", "o", "q", "s", "v", "$"}
local colorCycleIndex = 0

local function getVariedPayload(rawText)
    if not autoColorVariation then return rawText end
    local cleaned = rawText:gsub("^`%w%s*", "")
    colorCycleIndex = (colorCycleIndex % #COLOR_POOL) + 1
    local cPrimary = COLOR_POOL[colorCycleIndex]
    local cSecondary = COLOR_POOL[((colorCycleIndex + 5) % #COLOR_POOL) + 1]
    return "`" .. cPrimary .. cleaned .. "`" .. cSecondary
end

-- Memory pointer handles
local atTileFn = nil
local othersActiveTable = nil
local rolesModule = nil
local worldTable = nil
local myInGameName = nil
local exemptionCache = {}

local charTable = nil
local othersMod = nil

local instantBreakEnabled = false
local longArmEnabled = false
local noclipEnabled = false

local origHandPower = nil
local origSendHit = nil
local origRaymanOn = nil
local origPunchRange = nil
local origBuildRange = nil
local origSolidAt = nil
local boxHitsFn = nil
local fireRaymanFn = nil
local hookChatCommands = nil

local function grabPointersOnce()
    if othersActiveTable and atTileFn and worldTable and rolesModule and charTable and othersMod then return end
    if not getgc then return end

    pcall(function()
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" then
                if not charTable and rawget(tbl, "handPower") and rawget(tbl, "punchRange") then
                    charTable = tbl
                end
                if not worldTable and rawget(tbl, "raymanOn") then
                    worldTable = tbl
                end
                if not othersMod and rawget(tbl, "sendHit") and rawget(tbl, "playerAt") then
                    othersMod = tbl
                end
                if charTable and worldTable and othersMod then break end
            end
        end

        for _, fn in ipairs(getgc(false)) do
            if type(fn) == "function" and islclosure(fn) then
                local n = debug.info(fn, "n")
                if (n == "wrenchAt" or n == "showNames") and not othersActiveTable then
                    local uvs = getupvalues(fn)
                    if #uvs >= 2 and type(uvs[1]) == "table" and type(uvs[2]) == "table" then
                        othersActiveTable = uvs[1]
                        rolesModule = uvs[2]
                    end
                elseif n == "atTile" and not atTileFn then
                    local uvs = getupvalues(fn)
                    if #uvs == 2 and type(uvs[1]) == "number" and type(uvs[2]) == "number" then
                        atTileFn = fn
                    end
                elseif not worldTable then
                    local s = debug.info(fn, "s")
                    if s and s:find("Game") then
                        local uvs = getupvalues(fn)
                        for _, uv in ipairs(uvs) do
                            if type(uv) == "table" and rawget(uv, "name") and rawget(uv, "w") and rawget(uv, "h") then
                                worldTable = uv
                                break
                            end
                        end
                    end
                end
                if worldTable and othersActiveTable and rolesModule and atTileFn and charTable and othersMod then break end
            end
        end
    end)

    if worldTable and worldTable.ownerName then
        if worldTable.lock and worldTable.lock.owner == LocalPlayer.UserId then
            myInGameName = worldTable.ownerName
        else
            myInGameName = LocalPlayer.DisplayName
        end
    else
        myInGameName = LocalPlayer.DisplayName
    end

    if hookChatCommands then pcall(hookChatCommands) end
end

local function isRaymanWorn()
    if charTable and charTable.punchRange then
        local uv1 = debug.getupvalue(charTable.punchRange, 1)
        if type(uv1) == "table" then
            if uv1.hand == 5480 then return true end
            for _, v in ipairs(uv1) do
                if v == 5480 then return true end
            end
        end
    end
    return false
end

local origTileSend = _G.ZuhnOrigTileSend
local netModule = nil
local ItemDB = nil
pcall(function()
    netModule = require(game:GetService("ReplicatedStorage").Shared.Net)
    ItemDB = require(game:GetService("ReplicatedStorage").Shared.ItemDB)
    if netModule and netModule.tile and not _G.ZuhnOrigTileSend then
        _G.ZuhnOrigTileSend = netModule.tile.send
    end
    origTileSend = _G.ZuhnOrigTileSend
end)

local breakBusy = {}

local function applyInstantBreak(enabled)
    grabPointersOnce()
    instantBreakEnabled = enabled
    if enabled then
        if charTable then
            if not origHandPower then origHandPower = charTable.handPower end
            charTable.handPower = function()
                return 100
            end
        end
        if netModule and netModule.tile then
            if not origTileSend then
                _G.ZuhnOrigTileSend = _G.ZuhnOrigTileSend or netModule.tile.send
                origTileSend = _G.ZuhnOrigTileSend
            end
            netModule.tile.send = function(data)
                if instantBreakEnabled and data and data.id == 0 then
                    local key = string.format("%d_%d_%d", data.layer, data.x, data.y)
                    if breakBusy[key] then return end
                    breakBusy[key] = true
                    local targetId = 2
                    if worldTable then
                        local grid = data.layer == 1 and worldTable.fg or worldTable.bg
                        if grid and grid[data.y] and grid[data.y][data.x] and grid[data.y][data.x] > 0 then
                            targetId = grid[data.y][data.x]
                        end
                    end
                    local reqHits = (ItemDB and ItemDB[targetId] and ItemDB[targetId].hits) or 3
                    local extraHits = math.clamp(reqHits + 1, 4, 8)
                    task.spawn(function()
                        pcall(function()
                            for _ = 1, extraHits do
                                if netModule and netModule.act then
                                    netModule.act.send({ kind = 1, x = data.x + 0.5, y = data.y + 0.5 })
                                    netModule.act.send({ kind = 6, x = data.x + 0.5, y = data.y + 0.5 })
                                elseif othersMod and othersMod.sendHit then
                                    othersMod.sendHit(data.x, data.y)
                                end
                                task.wait(0.08)
                            end
                            task.wait(0.10)
                            origTileSend(data)
                            task.wait(0.04)
                            origTileSend(data)
                        end)
                        task.wait(0.06)
                        breakBusy[key] = nil
                    end)
                    return
                end
                return origTileSend(data)
            end
        end
    else
        if charTable and origHandPower then
            charTable.handPower = origHandPower
        end
        if netModule and netModule.tile and origTileSend then
            netModule.tile.send = origTileSend
            origTileSend = nil
        end
        table.clear(breakBusy)
    end
end

local function applyLongArm(enabled)
    grabPointersOnce()
    if enabled then
        if charTable and charTable.onWear and not isRaymanWorn() then
            pcall(charTable.onWear, 5480)
        end
        if worldTable then
            if not origRaymanOn then origRaymanOn = worldTable.raymanOn end
            worldTable.raymanOn = function()
                return true
            end
        end
        if charTable then
            if not origPunchRange then origPunchRange = charTable.punchRange end
            charTable.punchRange = function(...)
                local base = origPunchRange and origPunchRange(...) or 2.5
                return math.max(base, 5.5)
            end
            if not origBuildRange then origBuildRange = charTable.buildRange end
            charTable.buildRange = function(...)
                local base = origBuildRange and origBuildRange(...) or 2.5
                return math.max(base, 5.5)
            end
        end
    else
        if charTable and charTable.onWear and isRaymanWorn() then
            pcall(charTable.onWear, 5480)
        end
        if worldTable and origRaymanOn then
            worldTable.raymanOn = origRaymanOn
        end
        if charTable then
            if origPunchRange then charTable.punchRange = origPunchRange end
            if origBuildRange then charTable.buildRange = origBuildRange end
        end
    end
end

local function getPhysicsPointers()
    if not boxHitsFn or not fireRaymanFn then
        for _, fn in ipairs(getgc(false)) do
            if type(fn) == "function" and islclosure(fn) then
                local s = debug.info(fn, "s")
                if s and s:find("GameGui.Game") then
                    local n = debug.info(fn, "n")
                    if n == "boxHits" then
                        boxHitsFn = fn
                    elseif n == "fireRayman" then
                        fireRaymanFn = fn
                    end
                end
            end
        end
    end
end

local function applyNoclip(enabled)
    grabPointersOnce()
    getPhysicsPointers()
    if not boxHitsFn then return end

    if enabled then
        if not origSolidAt then
            origSolidAt = debug.getupvalue(boxHitsFn, 1)
        end
        local function noclipSolidAt(x, y)
            if not noclipEnabled then
                return origSolidAt(x, y)
            end
            if x < 0 or (worldTable and x >= worldTable.w or x >= 100) or (worldTable and y >= worldTable.h or y >= 60) then
                return true
            end
            if fireRaymanFn then
                local py = debug.getupvalue(fireRaymanFn, 2)
                if py then
                    local feetY = math.floor(py)
                    local holdingDown = UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down)
                    if not holdingDown and y >= feetY then
                        return origSolidAt(x, y)
                    end
                end
            end
            return false
        end
        debug.setupvalue(boxHitsFn, 1, noclipSolidAt)
    else
        if origSolidAt then
            debug.setupvalue(boxHitsFn, 1, origSolidAt)
        end
    end
end

task.spawn(grabPointersOnce)

local function getPlayerRole(userId)
    if not userId then return nil, nil end
    local RS = game:GetService("ReplicatedStorage")

    -- 1. Game Developer / Creator
    if game.CreatorType == Enum.CreatorType.User and userId == game.CreatorId then
        return "Dev", "#FFC107"
    end
    local okRoles, rolesMod = pcall(require, RS.Shared.Roles)
    if okRoles and rolesMod then
        if rolesMod.isDeveloper and rolesMod.isDeveloper(userId) then
            return "Dev", "#FFC107"
        end
        if rolesMod.isModerator and rolesMod.isModerator(userId) then
            return "Mod", "#00E5FF"
        end
        if rolesMod.isStaff and rolesMod.isStaff(userId) then
            return "Staff", "#00E5FF"
        end
    end

    local staffFolder = RS:FindFirstChild("StaffRoles")
    if staffFolder then
        local attr = staffFolder:GetAttribute("u" .. tostring(userId))
        if attr == "developer" then
            return "Dev", "#FFC107"
        elseif attr == "moderator" or attr == "staff" then
            return "Staff", "#00E5FF"
        end
    end
    local modList = RS:FindFirstChild("ModeratorList")
    if modList and modList:GetAttribute("u" .. tostring(userId)) == true then
        return "Mod", "#00E5FF"
    end

    -- 2. World Roles (Owner / Admin)
    grabPointersOnce()
    local lock = worldTable and worldTable.lock
    if lock then
        if lock.owner == userId then
            return "Owner", "#50E3C2"
        end
        local okLock, areaLock = pcall(require, RS.Shared.AreaLock)
        if okLock and areaLock then
            if (areaLock.onList and areaLock.onList(lock, userId)) or (areaLock.hasAccess and areaLock.hasAccess(lock, userId)) then
                return "Admin", "#A77BFF"
            end
        end
        if lock.access then
            for _, acc in ipairs(lock.access) do
                if acc[1] == userId then
                    return "Admin", "#A77BFF"
                end
            end
        end
    end

    return nil, nil
end

local function isPlayerExempt(userId)
    if userId == LocalPlayer.UserId then return true, "SELF" end
    local role = getPlayerRole(userId)
    if role then
        return true, role:upper()
    end
    return false, "NORMAL"
end

-- Network & Game Commands
local function sendBroadcast(text)
    task.spawn(function()
        local payload = getVariedPayload(text)
        local wc = TextChatService:FindFirstChild("WorldChannels")
        if wc then
            for _, ch in ipairs(wc:GetChildren()) do
                if ch:IsA("TextChannel") then
                    local ok = pcall(function() ch:SendAsync(payload) end)
                    if ok then return end
                end
            end
        end
        local textChannels = TextChatService:FindFirstChild("TextChannels")
        if textChannels then
            local gen = textChannels:FindFirstChild("RBXGeneral") or textChannels:FindFirstChildWhichIsA("TextChannel")
            if gen then pcall(function() gen:SendAsync(payload) end) end
        end
    end)
end

local function sendPublicChat(text)
    task.spawn(function()
        local str = tostring(text)
        local wc = TextChatService:FindFirstChild("WorldChannels")
        if wc then
            for _, ch in ipairs(wc:GetChildren()) do
                if ch:IsA("TextChannel") then
                    local ok = pcall(function() ch:SendAsync(str) end)
                    if ok then return end
                end
            end
        end
        local textChannels = TextChatService:FindFirstChild("TextChannels")
        if textChannels then
            local gen = textChannels:FindFirstChild("RBXGeneral") or textChannels:FindFirstChildWhichIsA("TextChannel")
            if gen then pcall(function() gen:SendAsync(str) end) end
        end
    end)
end

local function sendPrivateMessage(targetIgn, text)
    task.spawn(function()
        local payload = getVariedPayload(text)
        local fullMsg = "/msg " .. targetIgn .. " " .. payload
        local wc = TextChatService:FindFirstChild("WorldChannels")
        if wc then
            for _, ch in ipairs(wc:GetChildren()) do
                if ch:IsA("TextChannel") then
                    local ok = pcall(function() ch:SendAsync(fullMsg) end)
                    if ok then return end
                end
            end
        end
        local textChannels = TextChatService:FindFirstChild("TextChannels")
        if textChannels then
            local gen = textChannels:FindFirstChild("RBXGeneral") or textChannels:FindFirstChildWhichIsA("TextChannel")
            if gen then pcall(function() gen:SendAsync(fullMsg) end) end
        end
    end)
end

local function executeWorldCommand(action, targetIgn)
    local cleanAction = action:lower()
    local remoteAction = cleanAction
    if cleanAction == "ban" then remoteAction = "wban" end

    task.spawn(function()
        local okNet, Net = pcall(require, ReplicatedStorage.Shared.Net)
        if okNet and Net and Net.call then
            pcall(Net.call, "WorldCommand", remoteAction, targetIgn)
        end
    end)
end

-- Native Inventory Reader
local clientInvObject = nil
local invUiHandle = nil
local invChangedConn = nil
local onInventoryChangedCallback = nil

local function hookInventoryListener(cInv)
    if not cInv or not cInv.changed or invChangedConn then return end
    pcall(function()
        invChangedConn = cInv.changed.Event:Connect(function()
            if onInventoryChangedCallback then
                task.spawn(pcall, onInventoryChangedCallback)
            end
        end)
    end)
end

local function getNativeInventory()
    if clientInvObject and invUiHandle then
        hookInventoryListener(clientInvObject)
        return clientInvObject, invUiHandle
    end
    if not getgc then return nil, nil end

    pcall(function()
        for _, fn in ipairs(getgc(false)) do
            if type(fn) == "function" and islclosure(fn) then
                local uvs = getupvalues(fn)
                for _, uv in ipairs(uvs) do
                    if type(uv) == "table" and type(rawget(uv, "onDrop")) == "function" and type(rawget(uv, "refresh")) == "function" then
                        invUiHandle = uv
                        local refFn = uv.refresh
                        if refFn and islclosure(refFn) then
                            local rUvs = getupvalues(refFn)
                            for _, rUv in ipairs(rUvs) do
                                if type(rUv) == "table" and rawget(rUv, "slots") and rawget(rUv, "capacity") then
                                    clientInvObject = rUv
                                    hookInventoryListener(clientInvObject)
                                    break
                                end
                            end
                        end
                        break
                    end
                end
                if clientInvObject and invUiHandle then break end
            end
        end
    end)
    return clientInvObject, invUiHandle
end

local function executeDrop(itemId, amount, itemName)
    amount = tonumber(amount) or 1
    if amount <= 0 then return end

    local myPx = atTileFn and debug.getupvalue(atTileFn, 1) or 0
    local myPy = atTileFn and debug.getupvalue(atTileFn, 2) or 0
    local dropX = myPx + 0.5
    local dropY = myPy - 0.45

    local cInv, uiHandle = getNativeInventory()
    if cInv and cInv.remove then pcall(function() cInv:remove(itemId, amount) end) end
    if uiHandle and uiHandle.refresh then pcall(uiHandle.refresh) end

    local okNet, Net = pcall(require, game:GetService("ReplicatedStorage").Shared.Net)
    if okNet and Net and Net.drop and Net.drop.send then
        pcall(function()
            Net.drop.send({id = tonumber(itemId), n = tonumber(amount), x = dropX, y = dropY})
        end)
    end
end

-- Host Feature Helpers (Commands & Gems Counter)
local function getInventoryItemCount(targetId)
    local cInv = getNativeInventory()
    if not cInv or not cInv.slots then return 0 end
    local count = 0
    for _, slot in ipairs(cInv.slots) do
        local id = type(slot) == "table" and (slot.id or slot[1]) or nil
        local n = type(slot) == "table" and (slot.n or slot[2] or 0) or 0
        if tonumber(id) == tonumber(targetId) then
            count = count + n
        end
    end
    return count
end

local function getChatTable()
    local chatGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("ChatGui")
    if not chatGui then return nil end
    local hud = chatGui:FindFirstChild("HUD")
    local input = hud and hud:FindFirstChild("ConsoleClip") and hud.ConsoleClip:FindFirstChild("Bar") and hud.ConsoleClip.Bar:FindFirstChild("Field") and hud.ConsoleClip.Bar.Field:FindFirstChild("Input")
    if not input then return nil end
    for _, conn in ipairs(getconnections(input.FocusLost)) do
        local fn = conn.Function
        if fn and debug.info(fn, "s"):find("ChatUI") then
            local uvs = getupvalues(fn)
            local sendFn = uvs[4]
            if sendFn and type(sendFn) == "function" then
                local tbl = debug.getupvalue(sendFn, 1)
                if type(tbl) == "table" and tbl.onCommand and tbl.add then
                    return tbl
                end
            end
        end
    end
    return nil
end

local function handleHostDropCommand(cmdName, qty)
    local short = cmdName:sub(2):lower()
    local LOCK_MAP = {
        sl = { id = 202, name = "Small Lock" },
        wl = { id = 242, name = "World Lock" },
        dl = { id = 1796, name = "Diamond Lock" },
    }
    local info = LOCK_MAP[short]
    if not info then return end

    qty = tonumber(qty) or 1
    if qty < 1 then qty = 1 end

    local available = getInventoryItemCount(info.id)
    local cTable = getChatTable()

    if available <= 0 then
        if cTable and cTable.add then
            cTable.add(string.format("dropped 0 %s (none in inventory)", short))
        end
        return
    end

    local actualDrop = math.min(qty, available)
    executeDrop(info.id, actualDrop, info.name)

    if cTable and cTable.add then
        cTable.add(string.format("dropped %d %s", actualDrop, short))
    end

    task.spawn(function()
        task.wait(0.2)
        if refreshInventoryUI then pcall(refreshInventoryUI) end
    end)
end

local origOnCommand = nil
local hookedChatTable = nil

function hookChatCommands()
    local cTable = getChatTable()
    if not cTable or hookedChatTable == cTable then return end
    hookedChatTable = cTable
    origOnCommand = cTable.onCommand
    cTable.onCommand = function(cmd, ...)
        if hostDropCommandsEnabled and type(cmd) == "string" then
            local clean = cmd:gsub("^%s+", ""):gsub("%s+$", "")
            local cmdName, argStr = clean:match("^/([Dd][SsWwDd][Ll])%s*(%d*)$")
            if not cmdName then
                local dType, dArg = clean:match("^/[Dd][Rr][Oo][Pp]%s+([SsWwDd][Ll])%s*(%d*)$")
                if dType then
                    cmdName = "d" .. dType:lower()
                    argStr = dArg
                end
            end
            if cmdName then
                local lowerCmd = cmdName:lower()
                local qty = tonumber(argStr)
                if not qty or qty < 1 then qty = 1 end
                handleHostDropCommand(lowerCmd, qty)
                return
            end
        end
        return origOnCommand(cmd, ...)
    end
end

local lastKnownGems = nil
local pendingGems = 0
local gemsDebounceThread = nil

local function onGemsPickedUp(amount)
    if not hostGemsCountEnabled then return end
    pendingGems = pendingGems + amount
    if gemsDebounceThread then
        task.cancel(gemsDebounceThread)
    end
    gemsDebounceThread = task.delay(hostGemsDebounceDelay, function()
        local total = pendingGems
        pendingGems = 0
        gemsDebounceThread = nil
        if total > 0 and hostGemsCountEnabled then
            sendPublicChat(tostring(total))
        end
    end)
end

local function getGemsWatcherHandle()
    local chatGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("ChatGui")
    if not chatGui then return nil, nil end
    local hud = chatGui:FindFirstChild("HUD")
    local input = hud and hud:FindFirstChild("ConsoleClip") and hud.ConsoleClip:FindFirstChild("Bar") and hud.ConsoleClip.Bar:FindFirstChild("Field") and hud.ConsoleClip.Bar.Field:FindFirstChild("Input")
    if not input then return nil, nil end
    for _, conn in ipairs(getconnections(input.FocusLost)) do
        local fn = conn.Function
        if fn and debug.info(fn, "s"):find("ChatUI") then
            local uvs = getupvalues(fn)
            local sendFn = uvs[4]
            if sendFn and type(sendFn) == "function" then
                local tbl = debug.getupvalue(sendFn, 1)
                if type(tbl) == "table" and tbl.addGems then
                    local u2 = debug.getupvalue(tbl.addGems, 2)
                    return tbl.addGems, u2
                end
            end
        end
    end
    return nil, nil
end

-- Passive Gems Watcher (Zero hooks, native pickup preserved 100%)
task.spawn(function()
    while _G.ZuhnHubToken == loopToken do
        task.wait(0.05)
        local addGemsFn, u2 = getGemsWatcherHandle()
        if addGemsFn then
            local currentGems = (u2 and tonumber(u2.text)) or (debug.getupvalue(addGemsFn, 1))
            if currentGems and type(currentGems) == "number" then
                if lastKnownGems == nil then
                    lastKnownGems = currentGems
                elseif currentGems > lastKnownGems then
                    local delta = currentGems - lastKnownGems
                    lastKnownGems = currentGems
                    onGemsPickedUp(delta)
                else
                    lastKnownGems = currentGems
                end
            end
        end
    end
end)

-- ==============================================================
-- BOOT STARLIGHT INTERFACE SUITE & NEBULA ICONS
-- ==============================================================
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    for _, child in ipairs(CoreGui:GetChildren()) do
        if child.Name:find("Starlight") then child:Destroy() end
    end
    local RobloxGui = CoreGui:FindFirstChild("RobloxGui")
    if RobloxGui then
        for _, child in ipairs(RobloxGui:GetChildren()) do
            if child.Name:find("Starlight") then child:Destroy() end
        end
    end
end)

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()
local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()

-- Remove orphaned prebuilt config tooltip permanently
task.spawn(function()
    task.wait(0.5)
    pcall(function()
        local RobloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
        if RobloxGui then
            for _, sg in ipairs(RobloxGui:GetChildren()) do
                if sg.Name:find("Starlight") then
                    local tooltips = sg:FindFirstChild("Tooltips")
                    if tooltips then
                        local badTip = tooltips:FindFirstChild("BUTTON___prebuiltConfigDeleter")
                        if badTip then badTip:Destroy() end
                    end
                end
            end
        end
    end)
end)

playSound(sfxLogoId, 0.7)

local Window = Starlight:CreateWindow({
    Name = "Zuhn Hub",
    Subtitle = "v1.6",
    Icon = NebulaIcons:GetIcon("bolt", "Material"),
    DefaultSize = UDim2.fromOffset(560, 400),
    LoadingSettings = {
        Title = "Zuhn Hub",
        Subtitle = "by verroxz",
    },
})

-- Destroy built-in Starlight HomeTab / Dashboard placeholder (Discord, Changelog, tsuyuki_kanao)
pcall(function()
    local home = (Window.Instance and Window.Instance:FindFirstChild("HomeTab", true))
        or (Starlight.Instance and Starlight.Instance:FindFirstChild("HomeTab", true))
    if home then home:Destroy() end
end)

-- ==============================================================
-- TABS SETUP
-- ==============================================================
local MainTabSection = Window:CreateTabSection("")

-- TAB 1: PLAYER MODS (Instant Break & Long Arm Rayman)
local LocalPlayerTab = MainTabSection:CreateTab({
    Name = "",
    Icon = NebulaIcons:GetIcon("person", "Material"),
    Columns = 1,
}, "LocalPlayerTab")

local LocalPlayerBox = LocalPlayerTab:CreateGroupbox({
    Name = "Player Modifications",
    Column = 1,
}, "LocalPlayerBox")

LocalPlayerBox:CreateToggle({
    Name = "Instant Break",
    CurrentValue = false,
    Callback = function(val)
        instantBreakEnabled = val
        applyInstantBreak(val)
    end
}, "ToggleInstantBreak")

LocalPlayerBox:CreateToggle({
    Name = "Long Arm (Rayman 3 Blocks)",
    CurrentValue = false,
    Callback = function(val)
        longArmEnabled = val
        applyLongArm(val)
    end
}, "ToggleLongArm")

local MovementBox = LocalPlayerTab:CreateGroupbox({
    Name = "Movement",
    Column = 1,
}, "MovementBox")

MovementBox:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(val)
        noclipEnabled = val
        applyNoclip(val)
    end
}, "ToggleNoclip")

-- TAB 2: PLAYERS (Direct Scrollable List with inline action buttons)
local PlayerTab = MainTabSection:CreateTab({
    Name = "",
    Icon = NebulaIcons:GetIcon("group", "Material"),
    Columns = 1,
}, "PlayerTab")

local PlayerBox = PlayerTab:CreateGroupbox({
    Name = "Players in World",
    Column = 1,
}, "PlayerBox")

PlayerBox:CreateInput({
    Name = "Search Player",
    PlaceholderText = "Search by IGN or @username...",
    CurrentValue = "",
    Numeric = false,
    Enter = false,
    Callback = function(txt)
        playerSearchQuery = txt:lower()
        pcall(refreshPlayersUI)
    end
}, "InputSearchPlayer")

PlayerBox:CreateButton({
    Name = "↻ Refresh Player List",
    Icon = NebulaIcons:GetIcon("refresh", "Material"),
    Callback = function()
        pcall(refreshPlayersUI)
        Starlight:Notification({
            Title = "Refreshed",
            Icon = NebulaIcons:GetIcon("refresh", "Material"),
            Content = "Player list updated!"
        }, "NotiRefreshPlayers")
    end
}, "BtnRefreshPlayers")

PlayerBox:CreateDivider()

-- Container for Dynamic Players List (ZIndex 15 for Global ZIndexBehavior visibility)
local playerListContainer = Instance.new("Frame")
playerListContainer.Name = "PlayerListContainer"
playerListContainer.BackgroundTransparency = 1
playerListContainer.BorderSizePixel = 0
playerListContainer.ZIndex = 15
playerListContainer.Size = UDim2.new(1, 0, 0, 0)
playerListContainer.AutomaticSize = Enum.AutomaticSize.Y
playerListContainer.Parent = PlayerBox.ParentingItem

local pListLayout = Instance.new("UIListLayout")
pListLayout.FillDirection = Enum.FillDirection.Vertical
pListLayout.SortOrder = Enum.SortOrder.LayoutOrder
pListLayout.Padding = UDim.new(0, 6)
pListLayout.Parent = playerListContainer

local function isPlayerTabVisible()
    if not playerListContainer or not playerListContainer.Parent then return false end
    local tabFrame = playerListContainer:FindFirstAncestor("TAB_PlayerTab")
    if tabFrame and not tabFrame.Visible then return false end
    local mw = playerListContainer:FindFirstAncestor("MainWindow")
    if mw and not mw.Visible then return false end
    return true
end

local function createPlayerRow(playerData)
    local ign = playerData.name
    local uid = playerData.userId
    local rbxUsername = (playerData.who and playerData.who.Name) or (playerData.who and tostring(playerData.who)) or ""

    local distStr = ""
    if atTileFn and playerData.x and playerData.y then
        local myPx = debug.getupvalue(atTileFn, 1) or 0
        local myPy = debug.getupvalue(atTileFn, 2) or 0
        local dx = (playerData.x - myPx)
        local dy = (playerData.y - myPy)
        local d = math.sqrt(dx*dx + dy*dy)
        distStr = string.format(" • %.1f tiles", d)
    end

    local row = Instance.new("Frame")
    row.Name = "PlayerRow_" .. tostring(uid or ign)
    row.BackgroundColor3 = Color3.fromRGB(27, 29, 33)
    row.BorderSizePixel = 0
    row.ZIndex = 15
    row.Size = UDim2.new(1, 0, 0, 46)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = row

    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(65, 69, 77)
    border.Thickness = 1
    border.Parent = row

    -- Title: In-Game Name (IGN) + Role Badge
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PlayerName"
    nameLabel.BackgroundTransparency = 1
    nameLabel.ZIndex = 16
    nameLabel.Position = UDim2.new(0, 12, 0, 6)
    nameLabel.Size = UDim2.new(1, -215, 0, 18)
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.RichText = true
    local role, roleColor = getPlayerRole(uid)
    if role then
        nameLabel.Text = string.format('<b>%s</b>  <font color="%s"><b>(%s)</b></font>', ign, roleColor, role)
    else
        nameLabel.Text = string.format('<b>%s</b>', ign)
    end
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = row

    -- Subtitle: @username + tiles distance
    local subLabel = Instance.new("TextLabel")
    subLabel.Name = "PlayerSubtitle"
    subLabel.BackgroundTransparency = 1
    subLabel.ZIndex = 16
    subLabel.Position = UDim2.new(0, 12, 0, 24)
    subLabel.Size = UDim2.new(1, -215, 0, 16)
    subLabel.Font = Enum.Font.Gotham
    local userPart = (rbxUsername ~= "" and rbxUsername ~= ign) and ("@" .. rbxUsername) or ("@" .. ign)
    subLabel.Text = userPart .. distStr
    subLabel.TextColor3 = Color3.fromRGB(165, 165, 165)
    subLabel.TextSize = 11
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.TextTruncate = Enum.TextTruncate.AtEnd
    subLabel.Parent = row

    -- Actions Button Group (Ordered Left to Right: Pull > Kick > Ban)
    local actionHolder = Instance.new("Frame")
    actionHolder.Name = "Actions"
    actionHolder.BackgroundTransparency = 1
    actionHolder.ZIndex = 16
    actionHolder.Position = UDim2.new(1, -205, 0, 8)
    actionHolder.Size = UDim2.new(0, 195, 0, 30)
    actionHolder.Parent = row

    local hLayout = Instance.new("UIListLayout")
    hLayout.FillDirection = Enum.FillDirection.Horizontal
    hLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    hLayout.SortOrder = Enum.SortOrder.LayoutOrder
    hLayout.Padding = UDim.new(0, 5)
    hLayout.Parent = actionHolder

    local function makeBtn(text, order, onClick)
        local btn = Instance.new("TextButton")
        btn.Name = "Btn_" .. text
        btn.LayoutOrder = order
        btn.BackgroundColor3 = Color3.fromRGB(33, 36, 42)
        btn.BorderSizePixel = 0
        btn.ZIndex = 17
        btn.Size = UDim2.new(0, 58, 1, 0)
        btn.Font = Enum.Font.GothamMedium
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 11
        btn.AutoButtonColor = false

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 49, 57)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(33, 36, 42)}):Play()
        end)

        btn.MouseButton1Click:Connect(onClick)
        btn.Parent = actionHolder
        return btn
    end

    -- Pull (Order 1)
    makeBtn("Pull", 1, function()
        executeWorldCommand("pull", ign)
        Starlight:Notification({
            Title = "Executed",
            Icon = NebulaIcons:GetIcon("check_circle_outline", "Material"),
            Content = "/pull " .. ign
        }, "NotiPull")
    end)

    -- Kick (Order 2)
    makeBtn("Kick", 2, function()
        executeWorldCommand("kick", ign)
        Starlight:Notification({
            Title = "Executed",
            Icon = NebulaIcons:GetIcon("check_circle_outline", "Material"),
            Content = "/kick " .. ign
        }, "NotiKick")
    end)

    -- Ban (Order 3)
    makeBtn("Ban", 3, function()
        executeWorldCommand("ban", ign)
        Starlight:Notification({
            Title = "Executed",
            Icon = NebulaIcons:GetIcon("check_circle_outline", "Material"),
            Content = "/wban " .. ign
        }, "NotiBan")
    end)

    row.Parent = playerListContainer
end

function refreshPlayersUI()
    grabPointersOnce()
    if not playerListContainer or not playerListContainer.Parent then return end

    local activeRowNames = {}
    local count = 0

    if othersActiveTable then
        for _, v in pairs(othersActiveTable) do
            if type(v) == "table" and rawget(v, "name") and rawget(v, "userId") then
                local ign = tostring(v.name)
                local ignLower = ign:lower()
                local rbxName = (v.who and v.who.Name) and tostring(v.who.Name):lower() or ""
                local match = true
                if playerSearchQuery and playerSearchQuery ~= "" then
                    match = ignLower:find(playerSearchQuery, 1, true) or rbxName:find(playerSearchQuery, 1, true)
                end

                if match then
                    count = count + 1
                    local rowKey = "PlayerRow_" .. tostring(v.userId or ign)
                    activeRowNames[rowKey] = true

                    local existingRow = playerListContainer:FindFirstChild(rowKey)
                    if existingRow then
                        -- Smooth in-place property update without destroying UI or losing clicks
                        local distStr = ""
                        if atTileFn and v.x and v.y then
                            local myPx = debug.getupvalue(atTileFn, 1) or 0
                            local myPy = debug.getupvalue(atTileFn, 2) or 0
                            local dx = (v.x - myPx)
                            local dy = (v.y - myPy)
                            distStr = string.format(" • %.1f tiles", math.sqrt(dx*dx + dy*dy))
                        end
                        local subLbl = existingRow:FindFirstChild("PlayerSubtitle")
                        if subLbl then
                            local rbxUsername = (v.who and v.who.Name) or (v.who and tostring(v.who)) or ""
                            local userPart = (rbxUsername ~= "" and rbxUsername ~= ign) and ("@" .. rbxUsername) or ("@" .. ign)
                            subLbl.Text = userPart .. distStr
                        end
                        local nameLbl = existingRow:FindFirstChild("PlayerName")
                        if nameLbl then
                            local role, roleColor = getPlayerRole(v.userId)
                            nameLbl.RichText = true
                            if role then
                                nameLbl.Text = string.format('<b>%s</b>  <font color="%s"><b>(%s)</b></font>', ign, roleColor, role)
                            else
                                nameLbl.Text = string.format('<b>%s</b>', ign)
                            end
                        end
                        existingRow.Visible = true
                    else
                        createPlayerRow(v)
                    end
                end
            end
        end
    end

    -- Remove left players
    for _, ch in ipairs(playerListContainer:GetChildren()) do
        if ch:IsA("Frame") and ch.Name:find("^PlayerRow_") then
            if not activeRowNames[ch.Name] then
                ch:Destroy()
            end
        end
    end

    -- Empty label
    local emptyLbl = playerListContainer:FindFirstChild("EmptyLabel")
    if count == 0 then
        if not emptyLbl then
            emptyLbl = Instance.new("TextLabel")
            emptyLbl.Name = "EmptyLabel"
            emptyLbl.BackgroundTransparency = 1
            emptyLbl.ZIndex = 16
            emptyLbl.Size = UDim2.new(1, 0, 0, 32)
            emptyLbl.Font = Enum.Font.Gotham
            emptyLbl.TextColor3 = Color3.fromRGB(165, 165, 165)
            emptyLbl.TextSize = 12
            emptyLbl.Parent = playerListContainer
        end
        emptyLbl.Text = (playerSearchQuery ~= "") and "No players matched your search query." or "No other players detected in this world."
        emptyLbl.Visible = true
    elseif emptyLbl then
        emptyLbl:Destroy()
    end
end

-- Real-Time Dynamic Auto-Refresh Background Loop for Player List
local isUserTyping = false
UserInputService.TextBoxFocused:Connect(function()
    isUserTyping = true
end)
UserInputService.TextBoxFocusReleased:Connect(function()
    isUserTyping = false
end)

-- Click Character to Pull (/pull)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not hostClickPullEnabled then return end
    if _G.ZuhnHubToken ~= loopToken then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    if isUserTyping or UserInputService:GetFocusedTextBox() then
        return
    end

    -- Ignore clicks inside Starlight MainWindow
    if Starlight and Starlight.Instance and Starlight.Instance:FindFirstChild("MainWindow") then
        local mw = Starlight.Instance.MainWindow
        if mw.Visible then
            local pos = mw.AbsolutePosition
            local size = mw.AbsoluteSize
            local mx, my = input.Position.X, input.Position.Y
            if mx >= pos.X and mx <= pos.X + size.X and my >= pos.Y and my <= pos.Y + size.Y then
                return
            end
        end
    end

    local now = tick()
    if now - lastClickPullTick < 0.35 then return end

    grabPointersOnce()
    if not othersActiveTable then return end

    local clickX = input.Position.X
    local clickY = input.Position.Y
    local closestDist = math.huge
    local chosenName = nil

    for _, v in pairs(othersActiveTable) do
        if type(v) == "table" and v.seen then
            local isHit = false
            local center = nil

            local pFrame = v.group and v.group:FindFirstChild("Player")
            if pFrame and pFrame.Visible ~= false then
                local pos = pFrame.AbsolutePosition
                local size = pFrame.AbsoluteSize
                if clickX >= pos.X - 10 and clickX <= pos.X + size.X + 10 and
                   clickY >= pos.Y - 10 and clickY <= pos.Y + size.Y + 10 then
                    isHit = true
                    center = pos + size / 2
                end
            end

            if not isHit and v.tag and v.tag.Visible ~= false then
                local pos = v.tag.AbsolutePosition
                local size = v.tag.AbsoluteSize
                if clickX >= pos.X - 6 and clickX <= pos.X + size.X + 6 and
                   clickY >= pos.Y - 6 and clickY <= pos.Y + size.Y + 6 then
                    isHit = true
                    center = pos + size / 2
                end
            end

            if isHit and center then
                local dist = (Vector2.new(clickX, clickY) - center).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    chosenName = v.name or (v.who and v.who.Name)
                end
            end
        end
    end

    if chosenName and #chosenName > 0 then
        lastClickPullTick = now
        executeWorldCommand("pull", chosenName)
        Starlight:Notification({
            Title = "Executed",
            Icon = NebulaIcons:GetIcon("check_circle_outline", "Material"),
            Content = "/pull " .. chosenName
        }, "NotiClickPull")
    end
end)

task.spawn(function()
    while _G.ZuhnHubToken == loopToken do
        task.wait(1.0)
        pcall(function()
            if instantBreakEnabled then applyInstantBreak(true) end
            if longArmEnabled then applyLongArm(true) end
            if noclipEnabled then applyNoclip(true) end
            hookChatCommands()
        end)
        if not isUserTyping and isPlayerTabVisible() then
            pcall(refreshPlayersUI)
        end
    end
end)

-- TAB 2: ITEM DROPPER (Direct Scrollable List with Search & Sort)
local ItemTab = MainTabSection:CreateTab({
    Name = "",
    Icon = NebulaIcons:GetIcon("backpack", "Material"),
    Columns = 1,
}, "ItemTab")

local ItemBox = ItemTab:CreateGroupbox({
    Name = "Inventory Items",
    Column = 1,
}, "ItemBox")

ItemBox:CreateInput({
    Name = "Search Item",
    PlaceholderText = "Type item name...",
    CurrentValue = "",
    Numeric = false,
    Enter = false,
    Callback = function(txt)
        itemSearchQuery = txt:lower()
        pcall(refreshInventoryUI)
    end
}, "InputSearchItem")

ItemBox:CreateLabel({
    Name = "Sort Items",
}, "LblSortItem"):AddDropdown({
    Options = {"Default", "A-Z", "Lock Priority"},
    CurrentOption = {"Default"},
    MultipleOptions = false,
    Callback = function(Option)
        local val = type(Option) == "table" and Option[1] or Option
        itemSortMode = val or "Default"
        pcall(refreshInventoryUI)
    end
}, "DrpSortItem")

ItemBox:CreateButton({
    Name = "↻ Refresh Inventory",
    Icon = NebulaIcons:GetIcon("refresh", "Material"),
    Callback = function()
        pcall(refreshInventoryUI)
        Starlight:Notification({
            Title = "Inventory Refreshed",
            Icon = NebulaIcons:GetIcon("refresh", "Material"),
            Content = "Item slots synchronized!"
        }, "NotiInv")
    end
}, "BtnRefreshInv")

ItemBox:CreateDivider()

-- Container for Dynamic Items List (ZIndex 15 for Global ZIndexBehavior visibility)
local itemListContainer = Instance.new("Frame")
itemListContainer.Name = "ItemListContainer"
itemListContainer.BackgroundTransparency = 1
itemListContainer.BorderSizePixel = 0
itemListContainer.ZIndex = 15
itemListContainer.Size = UDim2.new(1, 0, 0, 0)
itemListContainer.AutomaticSize = Enum.AutomaticSize.Y
itemListContainer.Parent = ItemBox.ParentingItem

local iListLayout = Instance.new("UIListLayout")
iListLayout.FillDirection = Enum.FillDirection.Vertical
iListLayout.SortOrder = Enum.SortOrder.LayoutOrder
iListLayout.Padding = UDim.new(0, 6)
iListLayout.Parent = itemListContainer

local function createItemRow(itemId, itemName, itemCount)
    local row = Instance.new("Frame")
    row.Name = "ItemRow_" .. tostring(itemId)
    row.BackgroundColor3 = Color3.fromRGB(27, 29, 33)
    row.BorderSizePixel = 0
    row.ZIndex = 15
    row.Size = UDim2.new(1, 0, 0, 42)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = row

    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(65, 69, 77)
    border.Thickness = 1
    border.Parent = row

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "ItemName"
    nameLabel.BackgroundTransparency = 1
    nameLabel.ZIndex = 16
    nameLabel.Position = UDim2.new(0, 12, 0, 0)
    nameLabel.Size = UDim2.new(1, -225, 1, 0)
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.Text = string.format("%s (x%d)", itemName, itemCount)
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = row

    -- Actions Holder: Amount Input + Drop Button + Drop All Button
    local actionHolder = Instance.new("Frame")
    actionHolder.Name = "Actions"
    actionHolder.BackgroundTransparency = 1
    actionHolder.ZIndex = 16
    actionHolder.Position = UDim2.new(1, -215, 0, 6)
    actionHolder.Size = UDim2.new(0, 205, 0, 30)
    actionHolder.Parent = row

    local hLayout = Instance.new("UIListLayout")
    hLayout.FillDirection = Enum.FillDirection.Horizontal
    hLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    hLayout.Padding = UDim.new(0, 5)
    hLayout.Parent = actionHolder

    -- Amount Input Box (Starlight Dark BG)
    local amountInput = Instance.new("TextBox")
    amountInput.Name = "AmountInput"
    amountInput.BackgroundColor3 = Color3.fromRGB(23, 25, 29)
    amountInput.BorderSizePixel = 0
    amountInput.ZIndex = 17
    amountInput.Size = UDim2.new(0, 48, 1, 0)
    amountInput.Font = Enum.Font.GothamBold
    amountInput.Text = "1"
    amountInput.PlaceholderText = "1"
    amountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    amountInput.TextSize = 12
    amountInput.ClearTextOnFocus = false

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = amountInput

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(65, 69, 77)
    inputStroke.Thickness = 1
    inputStroke.Parent = amountInput
    amountInput.Parent = actionHolder

    -- Drop Custom Amount Button (No colored outline, white text)
    local dropBtn = Instance.new("TextButton")
    dropBtn.Name = "BtnDrop"
    dropBtn.BackgroundColor3 = Color3.fromRGB(33, 36, 42)
    dropBtn.BorderSizePixel = 0
    dropBtn.ZIndex = 17
    dropBtn.Size = UDim2.new(0, 65, 1, 0)
    dropBtn.Font = Enum.Font.GothamMedium
    dropBtn.Text = "Drop"
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 11
    dropBtn.AutoButtonColor = false

    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 6)
    dropCorner.Parent = dropBtn

    dropBtn.MouseEnter:Connect(function()
        TweenService:Create(dropBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 49, 57)}):Play()
    end)
    dropBtn.MouseLeave:Connect(function()
        TweenService:Create(dropBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(33, 36, 42)}):Play()
    end)

    dropBtn.MouseButton1Click:Connect(function()
        local qty = tonumber(amountInput.Text) or 1
        qty = math.clamp(qty, 1, itemCount)
        executeDrop(itemId, qty, itemName)
        Starlight:Notification({
            Title = "Dropped",
            Icon = NebulaIcons:GetIcon("check_circle_outline", "Material"),
            Content = string.format("Dropped %d %s", qty, itemName)
        }, "NotiDrop")
        task.wait(0.2)
        refreshInventoryUI()
    end)
    dropBtn.Parent = actionHolder

    -- Drop All Button (No colored outline, white text)
    local dropAllBtn = Instance.new("TextButton")
    dropAllBtn.Name = "BtnDropAll"
    dropAllBtn.BackgroundColor3 = Color3.fromRGB(33, 36, 42)
    dropAllBtn.BorderSizePixel = 0
    dropAllBtn.ZIndex = 17
    dropAllBtn.Size = UDim2.new(0, 65, 1, 0)
    dropAllBtn.Font = Enum.Font.GothamMedium
    dropAllBtn.Text = "Drop All"
    dropAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropAllBtn.TextSize = 11
    dropAllBtn.AutoButtonColor = false

    local dropAllCorner = Instance.new("UICorner")
    dropAllCorner.CornerRadius = UDim.new(0, 6)
    dropAllCorner.Parent = dropAllBtn

    dropAllBtn.MouseEnter:Connect(function()
        TweenService:Create(dropAllBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 49, 57)}):Play()
    end)
    dropAllBtn.MouseLeave:Connect(function()
        TweenService:Create(dropAllBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(33, 36, 42)}):Play()
    end)

    dropAllBtn.MouseButton1Click:Connect(function()
        executeDrop(itemId, itemCount, itemName)
        Starlight:Notification({
            Title = "Dropped All",
            Icon = NebulaIcons:GetIcon("check_circle_outline", "Material"),
            Content = string.format("Dropped %d %s", itemCount, itemName)
        }, "NotiDropAll")
        task.wait(0.2)
        refreshInventoryUI()
    end)
    dropAllBtn.Parent = actionHolder

    row.Parent = itemListContainer
end

local function isGenuineLockItem(name)
    local lower = (name or ""):lower():match("^%s*(.-)%s*$")
    return lower ~= nil and lower:match("%f[%a]lock$") ~= nil
end

function refreshInventoryUI()
    local cInv, uiHandle = getNativeInventory()
    for _, ch in ipairs(itemListContainer:GetChildren()) do
        if ch:IsA("Frame") or ch:IsA("TextLabel") then
            ch:Destroy()
        end
    end

    if not cInv or not cInv.slots then return end

    local okDB, itemDB = pcall(require, ReplicatedStorage.Shared.ItemDB)
    local items = {}

    for i, slot in ipairs(cInv.slots) do
        local id = type(slot) == "table" and (slot.id or slot[1]) or nil
        local n = type(slot) == "table" and (slot.n or slot[2] or 0) or 0
        local idNum = tonumber(id) or 0
        -- Filter out Fist (ID 18) and Wrench (ID 32)
        if id and n > 0 and idNum ~= 18 and idNum ~= 32 then
            local itemData = (okDB and itemDB and itemDB[id]) or {}
            local name = itemData.name or ("Item #" .. tostring(id))
            table.insert(items, {id = id, name = name, amount = n, originalIndex = i})
        end
    end

    -- Sorting Logic
    if itemSortMode == "A-Z" then
        table.sort(items, function(a, b)
            return a.name:lower() < b.name:lower()
        end)
    elseif itemSortMode == "Lock Priority" then
        table.sort(items, function(a, b)
            local aIsLock = isGenuineLockItem(a.name)
            local bIsLock = isGenuineLockItem(b.name)
            if aIsLock and not bIsLock then return true end
            if not aIsLock and bIsLock then return false end
            return a.name:lower() < b.name:lower()
        end)
    else
        table.sort(items, function(a, b)
            return a.originalIndex < b.originalIndex
        end)
    end

    local count = 0
    for _, item in ipairs(items) do
        local match = true
        if itemSearchQuery and itemSearchQuery ~= "" then
            match = item.name:lower():find(itemSearchQuery, 1, true) ~= nil
        end
        if match then
            createItemRow(item.id, item.name, item.amount)
            count = count + 1
        end
    end

    if count == 0 then
        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Name = "EmptyLabel"
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.ZIndex = 16
        emptyLbl.Size = UDim2.new(1, 0, 0, 32)
        emptyLbl.Font = Enum.Font.Gotham
        emptyLbl.Text = (itemSearchQuery ~= "") and "No items matched your search query." or "Your inventory is currently empty."
        emptyLbl.TextColor3 = Color3.fromRGB(165, 165, 165)
        emptyLbl.TextSize = 12
        emptyLbl.Parent = itemListContainer
    end
end

onInventoryChangedCallback = refreshInventoryUI

-- TAB: HOST (Drop Commands & Auto Gems Counter)
local HostTab = MainTabSection:CreateTab({
    Name = "",
    Icon = NebulaIcons:GetIcon("casino", "Material"),
    Columns = 1,
}, "HostTab")

local HostBox = HostTab:CreateGroupbox({
    Name = "Host",
    Column = 1,
}, "HostBox")

HostBox:CreateToggle({
    Name = "Drop Commands (/dsl, /dwl, /ddl)",
    CurrentValue = true,
    Callback = function(val)
        hostDropCommandsEnabled = val
    end
}, "ToggleHostDropCommands")

HostBox:CreateToggle({
    Name = "Auto Chat Gems Count",
    CurrentValue = false,
    Callback = function(val)
        hostGemsCountEnabled = val
    end
}, "ToggleHostGemsCount")

HostBox:CreateToggle({
    Name = "Click Character to Pull (/pull)",
    CurrentValue = false,
    Callback = function(val)
        hostClickPullEnabled = val
    end
}, "ToggleHostClickPull")

HostBox:CreateSlider({
    Name = "Gems Delay (Debounce Seconds)",
    Min = 0.1,
    Max = 1.0,
    CurrentValue = 0.35,
    Step = 0.05,
    Callback = function(val)
        hostGemsDebounceDelay = tonumber(val) or 0.35
    end
}, "SliderHostGemsDebounce")

-- Host Tab Category: Tax Calculator
local TaxBox = HostTab:CreateGroupbox({
    Name = "Tax Calculator",
    Column = 1,
}, "TaxBox")

local LblTaxPot = nil
local LblTaxAmount = nil
local LblTaxPayout = nil
local LblTaxWlOption = nil

local function calculateTaxPayout()
    local bet = math.max(1, tonumber(hostTaxBet) or 10)
    local totalPot = bet * 2
    local rate = math.max(1, tonumber(hostTaxRateLock) or 70)
    local pct = math.clamp(tonumber(hostTaxPercent) or 10, 0, 100)
    local taxRate = pct / 100

    local potText = ""
    local taxText = ""
    local payoutText = ""
    local wlOptionText = ""
    local chatMsg = ""
    local wlDrop = 0
    local slDrop = 0

    if hostTaxUnit == "SL" then
        local intPot = math.round(totalPot)
        local rawTax = intPot * taxRate
        local taxSL = math.round(rawTax)
        local cleanSL = intPot - taxSL

        potText = string.format("Total Pot (2P): %d SL", intPot)
        taxText = string.format("Host Tax (%d%%): %d SL", pct, taxSL)

        local payoutClean = ""
        if cleanSL >= rate then
            local wl = math.floor(cleanSL / rate)
            local remSL = cleanSL % rate
            wlDrop = wl
            slDrop = remSL
            if remSL > 0 then
                payoutClean = string.format("%d SL (%d WL + %d SL)", cleanSL, wl, remSL)
            else
                payoutClean = string.format("%d SL (%d WL)", cleanSL, wl)
            end
        else
            wlDrop = 0
            slDrop = cleanSL
            payoutClean = string.format("%d SL", cleanSL)
        end
        payoutText = string.format("Net Payout: %s", payoutClean)
        wlOptionText = "WL Option: (Only active in WL mode)"
        chatMsg = string.format("Bet: %d SL (Pot: %d SL) | Tax (%d%%): %d SL | Winner: %s", bet, intPot, pct, taxSL, payoutClean)
    else
        local potInSL = math.round(totalPot * rate)
        local rawTax = potInSL * taxRate
        local taxInSL = math.round(rawTax)
        local netSL = potInSL - taxInSL

        local netWL = math.floor(netSL / rate)
        local remSL = netSL % rate
        wlDrop = netWL
        slDrop = remSL

        potText = string.format("Total Pot (2P): %d WL (%d SL)", totalPot, potInSL)
        taxText = string.format("Host Tax (%d%%): %d SL", pct, taxInSL)

        local cleanDisplay = ""
        if netWL > 0 and remSL > 0 then
            cleanDisplay = string.format("%d WL + %d SL", netWL, remSL)
        elseif netWL > 0 then
            cleanDisplay = string.format("%d WL", netWL)
        else
            cleanDisplay = string.format("%d SL", remSL)
        end
        payoutText = string.format("Net Payout: %s", cleanDisplay)
        wlOptionText = string.format("Option 2: Host gives %d WL • Winner pays %d SL", totalPot, taxInSL)

        chatMsg = string.format("Bet: %d WL (Pot: %d WL) | Tax (%d%%): %d SL | Payout: %s OR (Host gives %d WL, Winner pays %d SL)", bet, totalPot, pct, taxInSL, cleanDisplay, totalPot, taxInSL)
    end

    return {
        pot = potText,
        tax = taxText,
        payout = payoutText,
        wlOption = wlOptionText,
        chat = chatMsg,
        wlDrop = wlDrop,
        slDrop = slDrop
    }
end

local function dropPayoutLocks()
    local data = calculateTaxPayout()
    local wlDrop = data.wlDrop or 0
    local slDrop = data.slDrop or 0

    if wlDrop <= 0 and slDrop <= 0 then
        Starlight:Notification({
            Title = "Cannot Drop",
            Icon = NebulaIcons:GetIcon("warning", "Material"),
            Content = "Net payout amount is 0!"
        }, "NotiTaxDropZero")
        return
    end

    local myWL = getInventoryItemCount(242)
    local mySL = getInventoryItemCount(202)

    if wlDrop > 0 and myWL < wlDrop then
        Starlight:Notification({
            Title = "Insufficient WL",
            Icon = NebulaIcons:GetIcon("warning", "Material"),
            Content = string.format("Need %d WL, but you only have %d WL!", wlDrop, myWL)
        }, "NotiTaxDropNoWL")
        return
    end

    if slDrop > 0 and mySL < slDrop then
        Starlight:Notification({
            Title = "Insufficient SL",
            Icon = NebulaIcons:GetIcon("warning", "Material"),
            Content = string.format("Need %d SL, but you only have %d SL!", slDrop, mySL)
        }, "NotiTaxDropNoSL")
        return
    end

    task.spawn(function()
        local droppedItems = {}
        if wlDrop > 0 then
            executeDrop(242, wlDrop, "World Lock")
            table.insert(droppedItems, string.format("%d WL", wlDrop))
            if slDrop > 0 then task.wait(0.25) end
        end
        if slDrop > 0 then
            executeDrop(202, slDrop, "Small Lock")
            table.insert(droppedItems, string.format("%d SL", slDrop))
        end

        Starlight:Notification({
            Title = "Payout Dropped",
            Icon = NebulaIcons:GetIcon("check_circle_outline", "Material"),
            Content = "Dropped " .. table.concat(droppedItems, " + ")
        }, "NotiTaxDropped")

        task.wait(0.3)
        if refreshInventoryUI then pcall(refreshInventoryUI) end
    end)
end

local function attachInlineDropButton()
    if not LblTaxPayout or not LblTaxPayout.Instance then return end
    local target = LblTaxPayout.Instance:FindFirstChild("ElementContainer") or LblTaxPayout.Instance
    local oldBtn = target:FindFirstChild("BtnInlineDrop") or LblTaxPayout.Instance:FindFirstChild("BtnInlineDrop")
    if oldBtn then return end

    local btn = Instance.new("TextButton")
    btn.Name = "BtnInlineDrop"
    btn.BackgroundColor3 = Color3.fromRGB(28, 31, 38)
    btn.BorderSizePixel = 0
    btn.ZIndex = 25
    btn.Size = UDim2.new(0, 94, 0, 24)
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.Position = UDim2.new(1, -2, 0.5, 0)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "Drop Payout"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(75, 82, 98)
    border.Thickness = 1
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(42, 46, 56)}):Play()
        TweenService:Create(border, TweenInfo.new(0.15), {Color = Color3.fromRGB(130, 140, 165)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 31, 38)}):Play()
        TweenService:Create(border, TweenInfo.new(0.15), {Color = Color3.fromRGB(75, 82, 98)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        dropPayoutLocks()
    end)

    btn.Parent = target
end

local function refreshTaxUI()
    local data = calculateTaxPayout()
    if LblTaxPot then pcall(function() LblTaxPot:Set({ Name = data.pot }) end) end
    if LblTaxAmount then pcall(function() LblTaxAmount:Set({ Name = data.tax }) end) end
    if LblTaxPayout then
        pcall(function()
            LblTaxPayout:Set({ Name = data.payout })
            attachInlineDropButton()
        end)
    end
    if LblTaxWlOption then pcall(function() LblTaxWlOption:Set({ Name = data.wlOption }) end) end
end

TaxBox:CreateLabel({
    Name = "Unit Mode",
}, "LblTaxUnit"):AddDropdown({
    Options = {"SL", "WL"},
    CurrentOption = {"SL"},
    MultipleOptions = false,
    Callback = function(Option)
        local val = type(Option) == "table" and Option[1] or Option
        hostTaxUnit = val or "SL"
        refreshTaxUI()
    end
}, "DrpTaxUnit")

TaxBox:CreateInput({
    Name = "Bet Per Player",
    PlaceholderText = "Default: 10",
    CurrentValue = "10",
    Numeric = true,
    Enter = false,
    Callback = function(txt)
        local n = tonumber(txt)
        if n and n > 0 then
            hostTaxBet = n
            refreshTaxUI()
        end
    end
}, "InputTaxBet")

TaxBox:CreateInput({
    Name = "Rate Lock (1 WL = ? SL)",
    PlaceholderText = "Default: 70",
    CurrentValue = "70",
    Numeric = true,
    Enter = false,
    Callback = function(txt)
        local n = tonumber(txt)
        if n and n > 0 then
            hostTaxRateLock = math.round(n)
            refreshTaxUI()
        end
    end
}, "InputTaxRateLock")

TaxBox:CreateInput({
    Name = "Host Tax (%)",
    PlaceholderText = "Default: 10",
    CurrentValue = "10",
    Numeric = true,
    Enter = false,
    Callback = function(txt)
        local n = tonumber(txt)
        if n and n >= 0 then
            hostTaxPercent = n
            refreshTaxUI()
        end
    end
}, "InputTaxPercent")

TaxBox:CreateDivider()

LblTaxPot = TaxBox:CreateLabel({
    Name = "Total Pot (2P): 20 SL",
}, "LblTaxPot")

LblTaxAmount = TaxBox:CreateLabel({
    Name = "Host Tax (10%): 2 SL",
}, "LblTaxAmount")

LblTaxPayout = TaxBox:CreateLabel({
    Name = "Net Payout: 18 SL",
}, "LblTaxPayout")

task.spawn(function()
    task.wait(0.2)
    attachInlineDropButton()
end)

LblTaxWlOption = TaxBox:CreateLabel({
    Name = "WL Option: (Only active in WL mode)",
}, "LblTaxWlOption")

TaxBox:CreateDivider()

TaxBox:CreateButton({
    Name = "💬 Send Payout to Chat",
    Icon = NebulaIcons:GetIcon("chat", "Material"),
    Callback = function()
        local data = calculateTaxPayout()
        sendPublicChat(data.chat)
        Starlight:Notification({
            Title = "Payout Sent",
            Icon = NebulaIcons:GetIcon("chat", "Material"),
            Content = "Payout format sent to chat!"
        }, "NotiTaxChatSent")
    end
}, "BtnSendTaxChat")

-- TAB 3: CHAT SPAM (Uncapped Custom Delay Input & Staff Safe Protection)
local SpamTab = MainTabSection:CreateTab({
    Name = "",
    Icon = NebulaIcons:GetIcon("chat", "Material"),
    Columns = 1,
}, "SpamTab")

local SpamBox = SpamTab:CreateGroupbox({
    Name = "Chat Spam",
    Column = 1,
}, "SpamBox")

SpamBox:CreateLabel({
    Name = "Spam Mode",
}, "LblSpamMode"):AddDropdown({
    Options = {"Private PM /msg", "Public Broadcast"},
    CurrentOption = {"Private PM /msg"},
    MultipleOptions = false,
    Callback = function(Option)
        local val = type(Option) == "table" and Option[1] or Option
        spamMode = (val and val:find("PM")) and "PM" or "Broadcast"
    end
}, "DrpSpamMode")

SpamBox:CreateInput({
    Name = "Target Player IGN",
    PlaceholderText = "Leave blank for all players...",
    CurrentValue = "",
    Numeric = false,
    Enter = false,
    Callback = function(txt)
        pmTarget = txt
    end
}, "InputPmTarget")

SpamBox:CreateInput({
    Name = "Message Payload",
    PlaceholderText = "Type message here...",
    CurrentValue = "Hello, buy cane here!",
    Numeric = false,
    Enter = false,
    Callback = function(txt)
        pmText = txt
        broadcastText = txt
    end
}, "InputMsgPayload")

SpamBox:CreateInput({
    Name = "Spam Delay (Seconds - Any Value)",
    PlaceholderText = "Default 1.0 (e.g. 0.2, 1.5, 10, 60)",
    CurrentValue = "1.0",
    Numeric = false,
    Enter = false,
    Callback = function(txt)
        local val = tonumber(txt)
        if val and val > 0 then
            spamDelay = val
        end
    end
}, "InputSpamDelay")

SpamBox:CreateToggle({
    Name = "Staff Safe Protection",
    CurrentValue = true,
    Callback = function(val)
        staffProtection = val
    end
}, "ToggleStaffProtect")

SpamBox:CreateToggle({
    Name = "Anti-Censor Color Codes",
    CurrentValue = true,
    Callback = function(val)
        autoColorVariation = val
    end
}, "ToggleAntiCensor")

SpamBox:CreateToggle({
    Name = "Start Automated Spam",
    CurrentValue = false,
    Callback = function(val)
        isSpamming = val
        if isSpamming then
            task.spawn(function()
                while isSpamming and _G.ZuhnHubToken == loopToken do
                    local delayTime = math.max(0.5, spamDelay)
                    if spamMode == "Broadcast" then
                        sendBroadcast(broadcastText)
                        task.wait(delayTime)
                    else
                        if pmTarget and pmTarget ~= "" then
                            local targetUid = nil
                            if othersActiveTable then
                                for _, p in pairs(othersActiveTable) do
                                    if type(p) == "table" and p.name and p.name:lower() == pmTarget:lower() then
                                        targetUid = p.userId
                                        break
                                    end
                                end
                            end
                            local isExempt = staffProtection and targetUid and isPlayerExempt(targetUid)
                            if not isExempt then
                                sendPrivateMessage(pmTarget, pmText)
                            end
                            task.wait(delayTime)
                        elseif othersActiveTable then
                            local sentCount = 0
                            for _, v in pairs(othersActiveTable) do
                                if not isSpamming or _G.ZuhnHubToken ~= loopToken then break end
                                if type(v) == "table" and rawget(v, "userId") and rawget(v, "name") then
                                    local isExempt = (staffProtection and isPlayerExempt(v.userId)) or (v.userId == LocalPlayer.UserId)
                                    if not isExempt then
                                        sentCount = sentCount + 1
                                        sendPrivateMessage(v.name, pmText)
                                        task.wait(delayTime)
                                    end
                                end
                            end
                            if sentCount == 0 then
                                task.wait(1.0)
                            end
                        else
                            task.wait(1.0)
                        end
                    end
                end
                isSpamming = false
            end)
        end
    end
}, "ToggleSpamActive")

-- TAB 4: SETTINGS & CONFIGS
local SettingsTab = MainTabSection:CreateTab({
    Name = "",
    Icon = NebulaIcons:GetIcon("settings", "Material"),
    Columns = 1,
}, "SettingsTab")

local HubPrefBox = SettingsTab:CreateGroupbox({
    Name = "Settings",
    Column = 1,
}, "HubPrefBox")

HubPrefBox:CreateSlider({
    Name = "Sound Effects Volume",
    Range = {0, 100},
    Increment = 5,
    CurrentValue = 65,
    Callback = function(val)
        soundVolume = val / 100
    end
}, "SliderVolume")

HubPrefBox:CreateButton({
    Name = "Unload Zuhn Hub",
    Icon = NebulaIcons:GetIcon("power_settings_new", "Material"),
    Callback = function()
        _G.ZuhnHubToken = (_G.ZuhnHubToken or 0) + 1
        isSpamming = false
        hostClickPullEnabled = false
        applyInstantBreak(false)
        applyLongArm(false)
        applyNoclip(false)
        pcall(function() Starlight:Destroy() end)
    end
}, "BtnUnload")

SettingsTab:BuildThemeGroupbox(1)

-- ==============================================================
-- UI STYLING & USER LOGO / AVATAR INJECTION
-- ==============================================================
task.spawn(function()
    for _ = 1, 35 do
        task.wait(0.15)
        if Starlight and Starlight.Instance and Starlight.Instance:FindFirstChild("MainWindow") then
            local mainW = Starlight.Instance.MainWindow
            local sidebar = mainW:FindFirstChild("Sidebar")
            local content = mainW:FindFirstChild("Content")

            if sidebar and content then
                pcall(function()
                    local home = mainW:FindFirstChild("HomeTab", true)
                    if home then home:Destroy() end
                end)

                -- 1. Slim sidebar strip (50px)
                pcall(function()
                    sidebar.Size = UDim2.new(0, 50, 1, 0)
                    content.Position = UDim2.new(0, 50, 0, 0)
                    content.Size = UDim2.new(1, -50, 1, 0)
                end)

                -- 2. Custom User Logo replace in Top Left
                pcall(function()
                    if sidebar:FindFirstChild("Icon") then
                        local iconImg = sidebar.Icon
                        iconImg.Size = UDim2.new(0, 36, 0, 36)
                        iconImg.Position = UDim2.new(0.5, -18, 0, 7)
                        if userLogoAssetId ~= "" then
                            iconImg.Image = userLogoAssetId
                        end
                    end
                    if sidebar:FindFirstChild("Header") then
                        sidebar.Header.Visible = false
                    end
                end)

                -- 3. Topbar: Zuhn Hub (White Bold) + v1.6
                pcall(function()
                    local topbar = content:FindFirstChild("Topbar")
                    if topbar and topbar:FindFirstChild("Headers") then
                        local headers = topbar.Headers
                        local subH = headers:FindFirstChild("Subheader")
                        if subH then
                            subH.RichText = true
                            subH.Text = '<font color="#FFFFFF"><b>Zuhn Hub</b></font>  <font color="#A5A5A5">v1.6</font>'
                            pcall(function() subH.TextSize = 16 end)
                        end
                    end
                end)

                -- 4. Player Character Headshot in Bottom Left (Rapat di paling bawah)
                pcall(function()
                    if sidebar:FindFirstChild("Player") then
                        local playerFrame = sidebar.Player
                        playerFrame.Visible = true
                        playerFrame.Size = UDim2.new(0, 38, 0, 38)
                        playerFrame.AnchorPoint = Vector2.new(0.5, 1)
                        playerFrame.Position = UDim2.new(0.5, 0, 1, -2)

                        if playerFrame:FindFirstChild("Header") then playerFrame.Header.Visible = false end
                        if playerFrame:FindFirstChild("subheader") then playerFrame.subheader.Visible = false end

                        if playerFrame:FindFirstChild("PlayerIcon") then
                            local pIcon = playerFrame.PlayerIcon
                            pIcon.Position = UDim2.new(0, 0, 0, 0)
                            pIcon.Size = UDim2.new(1, 0, 1, 0)
                            pIcon.Image = Players:GetUserThumbnailAsync(
                                LocalPlayer.UserId,
                                Enum.ThumbnailType.HeadShot,
                                Enum.ThumbnailSize.Size48x48
                            )
                            local corner = pIcon:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
                            corner.CornerRadius = UDim.new(1, 0)
                            corner.Parent = pIcon
                        end
                    end
                end)

                -- 5. Clean navigation tab icons
                pcall(function()
                    local nav = sidebar:FindFirstChild("Navigation")
                    if nav then
                        nav.Position = UDim2.new(0, 0, 0, 52)
                        nav.Size = UDim2.new(1, 0, 1, -98)
                        for _, section in ipairs(nav:GetChildren()) do
                            if section:IsA("Frame") then
                                for _, btn in ipairs(section:GetChildren()) do
                                    if btn:IsA("Frame") and btn:FindFirstChild("Icon") then
                                        btn.Size = UDim2.new(1, -8, 0, 36)
                                        if btn:FindFirstChild("Header") then btn.Header.Visible = false end
                                        btn.Icon.Position = UDim2.new(0.5, -9, 0.5, -9)
                                        btn.Icon.Size = UDim2.new(0, 18, 0, 18)
                                    end
                                end
                            end
                        end
                    end
                end)

                if sidebar:FindFirstChild("Player") and sidebar:FindFirstChild("Navigation") then
                    break
                end
            end
        end
    end
end)

-- Initialize initial data
task.spawn(function()
    task.wait(0.5)
    pcall(refreshPlayersUI)
    pcall(refreshInventoryUI)
end)

Starlight:LoadAutoloadConfig()

Starlight:Notification({
    Title = "Zuhn Hub",
    Icon = NebulaIcons:GetIcon("check_circle_outline", "Material"),
    Content = "Zuhn Hub loaded!"
}, "NotiLoaded")
