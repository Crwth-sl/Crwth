--// Advanced Exploit UI Library
local UILibrary = {}
UILibrary.__index = UILibrary

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedUILibrary"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

--// Main Window
function UILibrary:CreateWindow(title)

    local Window = {}

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 420)
    Main.Position = UDim2.new(0.5,-275,0.5,-210)
    Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local TopBar = Instance.new("TextLabel")
    TopBar.Size = UDim2.new(1,0,0,35)
    TopBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
    TopBar.Text = title
    TopBar.TextColor3 = Color3.fromRGB(255,255,255)
    TopBar.Font = Enum.Font.GothamBold
    TopBar.TextSize = 16
    TopBar.Parent = Main

    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(0,140,1,-35)
    TabHolder.Position = UDim2.new(0,0,0,35)
    TabHolder.BackgroundColor3 = Color3.fromRGB(18,18,18)
    TabHolder.Parent = Main

    local PageHolder = Instance.new("Frame")
    PageHolder.Size = UDim2.new(1,-140,1,-35)
    PageHolder.Position = UDim2.new(0,140,0,35)
    PageHolder.BackgroundTransparency = 1
    PageHolder.Parent = Main

    --// Dragging
    local dragging, dragInput, dragStart, startPos

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
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

    --// Tabs
    function Window:CreateTab(name)

        local Tab = {}

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1,0,0,35)
        Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255,255,255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 14
        Button.Parent = TabHolder

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1,0,1,0)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ScrollBarThickness = 4
        Page.Visible = false
        Page.Parent = PageHolder

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0,6)
        Layout.Parent = Page

        Button.MouseButton1Click:Connect(function()

            for _,v in pairs(PageHolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end

            Page.Visible = true
        end)

        --// Button
        function Tab:AddButton(text,callback)

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1,-10,0,35)
            Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255,255,255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Parent = Page

            Btn.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        --// Toggle
        function Tab:AddToggle(text,callback)

            local Toggle = false

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1,-10,0,35)
            Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            Btn.Text = text.." : OFF"
            Btn.TextColor3 = Color3.fromRGB(255,255,255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Parent = Page

            Btn.MouseButton1Click:Connect(function()

                Toggle = not Toggle

                Btn.Text = text.." : "..(Toggle and "ON" or "OFF")

                callback(Toggle)

            end)

        end

        return Tab

    end

    return Window

end

return UILibrary
