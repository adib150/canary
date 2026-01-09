-- Insomnia Autobank: Automatically deposits coins to the player's bank when activated
local data = {
	converterIds = {
		[28525] = 28526,
		[28526] = 28525,
	},
}

-- Recursively scan a container (and nested containers) to remove all coins
-- and return the total value in gold.
local function collectAndDepositCoins(player, container)
	local totalGoldValue = 0

	for i = 0, container:getSize() - 1 do
		local item = container:getItem(i)
		if item then
			if item:isContainer() then
				totalGoldValue = totalGoldValue + collectAndDepositCoins(player, Container(item.uid))
			else
				local itemId = item:getId()
				local itemCount = item:getCount()
				local coinValue = 0

				if itemId == ITEM_GOLD_COIN then
					coinValue = itemCount
				elseif itemId == ITEM_PLATINUM_COIN then
					coinValue = itemCount * 100
				elseif itemId == ITEM_CRYSTAL_COIN then
					coinValue = itemCount * 10000
				end

				if coinValue > 0 then
					totalGoldValue = totalGoldValue + coinValue
					item:remove()
				end
			end
		end
	end
	return totalGoldValue
end

local function collectCoinsFromPlayer(player)
	local totalGold = 0
	local storeInbox = player:getStoreInbox()
	if storeInbox then
		totalGold = totalGold + collectAndDepositCoins(player, storeInbox)
	end

	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	if backpack and backpack:isContainer() then
		totalGold = totalGold + collectAndDepositCoins(player, Container(backpack.uid))
	end

	return totalGold
end

local insomniaAutobank = Action()

function insomniaAutobank.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Toggle converter state
	local newId = data.converterIds[item.itemid]
	if not newId then
		return false
	end

	item:transform(newId)
	item:decay()

	-- When activating the converter, enable the built-in autoBank flow and deposit any coins in the player's containers once.
	if newId == 28526 then
		configManager.setBoolean(configKeys.AUTOBANK, true)

		local totalGold = collectCoinsFromPlayer(player)
		if totalGold > 0 then
			player:setBankBalance(player:getBankBalance() + totalGold)
			player:sendTextMessage(MESSAGE_LOOT, string.format("Deposited %d gold worth of coins into your bank.", totalGold))

			if item:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
				local charges = item:getAttribute(ITEM_ATTRIBUTE_CHARGES)
				if charges <= 1 then
					item:remove(1)
				else
					item:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges - 1)
				end
			end
		else
			player:sendTextMessage(MESSAGE_LOOT, "AutoBank enabled. Newly looted coins will be sent directly to your bank account.")
		end
	end
	return true
end

insomniaAutobank:id(28525, 28526)
insomniaAutobank:register()
