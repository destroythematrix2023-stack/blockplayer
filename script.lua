local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "BlockPlayerGUI"
gui.Parent = LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,120)
frame.Position = UDim2.new(0,200,0,200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.Parent = gui

local corner = Instance.new("UICorner",frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,25)
title.BackgroundTransparency = 1
title.Text = "Player Blocker"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1,-20,0,30)
dropdown.Position = UDim2.new(0,10,0,35)
dropdown.Text = "Select Player"
dropdown.Parent = frame

local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(1,-20,0,0)
listFrame.Position = UDim2.new(0,10,0,65)
listFrame.BackgroundColor3 = Color3.fromRGB(40,40,50)
listFrame.Visible = false
listFrame.Parent = frame

local selectedPlayer = nil

local function blockPlayer(player)
    if player then
        pcall(function()
            StarterGui:SetCore("BlockPlayer",player.UserId)
        end)
    end
end

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
                listFrame.Size = UDim2.new(1,-20,0,0)
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
blockBtn.Text = "Block Selected Player"
blockBtn.Parent = frame

blockBtn.MouseButton1Click:Connect(function()
    blockPlayer(selectedPlayer)
end)

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

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
