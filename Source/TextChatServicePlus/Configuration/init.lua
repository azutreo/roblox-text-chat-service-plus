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

-- Global configuration

Configuration.Version = "1.1.0"

Configuration.Prefixes = require(script.Prefixes)
Configuration.NameColors = require(script.NameColors)
Configuration.ChatColors = require(script.ChatColors)

-- Player messages
Configuration.PlayerMessage = {}

Configuration.PlayerMessage.NameFormat = "[%s]"

Configuration.PlayerMessage.PrefixFormat = "<font color='#%s'><b>%s</b></font> %s"
Configuration.PlayerMessage.NameColorFormat = "<font color='#%s'>%s</font>"
Configuration.PlayerMessage.TextFormat = "<font color='#%s'>%s</font>"

-- System messages
Configuration.SystemMessage = {}

Configuration.SystemMessage.PrefixTextFormat = "<font color='#%s'><b>%s</b></font>"
Configuration.SystemMessage.TextFormat = "<font color='#%s'>%s</font>"

Configuration.SystemMessage.Prefix = {
	Name = "System",
	Text = "[System]",
	Color = Color3.fromHex("#af4448")
}

Configuration.SystemMessage.ChatColor = {
	Name = "System",
	Color = Color3.fromHex("#e57373")
}

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