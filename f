--// Run.Line Hub UI Library

local RunLine = {}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Screen = Instance.new("ScreenGui")
Screen.Name = "RunLineHub"
Screen.ResetOnSpawn = false
Screen.Parent = PlayerGui

function RunLine:CreateWindow(title)

title = title or "Run.Line Hub"

local Window = {}

-- MAIN
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,640,0,420)
Main.Position = UDim2.new(.5,-320,.5,-210)
Main.BackgroundColor3 = Color3.fromRGB(17,20,28)
Main.Parent = Screen
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,8)

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,40)
Header.BackgroundColor3 = Color3.fromRGB(20,24,34)
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = title
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,10,0,0)
Title.Size = UDim2.new(1,0,1,0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,150,1,-40)
Sidebar.Position = UDim2.new(0,0,0,40)
Sidebar.BackgroundColor3 = Color3.fromRGB(14,17,24)
Sidebar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = Sidebar
TabLayout.Padding = UDim.new(0,5)

-- PAGE HOLDER
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1,-150,1,-40)
Pages.Position = UDim2.new(0,150,0,40)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

-- DRAGGING
local dragging, dragInput, startPos, startInput

Header.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
startInput = input.Position
startPos = Main.Position
end
end)

UIS.InputChanged:Connect(function(input)
if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
local delta = input.Position - startInput
Main.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)
end
end)

UIS.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = false
end
end)

-- TAB CREATION
function Window:CreateTab(name)

local Tab = {}

local TabButton = Instance.new("TextButton")
TabButton.Text = name
TabButton.Size = UDim2.new(1,0,0,35)
TabButton.BackgroundColor3 = Color3.fromRGB(20,25,35)
TabButton.TextColor3 = Color3.fromRGB(200,200,200)
TabButton.Font = Enum.Font.Gotham
TabButton.TextSize = 14
TabButton.Parent = Sidebar
Instance.new("UICorner",TabButton)

local Page = Instance.new("ScrollingFrame")
Page.Size = UDim2.new(1,0,1,0)
Page.BackgroundTransparency = 1
Page.ScrollBarThickness = 4
Page.Visible = false
Page.Parent = Pages

local Layout = Instance.new("UIListLayout")
Layout.Parent = Page
Layout.Padding = UDim.new(0,6)

TabButton.MouseButton1Click:Connect(function()

for _,v in pairs(Pages:GetChildren()) do
if v:IsA("ScrollingFrame") then
v.Visible = false
end
end

Page.Visible = true

end)

-- BUTTON
function Tab:AddButton(text,callback)

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1,-10,0,35)
Btn.Text = text
Btn.BackgroundColor3 = Color3.fromRGB(25,30,40)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.Gotham
Btn.TextSize = 14
Btn.Parent = Page
Instance.new("UICorner",Btn)

Btn.MouseButton1Click:Connect(callback)

end

-- TOGGLE
function Tab:AddToggle(text,callback)

local state = false

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1,-10,0,35)
Toggle.BackgroundColor3 = Color3.fromRGB(25,30,40)
Toggle.Text = text.." : OFF"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.Gotham
Toggle.TextSize = 14
Toggle.Parent = Page
Instance.new("UICorner",Toggle)

Toggle.MouseButton1Click:Connect(function()

state = not state
Toggle.Text = text.." : "..(state and "ON" or "OFF")

callback(state)

end)

end

-- SLIDER
function Tab:AddSlider(text,min,max,callback)

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1,-10,0,50)
Frame.BackgroundColor3 = Color3.fromRGB(25,30,40)
Frame.Parent = Page
Instance.new("UICorner",Frame)

local Label = Instance.new("TextLabel")
Label.Text = text.." : "..min
Label.BackgroundTransparency = 1
Label.Size = UDim2.new(1,0,0,20)
Label.TextColor3 = Color3.new(1,1,1)
Label.Font = Enum.Font.Gotham
Label.TextSize = 13
Label.Parent = Frame

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(1,-20,0,6)
Bar.Position = UDim2.new(0,10,0,30)
Bar.BackgroundColor3 = Color3.fromRGB(40,45,60)
Bar.Parent = Frame
Instance.new("UICorner",Bar)

local Fill = Instance.new("Frame")
Fill.Size = UDim2.new(0,0,1,0)
Fill.BackgroundColor3 = Color3.fromRGB(80,130,255)
Fill.Parent = Bar
Instance.new("UICorner",Fill)

local dragging = false

Bar.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
end
end)

UIS.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = false
end
end)

UIS.InputChanged:Connect(function(input)

if dragging then

local pos = (input.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X
pos = math.clamp(pos,0,1)

Fill.Size = UDim2.new(pos,0,1,0)

local value = math.floor((max-min)*pos+min)

Label.Text = text.." : "..value

callback(value)

end

end)

end

-- DROPDOWN
function Tab:AddDropdown(text,list,callback)

local Drop = Instance.new("TextButton")
Drop.Size = UDim2.new(1,-10,0,35)
Drop.Text = text
Drop.BackgroundColor3 = Color3.fromRGB(25,30,40)
Drop.TextColor3 = Color3.new(1,1,1)
Drop.Font = Enum.Font.Gotham
Drop.TextSize = 14
Drop.Parent = Page
Instance.new("UICorner",Drop)

Drop.MouseButton1Click:Connect(function()

local choice = list[math.random(1,#list)]
Drop.Text = text.." : "..choice

callback(choice)

end)

end

return Tab

end

return Window

end

return RunLine
