--[[

	SystemMessageHandler
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	Adds prefixes, name colors, and chat tags to player messages

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- local Knit = require(ReplicatedStorage.Packages.Knit)
local Configuration = require(script.Parent.Parent.Configuration)

---------------------
-- MODULE CREATION --
---------------------

local SystemMessageHandler = {}

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

function SystemMessageHandler:Sending(message, properties)
	return properties
end

function SystemMessageHandler:Success(message, properties)
	properties.PrefixText = string.format(
		Configuration.SystemMessage.PrefixTextFormat,
		Configuration.SystemMessage.Prefix.Color:ToHex(),
		Configuration.SystemMessage.Prefix.Text
	)

	properties.Text = string.format(
		Configuration.SystemMessage.TextFormat,
		Configuration.SystemMessage.ChatColor.Color:ToHex(),
		message.Text
	)

	return properties
end

--------------------
-- RETURN HANDLER --
--------------------

return SystemMessageHandler