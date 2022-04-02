--[[

	ChatColorModule
	- Shared/Modules
	Azutreo : Nicholas Foreman

	Description of Module

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- Commented since this is going to the public
-- local Knit = require(ReplicatedStorage.Packages.Knit)

-------------------
-- CREATE MODULE --
-------------------

local MyChatColorModule = {}

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
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyChatColorModule:GetChatColorForPlayer(player: Player): Color3
	return Color3.fromRGB(255, 200, 50)
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-- Commented for public module
--[[Knit.OnStart:andThen(function()
	-- Do stuff
end):catch(warn)]]

-------------------
-- RETURN MODULE --
-------------------

return MyChatColorModule