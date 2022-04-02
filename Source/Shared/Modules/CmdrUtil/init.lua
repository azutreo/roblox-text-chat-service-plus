--[[

	CmdrUtil
	- Shared/Modules
	Nicholas Foreman

	Util used for Cmdr commands

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)
local CheckCanRunCommands: table = require(Knit.SharedModules.CmdrUtil.CheckCanRunCommands)

-------------------
-- CREATE MODULE --
-------------------

local CmdrUtil: table = {}

---------------
-- CONSTANTS --
---------------

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- UTILITY FUNCTIONS --
-----------------------

----------------------
-- MODULE FUNCTIONS --
----------------------

function CmdrUtil:CheckCanRunCommands(userId: number): boolean
	return CheckCanRunCommands(userId)
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-------------------
-- RETURN MODULE --
-------------------

return CmdrUtil