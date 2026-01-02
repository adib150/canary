--local actionId = 8000
local itemDollId = 50344
local randMount = Action("RandomMountDoll")

-- Try to parse `data/XML/mounts.xml` for canonical mount ids and names.
local mounts = {}
local mountIds = {}
do
    local pathsToTry = {
        '/home/adib/canary/data/XML/mounts.xml',
        'data/XML/mounts.xml',
        './data/XML/mounts.xml'
    }
    local f = nil
    for _, p in ipairs(pathsToTry) do
        local ok
        ok, f = pcall(io.open, p, 'r')
        if ok and f then
            break
        end
        f = nil
    end

    if f then
        for line in f:lines() do
            local id, name = line:match('id="(%d+)"%s+clientid="%d+"%s+name="([^"]+)"')
            if id and name then
                local mid = tonumber(id)
                mounts[mid] = name
                table.insert(mountIds, mid)
            end
        end
        f:close()
    else
        -- Fallback: try to use global MountsIds if present
        if type(MountsIds) == 'table' and #MountsIds > 0 then
            for _, mid in ipairs(MountsIds) do
                mountIds[#mountIds + 1] = mid
                mounts[mid] = tostring(mid)
            end
        end
    end
end

local function pickRandomMissingMount(player)
    if not mountIds or #mountIds == 0 then
        return nil
    end

    local missing = {}
    for _, mid in ipairs(mountIds) do
        if not player:hasMount(mid) then
            table.insert(missing, mid)
        end
    end

    if #missing == 0 then
        return nil
    end

    return missing[math.random(1, #missing)]
end

function randMount.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local mountId = pickRandomMissingMount(player)
    if not mountId then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have all available mounts.")
        return true
    end

    -- Grant mount
    player:addMount(mountId)
    local name = mounts[mountId] or tostring(mountId)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received a new mount: %s.", name))
    item:remove(1)
    return true
end

randMount:id(itemDollId)
randMount:register()