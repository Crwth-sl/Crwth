local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

UILibrary.Themes = {

Dark = {
Background = Color3.fromRGB(15,15,15),
Secondary = Color3.fromRGB(25,25,25),
Accent = Color3.fromRGB(0,170,255),
Text = Color3.fromRGB(255,255,255)
},

Neon = {
Background = Color3.fromRGB(5,5,5),
Secondary = Color3.fromRGB(15,15,15),
Accent = Color3.fromRGB(0,255,200),
Text = Color3.fromRGB(200,255,255)
},

Cyber = {
Background = Color3.fromRGB(10,10,25),
Secondary = Color3.fromRGB(20,20,45),
Accent = Color3.fromRGB(170,0,255),
Text = Color3.fromRGB(255,255,255)
},

Glass = {
Background = Color3.fromRGB(40,40,40),
Secondary = Color3.fromRGB(60,60,60),
Accent = Color3.fromRGB(0,200,255),
Text = Color3.fromRGB(255,255,255)
}

}

UILibrary.Theme = UILibrary.Themes.Dark

function UILibrary:SetTheme(theme)
if UILibrary.Themes[theme] then
UILibrary.Theme = UILibrary.Themes[theme]
end
end

function UILibrary:CreateWindow(title)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,600,0,420)
Main.Position = UDim2.new(.5,-300,.5,-210)
Main.BackgroundColor3 = UILibrary.Theme.Background
Main.Parent = ScreenGui

Instance.new("UICorner",Main)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundColor3 = UILibrary.Theme.Secondary
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = title
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = UILibrary.Theme.Text
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.Parent = TopBar

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0,140,1,-40)
Tabs.Position = UDim2.new(0,0,0,40)
Tabs.BackgroundColor3 = UILibrary.Theme.Secondary
Tabs.Parent = Main

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1,-140,1,-40)
Container.Position = UDim2.new(0,140,0,40)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Window = {}
Window.Tabs = {}

function Window:CreateTab(name)

local TabButton = Instance.new("TextButton")
TabButton.Text = name
TabButton.Size = UDim2.new(1,0,0,40)
TabButton.BackgroundTransparency = 1
TabButton.TextColor3 = UILibrary.Theme.Text
TabButton.Parent = Tabs

local Page = Instance.new("ScrollingFrame")
Page.Visible = false
Page.Size = UDim2.new(1,0,1,0)
Page.BackgroundTransparency = 1
Page.Parent = Container

local Layout = Instance.new("UIListLayout",Page)
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

function Tab:CreateSection(text)

local Section = Instance.new("Frame")
Section.Size = UDim2.new(1,-10,0,120)
Section.BackgroundColor3 = UILibrary.Theme.Secondary
Section.Parent = Page

Instance.new("UICorner",Section)

local Title = Instance.new("TextLabel")
Title.Text = text
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.TextColor3 = UILibrary.Theme.Text
Title.Parent = Section

local Holder = Instance.new("Frame")
Holder.BackgroundTransparency = 1
Holder.Size = UDim2.new(1,0,1,-30)
Holder.Position = UDim2.new(0,0,0,30)
Holder.Parent = Section

local Layout = Instance.new("UIListLayout",Holder)
Layout.Padding = UDim.new(0,6)

local Elements = {}

function Elements:Button(text,callback)

local Button = Instance.new("TextButton")
Button.Text = text
Button.Size = UDim2.new(1,-10,0,30)
Button.BackgroundColor3 = UILibrary.Theme.Accent
Button.TextColor3 = Color3.new(1,1,1)
Button.Parent = Holder

Instance.new("UICorner",Button)

Button.MouseButton1Click:Connect(function()
pcall(callback)
end)

end

function Elements:Toggle(text,callback)

local State = false

local Toggle = Instance.new("TextButton")
Toggle.Text = text
Toggle.Size = UDim2.new(1,-10,0,30)
Toggle.BackgroundColor3 = UILibrary.Theme.Secondary
Toggle.TextColor3 = UILibrary.Theme.Text
Toggle.Parent = Holder

Instance.new("UICorner",Toggle)

Toggle.MouseButton1Click:Connect(function()

State = not State

if State then
Toggle.BackgroundColor3 = UILibrary.Theme.Accent
else
Toggle.BackgroundColor3 = UILibrary.Theme.Secondary
end

pcall(callback,State)

end)

end

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
Label.TextColor3 = UILibrary.Theme.Text
Label.Parent = Frame

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(1,0,0,10)
Bar.Position = UDim2.new(0,0,0,25)
Bar.BackgroundColor3 = UILibrary.Theme.Secondary
Bar.Parent = Frame

local Fill = Instance.new("Frame")
Fill.Size = UDim2.new(0,0,1,0)
Fill.BackgroundColor3 = UILibrary.Theme.Accent
Fill.Parent = Bar

Bar.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

UIS.InputChanged:Connect(function(move)

if move.UserInputType == Enum.UserInputType.MouseMovement then

local Percent = math.clamp(
(move.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,
0,1)

Fill.Size = UDim2.new(Percent,0,1,0)

Value = math.floor((max-min)*Percent+min)

Label.Text = text.." : "..Value

callback(Value)

end

end)

end

end)

end

function UILibrary:Notify(text)

local Notif = Instance.new("TextLabel")
Notif.Size = UDim2.new(0,250,0,50)
Notif.Position = UDim2.new(1,-260,1,-60)
Notif.BackgroundColor3 = UILibrary.Theme.Secondary
Notif.Text = text
Notif.TextColor3 = UILibrary.Theme.Text
Notif.Parent = game.CoreGui

TweenService:Create(
Notif,
TweenInfo.new(.5),
{Position = UDim2.new(1,-260,1,-120)}
):Play()

task.wait(3)

Notif:Destroy()

end
