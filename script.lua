local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local function BlockPlayer(player)
    if player then
        pcall(function()
            StarterGui:SetCore("BlockPlayer", player.UserId)
        end)
        print("Blocked:", player.Name)
    end
end

local function GetTradePartner()
    local Fsys = require(ReplicatedStorage:WaitForChild("Fsys"))
    local load = Fsys.load
    local UIManager = load("UIManager")

    if not UIManager then return end

    local TradeApp = UIManager.apps.TradeApp
    if not TradeApp then return end

    local partner = TradeApp:_get_partner()
    return partner
end

local gui = Instance.new("ScreenGui")
gui.Name = "TradeBlocker"
gui.Parent = LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,200,0,60)
frame.Position = UDim2.new(0,20,0,20)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.Parent = gui

local button = Instance.new("TextButton")
button.Size = UDim2.new(1,-10,1,-10)
button.Position = UDim2.new(0,5,0,5)
button.Text = "Block Trade Partner"
button.Parent = frame

button.MouseButton1Click:Connect(function()
    local partner = GetTradePartner()
    if partner then
        BlockPlayer(partner)
    else
        warn("No trade partner detected")
    end
end)
