local SoulKnowledge = Action("SoulKnowledge")

-- Mapping: knowledgeItemId -> { [targetItemId] = nextItemId, ... }
local transforms = {
    [50354] = { -- knowledge for mortal souls
        [50345] = 50346, -- empty mortal soul -> mortal soul filled with water
        [50346] = 50347, -- -> mortal soul with some milk
        [50347] = 50348, -- -> mortal soul filled with milk
        [50348] = 50349, -- -> empty angel soul
    },
    [50355] = { -- knowledge for angel soul
        [50349] = 50350, -- empty angel soul -> angel soul filled with water
        [50350] = 50351, -- -> angel soul filled with souls
        [50351] = 50357, -- -> empty celestial soul
    },
    [50367] = { -- knowledge for celestial soul (one variant)
        [50357] = 50358, -- empty celestial soul -> celestial soul with some power
        [50358] = 50359, -- -> celestial soul filled with power
        [50359] = 50360, -- -> celestial soul overflowing with power
        [50360] = 50361, -- -> ascendant soul with first domain
    },
    [50356] = { -- knowledge for celestial soul (other variant)
        [50361] = 50362, -- ascendant soul with first domain -> second domain
        [50362] = 50363,
        [50363] = 50364,
        [50364] = 50365,
        [50365] = 50353, -- -> godhood soul filled with life
    },
    [50368] = { -- knowledge for godhood soul
        [50353] = 50352, -- godhood soul filled with life -> godhood soul with some knowledge
        [50352] = 50366, -- -> godhood soul with all knowledge
    },
}

function SoulKnowledge.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or not target.itemid then
        return false
    end

    local kId = item.itemid
    local tId = target.itemid
    local kMap = transforms[kId]
    if not kMap then
        return false
    end

    local nextId = kMap[tId]
    if not nextId then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Nothing happens.")
        return true
    end

    -- transform the target soul to the next stage
    target:transform(nextId)
    target:decay()

    -- consume one knowledge item
    item:remove(1)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The knowledge strengthens the soul.")
    return true
end

-- Register all knowledge item ids handled by this action
SoulKnowledge:id(50354)
SoulKnowledge:id(50355)
SoulKnowledge:id(50356)
SoulKnowledge:id(50367)
SoulKnowledge:id(50368)
SoulKnowledge:register()
