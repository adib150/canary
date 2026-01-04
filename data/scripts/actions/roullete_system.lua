local config = {
    uniqueId = 30000, -- on lever

    lever = {
        left = 2772,
        right = 2773
    },

    playItem = {
        itemId = 19082,
        count = 1
    },

    rouletteOptions = {
        ignoredItems = {}, -- if you have tables/counters/other items on the roulette tiles, add them here
        winEffects = {CONST_ANI_FIRE, CONST_ME_SOUND_YELLOW, CONST_ME_SOUND_PURPLE, CONST_ME_SOUND_BLUE, CONST_ME_SOUND_WHITE}, -- first effect needs to be distance effect
        effectDelay = 333,
        spinTime = {min = 8, max = 12}, -- seconds
        spinSlowdownRamping = 5,
        rouletteStorage = "roulette-finishes" -- required storage to avoid player abuse (if they logout/die before roulette finishes.. they can spin again for free)
    },

    prizePool = {
        -- Lowered chances for top-tier equipment to make them realistically rare.
        {itemId = 3043, count = {1, 50},   chance = 4000}, -- crystal coins
        {itemId = 3392, count = {1, 1},    chance = 1000 }, -- royal helmet
        {itemId = 3387, count = {1, 1},    chance = 1000 }, -- demon helmet
        {itemId = 10387, count = {1, 1},    chance = 1000 }, -- zaoan legs
        {itemId = 3364, count = {1, 1},    chance = 1000 }, -- golden legs
        {itemId = 3366, count = {1, 1},    chance = 500 }, -- magic plate armor
        {itemId = 3555, count = {1, 1},    chance = 150  }, -- golden boots
        --store items
        {itemId = 19082, count = {1, 2},    chance = 1000 }, -- roulette token
        {itemId = 22118, count = {1, 100},    chance = 1000  }, -- tibia coins
        {itemId = 50343, count = {1, 3},    chance = 150  }, -- random outfit
        {itemId = 50344, count = {1, 3},    chance = 150  }, -- random mount
         {itemId = 673, count = {1, 5},    chance = 150 }, -- hammer of power
        {itemId = 30187, count = {1, 3},    chance = 150 }, -- awakening powder
        {itemId = 30191, count = {1, 3},    chance = 150 }, -- first socket upgrade powder
        {itemId = 30190, count = {1, 3},    chance = 150 }, -- second socket upgrade powder
        {itemId = 30188, count = {1, 3},    chance = 150  }, -- third socket upgrade powder
        {itemId = 31354, count = {1, 3},    chance = 150  }, --first socket reroll
        {itemId = 31356, count = {1, 3},    chance = 150  }, --second socket reroll
        {itemId = 31355, count = {1, 3},    chance = 150  }, --third socket reroll
        -- high-tier bags and rare items
        {itemId = 34109, count = {1, 1},    chance = 15 }, -- bag you desire
        {itemId = 43895, count = {1, 1},    chance = 10   }, -- bag you covet
        {itemId = 39546, count = {1, 1},    chance = 10 }, -- primal bag
        {itemId = 5903, count = {1, 1},    chance = 5  }  -- ferumbras hat

    },

    roulettePositions = {
        Position(27324, 25047, 7),
        Position(27325, 25047, 7),
        Position(27326, 25047, 7),
        Position(27327, 25047, 7),
        Position(27328, 25047, 7),
        Position(27329, 25047, 7), -- position 11 in this list is hard-coded to be the reward location, which is the item given to the player
        Position(27330, 25047, 7),
        Position(27331, 25047, 7),
        Position(27332, 25047, 7),
        Position(27333, 25047, 7),
        Position(27334, 25047, 7)
    }
}

local chancedItems = {}

local function resetLever(position)
    local lever = Tile(position):getItemById(config.lever.right)
    lever:transform(config.lever.left)
end

local function updateRoulette(newItemInfo)
    local positions = config.roulettePositions
    for i = #positions, 1, -1 do
        local tile = Tile(positions[i])
        if not tile then
            goto continue
        end
        
        local ground = tile:getGround()
        if not ground then
            goto continue
        end
        
        local item = tile:getTopVisibleThing()
        if item and item:getId() ~= ground:getId() and not table.contains(config.rouletteOptions.ignoredItems, item:getId()) then
            if i ~= 11 then
                item:moveTo(positions[i + 1])
            else
                item:remove()
            end
        end
        
        ::continue::
    end

    if ItemType(newItemInfo.itemId):getCharges() > 0 then
        local item = Game.createItem(newItemInfo.itemId, 1, positions[1])
        if item then
            item:setAttribute(ITEM_ATTRIBUTE_CHARGES, newItemInfo.count)
        end
    else
        Game.createItem(newItemInfo.itemId, newItemInfo.count, positions[1])
    end
end

local function clearRoulette(newItemInfo)
    local positions = config.roulettePositions
    for i = #positions, 1, -1 do
        local tile = Tile(positions[i])
        if not tile then
            logger.error("[Roulette] Invalid tile at position index: {}", i)
            goto continue
        end
        
        local ground = tile:getGround()
        if not ground then
            logger.error("[Roulette] No ground at position index: {}", i)
            goto continue
        end
        
        local item = tile:getTopVisibleThing()
        if item and item:getId() ~= ground:getId() and not table.contains(config.rouletteOptions.ignoredItems, item:getId()) then
            item:remove()
        end

        if newItemInfo == nil then
            positions[i]:sendMagicEffect(CONST_ME_POFF)
        else
            if ItemType(newItemInfo.itemId):getCharges() > 0 then
                local newItem = Game.createItem(newItemInfo.itemId, 1, positions[i])
                if newItem then
                    newItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, newItemInfo.count)
                end
            else
                Game.createItem(newItemInfo.itemId, newItemInfo.count, positions[i])
            end
        end
        
        ::continue::
    end
end

local function chanceNewReward()
    -- Use a weighted random selection based on `chance` values as weights.
    -- If weights are invalid (sum <= 0), fallback to the original inclusion-roll method.
    local newItemInfo = {itemId = 0, count = 0}

    -- Sum weights
    local totalWeight = 0
    for i = 1, #config.prizePool do
        local w = tonumber(config.prizePool[i].chance) or 0
        if w > 0 then
            totalWeight = totalWeight + w
        end
    end

    if totalWeight > 0 then
        -- Pick a random value in [1, totalWeight]
        local pick = math.random(1, totalWeight)
        local acc = 0
        local chosenIndex = nil
        for i = 1, #config.prizePool do
            local w = tonumber(config.prizePool[i].chance) or 0
            if w > 0 then
                acc = acc + w
                if pick <= acc then
                    chosenIndex = i
                    break
                end
            end
        end

        -- Safety fallback: if nothing chosen, pick last
        if not chosenIndex then
            chosenIndex = #config.prizePool
        end

        local prize = config.prizePool[chosenIndex]
        newItemInfo.itemId = prize.itemId
        newItemInfo.count = math.random(prize.count[1], prize.count[2])
        chancedItems[#chancedItems + 1] = prize.chance
        return newItemInfo
    end

    -- Fallback: original inclusion-then-uniform method
    local rewardTable = {}
    while #rewardTable < 1 do
        for i = 1, #config.prizePool do
            if config.prizePool[i].chance >= math.random(10000) then
                rewardTable[#rewardTable + 1] = i
            end
        end
    end

    local rand = math.random(#rewardTable)
    newItemInfo.itemId = config.prizePool[rewardTable[rand]].itemId
    newItemInfo.count = math.random(config.prizePool[rewardTable[rand]].count[1], config.prizePool[rewardTable[rand]].count[2])
    chancedItems[#chancedItems + 1] = config.prizePool[rewardTable[rand]].chance
    return newItemInfo
end

local function initiateReward(leverPosition, effectCounter)
    if effectCounter < #config.rouletteOptions.winEffects then
        effectCounter = effectCounter + 1
        if effectCounter == 1 then
            config.roulettePositions[11]:sendDistanceEffect(config.roulettePositions[6], config.rouletteOptions.winEffects[1])
            config.roulettePositions[11]:sendDistanceEffect(config.roulettePositions[6], config.rouletteOptions.winEffects[1])
        else
            for i = 1, #config.roulettePositions do
                config.roulettePositions[i]:sendMagicEffect(config.rouletteOptions.winEffects[effectCounter])
            end
        end

        if effectCounter == 2 then
            local item = Tile(config.roulettePositions[6]):getTopVisibleThing()
            local newItemInfo = {itemId = item:getId(), count = item:getCount()}
            clearRoulette(newItemInfo)
        end

        addEvent(initiateReward, config.rouletteOptions.effectDelay, leverPosition, effectCounter)
        return
    end

    resetLever(leverPosition)
end

local function rewardPlayer(playerId, leverPosition)
    local player = Player(playerId)
    if not player then
        return
    end

    local item = Tile(config.roulettePositions[6]):getTopVisibleThing()
    if not item then
        return
    end
    
    local itemId = item:getId()
    local itemCount = item:getCount()
    local itemCharges = item:getCharges()
    
    -- Check if player has more than 300 cap, send to store inbox first, otherwise normal inbox
    local targetInbox
    local inboxType = "inbox"
    
    if player:getFreeCapacity() > 300 then
        targetInbox = player:getStoreInbox()
        inboxType = "store inbox"
    end
    
    -- Fallback to regular inbox if store inbox not available or cap <= 300
    if not targetInbox then
        targetInbox = player:getInbox()
        inboxType = "inbox"
    end
    
    if targetInbox then
        local addedItem = targetInbox:addItem(itemId, itemCount, INDEX_WHEREEVER, FLAG_NOLIMIT)
        if addedItem and itemCharges > 0 then
            addedItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, itemCharges)
        end
    end

    player:sendTextMessage(MESSAGE_STATUS, "Congratulations! You have won " .. item:getName() .. ". The item has been sent to your " .. inboxType .. ".")
    player:kv():set(config.rouletteOptions.rouletteStorage, -1)
    player:setMoveLocked(false)
    
    -- Find the chance of the won item
    local wonItemChance = nil
    for i = 1, #config.prizePool do
        if config.prizePool[i].itemId == itemId then
            wonItemChance = config.prizePool[i].chance
            break
        end
    end
    
    -- Broadcast if item has chance lower than 100
    if wonItemChance and wonItemChance < 200 then
        Game.broadcastMessage("[RARE ROULETTE WIN] Congratulations to " .. player:getName() .. " for winning " .. item:getName() .. " from the roulette!", MESSAGE_EVENT_ADVANCE)
    end
end

local function roulette(playerId, leverPosition, spinTimeRemaining, spinDelay)
    local player = Player(playerId)
    if not player then
        resetLever(leverPosition)
        return
    end

    local newItemInfo = chanceNewReward()
    updateRoulette(newItemInfo)

    if spinTimeRemaining > 0 then
        spinDelay = spinDelay + config.rouletteOptions.spinSlowdownRamping
        addEvent(roulette, spinDelay, playerId, leverPosition, spinTimeRemaining - (spinDelay - config.rouletteOptions.spinSlowdownRamping), spinDelay)
        return
    end

    initiateReward(leverPosition, 0)
    rewardPlayer(playerId, leverPosition)
end

local roulettePackages = {
    {spins = 1, cost = 1, discount = 0},
    {spins = 11, cost = 10, discount = 9}, -- 1 free spin
    {spins = 120, cost = 100, discount = 17} -- 20 free spins (17% discount)
}

local function executeRouletteSpin(playerId, leverPosition, spinsRemaining)
    local player = Player(playerId)
    if not player then
        resetLever(leverPosition)
        return
    end

    if spinsRemaining <= 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All roulette spins completed!")
        player:kv():set(config.rouletteOptions.rouletteStorage, -1)
        player:setMoveLocked(false)
        resetLever(leverPosition)
        return
    end

    clearRoulette()
    chancedItems = {}

    local spinTimeRemaining = math.random((config.rouletteOptions.spinTime.min * 1000), (config.rouletteOptions.spinTime.max * 1000))
    
    -- Callback after single spin finishes
    local function onSpinComplete()
        addEvent(function()
            executeRouletteSpin(playerId, leverPosition, spinsRemaining - 1)
        end, 1000) -- 1 second delay between spins
    end

    -- Modified roulette function for batch processing
    local function batchRoulette(pId, levPos, spinTime, spinDel)
        local p = Player(pId)
        if not p then
            resetLever(levPos)
            return
        end

        local newItemInfo = chanceNewReward()
        updateRoulette(newItemInfo)

        if spinTime > 0 then
            spinDel = spinDel + config.rouletteOptions.spinSlowdownRamping
            addEvent(batchRoulette, spinDel, pId, levPos, spinTime - (spinDel - config.rouletteOptions.spinSlowdownRamping), spinDel)
            return
        end

        initiateReward(levPos, 0)
        rewardPlayer(pId, levPos)
        onSpinComplete()
    end

    batchRoulette(playerId, leverPosition, spinTimeRemaining, 100)
end

local function showRoulettePackageModal(player, leverPosition)
    local tokenCount = player:getItemCount(config.playItem.itemId)
    local itemName = ItemType(config.playItem.itemId):getName()
    
    local message = string.format("You have: %d %s(s)\n\nSelect your package:", tokenCount, itemName)
    
    local modal = ModalWindow({
        title = "Roulette Packages",
        message = message,
    })
    
    -- Add choices for each package
    for i, package in ipairs(roulettePackages) do
        local savings = ""
        if package.discount > 0 then
            savings = string.format(" (Save %d%%!)", package.discount)
        end
        local choiceText = string.format("%d Spins = %d %s(s)%s", package.spins, package.cost, itemName, savings)
        modal:addChoice(choiceText)
    end
    
    -- Add OK button with the main logic
    modal:addButton("OK", function(player, button, choice)
        if not choice or choice.id < 1 or choice.id > #roulettePackages then
            player:sendTextMessage(MESSAGE_FAILURE, "Please select a package.")
            return true
        end
        
        local selectedPackage = roulettePackages[choice.id]
        local currentTokens = player:getItemCount(config.playItem.itemId)
        
        if currentTokens < selectedPackage.cost then
            player:sendTextMessage(MESSAGE_FAILURE, string.format("You need %d %s(s) but only have %d.", selectedPackage.cost, itemName, currentTokens))
            return true
        end
        
        -- Get lever and transform it
        local lever = Tile(leverPosition):getItemById(config.lever.left)
        if not lever then
            player:sendTextMessage(MESSAGE_FAILURE, "Error: Lever not found.")
            return true
        end
        
        -- Deduct tokens and start roulette
        player:removeItem(config.playItem.itemId, selectedPackage.cost)
        player:kv():set(config.rouletteOptions.rouletteStorage, 1)
        player:setMoveLocked(true)
        
        lever:transform(config.lever.right)
        
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Starting %d roulette spin(s)!", selectedPackage.spins))
        
        executeRouletteSpin(player:getId(), leverPosition, selectedPackage.spins)
        
        return true
    end)
    
    modal:addButton("Cancel", function(player, button, choice)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Roulette cancelled.")
        return true
    end)
    
    modal:setDefaultEnterButton(1) -- OK
    modal:setDefaultEscapeButton(2) -- Cancel
    
    modal:sendToPlayer(player)
    return true
end

local casinoRoulette = Action()

function casinoRoulette.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == config.lever.right then
        player:sendTextMessage(MESSAGE_FAILURE, "Casino Roulette is currently in progress. Please wait.")
        return true
    end

    if player:kv():get(config.rouletteOptions.rouletteStorage) == 1 then
        player:sendTextMessage(MESSAGE_FAILURE, "You already have an active roulette session.")
        return true
    end

    showRoulettePackageModal(player, toPosition)
    return true
end

casinoRoulette:uid(config.uniqueId)
casinoRoulette:register()

local disableMovingItemsToRoulettePositions = EventCallback

disableMovingItemsToRoulettePositions.onMoveItem = function(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
    for v, k in pairs(config.roulettePositions) do
        if toPosition == k then
            return false
        end
    end
    return true
end

disableMovingItemsToRoulettePositions:register()

local rouletteLogout = CreatureEvent("Roulette Logout")

function rouletteLogout.onLogout(player)
    if player:kv():get(config.rouletteOptions.rouletteStorage) == 1 then
        player:sendTextMessage(MESSAGE_FAILURE, "You cannot disconnect while using roulette!")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end
    return true
end

rouletteLogout:register()