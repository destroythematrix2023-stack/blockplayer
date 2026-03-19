--// SERVICES
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

--// 👻 DESTROY ROBLOX BLOCK UI INSTANTLY
task.spawn(function()
    while true do
        local modal = CoreGui:FindFirstChild("BlockingModalScreen")
        if modal then
            modal:Destroy()
        end
        task.wait()
    end
end)

--// ⚡ BLOCK FUNCTION
local function BlockPlayer(player)
    if not player then return end

    pcall(function() setthreadidentity(8) end)

    StarterGui:SetCore("PromptBlockPlayer", player)

    -- instant confirm
    Vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    Vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

    GuiService.SelectedObject = nil

    pcall(function() setthreadidentity(2) end)
end

--// 🎨 GUI
local gui = Instance.new("ScreenGui", CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 150)
frame.Position = UDim2.new(0.5, -130, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- 🌈 RGB BORDER
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2

task.spawn(function()
    while true do
        for i = 0,1,0.01 do
            stroke.Color = Color3.fromHSV(i,1,1)
            task.wait()
        end
    end
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Block Player"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)

--// 🔽 DROPDOWN BUTTON
local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(1,-20,0,35)
dropdown.Position = UDim2.new(0,10,0,35)
dropdown.Text = "Select Player ▼"
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.BackgroundColor3 = Color3.fromRGB(35,35,50)
dropdown.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,8)

-- LIST
local list = Instance.new("ScrollingFrame", frame)
list.Position = UDim2.new(0,10,0,75)
list.Size = UDim2.new(1,-20,0,0)
list.CanvasSize = UDim2.new(0,0,0,0)
list.ScrollBarThickness = 4
list.BackgroundTransparency = 1
list.Visible = false

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,5)

-- BLOCK BUTTON
local blockBtn = Instance.new("TextButton", frame)
blockBtn.Size = UDim2.new(1,-20,0,35)
blockBtn.Position = UDim2.new(0,10,1,-45)
blockBtn.Text = "Block"
blockBtn.Font = Enum.Font.GothamBold
blockBtn.TextSize = 14
blockBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
blockBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", blockBtn).CornerRadius = UDim.new(0,8)

-- STATE
local selectedPlayer = nil
local open = false

-- CREATE PLAYER BUTTON
local function createPlayerButton(plr)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,28)
    btn.Text = plr.Name
    btn.BackgroundColor3 = Color3.fromRGB(45,45,65)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = list

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        selectedPlayer = plr
        dropdown.Text = plr.Name .. " ▲"
        
        -- close dropdown
        open = false
        TweenService:Create(list, TweenInfo.new(0.2), {
            Size = UDim2.new(1,-20,0,0)
        }):Play()
        task.wait(0.2)
        list.Visible = false
    end)
end

-- REFRESH
local function refresh()
    for _,v in pairs(list:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for _,plr in ipairs(Players:GetPlayers()) do
        createPlayerButton(plr)
    end

    task.wait()
    list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end

-- DROPDOWN TOGGLE
dropdown.MouseButton1Click:Connect(function()
    open = not open

    if open then
        list.Visible = true
        TweenService:Create(list, TweenInfo.new(0.25), {
            Size = UDim2.new(1,-20,0,120)
        }):Play()
        dropdown.Text = "Select Player ▲"
    else
        TweenService:Create(list, TweenInfo.new(0.25), {
            Size = UDim2.new(1,-20,0,0)
        }):Play()
        task.wait(0.2)
        list.Visible = false
        dropdown.Text = "Select Player ▼"
    end
end)

-- BLOCK BUTTON CLICK
blockBtn.MouseButton1Click:Connect(function()
    if selectedPlayer then
        BlockPlayer(selectedPlayer)

        -- 🟢 success animation
        blockBtn.Text = "Blocked!"
        TweenService:Create(blockBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60,200,100)
        }):Play()

        task.wait(1)

        blockBtn.Text = "Block"
        TweenService:Create(blockBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(200,50,50)
        }):Play()
    end
end)

-- AUTO UPDATE
Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)

refresh()
