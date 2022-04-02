--[[

	ServerConfig
	- Server/Modules
	Nicholas Foreman

	Configuration values to be used on the server

--]]

-------------------
-- CREATE MODULE --
-------------------

local ServerConfig: table = {}

----------------
-- PROPERTIES --
----------------

ServerConfig.DataCombineKey = "PlayerData-dev1"

ServerConfig.DataSetFromClientMessage = "Get pranked. Imagine trying to set data from the client... That's crazy."

-------------------
-- RETURN MODULE --
-------------------

return ServerConfig