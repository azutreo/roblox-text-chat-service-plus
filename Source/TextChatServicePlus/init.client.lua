--[[

	TextChatServicePlus
	- Client
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)
	Version: dev1.1.0

	Handles prefixes, name colors, and chat colors for the new TextChatService
	Plans for future updates to include more features

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- Uncomment if using Knit
-- local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerMessageHandler = require(script.Handlers.PlayerMessageHandler)

-----------------------
-- CREATE CONTROLLER --
-----------------------

-- Replace if using Knit
local MyNewChatController = {} --[[Knit.CreateController {
	Name = "NewChatController"
}]]

------------------------
-- PRIVATE PROPERTIES --
------------------------

type Function = (any) -> (any)

type Handler = {
	Sending: Function,
	Success: Function
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function OnIncomingMessage(message: TextChatMessage): TextChatMessageProperties
	local properties = Instance.new("TextChatMessageProperties")

	local handler: Handler?

	if message.TextSource then
		-- Player message
		handler = PlayerMessageHandler
	else
		-- System message
		handler = nil -- I will handle this in the future
	end

	-- Player messages

	local handlerFunction: Function

	if typeof(handler) ~= "table" then
		return properties
	elseif message.Status == Enum.TextChatMessageStatus.Success then
		handlerFunction = handler.Success
	else
		handlerFunction = handler.Sending
	end

	local success, result = pcall(handlerFunction, handler, message, properties)

	if success then
		return result
	else
		warn(result)
		return properties
	end
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

-------------------------------------
-- INITIALIZE AND START CONTROLLER --
-------------------------------------

function MyNewChatController:KnitStart()
	TextChatService.OnIncomingMessage = OnIncomingMessage
end

function MyNewChatController:KnitInit()

end

-------------------------------
-- RETURN CONTROLLER TO KNIT --
-------------------------------

MyNewChatController:KnitInit() -- Remove if using Knit
MyNewChatController:KnitStart() -- Remove if using Knit

-- Uncomment if using Knit
-- return MyNewChatController