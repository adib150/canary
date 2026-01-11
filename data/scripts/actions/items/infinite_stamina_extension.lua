local infiniteStaminaExtension = Action()

function infiniteStaminaExtension.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Mirror 36725 behavior (concoction cooldown), but do not consume.
	local cooldown = configManager.getNumber(configKeys.TIBIADROME_CONCOCTION_COOLDOWN)
	local lastStorage = Global.Storage.TibiaDrome.StaminaExtension.LastActivatedAt
	local lastActivatedAt = player:getStorageValue(lastStorage)
	if lastActivatedAt + cooldown > os.time() then
		local cooldownLeft = lastActivatedAt + cooldown - os.time()
		player:sendTextMessage(MESSAGE_FAILURE, "You must wait " .. Game.getTimeInWords(cooldownLeft) .. " before using " .. item:getName() .. " again.")
		return true
	end

	local currentStamina = player:getStamina()
	local maxStamina = 2520 -- Maximum stamina in minutes
	local addAmount = 120 -- minutes (2 hours)
	local newStamina = math.min(currentStamina + addAmount, maxStamina)
	player:setStamina(newStamina)
	player:setStorageValue(lastStorage, os.time())

	local staminaAdded = newStamina - currentStamina
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been granted " .. staminaAdded .. " minutes of stamina.")
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	-- Infinite use: do NOT consume the item
	return true
end

infiniteStaminaExtension:id(50371)
infiniteStaminaExtension:register()
