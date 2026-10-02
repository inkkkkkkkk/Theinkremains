local Players=game:GetService("Players")
local localPlayer=Players.LocalPlayer
local authorIds={
    [10380595563]="脚本作者_墨水依旧",
    [4122111506]="脚本作者_司空",
    [10619015725]="脚本作者_司空"
}
local taggedPlayers={}

local function getAuthorLabel(player)
    return authorIds[player.UserId]
end

local function addTag(char,labelText)
    if not char or not char:IsA("Model") then return end
    local head=char:FindFirstChild("Head")
    if not head then return end
    if head:FindFirstChild("AuthorTag") then return end
    local bill=Instance.new("BillboardGui")
    bill.Name="AuthorTag"
    bill.Size=UDim2.new(0,160,0,35)
    bill.AlwaysOnTop=true
    bill.StudsOffset=Vector3.new(0,2.8,0)
    bill.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    bill.Parent=head
    bill.Enabled=true
    local frame=Instance.new("Frame")
    frame.Size=UDim2.new(1,0,1,0)
    frame.BackgroundColor3=Color3.fromRGB(24,24,24)
    frame.BackgroundTransparency=0.08
    frame.BorderSizePixel=0
    frame.Parent=bill

    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,8)
    corner.Parent=frame

    local stroke=Instance.new("UIStroke")
    stroke.Thickness=2
    stroke.Color=Color3.fromRGB(145,145,145)
    stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    stroke.Parent=frame

    local grad=Instance.new("UIGradient")
    grad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(65,65,65)),
        ColorSequenceKeypoint.new(0.25,Color3.fromRGB(120,120,120)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(0.75,Color3.fromRGB(120,120,120)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(65,65,65))
    })
    grad.Rotation=0
    grad.Parent=stroke
    local label=Instance.new("TextLabel")
    label.Size=UDim2.new(1,0,1,0)
    label.BackgroundTransparency=1
    label.Text=labelText or "脚本作者"
    label.TextColor3=Color3.fromRGB(190,190,190)
    label.TextScaled=true
    label.Font=Enum.Font.GothamBold
    label.Parent=bill
    task.spawn(function()
        while bill and bill.Parent do
            grad.Rotation=(grad.Rotation+2)%360
            task.wait(0.02)
        end
    end)
    return true
end

task.spawn(function()
    while true do
        for _,p in ipairs(Players:GetPlayers()) do
            if getAuthorLabel(p) and not taggedPlayers[p.UserId] then
                if p.Character then
                    if addTag(p.Character,getAuthorLabel(p)) then
                        taggedPlayers[p.UserId]=true
                    end
                end
                p.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    addTag(char,getAuthorLabel(p))
                end)
            end
        end
        task.wait(2)
    end
end)