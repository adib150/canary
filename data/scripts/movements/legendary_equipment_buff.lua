-- Legendary Equipment Buff System
-- Dynamically registers for all equipment items

local config = {
    bonusPerTier = {
        healthPercent = 3,      -- +3% max HP per tier
        critChance = 40,        -- +0.4% crit chance per tier (100 = 1%)
        critDamage = 100,       -- +1% crit damage per tier (100 = 1%)
        damagePercent = 0.8     -- +0.8% damage per tier
    }
}

local function getTotalTier(item)
    if not item then
        return 0
    end
    
    local slot1 = item:getCustomAttribute("slot1") or "empty"
    local slot2 = item:getCustomAttribute("slot2") or "empty"
    local slot3 = item:getCustomAttribute("slot3") or "empty"
    
    local totalTier = 0
    for _, slotValue in ipairs({slot1, slot2, slot3}) do
        if slotValue ~= "empty" then
            local tier = tonumber(slotValue:match("legendary tier (%d+)"))
            if tier then
                totalTier = totalTier + tier
            end
        end
    end
    
    return totalTier
end

-- Get all equipment item IDs with classification 3 or 4
local equipmentIds = {}
for itemId = 1, 50000 do
    local itemType = ItemType(itemId)
    if itemType and itemType:isMovable() then
        local slotPosition = itemType:getSlotPosition()
        -- Check if it's equippable (head, armor, right, left, legs, feet)
        local validSlots = 1 + 8 + 16 + 32 + 64 + 128
        if bit.band(slotPosition, validSlots) > 0 then
            -- Note: We can't check classification during item type scan
            -- Classification is per-item instance, not item type
            -- So we register all equipment and check classification on equip
            table.insert(equipmentIds, itemId)
        end
    end
end

print(string.format("[Legendary Equipment] Registered %d equipment items", #equipmentIds))

-- Register equip event
local legendaryEquip = MoveEvent()

function legendaryEquip.onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end

    if not player or not item then
        return true
    end

    -- Check if item has classification 3 or 4
    local classification = item:getClassification()
    if classification ~= 3 and classification ~= 4 then
        return true
    end

    local tier = getTotalTier(item)
    if tier < 1 then
        return true
    end

    -- Create condition tied to equipment slot  
    local condition = Condition(CONDITION_ATTRIBUTES, slot)
    condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
    condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT, 100 + config.bonusPerTier.healthPercent * tier)
    condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, config.bonusPerTier.critChance * tier)
    condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, config.bonusPerTier.critDamage * tier)
    condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 100 + config.bonusPerTier.damagePercent * tier)
    condition:setParameter(CONDITION_PARAM_TICKS, -1)
    condition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

    player:addCondition(condition)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Legendary power flows through you! (Tier " .. tier .. ")")

    return true
end

legendaryEquip:type("equip")
for _, itemId in ipairs(equipmentIds) do
    legendaryEquip:id(itemId)
end
legendaryEquip:register()

-- Register deequip event
local legendaryDeequip = MoveEvent()

function legendaryDeequip.onDeEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end

    if not player or not item then
        return true
    end

    -- Check if item has classification 3 or 4
    local classification = item:getClassification()
    if classification ~= 3 and classification ~= 4 then
        return true
    end

    local tier = getTotalTier(item)
    if tier < 1 then
        return true
    end

    -- Remove condition tied to this slot
    player:removeCondition(CONDITION_ATTRIBUTES, slot)

    -- Adjust current HP to maintain health percentage after max HP change
    local currentHealth = player:getHealth()
    local maxHealth = player:getMaxHealth()
    
    if currentHealth > maxHealth then
        player:addHealth(maxHealth - currentHealth, false)
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The legendary power fades away.")

    return true
end

legendaryDeequip:type("deequip")
for _, itemId in ipairs(equipmentIds) do
    legendaryDeequip:id(itemId)
end
legendaryDeequip:register()
