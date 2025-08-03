-- StatForge Database Management
StatForge.Database = {}

local defaults = {
    profile = {
        showWindow = false,
        autoScan = true,
        rememberReforges = true,
        statWeights = {},
        reforgeHistory = {}
    }
}

function StatForge.Database:Initialize()
    StatForgeDB = StatForgeDB or {}
    
    -- Set up defaults if they don't exist
    for key, value in pairs(defaults.profile) do
        if StatForgeDB[key] == nil then
            StatForgeDB[key] = value
        end
    end
    
    -- Initialize character-specific data
    local playerName = UnitName("player")
    local realmName = GetRealmName()
    local characterKey = playerName .. "-" .. realmName
    
    StatForgeDB.characters = StatForgeDB.characters or {}
    StatForgeDB.characters[characterKey] = StatForgeDB.characters[characterKey] or {
        lastScan = 0,
        currentStats = {},
        recommendedReforges = {}
    }
    
    self.characterData = StatForgeDB.characters[characterKey]
end

function StatForge.Database:SaveReforge(itemLink, fromStat, toStat, amount)
    if not StatForgeDB.rememberReforges then return end
    
    local reforgeData = {
        timestamp = time(),
        itemLink = itemLink,
        fromStat = fromStat,
        toStat = toStat,
        amount = amount
    }
    
    table.insert(StatForgeDB.reforgeHistory, reforgeData)
    
    -- Keep only last 100 reforges
    if #StatForgeDB.reforgeHistory > 100 then
        table.remove(StatForgeDB.reforgeHistory, 1)
    end
end

function StatForge.Database:GetCharacterData()
    return self.characterData
end

function StatForge.Database:SaveCurrentStats(stats)
    self.characterData.currentStats = stats
    self.characterData.lastScan = time()
end

function StatForge.Database:SaveRecommendedReforges(reforges)
    self.characterData.recommendedReforges = reforges
end