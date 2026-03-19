local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- BLOCK FUNCTION
local function BlockPlayer(player)
    if not player then return end

    pcall(function()
        setthreadidentity(8)
    end)

    StarterGui:SetCore("PromptBlockPlayer", player)

    repeat RunService.Heartbeat:Wait()
    until CoreGui:FindFirstChild("BlockingModalScreen")

    local modal = CoreGui.BlockingModalScreen
    local button = modal.BlockingModalContainer
        .BlockingModalContainerWrapper
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
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "BlockUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 320)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scroll)

-- CREATE BUTTON
local function createButton(player)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 28)
    btn.Text = player.Name
    btn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = scroll

    btn.MouseButton1Click:Connect(function()
        BlockPlayer(player)
    end)
end

-- REFRESH
local function refresh()
    for _, v in ipairs(scroll:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        createButton(plr)
    end

    task.wait()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end

refresh()

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
