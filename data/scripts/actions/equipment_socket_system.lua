-- Equipment Socket System
-- Use Hammer of Power (673) + Awakening Powder of Power (30187) + 3kk gold to upgrade equipment sockets
-- Socket Removers: 31354 (socket 1), 31356 (socket 2), 31355 (socket 3) + Hammer of Power (673)
-- Compatible with: All equipment with classification 3 or 4 (Armors, Helmets, Legs, Boots, Weapons)

local config = {
    hammerId = 673,
    jewelId = 30187,
    upgradeCost = 3000000,
    maxTier = 10,
    maxSockets = 3,
    awakeningSuccessRate = 80, -- 80% chance to successfully add a socket
    socketRemovers = {
        [31354] = 1,  -- Removes socket 1
        [31356] = 2,  -- Removes socket 2
        [31355] = 3,  -- Removes socket 3
    },
}

-- Attribute pools based on equipment slot
local attributePools = {
    -- Weapons (right/left hand)
    weapon = {"critical chance", "critical damage", "magic level", "distance fight", "axe fight", "sword fight", "club fight", "fist fight", "shielding", "fishing", "hp", "mana", "life leech", "mana leech", "final damage", "damage reduction"},
    -- Armor
    armor = {"critical chance", "critical damage", "magic level", "distance fight", "axe fight", "sword fight", "club fight", "fist fight", "shielding", "fishing", "hp", "mana", "life leech", "mana leech", "damage reduction"},
    -- Helmet
    helmet = {"critical chance", "critical damage", "magic level", "distance fight", "axe fight", "sword fight", "club fight", "fist fight", "shielding", "fishing", "hp", "mana", "life leech", "mana leech", "final damage"},
    -- Legs
    legs = {"critical chance", "critical damage", "magic level", "distance fight", "axe fight", "sword fight", "club fight", "fist fight", "shielding", "fishing", "hp", "mana", "life leech", "mana leech", "final damage"},
    -- Boots
    boots = {"critical chance", "critical damage", "magic level", "distance fight", "axe fight", "sword fight", "club fight", "fist fight", "shielding", "fishing", "hp", "mana", "life leech", "mana leech", "damage reduction"},
}

local function getEquipmentSlotType(item)
    local itemType = ItemType(item:getId())
    local slotPosition = itemType:getSlotPosition()
    
    -- Check slot position (order matters - check more specific slots first)
    if bit.band(slotPosition, 1) ~= 0 then -- SLOTP_HEAD
        return "helmet"
    elseif bit.band(slotPosition, 8) ~= 0 then -- SLOTP_ARMOR
        return "armor"
    elseif bit.band(slotPosition, 64) ~= 0 then -- SLOTP_LEGS
        return "legs"
    elseif bit.band(slotPosition, 128) ~= 0 then -- SLOTP_FEET
        return "boots"
    elseif bit.band(slotPosition, 16) ~= 0 or bit.band(slotPosition, 32) ~= 0 then -- SLOTP_RIGHT or SLOTP_LEFT (weapons/shields)
        return "weapon"
    end
    
    return nil
end

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
        player:sendCancelMessage("This item cannot be socketed. Only classification 3 or 4 equipment can be socketed.")
        return true
    end

    -- Get current sockets status using custom attribute
    local socket1 = target:getCustomAttribute("socket1") or "empty"
    local socket2 = target:getCustomAttribute("socket2") or "empty"
    local socket3 = target:getCustomAttribute("socket3") or "empty"
    
    local sockets = { socket1, socket2, socket3 }

    -- Find first empty socket
    local emptySocketIndex = nil
    for i = 1, config.maxSockets do
        if sockets[i] == "empty" then
            emptySocketIndex = i
            break
        end
    end

    -- Check if all sockets are filled
    if not emptySocketIndex then
        player:sendCancelMessage("All sockets are already filled.")
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

    -- Check success rate
    local successRoll = math.random(100)
    if successRoll > config.awakeningSuccessRate then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Socket awakening failed! The power was too unstable.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    -- Get equipment slot type and select random attribute
    local slotType = getEquipmentSlotType(target)
    if not slotType then
        player:sendCancelMessage("Unable to determine equipment type.")
        return true
    end
    
    local attributePool = attributePools[slotType]
    local randomAttribute = attributePool[math.random(#attributePool)]
    local attributeValue = randomAttribute .. " tier 1"
    
    -- Apply upgrade
    target:setCustomAttribute("socket" .. emptySocketIndex, attributeValue)
    
    -- Update description to show sockets
    sockets[emptySocketIndex] = attributeValue
    
    -- Get existing description and update it
    local existingDesc = target:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or ""
    
    -- Remove old sockets line if it exists
    existingDesc = existingDesc:gsub("Power Sockets: %([^)]+%)\n?", "")
    existingDesc = existingDesc:gsub("\n$", "") -- Remove trailing newline
    
    -- Add new sockets line
    local newLine = existingDesc ~= "" and "\n" or ""
    local socketsDescription = existingDesc .. newLine .. "Power Sockets: (" .. sockets[1] .. ", " .. sockets[2] .. ", " .. sockets[3] .. ")"
    target:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, socketsDescription)

    -- Visual feedback
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Socket " .. emptySocketIndex .. " has been infused with " .. randomAttribute .. "! (Tier 1)")
    player:getPosition():sendMagicEffect(CONST_ME_ORANGE_ENERGY_SPARK)

    return true
end

equipmentUpgrade:id(config.jewelId)
equipmentUpgrade:register()

-- Socket Removal System
local socketRemoval = Action()

function socketRemoval.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Validate player
    if not player then
        return false
    end

    -- Validate target is an item
    if not target or not target:isItem() then
        player:sendCancelMessage("You can only use this on items.")
        return true
    end

    -- Check if item is a socket remover
    local socketToRemove = config.socketRemovers[item:getId()]
    if not socketToRemove then
        return false
    end

    -- Check if target is equipment
    if not isEquipment(target) then
        player:sendCancelMessage("This item cannot have sockets removed. Only classification 3 or 4 equipment can have sockets.")
        return true
    end

    -- Check if player has hammer
    if not player:getItemById(config.hammerId, 1) then
        player:sendCancelMessage("You need a Hammer of Power to remove a socket.")
        return true
    end

    -- Get current socket status
    local socketKey = "socket" .. socketToRemove
    local currentSocket = target:getCustomAttribute(socketKey) or "empty"
    
    if currentSocket == "empty" then
        player:sendCancelMessage("Socket " .. socketToRemove .. " is already empty.")
        return true
    end

    -- Consume resources
    player:removeItem(item:getId(), 1)
    player:removeItem(config.hammerId, 1)

    -- Remove the socket
    target:setCustomAttribute(socketKey, "empty")
    
    -- Update description
    local socket1 = target:getCustomAttribute("socket1") or "empty"
    local socket2 = target:getCustomAttribute("socket2") or "empty"
    local socket3 = target:getCustomAttribute("socket3") or "empty"
    
    local existingDesc = target:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or ""
    existingDesc = existingDesc:gsub("Power Sockets: %([^)]+%)\n?", "")
    existingDesc = existingDesc:gsub("\n$", "")
    
    local newLine = existingDesc ~= "" and "\n" or ""
    local socketsDescription = existingDesc .. newLine .. "Power Sockets: (" .. socket1 .. ", " .. socket2 .. ", " .. socket3 .. ")"
    target:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, socketsDescription)

    -- Visual feedback
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Socket " .. socketToRemove .. " has been emptied!")
    player:getPosition():sendMagicEffect(CONST_ME_SMOKE)

    return true
end

-- Register all socket removers
for itemId, socketNum in pairs(config.socketRemovers) do
    socketRemoval:id(itemId)
end
socketRemoval:register()
