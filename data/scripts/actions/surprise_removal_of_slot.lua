local SURPRISE_REMOVAL_ID = 6570

local removalRewards = {
	{ id = 12228, name = "removal of first slot of power" },
	{ id = 12209, name = "removal of second slot of power" },
	{ id = 12226, name = "removal of third slot of power" },
}

local surpriseRemoval = Action()

function surpriseRemoval.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randomIndex = math.random(1, #removalRewards)
	local rewardItem = removalRewards[randomIndex]
	
	player:addItem(rewardItem.id, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a " .. rewardItem.name .. ".")
	
	item:remove(1)
	return true
end

surpriseRemoval:id(SURPRISE_REMOVAL_ID)
surpriseRemoval:register()
