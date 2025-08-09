-- Strongest Punch Simulator Orb Teleporter
-- Features: Orb teleportation, nice UI, toggle on/off, minimize/maximize, anti-AFK

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OrbTeleporterUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.2, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Orb Teleporter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Name = "ToggleLabel"
ToggleLabel.Size = UDim2.new(0.5, 0, 0, 25)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "Teleport Active:"
ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleLabel.Font = Enum.Font.Gotham
ToggleLabel.TextSize = 14
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ContentFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.4, 0, 0, 25)
ToggleButton.Position = UDim2.new(0.5, 0, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ContentFrame

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0, 4)
Corner2.Parent = ToggleButton

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 35)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = ContentFrame

local OrbCountLabel = Instance.new("TextLabel")
OrbCountLabel.Name = "OrbCountLabel"
OrbCountLabel.Size = UDim2.new(1, 0, 0, 20)
OrbCountLabel.Position = UDim2.new(0, 0, 0, 60)
OrbCountLabel.BackgroundTransparency = 1
OrbCountLabel.Text = "Orbs Found: 0"
OrbCountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
OrbCountLabel.Font = Enum.Font.Gotham
OrbCountLabel.TextSize = 12
OrbCountLabel.TextXAlignment = Enum.TextXAlignment.Left
OrbCountLabel.Parent = ContentFrame

local AntiAFKLabel = Instance.new("TextLabel")
AntiAFKLabel.Name = "AntiAFKLabel"
AntiAFKLabel.Size = UDim2.new(0.5, 0, 0, 25)
AntiAFKLabel.Position = UDim2.new(0, 0, 0, 85)
AntiAFKLabel.BackgroundTransparency = 1
AntiAFKLabel.Text = "Anti-AFK:"
AntiAFKLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AntiAFKLabel.Font = Enum.Font.Gotham
AntiAFKLabel.TextSize = 14
AntiAFKLabel.TextXAlignment = Enum.TextXAlignment.Left
AntiAFKLabel.Parent = ContentFrame

local AntiAFKButton = Instance.new("TextButton")
AntiAFKButton.Name = "AntiAFKButton"
AntiAFKButton.Size = UDim2.new(0.4, 0, 0, 25)
AntiAFKButton.Position = UDim2.new(0.5, 0, 0, 85)
AntiAFKButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
AntiAFKButton.BorderSizePixel = 0
AntiAFKButton.Text = "ON"
AntiAFKButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAFKButton.Font = Enum.Font.GothamBold
AntiAFKButton.TextSize = 14
AntiAFKButton.Parent = ContentFrame

local Corner3 = Instance.new("UICorner")
Corner3.CornerRadius = UDim.new(0, 4)
Corner3.Parent = AntiAFKButton

-- Dragging functionality
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
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

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- UI Functions
local minimized = false
local teleportActive = false
local antiAFKActive = true
local orbs = {}

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 30)
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 200)
        MinimizeButton.Text = "_"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    script:Destroy()
end)

ToggleButton.MouseButton1Click:Connect(function()
    teleportActive = not teleportActive
    if teleportActive then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        ToggleButton.Text = "ON"
        StatusLabel.Text = "Status: Searching for orbs..."
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        ToggleButton.Text = "OFF"
        StatusLabel.Text = "Status: Idle"
    end
end)

AntiAFKButton.MouseButton1Click:Connect(function()
    antiAFKActive = not antiAFKActive
    if antiAFKActive then
        AntiAFKButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        AntiAFKButton.Text = "ON"
    else
        AntiAFKButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        AntiAFKButton.Text = "OFF"
    end
end)

-- Anti-AFK function
local lastAction = tick()
local function antiAFK()
    if not antiAFKActive then return end
    
    local now = tick()
    if now - lastAction > 30 then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        lastAction = now
    end
end

-- Orb finding function
local function findOrbs()
    orbs = {}
    local found = 0
    
    -- Look for orbs in the workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("orb") and obj:IsA("BasePart") then
            table.insert(orbs, obj)
            found = found + 1
        end
    end
    
    OrbCountLabel.Text = "Orbs Found: " .. found
    return found > 0
end

-- Teleport function
local function teleportToOrb(orb)
    if not orb or not orb.Parent then return false end
    
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    -- Calculate position (try to get above the orb)
    local targetPos = orb.Position + Vector3.new(0, 3, 0)
    
    -- Teleport
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    rootPart.CFrame = CFrame.new(targetPos)
    
    return true
end

-- Main loop
RunService.Heartbeat:Connect(function()
    antiAFK()
    
    if not teleportActive then return end
    
    -- Refresh orbs list every 10 seconds
    if tick() - lastAction > 10 then
        findOrbs()
        lastAction = tick()
    end
    
    -- Find the closest orb
    local closestOrb, closestDist = nil, math.huge
    local char = LocalPlayer.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        for _, orb in pairs(orbs) do
            if orb and orb.Parent then
                local dist = (rootPart.Position - orb.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestOrb = orb
                end
            end
        end
    end
    
    -- Teleport to closest orb if found
    if closestOrb then
        StatusLabel.Text = "Status: Teleporting to orb (" .. math.floor(closestDist) .. " studs away)"
        teleportToOrb(closestOrb)
    else
        StatusLabel.Text = "Status: No orbs found in range"
    end
end)

-- Initial orb scan
task.spawn(function()
    findOrbs()
    StatusLabel.Text = "Status: Ready"
end)
