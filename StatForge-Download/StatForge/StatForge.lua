-- StatForge Main Addon File
StatForge = StatForge or {}

-- Local references for performance
local addonName = "StatForge"
local playerClass, playerClassLocalized
local currentReforges = {}

-- Event handling
local eventFrame = CreateFrame("Frame")

function StatForge:OnLoad()
    -- Initialize database
    StatForge.Database:Initialize()
    
    -- Get player info
    playerClass, playerClassLocalized = UnitClass("player")
    
    -- Register events
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:RegisterEvent("PLAYER_LOGIN")
    eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
    eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    
    eventFrame:SetScript("OnEvent", function(self, event, ...)
        StatForge:OnEvent(event, ...)
    end)
    
    -- Create slash commands
    SLASH_STATFORGE1 = "/statforge"
    SLASH_STATFORGE2 = "/sf"
    SlashCmdList["STATFORGE"] = function(msg)
        StatForge:HandleSlashCommand(msg)
    end
    
    print("|cff00ff00StatForge|r: Reforging Assistant loaded. Type /statforge to open.")
end

function StatForge:OnEvent(event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            self:OnLoad()
        end
    elseif event == "PLAYER_LOGIN" then
        self:OnPlayerLogin()
    elseif event == "UNIT_INVENTORY_CHANGED" then
        local unit = ...
        if unit == "player" and StatForgeDB.autoScan then
            self:ScheduleRefresh()
        end
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        if StatForgeDB.autoScan then
            self:ScheduleRefresh()
        end
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
        local unit = ...
        if unit == "player" then
            self:OnSpecializationChanged()
        end
    end
end

function StatForge:OnPlayerLogin()
    -- Additional initialization after login
    self:UpdatePlayerInfo()
end

function StatForge:OnSpecializationChanged()
    if StatForgeFrame and StatForgeFrame:IsVisible() then
        self:RefreshDisplay()
    end
end

function StatForge:ScheduleRefresh()
    if self.refreshTimer then
        self.refreshTimer:Cancel()
    end
    
    self.refreshTimer = C_Timer.NewTimer(2, function()
        if StatForgeFrame and StatForgeFrame:IsVisible() then
            self:RefreshDisplay()
        end
    end)
end

function StatForge:HandleSlashCommand(msg)
    local command = string.lower(msg or "")
    
    if command == "show" or command == "" then
        self:ToggleFrame()
    elseif command == "scan" then
        self:ScanAndAnalyze()
    elseif command == "hide" then
        StatForgeFrame:Hide()
    elseif command == "reset" then
        self:ResetSettings()
    else
        print("|cff00ff00StatForge|r Commands:")
        print("  /statforge show - Toggle main window")
        print("  /statforge scan - Scan gear and calculate reforges")
        print("  /statforge hide - Hide main window")
        print("  /statforge reset - Reset all settings")
    end
end

function StatForge:ToggleFrame()
    if StatForgeFrame:IsVisible() then
        StatForgeFrame:Hide()
    else
        StatForgeFrame:Show()
        self:RefreshDisplay()
    end
end

function StatForge:ScanAndAnalyze()
    print("|cff00ff00StatForge|r: Scanning equipped gear...")
    
    -- Get current stats
    local currentStats = StatForge.StatCalculator:GetCurrentStats()
    StatForge.Database:SaveCurrentStats(currentStats)
    
    -- Calculate optimal reforges
    local reforges = StatForge.ReforgeEngine:CalculateOptimalReforges()
    StatForge.Database:SaveRecommendedReforges(reforges)
    
    currentReforges = reforges
    
    -- Update display
    self:RefreshDisplay()
    
    print("|cff00ff00StatForge|r: Analysis complete. Found " .. #reforges .. " recommended reforges.")
end

function StatForge:RefreshDisplay()
    if not StatForgeFrame or not StatForgeFrame:IsVisible() then
        return
    end
    
    self:UpdateCurrentStatsDisplay()
    self:UpdateRecommendationsDisplay()
    self:UpdateReforgeListDisplay()
    self:UpdateSummaryDisplay()
end

function StatForge:UpdateCurrentStatsDisplay()
    local currentStats = StatForge.StatCalculator:GetCurrentStats()
    local percentages = StatForge.StatCalculator:GetStatPercentages(currentStats)
    
    -- Update hit rating
    local hitText = StatForgeFrameCurrentStatsHitText
    if hitText then
        local hitRating = currentStats[StatForge.Constants.STATS.HIT_RATING] or 0
        local hitPercent = percentages[StatForge.Constants.STATS.HIT_RATING] or 0
        hitText:SetText(string.format("Hit Rating: %d (%.2f%%)", hitRating, hitPercent))
        
        -- Color based on cap status
        if StatForge.StatCalculator:IsAtCap(StatForge.Constants.STATS.HIT_RATING, hitRating) then
            hitText:SetTextColor(0, 1, 0) -- Green if at cap
        else
            hitText:SetTextColor(1, 1, 1) -- White if under cap
        end
    end
    
    -- Update expertise rating
    local expertiseText = StatForgeFrameCurrentStatsExpertiseText
    if expertiseText then
        local expertiseRating = currentStats[StatForge.Constants.STATS.EXPERTISE_RATING] or 0
        local expertisePercent = percentages[StatForge.Constants.STATS.EXPERTISE_RATING] or 0
        expertiseText:SetText(string.format("Expertise Rating: %d (%.2f%%)", expertiseRating, expertisePercent))
        
        if StatForge.StatCalculator:IsAtCap(StatForge.Constants.STATS.EXPERTISE_RATING, expertiseRating) then
            expertiseText:SetTextColor(0, 1, 0)
        else
            expertiseText:SetTextColor(1, 1, 1)
        end
    end
    
    -- Update other stats
    local statTexts = {
        {StatForgeFrameCurrentStatsCritText, StatForge.Constants.STATS.CRIT_RATING, "Crit Rating"},
        {StatForgeFrameCurrentStatsHasteText, StatForge.Constants.STATS.HASTE_RATING, "Haste Rating"},
        {StatForgeFrameCurrentStatsMasteryText, StatForge.Constants.STATS.MASTERY_RATING, "Mastery Rating"}
    }
    
    for _, data in ipairs(statTexts) do
        local textFrame, statID, statName = data[1], data[2], data[3]
        if textFrame then
            local rating = currentStats[statID] or 0
            local percent = percentages[statID] or 0
            textFrame:SetText(string.format("%s: %d (%.2f%%)", statName, rating, percent))
            textFrame:SetTextColor(1, 1, 1)
        end
    end
end

function StatForge:UpdateRecommendationsDisplay()
    local recommendations = StatForge.StatCalculator:GetRecommendedStats()
    
    -- Update spec text
    local specText = StatForgeFrameRecommendationsSpecText
    if specText then
        local specID = GetSpecialization()
        local specName = specID and select(2, GetSpecializationInfo(specID)) or "Unknown"
        specText:SetText("Current Spec: " .. specName)
    end
    
    -- Update priority text
    local priorityText = StatForgeFrameRecommendationsPriorityText
    if priorityText and recommendations.secondary then
        local priorityString = "Priority: Hit > Expertise"
        for _, statID in ipairs(recommendations.secondary) do
            local statName = StatForge.StatCalculator:GetStatName(statID)
            priorityString = priorityString .. " > " .. statName:gsub(" Rating", "")
        end
        priorityText:SetText(priorityString)
    end
end

function StatForge:UpdateReforgeListDisplay()
    -- Clear existing reforge display
    local contentFrame = StatForgeFrameReforgeScrollContent
    if not contentFrame then return end
    
    -- Hide all existing children
    for i = 1, contentFrame:GetNumChildren() do
        local child = select(i, contentFrame:GetChildren())
        child:Hide()
    end
    
    if not currentReforges or #currentReforges == 0 then
        -- Show "no reforges needed" message
        local noReforgeText = contentFrame.noReforgeText
        if not noReforgeText then
            noReforgeText = contentFrame:CreateFontString("NoReforgeText", "ARTWORK", "GameFontNormal")
            noReforgeText:SetPoint("TOP", contentFrame, "TOP", 0, -10)
            contentFrame.noReforgeText = noReforgeText
        end
        noReforgeText:SetText("No reforges recommended. Your stats are optimized!")
        noReforgeText:Show()
        return
    end
    
    -- Hide no reforge message
    if contentFrame.noReforgeText then
        contentFrame.noReforgeText:Hide()
    end
    
    -- Create reforge entries
    local yOffset = -10
    for i, reforge in ipairs(currentReforges) do
        local reforgeFrame = self:CreateReforgeEntry(contentFrame, reforge, i)
        reforgeFrame:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 10, yOffset)
        reforgeFrame:Show()
        yOffset = yOffset - 30
    end
    
    -- Update scroll frame content height
    contentFrame:SetHeight(math.max(240, #currentReforges * 30 + 20))
end

function StatForge:CreateReforgeEntry(parent, reforge, index)
    local frameName = "StatForgeReforgeEntry" .. index
    local frame = _G[frameName]
    
    if not frame then
        frame = CreateFrame("Frame", frameName, parent)
        frame:SetSize(380, 25)
        
        -- Item name
        local itemText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        itemText:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
        itemText:SetTextColor(1, 1, 1)
        frame.itemText = itemText
        
        -- Reforge description
        local reforgeText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        reforgeText:SetPoint("TOPLEFT", itemText, "BOTTOMLEFT", 0, -2)
        reforgeText:SetTextColor(0.8, 0.8, 0.8)
        frame.reforgeText = reforgeText
        
        -- Priority indicator
        local priorityText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        priorityText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
        frame.priorityText = priorityText
    end
    
    -- Update content
    if reforge.item and reforge.item.link then
        local itemName = GetItemInfo(reforge.item.link) or "Unknown Item"
        frame.itemText:SetText(itemName)
    else
        frame.itemText:SetText("Equipment Slot " .. (reforge.item and reforge.item.slot or "Unknown"))
    end
    
    local reforgeDesc = string.format("Reforge %d %s → %d %s", 
        reforge.amount,
        reforge.fromStatName:gsub(" Rating", ""),
        reforge.gainedAmount,
        reforge.toStatName:gsub(" Rating", "")
    )
    frame.reforgeText:SetText(reforgeDesc)
    
    -- Color priority text
    local priorityColor = {1, 1, 1} -- White default
    if reforge.priority == "Hit Cap" or reforge.priority == "Expertise Cap" then
        priorityColor = {1, 0, 0} -- Red for caps
    elseif reforge.priority == "Stat Optimization" then
        priorityColor = {0, 1, 0} -- Green for optimization
    end
    
    frame.priorityText:SetText(reforge.priority)
    frame.priorityText:SetTextColor(priorityColor[1], priorityColor[2], priorityColor[3])
    
    return frame
end

function StatForge:UpdateSummaryDisplay()
    local summaryText = StatForgeFrameSummarySummaryText
    if not summaryText then return end
    
    if not currentReforges or #currentReforges == 0 then
        summaryText:SetText("No reforges needed")
        return
    end
    
    local summary = StatForge.ReforgeEngine:GetRecommendationSummary(currentReforges)
    local summaryStr = string.format("Total Reforges: %d | Estimated Cost: %dg", 
        summary.totalReforges, summary.estimatedCost)
    
    if summary.hitGained > 0 then
        summaryStr = summaryStr .. string.format(" | Hit Gained: %d", summary.hitGained)
    end
    
    if summary.expertiseGained > 0 then
        summaryStr = summaryStr .. string.format(" | Expertise Gained: %d", summary.expertiseGained)
    end
    
    summaryText:SetText(summaryStr)
end

function StatForge:UpdatePlayerInfo()
    playerClass, playerClassLocalized = UnitClass("player")
end

function StatForge:OpenSettings()
    print("|cff00ff00StatForge|r: Settings panel coming in future update!")
end

function StatForge:ResetSettings()
    StatForgeDB = nil
    StatForge.Database:Initialize()
    print("|cff00ff00StatForge|r: Settings reset to defaults.")
end

-- Initialize when loaded
StatForge:OnLoad()