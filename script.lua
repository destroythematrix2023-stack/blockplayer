local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- BLOCK FUNCTION (auto confirms UI)
local function BlockPlayer(player)
    if not player then return end

    pcall(function()
        setthreadidentity(8)
    end)

    StarterGui:SetCore("PromptBlockPlayer", player)

    repeat RunService.Heartbeat:Wait()
    until CoreGui:FindFirstChild("BlockingModalScreen")

    local button = CoreGui.BlockingModalScreen
        .BlockingModalContainer.BlockingModalContainerWrapper
        .BlockingModal.AlertModal.AlertContents.Footer.Buttons["3"]

    GuiService.SelectedObject = button
    task.wait()

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

    GuiService.SelectedObject = nil

    pcall(function()
        setthreadidentity(2)
    end)
end

-- UI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = screenGui

local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, 0, 1, 0)
scrolling.CanvasSize = UDim2.new(0,0,0,0)
scrolling.ScrollBarThickness = 6
scrolling.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scrolling

-- CREATE BUTTON
local function createPlayerButton(player)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 30)
    btn.Text = player.Name
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = scrolling

    btn.MouseButton1Click:Connect(function()
        BlockPlayer(player)
    end)
end

-- REFRESH LIST
local function refreshList()
    for _, child in ipairs(scrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        createPlayerButton(player)
    end

    task.wait()
    scrolling.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y)
end

-- INITIAL LOAD
refreshList()

-- AUTO UPDATE
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
