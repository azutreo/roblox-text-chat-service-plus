--[[

	BeforeRunHook
	- Server/Shared/Main/CmdrService/Hooks
	Nicholas Foreman

	Disables commands for anyone not a developer

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)
local CmdrUtil: table = require(Knit.SharedModules.CmdrUtil)

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function CheckCanRunCommands(context: table): any
	local canRunCommands: boolean = CmdrUtil:CheckCanRunCommands(context.Executor.UserId)

	if not canRunCommands then
		return "You don't have permission to run this command"
	end
end

-----------------------------------
-- RETURN CMDR REGISTRY FUNCTION --
-----------------------------------

return function(registry): nil
	registry:RegisterHook("BeforeRun", CheckCanRunCommands)
end