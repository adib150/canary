-- Legendary Equipment Upgrade System
-- Use Hammer of Soul (673) + Jewel of Soul (30187) + 100k gold to upgrade equipment tiers
-- Compatible with: Armors, Helmets, Legs, Boots, Weapons

local config = {
    hammerId = 673,
    jewelId = 30187,
    upgradeCost = 100000,
    maxTier = 9,
    allowedEquipment = {
        39147, 34094, 34096, 34095, 28719, 27648, 22537, 36663,
        3397, 8862, 39165, 39164, 34157, 13993, 8038, 8039, 43876
    }
}

local equipmentUpgrade = Action()

function equipmentUpgrade.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Validate player
    if not player then
        return false
    end

    -- Validate target is an item
    if not target or not target:isItem() then
        player:sendCancelMessage("You can only use this on items.")
        return true
    end

    -- Check if jewel was used
    if item:getId() ~= config.jewelId then
        return false
    end

    -- Check if target is an allowed equipment
    local targetId = target:getId()
    if not table.contains(config.allowedEquipment, targetId) then
        player:sendCancelMessage("This item cannot be upgraded with the legendary system.")
        return true
    end

    -- Get current tier
    local description = target:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or ""
    local currentTier = tonumber(description:match("Legendary Tier %((%d+)%)")) or 0

    -- Check if already at max tier
    if currentTier >= config.maxTier then
        player:sendCancelMessage("This item is already at maximum legendary power.")
        return true
    end

    -- Check requirements
    if not player:getItemById(config.hammerId, 1) then
        player:sendCancelMessage("You need a Hammer of Power to upgrade.")
        return true
    end

    local totalMoney = player:getMoney() + player:getBankBalance()
    if totalMoney < config.upgradeCost then
        player:sendCancelMessage("You need " .. config.upgradeCost .. " gold to upgrade.")
        return true
    end

    -- Consume resources
    player:removeItem(config.jewelId, 1)
    player:removeItem(config.hammerId, 1)
    player:removeMoneyBank(config.upgradeCost)

    -- Apply upgrade
    local newTier = currentTier + 1
    target:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Legendary Tier (" .. newTier .. ").")

    -- Visual feedback
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The equipment has been upgraded to Legendary Tier " .. newTier .. "!")
    player:getPosition():sendMagicEffect(CONST_ME_ORANGE_ENERGY_SPARK)

    return true
end

equipmentUpgrade:id(config.jewelId)
equipmentUpgrade:register()
