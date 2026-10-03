-- 皮飞车 / 独立 UI 新版
-- 不使用 WindUI，使用 Roblox 原生实例创建独立界面
-- 保留：飞车开关、速度、前进、后退、停止、关闭清理

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

-- ==================== 飞车功能 ====================

local flyEnabled = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil

local function getRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function cleanupFly()
    flyEnabled = false

    if flyConnection then
        pcall(function() flyConnection:Disconnect() end)
        flyConnection = nil
    end

    local root = getRoot()
    if root then
        if bodyVelocity and bodyVelocity.Parent == root then
            pcall(function() bodyVelocity:Destroy() end)
        else
            local bv = root:FindFirstChild("inkHUB_FlyVelocity")
            if bv then pcall(function() bv:Destroy() end) end
        end

        if bodyGyro and bodyGyro.Parent == root then
            pcall(function() bodyGyro:Destroy() end)
        else
            local bg = root:FindFirstChild("inkHUB_FlyGyro")
            if bg then pcall(function() bg:Destroy() end) end
        end
    end

    bodyVelocity = nil
    bodyGyro = nil
end

local function startFly()
    cleanupFly()
    flyEnabled = true

    local root = getRoot()
    if not root then
        flyEnabled = false
        notify("皮飞车", "没有找到角色身体，请重新生成角色后再试。", 3)
        return
    end

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "inkHUB_FlyVelocity"
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "inkHUB_FlyGyro"
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.D = 5000
    bodyGyro.P = 100000
    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    bodyGyro.Parent = root

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled then return end

        local currentRoot = getRoot()
        if not currentRoot or not bodyVelocity or not bodyVelocity.Parent or not bodyGyro or not bodyGyro.Parent then
            return
        end

        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end)
end

local function setFlyVelocity(direction)
    if not flyEnabled or not bodyVelocity or not bodyVelocity.Parent then
        notify("皮飞车", "请先开启飞车。", 2)
        return
    end

    local camera = workspace.CurrentCamera
    local root = getRoot()
    if not camera or not root then return end

    bodyVelocity.Velocity = camera.CFrame.LookVector * flySpeed * direction

    task.delay(0.9, function()
        if flyEnabled and bodyVelocity and bodyVelocity.Parent then
            bodyVelocity.Velocity = Vector3.zero
        end
    end)
end

-- ==================== 独立 UI ====================

pcall(function()
    local old = CoreGui:FindFirstChild("PiFeiChe_IndependentUI")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "PiFeiChe_IndependentUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(330, 400)
main.Position = UDim2.new(0.5, -165, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
main.BackgroundTransparency = 0.06
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

-- 动态银灰边框
local border = Instance.new("UIStroke")
border.Name = "DynamicSilverBorder"
border.Thickness = 2
border.Color = Color3.fromRGB(160, 160, 160)
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
border.Parent = main

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180,180,180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120,120,120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,180))
})
borderGradient.Parent = border

task.spawn(function()
    while main.Parent and border.Parent do
        borderGradient.Rotation = (borderGradient.Rotation + 1.2) % 360
        RunService.RenderStepped:Wait()
    end
end)

-- 顶部装饰线
local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, -34, 0, 1)
topLine.Position = UDim2.new(0, 17, 0, 58)
topLine.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
topLine.BorderSizePixel = 0
topLine.Parent = main

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -70, 0, 36)
title.Position = UDim2.fromOffset(18, 10)
title.Font = Enum.Font.GothamBold
title.Text = "皮飞车"
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(1, -70, 0, 20)
subtitle.Position = UDim2.fromOffset(19, 35)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "FLY CONTROL"
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextColor3 = Color3.fromRGB(130, 130, 130)
subtitle.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -46, 0, 12)
close.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
close.Text = "×"
close.TextSize = 22
close.Font = Enum.Font.GothamMedium
close.TextColor3 = Color3.fromRGB(190, 190, 190)
close.AutoButtonColor = true
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = close

local function makeButton(text, y, height)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -36, 0, height or 42)
    b.Position = UDim2.fromOffset(18, y)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 39)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextSize = 14
    b.Font = Enum.Font.GothamMedium
    b.TextColor3 = Color3.fromRGB(215, 215, 215)
    b.AutoButtonColor = true
    b.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = b

    local s = Instance.new("UIStroke")
    s.Thickness = 1
    s.Transparency = 0.55
    s.Color = Color3.fromRGB(100,100,100)
    s.Parent = b

    return b
end

local flyToggle = makeButton("飞车：关闭", 76, 42)

local speedText = Instance.new("TextLabel")
speedText.BackgroundTransparency = 1
speedText.Size = UDim2.new(1, -36, 0, 24)
speedText.Position = UDim2.fromOffset(18, 128)
speedText.Font = Enum.Font.GothamMedium
speedText.Text = "飞车速度：50"
speedText.TextSize = 13
speedText.TextXAlignment = Enum.TextXAlignment.Left
speedText.TextColor3 = Color3.fromRGB(190,190,190)
speedText.Parent = main

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(1, -36, 0, 6)
sliderBack.Position = UDim2.fromOffset(18, 157)
sliderBack.BackgroundColor3 = Color3.fromRGB(55,55,60)
sliderBack.BorderSizePixel = 0
sliderBack.Parent = main

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1,0)
sliderCorner.Parent = sliderBack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(flySpeed / 500, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(165,165,165)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1,0)
fillCorner.Parent = sliderFill

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.fromOffset(20,20)
sliderButton.AnchorPoint = Vector2.new(0.5,0.5)
sliderButton.Position = UDim2.new(flySpeed / 500,0,0.5,0)
sliderButton.BackgroundColor3 = Color3.fromRGB(210,210,210)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderBack

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(1,0)
sliderButtonCorner.Parent = sliderButton

local draggingSlider = false

local function setSpeedFromX(x)
    local ratio = math.clamp((x - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
    flySpeed = math.max(1, math.floor(ratio * 499 + 1))
    speedText.Text = "飞车速度：" .. flySpeed
    sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    sliderButton.Position = UDim2.new(ratio, 0, 0.5, 0)
end

sliderButton.MouseButton1Down:Connect(function()
    draggingSlider = true
end)

sliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
        setSpeedFromX(input.Position.X)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        setSpeedFromX(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

local forward = makeButton("↑  向前飞", 180, 42)
local backward = makeButton("↓  向后飞", 228, 42)
local stop = makeButton("■  停止移动", 276, 42)

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, -36, 0, 20)
status.Position = UDim2.fromOffset(18, 328)
status.Font = Enum.Font.Gotham
status.Text = "状态：待机"
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = Color3.fromRGB(125,125,125)
status.Parent = main

-- 拖动窗口
local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

flyToggle.MouseButton1Click:Connect(function()
    if flyEnabled then
        cleanupFly()
        flyToggle.Text = "飞车：关闭"
        status.Text = "状态：已关闭"
    else
        startFly()
        if flyEnabled then
            flyToggle.Text = "飞车：开启"
            status.Text = "状态：飞车中"
        end
    end
end)

forward.MouseButton1Click:Connect(function()
    setFlyVelocity(1)
    if flyEnabled then status.Text = "状态：向前飞行" end
end)

backward.MouseButton1Click:Connect(function()
    setFlyVelocity(-1)
    if flyEnabled then status.Text = "状态：向后飞行" end
end)

stop.MouseButton1Click:Connect(function()
    if bodyVelocity and bodyVelocity.Parent then
        bodyVelocity.Velocity = Vector3.zero
    end
    if flyEnabled then status.Text = "状态：已停止移动" end
end)

close.MouseButton1Click:Connect(function()
    cleanupFly()
    gui:Destroy()
end)

LocalPlayer.CharacterAdded:Connect(function()
    cleanupFly()
    if flyToggle.Parent then
        flyToggle.Text = "飞车：关闭"
        status.Text = "状态：角色已重置"
    end
end)

notify("皮飞车", "独立 UI 加载成功", 3)
