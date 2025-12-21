local effects = {
    {position = Position(32227, 32200, 7), text = 'TEMPLE', effect = NONE},  
    {position = Position(32224, 32201, 7), text = 'EASY 1-200', effect = CONST_ME_GROUNDSHAKER},  
    {position = Position(32227, 32198, 7), text = 'MEDIUM 100-400', effect = CONST_ME_GROUNDSHAKER}, 
    {position = Position(32231, 32201, 7), text = 'HARD 300-800', effect = CONST_ME_GROUNDSHAKER}, 
    {position = Position(32227, 32205, 7), text = 'ENDGAME 800+', effect = CONST_ME_GROUNDSHAKER}, 
}

local animatedText = GlobalEvent("AnimatedText") 
function animatedText.onThink(interval)
    for i = 1, #effects do
        local settings = effects[i]
        local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
        if #spectators > 0 then
            if settings.text then
                for i = 1, #spectators do
                    spectators[i]:say(settings.text, TALKTYPE_MONSTER_SAY, false, spectators[i], settings.position)
                end
            end
            if settings.effect then
                settings.position:sendMagicEffect(settings.effect)
            end
        end
    end
   return true
end

animatedText:interval(4550)
animatedText:register()