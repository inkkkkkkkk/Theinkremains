local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local Run     = game:GetService("RunService")
local VIM     = game:GetService("VirtualInputManager")

local Modules   = RS:WaitForChild("Modules")
local Note      = require(Modules.Note)
local Conductor = require(Modules.Conductor)
local Player    = Players.LocalPlayer
local gh        = require(Player.PlayerGui:WaitForChild("GameUI").GameHandler)

local prev = shared.__AutoPlay
if prev then
    pcall(function() prev:releaseAll() end)
    pcall(function() prev.conn:Disconnect() end)
end

local AP = {
    enabled = true, offset = 0, presses = 0, skipped = 0,
    groups = {}, down = {}, releaseAt = {}, conn = nil,
    debug = true, frameBurst = 0, lastBurstWarn = 0,
}
shared.__AutoPlay = AP

local store = shared.__AutoPlayNotes or {}
shared.__AutoPlayNotes = store

local DEFAULT_KEYS = {
    Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.F,
    Enum.KeyCode.G, Enum.KeyCode.H, Enum.KeyCode.J, Enum.KeyCode.K,
    Enum.KeyCode.L,
}

local function sf(n, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local ok, v = pcall(function() return n[k] end)
        if ok and v ~= nil then return v end
    end
    return nil
end

local function getStrum(n)
    local v = sf(n, "StrumTime", "strumTime", "time", "Time", "hitTime", "HitTime", "timestamp")
    if type(v) == "number" then
        if v > 0 and v < 1000 then v = v * 1000 end
        return v
    end
    return nil
end

local function getMania(n)
    local v = sf(n, "Mania", "mania", "Mode", "mode", "Player", "player")
    if type(v) == "number" then return v end
    return 0
end

local function getLane(n)
    local v = sf(n, "NoteData", "noteData", "note", "Note", "lane", "Lane", "Column", "column", "index", "Index")
    if type(v) == "number" then return v + 1 end
    return nil
end

local function getMustPress(n)
    local v = sf(n, "MustPress", "mustPress", "AltAnim", "altAnim")
    if v == nil then return true end
    return v == true
end
local function getIsSusEnd(n)
    return sf(n, "IsSusEnd", "isSusEnd", "SustainEnd", "sustainEnd") == true
end
local function getIsSustain(n)
    return sf(n, "IsSustain", "isSustain", "IsHold", "isHold", "IsSustainNote", "isSustainNote") == true
end
local function getDead(n)
    return sf(n, "Destroyed", "destroyed") == true
        or sf(n, "GoodHit", "goodHit", "hit", "Hit", "WasHit", "wasHit", "NoteHit", "noteHit") == true
        or sf(n, "TooLate", "tooLate", "missed", "Missed") == true
        or sf(n, "Cleared", "cleared") == true
end

local function songPos()
    for _, k in ipairs({"SongPos", "songPos", "songPosition", "position", "Position"}) do
        local v = Conductor[k]
        if type(v) == "number" then return v end
    end
    return 0
end

local function insertNote(n)
    if type(n) ~= "table" or n.__apInStore then return end
    local st = getStrum(n)
    local l = getLane(n)
    if not st or not l then
        n.__apInStore = true
        AP.skipped = AP.skipped + 1
        return
    end
    n.__apInStore = true
    local m = getMania(n)
    local g = AP.groups[m]
    if not g then
        g = { lanes = {}, cursors = {}, dirty = {} }
        AP.groups[m] = g
        AP.down[m] = {}
        AP.releaseAt[m] = {}
    end
    local arr = g.lanes[l]
    if not arr then arr = {}; g.lanes[l] = arr end
    if #arr > 0 and st < (getStrum(arr[#arr]) or 0) then
        g.dirty[l] = true
    end
    arr[#arr + 1] = n
end

if not Note.__apWrapped then
    local rawNew = Note.new
    Note.new = function(...)
        local n = rawNew(...)
        if type(n) == "table" then
            if not n.__apInStore then
                store[#store + 1] = n
            end
            pcall(insertNote, n)
        end
        return n
    end
    Note.__apWrapped = true
end

local function harvest()
    local fields = {"notes", "Notes", "allNotes", "songNotes", "playerNotes", "noteList", "notesList"}
    local total = 0
    for _, k in ipairs(fields) do
        local v = gh[k]
        if type(v) == "table" then
            for _, n in ipairs(v) do
                if type(n) == "table" and not n.__apInStore and not getDead(n) then
                    local st = getStrum(n)
                    if st and st ~= 0 then
                        store[#store + 1] = n
                        pcall(insertNote, n)
                        total = total + 1
                    end
                end
            end
        end
    end
    if total > 0 then
        print("[AutoPlay] 回填", total, "个已存在音符")
    end
end
pcall(harvest)

local function isKeyboard(kc)
    if typeof(kc) ~= "EnumItem" then return false end
    local n = kc.Name
    return not (n:match("^Button") or n:match("^DPad") or n:match("^Thumbstick") or n == "Unknown")
end

local function laneKey(m, l)
    local kb = gh.settings and gh.settings.Keybinds
    if type(kb) == "table" then
        for _, idx in ipairs({m + 1, m}) do
            local s = kb[idx]
            if type(s) == "table" then
                local list = s[l] or s[l - 1]
                if type(list) == "table" then
                    for _, kc in ipairs(list) do
                        if isKeyboard(kc) then return kc end
                    end
                elseif typeof(list) == "EnumItem" and isKeyboard(list) then
                    return list
                end
            end
        end
    end
    return DEFAULT_KEYS[l]
end

local function sendKey(down, kc)
    if not kc then return end
    if not pcall(function() VIM:SendKeyEvent(down, kc, false, game) end) then
        if down then pcall(keypress, kc) else pcall(keyrelease, kc) end
    end
end

function AP:releaseAll()
    for m, lanes in pairs(AP.down) do
        for l, isDown in pairs(lanes) do
            if isDown then
                sendKey(false, laneKey(m, l))
                lanes[l] = false
            end
        end
    end
end

local function findEnd(arr, idx)
    local n = arr[idx]
    if n.__apEnd ~= nil then return n.__apEnd or nil end
    local head = getStrum(n)
    local sl = sf(n, "SustainLength", "sustainLength", "HoldTime", "holdTime", "length")
    if type(sl) == "number" and sl > 0 then
        n.__apEnd = head + sl
        return n.__apEnd
    end
    for j = idx + 1, #arr do
        local m = arr[j]
        local t = getStrum(m)
        if t and t > head then
            if getIsSusEnd(m) then
                n.__apEnd = t
                return t
            end
            if t > head + 30000 then break end
        end
    end
    n.__apEnd = false
    return nil
end

local function step(dt)
    for _, g in pairs(AP.groups) do
        for l in pairs(g.dirty) do
            local arr = g.lanes[l]
            if arr then
                table.sort(arr, function(a, b) return (getStrum(a) or 0) < (getStrum(b) or 0) end)
            end
            g.dirty[l] = nil
        end
    end

    local sp = songPos() + AP.offset
    if sp <= 0 then return end

    local ahead = sp + dt * 500
    local tol   = 1500
    local burst = 0

    for m, g in pairs(AP.groups) do
        local downTab = AP.down[m]
        local relTab  = AP.releaseAt[m]
        for l, arr in pairs(g.lanes) do
            if downTab[l] and sp >= (relTab[l] or 0) then
                sendKey(false, laneKey(m, l))
                downTab[l] = false
            end

            local i = g.cursors[l] or 1
            while arr[i] do
                local n = arr[i]
                local st = getStrum(n) or 0
                local drop = n.__apFired
                    or getDead(n)
                    or getIsSusEnd(n)
                    or not getMustPress(n)
                    or st < sp - tol
                if not drop then break end
                if not n.__apFired then n.__apFired = true end
                i = i + 1
            end
            g.cursors[l] = i

            local n = arr[i]
            if n and not downTab[l] and not n.__apFired and getMustPress(n) then
                local st = getStrum(n)
                if st and ahead >= st then
                    local kc = laneKey(m, l)
                    if kc then
                        n.__apFired = true
                        sendKey(true, kc)
                        downTab[l] = true
                        AP.presses = AP.presses + 1
                        burst = burst + 1
                        if getIsSustain(n) then
                            local e = findEnd(arr, i)
                            relTab[l] = (e and e + 20) or (st + 1500)
                        else
                            relTab[l] = sp + 22
                        end
                    end
                end
            end
        end
    end

    AP.frameBurst = burst
    if burst > 15 then
        local now = tick()
        if now - AP.lastBurstWarn > 2 then
            AP.lastBurstWarn = now
            warn(string.format("[AutoPlay] 单帧触发 %d 个音符，SongPos=%d，可能字段不匹配",
                burst, math.floor(sp)))
        end
    end
end

local prevGhost = gh.settings and gh.settings.GhostTapping
if gh.settings then gh.settings.GhostTapping = true end

function AP:Stop()
    AP.enabled = false
    if AP.conn then AP.conn:Disconnect(); AP.conn = nil end
    AP:releaseAll()
    if gh.settings and prevGhost ~= nil then
        gh.settings.GhostTapping = prevGhost
    end
    print("[AutoPlay] 已关闭")
end

AP.conn = Run.RenderStepped:Connect(function(dt)
    if not AP.enabled then return end
    local ok, err = pcall(step, dt)
    if not ok and AP.debug then warn("[AutoPlay] " .. tostring(err)) end
end)

function AP:Debug()
    print(string.format("[AutoPlay] store=%d 跳过=%d 已按=%d 帧内最近触发=%d SongPos=%d",
        #store, AP.skipped, AP.presses, AP.frameBurst, math.floor(songPos())))
    for m, g in pairs(AP.groups) do
        local lanes = {}
        for l, arr in pairs(g.lanes) do
            local fired, dead = 0, 0
            for _, n in ipairs(arr) do
                if n.__apFired then fired = fired + 1 end
                if getDead(n) then dead = dead + 1 end
            end
            lanes[#lanes + 1] = string.format("L%d=%d(fire%d,dead%d,key=%s)",
                l, #arr, fired, dead, tostring(laneKey(m, l)))
        end
        table.sort(lanes)
        print(string.format("  Mania %d: %s", m, table.concat(lanes, "  ")))
    end
    local shown = 0
    for _, n in ipairs(store) do
        shown = shown + 1
        local keys = {}
        for k in pairs(n) do
            if k ~= "__apInStore" and k ~= "__apFired" and k ~= "__apEnd" then
                keys[#keys + 1] = tostring(k)
            end
        end
        table.sort(keys)
        print(string.format("  音符%d: strum=%s lane=%s mania=%s fired=%s",
            shown,
            tostring(getStrum(n)), tostring(getLane(n)),
            tostring(getMania(n)), tostring(n.__apFired)))
        print("    字段: " .. table.concat(keys, ", "))
        if shown >= 5 then break end
    end
end

function AP:Harvest()
    harvest()
    AP:Debug()
end

print("[AutoPlay] 已启动 · 排查: shared.__AutoPlay:Debug()")
return AP