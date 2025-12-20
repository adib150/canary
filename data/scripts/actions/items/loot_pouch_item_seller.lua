-- rest of config (item prices) is under function, paste there your items list from npc
local config = {
    price_percent = 80, -- how many % of shop price player receive when sell by 'item seller'
    cash_to_bank = false, -- send money to bank, not add to player BP
    npc_files = { -- List of NPC files to load items from
        "data-otservbr-global/npc/ishina.lua",
        "data-otservbr-global/npc/tamoril.lua",
        "data-otservbr-global/npc/yasir.lua",
        "data-otservbr-global/npc/tarun.lua",
        "data-otservbr-global/npc/esrik.lua",
        "data-otservbr-global/npc/telas.lua",
        "data-otservbr-global/npc/haroun.lua",
        "data-otservbr-global/npc/alesar.lua",
        "data-otservbr-global/npc/nah_bob.lua",
        "data-otservbr-global/npc/yaman.lua",
        "data-otservbr-global/npc/haroun.lua",
        "data-otservbr-global/npc/rock_in_a_hard_place.lua",
        "data-otservbr-global/npc/ulrik.lua",
        "data-otservbr-global/npc/shanar.lua",
        "data-otservbr-global/npc/rachel.lua",
        "data-otservbr-global/npc/h.l..lua",
        "data-otservbr-global/npc/rashid.lua",
        "data-otservbr-global/npc/loot_seller.lua",
        -- Add more NPCs here as needed:
        -- "data-otservbr-global/npc/frans.lua",
        -- "data-otservbr-global/npc/xodet.lua",
    }
}

-- Function to load items from NPC file
local function loadItemsFromNPC(filePath)
    local items = {}
    local file = io.open(filePath, "r")
    if not file then
        print("[Warning] Could not open NPC file: " .. filePath)
        return items
    end
    
    local content = file:read("*all")
    file:close()
    
    -- Extract itemsTable from the file
    -- Pattern matches: { itemName = "X", clientId = Y, sell = Z }
    for itemName, clientId, sellPrice in content:gmatch('itemName%s*=%s*"([^"]+)"%s*,%s*clientId%s*=%s*(%d+)%s*,%s*sell%s*=%s*(%d+)') do
        local id = tonumber(clientId)
        local price = tonumber(sellPrice)
        if id and price then
            items[id] = price
        end
    end
    
    return items
end

-- Load all items from specified NPCs
local shopItems = {}
for _, npcFile in ipairs(config.npc_files) do
    local npcItems = loadItemsFromNPC(npcFile)
    for itemId, price in pairs(npcItems) do
        -- If item already exists, keep the higher price
        if not shopItems[itemId] or shopItems[itemId] < price then
            shopItems[itemId] = price
        end
    end
end

local itemCount = 0
for _ in pairs(shopItems) do itemCount = itemCount + 1 end
print("[Loot Pouch Seller] Loaded " .. itemCount .. " items from " .. #config.npc_files .. " NPC(s)")

local shopItems = shopItems
local itemLootSeller = Action()

local function sellItemsFromContainer(player, container, totalValue, itemsSold)
    totalValue = totalValue or 0
    itemsSold = itemsSold or {}
    
    for i = container:getSize() - 1, 0, -1 do
        local item = container:getItem(i)
        if item then
            local itemId = item:getId()
            
            -- Check if item is a container, recursively sell items inside
            if item:isContainer() then
                totalValue, itemsSold = sellItemsFromContainer(player, Container(item.uid), totalValue, itemsSold)
            else
                -- Check if item is sellable - with proper nil checks
                if itemId and shopItems[itemId] then
                    -- Additional safety checks
                    local uniqueId = item:getUniqueId()
                    local actionId = item:getActionId()
                    
                    if uniqueId and actionId and uniqueId >= 65535 and actionId == 0 then
                        local itemType = ItemType(itemId)
                        if itemType then
                            local itemCount = 1
                            if itemType:isStackable() then
                                itemCount = item:getCount() or 1
                            end
                            
                            local itemPrice = shopItems[itemId]
                            local itemValue = math.ceil(itemPrice * itemCount / 100 * config.price_percent)
                            
                            if itemValue > 0 then
                                local itemName = item:getName()
                                
                                -- Ensure itemName is valid
                                if itemName and type(itemName) == "string" and itemName ~= "" then
                                    -- Track sold items
                                    if not itemsSold[itemName] then
                                        itemsSold[itemName] = {count = 0, value = 0}
                                    end
                                    itemsSold[itemName].count = itemsSold[itemName].count + itemCount
                                    itemsSold[itemName].value = itemsSold[itemName].value + itemValue
                                    
                                    totalValue = totalValue + itemValue
                                    item:remove()
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return totalValue, itemsSold
end

function itemLootSeller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Function to recursively search for loot pouch in containers
    local function findLootPouchInContainer(container, maxDepth, currentDepth)
        currentDepth = currentDepth or 0
        if currentDepth >= (maxDepth or 3) then
            return nil
        end
        
        for i = 0, container:getSize() - 1 do
            local containerItem = container:getItem(i)
            if containerItem then
                if containerItem:getId() == 23721 then
                    return containerItem
                end
                -- Search nested containers
                if containerItem:isContainer() then
                    local found = findLootPouchInContainer(Container(containerItem.uid), maxDepth, currentDepth + 1)
                    if found then
                        return found
                    end
                end
            end
        end
        return nil
    end
    
    -- Find loot pouch in player's inventory (equipment slots and backpacks)
    local lootPouch = nil
    for slot = CONST_SLOT_FIRST, CONST_SLOT_LAST do
        local slotItem = player:getSlotItem(slot)
        if slotItem then
            if slotItem:getId() == 23721 then
                lootPouch = slotItem
                break
            end
            -- Search inside containers
            if slotItem:isContainer() then
                lootPouch = findLootPouchInContainer(Container(slotItem.uid), 5)
                if lootPouch then
                    break
                end
            end
        end
    end
    
    -- If not found in inventory, check Store Inbox
    if not lootPouch then
        local storeInbox = player:getStoreInbox()
        if storeInbox then
            lootPouch = findLootPouchInContainer(storeInbox, 5)
        end
    end
    
    if not lootPouch then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need a loot pouch (ID: 23721) in your inventory or Store Inbox.')
        return true
    end
    
    if not lootPouch:isContainer() then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is not a valid container.')
        return true
    end
    
    local container = Container(lootPouch.uid)
    if container:getSize() == 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The loot pouch is empty.')
        return true
    end
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Selling items from loot pouch...')
    local totalValue, itemsSold = sellItemsFromContainer(player, container, 0, {})
        
        if totalValue > 0 then
            fromPosition:sendMagicEffect(CONST_ME_GIFT_WRAPS)
            
            local message = 'You sold items for ' .. totalValue .. ' gold coins.'
            if config.cash_to_bank then
                player:setBankBalance(player:getBankBalance() + totalValue)
                message = message .. ' Money was added to your bank account.'
            else
                player:addMoney(totalValue)
            end
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
            
            -- Optional: show detailed breakdown (only if there are items)
            local detailsTable = {}
            for itemName, data in pairs(itemsSold) do
                if itemName and data.count and data.value then
                    table.insert(detailsTable, data.count .. 'x ' .. itemName .. ' (' .. data.value .. 'gp)')
                end
            end
            
            if #detailsTable > 0 then
                local details = 'Sold: ' .. table.concat(detailsTable, ', ')
                if #details <= 255 then -- Ensure message isn't too long
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, details)
                end
            end
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'No sellable items found in the loot pouch.')
        end
        
        return true
end

itemLootSeller:id(10290)
itemLootSeller:register()
