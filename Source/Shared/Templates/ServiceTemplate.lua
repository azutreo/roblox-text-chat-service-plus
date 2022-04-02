--[[

	NameService
	- Server/Services/Location
	Nicholas Foreman

	Description of Service

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)

-------------------------
-- CREATE KNIT SERVICE --
-------------------------

local MyNameService: table = Knit.CreateService {
	Name = "NameService",
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

function MyNameService:KnitStart(): nil

end

function MyNameService:KnitInit(): nil

end

----------------------------
-- RETURN SERVICE TO KNIT --
----------------------------

return MyNameService