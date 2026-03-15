local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

local function BlockPlayer(player)
    if player then
        pcall(function()
            StarterGui:SetCore("BlockPlayer", player.UserId)
        end)
    end
end

local function GetTradePartner()
    local tradeGui = LocalPlayer.PlayerGui:FindFirstChild("TradeApp")
    if not tradeGui then return end

    local name = tradeGui.Frame.NegotiationFrame.Header.PartnerFrame.NameLabel.Text

    for _,p in pairs(Players:GetPlayers()) do
        if p.Name:lower() == name:lower() then
            return p
        end
    end
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
    BlockPlayer(partner)
end)
