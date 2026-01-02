local addonBonus = CreatureEvent("AddonBonus")

OnlinePlayersBonus = {}

-- Configurable uniform bonuses applied per full-outfit (with addons) and per mount.

local function safeGetVocationBase(player)
	local ok, voc = pcall(function() return player:getVocation():getBaseId() end)
	if not ok or not voc then
		return 0
	end
	return voc
end

local function addBonusToTable(dest, player, condition, value)
	if value == nil then
		return
	end
	if condition == CONDITION_PARAM_SKILL_MELEE then
		dest[CONDITION_PARAM_SKILL_FIST] = (dest[CONDITION_PARAM_SKILL_FIST] or 0) + value
		local baseVoc = safeGetVocationBase(player)
		if baseVoc == 1 or baseVoc == 2 then
			dest[CONDITION_PARAM_STAT_MAGICPOINTS] = (dest[CONDITION_PARAM_STAT_MAGICPOINTS] or 0) + value
		elseif baseVoc == 3 then
			dest[CONDITION_PARAM_SKILL_DISTANCE] = (dest[CONDITION_PARAM_SKILL_DISTANCE] or 0) + value
		else
			dest[CONDITION_PARAM_SKILL_MELEE] = (dest[CONDITION_PARAM_SKILL_MELEE] or 0) + value
		end
	else
		dest[condition] = (dest[condition] or 0) + value
	end
end

local function normalizeBonusVal(b)
	if type(b) == 'table' then
		return b.value
	end
	return b
end

local function tableShallowCopy(src)
	local t = {}
	for k, v in pairs(src or {}) do t[k] = v end
	return t
end


-- Precompute effective bonuses per looktype and per mount for fast lookup.
local LOOKTYPE_BONUSES = {}
local MOUNT_BONUSES = {}

-- Helper: overlay numeric bonuses from a bonuses table into target (overwrites values)
local function overlayBonuses(target, bonuses)
	if type(bonuses) ~= 'table' then return end
	for condition, v in pairs(bonuses) do
		local val = normalizeBonusVal(v)
		if val ~= nil then
			target[condition] = val
		end
	end
end

-- Build looktype bonuses from AddonBonuses entries
if type(AddonBonuses) == 'table' then
	for _, entry in ipairs(AddonBonuses) do
		local base = tableShallowCopy(DEFAULT_CONDITIONS)
		if type(entry.bonuses) == 'table' then
			overlayBonuses(base, entry.bonuses)
		end
		if type(entry.looktypes) == 'table' then
			for _, lt in ipairs(entry.looktypes) do
				LOOKTYPE_BONUSES[lt] = tableShallowCopy(base)
			end
		end
	end
end

-- Build mount bonuses from MountsBonuses if present
if type(MountsIds) == 'table' then
	for _, mid in ipairs(MountsIds) do
		local base = tableShallowCopy(DEFAULT_CONDITIONS)
		if type(MountsBonuses) == 'table' and type(MountsBonuses[mid]) == 'table' then
			overlayBonuses(base, MountsBonuses[mid])
		end
		MOUNT_BONUSES[mid] = tableShallowCopy(base)
	end
end

-- Apply SPECIAL_BONUSES overrides (if present) — these replace values for specified looktypes or mounts
if type(SPECIAL_BONUSES) == 'table' then
	if type(SPECIAL_BONUSES.looktypes) == 'table' then
		for lt, spec in pairs(SPECIAL_BONUSES.looktypes) do
			local base = tableShallowCopy(DEFAULT_CONDITIONS)
			overlayBonuses(base, spec)
			LOOKTYPE_BONUSES[tonumber(lt) or lt] = base
		end
	end
	if type(SPECIAL_BONUSES.mounts) == 'table' then
		for mid, spec in pairs(SPECIAL_BONUSES.mounts) do
			local base = tableShallowCopy(DEFAULT_CONDITIONS)
			overlayBonuses(base, spec)
			MOUNT_BONUSES[tonumber(mid) or mid] = base
		end
	end
end

function addonBonus.onLogin(player)
	local playerBonuses = {}
	local fullAddonCount = 0
	local mountsCount = 0

	-- For each AddonBonuses entry, check if player has any of the looktypes (count once per entry)
	if type(AddonBonuses) == 'table' then
		for _, entry in ipairs(AddonBonuses) do
			if type(entry.looktypes) == 'table' then
				for _, lt in ipairs(entry.looktypes) do
					if player:hasOutfit(lt, 3) then
						fullAddonCount = fullAddonCount + 1
						local bonuses = LOOKTYPE_BONUSES[lt] or tableShallowCopy(DEFAULT_CONDITIONS)
						for condition, val in pairs(bonuses) do
							addBonusToTable(playerBonuses, player, condition, val)
						end
						break
					end
				end
			end
		end
	end

	-- Mounts
	if type(MountsIds) == 'table' then
		for _, mid in ipairs(MountsIds) do
			if player:hasMount(mid) then
				mountsCount = mountsCount + 1
				local bonuses = MOUNT_BONUSES[mid] or tableShallowCopy(DEFAULT_CONDITIONS)
				for condition, val in pairs(bonuses) do
					addBonusToTable(playerBonuses, player, condition, val)
				end
			end
		end
	end

	local tempCondition = Condition(CONDITION_ATTRIBUTES)
	tempCondition:setParameter(CONDITION_PARAM_TICKS, -1)
	for condition, value in pairs(playerBonuses) do
		tempCondition:setParameter(condition, value)
	end
	player:addCondition(tempCondition)
	player:addHealth(playerBonuses[CONDITION_PARAM_STAT_MAXHITPOINTS] or 0)
	player:addMana(playerBonuses[CONDITION_PARAM_STAT_MAXMANAPOINTS] or 0)
	OnlinePlayersBonus[player:getId()] = { playerBonuses = playerBonuses, fullAddonCount = fullAddonCount, mountsCount = mountsCount }
	return true
end

addonBonus:register()
