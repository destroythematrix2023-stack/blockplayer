-- SERVICES
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- 🔒 INVISIBLE BLOCK FUNCTION
local function BlockPlayer(player)
    if not player then return end

    pcall(function()
        setthreadidentity(8)
    end)

    StarterGui:SetCore("PromptBlockPlayer", player)

    local modal
    repeat
        modal = CoreGui:FindFirstChild("BlockingModalScreen")
        RunService.RenderStepped:Wait()
    until modal

    -- 👻 hide instantly
    modal.Enabled = false

    local button = modal.BlockingModalContainer
        .BlockingModalContainerWrapper
        .BlockingModal.AlertModal.AlertContents.Footer.Buttons["3"]

    GuiService.SelectedObject = button

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

    GuiService.SelectedObject = nil

    pcall(function()
        setthreadidentity(2)
    end)
end

-- 🎨 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BlockUI"
gui.Parent = CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 360)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.BorderSizePixel = 0
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

-- 🔍 SEARCH BAR
local search = Instance.new("TextBox", frame)
search.Size = UDim2.new(1,-20,0,32)
search.Position = UDim2.new(0,10,0,10)
search.PlaceholderText = "Search player..."
search.BackgroundColor3 = Color3.fromRGB(40,40,55)
search.TextColor3 = Color3.new(1,1,1)
search.Font = Enum.Font.Gotham
search.TextSize = 14
search.ClearTextOnFocus = false

Instance.new("UICorner", search).CornerRadius = UDim.new(0,8)

-- 📜 SCROLL LIST
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position = UDim2.new(0,10,0,50)
scroll.Size = UDim2.new(1,-20,1,-60)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

-- 🎯 CREATE PLAYER BUTTON
local function createButton(player)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,32)
    btn.Text = player.Name
    btn.BackgroundColor3 = Color3.fromRGB(45,45,65)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Parent = scroll

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    -- hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(70,70,100)
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(45,45,65)
        }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        BlockPlayer(player)
    end)
end

-- 🔄 REFRESH LIST
local function refreshList(filter)
    for _,v in pairs(scroll:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    for _,plr in ipairs(Players:GetPlayers()) do
        if not filter or string.find(string.lower(plr.Name), filter) then
            createButton(plr)
        end
    end

    task.wait()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end

-- 🔍 SEARCH FILTER
search:GetPropertyChangedSignal("Text"):Connect(function()
    local text = string.lower(search.Text)
    refreshList(text ~= "" and text or nil)
end)

-- 🔁 AUTO UPDATE
Players.PlayerAdded:Connect(function()
    refreshList(string.lower(search.Text))
end)

Players.PlayerRemoving:Connect(function()
    refreshList(string.lower(search.Text))
end)

-- 🚀 INIT
refreshList()
