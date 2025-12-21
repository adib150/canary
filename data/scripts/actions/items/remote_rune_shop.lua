-- Remote Magic Shop
-- This script allows players to open Alexander's shop remotely
-- without needing to find and talk to the NPC

local shopItems = {
	{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
	{ itemName = "blank rune", clientId = 3147, buy = 10 },
	{ itemName = "desintegrate rune", clientId = 3197, buy = 26 },
	{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
	{ itemName = "fireball rune", clientId = 3189, buy = 30 },
	{ itemName = "holy missile rune", clientId = 3182, buy = 16 },
	{ itemName = "icicle rune", clientId = 3158, buy = 30 },
	{ itemName = "magic wall rune", clientId = 3180, buy = 116 },
	{ itemName = "paralyze rune", clientId = 3165, buy = 700 },
	{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
	{ itemName = "soulfire rune", clientId = 3195, buy = 46 },
	{ itemName = "stone shower rune", clientId = 3175, buy = 41 },
	{ itemName = "thunderstorm rune", clientId = 3202, buy = 52 },
	{ itemName = "wild growth rune", clientId = 3156, buy = 160 },
	{ itemName = "avalanche rune", clientId = 3161, buy = 160 },
	{ itemName = "great fireball rune", clientId = 3191, buy = 160 },
}

-- Configuration: Position where the invisible shop NPC is located
-- You need to place Alexander NPC at this position on your map
local SHOP_NPC_NAME = "Alexander"
local SHOP_NPC_POSITION = Position(33256, 31839, 3) -- Change this to where your Alexander is

-- Timer configuration
local SHOP_COOLDOWN = 240 * 1000 -- 240 seconds (4 minutes) in milliseconds

-- Storage for tracking cooldowns
local STORAGE_RUNE_SHOP_COOLDOWN = 45820

local remoteShop = Action()

function remoteShop.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Check cooldown
	local currentTime = os.time()
	local lastUseTime = player:getStorageValue(STORAGE_RUNE_SHOP_COOLDOWN)
	
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
	player:setStorageValue(STORAGE_RUNE_SHOP_COOLDOWN, currentTime)
	
	return true
end

remoteShop:id(31267)
remoteShop:register()
