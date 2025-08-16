-- ARI HUB V2 - Premium Mobile Hack (Fixed for Delta Executor) | By Bebang
-- Compatible: Delta Executor (Android) - No CoreGui - Only ScreenGui

local pcall, wait, ipairs, pairs, tonumber = pcall, wait, ipairs, pairs, tonumber
local game = game
local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- == Settings ==
local SETTINGS = {
    ESP = { Enabled = false, MaxDistance = 1000 },
    Noclip = { Enabled = false },
    Movement = { Speed = 16, InfiniteJump = false },
    Safety = { AntiFall = false },
    Teleport = { Target = nil }
}

-- == Load Settings ==
local function LoadSettings()
    local success, data = pcall(function()
        return readfile("MobileHackSettings.json")
    end)
    if success and data then
        local ok, config = pcall(HttpService.JSONDecode, HttpService, data)
        if ok then
            SETTINGS = config
        end
    end
end

-- == Save Settings ==
local function SaveSettings()
    local json = pcall(function()
        return HttpService:JSONEncode(SETTINGS)
    end)
    if json then
        pcall(function()
            writefile("MobileHackSettings.json", json)
        end)
    end
end

LoadSettings()

-- == Wait for PlayerGui ==
LocalPlayer:WaitForChild("PlayerGui")

-- == Create ScreenGui ==
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileHackUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui -- ✅ Hanya ScreenGui, bukan CoreGui

-- == Main Frame ==
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- == Rounded Corners ==
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- == Glossy Border ==
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(150, 150, 150)
UIStroke.Transparency = 0.7
UIStroke.Parent = MainFrame

-- == Title Bar ==
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
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
Title.Parent = TitleBar

-- == Animate Title ==
coroutine.wrap(function()
    local colors = {
        Color3.fromRGB(0, 100, 255),
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(0, 150, 255)
    }
    while true do
        for i = 1, #colors do
            Title.TextColor3 = colors[i]
            wait(1.5)
        end
    end
end)()

-- == Close Button ==
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

-- == Minimize Button ==
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

-- == Content Frame ==
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -10, 1, -40)
ContentFrame.Position = UDim2.new(0, 5, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- == ESP Toggle ==
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

-- == Player List ==
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 100)
PlayerList.Position = UDim2.new(0.05, 0, 0.15, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PlayerList.BackgroundTransparency = 0.2
PlayerList.ScrollBarThickness = 5
PlayerList.Parent = ContentFrame

-- == Speed Input ==
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

-- == Feature Toggles ==
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

-- == Apply Styling to Buttons/TextBox ==
for _, child in ipairs(ContentFrame:GetChildren()) do
    if child:IsA("TextButton") or child:IsA("TextBox") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = child

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(150, 150, 150)
        stroke.Transparency = 0.7
        stroke.Parent = child
    end
end

-- == ESP System (Fixed Position & Size) ==
local ESPCache = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPCache[player] then
        for _, obj in pairs(ESPCache[player]) do
            if obj and obj.Parent then obj:Destroy() end
        end
        ESPCache[player] = nil
    end

    local function Setup(character)
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local root = character:FindFirstChild("HumanoidRootPart")

        -- ESP Box
        local Box = Instance.new("BoxHandleAdornment")
        Box.Adornee = root
        Box.AlwaysOnTop = true
        Box.Size = Vector3.new(2, 3, 1)
        Box.Color3 = Color3.fromRGB(255, 50, 50)
        Box.Transparency = 0.4
        Box.ZIndex = 10
        Box.Parent = root

        -- Name Label
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(0, 180, 0, 20)
        NameLabel.BackgroundTransparency = 1
        NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameLabel.Text = player.Name
        NameLabel.Font = Enum.Font.SourceSansBold
        NameLabel.TextSize = 16
        NameLabel.Visible = false
        NameLabel.ZIndex = 10
        NameLabel.Parent = ScreenGui

        -- Distance Label
        local DistanceLabel = Instance.new("TextLabel")
        DistanceLabel.Size = UDim2.new(0, 180, 0, 20)
        DistanceLabel.BackgroundTransparency = 1
        DistanceLabel.TextColor3 = Color3.fromRGB(200, 200, 100)
        DistanceLabel.Text = ""
        DistanceLabel.Font = Enum.Font.SourceSans
        DistanceLabel.TextSize = 14
        DistanceLabel.Visible = false
        DistanceLabel.ZIndex = 10
        DistanceLabel.Parent = ScreenGui

        ESPCache[player] = { Box, NameLabel, DistanceLabel }

        local function Update()
            if not SETTINGS.ESP.Enabled or not root or not root.Parent then
                for _, obj in pairs(ESPCache[player]) do
                    if obj and obj.Parent then obj.Visible = false end
                end
                return
            end

            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myHrp then return end

            local dist = (myHrp.Position - root.Position).Magnitude
            if dist > SETTINGS.ESP.MaxDistance then
                NameLabel.Visible = false
                DistanceLabel.Visible = false
                Box.Visible = false
                return
            end

            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                NameLabel.Position = UDim2.new(0, pos.X - 90, 0, pos.Y - 35)
                DistanceLabel.Position = UDim2.new(0, pos.X - 90, 0, pos.Y - 18)
                DistanceLabel.Text = math.floor(dist) .. " studs"
                NameLabel.Visible = true
                DistanceLabel.Visible = true
                Box.Visible = true
            else
                NameLabel.Visible = false
                DistanceLabel.Visible = false
            end
        end

        local conn = RunService.RenderStepped:Connect(Update)
        character.Destroying:Connect(function()
            conn:Disconnect()
            for _, obj in pairs(ESPCache[player]) do
                if obj and obj.Parent then obj:Destroy() end
            end
            ESPCache[player] = nil
        end)
    end

    if player.Character then Setup(player.Character) end
    player.CharacterAdded:Connect(function(char)
        if SETTINGS.ESP.Enabled then Setup(char) end
    end)
end

-- == Apply Speed ==
local function ApplySpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = SETTINGS.Movement.Speed
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    ApplySpeed()
end)

-- == Update Player List ==
local function UpdatePlayerList()
    for _, obj in ipairs(PlayerList:GetChildren()) do
        if obj:IsA("TextButton") then
            obj:Destroy()
        end
    end

    local offset = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 25)
            btn.Position = UDim2.new(0, 5, 0, offset)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.BackgroundTransparency = 0.2
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Text = p.Name
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.Parent = PlayerList

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                SETTINGS.Teleport.Target = p
                SaveSettings()
            end)

            offset = offset + 30
        end
    end
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, offset)
end

-- == Noclip ==
RunService.Stepped:Connect(function()
    if SETTINGS.Noclip.Enabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- == Infinite Jump ==
UserInputService.JumpRequest:Connect(function()
    if SETTINGS.Movement.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- == Anti-Fall Platform ==
local Platform = nil
local function UpdateAntiFall()
    if SETTINGS.Safety.AntiFall then
        if not Platform then
            Platform = Instance.new("Part")
            Platform.Size = Vector3.new(50, 1, 50)
            Platform.Anchored = true
            Platform.Transparency = 0.7
            Platform.Color = Color3.fromRGB(100, 100, 255)
            Platform.CanCollide = true
            Platform.Parent = workspace
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Platform.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 10, 0)
        end
    elseif Platform then
        Platform:Destroy()
        Platform = nil
    end
end

-- == Teleport Function ==
local function Teleport()
    if SETTINGS.Teleport.Target and SETTINGS.Teleport.Target.Character and LocalPlayer.Character then
        local targetHrp = SETTINGS.Teleport.Target.Character:FindFirstChild("HumanoidRootPart")
        local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHrp and myHrp then
            myHrp.CFrame = targetHrp.CFrame
        end
    end
end

-- == UI Events ==
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    local isMin = MainFrame.Size == UDim2.new(0, 280, 0, 30)
    MainFrame.Size = isMin and UDim2.new(0, 280, 0, 350) or UDim2.new(0, 280, 0, 30)
    ContentFrame.Visible = isMin
    MinimizeButton.Text = isMin and "-" or "+"
end)

ESPToggle.MouseButton1Click:Connect(function()
    SETTINGS.ESP.Enabled = not SETTINGS.ESP.Enabled
    ESPToggle.BackgroundColor3 = SETTINGS.ESP.Enabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    ESPToggle.Text = "ESP: "..(SETTINGS.ESP.Enabled and "ON" or "OFF")
    SaveSettings()
    if SETTINGS.ESP.Enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            CreateESP(p)
        end
    else
        for _, esp in pairs(ESPCache) do
            for _, obj in pairs(esp) do
                if obj and obj.Parent then obj:Destroy() end
            end
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
    UpdateAntiFall()
    SaveSettings()
end)

SpeedApply.MouseButton1Click:Connect(function()
    local speed = tonumber(SpeedBox.Text)
    if speed and speed > 0 then
        SETTINGS.Movement.Speed = speed
        ApplySpeed()
        SaveSettings()
    end
end)

TeleportButton.MouseButton1Click:Connect(Teleport)

-- == Initialize ==
UpdatePlayerList()
ApplySpeed()
UpdateAntiFall()

if SETTINGS.ESP.Enabled then
    for _, p in ipairs(Players:GetPlayers()) do
        CreateESP(p)
    end
end

-- == Player Events ==
Players.PlayerAdded:Connect(function(p)
    if SETTINGS.ESP.Enabled then CreateESP(p) end
    UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function(p)
    if ESPCache[p] then
        for _, obj in pairs(ESPCache[p]) do
            if obj and obj.Parent then obj:Destroy() end
        end
        ESPCache[p] = nil
    end
    UpdatePlayerList()
end)

-- == Auto Save Every 10 Seconds ==
while wait(10) do
    SaveSettings()
end
