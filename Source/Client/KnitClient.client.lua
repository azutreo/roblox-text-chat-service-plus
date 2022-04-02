--[[

	KnitClient
	- Client
	Nicholas Foreman

	Loads, initializes, and starts Knit

--]]

-- Wait for the player to load into the game before loading Knit
if not game:IsLoaded() then
	game.Loaded:Wait()
end

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

------------------------------
-- LOAD AND INITIALIZE KNIT --
------------------------------

local Knit: table = require(ReplicatedStorage:WaitForChild("Packages").Knit)
local Controllers: Folder = script.Parent:WaitForChild("Controllers")
local Components: Folder = script.Parent:WaitForChild("Components")

-- References to modules
Knit.SharedModules = ReplicatedStorage:WaitForChild("Modules")
Knit.ClientModules = script.Parent:WaitForChild("Modules")

Knit.SharedPackages = ReplicatedStorage.Packages

Knit.Enum = require(Knit.SharedModules.Enums)

Knit.SharedConfig = require(Knit.SharedModules.SharedConfig)
Knit.ClientConfig = require(Knit.ClientModules.ClientConfig)

Knit.SharedUtil = require(Knit.SharedModules.SharedUtil)
Knit.ClientUtil = require(Knit.ClientModules.ClientUtil)

-- Get place type for subfolder selection
local PlaceIdToPlaceType: table = require(Knit.SharedModules.PlaceIdToPlaceType)
Knit.PlaceType = PlaceIdToPlaceType[game.PlaceId]

-- Variables for client loading
local ClientLoadedEvent: RemoteEvent = ReplicatedStorage:WaitForChild("ClientLoaded")
local GetClientLoadedFunction: RemoteFunction = ReplicatedStorage:WaitForChild("GetClientLoaded")

Knit._IsLoaded = false
Knit.IsLoaded = false

-- Reference to player gui
Knit.PlayerGui = Knit.Player.PlayerGui

-----------------------
-- UTILITY FUNCTIONS --
-----------------------

-- Searches for and adds controllers
local function RequireModules(folder: Folder): nil
	for _, module: ModuleScript? in ipairs(folder:GetDescendants()) do
		if module:IsA("ModuleScript") and (module.Name:match("Controller$") or module.Name:match("Component$")) then
			local success, result = pcall(require, module)
			if not success then
				warn(result)
			end
		end
	end
end

-- Sets game loaded to true
local function OnClientLoaded(): nil
	if Knit._IsLoaded then
		return
	end

	Knit._IsLoaded = true
end

----------------------
-- LOAD CONTROLLERS --
----------------------

RequireModules(Controllers.Shared)

for folderName, _ in pairs(Knit.PlaceType) do
	local folder = Controllers:FindFirstChild(folderName)
	if folder then
		RequireModules(folder)
	end
end

----------------------------------
-- WAIT FOR GAME CLIENT TO LOAD --
----------------------------------

ClientLoadedEvent.Event:Connect(OnClientLoaded)

local loadingController = GetClientLoadedFunction:Invoke()
if loadingController then
	OnClientLoaded()
else
	ClientLoadedEvent.Event:Connect(OnClientLoaded)
end

-- Wait until game is loaded
while not Knit._IsLoaded do
	task.wait()
end

----------------
-- START KNIT --
----------------

local startTime: number = os.clock()

Knit.Start():andThen(function()
	RequireModules(Components)
	Knit._ComponentsLoaded = true

	print(string.format("Client successfully started version %s (%d) [%d ms]",
		Knit.SharedConfig.Version,
		game.PlaceVersion,
		math.round((os.clock() - startTime) * 1000)
	))
end):catch(warn)