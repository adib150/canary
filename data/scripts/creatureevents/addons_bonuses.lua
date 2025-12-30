-- CONDITION_PARAM_SKILL_MELEE = 2
-- CONDITION_PARAM_SKILL_SHIELD = 2
-- CONDITION_PARAM_SKILL_FISHING = 2
-- CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE = 50
-- CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT = 50
-- CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT = 50
-- CONDITION_PARAM_STAT_MAXHITPOINTS = 50
-- CONDITION_PARAM_STAT_MAXMANAPOINTS = 50


AddonBonuses = {
	{ looktypes = { 136, 128 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Citizen addons
	{ looktypes = { 137, 129 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Hunter addons
	{ looktypes = { 138, 130 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Mage addons
	{ looktypes = { 139, 131 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Knight addons
	{ looktypes = { 140, 132 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Noblewoman/Nobleman addons
	{ looktypes = { 141, 133 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Summoner addons
	{ looktypes = { 142, 134 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Warrior addons
	{ looktypes = { 147, 143 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Barbarian addons
	{ looktypes = { 148, 144 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Druid addons
	{ looktypes = { 149, 145 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Wizard addons
	{ looktypes = { 150, 146 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Oriental addons
	{ looktypes = { 155, 151 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Pirate addons
	{ looktypes = { 156, 152 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Assassin addons
	{ looktypes = { 157, 153 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Beggar addons
	{ looktypes = { 158, 154 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Shaman addons
	{ looktypes = { 252, 251 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Norsewoman/Norseman addons
	{ looktypes = { 269, 268 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Nightmare addons
	{ looktypes = { 270, 273 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Jester addons
	{ looktypes = { 279, 278 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Brotherhood addons
	{ looktypes = { 288, 289 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Demon Hunter addons
	{ looktypes = { 324, 325 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Yalaharian addons
	{ looktypes = { 329, 328 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Newly Wed addons
	{ looktypes = { 336, 335 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Warmaster addons
	{ looktypes = { 366, 367 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Wayfarer addons
	{ looktypes = { 431, 430 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Afflicted addons
	{ looktypes = { 433, 432 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Elementalist addons
	{ looktypes = { 464, 463 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Deepling addons
	{ looktypes = { 466, 465 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Insectoid addons
	{ looktypes = { 471, 472 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Entrepreneur addons
	{ looktypes = { 513, 512 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Crystal Warlord addons
	{ looktypes = { 514, 516 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Soil Guardian addons
	{ looktypes = { 542, 541 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Demon addons
	{ looktypes = { 575, 574 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Cave Explorer addons
	{ looktypes = { 578, 577 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Dream Warden addons
	{ looktypes = { 618, 610 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Glooth Engineer addons
	{ looktypes = { 620, 619 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Jersey addons
	{ looktypes = { 632, 633 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Champion addons
	{ looktypes = { 635, 634 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Conjurer addons
	{ looktypes = { 636, 637 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Beastmaster addons
	{ looktypes = { 664, 665 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Chaos Acolyte addons
	{ looktypes = { 666, 667 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Death Herald addons
	{ looktypes = { 683, 684 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Ranger addons
	{ looktypes = { 694, 695 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Ceremonial Garb addons
	{ looktypes = { 696, 697 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Puppeteer addons
	{ looktypes = { 698, 699 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Spirit Caller addons
	{ looktypes = { 724, 725 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Evoker addons
	{ looktypes = { 732, 733 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Seaweaver addons
	{ looktypes = { 745, 746 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Recruiter addons
	{ looktypes = { 749, 750 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Sea Dog addons
	{ looktypes = { 759, 760 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Royal Pumpkin addons
	{ looktypes = { 845, 846 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Rift Warrior addons
	{ looktypes = { 852, 853 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Winter Warden addons
	{ looktypes = { 874, 873 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Philosopher addons
	{ looktypes = { 885, 884 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Arena Champion addons
	{ looktypes = { 900, 899 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Lupine Warden addons
	{ looktypes = { 909, 908 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Grove Keeper addons
	{ looktypes = { 929, 931 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Festive addons
	{ looktypes = { 956, 955 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Pharaoh addons
	{ looktypes = { 958, 957 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Trophy Hunter addons
	{ looktypes = { 963, 962 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Retro Warrior addons
	{ looktypes = { 965, 964 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Retro Summoner addons
	{ looktypes = { 967, 966 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Retro Noblewoman/Nobleman addons
	{ looktypes = { 969, 968 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Retro Mage addons
	{ looktypes = { 971, 970 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Retro Knight addons
	{ looktypes = { 973, 972 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Retro Hunter addons
	{ looktypes = { 975, 974 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Retro Citizen addons
	{ looktypes = { 1020, 1021 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Herbalist addons
	{ looktypes = { 1024, 1023 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Sun Priest addons
	{ looktypes = { 1043, 1042 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Makeshift Warrior addons
	{ looktypes = { 1050, 1051 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Siege Master addons
	{ looktypes = { 1057, 1056 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Mercenary addons
	{ looktypes = { 1070, 1069 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Battle Mage addons
	{ looktypes = { 1095, 1094 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Discoverer addons
	{ looktypes = { 1103, 1102 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Sinister Archer addons
	{ looktypes = { 1128, 1127 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Pumpkin Mummy addons
	{ looktypes = { 1147, 1146 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Dream Warrior addons
	{ looktypes = { 1162, 1161 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Percht Raider addons
	{ looktypes = { 1174, 1173 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Owl Keeper addons
	{ looktypes = { 1187, 1186 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Guidon Bearer addons
	{ looktypes = { 1203, 1202 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Void Master addons
	{ looktypes = { 1205, 1204 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Veteran Paladin addons
	{ looktypes = { 1207, 1206 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Lion of War addons
	{ looktypes = { 1211, 1210 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Golden addons
	{ looktypes = { 1244, 1243 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Hand of the Inquisition addons
	{ looktypes = { 1246, 1245 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Breezy Garb addons
	{ looktypes = { 1252, 1251 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Orcsoberfest Garb addons
	{ looktypes = { 1271, 1270 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Poltergeist addons
	{ looktypes = { 1280, 1279 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Herder addons
	{ looktypes = { 1283, 1282 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Falconer addons
	{ looktypes = { 1289, 1288 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Dragon Slayer addons
	{ looktypes = { 1293, 1292 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Trailblazer addons
	{ looktypes = { 1323, 1322 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Revenant addons
	{ looktypes = { 1332, 1331 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Jouster addons
	{ looktypes = { 1339, 1338 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Moth Cape addons
	{ looktypes = { 1372, 1371 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Rascoohan addons
	{ looktypes = { 1383, 1382 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Merry Garb addons
	{ looktypes = { 1385, 1384 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Rune Master addons
	{ looktypes = { 1387, 1386 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Citizen of Issavi addons
	{ looktypes = { 1416, 1415 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Forest Warden addons
	{ looktypes = { 1437, 1436 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Royal Bounacean Advisor addons
	{ looktypes = { 1445, 1444 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Dragon Knight addons
	{ looktypes = { 1450, 1449 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Arbalester addons
	{ looktypes = { 1456, 1457 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Royal Costume addons
	{ looktypes = { 1461, 1460 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } }, -- Formal Dress addons
	{ looktypes = { 1490, 1489 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Ghost Blade addons
	{ looktypes = { 1501, 1500 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Nordic Chieftain addons
	{ looktypes = { 1569, 1568 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Fire-Fighter addons
	{ looktypes = { 1576, 1575 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Fencer addons
	{ looktypes = { 1582, 1581 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Shadowlotus Disciple addons
	{ looktypes = { 1598, 1597 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Ancient Aucar addons
	{ looktypes = { 1613, 1612 }, bonuses = { [CONDITION_PARAM_SKILL_MELEE] = { value = 2 } } }, -- Frost Tracer addons
	{ looktypes = { 1619, 1618 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Armoured Archer addons
	{ looktypes = { 1663, 1662 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Decaying Defender addons
	{ looktypes = { 1676, 1675 }, bonuses = { [CONDITION_PARAM_SKILL_SHIELD] = { value = 2 } } }, -- Darklight Evoker addons
	{ looktypes = { 1681, 1680 }, bonuses = { [CONDITION_PARAM_SKILL_FISHING] = { value = 2 } } }, -- Flamefury Mage addons
	{ looktypes = { 1714, 1713 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Doom Knight addons
	{ looktypes = { 1723, 1722 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Draccoon Herald addons
	{ looktypes = { 1726, 1725 }, bonuses = { [CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = 50 } } }, -- Celestial Avenger addons
	{ looktypes = { 1746, 1745 }, bonuses = { [CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 50 } } }, -- Blade Dancer addons
	{ looktypes = { 1775, 1774 }, bonuses = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 } } }, -- Rootwalker addons
	{ looktypes = { 1777, 1776 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Beekeeper addons
	{ looktypes = { 1814 }, bonuses = { [CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 } } }, -- Unknown outfit (1814)
	{ looktypes = { 1813 }, bonuses = { [CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = 50 } } } -- Unknown outfit (1813)
}

MountsIds = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 50, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232 }
