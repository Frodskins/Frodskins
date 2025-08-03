-- StatForge Gear Scanner
StatForge.GearScanner = {}

function StatForge.GearScanner:ScanEquippedGear()
    local equippedItems = {}
    
    for slotID, slotName in pairs(StatForge.Constants.EQUIPMENT_SLOTS) do
        local itemLink = GetInventoryItemLink("player", slotID)
        if itemLink then
            local itemData = self:GetItemReforgeableStats(itemLink, slotID)
            if itemData and itemData.hasReforgeableStats then
                equippedItems[slotID] = itemData
            end
        end
    end
    
    return equippedItems
end

function StatForge.GearScanner:GetItemReforgeableStats(itemLink, slotID)
    if not itemLink then return nil end
    
    -- Use GetItemStats to get item statistics
    local itemStats = GetItemStats(itemLink)
    if not itemStats then 
        print("|cffff0000StatForge|r: Could not get stats for item: " .. (itemLink or "unknown"))
        return nil 
    end
    
    local itemData = {
        link = itemLink,
        slot = slotID,
        stats = {},
        reforgeableStats = {},
        hasReforgeableStats = false,
        currentReforge = nil
    }
    
    -- Parse item stats
    for statKey, statValue in pairs(itemStats) do
        local statID = self:ConvertStatKeyToID(statKey)
        if statID and self:IsStatReforgeable(statID) and statValue > 0 then
            itemData.stats[statID] = statValue
            table.insert(itemData.reforgeableStats, {
                statID = statID,
                value = statValue,
                name = StatForge.StatCalculator:GetStatName(statID)
            })
            itemData.hasReforgeableStats = true
        end
    end
    
    -- Additional fallback for tooltip parsing if GetItemStats fails
    if not itemData.hasReforgeableStats then
        itemData = self:ParseItemTooltip(itemLink, slotID) or itemData
    end
    
    return itemData
end

function StatForge.GearScanner:ParseItemTooltip(itemLink, slotID)
    -- Create a temporary tooltip to scan item stats
    local tooltip = CreateFrame("GameTooltip", "StatForgeTooltip", nil, "GameTooltipTemplate")
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:SetHyperlink(itemLink)
    
    local itemData = {
        link = itemLink,
        slot = slotID,
        stats = {},
        reforgeableStats = {},
        hasReforgeableStats = false,
        currentReforge = nil
    }
    
    -- Parse tooltip lines for stats
    for i = 1, tooltip:NumLines() do
        local line = _G["StatForgeTooltipTextLeft" .. i]
        if line then
            local text = line:GetText()
            if text then
                -- Look for stat patterns in tooltip text
                local hitRating = string.match(text, "(%d+) Hit Rating")
                local critRating = string.match(text, "(%d+) Critical Strike Rating")
                local hasteRating = string.match(text, "(%d+) Haste Rating")
                local expertiseRating = string.match(text, "(%d+) Expertise Rating")
                local masteryRating = string.match(text, "(%d+) Mastery Rating")
                local dodgeRating = string.match(text, "(%d+) Dodge Rating")
                local parryRating = string.match(text, "(%d+) Parry Rating")
                
                if hitRating then
                    local value = tonumber(hitRating)
                    itemData.stats[StatForge.Constants.STATS.HIT_RATING] = value
                    table.insert(itemData.reforgeableStats, {
                        statID = StatForge.Constants.STATS.HIT_RATING,
                        value = value,
                        name = "Hit Rating"
                    })
                    itemData.hasReforgeableStats = true
                end
                
                if critRating then
                    local value = tonumber(critRating)
                    itemData.stats[StatForge.Constants.STATS.CRIT_RATING] = value
                    table.insert(itemData.reforgeableStats, {
                        statID = StatForge.Constants.STATS.CRIT_RATING,
                        value = value,
                        name = "Critical Strike Rating"
                    })
                    itemData.hasReforgeableStats = true
                end
                
                if hasteRating then
                    local value = tonumber(hasteRating)
                    itemData.stats[StatForge.Constants.STATS.HASTE_RATING] = value
                    table.insert(itemData.reforgeableStats, {
                        statID = StatForge.Constants.STATS.HASTE_RATING,
                        value = value,
                        name = "Haste Rating"
                    })
                    itemData.hasReforgeableStats = true
                end
                
                if expertiseRating then
                    local value = tonumber(expertiseRating)
                    itemData.stats[StatForge.Constants.STATS.EXPERTISE_RATING] = value
                    table.insert(itemData.reforgeableStats, {
                        statID = StatForge.Constants.STATS.EXPERTISE_RATING,
                        value = value,
                        name = "Expertise Rating"
                    })
                    itemData.hasReforgeableStats = true
                end
                
                if masteryRating then
                    local value = tonumber(masteryRating)
                    itemData.stats[StatForge.Constants.STATS.MASTERY_RATING] = value
                    table.insert(itemData.reforgeableStats, {
                        statID = StatForge.Constants.STATS.MASTERY_RATING,
                        value = value,
                        name = "Mastery Rating"
                    })
                    itemData.hasReforgeableStats = true
                end
                
                if dodgeRating then
                    local value = tonumber(dodgeRating)
                    itemData.stats[StatForge.Constants.STATS.DODGE_RATING] = value
                    table.insert(itemData.reforgeableStats, {
                        statID = StatForge.Constants.STATS.DODGE_RATING,
                        value = value,
                        name = "Dodge Rating"
                    })
                    itemData.hasReforgeableStats = true
                end
                
                if parryRating then
                    local value = tonumber(parryRating)
                    itemData.stats[StatForge.Constants.STATS.PARRY_RATING] = value
                    table.insert(itemData.reforgeableStats, {
                        statID = StatForge.Constants.STATS.PARRY_RATING,
                        value = value,
                        name = "Parry Rating"
                    })
                    itemData.hasReforgeableStats = true
                end
            end
        end
    end
    
    tooltip:Hide()
    return itemData.hasReforgeableStats and itemData or nil
end

function StatForge.GearScanner:ConvertStatKeyToID(statKey)
    local statKeyToID = {
        ["ITEM_MOD_HIT_RATING_SHORT"] = StatForge.Constants.STATS.HIT_RATING,
        ["ITEM_MOD_CRIT_RATING_SHORT"] = StatForge.Constants.STATS.CRIT_RATING,
        ["ITEM_MOD_HASTE_RATING_SHORT"] = StatForge.Constants.STATS.HASTE_RATING,
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = StatForge.Constants.STATS.EXPERTISE_RATING,
        ["ITEM_MOD_MASTERY_RATING_SHORT"] = StatForge.Constants.STATS.MASTERY_RATING,
        ["ITEM_MOD_DODGE_RATING_SHORT"] = StatForge.Constants.STATS.DODGE_RATING,
        ["ITEM_MOD_PARRY_RATING_SHORT"] = StatForge.Constants.STATS.PARRY_RATING,
        -- Additional possible variations
        ["HIT_RATING"] = StatForge.Constants.STATS.HIT_RATING,
        ["CRIT_RATING"] = StatForge.Constants.STATS.CRIT_RATING,
        ["HASTE_RATING"] = StatForge.Constants.STATS.HASTE_RATING,
        ["EXPERTISE_RATING"] = StatForge.Constants.STATS.EXPERTISE_RATING,
        ["MASTERY_RATING"] = StatForge.Constants.STATS.MASTERY_RATING,
        ["DODGE_RATING"] = StatForge.Constants.STATS.DODGE_RATING,
        ["PARRY_RATING"] = StatForge.Constants.STATS.PARRY_RATING
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