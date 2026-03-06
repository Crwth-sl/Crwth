local UILib = {}
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FutureUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Tween helper
local function Tween(obj,props,time)
	TweenService:Create(obj,TweenInfo.new(time,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play()
end

function UILib:CreateWindow(title)

	local Window = {}

	-- Main
	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0,620,0,420)
	Main.Position = UDim2.new(.5,-310,.5,-210)
	Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
	Main.Parent = ScreenGui
	
	Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

	-- Glow
	local Stroke = Instance.new("UIStroke",Main)
	Stroke.Color = Color3.fromRGB(80,140,255)
	Stroke.Thickness = 1.5

	-- Topbar
	local Top = Instance.new("Frame")
	Top.Size = UDim2.new(1,0,0,45)
	Top.BackgroundTransparency = 1
	Top.Parent = Main

	local Title = Instance.new("TextLabel")
	Title.Text = title
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,15,0,0)
	Title.Size = UDim2.new(1,0,1,0)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Top

	-- Tab holder
	local Tabs = Instance.new("Frame")
	Tabs.Size = UDim2.new(0,150,1,-45)
	Tabs.Position = UDim2.new(0,0,0,45)
	Tabs.BackgroundTransparency = 1
	Tabs.Parent = Main

	local TabLayout = Instance.new("UIListLayout",Tabs)
	TabLayout.Padding = UDim.new(0,6)

	-- Page holder
	local Pages = Instance.new("Frame")
	Pages.Size = UDim2.new(1,-160,1,-55)
	Pages.Position = UDim2.new(0,155,0,50)
	Pages.BackgroundTransparency = 1
	Pages.Parent = Main

	-- Dragging
	local dragToggle, dragStart, startPos

	Top.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragToggle = true
			dragStart = input.Position
			startPos = Main.Position
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragToggle = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	-- Tab function
	function Window:CreateTab(name)

		local Tab = {}

		local Button = Instance.new("TextButton")
		Button.Size = UDim2.new(1,-10,0,38)
		Button.BackgroundColor3 = Color3.fromRGB(25,25,30)
		Button.Text = name
		Button.TextColor3 = Color3.fromRGB(200,200,200)
		Button.Font = Enum.Font.Gotham
		Button.TextSize = 14
		Button.Parent = Tabs

		Instance.new("UICorner",Button).CornerRadius = UDim.new(0,8)

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1,0,1,0)
		Page.ScrollBarThickness = 3
		Page.Visible = false
		Page.BackgroundTransparency = 1
		Page.Parent = Pages

		local Layout = Instance.new("UIListLayout",Page)
		Layout.Padding = UDim.new(0,8)

		Button.MouseEnter:Connect(function()
			Tween(Button,{BackgroundColor3 = Color3.fromRGB(40,40,50)},.15)
		end)

		Button.MouseLeave:Connect(function()
			Tween(Button,{BackgroundColor3 = Color3.fromRGB(25,25,30)},.15)
		end)

		Button.MouseButton1Click:Connect(function()
			for _,v in pairs(Pages:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			Page.Visible = true
		end)

		-- Button element
		function Tab:AddButton(text,callback)

			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1,-6,0,36)
			Btn.BackgroundColor3 = Color3.fromRGB(28,28,34)
			Btn.Text = text
			Btn.TextColor3 = Color3.fromRGB(255,255,255)
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.Parent = Page

			Instance.new("UICorner",Btn).CornerRadius = UDim.new(0,8)

			Btn.MouseEnter:Connect(function()
				Tween(Btn,{BackgroundColor3 = Color3.fromRGB(60,80,150)},.15)
			end)

			Btn.MouseLeave:Connect(function()
				Tween(Btn,{BackgroundColor3 = Color3.fromRGB(28,28,34)},.15)
			end)

			Btn.MouseButton1Click:Connect(function()
				callback()
			end)
		end

		-- Toggle element
		function Tab:AddToggle(text,callback)

			local state = false

			local Toggle = Instance.new("TextButton")
			Toggle.Size = UDim2.new(1,-6,0,36)
			Toggle.BackgroundColor3 = Color3.fromRGB(28,28,34)
			Toggle.Text = text.." : OFF"
			Toggle.TextColor3 = Color3.fromRGB(255,255,255)
			Toggle.Font = Enum.Font.Gotham
			Toggle.TextSize = 14
			Toggle.Parent = Page

			Instance.new("UICorner",Toggle).CornerRadius = UDim.new(0,8)

			Toggle.MouseButton1Click:Connect(function()

				state = not state

				if state then
					Toggle.Text = text.." : ON"
					Tween(Toggle,{BackgroundColor3 = Color3.fromRGB(70,130,255)},.2)
				else
					Toggle.Text = text.." : OFF"
					Tween(Toggle,{BackgroundColor3 = Color3.fromRGB(28,28,34)},.2)
				end

				callback(state)

			end)
		end

		return Tab

	end

	return Window
end

return UILib
