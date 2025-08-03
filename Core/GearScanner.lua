-- StatForge Gear Scanner
StatForge.GearScanner = {}

function StatForge.GearScanner:ScanEquippedGear()
    local equippedItems = {}
    
    for slotID, slotName in pairs(StatForge.Constants.EQUIPMENT_SLOTS) do
        local itemLink = GetInventoryItemLink("player", slotID)
        if itemLink then
            local itemData = self:GetItemReforgeableStats(itemLink, slotID)
            if itemData and #itemData.reforgeableStats > 0 then
                equippedItems[slotID] = itemData
            end
        end
    end
    
    return equippedItems
end

function StatForge.GearScanner:GetItemReforgeableStats(itemLink, slotID)
    if not itemLink then return nil end
    
    local itemStats = GetItemStats(itemLink)
    if not itemStats then return nil end
    
    local reforgeableStats = {}
    local itemData = {
        link = itemLink,
        slot = slotID,
        stats = {},
        reforgeableStats = {},
        currentReforge = nil
    }
    
    -- Get all stats on the item
    for statKey, statValue in pairs(itemStats) do
        -- Convert stat key to our stat ID system
        local statID = self:ConvertStatKeyToID(statKey)
        if statID and self:IsStatReforgeable(statID) then
            itemData.stats[statID] = statValue
            table.insert(reforgeableStats, {
                statID = statID,
                value = statValue,
                name = StatForge.StatCalculator:GetStatName(statID)
            })
        end
    end
    
    itemData.reforgeableStats = reforgeableStats
    
    -- Check if item is already reforged
    itemData.currentReforge = self:GetCurrentReforge(itemLink)
    
    return itemData
end

function StatForge.GearScanner:ConvertStatKeyToID(statKey)
    local statKeyToID = {
        ["ITEM_MOD_HIT_RATING_SHORT"] = StatForge.Constants.STATS.HIT_RATING,
        ["ITEM_MOD_CRIT_RATING_SHORT"] = StatForge.Constants.STATS.CRIT_RATING,
        ["ITEM_MOD_HASTE_RATING_SHORT"] = StatForge.Constants.STATS.HASTE_RATING,
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = StatForge.Constants.STATS.EXPERTISE_RATING,
        ["ITEM_MOD_MASTERY_RATING_SHORT"] = StatForge.Constants.STATS.MASTERY_RATING,
        ["ITEM_MOD_DODGE_RATING_SHORT"] = StatForge.Constants.STATS.DODGE_RATING,
        ["ITEM_MOD_PARRY_RATING_SHORT"] = StatForge.Constants.STATS.PARRY_RATING
    }
    
    return statKeyToID[statKey]
end

function StatForge.GearScanner:IsStatReforgeable(statID)
    -- Check if the stat can be reforged from or to
    return StatForge.Constants.REFORGE_MAPPINGS[statID] ~= nil
end

function StatForge.GearScanner:GetCurrentReforge(itemLink)
    -- This would require scanning the item tooltip for reforge information
    -- In a real implementation, you'd parse the tooltip to detect existing reforges
    -- For now, we'll return nil (no reforge detected)
    return nil
end

function StatForge.GearScanner:GetReforgeableAmount(itemData, statID)
    local statValue = itemData.stats[statID]
    if not statValue then return 0 end
    
    -- In MoP, you can reforge up to 40% of a stat's value
    return math.floor(statValue * StatForge.Constants.REFORGE_CONVERSION_RATE)
end

function StatForge.GearScanner:CanReforgeFromTo(fromStatID, toStatID)
    local validTargets = StatForge.Constants.REFORGE_MAPPINGS[fromStatID]
    if not validTargets then return false end
    
    for _, validStatID in ipairs(validTargets) do
        if validStatID == toStatID then
            return true
        end
    end
    
    return false
end

function StatForge.GearScanner:GetAvailableReforges(itemData)
    local reforges = {}
    
    for fromStatID, fromValue in pairs(itemData.stats) do
        if self:IsStatReforgeable(fromStatID) then
            local reforgeableAmount = self:GetReforgeableAmount(itemData, fromStatID)
            
            if reforgeableAmount > 0 then
                local validTargets = StatForge.Constants.REFORGE_MAPPINGS[fromStatID]
                for _, toStatID in ipairs(validTargets) do
                    table.insert(reforges, {
                        fromStat = fromStatID,
                        toStat = toStatID,
                        maxAmount = reforgeableAmount,
                        fromStatName = StatForge.StatCalculator:GetStatName(fromStatID),
                        toStatName = StatForge.StatCalculator:GetStatName(toStatID)
                    })
                end
            end
        end
    end
    
    return reforges
end