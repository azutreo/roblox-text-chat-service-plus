--[[

	NameClass
	- Location/Modules
	Nicholas Foreman

	Description of Class

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)
local KnitClass: table = require(ReplicatedStorage.Modules.KnitClass)

------------------
-- CREATE CLASS --
------------------

local MyNameClass: table = {}
MyNameClass.__index = MyNameClass
setmetatable(MyNameClass, KnitClass)

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

---------------------------------
-- NEW CLASS INSTANCE FUNCTION --
---------------------------------

function MyNameClass.new(): table
	local self: table = KnitClass.new({}, MyNameClass)

	return self
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

---------------------------
-- MODULE INITIALIZATION --
---------------------------

Knit.OnStart:andThen(function()
	-- Do stuff
end):catch(warn)

------------------
-- RETURN CLASS --
------------------

return setmetatable(MyNameClass, MyNameClass)