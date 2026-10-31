local p = game:GetService("Players")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local tw = game:GetService("TweenService")
local lp = p.LocalPlayer

local pr = pcall(function() 
    local g = Instance.new("ScreenGui", cg)
    g:Destroy()
    return cg 
end) and cg or lp:WaitForChild("PlayerGui")

if pr:FindFirstChild("KillerUI") then pr.KillerUI:Destroy() end

local sg = Instance.new("ScreenGui", pr)
sg.Name = "KillerUI"
sg.DisplayOrder = 999999
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true

local f = Instance.new("Frame", sg)
f.AnchorPoint = Vector2.new(0.5, 0.5)
f.Size = UDim2.fromOffset(280, 240)
f.Position = UDim2.new(0.5, 0, 0.35, 0)
f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
f.BorderSizePixel = 0
f.ClipsDescendants = true

local us = Instance.new("UIScale", f)
local c1 = Instance.new("UICorner", f); c1.CornerRadius = UDim.new(0, 10)
local s1 = Instance.new("UIStroke", f); s1.Color = Color3.fromRGB(60, 60, 60); s1.Transparency = 0.3
local bg = Instance.new("UIGradient", f); bg.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(15, 15, 15)); bg.Rotation = 90

local bar = Instance.new("Frame", f); bar.Size = UDim2.new(1, 0, 0, 36); bar.BackgroundTransparency = 1; bar.ZIndex = 5
local dot = Instance.new("Frame", bar); dot.Size = UDim2.fromOffset(8, 8); dot.Position = UDim2.new(0, 15, 0.5, -4); dot.BackgroundColor3 = Color3.fromRGB(200, 50, 50); dot.ZIndex = 6
local c2 = Instance.new("UICorner", dot); c2.CornerRadius = UDim.new(1, 0)

local title = Instance.new("TextLabel", bar); title.Size = UDim2.new(1, -90, 1, 0); title.Position = UDim2.new(0, 30, 0, 0); title.BackgroundTransparency = 1; title.Text = "警长X杀手辅助"; title.TextColor3 = Color3.fromRGB(220, 220, 220); title.Font = Enum.Font.SourceSansBold; title.TextSize = 16; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 6

local minB = Instance.new("TextButton", bar); minB.Size = UDim2.fromOffset(30, 30); minB.Position = UDim2.new(1, -75, 0.5, -15); minB.BackgroundTransparency = 1; minB.Text = "—"; minB.TextColor3 = Color3.fromRGB(150, 150, 150); minB.Font = Enum.Font.SourceSansBold; minB.TextSize = 18; minB.ZIndex = 6
local clsB = Instance.new("TextButton", bar); clsB.Size = UDim2.fromOffset(30, 30); clsB.Position = UDim2.new(1, -40, 0.5, -15); clsB.BackgroundTransparency = 1; clsB.Text = "×"; clsB.TextColor3 = Color3.fromRGB(150, 150, 150); clsB.Font = Enum.Font.SourceSansBold; clsB.TextSize = 20; clsB.ZIndex = 6

local div = Instance.new("Frame", f); div.Size = UDim2.new(1, -30, 0, 1); div.Position = UDim2.new(0, 15, 0, 36); div.BackgroundColor3 = Color3.fromRGB(50, 50, 50); div.BorderSizePixel = 0; div.ZIndex = 5

local mainElements = {div}

local function createBtn(txt, yPos, color)
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(1, -30, 0, 45); b.Position = UDim2.new(0, 15, 0, yPos); b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.Text = ""; b.AutoButtonColor = false; b.ZIndex = 2
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(60, 60, 60)
    local ic = Instance.new("Frame", b); ic.Size = UDim2.fromOffset(6, 6); ic.Position = UDim2.new(0, 15, 0.5, -3); ic.BackgroundColor3 = Color3.fromRGB(80, 80, 80); ic.ZIndex = 3
    local c3 = Instance.new("UICorner", ic); c3.CornerRadius = UDim.new(1, 0)
    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 30, 0, 0); l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.SourceSansBold; l.TextSize = 15; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 3
    
    b.MouseEnter:Connect(function() tw:Create(b, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play() end)
    b.MouseLeave:Connect(function() tw:Create(b, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play() end)
    
    local isOn = false
    b.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            tw:Create(ic, TweenInfo.new(.2), {BackgroundColor3 = color}):Play()
            tw:Create(l, TweenInfo.new(.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            tw:Create(s, TweenInfo.new(.2), {Transparency = .5, Color = color}):Play()
        else
            tw:Create(ic, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
            tw:Create(l, TweenInfo.new(.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            tw:Create(s, TweenInfo.new(.2), {Transparency = 1, Color = Color3.fromRGB(60, 60, 60)}):Play()
        end
    end)
    
    table.insert(mainElements, b)
    return function() return isOn end
end

local getShootState = createBtn("自动射击 (防友军/墙挡)", 50, Color3.fromRGB(0, 170, 255))
local getThrowState = createBtn("自动飞刀 (防墙挡)", 105, Color3.fromRGB(255, 50, 50))
local getAimState = createBtn("视角自瞄 (防墙挡)", 160, Color3.fromRGB(0, 200, 100))

local wm = Instance.new("TextLabel", f); wm.Size = UDim2.new(1, -40, 0, 20); wm.Position = UDim2.new(0, 15, 1, -30); wm.BackgroundTransparency = 1; wm.Text = "BY.Theinkremains"; wm.TextColor3 = Color3.fromRGB(160, 160, 160); wm.Font = Enum.Font.SourceSansBold; wm.TextSize = 16; wm.TextXAlignment = Enum.TextXAlignment.Left; wm.ZIndex = 10
table.insert(mainElements, wm)

local rez = Instance.new("TextButton", f); rez.Size = UDim2.fromOffset(25, 25); rez.Position = UDim2.new(1, -25, 1, -25); rez.BackgroundTransparency = 1; rez.Text = "◢"; rez.TextColor3 = Color3.fromRGB(150, 150, 150); rez.Font = Enum.Font.SourceSansBold; rez.TextSize = 16; rez.ZIndex = 10
table.insert(mainElements, rez)

local minOn = false
minB.MouseButton1Click:Connect(function()
    minOn = not minOn
    local targetHeight = minOn and 36 or 240
    tw:Create(f, TweenInfo.new(.3, Enum.EasingStyle.Quint), {Size = UDim2.fromOffset(280, targetHeight)}):Play()
    
    for _, el in ipairs(mainElements) do
        el.Visible = not minOn
    end
    
    minB.Text = minOn and "+" or "—"
    title.Text = minOn and "警长X杀手 (已折叠)" or "警长X杀手辅助"
end)

clsB.MouseButton1Click:Connect(function()
    local cx = f.AbsolutePosition.X + f.AbsoluteSize.X / 2
    local cy = f.AbsolutePosition.Y + f.AbsoluteSize.Y / 2
    f.Visible = false
    for i = 1, 40 do
        local shard = Instance.new("Frame", sg)
        shard.AnchorPoint = Vector2.new(0.5, 0.5)
        shard.Position = UDim2.fromOffset(cx, cy)
        local size = math.random(5, 15)
        shard.Size = UDim2.fromOffset(size, size)
        shard.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(60, 60, 60)
        shard.ZIndex = 999
        local corner = Instance.new("UICorner", shard)
        corner.CornerRadius = UDim.new(1, 0)
        local angle = math.rad(math.random(0, 360))
        local distance = math.random(150, 400)
        local targetX = cx + math.cos(angle) * distance
        local targetY = cy + math.sin(angle) * distance
        local rotation = math.random(-360, 360)
        local tweenInfo = TweenInfo.new(math.random(50, 80) / 100, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = tw:Create(shard, tweenInfo, {
            Position = UDim2.fromOffset(targetX, targetY),
            Size = UDim2.fromOffset(0, 0),
            Rotation = rotation,
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function() shard:Destroy() end)
    end
    task.delay(0.8, function() sg:Destroy() end)
end)

local drag, dIn, dSt, sPos
bar.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        drag = true; dSt = i.Position; sPos = f.Position 
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end) 
    end 
end)
bar.InputChanged:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then dIn = i end 
end)
uis.InputChanged:Connect(function(i) 
    if i == dIn and drag then 
        local d = i.Position - dSt
        f.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
    end 
end)

local rezOn, rzSt, scSt
rez.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        rezOn = true; rzSt = i.Position; scSt = us.Scale 
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then rezOn = false end end) 
    end 
end)
uis.InputChanged:Connect(function(i) 
    if rezOn and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
        local d = i.Position - rzSt
        us.Scale = math.clamp(scSt + (d.X + d.Y) / 400, 0.5, 1.6)
    end 
end)

local throwCooldown = 2.0 
local lastThrowTime = 0
local silentFireCooldown = 0.25
local lastSilentFireTime = 0

local function hasTool(plr, toolName)
    if not plr or not plr.Character then return false end
    local bp = plr:FindFirstChild("Backpack") or plr.Character:FindFirstChildOfClass("Backpack")
    return (bp and bp:FindFirstChild(toolName)) or plr.Character:FindFirstChild(toolName) ~= nil
end

local function isLineClear(origin, targetPos, ignore1, ignore2)
    local dir = targetPos - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {ignore1, ignore2}
    local result = workspace:Raycast(origin, dir, params)
    return result == nil
end

rs.Heartbeat:Connect(function()
    if not getShootState() then return end
    if tick() - lastSilentFireTime < silentFireCooldown then return end
    
    local char = lp.Character
    local gun = char and char:FindFirstChild("Gun")
    if not gun or not gun:FindFirstChild("Shoot") then return end

    local camera = workspace.CurrentCamera
    local centerPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closestTarget, minDist, targetHead = nil, math.huge, nil
    
    for _, plr in ipairs(p:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Head") then
            if hasTool(plr, "Knife") then
                local head = plr.Character.Head
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen and screenPos.Z > 0 then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerPos).Magnitude
                    if dist <= 300 and dist < minDist then
                        if isLineClear(camera.CFrame.Position, head.Position, char, plr.Character) then
                            minDist = dist
                            closestTarget = plr
                            targetHead = head
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
        pcall(function() gun.Shoot:FireServer(fakeCamCFrame, CFrame.new(targetPos)) end)
        lastSilentFireTime = tick()
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if getThrowState() and tick() - lastThrowTime >= throwCooldown then
            local char = lp.Character
            local knife = char and char:FindFirstChild("Knife")
            local knifeEvent = knife and knife:FindFirstChild("Events") and knife.Events:FindFirstChild("KnifeThrown")
            
            if knifeEvent then
                local closestTarget = nil
                local minDist = math.huge
                for _, plr in ipairs(p:GetPlayers()) do
                    if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Head") then
                        if not hasTool(plr, "Knife") then
                            local targetHead = plr.Character.Head
                            local dist = (char.Head.Position - targetHead.Position).Magnitude
                            if dist < minDist then
                                if isLineClear(char.Head.Position, targetHead.Position, char, plr.Character) then
                                    minDist = dist
                                    closestTarget = plr
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
                end
            end
        end
    end
end)

rs.Heartbeat:Connect(function()
    if not getAimState() then return end
    local char = lp.Character
    if not char or not char:FindFirstChild("Head") then return end
    
    local camera = workspace.CurrentCamera
    local centerPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closestTarget, minDist = nil, 250
    
    for _, plr in ipairs(p:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen and screenPos.Z > 0 then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerPos).Magnitude
                if dist <= 250 and dist < minDist then
                    if isLineClear(camera.CFrame.Position, head.Position, char, plr.Character) then
                        minDist = dist
                        closestTarget = head
                    end
                end
            end
        end
    end
    
    if closestTarget then
        camera.CFrame = CFrame.new(camera.CFrame.Position, closestTarget.Position)
    end
end)