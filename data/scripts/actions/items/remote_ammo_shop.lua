-- Remote Magic Shop
-- This script allows players to open Alexander's shop remotely
-- without needing to find and talk to the NPC

local shopItems = {
	{ itemName = "diamond arrow", clientId = 35901, buy = 130 },
	{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
	{ itemName = "crystalline arrow", clientId = 15793, buy = 20 },
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "drill bolt", clientId = 16142, buy = 12 },
	{ itemName = "earth arrow", clientId = 774, buy = 5 },
	{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
	{ itemName = "flaming arrow", clientId = 763, buy = 5 },
	{ itemName = "flash arrow", clientId = 761, buy = 5 },
	{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
	{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
	{ itemName = "power bolt", clientId = 3450, buy = 7 },
	{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
	{ itemName = "royal spear", clientId = 7378, buy = 15 },
	{ itemName = "shiver arrow", clientId = 762, buy = 5 },
	{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
	{ itemName = "spear", clientId = 3277, buy = 9, sell = 3 },
	{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
	{ itemName = "throwing star", clientId = 3287, buy = 42 },
	{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
}

-- Configuration: Position where the invisible shop NPC is located
-- You need to place Alexander NPC at this position on your map
local SHOP_NPC_NAME = "Alexander"
local SHOP_NPC_POSITION = Position(33256, 31839, 3) -- Change this to where your Alexander is

-- Timer configuration
local SHOP_COOLDOWN = 240 * 1000 -- 240 seconds (4 minutes) in milliseconds

-- Storage for tracking cooldowns
local STORAGE_AMMO_SHOP_COOLDOWN = 45822

local remoteShop = Action()

function remoteShop.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Check cooldown
	local currentTime = os.time()
	local lastUseTime = player:getStorageValue(STORAGE_AMMO_SHOP_COOLDOWN)
	
	if lastUseTime > 0 then
		local timePassed = (currentTime - lastUseTime) * 1000
		if timePassed < SHOP_COOLDOWN then
			local remainingTime = math.ceil((SHOP_COOLDOWN - timePassed) / 1000)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You must wait %d seconds before opening the shop again.", remainingTime))
			return true
		end
	end
	
	-- Find the shop NPC by name
	local spectators = Game.getSpectators(SHOP_NPC_POSITION, false, false, 0, 0, 0, 0)
	local shopNpc = nil
	
	for _, creature in ipairs(spectators) do
		if creature:isNpc() and creature:getName() == SHOP_NPC_NAME then
			shopNpc = creature
			break
		end
	end
	
	if not shopNpc then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Shop is currently unavailable. Please contact an administrator.")
		return true
	end
	
	-- Open shop window
	shopNpc:openShopWindowTable(player, shopItems)
	
	-- Set cooldown
	player:setStorageValue(STORAGE_AMMO_SHOP_COOLDOWN, currentTime)
	
	return true
end

remoteShop:id(28897)
remoteShop:register()
