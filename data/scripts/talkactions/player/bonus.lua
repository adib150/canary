local bonus = TalkAction("!bonus")

ConditionParamNames = {
	[CONDITION_PARAM_SKILL_MELEE] = "Skills",
	[CONDITION_PARAM_SKILL_SHIELD] = "Shielding Skill",
	[CONDITION_PARAM_SKILL_FISHING] = "Fishing Skill",
	[CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE] = "Critical Hit Damage",
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
		local conditionName = ConditionParamNames[condition]
		if conditionName then
			message = message .. string.format("%s: %d\n", conditionName, value)
		end
	end
	if message == "Your current bonuses are:\n" then
		message = "You have no bonuses."
	end
	player:showInfoModal("Player Bonuses", message, "Close")

	return true
end

bonus:groupType("normal")
bonus:register()
