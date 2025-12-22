-- Legendary Equipment Upgrade System
-- Use Hammer of Power (673) + Awakening Powder of Power (30187) + 100k gold to upgrade equipment slots
-- Compatible with: All equipment (Armors, Helmets, Legs, Boots, Weapons, Shields, etc.)

local config = {
    hammerId = 673,
    jewelId = 30187,
    upgradeCost = 100000,
    maxTier = 9,
    maxSlots = 3,
}

local function isEquipment(item)
    if not item then
        return false
    end
    
    local itemType = ItemType(item:getId())
    if not itemType then
        return false
    end
    
    -- Check if item is equippable (weapons, armor, helmets, legs, boots)
    local slotPosition = itemType:getSlotPosition()
    local validSlots = 1 + 8 + 16 + 32 + 64 + 128  -- head, armor, right, left, legs, feet
    if bit.band(slotPosition, validSlots) == 0 then
        return false
    end
    
    -- Check if classification is 3 or 4
    local classification = item:getClassification()
    return classification == 3 or classification == 4
end

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

    -- Check if target is equipment
    if not isEquipment(target) then
        player:sendCancelMessage("This item cannot be upgraded with the legendary system.")
        return true
    end

    -- Get current slots status using custom attribute
    local slot1 = target:getCustomAttribute("slot1") or "empty"
    local slot2 = target:getCustomAttribute("slot2") or "empty"
    local slot3 = target:getCustomAttribute("slot3") or "empty"
    
    local slots = { slot1, slot2, slot3 }

    -- Find first empty slot
    local emptySlotIndex = nil
    for i = 1, config.maxSlots do
        if slots[i] == "empty" then
            emptySlotIndex = i
            break
        end
    end

    -- Check if all slots are filled
    if not emptySlotIndex then
        player:sendCancelMessage("All slots are already fulfilled.")
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
    target:setCustomAttribute("slot" .. emptySlotIndex, "legendary tier 1")
    
    -- Update description to show slots
    slots[emptySlotIndex] = "legendary tier 1"
    
    -- Get existing description and update it
    local existingDesc = target:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or ""
    
    -- Remove old slots line if it exists
    existingDesc = existingDesc:gsub("Slots of Power: %([^)]+%)\n?", "")
    existingDesc = existingDesc:gsub("\n$", "") -- Remove trailing newline
    
    -- Add new slots line
    local newLine = existingDesc ~= "" and "\n" or ""
    local slotsDescription = existingDesc .. newLine .. "Slots of Power: (" .. slots[1] .. ", " .. slots[2] .. ", " .. slots[3] .. ")"
    target:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, slotsDescription)

    -- Visual feedback
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The equipment slot " .. emptySlotIndex .. " has been upgraded to Legendary Tier 1!")
    player:getPosition():sendMagicEffect(CONST_ME_ORANGE_ENERGY_SPARK)

    return true
end

equipmentUpgrade:id(config.jewelId)
equipmentUpgrade:register()
