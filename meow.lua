local RunLine = {}

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--// Internal
local Objects = {}
local CurrentTheme = {}
local LibraryName = "RunLine_UI_"..tostring(math.random(1000,9999))

--// THEMES
local Themes = {

    Neon = {
        Accent = Color3.fromRGB(0,255,255),
        Background = Color3.fromRGB(10,10,15),
        Topbar = Color3.fromRGB(15,15,25),
        Element = Color3.fromRGB(20,20,30),
        Text = Color3.fromRGB(255,255,255)
    },

    Glass = {
        Accent = Color3.fromRGB(255,255,255),
        Background = Color3.fromRGB(35,35,40),
        Topbar = Color3.fromRGB(45,45,50),
        Element = Color3.fromRGB(60,60,65),
        Text = Color3.fromRGB(240,240,240)
    },

    Synapse = {
        Accent = Color3.fromRGB(255,60,60),
        Background = Color3.fromRGB(16,16,16),
        Topbar = Color3.fromRGB(25,25,25),
        Element = Color3.fromRGB(35,35,35),
        Text = Color3.fromRGB(255,255,255)
    },

    Cyberpunk = {
        Accent = Color3.fromRGB(180,0,255),
        Background = Color3.fromRGB(12,8,20),
        Topbar = Color3.fromRGB(20,10,35),
        Element = Color3.fromRGB(30,15,50),
        Text = Color3.fromRGB(255,255,255)
    }

}

--// Tween Helper
local function Tween(obj, properties, time)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    ):Play()
end

--// DRAG SYSTEM
function RunLine:EnableDragging(frame, parent)

    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            dragging = true
            mousePos = input.Position
            framePos = parent.Position

            input.Changed:Connect(function()

                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end

            end)

        end

    end)

    frame.InputChanged:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if input == dragInput and dragging then

            local delta = input.Position - mousePos

            parent.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )

        end

    end)

end

--// THEME SYSTEM
function RunLine:SetTheme(name)

    if Themes[name] then

        for i,v in pairs(Themes[name]) do
            CurrentTheme[i] = v
        end

    end

end

--// WINDOW CREATION
function RunLine:CreateWindow(config)

    config = config or {}

    local Name = config.Name or "RunLine"
    local Theme = config.Theme or "Neon"

    self:SetTheme(Theme)

    if game.CoreGui:FindFirstChild(LibraryName) then
        game.CoreGui[LibraryName]:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = LibraryName
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false

    --// MAIN WINDOW
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0,600,0,360)
    Main.Position = UDim2.new(0.5,-300,0.5,-180)
    Main.BackgroundColor3 = CurrentTheme.Background
    Main.Parent = ScreenGui
    Main.ClipsDescendants = true

    Instance.new("UICorner",Main).CornerRadius = UDim.new(0,8)

    --// ACCENT STROKE
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Main
    Stroke.Color = CurrentTheme.Accent
    Stroke.Thickness = 1.5

    --// TOPBAR
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1,0,0,36)
    Topbar.BackgroundColor3 = CurrentTheme.Topbar
    Topbar.Parent = Main

    Instance.new("UICorner",Topbar).CornerRadius = UDim.new(0,8)

    --// TITLE
    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0,10,0,0)
    Title.Size = UDim2.new(1,0,1,0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = Name
    Title.TextColor3 = CurrentTheme.Text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    --// CLOSE BUTTON
    local Close = Instance.new("TextButton")
    Close.Parent = Topbar
    Close.Size = UDim2.new(0,30,0,30)
    Close.Position = UDim2.new(1,-35,0,3)
    Close.Text = "X"
    Close.Font = Enum.Font.GothamBold
    Close.TextColor3 = CurrentTheme.Text
    Close.BackgroundTransparency = 1

    Close.MouseButton1Click:Connect(function()

        Tween(Main,{Size = UDim2.new(0,0,0,0)},0.2)

        task.wait(0.2)

        ScreenGui:Destroy()

    end)

    --// SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Main
    Sidebar.Size = UDim2.new(0,160,1,-36)
    Sidebar.Position = UDim2.new(0,0,0,36)
    Sidebar.BackgroundColor3 = CurrentTheme.Topbar

    --// TAB HOLDER
    local TabsHolder = Instance.new("Frame")
    TabsHolder.Parent = Sidebar
    TabsHolder.BackgroundTransparency = 1
    TabsHolder.Size = UDim2.new(1,0,1,0)

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = TabsHolder
    Layout.Padding = UDim.new(0,6)

    --// PAGE CONTAINER
    local Pages = Instance.new("Frame")
    Pages.Parent = Main
    Pages.Position = UDim2.new(0,160,0,36)
    Pages.Size = UDim2.new(1,-160,1,-36)
    Pages.BackgroundTransparency = 1

    --// DRAG WINDOW
    self:EnableDragging(Topbar,Main)

    local Window = {}

    function Window:CreateTab(name)

        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabsHolder
        TabButton.Size = UDim2.new(1,-10,0,30)
        TabButton.Position = UDim2.new(0,5,0,0)
        TabButton.Text = name
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 14
        TabButton.TextColor3 = CurrentTheme.Text
        TabButton.BackgroundColor3 = CurrentTheme.Element

        Instance.new("UICorner",TabButton).CornerRadius = UDim.new(0,6)

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Pages
        Page.Size = UDim2.new(1,0,1,0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 4

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0,8)

        TabButton.MouseButton1Click:Connect(function()

            for _,v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end

            Page.Visible = true

        end)

        local Tab = {}
        Tab.Page = Page

        return Tab

    end

    return Window

end

return RunLine

--// Section Creation
function Window:CreateSection(tab, name)

    local SectionFrame = Instance.new("Frame")
    SectionFrame.Parent = tab.Page
    SectionFrame.BackgroundColor3 = CurrentTheme.Element
    SectionFrame.Size = UDim2.new(1,-10,0,40)
    SectionFrame.ClipsDescendants = true

    Instance.new("UICorner",SectionFrame).CornerRadius = UDim.new(0,6)

    --// Title
    local Title = Instance.new("TextLabel")
    Title.Parent = SectionFrame
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1,0,0,30)
    Title.Position = UDim2.new(0,10,0,0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = name
    Title.TextColor3 = CurrentTheme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    --// Container
    local Container = Instance.new("Frame")
    Container.Parent = SectionFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0,5,0,30)
    Container.Size = UDim2.new(1,-10,0,0)

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.Padding = UDim.new(0,6)

    --// Auto resize section
    local function UpdateSection()

        local size = Layout.AbsoluteContentSize.Y

        Tween(SectionFrame,{
            Size = UDim2.new(1,-10,0,size + 40)
        },0.15)

        Container.Size = UDim2.new(1,-10,0,size)

        -- update page scroll
        task.wait()

        tab.Page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            tab.Page.UIListLayout.AbsoluteContentSize.Y + 10
        )

    end

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSection)

    local Section = {}

    Section.Container = Container

    return Section

end


--// ELEMENT BASE
function RunLine:_CreateElement(section,height)

    local Element = Instance.new("Frame")
    Element.Parent = section.Container
    Element.BackgroundColor3 = CurrentTheme.Element
    Element.Size = UDim2.new(1,0,0,height or 32)

    Instance.new("UICorner",Element).CornerRadius = UDim.new(0,6)

    return Element

end

local function Ripple(button)

    local circle = Instance.new("ImageLabel")
    circle.Parent = button
    circle.BackgroundTransparency = 1
    circle.Image = "rbxassetid://4560909609"
    circle.ImageColor3 = CurrentTheme.Accent
    circle.ImageTransparency = 0.6

    local mouse = game.Players.LocalPlayer:GetMouse()

    local x = mouse.X - circle.AbsolutePosition.X
    local y = mouse.Y - circle.AbsolutePosition.Y

    circle.Position = UDim2.new(0,x,0,y)

    local size = button.AbsoluteSize.X * 1.5

    Tween(circle,{
        Size = UDim2.new(0,size,0,size),
        Position = UDim2.new(0.5,-size/2,0.5,-size/2),
        ImageTransparency = 1
    },0.4)

    task.delay(0.4,function()
        circle:Destroy()
    end)

end

--------------------------------------------------
-- BUTTON
--------------------------------------------------

function RunLine:CreateButton(section, name, callback)

    callback = callback or function() end

    local Button = self:_CreateElement(section,34)

    local Text = Instance.new("TextLabel")
    Text.Parent = Button
    Text.BackgroundTransparency = 1
    Text.Size = UDim2.new(1,-10,1,0)
    Text.Position = UDim2.new(0,10,0,0)
    Text.Font = Enum.Font.GothamSemibold
    Text.Text = name
    Text.TextSize = 14
    Text.TextColor3 = CurrentTheme.Text
    Text.TextXAlignment = Enum.TextXAlignment.Left

    local Click = Instance.new("TextButton")
    Click.Parent = Button
    Click.BackgroundTransparency = 1
    Click.Size = UDim2.new(1,0,1,0)
    Click.Text = ""

    -- hover animation
    Click.MouseEnter:Connect(function()

        Tween(Button,{
            BackgroundColor3 = CurrentTheme.Accent
        },0.15)

    end)

    Click.MouseLeave:Connect(function()

        Tween(Button,{
            BackgroundColor3 = CurrentTheme.Element
        },0.15)

    end)

    Click.MouseButton1Click:Connect(function()

        Ripple(Button)
        callback()

    end)

end


--------------------------------------------------
-- TOGGLE
--------------------------------------------------

function RunLine:CreateToggle(section, name, callback)

    callback = callback or function() end
    local state = false

    local Toggle = self:_CreateElement(section,34)

    local Text = Instance.new("TextLabel")
    Text.Parent = Toggle
    Text.BackgroundTransparency = 1
    Text.Size = UDim2.new(1,-50,1,0)
    Text.Position = UDim2.new(0,10,0,0)
    Text.Font = Enum.Font.GothamSemibold
    Text.Text = name
    Text.TextSize = 14
    Text.TextColor3 = CurrentTheme.Text
    Text.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("Frame")
    Switch.Parent = Toggle
    Switch.Size = UDim2.new(0,40,0,18)
    Switch.Position = UDim2.new(1,-50,0.5,-9)
    Switch.BackgroundColor3 = Color3.fromRGB(40,40,40)

    Instance.new("UICorner",Switch).CornerRadius = UDim.new(1,0)

    local Knob = Instance.new("Frame")
    Knob.Parent = Switch
    Knob.Size = UDim2.new(0,16,0,16)
    Knob.Position = UDim2.new(0,1,0.5,-8)
    Knob.BackgroundColor3 = Color3.new(1,1,1)

    Instance.new("UICorner",Knob).CornerRadius = UDim.new(1,0)

    local Click = Instance.new("TextButton")
    Click.Parent = Toggle
    Click.BackgroundTransparency = 1
    Click.Size = UDim2.new(1,0,1,0)
    Click.Text = ""

    Click.MouseButton1Click:Connect(function()

        state = not state

        if state then

            Tween(Knob,{
                Position = UDim2.new(1,-17,0.5,-8)
            },0.2)

            Tween(Switch,{
                BackgroundColor3 = CurrentTheme.Accent
            },0.2)

        else

            Tween(Knob,{
                Position = UDim2.new(0,1,0.5,-8)
            },0.2)

            Tween(Switch,{
                BackgroundColor3 = Color3.fromRGB(40,40,40)
            },0.2)

        end

        callback(state)

    end)

end


--------------------------------------------------
-- LABEL
--------------------------------------------------

function RunLine:CreateLabel(section, text)

    local Label = self:_CreateElement(section,30)

    local Text = Instance.new("TextLabel")
    Text.Parent = Label
    Text.BackgroundTransparency = 1
    Text.Size = UDim2.new(1,-10,1,0)
    Text.Position = UDim2.new(0,10,0,0)
    Text.Font = Enum.Font.Gotham
    Text.Text = text
    Text.TextSize = 14
    Text.TextColor3 = CurrentTheme.Text
    Text.TextXAlignment = Enum.TextXAlignment.Left

    local LabelObject = {}

    function LabelObject:Set(newText)
        Text.Text = newText
    end

    return LabelObject

end

--------------------------------------------------
-- SLIDER
--------------------------------------------------

function RunLine:CreateSlider(section,name,min,max,callback)

    callback = callback or function() end
    min = min or 0
    max = max or 100

    local value = min

    local Slider = self:_CreateElement(section,40)

    local Text = Instance.new("TextLabel")
    Text.Parent = Slider
    Text.BackgroundTransparency = 1
    Text.Size = UDim2.new(1,-60,0,16)
    Text.Position = UDim2.new(0,10,0,0)
    Text.Font = Enum.Font.GothamSemibold
    Text.Text = name.." : "..value
    Text.TextSize = 13
    Text.TextColor3 = CurrentTheme.Text
    Text.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame")
    Bar.Parent = Slider
    Bar.Size = UDim2.new(1,-20,0,6)
    Bar.Position = UDim2.new(0,10,0,24)
    Bar.BackgroundColor3 = Color3.fromRGB(40,40,40)

    Instance.new("UICorner",Bar).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame")
    Fill.Parent = Bar
    Fill.Size = UDim2.new(0,0,1,0)
    Fill.BackgroundColor3 = CurrentTheme.Accent

    Instance.new("UICorner",Fill).CornerRadius = UDim.new(1,0)

    local dragging = false
    local mouse = game.Players.LocalPlayer:GetMouse()

    Bar.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end

    end)

    Bar.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end

    end)

    mouse.Move:Connect(function()

        if dragging then

            local size = math.clamp(
                (mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
                0,
                1
            )

            Fill.Size = UDim2.new(size,0,1,0)

            value = math.floor(min + (max-min)*size)

            Text.Text = name.." : "..value

            callback(value)

        end

    end)

end


--------------------------------------------------
-- TEXTBOX
--------------------------------------------------

function RunLine:CreateTextbox(section,name,callback)

    callback = callback or function() end

    local Box = self:_CreateElement(section,34)

    local Label = Instance.new("TextLabel")
    Label.Parent = Box
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.4,0,1,0)
    Label.Position = UDim2.new(0,10,0,0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = name
    Label.TextSize = 14
    Label.TextColor3 = CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Textbox = Instance.new("TextBox")
    Textbox.Parent = Box
    Textbox.Size = UDim2.new(0.55,0,0,22)
    Textbox.Position = UDim2.new(0.42,0,0.5,-11)
    Textbox.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Textbox.Text = ""
    Textbox.PlaceholderText = "Type..."
    Textbox.TextColor3 = CurrentTheme.Text
    Textbox.Font = Enum.Font.Gotham
    Textbox.TextSize = 13

    Instance.new("UICorner",Textbox).CornerRadius = UDim.new(0,4)

    Textbox.FocusLost:Connect(function(enter)

        if enter then
            callback(Textbox.Text)
        end

    end)

end


--------------------------------------------------
-- DROPDOWN
--------------------------------------------------

function RunLine:CreateDropdown(section,name,list,callback)

    callback = callback or function() end
    list = list or {}

    local open = false
    local selected = name

    local Frame = self:_CreateElement(section,34)

    local Button = Instance.new("TextButton")
    Button.Parent = Frame
    Button.Size = UDim2.new(1,0,1,0)
    Button.Text = ""
    Button.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0,10,0,0)
    Label.Size = UDim2.new(1,-20,1,0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = selected
    Label.TextColor3 = CurrentTheme.Text
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Parent = Frame
    OptionsFrame.Position = UDim2.new(0,0,1,4)
    OptionsFrame.Size = UDim2.new(1,0,0,0)
    OptionsFrame.BackgroundTransparency = 1
    OptionsFrame.ClipsDescendants = true

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = OptionsFrame
    Layout.Padding = UDim.new(0,4)

    local function Refresh()

        OptionsFrame.Size = UDim2.new(
            1,
            0,
            0,
            Layout.AbsoluteContentSize.Y
        )

    end

    for _,v in pairs(list) do

        local Option = Instance.new("TextButton")
        Option.Parent = OptionsFrame
        Option.Size = UDim2.new(1,0,0,30)
        Option.Text = v
        Option.Font = Enum.Font.Gotham
        Option.TextSize = 13
        Option.BackgroundColor3 = CurrentTheme.Element
        Option.TextColor3 = CurrentTheme.Text

        Instance.new("UICorner",Option).CornerRadius = UDim.new(0,6)

        Option.MouseButton1Click:Connect(function()

            selected = v
            Label.Text = v

            open = false
            OptionsFrame.Size = UDim2.new(1,0,0,0)

            callback(v)

        end)

    end

    Refresh()

    Button.MouseButton1Click:Connect(function()

        open = not open

        if open then
            Refresh()
        else
            OptionsFrame.Size = UDim2.new(1,0,0,0)
        end

    end)

end


--------------------------------------------------
-- MULTI SELECT DROPDOWN
--------------------------------------------------

function RunLine:CreateMultiDropdown(section,name,list,callback)

    callback = callback or function() end
    list = list or {}

    local selected = {}

    local Frame = self:_CreateElement(section,34)

    local Button = Instance.new("TextButton")
    Button.Parent = Frame
    Button.Size = UDim2.new(1,0,1,0)
    Button.BackgroundTransparency = 1
    Button.Text = ""

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1,-20,1,0)
    Label.Position = UDim2.new(0,10,0,0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = name
    Label.TextColor3 = CurrentTheme.Text
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Options = Instance.new("Frame")
    Options.Parent = Frame
    Options.Position = UDim2.new(0,0,1,4)
    Options.Size = UDim2.new(1,0,0,0)
    Options.BackgroundTransparency = 1
    Options.ClipsDescendants = true

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Options
    Layout.Padding = UDim.new(0,4)

    for _,v in pairs(list) do

        local Option = Instance.new("TextButton")
        Option.Parent = Options
        Option.Size = UDim2.new(1,0,0,30)
        Option.Text = v
        Option.Font = Enum.Font.Gotham
        Option.TextSize = 13
        Option.BackgroundColor3 = CurrentTheme.Element
        Option.TextColor3 = CurrentTheme.Text

        Instance.new("UICorner",Option).CornerRadius = UDim.new(0,6)

        Option.MouseButton1Click:Connect(function()

            if table.find(selected,v) then
                table.remove(selected,table.find(selected,v))
                Option.BackgroundColor3 = CurrentTheme.Element
            else
                table.insert(selected,v)
                Option.BackgroundColor3 = CurrentTheme.Accent
            end

            callback(selected)

        end)

    end

    Button.MouseButton1Click:Connect(function()

        if Options.Size.Y.Offset == 0 then

            Options.Size = UDim2.new(
                1,
                0,
                0,
                Layout.AbsoluteContentSize.Y
            )

        else

            Options.Size = UDim2.new(1,0,0,0)

        end

    end)

end

--------------------------------------------------
-- KEYBIND
--------------------------------------------------

function RunLine:CreateKeybind(section,name,defaultKey,callback)

    callback = callback or function() end
    local currentKey = defaultKey or Enum.KeyCode.RightControl

    local Bind = self:_CreateElement(section,34)

    local Label = Instance.new("TextLabel")
    Label.Parent = Bind
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.6,0,1,0)
    Label.Position = UDim2.new(0,10,0,0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = name
    Label.TextSize = 14
    Label.TextColor3 = CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local KeyButton = Instance.new("TextButton")
    KeyButton.Parent = Bind
    KeyButton.Size = UDim2.new(0.3,0,0,22)
    KeyButton.Position = UDim2.new(0.65,0,0.5,-11)
    KeyButton.BackgroundColor3 = CurrentTheme.Element
    KeyButton.Text = currentKey.Name
    KeyButton.Font = Enum.Font.Gotham
    KeyButton.TextSize = 13
    KeyButton.TextColor3 = CurrentTheme.Text

    Instance.new("UICorner",KeyButton).CornerRadius = UDim.new(0,4)

    KeyButton.MouseButton1Click:Connect(function()

        KeyButton.Text = "..."

        local input = game:GetService("UserInputService").InputBegan:Wait()

        if input.KeyCode ~= Enum.KeyCode.Unknown then

            currentKey = input.KeyCode
            KeyButton.Text = currentKey.Name

        end

    end)

    game:GetService("UserInputService").InputBegan:Connect(function(input,typing)

        if typing then return end

        if input.KeyCode == currentKey then
            callback()
        end

    end)

end


--------------------------------------------------
-- COLOR PICKER (simple accent changer)
--------------------------------------------------

function RunLine:CreateColorPicker(section,name,defaultColor,callback)

    callback = callback or function() end
    defaultColor = defaultColor or CurrentTheme.Accent

    local Picker = self:_CreateElement(section,34)

    local Label = Instance.new("TextLabel")
    Label.Parent = Picker
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.6,0,1,0)
    Label.Position = UDim2.new(0,10,0,0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = name
    Label.TextSize = 14
    Label.TextColor3 = CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ColorButton = Instance.new("TextButton")
    ColorButton.Parent = Picker
    ColorButton.Size = UDim2.new(0,30,0,20)
    ColorButton.Position = UDim2.new(1,-40,0.5,-10)
    ColorButton.BackgroundColor3 = defaultColor
    ColorButton.Text = ""

    Instance.new("UICorner",ColorButton).CornerRadius = UDim.new(0,4)

    ColorButton.MouseButton1Click:Connect(function()

        local newColor = Color3.fromHSV(math.random(),1,1)

        ColorButton.BackgroundColor3 = newColor

        callback(newColor)

    end)

end


--------------------------------------------------
-- NOTIFICATION SYSTEM
--------------------------------------------------

function RunLine:Notify(title,text,time)

    time = time or 3

    if not game.CoreGui:FindFirstChild("RunLineNotifications") then

        local Holder = Instance.new("ScreenGui")
        Holder.Name = "RunLineNotifications"
        Holder.Parent = game.CoreGui

        local LayoutFrame = Instance.new("Frame")
        LayoutFrame.Parent = Holder
        LayoutFrame.Position = UDim2.new(1,-260,1,-10)
        LayoutFrame.Size = UDim2.new(0,250,1,0)
        LayoutFrame.BackgroundTransparency = 1
        LayoutFrame.Name = "Container"

        local Layout = Instance.new("UIListLayout")
        Layout.Parent = LayoutFrame
        Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        Layout.Padding = UDim.new(0,6)

    end

    local Holder = game.CoreGui.RunLineNotifications.Container

    local Notif = Instance.new("Frame")
    Notif.Parent = Holder
    Notif.Size = UDim2.new(1,0,0,60)
    Notif.BackgroundColor3 = CurrentTheme.Element

    Instance.new("UICorner",Notif).CornerRadius = UDim.new(0,6)

    local Title = Instance.new("TextLabel")
    Title.Parent = Notif
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0,10,0,4)
    Title.Size = UDim2.new(1,-20,0,20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = CurrentTheme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Desc = Instance.new("TextLabel")
    Desc.Parent = Notif
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0,10,0,24)
    Desc.Size = UDim2.new(1,-20,0,30)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = text
    Desc.TextColor3 = CurrentTheme.Text
    Desc.TextSize = 13
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    Notif.Position = UDim2.new(1,250,0,0)

    Tween(Notif,{
        Position = UDim2.new(0,0,0,0)
    },0.25)

    task.delay(time,function()

        Tween(Notif,{
            Position = UDim2.new(1,250,0,0)
        },0.25)

        task.wait(0.25)

        Notif:Destroy()

    end)

end


--------------------------------------------------
-- UI TOGGLE KEY
--------------------------------------------------

function RunLine:SetToggleKey(key)

    key = key or Enum.KeyCode.RightControl

    game:GetService("UserInputService").InputBegan:Connect(function(input,typing)

        if typing then return end

        if input.KeyCode == key then

            local gui = game.CoreGui:FindFirstChild(LibraryName)

            if gui then
                gui.Enabled = not gui.Enabled
            end

        end

    end)

end


--------------------------------------------------
-- THEME SWITCHER
--------------------------------------------------

function RunLine:ChangeTheme(name)

    if Themes[name] then

        for i,v in pairs(Themes[name]) do
            CurrentTheme[i] = v
        end

    end

end

--// RUNLINE UI LIBRARY
--// PART 6 - ULTRA FEATURES

---


local HttpService = game:GetService("HttpService")

RunLine.Config = {}

function RunLine:SaveConfig(name)

if not writefile then return end

local data = HttpService:JSONEncode(RunLine.Config)

writefile("RunLine_"..name..".json",data)

end

function RunLine:LoadConfig(name)

if not readfile then return end

local raw = readfile("RunLine_"..name..".json")

if raw then
    RunLine.Config = HttpService:JSONDecode(raw)
end

end

---


function RunLine:SetScale(scale)

scale = scale or 1

local gui = game.CoreGui:FindFirstChild(LibraryName)

if not gui then return end

if not gui:FindFirstChild("UIScale") then

    local UIScale = Instance.new("UIScale")
    UIScale.Parent = gui

end

gui.UIScale.Scale = scale

end

---


function RunLine:ToggleBlur(state)

local Lighting = game:GetService("Lighting")

if state then

    if not Lighting:FindFirstChild("RunLineBlur") then

        local Blur = Instance.new("BlurEffect")
        Blur.Name = "RunLineBlur"
        Blur.Size = 12
        Blur.Parent = Lighting

    end

else

    if Lighting:FindFirstChild("RunLineBlur") then
        Lighting.RunLineBlur:Destroy()
    end

end

end


function RunLine:AddTabGlow(tabButton)

local Glow = Instance.new("UIStroke")
Glow.Parent = tabButton
Glow.Color = CurrentTheme.Accent
Glow.Thickness = 1.5
Glow.Transparency = 1

tabButton.MouseEnter:Connect(function()

    Tween(Glow,{
        Transparency = 0
    },0.2)

end)

tabButton.MouseLeave:Connect(function()

    Tween(Glow,{
        Transparency = 1
    },0.2)

end)

end

---


function RunLine:CreateSearch(tab)

local Search = Instance.new("TextBox")
Search.Parent = tab.Page
Search.Size = UDim2.new(1,-10,0,28)
Search.PlaceholderText = "Search..."
Search.Text = ""
Search.Font = Enum.Font.Gotham
Search.TextSize = 14
Search.BackgroundColor3 = CurrentTheme.Element
Search.TextColor3 = CurrentTheme.Text

Instance.new("UICorner",Search).CornerRadius = UDim.new(0,6)

Search:GetPropertyChangedSignal("Text"):Connect(function()

    local text = string.lower(Search.Text)

    for _,v in pairs(tab.Page:GetChildren()) do

        if v:IsA("Frame") and v:FindFirstChildOfClass("TextLabel") then

            local label = v:FindFirstChildOfClass("TextLabel")

            if label then

                local name = string.lower(label.Text)

                if string.find(name,text) then
                    v.Visible = true
                else
                    v.Visible = false
                end

            end

        end

    end

end)

end


function RunLine:AddDropdownSearch(dropdownFrame)

local Search = Instance.new("TextBox")
Search.Parent = dropdownFrame
Search.Size = UDim2.new(1,0,0,26)
Search.PlaceholderText = "Search..."
Search.Text = ""
Search.Font = Enum.Font.Gotham
Search.TextSize = 13
Search.BackgroundColor3 = CurrentTheme.Element
Search.TextColor3 = CurrentTheme.Text

Instance.new("UICorner",Search).CornerRadius = UDim.new(0,5)

Search:GetPropertyChangedSignal("Text"):Connect(function()

    local query = string.lower(Search.Text)

    for _,v in pairs(dropdownFrame:GetChildren()) do

        if v:IsA("TextButton") then

            if string.find(string.lower(v.Text),query) then
                v.Visible = true
            else
                v.Visible = false
            end

        end

    end

end)

end
