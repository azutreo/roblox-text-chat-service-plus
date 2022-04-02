--[[

	Enums
	- Shared/Modules
	Nicholas Foreman

	A list of enums to be used across Knit

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local EnumList = require(ReplicatedStorage.Packages.EnumList)

-------------------
-- CREATE MODULE --
-------------------

local Enums = {}

-----------
-- ENUMS --
-----------

Enums.ProductType = EnumList.new("ProductType", {
	"NotFound",
	"Currency"
})

-------------------
-- RETURN MODULE --
-------------------

return Enums