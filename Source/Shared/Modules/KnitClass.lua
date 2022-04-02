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

local TableUtil: table = require(ReplicatedStorage.Packages.TableUtil)

------------------
-- CREATE CLASS --
------------------

local KnitClass: table = {}
KnitClass.__index = KnitClass

------------------------
-- PRIVATE PROPERTIES --
------------------------

local Objects: table = {}
local IndexCount: number = 0

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function SetupClass(self: table, original: table?): table
	setmetatable(self, original or KnitClass)
	table.insert(Objects, self)

	IndexCount += 1
	self._Index = IndexCount

	return self
end

---------------------------------
-- NEW CLASS INSTANCE FUNCTION --
---------------------------------

function KnitClass.new(original: table?): table
	return SetupClass(original or {}, nil)
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function KnitClass:Destroy(): boolean
	local function GetModule()
		for index: number, module: table in ipairs(Objects) do
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

function KnitClass:Clone(original: table?): table
	local clone: table = TableUtil.Copy(self, true)

	return SetupClass(clone, original)
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

------------------
-- RETURN CLASS --
------------------

return setmetatable(KnitClass, KnitClass)