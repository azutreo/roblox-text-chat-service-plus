--[[

	LoadingController
	- ReplicatedFrst
	Nicholas Foreman

	Shows loading screen

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players: Players = game:GetService("Players")
local ReplicatedFirst: ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui: StarterGui = game:GetService("StarterGui")
local TeleportService: TeleportService = game:GetService("TeleportService")

-----------------------------
-- TELEPORT/LOADING SCREEN --
-----------------------------

-- Get the player gui to insert the loading gui into
local LocalPlayer: Player? = Players.LocalPlayer
local PlayerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")

local loadingGui: ScreenGui? = nil

local TeleportGui: Instance = TeleportService:GetArrivingTeleportGui()
if TeleportGui then
	loadingGui = TeleportGui
	loadingGui.Parent = PlayerGui
	loadingGui.Enabled = true
else
	local LoadingGui: ScreenGui = script.Parent:WaitForChild("LoadingGui")

	loadingGui = LoadingGui:Clone()
	loadingGui.Parent = PlayerGui
	loadingGui.Enabled = true
end

task.wait()
ReplicatedFirst:RemoveDefaultLoadingScreen()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages.Knit)
local Signal = require(Packages.Signal)

----------------------------
-- CREATE KNIT CONTROLLER --
----------------------------

local LoadingController = Knit.CreateController {
	Name = "LoadingController",
	Loaded = Signal.new()
}

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

-------------------------------------
-- INITIALIZE AND START CONTROLLER --
-------------------------------------

function LoadingController:KnitStart()
	task.wait(1)

	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	if loadingGui and loadingGui:IsDescendantOf(game) then
		loadingGui:Destroy()
	end

	--[[while not self._IsReady do
		task.wait()
	end]]

	Knit.IsLoaded = true
	self.Loaded:Fire()
end

function LoadingController:KnitInit()

end

---------------------------------------------
-- FIRE AND CONNECT LOADING EVENT/FUNCTION --
---------------------------------------------

local ClientLoadedEvent = ReplicatedStorage:WaitForChild("ClientLoaded")
local GetClientLoadedFunction = ReplicatedStorage:WaitForChild("GetClientLoaded")

GetClientLoadedFunction.OnInvoke = function()
	return LoadingController
end

ClientLoadedEvent:Fire(LoadingController)