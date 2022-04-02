--[[

	NameComponent
	- Location/Components
	Nicholas Foreman

	Description of Component

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(Knit.SharedPackages.Component)

----------------------
-- CREATE COMPONENT --
----------------------

local MyNameComponent = Component.new({
	Tag = "NameComponent",
	RenderPriority = Enum.RenderPriority.Last.Value
})

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

--------------------------------------
-- CONNECT COMPONENT CORE FUNCTIONS --
--------------------------------------

function MyNameComponent:Construct(): nil

end

function MyNameComponent:Start(): nil

end

function MyNameComponent:Stop(): nil

end

function MyNameComponent:HeartbeatUpdate(deltaTime: number): nil

end

function MyNameComponent:SteppedUpdate(deltaTime: number): nil

end

function MyNameComponent:RenderSteppedUpdate(deltaTime: number): nil

end

----------------------
-- RETURN COMPONENT --
----------------------

return MyNameComponent