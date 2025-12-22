-- Equipment Socket Upgrade System
-- Upgrade individual socket tiers from 1 to 10
-- First Socket: Use item 30191 + Hammer (673)
-- Second Socket: Use item 30190 + Hammer (673)
-- Third Socket: Use item 30188 + Hammer (673)

local config = {
    hammerId = 673,
    maxTier = 10,
    baseCost = 1000000, -- Base cost for tier 1->2 upgrade (1kk)
    baseSuccessRate = 80, -- Starting success rate at 80%
    successRateDecreasePerTier = 10, -- Decrease by 10% per tier
    minSuccessRate = 20, -- Minimum success rate of 20%
    downgradeChance = 20, -- 20% chance to downgrade 1 tier (for tier 2+)
    
    socketUpgrades = {
        [30191] = { socket = 1, name = "first" },   -- First socket upgrade powder
        [30190] = { socket = 2, name = "second" },  -- Second socket upgrade powder
        [30188] = { socket = 3, name = "third" }    -- Third socket upgrade powder
    }
}

-- Fibonacci sequence for tier costs: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55
local function getUpgradeCost(currentTier)
    local fibonacci = {1, 1, 2, 3, 5, 8, 13, 21, 34, 55}
    return config.baseCost * fibonacci[currentTier]
end

-- Calculate success rate based on current tier
local function getSuccessRate(currentTier)
    local rate = config.baseSuccessRate - (currentTier * config.successRateDecreasePerTier)
    return math.max(rate, config.minSuccessRate)
end

local function isEquipment(item)
    if not item then
        return false
    end
    
    local itemType = ItemType(item:getId())
    if not itemType then
        return false
    end
    
    local slotPosition = itemType:getSlotPosition()
    local validSlots = 1 + 8 + 16 + 32 + 64 + 128
    if bit.band(slotPosition, validSlots) == 0 then
        return false
    end
    
    local classification = item:getClassification()
    return classification == 3 or classification == 4
end

local function getCurrentTier(socketValue)
    if not socketValue or socketValue == "empty" then
        return 0
    end
    
    -- Extract tier number from format "<attribute> tier X"
    return tonumber(socketValue:match("tier (%d+)")) or 0
end

local socketUpgrade = Action()

function socketUpgrade.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not player then
        return false
    end

    if not target or not target:getId() then
        player:sendCancelMessage("You can only use this on items.")
        return true
    end

    local upgradeInfo = config.socketUpgrades[item:getId()]
    if not upgradeInfo then
        return false
    end

    if not isEquipment(target) then
        player:sendCancelMessage("This item cannot be upgraded. Only classification 3 or 4 equipment can be upgraded.")
        return true
    end

    -- Check if player has hammer
    if not player:getItemById(config.hammerId, 1) then
        player:sendCancelMessage("You need a Hammer of Power to upgrade sockets.")
        return true
    end

    -- Get current socket status
    local socketAttr = "socket" .. upgradeInfo.socket
    local socketValue = target:getCustomAttribute(socketAttr) or "empty"
    
    local currentTier = getCurrentTier(socketValue)
    
    if currentTier == 0 then
        player:sendCancelMessage("The " .. upgradeInfo.name .. " socket is empty. Use Awakening Powder to add a socket first.")
        return true
    end

    if currentTier >= config.maxTier then
        player:sendCancelMessage("The " .. upgradeInfo.name .. " socket is already at maximum tier (" .. config.maxTier .. ").")
        return true
    end

    -- Check gold requirement
    local upgradeCost = getUpgradeCost(currentTier)
    local totalMoney = player:getMoney() + player:getBankBalance()
    if totalMoney < upgradeCost then
        player:sendCancelMessage("You need " .. upgradeCost .. " gold to upgrade to tier " .. (currentTier + 1) .. ".")
        return true
    end

    -- Consume resources
    player:removeItem(item:getId(), 1)
    player:removeItem(config.hammerId, 1)
    player:removeMoneyBank(upgradeCost)

    -- Check for downgrade (tier 2+)
    if currentTier >= 2 then
        local downgradeRoll = math.random(100)
        if downgradeRoll <= config.downgradeChance then
            local newTier = currentTier - 1
            
            -- Extract attribute name from current socket value
            local attributeName = socketValue:match("(.+) tier %d+")
            if attributeName then
                target:setCustomAttribute(socketAttr, attributeName .. " tier " .. newTier)
                
                -- Update all sockets for description
                local socket1 = target:getCustomAttribute("socket1") or "empty"
                local socket2 = target:getCustomAttribute("socket2") or "empty"
                local socket3 = target:getCustomAttribute("socket3") or "empty"
                
                local existingDesc = target:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or ""
                existingDesc = existingDesc:gsub("Power Sockets: %b()", "")
                existingDesc = existingDesc:gsub("\n+$", "")
                
                local newLine = existingDesc ~= "" and "\n" or ""
                local socketsDescription = existingDesc .. newLine .. "Power Sockets: (" .. socket1 .. ", " .. socket2 .. ", " .. socket3 .. ")"
                target:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, socketsDescription)
            end
            
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The socket destabilized! The " .. upgradeInfo.name .. " socket has been downgraded to tier " .. newTier .. ".")
            player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
            return true
        end
    end

    -- Check success rate
    local successRate = getSuccessRate(currentTier)
    local successRoll = math.random(100)
    
    if successRoll > successRate then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Upgrade failed! (Success chance was " .. successRate .. "%) The socket remains at tier " .. currentTier .. ".")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    -- Upgrade the socket
    local newTier = currentTier + 1
    
    -- Extract attribute name from current socket value (e.g., "critical chance tier 1" -> "critical chance")
    local attributeName = socketValue:match("(.+) tier %d+")
    if not attributeName then
        player:sendCancelMessage("Invalid socket format.")
        return true
    end
    
    target:setCustomAttribute(socketAttr, attributeName .. " tier " .. newTier)

    -- Update all sockets for description
    local socket1 = target:getCustomAttribute("socket1") or "empty"
    local socket2 = target:getCustomAttribute("socket2") or "empty"
    local socket3 = target:getCustomAttribute("socket3") or "empty"

    -- Get existing description and update it
    local existingDesc = target:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or ""
    existingDesc = existingDesc:gsub("Power Sockets: %b()", "")
    existingDesc = existingDesc:gsub("\n+$", "")
    
    -- Add new sockets line
    local newLine = existingDesc ~= "" and "\n" or ""
    local socketsDescription = existingDesc .. newLine .. "Power Sockets: (" .. socket1 .. ", " .. socket2 .. ", " .. socket3 .. ")"
    target:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, socketsDescription)

    -- Visual feedback
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Success! The " .. upgradeInfo.name .. " socket has been upgraded to tier " .. newTier .. "! (Cost: " .. upgradeCost .. " gold)")
    player:getPosition():sendMagicEffect(CONST_ME_ENERGYAREA)

    return true
end

socketUpgrade:id(30191) -- First socket
socketUpgrade:id(30190) -- Second socket
socketUpgrade:id(30188) -- Third socket
socketUpgrade:register()
