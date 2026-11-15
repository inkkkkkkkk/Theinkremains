local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

local function c(cl, p, par)
    local o = Instance.new(cl)
    for k, v in pairs(p) do o[k] = v end
    if par then o.Parent = par end
    return o
end

local BG = Color3.fromRGB(10, 10, 12)
local PNL = Color3.fromRGB(16, 16, 18)
local BTN = Color3.fromRGB(30, 30, 35)
local BTN_HOVER = Color3.fromRGB(45, 45, 50)
local BTN_DOWN = Color3.fromRGB(20, 20, 25)
local RED = Color3.fromRGB(200, 10, 30)
local WHT = Color3.fromRGB(255, 255, 255)
local TXT = Color3.fromRGB(255, 255, 255)
local DIM = Color3.fromRGB(150, 150, 150)

local BootGui = c("ScreenGui", {Parent = pgui, IgnoreGuiInset = true, DisplayOrder = 999}, nil)
local MainBG = c("Frame", {BackgroundColor3 = Color3.fromRGB(3, 3, 3), Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0}, BootGui)
local Center = c("Frame", {BackgroundTransparency = 1, Size = UDim2.new(0, 200, 0, 200), Position = UDim2.new(0.5, 0, 0.5, -20), AnchorPoint = Vector2.new(0.5, 0.5)}, MainBG)

local Spikes = {}
for i = 1, 4 do
    table.insert(Spikes, c("Frame", {BackgroundColor3 = RED, Size = UDim2.new(0, 2, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), Rotation = 45 + (i-1) * 90, BackgroundTransparency = 1}, Center))
end
local Core = c("Frame", {BackgroundColor3 = WHT, Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1}, Center)
c("UICorner", {CornerRadius = UDim.new(1,0)}, Core)

local TxtBox = c("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 80), Position = UDim2.new(0, 0, 0.5, 110), AnchorPoint = Vector2.new(0, 0.5)}, Center)
local T1 = c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Font = Enum.Font.GothamBlack, Text = "", TextColor3 = WHT, TextSize = 28}, TxtBox)
local T2 = c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Font = Enum.Font.GothamBlack, Text = "", TextColor3 = RED, TextSize = 28, TextTransparency = 1}, TxtBox)
local T3 = c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 45), Font = Enum.Font.Code, Text = "BY.Rebzyyx/Rezlaine", TextColor3 = RED, TextSize = 13, TextTransparency = 1}, TxtBox)

local MainGui = c("ScreenGui", {Parent = pgui, ResetOnSpawn = false}, nil)
local Main = c("Frame", {BackgroundColor3 = BG, Position = UDim2.new(0.5, 0, 1.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 500, 0, 360), ClipsDescendants = true, BorderSizePixel = 0, ZIndex = 1}, MainGui)
c("UICorner", {CornerRadius = UDim.new(0, 10)}, Main)
c("UIStroke", {Color = RED, Thickness = 2, Transparency = 0.1}, Main)

local UIScale = c("UIScale", {Scale = 1}, Main)

local Top = c("Frame", {BackgroundColor3 = PNL, Size = UDim2.new(1, 0, 0, 45), BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 5}, Main)
c("UICorner", {CornerRadius = UDim.new(0, 10)}, Top)

local RedLine = c("Frame", {Name = "RedLine", BackgroundColor3 = RED, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BorderSizePixel = 0, ZIndex = 5}, Top)

c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(0, 150, 1, 0), Position = UDim2.new(0, 15, 0, 0), Font = Enum.Font.GothamBlack, Text = "REBZYYX", TextColor3 = TXT, TextSize = 24, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6}, Top)
c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(0, 150, 1, 0), Position = UDim2.new(0, 140, 0, 0), Font = Enum.Font.GothamBold, Text = "F3Xgui V67", TextColor3 = RED, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6}, Top)

local Close = c("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(0, 35, 1, 0), Position = UDim2.new(1, -35, 0, 0), Text = "×", TextColor3 = TXT, TextSize = 24, Font = Enum.Font.GothamBold, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 10}, Top)
Close.MouseEnter:Connect(function() Close.TextColor3 = RED end)
Close.MouseLeave:Connect(function() Close.TextColor3 = TXT end)

local Min = c("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(0, 35, 1, 0), Position = UDim2.new(1, -70, 0, 0), Text = "—", TextColor3 = TXT, TextSize = 16, Font = Enum.Font.GothamBold, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 10}, Top)
Min.MouseEnter:Connect(function() Min.TextColor3 = RED end)
Min.MouseLeave:Connect(function() Min.TextColor3 = TXT end)

local Side = c("Frame", {BackgroundColor3 = PNL, Position = UDim2.new(0, 0, 0, 45), Size = UDim2.new(0, 120, 1, -45), BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2}, Main)
c("UICorner", {CornerRadius = UDim.new(0, 10)}, Side)
c("Frame", {BackgroundColor3 = BG, Position = UDim2.new(1, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0), BorderSizePixel = 0, ZIndex = 2}, Side)

local Cont = c("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0, 130, 0, 60), Size = UDim2.new(0, 350, 0, 290), BorderSizePixel = 0, ZIndex = 2}, Main)

local Ind = c("Frame", {BackgroundColor3 = RED, Position = UDim2.new(0, 5, 0, 29), Size = UDim2.new(0, 3, 0, 22), BorderSizePixel = 0, ZIndex = 3}, Side)
c("UICorner", {CornerRadius = UDim.new(1, 0)}, Ind)

local NB = {}
local function mNB(t, y)
    local b = c("TextButton", {BackgroundTransparency = 1, Position = UDim2.new(0, 20, 0, y), Size = UDim2.new(0, 100, 0, 40), Font = Enum.Font.GothamBold, Text = t, TextColor3 = DIM, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, ZIndex = 3}, Side)
    b.MouseEnter:Connect(function() if b.TextColor3 == DIM then b.TextColor3 = WHT end end)
    b.MouseLeave:Connect(function() if b.TextColor3 == WHT then b.TextColor3 = DIM end end)
    table.insert(NB, b)
    return b
end

local Home = c("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, ZIndex = 2}, Cont)
local P2 = c("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, BorderSizePixel = 0, ZIndex = 2, ScrollBarThickness = 3, ScrollBarImageColor3 = RED, CanvasSize = UDim2.new(0,0,0,0)}, Cont)
local P3 = c("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, BorderSizePixel = 0, ZIndex = 2, ScrollBarThickness = 3, ScrollBarImageColor3 = RED, CanvasSize = UDim2.new(0,0,0,0)}, Cont)
local P4 = c("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, BorderSizePixel = 0, ZIndex = 2, ScrollBarThickness = 3, ScrollBarImageColor3 = RED, CanvasSize = UDim2.new(0,0,0,0)}, Cont)
local P = {Home, P2, P3, P4}

local NH, N1, N2, N3 = mNB("家", 20), mNB("基础", 70), mNB("音乐", 120), mNB("其它", 170)
local function setP(i)
    for j, p in ipairs(P) do p.Visible = (j == i) end
    TweenService:Create(Ind, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 5, 0, 29 + (i - 1) * 50)}):Play()
    for j, b in ipairs(NB) do b.TextColor3 = (j == i) and TXT or DIM end
end

NH.MouseButton1Down:Connect(function() setP(1) end)
N1.MouseButton1Down:Connect(function() setP(2) end)
N2.MouseButton1Down:Connect(function() setP(3) end)
N3.MouseButton1Down:Connect(function() setP(4) end)
setP(1)

local function mBtn(par, t, pos, callback)
    local b = c("TextButton", {BackgroundColor3 = BTN, BorderSizePixel = 0, Position = pos, Size = UDim2.new(0, 105, 0, 38), Font = Enum.Font.GothamMedium, Text = t, TextColor3 = TXT, TextSize = 13, AutoButtonColor = false, ZIndex = 3}, par)
    c("UICorner", {CornerRadius = UDim.new(0, 8)}, b)
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = BTN_HOVER}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = BTN}):Play() end)
    b.MouseButton1Down:Connect(function() TweenService:Create(b, TweenInfo.new(0.05), {BackgroundColor3 = BTN_DOWN}):Play() end)
    b.MouseButton1Up:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = BTN_HOVER}):Play() end)
    if callback then b.MouseButton1Click:Connect(callback) end
end

local function pop(par, list)
    for i, n in ipairs(list) do 
        mBtn(par, n[1], UDim2.new(0, ((i - 1) % 3) * 115, 0, math.floor((i - 1) / 3) * 48), n[2]) 
    end
    if par:IsA("ScrollingFrame") then
        local rows = math.ceil(#list / 3)
        par.CanvasSize = UDim2.new(0, 0, 0, rows * 48)
    end
end

local Prof = c("Frame", {BackgroundColor3 = BTN, Size = UDim2.new(1, 0, 0, 80), Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0}, Home)
c("UICorner", {CornerRadius = UDim.new(0, 8)}, Prof)

local AF = c("Frame", {BackgroundColor3 = PNL, Size = UDim2.new(0, 64, 0, 64), Position = UDim2.new(0, 8, 0, 8), BorderSizePixel = 0, ClipsDescendants = true}, Prof)
c("UICorner", {CornerRadius = UDim.new(1, 0)}, AF)
c("UIStroke", {Color = RED, Thickness = 2}, AF)
local Img = c("ImageLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Image = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"}, AF)
c("UICorner", {CornerRadius = UDim.new(1, 0)}, Img)

c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(0, 250, 0, 25), Position = UDim2.new(0, 85, 0, 10), Font = Enum.Font.GothamBlack, Text = player.DisplayName, TextColor3 = TXT, TextSize = 22, TextXAlignment = Enum.TextXAlignment.Left}, Prof)
c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(0, 250, 0, 15), Position = UDim2.new(0, 85, 0, 35), Font = Enum.Font.GothamMedium, Text = "@"..player.Name, TextColor3 = DIM, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left}, Prof)
c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(0, 250, 0, 15), Position = UDim2.new(0, 85, 0, 55), Font = Enum.Font.Code, Text = "ID: "..player.UserId, TextColor3 = RED, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Prof)

local Stats = c("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 60), Position = UDim2.new(0, 0, 0, 90)}, Home)
local function mkStat(x, title)
    local b = c("Frame", {BackgroundColor3 = BTN, Size = UDim2.new(0, 110, 0, 50), Position = UDim2.new(0, x, 0, 0), BorderSizePixel = 0}, Stats)
    c("UICorner", {CornerRadius = UDim.new(0, 8)}, b)
    c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 5), Font = Enum.Font.GothamMedium, Text = title, TextColor3 = DIM, TextSize = 12}, b)
    return c("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 0, 0, 20), Font = Enum.Font.GothamBlack, Text = "...", TextColor3 = TXT, TextSize = 16}, b)
end

local txtPing = mkStat(0, "延迟")
local txtFps = mkStat(120, "帧率")
local txtAge = mkStat(240, "注册天数")
txtAge.Text = tostring(player.AccountAge)

task.spawn(function()
    local frames = 0
    local lastTime = tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - lastTime >= 1 then
            txtFps.Text = tostring(math.floor(frames / (now - lastTime))).." FPS"
            txtPing.Text = tostring(math.floor(player:GetNetworkPing() * 1000)).." ms"
            frames = 0
            lastTime = now
        end
    end)
end)

c("ImageLabel", {
    BackgroundTransparency = 1, 
    Size = UDim2.new(1, 0, 1, -155), 
    Position = UDim2.new(0, 0, 0, 155), 
    Image = "rbxassetid://95719226713148",
    ScaleType = Enum.ScaleType.Stretch
}, Home)

local function playMusic(id, pitch)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local hdClient = ReplicatedStorage:FindFirstChild("HDAdminHDClient")
    if hdClient then
        hdClient.Signals.RequestCommandSilent:InvokeServer(";music "..id.." ;pitch "..(pitch or 1).." ;volume inf")
    else
        print("未找到 HD Admin 客户端，无法播放音乐。")
    end
end

local MusicList = {
    {"主题1", function() playMusic("86412047196482", 1.1) end},
    {"主题2", function() playMusic("76578817848504", 1) end},
    {"主题3", function() playMusic("71123357599630", 1) end},
    {"jumpstyle", function() playMusic("1839246711", 1) end},
    {"1x1", function() playMusic("139488665764275", 1.1) end},
    {"真主", function() playMusic("85390427326662", 0.15) end},
    {"jumpDance", function() playMusic("1839246879", 1) end},
    {"unhappy", function() playMusic("88523902860927", 1) end},
    {"g00by", function() playMusic("1847661821", 1) end},
    {"c00kidd", function() playMusic("95156028272944", 0.2) end},
    {"idk", function() playMusic("104497567166761", 0.25) end},
    {"马里奥", function() playMusic("99907604701668", 0.128) end},
    {"SpartaRemix", function() playMusic("73293994328169", 0.13) end},
    {"jjee", function() playMusic("121917421105212", 0.15) end},
    {"谁如此自主", function() playMusic("120785124326826", 0.9) end},
    {"18 Мне Уже", function() playMusic("87744462419495", 0.13) end},
    {"叙利亚", function() playMusic("136356992500400", 0.25) end},
    {"i love you so", function() playMusic("100048144167699", 1) end},
    {"感觉我根本不在这里", function() playMusic("83707813531588", 1) end},
    {"jason", function() playMusic("87789875437291", 1) end},
    {"停止音乐", function() 
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local hdClient = ReplicatedStorage:FindFirstChild("HDAdminHDClient")
        if hdClient then hdClient.Signals.RequestCommandSilent:InvokeServer(";unmusic") end
    end}
}

local function getRemote()
    local tool
    for _, v in pairs(player:GetDescendants()) do
        if v.Name == "SyncAPI" and v.Parent:FindFirstChild("Tools") and not v.Parent:FindFirstChild("Tools"):FindFirstChild("Marketplace") then
            tool = v.Parent
        end
    end
    if not tool then
        for _, v in pairs(player:GetDescendants()) do
            if v.Name == "SyncAPI" then tool = v.Parent end
        end
    end
    if tool and tool:FindFirstChild("SyncAPI") then
        return tool.SyncAPI.ServerEndpoint
    end
    return nil
end

local function syncInvoke(...)
    local remote = getRemote()
    if remote then
        return remote:InvokeServer(...)
    end
end

local skyPart = nil
local discoConn, spinConn = nil, nil
local vertexVal = 4 
local spinSpeed = 4 
local rotX, rotY, rotZ = 0, 0, 0
local lastServerSync = 0
local SERVER_SYNC_RATE = 0.05

local function DestroySky()
    if discoConn then discoConn:Disconnect() discoConn = nil end
    if spinConn then spinConn:Disconnect() spinConn = nil end
    if skyPart then
        syncInvoke("Remove", {skyPart})
        skyPart = nil
    end
end

local function CreateSky(imageId)
    DestroySky()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local fixedPos = hrp.CFrame.Position + Vector3.new(0, 10, 0)
    local cf = CFrame.new(fixedPos)
    
    local createdPart = syncInvoke("CreatePart", "Normal", cf, workspace)
    if createdPart then
        skyPart = createdPart
    end

    if not skyPart then
        print("生成天空盒失败，请确保你拿着 F3X 工具")
        return
    end

    syncInvoke("SyncAnchor", {{Part = skyPart, Anchored = true}})
    syncInvoke("SyncCollision", {{Part = skyPart, CanCollide = false}})
    syncInvoke("SyncTransparency", {{Part = skyPart, Transparency = 0}})
    syncInvoke("CreateMeshes", {{Part = skyPart}})
    task.wait(0.05)

    syncInvoke("SyncMesh", {{
        Part = skyPart,
        MeshType = Enum.MeshType.FileMesh,
        MeshId = "rbxassetid://111891702759441",
        TextureId = "rbxassetid://" .. imageId,
        Scale = Vector3.new(4000, 4000, 4000), 
        VertexColor = Vector3.new(vertexVal, vertexVal, vertexVal)
    }})

    local hue = 0
    discoConn = RunService.RenderStepped:Connect(function(dt)
        if not skyPart or not skyPart.Parent then return end
        hue = (hue + (dt * 0.3)) % 1 
        local color = Color3.fromHSV(hue, 1, 1)
        local vColor = Vector3.new(color.R * vertexVal, color.G * vertexVal, color.B * vertexVal)
        syncInvoke("SyncMesh", {{Part = skyPart, VertexColor = vColor}})
    end)

    spinConn = RunService.RenderStepped:Connect(function(dt)
        if not skyPart or not skyPart.Parent then return end
        
        rotX = (rotX + (spinSpeed * dt * 14)) % 360
        rotY = (rotY + (spinSpeed * dt * 22)) % 360
        rotZ = (rotZ + (spinSpeed * dt * 18)) % 360

        local rotationCFrame = CFrame.Angles(math.rad(rotX), math.rad(rotY), math.rad(rotZ))
        local newCFrame = CFrame.new(fixedPos) * rotationCFrame

        skyPart.CFrame = newCFrame

        lastServerSync = lastServerSync + dt
        if lastServerSync >= SERVER_SYNC_RATE then
            lastServerSync = 0
            syncInvoke("SyncRotate", {{Part = skyPart, CFrame = newCFrame}})
        end
    end)
end

local function SpamDecal(texId)
    local r = getRemote()
    if not r then return end
    
    local parts = {}
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "Sky" and v.Name ~= "Skybox" then
            table.insert(parts, v)
        end
    end
    local total = #parts
    local batchSize = 20
    local faces = {Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Right, Enum.NormalId.Left, Enum.NormalId.Bottom, Enum.NormalId.Top}
    
    task.spawn(function()
        for i = 1, total, batchSize do
            local threads = {}
            for j = i, math.min(i + batchSize - 1, total) do
                local part = parts[j]
                if part and part.Parent then
                    table.insert(threads, task.spawn(function()
                        pcall(function()
                            r:InvokeServer("SetLocked", {part}, false)
                            for _, face in ipairs(faces) do
                                r:InvokeServer("CreateTextures", {{Part=part,Face=face,TextureType="Decal"}})
                                r:InvokeServer("SyncTexture", {{Part=part,Face=face,TextureType="Decal",Texture="rbxassetid://"..texId}})
                            end
                        end)
                    end))
                end
            end
            task.wait(0.1)
        end
    end)
end

local function CancelDecal()
    local r = getRemote()
    if not r then return end
    
    task.spawn(function()
        local decals = {}
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Decal") then table.insert(decals, v) end
        end
        local total = #decals
        local batchSize = 20
        
        for i = 1, total, batchSize do
            local threads = {}
            for j = i, math.min(i + batchSize - 1, total) do
                local decal = decals[j]
                if decal and decal.Parent then
                    table.insert(threads, task.spawn(function()
                        pcall(function() r:InvokeServer("Remove", {decal}) end)
                    end))
                end
            end
            task.wait(0.1)
        end
    end)
end

local lastCmdTime = 0
local function SendCmd(cmd)
    if tick() - lastCmdTime < 3 then return end
    lastCmdTime = tick()
    
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local hdClient = ReplicatedStorage:FindFirstChild("HDAdminHDClient")
    if hdClient and hdClient:FindFirstChild("Signals") then
        local remote = hdClient.Signals:FindFirstChild("RequestCommandSilent") or hdClient.Signals:FindFirstChild("RequestCommand")
        if remote then
            pcall(function()
                remote:InvokeServer(cmd)
            end)
        end
    end
end

local isStormRunning = false
local isRiseRunning = false

local function StartFalling(texId)
    isStormRunning = false
    isRiseRunning = false
    task.wait(0.1)
    isStormRunning = true
    local r = getRemote()
    if not r then return end
    task.spawn(function()
        while isStormRunning do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then break end
            for i = 1, 2 do
                task.spawn(function()
                    local randomX = math.random(-400, 400)
                    local randomZ = math.random(-400, 400)
                    local randomY = math.random(-30, 30)
                    local spawnPos = hrp.CFrame.Position + Vector3.new(randomX, randomY, randomZ)
                    local cf = CFrame.new(spawnPos)
                    local p = r:InvokeServer("CreatePart", "Normal", cf, workspace)
                    if p then
                        r:InvokeServer("SetName", {p}, "F3xParticle_Fall")
                        r:InvokeServer("SyncResize", {{Part=p, CFrame=cf, Size=Vector3.new(15, 15, 0.2)}})
                        r:InvokeServer("SyncCollision", {{Part=p, CanCollide=false}})
                        r:InvokeServer("SetLocked", {p}, true)
                        r:InvokeServer("CreateTextures", {{Part=p, Face=Enum.NormalId.Front, TextureType="Decal"}})
                        r:InvokeServer("SyncTexture", {{Part=p, Face=Enum.NormalId.Front, TextureType="Decal", Texture="rbxassetid://"..texId}})
                        r:InvokeServer("CreateTextures", {{Part=p, Face=Enum.NormalId.Back, TextureType="Decal"}})
                        r:InvokeServer("SyncTexture", {{Part=p, Face=Enum.NormalId.Back, TextureType="Decal", Texture="rbxassetid://"..texId}})
                        task.spawn(function()
                            local currentCF = cf
                            local lifeTime = 0
                            while isStormRunning do
                                if not p or not p.Parent then break end
                                currentCF = currentCF + Vector3.new(0, 5, 0)
                                r:InvokeServer("SyncMove", {{Part=p, CFrame=currentCF}})
                                lifeTime = lifeTime + 0.05
                                if lifeTime > 10 then
                                    r:InvokeServer("Remove", {p})
                                    break
                                end
                                task.wait(0.05)
                            end
                        end)
                    end
                end)
            end
            task.wait(0.1)
        end
    end)
end

local function StartRise(texId)
    isRiseRunning = false
    isStormRunning = false
    task.wait(0.1)
    isRiseRunning = true
    local r = getRemote()
    if not r then return end
    task.spawn(function()
        while isRiseRunning do
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    task.spawn(function()
                        local hrp = plr.Character.HumanoidRootPart
                        local spawnPos = hrp.CFrame.Position + Vector3.new(0, 3, 0)
                        local cf = CFrame.new(spawnPos)
                        local p = r:InvokeServer("CreatePart", "Normal", cf, workspace)
                        if p then
                            r:InvokeServer("SetName", {p}, "F3xParticle_Rise")
                            r:InvokeServer("SyncResize", {{Part=p, CFrame=cf, Size=Vector3.new(5, 5, 0.2)}})
                            r:InvokeServer("SyncCollision", {{Part=p, CanCollide=false}})
                            r:InvokeServer("SetLocked", {p}, true)
                            r:InvokeServer("CreateTextures", {{Part=p, Face=Enum.NormalId.Front, TextureType="Decal"}})
                            r:InvokeServer("SyncTexture", {{Part=p, Face=Enum.NormalId.Front, TextureType="Decal", Texture="rbxassetid://"..texId}})
                            r:InvokeServer("CreateTextures", {{Part=p, Face=Enum.NormalId.Back, TextureType="Decal"}})
                            r:InvokeServer("SyncTexture", {{Part=p, Face=Enum.NormalId.Back, TextureType="Decal", Texture="rbxassetid://"..texId}})
                            task.spawn(function()
                                local currentCF = cf
                                local lifeTime = 0
                                while isRiseRunning do
                                    if not p or not p.Parent then break end
                                    currentCF = currentCF + Vector3.new(0, 1, 0)
                                    r:InvokeServer("SyncMove", {{Part=p, CFrame=currentCF}})
                                    lifeTime = lifeTime + 0.05
                                    if lifeTime > 2 then
                                        r:InvokeServer("Remove", {p})
                                        break
                                    end
                                    task.wait(0.05)
                                end
                            end)
                        end
                    end)
                end
            end
            task.wait(0.3)
        end
    end)
end

local function StopAndClearFalling()
    isStormRunning = false
    local r = getRemote()
    if not r then return end
    task.spawn(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "F3xParticle_Fall" then
                pcall(function() r:InvokeServer("Remove", {v}) end)
            end
        end
    end)
end

local function StopAndClearRise()
    isRiseRunning = false
    local r = getRemote()
    if not r then return end
    task.spawn(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "F3xParticle_Rise" then
                pcall(function() r:InvokeServer("Remove", {v}) end)
            end
        end
    end)
end

local jumpscareList = {"95719226713148","125099022586543","109960935915507","124438945870041","124863880408647","136729144659713"}

local function TriggerJumpscare(imgId)
    local r = getRemote()
    if not r then return end
    
    SendCmd(";music 6018028320 ;volume 100")
    
    for _, targetPlayer in ipairs(game:GetService("Players"):GetPlayers()) do
        task.spawn(function()
            local camera = workspace.CurrentCamera
            local spawnCF = camera.CFrame * CFrame.new(0, 0, -2) * CFrame.Angles(math.rad(90), 0, 0)
            
            local p = r:InvokeServer("CreatePart", "Normal", spawnCF, workspace)
            if p then
                r:InvokeServer("SetName", {p}, "F3xJumpscare")
                r:InvokeServer("SyncMaterial", {{Part=p, Transparency=1}})
                r:InvokeServer("SyncResize", {{Part=p, CFrame=p.CFrame, Size=Vector3.new(6.3, 3, 0.1)}})
                r:InvokeServer("SetLocked", {p}, true)
                r:InvokeServer("CreateTextures", {{Part=p, Face=Enum.NormalId.Front, TextureType="Decal"}})
                r:InvokeServer("SyncTexture", {{Part=p, Face=Enum.NormalId.Front, TextureType="Decal", Texture="rbxassetid://"..tostring(imgId)}})
                
                local startTime = tick()
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if tick() - startTime > 9 then
                        conn:Disconnect()
                        pcall(function() r:InvokeServer("Remove", {p}) end)
                        return
                    end
                    if p and p.Parent then
                        local followCF = camera.CFrame * CFrame.new(0, 0, -2) * CFrame.Angles(math.rad(180), 0, math.rad(-180))
                        r:InvokeServer("SyncMove", {{Part=p, CFrame=followCF}})
                    else
                        conn:Disconnect()
                    end
                end)
            end
        end)
    end
end

local BaseList = {
    {"天空盒1", function() CreateSky("95719226713148") end},
    {"天空盒2", function() CreateSky("125099022586543") end},
    {"天空盒3", function() CreateSky("109960935915507") end},
    {"天空盒4", function() CreateSky("124438945870041") end},
    {"天空盒5", function() CreateSky("124863880408647") end},
    {"删除天空盒", function() DestroySky() end},
    
    {"贴图1", function() SpamDecal("95719226713148") end},
    {"贴图2", function() SpamDecal("125099022586543") end},
    {"贴图3", function() SpamDecal("109960935915507") end},
    {"贴图4", function() SpamDecal("124438945870041") end},
    {"贴图5", function() SpamDecal("124863880408647") end},
    {"取消贴图", function() CancelDecal() end},
    
    {"粒子1", function() StartFalling("95719226713148") end},
    {"粒子2", function() StartFalling("125099022586543") end},
    {"粒子3", function() StartFalling("109960935915507") end},
    {"粒子4", function() StartFalling("124438945870041") end},
    {"粒子5", function() StartFalling("124863880408647") end},
    {"停止并清除", function() StopAndClearFalling() end}, 
    
    {"跟随粒子1", function() StartRise("95719226713148") end},
    {"跟随粒子2", function() StartRise("125099022586543") end},
    {"跟随粒子3", function() StartRise("109960935915507") end},
    {"跟随粒子4", function() StartRise("124438945870041") end},
    {"跟随粒子5", function() StartRise("124863880408647") end},
    {"停止并清除", function() StopAndClearRise() end}, 

    {"跳跃惊吓1", function() TriggerJumpscare(jumpscareList[1]) end},
    {"跳跃惊吓2", function() TriggerJumpscare(jumpscareList[2]) end},
    {"跳跃惊吓3", function() TriggerJumpscare(jumpscareList[3]) end},
    {"跳跃惊吓4", function() TriggerJumpscare(jumpscareList[4]) end},
    {"跳跃惊吓5", function() TriggerJumpscare(jumpscareList[5]) end},
    {"跳跃惊吓6", function() TriggerJumpscare(jumpscareList[6]) end},

    {"公告1", function() SendCmd(";serverMessage Team_RZ") end},
    {"公告2", function() SendCmd(";serverMessage Rebzyyx NB") end},
    {"公告3", function() SendCmd(";serverMessage BY.Rebzyyx,Rezlaine") end},
    
    {"提示1", function() SendCmd(";sh Team_RZ") end},
    {"提示2", function() SendCmd(";sh Rebzyyx NB") end},
    {"提示3", function() SendCmd(";sh BY.Rebzyyx,Rezlaine") end}
}

pop(P3, MusicList)
pop(P2, BaseList)
pop(P4, {
    {"获取F3X", function() SendCmd(";btools me") end}, 
    
    {"标题(自己)", function() SendCmd(";titler me Rebzyyx") end},
    {"标题(全服)", function() SendCmd(";titler all Rebzyyx") end},
    
    {"全服改名", function() SendCmd(";name all Rebzyyx") end}, 
    
    {"系统提示", function() SendCmd(";systemmessage The server has been invaded by Rebzyyx. Rebzyyx F3xgui v67 BY.Rebzyyx, Rezlaine.") end},
    
    {"全服改皮肤", function() SendCmd(";char all zczczczc722") end} 
})

local ResizeZone = c("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -30, 1, -30), Text = "", BorderSizePixel = 0, ZIndex = 1}, Main)
local isMin, normalSize, minSize = false, UDim2.new(0, 500, 0, 360), UDim2.new(0, 500, 0, 45)

Min.MouseButton1Down:Connect(function()
    isMin = not isMin
    if isMin then
        Side.Visible = false
        Cont.Visible = false
        ResizeZone.Visible = false
        RedLine.Visible = false
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minSize}):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize}):Play()
        task.delay(0.3, function() 
            Side.Visible = true
            Cont.Visible = true
            ResizeZone.Visible = true
            RedLine.Visible = true
        end)
    end
end)

local drag, dragStart, startPos, rDrag, rStart, rScaleStart = false, nil, nil, false, nil, nil
Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag, dragStart, startPos = true, input.Position, Main.Position end
end)
ResizeZone.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then rDrag, rStart, rScaleStart = true, input.Position, UIScale.Scale end
end)

UIS.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X / UIScale.Scale, startPos.Y.Scale, startPos.Y.Offset + d.Y / UIScale.Scale)
    end
    if rDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UIScale.Scale = math.clamp(rScaleStart + ((input.Position.X - rStart.X) / 300), 0.5, 1.5)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        drag, rDrag = false, false 
    end
end)

local isClosing = false
Close.MouseButton1Down:Connect(function()
    if isClosing then return end
    isClosing = true
    local absPos, absSize = Main.AbsolutePosition, Main.AbsoluteSize
    Main.Visible = false
    local pieces = {}
    for i = 1, 40 do
        local p = c("Frame", {BackgroundColor3 = (i % 2 == 0) and RED or BTN, Position = UDim2.new(0, absPos.X + math.random(0, absSize.X), 0, absPos.Y + math.random(0, absSize.Y)), Size = UDim2.new(0, math.random(5, 20), 0, math.random(5, 20)), BorderSizePixel = 0, ZIndex = 10}, MainGui)
        table.insert(pieces, {Frame = p, VelX = math.random(-400, 400), VelY = math.random(-500, 100), RotVel = math.random(-15, 15)})
    end
    local startTime, conn = tick(), nil
    conn = RunService.RenderStepped:Connect(function(dt)
        local elapsed = tick() - startTime
        for _, data in pairs(pieces) do
            if data.Frame and data.Frame.Parent then
                data.VelY = data.VelY + 1200 * dt
                data.Frame.Position = UDim2.new(0, data.Frame.Position.X.Offset + data.VelX * dt, 0, data.Frame.Position.Y.Offset + data.VelY * dt)
                data.Frame.Rotation = data.Frame.Rotation + data.RotVel * dt * 5
                data.Frame.BackgroundTransparency = math.clamp((elapsed - 0.5) / 1, 0, 1)
            end
        end
        if elapsed > 1.5 then conn:Disconnect(); MainGui:Destroy() end
    end)
end)

task.spawn(function()
    task.wait(0.2)
    for i, s in ipairs(Spikes) do
        task.delay(i * 0.04, function()
            TweenService:Create(s, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 2, 0, 180), BackgroundTransparency = 0}):Play()
        end)
    end
    TweenService:Create(Core, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 15, 0, 15), BackgroundTransparency = 0}):Play()
    task.wait(0.5)
    
    local str = "REBZYYX"
    local ch = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
    local el = 0
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        el = el + dt
        local prog = math.floor((el / 0.8) * #str)
        local cur = string.sub(str, 1, prog)
        for i = prog + 1, #str do cur = cur .. string.sub(ch, math.random(1, #ch), math.random(1, #ch)) end
        T1.Text, T2.Text = cur, cur
        if el >= 0.8 then conn:Disconnect(); T1.Text, T2.Text = str, str end
    end)
    
    TweenService:Create(T3, TweenInfo.new(0.5), {TextTransparency = 0.2}):Play()
    task.wait(1.2)
    
    for _, s in ipairs(Spikes) do
        TweenService:Create(s, TweenInfo.new(0.2), {Size = UDim2.new(0, 2, 0, 0), BackgroundTransparency = 1}):Play()
    end
    TweenService:Create(Core, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    TweenService:Create(T1, TweenInfo.new(0.3), {TextTransparency = 1, TextSize = 40}):Play()
    TweenService:Create(T2, TweenInfo.new(0.3), {TextTransparency = 1, TextSize = 40}):Play()
    TweenService:Create(T3, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    
    local F = c("Frame", {BackgroundColor3 = RED, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BorderSizePixel = 0}, MainBG)
    TweenService:Create(F, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 2000), BackgroundTransparency = 1}):Play()
    TweenService:Create(MainBG, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    
    task.wait(0.3)
    TweenService:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.8)
    BootGui:Destroy()
end)