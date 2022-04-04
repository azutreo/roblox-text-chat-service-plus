--[[

	NewChatController
	- Client/Shared
	Azutreo : Nicholas Foreman

	Handles prefixes, name colors, and chat colors for the new TextChatService

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- Commented since this is going to the public
-- local Knit = require(ReplicatedStorage.Packages.Knit)
local UtilModule = require(script.Util)
local PlayerMessageHandler = require(script.Handlers.PlayerMessageHandler)

-----------------------
-- CREATE CONTROLLER --
-----------------------

-- Also commented since this is going to the public
local MyNewChatController = {} --[[Knit.CreateController {
	Name = "NewChatController"
}]]

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function OnIncomingMessage(message: TextChatMessage): TextChatMessageProperties
	local properties = Instance.new("TextChatMessageProperties")

	if not message.TextSource then
		return properties
	end

	if message.Status ~= Enum.TextChatMessageStatus.Success then
		return properties
	end

	local player: Player = Players:GetPlayerByUserId(message.TextSource.UserId)
	if not UtilModule:CheckIsPlayerValid(player) then
		return properties
	end

	return PlayerMessageHandler(player, message, properties)
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

-------------------------------------
-- INITIALIZE AND START CONTROLLER --
-------------------------------------

function MyNewChatController:KnitStart(): nil
	TextChatService.OnIncomingMessage = OnIncomingMessage

	return nil
end

function MyNewChatController:KnitInit(): nil
	return nil
end

-------------------------------
-- RETURN CONTROLLER TO KNIT --
-------------------------------

MyNewChatController:KnitInit()
MyNewChatController:KnitStart()

-- Commented for public module
-- return MyNewChatController