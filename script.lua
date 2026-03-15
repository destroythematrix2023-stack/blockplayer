local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local blockedPlayers = {}

local function blockPlayer(player)
	if player then
		blockedPlayers[player.UserId] = true
		print("Blocked interactions with:", player.Name)
	end
end

-- block trade requests
task.spawn(function()

	local Fsys = require(ReplicatedStorage:WaitForChild("Fsys"))
	local load = Fsys.load
	local RouterClient = load("RouterClient")

	local tradeEvent = RouterClient.get_event("TradeAPI/TradeRequestReceived")

	if tradeEvent then
		tradeEvent.OnClientEvent:Connect(function(player)
			if blockedPlayers[player.UserId] then
				print("Blocked trade request from",player.Name)
				return
			end
		end)
	end

end)

local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,140)
frame.Position = UDim2.new(0,200,0,200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,25)
title.Text = "Player Control"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1,-20,0,30)
dropdown.Position = UDim2.new(0,10,0,35)
dropdown.Text = "Select Player"
dropdown.Parent = frame

local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(1,-20,0,0)
listFrame.Position = UDim2.new(0,10,0,65)
listFrame.Visible = false
listFrame.Parent = frame

local selectedPlayer = nil

local function refreshPlayers()

	for _,v in pairs(listFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end

	local y = 0

	for _,p in pairs(Players:GetPlayers()) do

		if p ~= LocalPlayer then

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,0,0,25)
			btn.Position = UDim2.new(0,0,0,y)
			btn.Text = p.Name
			btn.Parent = listFrame

			btn.MouseButton1Click:Connect(function()

				selectedPlayer = p
				dropdown.Text = p.Name
				listFrame.Visible = false

			end)

			y = y + 25

		end

	end

	listFrame.Size = UDim2.new(1,-20,0,y)

end

dropdown.MouseButton1Click:Connect(function()

	listFrame.Visible = not listFrame.Visible

end)

refreshPlayers()

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

local blockBtn = Instance.new("TextButton")
blockBtn.Size = UDim2.new(1,-20,0,30)
blockBtn.Position = UDim2.new(0,10,1,-35)
blockBtn.Text = "Block Player"
blockBtn.Parent = frame

blockBtn.MouseButton1Click:Connect(function()

	blockPlayer(selectedPlayer)

end)

-- draggable gui
local dragging
local dragStart
local startPos

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
