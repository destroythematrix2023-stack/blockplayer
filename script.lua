local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local blocked = {}

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,150,0,55)
frame.Position = UDim2.new(0,200,0,200)
frame.BackgroundColor3 = Color3.fromRGB(25,25,30)
frame.Parent = gui

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1,-10,0,20)
dropdown.Position = UDim2.new(0,5,0,5)
dropdown.Text = "Select Player"
dropdown.Parent = frame

local blockBtn = Instance.new("TextButton")
blockBtn.Size = UDim2.new(1,-10,0,20)
blockBtn.Position = UDim2.new(0,5,0,30)
blockBtn.Text = "Block"
blockBtn.Parent = frame

local list = Instance.new("Frame")
list.Position = UDim2.new(0,0,1,0)
list.Size = UDim2.new(1,0,0,0)
list.Visible = false
list.Parent = frame

local selected

local function refresh()
	for _,v in pairs(list:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end

	local y = 0
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1,0,0,18)
			b.Position = UDim2.new(0,0,0,y)
			b.Text = p.Name
			b.Parent = list

			b.MouseButton1Click:Connect(function()
				selected = p
				dropdown.Text = p.Name
				list.Visible = false
			end)

			y += 18
		end
	end

	list.Size = UDim2.new(1,0,0,y)
end

dropdown.MouseButton1Click:Connect(function()
	list.Visible = not list.Visible
end)

blockBtn.MouseButton1Click:Connect(function()
	if selected then
		blocked[selected.UserId] = true
		print("Blocked:",selected.Name)
	end
end)

refresh()

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)

task.spawn(function()
	local Fsys = require(ReplicatedStorage:WaitForChild("Fsys"))
	local load = Fsys.load
	local RouterClient = load("RouterClient")

	local tradeEvent = RouterClient.get_event("TradeAPI/TradeRequestReceived")

	if tradeEvent then
		tradeEvent.OnClientEvent:Connect(function(player)
			if blocked[player.UserId] then
				print("Ignored trade from",player.Name)
				return
			end
		end)
	end
end)

-- draggable
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

frame.InputChanged:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
