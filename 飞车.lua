--XvPxOL开源/分享禁止外传
--交流群1032142349


local _ScreenGui = Instance.new('ScreenGui')
local _Frame = Instance.new('Frame')
local _Frame2 = Instance.new('Frame')
local _TextButton = Instance.new('TextButton')
local _TextBox = Instance.new('TextBox')
local _TextButton2 = Instance.new('TextButton')
local _TextLabel = Instance.new('TextLabel')
local _TextLabel2 = Instance.new('TextLabel')
local _TextLabel3 = Instance.new('TextLabel')
local _TextButton3 = Instance.new('TextButton')
local _TextLabel4 = Instance.new('TextLabel')
local _TextButton4 = Instance.new('TextButton')
local _TextButton5 = Instance.new('TextButton')
local _Frame3 = Instance.new('Frame')
local _TextButton6 = Instance.new('TextButton')
local _TextButton7 = Instance.new('TextButton')

_ScreenGui.Name = 'Flym gui v2'
_ScreenGui.Parent = game.CoreGui
_ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

_Frame.Name = 'Drag'
_Frame.Parent = _ScreenGui
_Frame.Active = true
_Frame.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
_Frame.BorderSizePixel = 0
_Frame.Draggable = true
_Frame.Position = UDim2.new(0.482438415, 0, 0.454874992, 0)
_Frame.Size = UDim2.new(0, 237, 0, 27)

_Frame2.Name = 'FlyFrame'
_Frame2.Parent = _Frame
_Frame2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
_Frame2.BorderSizePixel = 0
_Frame2.Draggable = true
_Frame2.Position = UDim2.new(-0.00200000009, 0, 0.989000022, 0)
_Frame2.Size = UDim2.new(0, 237, 0, 139)

_TextButton.Name = 'ddnsfbfwewefe'
_TextButton.Parent = _Frame2
_TextButton.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
_TextButton.BorderSizePixel = 0
_TextButton.Position = UDim2.new(-0.000210968778, 0, -0.00395679474, 0)
_TextButton.Size = UDim2.new(0, 237, 0, 27)
_TextButton.Font = Enum.Font.SourceSans
_TextButton.Text = '汉化者:小皮'
_TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextButton.TextScaled = true
_TextButton.TextSize = 14
_TextButton.TextWrapped = true

_TextBox.Name = '速度'
_TextBox.Parent = _Frame2
_TextBox.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
_TextBox.BorderColor3 = Color3.fromRGB(0, 0, 191)
_TextBox.BorderSizePixel = 0
_TextBox.Position = UDim2.new(0.445025861, 0, 0.402877688, 0)
_TextBox.Size = UDim2.new(0, 111, 0, 33)
_TextBox.Font = Enum.Font.SourceSans
_TextBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
_TextBox.Text = '50'
_TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextBox.TextScaled = true
_TextBox.TextSize = 14
_TextBox.TextWrapped = true

_TextButton2.Name = 'Fly'
_TextButton2.Parent = _Frame2
_TextButton2.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
_TextButton2.BorderSizePixel = 0
_TextButton2.Position = UDim2.new(0.0759493634, 0, 0.705797076, 0)
_TextButton2.Size = UDim2.new(0, 199, 0, 32)
_TextButton2.Font = Enum.Font.SourceSans
_TextButton2.Text = '开启'
_TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextButton2.TextScaled = true
_TextButton2.TextSize = 14
_TextButton2.TextWrapped = true

_TextButton2.MouseButton1Click:Connect(function()
    local _HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
    _TextButton2.Visible = false
    _TextLabel3.Text = '开'
    _TextLabel3.TextColor3 = Color3.fromRGB(0, 255, 0)
    _TextButton3.Visible = true
    _Frame3.Visible = true
    local _BodyVelocity = Instance.new('BodyVelocity', _HumanoidRootPart)
    local _BodyGyro = Instance.new('BodyGyro', _HumanoidRootPart)
    _BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    game:GetService('RunService').RenderStepped:connect(function()
        _BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        _BodyGyro.D = 5000
        _BodyGyro.P = 100000
        _BodyGyro.CFrame = game.Workspace.CurrentCamera.CFrame
    end)
end)

_TextLabel.Name = '速度'
_TextLabel.Parent = _Frame2
_TextLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
_TextLabel.BorderSizePixel = 0
_TextLabel.Position = UDim2.new(0.0759493634, 0, 0.402877688, 0)
_TextLabel.Size = UDim2.new(0, 87, 0, 32)
_TextLabel.ZIndex = 0
_TextLabel.Font = Enum.Font.SourceSans
_TextLabel.Text = '速度:'
_TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextLabel.TextScaled = true
_TextLabel.TextSize = 14
_TextLabel.TextWrapped = true

_TextLabel2.Name = 'Stat'
_TextLabel2.Parent = _Frame2
_TextLabel2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
_TextLabel2.BorderSizePixel = 0
_TextLabel2.Position = UDim2.new(0.299983799, 0, 0.239817441, 0)
_TextLabel2.Size = UDim2.new(0, 85, 0, 15)
_TextLabel2.Font = Enum.Font.SourceSans
_TextLabel2.Text = '状态:'
_TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextLabel2.TextScaled = true
_TextLabel2.TextSize = 14
_TextLabel2.TextWrapped = true

_TextLabel3.Name = 'Stat2'
_TextLabel3.Parent = _Frame2
_TextLabel3.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
_TextLabel3.BorderSizePixel = 0
_TextLabel3.Position = UDim2.new(0.546535194, 0, 0.239817441, 0)
_TextLabel3.Size = UDim2.new(0, 27, 0, 15)
_TextLabel3.Font = Enum.Font.SourceSans
_TextLabel3.Text = '关'
_TextLabel3.TextColor3 = Color3.fromRGB(255, 0, 0)
_TextLabel3.TextScaled = true
_TextLabel3.TextSize = 14
_TextLabel3.TextWrapped = true

_TextButton3.Name = 'Unfly'
_TextButton3.Parent = _Frame2
_TextButton3.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
_TextButton3.BorderSizePixel = 0
_TextButton3.Position = UDim2.new(0.0759493634, 0, 0.705797076, 0)
_TextButton3.Size = UDim2.new(0, 199, 0, 32)
_TextButton3.Visible = false
_TextButton3.Font = Enum.Font.SourceSans
_TextButton3.Text = '关闭'
_TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextButton3.TextScaled = true
_TextButton3.TextSize = 14
_TextButton3.TextWrapped = true

_TextButton3.MouseButton1Click:Connect(function()
    local _HumanoidRootPart2 = game.Players.LocalPlayer.Character.HumanoidRootPart
    _TextButton2.Visible = true
    _TextLabel3.Text = '关'
    _TextLabel3.TextColor3 = Color3.fromRGB(255, 0, 0)
    wait()
    _TextButton3.Visible = false
    _Frame3.Visible = false
    _HumanoidRootPart2:FindFirstChildOfClass('BodyVelocity'):Destroy()
    _HumanoidRootPart2:FindFirstChildOfClass('BodyGyro'):Destroy()
end)

_TextLabel4.Name = '皮飞车'
_TextLabel4.Parent = _Frame
_TextLabel4.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
_TextLabel4.BorderSizePixel = 0
_TextLabel4.Size = UDim2.new(0, 57, 0, 27)
_TextLabel4.Font = Enum.Font.SourceSans
_TextLabel4.Text = '皮飞车'
_TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextLabel4.TextScaled = true
_TextLabel4.TextSize = 14
_TextLabel4.TextWrapped = true

_TextButton4.Name = 'Close'
_TextButton4.Parent = _Frame
_TextButton4.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
_TextButton4.BorderSizePixel = 0
_TextButton4.Position = UDim2.new(0.875, 0, 0, 0)
_TextButton4.Size = UDim2.new(0, 27, 0, 27)
_TextButton4.Font = Enum.Font.SourceSans
_TextButton4.Text = 'X'
_TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextButton4.TextScaled = true
_TextButton4.TextSize = 14
_TextButton4.TextWrapped = true

_TextButton4.MouseButton1Click:Connect(function()
    _ScreenGui:Destroy()
end)

_TextButton5.Name = 'Minimize'
_TextButton5.Parent = _Frame
_TextButton5.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
_TextButton5.BorderSizePixel = 0
_TextButton5.Position = UDim2.new(0.75, 0, 0, 0)
_TextButton5.Size = UDim2.new(0, 27, 0, 27)
_TextButton5.Font = Enum.Font.SourceSans
_TextButton5.Text = '-'
_TextButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextButton5.TextScaled = true
_TextButton5.TextSize = 14
_TextButton5.TextWrapped = true

function Mini()
    if _TextButton5.Text ~= '-' then
        if _TextButton5.Text == '+' then
            _TextButton5.Text = '-'
            _Frame2.Visible = true
        end
    else
        _TextButton5.Text = '+'
        _Frame2.Visible = false
    end
end

_TextButton5.MouseButton1Click:Connect(Mini)

_Frame3.Name = 'Fly on'
_Frame3.Parent = _ScreenGui
_Frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
_Frame3.BorderSizePixel = 0
_Frame3.Position = UDim2.new(0.117647067, 0, 0.550284624, 0)
_Frame3.Size = UDim2.new(0.148000002, 0, 0.314999998, 0)
_Frame3.Visible = false
_Frame3.Active = true
_Frame3.Draggable = true

_TextButton6.Name = 'W'
_TextButton6.Parent = _Frame3
_TextButton6.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
_TextButton6.BorderSizePixel = 0
_TextButton6.Position = UDim2.new(0.134719521, 0, 0.0152013302, 0)
_TextButton6.Size = UDim2.new(0.708999991, 0, 0.499000013, 0)
_TextButton6.Font = Enum.Font.SourceSans
_TextButton6.Text = '^'
_TextButton6.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextButton6.TextScaled = true
_TextButton6.TextSize = 14
_TextButton6.TextWrapped = true

_TextButton6.TouchLongPress:Connect(function()
    local _HumanoidRootPart3 = game.Players.LocalPlayer.Character.HumanoidRootPart
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart3.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 0
end)

_TextButton6.MouseButton1Click:Connect(function()
    local _HumanoidRootPart4 = game.Players.LocalPlayer.Character.HumanoidRootPart
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * _TextBox.Text
    wait(0.1)
    _HumanoidRootPart4.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 0
end)

_TextButton7.Name = 'S'
_TextButton7.Parent = _Frame3
_TextButton7.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
_TextButton7.BorderSizePixel = 0
_TextButton7.Position = UDim2.new(0.134000003, 0, 0.479999989, 0)
_TextButton7.Rotation = 180
_TextButton7.Size = UDim2.new(0.708999991, 0, 0.499000013, 0)
_TextButton7.Font = Enum.Font.SourceSans
_TextButton7.Text = '^'
_TextButton7.TextColor3 = Color3.fromRGB(255, 255, 255)
_TextButton7.TextScaled = true
_TextButton7.TextSize = 14
_TextButton7.TextWrapped = true

_TextButton7.TouchLongPress:Connect(function()
    local _HumanoidRootPart5 = game.Players.LocalPlayer.Character.HumanoidRootPart
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart5.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 0
end)

_TextButton7.MouseButton1Click:Connect(function()
    local _HumanoidRootPart6 = game.Players.LocalPlayer.Character.HumanoidRootPart
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -_TextBox.Text
    wait(0.1)
    _HumanoidRootPart6.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 0
end)