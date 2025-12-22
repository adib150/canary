local SURPRISE_POWDER_ID = 6571

local powderRewards = {
	{ id = 30191, name = "first socket upgrade powder" },
	{ id = 30190, name = "second socket upgrade powder" },
	{ id = 30188, name = "third socket upgrade powder" },
}

local surprisePowder = Action()

function surprisePowder.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randomIndex = math.random(1, #powderRewards)
	local rewardItem = powderRewards[randomIndex]
	
	player:addItem(rewardItem.id, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a " .. rewardItem.name .. ".")
	
	item:remove(1)
	return true
end

surprisePowder:id(SURPRISE_POWDER_ID)
surprisePowder:register()
