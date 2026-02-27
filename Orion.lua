--// Orange Sidebar UI Library
local Library = {}
Library.__index = Library

-- Theme
local Theme = {
    Background = Color3.fromRGB(15,15,15),
    Section = Color3.fromRGB(20,20,20),
    Accent = Color3.fromRGB(255,120,0),
    Text = Color3.fromRGB(220,220,220)
}

-- Create Window
function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OrangeUI"
    ScreenGui.Parent = game.CoreGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 750, 0, 450)
    Main.Position = UDim2.new(0.5, -375, 0.5, -225)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 60, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10,10,10)
    Sidebar.BorderSizePixel = 0

    local TabContainer = Instance.new("Frame", Main)
    TabContainer.Position = UDim2.new(0, 60, 0, 0)
    TabContainer.Size = UDim2.new(1, -60, 1, 0)
    TabContainer.BackgroundTransparency = 1

    local UIList = Instance.new("UIListLayout", Sidebar)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIList.Padding = UDim.new(0, 10)

    local Window = {}
    Window.Tabs = {}

    function Window:AddTab(name)
        local TabButton = Instance.new("TextButton", Sidebar)
        TabButton.Size = UDim2.new(0, 40, 0, 40)
        TabButton.Text = ""
        TabButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
        TabButton.BorderSizePixel = 0
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0,6)

        local Page = Instance.new("ScrollingFrame", TabContainer)
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0,10,0,10)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ScrollBarThickness = 4
        Page.BackgroundTransparency = 1
        Page.Visible = false

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,8)

        Window.Tabs[name] = Page

        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(Window.Tabs) do
                v.Visible = false
            end
            Page.Visible = true
        end)

        local Tab = {}

        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel", Page)
            Label.Size = UDim2.new(1, -10, 0, 30)
            Label.BackgroundColor3 = Theme.Section
            Label.Text = text
            Label.TextColor3 = Theme.Text
            Label.BorderSizePixel = 0
            Instance.new("UICorner", Label)
        end

        function Tab:AddButton(text, callback)
            local Button = Instance.new("TextButton", Page)
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.BackgroundColor3 = Theme.Section
            Button.Text = text
            Button.TextColor3 = Theme.Text
            Button.BorderSizePixel = 0
            Instance.new("UICorner", Button)

            Button.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        function Tab:AddToggle(text, callback)
            local Toggle = Instance.new("TextButton", Page)
            Toggle.Size = UDim2.new(1, -10, 0, 35)
            Toggle.BackgroundColor3 = Theme.Section
            Toggle.Text = text .. " : OFF"
            Toggle.TextColor3 = Theme.Text
            Toggle.BorderSizePixel = 0
            Instance.new("UICorner", Toggle)

            local state = false
            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Toggle.Text = text .. " : " .. (state and "ON" or "OFF")
                callback(state)
            end)
        end

        function Tab:AddSlider(text, min, max, callback)
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(1, -10, 0, 50)
            SliderFrame.BackgroundColor3 = Theme.Section
            SliderFrame.BorderSizePixel = 0
            Instance.new("UICorner", SliderFrame)

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Text = text .. ": " .. min
            Label.TextColor3 = Theme.Text

            local Bar = Instance.new("Frame", SliderFrame)
            Bar.Position = UDim2.new(0,10,0,30)
            Bar.Size = UDim2.new(1,-20,0,8)
            Bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
            Instance.new("UICorner", Bar)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new(0,0,1,0)
            Fill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", Fill)

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local conn
                    conn = game:GetService("UserInputService").InputChanged:Connect(function(move)
                        if move.UserInputType == Enum.UserInputType.MouseMovement then
                            local percent = math.clamp(
                                (move.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
                                0,1
                            )
                            Fill.Size = UDim2.new(percent,0,1,0)
                            local value = math.floor(min + (max-min)*percent)
                            Label.Text = text .. ": " .. value
                            callback(value)
                        end
                    end)

                    game:GetService("UserInputService").InputEnded:Connect(function(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                            conn:Disconnect()
                        end
                    end)
                end
            end)
        end

        return Tab
    end

    return Window
end

return Library
