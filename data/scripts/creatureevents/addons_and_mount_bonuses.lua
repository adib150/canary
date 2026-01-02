-- CONDITION_PARAM_SKILL_MELEE = 2
-- CONDITION_PARAM_SKILL_SHIELD = 2
-- CONDITION_PARAM_SKILL_FISHING = 2
-- CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE = 50
-- CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT = 50
-- CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT = 50
-- CONDITION_PARAM_STAT_MAXHITPOINTS = 50
-- CONDITION_PARAM_STAT_MAXMANAPOINTS = 50

-- Central variable definitions you can tweak per your requested defaults
VARIABLEHP = 5               -- +5 max HP per full outfit / per mount
VARIABLEMAIN = 0.2           -- +0.2 to main skill
VARIABLECRITCHANCE = 5     -- +0.1 crit chance
VARIABLECRITDAMAGE = 10     -- +0.2 crit damage
VARIABLEMP = 5               -- +5 max MP
VARIABLEMANALEECH = 0.1      -- +0.1 mana leech amount
VARIABLELIFELEECH = 0.1      -- +0.1 life leech amount
VARIABLESHIELD = 0.1         -- +0.1 shield skill


AddonBonuses = {
	{ looktypes = { 136, 128 } }, -- Citizen addons
	{ looktypes = { 137, 129 } }, -- Hunter addons
	{ looktypes = { 138, 130 } }, -- Mage addons
	{ looktypes = { 139, 131 } }, -- Knight addons
	{ looktypes = { 140, 132 } }, -- Noblewoman/Nobleman addons
	{ looktypes = { 141, 133 } }, -- Summoner addons
	{ looktypes = { 142, 134 } }, -- Warrior addons
	{ looktypes = { 147, 143 } }, -- Barbarian addons
	{ looktypes = { 148, 144 } }, -- Druid addons
	{ looktypes = { 149, 145 } }, -- Wizard addons
	{ looktypes = { 150, 146 } }, -- Oriental addons
	{ looktypes = { 155, 151 } }, -- Pirate addons
	{ looktypes = { 156, 152 } }, -- Assassin addons
	{ looktypes = { 157, 153 } }, -- Beggar addons
	{ looktypes = { 158, 154 } }, -- Shaman addons
	{ looktypes = { 252, 251 } }, -- Norsewoman/Norseman addons
	{ looktypes = { 269, 268 } }, -- Nightmare addons
	{ looktypes = { 270, 273 } }, -- Jester addons
	{ looktypes = { 279, 278 } }, -- Brotherhood addons
	{ looktypes = { 288, 289 } }, -- Demon Hunter addons
	{ looktypes = { 324, 325 } }, -- Yalaharian addons
	{ looktypes = { 329, 328 } }, -- Newly Wed addons
	{ looktypes = { 336, 335 } }, -- Warmaster addons
	{ looktypes = { 366, 367 } }, -- Wayfarer addons
	{ looktypes = { 431, 430 } }, -- Afflicted addons
	{ looktypes = { 433, 432 } }, -- Elementalist addons
	{ looktypes = { 464, 463 } }, -- Deepling addons
	{ looktypes = { 466, 465 } }, -- Insectoid addons
	{ looktypes = { 471, 472 } }, -- Entrepreneur addons
	{ looktypes = { 513, 512 } }, -- Crystal Warlord addons
	{ looktypes = { 514, 516 } }, -- Soil Guardian addons
	{ looktypes = { 542, 541 } }, -- Demon addons
	{ looktypes = { 575, 574 } }, -- Cave Explorer addons
	{ looktypes = { 578, 577 } }, -- Dream Warden addons
	{ looktypes = { 618, 610 } }, -- Glooth Engineer addons
	{ looktypes = { 620, 619 } }, -- Jersey addons
	{ looktypes = { 632, 633 } }, -- Champion addons
	{ looktypes = { 635, 634 } }, -- Conjurer addons
	{ looktypes = { 636, 637 } }, -- Beastmaster addons
	{ looktypes = { 664, 665 } }, -- Chaos Acolyte addons
	{ looktypes = { 666, 667 } }, -- Death Herald addons
	{ looktypes = { 683, 684 } }, -- Ranger addons
	{ looktypes = { 694, 695 } }, -- Ceremonial Garb addons
	{ looktypes = { 696, 697 } }, -- Puppeteer addons
	{ looktypes = { 698, 699 } }, -- Spirit Caller addons
	{ looktypes = { 724, 725 } }, -- Evoker addons
	{ looktypes = { 732, 733 } }, -- Seaweaver addons
	{ looktypes = { 745, 746 } }, -- Recruiter addons
	{ looktypes = { 749, 750 } }, -- Sea Dog addons
	{ looktypes = { 759, 760 } }, -- Royal Pumpkin addons
	{ looktypes = { 845, 846 } }, -- Rift Warrior addons
	{ looktypes = { 852, 853 } }, -- Winter Warden addons
	{ looktypes = { 874, 873 } }, -- Philosopher addons
	{ looktypes = { 885, 884 } }, -- Arena Champion addons
	{ looktypes = { 900, 899 } }, -- Lupine Warden addons
	{ looktypes = { 909, 908 } }, -- Grove Keeper addons
	{ looktypes = { 929, 931 } }, -- Festive addons
	{ looktypes = { 956, 955 } }, -- Pharaoh addons
	{ looktypes = { 958, 957 } }, -- Trophy Hunter addons
	{ looktypes = { 963, 962 } }, -- Retro Warrior addons
	{ looktypes = { 965, 964 } }, -- Retro Summoner addons
	{ looktypes = { 967, 966 } }, -- Retro Noblewoman/Nobleman addons
	{ looktypes = { 969, 968 } }, -- Retro Mage addons
	{ looktypes = { 971, 970 } }, -- Retro Knight addons
	{ looktypes = { 973, 972 } }, -- Retro Hunter addons
	{ looktypes = { 975, 974 } }, -- Retro Citizen addons
	{ looktypes = { 1020, 1021 } }, -- Herbalist addons
	{ looktypes = { 1024, 1023 } }, -- Sun Priest addons
	{ looktypes = { 1043, 1042 } }, -- Makeshift Warrior addons
	{ looktypes = { 1050, 1051 } }, -- Siege Master addons
	{ looktypes = { 1057, 1056 } }, -- Mercenary addons
	{ looktypes = { 1070, 1069 } }, -- Battle Mage addons
	{ looktypes = { 1095, 1094 } }, -- Discoverer addons
	{ looktypes = { 1103, 1102 } }, -- Sinister Archer addons
	{ looktypes = { 1128, 1127 } }, -- Pumpkin Mummy addons
	{ looktypes = { 1147, 1146 } }, -- Dream Warrior addons
	{ looktypes = { 1162, 1161 } }, -- Percht Raider addons
	{ looktypes = { 1174, 1173 } }, -- Owl Keeper addons
	{ looktypes = { 1187, 1186 } }, -- Guidon Bearer addons
	{ looktypes = { 1203, 1202 } }, -- Void Master addons
	{ looktypes = { 1205, 1204 } }, -- Veteran Paladin addons
	{ looktypes = { 1207, 1206 } }, -- Lion of War addons
	{ looktypes = { 1211, 1210 } }, -- Golden addons
	{ looktypes = { 1244, 1243 } }, -- Hand of the Inquisition addons
	{ looktypes = { 1246, 1245 } }, -- Breezy Garb addons
	{ looktypes = { 1252, 1251 } }, -- Orcsoberfest Garb addons
	{ looktypes = { 1271, 1270 } }, -- Poltergeist addons
    { looktypes = { 1280, 1279 } }, -- Herder addons
    { looktypes = { 1283, 1282 } }, -- Falconer addons
    { looktypes = { 1289, 1288 } }, -- Dragon Slayer addons
    { looktypes = { 1293, 1292 } }, -- Trailblazer addons
    { looktypes = { 1323, 1322 } }, -- Revenant addons
    { looktypes = { 1332, 1331 } }, -- Jouster addons
    { looktypes = { 1339, 1338 } }, -- Moth Cape addons
    { looktypes = { 1372, 1371 } }, -- Rascoohan addons
    { looktypes = { 1383, 1382 } }, -- Merry Garb addons
    { looktypes = { 1385, 1384 } }, -- Rune Master addons
    { looktypes = { 1387, 1386 } }, -- Citizen of Issavi addons
    { looktypes = { 1416, 1415 } }, -- Forest Warden addons
    { looktypes = { 1437, 1436 } }, -- Royal Bounacean Advisor addons
    { looktypes = { 1445, 1444 } }, -- Dragon Knight addons
    { looktypes = { 1450, 1449 } }, -- Arbalester addons
    { looktypes = { 1456, 1457 } }, -- Royal Costume addons
    { looktypes = { 1461, 1460 } }, -- Formal Dress addons
    { looktypes = { 1490, 1489 } }, -- Ghost Blade addons
    { looktypes = { 1501, 1500 } }, -- Nordic Chieftain addons
    { looktypes = { 1569, 1568 } }, -- Fire-Fighter addons
    { looktypes = { 1576, 1575 } }, -- Fencer addons
    { looktypes = { 1582, 1581 } }, -- Shadowlotus Disciple addons
    { looktypes = { 1598, 1597 } }, -- Ancient Aucar addons
    { looktypes = { 1613, 1612 } }, -- Frost Tracer addons
    { looktypes = { 1619, 1618 } }, -- Armoured Archer addons
    { looktypes = { 1663, 1662 } }, -- Decaying Defender addons
    { looktypes = { 1676, 1675 } }, -- Darklight Evoker addons
    { looktypes = { 1681, 1680 } }, -- Flamefury Mage addons
    { looktypes = { 1714, 1713 } }, -- Doom Knight addons
    { looktypes = { 1723, 1722 } }, -- Draccoon Herald addons
    { looktypes = { 1726, 1725 } }, -- Celestial Avenger addons
    { looktypes = { 1746, 1745 } }, -- Blade Dancer addons
    { looktypes = { 1775, 1774 } }, -- Rootwalker addons
    { looktypes = { 1777, 1776 } }, -- Beekeeper addons
    { looktypes = { 1814 } }, -- Unknown outfit (1814)
    { looktypes = { 1813 } } -- Unknown outfit (1813)
}

MountsIds = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 50, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232 }

-- Create a default full-bonus set matching the requested values:
-- +5 max HP, +0.2 main skill, +0.1 crit chance, +0.2 crit damage,
-- +5 max MP, +0.1 mana leech, +0.1 life leech, +0.1 shield skill
-- Map condition keys to the central variable names so entries use those variables by default
local CONDITION_TO_VARIABLE = {
	[CONDITION_PARAM_STAT_MAXHITPOINTS] = 'VARIABLEHP',
	[CONDITION_PARAM_SKILL_MELEE] = 'VARIABLEMAIN',
	[CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE] = 'VARIABLECRITCHANCE',
	[CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = 'VARIABLECRITDAMAGE',
	[CONDITION_PARAM_STAT_MAXMANAPOINTS] = 'VARIABLEMP',
	[CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = 'VARIABLEMANALEECH',
	[CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = 'VARIABLELIFELEECH',
	[CONDITION_PARAM_SKILL_SHIELD] = 'VARIABLESHIELD'
}

MountsBonuses = MountsBonuses or {}

-- Ensure every AddonBonuses entry has a `bonuses` table and use central variables by default.
for _, entry in ipairs(AddonBonuses) do
	entry.bonuses = entry.bonuses or {}
	for condition, varName in pairs(CONDITION_TO_VARIABLE) do
		-- if this entry doesn't already provide a specific bonus for the condition, set it to use the variable
		if type(entry.bonuses[condition]) ~= 'table' or entry.bonuses[condition].value == nil then
			local val = _G[varName]
			if val ~= nil then
				entry.bonuses[condition] = { value = val }
			end
		end
	end
end

-- Build MountsBonuses for all mounts if not present, using the same central variables.
for _, mid in ipairs(MountsIds) do
	MountsBonuses[mid] = MountsBonuses[mid] or {}
	for condition, varName in pairs(CONDITION_TO_VARIABLE) do
		if type(MountsBonuses[mid][condition]) ~= 'table' or MountsBonuses[mid][condition].value == nil then
			local val = _G[varName]
			if val ~= nil then
				MountsBonuses[mid][condition] = { value = val }
			end
		end
	end
end

-- Force every AddonBonuses and MountsBonuses entry to include the full set of CENTRAL VARIABLE-driven bonuses.
-- This will overwrite any existing bonuses on entries so every addon and mount explicitly grants the same list.
local FULL_BONUSES_TEMPLATE = {
	[CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = VARIABLEHP },
	[CONDITION_PARAM_SKILL_MELEE] = { value = VARIABLEMAIN },
	[CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE] = { value = VARIABLECRITCHANCE },
	[CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = VARIABLECRITDAMAGE },
	[CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = VARIABLEMP },
	[CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = { value = VARIABLEMANALEECH },
	[CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = { value = VARIABLELIFELEECH },
	[CONDITION_PARAM_SKILL_SHIELD] = { value = VARIABLESHIELD }
}

local function copyBonusesTemplate()
	local t = {}
	for k, v in pairs(FULL_BONUSES_TEMPLATE) do
		t[k] = { value = v.value }
	end
	return t
end

for _, entry in ipairs(AddonBonuses) do
	entry.bonuses = copyBonusesTemplate()
end

for _, mid in ipairs(MountsIds) do
	MountsBonuses[mid] = copyBonusesTemplate()
end
-- SPECIAL_BONUSES: configure per-looktype and per-mount overrides here.
-- Example: to make looktypes 1211 and 1210 the golden outfit with special bonuses,
-- add them under `looktypes` below. Mounts can be listed under `mounts` with mount id keys.
SPECIAL_BONUSES = SPECIAL_BONUSES or {
	looktypes = {
		-- Golden outfit (special): looktypes 1211 and 1210
		[1211] = {
			[CONDITION_PARAM_SKILL_MELEE] = { value = 5 },
			[CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 },
			[CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 },
			[CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE] = { value = 5 },
			[CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 10 }
		},
		[1210] = {
			[CONDITION_PARAM_SKILL_MELEE] = { value = 5 },
			[CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 50 },
			[CONDITION_PARAM_STAT_MAXMANAPOINTS] = { value = 50 },
			[CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE] = { value = 5 },
			[CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = { value = 10 }
		}
	},
	mounts = {
		-- [1] = { [CONDITION_PARAM_STAT_MAXHITPOINTS] = { value = 10 }, ... }
	}
}

-- Apply any special per-looktype bonuses to AddonBonuses entries (overrides defaults)
for _, entry in ipairs(AddonBonuses) do
	for _, lt in ipairs(entry.looktypes) do
		local spec = SPECIAL_BONUSES.looktypes and SPECIAL_BONUSES.looktypes[lt]
		if spec then
			entry.bonuses = {}
			for condition, bonus in pairs(spec) do
				local val = bonus.value or bonus
				entry.bonuses[condition] = { value = val }
			end
			break
		end
	end
end

-- Apply any special per-mount bonuses (overrides defaults)
for mid, spec in pairs(SPECIAL_BONUSES.mounts or {}) do
	MountsBonuses[mid] = MountsBonuses[mid] or {}
	MountsBonuses[mid] = {}
	for condition, bonus in pairs(spec) do
		local val = bonus.value or bonus
		MountsBonuses[mid][condition] = { value = val }
	end
end
