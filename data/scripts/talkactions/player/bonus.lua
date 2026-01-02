local bonus = TalkAction("!bonus")

ConditionParamNames = {
	[CONDITION_PARAM_SKILL_MELEE] = "Skills",
	[CONDITION_PARAM_SKILL_FIST] = "Main Skill Bonus",
	[CONDITION_PARAM_SKILL_SHIELD] = "Shielding Skill",
	[CONDITION_PARAM_SKILL_FISHING] = "Fishing Skill",
	[CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = "Critical Hit Damage",
	[CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE] = "Critical Hit Chance",
	[CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT] = "Life Leech Amount",
	[CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT] = "Mana Leech Amount",
	[CONDITION_PARAM_STAT_MAXHITPOINTS] = "Maximum Hit Points",
	[CONDITION_PARAM_STAT_MAXMANAPOINTS] = "Maximum Mana Points",
}

function bonus.onSay(player, words, param)
	local playerAddonsBonus = OnlinePlayersBonus[player:getId()]
	local bonus = playerAddonsBonus.playerBonuses

	if not bonus then
		return true
	end
	local message = "Your current bonuses from addons are:\n"

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
		-- Show critical chance/damage as percent
		if condition == CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE or condition == CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE then
			message = message .. string.format("%s: %.2f%%\n", conditionName, value / 100)
		elseif math.type and math.type(value) == "float" or (type(value) == "number" and value % 1 ~= 0) then
			message = message .. string.format("%s: %.2f\n", conditionName, value)
		else
			message = message .. string.format("%s: %d\n", conditionName, value)
		end
		::continue::
	end
	if message == "Your current bonuses from addons are:\n" then
		message = "You have no bonuses."
	end
	player:showInfoModal("Player Bonuses", message, "Close")

	return true
end

bonus:groupType("normal")
bonus:register()
