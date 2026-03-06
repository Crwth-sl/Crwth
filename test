local MegaUI = {}
MegaUI.__index = MegaUI

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- THEMES

MegaUI.Themes = {

Dark = {
Background = Color3.fromRGB(15,15,15),
Secondary = Color3.fromRGB(25,25,25),
Accent = Color3.fromRGB(0,170,255),
Text = Color3.fromRGB(255,255,255)
},

Neon = {
Background = Color3.fromRGB(5,5,5),
Secondary = Color3.fromRGB(20,20,20),
Accent = Color3.fromRGB(0,255,200),
Text = Color3.fromRGB(200,255,255)
},

Cyber = {
Background = Color3.fromRGB(10,10,30),
Secondary = Color3.fromRGB(30,30,60),
Accent = Color3.fromRGB(200,0,255),
Text = Color3.fromRGB(255,255,255)
}

}

MegaUI.Theme = MegaUI.Themes.Dark

function MegaUI:SetTheme(name)
if MegaUI.Themes[name] then
MegaUI.Theme = MegaUI.Themes[name]
end
end

-- WINDOW

function MegaUI:CreateWindow(title)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,700,0,450)
Main.Position = UDim2.new(.5,-350,.5,-225)
Main.BackgroundColor3 = MegaUI.Theme.Background
Main.Parent = ScreenGui

Instance.new("UICorner",Main)

-- DRAG SYSTEM

local dragging = false
local dragInput
local dragStart
local startPos

Main.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
dragStart = input.Position
startPos = Main.Position
end
end)

UIS.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement then
dragInput = input
end
end)

UIS.InputChanged:Connect(function(input)

if input == dragInput and dragging then

local delta = input.Position - dragStart

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

-- TOP BAR

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,40)
Top.BackgroundColor3 = MegaUI.Theme.Secondary
Top.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = title
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.TextColor3 = MegaUI.Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Top

-- TAB LIST

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0,150,1,-40)
Tabs.Position = UDim2.new(0,0,0,40)
Tabs.BackgroundColor3 = MegaUI.Theme.Secondary
Tabs.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = Tabs

-- PAGE CONTAINER

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1,-150,1,-40)
Container.Position = UDim2.new(0,150,0,40)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Window = {}

function Window:CreateTab(name)

local TabButton = Instance.new("TextButton")
TabButton.Size = UDim2.new(1,0,0,40)
TabButton.Text = name
TabButton.BackgroundTransparency = 1
TabButton.TextColor3 = MegaUI.Theme.Text
TabButton.Parent = Tabs

local Page = Instance.new("ScrollingFrame")
Page.Size = UDim2.new(1,0,1,0)
Page.CanvasSize = UDim2.new(0,0,0,0)
Page.ScrollBarThickness = 4
Page.Visible = false
Page.BackgroundTransparency = 1
Page.Parent = Container

local Layout = Instance.new("UIListLayout")
Layout.Parent = Page
Layout.Padding = UDim.new(0,10)

TabButton.MouseButton1Click:Connect(function()

for _,v in pairs(Container:GetChildren()) do
if v:IsA("ScrollingFrame") then
v.Visible = false
end
end

Page.Visible = true

end)

local Tab = {}

function Tab:CreateSection(title)

local Section = Instance.new("Frame")
Section.Size = UDim2.new(1,-20,0,160)
Section.BackgroundColor3 = MegaUI.Theme.Secondary
Section.Parent = Page

Instance.new("UICorner",Section)

local Label = Instance.new("TextLabel")
Label.Text = title
Label.Size = UDim2.new(1,0,0,25)
Label.BackgroundTransparency = 1
Label.TextColor3 = MegaUI.Theme.Text
Label.Parent = Section

local Holder = Instance.new("Frame")
Holder.Size = UDim2.new(1,0,1,-25)
Holder.Position = UDim2.new(0,0,0,25)
Holder.BackgroundTransparency = 1
Holder.Parent = Section

local Layout = Instance.new("UIListLayout")
Layout.Parent = Holder
Layout.Padding = UDim.new(0,6)

local Elements = {}

-- BUTTON

function Elements:Button(text,callback)

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1,-10,0,30)
Button.Text = text
Button.BackgroundColor3 = MegaUI.Theme.Accent
Button.TextColor3 = Color3.new(1,1,1)
Button.Parent = Holder

Instance.new("UICorner",Button)

Button.MouseButton1Click:Connect(function()
pcall(callback)
end)

end

-- TOGGLE

function Elements:Toggle(text,callback)

local enabled = false

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1,-10,0,30)
Toggle.Text = text
Toggle.BackgroundColor3 = MegaUI.Theme.Secondary
Toggle.TextColor3 = MegaUI.Theme.Text
Toggle.Parent = Holder

Instance.new("UICorner",Toggle)

Toggle.MouseButton1Click:Connect(function()

enabled = not enabled

TweenService:Create(
Toggle,
TweenInfo.new(.2),
{
BackgroundColor3 = enabled and MegaUI.Theme.Accent or MegaUI.Theme.Secondary
}
):Play()

callback(enabled)

end)

end

-- SLIDER

function Elements:Slider(text,min,max,callback)

local Value = min

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1,-10,0,40)
Frame.BackgroundTransparency = 1
Frame.Parent = Holder

local Label = Instance.new("TextLabel")
Label.Text = text.." : "..Value
Label.Size = UDim2.new(1,0,0,20)
Label.BackgroundTransparency = 1
Label.TextColor3 = MegaUI.Theme.Text
Label.Parent = Frame

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(1,0,0,10)
Bar.Position = UDim2.new(0,0,0,25)
Bar.BackgroundColor3 = MegaUI.Theme.Secondary
Bar.Parent = Frame

local Fill = Instance.new("Frame")
Fill.Size = UDim2.new(0,0,1,0)
Fill.BackgroundColor3 = MegaUI.Theme.Accent
Fill.Parent = Bar

Bar.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

local move
move = UIS.InputChanged:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseMovement then

local percent = math.clamp(
(input.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,
0,1)

Fill.Size = UDim2.new(percent,0,1,0)

Value = math.floor((max-min)*percent+min)

Label.Text = text.." : "..Value

callback(Value)

end

end)

UIS.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then
move:Disconnect()
end

end)

end

end)

end

return Elements

end

return Tab

end

return Window

end

-- NOTIFICATIONS

function MegaUI:Notify(text)

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(0,250,0,40)
Label.Position = UDim2.new(1,-260,1,-50)
Label.BackgroundColor3 = MegaUI.Theme.Secondary
Label.Text = text
Label.TextColor3 = MegaUI.Theme.Text
Label.Parent = game.CoreGui

TweenService:Create(Label,TweenInfo.new(.3),
{Position = UDim2.new(1,-260,1,-120)}
):Play()

task.wait(3)

Label:Destroy()

end

return MegaUI
