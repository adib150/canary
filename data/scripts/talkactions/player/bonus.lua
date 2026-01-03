local bonus = TalkAction("!bonus")

ConditionParamNames = {
	[CONDITION_PARAM_SKILL_MELEE] = "Skills",
	[CONDITION_PARAM_SKILL_FIST] = "Fist Skill",
	[CONDITION_PARAM_SKILL_SHIELD] = "Shielding Skill",
	[CONDITION_PARAM_SKILL_FISHING] = "Fishing Skill",
	[CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = "Critical Hit Damage",
	[CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE] = "Critical Hit Chance",
	[CONDITION_PARAM_ONSLAUGHT_CHANCE] = "Onslaught Chance",
	[CONDITION_PARAM_SKILL_AXE] = "Axe Skill",
	[CONDITION_PARAM_SKILL_SWORD] = "Sword Skill",
	[CONDITION_PARAM_SKILL_CLUB] = "Club Skill",
	[CONDITION_PARAM_SKILL_DISTANCE] = "Distance Skill",
	[CONDITION_PARAM_SKILL_LIFE_LEECH_CHANCE] = "Life Leech Chance",
	[CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = "Life Leech Amount",
	[CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE] = "Mana Leech Chance",
	[CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = "Mana Leech Amount",
	[CONDITION_PARAM_BUFF_DAMAGEDEALT] = "Damage Dealt",
	[CONDITION_PARAM_BUFF_DAMAGERECEIVED] = "Damage Taken",
	[CONDITION_PARAM_MOMENTUM_CHANCE] = "Momentum Chance",
	[CONDITION_PARAM_TRANSCENDENCE_CHANCE] = "Transcendence Chance",
	[CONDITION_PARAM_AMPLIFICATION_CHANCE] = "Amplification Chance",
	[CONDITION_PARAM_RUSE_CHANCE] = "Ruse Chance",
	[CONDITION_PARAM_STAT_MAXHITPOINTS] = "Maximum Hit Points",
	[CONDITION_PARAM_STAT_MAXMANAPOINTS] = "Maximum Mana Points",
	[CONDITION_PARAM_STAT_MAGICPOINTS] = "Magic Level",
	[CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT] = "HP Percent",
	[CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT] = "Mana Percent",
}

local function formatBonus(condition, value)
	-- percent-style params
	if condition == CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE
		or condition == CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE
		or condition == CONDITION_PARAM_ONSLAUGHT_CHANCE
		or condition == CONDITION_PARAM_MOMENTUM_CHANCE
		or condition == CONDITION_PARAM_TRANSCENDENCE_CHANCE
		or condition == CONDITION_PARAM_AMPLIFICATION_CHANCE
		or condition == CONDITION_PARAM_RUSE_CHANCE then
		return string.format("%.2f%%", value / 100)
	end
	-- damage dealt / taken are percent whole-number deltas
	if condition == CONDITION_PARAM_BUFF_DAMAGEDEALT or condition == CONDITION_PARAM_BUFF_DAMAGERECEIVED then
		return string.format("%d%%", value)
	end
	if math.type and math.type(value) == "float" or (type(value) == "number" and value % 1 ~= 0) then
		return string.format("%.2f", value)
	end
	return string.format("%d", value)
end

local allowedSocketSlots = {1, 4, 5, 6, 7, 8} -- HEAD, ARMOR, RIGHT, LEFT, LEGS, FEET

local function computeSocketBonuses(player)
	local totals = {}
	for _, slot in ipairs(allowedSocketSlots) do
		local item = player:getSlotItem(slot)
		if item then
			local classification = item:getClassification()
			if classification == 3 or classification == 4 then
				for i = 1, 3 do
					local socketValue = item:getCustomAttribute("socket" .. i) or "empty"
					if socketValue ~= "empty" then
						local attributeName, tier = socketValue:match("(.+) tier (%d+)")
						tier = tonumber(tier)
						if attributeName and tier then
							totals[attributeName] = (totals[attributeName] or 0) + tier
						end
					end
				end
			end
		end
	end

	if next(totals) == nil then
		return nil
	end

	--here we map the total tiers to actual condition parameters it is harded coded the socket bonuses to see on !bonus
	local socketBonus = {}
	for attributeName, totalTiers in pairs(totals) do
		if attributeName == "critical chance" then
			socketBonus[CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE] = (socketBonus[CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE] or 0) + (40 * totalTiers)
		elseif attributeName == "critical damage" then
			socketBonus[CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = (socketBonus[CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] or 0) + (100 * totalTiers)
		elseif attributeName == "onslaught chance" then
			socketBonus[CONDITION_PARAM_ONSLAUGHT_CHANCE] = (socketBonus[CONDITION_PARAM_ONSLAUGHT_CHANCE] or 0) + (0.5 * totalTiers * 100)
		elseif attributeName == "momentum chance" then
			socketBonus[CONDITION_PARAM_MOMENTUM_CHANCE] = (socketBonus[CONDITION_PARAM_MOMENTUM_CHANCE] or 0) + (0.5 * totalTiers * 100)
		elseif attributeName == "transcendence chance" then
			socketBonus[CONDITION_PARAM_TRANSCENDENCE_CHANCE] = (socketBonus[CONDITION_PARAM_TRANSCENDENCE_CHANCE] or 0) + (0.5 * totalTiers * 100)
		elseif attributeName == "amplification chance" then
			socketBonus[CONDITION_PARAM_AMPLIFICATION_CHANCE] = (socketBonus[CONDITION_PARAM_AMPLIFICATION_CHANCE] or 0) + (0.5 * totalTiers * 100)
		elseif attributeName == "ruse chance" then
			socketBonus[CONDITION_PARAM_RUSE_CHANCE] = (socketBonus[CONDITION_PARAM_RUSE_CHANCE] or 0) + (0.5 * totalTiers * 100)
		elseif attributeName == "magic level" then
			socketBonus[CONDITION_PARAM_STAT_MAGICPOINTS] = (socketBonus[CONDITION_PARAM_STAT_MAGICPOINTS] or 0) + totalTiers
		elseif attributeName == "distance fight" then
			socketBonus[CONDITION_PARAM_SKILL_DISTANCE] = (socketBonus[CONDITION_PARAM_SKILL_DISTANCE] or 0) + totalTiers
		elseif attributeName == "axe fight" then
			socketBonus[CONDITION_PARAM_SKILL_AXE] = (socketBonus[CONDITION_PARAM_SKILL_AXE] or 0) + totalTiers
		elseif attributeName == "sword fight" then
			socketBonus[CONDITION_PARAM_SKILL_SWORD] = (socketBonus[CONDITION_PARAM_SKILL_SWORD] or 0) + totalTiers
		elseif attributeName == "club fight" then
			socketBonus[CONDITION_PARAM_SKILL_CLUB] = (socketBonus[CONDITION_PARAM_SKILL_CLUB] or 0) + totalTiers
		elseif attributeName == "shielding" then
			socketBonus[CONDITION_PARAM_SKILL_SHIELD] = (socketBonus[CONDITION_PARAM_SKILL_SHIELD] or 0) + totalTiers
		elseif attributeName == "fist fight" then
			socketBonus[CONDITION_PARAM_SKILL_FIST] = (socketBonus[CONDITION_PARAM_SKILL_FIST] or 0) + totalTiers
		elseif attributeName == "fishing" then
			socketBonus[CONDITION_PARAM_SKILL_FISHING] = (socketBonus[CONDITION_PARAM_SKILL_FISHING] or 0) + totalTiers
		elseif attributeName == "hp" then
			socketBonus[CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT] = (socketBonus[CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT] or 100) + (0.5 * totalTiers)
		elseif attributeName == "mana" then
			socketBonus[CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT] = (socketBonus[CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT] or 100) + (0.5 * totalTiers)
		elseif attributeName == "life leech" then
			socketBonus[CONDITION_PARAM_SKILL_LIFE_LEECH_CHANCE] = 100
			socketBonus[CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = (socketBonus[CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] or 0) + (100 * totalTiers)
		elseif attributeName == "mana leech" then
			socketBonus[CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE] = 100
			socketBonus[CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = (socketBonus[CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] or 0) + (50 * totalTiers)
		elseif attributeName == "final damage" then
			socketBonus[CONDITION_PARAM_BUFF_DAMAGEDEALT] = (socketBonus[CONDITION_PARAM_BUFF_DAMAGEDEALT] or 100) + totalTiers
		elseif attributeName == "damage reduction" then
			socketBonus[CONDITION_PARAM_BUFF_DAMAGERECEIVED] = (socketBonus[CONDITION_PARAM_BUFF_DAMAGERECEIVED] or 100) - totalTiers
		end
	end

	return socketBonus
end

function bonus.onSay(player, words, param)
	local playerAddonsBonus = OnlinePlayersBonus[player:getId()]
	local bonus = playerAddonsBonus.playerBonuses

	if not bonus then
		return true
	end
	local message = "Your current bonuses from addons/mounts are:\n"

	message = message .. string.format("\nFull Addon Count: %d\n", playerAddonsBonus.fullAddonCount)
	message = message .. string.format("Mounts Count: %d\n\n", playerAddonsBonus.mountsCount)


	for condition, value in pairs(bonus) do
		-- Hide Fist Skill if vocation-specific skills are present with the same value
		if condition == CONDITION_PARAM_SKILL_FIST then
			local hasVocSkill = bonus[CONDITION_PARAM_SKILL_MELEE] or bonus[CONDITION_PARAM_SKILL_DISTANCE] or bonus[CONDITION_PARAM_STAT_MAGICPOINTS]
			if hasVocSkill and value == hasVocSkill then
				goto continue
			end
		end
		local conditionName = ConditionParamNames[condition] or ("Param " .. tostring(condition))
		-- Show percent-style bonuses
		if condition == CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE
			or condition == CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE
			or condition == CONDITION_PARAM_ONSLAUGHT_CHANCE
			or condition == CONDITION_PARAM_MOMENTUM_CHANCE
			or condition == CONDITION_PARAM_TRANSCENDENCE_CHANCE
			or condition == CONDITION_PARAM_AMPLIFICATION_CHANCE
			or condition == CONDITION_PARAM_RUSE_CHANCE then
			message = message .. string.format("%s: %.2f%%\n", conditionName, value / 100)
		elseif math.type and math.type(value) == "float" or (type(value) == "number" and value % 1 ~= 0) then
			message = message .. string.format("%s: %.2f\n", conditionName, value)
		else
			message = message .. string.format("%s: %d\n", conditionName, value)
		end
		::continue::
	end

	-- Socket bonuses (from equipped classification 3/4 items with sockets)
	local socketBonus = computeSocketBonuses(player)
	if socketBonus then
		message = message .. "\nSocket bonuses:\n"
		for condition, value in pairs(socketBonus) do
			local conditionName = ConditionParamNames[condition] or ("Param " .. tostring(condition))
			message = message .. string.format("%s: %s\n", conditionName, formatBonus(condition, value))
		end
	end

	if message == "Your current bonuses from addons/mounts are:\n" and not socketBonus then
		message = "You have no bonuses."
	end
	player:showInfoModal("Player Bonuses", message, "Close")

	return true
end

bonus:groupType("normal")
bonus:register()
