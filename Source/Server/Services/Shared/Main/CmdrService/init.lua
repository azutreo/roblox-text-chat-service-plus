--[[

	CmdrService
	- Server/Services/Shared/Main
	Nicholas Foreman

	Initializes Cmdr by evaera
	https://eryn.io/Cmdr/

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage: ServerStorage = game:GetService("ServerStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)
local Cmdr: table = require(Knit.ServerPackages.Cmdr)

-------------------------
-- CREATE KNIT SERVICE --
-------------------------

local MyCmdrService: table = Knit.CreateService {
	Name = "CmdrService",
	Client = {}
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

------------------------------
-- CLIENT-EXPOSED FUNCTIONS --
------------------------------

----------------------------------
-- INITIALIZE AND START SERVICE --
----------------------------------

function MyCmdrService:KnitStart(): nil
	Cmdr:RegisterHooksIn(script.Hooks)
	Cmdr:RegisterDefaultCommands()
end

function MyCmdrService:KnitInit(): nil

end

----------------------------
-- RETURN SERVICE TO KNIT --
----------------------------

return MyCmdrService