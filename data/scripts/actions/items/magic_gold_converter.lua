local data = {
	converterIds = {
		[28525] = 28526,
		[28526] = 28525,
	},

	coins = {
		[ITEM_GOLD_COIN] = ITEM_PLATINUM_COIN,
		[ITEM_PLATINUM_COIN] = ITEM_CRYSTAL_COIN,
	},
}

local function findAndConvertCoins(player, container, converter)
	for i = 0, container:getSize() - 1 do
		local item = container:getItem(i)
		if item:isContainer() then
			findAndConvertCoins(player, Container(item.uid), converter)
		else
			local itemId = item:getId()
			local itemCount = item:getCount()
			
			-- Check if autoBank is enabled
			if configManager.getBoolean(configKeys.AUTOBANK) then
				local coinValue = 0
				if itemId == ITEM_GOLD_COIN then
					coinValue = itemCount
				elseif itemId == ITEM_PLATINUM_COIN then
					coinValue = itemCount * 100
				elseif itemId == ITEM_CRYSTAL_COIN then
					coinValue = itemCount * 10000
				end
				
				if coinValue > 0 then
					item:remove()
					player:setBankBalance(player:getBankBalance() + coinValue)
					-- Only consume charge if converter has charges attribute
					if converter:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
						converter:setAttribute(ITEM_ATTRIBUTE_CHARGES, converter:getAttribute(ITEM_ATTRIBUTE_CHARGES) - 1)
					end
					return true
				end
			else
				-- Original conversion logic (100 gold -> 1 platinum, 100 platinum -> 1 crystal)
				for fromId, toId in pairs(data.coins) do
					if itemId == fromId and itemCount == 100 then
						item:remove()
						if not (container:addItem(toId, 1)) then
							player:addItem(toId, 1)
						end

						-- Only consume charge if converter has charges attribute
						if converter:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
							converter:setAttribute(ITEM_ATTRIBUTE_CHARGES, converter:getAttribute(ITEM_ATTRIBUTE_CHARGES) - 1)
						end
						return true
					end
				end
			end
		end
	end
	return false
end

local function startConverter(playerId, converterItemId)
	local player = Player(playerId)
	if player then
		local converter = player:getItemById(converterItemId, true)
		if converter then
			local hasCharges = true
			if converter:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
				local charges = converter:getAttribute(ITEM_ATTRIBUTE_CHARGES)
				if charges < 1 then
					converter:remove(1)
					hasCharges = false
				end
			end
			
			if hasCharges then
				-- Check for any coins when autoBank is enabled, or 100+ stacks for conversion
				local hasCoins = false
				if configManager.getBoolean(configKeys.AUTOBANK) then
					hasCoins = player:getItemCount(ITEM_GOLD_COIN) > 0 or player:getItemCount(ITEM_PLATINUM_COIN) > 0 or player:getItemCount(ITEM_CRYSTAL_COIN) > 0
				else
					hasCoins = player:getItemCount(ITEM_GOLD_COIN) >= 100 or player:getItemCount(ITEM_PLATINUM_COIN) >= 100
				end
				
				if hasCoins then
					findAndConvertCoins(player, player:getStoreInbox(), converter)
				end
				addEvent(startConverter, 300, playerId, converterItemId)
			end
		end
	end
end

local magicGoldConverter = Action()

function magicGoldConverter.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(data.converterIds[item.itemid])
	item:decay()
	startConverter(player:getId(), 28526)
	return true
end

magicGoldConverter:id(28525, 28526)
magicGoldConverter:register()
