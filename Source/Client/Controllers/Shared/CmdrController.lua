--[[

	CmdrController
	- Client/Shared/Main
	Nicholas Foreman

	Initializes Cmdr by evaera
	https://eryn.io/Cmdr/

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit = require(ReplicatedStorage.Packages.Knit)
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))
local CmdrUtil = require(Knit.SharedModules.CmdrUtil)

----------------------------
-- CREATE KNIT CONTROLLER --
----------------------------

local MyCmdrController = Knit.CreateController {
	Name = "CmdrController"
}

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PUBLIC PROPERTIES --
------------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

-------------------------------------
-- INITIALIZE AND START CONTROLLER --
-------------------------------------

function MyCmdrController:KnitStart(): nil
	if CmdrUtil:CheckCanRunCommands(Knit.Player.UserId) then
		Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })
	else
		Cmdr:SetEnabled(false)
	end
end

function MyCmdrController:KnitInit(): nil

end

-------------------------------
-- RETURN CONTROLLER TO KNIT --
-------------------------------

return MyCmdrController