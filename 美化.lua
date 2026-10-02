local A=game:GetService("StarterGui")

local function gradient(text,startColor,endColor)
    local result=""
    local chars={}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars,uchar) end
    local length=#chars
    for i=1,length do
        local t=(i-1)/math.max(length-1,1)
        local r=startColor.R+(endColor.R-startColor.R)*t
        local g=startColor.G+(endColor.G-startColor.G)*t
        local b=startColor.B+(endColor.B-startColor.B)*t
        result=result..string.format('<font color="rgb(%d,%d,%d)">%s</font>',math.floor(r*255),math.floor(g*255),math.floor(b*255),chars[i])
    end
    return result
end

local B=nil
local winduiUrls={
    "https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua",
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
    "https://raw.githubusercontent.com/951357nvjn/dyzs/refs/heads/main/winduiYI.lua"
}
local winduiLastError="未知错误"
for _,url in ipairs(winduiUrls) do
    local ok,result=pcall(function()
        local code=game:HttpGet(url,true)
        if type(code)~="string" or #code<100 then error("WindUI下载内容为空") end
        local loader=loadstring(code)
        if type(loader)~="function" then error("WindUI loadstring失败") end
        local lib=loader()
        if not lib then error("WindUI初始化返回空") end
        return lib
    end)
    if ok and result then B=result break end
    winduiLastError=tostring(result)
    task.wait(0.25)
end
if not B then
    pcall(function() A:SetCore("SendNotification",{Title="WindUI加载失败",Text="请检查Delta网络/HttpGet支持",Duration=5}) end)
    warn("[ink_美化] WindUI加载失败:",winduiLastError)
    return
end

pcall(function()
    B:AddTheme({
        Name="inkGray",
        Accent=Color3.fromRGB(105,105,105),
        Dialog=Color3.fromRGB(32,32,32),
        Outline=Color3.fromRGB(125,125,125),
        Text=Color3.fromRGB(235,235,235),
        Placeholder=Color3.fromRGB(145,145,145),
        Background=Color3.fromRGB(24,24,24),
        Button=Color3.fromRGB(58,58,58),
        Icon=Color3.fromRGB(190,190,190),
        Title=Color3.fromRGB(155,155,155),
        Author=Color3.fromRGB(145,145,145),
    })
    B:SetTheme("inkGray")
end)

local C=B:CreateWindow({
    Icon="rbxassetid://71953031400395",
    Title=gradient("ink_美化",Color3.fromRGB(180,180,180),Color3.fromRGB(100,100,100)),
    Author=gradient("@墨水依旧 司空",Color3.fromRGB(180,180,180),Color3.fromRGB(100,100,100)),
    Folder="ink_美化",
    NewElements=true,
    HideSearchBar=false,
    Theme="inkGray",
})

pcall(function()
    C:EditOpenButton({
        Title="ink_美化",
        Icon="crown",
        StrokeThickness=5,
        TextColor=Color3.fromRGB(150,150,150),
        TitleColor=Color3.fromRGB(150,150,150),
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),
            ColorSequenceKeypoint.new(0.5,Color3.fromRGB(150,150,150)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(70,70,70))
        }),
        Draggable=true
    })
end)

pcall(function()
    local RunService=game:GetService("RunService")
    local CoreGui=game:GetService("CoreGui")
    local targetWindow=C.UIElements and C.UIElements.Main
    if not targetWindow then
        for _,obj in ipairs(CoreGui:GetDescendants()) do
            if obj:IsA("Frame") and obj.AbsoluteSize.X>300 and obj.AbsoluteSize.Y>150 then
                local title=obj:FindFirstChildWhichIsA("TextLabel",true)
                if title and title.Text=="ink_美化" then targetWindow=obj break end
            end
        end
    end
    if targetWindow then
        local stroke=Instance.new("UIStroke")
        stroke.Name="inkGrayMainBorder"
        stroke.Thickness=7
        stroke.Transparency=0
        stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        stroke.Parent=targetWindow
        local grad=Instance.new("UIGradient")
        grad.Name="inkGrayBorderGradient"
        grad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(65,65,65)),
            ColorSequenceKeypoint.new(0.25,Color3.fromRGB(120,120,120)),
            ColorSequenceKeypoint.new(0.5,Color3.fromRGB(200,200,200)),
            ColorSequenceKeypoint.new(0.75,Color3.fromRGB(120,120,120)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(65,65,65))
        })
        grad.Parent=stroke
        task.spawn(function()
            while targetWindow.Parent and stroke.Parent and grad.Parent do
                grad.Rotation=(grad.Rotation+1.5)%360
                RunService.RenderStepped:Wait()
            end
        end)
        for _,info in ipairs({{16,0.88},{11,0.80},{7,0.70}}) do
            local glow=Instance.new("UIStroke")
            glow.Thickness=info[1]
            glow.Transparency=info[2]
            glow.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            glow.Parent=targetWindow
            local g=Instance.new("UIGradient")
            g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(70,70,70)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(190,190,190)),ColorSequenceKeypoint.new(1,Color3.fromRGB(70,70,70))})
            g.Parent=glow
            task.spawn(function()
                while targetWindow.Parent and glow.Parent and g.Parent do
                    g.Rotation=(g.Rotation+1.1)%360
                    RunService.RenderStepped:Wait()
                end
            end)
        end
    end
end)

pcall(function()
    local CoreGui=game:GetService("CoreGui")
    local function recolor(root)
        for _,obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if obj.Text=="ink_美化" then obj.TextColor3=Color3.fromRGB(155,155,155)
                elseif obj.Text=="@墨水依旧 司空" then obj.TextColor3=Color3.fromRGB(125,125,125) end
            end
        end
    end
    recolor(CoreGui)
    task.delay(0.25,function() pcall(function() recolor(CoreGui) end) end)
    task.delay(0.8,function() pcall(function() recolor(CoreGui) end) end)
end)

local D=C:Section({Title="功能菜单",Opened=true})

local Z = D:Tab({Title="公告", Icon="bell"})
Z:Paragraph({
    Title = "欢迎使用 ink_美化",
    Desc = "作者：墨水依旧和司空\n墨水快手号:zczczczc766\n司空快手号:smalldesikon111和smalldesikon\n开源并公开的4000+\n没惹你就开源的自动给我30年寿命\n公益脚本禁止倒卖",
    Image = "rbxassetid://84411268070942",
    ImageSize = 100,
})
Z:Button({Title="复制作者QQ", Callback=function() setclipboard("2047955671") A:SetCore("SendNotification",{Title="已复制", Text="作者QQ：2047955671", Duration=2}) end})
Z:Button({Title="复制作者QQ群", Callback=function() setclipboard("1101093219") A:SetCore("SendNotification",{Title="已复制", Text="作者QQ群：1101093219", Duration=2}) end})
Z:Button({Title="复制作者副群", Callback=function() setclipboard("1063828524") A:SetCore("SendNotification",{Title="已复制", Text="作者副群：1063828524", Duration=2}) end})

local CosmeticsTab = D:Tab({Title="角色美化", Icon="sparkles"})

local player = game.Players.LocalPlayer

local hairHidden = false
local allAccessoriesHidden = false
local accessoryOriginal = {}

local accessoryWhitelist = {}

local function addAccessoryWhitelist(accessory)
    if accessory then
        accessoryWhitelist[accessory] = true
    end
end

local function isWhitelistAccessory(accessory)
    return accessoryWhitelist[accessory] == true
end

local function rememberAccessoryPart(part)
    if not part or not part:IsA("BasePart") then return end
    if accessoryOriginal[part] == nil then
        accessoryOriginal[part] = {
            Transparency = part.Transparency,
            LocalTransparencyModifier = part.LocalTransparencyModifier,
        }
    end
end

local function setAccessoryHidden(accessory, hidden)
    if not accessory or not accessory:IsA("Accessory") then return end
    for _, obj in ipairs(accessory:GetDescendants()) do
        if obj:IsA("BasePart") then
            if hidden then
                rememberAccessoryPart(obj)
                obj.LocalTransparencyModifier = 1
                obj.Transparency = 1
            else
                local old = accessoryOriginal[obj]
                if old then
                    obj.Transparency = old.Transparency
                    obj.LocalTransparencyModifier = old.LocalTransparencyModifier
                    accessoryOriginal[obj] = nil
                end
            end
        end
    end
end

local function isHairAccessory(accessory)
    if not accessory or not accessory:IsA("Accessory") then return false end

    local ok, accessoryType = pcall(function()
        return accessory.AccessoryType
    end)
    if ok and accessoryType == Enum.AccessoryType.Hair then
        return true
    end

    local handle = accessory:FindFirstChild("Handle")
    if handle and handle:FindFirstChild("HairAttachment") then
        return true
    end

    local lowerName = string.lower(accessory.Name)
    return lowerName:find("hair") ~= nil or lowerName:find("头发") ~= nil
end

local function updateAccessoryVisibility()
    local char = player.Character
    if not char then return end

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Accessory") then
            if isWhitelistAccessory(obj) then
                setAccessoryHidden(obj, false)
            elseif allAccessoriesHidden then
                if isHairAccessory(obj) then
                    setAccessoryHidden(obj, hairHidden)
                else
                    setAccessoryHidden(obj, true)
                end
            elseif hairHidden and isHairAccessory(obj) then
                setAccessoryHidden(obj, true)
            else
                setAccessoryHidden(obj, false)
            end
        end
    end
end

CosmeticsTab:Toggle({
    Title = "去掉头发",
    Value = false,
    Callback = function(state)
        hairHidden = state
        updateAccessoryVisibility()
    end
})

CosmeticsTab:Toggle({
    Title = "去掉所有饰品",
    Value = false,
    Callback = function(state)
        allAccessoriesHidden = state
        updateAccessoryVisibility()
    end
})

local accessoryStates = {}
local wornAccessories = {}

local savedBodyDescriptions = {}
local bodyPartOriginal = {}

local function getBodyParts(char, kind)
    local parts = {}
    if kind == "无头" then
        local head = char:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            table.insert(parts, head)
        end
    elseif kind == "断腿" then
        for _, n in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
            local p = char:FindFirstChild(n)
            if p and p:IsA("BasePart") then
                table.insert(parts, p)
            end
        end
        local r6 = char:FindFirstChild("Right Leg")
        if r6 and r6:IsA("BasePart") then
            table.insert(parts, r6)
        end
    elseif kind == "无腿" then
        for _, n in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}) do
            local p = char:FindFirstChild(n)
            if p and p:IsA("BasePart") then
                table.insert(parts, p)
            end
        end
    end
    return parts
end

local function setLocalHidden(part, hidden)
    if not part or not part:IsA("BasePart") then return end
    if hidden then
        if bodyPartOriginal[part] == nil then
            bodyPartOriginal[part] = {
                Transparency = part.Transparency,
                LocalTransparencyModifier = part.LocalTransparencyModifier,
            }
        end
        part.LocalTransparencyModifier = 1
        part.Transparency = 1
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
    else
        local old = bodyPartOriginal[part]
        if old then
            part.Transparency = old.Transparency
            part.LocalTransparencyModifier = old.LocalTransparencyModifier
            bodyPartOriginal[part] = nil
        end
    end
end

local KORBLOX_ID = 139607718
local KORBLOX_HEIGHT = 3
local korbloxObject = nil
local korbloxOriginalParts = {}
local korbloxR6DescriptionApplied = false

local function rememberPart(part)
    if not part or not part:IsA("BasePart") or korbloxOriginalParts[part] then return end
    korbloxOriginalParts[part] = {
        Transparency = part.Transparency,
        LocalTransparencyModifier = part.LocalTransparencyModifier,
        CanCollide = part.CanCollide,
        CanTouch = part.CanTouch,
        CanQuery = part.CanQuery,
    }
end

local function hideRightLegPart(part)
    if not part or not part:IsA("BasePart") then return end
    rememberPart(part)
    part.LocalTransparencyModifier = 1
    part.Transparency = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
end

local function restoreRightLegParts()
    for part, old in pairs(korbloxOriginalParts) do
        if part and part.Parent then
            part.Transparency = old.Transparency
            part.LocalTransparencyModifier = old.LocalTransparencyModifier
            part.CanCollide = old.CanCollide
            part.CanTouch = old.CanTouch
            part.CanQuery = old.CanQuery
        end
    end
    table.clear(korbloxOriginalParts)
end

local function destroyKorblox()
    if korbloxObject then
        pcall(function() korbloxObject:Destroy() end)
        korbloxObject = nil
    end

    local char = player.Character
    if char then
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("CharacterMesh") and obj.Name == "Korblox Deathspeaker Right Leg" then
                pcall(function() obj:Destroy() end)
            end
        end
    end

    korbloxR6DescriptionApplied = false
    restoreRightLegParts()
end

local function getRightLegParts(char)
    local result = {}
    for _, n in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
        local p = char:FindFirstChild(n)
        if p and p:IsA("BasePart") then
            table.insert(result, p)
        end
    end
    return result
end

local function isR6(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.RigType == Enum.HumanoidRigType.R6
end

local function isR15(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.RigType == Enum.HumanoidRigType.R15
end

local function tryApplyR6RightLegDescription(char)
    if not isR6(char) or korbloxR6DescriptionApplied then
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    local ok, desc = pcall(function()
        return hum:GetAppliedDescription()
    end)
    if not ok or not desc then return false end

    local changed = pcall(function()
        desc.RightLeg = KORBLOX_ID
        hum:ApplyDescription(desc)
    end)

    if changed then
        korbloxR6DescriptionApplied = true
        return true
    end

    pcall(function() desc:Destroy() end)
    return false
end

local function weldKorbloxModel(model, char)
    local target =
        char:FindFirstChild("Right Leg")
        or char:FindFirstChild("RightLowerLeg")
        or char:FindFirstChild("RightUpperLeg")

    if not target then return false end

    local primary = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
    if not primary then return false end

    if model:IsA("Model") then
        model.PrimaryPart = primary
    end

    local initialOffset = CFrame.new(0, 25, 0)
    local targetPivot = target.CFrame * initialOffset

    if model:IsA("Model") then
        pcall(function()
            model:PivotTo(targetPivot)
        end)
    else
        primary.CFrame = targetPivot
    end

    pcall(function()
        local bboxCF, bboxSize = model:IsA("Model") and model:GetBoundingBox()
            or primary.CFrame, primary.Size

        local targetTop = target.Position.Y + target.Size.Y * 0.5
        local modelTop = bboxCF.Position.Y + bboxSize.Y * 0.5
        local correction = targetTop - modelTop + 0.05

        local correctedPivot = (model:IsA("Model") and model:GetPivot() or primary.CFrame)
            * CFrame.new(0, correction, 0)

        if model:IsA("Model") then
            model:PivotTo(correctedPivot)
        else
            primary.CFrame = correctedPivot
        end
    end)

    local root = model:IsA("Model") and model.PrimaryPart or primary

    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Anchored = false
            obj.Massless = true
            obj.CanCollide = false
            obj.CanTouch = false
            obj.CanQuery = false
            if obj ~= root then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = root
                weld.Part1 = obj
                weld.Parent = root
            end
        end
    end

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = target
    weld.Part1 = root
    weld.Parent = root

    return true
end

local function loadRealKorblox()
    local char = player.Character
    if not char then return false end

    if korbloxObject and korbloxObject.Parent == char then
        for _, p in ipairs(getRightLegParts(char)) do
            hideRightLegPart(p)
        end
        return true
    end

    if isR6(char) then
        tryApplyR6RightLegDescription(char)
    end

    for _, p in ipairs(getRightLegParts(char)) do
        hideRightLegPart(p)
    end

    local ok, objects = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(KORBLOX_ID))
    end)

    if not ok or not objects or not objects[1] then
        return korbloxR6DescriptionApplied
    end

    local asset = objects[1]
    local characterMesh =
        asset:IsA("CharacterMesh") and asset
        or asset:FindFirstChildWhichIsA("CharacterMesh", true)

    if characterMesh then
        characterMesh.Name = "Korblox Deathspeaker Right Leg"
        pcall(function()
            characterMesh.BodyPart = Enum.BodyPart.RightLeg
        end)
        characterMesh.Parent = char
        korbloxObject = characterMesh

        for _, p in ipairs(getRightLegParts(char)) do
            hideRightLegPart(p)
        end

        if accessoryStates["无头"] then
            task.defer(function()
                if player.Character == char then
                    applyBodyPart("无头", true)
                end
            end)
        end
        return true
    end

    local container = asset
    container.Name = "Korblox_139607718"
    container.Parent = char

    if weldKorbloxModel(container, char) then
        korbloxObject = container

        if accessoryStates["无头"] then
            task.defer(function()
                if player.Character == char then
                    applyBodyPart("无头", true)
                end
            end)
        end
        return true
    end

    pcall(function() container:Destroy() end)
    return korbloxR6DescriptionApplied
end

local function applyBodyPart(name, enabled)
    local char = player.Character
    if not char then return end

    if name == "无头" then
        if enabled then
            for _, p in ipairs(getBodyParts(char, "无头")) do
                setLocalHidden(p, true)
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Decal") and (obj.Name == "face" or (obj.Parent and obj.Parent.Name == "Head")) then
                    if bodyPartOriginal[obj] == nil then
                        bodyPartOriginal[obj] = {Transparency = obj.Transparency}
                    end
                    obj.Transparency = 1
                end
            end
        else
            for part, old in pairs(bodyPartOriginal) do
                if typeof(part) == "Instance" and part.Parent then
                    if part:IsA("BasePart") then
                        part.Transparency = old.Transparency
                        part.LocalTransparencyModifier = old.LocalTransparencyModifier
                    elseif part:IsA("Decal") then
                        part.Transparency = old.Transparency
                    end
                end
                bodyPartOriginal[part] = nil
            end
        end

    elseif name == "断腿R15" then
        if enabled then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.RigType == Enum.HumanoidRigType.R15 then
                    local rf = char:FindFirstChild("RightFoot")
                    local rl = char:FindFirstChild("RightLowerLeg")
                    local ru = char:FindFirstChild("RightUpperLeg")
                    if ru and rl and rf then
                        rf.Transparency = 1
                        rl.Transparency = 1
                        ru.MeshId = "http://www.roblox.com/asset/?id=902942096"
                        ru.TextureID = "http://roblox.com/asset/?id=902843398"
                    end
                end
            end
        end
    elseif name == "断腿R6" then
        if enabled then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.RigType == Enum.HumanoidRigType.R6 then
                    local rightLeg = char:FindFirstChild("Right Leg")
                    if rightLeg then
                        local mesh = rightLeg:FindFirstChildOfClass("SpecialMesh")
                        if not mesh then
                            mesh = Instance.new("SpecialMesh")
                            mesh.Parent = rightLeg
                        end
                        rightLeg.Color = Color3.fromRGB(64, 64, 64)
                        rightLeg.Transparency = 0
                        mesh.MeshType = Enum.MeshType.FileMesh
                        mesh.MeshId = "rbxassetid://101851696"
                        mesh.TextureId = "rbxassetid://101851254"
                        mesh.Scale = Vector3.new(1, 1, 1)
                    end
                end
            end
        end
    elseif name == "无腿" then
        if enabled then
            for _, p in ipairs(getBodyParts(char, "无腿")) do
                setLocalHidden(p, true)
            end
        else
            for part, old in pairs(bodyPartOriginal) do
                if typeof(part) == "Instance" and part.Parent and part:IsA("BasePart") then
                    part.Transparency = old.Transparency
                    part.LocalTransparencyModifier = old.LocalTransparencyModifier
                end
                bodyPartOriginal[part] = nil
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.25) do
        local char = player.Character
        if char then
            if hairHidden or allAccessoriesHidden then
                updateAccessoryVisibility()
            end
            if accessoryStates["无头"] then
                applyBodyPart("无头", true)
            end
            if accessoryStates["无腿"] then
                for _, p in ipairs(getBodyParts(char, "无腿")) do
                    setLocalHidden(p, true)
                end
            end
            if accessoryStates["断腿R15"] then
                if isR15(char) then
                    applyBodyPart("断腿R15", true)
                end
            end
            if accessoryStates["断腿R6"] then
                if isR6(char) then
                    applyBodyPart("断腿R6", true)
                end
            end
        end
    end
end)

local function loadAccessory(id, name)
    if name == "无头" then
        applyBodyPart(name, true)
        return
    end

    task.defer(function()
        pcall(function()
            local char = player.Character
            if not char then return end

            if wornAccessories[name] then
                wornAccessories[name]:Destroy()
                wornAccessories[name] = nil
            end

            local acc = game:GetObjects("rbxassetid://" .. tostring(id))[1]
            if not acc then return end

            local handle = acc:FindFirstChild("Handle", true)
            if not handle or not handle:IsA("BasePart") then
                acc:Destroy()
                return
            end

            local A1 = handle:FindFirstChildOfClass("Attachment")
            if not A1 then
                acc.Parent = char
                handle.Anchored = false
                handle.Massless = true
                local weld = Instance.new("Weld", handle)
                weld.Part0 = handle
                weld.Part1 = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                weld.C0 = CFrame.new(0, 0.5, 0)
                wornAccessories[name] = acc
                addAccessoryWhitelist(acc)
                return
            end

            local A0 = nil
            local searchParts = {"Head", "HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso"}
            for _, partName in ipairs(searchParts) do
                local part = char:FindFirstChild(partName)
                if part then
                    A0 = part:FindFirstChild(A1.Name, true)
                    if A0 then break end
                end
            end

            if not A0 then
                acc.Parent = char
                handle.Anchored = false
                handle.Massless = true
                local weld = Instance.new("Weld", handle)
                weld.Part0 = handle
                weld.Part1 = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                weld.C0 = CFrame.new(0, 0.5, 0)
                wornAccessories[name] = acc
                addAccessoryWhitelist(acc)
                return
            end

            acc.Parent = char
            handle.Anchored = false
            handle.Massless = true
            handle.CFrame = A0.WorldCFrame * A1.CFrame:Inverse()

            local weld = Instance.new("WeldConstraint", handle)
            weld.Part0 = handle
            weld.Part1 = A0.Parent

            wornAccessories[name] = acc
                addAccessoryWhitelist(acc)
        end)
    end)
end

local function removeAccessory(name)
    if name == "无头" or name == "断腿" or name == "无腿" then
        applyBodyPart(name, false)
        return
    end

    if wornAccessories[name] then
        wornAccessories[name]:Destroy()
        wornAccessories[name] = nil
    end
end

CosmeticsTab:Toggle({
    Title = "断腿 R15",
    Value = false,
    Callback = function(state)
        accessoryStates["断腿R15"] = state
        if state then
            applyBodyPart("断腿R15", true)
        else
        end
    end
})

CosmeticsTab:Toggle({
    Title = "断腿 R6",
    Value = false,
    Callback = function(state)
        accessoryStates["断腿R6"] = state
        if state then
            applyBodyPart("断腿R6", true)
        else
        end
    end
})

local accessories = {
    {name = "无头", id = 15093053680},
    {name = "无腿", id = 0},
    {name = "8位皇家王冠", id = 10159600649},
    {name = "8位血条", id = 10159610478},
    {name = "美金气球", id = 14559645454},
    {name = "火角", id = 215718515},
    {name = "冰角", id = 74891470},
    {name = "毒角", id = 1744060292},
    {name = "紫色瓦尔基里", id = 1402432199},
    {name = "8位章鱼先生", id = 507795810},
    {name = "红色多米诺王冠", id = 42211680},
    {name = "火焰莫西干", id = 191101707},
    {name = "闪亮女武神", id = 1180433861},
}

for _, acc in ipairs(accessories) do
    accessoryStates[acc.name] = false
    CosmeticsTab:Toggle({
        Title = acc.name,
        Value = false,
        Callback = function(state)
            accessoryStates[acc.name] = state
            if state then
                loadAccessory(acc.id, acc.name)
            else
                removeAccessory(acc.name)
            end
        end
    })
end

player.CharacterAdded:Connect(function(char)
    savedBodyDescriptions = {}
    task.wait(0.8)
    updateAccessoryVisibility()
    if accessoryStates["断腿R15"] then
        applyBodyPart("断腿R15", true)
    end
    if accessoryStates["断腿R6"] then
        applyBodyPart("断腿R6", true)
    end
    for _, acc in ipairs(accessories) do
        if accessoryStates[acc.name] then
            loadAccessory(acc.id, acc.name)
        end
    end
end)

