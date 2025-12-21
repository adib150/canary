-- Legendary Equipment Buff System
-- Applies stat bonuses when legendary equipment is equipped
-- Compatible with: Armors, Helmets, Legs, Boots, Weapons

local config = {
    equipmentIds = {
        39147, 34094, 34096, 34095, 28719, 27648, 22537, 36663,
        3397, 8862, 39165, 39164, 34157, 13993, 8038, 8039, 43876
    },
    bonusPerTier = {
        healthPercent = 3,      -- +3% max HP per tier
        critChance = 0.4,       -- +0.4% crit chance per tier
        critDamage = 1,         -- +1% crit damage per tier
        damagePercent = 0.8     -- +0.8% damage per tier
    }
}

local legendaryEquip = MoveEvent()

function legendaryEquip.onEquip(player, item, slot, isCheck)
    -- Skip validation check
    if isCheck then
        return true
    end

    -- Validate player and item
    if not player or not item then
        return true
    end

    -- Check for legendary tier
    local description = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
    if not description or not description:lower():find("legendary tier") then
        return true
    end

    -- Extract tier number
    local tier = tonumber(description:match("Legendary Tier %((%d+)%)"))
    if not tier or tier < 1 then
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
for _, id in ipairs(config.equipmentIds) do
    legendaryEquip:id(id)
end
legendaryEquip:register()

local legendaryDeequip = MoveEvent()

function legendaryDeequip.onDeEquip(player, item, slot, isCheck)
    -- Skip validation check
    if isCheck then
        return true
    end

    -- Validate player and item
    if not player or not item then
        return true
    end

    -- Check for legendary tier
    local description = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
    if not description or not description:lower():find("legendary tier") then
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
for _, id in ipairs(config.equipmentIds) do
    legendaryDeequip:id(id)
end
legendaryDeequip:register()
