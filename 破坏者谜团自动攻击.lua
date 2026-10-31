local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local guiParent = CoreGui
local ok, parent = pcall(function()
    local test = Instance.new("ScreenGui")
    test.Parent = CoreGui
    test:Destroy()
    return CoreGui
end)
if not ok then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

local oldGui = guiParent:FindFirstChild("KillerTools_ProUI")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillerTools_ProUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = guiParent

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.fromOffset(280, 250)
mainFrame.Position = UDim2.new(0.5, -140, 0.3, 0) 
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 60)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
})
bgGrad.Rotation = 90
bgGrad.Parent = mainFrame

local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 36)
dragBar.BackgroundTransparency = 1
dragBar.Parent = mainFrame

local titleDot = Instance.new("Frame")
titleDot.Size = UDim2.fromOffset(8, 8)
titleDot.Position = UDim2.new(0, 15, 0.5, -4)
titleDot.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
titleDot.Parent = dragBar
Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Position = UDim2.new(0, 30, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "极限双修系统"
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = dragBar

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -30, 0, 1)
divider.Position = UDim2.new(0, 15, 0, 36)
divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
divider.BorderSizePixel = 0
divider.Parent = mainFrame

local function createProButton(text, yPos, iconColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 45)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    
    local icon = Instance.new("Frame", btn)
    icon.Size = UDim2.fromOffset(6, 6)
    icon.Position = UDim2.new(0, 15, 0.5, -3)
    icon.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    icon.Parent = btn
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
    
    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)
    
    local state = false
    local function setState(newState)
        state = newState
        if state then
            TweenService:Create(icon, TweenInfo.new(0.2), {BackgroundColor3 = iconColor}):Play()
            TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.5, Color = iconColor}):Play()
        else
            TweenService:Create(icon, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
            TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 1, Color = Color3.fromRGB(60, 60, 60)}):Play()
        end
    end
    
    btn.MouseButton1Click:Connect(function() setState(not state) end)
    return function() return state end
end

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 0, 20)
statusLabel.Position = UDim2.new(0, 15, 0, 220)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "等待操作..."
statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = mainFrame

local getThrowState = createProButton("自动飞刀 (防墙挡)", 50, Color3.fromRGB(0, 170, 255))
local getShootState = createProButton("自动射击 (防友军/墙挡)", 105, Color3.fromRGB(255, 50, 50))
local getAimState = createProButton("视角自瞄 (通用)", 160, Color3.fromRGB(0, 200, 100))

local throwCooldown = 2.0 
local lastThrowTime = 0
local silentFireCooldown = 0.25
local lastSilentFireTime = 0

local function hasTool(p, toolName)
    if not p or not p.Character then return false end
    local bp = p:FindFirstChild("Backpack") or p.Character:FindFirstChildOfClass("Backpack")
    return (bp and bp:FindFirstChild(toolName)) or p.Character:FindFirstChild(toolName) ~= nil
end

local function isLineClear(origin, targetPos, ignore1, ignore2)
    local dir = targetPos - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {ignore1, ignore2}
    
    local result = workspace:Raycast(origin, dir, params)
    if result then
        return false, result.Instance.Parent and Players:GetPlayerFromCharacter(result.Instance.Parent)
    end
    return true, nil
end

task.spawn(function()
    while task.wait(0.1) do
        if getThrowState() and tick() - lastThrowTime >= throwCooldown then
            local char = LocalPlayer.Character
            local knife = char and char:FindFirstChild("Knife")
            local knifeEvent = knife and knife:FindFirstChild("Events") and knife.Events:FindFirstChild("KnifeThrown")
            
            if knifeEvent then
                local closestTarget = nil
                local minDist = math.huge
                
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        if not hasTool(p, "Knife") then
                            local targetHead = p.Character.Head
                            local dist = (char.Head.Position - targetHead.Position).Magnitude
                            
                            if dist < minDist then
                                local isClear = isLineClear(char.Head.Position, targetHead.Position, char, p.Character)
                                if isClear then
                                    minDist = dist
                                    closestTarget = p
                                end
                            end
                        end
                    end
                end
                
                if closestTarget then
                    local targetPos = closestTarget.Character.Head.Position
                    local camera = workspace.CurrentCamera
                    local originalCFrame = camera.CFrame
                    camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPos)
                    task.wait(0.05)
                    pcall(function() knifeEvent:FireServer(camera.CFrame, CFrame.new(targetPos)) end)
                    camera.CFrame = originalCFrame
                    lastThrowTime = tick()
                    statusLabel.Text = "飞刀命中: " .. closestTarget.Name
                    statusLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not getShootState() then return end
    if tick() - lastSilentFireTime < silentFireCooldown then return end
    
    local char = LocalPlayer.Character
    local gun = char and char:FindFirstChild("Gun")
    if not gun or not gun:FindFirstChild("Shoot") then return end

    local camera = workspace.CurrentCamera
    local centerPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closestTarget, minDist, targetHead = nil, math.huge, nil
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if hasTool(p, "Knife") then
                local head = p.Character.Head
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen and screenPos.Z > 0 then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerPos).Magnitude
                    if dist <= 300 and dist < minDist then
                        local isClear, hitPlayer = isLineClear(camera.CFrame.Position, head.Position, char, p.Character)
                        if isClear then
                            minDist = dist
                                  closestTarget = p
                            targetHead = head
                        elseif hitPlayer and not hasTool(hitPlayer, "Knife") then
                            statusLabel.Text = "被 " .. hitPlayer.Name .. " 阻挡"
                            statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                        end
                    end
                end
            end
        end
    end
    
    if closestTarget and targetHead then
        local targetPos = targetHead.Position
        local fakeCamCFrame = CFrame.lookAt(camera.CFrame.Position, targetPos)
        pcall(function() gun:Activate() end)
        pcall(function() gun:Shoot:FireServer(fakeCamCFrame, CFrame.new(targetPos)) end)
        lastSilentFireTime = tick()
        statusLabel.Text = "开火命中: " .. closestTarget.Name
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

RunService.Heartbeat:Connect(function()
    if not getAimState() then return end
    
    local camera = workspace.CurrentCamera
    local centerPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closestTarget, minDist = nil, 250
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen and screenPos.Z > 0 then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerPos).Magnitude
                if dist <= 250 and dist < minDist then
                    minDist = dist
                    closestTarget = head
                end
            end
        end
    end
    
    if closestTarget then
        camera.CFrame = CFrame.new(camera.CFrame.Position, closestTarget.Position)
    end
end)

local dragging, dragInput, dragStart, startPos
dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("[极限双修系统] 加载完成。")