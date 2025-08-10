-- ARI HUB V2 for Delta Executor (Android)
-- By Bebang (Premium Version)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Settings (with auto-save functionality)
local SETTINGS = {
    ESP = { Enabled = false, MaxDistance = 1000 },
    Noclip = { Enabled = false },
    Movement = { Speed = 16, InfiniteJump = false },
    Safety = { AntiFall = false },
    Teleport = { Target = nil }
}

-- Load settings if they exist
local function LoadSettings()
    local success, savedSettings = pcall(function()
        return readfile("MobileHackSettings.json")
    end)
    if success and savedSettings then
        SETTINGS = game:GetService("HttpService"):JSONDecode(savedSettings)
    end
end

-- Save settings
local function SaveSettings()
    local json = game:GetService("HttpService"):JSONEncode(SETTINGS)
    writefile("MobileHackSettings.json", json)
end

-- Load settings immediately
LoadSettings()

-- UI Setup (Premium Glossy Design)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileHackUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.BackgroundTransparency = 0.2 -- Slightly transparent
MainFrame.Active = true
MainFrame.Draggable = true

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12) -- Rounded corners
UICorner.Parent = MainFrame

-- Glossy effect
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(150, 150, 150)
UIStroke.Transparency = 0.7
UIStroke.Parent = MainFrame

MainFrame.Parent = ScreenGui

-- Title Bar with animated blue text
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BackgroundTransparency = 0.3
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "ARI HUB V2"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Animate title color
local titleColors = {
    Color3.fromRGB(0, 100, 255),
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(0, 200, 255),
    Color3.fromRGB(0, 150, 255)
}

local currentColorIndex = 1
local function animateTitle()
    while true do
        currentColorIndex = currentColorIndex % #titleColors + 1
        local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(Title, tweenInfo, {TextColor3 = titleColors[currentColorIndex]})
        tween:Play()
        wait(1.5)
    end
end
coroutine.wrap(animateTitle)()

-- Control Buttons
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CloseButton.BackgroundTransparency = 0.3
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.BackgroundTransparency = 0.3
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TitleBar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -10, 1, -40)
ContentFrame.Position = UDim2.new(0, 5, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(0.9, 0, 0, 40)
ESPToggle.Position = UDim2.new(0.05, 0, 0, 0)
ESPToggle.BackgroundColor3 = SETTINGS.ESP.Enabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
ESPToggle.BackgroundTransparency = 0.2
ESPToggle.TextColor3 = Color3.new(1, 1, 1)
ESPToggle.Text = SETTINGS.ESP.Enabled and "ESP: ON" or "ESP: OFF"
ESPToggle.Font = Enum.Font.SourceSansBold
ESPToggle.TextSize = 16
ESPToggle.Parent = ContentFrame

-- Player List for Teleport
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 100)
PlayerList.Position = UDim2.new(0.05, 0, 0.15, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PlayerList.BackgroundTransparency = 0.2
PlayerList.ScrollBarThickness = 5
PlayerList.Parent = ContentFrame

-- Speed Control
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.6, 0, 0, 30)
SpeedBox.Position = UDim2.new(0.05, 0, 0.5, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedBox.BackgroundTransparency = 0.2
SpeedBox.TextColor3 = Color3.new(1, 1, 1)
SpeedBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
SpeedBox.Text = tostring(SETTINGS.Movement.Speed)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.TextSize = 16
SpeedBox.Parent = ContentFrame

local SpeedApply = Instance.new("TextButton")
SpeedApply.Size = UDim2.new(0.25, 0, 0, 30)
SpeedApply.Position = UDim2.new(0.7, 0, 0.5, 0)
SpeedApply.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedApply.BackgroundTransparency = 0.2
SpeedApply.TextColor3 = Color3.new(1, 1, 1)
SpeedApply.Text = "Apply"
SpeedApply.Font = Enum.Font.SourceSans
SpeedApply.TextSize = 14
SpeedApply.Parent = ContentFrame

-- Feature Toggles
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(0.43, 0, 0, 30)
NoclipToggle.Position = UDim2.new(0.05, 0, 0.65, 0)
NoclipToggle.BackgroundColor3 = SETTINGS.Noclip.Enabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
NoclipToggle.BackgroundTransparency = 0.2
NoclipToggle.TextColor3 = Color3.new(1, 1, 1)
NoclipToggle.Text = "Noclip: "..(SETTINGS.Noclip.Enabled and "ON" or "OFF")
NoclipToggle.Font = Enum.Font.SourceSans
NoclipToggle.TextSize = 14
NoclipToggle.Parent = ContentFrame

local InfJumpToggle = Instance.new("TextButton")
InfJumpToggle.Size = UDim2.new(0.43, 0, 0, 30)
InfJumpToggle.Position = UDim2.new(0.52, 0, 0.65, 0)
InfJumpToggle.BackgroundColor3 = SETTINGS.Movement.InfiniteJump and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
InfJumpToggle.BackgroundTransparency = 0.2
InfJumpToggle.TextColor3 = Color3.new(1, 1, 1)
InfJumpToggle.Text = "Inf Jump: "..(SETTINGS.Movement.InfiniteJump and "ON" or "OFF")
InfJumpToggle.Font = Enum.Font.SourceSans
InfJumpToggle.TextSize = 14
InfJumpToggle.Parent = ContentFrame

local AntiFallToggle = Instance.new("TextButton")
AntiFallToggle.Size = UDim2.new(0.43, 0, 0, 30)
AntiFallToggle.Position = UDim2.new(0.05, 0, 0.8, 0)
AntiFallToggle.BackgroundColor3 = SETTINGS.Safety.AntiFall and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
AntiFallToggle.BackgroundTransparency = 0.2
AntiFallToggle.TextColor3 = Color3.new(1, 1, 1)
AntiFallToggle.Text = "Anti-Fall: "..(SETTINGS.Safety.AntiFall and "ON" or "OFF")
AntiFallToggle.Font = Enum.Font.SourceSans
AntiFallToggle.TextSize = 14
AntiFallToggle.Parent = ContentFrame

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0.43, 0, 0, 30)
TeleportButton.Position = UDim2.new(0.52, 0, 0.8, 0)
TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportButton.BackgroundTransparency = 0.2
TeleportButton.TextColor3 = Color3.new(1, 1, 1)
TeleportButton.Text = "Teleport"
TeleportButton.Font = Enum.Font.SourceSans
TeleportButton.TextSize = 14
TeleportButton.Parent = ContentFrame

-- Apply rounded corners to all buttons
for _, child in ipairs(ContentFrame:GetChildren()) do
    if child:IsA("TextButton") or child:IsA("TextBox") then
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = child
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Thickness = 1
        btnStroke.Color = Color3.fromRGB(150, 150, 150)
        btnStroke.Transparency = 0.7
        btnStroke.Parent = child
    end
end

-- ESP System (same as before)
local ESPCache = {}

local function createESP(player)
    if player == LocalPlayer then return end
    if ESPCache[player] then 
        if ESPCache[player].Box then ESPCache[player].Box:Destroy() end
        if ESPCache[player].NameLabel then ESPCache[player].NameLabel:Destroy() end
        if ESPCache[player].DistanceLabel then ESPCache[player].DistanceLabel:Destroy() end
        ESPCache[player] = nil
    end
    
    local function setupESP(character)
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        local esp = {
            Box = Instance.new("BoxHandleAdornment"),
            NameLabel = Instance.new("TextLabel"),
            DistanceLabel = Instance.new("TextLabel")
        }
        
        esp.Box.Adornee = rootPart
        esp.Box.AlwaysOnTop = true
        esp.Box.Size = Vector3.new(2, 3, 1)
        esp.Box.Color3 = Color3.fromRGB(255, 50, 50)
        esp.Box.Transparency = 0.5
        esp.Box.Parent = rootPart
        
        esp.NameLabel.Size = UDim2.new(0, 200, 0, 20)
        esp.NameLabel.BackgroundTransparency = 1
        esp.NameLabel.TextColor3 = Color3.new(1, 1, 1)
        esp.NameLabel.Text = player.Name
        esp.NameLabel.Font = Enum.Font.SourceSansBold
        esp.NameLabel.TextSize = 14
        esp.NameLabel.Parent = ScreenGui
        
        esp.DistanceLabel.Size = UDim2.new(0, 200, 0, 20)
        esp.DistanceLabel.BackgroundTransparency = 1
        esp.DistanceLabel.TextColor3 = Color3.new(1, 1, 1)
        esp.DistanceLabel.Font = Enum.Font.SourceSans
        esp.DistanceLabel.TextSize = 12
        esp.DistanceLabel.Parent = ScreenGui
        
        ESPCache[player] = esp
        
        local function update()
            if not SETTINGS.ESP.Enabled or not character or not rootPart or not rootPart.Parent then
                esp.Box.Visible = false
                esp.NameLabel.Visible = false
                esp.DistanceLabel.Visible = false
                return
            end
            
            local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                            (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude) or 0
            if distance > SETTINGS.ESP.MaxDistance then
                esp.Box.Visible = false
                esp.NameLabel.Visible = false
                esp.DistanceLabel.Visible = false
                return
            end
            
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                esp.NameLabel.Position = UDim2.new(0, vector.X, 0, vector.Y - 40)
                esp.DistanceLabel.Position = UDim2.new(0, vector.X, 0, vector.Y - 20)
                esp.DistanceLabel.Text = math.floor(distance).." studs"
                
                esp.Box.Visible = true
                esp.NameLabel.Visible = true
                esp.DistanceLabel.Visible = true
            else
                esp.NameLabel.Visible = false
                esp.DistanceLabel.Visible = false
            end
        end
        
        local renderConnection
        renderConnection = RunService.RenderStepped:Connect(update)
        
        character.Destroying:Connect(function()
            if renderConnection then
                renderConnection:Disconnect()
                renderConnection = nil
            end
            if ESPCache[player] then
                if ESPCache[player].Box then ESPCache[player].Box:Destroy() end
                if ESPCache[player].NameLabel then ESPCache[player].NameLabel:Destroy() end
                if ESPCache[player].DistanceLabel then ESPCache[player].DistanceLabel:Destroy() end
                ESPCache[player] = nil
            end
        end)
    end
    
    if player.Character then
        setupESP(player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        if SETTINGS.ESP.Enabled then
            setupESP(character)
        end
    end)
end

-- Speed System with respawn persistence
local function applySpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = SETTINGS.Movement.Speed
    end
end

-- Apply speed when character respawns
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.5) -- Small delay to ensure humanoid is loaded
    applySpeed()
end)

-- Update Player List
local function updatePlayerList()
    PlayerList:ClearAllChildren()
    
    local yOffset = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 25)
            button.Position = UDim2.new(0, 5, 0, yOffset)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            button.BackgroundTransparency = 0.2
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Text = player.Name
            button.Font = Enum.Font.SourceSans
            button.TextSize = 14
            button.Parent = PlayerList
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = button
            
            button.MouseButton1Click:Connect(function()
                SETTINGS.Teleport.Target = player
                SaveSettings()
            end)
            
            yOffset = yOffset + 30
        end
    end
    
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Noclip Function
local function noclip()
    if SETTINGS.Noclip.Enabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- Infinite Jump
local function infiniteJump()
    if SETTINGS.Movement.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Anti-Fall Platform (Fixed to stay in place)
local platform
local function updateAntiFall()
    if SETTINGS.Safety.AntiFall then
        if not platform then
            platform = Instance.new("Part")
            platform.Size = Vector3.new(50, 1, 50)
            platform.Anchored = true
            platform.Transparency = 0.7
            platform.Color = Color3.fromRGB(100, 100, 255)
            platform.CanCollide = true
            platform.Parent = workspace
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                platform.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 10, 0)
            else
                platform.Position = Vector3.new(0, 0, 0)
            end
        end
    elseif platform then
        platform:Destroy()
        platform = nil
    end
end

-- Teleport Function
local function teleport()
    if SETTINGS.Teleport.Target and SETTINGS.Teleport.Target.Character and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = SETTINGS.Teleport.Target.Character:FindFirstChild("HumanoidRootPart").CFrame
        SaveSettings()
    end
end

-- UI Events
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 280, 0, 30) or UDim2.new(0, 280, 0, 350)
    ContentFrame.Visible = not isMinimized
    MinimizeButton.Text = isMinimized and "+" or "-"
end)

ESPToggle.MouseButton1Click:Connect(function()
    SETTINGS.ESP.Enabled = not SETTINGS.ESP.Enabled
    ESPToggle.BackgroundColor3 = SETTINGS.ESP.Enabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    ESPToggle.Text = SETTINGS.ESP.Enabled and "ESP: ON" or "ESP: OFF"
    SaveSettings()
    
    if SETTINGS.ESP.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
    else
        for _, esp in pairs(ESPCache) do
            if esp.Box then esp.Box:Destroy() end
            if esp.NameLabel then esp.NameLabel:Destroy() end
            if esp.DistanceLabel then esp.DistanceLabel:Destroy() end
        end
        ESPCache = {}
    end
end)

NoclipToggle.MouseButton1Click:Connect(function()
    SETTINGS.Noclip.Enabled = not SETTINGS.Noclip.Enabled
    NoclipToggle.BackgroundColor3 = SETTINGS.Noclip.Enabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    NoclipToggle.Text = "Noclip: "..(SETTINGS.Noclip.Enabled and "ON" or "OFF")
    SaveSettings()
end)

InfJumpToggle.MouseButton1Click:Connect(function()
    SETTINGS.Movement.InfiniteJump = not SETTINGS.Movement.InfiniteJump
    InfJumpToggle.BackgroundColor3 = SETTINGS.Movement.InfiniteJump and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    InfJumpToggle.Text = "Inf Jump: "..(SETTINGS.Movement.InfiniteJump and "ON" or "OFF")
    SaveSettings()
end)

AntiFallToggle.MouseButton1Click:Connect(function()
    SETTINGS.Safety.AntiFall = not SETTINGS.Safety.AntiFall
    AntiFallToggle.BackgroundColor3 = SETTINGS.Safety.AntiFall and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    AntiFallToggle.Text = "Anti-Fall: "..(SETTINGS.Safety.AntiFall and "ON" or "OFF")
    updateAntiFall()
    SaveSettings()
end)

SpeedApply.MouseButton1Click:Connect(function()
    local speed = tonumber(SpeedBox.Text)
    if speed and speed > 0 then
        SETTINGS.Movement.Speed = speed
        applySpeed()
        SaveSettings()
    end
end)

TeleportButton.MouseButton1Click:Connect(function()
    teleport()
end)

-- Initialize
updatePlayerList()
applySpeed() -- Apply speed immediately
updateAntiFall()

-- Initialize ESP if enabled
if SETTINGS.ESP.Enabled then
    for _, player in ipairs(Players:GetPlayers()) do
        createESP(player)
    end
end

-- Connections
RunService.Stepped:Connect(noclip)

UserInputService.JumpRequest:Connect(function()
    infiniteJump()
end)

Players.PlayerAdded:Connect(function(player)
    if SETTINGS.ESP.Enabled then
        createESP(player)
    end
    updatePlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPCache[player] then
        if ESPCache[player].Box then ESPCache[player].Box:Destroy() end
        if ESPCache[player].NameLabel then ESPCache[player].NameLabel:Destroy() end
        if ESPCache[player].DistanceLabel then ESPCache[player].DistanceLabel:Destroy() end
        ESPCache[player] = nil
    end
    updatePlayerList()
end)

-- Auto-update
while wait(1) do
    SaveSettings()
end
