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
    
    -- Get stats using proper WoW API functions
    stats[StatForge.Constants.STATS.HIT_RATING] = GetCombatRating(CR_HIT_MELEE) or 0
    stats[StatForge.Constants.STATS.CRIT_RATING] = GetCombatRating(CR_CRIT_MELEE) or 0
    stats[StatForge.Constants.STATS.HASTE_RATING] = GetCombatRating(CR_HASTE_MELEE) or 0
    stats[StatForge.Constants.STATS.EXPERTISE_RATING] = GetCombatRating(CR_EXPERTISE) or 0
    stats[StatForge.Constants.STATS.MASTERY_RATING] = GetCombatRating(CR_MASTERY) or 0
    stats[StatForge.Constants.STATS.DODGE_RATING] = GetCombatRating(CR_DODGE) or 0
    stats[StatForge.Constants.STATS.PARRY_RATING] = GetCombatRating(CR_PARRY) or 0
    
    -- Fallback method if GetCombatRating doesn't work with constants
    if stats[StatForge.Constants.STATS.HIT_RATING] == 0 then
        stats[StatForge.Constants.STATS.HIT_RATING] = GetCombatRating(31) or 0
    end
    if stats[StatForge.Constants.STATS.CRIT_RATING] == 0 then
        stats[StatForge.Constants.STATS.CRIT_RATING] = GetCombatRating(32) or 0
    end
    if stats[StatForge.Constants.STATS.HASTE_RATING] == 0 then
        stats[StatForge.Constants.STATS.HASTE_RATING] = GetCombatRating(36) or 0
    end
    if stats[StatForge.Constants.STATS.EXPERTISE_RATING] == 0 then
        stats[StatForge.Constants.STATS.EXPERTISE_RATING] = GetCombatRating(37) or 0
    end
    if stats[StatForge.Constants.STATS.MASTERY_RATING] == 0 then
        stats[StatForge.Constants.STATS.MASTERY_RATING] = GetCombatRating(49) or 0
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
        -- Return default recommendations if we can't determine class/spec
        return {
            caps = {hit = 2550, expertise = 2550},
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING}
        }
    end
    
    local classPriorities = StatForge.Constants.STAT_PRIORITIES[playerClass]
    if not classPriorities then
        -- Return default if class not found
        return {
            caps = {hit = 2550, expertise = 2550},
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING}
        }
    end
    
    local specPriorities = classPriorities[specID]
    if not specPriorities then
        -- Return default if spec not found
        return {
            caps = {hit = 2550, expertise = 2550},
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING}
        }
    end
    
    return specPriorities
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