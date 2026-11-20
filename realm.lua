local Rst = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")
local rq = Rst:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local backpack = player.Backpack
local storedCharacter = char
local originalParent = storedCharacter.Parent

local function restoreChar()
	if storedCharacter and storedCharacter.Parent ~= originalParent then
		storedCharacter.Parent = originalParent
	end
end

local function getf3x()
	for _, v in ipairs(backpack:GetChildren()) do
		if v:FindFirstChild("SyncAPI") then
			return v
		end
	end
	for _, v in ipairs(char:GetChildren()) do
		if v:FindFirstChild("SyncAPI") then
			return v
		end
	end
	return nil
end

pcall(function() rq:InvokeServer(";btools") end)

local f3x = nil
for i = 1, 40 do
	f3x = getf3x()
	if f3x then break end
	task.wait(0.25)
end
if not f3x then
	restoreChar()
	error("btools not loaded")
end

local syncapi = f3x:WaitForChild("SyncAPI")
local serverendpoint = syncapi:WaitForChild("ServerEndpoint")

local function _(args)
	serverendpoint:InvokeServer(unpack(args))
end

local function resize(part, size, cf)
	_({ "SyncResize", { { Part = part, CFrame = cf, Size = size } } })
end

local function syncmaterial(part, mate)
	_({ "SyncMaterial", { { Part = part, Material = mate } } })
end

local function transparency(part, trans)
	_({ "SyncTransparency", { { Part = part, Transparency = trans } } })
end

local function color(part, color)
	_({ "SyncColor", { { Part = part, Color = color, UnionColoring = false } } })
end

local function name(part, stringa)
	_({ "SetName", { part }, stringa })
end

local function lock(part, boolean)
	_({ "SetLocked", { part }, boolean })
end

local function setcollision(part, booleana)
	_({ "SyncCollision", { { Part = part, CanCollide = booleana } } })
end

local function setanchor(part, boolean)
	_({ "SyncAnchor", { { Part = part, Anchored = boolean } } })
end

local function createdecal(part, side)
	_({ "CreateTextures", { { Part = part, Face = side, TextureType = "Decal" } } })
end

local function setdecal(part, asset, side)
	_({ "SyncTexture", { { Part = part, Face = side, TextureType = "Decal", Texture = "rbxassetid://" .. asset } } })
end

local KEEP = {
	kys = true,
	base = true,
	wall1 = true,
	Wall2 = true,
	wall3 = true,
	spawnpoint = true,
	SkyBox = true
}

local function isTarget(v)
	return (v:IsA("BasePart") or v:IsA("UnionOperation") or v:IsA("MeshPart"))
		and not KEEP[v.Name]
		and v ~= storedCharacter
		and not v:IsDescendantOf(storedCharacter)
		and v.Parent ~= backpack
		and not v:IsDescendantOf(backpack)
end

local function batch(action, list, build, size)
	size = size or 250
	for i = 1, #list, size do
		local chunk = {}
		local n = 0
		for j = i, math.min(i + size - 1, #list) do
			n = n + 1
			chunk[n] = build(list[j])
		end
		pcall(function()
			serverendpoint:InvokeServer(action, chunk)
		end)
	end
end

local function collect()
	local list = {}
	for _, v in ipairs(workspace:GetDescendants()) do
		if isTarget(v) then
			list[#list + 1] = v
		end
	end
	return list
end

local function ClearMapFast()
	storedCharacter.Parent = nil
	task.wait(0.1)

	pcall(function() rq:InvokeServer(";punish all") end)
	task.wait(0.4)

	local list = collect()
	if #list > 0 then
		batch("SetLocked", list, function(p) return p end, 300)
		task.wait(0.05)
		batch("SyncAnchor", list, function(p) return { Part = p, Anchored = false } end, 300)
		task.wait(0.05)
	end

	for pass = 1, 15 do
		local todo = collect()
		if #todo == 0 then break end
		batch("Remove", todo, function(p) return p end, 250)
		task.wait(0.06)
	end

	pcall(function() rq:InvokeServer(";unpunish all") end)
	restoreChar()
end

local function bySnake()
	local pos1 = CFrame.new(0, -1, 0)
	local baseplate = serverendpoint:InvokeServer("CreatePart", "Normal", pos1, workspace)
	resize(baseplate, Vector3.new(180, 2, 180), pos1)
	color(baseplate, Color3.fromRGB(45, 45, 45))
	syncmaterial(baseplate, Enum.Material.Concrete)
	name(baseplate, "base")
	lock(baseplate, true)

	task.wait(0.2)

	local pos2 = CFrame.new(-35, 10, 0)
	local wall1 = serverendpoint:InvokeServer("CreatePart", "Normal", pos2, workspace)
	resize(wall1, Vector3.new(2, 20, 35), pos2)
	transparency(wall1, 1)
	createdecal(wall1, Enum.NormalId.Right)
	setdecal(wall1, "109960935915507", Enum.NormalId.Right)
	name(wall1, "wall1")
	lock(wall1, true)

	local pos3 = CFrame.new(35, 10, 0)
	local wall2 = serverendpoint:InvokeServer("CreatePart", "Normal", pos3, workspace)
	resize(wall2, Vector3.new(2, 20, 35), pos3)
	transparency(wall2, 1)
	createdecal(wall2, Enum.NormalId.Left)
	setdecal(wall2, "125099022586543", Enum.NormalId.Left)
	name(wall2, "Wall2")
	lock(wall2, true)

	local pos4 = CFrame.new(0, 10, -35)
	local wall3 = serverendpoint:InvokeServer("CreatePart", "Normal", pos4, workspace)
	resize(wall3, Vector3.new(35, 20, 2), pos4)
	transparency(wall3, 1)
	createdecal(wall3, Enum.NormalId.Back)
	setdecal(wall3, "95719226713148", Enum.NormalId.Back)
	name(wall3, "wall3")
	lock(wall3, true)

	local pos5 = CFrame.new(0, 10, 35)
	local wall4 = serverendpoint:InvokeServer("CreatePart", "Normal", pos5, workspace)
	resize(wall4, Vector3.new(35, 20, 2), pos5)
	transparency(wall4, 1)
	createdecal(wall4, Enum.NormalId.Front)
	setdecal(wall4, "95719226713148", Enum.NormalId.Front)
	name(wall4, "wall4")
	lock(wall4, true)

	task.wait(0.2)

	local pos7 = CFrame.new(0, 1.5, 40)
	local spawn = serverendpoint:InvokeServer("CreatePart", "Spawn", pos7, workspace)
	resize(spawn, Vector3.new(8, 1, 8), pos7)
	transparency(spawn, 1)
	color(spawn, Color3.fromRGB(0, 255, 0))
	syncmaterial(spawn, Enum.Material.Neon)
	name(spawn, "spawnpoint")
	setcollision(spawn, false)
	setanchor(spawn, true)
	lock(spawn, true)
end

local skyPart = nil
local rotX, rotY, rotZ = 0, 0, 0
local vertexVal = 4
local spinSpeed = 4

local function CreateSky1()
	local fixedPos = Vector3.new(0, 0, 0)
	local cf = CFrame.new(fixedPos)

	local createdPart = serverendpoint:InvokeServer("CreatePart", "Normal", cf, workspace)
	if not createdPart then
		return
	end
	skyPart = createdPart

	serverendpoint:InvokeServer("SetName", { skyPart }, "SkyBox")
	serverendpoint:InvokeServer("SyncAnchor", { { Part = skyPart, Anchored = true } })
	serverendpoint:InvokeServer("SyncCollision", { { Part = skyPart, CanCollide = false } })
	serverendpoint:InvokeServer("SyncTransparency", { { Part = skyPart, Transparency = 0 } })
	serverendpoint:InvokeServer("SyncResize", { { Part = skyPart, CFrame = cf, Size = Vector3.new(1500, 1500, 1500) } })
	serverendpoint:InvokeServer("CreateMeshes", { { Part = skyPart } })
	task.wait(0.2)

	serverendpoint:InvokeServer("SyncMesh", { {
		Part = skyPart,
		MeshId = "rbxassetid://111891702759441",
		TextureId = "rbxassetid://95719226713148",
		Scale = Vector3.new(1000, 1000, 1000),
		VertexColor = Vector3.new(vertexVal, vertexVal, vertexVal)
	} })

	local hue = 0
	local lastServerSync = 0
	RS.RenderStepped:Connect(function(dt)
		if not skyPart or not skyPart.Parent then return end
		pcall(function()
			hue = (hue + dt * 0.3) % 1
			local c = Color3.fromHSV(hue, 1, 1)
			local vColor = Vector3.new(c.R * vertexVal, c.G * vertexVal, c.B * vertexVal)

			rotX = (rotX + spinSpeed * dt * 14) % 360
			rotY = (rotY + spinSpeed * dt * 22) % 360
			rotZ = (rotZ + spinSpeed * dt * 18) % 360

			local newCFrame = CFrame.new(fixedPos) * CFrame.Angles(math.rad(rotX), math.rad(rotY), math.rad(rotZ))
			skyPart.CFrame = newCFrame

			lastServerSync = lastServerSync + dt
			if lastServerSync >= 0.25 then
				lastServerSync = 0
				serverendpoint:InvokeServer("SyncMesh", { { Part = skyPart, VertexColor = vColor } })
				serverendpoint:InvokeServer("SyncRotate", { { Part = skyPart, CFrame = newCFrame } })
			end
		end)
	end)
end

local ok, err = pcall(function()
	ClearMapFast()
	task.wait(0.2)
	bySnake()
	CreateSky1()
end)

if not ok then
	warn(err)
end

restoreChar()
task.wait(1)

pcall(function() rq:InvokeServer(";re all") end)
task.wait(5)

pcall(function() rq:InvokeServer(";char all zczczczc722") end)
task.wait(1)
pcall(function() rq:InvokeServer(";music 87744462419495 ;pitch 0.13 ;volume 10") end)

task.wait(4)
pcall(function() rq:InvokeServer(";alert all realm_Rebzyyx") end)
pcall(function() rq:InvokeServer(";sm realm_Rebzyyx") end)
