local addonBonus = CreatureEvent("AddonBonus")

OnlinePlayersBonus = {}

local function addBonusToTable(table, player, condition, value)
	if condition == CONDITION_PARAM_SKILL_MELEE then
		if not table[CONDITION_PARAM_SKILL_FIST] then
			table[CONDITION_PARAM_SKILL_FIST] = value
		else
			table[CONDITION_PARAM_SKILL_FIST] = table[CONDITION_PARAM_SKILL_FIST] + value
		end
		if player:getVocation():getBaseId() == 1 or player:getVocation():getBaseId() == 2 then
			if not table[CONDITION_PARAM_STAT_MAGICPOINTS] then
				table[CONDITION_PARAM_STAT_MAGICPOINTS] = value
			else
				table[CONDITION_PARAM_STAT_MAGICPOINTS] = table[CONDITION_PARAM_STAT_MAGICPOINTS] + value
			end
		elseif player:getVocation():getBaseId() == 3 then
			if not table[CONDITION_PARAM_SKILL_DISTANCE] then
				table[CONDITION_PARAM_SKILL_DISTANCE] = value
			else
				table[CONDITION_PARAM_SKILL_DISTANCE] = table[CONDITION_PARAM_SKILL_DISTANCE] + value
			end
		else
			if not table[CONDITION_PARAM_SKILL_MELEE] then
				table[CONDITION_PARAM_SKILL_MELEE] = value
			else
				table[CONDITION_PARAM_SKILL_MELEE] = table[CONDITION_PARAM_SKILL_MELEE] + value
			end
		end
	else
		if not table[condition] then
			table[condition] = value
		else
			table[condition] = table[condition] + value
		end
	end
end


function addonBonus.onLogin(player)
	local playerBonuses = {}
	local fullAddonCount = 0
	local mountsCount = 0

	-- Addons bonus
	for _, entry in pairs(AddonBonuses) do
		for _, lt in ipairs(entry.looktypes) do
			if player:hasOutfit(lt, 3) then
				fullAddonCount = fullAddonCount + 1
				for condition, bonus in pairs(entry.bonuses) do
					addBonusToTable(playerBonuses, player, condition, bonus.value)
				end
				break
			end
		end
	end

	-- Mount Bonus
	for _, entry in pairs(MountsIds) do
		if player:hasMount(entry) then
			mountsCount = mountsCount + 1
			addBonusToTable(playerBonuses, player, CONDITION_PARAM_STAT_MAXHITPOINTS, 100)
			addBonusToTable(playerBonuses, player, CONDITION_PARAM_STAT_MAXMANAPOINTS, 100)
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
