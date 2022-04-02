--[[

	NewChatController
	- Client/Shared
	Azutreo : Nicholas Foreman

	Handles prefixes and name colors for the new TextChatService

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
local PrefixModule = require(script.PrefixModule)
local NameColorModule = require(script.NameColorModule)
local ChatColorModule = require(script.ChatColorModule)

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

local FORMAT_PREFIX = "<font color='#%s'><b>%s</b></font> %s"
local FORMAT_NAME = "[%s]"
local FORMAT_NAME_COLOR = "<font color='#%s'>%s</font>"
local FORMAT_CHAT_COLOR = "<font color='#%s'>%s</font>"

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

	local player: Player = Players:GetPlayerByUserId(message.TextSource.UserId)

	local prefix = PrefixModule:GetPrefixForPlayer(player)
	local nameColor: Color3? = NameColorModule:GetNameColorForPlayer(player)
	local chatColor: Color3? = ChatColorModule:GetChatColorForPlayer(player)

	properties.PrefixText = string.format(FORMAT_NAME, message.PrefixText)

	if typeof(nameColor) == "Color3" then
		properties.PrefixText = string.format(FORMAT_NAME_COLOR, nameColor:ToHex(), properties.PrefixText)
	end

	if typeof(prefix) == "table" and prefix.NotDefault then
		properties.PrefixText = string.format(FORMAT_PREFIX, prefix.TagColor:ToHex(), prefix.TagText, properties.PrefixText)
	end

	--[[if typeof(chatColor) == "Color3" then
		properties.Text = string.format(FORMAT_CHAT_COLOR, chatColor:ToHex(), message.Text)
	end]]

	return properties
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