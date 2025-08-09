-- Strongest Punch Simulator Orb Teleporter
-- Enhanced version with better orb detection, UI, and anti-AFK

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
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Title Bar
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
Title.Text = "Orb Teleporter v3"
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

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Teleport Section
local TeleportSection = Instance.new("Frame")
TeleportSection.Name = "TeleportSection"
TeleportSection.Size = UDim2.new(1, 0, 0, 100)
TeleportSection.BackgroundTransparency = 1
TeleportSection.Parent = ContentFrame

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Name = "ToggleLabel"
ToggleLabel.Size = UDim2.new(0.5, 0, 0, 25)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "Teleport Active:"
ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleLabel.Font = Enum.Font.Gotham
ToggleLabel.TextSize = 14
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = TeleportSection

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
ToggleButton.Parent = TeleportSection

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0, 4)
Corner2.Parent = ToggleButton

local OrbTypeLabel = Instance.new("TextLabel")
OrbTypeLabel.Name = "OrbTypeLabel"
OrbTypeLabel.Size = UDim2.new(0.5, 0, 0, 25)
OrbTypeLabel.Position = UDim2.new(0, 0, 0, 30)
OrbTypeLabel.BackgroundTransparency = 1
OrbTypeLabel.Text = "Orb Type:"
OrbTypeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
OrbTypeLabel.Font = Enum.Font.Gotham
OrbTypeLabel.TextSize = 14
OrbTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
OrbTypeLabel.Parent = TeleportSection

local OrbTypeBox = Instance.new("TextBox")
OrbTypeBox.Name = "OrbTypeBox"
OrbTypeBox.Size = UDim2.new(0.4, 0, 0, 25)
OrbTypeBox.Position = UDim2.new(0.5, 0, 0, 30)
OrbTypeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
OrbTypeBox.BorderSizePixel = 0
OrbTypeBox.Text = "Orb" -- Default search term
OrbTypeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
OrbTypeBox.Font = Enum.Font.Gotham
OrbTypeBox.TextSize = 14
OrbTypeBox.PlaceholderText = "Enter orb name"
OrbTypeBox.Parent = TeleportSection

local Corner4 = Instance.new("UICorner")
Corner4.CornerRadius = UDim.new(0, 4)
Corner4.Parent = OrbTypeBox

local ScanRangeLabel = Instance.new("TextLabel")
ScanRangeLabel.Name = "ScanRangeLabel"
ScanRangeLabel.Size = UDim2.new(0.5, 0, 0, 25)
ScanRangeLabel.Position = UDim2.new(0, 0, 0, 60)
ScanRangeLabel.BackgroundTransparency = 1
ScanRangeLabel.Text = "Scan Range:"
ScanRangeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ScanRangeLabel.Font = Enum.Font.Gotham
ScanRangeLabel.TextSize = 14
ScanRangeLabel.TextXAlignment = Enum.TextXAlignment.Left
ScanRangeLabel.Parent = TeleportSection

local ScanRangeBox = Instance.new("TextBox")
ScanRangeBox.Name = "ScanRangeBox"
ScanRangeBox.Size = UDim2.new(0.4, 0, 0, 25)
ScanRangeBox.Position = UDim2.new(0.5, 0, 0, 60)
ScanRangeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ScanRangeBox.BorderSizePixel = 0
ScanRangeBox.Text = "500" -- Default scan range
ScanRangeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanRangeBox.Font = Enum.Font.Gotham
ScanRangeBox.TextSize = 14
ScanRangeBox.Parent = TeleportSection

local Corner5 = Instance.new("UICorner")
Corner5.CornerRadius = UDim.new(0, 4)
Corner5.Parent = ScanRangeBox

-- Info Section
local InfoSection = Instance.new("Frame")
InfoSection.Name = "InfoSection"
InfoSection.Size = UDim2.new(1, 0, 0, 60)
InfoSection.Position = UDim2.new(0, 0, 0, 110)
InfoSection.BackgroundTransparency = 1
InfoSection.Parent = ContentFrame

local OrbCountLabel = Instance.new("TextLabel")
OrbCountLabel.Name = "OrbCountLabel"
OrbCountLabel.Size = UDim2.new(1, 0, 0, 20)
OrbCountLabel.BackgroundTransparency = 1
OrbCountLabel.Text = "Orbs Found: 0"
OrbCountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
OrbCountLabel.Font = Enum.Font.Gotham
OrbCountLabel.TextSize = 12
OrbCountLabel.TextXAlignment = Enum.TextXAlignment.Left
OrbCountLabel.Parent = InfoSection

local LastOrbLabel = Instance.new("TextLabel")
LastOrbLabel.Name = "LastOrbLabel"
LastOrbLabel.Size = UDim2.new(1, 0, 0, 20)
LastOrbLabel.Position = UDim2.new(0, 0, 0, 20)
LastOrbLabel.BackgroundTransparency = 1
LastOrbLabel.Text = "Last Orb: None"
LastOrbLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LastOrbLabel.Font = Enum.Font.Gotham
LastOrbLabel.TextSize = 12
LastOrbLabel.TextXAlignment = Enum.TextXAlignment.Left
LastOrbLabel.Parent = InfoSection

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = InfoSection

-- Anti-AFK Section
local AntiAFKSection = Instance.new("Frame")
AntiAFKSection.Name = "AntiAFKSection"
AntiAFKSection.Size = UDim2.new(1, 0, 0, 25)
AntiAFKSection.Position = UDim2.new(0, 0, 0, 180)
AntiAFKSection.BackgroundTransparency = 1
AntiAFKSection.Parent = ContentFrame

local AntiAFKLabel = Instance.new("TextLabel")
AntiAFKLabel.Name = "AntiAFKLabel"
AntiAFKLabel.Size = UDim2.new(0.5, 0, 1, 0)
AntiAFKLabel.BackgroundTransparency = 1
AntiAFKLabel.Text = "Anti-AFK:"
AntiAFKLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AntiAFKLabel.Font = Enum.Font.Gotham
AntiAFKLabel.TextSize = 14
AntiAFKLabel.TextXAlignment = Enum.TextXAlignment.Left
AntiAFKLabel.Parent = AntiAFKSection

local AntiAFKButton = Instance.new("TextButton")
AntiAFKButton.Name = "AntiAFKButton"
AntiAFKButton.Size = UDim2.new(0.4, 0, 1, 0)
AntiAFKButton.Position = UDim2.new(0.5, 0, 0, 0)
AntiAFKButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
AntiAFKButton.BorderSizePixel = 0
AntiAFKButton.Text = "ON"
AntiAFKButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAFKButton.Font = Enum.Font.GothamBold
AntiAFKButton.TextSize = 14
AntiAFKButton.Parent = AntiAFKSection

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
local lastOrbName = "None"

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 350, 0, 30)
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 350, 0, 250)
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
        findOrbs()
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

-- Enhanced orb finding function
local function findOrbs()
    orbs = {}
    local found = 0
    local searchTerm = OrbTypeBox.Text
    local scanRange = tonumber(ScanRangeBox.Text) or 500
    
    if searchTerm == "" then
        StatusLabel.Text = "Status: Please enter orb name"
        return false
    end
    
    -- Get player position
    local char = LocalPlayer.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        StatusLabel.Text = "Status: No character found"
        return false
    end
    
    -- Look for orbs in the workspace with more flexible matching
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj:IsDescendantOf(workspace) then
            -- Check distance first for performance
            local dist = (rootPart.Position - obj.Position).Magnitude
            if dist > scanRange then continue end
            
            -- Check if name contains search term (case insensitive)
            if obj.Name:lower():find(searchTerm:lower(), 1, true) then
                -- Additional checks to confirm it's an orb
                if obj:FindFirstChildOfClass("ParticleEmitter") or 
                   obj:FindFirstChildOfClass("PointLight") or
                   obj.Transparency < 1 then
                    table.insert(orbs, obj)
                    found = found + 1
                end
            end
        end
    end
    
    OrbCountLabel.Text = "Orbs Found: " .. found
    StatusLabel.Text = found > 0 and "Status: Found "..found.." orbs" or "Status: No orbs found"
    return found > 0
end

-- Improved teleport function
local function teleportToOrb(orb)
    if not orb or not orb.Parent then return false end
    
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    -- Save the orb name for display
    lastOrbName = orb.Name
    LastOrbLabel.Text = "Last Orb: "..lastOrbName
    
    -- Calculate position (try to get above the orb)
    local targetPos = orb.Position + Vector3.new(0, 3, 0)
    
    -- Teleport with small delay
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    task.wait(0.1)
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
        StatusLabel.Text = "Status: Teleporting to "..closestOrb.Name.." (" .. math.floor(closestDist) .. " studs)"
        teleportToOrb(closestOrb)
    else
        StatusLabel.Text = "Status: No orbs found in range"
    end
end)

-- Initial setup
task.spawn(function()
    StatusLabel.Text = "Status: Ready"
    LastOrbLabel.Text = "Last Orb: None"
end)
