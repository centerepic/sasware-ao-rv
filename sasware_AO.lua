Version = "indev-0.9.1"
Startup = tick()

local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Bin = LocalPlayer:WaitForChild("bin")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Remotes = ReplicatedStorage:WaitForChild("RS"):WaitForChild("Remotes")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local promptGui = CoreGui:WaitForChild("RobloxPromptGui")
local promptOverlay = promptGui:WaitForChild("promptOverlay")
local Temporary = workspace.Map.Temporary
local LoadArea
local LoadNPC = nil
local anonEvent
local anonDB = false

local function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

local FLYING = false
local QEfly = true
local iyflyspeed = 1
local vehicleflyspeed = 1

local IYMouse = Players.LocalPlayer:GetMouse()

local flyKeyDown
local flyKeyUp

function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until IYMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

for index, connection in next, getconnections(Remotes:WaitForChild("Misc").OnTeleport.OnClientEvent) do
    local env = connection.Function and getfenv(connection.Function)
    if env and tostring(rawget(env, "script")) == "Unloading" then
        LoadArea = debug.getupvalue(connection.Function, 2)
        break
    end
end

pcall(function()
for index, connection in next, getconnections(Remotes:WaitForChild("Misc").OnTeleport.OnClientEvent) do
    if connection.Function and tostring(rawget(getfenv(connection.Function), "script")) == "SetupNPCs" then
        Debug("Found and set LoadNPC function.")
        LoadNPC = hookfunction(debug.getupvalue(connection.Function, 6), function(...)
            if not checkcaller() then
                return
            end LoadNPC(...)
        end)
    end
end
end)

local Islands = {}

for i,v in pairs(workspace.Map:GetChildren()) do
    if v:FindFirstChild("DetailsLoaded") and v:FindFirstChild("Center") and not v.Name:find("Shipwreck") then
        table.insert(Islands,v.Name)
    end
end

local Settings = {
    DebuggingEnabled = true
}

Debug = function(...)
    if Settings.DebuggingEnabled then
        print(...)
    end
end

local Round = function(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function SortByDistance(objects)
    table.sort(objects, function(a, b)
        local aDistance = (a.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).magnitude
        local bDistance = (b.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).magnitude
        return aDistance < bDistance
    end)
    return objects
end

local function SortByDistanceBaseParts(objects)
    table.sort(objects, function(a, b)
        local aDistance = (a.Position - LocalPlayer.Character.PrimaryPart.Position).magnitude
        local bDistance = (b.Position - LocalPlayer.Character.PrimaryPart.Position).magnitude
        return aDistance < bDistance
    end)
    return objects
end

local function FindChildByIndexSequence(Parent, IndexSequence)
    local CurrentChild = Parent
    for _, Index in ipairs(IndexSequence) do
        CurrentChild = CurrentChild:FindFirstChild(tostring(Index))
        if not CurrentChild then
            return nil
        end
    end
    return CurrentChild
end

local function GetLoadedIslands()
    local LoadedIslands = {}
    for i,v in pairs(workspace.Map:GetChildren()) do
        if v:FindFirstChild("DetailsLoaded") and v.DetailsLoaded.Value == true then
            table.insert(LoadedIslands,v)
        end
    end
    return LoadedIslands
end

local function GetFoodTools()
    local Food = {}

    local BackpackUI = LocalPlayer.PlayerGui.Backpack.Backpack.Inventory.ScrollingFrame.UIGridFrame
    for i, ToolFrame in pairs(BackpackUI:GetChildren()) do
        Debug(ToolFrame.Name)
        if FindChildByIndexSequence(ToolFrame, {"View", "HungerIcon"}) and ToolFrame:FindFirstChild("Tool") and ToolFrame:FindFirstChild("Tool").Value then
            Debug("Found food item")
            table.insert(Food, ToolFrame.Tool.Value)
        end
    end

    local BackpackUI = LocalPlayer.PlayerGui.Backpack.Backpack.Hotbar
    for i, ToolFrame in pairs(BackpackUI:GetChildren()) do
        Debug(ToolFrame.Name)
        if FindChildByIndexSequence(ToolFrame, {"View", "HungerIcon"}) and ToolFrame:FindFirstChild("Tool") and ToolFrame:FindFirstChild("Tool").Value then
            Debug("Found food item")
            table.insert(Food, ToolFrame.Tool.Value)
        end
    end

    return Food
end

local function FindNearestEnemy()
    local EnemiesFolder = workspace.Enemies
    local MinDistance = math.huge
    local NearestEnemy = nil
    
    for i, Enemy in ipairs(EnemiesFolder:GetChildren()) do
        if Enemy:IsA("Model") and Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            local Distance = (Enemy.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Distance < 20 and Distance < MinDistance then
                MinDistance = Distance
                NearestEnemy = Enemy
            end
        end
    end
    
    return NearestEnemy
end

local function FindNearestPlayer()
    local MinDistance = math.huge
    local NearestEnemy = nil
    
    for _, Enemy in pairs(workspace:GetChildren()) do
        if Enemy:IsA("Model") and Enemy:FindFirstChild("HumanoidRootPart") and Players:FindFirstChild(Enemy.Name) and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
            local Distance = (Enemy.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Distance < 20 and Distance < MinDistance then
                MinDistance = Distance
                NearestEnemy = Enemy
            end
        end
    end
    
    return NearestEnemy
end

local TP = function(Position)
    if typeof(Position) == "Instance" then
        Position = Position.CFrame
    end
    if typeof(Position) == "Vector3" then
        Position = CFrame.new(Position)
    end
    if typeof(Position) == "CFrame" then
        LocalPlayer.Character:PivotTo(Position)
    else
        warn("[!] Invalid Argument Passed to TP()")
    end
end
local FindFirstChildByNameContaining = function(parent, searchStr)
    for _, child in pairs(parent:GetChildren()) do
        if string.find(child.Name, searchStr) then
            return child
        end
    end
    return nil
end

local GetCurrentStoryMarker = function()
    return FindFirstChildByNameContaining(Camera, "StoryMarker")
end

local GetCurrentQuestMarker = function()
    return FindFirstChildByNameContaining(Camera, "QuestMarker")
end

local Enemies = {
    "Shark",
    "Jaw Pirate",
    "Greenwish Cultist",
    "Spire Bandit",
    "Commodore Kai",
    "Blackwater Criminal",
    "Marine",
    "Ravenna Ensign",
    "Ravenna Guard",
    "Ice Smuggler",
    "Frost Brigand",
    "Iris",
    "Lord Elius",
    "General Argos",
    "Lady Carina",
    "King Calvus",
    "Shura"
  }

local function OnCharacterChildAdded(Child)
    if (Toggles.NoKnockback.Value == true or Toggles.AutoFish.Value == true) and Child:IsA("BodyVelocity") and Child.Name == "BodyVelocity" and Child.Parent == LocalPlayer.Character.HumanoidRootPart then
        print(Child.Velocity)
        Child.Velocity = Vector3.new(0,0,0)
    end
end

local function GetShip()
    return workspace.Boats:FindFirstChild(LocalPlayer.Name .. "Boat") or false
end

local function SetWindShake(bool)
    local WindShake = game:GetService("Players").LocalPlayer.PlayerScripts.WindShake
    WindShake.Disabled = not bool
end

local function HeartbeatTP(Position)
    local Connection = RunService.Heartbeat:Connect(function()
        TP(Position)
    end)
    return Connection
end

local function GetClosestChest()
    for i, Island in pairs(GetLoadedIslands()) do
        if Island:FindFirstChild("Chests") then
            local Chests = {}
            for i,v in pairs(Island.Chests:GetChildren()) do
                if v:IsA("Model") then
                    table.insert(Chests,v)
                end
            end

            Chests = SortByDistance(Chests)

            for _,Chest in pairs(Chests) do
                if Chest:IsA("Model") then
                    local PrimaryPart = Chest.PrimaryPart
                    if PrimaryPart and PrimaryPart:FindFirstChild("Prompt") and PrimaryPart.Prompt.Enabled and PrimaryPart.Transparency ~= 1 then
                        return Chest
                    end
                end
            end
        end
    end
    return nil
end

local function GetClosestLostCargo()
    local Cargo = {}
    for i, LostCargo in pairs(Temporary:GetChildren()) do
        if LostCargo.Name == "LostCargo" then
            table.insert(Cargo,LostCargo)
        end
    end

    Cargo = SortByDistanceBaseParts(Cargo)

    for _,LostCargo in pairs(Cargo) do
        return LostCargo
    end

    return nil
end

local AutoChestCoroutine
local AutoLostCargoCoroutine
local AutoFishCoroutine
local AutoEatCoroutine
local AutoEnemyCoro

local Window = Library:CreateWindow({
    Title = 'Arcane Odyssey | ' .. Version,
    Center = true,
    AutoShow = true,
})

-- Create the tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    UISettings = Window:AddTab('UI Settings')
}

-- Add the left and right groupboxes to the Main tab
local CombatGroupBox = Tabs.Main:AddLeftGroupbox('Combat')
local TeleportsGroupBox = Tabs.Main:AddLeftGroupbox('Teleports')
local CharacterGroupBox = Tabs.Main:AddLeftGroupbox('Character')
local NPCGroupBox = Tabs.Main:AddRightGroupbox('NPCs')
local GameGroupBox = Tabs.Main:AddRightGroupbox('Game')

CombatGroupBox:AddToggle('KillAura', {
    Text = 'NPC Kill Aura',
    Default = false,
    Tooltip = 'Spam hits nearest NPC enemy.'
})

CombatGroupBox:AddToggle('PlrKillAura', {
    Text = 'Player Kill Aura',
    Default = false,
    Tooltip = 'Spam hits nearest player.'
})

CombatGroupBox:AddToggle('TPAura', {
    Text = 'TP Aura',
    Default = false,
    Tooltip = 'Additionally loop tps to killaura target.'
})

CombatGroupBox:AddToggle('NoKnockback', {
    Text = 'No Knockback',
    Default = false,
    Tooltip = 'Tries to prevent knockback.'
})

CombatGroupBox:AddToggle('NoWeaponDamage', {
    Text = 'Godmode',
    Default = false,
    Tooltip = 'You cannot take damage.'
})

-- Add the toggles to the NPC groupbox
NPCGroupBox:AddToggle('BlindNPCs', {
    Text = 'Blind NPCs',
    Default = false,
    Tooltip = 'Makes NPCs blind'
})

NPCGroupBox:AddToggle('ImmobileNPCs', {
    Text = 'Immobile NPCs',
    Default = false,
    Tooltip = 'Makes NPCs immobile'
})

local HungerValue = 100
local Eating = false

CharacterGroupBox:AddToggle('AutoEat', {
    Text = 'Auto Eat',
    Default = false,
    Tooltip = 'Automatically eats fruits/other food when hungry.',
    Callback = function(Value)
        if Value then
            AutoEatCoroutine = coroutine.create(function()
                while wait(1) do
                    local HV = tonumber(LocalPlayer.PlayerGui.MainGui.UI.HUD.Anchor.HungerBar.Back.Amount.Text)
                    HungerValue = HV
                    if HungerValue < 50 and Eating == false then
                        Eating = true
                        

                        repeat
                            Debug("Starving!")
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.Backquote,false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,Enum.KeyCode.Backquote,false,game)
                            task.wait(0.2)
                            local Food = GetFoodTools()
                            task.wait(0.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.Backquote,false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,Enum.KeyCode.Backquote,false,game)

                            Debug(#Food)
                            for i,v in pairs(Food) do
                                if not v.Name:find("Buffet") and not v.Name:find("Dinner") and not v.Name:find("Combo") then
                                    Remotes:WaitForChild("Misc"):WaitForChild("ToolAction"):FireServer(v)                                
                                    task.wait(.5)
                                end
                            end
                        until tonumber(LocalPlayer.PlayerGui.MainGui.UI.HUD.Anchor.HungerBar.Back.Amount.Text) >= 70 

                        
                        Eating = false
                    end
                end
                -- Remotes.UI.UpdateHunger.OnClientEvent:Connect(function(HV)
                --     Debug(HV)
                --     HungerValue = HV
                --     if HungerValue < 50 and Eating == false then
                --         Eating = true
                --         Debug("Starving!")
                --         game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.Backquote,false,game)
                --         game:GetService("VirtualInputManager"):SendKeyEvent(false,Enum.KeyCode.Backquote,false,game)
                --         wait(0.5)
                --         local Food = GetFoodTools()
                --         wait(0.5)
                --         game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.Backquote,false,game)
                --         game:GetService("VirtualInputManager"):SendKeyEvent(false,Enum.KeyCode.Backquote,false,game)
                --         Debug(#Food)
                --         local Count = 1
                --         for i,v in pairs(Food) do
                --             if not v.Name:find("Buffet") and not v.Name:find("Dinner") and not v.Name:find("Combo") then
                --                 Remotes:WaitForChild("Misc"):WaitForChild("ToolAction"):FireServer(v)                                
                --                 task.wait(.5)
                --                 Count += 1
                --                 if Count >= 10 then
                --                     break
                --                 end
                --             end
                --         end
                --         Eating = false
                --     end
                -- end)
            end)
            coroutine.resume(AutoEatCoroutine)
        else
            if AutoEatCoroutine then
                coroutine.close(AutoEatCoroutine)
                AutoChestCoroutine = nil
            end
        end
    end
})

CharacterGroupBox:AddToggle('BoatFly', {
    Text = 'Boat/Character Fly',
    Default = false,
    Tooltip = 'Makes you 💨',
    Callback = function(Value)
        if Value then
            NOFLY()
            wait()
            sFLY(true)
        else
            NOFLY()
        end
    end
})

CharacterGroupBox:AddSlider('FlySpeed', {
    Text = 'Fly Speed',
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false
})

Options.FlySpeed:OnChanged(function()
    vehicleflyspeed = Options.FlySpeed.Value
end)

CharacterGroupBox:AddToggle('InfiniteStamina', {
    Text = 'Infinite Stamina',
    Default = false,
    Tooltip = 'Gives you infinite stamina.',
    Callback = function(Value)
        if Value then
            Remotes:WaitForChild("Combat"):WaitForChild("StaminaCost"):FireServer(-1000,"Dodge")
        else
            Remotes:WaitForChild("Combat"):WaitForChild("StaminaCost"):FireServer(Bin.Stamina.Value/Bin.MaxStamina.Value,"Dodge")
        end
    end
})

CharacterGroupBox:AddToggle('Jesus', {
    Text = 'Jesus',
    Default = false,
    Tooltip = 'Lets you walk on water.',
    Callback = function(Value)
        if Value then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
			local newPart = Instance.new("Part")
			newPart.Name = "JesusToggle"
			newPart.Anchored = true
			newPart.CanCollide = true
			newPart.Transparency = 1
			newPart.Size = Vector3.new(50, 1, 50)
			newPart.Parent = workspace
            task.spawn(function()
                while Value do
                    if hrp.Position.Y >= 405 then -- Stop player from using jesus while driving
                        newPart.CanCollide = false
                    else
                        newPart.CanCollide = true
                    end
                    newPart.Position = Vector3.new(hrp.Position.X, 400, hrp.Position.Z)
                    task.wait()
                end
            end)
        else
            pcall(function()
                local thePart = workspace:FindFirstChild("JesusToggle")
                if thePart then
                    thePart:Destroy()
                end
            end)
        end
    end
})

CharacterGroupBox:AddButton({
    Text = 'Hide Name/Level from other players',
    Func = function()
        local Overhead = FindChildByIndexSequence(LocalPlayer.Character, {"Head","Overhead"})
        if Overhead then
            local OverheadClone = Overhead:Clone()
            Overhead.Name = "NotOverhead"
            OverheadClone.Parent = Overhead.Parent
            Overhead:ClearAllChildren()
        end
    end,
    DoubleClick = false,
    Tooltip = 'Hides the UI over your head from other players, makes reporting impossible.'
})

local IslandOffsets = {
    ["Mount Othrys"] = Vector3.new(0, 28063, -10),
    ["Harvest Island"] = Vector3.new(-234, -112, 99),
    ["Ravenna"] = Vector3.new(0, -500, 0)
}

TeleportsGroupBox:AddDropdown('IslandsDropdown', {
    AllowNull = true,
    Values = Islands,
    Default = nil,
    Multi = false,
    Text = 'Teleport to island',
    Tooltip = 'List of islands (Automatically updated)',
})

local HeartbeatConnection
Options.IslandsDropdown:OnChanged(function()
    if Options.IslandsDropdown.Value ~= nil then
        local Island = workspace.Map:FindFirstChild(Options.IslandsDropdown.Value)
        if Island then
            LoadArea(Island.Center.Position, false)
            if HeartbeatConnection then
                HeartbeatConnection:Disconnect()
            end
            HeartbeatConnection = RunService.Heartbeat:Connect(function()
                TP(Island.Center.Position + Vector3.new(0,255,0))
            end)
            repeat task.wait() until Island:FindFirstChild("Notes")
            for i = 10,1,-1 do
                for i,v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Velocity = Vector3.zero
                    end
                end
                task.wait(0.1)
            end
            HeartbeatConnection:Disconnect()
            HeartbeatConnection = nil
            if IslandOffsets[Island.Name] then
                TP(Island.Center.Position - IslandOffsets[Island.Name])
            end
        end
        Options.IslandsDropdown:SetValue(nil)
    end
end)

TeleportsGroupBox:AddButton({
    Text = 'Teleport to current story quest',
    Func = function()
        local StoryMarker = GetCurrentStoryMarker()
        if StoryMarker then
            LoadArea(StoryMarker.Position, false)
            TP(StoryMarker)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to the next story marker, if it exists.'
})

TeleportsGroupBox:AddButton({
    Text = 'Teleport to ship',
    Func = function()
        TP(GetShip().PrimaryPart.Position + Vector3.new(0,20,0))
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to your boat, if it exists.'
})

TeleportsGroupBox:AddButton({
    Text = 'Teleport to current quest',
    Func = function()
        local QuestMarker = GetCurrentQuestMarker()
        if QuestMarker then
            LoadArea(QuestMarker.Position, false)
            TP(QuestMarker)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to the next quest marker, if it exists.'
})

local HBCALC
TeleportsGroupBox:AddToggle('AutoLostCargo', {
    Text = 'Auto Lost Cargo [RISKY]',
    Default = false,
    Tooltip = 'Teleports you to all lost cargo loots it.',
    Callback = function(Value)
        if Value then
            local LastCargoPos = LocalPlayer.Character.HumanoidRootPart.Position
            AutoLostCargoCoroutine = coroutine.create(function()
                
                while wait(1) do
                    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local ClosestCargo = GetClosestLostCargo()
                        if ClosestCargo then

                            local PrimaryPart = ClosestCargo
                
                            if LastCargoPos ~= nil and (LastCargoPos - PrimaryPart.Position).Magnitude > 10 then
                                local TTW = math.abs(((LastCargoPos - PrimaryPart.Position).Magnitude)/70)
                                if TTW < 90 then
                                    if HBCALC then
                                        HBCALC:Disconnect()
                                        HBCALC = nil
                                    end
                                    Library:Notify("Waiting for anticheat heat to dissipate... [" .. tostring(Round(TTW,2)) .. "]", TTW/2)
                                    if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                        repeat wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    end
                                    HBCALC = HeartbeatTP(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,2000,0))
                                    wait(TTW)
                                    if HBCALC then
                                        HBCALC:Disconnect()
                                        HBCALC = nil
                                    end
                                    if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                        repeat wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    end
                                    LocalPlayer.Character.HumanoidRootPart.Anchored = false
                                else
                                    continue
                                end
                            end
                            
                            local Prompt = PrimaryPart:FindFirstChildOfClass("ProximityPrompt")
                            
                            if Prompt then
                                if HBCALC then
                                    HBCALC:Disconnect()
                                    HBCALC = nil
                                end
                                LastCargoPos = PrimaryPart.Position
                                HBCALC = HeartbeatTP(PrimaryPart.Position + Vector3.new(0,5,0))
                                task.wait(0.2)
                                fireproximityprompt(Prompt,math.random(1,2))
                            end
                        end
                    end
                end
            end)
            coroutine.resume(AutoLostCargoCoroutine)
        else
            if AutoLostCargoCoroutine then
                if HBCALC then
                    HBCALC:Disconnect()
                    HBCALC = nil
                end
                coroutine.close(AutoLostCargoCoroutine)
                AutoChestCoroutine = nil
            end
        end
    end
})

local HBCAC
TeleportsGroupBox:AddToggle('AutoChest', {
    Text = 'Auto Chests [RISKY]',
    Default = false,
    Tooltip = 'Teleports you to all chests loaded and loots them.',
    Callback = function(Value)
        if Value then
            AutoChestCoroutine = coroutine.create(function()
                local LastChestPos = LocalPlayer.Character.HumanoidRootPart.Position
                while wait(1) do
                    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local ClosestChest = GetClosestChest()
                        if ClosestChest then

                            local PrimaryPart = ClosestChest.PrimaryPart
                
                            if LastChestPos ~= nil and (LastChestPos - PrimaryPart.Position).Magnitude > 10 then
                                local TTW = math.abs(((LastChestPos - PrimaryPart.Position).Magnitude)/90)
                                --if TTW < 60 then
                                    Library:Notify("Waiting for anticheat heat to dissipate... [" .. tostring(Round(TTW,2)) .. "]", TTW/2)
                                    if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                        repeat wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    end
                                    if HBCAC then
                                        HBCAC:Disconnect()
                                        HBCAC = nil
                                    end
                                    HBCAC = HeartbeatTP(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,2000,0))
                                    wait(TTW)
                                    if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                        repeat wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    end
                                    if HBCAC then
                                        HBCAC:Disconnect()
                                        HBCAC = nil
                                    end
                                --else
                                    --continue
                                --end
                            end
                
                            local Prompt = PrimaryPart:FindFirstChild("Prompt")
                
                            if Prompt then
                                if HBCAC then
                                    HBCAC:Disconnect()
                                    HBCAC = nil
                                end
                                LastChestPos = PrimaryPart.Position
                                HBCAC = HeartbeatTP(PrimaryPart.Position - Vector3.new(0,6,0))
                                --Chests = SortByDistance(Chests)
                                task.wait(0.2)
                                fireproximityprompt(Prompt,math.random(1,2))
                            end
                        end
                    end
                end
            end)
            coroutine.resume(AutoChestCoroutine)
        else
            if HBCAC then
                HBCAC:Disconnect()
                HBCAC = nil
            end
            coroutine.close(AutoChestCoroutine)
            AutoChestCoroutine = nil
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
            for i = 10,1,-1 do
                for i,v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Velocity = Vector3.zero
                    end
                end
                task.wait(0.1)
            end
        end
    end
})

TeleportsGroupBox:AddToggle('InstantProximityPrompt', {
    Text = 'Instant Interact',
    Default = false,
    Tooltip = 'Makes all proximityprompts instant.',
})

GameGroupBox:AddToggle('SkipDialog', {
    Text = 'Auto-Skip Dialog',
    Default = false,
    Tooltip = 'May make choices you don\'t want! Make sure to disable for important story dialog.',
})

GameGroupBox:AddToggle('AllFarm', {
    Text = 'Kill ALL enemies',
    Default = false,
    Tooltip = 'Makes Auto-Kill target all enemies.',
})

GameGroupBox:AddToggle('EnemyFarm', {
    Text = 'Auto-Kill Enemies',
    Default = false,
    Tooltip = 'Automatically Kill Selected Enemies',
    Callback = function(Value)
        if Value then
            AutoEnemyCoro = coroutine.create(function()
                while wait(1) do
                    if Toggles.AllFarm.Value == false then
                        local SelectedEnemies = Options.EnemyDropDown.Value
                        for i,EnemyObject in pairs(workspace.Enemies:GetChildren()) do
                            if SelectedEnemies[EnemyObject.Name] and EnemyObject:FindFirstChild("HumanoidRootPart") and EnemyObject:FindFirstChildOfClass("Humanoid") and EnemyObject.Humanoid.Health > 0 then
                                if EnemyObject.PrimaryPart.Position.Y > 350 and (LocalPlayer.Character.HumanoidRootPart.Position - EnemyObject.PrimaryPart.Position).Magnitude < 550 and EnemyObject:FindFirstChild("LOADED") then
                                    repeat
                                        if EnemyObject:FindFirstChild("HumanoidRootPart") then
                                            RunService.Heartbeat:Wait()
                                            if EnemyObject:FindFirstChild("HumanoidRootPart") and EnemyObject:FindFirstChild("HumanoidRootPart").Position.Y > 350 then
                                                TP(EnemyObject:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,6,0))
                                            end
                                        end
                                    until (not EnemyObject:FindFirstChild("Humanoid")) or EnemyObject.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        for i,EnemyObject in pairs(workspace.Enemies:GetChildren()) do
                            if EnemyObject:FindFirstChild("HumanoidRootPart") and EnemyObject:FindFirstChildOfClass("Humanoid") and EnemyObject.Humanoid.Health > 0 then
                                if EnemyObject.PrimaryPart.Position.Y > 350 and (LocalPlayer.Character.HumanoidRootPart.Position - EnemyObject.PrimaryPart.Position).Magnitude < 550 and EnemyObject:FindFirstChild("LOADED") then
                                    repeat
                                        if EnemyObject:FindFirstChild("HumanoidRootPart") then
                                            RunService.Heartbeat:Wait()
                                            if EnemyObject:FindFirstChild("HumanoidRootPart") and EnemyObject:FindFirstChild("HumanoidRootPart").Position.Y > 350 then
                                                TP(EnemyObject:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,6,0))
                                            end
                                        end
                                    until EnemyObject.Humanoid.Health <= 0
                                end
                            end
                        end
                    end
                end
            end)
            coroutine.resume(AutoEnemyCoro)
        else
            coroutine.close(AutoEnemyCoro)
            AutoEnemyCoro = nil
        end
    end
})

GameGroupBox:AddDropdown('EnemyDropDown', {
    AllowNull = true,
    Values = Enemies,
    Default = nil,
    Multi = true,
    Text = 'Teleport to enemies',
    Tooltip = 'List of Enemies (Automatically updated)',
})

-- GameGroupBox:AddButton({
--     Text = 'Update Enemy list',
--     Func = function()
--         EnemyDropDownObj:SetValues(GetEnemies())
--     end,
--     DoubleClick = false,
--     Tooltip = "Updates enemy list."
-- })

GameGroupBox:AddButton({
    Text = 'Rejoin',
    Func = function()
        TeleportService:Teleport(12604352060, LocalPlayer, tonumber(Bin.File.Value) or 1)
    end,
    DoubleClick = false,
    Tooltip = "Rejoins the server you're currently in."
})

GameGroupBox:AddButton({
    Text = 'Serverhop',
    Func = function()
        local srvHop = loadstring(game:HttpGet('https://raw.githubusercontent.com/AlternateYT/Roblox-Scripts/main/Serverhop%20Module.lua'))()
        srvHop:Hop(game.PlaceId, tonumber(Bin.File.Value) or 1)
    end,
    DoubleClick = false,
    Tooltip = "Server hops to a different server."
})

GameGroupBox:AddButton({
    Text = 'Discover all islands',
    Func = function()
        for i,v in pairs(workspace.Map:GetChildren()) do
            if v:IsA("Folder") and v:FindFirstChild("DetailsLoaded") then
                Remotes:WaitForChild("Misc"):WaitForChild("UpdateLastSeen"):FireServer(v.Name, "")             
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Loads all islands, discovering them.'
})

local EnvGroupBox = Tabs.Main:AddRightGroupbox('Enviornment')

if LoadNPC then
    EnvGroupBox:AddButton({
        Text = 'Load nearby NPCs',
        Func = function()
            for i,NPC in pairs(workspace.NPCs:GetChildren()) do
                if NPC:FindFirstChild("CF") and NPC:IsA("Model") and (NPC.CF.Value.p - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 1000 then
                    pcall(LoadNPC, NPC, NPC.CF.Value.p)
                    pcall(LoadArea, NPC.CF.Value.p, false)
                end
            end
        end,
        DoubleClick = false,
        Tooltip = 'Loads all nearby NPCs instantly.'
    })
end

EnvGroupBox:AddToggle('BadLighting', {
    Text = 'Optimize Lighting',
    Default = false,
    Tooltip = 'Disables future lighting and global shadows.',
    Callback = function(Value)
        if Value == true then
            sethiddenproperty(game.Lighting, "Technology", Enum.Technology.Compatibility)
            game.Lighting.GlobalShadows = false
        else
            sethiddenproperty(game.Lighting, "Technology", Enum.Technology.Future)
            game.Lighting.GlobalShadows = true
        end
    end
})

EnvGroupBox:AddToggle('TreeShake', {
    Text = 'Disable Tree Shake',
    Default = false,
    Tooltip = 'Disable annoying and laggy tree shaking',
    Callback = function(Value)
        SetWindShake(not Value)
    end
})

EnvGroupBox:AddToggle('FullBright', {
    Text = 'Daytime',
    Default = false,
    Tooltip = 'Disables day/night cycle and makes it day.'
})

EnvGroupBox:AddToggle('NoFog', {
    Text = 'Disable Fog',
    Default = false,
    Tooltip = 'You can see!',
    Callback = function(Value)
        if Value then
            TweenService:Create(Lighting.Atmosphere,TweenInfo.new(1),{Density = 0}):Play()
        end
    end
})

--game:GetService("Workspace").Camera.OverheadFX:destroy()
GameGroupBox:AddToggle('AutoFish', {
    Text = 'Auto fish',
    Default = false,
    Tooltip = 'Automatically fishes for you.',
    Callback = function(Value)
        if Value then
            if AutoFishCoroutine then
                coroutine.close(AutoFishCoroutine)
            end
            AutoFishCoroutine = coroutine.create(function()
                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local Humanoid = Character:FindFirstChild("Humanoid")
                local Rod

                local ToolAction = function(Rod)
                    Remotes.Misc.ToolAction:FireServer(Rod)
                end

                local function GetRod()
                    local rod
                    for _, plrRod in pairs(Character:GetChildren()) do
                        if string.find(string.lower(plrRod.Name), "rod") then
                            rod = plrRod
                            break
                        end
                        task.wait()
                    end
                    if not rod then
                        for _, plrRod in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if string.find(string.lower(plrRod.Name), "rod") then
                                rod = plrRod
                                Humanoid:EquipTool(rod)
                                break
                            end
                            task.wait()
                        end
                    end

                    return rod
                end

                while task.wait(1) do
                    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    Humanoid = Character:FindFirstChild("Humanoid")
                    Rod = GetRod()

                    if Rod then

                        local Counter = 0
                        local MaxCounter = 5

                        repeat
                            Counter += 1
                            task.wait(1)
                        until Counter >= MaxCounter or Character:FindFirstChild("FishClock")

                        if Counter < MaxCounter then

                            repeat 
                                task.wait() 
                            until Character:FindFirstChild("FishBiteGoal") and Character:FindFirstChild("FishBiteProgress") or not Character:FindFirstChild("FishClock")

                            local FishBiteGoal = Character:FindFirstChild("FishBiteGoal")
                            local FishBiteProg = Character:FindFirstChild("FishBiteProgress")

                            if FishBiteGoal and FishBiteProg then
                                repeat
                                    ToolAction(Rod)
                                    task.wait(0.1)
                                until FishBiteProg.Value >= FishBiteGoal.Value or not Character:FindFirstChild("FishClock") or not Character:FindFirstChild("BobberVal")
                                Counter = 0
                                FishBiteGoal = nil
                                FishBiteProg = nil
                                repeat task.wait() until not Character:FindFirstChild("BobberVal") and not Character:FindFirstChild("FishClock")
                                task.wait(1)
                            end

                        else
                            ToolAction(Rod)
                        end
                    
                    else
                        Debug("No rod.")
                    end
                end
            end)
            coroutine.resume(AutoFishCoroutine)
        else
            if AutoFishCoroutine then
                coroutine.close(AutoFishCoroutine)
            end
            AutoFishCoroutine = false
        end
    end
})

GameGroupBox:AddSlider('BoatSpeedSlider', {
    Text = 'Boat Speed',
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false
})

local UserInputService = game:GetService("UserInputService")

local isWKeyDown = false
local isSKeyDown = false

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.W then
        isWKeyDown = true
    elseif input.KeyCode == Enum.KeyCode.S then
        isSKeyDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.W then
        isWKeyDown = false
    elseif input.KeyCode == Enum.KeyCode.S then
        isSKeyDown = false
    end
end)

local OldCurrentEnemy
local NearestEnemy
local OldCurrentEnemyPlr
local NearestEnemyPlr

local TargetAquisitionCoro = coroutine.create(function()
    while task.wait(1) do
        if Toggles.KillAura.Value == true and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            pcall(function()
                if OldCurrentEnemy == nil or OldCurrentEnemy:FindFirstChild("HumanoidRootPart") == nil or OldCurrentEnemy:FindFirstChild("Humanoid") == nil or (OldCurrentEnemy.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20 or OldCurrentEnemy.Humanoid.Health <= 0 then
                    NearestEnemy = FindNearestEnemy()
                else
                    NearestEnemy = OldCurrentEnemy
                end
            end)
        end
    end
end)

local TargetAquisitionCoroPlrEnemy = coroutine.create(function()
    while task.wait(1) do
        if Toggles.PlrKillAura.Value == true and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            pcall(function()
                if OldCurrentEnemyPlr == nil or OldCurrentEnemyPlr:FindFirstChild("HumanoidRootPart") == nil or (OldCurrentEnemyPlr.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20 or OldCurrentEnemyPlr.Humanoid.Health <= 0 then
                    NearestEnemyPlr = FindNearestPlayer()
                else
                    NearestEnemyPlr = OldCurrentEnemyPlr
                end
            end)
        end
    end
end)

local AccumulatedDeltaTime = 0
local KillAuraCoro = coroutine.create(function()
    while true do
        local DeltaTime = RunService.Heartbeat:Wait()
    --RunService.Heartbeat:Connect(function(DeltaTime)
        AccumulatedDeltaTime += DeltaTime
        if AccumulatedDeltaTime > 0.05 and Toggles.KillAura.Value == true and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            if LocalPlayer.Character:FindFirstChild("Basic Combat") then
                if Bin.MagicEnergy.Value < 30 then
                    local args = {
                        [1] = true
                    }
                    
                    Remotes.Misc.ChargingToggle:FireServer(unpack(args))
                    wait(1.5)
                    local args = {
                        [1] = false
                    }
                    
                    Remotes.Misc.ChargingToggle:FireServer(unpack(args))
                end
                AccumulatedDeltaTime = 0
                if NearestEnemy and NearestEnemy:FindFirstChild("Humanoid") then
                    if NearestEnemy.Humanoid.Health > 0 then
                        OldCurrentEnemy = NearestEnemy
                        pcall(function()
                            if Toggles.TPAura.Value == true and (LocalPlayer.Character.HumanoidRootPart.Position - NearestEnemy.PrimaryPart.Position).Magnitude < 30 then
                                TP(NearestEnemy.PrimaryPart)
                            end
                        end)

                        local args = {
                            [1] = LocalPlayer.Character:FindFirstChild("Basic Combat"),
                            [3] = NearestEnemy.PrimaryPart.Position
                        }
                        Remotes.Combat.UseMelee:FireServer(unpack(args))
                        
                        local AttackArgs = {
                            [1] = 0,
                            [2] = LocalPlayer.Character,
                            [3] = NearestEnemy,
                            [4] = LocalPlayer.Character:FindFirstChildOfClass("Tool"),
                            [5] = "Attack"
                        }

                        for i = 15,1,-1 do
                            if NearestEnemy.Humanoid.Health > 0 then
                                task.spawn(function()
                                    Remotes.Combat.DealStrengthDamage:FireServer(table.unpack(AttackArgs))
                                end)
                            end
                        end
                    end
                end
            else
                AccumulatedDeltaTime = 0
                if NearestEnemy then
                    OldCurrentEnemy = NearestEnemy
                    pcall(function()
                        if Toggles.TPAura.Value == true and (LocalPlayer.Character.HumanoidRootPart.Position - NearestEnemy.PrimaryPart.Position).Magnitude < 30 then
                            TP(NearestEnemy.PrimaryPart)
                        end
                    end)
                    for i = 4,1,-1 do
                        task.spawn(function()
                            local args = {
                                [1] = 0,
                                [2] = LocalPlayer.Character,
                                [3] = NearestEnemy,
                                [4] = LocalPlayer.Character:FindFirstChildOfClass("Tool"),
                                [5] = "Slash",
                                [6] = NearestEnemy.PrimaryPart.Position,
                                [7] = 1.5
                            }
        
                            Remotes.Combat.DealWeaponDamage:FireServer(table.unpack(args))
                        end)
                    end
                end
            end
        end
    end
end)

local AccumulatedDeltaTimePlr = 0
local KillAuraCoroPlr = coroutine.create(function()
    while true do
        local DeltaTime = RunService.Heartbeat:Wait()
    --RunService.Heartbeat:Connect(function(DeltaTime)
        AccumulatedDeltaTimePlr += DeltaTime
        if AccumulatedDeltaTimePlr > 0.05 and Toggles.PlrKillAura.Value == true and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            if LocalPlayer.Character:FindFirstChild("Basic Combat") then
                if Bin.MagicEnergy.Value < 30 then
                    local args = {
                        [1] = true
                    }
                    
                    Remotes.Misc.ChargingToggle:FireServer(unpack(args))
                    wait(1.5)
                    local args = {
                        [1] = false
                    }
                    
                    Remotes.Misc.ChargingToggle:FireServer(unpack(args))
                end
                AccumulatedDeltaTimePlr = 0
                if NearestEnemyPlr then
                    if NearestEnemyPlr.Humanoid.Health > 0 then
                        OldCurrentEnemyPlr = NearestEnemyPlr
                        pcall(function()
                            if Toggles.TPAura.Value == true and (LocalPlayer.Character.HumanoidRootPart.Position - NearestEnemyPlr.PrimaryPart.Position).Magnitude < 30 then
                                TP(NearestEnemyPlr.PrimaryPart)
                            end
                        end)

                        local args = {
                            [1] = LocalPlayer.Character:FindFirstChild("Basic Combat"),
                            [3] = NearestEnemyPlr.PrimaryPart.Position
                        }
                        Remotes.Combat.UseMelee:FireServer(unpack(args))

                        for i = 8,1,-1 do
                            if NearestEnemyPlr.Humanoid.Health > 0 then
                                task.spawn(function()
                                    local args = {
                                        [1] = 0,
                                        [2] = LocalPlayer.Character,
                                        [3] = NearestEnemyPlr,
                                        [4] = LocalPlayer.Character:FindFirstChildOfClass("Tool"),
                                        [5] = "Attack"
                                    }
                
                                    Remotes.Combat.DealStrengthDamage:FireServer(table.unpack(args))
                                end)
                            end
                        end
                    end
                end
            else
                AccumulatedDeltaTimePlr = 0
                if NearestEnemyPlr then
                    OldCurrentEnemyPlr = NearestEnemyPlr
                    pcall(function()
                        if Toggles.TPAura.Value == true and (LocalPlayer.Character.HumanoidRootPart.Position - NearestEnemyPlr.PrimaryPart.Position).Magnitude < 30 then
                            TP(NearestEnemyPlr.PrimaryPart)
                        end
                    end)
                    for i = 4,1,-1 do
                        task.spawn(function()
                            local args = {
                                [1] = 0,
                                [2] = LocalPlayer.Character,
                                [3] = NearestEnemyPlr,
                                [4] = LocalPlayer.Character:FindFirstChildOfClass("Tool"),
                                [5] = "Slash",
                                [6] = NearestEnemyPlr.PrimaryPart.Position,
                                [7] = 1.5
                            }
        
                            Remotes.Combat.DealWeaponDamage:FireServer(table.unpack(args))
                        end)
                    end
                end
            end
        end
    end
end)

local BoatSpeedCoro = coroutine.create(function()
    RunService.Heartbeat:Connect(function()
        if Options.BoatSpeedSlider.Value > 1 and (isWKeyDown or isSKeyDown) then
            local Boat = GetShip()
            local BodyVelocity = FindChildByIndexSequence(Boat,{"Center", "SailV"})
            if BodyVelocity and BodyVelocity.Velocity.Magnitude > 5 then
                BodyVelocity.Velocity = BodyVelocity.Velocity.Unit * (Boat.Speed.Value * 0.5) * Options.BoatSpeedSlider.Value
            end
        end
    end)
end)

coroutine.resume(BoatSpeedCoro)
coroutine.resume(TargetAquisitionCoro)
coroutine.resume(KillAuraCoro)
coroutine.resume(TargetAquisitionCoroPlrEnemy)
coroutine.resume(KillAuraCoroPlr)

local oldhmmnc
oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    if not checkcaller() then
        if tostring(self) == "SetTarget" or tostring(self) == "ChangeStatus" and getnamecallmethod() == "FireServer" then
            if Toggles.BlindNPCs.Value == true then
                return
            end
        end
        if tostring(self) == "TargetBehavior" and getnamecallmethod() == "InvokeServer" then
            if Toggles.ImmobileNPCs.Value == true then
                return
            end
        end
        if tostring(self) == "DealAttackDamage" and getnamecallmethod() == "FireServer" and Args[2] == LocalPlayer.Character then
            if Toggles.NoWeaponDamage.Value == true then
                return
            end
        end
        if tostring(self) == "TakeSideDamage" and getnamecallmethod() == "FireServer" and workspace.Enemies[Args[1]] then
            if Toggles.NoWeaponDamage.Value == true then
                return
            end
        end
        if tostring(self) == "DealWeaponDamage" and getnamecallmethod() == "FireServer" and Args[3] == LocalPlayer.Character then
            if Toggles.NoWeaponDamage.Value == true then
                return
            end
        end
        if tostring(self) == "DealBossDamage" and getnamecallmethod() == "FireServer" and Args[2] == LocalPlayer.Character then
            if Toggles.NoWeaponDamage.Value == true then
                return
            end
        end
        if self == LocalPlayer and getnamecallmethod() == "Kick" then
            return
        end
    end
    return oldhmmnc(self, ...)
end)

-- local newindexhmm
-- newindexhmm = hookmetamethod(game, "__newindex", function(self, key, val)
--     if not checkcaller() then
--         if tostring(key) == "Text" and Toggles.Anonymous.Value then
--             local function stopText()
--                 local guiText = ""
--                 guiText = tostring(val)
--                 guiText = guiText:gsub(LocalPlayer.Name, "Anonymous")
--                 guiText = guiText:gsub((LocalPlayer.Name):lower(), "Anonymous")
--                 guiText = guiText:gsub(LocalPlayer.DisplayName, "Anonymous")
--                 guiText = guiText:gsub((LocalPlayer.DisplayName):lower(), "Anonymous")
--                 return newindexhmm(self, key, guiText)
--             end
--             if string.find(tostring(val), LocalPlayer.Name) then
--                 stopText()
--             elseif string.find(tostring(val), string.lower(LocalPlayer.Name)) then
--                 stopText()
--             elseif string.find(tostring(val), LocalPlayer.DisplayName) then
--                 stopText()
--             elseif string.find(tostring(val), string.lower(LocalPlayer.DisplayName)) then
--                 stopText()
--             end
--         end
--     end
--     return newindexhmm(self, key, val)
-- end)

Lighting.Atmosphere.Changed:Connect(function(Property)
    if Toggles.FullBright.Value == true then
        if Property == "Decay" then
            Lighting.Atmosphere.Decay = Color3.new(0.690196, 0.839215, 0.827450)
        end
    end
    if Toggles.NoFog.Value == true then
        if Property == "Density" then
            Lighting.Atmosphere.Density = 0
        end
    end
end)

Lighting.Changed:Connect(function(Property)
    if Toggles.FullBright.Value == true then
        if Property == "ClockTime" then
            Lighting.ClockTime = 12
        end
        if Property == "Brightness" then
            Lighting.Brightness = 3
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    local DCon
    DCon = character.DescendantAdded:Connect(OnCharacterChildAdded)
    character:WaitForChild("Humanoid").Died:Once(function()
        DCon:Disconnect()
    end)
end)

LocalPlayer.PlayerGui.ChildAdded:Connect(function(ScreenGui)
    if ScreenGui.Name == "Dialog" and Toggles.SkipDialog.Value == true then
        local ChosenOption = ScreenGui:WaitForChild("ChosenOption", 5)
        local UIOpen = ScreenGui:WaitForChild("Open", 5)
        local QuestDetails = ScreenGui.Background:WaitForChild("QuestDetails", 5)

        if ScreenGui.NPC.Value.Attributes:FindFirstChild("Quest") then
            Debug("QuestDetected")
            repeat
                if QuestDetails.Visible == false then
                    for i = 2,1,-1 do
                        game.VirtualInputManager:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, true, game, 0)
                        wait()
                        game.VirtualInputManager:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, false, game, 0)
                    end
                    ChosenOption.Value = 1
                    Debug("SetValue1")
                    wait(0.45)
                end
            until UIOpen.Value == false or QuestDetails.Visible == true
        else
            repeat
                for i = 2,1,-1 do
                    game.VirtualInputManager:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, true, game, 0)
                    wait()
                    game.VirtualInputManager:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, false, game, 0)
                end
                ChosenOption.Value = 1
                wait()
            until UIOpen.Value == false or QuestDetails.Visible == true
        end
    end
end)

LocalPlayer.Character:WaitForChild("Humanoid")

game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantProximityPrompt.Value == true then
        fireproximityprompt(prompt,1)
    end
end)

local DCon
DCon = LocalPlayer.Character.DescendantAdded:Connect(OnCharacterChildAdded)
LocalPlayer.Character:WaitForChild("Humanoid").Died:Once(function()
    DCon:Disconnect()
    Debug("Disconnected character DescendantAdded.")
end)

-- UI Settings
local MenuGroup = Tabs.UISettings:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function()  Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('saswareao')
SaveManager:SetFolder('saswareao/main')

SaveManager:BuildConfigSection(Tabs.UISettings)

ThemeManager:ApplyToTab(Tabs.UISettings)