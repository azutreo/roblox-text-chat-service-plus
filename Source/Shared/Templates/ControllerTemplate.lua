--[[

	NameController
	- Client/Controllers/Location
	Nicholas Foreman

	Description of Controller

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)

----------------------------
-- CREATE KNIT CONTROLLER --
----------------------------

local MyNameController: table = Knit.CreateController {
	Name = "NameController",
}

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

-------------------------------------
-- INITIALIZE AND START CONTROLLER --
-------------------------------------

function MyNameController:KnitStart(): nil

end

function MyNameController:KnitInit(): nil

end

-------------------------------
-- RETURN CONTROLLER TO KNIT --
-------------------------------

return MyNameController