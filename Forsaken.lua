local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

print("[testbraken] Loading v9.1.1...")

-- Obsidian UI Library（DevSloPo 搬运版本）
local Obsidian = loadstring(game:HttpGet("https://raw.githubusercontent.com/DevSloPo/obsidian_UI/main/Library.lua"))()


local config = {
  AntiBlindness = false,
  AntiGlitch = false,
  AntiSubspaced = false,
  AntiNoliLaugh = false,
  MinionESP = false,
  ProjectileESP = false,
  AzureTrapESP = false,
  AutoBlock = false,
  AutoBlockButton = false,
  ABMode = "Guest1337",
  AimPunch = false,
  FOVValue = 120,
  LowGraphics = false,
  MaxZoom = false,
  FPSPing = false,
  NoclipCam = false,
  ForceChat = false,
  Disable007n7 = false,
  ShowPrivacy = false,
  AutoBlockCustom = false,
  CustomABMode = "Guest1337",
  FourthButtonTarget = "default",
  CustomDiamondLength = 8,
  CustomDiamondWidth = 4,
  CustomDiamondOffset = 3,
  CustomCircleRadius = 5,
  ShowDiamond = false,
  ShowCircle = false,
  ZoneHeight = 0.5,
}

local toggles, sliders = {}, {}
local inputs = {}
local playerDropdown = nil
local suppressCallbacks = false
local rememberedZones = {diamond = false, circle = false}
local configFolder = "TestHub"
local configName = "default"

local function getConfigPath()
  return configFolder .. "/" .. configName .. ".json"
end

local function saveConfig()
  if not (writefile and isfolder and makefolder) then
    return false
  end
  pcall(function()
    if not isfolder(configFolder) then
      makefolder(configFolder)
    end
  end)
  return pcall(function()
    writefile(getConfigPath(), HttpService:JSONEncode(config))
  end)
end

local function loadConfig()
  if not (isfile and readfile and isfile(getConfigPath())) then
    return nil
  end
  local ok, decoded = pcall(function()
    return HttpService:JSONDecode(readfile(getConfigPath()))
  end)
  if ok and type(decoded) == "table" then
    return decoded
  end
  return nil
end

local function deleteConfig()
  if not (isfile and delfile) then
    return false
  end
  if isfile(getConfigPath()) then
    pcall(function()
      delfile(getConfigPath())
    end)
    return true
  end
  return false
end

local antiBlindnessState = {running = false, conn = nil}

local function startAntiBlindness()
  if antiBlindnessState.running then return end
  antiBlindnessState.running = true
  for _, child in ipairs(Lighting:GetChildren()) do
    if child:IsA("BlurEffect") then
      pcall(function()
        child:Destroy()
      end)
    end
  end
  antiBlindnessState.conn = Lighting.ChildAdded:Connect(function(child)
    if not antiBlindnessState.running then return end
    if child:IsA("BlurEffect") then
      pcall(function()
        child:Destroy()
      end)
    end
  end)
end

local function stopAntiBlindness()
  antiBlindnessState.running = false
  if antiBlindnessState.conn then
    antiBlindnessState.conn:Disconnect()
    antiBlindnessState.conn = nil
  end
end

local antiGlitchState = {running = false, connections = {}}

local function startAntiGlitch()
  if antiGlitchState.running then return end
  antiGlitchState.running = true
  local glitchNames = {Glitched = true, Hallucination = true}

  local function isGlitchElement(instance)
    if not instance or not glitchNames[instance.Name] then
      return false
    end
    local mainUI = playerGui:FindFirstChild("MainUI")
    local temporaryUI = playerGui:FindFirstChild("TemporaryUI")
    if mainUI then
      local statusContainer = mainUI:FindFirstChild("StatusContainer")
      if statusContainer and instance:IsDescendantOf(statusContainer) then
        return true
      end
    end
    if temporaryUI and instance:IsDescendantOf(temporaryUI) then
      return true
    end
    return false
  end

  local function handleInstance(instance)
    if not instance or not instance.Parent then return end
    if isGlitchElement(instance) then
      pcall(function()
        instance:Destroy()
      end)
    elseif instance:IsA("Frame") then
      local temporaryUI = playerGui:FindFirstChild("TemporaryUI")
      if temporaryUI then
        local frame = temporaryUI:FindFirstChild("Frame")
        if frame and instance:IsDescendantOf(frame) then
          pcall(function()
            instance:Destroy()
          end)
        end
      end
    end
  end

  local function watchRoot(root)
    if not root then return end
    table.insert(antiGlitchState.connections, root.DescendantAdded:Connect(handleInstance))
    for _, descendant in ipairs(root:GetDescendants()) do
      handleInstance(descendant)
    end
  end

  watchRoot(playerGui)
end

local function stopAntiGlitch()
  antiGlitchState.running = false
  for _, connection in ipairs(antiGlitchState.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end
  antiGlitchState.connections = {}
end

local antiSubspacedState = {running = false, connections = {}}

local function startAntiSubspaced()
  if antiSubspacedState.running then return end
  antiSubspacedState.running = true
  local lightingEffectNames = {
    SubspaceVFXBlur = true,
    SubspaceVFXColorCorrection = true,
    HealthDesaturation = true,
  }
  local uiEffectNames = {Subspaced = true}

  local function isLightingEffect(instance)
    return lightingEffectNames[instance.Name] and instance:IsDescendantOf(Lighting)
  end

  local function isUiEffect(instance)
    if not uiEffectNames[instance.Name] then
      return false
    end
    local mainUI = playerGui:FindFirstChild("MainUI")
    local temporaryUI = playerGui:FindFirstChild("TemporaryUI")
    if mainUI then
      local statusContainer = mainUI:FindFirstChild("StatusContainer")
      if statusContainer and instance:IsDescendantOf(statusContainer) then
        return true
      end
    end
    if temporaryUI and instance:IsDescendantOf(temporaryUI) then
      return true
    end
    return false
  end

  local function handleInstance(instance)
    if not instance or not instance.Parent then return end
    if isLightingEffect(instance) or isUiEffect(instance) then
      pcall(function()
        instance:Destroy()
      end)
    end
  end

  local function watchRoot(root)
    if not root then return end
    table.insert(antiSubspacedState.connections, root.DescendantAdded:Connect(handleInstance))
    for _, descendant in ipairs(root:GetDescendants()) do
      handleInstance(descendant)
    end
  end

  watchRoot(Lighting)
  watchRoot(playerGui)
end

local function stopAntiSubspaced()
  antiSubspacedState.running = false
  for _, connection in ipairs(antiSubspacedState.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end
  antiSubspacedState.connections = {}
end

local antiNoliLaughState = {running = false, connections = {}}

local function startAntiNoliLaugh()
  if antiNoliLaughState.running then return end
  antiNoliLaughState.running = true

  local function isNoliLaugh(instance)
    if not instance or instance.Name ~= "noliLaugh" then
      return false
    end
    local camera = Workspace.CurrentCamera
    return camera and (instance:IsDescendantOf(camera) or instance:IsDescendantOf(Workspace))
  end

  local function handleInstance(instance)
    if not instance or not instance.Parent then return end
    if isNoliLaugh(instance) then
      pcall(function()
        instance:Destroy()
      end)
    end
  end

  local function watchRoot(root)
    if not root then return end
    table.insert(antiNoliLaughState.connections, root.DescendantAdded:Connect(handleInstance))
    for _, descendant in ipairs(root:GetDescendants()) do
      handleInstance(descendant)
    end
  end

  watchRoot(Workspace.CurrentCamera)
  table.insert(antiNoliLaughState.connections, Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    watchRoot(Workspace.CurrentCamera)
  end))
  local existingCamera = Workspace:FindFirstChild("Camera")
  if existingCamera then
    watchRoot(existingCamera)
  end
  table.insert(antiNoliLaughState.connections, Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Camera" then
      watchRoot(child)
    end
  end))
end

local function stopAntiNoliLaugh()
  antiNoliLaughState.running = false
  for _, connection in ipairs(antiNoliLaughState.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end
  antiNoliLaughState.connections = {}
end

local minionEspState = {running = false, connections = {}, folder = nil}
local characterOwnersWeak = setmetatable({}, {__mode = "k"})
local characterOwners = {}

local function trackPlayer(player)
  if player.Character then
    characterOwnersWeak[player.Character] = player
    characterOwners[player.Character] = player
  end
  player.CharacterAdded:Connect(function(character)
    characterOwnersWeak[character] = player
    characterOwners[character] = player
    task.wait(0.1)
    if minionEspState.folder then
      local existing = minionEspState.folder:FindFirstChild(character:GetDebugId())
      if existing then
        existing:Destroy()
      end
    end
  end)
end

for _, player in ipairs(Players:GetPlayers()) do
  trackPlayer(player)
end
Players.PlayerAdded:Connect(trackPlayer)
Players.PlayerRemoving:Connect(function(player)
  if player.Character then
    characterOwnersWeak[player.Character] = nil
    characterOwners[player.Character] = nil
  end
end)

local minionExcludedNames = {
  "primordial", "betrayed", "classic", "crew leader", "evil green skeleton",
  "soccer legend", "green guest", "toy", "16th night", "pride", "green envy",
  "darkness", "infernum", "monochrome", "illumina", "bluesteel", "everfrost",
  "fleskhjerta", "voidbound", "timeless", "toon", "xx4ce0fspadesxx", "ace",
  "milestone zero", "milestone i", "milestone ii", "milestone iii", "milestone iv",
  "milestone", "guardian", "hacklord", "erlking", "crazyblox", "martyr",
  "eye of the abyss", "savior", "scarletkidd", "guide shedletsky", "shedletsky",
  "jack frost", "eggs", "champion", "big 1x1x1x1", "big 1x1",
}

local function startMinionEsp()
  if minionEspState.running then return end
  minionEspState.running = true

  local highlightFolder = Instance.new("Folder")
  highlightFolder.Name = "MinionESP_Highlights"
  highlightFolder.Parent = CoreGui
  minionEspState.folder = highlightFolder

  local keywordNames = {
    "killer", "kidd", "1x1x1x1", "c00lkidd", "c00lkid", "jane", "doe", "jane_doe",
    "janedoe", "lobby", "ambient", "decor", "prop", "dummy", "statue", "mannequin",
    "display", "preview", "shop", "corpse", "dead", "ragdoll", "body", "bone", "npc",
    "character",
  }
  local ambientAncestorNames = {
    "lobby", "menu", "npc", "ambient", "decor", "characters", "preview", "display",
    "shop", "spawn_area",
  }
  local minionAncestorNames = {"minion", "enem", "summon", "spawned", "mob", "rotten"}

  local function nameMatchesList(name, list)
    local lowered = string.lower(name)
    for _, keyword in ipairs(list) do
      if string.find(lowered, keyword, 1, true) then
        return true
      end
    end
    return false
  end

  local function isExcludedName(name)
    local lowered = string.lower(name)
    for _, excluded in ipairs(minionExcludedNames) do
      if lowered == excluded or string.find(lowered, excluded, 1, true) then
        return true
      end
    end
    return false
  end

  local function selfOrAncestorIsExcludedName(instance)
    local current, depth = instance, 0
    while current and depth < 5 do
      if isExcludedName(current.Name) then
        return true
      end
      current, depth = current.Parent, depth + 1
    end
    return false
  end

  local function selfOrAncestorHasKeyword(instance)
    local current, depth = instance, 0
    while current and depth < 5 do
      if nameMatchesList(current.Name, keywordNames) then
        return true
      end
      current, depth = current.Parent, depth + 1
    end
    return false
  end

  local function ancestorIsAmbient(instance)
    local current, depth = instance.Parent, 0
    while current and depth < 5 do
      if nameMatchesList(current.Name, ambientAncestorNames) then
        return true
      end
      current, depth = current.Parent, depth + 1
    end
    return false
  end

  local function ancestorIsMinionGroup(instance)
    local current, depth = instance.Parent, 0
    while current and depth < 5 do
      if nameMatchesList(current.Name, minionAncestorNames) then
        return true
      end
      current, depth = current.Parent, depth + 1
    end
    return false
  end

  local function isPlayerCharacter(model)
    if characterOwnersWeak[model] or characterOwners[model] then
      return true
    end
    local ok, owner = pcall(function()
      return Players:GetPlayerFromCharacter(model)
    end)
    if ok and owner then
      return true
    end
    for character in pairs(characterOwners) do
      if character and character.Parent then
        if model == character then
          return true
        end
        local okDescendant, isDescendant = pcall(function()
          return model:IsDescendantOf(character)
        end)
        if okDescendant and isDescendant then
          return true
        end
      else
        characterOwners[character] = nil
      end
    end
    local current, depth = model, 0
    while current and depth < 10 do
      if current:IsA("Player") then
        return true
      end
      current, depth = current.Parent, depth + 1
    end
    return false
  end

  local function isMinionModel(model)
    if not model:IsA("Model") then return false end
    if isPlayerCharacter(model) then return false end
    local hasExcludedName = selfOrAncestorIsExcludedName(model)
    if not hasExcludedName and selfOrAncestorHasKeyword(model) then return false end
    if ancestorIsAmbient(model) then return false end
    local inMinionGroup = ancestorIsMinionGroup(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
      return false
    end
    local rootPart = model:FindFirstChild("HumanoidRootPart")
      or model:FindFirstChild("Torso")
      or model:FindFirstChild("UpperTorso")
      or model:FindFirstChild("Head")
    if not rootPart then return false end
    local anchoredCount, partCount = 0, 0
    for _, child in ipairs(model:GetChildren()) do
      if child:IsA("BasePart") then
        partCount = partCount + 1
        if child.Anchored then
          anchoredCount = anchoredCount + 1
        end
      end
    end
    if partCount > 0 and anchoredCount == partCount then return false end
    if not inMinionGroup and not hasExcludedName and rootPart.Anchored then return false end
    return true
  end

  local function createMinionHighlight(model)
    if not model or not model:IsA("Model") or isPlayerCharacter(model) then return end
    local key = model:GetDebugId()
    if highlightFolder:FindFirstChild(key) then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = key
    highlight.Adornee = model
    highlight.FillTransparency = 0.5
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = highlightFolder
    model.Destroying:Connect(function()
      if highlight then
        highlight:Destroy()
      end
    end)
    task.delay(0.3, function()
      if highlight and highlight.Parent and isPlayerCharacter(model) then
        highlight:Destroy()
      end
    end)
  end

  local function considerInstance(instance)
    if minionEspState.running and isMinionModel(instance) then
      createMinionHighlight(instance)
    end
  end

  for _, descendant in ipairs(Workspace:GetDescendants()) do
    considerInstance(descendant)
  end
  table.insert(minionEspState.connections, Workspace.DescendantAdded:Connect(function(descendant)
    task.wait(0.1)
    considerInstance(descendant)
  end))
end

local function stopMinionEsp()
  minionEspState.running = false
  for _, connection in ipairs(minionEspState.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end
  minionEspState.connections = {}
  if minionEspState.folder then
    pcall(function()
      minionEspState.folder:Destroy()
    end)
    minionEspState.folder = nil
  end
end

local projectileEspState = {running = false, connections = {}, folder = nil}

local function startProjectileEsp()
  if projectileEspState.running then return end
  projectileEspState.running = true

  local highlightFolder = Instance.new("Folder")
  highlightFolder.Name = "ProjectileESP_Highlights"
  highlightFolder.Parent = Workspace
  projectileEspState.folder = highlightFolder

  local projectileColor = Color3.fromRGB(255, 50, 50)
  local projectileNames = {HumanoidRootProjectile = true}
  local ignoredAncestorNames = {"lobby", "spawn", "menu", "waitingroom", "decor", "ambient"}
  local trackedParts = setmetatable({}, {__mode = "k"})
  local highlightsByPart = setmetatable({}, {__mode = "k"})

  local function belongsToCharacter(instance)
    for _, player in ipairs(Players:GetPlayers()) do
      local character = player.Character
      if character and instance:IsDescendantOf(character) then
        return true
      end
    end
    local model = instance:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
      return true
    end
    return false
  end

  local function isInIgnoredArea(instance)
    local current = instance.Parent
    while current and current ~= Workspace do
      local lowered = current.Name:lower()
      for _, ignored in ipairs(ignoredAncestorNames) do
        if lowered:find(ignored) then
          return true
        end
      end
      current = current.Parent
    end
    return false
  end

  local function addHighlight(part)
    if not projectileEspState.running or not part or not part.Parent or trackedParts[part] then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ProjESPHL"
    highlight.Adornee = part
    highlight.FillColor = projectileColor
    highlight.FillTransparency = 0.35
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = highlightFolder
    trackedParts[part] = true
    highlightsByPart[part] = highlight
    part.AncestryChanged:Connect(function(_, newParent)
      if not newParent then
        trackedParts[part] = nil
        if highlight and highlight.Parent then
          highlight:Destroy()
        end
        highlightsByPart[part] = nil
      end
    end)
  end

  local function considerInstance(instance)
    if not projectileEspState.running or not instance or not instance.Parent
      or belongsToCharacter(instance) or isInIgnoredArea(instance) then
      return
    end
    if projectileNames[instance.Name] and instance:IsA("BasePart") then
      local fullName = instance:GetFullName()
      if fullName:find("Map.Ingame", 1, true) then
        addHighlight(instance)
      end
    end
  end

  table.insert(projectileEspState.connections, Workspace.DescendantAdded:Connect(function(descendant)
    if not projectileEspState.running then return end
    if descendant:IsA("BasePart") or descendant:IsA("Model") then
      considerInstance(descendant)
    end
  end))

  task.spawn(function()
    local processed = 0
    for _, descendant in ipairs(Workspace:GetDescendants()) do
      if not projectileEspState.running then break end
      if descendant:IsA("BasePart") or descendant:IsA("Model") then
        considerInstance(descendant)
        processed = processed + 1
        if processed % 250 == 0 then
          task.wait()
        end
      end
    end
  end)
end

local function stopProjectileEsp()
  projectileEspState.running = false
  for _, connection in ipairs(projectileEspState.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end
  projectileEspState.connections = {}
  if projectileEspState.folder then
    pcall(function()
      projectileEspState.folder:Destroy()
    end)
    projectileEspState.folder = nil
  end
end

local azureTrapEspState = {running = false, connections = {}, folder = nil}

local function startAzureTrapEsp()
  if azureTrapEspState.running then return end
  azureTrapEspState.running = true

  local highlightFolder = Instance.new("Folder")
  highlightFolder.Name = "AzureTrapESP_Folder"
  highlightFolder.Parent = Workspace
  azureTrapEspState.folder = highlightFolder

  local trapColor = Color3.fromRGB(160, 32, 240)
  local maxSameNameCount, recentWindowSeconds, pollInterval = 6, 5, 0.3

  local trapPartNames = {
    Flower_Base = true,
    Flower_Bottom = true,
    Flower_Root = true,
    Flower_Tentacle = true,
    Flower_Top = true,
    Nectar = true,
    Root1 = true,
    Root2 = true,
    Root3 = true,
    Root4 = true,
    Tendril_Middle = true,
    Tentacle = true,
    ["Tentacle42.001"] = true,
    Tentacle_Base = true,
    GroundBulb = true,
    Vine = true,
  }
  local ignoredAncestorNames = {"lobby", "spawn", "menu", "waitingroom", "decor", "ambient"}

  local highlightByPart, highlightedParts, recentParts = {}, {}, {}
  local nameCounts, floodedNames, countedParts = {}, {}, {}

  local function belongsToCharacter(instance)
    for _, player in ipairs(Players:GetPlayers()) do
      local character = player.Character
      if character and instance:IsDescendantOf(character) then
        return true
      end
    end
    local model = instance:FindFirstAncestorOfClass("Model")
    return model and model:FindFirstChildOfClass("Humanoid")
  end

  local function isInIgnoredArea(instance)
    local current = instance.Parent
    while current and current ~= Workspace do
      local lowered = current.Name:lower()
      for _, ignored in ipairs(ignoredAncestorNames) do
        if lowered:find(ignored) then
          return true
        end
      end
      current = current.Parent
    end
    return false
  end

  local function isTargetPart(part)
    return trapPartNames[part.Name] and not floodedNames[part.Name]
  end

  local function removeHighlightsByName(name)
    for part, highlight in pairs(highlightByPart) do
      if part.Name == name then
        if highlight and highlight.Parent then
          highlight:Destroy()
        end
        highlightByPart[part] = nil
        highlightedParts[part] = nil
      end
    end
  end

  local function countPart(part)
    if countedParts[part] or not trapPartNames[part.Name] then return end
    countedParts[part] = true
    nameCounts[part.Name] = (nameCounts[part.Name] or 0) + 1
    if nameCounts[part.Name] > maxSameNameCount and not floodedNames[part.Name] then
      floodedNames[part.Name] = true
      removeHighlightsByName(part.Name)
    end
  end

  local function uncountPart(part)
    if not countedParts[part] then return end
    countedParts[part] = nil
    local name = part.Name
    if not nameCounts[name] then return end
    nameCounts[name] = math.max(0, nameCounts[name] - 1)
    if nameCounts[name] <= maxSameNameCount and floodedNames[name] then
      floodedNames[name] = nil
    end
  end

  local function cleanupPart(part)
    uncountPart(part)
    highlightedParts[part] = nil
    recentParts[part] = nil
    if highlightByPart[part] then
      if highlightByPart[part].Parent then
        highlightByPart[part]:Destroy()
      end
      highlightByPart[part] = nil
    end
  end

  local function createHighlight(part)
    if highlightedParts[part] then return end
    if highlightByPart[part] then
      highlightedParts[part] = true
      return
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "AzureTrapHL"
    highlight.Adornee = part
    highlight.FillColor = trapColor
    highlight.FillTransparency = 0.75
    highlight.OutlineColor = trapColor
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = highlightFolder
    highlightByPart[part] = highlight
    highlightedParts[part] = true
  end

  local function considerPart(part)
    if not azureTrapEspState.running or not part:IsA("BasePart") then return end
    if highlightedParts[part] or belongsToCharacter(part) or isInIgnoredArea(part) then return end
    if not isTargetPart(part) then return end
    if not part:GetAttribute("AzureESP_Hooked") then
      part:SetAttribute("AzureESP_Hooked", true)
      part.AncestryChanged:Connect(function(_, newParent)
        if not newParent then
          cleanupPart(part)
        end
      end)
    end
    createHighlight(part)
  end

  for _, descendant in ipairs(Workspace:GetDescendants()) do
    if descendant:IsA("BasePart") and trapPartNames[descendant.Name] then
      countedParts[descendant] = true
      nameCounts[descendant.Name] = (nameCounts[descendant.Name] or 0) + 1
    end
  end
  for name, count in pairs(nameCounts) do
    if count > maxSameNameCount then
      floodedNames[name] = true
    end
  end
  for _, descendant in ipairs(Workspace:GetDescendants()) do
    if descendant:IsA("BasePart") then
      considerPart(descendant)
    end
  end

  table.insert(azureTrapEspState.connections, Workspace.DescendantAdded:Connect(function(descendant)
    if not descendant:IsA("BasePart") then return end
    countPart(descendant)
    recentParts[descendant] = tick()
    considerPart(descendant)
  end))

  task.spawn(function()
    while azureTrapEspState.running do
      task.wait(pollInterval)
      local now = tick()
      for part, addedAt in pairs(recentParts) do
        if not part.Parent then
          recentParts[part] = nil
        elseif now - addedAt > recentWindowSeconds then
          recentParts[part] = nil
        elseif not highlightedParts[part] then
          considerPart(part)
        end
      end
    end
  end)
end

local function stopAzureTrapEsp()
  azureTrapEspState.running = false
  for _, connection in ipairs(azureTrapEspState.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end
  azureTrapEspState.connections = {}
  if azureTrapEspState.folder then
    pcall(function()
      azureTrapEspState.folder:Destroy()
    end)
    azureTrapEspState.folder = nil
  end
end

local forceChatState = {running = false}

local function startForceChat()
  if forceChatState.running then return end
  forceChatState.running = true
  task.spawn(function()
    while forceChatState.running do
      task.wait(0.5)
      pcall(function()
        local chatWindow = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
        if chatWindow then
          chatWindow.Enabled = true
        end
      end)
    end
  end)
end

local function stopForceChat()
  forceChatState.running = false
end

local disableCloneState = {running = false, moved = {}}

local function startDisableClone()
  if disableCloneState.running then return end
  disableCloneState.running = true
  disableCloneState.moved = {}
  task.spawn(function()
    while disableCloneState.running do
      task.wait(0.5)
      local ingame = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame")
      if ingame then
        for _, child in ipairs(ingame:GetChildren()) do
          if child.Name:lower() == "007n7" and not Players:GetPlayerFromCharacter(child) then
            local originalParent = child.Parent
            if pcall(function()
              child.Parent = Lighting
            end) then
              disableCloneState.moved[child] = originalParent
            end
          end
        end
      end
    end
  end)
end

local function stopDisableClone()
  disableCloneState.running = false
  for instance, originalParent in pairs(disableCloneState.moved) do
    if instance and instance.Parent == Lighting and originalParent and originalParent.Parent then
      pcall(function()
        instance.Parent = originalParent
      end)
    end
  end
  table.clear(disableCloneState.moved)
end

local showPrivacyState = {running = false}

local function startShowPrivacy()
  if showPrivacyState.running then return end
  showPrivacyState.running = true
  task.spawn(function()
    while showPrivacyState.running do
      task.wait(0.5)
      for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
          local playerData = player:FindFirstChild("PlayerData")
          local privacyFolder = playerData and playerData:FindFirstChild("Privacy", true)
          if privacyFolder then
            for _, setting in ipairs(privacyFolder:GetChildren()) do
              if setting:IsA("BoolValue") then
                pcall(function()
                  setting.Value = false
                end)
              end
            end
          end
        end
      end
    end
  end)
end

local function stopShowPrivacy()
  showPrivacyState.running = false
end

local autoBlockState = {
  running = false,
  connections = {},
  attrStates = {},
  attrDebounce = 0,
  blueDebounce = 0,
  punchDebounce = 0,
  generation = 0,
  RemoteEvent = nil,
  KillersFolder = nil,
  LocalRoot = nil,
}

local startAutoBlock, stopAutoBlock

local fourthButtonState = {
  instance = nil,
  applyTint = nil,
  running = false,
  connections = {},
  cachedPos = nil,
  cachedSize = nil,
  sourceName = nil,
}

local lastToggleTime = 0
local pendingToggle = nil
local pendingToggleTask = nil
local toggleDebounce = 0.08

do
  local modules = ReplicatedStorage:FindFirstChild("Modules")
  local outerNetwork = modules and modules:FindFirstChild("Network", true)
  local innerNetwork = outerNetwork and outerNetwork:FindFirstChild("Network", true)
  autoBlockState.RemoteEvent = innerNetwork and innerNetwork:FindFirstChild("RemoteEvent")
  if not autoBlockState.RemoteEvent then
    autoBlockState.RemoteEvent = ReplicatedStorage:FindFirstChild("RemoteEvent", true)
  end
end

local function getPingSeconds()
  local ping = 0.05
  pcall(function()
    local network = Stats:FindFirstChild("Network")
    local serverStatsItem = network and network:FindFirstChild("ServerStatsItem")
    local dataPing = serverStatsItem and serverStatsItem:FindFirstChild("Data Ping")
    if dataPing then
      ping = dataPing:GetValue() / 1000
    end
  end)
  return math.clamp(ping, 0.05, 0.35)
end

local blockSoundIdList = {
  "102228729296384", "140242176732868", "112809109188560", "136323728355613",
  "115026634746636", "84116622032112", "108907358619313", "127793641088496",
  "86174610237192", "95079963655241", "101199185291628", "119942598489800",
  "84307400688050", "113037804008732", "105200830849301", "75330693422988",
  "82221759983649", "81702359653578", "108610718831698", "112395455254818",
  "109431876587852", "109348678063422", "85853080745515", "98733709078792",
  "105840448036441", "114742322778642", "119583605486352", "79980897195554",
  "71805956520207", "79391273191671", "89004992452376", "101553872555606",
  "101698569375359", "105415540898010", "106300477136129", "80516583309685",
  "116581754553533", "117231507259853", "119089145505438", "71834552297085",
  "117173212095661", "104910828105172", "140412278320643", "85544168523099",
  "114506382930939", "116527305931161", "131406927389838", "94317217837143",
  "121954639447247", "125213046326879", "128856426573270", "128195973631079",
  "124903763333174", "98111231282218", "136728245733659", "131123355704017",
  "107444859834748", "76959687420003", "72425554233832", "96594507550917",
  "139996647355899", "107345261604889", "127557531826290", "108651070773439",
  "74842815979546", "124397369810639", "76467993976301", "118493324723683",
  "78298577002481", "5148302439", "98675142200448", "128367348686124",
  "103684883268194", "109246041199659", "80540530406270", "139523195429581",
  "105204810054381", "116468089135195", "133709029886490", "124234993291213",
  "99856718263455", "74809026448465", "86833981571073", "110372418055226",
  "86494585504534", "99829427721752", "120059928759346", "104625283622511",
  "105316545074913", "126131675979001", "82336352305186", "93366464803829",
  "84069821282466",
}

local blockSoundIds = {}
for _, soundId in ipairs(blockSoundIdList) do
  blockSoundIds["rbxassetid://" .. soundId] = true
  blockSoundIds[soundId] = true
end

local punchSoundIdList = {
  "132298811847315", "81114852524420", "123825742002486", "116616310968045",
  "102808968188291", "117828699507982", "125854302746190", "18568553101",
  "95135835034592", "135209101640984", "91165993312513", "82772022662025",
}

local punchSoundIds = {}
for _, soundId in ipairs(punchSoundIdList) do
  punchSoundIds["rbxassetid://" .. soundId] = true
end

local function isPunchSound(soundId)
  if not soundId or soundId == "" then return false end
  if punchSoundIds[soundId] then return true end
  local numericId = soundId:match("rbxassetid://(%d+)") or soundId:match("^(%d+)$")
  return numericId and punchSoundIds["rbxassetid://" .. numericId] or false
end

local function fireAbility(abilityName)
  if autoBlockState.RemoteEvent then
    pcall(function()
      autoBlockState.RemoteEvent:FireServer("UseActorAbility", {abilityName})
    end)
  end
end

local function fireBlock()
  fireAbility("Block")
end

local function fireClone()
  fireAbility("Clone")
end

local function getActiveBlockMode()
  if config.AutoBlockCustom then
    return config.CustomABMode
  end
  return config.ABMode
end

local function performBlock()
  if getActiveBlockMode() == "007n7" then
    fireClone()
  else
    fireBlock()
  end
end

local function getNearestKiller()
  local killersFolder = autoBlockState.KillersFolder
  if not killersFolder or not killersFolder.Parent then
    local playersFolder = Workspace:FindFirstChild("Players")
    killersFolder = playersFolder and playersFolder:FindFirstChild("Killers")
  end
  local localRoot = autoBlockState.LocalRoot
  if not localRoot or not localRoot.Parent then
    local character = localPlayer.Character
    localRoot = character and character:FindFirstChild("HumanoidRootPart")
  end
  if not killersFolder or not localRoot then
    return nil, nil
  end
  local nearestRoot, nearestModel, nearestDistance = nil, nil, 30
  for _, killer in pairs(killersFolder:GetChildren()) do
    local killerRoot = killer:FindFirstChild("HumanoidRootPart")
    if killerRoot then
      local distance = (localRoot.Position - killerRoot.Position).Magnitude
      if distance < nearestDistance then
        nearestDistance = distance
        nearestRoot = killerRoot
        nearestModel = killer
      end
    end
  end
  return nearestRoot, nearestModel
end

local function aimAtKiller()
  local killerRoot, killerModel = getNearestKiller()
  if not (killerRoot and autoBlockState.LocalRoot and killerModel) then return end
  local killerHumanoid = killerModel:FindFirstChildOfClass("Humanoid")
  local startTime = tick()
  local lastKillerPosition = killerRoot.Position
  local connection
  connection = RunService.RenderStepped:Connect(function(deltaTime)
    if not autoBlockState.running or tick() - startTime > 0.6 or not autoBlockState.LocalRoot or not killerRoot then
      connection:Disconnect()
      return
    end
    local myPosition = autoBlockState.LocalRoot.Position
    local killerPosition = killerRoot.Position
    local velocity = (killerPosition - lastKillerPosition) / math.max(deltaTime, 0.001)
    lastKillerPosition = killerPosition
    local moveDirection = killerHumanoid and killerHumanoid.MoveDirection or Vector3.new()
    local walkSpeed = killerHumanoid and killerHumanoid.WalkSpeed or 16
    local leadTime = 0.24 + getPingSeconds()
    local predictedPosition = killerPosition
      + moveDirection * walkSpeed * leadTime
      + Vector3.new(velocity.X, 0, velocity.Z) * 0.08
    autoBlockState.LocalRoot.CFrame = CFrame.lookAt(
      myPosition,
      Vector3.new(predictedPosition.X, myPosition.Y, predictedPosition.Z)
    )
  end)
end

local function aimAndPunch()
  if not autoBlockState.running or not config.AimPunch then return end
  if getActiveBlockMode() == "007n7" then return end
  local now = tick()
  if now - autoBlockState.punchDebounce < 0.2 then return end
  autoBlockState.punchDebounce = now
  task.spawn(function()
    aimAtKiller()
    fireAbility("Punch")
  end)
end

local function watchPunchSounds(character)
  if not character then return end
  local function checkSound(instance)
    if instance:IsA("Sound") and isPunchSound(instance.SoundId) then
      aimAndPunch()
    end
  end
  for _, descendant in pairs(character:GetDescendants()) do
    checkSound(descendant)
  end
  table.insert(autoBlockState.connections, character.DescendantAdded:Connect(checkSound))
end

local customZoneState = {running = false, connections = {}, folder = nil, killerZones = {}}
local zonePadding = 1.5

local function getZoneCFrame(killerRoot)
  local raycastParams = RaycastParams.new()
  raycastParams.FilterType = Enum.RaycastFilterType.Exclude
  raycastParams.FilterDescendantsInstances = {killerRoot.Parent, localPlayer.Character}
  raycastParams.IgnoreWater = true
  local result = Workspace:Raycast(killerRoot.Position, Vector3.new(0, -30, 0), raycastParams)
  local groundY = result and (killerRoot.Position.Y - result.Distance) or (killerRoot.Position.Y - 3)
  return CFrame.new(killerRoot.Position.X, groundY + (config.ZoneHeight or 0.5), killerRoot.Position.Z)
    * killerRoot.CFrame.Rotation
end

local function createZoneVisuals(killer)
  local zoneModel = Instance.new("Model")
  zoneModel.Name = "ABCustomZone_" .. killer.Name
  zoneModel.Parent = customZoneState.folder
  local edges = {}
  for index = 1, 4 do
    local edge = Instance.new("Part")
    edge.Name = "Edge" .. index
    edge.Anchored = true
    edge.CanCollide = false
    edge.CanQuery = false
    edge.CanTouch = false
    edge.CastShadow = false
    edge.Material = Enum.Material.Neon
    edge.Color = Color3.fromRGB(255, 0, 0)
    edge.Transparency = 0.3
    edge.Size = Vector3.new(0.35, 0.08, 1)
    edge.CFrame = CFrame.new(0, -5000, 0)
    edge.Parent = zoneModel
    edges[index] = edge
  end
  local circle = Instance.new("Part")
  circle.Shape = Enum.PartType.Cylinder
  circle.Name = "Circle"
  circle.Anchored = true
  circle.CanCollide = false
  circle.CanQuery = false
  circle.CanTouch = false
  circle.CastShadow = false
  circle.Material = Enum.Material.Neon
  circle.Color = Color3.fromRGB(255, 0, 0)
  circle.Transparency = 0.65
  circle.Size = Vector3.new(0.08, 10, 10)
  circle.CFrame = CFrame.new(0, -5000, 0)
  circle.Parent = zoneModel
  return {model = zoneModel, edges = edges, circle = circle, killer = killer}
end

local function isInsideDiamond(position, killerCFrame, killerPosition)
  if not config.ShowDiamond then return false end
  local lookVector = killerCFrame.LookVector
  local rightVector = killerCFrame.RightVector
  local forward = Vector3.new(lookVector.X, 0, lookVector.Z)
  local right = Vector3.new(rightVector.X, 0, rightVector.Z)
  if forward.Magnitude < 0.01 or right.Magnitude < 0.01 then return false end
  forward = forward.Unit
  right = right.Unit
  local offset = Vector3.new(position.X - killerPosition.X, 0, position.Z - killerPosition.Z)
  local forwardDistance = offset:Dot(forward)
  local rightDistance = offset:Dot(right)
  local diamondCenter = config.CustomDiamondOffset + config.CustomDiamondLength / 2
  local forwardFromCenter = forwardDistance - diamondCenter
  local halfWidth = config.CustomDiamondWidth / 2 + zonePadding
  local halfLength = config.CustomDiamondLength / 2 + zonePadding
  return math.abs(rightDistance) / halfWidth + math.abs(forwardFromCenter) / halfLength <= 1
end

local function isInsideCircle(position, center)
  if not config.ShowCircle then return false end
  local dx = position.X - center.X
  local dz = position.Z - center.Z
  local radius = config.CustomCircleRadius + zonePadding
  return dx * dx + dz * dz <= radius * radius
end

local function isLocalPlayerInZone(killer)
  if not killer or not killer.Parent then return false end
  local killerRoot = killer:FindFirstChild("HumanoidRootPart")
  local character = localPlayer.Character
  local localRoot = character and character:FindFirstChild("HumanoidRootPart")
  if not killerRoot or not localRoot then return false end
  return isInsideDiamond(localRoot.Position, killerRoot.CFrame, killerRoot.Position)
    or isInsideCircle(localRoot.Position, killerRoot.Position)
end

local function updateZoneVisuals(visuals, killerRoot, localRoot)
  if not visuals or not visuals.model or not visuals.model.Parent then return end
  if not killerRoot or not killerRoot.Parent then return end
  local zoneCFrame = getZoneCFrame(killerRoot)
  local faceOffset = config.CustomDiamondOffset
  local diamondLength = config.CustomDiamondLength
  local diamondWidth = config.CustomDiamondWidth
  local nearPoint = zoneCFrame:PointToWorldSpace(Vector3.new(0, 0, -faceOffset))
  local farPoint = zoneCFrame:PointToWorldSpace(Vector3.new(0, 0, -(faceOffset + diamondLength)))
  local leftPoint = zoneCFrame:PointToWorldSpace(Vector3.new(-diamondWidth / 2, 0, -(faceOffset + diamondLength / 2)))
  local rightPoint = zoneCFrame:PointToWorldSpace(Vector3.new(diamondWidth / 2, 0, -(faceOffset + diamondLength / 2)))
  local segments = {
    {nearPoint, leftPoint},
    {nearPoint, rightPoint},
    {farPoint, leftPoint},
    {farPoint, rightPoint},
  }
  for index, segment in ipairs(segments) do
    local startPoint, endPoint = segment[1], segment[2]
    local midpoint = (startPoint + endPoint) / 2
    local delta = endPoint - startPoint
    local length = delta.Magnitude
    if length > 0.01 then
      local direction = delta.Unit
      local edge = visuals.edges[index]
      if edge then
        edge.Size = Vector3.new(0.35, 0.08, length)
        edge.CFrame = CFrame.lookAt(midpoint, midpoint + direction)
        edge.Transparency = config.ShowDiamond and 0.3 or 1
      end
    end
  end
  if visuals.circle then
    local circleCenter = Vector3.new(zoneCFrame.Position.X, zoneCFrame.Position.Y + 0.04, zoneCFrame.Position.Z)
    visuals.circle.Size = Vector3.new(0.08, config.CustomCircleRadius * 2, config.CustomCircleRadius * 2)
    visuals.circle.CFrame = CFrame.new(circleCenter) * CFrame.Angles(0, 0, math.rad(90))
    visuals.circle.Transparency = config.ShowCircle and 0.65 or 1
  end
  local insideDiamond = localRoot and isInsideDiamond(localRoot.Position, killerRoot.CFrame, killerRoot.Position) or false
  local insideCircle = localRoot and isInsideCircle(localRoot.Position, killerRoot.Position) or false
  local diamondColor = insideDiamond and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
  local circleColor = insideCircle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
  for _, edge in ipairs(visuals.edges) do
    if edge and edge.Parent then
      edge.Color = diamondColor
    end
  end
  if visuals.circle and visuals.circle.Parent then
    visuals.circle.Color = circleColor
  end
end

local function startCustomZones()
  if customZoneState.running then return end
  customZoneState.running = true
  customZoneState.connections = {}
  customZoneState.killerZones = {}
  customZoneState.folder = Instance.new("Folder")
  customZoneState.folder.Name = "ABCustomZoneVisuals"
  customZoneState.folder.Parent = Workspace
  table.insert(customZoneState.connections, RunService.RenderStepped:Connect(function()
    if not customZoneState.running then return end
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return end
    local character = localPlayer.Character
    local localRoot = character and character:FindFirstChild("HumanoidRootPart")
    for _, killer in ipairs(killersFolder:GetChildren()) do
      if killer:IsA("Model") then
        local killerRoot = killer:FindFirstChild("HumanoidRootPart")
        if killerRoot then
          local visuals = customZoneState.killerZones[killer]
          if not visuals or not visuals.model or not visuals.model.Parent then
            if visuals and visuals.model then
              pcall(function()
                visuals.model:Destroy()
              end)
            end
            visuals = createZoneVisuals(killer)
            customZoneState.killerZones[killer] = visuals
          end
          updateZoneVisuals(visuals, killerRoot, localRoot)
        end
      end
    end
    for killer, visuals in pairs(customZoneState.killerZones) do
      if not killer.Parent or not killer:IsDescendantOf(Workspace) then
        if visuals.model then
          pcall(function()
            visuals.model:Destroy()
          end)
        end
        customZoneState.killerZones[killer] = nil
      end
    end
  end))
  print("[testbraken] Custom Zone ON")
end

local function stopCustomZones()
  if not customZoneState.running then return end
  customZoneState.running = false
  for _, connection in ipairs(customZoneState.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end
  customZoneState.connections = {}
  for _, visuals in pairs(customZoneState.killerZones) do
    if visuals.model then
      pcall(function()
        visuals.model:Destroy()
      end)
    end
  end
  customZoneState.killerZones = {}
  if customZoneState.folder then
    pcall(function()
      customZoneState.folder:Destroy()
    end)
    customZoneState.folder = nil
  end
  print("[testbraken] Custom Zone OFF")
end

local function refreshCustomZones()
  local wanted = config.ShowDiamond or config.ShowCircle
  if wanted and not customZoneState.running then
    startCustomZones()
  elseif not wanted and customZoneState.running then
    stopCustomZones()
  end
end

local function enforceBlockModeExclusivity()
  if config.AutoBlock and config.AutoBlockCustom then
    config.AutoBlockCustom = false
    if toggles.AutoBlockCustom then
      suppressCallbacks = true
      pcall(function()
        toggles.AutoBlockCustom:Set(false)
      end)
      suppressCallbacks = false
    end
  end
  if config.AutoBlock then
    if config.ShowDiamond then
      rememberedZones.diamond = true
      config.ShowDiamond = false
    end
    if config.ShowCircle then
      rememberedZones.circle = true
      config.ShowCircle = false
    end
    if toggles.ShowDiamond then
      suppressCallbacks = true
      pcall(function()
        toggles.ShowDiamond:Set(false)
      end)
      suppressCallbacks = false
    end
    if toggles.ShowCircle then
      suppressCallbacks = true
      pcall(function()
        toggles.ShowCircle:Set(false)
      end)
      suppressCallbacks = false
    end
  end
  refreshCustomZones()
end

local function watchKillerSounds(killer)
  if not killer then return end

  local function checkSound(sound)
    if not autoBlockState.running then return end
    if not (config.AutoBlock or config.AutoBlockCustom) then return end
    if not sound or not sound:IsA("Sound") then return end
    local soundId = sound.SoundId
    if soundId == "" then return end
    local numericId = soundId:match("rbxassetid://(%d+)") or soundId:match("://(%d+)") or soundId:match("^(%d+)$")
    local isBlockSound = blockSoundIds[soundId]
      or (numericId and (blockSoundIds["rbxassetid://" .. numericId] or blockSoundIds[numericId]))
    if not isBlockSound then return end
    if not autoBlockState.LocalRoot then return end
    local killerRoot = killer:FindFirstChild("HumanoidRootPart")
    if not killerRoot or not killerRoot.Parent then return end
    if config.AutoBlockCustom then
      if not isLocalPlayerInZone(killer) then return end
    else
      local offset = autoBlockState.LocalRoot.Position - killerRoot.Position
      local distance = offset.Magnitude
      if distance > 15 then return end
      if distance > 0 and killerRoot.CFrame.LookVector:Dot(offset.Unit) < 0.3 then return end
    end
    local now = tick()
    if now - autoBlockState.blueDebounce < 0.15 then return end
    autoBlockState.blueDebounce = now
    performBlock()
  end

  for _, descendant in ipairs(killer:GetDescendants()) do
    if descendant:IsA("Sound") then
      checkSound(descendant)
    end
  end
  table.insert(autoBlockState.connections, killer.DescendantAdded:Connect(checkSound))
end

local function checkKillerAbilities()
  if not autoBlockState.running or not (config.AutoBlock or config.AutoBlockCustom) then return end
  if not autoBlockState.KillersFolder or not autoBlockState.LocalRoot or not autoBlockState.LocalRoot.Parent then return end
  for _, killer in ipairs(autoBlockState.KillersFolder:GetChildren()) do
    if killer:IsA("Model") then
      local killerRoot = killer:FindFirstChild("HumanoidRootPart")
      if killerRoot then
        local abilityLastUsed = killer:GetAttribute("AbilityLastUsed") or 0
        local abilitiesUsed = killer:GetAttribute("AbilitiesUsed") or 0
        local previous = autoBlockState.attrStates[killer]
        if previous then
          local abilityChanged = abilityLastUsed > previous.lastAbility
          if abilitiesUsed > previous.lastUsed then
            previous.isBait = true
          end
          if abilityChanged then
            if previous.isBait then
              previous.isBait = false
            else
              local shouldBlock = false
              if config.AutoBlockCustom then
                if isLocalPlayerInZone(killer) then
                  shouldBlock = true
                end
              else
                local offset = autoBlockState.LocalRoot.Position - killerRoot.Position
                local distance = offset.Magnitude
                if distance <= 15 and distance > 0 and killerRoot.CFrame.LookVector:Dot(offset.Unit) >= 0.3 then
                  shouldBlock = true
                end
              end
              if shouldBlock then
                local now = tick()
                if now - autoBlockState.attrDebounce >= 0.15 then
                  autoBlockState.attrDebounce = now
                  performBlock()
                end
              end
            end
          end
          previous.lastAbility = abilityLastUsed
          previous.lastUsed = abilitiesUsed
        else
          autoBlockState.attrStates[killer] = {
            lastAbility = abilityLastUsed,
            lastUsed = abilitiesUsed,
            isBait = false,
          }
        end
      end
    end
  end
end

local function applyBlockToggle(request)
  if not request then return end
  if request.mode == "default" then
    config.AutoBlock = request.value
    if request.value then
      config.AutoBlockCustom = false
      if config.ShowDiamond then
        rememberedZones.diamond = true
        config.ShowDiamond = false
        if toggles.ShowDiamond then
          suppressCallbacks = true
          pcall(function()
            toggles.ShowDiamond:Set(false)
          end)
          suppressCallbacks = false
        end
      end
      if config.ShowCircle then
        rememberedZones.circle = true
        config.ShowCircle = false
        if toggles.ShowCircle then
          suppressCallbacks = true
          pcall(function()
            toggles.ShowCircle:Set(false)
          end)
          suppressCallbacks = false
        end
      end
      refreshCustomZones()
    end
  else
    config.AutoBlockCustom = request.value
    if request.value then
      config.AutoBlock = false
      if rememberedZones.diamond then
        config.ShowDiamond = true
        if toggles.ShowDiamond then
          suppressCallbacks = true
          pcall(function()
            toggles.ShowDiamond:Set(true)
          end)
          suppressCallbacks = false
        end
      end
      if rememberedZones.circle then
        config.ShowCircle = true
        if toggles.ShowCircle then
          suppressCallbacks = true
          pcall(function()
            toggles.ShowCircle:Set(true)
          end)
          suppressCallbacks = false
        end
      end
      rememberedZones.diamond = false
      rememberedZones.circle = false
      refreshCustomZones()
    end
  end
  if toggles.AutoBlock then
    suppressCallbacks = true
    pcall(function()
      toggles.AutoBlock:Set(config.AutoBlock)
    end)
    suppressCallbacks = false
  end
  if toggles.AutoBlockCustom then
    suppressCallbacks = true
    pcall(function()
      toggles.AutoBlockCustom:Set(config.AutoBlockCustom)
    end)
    suppressCallbacks = false
  end
  if config.AutoBlock or config.AutoBlockCustom then
    if not autoBlockState.running then
      pcall(startAutoBlock)
    end
  else
    if autoBlockState.running then
      pcall(stopAutoBlock)
    end
  end
  if fourthButtonState.applyTint then
    pcall(fourthButtonState.applyTint)
  end
end

local function schedulePendingToggle()
  if pendingToggleTask then
    pcall(task.cancel, pendingToggleTask)
    pendingToggleTask = nil
  end
  pendingToggleTask = task.delay(toggleDebounce, function()
    pendingToggleTask = nil
    local request = pendingToggle
    pendingToggle = nil
    if request ~= nil then
      lastToggleTime = tick()
      applyBlockToggle(request)
    end
  end)
end

local function requestBlockToggle(value, mode)
  if value == nil then return end
  mode = mode or (config.AutoBlockCustom and "custom" or "default")
  pendingToggle = {value = value, mode = mode}
  local now = tick()
  if lastToggleTime > 0 and now - lastToggleTime < toggleDebounce then
    schedulePendingToggle()
    return
  end
  if pendingToggleTask then
    pcall(task.cancel, pendingToggleTask)
    pendingToggleTask = nil
  end
  lastToggleTime = now
  local request = pendingToggle
  pendingToggle = nil
  applyBlockToggle(request)
end

local function startFourthButton()
  if fourthButtonState.running then return end
  fourthButtonState.running = true
  fourthButtonState.connections = {}

  do
    local mainUI = playerGui:FindFirstChild("MainUI")
    if mainUI then
      local abilityContainer = mainUI:FindFirstChild("AbilityContainer", true)
      if abilityContainer then
        local leftover = abilityContainer:FindFirstChild("FourthBlockAbility")
        if leftover then
          pcall(function()
            leftover:Destroy()
          end)
        end
      end
    end
  end

  if not fourthButtonState.applyTint then
    fourthButtonState.applyTint = function()
      local button = fourthButtonState.instance
      if not button or not button.Parent then return end
      local tint = (config.AutoBlock or config.AutoBlockCustom) and Color3.fromRGB(0, 255, 60) or Color3.fromRGB(255, 0, 0)
      if button:IsA("ImageButton") or button:IsA("ImageLabel") then
        button.ImageColor3 = tint
      end
      for _, descendant in ipairs(button:GetDescendants()) do
        if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
          descendant.ImageColor3 = tint
        elseif descendant:IsA("Frame") and descendant.BackgroundTransparency < 1 then
          descendant.BackgroundColor3 = tint
        end
      end
    end
  end

  local lastActivation = 0
  local activationCooldown = 0.15

  local function onFourthButtonActivated()
    local now = tick()
    if now - lastActivation < activationCooldown then return end
    lastActivation = now
    local target = config.FourthButtonTarget or "default"
    if target == "custom" then
      if config.AutoBlockCustom then
        requestBlockToggle(false, "custom")
      else
        requestBlockToggle(true, "custom")
      end
    else
      if config.AutoBlock then
        requestBlockToggle(false, "default")
      else
        requestBlockToggle(true, "default")
      end
    end
  end

  table.insert(fourthButtonState.connections, RunService.RenderStepped:Connect(function()
    if not fourthButtonState.running then return end
    local button = fourthButtonState.instance
    if button and button.Parent then
      local okPosition, position = pcall(function()
        return button.AbsolutePosition
      end)
      local okSize, size = pcall(function()
        return button.AbsoluteSize
      end)
      if okPosition and okSize then
        fourthButtonState.cachedPos = position
        fourthButtonState.cachedSize = size
      end
    else
      fourthButtonState.cachedPos = nil
      fourthButtonState.cachedSize = nil
    end
  end))

  local function isPointOverButton(point)
    local button = fourthButtonState.instance
    if not button or not button.Parent then return false end
    local ok, objects = pcall(function()
      return UserInputService:GetGuiObjectsAtPosition(point.X, point.Y)
    end)
    if ok and objects and #objects > 0 then
      local topObject = objects[1]
      return topObject == button or topObject:IsDescendantOf(button)
    end
    if not fourthButtonState.cachedPos or not fourthButtonState.cachedSize then return false end
    local position, size = fourthButtonState.cachedPos, fourthButtonState.cachedSize
    return point.X >= position.X and point.X <= position.X + size.X
      and point.Y >= position.Y and point.Y <= position.Y + size.Y
  end

  local pressPosition, pressTime = nil, 0

  table.insert(fourthButtonState.connections, UserInputService.InputBegan:Connect(function(input)
    if not fourthButtonState.running then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
      return
    end
    if not isPointOverButton(input.Position) then return end
    pressPosition = input.Position
    pressTime = tick()
  end))

  table.insert(fourthButtonState.connections, UserInputService.InputEnded:Connect(function(input)
    if not fourthButtonState.running then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
      return
    end
    if not pressPosition then return end
    local heldFor = tick() - pressTime
    pressPosition = nil
    if heldFor > 0.5 then return end
    if not isPointOverButton(input.Position) then return end
    onFourthButtonActivated()
  end))

  local function hookButtonInput(root)
    if not root then return end
    local function hookObject(object)
      if not object then return end
      if object:IsA("GuiButton") then
        pcall(function()
          object.Active = true
          object.Selectable = true
        end)
        pcall(function()
          object.MouseButton1Click:Connect(onFourthButtonActivated)
        end)
        pcall(function()
          object.Activated:Connect(onFourthButtonActivated)
        end)
      end
    end
    hookObject(root)
    for _, descendant in ipairs(root:GetDescendants()) do
      if descendant:IsA("GuiObject") then
        hookObject(descendant)
      end
    end
  end

  task.spawn(function()
    while fourthButtonState.running do
      task.wait(0.5)
      if not fourthButtonState.running then break end
      local mainUI = playerGui:FindFirstChild("MainUI")
      if mainUI then
        local abilityContainer = mainUI:FindFirstChild("AbilityContainer", true)
        if abilityContainer then
          local blockButton = abilityContainer:FindFirstChild("Block")
          local cloneButton = abilityContainer:FindFirstChild("Clone")
          local activeMode = getActiveBlockMode()
          local source = nil
          if blockButton and cloneButton then
            source = (activeMode == "007n7") and cloneButton or blockButton
          else
            source = blockButton or cloneButton
          end
          local existing = abilityContainer:FindFirstChild("FourthBlockAbility")
          local needsRebuild = false
          if not existing then
            needsRebuild = (source ~= nil)
          elseif not source then
            needsRebuild = false
          elseif fourthButtonState.sourceName ~= source.Name then
            needsRebuild = true
          elseif fourthButtonState.instance ~= existing then
            fourthButtonState.instance = existing
            hookButtonInput(existing)
            if fourthButtonState.applyTint then
              fourthButtonState.applyTint()
            end
          end
          if needsRebuild and source then
            if existing then
              pcall(function()
                existing:Destroy()
              end)
            end
            local copy = source:Clone()
            copy.Name = "FourthBlockAbility"
            copy.LayoutOrder = 4
            if copy:IsA("GuiObject") then
              copy.ZIndex = 50
            end
            for _, descendant in ipairs(copy:GetDescendants()) do
              if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                local loweredText = descendant.Text:lower()
                if loweredText:find("block") or loweredText:find("clone") then
                  descendant.Text = ""
                  descendant.Visible = false
                end
              end
              if descendant:IsA("GuiObject") then
                descendant.ZIndex = math.max(descendant.ZIndex, 50)
                descendant.Active = true
              end
            end
            copy.Parent = abilityContainer
            fourthButtonState.instance = copy
            fourthButtonState.sourceName = source.Name
            hookButtonInput(copy)
            if fourthButtonState.applyTint then
              fourthButtonState.applyTint()
            end
            print("[testbraken] ✅ 4th button created from:", source.Name)
          end
        end
      end
    end
  end)

  print("[testbraken] AutoBlockButton ON")
end

local function stopFourthButton()
  if not fourthButtonState.running then return end
  fourthButtonState.running = false
  for _, connection in ipairs(fourthButtonState.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end
  fourthButtonState.connections = {}
  if fourthButtonState.instance and fourthButtonState.instance.Parent then
    pcall(function()
      fourthButtonState.instance:Destroy()
    end)
  end
  fourthButtonState.instance = nil
  fourthButtonState.cachedPos = nil
  fourthButtonState.cachedSize = nil
  fourthButtonState.sourceName = nil
  print("[testbraken] AutoBlockButton OFF")
end

function startAutoBlock()
  if autoBlockState.running then return end
  autoBlockState.running = true
  autoBlockState.generation = autoBlockState.generation + 1
  local generation = autoBlockState.generation
  autoBlockState.attrStates = {}

  local character = localPlayer.Character
  if character then
    autoBlockState.LocalRoot = character:FindFirstChild("HumanoidRootPart")
    watchPunchSounds(character)
  end
  table.insert(autoBlockState.connections, localPlayer.CharacterAdded:Connect(function(newCharacter)
    autoBlockState.LocalRoot = newCharacter:WaitForChild("HumanoidRootPart", 5)
    watchPunchSounds(newCharacter)
  end))

  local function watchKiller(killer)
    if not killer or not killer:IsA("Model") then return end
    watchKillerSounds(killer)
  end

  local function attachToKillersFolder(folder)
    if not folder then return false end
    autoBlockState.KillersFolder = folder
    table.insert(autoBlockState.connections, folder.ChildAdded:Connect(function(child)
      if autoBlockState.running and autoBlockState.generation == generation then
        task.wait(0.1)
        watchKiller(child)
      end
    end))
    for _, child in ipairs(folder:GetChildren()) do
      watchKiller(child)
    end
    return true
  end

  local playersFolder = Workspace:FindFirstChild("Players")
  local killersFolder = playersFolder and playersFolder:FindFirstChild("Killers")
  if not attachToKillersFolder(killersFolder) then
    task.spawn(function()
      local attempts = 0
      while autoBlockState.running and autoBlockState.generation == generation and attempts < 60 do
        attempts = attempts + 1
        task.wait(1)
        local retryPlayers = Workspace:FindFirstChild("Players")
        local retryKillers = retryPlayers and retryPlayers:FindFirstChild("Killers")
        if retryKillers and attachToKillersFolder(retryKillers) then
          break
        end
      end
    end)
  end

  table.insert(autoBlockState.connections, RunService.Heartbeat:Connect(function()
    if not autoBlockState.running or autoBlockState.generation ~= generation then return end
    checkKillerAbilities()
  end))

  if fourthButtonState.applyTint then
    fourthButtonState.applyTint()
  end
  print("[testbraken] AutoBlock ON")
end

function stopAutoBlock()
  autoBlockState.running = false
  autoBlockState.generation = autoBlockState.generation + 1
  autoBlockState.attrStates = {}
  for _, connection in ipairs(autoBlockState.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end
  autoBlockState.connections = {}
  print("[testbraken] AutoBlock OFF")
end

local minFov, maxFov = 30, 120
local lastFovChange = 0
local fovBindName = "TestHub_FOVForce"

local function applyFov()
  local camera = Workspace.CurrentCamera
  if camera and camera.FieldOfView ~= config.FOVValue then
    pcall(function()
      camera.FieldOfView = config.FOVValue
    end)
  end
end

pcall(function()
  RunService:UnbindFromRenderStep(fovBindName)
end)
pcall(function()
  RunService:BindToRenderStep(fovBindName, Enum.RenderPriority.Last.Value + 1, function()
    local camera = Workspace.CurrentCamera
    if camera and camera.FieldOfView ~= config.FOVValue then
      pcall(function()
        camera.FieldOfView = config.FOVValue
      end)
    end
  end)
end)

local fovConnection = nil

local function watchCameraFov(camera)
  if fovConnection then
    pcall(function()
      fovConnection:Disconnect()
    end)
    fovConnection = nil
  end
  if not camera then return end
  fovConnection = camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if camera.FieldOfView ~= config.FOVValue then
      pcall(function()
        camera.FieldOfView = config.FOVValue
      end)
    end
  end)
end

watchCameraFov(Workspace.CurrentCamera)
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
  watchCameraFov(Workspace.CurrentCamera)
end)

RunService.Stepped:Connect(function()
  local camera = Workspace.CurrentCamera
  if camera and camera.FieldOfView ~= config.FOVValue then
    pcall(function()
      camera.FieldOfView = config.FOVValue
    end)
  end
end)

RunService.Heartbeat:Connect(function()
  local camera = Workspace.CurrentCamera
  if camera and camera.FieldOfView ~= config.FOVValue then
    pcall(function()
      camera.FieldOfView = config.FOVValue
    end)
  end
end)

localPlayer.CharacterAdded:Connect(function()
  task.wait(0.1)
  applyFov()
  task.wait(0.4)
  applyFov()
  task.wait(0.6)
  applyFov()
end)

local function scheduleFovApply()
  lastFovChange = tick()
  task.delay(0.1, function()
    if tick() - lastFovChange >= 0.05 then
      applyFov()
    end
  end)
end

local lowGraphicsState = {
  enabled = false,
  saved = {},
  destroyed = {},
  lightSaved = {},
  terrainSaved = {},
  conn = nil,
}

local function saveProperty(instance, property)
  if not lowGraphicsState.saved[instance] then
    lowGraphicsState.saved[instance] = {}
  end
  if lowGraphicsState.saved[instance][property] == nil then
    local ok, value = pcall(function()
      return instance[property]
    end)
    if ok then
      lowGraphicsState.saved[instance][property] = value
    end
  end
end

local function saveDestroyed(instance)
  if lowGraphicsState.destroyed[instance] then return end
  local parent = instance.Parent
  if not parent then return end
  local ok, copy = pcall(function()
    return instance:Clone()
  end)
  if ok and copy then
    lowGraphicsState.destroyed[instance] = {Clone = copy, Parent = parent}
  end
end

local function stripInstance(instance)
  if not lowGraphicsState.enabled then return end
  if instance:IsA("BasePart") then
    for _, property in ipairs({
      "CastShadow", "Material", "Reflectance", "BackSurface", "BottomSurface",
      "FrontSurface", "LeftSurface", "RightSurface", "TopSurface",
    }) do
      saveProperty(instance, property)
    end
    instance.CastShadow = false
    instance.Material = Enum.Material.Plastic
    instance.Reflectance = 0
    instance.BackSurface = Enum.SurfaceType.SmoothNoOutlines
    instance.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
    instance.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
    instance.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
    instance.RightSurface = Enum.SurfaceType.SmoothNoOutlines
    instance.TopSurface = Enum.SurfaceType.SmoothNoOutlines
  elseif instance:IsA("Decal") then
    saveProperty(instance, "Transparency")
    saveProperty(instance, "Texture")
    instance.Transparency = 1
    instance.Texture = ""
  elseif instance:IsA("ParticleEmitter") or instance:IsA("Trail") then
    saveProperty(instance, "Lifetime")
    instance.Lifetime = NumberRange.new(0)
  elseif instance:IsA("ForceField") or instance:IsA("Sparkles") or instance:IsA("Smoke")
    or instance:IsA("Fire") or instance:IsA("Beam") then
    saveDestroyed(instance)
    instance:Destroy()
  end
end

local function startLowGraphics()
  if lowGraphicsState.enabled then return end
  lowGraphicsState.enabled = true
  local terrain = Workspace:FindFirstChildWhichIsA("Terrain")
  if terrain then
    lowGraphicsState.terrainSaved = {
      WaterWaveSize = terrain.WaterWaveSize,
      WaterWaveSpeed = terrain.WaterWaveSpeed,
      WaterReflectance = terrain.WaterReflectance,
      WaterTransparency = terrain.WaterTransparency,
    }
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 1
  end
  lowGraphicsState.lightSaved = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
  }
  Lighting.GlobalShadows = false
  Lighting.FogEnd = 9e9
  Lighting.FogStart = 9e9
  pcall(function()
    settings().Rendering.QualityLevel = 1
  end)
  for _, descendant in pairs(Workspace:GetDescendants()) do
    pcall(stripInstance, descendant)
  end
  for _, descendant in pairs(Lighting:GetDescendants()) do
    if descendant:IsA("PostEffect") then
      saveProperty(descendant, "Enabled")
      descendant.Enabled = false
    end
  end
  lowGraphicsState.conn = Workspace.DescendantAdded:Connect(function(descendant)
    if not lowGraphicsState.enabled then return end
    task.defer(function()
      pcall(stripInstance, descendant)
    end)
  end)
end

local function stopLowGraphics()
  if not lowGraphicsState.enabled then return end
  lowGraphicsState.enabled = false
  if lowGraphicsState.conn then
    lowGraphicsState.conn:Disconnect()
    lowGraphicsState.conn = nil
  end
  for instance, properties in pairs(lowGraphicsState.saved) do
    if instance and instance.Parent then
      for property, value in pairs(properties) do
        pcall(function()
          instance[property] = value
        end)
      end
    end
  end
  for _, entry in pairs(lowGraphicsState.destroyed) do
    if entry.Clone and entry.Parent and entry.Parent.Parent then
      pcall(function()
        entry.Clone.Parent = entry.Parent
      end)
    end
  end
  local terrain = Workspace:FindFirstChildWhichIsA("Terrain")
  if terrain then
    for property, value in pairs(lowGraphicsState.terrainSaved) do
      pcall(function()
        terrain[property] = value
      end)
    end
  end
  for property, value in pairs(lowGraphicsState.lightSaved) do
    pcall(function()
      Lighting[property] = value
    end)
  end
  table.clear(lowGraphicsState.saved)
  table.clear(lowGraphicsState.destroyed)
  table.clear(lowGraphicsState.terrainSaved)
  table.clear(lowGraphicsState.lightSaved)
end

local function enableMaxZoom()
  localPlayer.CameraMaxZoomDistance = 10000
end

local function disableMaxZoom()
  localPlayer.CameraMaxZoomDistance = 5
end

localPlayer.CameraMinZoomDistance = 0.5
localPlayer.CameraMaxZoomDistance = 5

local fpsMonitorState = {enabled = false, gui = nil, label = nil, conn = nil, frames = 0, elapsed = 0}

local function startFpsMonitor()
  if fpsMonitorState.enabled then return end
  fpsMonitorState.enabled = true
  if not fpsMonitorState.gui then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FPSPingMonitor"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999998
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    fpsMonitorState.gui = screenGui

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Position = UDim2.new(1, -2, 0, -1)
    frame.Size = UDim2.new(0, 112, 0, 22)
    frame.BackgroundColor3 = Color3.fromRGB(15, 30, 20)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -4, 1, 0)
    label.Position = UDim2.new(0, 2, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(80, 255, 130)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Text = "FPS: -- | PING: -- ms"
    label.Parent = frame
    fpsMonitorState.label = label
  end
  fpsMonitorState.gui.Enabled = true
  fpsMonitorState.frames = 0
  fpsMonitorState.elapsed = 0
  fpsMonitorState.conn = RunService.RenderStepped:Connect(function(deltaTime)
    if not fpsMonitorState.enabled then return end
    fpsMonitorState.frames = fpsMonitorState.frames + 1
    fpsMonitorState.elapsed = fpsMonitorState.elapsed + deltaTime
    if fpsMonitorState.elapsed >= 1 then
      local fps = math.floor(fpsMonitorState.frames / fpsMonitorState.elapsed + 0.5)
      fpsMonitorState.frames, fpsMonitorState.elapsed = 0, 0
      local pingText = "--"
      pcall(function()
        local network = Stats.Network
        local dataPing = network and network.ServerStatsItem and network.ServerStatsItem["Data Ping"]
        if dataPing then
          pingText = math.floor(dataPing:GetValue() + 0.5)
        end
      end)
      if fpsMonitorState.label then
        fpsMonitorState.label.Text = "FPS: " .. fps .. " | PING: " .. pingText .. " ms"
      end
    end
  end)
end

local function stopFpsMonitor()
  fpsMonitorState.enabled = false
  if fpsMonitorState.conn then
    fpsMonitorState.conn:Disconnect()
    fpsMonitorState.conn = nil
  end
  if fpsMonitorState.gui then
    fpsMonitorState.gui.Enabled = false
  end
end

local noclipCamState = {enabled = false, applied = false, orig = nil, mod = nil}

local function findPopperModule()
  local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
  if not playerScripts then return nil end
  local playerModule = playerScripts:FindFirstChild("PlayerModule")
  if not playerModule then return nil end
  local cameraModule = playerModule:FindFirstChild("CameraModule")
  if not cameraModule then return nil end
  local zoomController = cameraModule:FindFirstChild("ZoomController")
  if not zoomController then return nil end
  return zoomController:FindFirstChild("Popper")
end

local function patchPopper()
  if noclipCamState.applied then return true end
  noclipCamState.mod = findPopperModule()
  if not noclipCamState.mod then return false end
  local setConstant = debug and debug.setconstant
  local getConstants = debug and debug.getconstants
  if not (setConstant and getConstants and getgc) then return false end
  noclipCamState.orig = {}
  for _, candidate in pairs(getgc()) do
    if type(candidate) == "function" then
      local okEnv, environment = pcall(function()
        return getfenv(candidate)
      end)
      if okEnv and environment and environment.script == noclipCamState.mod then
        local okConstants, constants = pcall(getConstants, candidate)
        if okConstants and constants then
          for index, constant in pairs(constants) do
            if tonumber(constant) == 0.25 then
              noclipCamState.orig[candidate] = noclipCamState.orig[candidate] or {}
              noclipCamState.orig[candidate][index] = constant
              pcall(setConstant, candidate, index, 0)
            elseif tonumber(constant) == 0 then
              noclipCamState.orig[candidate] = noclipCamState.orig[candidate] or {}
              noclipCamState.orig[candidate][index] = constant
              pcall(setConstant, candidate, index, 0.25)
            end
          end
        end
      end
    end
  end
  noclipCamState.applied = true
  return true
end

local function unpatchPopper()
  if not noclipCamState.orig or not noclipCamState.mod then
    noclipCamState.applied = false
    return
  end
  local setConstant = debug and debug.setconstant
  if setConstant then
    for candidate, constants in pairs(noclipCamState.orig) do
      for index, constant in pairs(constants) do
        pcall(setConstant, candidate, index, constant)
      end
    end
  end
  noclipCamState.orig = nil
  noclipCamState.applied = false
end

local function startNoclipCam()
  noclipCamState.enabled = true
  task.spawn(function()
    local attempts = 0
    while not noclipCamState.applied and attempts < 20 do
      attempts = attempts + 1
      if patchPopper() then
        break
      end
      task.wait(0.5)
    end
  end)
end

local function stopNoclipCam()
  noclipCamState.enabled = false
  unpatchPopper()
end

local killerEspState = {running = false, connAdd = nil, connIngameAdd = nil}
local survivorEspState = {running = false, connAdd = nil}
local espHighlightName = "testbraken_ESP_HL"
local espSettings = {
  KillerColor = Color3.fromRGB(255, 50, 50),
  SurvivorColor = Color3.fromRGB(50, 255, 50),
  FillTransparency = 0.5,
  OutlineTransparency = 0,
}
local highlightWatchers = {}

local function applyHighlight(model, color)
  if not model or not model.Parent then return end
  if model:GetAttribute("Username") == localPlayer.Name then return end
  local existing = model:FindFirstChild(espHighlightName)
  if existing then
    existing.FillColor = color
    existing.OutlineColor = color
    return existing
  end
  for _, descendant in ipairs(model:GetDescendants()) do
    if descendant:IsA("Highlight") and descendant.Name ~= espHighlightName then
      descendant:Destroy()
      break
    end
  end
  existing = Instance.new("Highlight")
  existing.Name = espHighlightName
  existing.Adornee = model
  existing.FillColor = color
  existing.OutlineColor = color
  existing.FillTransparency = espSettings.FillTransparency
  existing.OutlineTransparency = espSettings.OutlineTransparency
  existing.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  existing.Parent = model
  if not highlightWatchers[model] then
    highlightWatchers[model] = model.ChildAdded:Connect(function(child)
      if child:IsA("Highlight") and child.Name ~= espHighlightName then
        task.wait(3)
        task.defer(function()
          if child.Parent then
            child:Destroy()
          end
          local own = model:FindFirstChild(espHighlightName)
          if own then
            own.FillColor = color
            own.OutlineColor = color
          end
        end)
      end
    end)
  end
  return existing
end

local function removeHighlight(model)
  if not model then return end
  local existing = model:FindFirstChild(espHighlightName)
  if existing then
    existing:Destroy()
  end
  if highlightWatchers[model] then
    pcall(function()
      highlightWatchers[model]:Disconnect()
    end)
    highlightWatchers[model] = nil
  end
end

local function startKillerEsp()
  if killerEspState.running then return end
  killerEspState.running = true
  local killersFolder = Workspace:WaitForChild("Players", 10)
  killersFolder = killersFolder and killersFolder:FindFirstChild("Killers")
  if not killersFolder then
    print("[testbraken] KillerESP: Killers folder not found")
    return
  end
  local ingame = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame")
  for _, killer in ipairs(killersFolder:GetChildren()) do
    applyHighlight(killer, espSettings.KillerColor)
  end
  if ingame then
    for _, child in ipairs(ingame:GetChildren()) do
      local humanoid = child:FindFirstChildOfClass("Humanoid")
      if humanoid and not Players:GetPlayerFromCharacter(child) and humanoid.WalkSpeed ~= 16 and humanoid.WalkSpeed ~= 26 then
        applyHighlight(child, Color3.fromRGB(180, 0, 0))
      end
    end
    killerEspState.connIngameAdd = ingame.ChildAdded:Connect(function(child)
      if not killerEspState.running then return end
      task.wait(0.5)
      local humanoid = child:FindFirstChildOfClass("Humanoid")
      if humanoid and not Players:GetPlayerFromCharacter(child) and humanoid.WalkSpeed ~= 16 and humanoid.WalkSpeed ~= 26 then
        applyHighlight(child, Color3.fromRGB(180, 0, 0))
      end
    end)
  end
  killerEspState.connAdd = killersFolder.ChildAdded:Connect(function(child)
    if not killerEspState.running then return end
    task.wait(0.5)
    applyHighlight(child, espSettings.KillerColor)
  end)
  print("[testbraken] KillerESP ON")
end

local function stopKillerEsp()
  if not killerEspState.running then return end
  killerEspState.running = false
  if killerEspState.connAdd then
    pcall(function()
      killerEspState.connAdd:Disconnect()
    end)
    killerEspState.connAdd = nil
  end
  if killerEspState.connIngameAdd then
    pcall(function()
      killerEspState.connIngameAdd:Disconnect()
    end)
    killerEspState.connIngameAdd = nil
  end
  local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
  if killersFolder then
    for _, killer in ipairs(killersFolder:GetChildren()) do
      removeHighlight(killer)
    end
  end
  local ingame = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame")
  if ingame then
    for _, descendant in ipairs(ingame:GetDescendants()) do
      if descendant:IsA("Highlight") and descendant.Name == espHighlightName then
        descendant:Destroy()
      end
    end
  end
  print("[testbraken] KillerESP OFF")
end

local function startSurvivorEsp()
  if survivorEspState.running then return end
  survivorEspState.running = true
  local survivorsFolder = Workspace:WaitForChild("Players", 10)
  survivorsFolder = survivorsFolder and survivorsFolder:FindFirstChild("Survivors")
  if not survivorsFolder then
    print("[testbraken] SurvivorESP: Survivors folder not found")
    return
  end
  for _, survivor in ipairs(survivorsFolder:GetChildren()) do
    if survivor ~= localPlayer.Character then
      applyHighlight(survivor, espSettings.SurvivorColor)
    end
  end
  survivorEspState.connAdd = survivorsFolder.ChildAdded:Connect(function(child)
    if not survivorEspState.running then return end
    task.wait(0.5)
    if child ~= localPlayer.Character then
      applyHighlight(child, espSettings.SurvivorColor)
    end
  end)
  print("[testbraken] SurvivorESP ON")
end

local function stopSurvivorEsp()
  if not survivorEspState.running then return end
  survivorEspState.running = false
  if survivorEspState.connAdd then
    pcall(function()
      survivorEspState.connAdd:Disconnect()
    end)
    survivorEspState.connAdd = nil
  end
  local survivorsFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
  if survivorsFolder then
    for _, survivor in ipairs(survivorsFolder:GetChildren()) do
      removeHighlight(survivor)
    end
  end
  print("[testbraken] SurvivorESP OFF")
end

local staminaState = {
  InfStamina = false,
  AlwaysSprint = false,
  running = false,
  conn = nil,
  Sprinting = nil,
}

local function loadSprintingModule()
  if staminaState.Sprinting then
    return staminaState.Sprinting
  end
  local ok, module = pcall(function()
    return require(
      ReplicatedStorage:WaitForChild("Systems", 5)
        :WaitForChild("Character", 5)
        :WaitForChild("Game", 5)
        :WaitForChild("Sprinting", 5)
    )
  end)
  if ok and module then
    staminaState.Sprinting = module
  end
  return staminaState.Sprinting
end

local function startStaminaLoop()
  if staminaState.running then return end
  staminaState.running = true
  task.spawn(function()
    while staminaState.running do
      task.wait(0.1)
      local sprinting = staminaState.Sprinting
      if sprinting then
        if staminaState.InfStamina then
          sprinting.Stamina = sprinting.MaxStamina or 100
          sprinting.StaminaLossDisabled = true
        end
        if staminaState.AlwaysSprint then
          if not sprinting.IsSprinting then
            sprinting.IsSprinting = true
            if sprinting.__sprintedEvent then
              sprinting.__sprintedEvent:Fire(true)
            end
          end
        end
      end
    end
  end)
end

local function stopStaminaLoop()
  staminaState.running = false
  local sprinting = staminaState.Sprinting
  if sprinting then
    sprinting.StaminaLossDisabled = false
    sprinting.IsSprinting = false
    if sprinting.__sprintedEvent then
      sprinting.__sprintedEvent:Fire(false)
    end
  end
end

local function refreshStamina()
  local wanted = staminaState.InfStamina or staminaState.AlwaysSprint
  if wanted then
    loadSprintingModule()
    startStaminaLoop()
  else
    stopStaminaLoop()
  end
end

--// Obsidian UI 初始化与旧控件接口适配层
local obsidianWindow = Obsidian:CreateWindow({
  Title = "Forsaken 中文版",
  Footer = "中文重构版",
  Size = UDim2.fromOffset(640, 560),
  Center = true,
  AutoShow = true,
  ToggleKeybind = Enum.KeyCode.RightControl,
  ShowCustomCursor = false,
  Resizable = true,
  MobileButtonsSide = "Right",
})

local uiId = 0
local function nextUiId(prefix)
  uiId = uiId + 1
  return (prefix or "Forsaken") .. tostring(uiId)
end

local function wrapControl(control, kind)
  local wrapper = {_control = control, _kind = kind}
  return setmetatable(wrapper, {
    __index = function(self, key)
      if key == "Value" then
        return self._control and self._control.Value
      elseif key == "Set" then
        return function(_, value)
          if not self._control then return end
          if self._control.SetValue then
            self._control:SetValue(value)
          elseif self._control.Set then
            self._control:Set(value)
          end
        end
      elseif key == "Refresh" then
        return function(_, values)
          if self._control and self._control.SetValues then
            self._control:SetValues(values)
          elseif self._control and self._control.Refresh then
            self._control:Refresh(values)
          end
        end
      end
      local value = self._control and self._control[key]
      if type(value) == "function" then
        return function(_, ...)
          return value(self._control, ...)
        end
      end
      return value
    end,
  })
end

local window = {}
function window:Tab(options)
  local rawTab = obsidianWindow:AddTab(options.Title or "页面", options.Icon)
  local tab = {_tab = rawTab, _groupbox = nil, _sectionCount = 0}
  function tab:Section(sectionOptions)
    self._sectionCount = self._sectionCount + 1
    local title = sectionOptions.Title or "功能"
    if self._sectionCount % 2 == 1 then
      self._groupbox = self._tab:AddLeftGroupbox(title)
    else
      self._groupbox = self._tab:AddRightGroupbox(title)
    end
    return self._groupbox
  end
  local function getGroupbox(self)
    if not self._groupbox then
      self._groupbox = self._tab:AddLeftGroupbox("功能")
    end
    return self._groupbox
  end
  function tab:Paragraph(paragraphOptions)
    local title = paragraphOptions.Title or "说明"
    local desc = paragraphOptions.Desc or ""
    return getGroupbox(self):AddLabel({
      Text = "<b>" .. tostring(title) .. "</b>\n" .. tostring(desc),
      DoesWrap = true,
    })
  end
  function tab:Toggle(options)
    local control = getGroupbox(self):AddToggle(nextUiId("Toggle"), {
      Text = options.Title or "开关",
      Default = options.Value == true,
      Callback = options.Callback,
    })
    return wrapControl(control, "Toggle")
  end
  function tab:Slider(options)
    local range = options.Value or {}
    local control = getGroupbox(self):AddSlider(nextUiId("Slider"), {
      Text = options.Title or "数值",
      Min = range.Min or 0,
      Max = range.Max or 100,
      Default = range.Default or range.Min or 0,
      Rounding = 0,
      Callback = options.Callback,
    })
    return wrapControl(control, "Slider")
  end
  function tab:Dropdown(options)
    local control = getGroupbox(self):AddDropdown(nextUiId("Dropdown"), {
      Text = options.Title or "选择",
      Values = options.Values or {},
      Default = options.Value,
      Callback = options.Callback,
    })
    return wrapControl(control, "Dropdown")
  end
  function tab:Input(options)
    local control = getGroupbox(self):AddInput(nextUiId("Input"), {
      Text = options.Title or "输入",
      Default = tostring(options.Value or ""),
      Placeholder = options.Placeholder or "",
      Finished = true,
      Callback = options.Callback,
    })
    return wrapControl(control, "Input")
  end
  function tab:Button(options)
    return getGroupbox(self):AddButton({
      Text = options.Title or "执行",
      Func = options.Callback or function() end,
    })
  end
  return tab
end

local function syncZoneInputs()
  if inputs.CustomDiamondLength then
    pcall(function()
      inputs.CustomDiamondLength:Set(tostring(config.CustomDiamondLength))
    end)
  end
  if inputs.CustomDiamondWidth then
    pcall(function()
      inputs.CustomDiamondWidth:Set(tostring(config.CustomDiamondWidth))
    end)
  end
  if inputs.CustomDiamondOffset then
    pcall(function()
      inputs.CustomDiamondOffset:Set(tostring(config.CustomDiamondOffset))
    end)
  end
  if inputs.CustomCircleRadius then
    pcall(function()
      inputs.CustomCircleRadius:Set(tostring(config.CustomCircleRadius))
    end)
  end
  if inputs.ZoneHeight then
    pcall(function()
      inputs.ZoneHeight:Set(tostring(config.ZoneHeight))
    end)
  end
end

local mainTab = window:Tab({Title = "主页", Icon = "house"})

mainTab:Section({Title = "🇻🇳 致谢"})
mainTab:Paragraph({
  Title = "献给我们所有人",
  Desc = "我们——代码浩瀚宇宙中的普通人——共同编织了一个梦想。\n\n从 DeepSeek、ChatGPT、Gemini 和 Google 的第一行代码，到你我无数个不眠之夜，一个倾注了心血的小小作品终于诞生。\n\n没有 AI 能取代人类，也没有任何人能独自走完这段路。我们是一个整体——人类与机器，怀着共同的热忱前行。\n\n感谢从未放弃。\n感谢始终相信。\n也感谢此刻的你，愿意来到这里。💙",
})

mainTab:Section({Title = "特别献词"})
mainTab:Paragraph({
  Title = "献给我们所有人",
  Desc = "我们——代码浩瀚宇宙中的普通人——共同编织了一个梦想。\n\n从 DeepSeek、ChatGPT、Gemini 和 Google 的第一行代码，到你我无数个不眠之夜，一个倾注了心血的小小作品终于诞生。\n\n没有 AI 能取代人类，也没有任何人能独自走完这段路。我们是一个整体——人类与机器，怀着共同的热忱前行。\n\n感谢从未放弃。\n感谢始终相信。\n也感谢此刻的你，愿意来到这里。💙",
})

mainTab:Section({Title = "制作人员"})
mainTab:Paragraph({
  Title = "制作名单",
  Desc = "• 你 — 创意、测试与方向\n• DeepSeek — 主要代码辅助\n• ChatGPT（OpenAI）— 逻辑与推理\n• Gemini（Google）— 分析与扩展\n• Google — 搜索与资料参考",
})

local espTab = window:Tab({Title = "透视", Icon = "eye"})

espTab:Section({Title = "玩家透视"})
toggles.KillerESP = espTab:Toggle({
  Title = "杀手透视",
  Value = false,
  Callback = function(enabled)
    if enabled then
      startKillerEsp()
    else
      stopKillerEsp()
    end
  end,
})
espTab:Toggle({
  Title = "杀手透视颜色（红色）",
  Value = false,
  Callback = function(alternate)
    espSettings.KillerColor = alternate and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 50, 50)
  end,
})
toggles.SurvivorESP = espTab:Toggle({
  Title = "幸存者透视",
  Value = false,
  Callback = function(enabled)
    if enabled then
      startSurvivorEsp()
    else
      stopSurvivorEsp()
    end
  end,
})
espTab:Toggle({
  Title = "幸存者透视颜色（绿色）",
  Value = false,
  Callback = function(alternate)
    espSettings.SurvivorColor = alternate and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 255, 50)
  end,
})

espTab:Section({Title = "实体透视"})
toggles.MinionESP = espTab:Toggle({
  Title = "随从透视（c00lkidd / 1x1x1x1）",
  Value = config.MinionESP,
  Callback = function(enabled)
    config.MinionESP = enabled
    if enabled then
      startMinionEsp()
    else
      stopMinionEsp()
    end
  end,
})
toggles.ProjectileESP = espTab:Toggle({
  Title = "投射物透视（c00lkidd）",
  Value = config.ProjectileESP,
  Callback = function(enabled)
    config.ProjectileESP = enabled
    if enabled then
      startProjectileEsp()
    else
      stopProjectileEsp()
    end
  end,
})
toggles.AzureTrapESP = espTab:Toggle({
  Title = "蔚蓝陷阱透视",
  Value = config.AzureTrapESP,
  Callback = function(enabled)
    config.AzureTrapESP = enabled
    if enabled then
      startAzureTrapEsp()
    else
      stopAzureTrapEsp()
    end
  end,
})

local autoBlockTab = window:Tab({Title = "自动格挡", Icon = "shield"})

autoBlockTab:Section({Title = "自动格挡（默认模式）"})
toggles.AutoBlock = autoBlockTab:Toggle({
  Title = "自动格挡",
  Value = config.AutoBlock,
  Callback = function(enabled)
    if suppressCallbacks then return end
    requestBlockToggle(enabled, "default")
  end,
})
toggles.ABModeDropdown = autoBlockTab:Dropdown({
  Title = "自动格挡模式",
  Values = {"Guest 1337", "007n7"},
  Value = (config.ABMode == "007n7") and "007n7" or "Guest 1337",
  Callback = function(selected)
    config.ABMode = (selected == "007n7") and "007n7" or "Guest1337"
  end,
})
toggles.AimPunch = autoBlockTab:Toggle({
  Title = "自动瞄准并出拳",
  Value = config.AimPunch,
  Callback = function(enabled)
    config.AimPunch = enabled
  end,
})
toggles.AutoBlockButton = autoBlockTab:Toggle({
  Title = "自动格挡按钮",
  Value = config.AutoBlockButton,
  Callback = function(enabled)
    config.AutoBlockButton = enabled
    if enabled then
      startFourthButton()
    else
      stopFourthButton()
    end
  end,
})
toggles.FourthButtonTargetDropdown = autoBlockTab:Dropdown({
  Title = "第四个按钮目标",
  Values = {"默认", "自定义"},
  Value = (config.FourthButtonTarget == "custom") and "自定义" or "默认",
  Callback = function(selected)
    config.FourthButtonTarget = (selected == "自定义") and "custom" or "default"
  end,
})

autoBlockTab:Section({Title = "自定义自动格挡"})
toggles.AutoBlockCustom = autoBlockTab:Toggle({
  Title = "自定义自动格挡",
  Value = config.AutoBlockCustom,
  Callback = function(enabled)
    if suppressCallbacks then return end
    requestBlockToggle(enabled, "custom")
  end,
})
toggles.CustomABModeDropdown = autoBlockTab:Dropdown({
  Title = "自定义格挡模式",
  Values = {"Guest 1337", "007n7"},
  Value = (config.CustomABMode == "007n7") and "007n7" or "Guest 1337",
  Callback = function(selected)
    config.CustomABMode = (selected == "007n7") and "007n7" or "Guest1337"
  end,
})
toggles.ShowDiamond = autoBlockTab:Toggle({
  Title = "显示菱形判定区",
  Value = config.ShowDiamond,
  Callback = function(enabled)
    if suppressCallbacks then
      config.ShowDiamond = enabled
      refreshCustomZones()
      return
    end
    if config.AutoBlock then
      suppressCallbacks = true
      pcall(function()
        toggles.ShowDiamond:Set(false)
      end)
      suppressCallbacks = false
      config.ShowDiamond = false
      refreshCustomZones()
      return
    end
    config.ShowDiamond = enabled
    refreshCustomZones()
  end,
})
inputs.CustomDiamondLength = autoBlockTab:Input({
  Title = "菱形长度",
  Value = tostring(config.CustomDiamondLength),
  Placeholder = "8",
  Callback = function(text)
    config.CustomDiamondLength = math.max(1, tonumber(text) or 8)
  end,
})
inputs.CustomDiamondWidth = autoBlockTab:Input({
  Title = "菱形宽度",
  Value = tostring(config.CustomDiamondWidth),
  Placeholder = "4",
  Callback = function(text)
    config.CustomDiamondWidth = math.max(1, tonumber(text) or 4)
  end,
})
inputs.CustomDiamondOffset = autoBlockTab:Input({
  Title = "菱形朝向偏移",
  Value = tostring(config.CustomDiamondOffset),
  Placeholder = "3",
  Callback = function(text)
    config.CustomDiamondOffset = math.max(0, tonumber(text) or 3)
  end,
})
toggles.ShowCircle = autoBlockTab:Toggle({
  Title = "显示圆形判定区",
  Value = config.ShowCircle,
  Callback = function(enabled)
    if suppressCallbacks then
      config.ShowCircle = enabled
      refreshCustomZones()
      return
    end
    if config.AutoBlock then
      suppressCallbacks = true
      pcall(function()
        toggles.ShowCircle:Set(false)
      end)
      suppressCallbacks = false
      config.ShowCircle = false
      refreshCustomZones()
      return
    end
    config.ShowCircle = enabled
    refreshCustomZones()
  end,
})
inputs.CustomCircleRadius = autoBlockTab:Input({
  Title = "圆形半径",
  Value = tostring(config.CustomCircleRadius),
  Placeholder = "5",
  Callback = function(text)
    config.CustomCircleRadius = math.max(1, tonumber(text) or 5)
  end,
})
inputs.ZoneHeight = autoBlockTab:Input({
  Title = "判定区高度",
  Value = tostring(config.ZoneHeight),
  Placeholder = "0.5",
  Callback = function(text)
    config.ZoneHeight = tonumber(text) or 0.5
  end,
})

local staminaTab = window:Tab({Title = "体力", Icon = "zap"})

staminaTab:Section({Title = "体力功能"})
staminaTab:Toggle({
  Title = "无限体力",
  Value = false,
  Callback = function(enabled)
    staminaState.InfStamina = enabled
    refreshStamina()
  end,
})
staminaTab:Toggle({
  Title = "始终冲刺",
  Value = false,
  Callback = function(enabled)
    staminaState.AlwaysSprint = enabled
    refreshStamina()
  end,
})
staminaTab:Section({Title = "功能说明"})
staminaTab:Paragraph({
  Title = "工作原理",
  Desc = "无限体力会每 0.1 秒补满体力条，并阻止体力消耗。始终冲刺会持续保持冲刺状态。两个功能均适用于幸存者和杀手身份。首次使用时会从游戏中加载冲刺模块。",
})

local fovTab = window:Tab({Title = "视野", Icon = "camera"})

fovTab:Section({Title = "视野范围"})
sliders.FOV = fovTab:Slider({
  Title = "视野",
  Value = {Min = minFov, Max = maxFov, Default = config.FOVValue},
  Callback = function(value)
    local clamped = math.clamp(math.floor(value), minFov, maxFov)
    if clamped == config.FOVValue then return end
    config.FOVValue = clamped
    scheduleFovApply()
  end,
})
fovTab:Button({
  Title = "重新应用视野",
  Callback = function()
    applyFov()
  end,
})

local playerInfoTab = window:Tab({Title = "玩家信息", Icon = "user"})

playerInfoTab:Section({Title = "玩家资料"})
playerDropdown = playerInfoTab:Dropdown({
  Title = "选择玩家",
  Values = (function()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
      table.insert(names, player.Name)
    end
    return names
  end)(),
  Callback = function(selected)
  end,
})
playerInfoTab:Button({
  Title = "复制个人资料链接",
  Callback = function()
    if not playerDropdown then return end
    local selectedName = playerDropdown.Value
    if not selectedName then return end
    for _, player in ipairs(Players:GetPlayers()) do
      if player.Name == selectedName and setclipboard then
        setclipboard("https://www.roblox.com/users/" .. player.UserId .. "/profile")
      end
    end
  end,
})
playerInfoTab:Button({
  Title = "刷新玩家列表",
  Callback = function()
    if not playerDropdown then return end
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
      table.insert(names, player.Name)
    end
    pcall(function()
      playerDropdown:Refresh(names)
    end)
  end,
})

local miscTab = window:Tab({Title = "其他功能", Icon = "settings"})

miscTab:Section({Title = "效果处理"})
toggles.AntiBlindness = miscTab:Toggle({
  Title = "防闪光/致盲",
  Value = config.AntiBlindness,
  Callback = function(enabled)
    config.AntiBlindness = enabled
    if enabled then
      startAntiBlindness()
    else
      stopAntiBlindness()
    end
  end,
})
toggles.AntiGlitch = miscTab:Toggle({
  Title = "屏蔽故障效果（1x1x1x1）",
  Value = config.AntiGlitch,
  Callback = function(enabled)
    config.AntiGlitch = enabled
    if enabled then
      startAntiGlitch()
    else
      stopAntiGlitch()
    end
  end,
})
toggles.AntiSubspaced = miscTab:Toggle({
  Title = "屏蔽空间异常效果（Taph）",
  Value = config.AntiSubspaced,
  Callback = function(enabled)
    config.AntiSubspaced = enabled
    if enabled then
      startAntiSubspaced()
    else
      stopAntiSubspaced()
    end
  end,
})
toggles.AntiNoliLaugh = miscTab:Toggle({
  Title = "屏蔽 Noli 笑声",
  Value = config.AntiNoliLaugh,
  Callback = function(enabled)
    config.AntiNoliLaugh = enabled
    if enabled then
      startAntiNoliLaugh()
    else
      stopAntiNoliLaugh()
    end
  end,
})

miscTab:Section({Title = "画质设置"})
toggles.LowGraphics = miscTab:Toggle({
  Title = "低画质模式",
  Value = config.LowGraphics,
  Callback = function(enabled)
    config.LowGraphics = enabled
    if enabled then
      startLowGraphics()
    else
      stopLowGraphics()
    end
  end,
})
toggles.FPSPing = miscTab:Toggle({
  Title = "帧率 + 网络延迟",
  Value = config.FPSPing,
  Callback = function(enabled)
    config.FPSPing = enabled
    if enabled then
      startFpsMonitor()
    else
      stopFpsMonitor()
    end
  end,
})

miscTab:Section({Title = "镜头设置"})
toggles.MaxZoom = miscTab:Toggle({
  Title = "无限镜头缩放",
  Value = config.MaxZoom,
  Callback = function(enabled)
    config.MaxZoom = enabled
    if enabled then
      enableMaxZoom()
    else
      disableMaxZoom()
    end
  end,
})
toggles.NoclipCam = miscTab:Toggle({
  Title = "镜头穿墙",
  Value = config.NoclipCam,
  Callback = function(enabled)
    config.NoclipCam = enabled
    if enabled then
      startNoclipCam()
    else
      stopNoclipCam()
    end
  end,
})

miscTab:Section({Title = "隐私 / 聊天"})
toggles.ForceChat = miscTab:Toggle({
  Title = "强制聊天",
  Value = config.ForceChat,
  Callback = function(enabled)
    config.ForceChat = enabled
    if enabled then
      startForceChat()
    else
      stopForceChat()
    end
  end,
})
toggles.Disable007n7 = miscTab:Toggle({
  Title = "禁用 007n7 分身",
  Value = config.Disable007n7,
  Callback = function(enabled)
    config.Disable007n7 = enabled
    if enabled then
      startDisableClone()
    else
      stopDisableClone()
    end
  end,
})
toggles.ShowPrivacy = miscTab:Toggle({
  Title = "显示隐私信息",
  Value = config.ShowPrivacy,
  Callback = function(enabled)
    config.ShowPrivacy = enabled
    if enabled then
      startShowPrivacy()
    else
      stopShowPrivacy()
    end
  end,
})

miscTab:Section({Title = "紧急操作"})
miscTab:Button({
  Title = "🛑 关闭全部功能",
  Callback = function()
    stopAntiBlindness()
    stopAntiGlitch()
    stopAntiSubspaced()
    stopAntiNoliLaugh()
    stopKillerEsp()
    stopSurvivorEsp()
    stopMinionEsp()
    stopProjectileEsp()
    stopAzureTrapEsp()
    stopAutoBlock()
    stopFourthButton()
    stopCustomZones()
    staminaState.InfStamina = false
    staminaState.AlwaysSprint = false
    stopStaminaLoop()
    stopLowGraphics()
    stopFpsMonitor()
    disableMaxZoom()
    stopNoclipCam()
    stopForceChat()
    stopDisableClone()
    stopShowPrivacy()
    for key, value in pairs(config) do
      if type(value) == "boolean" and key ~= "AimPunch" then
        config[key] = false
      end
    end
    config.ABMode = "Guest1337"
    config.CustomABMode = "Guest1337"
    config.FourthButtonTarget = "default"
    for key, toggle in pairs(toggles) do
      if toggle and config[key] ~= nil then
        suppressCallbacks = true
        pcall(function()
          toggle:Set(config[key])
        end)
        suppressCallbacks = false
      end
    end
    if toggles.ABModeDropdown then
      pcall(function()
        toggles.ABModeDropdown:Set("Guest 1337")
      end)
    end
    if toggles.CustomABModeDropdown then
      pcall(function()
        toggles.CustomABModeDropdown:Set("Guest 1337")
      end)
    end
    if toggles.FourthButtonTargetDropdown then
      pcall(function()
        toggles.FourthButtonTargetDropdown:Set("默认")
      end)
    end
    config.CustomDiamondLength = 8
    config.CustomDiamondWidth = 4
    config.CustomDiamondOffset = 3
    config.CustomCircleRadius = 5
    config.ZoneHeight = 0.5
    rememberedZones.diamond = false
    rememberedZones.circle = false
    syncZoneInputs()
    config.FOVValue = 80
    if sliders.FOV then
      pcall(function()
        sliders.FOV:Set(80)
      end)
    end
    local camera = Workspace.CurrentCamera
    if camera then
      pcall(function()
        camera.FieldOfView = 80
      end)
    end
    print("[testbraken] ⛔ All disabled. FOV reset to 80.")
  end,
})

local configTab = window:Tab({Title = "配置管理", Icon = "save"})

configTab:Section({Title = "保存 / 加载 / 删除配置"})
configTab:Button({
  Title = "💾 保存配置",
  Callback = function()
    local saved = saveConfig()
    print(
      "[testbraken] Save:", saved,
      "| AutoBlock:", config.AutoBlock,
      "| Custom:", config.AutoBlockCustom,
      "| ABMode:", config.ABMode,
      "| CustomABMode:", config.CustomABMode,
      "| 4thTarget:", config.FourthButtonTarget,
      "| ShowDia:", config.ShowDiamond,
      "| ShowCir:", config.ShowCircle,
      "| memDia:", rememberedZones.diamond,
      "| memCir:", rememberedZones.circle
    )
  end,
})
configTab:Button({
  Title = "📂 加载配置",
  Callback = function()
    local loaded = loadConfig()
    if not loaded then
      print("[testbraken] No config")
      return
    end
    for key, value in pairs(loaded) do
      if config[key] ~= nil then
        config[key] = value
      end
    end
    for key, toggle in pairs(toggles) do
      if toggle and config[key] ~= nil then
        suppressCallbacks = true
        pcall(function()
          toggle:Set(config[key])
        end)
        suppressCallbacks = false
      end
    end
    if toggles.ABModeDropdown then
      pcall(function()
        toggles.ABModeDropdown:Set(config.ABMode == "007n7" and "007n7" or "Guest 1337")
      end)
    end
    if toggles.CustomABModeDropdown then
      pcall(function()
        toggles.CustomABModeDropdown:Set(config.CustomABMode == "007n7" and "007n7" or "Guest 1337")
      end)
    end
    if toggles.FourthButtonTargetDropdown then
      pcall(function()
        toggles.FourthButtonTargetDropdown:Set(config.FourthButtonTarget == "custom" and "自定义" or "默认")
      end)
    end
    if sliders.FOV then
      pcall(function()
        sliders.FOV:Set(config.FOVValue)
      end)
    end
    syncZoneInputs()
    if config.AntiBlindness then startAntiBlindness() else stopAntiBlindness() end
    if config.AntiGlitch then startAntiGlitch() else stopAntiGlitch() end
    if config.AntiSubspaced then startAntiSubspaced() else stopAntiSubspaced() end
    if config.AntiNoliLaugh then startAntiNoliLaugh() else stopAntiNoliLaugh() end
    if config.MinionESP then startMinionEsp() else stopMinionEsp() end
    if config.ProjectileESP then startProjectileEsp() else stopProjectileEsp() end
    if config.AzureTrapESP then startAzureTrapEsp() else stopAzureTrapEsp() end
    if config.AutoBlock or config.AutoBlockCustom then startAutoBlock() else stopAutoBlock() end
    enforceBlockModeExclusivity()
    if config.AutoBlockButton then startFourthButton() else stopFourthButton() end
    if config.LowGraphics then startLowGraphics() else stopLowGraphics() end
    if config.FPSPing then startFpsMonitor() else stopFpsMonitor() end
    if config.MaxZoom then enableMaxZoom() else disableMaxZoom() end
    if config.NoclipCam then startNoclipCam() else stopNoclipCam() end
    if config.ForceChat then startForceChat() else stopForceChat() end
    if config.Disable007n7 then startDisableClone() else stopDisableClone() end
    if config.ShowPrivacy then startShowPrivacy() else stopShowPrivacy() end
    applyFov()
    if fourthButtonState.applyTint then
      fourthButtonState.applyTint()
    end
    print(
      "[testbraken] Config loaded (AutoBlock:", config.AutoBlock,
      "| Custom:", config.AutoBlockCustom,
      "| ABMode:", config.ABMode,
      "| CustomABMode:", config.CustomABMode,
      "| Diamond:", config.CustomDiamondLength .. "x" .. config.CustomDiamondWidth,
      "| Circle:", config.CustomCircleRadius,
      "| memDia:", rememberedZones.diamond,
      "| memCir:", rememberedZones.circle,
      ")"
    )
  end,
})
configTab:Button({
  Title = "🗑 删除配置",
  Callback = function()
    local deleted = deleteConfig()
    print("[testbraken] Delete:", deleted)
  end,
})

if config.AntiBlindness then
  startAntiBlindness()
end

task.spawn(function()
  task.wait(1.0)
  local loaded = loadConfig()
  if loaded then
    for key, value in pairs(loaded) do
      if config[key] ~= nil then
        config[key] = value
      end
    end
    if config.AntiBlindness then startAntiBlindness() else stopAntiBlindness() end
    if config.AntiGlitch then startAntiGlitch() end
    if config.AntiSubspaced then startAntiSubspaced() end
    if config.AntiNoliLaugh then startAntiNoliLaugh() end
    if config.MinionESP then startMinionEsp() end
    if config.ProjectileESP then startProjectileEsp() end
    if config.AzureTrapESP then startAzureTrapEsp() end
    if config.AutoBlock or config.AutoBlockCustom then startAutoBlock() end
    enforceBlockModeExclusivity()
    if config.AutoBlockButton then startFourthButton() end
    if config.LowGraphics then startLowGraphics() end
    if config.FPSPing then startFpsMonitor() end
    if config.MaxZoom then enableMaxZoom() end
    if config.NoclipCam then startNoclipCam() end
    if config.ForceChat then startForceChat() end
    if config.Disable007n7 then startDisableClone() end
    if config.ShowPrivacy then startShowPrivacy() end
    applyFov()
    for key, toggle in pairs(toggles) do
      if toggle and config[key] ~= nil then
        suppressCallbacks = true
        pcall(function()
          toggle:Set(config[key])
        end)
        suppressCallbacks = false
      end
    end
    if toggles.ABModeDropdown then
      pcall(function()
        toggles.ABModeDropdown:Set(config.ABMode == "007n7" and "007n7" or "Guest 1337")
      end)
    end
    if toggles.CustomABModeDropdown then
      pcall(function()
        toggles.CustomABModeDropdown:Set(config.CustomABMode == "007n7" and "007n7" or "Guest 1337")
      end)
    end
    if toggles.FourthButtonTargetDropdown then
      pcall(function()
        toggles.FourthButtonTargetDropdown:Set(config.FourthButtonTarget == "custom" and "自定义" or "默认")
      end)
    end
    if sliders.FOV then
      pcall(function()
        sliders.FOV:Set(config.FOVValue)
      end)
    end
    syncZoneInputs()
    if fourthButtonState.applyTint then
      fourthButtonState.applyTint()
    end
    print(
      "[testbraken] Auto-loaded config (AutoBlock:", config.AutoBlock,
      "| Custom:", config.AutoBlockCustom,
      "| ABMode:", config.ABMode,
      "| CustomABMode:", config.CustomABMode,
      "| Diamond:", config.CustomDiamondLength .. "x" .. config.CustomDiamondWidth,
      "| Circle:", config.CustomCircleRadius,
      "| memDia:", rememberedZones.diamond,
      "| memCir:", rememberedZones.circle,
      ")"
    )
  end
end)

if config.AutoBlockButton then
  startFourthButton()
end

refreshCustomZones()

Players.PlayerAdded:Connect(function()
  task.defer(function()
    if playerDropdown then
      local names = {}
      for _, player in ipairs(Players:GetPlayers()) do
        table.insert(names, player.Name)
      end
      pcall(function()
        playerDropdown:Refresh(names)
      end)
    end
  end)
end)

Players.PlayerRemoving:Connect(function()
  task.defer(function()
    if playerDropdown then
      local names = {}
      for _, player in ipairs(Players:GetPlayers()) do
        table.insert(names, player.Name)
      end
      pcall(function()
        playerDropdown:Refresh(names)
      end)
    end
  end)
end)

print("[testbraken] v9.1.1 Loaded")