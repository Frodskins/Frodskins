-- StatForge Stat Calculator
StatForge.StatCalculator = {}

-- Rating to percentage conversion constants for level 90 in MoP
local RATING_CONVERSIONS = {
    [StatForge.Constants.STATS.HIT_RATING] = 340,      -- 340 rating = 1% hit
    [StatForge.Constants.STATS.CRIT_RATING] = 600,     -- 600 rating = 1% crit
    [StatForge.Constants.STATS.HASTE_RATING] = 425,    -- 425 rating = 1% haste
    [StatForge.Constants.STATS.EXPERTISE_RATING] = 340, -- 340 rating = 1% expertise
    [StatForge.Constants.STATS.MASTERY_RATING] = 600   -- 600 rating = 1% mastery
}

function StatForge.StatCalculator:GetCurrentStats()
    local stats = {}
    
    -- Get base stats from character sheet
    for statID, _ in pairs(StatForge.Constants.STATS) do
        local statValue = GetCombatRating(statID) or 0
        stats[statID] = statValue
    end
    
    return stats
end

function StatForge.StatCalculator:ConvertRatingToPercent(statID, rating)
    local conversionRate = RATING_CONVERSIONS[statID]
    if not conversionRate then return 0 end
    
    return (rating / conversionRate)
end

function StatForge.StatCalculator:GetStatPercentages(stats)
    local percentages = {}
    
    for statID, rating in pairs(stats) do
        if RATING_CONVERSIONS[statID] then
            percentages[statID] = self:ConvertRatingToPercent(statID, rating)
        else
            percentages[statID] = rating
        end
    end
    
    return percentages
end

function StatForge.StatCalculator:GetMissingStats(currentStats, targetStats)
    local missing = {}
    
    for statID, target in pairs(targetStats) do
        local current = currentStats[statID] or 0
        if current < target then
            missing[statID] = target - current
        end
    end
    
    return missing
end

function StatForge.StatCalculator:GetExcessStats(currentStats, targetStats)
    local excess = {}
    
    for statID, current in pairs(currentStats) do
        local target = targetStats[statID] or 0
        if current > target then
            excess[statID] = current - target
        end
    end
    
    return excess
end

function StatForge.StatCalculator:CalculateStatValue(baseValue, reforgeAmount, isSourceStat)
    if isSourceStat then
        return baseValue - reforgeAmount
    else
        return baseValue + (reforgeAmount * StatForge.Constants.REFORGE_CONVERSION_RATE)
    end
end

function StatForge.StatCalculator:GetRecommendedStats()
    local playerClass = select(2, UnitClass("player"))
    local specID = GetSpecialization()
    
    if not playerClass or not specID then
        return {}
    end
    
    local classPriorities = StatForge.Constants.STAT_PRIORITIES[playerClass]
    if not classPriorities or not classPriorities[specID] then
        return {}
    end
    
    return classPriorities[specID]
end

function StatForge.StatCalculator:IsAtCap(statID, currentValue)
    local caps = StatForge.Constants.CAPS
    
    if statID == StatForge.Constants.STATS.HIT_RATING then
        return currentValue >= caps.MELEE_HIT -- Using melee hit as default
    elseif statID == StatForge.Constants.STATS.EXPERTISE_RATING then
        return currentValue >= caps.EXPERTISE
    end
    
    return false
end

function StatForge.StatCalculator:GetStatName(statID)
    local statNames = {
        [StatForge.Constants.STATS.HIT_RATING] = "Hit Rating",
        [StatForge.Constants.STATS.CRIT_RATING] = "Critical Strike Rating",
        [StatForge.Constants.STATS.HASTE_RATING] = "Haste Rating", 
        [StatForge.Constants.STATS.EXPERTISE_RATING] = "Expertise Rating",
        [StatForge.Constants.STATS.MASTERY_RATING] = "Mastery Rating",
        [StatForge.Constants.STATS.DODGE_RATING] = "Dodge Rating",
        [StatForge.Constants.STATS.PARRY_RATING] = "Parry Rating"
    }
    
    return statNames[statID] or "Unknown Stat"
end