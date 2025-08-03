-- StatForge Reforge Engine
StatForge.ReforgeEngine = {}

function StatForge.ReforgeEngine:CalculateOptimalReforges()
    local currentStats = StatForge.StatCalculator:GetCurrentStats()
    local equippedItems = StatForge.GearScanner:ScanEquippedGear()
    local recommendations = StatForge.StatCalculator:GetRecommendedStats()
    
    if not recommendations.caps then
        return {}
    end
    
    local reforgeRecommendations = {}
    
    -- Phase 1: Ensure hit and expertise caps are met
    local hitNeeded = math.max(0, recommendations.caps.hit - (currentStats[StatForge.Constants.STATS.HIT_RATING] or 0))
    local expertiseNeeded = math.max(0, recommendations.caps.expertise - (currentStats[StatForge.Constants.STATS.EXPERTISE_RATING] or 0))
    
    -- Phase 2: Find reforges to meet caps
    if hitNeeded > 0 or expertiseNeeded > 0 then
        local capReforges = self:FindReforgesForCaps(equippedItems, hitNeeded, expertiseNeeded)
        for _, reforge in ipairs(capReforges) do
            table.insert(reforgeRecommendations, reforge)
        end
    end
    
    -- Phase 3: Optimize remaining stats based on priority
    local optimizationReforges = self:OptimizeSecondaryStats(equippedItems, recommendations, reforgeRecommendations)
    for _, reforge in ipairs(optimizationReforges) do
        table.insert(reforgeRecommendations, reforge)
    end
    
    return reforgeRecommendations
end

function StatForge.ReforgeEngine:FindReforgesForCaps(equippedItems, hitNeeded, expertiseNeeded)
    local reforges = {}
    local remainingHitNeeded = hitNeeded
    local remainingExpertiseNeeded = expertiseNeeded
    
    -- Priority order for stats to reforge away from (lowest priority first)
    local reforgeFromPriority = {
        StatForge.Constants.STATS.DODGE_RATING,
        StatForge.Constants.STATS.PARRY_RATING,
        StatForge.Constants.STATS.MASTERY_RATING,
        StatForge.Constants.STATS.CRIT_RATING,
        StatForge.Constants.STATS.HASTE_RATING
    }
    
    for _, slotData in pairs(equippedItems) do
        if remainingHitNeeded <= 0 and remainingExpertiseNeeded <= 0 then
            break
        end
        
        local availableReforges = StatForge.GearScanner:GetAvailableReforges(slotData)
        
        -- Try to reforge to hit first if needed
        if remainingHitNeeded > 0 then
            for _, fromStatID in ipairs(reforgeFromPriority) do
                local reforge = self:FindBestReforgeForStat(availableReforges, fromStatID, StatForge.Constants.STATS.HIT_RATING, remainingHitNeeded)
                if reforge then
                    reforge.item = slotData
                    reforge.priority = "Hit Cap"
                    table.insert(reforges, reforge)
                    remainingHitNeeded = remainingHitNeeded - reforge.gainedAmount
                    break
                end
            end
        end
        
        -- Try to reforge to expertise if needed
        if remainingExpertiseNeeded > 0 then
            for _, fromStatID in ipairs(reforgeFromPriority) do
                local reforge = self:FindBestReforgeForStat(availableReforges, fromStatID, StatForge.Constants.STATS.EXPERTISE_RATING, remainingExpertiseNeeded)
                if reforge then
                    reforge.item = slotData
                    reforge.priority = "Expertise Cap"
                    table.insert(reforges, reforge)
                    remainingExpertiseNeeded = remainingExpertiseNeeded - reforge.gainedAmount
                    break
                end
            end
        end
    end
    
    return reforges
end

function StatForge.ReforgeEngine:FindBestReforgeForStat(availableReforges, fromStatID, toStatID, neededAmount)
    local bestReforge = nil
    local bestAmount = 0
    
    for _, reforge in ipairs(availableReforges) do
        if reforge.fromStat == fromStatID and reforge.toStat == toStatID then
            local actualGain = math.floor(reforge.maxAmount * StatForge.Constants.REFORGE_CONVERSION_RATE)
            local usefulAmount = math.min(actualGain, neededAmount)
            
            if usefulAmount > bestAmount then
                bestAmount = usefulAmount
                bestReforge = {
                    fromStat = fromStatID,
                    toStat = toStatID,
                    amount = math.ceil(usefulAmount / StatForge.Constants.REFORGE_CONVERSION_RATE),
                    gainedAmount = usefulAmount,
                    fromStatName = reforge.fromStatName,
                    toStatName = reforge.toStatName
                }
            end
        end
    end
    
    return bestReforge
end

function StatForge.ReforgeEngine:OptimizeSecondaryStats(equippedItems, recommendations, existingReforges)
    local reforges = {}
    
    -- Get current secondary stat priorities
    local secondaryPriorities = recommendations.secondary or {}
    if #secondaryPriorities == 0 then
        return reforges
    end
    
    local highestPriorityStat = secondaryPriorities[1]
    local lowestPriorityStats = {
        StatForge.Constants.STATS.DODGE_RATING,
        StatForge.Constants.STATS.PARRY_RATING
    }
    
    -- Add lowest priority secondary stats
    for i = #secondaryPriorities, 1, -1 do
        table.insert(lowestPriorityStats, secondaryPriorities[i])
    end
    
    for _, slotData in pairs(equippedItems) do
        -- Skip items that already have reforge recommendations
        if not self:ItemHasExistingReforge(slotData, existingReforges) then
            local availableReforges = StatForge.GearScanner:GetAvailableReforges(slotData)
            
            -- Try to reforge from lowest priority to highest priority stat
            for _, fromStatID in ipairs(lowestPriorityStats) do
                local reforge = self:FindBestReforgeForStat(availableReforges, fromStatID, highestPriorityStat, math.huge)
                if reforge then
                    reforge.item = slotData
                    reforge.priority = "Stat Optimization"
                    table.insert(reforges, reforge)
                    break
                end
            end
        end
    end
    
    return reforges
end

function StatForge.ReforgeEngine:ItemHasExistingReforge(slotData, existingReforges)
    for _, reforge in ipairs(existingReforges) do
        if reforge.item and reforge.item.slot == slotData.slot then
            return true
        end
    end
    return false
end

function StatForge.ReforgeEngine:CalculateReforgeValue(currentStats, reforge)
    local currentHit = currentStats[StatForge.Constants.STATS.HIT_RATING] or 0
    local currentExpertise = currentStats[StatForge.Constants.STATS.EXPERTISE_RATING] or 0
    
    local hitCap = StatForge.Constants.CAPS.MELEE_HIT
    local expertiseCap = StatForge.Constants.CAPS.EXPERTISE
    
    local value = 0
    
    -- High value for reaching caps
    if reforge.toStat == StatForge.Constants.STATS.HIT_RATING and currentHit < hitCap then
        value = value + 100
    elseif reforge.toStat == StatForge.Constants.STATS.EXPERTISE_RATING and currentExpertise < expertiseCap then
        value = value + 100
    end
    
    -- Penalize going over caps
    if reforge.toStat == StatForge.Constants.STATS.HIT_RATING and currentHit >= hitCap then
        value = value - 50
    elseif reforge.toStat == StatForge.Constants.STATS.EXPERTISE_RATING and currentExpertise >= expertiseCap then
        value = value - 50
    end
    
    return value
end

function StatForge.ReforgeEngine:GetRecommendationSummary(reforges)
    local summary = {
        totalReforges = #reforges,
        hitGained = 0,
        expertiseGained = 0,
        estimatedCost = 0
    }
    
    for _, reforge in ipairs(reforges) do
        if reforge.toStat == StatForge.Constants.STATS.HIT_RATING then
            summary.hitGained = summary.hitGained + reforge.gainedAmount
        elseif reforge.toStat == StatForge.Constants.STATS.EXPERTISE_RATING then
            summary.expertiseGained = summary.expertiseGained + reforge.gainedAmount
        end
        
        -- Estimate cost (varies by item level, using base cost here)
        summary.estimatedCost = summary.estimatedCost + 5 -- Base reforge cost in MoP
    end
    
    return summary
end