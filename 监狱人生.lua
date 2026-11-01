local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local function getGuiParent()
    local ok, parent = pcall(function()
        local test = Instance.new("ScreenGui")
        test.Parent = CoreGui
        test:Destroy()
        return CoreGui
    end)
    if ok and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function loadWindUI()
    local source = game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua", true)
    assert(type(source) == "string" and #source > 100, "WindUI 下载内容为空")
    local loader = loadstring(source)
    assert(type(loader) == "function", "WindUI loadstring 失败")
    return loader()
end

local okWind, WindUI = pcall(loadWindUI)

if not okWind or not WindUI then
    warn("[ink_HUB] UI 加载失败：", tostring(WindUI))
    return
end

pcall(function()
    WindUI:AddTheme({
        Name = "inkGray",
        Accent = Color3.fromRGB(105, 105, 105),
        Dialog = Color3.fromRGB(32, 32, 32),
        Outline = Color3.fromRGB(125, 125, 125),
        Text = Color3.fromRGB(235, 235, 235),
        Placeholder = Color3.fromRGB(145, 145, 145),
        Background = Color3.fromRGB(24, 24, 24),
        Button = Color3.fromRGB(58, 58, 58),
        Icon = Color3.fromRGB(190, 190, 190),
        Title = Color3.fromRGB(155, 155, 155),
        Author = Color3.fromRGB(145, 145, 145),
    })
end)

local window
local okWindow, windowResult = pcall(function()
    return WindUI:CreateWindow({
        Title = "ink_破坏者谜团2",
        Author = "@Theinkremains",
        Icon = "rbxassetid://71953031400395",
        Folder = "ink_HUB",
        NewElements = true,
        HideSearchBar = false,
        Theme = "inkGray",
    })
end)
if not okWindow or not windowResult then
    warn("[ink_HUB] UI 创建失败：", tostring(windowResult))
    return
end
window = windowResult

local function showNotify(titleText, contentText, isError)
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local activeNotifies = _G.inkActiveNotifies or {}
    _G.inkActiveNotifies = activeNotifies

    local gui = CoreGui:FindFirstChild("ink_Notify") or Instance.new("ScreenGui", CoreGui)
    gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = "ink_Notify", false, 999999

    local frame = Instance.new("Frame", gui)
    frame.Size, frame.AnchorPoint, frame.Position, frame.BackgroundTransparency = UDim2.fromOffset(260, 65), Vector2.new(1, 1), UDim2.new(1, 300, 1, -20), 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color, stroke.Transparency, stroke.Thickness = isError and Color3.fromRGB(255,100,100) or Color3.fromRGB(180,180,180), 0.2, 1.5

    local baseBg = Instance.new("Frame", frame)
    baseBg.Size, baseBg.BackgroundColor3, baseBg.BackgroundTransparency, baseBg.ZIndex = UDim2.fromScale(1, 1), isError and Color3.fromRGB(140,70,70) or Color3.fromRGB(100,100,100), 0.5, 1
    Instance.new("UICorner", baseBg).CornerRadius = UDim.new(0, 8)

    local baseIcon = Instance.new("Frame", baseBg)
    baseIcon.Size, baseIcon.Position, baseIcon.BackgroundColor3, baseIcon.BackgroundTransparency, baseIcon.ZIndex = UDim2.fromOffset(30, 30), UDim2.new(0, 12, 0.5, -15), baseBg.BackgroundColor3, baseBg.BackgroundTransparency, 2
    Instance.new("UICorner", baseIcon).CornerRadius = UDim.new(1,0)

    local txtBase = Instance.new("TextLabel", baseBg)
    txtBase.Size, txtBase.Position, txtBase.BackgroundTransparency, txtBase.Text, txtBase.TextColor3, txtBase.Font, txtBase.TextSize, txtBase.TextXAlignment, txtBase.ZIndex = UDim2.fromOffset(30, 30), UDim2.new(0, 12, 0.5, -15), 1, isError and "×" or "✓", Color3.fromRGB(80,80,80), Enum.Font.GothamBold, 16, Enum.TextXAlignment.Center, 3
    
    local tBase = Instance.new("TextLabel", baseBg)
    tBase.Size, tBase.Position, tBase.BackgroundTransparency, tBase.Text, tBase.TextColor3, tBase.Font, tBase.TextSize, tBase.TextXAlignment, tBase.ZIndex = UDim2.new(1, -50, 0, 20), UDim2.new(0, 50, 0, 12), 1, titleText or "提示", Color3.fromRGB(80,80,80), Enum.Font.GothamBold, 15, Enum.TextXAlignment.Left, 3
    
    local cBase = Instance.new("TextLabel", baseBg)
    cBase.Size, cBase.Position, cBase.BackgroundTransparency, cBase.Text, cBase.TextColor3, cBase.Font, cBase.TextSize, cBase.TextXAlignment, cBase.ZIndex = UDim2.new(1, -50, 0, 20), UDim2.new(0, 50, 0, 32), 1, contentText or "", Color3.fromRGB(120,120,120), Enum.Font.Gotham, 13, Enum.TextXAlignment.Left, 3

    local fillBg = Instance.new("Frame", frame)
    fillBg.Size, fillBg.BackgroundColor3, fillBg.BackgroundTransparency, fillBg.ZIndex = UDim2.fromScale(1, 1), isError and Color3.fromRGB(70,10,10) or Color3.fromRGB(25,25,25), 0, 2
    Instance.new("UICorner", fillBg).CornerRadius = UDim.new(0, 8)

    local bgGrad = Instance.new("UIGradient", fillBg)
    bgGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.9, 1), NumberSequenceKeypoint.new(0.91, 0), NumberSequenceKeypoint.new(1, 0)})
    bgGrad.Offset = Vector2.new(1, 0)

    local fillIcon = Instance.new("Frame", fillBg)
    fillIcon.Size, fillIcon.Position, fillIcon.BackgroundColor3, fillIcon.BackgroundTransparency, fillIcon.ZIndex = UDim2.fromOffset(30, 30), UDim2.new(0, 12, 0.5, -15), fillBg.BackgroundColor3, 0, 2
    Instance.new("UICorner", fillIcon).CornerRadius = UDim.new(1,0)

    local iconGrad = Instance.new("UIGradient", fillIcon)
    iconGrad.Transparency, iconGrad.Offset = bgGrad.Transparency, Vector2.new(1, 0)

    local txtFill = Instance.new("TextLabel", fillBg)
    txtFill.Size, txtFill.Position, txtFill.BackgroundTransparency, txtFill.Text, txtFill.TextColor3, txtFill.Font, txtFill.TextSize, txtFill.TextXAlignment, txtFill.ZIndex = UDim2.fromOffset(30, 30), UDim2.new(0, 12, 0.5, -15), 1, isError and "×" or "✓", Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 16, Enum.TextXAlignment.Center, 3
    
    local tFill = Instance.new("TextLabel", fillBg)
    tFill.Size, tFill.Position, tFill.BackgroundTransparency, tFill.Text, tFill.TextColor3, tFill.Font, tFill.TextSize, tFill.TextXAlignment, tFill.ZIndex = UDim2.new(1, -50, 0, 20), UDim2.new(0, 50, 0, 12), 1, titleText or "提示", Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 15, Enum.TextXAlignment.Left, 3
    
    local cFill = Instance.new("TextLabel", fillBg)
    cFill.Size, cFill.Position, cFill.BackgroundTransparency, cFill.Text, cFill.TextColor3, cFill.Font, cFill.TextSize, cFill.TextXAlignment, cFill.ZIndex = UDim2.new(1, -50, 0, 20), UDim2.new(0, 50, 0, 32), 1, contentText or "", Color3.fromRGB(180,180,180), Enum.Font.Gotham, 13, Enum.TextXAlignment.Left, 3

    local close = Instance.new("TextButton", frame)
    close.Size, close.Position, close.BackgroundTransparency, close.Text, close.TextColor3, close.Font, close.TextSize, close.ZIndex = UDim2.fromOffset(25,25), UDim2.new(1,-30,0,5), 1, "×", Color3.fromRGB(150,150,150), Enum.Font.GothamBold, 14, 4

    close.MouseEnter:Connect(function() TweenService:Create(close, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(255, 80, 80), TextSize = 20}):Play() end)
    close.MouseLeave:Connect(function() TweenService:Create(close, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(150, 150, 150), TextSize = 14}):Play() end)
    
    table.insert(activeNotifies, frame)
    
    for i, f in ipairs(activeNotifies) do
        TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, -20 - ((i - 1) * 75))}):Play()
    end
    
    TweenService:Create(bgGrad, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Offset = Vector2.new(-1, 0)}):Play()
    TweenService:Create(iconGrad, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Offset = Vector2.new(-1, 0)}):Play()
    
    local function destroy()
        if frame:GetAttribute("Dead") then return end
        frame:SetAttribute("Dead", true)
        for i, f in ipairs(activeNotifies) do if f == frame then table.remove(activeNotifies, i) break end end
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 1, frame.Position.Y.Offset)}):Play()
        task.wait(0.3)
        frame:Destroy()
        for i, f in ipairs(activeNotifies) do
            TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, -20 - ((i - 1) * 75))}):Play()
        end
    end
    close.MouseButton1Click:Connect(function() task.wait(0.1) destroy() end)
    task.delay(3, destroy)
end

pcall(function()
    window:Tag({ Title = "监狱人生", Radius = 5, Color = Color3.fromHex("#555555") })
    window:Tag({ Title = "服务器专属", Radius = 6, Color = Color3.fromHex("#B0B0B0") })
end)

pcall(function()
    window:EditOpenButton({
        Title = "Project_ink_监狱人生",
        Icon = "crown",
        StrokeThickness = 5,
        TextColor = Color3.fromRGB(150, 150, 150),
        TitleColor = Color3.fromRGB(150, 150, 150),
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 90)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 70))
        }),
        Draggable = true
    })
end)

pcall(function()
    local targetWindow = window.UIElements and window.UIElements.Main
    if not targetWindow then
        local CoreGui = game:GetService("CoreGui")
        for _, obj in ipairs(CoreGui:GetDescendants()) do
            if obj:IsA("Frame") and obj.AbsoluteSize.X > 300 and obj.AbsoluteSize.Y > 150 then
                local title = obj:FindFirstChildWhichIsA("TextLabel", true)
                if title and title.Text == "ink_监狱人生" then
                    targetWindow = obj
                    break
                end
            end
        end
    end

    if targetWindow then
        local oldStroke = targetWindow:FindFirstChild("inkGrayMainBorder")
        if oldStroke then oldStroke:Destroy() end

        local stroke = Instance.new("UIStroke")
        stroke.Name = "inkGrayMainBorder"
        stroke.Thickness = 7
        stroke.Transparency = 0
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = Color3.fromRGB(145,145,145)
        stroke.Parent = targetWindow

        local glowColors = {
            {Name = "inkGrayGlowOuter", Thickness = 16, Transparency = 0.88},
            {Name = "inkGrayGlowMid", Thickness = 11, Transparency = 0.80},
            {Name = "inkGrayGlowInner", Thickness = 7, Transparency = 0.70},
        }

        for _, info in ipairs(glowColors) do
            local oldGlow = targetWindow:FindFirstChild(info.Name)
            if oldGlow then oldGlow:Destroy() end

            local glow = Instance.new("UIStroke")
            glow.Name = info.Name
            glow.Thickness = info.Thickness
            glow.Transparency = info.Transparency
            glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            glow.Color = Color3.fromRGB(150,150,150)
            glow.Parent = targetWindow

            local glowGradient = Instance.new("UIGradient")
            glowGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(70,70,70)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190,190,190)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(70,70,70))
            })
            glowGradient.Parent = glow

            task.spawn(function()
                local r = 0
                while targetWindow.Parent and glow.Parent and glowGradient.Parent do
                    r = (r + 1.1) % 360
                    glowGradient.Rotation = r
                    RunService.RenderStepped:Wait()
                end
            end)
        end

        local gradient = Instance.new("UIGradient")
        gradient.Name = "inkGrayBorderGradient"
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(65,65,65)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120,120,120)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200,200,200)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120,120,120)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(65,65,65))
        })
        gradient.Parent = stroke

        task.spawn(function()
            local rotation = 0
            while targetWindow.Parent and stroke.Parent and gradient.Parent do
                rotation = (rotation + 1.5) % 360
                gradient.Rotation = rotation
                RunService.RenderStepped:Wait()
            end
        end)
    end
end)
    pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local function recolor(root)
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if obj.Text == "ink_监狱人生" then
                    obj.TextColor3 = Color3.fromRGB(155,155,155)
                elseif obj.Text == "@Theinkremains" then
                    obj.TextColor3 = Color3.fromRGB(125,125,125)
                end
            end
        end
    end

    recolor(CoreGui)
    task.delay(0.25, function() pcall(function() recolor(CoreGui) end) end)
    task.delay(0.8, function() pcall(function() recolor(CoreGui) end) end)
end)

local GunTab = window:Tab({Title = "枪械修改", Icon = "crosshair"})
local modifyEnabled = false
local currentWeapon = nil
local inputRefs = {}

local function getEquippedGun()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            if tool:GetAttribute("Damage") or tool:GetAttribute("MaxAmmo") or tool.Name:lower():find("gun") or tool.Name == "MP5" or tool.Name == "Remington 870" then
                return tool
            end
        end
    end
    return nil
end

local function refreshInputPlaceholders()
    currentWeapon = getEquippedGun()
    
    local function updatePlaceholder(inputObj, attrName)
        if not inputObj then return end
        if currentWeapon then
            local val = currentWeapon:GetAttribute(attrName)
            if val ~= nil then
                inputObj.Placeholder = "当前默认值: " .. tostring(val)
            else
                inputObj.Placeholder = "当前枪械无此属性"
            end
        else
            inputObj.Placeholder = "请先拿枪"
        end
    end

    updatePlaceholder(inputRefs.Damage, "Damage")
    updatePlaceholder(inputRefs.FireRate, "FireRate")
    updatePlaceholder(inputRefs.MaxAmmo, "MaxAmmo")
    updatePlaceholder(inputRefs.CurrentAmmo, "CurrentAmmo")
    updatePlaceholder(inputRefs.ReloadTime, "ReloadTime")
    updatePlaceholder(inputRefs.Range, "Range")
    updatePlaceholder(inputRefs.AutoFire, "AutoFire")
end

local function createAttributeInput(title, attrName, isBool)
    local input = GunTab:Input({
        Title = title,
        Value = "",
        Placeholder = "请先拿枪",
        Callback = function(text)
            if not modifyEnabled then return end
            if not currentWeapon then return end
            
            if isBool then
                if text == "1" or text:lower() == "true" then
                    currentWeapon:SetAttribute(attrName, true)
                elseif text == "0" or text:lower() == "false" then
                    currentWeapon:SetAttribute(attrName, false)
                end
            else
                local num = tonumber(text)
                if num then
                    currentWeapon:SetAttribute(attrName, num)
                end
            end
        end
    })
    inputRefs[attrName] = input
    return input
end

GunTab:Toggle({
    Title = "开启修改枪械属性",
    Value = false,
    Callback = function(v)
        modifyEnabled = v
        if v then 
            showNotify("枪械修改", "已开启，输入数值即刻生效", false)
            refreshInputPlaceholders()
        else
            showNotify("枪械修改", "已关闭修改", true)
        end
    end
})

GunTab:Divider()

createAttributeInput("伤害 (Damage)", "Damage")
createAttributeInput("射速 (FireRate) - 越小越快", "FireRate")
createAttributeInput("最大弹匣 (MaxAmmo)", "MaxAmmo")
createAttributeInput("当前弹药 (CurrentAmmo)", "CurrentAmmo")
createAttributeInput("换弹时间 (ReloadTime)", "ReloadTime")
createAttributeInput("射程 (Range)", "Range")
createAttributeInput("自动射击 (AutoFire) - 输1开,0关", "AutoFire", true)

local function onCharacterChanged()
    task.wait(0.5)
    refreshInputPlaceholders()
    
    local char = LocalPlayer.Character
    if char then
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.2)
                refreshInputPlaceholders()
                if modifyEnabled then
                    showNotify("检测到新武器", "属性输入框已更新", false)
                end
            end
        end)
        
        char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.1)
                refreshInputPlaceholders()
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(onCharacterChanged)
if LocalPlayer.Character then
    onCharacterChanged()
end

print("[ink_HUB] 加载成功")