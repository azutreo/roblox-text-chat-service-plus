--[[

	PlayerMessageHandler
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	Adds prefixes, name colors, and chat tags to player messages

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- local Knit = require(ReplicatedStorage.Packages.Knit)
local Util = require(script.Parent.Parent.Util)
local Configuration = require(script.Parent.Parent.Configuration)

---------------------
-- MODULE CREATION --
---------------------

local PlayerMessageHandler = {}

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

function PlayerMessageHandler:Sending(message, properties)
	properties.PrefixText = string.format(Configuration.NameFormat, message.PrefixText)
	properties.Text = string.rep("_", #message.Text)

	return properties
end

function PlayerMessageHandler:Success(message, properties)
	-- properties.Text = message.Text

	return properties
end

--------------------
-- RETURN HANDLER --
--------------------

return PlayerMessageHandler