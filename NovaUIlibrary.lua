--[[
    Nova UI Library
    A beautiful, modern and feature-rich UI library for Roblox exploits
    Created by Master
    
    Features:
    - Smooth animations and transitions
    - Multiple theme support with customization
    - Advanced components (toggles, sliders, dropdowns, color pickers)
    - Drag and resize functionality
    - Blur effects and shadows
    - Responsive design
    - Customizable notifications
    - Tooltips and context menus
    - Keyboard shortcuts
]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Utility Functions
local Nova = {}
Nova.Themes = {
    Dark = {
        Primary = Color3.fromRGB(30, 30, 35),
        Secondary = Color3.fromRGB(40, 40, 45),
        Tertiary = Color3.fromRGB(50, 50, 55),
        Text = Color3.fromRGB(240, 240, 245),
        TextDark = Color3.fromRGB(180, 180, 185),
        Accent = Color3.fromRGB(100, 100, 255),
        Error = Color3.fromRGB(255, 80, 80),
        Success = Color3.fromRGB(80, 255, 120),
        Warning = Color3.fromRGB(255, 180, 70)
    },
    Light = {
        Primary = Color3.fromRGB(240, 240, 245),
        Secondary = Color3.fromRGB(230, 230, 235),
        Tertiary = Color3.fromRGB(220, 220, 225),
        Text = Color3.fromRGB(30, 30, 35),
        TextDark = Color3.fromRGB(70, 70, 75),
        Accent = Color3.fromRGB(70, 70, 225),
        Error = Color3.fromRGB(225, 60, 60),
        Success = Color3.fromRGB(60, 225, 100),
        Warning = Color3.fromRGB(225, 160, 50)
    },
    Midnight = {
        Primary = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 40),
        Tertiary = Color3.fromRGB(40, 40, 50),
        Text = Color3.fromRGB(220, 220, 255),
        TextDark = Color3.fromRGB(160, 160, 195),
        Accent = Color3.fromRGB(130, 100, 255),
        Error = Color3.fromRGB(255, 70, 90),
        Success = Color3.fromRGB(70, 225, 140),
        Warning = Color3.fromRGB(255, 170, 60)
    },
    Aqua = {
        Primary = Color3.fromRGB(20, 40, 50),
        Secondary = Color3.fromRGB(30, 50, 60),
        Tertiary = Color3.fromRGB(40, 60, 70),
        Text = Color3.fromRGB(220, 240, 255),
        TextDark = Color3.fromRGB(160, 180, 195),
        Accent = Color3.fromRGB(80, 180, 255),
        Error = Color3.fromRGB(255, 70, 90),
        Success = Color3.fromRGB(70, 225, 140),
        Warning = Color3.fromRGB(255, 170, 60)
    },
    Crimson = {
        Primary = Color3.fromRGB(40, 20, 25),
        Secondary = Color3.fromRGB(50, 30, 35),
        Tertiary = Color3.fromRGB(60, 40, 45),
        Text = Color3.fromRGB(255, 220, 225),
        TextDark = Color3.fromRGB(195, 160, 165),
        Accent = Color3.fromRGB(255, 80, 100),
        Error = Color3.fromRGB(255, 70, 90),
        Success = Color3.fromRGB(70, 225, 140),
        Warning = Color3.fromRGB(255, 170, 60)
    }
}

Nova.CurrentTheme = Nova.Themes.Dark
Nova.Font = Enum.Font.GothamSemibold
Nova.FontBold = Enum.Font.GothamBold
Nova.RoundAmount = 8
Nova.ToggleSpeed = 0.15
Nova.EasingStyle = Enum.EasingStyle.Quart
Nova.EasingDirection = Enum.EasingDirection.Out

-- Utility Functions
local function tween(object, info, properties)
    local tweenInfo = typeof(info) == "table" and TweenInfo.new(
        info.Time or 0.25,
        info.Style or Nova.EasingStyle,
        info.Direction or Nova.EasingDirection,
        info.RepeatCount or 0,
        info.Reverses or false,
        info.Delay or 0
    ) or info
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    return tween
end

local function createShadow(parent, size, transparency, zIndex)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, size or 20, 1, size or 20)
    shadow.ZIndex = zIndex or 0
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    
    return shadow
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Nova.CurrentTheme.Accent
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = parent
    
    return stroke
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or Nova.RoundAmount)
    corner.Parent = parent
    
    return corner
end

local function createGradient(parent, colorSequence, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    
    return gradient
end

local function createRipple(parent, position)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.Position = position or UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = 10
    
    createCorner(ripple, 100)
    
    ripple.Parent = parent
    
    local targetSize = UDim2.new(1.5, 0, 1.5, 0)
    
    tween(ripple, {Time = 0.5}, {
        Size = targetSize,
        BackgroundTransparency = 1
    }).Completed:Connect(function()
        ripple:Destroy()
    end)
    
    return ripple
end

local function createBlur()
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
    
    return blur
end

local function formatNumber(number)
    local formatted = tostring(number)
    while true do  
        local formatted2, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        formatted = formatted2
        if k == 0 then
            break
        end
    end
    return formatted
end

local function getTextBounds(text, font, size)
    return TextService:GetTextSize(text, size, font, Vector2.new(math.huge, math.huge))
end

-- Create Main GUI
function Nova:CreateWindow(options)
    options = options or {}
    
    -- Default options
    local windowOptions = {
        Title = options.Title or "Nova UI Library",
        SubTitle = options.SubTitle or "by Master",
        Size = options.Size or UDim2.new(0, 600, 0, 400),
        Theme = options.Theme or "Dark",
        Position = options.Position,
        Blur = options.Blur or false,
        MinimizeKey = options.MinimizeKey or Enum.KeyCode.RightControl,
        SaveConfig = options.SaveConfig or false,
        ConfigFolder = options.ConfigFolder or "NovaUILibrary",
        Discord = options.Discord or {
            Enabled = false,
            Invite = "discord.gg/novauilibrary",
            RememberJoins = true
        }
    }
    
    -- Set theme
    Nova.CurrentTheme = Nova.Themes[windowOptions.Theme] or Nova.Themes.Dark
    
    -- Create ScreenGui
    local NovaGui = Instance.new("ScreenGui")
    NovaGui.Name = "NovaUILibrary"
    NovaGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NovaGui.ResetOnSpawn = false
    
    -- Parent the GUI
    if syn and syn.protect_gui then
        syn.protect_gui(NovaGui)
        NovaGui.Parent = CoreGui
    elseif gethui then
        NovaGui.Parent = gethui()
    else
        NovaGui.Parent = CoreGui
    end
    
    -- Create blur effect if enabled
    local blurEffect
    if windowOptions.Blur then
        blurEffect = createBlur()
        tween(blurEffect, {Time = 0.5}, {Size = 10})
    end
    
    -- Create main window container
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.BackgroundColor3 = Nova.CurrentTheme.Primary
    MainWindow.BorderSizePixel = 0
    MainWindow.Position = windowOptions.Position or UDim2.new(0.5, -windowOptions.Size.X.Offset / 2, 0.5, -windowOptions.Size.Y.Offset / 2)
    MainWindow.Size = windowOptions.Size
    MainWindow.ClipsDescendants = true
    MainWindow.Parent = NovaGui
    
    -- Add corner and shadow
    createCorner(MainWindow)
    createShadow(MainWindow, 30, 0.5, -1)
    
    -- Create title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Nova.CurrentTheme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Parent = MainWindow
    
    createCorner(TitleBar)
    
    -- Create title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Font = Nova.FontBold
    Title.Text = windowOptions.Title
    Title.TextColor3 = Nova.CurrentTheme.Text
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Create subtitle
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 15, 0.5, 2)
    SubTitle.Size = UDim2.new(0.5, 0, 0.5, 0)
    SubTitle.Font = Nova.Font
    SubTitle.Text = windowOptions.SubTitle
    SubTitle.TextColor3 = Nova.CurrentTheme.TextDark
    SubTitle.TextSize = 14
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = TitleBar
    
    -- Create window controls
    local WindowControls = Instance.new("Frame")
    WindowControls.Name = "WindowControls"
    WindowControls.BackgroundTransparency = 1
    WindowControls.Position = UDim2.new(1, -100, 0, 0)
    WindowControls.Size = UDim2.new(0, 100, 1, 0)
    WindowControls.Parent = TitleBar
    
    -- Create minimize button
    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(0, 10, 0.5, -10)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Image = "rbxassetid://7072719338"
    MinimizeButton.ImageColor3 = Nova.CurrentTheme.TextDark
    MinimizeButton.Parent = WindowControls
    
    -- Create close button
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0.5, -10)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Image = "rbxassetid://7072725342"
    CloseButton.ImageColor3 = Nova.CurrentTheme.TextDark
    CloseButton.Parent = WindowControls
    
    -- Create content container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 0, 0, 40)
    ContentContainer.Size = UDim2.new(1, 0, 1, -40)
    ContentContainer.Parent = MainWindow
    
    -- Create tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = Nova.CurrentTheme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 10)
    TabContainer.Size = UDim2.new(0, 150, 1, -20)
    TabContainer.Parent = ContentContainer
    
    createCorner(TabContainer)
    
    -- Create tab buttons container
    local TabButtonsContainer = Instance.new("ScrollingFrame")
    TabButtonsContainer.Name = "TabButtonsContainer"
    TabButtonsContainer.BackgroundTransparency = 1
    TabButtonsContainer.BorderSizePixel = 0
    TabButtonsContainer.Position = UDim2.new(0, 0, 0, 10)
    TabButtonsContainer.Size = UDim2.new(1, 0, 1, -20)
    TabButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtonsContainer.ScrollBarThickness = 2
    TabButtonsContainer.ScrollBarImageColor3 = Nova.CurrentTheme.Accent
    TabButtonsContainer.Parent = TabContainer
    
    -- Create tab buttons layout
    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.Name = "TabButtonsLayout"
    TabButtonsLayout.Padding = UDim.new(0, 5)
    TabButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabButtonsLayout.Parent = TabButtonsContainer
    
    -- Create tab content container
    local TabContentContainer = Instance.new("Frame")
    TabContentContainer.Name = "TabContentContainer"
    TabContentContainer.BackgroundColor3 = Nova.CurrentTheme.Secondary
    TabContentContainer.BorderSizePixel = 0
    TabContentContainer.Position = UDim2.new(0, 170, 0, 10)
    TabContentContainer.Size = UDim2.new(1, -180, 1, -20)
    TabContentContainer.Parent = ContentContainer
    
    createCorner(TabContentContainer)
    
    -- Create watermark
    local Watermark = Instance.new("TextLabel")
    Watermark.Name = "Watermark"
    Watermark.BackgroundTransparency = 1
    Watermark.Position = UDim2.new(1, -110, 1, -25)
    Watermark.Size = UDim2.new(0, 100, 0, 20)
    Watermark.Font = Nova.Font
    Watermark.Text = "Nova UI Library"
    Watermark.TextColor3 = Nova.CurrentTheme.TextDark
    Watermark.TextSize = 12
    Watermark.TextXAlignment = Enum.TextXAlignment.Right
    Watermark.Parent = TabContentContainer
    
    -- Window functionality
    local window = {}
    window.Tabs = {}
    window.CurrentTab = nil
    window.Minimized = false
    
    -- Make window draggable
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainWindow.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Minimize/maximize window
    MinimizeButton.MouseButton1Click:Connect(function()
        window.Minimized = not window.Minimized
        
        if window.Minimized then
            tween(ContentContainer, {Time = 0.5}, {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 40)
            })
            tween(MainWindow, {Time = 0.5}, {
                Size = UDim2.new(0, windowOptions.Size.X.Offset, 0, 40)
            })
        else
            tween(ContentContainer, {Time = 0.5}, {
                Size = UDim2.new(1, 0, 1, -40),
                Position = UDim2.new(0, 0, 0, 40)
            })
            tween(MainWindow, {Time = 0.5}, {
                Size = windowOptions.Size
            })
        end
    end)
    
    -- Close window
    CloseButton.MouseButton1Click:Connect(function()
        tween(MainWindow, {Time = 0.5}, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        
        if blurEffect then
            tween(blurEffect, {Time = 0.5}, {Size = 0})
        end
        
        wait(0.5)
        NovaGui:Destroy()
        
        if blurEffect then
            blurEffect:Destroy()
        end
    end)
    
    -- Minimize with keybind
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == windowOptions.MinimizeKey then
            window.Minimized = not window.Minimized
            
            if window.Minimized then
                tween(ContentContainer, {Time = 0.5}, {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 40)
                })
                tween(MainWindow, {Time = 0.5}, {
                    Size = UDim2.new(0, windowOptions.Size.X.Offset, 0, 40)
                })
            else
                tween(ContentContainer, {Time = 0.5}, {
                    Size = UDim2.new(1, 0, 1, -40),
                    Position = UDim2.new(0, 0, 0, 40)
                })
                tween(MainWindow, {Time = 0.5}, {
                    Size = windowOptions.Size
                })
            end
        end
    end)
    
    -- Create tab function
    function window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        
        local tabInfo = {
            Name = tabOptions.Name or "Tab",
            Icon = tabOptions.Icon
        }
        
        -- Create tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabInfo.Name .. "Button"
        TabButton.BackgroundColor3 = Nova.CurrentTheme.Tertiary
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 130, 0, 32)
        TabButton.Font = Nova.Font
        TabButton.Text = tabInfo.Name
        TabButton.TextColor3 = Nova.CurrentTheme.TextDark
        TabButton.TextSize = 14
        TabButton.Parent = TabButtonsContainer
        
        createCorner(TabButton, 6)
        
        -- Create tab icon if provided
        if tabInfo.Icon then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "Icon"
            TabIcon.BackgroundTransparency = 1
            TabIcon.Position = UDim2.new(0, 10, 0.5, -8)
            TabIcon.Size = UDim2.new(0, 16, 0, 16)
            TabIcon.Image = tabInfo.Icon
            TabIcon.ImageColor3 = Nova.CurrentTheme.TextDark
            TabIcon.Parent = TabButton
            
            -- Adjust text position
            TabButton.Text = "    " .. tabInfo.Name
            TabButton.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        -- Create tab content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabInfo.Name .. "Content"
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Nova.CurrentTheme.Accent
        TabContent.Visible = false
        TabContent.Parent = TabContentContainer
        
        -- Create content layout
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Name = "ContentLayout"
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContentLayout.Parent = TabContent
        
        -- Create content padding
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Name = "ContentPadding"
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.Parent = TabContent
        
        -- Update canvas size when elements are added
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab functionality
        local tab = {}
        tab.Elements = {}
        
        -- Select tab function
        function tab:Select()
            for _, otherTab in pairs(window.Tabs) do
                otherTab.Button.BackgroundTransparency = 1
                otherTab.Button.TextColor3 = Nova.CurrentTheme.TextDark
                otherTab.Content.Visible = false
                
                if otherTab.Button:FindFirstChild("Icon") then
                    otherTab.Button.Icon.ImageColor3 = Nova.CurrentTheme.TextDark
                end
            end
            
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Nova.CurrentTheme.Text
            TabContent.Visible = true
            
            if TabButton:FindFirstChild("Icon") then
                TabButton.Icon.ImageColor3 = Nova.CurrentTheme.Text
            end
            
            window.CurrentTab = tab
        end
        
        -- Tab button click
        TabButton.MouseButton1Click:Connect(function()
            tab:Select()
            createRipple(TabButton, UDim2.new(0.5, 0, 0.5, 0))
        end)
        
        -- Add tab to window
        tab.Button = TabButton
        tab.Content = TabContent
        table.insert(window.Tabs, tab)
        
        -- Select first tab
        if #window.Tabs == 1 then
            tab:Select()
        end
        
        -- Section function
        function tab:CreateSection(sectionOptions)
            sectionOptions = sectionOptions or {}
            
            local sectionInfo = {
                Name = sectionOptions.Name or "Section"
            }
            
            -- Create section container
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = sectionInfo.Name .. "Section"
            SectionContainer.BackgroundColor3 = Nova.CurrentTheme.Tertiary
            SectionContainer.BorderSizePixel = 0
            SectionContainer.Size = UDim2.new(1, -20, 0, 40)
            SectionContainer.ClipsDescendants = true
            SectionContainer.Parent = TabContent
            
            createCorner(SectionContainer, 6)
            
            -- Create section title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.Size = UDim2.new(1, -30, 0, 40)
            SectionTitle.Font = Nova.FontBold
            SectionTitle.Text = sectionInfo.Name
            SectionTitle.TextColor3 = Nova.CurrentTheme.Text
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionContainer
            
            -- Create section content
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 40)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Parent = SectionContainer
            
            -- Create content layout
            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Name = "SectionLayout"
            SectionLayout.Padding = UDim.new(0, 8)
            SectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            SectionLayout.Parent = SectionContent
            
            -- Create content padding
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.Name = "SectionPadding"
            SectionPadding.PaddingTop = UDim.new(0, 5)
            SectionPadding.PaddingBottom = UDim.new(0, 10)
            SectionPadding.PaddingLeft = UDim.new(0, 10)
            SectionPadding.PaddingRight = UDim.new(0, 10)
            SectionPadding.Parent = SectionContent
            
            -- Update section size when elements are added
            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 15)
                SectionContainer.Size = UDim2.new(1, -20, 0, 40 + SectionContent.Size.Y.Offset)
            end)
            
            -- Section functionality
            local section = {}
            
            -- Button function
            function section:AddButton(buttonOptions)
                buttonOptions = buttonOptions or {}
                
                local buttonInfo = {
                    Name = buttonOptions.Name or "Button",
                    Callback = buttonOptions.Callback or function() end
                }
                
                -- Create button
                local Button = Instance.new("TextButton")
                Button.Name = buttonInfo.Name .. "Button"
                Button.BackgroundColor3 = Nova.CurrentTheme.Primary
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, -20, 0, 32)
                Button.Font = Nova.Font
                Button.Text = buttonInfo.Name
                Button.TextColor3 = Nova.CurrentTheme.Text
                Button.TextSize = 14
                Button.ClipsDescendants = true
                Button.Parent = SectionContent
                
                createCorner(Button, 6)
                
                -- Button functionality
                Button.MouseButton1Click:Connect(function()
                    createRipple(Button, UDim2.new(0, Mouse.X - Button.AbsolutePosition.X, 0, Mouse.Y - Button.AbsolutePosition.Y))
                    buttonInfo.Callback()
                end)
                
                -- Button hover effect
                Button.MouseEnter:Connect(function()
                    tween(Button, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Secondary})
                end)
                
                Button.MouseLeave:Connect(function()
                    tween(Button, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Primary})
                end)
                
                local button = {}
                
                function button:SetText(text)
                    Button.Text = text
                end
                
                function button:SetCallback(callback)
                    buttonInfo.Callback = callback
                end
                
                return button
            end
            
            -- Toggle function
            function section:AddToggle(toggleOptions)
                toggleOptions = toggleOptions or {}
                
                local toggleInfo = {
                    Name = toggleOptions.Name or "Toggle",
                    Default = toggleOptions.Default or false,
                    Callback = toggleOptions.Callback or function() end,
                    Flag = toggleOptions.Flag
                }
                
                -- Create toggle container
                local ToggleContainer = Instance.new("Frame")
                ToggleContainer.Name = toggleInfo.Name .. "ToggleContainer"
                ToggleContainer.BackgroundTransparency = 1
                ToggleContainer.Size = UDim2.new(1, -20, 0, 32)
                ToggleContainer.Parent = SectionContent
                
                -- Create toggle label
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 42, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -72, 1, 0)
                ToggleLabel.Font = Nova.Font
                ToggleLabel.Text = toggleInfo.Name
                ToggleLabel.TextColor3 = Nova.CurrentTheme.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleContainer
                
                -- Create toggle button
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Button"
                ToggleButton.BackgroundColor3 = toggleInfo.Default and Nova.CurrentTheme.Accent or Nova.CurrentTheme.Secondary
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(0, 0, 0.5, -10)
                ToggleButton.Size = UDim2.new(0, 32, 0, 20)
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleContainer
                
                createCorner(ToggleButton, 10)
                
                -- Create toggle indicator
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.BackgroundColor3 = Nova.CurrentTheme.Text
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Position = toggleInfo.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
                ToggleIndicator.Parent = ToggleButton
                
                createCorner(ToggleIndicator, 8)
                
                -- Toggle functionality
                local toggle = {Value = toggleInfo.Default}
                
                function toggle:Set(value)
                    toggle.Value = value
                    
                    tween(ToggleButton, {Time = Nova.ToggleSpeed}, {
                        BackgroundColor3 = toggle.Value and Nova.CurrentTheme.Accent or Nova.CurrentTheme.Secondary
                    })
                    
                    tween(ToggleIndicator, {Time = Nova.ToggleSpeed}, {
                        Position = toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    })
                    
                    toggleInfo.Callback(toggle.Value)
                    
                    if toggleInfo.Flag then
                        Nova.Flags[toggleInfo.Flag] = toggle.Value
                    end
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    toggle:Set(toggle.Value)
                end)
                
                -- Add to flags if needed
                if toggleInfo.Flag then
                    Nova.Flags = Nova.Flags or {}
                    Nova.Flags[toggleInfo.Flag] = toggle.Value
                end
                
                return toggle
            end
            
            -- Slider function
            function section:AddSlider(sliderOptions)
                sliderOptions = sliderOptions or {}
                
                local sliderInfo = {
                    Name = sliderOptions.Name or "Slider",
                    Min = sliderOptions.Min or 0,
                    Max = sliderOptions.Max or 100,
                    Default = sliderOptions.Default or 50,
                    Increment = sliderOptions.Increment or 1,
                    ValueName = sliderOptions.ValueName or "",
                    Callback = sliderOptions.Callback or function() end,
                    Flag = sliderOptions.Flag
                }
                
                -- Validate default value
                sliderInfo.Default = math.clamp(sliderInfo.Default, sliderInfo.Min, sliderInfo.Max)
                
                -- Create slider container
                local SliderContainer = Instance.new("Frame")
                SliderContainer.Name = sliderInfo.Name .. "SliderContainer"
                SliderContainer.BackgroundTransparency = 1
                SliderContainer.Size = UDim2.new(1, -20, 0, 50)
                SliderContainer.Parent = SectionContent
                
                -- Create slider label
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 0, 0, 0)
                SliderLabel.Size = UDim2.new(1, 0, 0, 20)
                SliderLabel.Font = Nova.Font
                SliderLabel.Text = sliderInfo.Name
                SliderLabel.TextColor3 = Nova.CurrentTheme.Text
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderContainer
                
                -- Create slider value label
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -40, 0, 0)
                SliderValue.Size = UDim2.new(0, 40, 0, 20)
                SliderValue.Font = Nova.Font
                SliderValue.Text = tostring(sliderInfo.Default) .. (sliderInfo.ValueName ~= "" and " " .. sliderInfo.ValueName or "")
                SliderValue.TextColor3 = Nova.CurrentTheme.TextDark
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderContainer
                
                -- Create slider background
                local SliderBackground = Instance.new("Frame")
                SliderBackground.Name = "Background"
                SliderBackground.BackgroundColor3 = Nova.CurrentTheme.Secondary
                SliderBackground.BorderSizePixel = 0
                SliderBackground.Position = UDim2.new(0, 0, 0, 25)
                SliderBackground.Size = UDim2.new(1, 0, 0, 10)
                SliderBackground.Parent = SliderContainer
                
                createCorner(SliderBackground, 5)
                
                -- Create slider fill
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.BackgroundColor3 = Nova.CurrentTheme.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((sliderInfo.Default - sliderInfo.Min) / (sliderInfo.Max - sliderInfo.Min), 0, 1, 0)
                SliderFill.Parent = SliderBackground
                
                createCorner(SliderFill, 5)
                
                -- Create slider knob
                local SliderKnob = Instance.new("Frame")
                SliderKnob.Name = "Knob"
                SliderKnob.BackgroundColor3 = Nova.CurrentTheme.Text
                SliderKnob.BorderSizePixel = 0
                SliderKnob.Position = UDim2.new(1, -10, 0.5, -10)
                SliderKnob.Size = UDim2.new(0, 20, 0, 20)
                SliderKnob.ZIndex = 2
                SliderKnob.Parent = SliderFill
                
                createCorner(SliderKnob, 10)
                createShadow(SliderKnob, 10, 0.3, 1)
                
                -- Slider functionality
                local slider = {Value = sliderInfo.Default}
                local dragging = false
                
                local function updateSlider(value)
                    value = math.clamp(value, sliderInfo.Min, sliderInfo.Max)
                    
                    if sliderInfo.Increment > 0 then
                        value = math.floor(value / sliderInfo.Increment + 0.5) * sliderInfo.Increment
                        value = math.clamp(value, sliderInfo.Min, sliderInfo.Max)
                    end
                    
                    slider.Value = value
                    SliderValue.Text = tostring(slider.Value) .. (sliderInfo.ValueName ~= "" and " " .. sliderInfo.ValueName or "")
                    
                    local percent = (slider.Value - sliderInfo.Min) / (sliderInfo.Max - sliderInfo.Min)
                    tween(SliderFill, {Time = 0.1}, {
                        Size = UDim2.new(percent, 0, 1, 0)
                    })
                    
                    sliderInfo.Callback(slider.Value)
                    
                    if sliderInfo.Flag then
                        Nova.Flags[sliderInfo.Flag] = slider.Value
                    end
                end
                
                function slider:Set(value)
                    updateSlider(value)
                end
                
                SliderBackground.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        
                        local percent = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                        local value = sliderInfo.Min + (sliderInfo.Max - sliderInfo.Min) * percent
                        
                        updateSlider(value)
                    end
                end)
                
                SliderBackground.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                        local value = sliderInfo.Min + (sliderInfo.Max - sliderInfo.Min) * percent
                        
                        updateSlider(value)
                    end
                end)
                
                -- Add to flags if needed
                if sliderInfo.Flag then
                    Nova.Flags = Nova.Flags or {}
                    Nova.Flags[sliderInfo.Flag] = slider.Value
                end
                
                return slider
            end
            
            -- Dropdown function
            function section:AddDropdown(dropdownOptions)
                dropdownOptions = dropdownOptions or {}
                
                local dropdownInfo = {
                    Name = dropdownOptions.Name or "Dropdown",
                    Options = dropdownOptions.Options or {},
                    Default = dropdownOptions.Default or nil,
                    Callback = dropdownOptions.Callback or function() end,
                    Flag = dropdownOptions.Flag
                }
                
                -- Create dropdown container
                local DropdownContainer = Instance.new("Frame")
                DropdownContainer.Name = dropdownInfo.Name .. "DropdownContainer"
                DropdownContainer.BackgroundTransparency = 1
                DropdownContainer.Size = UDim2.new(1, -20, 0, 40)
                DropdownContainer.ClipsDescendants = true
                DropdownContainer.Parent = SectionContent
                
                -- Create dropdown label
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 0, 0, 0)
                DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
                DropdownLabel.Font = Nova.Font
                DropdownLabel.Text = dropdownInfo.Name
                DropdownLabel.TextColor3 = Nova.CurrentTheme.Text
                DropdownLabel.TextSize = 14
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownContainer
                
                -- Create dropdown button
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.BackgroundColor3 = Nova.CurrentTheme.Secondary
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Position = UDim2.new(0, 0, 0, 20)
                DropdownButton.Size = UDim2.new(1, 0, 0, 32)
                DropdownButton.Font = Nova.Font
                DropdownButton.Text = dropdownInfo.Default or "Select..."
                DropdownButton.TextColor3 = Nova.CurrentTheme.Text
                DropdownButton.TextSize = 14
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.TextTruncate = Enum.TextTruncate.AtEnd
                DropdownButton.ClipsDescendants = true
                DropdownButton.Parent = DropdownContainer
                
                createCorner(DropdownButton, 6)
                
                -- Create dropdown icon
                local DropdownIcon = Instance.new("ImageLabel")
DropdownIcon.Name = "DropdownIcon"
DropdownIcon.Size = UDim2.new(0, 20, 0, 20)
DropdownIcon.Position = UDim2.new(1, -25, 0.5, -10)
DropdownIcon.BackgroundTransparency = 1
DropdownIcon.Image = "rbxassetid://6031091004"
DropdownIcon.ImageColor3 = Nova.CurrentTheme.Text
DropdownIcon.Parent = DropdownButton

local OptionsFrame = Instance.new("Frame")
OptionsFrame.Name = "OptionsFrame"
OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
OptionsFrame.BackgroundColor3 = Nova.CurrentTheme.Secondary
OptionsFrame.BorderSizePixel = 0
OptionsFrame.ClipsDescendants = true
OptionsFrame.Visible = false
OptionsFrame.ZIndex = 5
OptionsFrame.Parent = DropdownButton

createCorner(OptionsFrame)
createShadow(OptionsFrame, 15, 0.5, 4)

local OptionsHolder = Instance.new("ScrollingFrame")
OptionsHolder.Name = "OptionsHolder"
OptionsHolder.Size = UDim2.new(1, -10, 1, -10)
OptionsHolder.Position = UDim2.new(0, 5, 0, 5)
OptionsHolder.BackgroundTransparency = 1
OptionsHolder.BorderSizePixel = 0
OptionsHolder.ScrollBarThickness = 2
OptionsHolder.ScrollBarImageColor3 = Nova.CurrentTheme.Accent
OptionsHolder.ZIndex = 5
OptionsHolder.Parent = OptionsFrame

local OptionsList = Instance.new("UIListLayout")
OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
OptionsList.Padding = UDim.new(0, 5)
OptionsList.Parent = OptionsHolder

-- Create options
local optionButtons = {}
for i, option in ipairs(options) do
    local OptionButton = Instance.new("TextButton")
    OptionButton.Name = "Option_" .. option
    OptionButton.Size = UDim2.new(1, 0, 0, 30)
    OptionButton.BackgroundColor3 = Nova.CurrentTheme.Tertiary
    OptionButton.Text = ""
    OptionButton.AutoButtonColor = false
    OptionButton.ZIndex = 6
    OptionButton.Parent = OptionsHolder
    
    createCorner(OptionButton)
    
    local OptionText = Instance.new("TextLabel")
    OptionText.Name = "OptionText"
    OptionText.Size = UDim2.new(1, -10, 1, 0)
    OptionText.Position = UDim2.new(0, 10, 0, 0)
    OptionText.BackgroundTransparency = 1
    OptionText.Text = option
    OptionText.TextColor3 = Nova.CurrentTheme.Text
    OptionText.TextSize = 14
    OptionText.Font = Nova.Font
    OptionText.TextXAlignment = Enum.TextXAlignment.Left
    OptionText.ZIndex = 6
    OptionText.Parent = OptionButton
    
    OptionButton.MouseEnter:Connect(function()
        tween(OptionButton, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Accent})
        tween(OptionText, {Time = 0.2}, {TextColor3 = Color3.fromRGB(255, 255, 255)})
    end)
    
    OptionButton.MouseLeave:Connect(function()
        tween(OptionButton, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Tertiary})
        tween(OptionText, {Time = 0.2}, {TextColor3 = Nova.CurrentTheme.Text})
    end)
    
    OptionButton.MouseButton1Click:Connect(function()
        DropdownText.Text = option
        callback(option)
        
        tween(OptionsFrame, {Time = 0.2}, {Size = UDim2.new(1, 0, 0, 0)})
        tween(DropdownIcon, {Time = 0.2}, {Rotation = 0})
        wait(0.2)
        OptionsFrame.Visible = false
    end)
    
    table.insert(optionButtons, OptionButton)
end

-- Update options frame size
OptionsHolder.CanvasSize = UDim2.new(0, 0, 0, OptionsList.AbsoluteContentSize.Y + 10)

-- Toggle dropdown
local dropdownOpen = false
DropdownButton.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    
    if dropdownOpen then
        OptionsFrame.Visible = true
        tween(OptionsFrame, {Time = 0.2}, {Size = UDim2.new(1, 0, 0, math.min(#options * 35, 150))})
        tween(DropdownIcon, {Time = 0.2}, {Rotation = 180})
    else
        tween(OptionsFrame, {Time = 0.2}, {Size = UDim2.new(1, 0, 0, 0)})
        tween(DropdownIcon, {Time = 0.2}, {Rotation = 0})
        wait(0.2)
        OptionsFrame.Visible = false
    end
end)

return DropdownButton
end

-- Create a slider
function Section:CreateSlider(title, min, max, default, increment, callback)
local Slider = Instance.new("Frame")
Slider.Name = "Slider_" .. title
Slider.Size = UDim2.new(1, -20, 0, 60)
Slider.BackgroundColor3 = Nova.CurrentTheme.Secondary
Slider.BorderSizePixel = 0
Slider.Parent = self.Container

createCorner(Slider)
createShadow(Slider, 10, 0.5, 2)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 0, 20)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = title
Title.TextColor3 = Nova.CurrentTheme.Text
Title.TextSize = 14
Title.Font = Nova.Font
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Slider

local ValueDisplay = Instance.new("TextLabel")
ValueDisplay.Name = "ValueDisplay"
ValueDisplay.Size = UDim2.new(0, 50, 0, 20)
ValueDisplay.Position = UDim2.new(1, -60, 0, 5)
ValueDisplay.BackgroundTransparency = 1
ValueDisplay.Text = tostring(default)
ValueDisplay.TextColor3 = Nova.CurrentTheme.TextDark
ValueDisplay.TextSize = 14
ValueDisplay.Font = Nova.Font
ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
ValueDisplay.Parent = Slider

local SliderBar = Instance.new("Frame")
SliderBar.Name = "SliderBar"
SliderBar.Size = UDim2.new(1, -20, 0, 5)
SliderBar.Position = UDim2.new(0, 10, 0, 35)
SliderBar.BackgroundColor3 = Nova.CurrentTheme.Tertiary
SliderBar.BorderSizePixel = 0
SliderBar.Parent = Slider

createCorner(SliderBar, 10)

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
SliderFill.BackgroundColor3 = Nova.CurrentTheme.Accent
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

createCorner(SliderFill, 10)

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(1, 0, 1, 0)
SliderButton.BackgroundTransparency = 1
SliderButton.Text = ""
SliderButton.Parent = SliderBar

local SliderDragger = Instance.new("Frame")
SliderDragger.Name = "SliderDragger"
SliderDragger.Size = UDim2.new(0, 16, 0, 16)
SliderDragger.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
SliderDragger.BackgroundColor3 = Nova.CurrentTheme.Accent
SliderDragger.BorderSizePixel = 0
SliderDragger.ZIndex = 3
SliderDragger.Parent = SliderBar

createCorner(SliderDragger, 8)
createShadow(SliderDragger, 5, 0.3, 3)

-- Slider functionality
local isDragging = false
local function updateSlider(input)
    local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), -8, 0.5, -8)
    local value = min + ((max - min) * math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1))
    
    -- Apply increment
    value = min + (math.floor((value - min) / increment + 0.5) * increment)
    
    -- Clamp value
    value = math.clamp(value, min, max)
    
    -- Update UI
    local percentage = (value - min) / (max - min)
    SliderDragger.Position = UDim2.new(percentage, -8, 0.5, -8)
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    ValueDisplay.Text = tostring(value)
    
    -- Call callback
    callback(value)
end

SliderButton.MouseButton1Down:Connect(function(input)
    isDragging = true
    updateSlider(input)
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
        updateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

return Slider
end

-- Create a toggle
function Section:CreateToggle(title, default, callback)
local Toggle = Instance.new("Frame")
Toggle.Name = "Toggle_" .. title
Toggle.Size = UDim2.new(1, -20, 0, 40)
Toggle.BackgroundColor3 = Nova.CurrentTheme.Secondary
Toggle.BorderSizePixel = 0
Toggle.Parent = self.Container

createCorner(Toggle)
createShadow(Toggle, 10, 0.5, 2)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = title
Title.TextColor3 = Nova.CurrentTheme.Text
Title.TextSize = 14
Title.Font = Nova.Font
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Toggle

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 40, 0, 20)
ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
ToggleButton.BackgroundColor3 = default and Nova.CurrentTheme.Accent or Nova.CurrentTheme.Tertiary
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = ""
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = Toggle

createCorner(ToggleButton, 10)

local ToggleCircle = Instance.new("Frame")
ToggleCircle.Name = "ToggleCircle"
ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
ToggleCircle.Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleCircle.BorderSizePixel = 0
ToggleCircle.Parent = ToggleButton

createCorner(ToggleCircle, 10)
createShadow(ToggleCircle, 5, 0.3, 3)

-- Toggle functionality
local isToggled = default or false

ToggleButton.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    
    tween(ToggleButton, {Time = Nova.ToggleSpeed}, {BackgroundColor3 = isToggled and Nova.CurrentTheme.Accent or Nova.CurrentTheme.Tertiary})
    tween(ToggleCircle, {Time = Nova.ToggleSpeed}, {Position = UDim2.new(isToggled and 1 or 0, isToggled and -18 or 2, 0.5, -8)})
    
    callback(isToggled)
end)

return Toggle
end

-- Create a button
function Section:CreateButton(title, callback)
local Button = Instance.new("Frame")
Button.Name = "Button_" .. title
Button.Size = UDim2.new(1, -20, 0, 40)
Button.BackgroundColor3 = Nova.CurrentTheme.Secondary
Button.BorderSizePixel = 0
Button.Parent = self.Container

createCorner(Button)
createShadow(Button, 10, 0.5, 2)

local ButtonButton = Instance.new("TextButton")
ButtonButton.Name = "ButtonButton"
ButtonButton.Size = UDim2.new(1, 0, 1, 0)
ButtonButton.BackgroundTransparency = 1
ButtonButton.Text = ""
ButtonButton.Parent = Button

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = title
Title.TextColor3 = Nova.CurrentTheme.Text
Title.TextSize = 14
Title.Font = Nova.Font
Title.Parent = Button

-- Button functionality
ButtonButton.MouseEnter:Connect(function()
    tween(Button, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Accent})
    tween(Title, {Time = 0.2}, {TextColor3 = Color3.fromRGB(255, 255, 255)})
end)

ButtonButton.MouseLeave:Connect(function()
    tween(Button, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Secondary})
    tween(Title, {Time = 0.2}, {TextColor3 = Nova.CurrentTheme.Text})
end)

ButtonButton.MouseButton1Down:Connect(function()
    tween(Button, {Time = 0.1}, {BackgroundColor3 = Color3.fromRGB(Nova.CurrentTheme.Accent.R * 0.8, Nova.CurrentTheme.Accent.G * 0.8, Nova.CurrentTheme.Accent.B * 0.8)})
    createRipple(Button, UDim2.new(0, Mouse.X - Button.AbsolutePosition.X, 0, Mouse.Y - Button.AbsolutePosition.Y))
end)

ButtonButton.MouseButton1Up:Connect(function()
    tween(Button, {Time = 0.1}, {BackgroundColor3 = Nova.CurrentTheme.Accent})
end)

ButtonButton.MouseButton1Click:Connect(function()
    callback()
end)

return Button
end

-- Create a color picker
function Section:CreateColorPicker(title, default, callback)
local ColorPicker = Instance.new("Frame")
ColorPicker.Name = "ColorPicker_" .. title
ColorPicker.Size = UDim2.new(1, -20, 0, 40)
ColorPicker.BackgroundColor3 = Nova.CurrentTheme.Secondary
ColorPicker.BorderSizePixel = 0
ColorPicker.Parent = self.Container

createCorner(ColorPicker)
createShadow(ColorPicker, 10, 0.5, 2)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = title
Title.TextColor3 = Nova.CurrentTheme.Text
Title.TextSize = 14
Title.Font = Nova.Font
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = ColorPicker

local ColorButton = Instance.new("TextButton")
ColorButton.Name = "ColorButton"
ColorButton.Size = UDim2.new(0, 30, 0, 30)
ColorButton.Position = UDim2.new(1, -40, 0.5, -15)
ColorButton.BackgroundColor3 = default or Color3.fromRGB(255, 0, 0)
ColorButton.BorderSizePixel = 0
ColorButton.Text = ""
ColorButton.AutoButtonColor = false
ColorButton.Parent = ColorPicker

createCorner(ColorButton, 6)
createShadow(ColorButton, 5, 0.3, 3)

-- Color picker UI
local ColorPickerFrame = Instance.new("Frame")
ColorPickerFrame.Name = "ColorPickerFrame"
ColorPickerFrame.Size = UDim2.new(0, 200, 0, 220)
ColorPickerFrame.Position = UDim2.new(1, -210, 0, 50)
ColorPickerFrame.BackgroundColor3 = Nova.CurrentTheme.Secondary
ColorPickerFrame.BorderSizePixel = 0
ColorPickerFrame.Visible = false
ColorPickerFrame.ZIndex = 10
ColorPickerFrame.Parent = ColorPicker

createCorner(ColorPickerFrame)
createShadow(ColorPickerFrame, 10, 0.5, 9)

local ColorPickerTitle = Instance.new("TextLabel")
ColorPickerTitle.Name = "ColorPickerTitle"
ColorPickerTitle.Size = UDim2.new(1, -20, 0, 30)
ColorPickerTitle.Position = UDim2.new(0, 10, 0, 5)
ColorPickerTitle.BackgroundTransparency = 1
ColorPickerTitle.Text = "Color Picker"
ColorPickerTitle.TextColor3 = Nova.CurrentTheme.Text
ColorPickerTitle.TextSize = 16
ColorPickerTitle.Font = Nova.FontBold
ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left
ColorPickerTitle.ZIndex = 10
ColorPickerTitle.Parent = ColorPickerFrame

local ColorPickerHue = Instance.new("ImageLabel")
ColorPickerHue.Name = "ColorPickerHue"
ColorPickerHue.Size = UDim2.new(0, 20, 0, 150)
ColorPickerHue.Position = UDim2.new(1, -30, 0, 40)
ColorPickerHue.BackgroundTransparency = 1
ColorPickerHue.Image = "rbxassetid://6523286724"
ColorPickerHue.ZIndex = 10
ColorPickerHue.Parent = ColorPickerFrame

local ColorPickerSatVal = Instance.new("ImageLabel")
ColorPickerSatVal.Name = "ColorPickerSatVal"
ColorPickerSatVal.Size = UDim2.new(0, 150, 0, 150)
ColorPickerSatVal.Position = UDim2.new(0, 10, 0, 40)
ColorPickerSatVal.BackgroundTransparency = 1
ColorPickerSatVal.Image = "rbxassetid://6523291212"
ColorPickerSatVal.ZIndex = 10
ColorPickerSatVal.Parent = ColorPickerFrame

local ColorPickerSatValGradient = Instance.new("UIGradient")
ColorPickerSatValGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})
ColorPickerSatValGradient.Parent = ColorPickerSatVal

local HueSelector = Instance.new("Frame")
HueSelector.Name = "HueSelector"
HueSelector.Size = UDim2.new(1, 0, 0, 3)
HueSelector.Position = UDim2.new(0, 0, 0, 0)
HueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HueSelector.BorderSizePixel = 0
HueSelector.ZIndex = 11
HueSelector.Parent = ColorPickerHue

local SatValSelector = Instance.new("Frame")
SatValSelector.Name = "SatValSelector"
SatValSelector.Size = UDim2.new(0, 10, 0, 10)
SatValSelector.Position = UDim2.new(1, -5, 0, -5)
SatValSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SatValSelector.BorderSizePixel = 0
SatValSelector.ZIndex = 11
SatValSelector.Parent = ColorPickerSatVal

createCorner(SatValSelector, 10)

local ColorPreview = Instance.new("Frame")
ColorPreview.Name = "ColorPreview"
ColorPreview.Size = UDim2.new(0, 30, 0, 30)
ColorPreview.Position = UDim2.new(0, 10, 1, -40)
ColorPreview.BackgroundColor3 = default or Color3.fromRGB(255, 0, 0)
ColorPreview.BorderSizePixel = 0
ColorPreview.ZIndex = 10
ColorPreview.Parent = ColorPickerFrame

createCorner(ColorPreview, 6)

local ColorPickerApply = Instance.new("TextButton")
ColorPickerApply.Name = "ColorPickerApply"
ColorPickerApply.Size = UDim2.new(0, 80, 0, 30)
ColorPickerApply.Position = UDim2.new(1, -90, 1, -40)
ColorPickerApply.BackgroundColor3 = Nova.CurrentTheme.Accent
ColorPickerApply.BorderSizePixel = 0
ColorPickerApply.Text = "Apply"
ColorPickerApply.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPickerApply.TextSize = 14
ColorPickerApply.Font = Nova.Font
ColorPickerApply.ZIndex = 10
ColorPickerApply.Parent = ColorPickerFrame

createCorner(ColorPickerApply, 6)

-- Color picker functionality
local hue, sat, val = 0, 1, 1
local selectedColor = default or Color3.fromRGB(255, 0, 0)

local function updateColor()
    local hsvColor = Color3.fromHSV(hue, sat, val)
    ColorPreview.BackgroundColor3 = hsvColor
    ColorPickerSatValGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 0, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, 1))
    })
    selectedColor = hsvColor
end

local function updateHue(input)
    local huePosition = math.clamp((input.Position.Y - ColorPickerHue.AbsolutePosition.Y) / ColorPickerHue.AbsoluteSize.Y, 0, 1)
    HueSelector.Position = UDim2.new(0, 0, huePosition, -1)
    hue = 1 - huePosition
    updateColor()
end

local function updateSatVal(input)
    local satPosition = math.clamp((input.Position.X - ColorPickerSatVal.AbsolutePosition.X) / ColorPickerSatVal.AbsoluteSize.X, 0, 1)
    local valPosition = math.clamp((input.Position.Y - ColorPickerSatVal.AbsolutePosition.Y) / ColorPickerSatVal.AbsoluteSize.Y, 0, 1)
    SatValSelector.Position = UDim2.new(satPosition, -5, valPosition, -5)
    sat = satPosition
    val = 1 - valPosition
    updateColor()
end

-- Initialize color picker
local function initializeColorPicker()
    local h, s, v = Color3.toHSV(default or Color3.fromRGB(255, 0, 0))
    hue, sat, val = h, s, v
    
    HueSelector.Position = UDim2.new(0, 0, 1 - hue, -1)
    SatValSelector.Position = UDim2.new(sat, -5, 1 - val, -5)
    
    updateColor()
end

initializeColorPicker()

-- Color picker events
local hueDragging = false
ColorPickerHue.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        hueDragging = true
        updateHue(input)
    end
end)

ColorPickerHue.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        hueDragging = false
    end
end)

local satValDragging = false
ColorPickerSatVal.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        satValDragging = true
        updateSatVal(input)
    end
end)

ColorPickerSatVal.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        satValDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if hueDragging then
            updateHue(input)
        elseif satValDragging then
            updateSatVal(input)
        end
    end
end)

-- Toggle color picker
local colorPickerOpen = false
ColorButton.MouseButton1Click:Connect(function()
    colorPickerOpen = not colorPickerOpen
    ColorPickerFrame.Visible = colorPickerOpen
end)

-- Apply color
ColorPickerApply.MouseButton1Click:Connect(function()
    ColorButton.BackgroundColor3 = selectedColor
    callback(selectedColor)
    colorPickerOpen = false
    ColorPickerFrame.Visible = false
end)

return ColorPicker
end

-- Create a keybind
function Section:CreateKeybind(title, default, callback)
local Keybind = Instance.new("Frame")
Keybind.Name = "Keybind_" .. title
Keybind.Size = UDim2.new(1, -20, 0, 40)
Keybind.BackgroundColor3 = Nova.CurrentTheme.Secondary
Keybind.BorderSizePixel = 0
Keybind.Parent = self.Container

createCorner(Keybind)
createShadow(Keybind, 10, 0.5, 2)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = title
Title.TextColor3 = Nova.CurrentTheme.Text
Title.TextSize = 14
Title.Font = Nova.Font
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Keybind

local KeybindButton = Instance.new("TextButton")
KeybindButton.Name = "KeybindButton"
KeybindButton.Size = UDim2.new(0, 100, 0, 30)
KeybindButton.Position = UDim2.new(1, -110, 0.5, -15)
KeybindButton.BackgroundColor3 = Nova.CurrentTheme.Tertiary
KeybindButton.BorderSizePixel = 0
KeybindButton.Text = default and default.Name or "None"
KeybindButton.TextColor3 = Nova.CurrentTheme.Text
KeybindButton.TextSize = 14
KeybindButton.Font = Nova.Font
KeybindButton.AutoButtonColor = false
KeybindButton.Parent = Keybind

createCorner(KeybindButton, 6)
createShadow(KeybindButton, 5, 0.3, 3)

-- Keybind functionality
local selectedKey = default
local listening = false

KeybindButton.MouseButton1Click:Connect(function()
    listening = true
    KeybindButton.Text = "..."
    KeybindButton.TextColor3 = Nova.CurrentTheme.Accent
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if listening and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
        selectedKey = input.KeyCode
        KeybindButton.Text = selectedKey.Name
        KeybindButton.TextColor3 = Nova.CurrentTheme.Text
        listening = false
        callback(selectedKey)
    elseif not listening and not gameProcessed and selectedKey and input.KeyCode == selectedKey then
        callback(selectedKey)
    end
end)

return Keybind
end

-- Create a text box
function Section:CreateTextBox(title, placeholder, callback)
local TextBox = Instance.new("Frame")
TextBox.Name = "TextBox_" .. title
TextBox.Size = UDim2.new(1, -20, 0, 70)
TextBox.BackgroundColor3 = Nova.CurrentTheme.Secondary
TextBox.BorderSizePixel = 0
TextBox.Parent = self.Container

createCorner(TextBox)
createShadow(TextBox, 10, 0.5, 2)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 0, 20)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = title
Title.TextColor3 = Nova.CurrentTheme.Text
Title.TextSize = 14
Title.Font = Nova.Font
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TextBox

local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(1, -20, 0, 30)
InputBox.Position = UDim2.new(0, 10, 0, 30)
InputBox.BackgroundColor3 = Nova.CurrentTheme.Tertiary
InputBox.BorderSizePixel = 0
InputBox.PlaceholderText = placeholder
InputBox.PlaceholderColor3 = Nova.CurrentTheme.TextDark
InputBox.Text = ""
InputBox.TextColor3 = Nova.CurrentTheme.Text
InputBox.TextSize = 14
InputBox.Font = Nova.Font
InputBox.ClearTextOnFocus = false
InputBox.Parent = TextBox

createCorner(InputBox, 6)
createStroke(InputBox, Nova.CurrentTheme.Accent, 0, 0.5)

-- TextBox functionality
InputBox.Focused:Connect(function()
    tween(InputBox, {Time = 0.2}, {BackgroundColor3 = Color3.fromRGB(
        Nova.CurrentTheme.Tertiary.R * 1.1,
        Nova.CurrentTheme.Tertiary.G * 1.1,
        Nova.CurrentTheme.Tertiary.B * 1.1
    )})
    tween(InputBox:FindFirstChildOfClass("UIStroke"), {Time = 0.2}, {Transparency = 0})
end)

InputBox.FocusLost:Connect(function(enterPressed)
    tween(InputBox, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Tertiary})
    tween(InputBox:FindFirstChildOfClass("UIStroke"), {Time = 0.2}, {Transparency = 0.5})
    
    if enterPressed then
        callback(InputBox.Text)
    end
end)

return TextBox
end

-- Create a label
function Section:CreateLabel(text)
local Label = Instance.new("Frame")
Label.Name = "Label_" .. text
Label.Size = UDim2.new(1, -20, 0, 30)
Label.BackgroundColor3 = Nova.CurrentTheme.Secondary
Label.BorderSizePixel = 0
Label.Parent = self.Container

createCorner(Label)
createShadow(Label, 10, 0.5, 2)

local Text = Instance.new("TextLabel")
Text.Name = "Text"
Text.Size = UDim2.new(1, -20, 1, 0)
Text.Position = UDim2.new(0, 10, 0, 0)
Text.BackgroundTransparency = 1
Text.Text = text
Text.TextColor3 = Nova.CurrentTheme.Text
Text.TextSize = 14
Text.Font = Nova.Font
Text.TextXAlignment = Enum.TextXAlignment.Left
Text.Parent = Label

return Label
end

-- Create a separator
function Section:CreateSeparator(text)
local Separator = Instance.new("Frame")
Separator.Name = "Separator_" .. (text or "")
Separator.Size = UDim2.new(1, -20, 0, 20)
Separator.BackgroundTransparency = 1
Separator.Parent = self.Container

local Line1 = Instance.new("Frame")
Line1.Name = "Line1"
Line1.Size = UDim2.new(0.5, -10, 0, 1)
Line1.Position = UDim2.new(0, 0, 0.5, 0)
Line1.BackgroundColor3 = Nova.CurrentTheme.TextDark
Line1.BorderSizePixel = 0
Line1.Parent = Separator

local Line2 = Instance.new("Frame")
Line2.Name = "Line2"
Line2.Size = UDim2.new(0.5, -10, 0, 1)
Line2.Position = UDim2.new(0.5, 10, 0.5, 0)
Line2.BackgroundColor3 = Nova.CurrentTheme.TextDark
Line2.BorderSizePixel = 0
Line2.Parent = Separator

if text then
    Line1.Size = UDim2.new(0.5, -30, 0, 1)
    Line2.Size = UDim2.new(0.5, -30, 0, 1)
    Line2.Position = UDim2.new(0.5, 30, 0.5, 0)
    
    local Text = Instance.new("TextLabel")
    Text.Name = "Text"
    Text.Size = UDim2.new(0, 50, 0, 20)
    Text.Position = UDim2.new(0.5, -25, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = text
    Text.TextColor3 = Nova.CurrentTheme.TextDark
    Text.TextSize = 12
    Text.Font = Nova.Font
    Text.Parent = Separator
end

return Separator
end

-- Create a notification
function Nova:Notify(title, text, duration, options)
options = options or {}
duration = duration or 5

local NotificationHolder = NovaGui:FindFirstChild("NotificationHolder") or Instance.new("Frame")
if not NovaGui:FindFirstChild("NotificationHolder") then
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.Size = UDim2.new(0, 300, 1, 0)
    NotificationHolder.Position = UDim2.new(1, -310, 0, 0)
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Parent = NovaGui
    
    local NotificationList = Instance.new("UIListLayout")
    NotificationList.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationList.Padding = UDim.new(0, 10)
    NotificationList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotificationList.Parent = NotificationHolder
end

local Notification = Instance.new("Frame")
Notification.Name = "Notification"
Notification.Size = UDim2.new(1, -10, 0, 80)
Notification.BackgroundColor3 = Nova.CurrentTheme.Secondary
Notification.BorderSizePixel = 0
Notification.ClipsDescendants = true
Notification.Parent = NotificationHolder

createCorner(Notification)
createShadow(Notification, 15, 0.5, 2)

local NotificationBar = Instance.new("Frame")
NotificationBar.Name = "NotificationBar"
NotificationBar.Size = UDim2.new(1, 0, 0, 5)
NotificationBar.BackgroundColor3 = options.Color or Nova.CurrentTheme.Accent
NotificationBar.BorderSizePixel = 0
NotificationBar.Parent = Notification

local NotificationTitle = Instance.new("TextLabel")
NotificationTitle.Name = "NotificationTitle"
NotificationTitle.Size = UDim2.new(1, -20, 0, 30)
NotificationTitle.Position = UDim2.new(0, 10, 0, 10)
NotificationTitle.BackgroundTransparency = 1
NotificationTitle.Text = title
NotificationTitle.TextColor3 = Nova.CurrentTheme.Text
NotificationTitle.TextSize = 16
NotificationTitle.Font = Nova.FontBold
NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
NotificationTitle.Parent = Notification

local NotificationText = Instance.new("TextLabel")
NotificationText.Name = "NotificationText"
NotificationText.Size = UDim2.new(1, -20, 0, 30)
NotificationText.Position = UDim2.new(0, 10, 0, 40)
NotificationText.BackgroundTransparency = 1
NotificationText.Text = text
NotificationText.TextColor3 = Nova.CurrentTheme.TextDark
NotificationText.TextSize = 14
NotificationText.Font = Nova.Font
NotificationText.TextXAlignment = Enum.TextXAlignment.Left
NotificationText.TextWrapped = true
NotificationText.Parent = Notification

-- Animate notification
Notification.Position = UDim2.new(1, 0, 1, -90)
tween(Notification, {Time = 0.5}, {Position = UDim2.new(0, 0, 1, -90)})

-- Close notification after duration
spawn(function()
    wait(duration)
    tween(Notification, {Time = 0.5}, {Position = UDim2.new(1, 0, 1, -90)})
    wait(0.5)
    Notification:Destroy()
end)

return Notification
end

-- Initialize the library
function Nova:Init()
    -- Add key system if enabled
    if windowOptions.KeySystem then
        -- Create key system UI
        local KeySystem = Instance.new("Frame")
        KeySystem.Name = "KeySystem"
        KeySystem.Size = UDim2.new(0, 400, 0, 200)
        KeySystem.Position = UDim2.new(0.5, -200, 0.5, -100)
        KeySystem.BackgroundColor3 = Nova.CurrentTheme.Primary
        KeySystem.BorderSizePixel = 0
        KeySystem.Parent = NovaGui
        
        createCorner(KeySystem)
        createShadow(KeySystem, 15, 0.5, 2)
        
        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Name = "KeyTitle"
        KeyTitle.Size = UDim2.new(1, -20, 0, 30)
        KeyTitle.Position = UDim2.new(0, 10, 0, 10)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = windowOptions.KeySettings.Title or "Key System"
        KeyTitle.TextColor3 = Nova.CurrentTheme.Text
        KeyTitle.TextSize = 20
        KeyTitle.Font = Nova.FontBold
        KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
        KeyTitle.Parent = KeySystem
        
        local KeySubtitle = Instance.new("TextLabel")
        KeySubtitle.Name = "KeySubtitle"
        KeySubtitle.Size = UDim2.new(1, -20, 0, 20)
        KeySubtitle.Position = UDim2.new(0, 10, 0, 40)
        KeySubtitle.BackgroundTransparency = 1
        KeySubtitle.Text = windowOptions.KeySettings.Subtitle or "Key Verification"
        KeySubtitle.TextColor3 = Nova.CurrentTheme.TextDark
        KeySubtitle.TextSize = 14
        KeySubtitle.Font = Nova.Font
        KeySubtitle.TextXAlignment = Enum.TextXAlignment.Left
        KeySubtitle.Parent = KeySystem
        
        local KeyNote = Instance.new("TextLabel")
        KeyNote.Name = "KeyNote"
        KeyNote.Size = UDim2.new(1, -20, 0, 20)
        KeyNote.Position = UDim2.new(0, 10, 0, 70)
        KeyNote.BackgroundTransparency = 1
        KeyNote.Text = windowOptions.KeySettings.Note or "Enter the key to continue"
        KeyNote.TextColor3 = Nova.CurrentTheme.TextDark
        KeyNote.TextSize = 14
        KeyNote.Font = Nova.Font
        KeyNote.TextXAlignment = Enum.TextXAlignment.Left
        KeyNote.Parent = KeySystem
        
        local KeyInput = Instance.new("TextBox")
        KeyInput.Name = "KeyInput"
        KeyInput.Size = UDim2.new(1, -20, 0, 40)
        KeyInput.Position = UDim2.new(0, 10, 0, 100)
        KeyInput.BackgroundColor3 = Nova.CurrentTheme.Secondary
        KeyInput.BorderSizePixel = 0
        KeyInput.PlaceholderText = "Enter Key"
        KeyInput.PlaceholderColor3 = Nova.CurrentTheme.TextDark
        KeyInput.Text = ""
        KeyInput.TextColor3 = Nova.CurrentTheme.Text
        KeyInput.TextSize = 14
        KeyInput.Font = Nova.Font
        KeyInput.ClearTextOnFocus = false
        KeyInput.Parent = KeySystem
        
        createCorner(KeyInput, 6)
        createStroke(KeyInput, Nova.CurrentTheme.Accent, 1, 0.5)
        
        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Name = "SubmitButton"
        SubmitButton.Size = UDim2.new(0, 100, 0, 30)
        SubmitButton.Position = UDim2.new(0.5, -50, 1, -50)
        SubmitButton.BackgroundColor3 = Nova.CurrentTheme.Accent
        SubmitButton.BorderSizePixel = 0
        SubmitButton.Text = "Submit"
        SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitButton.TextSize = 14
        SubmitButton.Font = Nova.Font
        SubmitButton.Parent = KeySystem
        
        createCorner(SubmitButton, 6)
        createShadow(SubmitButton, 5, 0.3, 3)
        
        -- Key verification
        local function verifyKey(key)
            local keys = windowOptions.KeySettings.Key
            if type(keys) == "string" then
                return key == keys
            elseif type(keys) == "table" then
                for _, validKey in ipairs(keys) do
                    if key == validKey then
                        return true
                    end
                end
            end
            return false
        end
        
        SubmitButton.MouseButton1Click:Connect(function()
            if verifyKey(KeyInput.Text) then
                tween(KeySystem, {Time = 0.5}, {Position = UDim2.new(0.5, -200, 1.5, -100)})
                wait(0.5)
                KeySystem:Destroy()
                
                -- Save key if enabled
                if windowOptions.KeySettings.SaveKey then
                    -- Implementation for saving key would go here
                end
                
                -- Initialize main window
                self:InitMainWindow()
            else
                tween(KeyInput, {Time = 0.1}, {Position = UDim2.new(0, 15, 0, 100)})
                wait(0.05)
                tween(KeyInput, {Time = 0.1}, {Position = UDim2.new(0, 5, 0, 100)})
                wait(0.05)
                tween(KeyInput, {Time = 0.1}, {Position = UDim2.new(0, 10, 0, 100)})
                
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Invalid Key"
                KeyInput.PlaceholderColor3 = Nova.CurrentTheme.Error
            end
        end)
    else
        self:InitMainWindow()
    end
    
    return self
end

function Nova:InitMainWindow()
    -- Create main window
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, windowOptions.Width or 600, 0, windowOptions.Height or 400)
    MainWindow.Position = UDim2.new(0.5, -(windowOptions.Width or 600)/2, 0.5, -(windowOptions.Height or 400)/2)
    MainWindow.BackgroundColor3 = Nova.CurrentTheme.Primary
    MainWindow.BorderSizePixel = 0
    MainWindow.Parent = NovaGui
    
    createCorner(MainWindow)
    createShadow(MainWindow, 15, 0.5, 2)
    
    -- Create title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Nova.CurrentTheme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainWindow
    
    createCorner(TitleBar, 10, true)
    
    local TitleBarLine = Instance.new("Frame")
    TitleBarLine.Name = "TitleBarLine"
    TitleBarLine.Size = UDim2.new(1, 0, 0, 1)
    TitleBarLine.Position = UDim2.new(0, 0, 1, 0)
    TitleBarLine.BackgroundColor3 = Nova.CurrentTheme.Accent
    TitleBarLine.BorderSizePixel = 0
    TitleBarLine.ZIndex = 2
    TitleBarLine.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = windowOptions.Name or "Nova UI Library"
    Title.TextColor3 = Nova.CurrentTheme.Text
    Title.TextSize = 18
    Title.Font = Nova.FontBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Create close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -30, 0.5, -12)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = ""
    CloseButton.Parent = TitleBar
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Name = "CloseIcon"
    CloseIcon.Size = UDim2.new(1, 0, 1, 0)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Image = "rbxassetid://6031094678"
    CloseIcon.ImageColor3 = Nova.CurrentTheme.Text
    CloseIcon.Parent = CloseButton
    
    -- Create minimize button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
    MinimizeButton.Position = UDim2.new(1, -60, 0.5, -12)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Text = ""
    MinimizeButton.Parent = TitleBar
    
    local MinimizeIcon = Instance.new("ImageLabel")
    MinimizeIcon.Name = "MinimizeIcon"
    MinimizeIcon.Size = UDim2.new(1, 0, 1, 0)
    MinimizeIcon.BackgroundTransparency = 1
    MinimizeIcon.Image = "rbxassetid://6031090990"
    MinimizeIcon.ImageColor3 = Nova.CurrentTheme.Text
    MinimizeIcon.Parent = MinimizeButton
    
    -- Create content container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, 0, 1, -40)
    ContentContainer.Position = UDim2.new(0, 0, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainWindow
    
    -- Create tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, 0)
    TabContainer.BackgroundColor3 = Nova.CurrentTheme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = ContentContainer
    
    createCorner(TabContainer, 10, false, true)
    
    local TabContainerLine = Instance.new("Frame")
    TabContainerLine.Name = "TabContainerLine"
    TabContainerLine.Size = UDim2.new(0, 1, 1, 0)
    TabContainerLine.Position = UDim2.new(1, 0, 0, 0)
    TabContainerLine.BackgroundColor3 = Nova.CurrentTheme.Accent
    TabContainerLine.BorderSizePixel = 0
    TabContainerLine.ZIndex = 2
    TabContainerLine.Parent = TabContainer
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 0
    TabList.ScrollingEnabled = true
    TabList.Parent = TabContainer
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabList
    
    local TabListPadding = Instance.new("UIPadding")
    TabListPadding.PaddingTop = UDim.new(0, 10)
    TabListPadding.PaddingLeft = UDim.new(0, 10)
    TabListPadding.PaddingRight = UDim.new(0, 10)
    TabListPadding.Parent = TabList
    
    -- Create tab content container
    local TabContentContainer = Instance.new("Frame")
    TabContentContainer.Name = "TabContentContainer"
    TabContentContainer.Size = UDim2.new(1, -150, 1, 0)
    TabContentContainer.Position = UDim2.new(0, 150, 0, 0)
    TabContentContainer.BackgroundTransparency = 1
    TabContentContainer.Parent = ContentContainer
    
    -- Make window draggable
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainWindow.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        tween(MainWindow, {Time = 0.5}, {Position = UDim2.new(0.5, -(windowOptions.Width or 600)/2, 1.5, -(windowOptions.Height or 400)/2)})
        wait(0.5)
        NovaGui:Destroy()
    end)
    
    -- Minimize button functionality
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            tween(MainWindow, {Time = 0.5}, {Size = UDim2.new(0, windowOptions.Width or 600, 0, 40)})
        else
            tween(MainWindow, {Time = 0.5}, {Size = UDim2.new(0, windowOptions.Width or 600, 0, windowOptions.Height or 400)})
        end
    end)
    
    -- Store references
    self.MainWindow = MainWindow
    self.TabList = TabList
    self.TabContentContainer = TabContentContainer
    
    -- Animate window
    MainWindow.Position = UDim2.new(0.5, -(windowOptions.Width or 600)/2, 1.5, -(windowOptions.Height or 400)/2)
    tween(MainWindow, {Time = 0.5}, {Position = UDim2.new(0.5, -(windowOptions.Width or 600)/2, 0.5, -(windowOptions.Height or 400)/2)})
end

-- Create a tab
function Nova:CreateTab(title, icon)
    -- Create tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "Tab_" .. title
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = Nova.CurrentTheme.Tertiary
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabList
    
    createCorner(TabButton, 8)
    
    local TabIcon
    if icon then
        TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "TabIcon"
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon
        TabIcon.ImageColor3 = Nova.CurrentTheme.Text
        TabIcon.Parent = TabButton
    end
    
    local TabTitle = Instance.new("TextLabel")
    TabTitle.Name = "TabTitle"
    TabTitle.Size = UDim2.new(1, icon and -40 or -20, 1, 0)
    TabTitle.Position = UDim2.new(0, icon and 40 or 10, 0, 0)
    TabTitle.BackgroundTransparency = 1
    TabTitle.Text = title
    TabTitle.TextColor3 = Nova.CurrentTheme.Text
    TabTitle.TextSize = 14
    TabTitle.Font = Nova.Font
    TabTitle.TextXAlignment = Enum.TextXAlignment.Left
    TabTitle.Parent = TabButton
    
    -- Create tab content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = "TabContent_" .. title
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Nova.CurrentTheme.Accent
    TabContent.Visible = false
    TabContent.Parent = self.TabContentContainer
    
    local TabContentLayout = Instance.new("UIListLayout")
    TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabContentLayout.Padding = UDim.new(0, 10)
    TabContentLayout.Parent = TabContent
    
    local TabContentPadding = Instance.new("UIPadding")
    TabContentPadding.PaddingTop = UDim.new(0, 10)
    TabContentPadding.PaddingLeft = UDim.new(0, 10)
    TabContentPadding.PaddingRight = UDim.new(0, 10)
    TabContentPadding.PaddingBottom = UDim.new(0, 10)
    TabContentPadding.Parent = TabContent
    
    -- Tab functionality
    local tab = {
        Button = TabButton,
        Content = TabContent,
        Sections = {}
    }
    
    -- Select tab function
    local function selectTab()
        -- Deselect all tabs
        for _, otherTab in ipairs(self.Tabs) do
            tween(otherTab.Button, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Tertiary})
            otherTab.Content.Visible = false
        end
        
        -- Select this tab
        tween(TabButton, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Accent})
        TabContent.Visible = true
        
        -- Update icon color
        if TabIcon then
            TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        -- Update text color
        TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    TabButton.MouseButton1Click:Connect(selectTab)
    
    -- Add hover effect
    TabButton.MouseEnter:Connect(function()
        if TabContent.Visible then return end
        tween(TabButton, {Time = 0.2}, {BackgroundColor3 = Color3.fromRGB(
            Nova.CurrentTheme.Tertiary.R * 1.1,
            Nova.CurrentTheme.Tertiary.G * 1.1,
            Nova.CurrentTheme.Tertiary.B * 1.1
        )})
    end)
    
    TabButton.MouseLeave:Connect(function()
        if TabContent.Visible then return end
        tween(TabButton, {Time = 0.2}, {BackgroundColor3 = Nova.CurrentTheme.Tertiary})
    end)
    
    -- Create section function
    function tab:CreateSection(title)
        local Section = Instance.new("Frame")
        Section.Name = "Section_" .. title
        Section.Size = UDim2.new(1, -20, 0, 40)
        Section.BackgroundColor3 = Nova.CurrentTheme.Secondary
        Section.BorderSizePixel = 0
        Section.AutomaticSize = Enum.AutomaticSize.Y
        Section.Parent = TabContent
        
        createCorner(Section)
        createShadow(Section, 10, 0.5, 2)
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "SectionTitle"
        SectionTitle.Size = UDim2.new(1, -20, 0, 30)
        SectionTitle.Position = UDim2.new(0, 10, 0, 5)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = title
        SectionTitle.TextColor3 = Nova.CurrentTheme.Text
        SectionTitle.TextSize = 16
        SectionTitle.Font = Nova.FontBold
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = Section
        
        local SectionDivider = Instance.new("Frame")
        SectionDivider.Name = "SectionDivider"
        SectionDivider.Size = UDim2.new(1, -20, 0, 1)
        SectionDivider.Position = UDim2.new(0, 10, 0, 35)
        SectionDivider.BackgroundColor3 = Nova.CurrentTheme.Accent
        SectionDivider.BorderSizePixel = 0
        SectionDivider.Parent = Section
        
        local SectionContainer = Instance.new("Frame")
        SectionContainer.Name = "SectionContainer"
        SectionContainer.Size = UDim2.new(1, 0, 0, 0)
        SectionContainer.Position = UDim2.new(0, 0, 0, 45)
        SectionContainer.BackgroundTransparency = 1
        SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
        SectionContainer.Parent = Section
        
        local SectionLayout = Instance.new("UIListLayout")
        SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SectionLayout.Padding = UDim.new(0, 10)
        SectionLayout.Parent = SectionContainer
        
        local SectionPadding = Instance.new("UIPadding")
        SectionPadding.PaddingTop = UDim.new(0, 5)
        SectionPadding.PaddingLeft = UDim.new(0, 10)
        SectionPadding.PaddingRight = UDim.new(0, 10)
        SectionPadding.PaddingBottom = UDim.new(0, 10)
        SectionPadding.Parent = SectionContainer
        
        -- Update canvas size
        SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Section.Size = UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y + 55)
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Create section object
        local section = {
            Container = SectionContainer
        }
        
        -- Add section to tab
        table.insert(tab.Sections, section)
        
        -- Return section with element creation methods
        return section
    end
    
    -- Add tab to tabs table
    table.insert(self.Tabs, tab)
    
    -- Select first tab
    if #self.Tabs == 1 then
        selectTab()
    end
    
    -- Update canvas size
    TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    return tab
end

-- Return the library
return Nova
