--[[

	KnitServer
	- Server
	Nicholas Foreman

	Loads, initializes, and starts Knit

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage: ServerStorage = game:GetService("ServerStorage")

------------------------------
-- LOAD AND INITIALIZE KNIT --
------------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)
local Services: Folder = script.Parent.Services
local Components: Folder = script.Parent.Components

-- References to modules and packages
Knit.SharedModules = ReplicatedStorage.Modules
Knit.ServerModules = script.Parent.Modules

Knit.SharedPackages = ReplicatedStorage.Packages
Knit.ServerPackages = ServerStorage.Packages

Knit.Enum = require(Knit.SharedModules.Enums)

Knit.SharedConfig = require(Knit.SharedModules.SharedConfig)
Knit.ServerConfig = require(Knit.ServerModules.ServerConfig)

Knit.SharedUtil = require(Knit.SharedModules.SharedUtil)
Knit.ServerUtil = require(Knit.ServerModules.ServerUtil)

-- Get place type for subfolder selection
local PlaceIdToPlaceType: table = require(Knit.SharedModules.PlaceIdToPlaceType)
Knit.PlaceType = PlaceIdToPlaceType[game.PlaceId]

-----------------------
-- UTILITY FUNCTIONS --
-----------------------

-- Searches for and adds services
local function RequireModules(folder: Folder): nil
	for _, module: ModuleScript? in ipairs(folder:GetDescendants()) do
		if module:IsA("ModuleScript") and (module.Name:match("Service$") or module.Name:match("Component$")) then
			local success: boolean, result: string? = pcall(require, module)

			if not success then
				warn(result)
			end
		end
	end
end

-- Logging inbound client events and requests
local function Logger(player: Player, ...): nil
	print(player, ...)
	return true
end

-------------------
-- LOAD SERVICES --
-------------------

RequireModules(Services.Shared)

for folderName, _ in pairs(Knit.PlaceType) do
	local folder = Services:FindFirstChild(folderName)
	if folder then
		RequireModules(folder)
	end
end

----------------
-- START KNIT --
----------------

local startTime: number = os.clock()

Knit.Start(--[[{
	Middleware = { Inbound = {Logger} }
}]]):andThen(function()
	RequireModules(Components)
	Knit._ComponentsLoaded = true

	print(string.format("Server successfully started version %s (%d) [%d ms]",
		Knit.SharedConfig.Version,
		game.PlaceVersion,
		math.round((os.clock() - startTime) * 1000)
	))
end):catch(warn)