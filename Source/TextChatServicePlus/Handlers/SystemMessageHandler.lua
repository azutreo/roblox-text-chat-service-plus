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
local Util = require(script.Parent.Parent.Util)
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
	properties.PrefixText = Configuration.SystemMessagePrefix
	properties.Text = string.format(Configuration.SystemMessageFormat, string.rep("_", #message.Text))

	return properties
end

function SystemMessageHandler:Success(message, properties)
	properties.PrefixText = Configuration.SystemMessagePrefix
	properties.Text = string.format(Configuration.SystemMessageFormat, message.Text)

	return properties
end

--------------------
-- RETURN HANDLER --
--------------------

return SystemMessageHandler