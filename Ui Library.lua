--// Synapse-Style UI Library (Part 1 - Core)

local Library = {}
Library.__index = Library

--// Services
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

--// Theme
local Theme = {
    Background = Color3.fromRGB(26, 26, 26),
    Sidebar = Color3.fromRGB(21, 21, 21),
    Section = Color3.fromRGB(32, 32, 32),
    Accent = Color3.fromRGB(0, 120, 255),
    Text = Color3.fromRGB(220, 220, 220),
    SubText = Color3.fromRGB(170, 170, 170)
}

--// Tween Utility
local function Tween(obj, time, props)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

--// Create Window
function Library:CreateWindow(config)

    config = config or {}
    local title = config.Title or "Kavo UI"
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightShift

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SynapseStyleUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 480, 0, 360)
    Main.Position = UDim2.new(0.5, -240, 0.5, -180)
    Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,6)

    -- Top Bar
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1,0,0,35)
    TopBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
    TopBar.BorderSizePixel = 0

    -- Accent Line
    local Accent = Instance.new("Frame", TopBar)
    Accent.Size = UDim2.new(1,0,0,2)
    Accent.Position = UDim2.new(0,0,1,-2)
    Accent.BackgroundColor3 = Color3.fromRGB(0,120,255)
    Accent.BorderSizePixel = 0

    -- Title
    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1,0,1,0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Color3.fromRGB(220,220,220)

    -- Tabs Bar
    local TabsBar = Instance.new("Frame", Main)
    TabsBar.Position = UDim2.new(0,0,0,35)
    TabsBar.Size = UDim2.new(1,0,0,30)
    TabsBar.BackgroundColor3 = Color3.fromRGB(28,28,28)
    TabsBar.BorderSizePixel = 0

    local TabsLayout = Instance.new("UIListLayout", TabsBar)
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.Padding = UDim.new(0,6)

    -- Content
    local Content = Instance.new("Frame", Main)
    Content.Position = UDim2.new(0,0,0,65)
    Content.Size = UDim2.new(1,0,1,-65)
    Content.BackgroundTransparency = 1

    -- Dragging
    local dragging, dragStart, startPos

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local Window = {}
    Window.Tabs = {}

    function Window:CreateTab(tabName)

        local TabButton = Instance.new("TextButton", TabsBar)
        TabButton.Size = UDim2.new(0,90,1,0)
        TabButton.Text = tabName
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 12
        TabButton.TextColor3 = Color3.fromRGB(170,170,170)
        TabButton.BackgroundTransparency = 1

        local Underline = Instance.new("Frame", TabButton)
        Underline.Size = UDim2.new(1,0,0,2)
        Underline.Position = UDim2.new(0,0,1,-2)
        Underline.BackgroundColor3 = Color3.fromRGB(0,120,255)
        Underline.Visible = false
        Underline.BorderSizePixel = 0

        local TabFrame = Instance.new("ScrollingFrame", Content)
        TabFrame.Size = UDim2.new(1,0,1,0)
        TabFrame.CanvasSize = UDim2.new(0,0,0,0)
        TabFrame.ScrollBarThickness = 4
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false

        local Layout = Instance.new("UIListLayout", TabFrame)
        Layout.Padding = UDim.new(0,8)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 8)
        end)

        TabButton.MouseButton1Click:Connect(function()

            for _,tab in pairs(Window.Tabs) do
                tab.Frame.Visible = false
                tab.Button.TextColor3 = Color3.fromRGB(170,170,170)
                tab.Underline.Visible = false
            end

            TabFrame.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(220,220,220)
            Underline.Visible = true
        end)

        table.insert(Window.Tabs,{
            Button = TabButton,
            Frame = TabFrame,
            Underline = Underline
        })

        if #Window.Tabs == 1 then
            TabFrame.Visible = true
            Underline.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(220,220,220)
        end

        local Tab = {}
        Tab.Frame = TabFrame

        function Tab:CreateSection(title)

            local SectionFrame = Instance.new("Frame", TabFrame)
            SectionFrame.Size = UDim2.new(1,-12,0,0)
            SectionFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0,4)

            local Padding = Instance.new("UIPadding", SectionFrame)
            Padding.PaddingTop = UDim.new(0,8)
            Padding.PaddingBottom = UDim.new(0,8)
            Padding.PaddingLeft = UDim.new(0,8)
            Padding.PaddingRight = UDim.new(0,8)

            local Layout = Instance.new("UIListLayout", SectionFrame)
            Layout.Padding = UDim.new(0,6)

            local Label = Instance.new("TextLabel", SectionFrame)
            Label.Text = title
            Label.Size = UDim2.new(1,0,0,18)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 12
            Label.TextColor3 = Color3.fromRGB(200,200,200)
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Section = {}
            Section.Container = SectionFrame

            return Section
        end

        return Tab
    end

    return Window
end


            -- Dropdown (Single + Multi)
            function Section:CreateDropdown(config)

    local Title = config.Title or "Dropdown"
    local Options = config.Options or {}
    local Multi = config.Multi or false
    local Default = config.Default
    local Callback = config.Callback or function() end

    Library._Registry = Library._Registry or {}

    local Selected = {}
    local Open = false

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = Theme.Background
    Frame.BorderSizePixel = 0
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.Parent = SectionFrame
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,6)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundTransparency = 1
    Button.Text = Title
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 13
    Button.TextColor3 = Theme.Text
    Button.Parent = Frame

    local Drop = Instance.new("Frame")
    Drop.Position = UDim2.new(0,0,0,32)
    Drop.Size = UDim2.new(1,0,0,0)
    Drop.ClipsDescendants = true
    Drop.BackgroundTransparency = 1
    Drop.Parent = Frame

    local function UpdateText()
        local list = {}
        for k,_ in pairs(Selected) do
            table.insert(list,k)
        end
        Button.Text = (#list > 0) and table.concat(list,", ") or Title
    end

    local function SetValue(value)

        Selected = {}

        if Multi then
            if type(value) == "table" then
                for _,v in pairs(value) do
                    Selected[v] = true
                end
            end
        else
            Selected[value] = true
        end

        UpdateText()

        if Multi then
            local ret = {}
            for k,_ in pairs(Selected) do
                table.insert(ret,k)
            end
            Callback(ret)
        else
            for k,_ in pairs(Selected) do
                Callback(k)
                break
            end
        end
    end

    Button.MouseButton1Click:Connect(function()
        Open = not Open
        Tween(Drop, 0.25, {
            Size = Open and UDim2.new(1,0,0,#Options*28)
                or UDim2.new(1,0,0,0)
        })
    end)

    for _,option in pairs(Options) do
        local Opt = Instance.new("TextButton")
        Opt.Size = UDim2.new(1,0,0,26)
        Opt.Text = option
        Opt.Font = Enum.Font.Gotham
        Opt.TextSize = 13
        Opt.TextColor3 = Theme.Text
        Opt.BackgroundColor3 = Theme.Section
        Opt.BorderSizePixel = 0
        Opt.Parent = Drop
        Instance.new("UICorner", Opt).CornerRadius = UDim.new(0,4)

        Opt.MouseButton1Click:Connect(function()

            if Multi then
                Selected[option] = not Selected[option]
                UpdateText()

                local ret = {}
                for k,_ in pairs(Selected) do
                    table.insert(ret,k)
                end
                Callback(ret)
            else
                SetValue(option)
                Open = false
                Tween(Drop,0.25,{Size = UDim2.new(1,0,0,0)})
            end
        end)
    end

    Library._Registry[Title] = {
        Type = "Dropdown",
        Get = function()
            if Multi then
                local ret = {}
                for k,_ in pairs(Selected) do
                    table.insert(ret,k)
                end
                return ret
            else
                for k,_ in pairs(Selected) do
                    return k
                end
            end
        end,
        Set = function(v)
            SetValue(v)
        end
    }

    if Default then
        SetValue(Default)
    else
        UpdateText()
    end
end
            --// ===== STATE REGISTRY (GLOBAL FOR WINDOW) =====

            Library._Registry = Library._Registry or {}

            --// KEYBIND
            function Section:CreateKeybind(config)
                local Title = config.Title or "Keybind"
                local Default = config.Default or Enum.KeyCode.E
                local Callback = config.Callback or function() end

                local CurrentKey = Default
                local Listening = false

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1,0,0,32)
                Frame.BackgroundColor3 = Theme.Background
                Frame.BorderSizePixel = 0
                Frame.Parent = SectionFrame
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,6)

                local Label = Instance.new("TextLabel", Frame)
                Label.Size = UDim2.new(0.6,0,1,0)
                Label.BackgroundTransparency = 1
                Label.Text = Title
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextColor3 = Theme.Text
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Position = UDim2.new(0,10,0,0)

                local Button = Instance.new("TextButton", Frame)
                Button.Size = UDim2.new(0.3,0,0,22)
                Button.Position = UDim2.new(0.65,0,0.5,-11)
                Button.BackgroundColor3 = Theme.Section
                Button.Text = CurrentKey.Name
                Button.Font = Enum.Font.Gotham
                Button.TextSize = 12
                Button.TextColor3 = Theme.Text
                Button.BorderSizePixel = 0
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0,4)

                Button.MouseButton1Click:Connect(function()
                    Button.Text = "..."
                    Listening = true
                end)

                UIS.InputBegan:Connect(function(input, gpe)
                    if Listening and not gpe then
                        CurrentKey = input.KeyCode
                        Button.Text = CurrentKey.Name
                        Listening = false
                    elseif input.KeyCode == CurrentKey and not gpe then
                        Callback()
                    end
                end)
            end

            --// TEXTBOX
            function Section:CreateTextbox(config)
                local Title = config.Title or "Textbox"
                local Default = config.Default or ""
                local Callback = config.Callback or function() end

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1,0,0,50)
                Frame.BackgroundColor3 = Theme.Background
                Frame.BorderSizePixel = 0
                Frame.Parent = SectionFrame
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,6)

                local Label = Instance.new("TextLabel", Frame)
                Label.Text = Title
                Label.Size = UDim2.new(1, -20, 0, 20)
                Label.Position = UDim2.new(0,10,0,5)
                Label.BackgroundTransparency = 1
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextColor3 = Theme.Text
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local Box = Instance.new("TextBox", Frame)
                Box.Size = UDim2.new(1,-20,0,22)
                Box.Position = UDim2.new(0,10,0,25)
                Box.BackgroundColor3 = Theme.Section
                Box.Text = Default
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 12
                Box.TextColor3 = Theme.Text
                Box.BorderSizePixel = 0
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0,4)

                Box.FocusLost:Connect(function()
                    Callback(Box.Text)
                end)
            end


            --// LABEL
            function Section:CreateLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1,0,0,20)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextColor3 = Theme.SubText
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SectionFrame
            end


            --// PARAGRAPH
            function Section:CreateParagraph(title, content)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1,0,0,60)
                Frame.BackgroundColor3 = Theme.Background
                Frame.BorderSizePixel = 0
                Frame.Parent = SectionFrame
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,6)

                local TitleLabel = Instance.new("TextLabel", Frame)
                TitleLabel.Text = title
                TitleLabel.Size = UDim2.new(1,-20,0,20)
                TitleLabel.Position = UDim2.new(0,10,0,5)
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.Font = Enum.Font.GothamBold
                TitleLabel.TextSize = 13
                TitleLabel.TextColor3 = Theme.Text
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

                local ContentLabel = Instance.new("TextLabel", Frame)
                ContentLabel.Text = content
                ContentLabel.Size = UDim2.new(1,-20,0,30)
                ContentLabel.Position = UDim2.new(0,10,0,25)
                ContentLabel.BackgroundTransparency = 1
                ContentLabel.Font = Enum.Font.Gotham
                ContentLabel.TextSize = 12
                ContentLabel.TextColor3 = Theme.SubText
                ContentLabel.TextWrapped = true
                ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
            end


            --// SEPARATOR
            function Section:CreateSeparator()
                local Line = Instance.new("Frame")
                Line.Size = UDim2.new(1,0,0,1)
                Line.BackgroundColor3 = Theme.Section
                Line.BorderSizePixel = 0
                Line.Parent = SectionFrame
            end


            --// ===== CONFIG SYSTEM =====

            function Library:SaveConfig(name)
                if not writefile then return end
                local data = {}

                for id, element in pairs(Library._Registry) do
                    data[id] = element.Get()
                end

                writefile(name .. ".json", game:GetService("HttpService"):JSONEncode(data))
            end

            function Library:LoadConfig(name)
                if not readfile or not isfile then return end
                if not isfile(name .. ".json") then return end

                local data = game:GetService("HttpService"):JSONDecode(readfile(name .. ".json"))

                for id, value in pairs(data) do
                    if Library._Registry[id] then
                        Library._Registry[id].Set(value)
                    end
                end
            end

            return Section
        end

        return Tab
    end

    return Window
end

--// ==============================
--// NOTIFICATION SYSTEM
--// ==============================

Library._Notifications = {}
Library._NotificationYOffset = 0

function Library:Notify(text, duration)

    duration = duration or 3

    local ScreenGui = game.CoreGui:FindFirstChild("SynapseStyleUI")
    if not ScreenGui then return end

    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 320, 0, 55)
    Notif.Position = UDim2.new(1, 20, 1, -80 - Library._NotificationYOffset)
    Notif.BackgroundColor3 = Theme.Background
    Notif.BorderSizePixel = 0
    Notif.Parent = ScreenGui
    Notif.Name = "Notification"

    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 6)

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.BackgroundColor3 = Theme.Accent
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = Notif

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = Theme.Text
    Label.TextWrapped = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Parent = Notif

    -- Slide In Animation
    Tween(Notif, 0.35, {
        Position = UDim2.new(1, -340, 1, -80 - Library._NotificationYOffset)
    })

    table.insert(Library._Notifications, Notif)
    Library._NotificationYOffset += 65

    -- Auto Remove
    task.delay(duration, function()

        Tween(Notif, 0.3, {
            Position = UDim2.new(1, 20, 1, -80 - Library._NotificationYOffset)
        })

        task.wait(0.3)

        Notif:Destroy()

        Library._NotificationYOffset -= 65

        -- Re-stack remaining notifications
        for i, notification in ipairs(Library._Notifications) do
            if notification and notification.Parent then
                Tween(notification, 0.3, {
                    Position = UDim2.new(1, -340, 1, -80 - ((i-1) * 65))
                })
            end
        end
    end)
end

return Library
