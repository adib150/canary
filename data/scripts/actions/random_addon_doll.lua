local actionId = 8000
local itemDollId = 50343

local randOutfit = Action("RandomOutfitForNewPlayers")

-- Embedded authoritative looktypes list (copied from add_addon talkaction)
local looktypes = {
    -- Female Outfits
    136,137,138,139,140,141,142,147,148,149,150,155,156,157,158,252,269,270,279,288,324,329,336,366,431,433,464,466,471,513,514,542,575,578,618,620,632,635,636,664,666,683,694,696,698,724,732,745,749,759,845,852,874,885,900,909,929,956,958,963,965,967,969,971,973,975,1020,1024,1043,1050,1057,1070,1095,1103,1128,1147,1162,1174,1187,1203,1205,1207,1211,1244,1246,1252,1271,1280,1283,1289,1293,1323,1332,1339,1372,1383,1385,1387,1416,1437,1445,1450,1456,1461,1490,1501,1569,1576,1582,1598,1613,1619,1663,1676,1681,1714,1723,1726,1746,1775,1777,
    -- Male Outfits
    1714,1723,1726,1746,1775,1777,128,129,130,131,132,133,134,143,144,145,146,151,152,153,154,251,268,273,278,289,325,328,335,367,430,432,463,465,472,512,516,541,574,577,610,619,633,634,637,665,667,684,695,697,699,725,733,746,750,760,846,853,873,884,899,908,931,955,957,962,964,966,968,970,972,974,1021,1023,1042,1051,1056,1069,1094,1102,1127,1146,1161,1173,1186,1202,1204,1206,1210,1243,1245,1251,1270,1279,1282,1288,1292,1322,1331,1338,1371,1382,1384,1386,1415,1436,1444,1449,1457,1460,1489,1500,1568,1575,1581,1597,1612,1618,1662,1675,1680,1713,1722,1725,1745,1774,1776
}

-- Build sex-filtered looktype lists by reading `data/XML/outfits.xml` (type="0" = female, "1" = male)
local femaleLooktypes = {}
local maleLooktypes = {}
do
    local pathsToTry = {
        '/home/adib/canary/data/XML/outfits.xml',
        'data/XML/outfits.xml',
        './data/XML/outfits.xml'
    }
    local ok, f = nil, nil
    for _, p in ipairs(pathsToTry) do
        ok, f = pcall(io.open, p, 'r')
        if ok and f then
            break
        end
    end
    if ok and f then
        local femaleMap = {}
        local maleMap = {}
        for line in f:lines() do
            local t, look = line:match('type="(%d+)"%s+looktype="(%d+)"')
            if t and look then
                local num = tonumber(look)
                if t == '0' then
                    femaleMap[num] = true
                else
                    maleMap[num] = true
                end
            end
        end
        f:close()

        for _, look in ipairs(looktypes) do
            if femaleMap[look] then
                table.insert(femaleLooktypes, look)
            elseif maleMap[look] then
                table.insert(maleLooktypes, look)
            end
        end
    else
        -- Fallback: split by index parity heuristic if XML unavailable
        for i, look in ipairs(looktypes) do
            if i % 2 == 1 then
                table.insert(femaleLooktypes, look)
            else
                table.insert(maleLooktypes, look)
            end
        end
    end
end

-- Helper: choose the right looktypes array according to player sex
local function looktypesForPlayer(player)
    local sex = player and player.getSex and player:getSex() or PLAYERSEX_MALE
    if sex == PLAYERSEX_FEMALE then
        return femaleLooktypes
    end
    return maleLooktypes
end

-- Outfit names mapping (from data/XML/outfits.xml)
local outfitNames = {
    [136] = "Citizen", [137] = "Hunter", [138] = "Mage", [139] = "Knight", [140] = "Noblewoman", [141] = "Summoner", [142] = "Warrior",
    [147] = "Barbarian", [148] = "Druid", [149] = "Wizard", [150] = "Oriental", [155] = "Pirate", [156] = "Assassin", [157] = "Beggar",
    [158] = "Shaman", [252] = "Norsewoman", [269] = "Nightmare", [270] = "Jester", [279] = "Brotherhood", [288] = "Demon Hunter", [324] = "Yalaharian",
    [329] = "Newly Wed", [336] = "Warmaster", [366] = "Wayfarer", [431] = "Afflicted", [433] = "Elementalist", [464] = "Deepling", [466] = "Insectoid",
    [471] = "Entrepreneur", [513] = "Crystal Warlord", [514] = "Soil Guardian", [542] = "Demon", [575] = "Cave Explorer", [578] = "Dream Warden",
    [618] = "Glooth Engineer", [620] = "Jersey", [632] = "Champion", [635] = "Conjurer", [636] = "Beastmaster", [664] = "Chaos Acolyte",
    [666] = "Death Herald", [683] = "Ranger", [694] = "Ceremonial Garb", [696] = "Puppeteer", [698] = "Spirit Caller", [724] = "Evoker",
    [732] = "Seaweaver", [745] = "Recruiter", [749] = "Sea Dog", [759] = "Royal Pumpkin", [845] = "Rift Warrior", [852] = "Winter Warden",
    [874] = "Philosopher", [885] = "Arena Champion", [900] = "Lupine Warden", [909] = "Grove Keeper", [929] = "Festive", [956] = "Pharaoh",
    [958] = "Trophy Hunter", [963] = "Retro Warrior", [965] = "Retro Summoner", [967] = "Retro Noblewoman", [969] = "Retro Mage", [971] = "Retro Knight",
    [973] = "Retro Hunter", [975] = "Retro Citizen", [1020] = "Herbalist", [1024] = "Sun Priest", [1043] = "Makeshift Warrior", [1050] = "Siege Master",
    [1057] = "Mercenary", [1070] = "Battle Mage", [1095] = "Discoverer", [1103] = "Sinister Archer", [1128] = "Pumpkin Mummy", [1147] = "Dream Warrior",
    [1162] = "Percht Raider", [1174] = "Owl Keeper", [1187] = "Guidon Bearer", [1203] = "Void Master", [1205] = "Veteran Paladin", [1207] = "Lion of War",
    [1211] = "Golden", [1244] = "Hand of the Inquisition", [1246] = "Breezy Garb", [1252] = "Orcsoberfest Garb", [1271] = "Poltergeist", [1280] = "Herder",
    [1283] = "Falconer", [1289] = "Dragon Slayer", [1293] = "Trailblazer", [1323] = "Revenant", [1332] = "Jouster", [1339] = "Moth Cape", [1372] = "Rascoohan",
    [1383] = "Merry Garb", [1385] = "Rune Master", [1387] = "Citizen of Issavi", [1416] = "Forest Warden", [1437] = "Royal Bounacean Advisor", [1445] = "Dragon Knight",
    [1450] = "Arbalester", [1456] = "Royal Costume", [1461] = "Formal Dress", [1490] = "Ghost Blade", [1501] = "Nordic Chieftain", [1569] = "Fire-Fighter",
    [1576] = "Fencer", [1582] = "Shadowlotus Disciple", [1598] = "Ancient Aucar", [1613] = "Frost Tracer", [1619] = "Armoured Archer", [1663] = "Decaying Defender",
    [1676] = "Darklight Evoker", [1681] = "Flamefury Mage", [1714] = "Doom Knight", [1723] = "Draccoon Herald", [1726] = "Celestial Avenger", [1746] = "Blade Dancer",
    [1775] = "Rootwalker", [1777] = "Beekeeper", [1808] = "Fiend Slayer", [1832] = "Winged Druid",
    -- Male names
    [128] = "Citizen", [129] = "Hunter", [130] = "Mage", [131] = "Knight", [132] = "Nobleman", [133] = "Summoner", [134] = "Warrior",
    [143] = "Barbarian", [144] = "Druid", [145] = "Wizard", [146] = "Oriental", [151] = "Pirate", [152] = "Assassin", [153] = "Beggar",
    [154] = "Shaman", [251] = "Norseman", [268] = "Nightmare", [273] = "Jester", [278] = "Brotherhood", [289] = "Demon Hunter", [325] = "Yalaharian",
    [328] = "Newly Wed", [335] = "Warmaster", [367] = "Wayfarer", [430] = "Afflicted", [432] = "Elementalist", [463] = "Deepling", [465] = "Insectoid",
    [472] = "Entrepreneur", [512] = "Crystal Warlord", [516] = "Soil Guardian", [541] = "Demon", [574] = "Cave Explorer", [577] = "Dream Warden",
    [610] = "Glooth Engineer", [619] = "Jersey", [633] = "Champion", [634] = "Conjurer", [637] = "Beastmaster", [665] = "Chaos Acolyte",
    [667] = "Death Herald", [684] = "Ranger", [695] = "Ceremonial Garb", [697] = "Puppeteer", [699] = "Spirit Caller", [725] = "Evoker",
    [733] = "Seaweaver", [746] = "Recruiter", [750] = "Sea Dog", [760] = "Royal Pumpkin", [846] = "Rift Warrior", [853] = "Winter Warden",
    [873] = "Philosopher", [884] = "Arena Champion", [899] = "Lupine Warden", [908] = "Grove Keeper", [931] = "Festive", [955] = "Pharaoh",
    [957] = "Trophy Hunter", [962] = "Retro Warrior", [964] = "Retro Summoner", [966] = "Retro Nobleman", [968] = "Retro Mage", [970] = "Retro Knight",
    [972] = "Retro Hunter", [974] = "Retro Citizen", [1021] = "Herbalist", [1023] = "Sun Priest", [1042] = "Makeshift Warrior", [1051] = "Siege Master",
    [1056] = "Mercenary", [1069] = "Battle Mage", [1094] = "Discoverer", [1102] = "Sinister Archer", [1127] = "Pumpkin Mummy", [1146] = "Dream Warrior",
    [1161] = "Percht Raider", [1173] = "Owl Keeper", [1186] = "Guidon Bearer", [1202] = "Void Master", [1204] = "Veteran Paladin", [1206] = "Lion of War",
    [1210] = "Golden", [1243] = "Hand of the Inquisition", [1245] = "Breezy Garb", [1251] = "Orcsoberfest Garb", [1270] = "Poltergeist", [1279] = "Herder",
    [1282] = "Falconer", [1288] = "Dragon Slayer", [1292] = "Trailblazer", [1322] = "Revenant", [1331] = "Jouster", [1338] = "Moth Cape", [1371] = "Rascoohan",
    [1382] = "Merry Garb", [1384] = "Rune Master", [1386] = "Citizen of Issavi", [1415] = "Forest Warden", [1436] = "Royal Bounacean Advisor", [1444] = "Dragon Knight",
    [1449] = "Arbalester", [1457] = "Royal Costume", [1460] = "Formal Dress", [1489] = "Ghost Blade", [1500] = "Nordic Chieftain", [1568] = "Fire-Fighter",
    [1575] = "Fencer", [1581] = "Shadowlotus Disciple", [1597] = "Ancient Aucar", [1612] = "Frost Tracer", [1618] = "Armoured Archer", [1662] = "Decaying Defender",
    [1675] = "Darklight Evoker", [1680] = "Flamefury Mage", [1713] = "Doom Knight", [1722] = "Draccoon Herald", [1725] = "Celestial Avenger", [1745] = "Blade Dancer",
    [1774] = "Rootwalker", [1776] = "Beekeeper",
}

-- Helper to pick a random looktype the player owns and that is missing the chosen addon
local function pickMissingAddonLooktype(player, looktypes, addon)
    if not looktypes or #looktypes == 0 then
        return nil
    end

    -- Try up to N times randomly, or scan once to find any valid candidate
    local tries = math.min(#looktypes, 50)
    for i = 1, tries do
        local look = looktypes[math.random(1, #looktypes)]
        if player:hasOutfit(look) and not player:hasOutfit(look, addon) then
            return look
        end
    end

    -- Fallback: linear scan
    for _, look in ipairs(looktypes) do
        if player:hasOutfit(look) and not player:hasOutfit(look, addon) then
            return look
        end
    end

    return nil
end

-- Helper to pick a random looktype the player does NOT own (to grant the base outfit)
local function pickMissingOutfitLooktype(player, looktypes)
    if not looktypes or #looktypes == 0 then
        return nil
    end

    local tries = math.min(#looktypes, 50)
    for i = 1, tries do
        local look = looktypes[math.random(1, #looktypes)]
        if not player:hasOutfit(look) then
            return look
        end
    end

    for _, look in ipairs(looktypes) do
        if not player:hasOutfit(look) then
            return look
        end
    end

    return nil
end

function randOutfit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Randomly prefer granting a base outfit or an addon (50/50)
    local tryOutfitFirst = math.random(1, 2) == 1

    local function sendNoEligibleMessage(playerLooktypes)
        -- If player owns any outfits, inform they already have both addons for one of them
        for _, ownedLook in ipairs(playerLooktypes) do
            if player:hasOutfit(ownedLook) then
                local name = outfitNames[ownedLook] or tostring(ownedLook)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You already have all addons and outfits.", name))
                return
            end
        end
        -- Player doesn't own any outfits from the list
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have any outfits that can receive a new addon.")
    end

    local playerLooktypes = looktypesForPlayer(player)

    if tryOutfitFirst then
        -- Try to give a missing base outfit first
        local missingOutfit = pickMissingOutfitLooktype(player, playerLooktypes)
        if missingOutfit then
            local ok = player:addOutfit(missingOutfit)
            if ok then
                local name = outfitNames[missingOutfit] or tostring(missingOutfit)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received the outfit: %s.", name))
                item:remove(1)
                return true
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Something went wrong while granting the outfit.")
                return true
            end
        end

        -- No missing outfits; try to grant an addon as fallback
        local addon = math.random(1, 2)
        local look = pickMissingAddonLooktype(player, playerLooktypes, addon)
        if not look then
            -- try the other addon
            addon = 3 - addon
            look = pickMissingAddonLooktype(player, playerLooktypes, addon)
        end
        if not look then
            sendNoEligibleMessage(playerLooktypes)
            return true
        end

        local ok = player:addOutfitAddon(look, addon)
        if ok then
            local name = outfitNames[look] or tostring(look)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You obtained addon (%d) for outfit %s.", addon, name))
            item:remove(1)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Something went wrong while granting the addon.")
        end
        return true
    else
        -- Try addon first
        local addon = math.random(1, 2)
        local look = pickMissingAddonLooktype(player, playerLooktypes, addon)
        if not look then
            addon = 3 - addon
            look = pickMissingAddonLooktype(player, playerLooktypes, addon)
        end
        if look then
            local ok = player:addOutfitAddon(look, addon)
            if ok then
                local name = outfitNames[look] or tostring(look)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You obtained addon (%d) for outfit %s.", addon, name))
                item:remove(1)
                return true
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Something went wrong while granting the addon.")
                return true
            end
        end

        -- No addons eligible; try to grant a missing outfit
        local missingOutfit = pickMissingOutfitLooktype(player, playerLooktypes)
        if missingOutfit then
            local ok = player:addOutfit(missingOutfit)
            if ok then
                local name = outfitNames[missingOutfit] or tostring(missingOutfit)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received the outfit: %s.", name))
                item:remove(1)
                return true
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Something went wrong while granting the outfit.")
                return true
            end
        end

        sendNoEligibleMessage()
        return true
    end
end

randOutfit:id(itemDollId)
randOutfit:aid(actionId)
randOutfit:register()