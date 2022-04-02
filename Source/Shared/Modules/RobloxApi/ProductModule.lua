--[[

	ProductModule
	- Shared/Modules/RobloxApi
	Nicholas Foreman

	Description of Module

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit = require(ReplicatedStorage.Packages.Knit)

-------------------
-- CREATE MODULE --
-------------------

local MyProductModule = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

local TIME_HOUR_ONE = 60 * 60
local TIME_DAY_ONE = TIME_HOUR_ONE * 24
local TIME_WEEK_ONE = TIME_DAY_ONE * 7
local TIME_MONTH_ONE = TIME_DAY_ONE * 30
local TIME_MONTH_THREE = TIME_MONTH_ONE * 3
local TIME_MONTH_SIX = TIME_MONTH_ONE * 6
local TIME_YEAR_ONE = TIME_MONTH_ONE * 12

export type Product = {
	Name: string,
	Identifier: string,
	ProductId: number,
	ProductType,
	ExtraData: {any}
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

MyProductModule.Products = {

}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyProductModule:GetProductByIdentifier(identifier: string): Product
	for _, product: Product in ipairs(self.Products) do
		if product.Identifier == identifier then
			return product
		end
	end

	return {
		Name = "Not Found",
		Identifier = "Not_Found",
		ProductId = 0,
		ProductType = Knit.Enum.ProductType.NotFound,
		ExtraData = {}
	}
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-------------------
-- RETURN MODULE --
-------------------

return MyProductModule