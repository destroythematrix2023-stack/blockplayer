-- SERVICES
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local Vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- 🔒 INVISIBLE BLOCK (STRONGER)
local function BlockPlayer(player)
    if not player then return end

    pcall(function() setthreadidentity(8) end)

    StarterGui:SetCore("PromptBlockPlayer", player)

    local modal
    repeat
        modal = CoreGui:FindFirstChild("BlockingModalScreen")
        RunService.RenderStepped:Wait()
    until modal

    -- 💀 FORCE HIDE EVERYTHING BEFORE RENDER
    for _,v in pairs(modal:GetDescendants()) do
        if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("TextButton") then
            v.Visible = false
        end
    end

    local button = modal.BlockingModalContainer
        .BlockingModalContainerWrapper
        .BlockingModal.AlertModal.AlertContents.Footer.Buttons["3"]

    GuiService.SelectedObject = button

    Vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    Vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

    GuiService.SelectedObject = nil

    modal:Destroy() -- completely remove

    pcall(function() setthreadidentity(2) end)
end

-- 🎨 GUI
local gui = Instance.new("ScreenGui", CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 60)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

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

-- 🔽 DROPDOWN BUTTON
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1,-20,0,30)
toggle.Position = UDim2.new(0,10,0,15)
toggle.Text = "Select Player ▼"
toggle.Font = Enum.Font.GothamSemibold
toggle.TextSize = 14
toggle.BackgroundColor3 = Color3.fromRGB(45,45,65)
toggle.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

-- 📜 DROPDOWN LIST
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position = UDim2.new(0,10,0,50)
scroll.Size = UDim2.new(1,-20,0,0) -- closed
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1
scroll.Visible = false

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

local opened = false

-- 🎯 BUTTON CREATION
local function createButton(player)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,28)
    btn.Text = player.Name
    btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = scroll

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        BlockPlayer(player)
    end)
end

-- 🔄 REFRESH
local function refresh()
    for _,v in pairs(scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for _,plr in ipairs(Players:GetPlayers()) do
        createButton(plr)
    end

    task.wait()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end

-- 🔽 TOGGLE DROPDOWN
toggle.MouseButton1Click:Connect(function()
    opened = not opened

    if opened then
        scroll.Visible = true
        TweenService:Create(scroll, TweenInfo.new(0.25), {
            Size = UDim2.new(1,-20,0,200)
        }):Play()
        toggle.Text = "Select Player ▲"
    else
        TweenService:Create(scroll, TweenInfo.new(0.25), {
            Size = UDim2.new(1,-20,0,0)
        }):Play()
        task.wait(0.25)
        scroll.Visible = false
        toggle.Text = "Select Player ▼"
    end
end)

-- 🔁 AUTO UPDATE
Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)

refresh()
