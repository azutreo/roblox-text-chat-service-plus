--[[

	Configuration
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	Editable configuration values to be used for handlers

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- local Knit = require(ReplicatedStorage.Packages.Knit)

-------------------
-- CREATE MODULE --
-------------------

local Configuration = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

Configuration.Version = "1.1.0" -- do not edit <3

Configuration.SystemMessageFormat = "%s"
Configuration.SystemMessagePrefix = "<font color='#af4448'><b>[System]</b></font>"

Configuration.NameFormat = "[%s]"

Configuration.PrefixFormat = "<font color='#%s'><b>%s</b></font> %s"
Configuration.NameColorFormat = "<font color='#%s'>%s</font>"
Configuration.ChatColorFormat = "<font color='#%s'>%s</font>"

Configuration.Prefixes = require(script.Prefixes)
Configuration.NameColors = require(script.NameColors)
Configuration.ChatColors = require(script.ChatColors)

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-------------------
-- RETURN MODULE --
-------------------

return Configuration