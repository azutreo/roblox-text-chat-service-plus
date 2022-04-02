--[[

	KnitClass
	- Shared/Modules
	Nicholas Foreman

	A basic class to be inherited by other classes

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

------------------
-- CREATE CLASS --
------------------

local KnitClass = {}
KnitClass.__index = KnitClass

------------------------
-- PRIVATE PROPERTIES --
------------------------

local Objects = {}
local IndexCount: number = 0

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function SetupClass(self, original?)
	setmetatable(self, original or KnitClass)
	table.insert(Objects, self)

	IndexCount += 1
	self._Index = IndexCount

	return self
end

---------------------------------
-- NEW CLASS INSTANCE FUNCTION --
---------------------------------

function KnitClass.new(original?)
	return SetupClass(original or {}, nil)
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function KnitClass:Destroy(): boolean
	local function GetModule()
		for index: number, module in ipairs(Objects) do
			if module._Index == self._Index then
				return index
			end
		end
	end

	local moduleIndex: number? = GetModule()
	if not moduleIndex then
		return false
	end

	table.remove(Objects, moduleIndex)
	self = nil

	return true
end

function KnitClass:Clone(original?)
	local clone = TableUtil.Copy(self, true)

	return SetupClass(clone, original)
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

------------------
-- RETURN CLASS --
------------------

return setmetatable(KnitClass, KnitClass)