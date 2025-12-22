-- Equipment Socket Buff System
-- Applies stat bonuses based on socketed attributes and tiers
-- Only works on classification 3 or 4 equipment

local config = {
    -- Bonus values per tier for each attribute type
    attributeBonuses = {
        ["critical chance"] = {
            type = "critChance",
            value = 40  -- +0.4% per tier (100 = 1%)
        },
        ["critical damage"] = {
            type = "critDamage",
            value = 100  -- +1% per tier (100 = 1%)
        },
        ["magic level"] = {
            type = "magicLevel",
            value = 1  -- +1 magic level per tier
        },
        ["distance fight"] = {
            type = "distanceSkill",
            value = 1  -- +1 distance skill per tier
        },
        ["axe fight"] = {
            type = "axeSkill",
            value = 1  -- +1 axe skill per tier
        },
        ["sword fight"] = {
            type = "swordSkill",
            value = 1  -- +1 sword skill per tier
        },
        ["club fight"] = {
            type = "clubSkill",
            value = 1  -- +1 club skill per tier
        },
        ["onslaught"] = {
            type = "damagePercent",
            value = 2  -- +2% damage per tier
        },
        ["transcendence"] = {
            type = "healthPercent",
            value = 3  -- +3% max HP per tier
        },
        ["amplification"] = {
            type = "manaPercent",
            value = 3  -- +3% max mana per tier
        },
        ["ruse"] = {
            type = "dodgePercent",
            value = 1  -- +1% dodge per tier
        },
        ["momentum"] = {
            type = "speedBoost",
            value = 5  -- +5 speed per tier
        }
    }
}

local function getSocketAttributes(item)
    if not item then
        return {}
    end
    
    local socket1 = item:getCustomAttribute("socket1") or "empty"
    local socket2 = item:getCustomAttribute("socket2") or "empty"
    local socket3 = item:getCustomAttribute("socket3") or "empty"
    
    local attributes = {}
    for _, socketValue in ipairs({socket1, socket2, socket3}) do
        if socketValue ~= "empty" then
            -- Extract attribute name and tier (e.g., "critical chance tier 5")
            local attributeName, tier = socketValue:match("(.+) tier (%d+)")
            if attributeName and tier then
                tier = tonumber(tier)
                if not attributes[attributeName] then
                    attributes[attributeName] = 0
                end
                attributes[attributeName] = attributes[attributeName] + tier
            end
        end
    end
    
    return attributes
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

print(string.format("[Socket System] Registered %d equipment items", #equipmentIds))

-- Register equip event
local legendaryEquip = MoveEvent()

function legendaryEquip.onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end

    if not player or not item then
        return true
    end

    -- Debug: Check classification
    local classification = item:getClassification()
    print(string.format("[Socket Debug] Item: %s, Classification: %d", item:getName(), classification))
    
    -- Check if item has classification 3 or 4
    if classification ~= 3 and classification ~= 4 then
        print(string.format("[Socket Debug] Skipping - classification is not 3 or 4"))
        return true
    end

    local socketAttributes = getSocketAttributes(item)
    
    -- Debug logging
    print(string.format("[Socket Debug] Socket1: %s", item:getCustomAttribute("socket1") or "empty"))
    print(string.format("[Socket Debug] Socket2: %s", item:getCustomAttribute("socket2") or "empty"))
    print(string.format("[Socket Debug] Socket3: %s", item:getCustomAttribute("socket3") or "empty"))
    print(string.format("[Socket Debug] Attributes found: %d", next(socketAttributes) and 1 or 0))
    
    if not next(socketAttributes) then
        return true
    end

    -- Create condition tied to equipment slot
    local condition = Condition(CONDITION_ATTRIBUTES, slot)
    condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
    condition:setParameter(CONDITION_PARAM_TICKS, -1)
    condition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
    
    -- Initialize base stats
    local healthPercent = 100
    local manaPercent = 100
    local damagePercent = 100
    local critChance = 0
    local critDamage = 0
    local magicLevel = 0
    local axeSkill = 0
    local swordSkill = 0
    local clubSkill = 0
    local distanceSkill = 0
    local speedBoost = 0
    local dodgePercent = 0
    
    -- Apply bonuses from each attribute
    local attributeMessages = {}
    for attributeName, totalTiers in pairs(socketAttributes) do
        local bonusConfig = config.attributeBonuses[attributeName]
        if bonusConfig then
            local bonusType = bonusConfig.type
            local bonusValue = bonusConfig.value * totalTiers
            
            if bonusType == "healthPercent" then
                healthPercent = healthPercent + bonusValue
            elseif bonusType == "manaPercent" then
                manaPercent = manaPercent + bonusValue
            elseif bonusType == "damagePercent" then
                damagePercent = damagePercent + bonusValue
            elseif bonusType == "critChance" then
                critChance = critChance + bonusValue
            elseif bonusType == "critDamage" then
                critDamage = critDamage + bonusValue
            elseif bonusType == "magicLevel" then
                magicLevel = magicLevel + bonusValue
            elseif bonusType == "axeSkill" then
                axeSkill = axeSkill + bonusValue
            elseif bonusType == "swordSkill" then
                swordSkill = swordSkill + bonusValue
            elseif bonusType == "clubSkill" then
                clubSkill = clubSkill + bonusValue
            elseif bonusType == "distanceSkill" then
                distanceSkill = distanceSkill + bonusValue
            elseif bonusType == "speedBoost" then
                speedBoost = speedBoost + bonusValue
            elseif bonusType == "dodgePercent" then
                dodgePercent = dodgePercent + bonusValue
            end
            
            table.insert(attributeMessages, attributeName .. " (tier " .. totalTiers .. ")")
        end
    end
    
    -- Set all condition parameters
    condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT, healthPercent)
    condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT, manaPercent)
    condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, damagePercent)
    condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, critChance)
    condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, critDamage)
    
    if magicLevel > 0 then
        condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, magicLevel)
    end
    if axeSkill > 0 then
        condition:setParameter(CONDITION_PARAM_SKILL_AXE, axeSkill)
    end
    if swordSkill > 0 then
        condition:setParameter(CONDITION_PARAM_SKILL_SWORD, swordSkill)
    end
    if clubSkill > 0 then
        condition:setParameter(CONDITION_PARAM_SKILL_CLUB, clubSkill)
    end
    if distanceSkill > 0 then
        condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, distanceSkill)
    end
    if speedBoost > 0 then
        condition:setParameter(CONDITION_PARAM_SPEED, speedBoost)
    end
    -- Note: Dodge is not directly supported by Canary conditions, we'll skip it for now

    player:addCondition(condition)
    
    if #attributeMessages > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Socket power surges through you! " .. table.concat(attributeMessages, ", "))
    end

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

    local socketAttributes = getSocketAttributes(item)
    if not next(socketAttributes) then
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

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The socket power fades away.")

    return true
end

legendaryDeequip:type("deequip")
for _, itemId in ipairs(equipmentIds) do
    legendaryDeequip:id(itemId)
end
legendaryDeequip:register()
