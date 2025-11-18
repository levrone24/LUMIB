-- Delta Android Blox Fruits Executor v3.0
-- GitHub Hosted | Mobile Optimized

getgenv().MobileSettings = {
    AutoFarm = false,
    AutoCollect = false,
    WalkSpeed = 100,
    JumpPower = 150
}

-- Mobile-optimized functions
local function GetLocalPlayer()
    return game:GetService("Players").LocalPlayer
end

local function GetClosestNPC()
    local plr = GetLocalPlayer()
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local root = char.HumanoidRootPart
    local closest = nil
    local distance = 9999
    
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            if npc:FindFirstChild("HumanoidRootPart") then
                local dist = (root.Position - npc.HumanoidRootPart.Position).Magnitude
                if dist < distance then
                    distance = dist
                    closest = npc
                end
            end
        end
    end
    return closest, distance
end

local function MobileTeleport(cframe)
    local plr = GetLocalPlayer()
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = cframe
        wait(0.25)
        -- Anti-stuck mechanism
        if plr.Character.Humanoid.Sit then
            plr.Character.Humanoid.Sit = false
        end
    end
end

-- Auto Farm System
local function MobileFarm()
    local npc, dist = GetClosestNPC()
    if not npc then return end
    
    local plr = GetLocalPlayer()
    local char = plr.Character
    
    if dist < 50 then
        -- Teleport above target
        MobileTeleport(npc.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0))
        
        -- Execute attacks
        local combatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("CombatRemote")
        if combatRemote then
            combatRemote:FireServer("MouseClick", true, npc.HumanoidRootPart.CFrame, npc)
            for i = 1, 3 do
                combatRemote:FireServer("KeyPress", tostring(i), npc)
                wait(0.1)
            end
        end
    end
end

-- Auto Collect System
local function MobileCollect()
    local char = GetLocalPlayer().Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    
    for _, item in pairs(workspace:GetChildren()) do
        if item:IsA("Part") and item.Name == "Drop" then
            if (root.Position - item.Position).Magnitude < 25 then
                firetouchinterest(root, item, 0)
                wait()
                firetouchinterest(root, item, 1)
            end
        end
    end
end

-- Mobile GUI Library
local DeltaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Rayfield/main/source.lua"))()
local Window = DeltaUI:CreateWindow({
    Name = "Delta Android v3.0",
    LoadingTitle = "Mobile Scripts Loading...",
    LoadingSubtitle = "by GitHub Host",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "delta-mobile",
        FileName = "config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = false
})

-- Main Tab
local FarmTab = Window:CreateTab("Auto Farm", "rbxassetid://123456789")
FarmTab:CreateToggle("Auto Farm NPCs", false, function(State)
    getgenv().MobileSettings.AutoFarm = State
    while getgenv().MobileSettings.AutoFarm and wait(0.5) do
        MobileFarm()
    end
end)

FarmTab:CreateToggle("Auto Collect Drops", false, function(State)
    getgenv().MobileSettings.AutoCollect = State
    while getgenv().MobileSettings.AutoCollect and wait(1) do
        MobileCollect()
    end
end)

-- Player Tab
local PlayerTab = Window:CreateTab("Player", "rbxassetid://123456789")
PlayerTab:CreateSlider("WalkSpeed", 16, 500, 100, function(Value)
    getgenv().MobileSettings.WalkSpeed = Value
    local hum = GetLocalPlayer().Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = Value end
end)

PlayerTab:CreateSlider("JumpPower", 50, 500, 150, function(Value)
    getgenv().MobileSettings.JumpPower = Value
    local hum = GetLocalPlayer().Character:FindFirstChild("Humanoid")
    if hum then hum.JumpPower = Value end
end)

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", "rbxassetid://123456789")
TeleportTab:CreateButton("Marine Starter", function()
    MobileTeleport(CFrame.new(-1141, 48, 3827))
end)

TeleportTab:CreateButton("Pirate Starter", function()
    MobileTeleport(CFrame.new(1094, 48, 6834))
end)

TeleportTab:CreateButton("Jungle", function()
    MobileTeleport(CFrame.new(-1506, 72, 366))
end)

TeleportTab:CreateButton("Desert", function()
    MobileTeleport(CFrame.new(1104, 48, 1410))
end)

-- Performance Tab
local PerfTab = Window:CreateTab("Performance", "rbxassetid://123456789")
PerfTab:CreateToggle("Reduce Graphics", false, function(State)
    if State then
        settings().Rendering.QualityLevel = 1
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("Part") then
                part.Material = Enum.Material.Plastic
            end
        end
    end
end)

-- Init complete
DeltaUI:Notify("Delta Android Script Loaded", "GitHub Hosted Version 3.0", 5)
print("Mobile executor activated via GitHub")
