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
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- Uncomment if using Knit
-- local Knit = require(ReplicatedStorage.Packages.Knit)
local Configuration = require(script.Configuration)

local PlayerMessageHandler = require(script.Handlers.PlayerMessageHandler)
local SystemMessageHandler = require(script.Handlers.SystemMessageHandler)
local AssignChatDataHandler = require(script.Handlers.AssignChatDataHandler)

local Prefixes = Configuration.Prefixes
local NameColors = Configuration.NameColors
local ChatColors = Configuration.ChatColors

-----------------------
-- CREATE CONTROLLER --
-----------------------

-- Replace if using Knit
local MyTextChatServicePlusController = {} --[[Knit.CreateController {
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

local lastUpdate: number = time()

local collectionTagsTracked: {string} = {}

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
		handler = PlayerMessageHandler -- Player message
	else
		handler = SystemMessageHandler -- System message
	end

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

local function OnPlayerAdded(player: Player)
	task.spawn(AssignChatDataHandler.UpdateForPlayer, AssignChatDataHandler, player)

	player:GetPropertyChangedSignal("TeamColor"):Connect(function()
		AssignChatDataHandler:UpdateForPlayer(player)
	end)

	player.AttributeChanged:Connect(function(attribute)
		AssignChatDataHandler:UpdateForPlayer(player)
	end)
end

local function TrackCollectionTag(collectionTagName: string)
	if table.find(collectionTagsTracked, collectionTagName) then
		return
	end
	table.insert(collectionTagsTracked, collectionTagName)

	CollectionService:GetInstanceAddedSignal(collectionTagName):Connect(function()
		MyTextChatServicePlusController:UpdatePlayers()
	end)

	CollectionService:GetInstanceRemovedSignal(collectionTagName):Connect(function()
		MyTextChatServicePlusController:UpdatePlayers()
	end)
end

local function TrackCollectionTagsFor(assignments: {any})
	for _, assignment: {any} in ipairs(assignments) do
		if assignment.CollectionTagName then
			TrackCollectionTag(assignment.CollectionTagName)
		end
	end
end

local function TrackCollectionTags()
	TrackCollectionTagsFor(Prefixes.Assignments.CollectionTags)
	TrackCollectionTagsFor(NameColors.Assignments.CollectionTags)
	TrackCollectionTagsFor(ChatColors.Assignments.CollectionTags)
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyTextChatServicePlusController:UpdatePlayers(deltaTime: number)
	for _, player: Player in ipairs(Players:GetPlayers()) do
		task.spawn(AssignChatDataHandler.UpdateForPlayer, AssignChatDataHandler, player)
	end
end

-------------------------------------
-- INITIALIZE AND START CONTROLLER --
-------------------------------------

function MyTextChatServicePlusController:KnitStart()
	TextChatService.OnIncomingMessage = OnIncomingMessage

	Players.PlayerAdded:Connect(OnPlayerAdded)
	for _, player: Player in ipairs(Players:GetPlayers()) do
		OnPlayerAdded(player)
	end

	RunService.Stepped:Connect(function(totalTime: number, deltaTime: number)
		if (time() - lastUpdate) < Configuration.CacheUpdateTime then
			return
		end
		lastUpdate = time()

		self:UpdatePlayers()
	end)

	TrackCollectionTags()
end

function MyTextChatServicePlusController:KnitInit()

end

-------------------------------
-- RETURN CONTROLLER TO KNIT --
-------------------------------

MyTextChatServicePlusController:KnitInit() -- Remove if using Knit
MyTextChatServicePlusController:KnitStart() -- Remove if using Knit

-- Uncomment if using Knit
-- return MyTextChatServicePlusController