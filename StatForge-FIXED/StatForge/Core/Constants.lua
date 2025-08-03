-- StatForge Constants for Mists of Pandaria Classic
StatForge = StatForge or {}
StatForge.Constants = {}

-- Stat IDs from WoW API
StatForge.Constants.STATS = {
    STRENGTH = 1,
    AGILITY = 2,
    STAMINA = 3,
    INTELLECT = 4,
    SPIRIT = 5,
    DODGE_RATING = 13,
    PARRY_RATING = 14,
    BLOCK_RATING = 15,
    HIT_RATING = 31,
    CRIT_RATING = 32,
    HASTE_RATING = 36,
    EXPERTISE_RATING = 37,
    MASTERY_RATING = 49
}

-- Reforge conversion rates (40% conversion in MoP)
StatForge.Constants.REFORGE_CONVERSION_RATE = 0.4

-- Reforge mappings - what stats can be reforged to what
StatForge.Constants.REFORGE_MAPPINGS = {
    [StatForge.Constants.STATS.DODGE_RATING] = {
        StatForge.Constants.STATS.HIT_RATING,
        StatForge.Constants.STATS.CRIT_RATING,
        StatForge.Constants.STATS.HASTE_RATING,
        StatForge.Constants.STATS.EXPERTISE_RATING,
        StatForge.Constants.STATS.MASTERY_RATING
    },
    [StatForge.Constants.STATS.PARRY_RATING] = {
        StatForge.Constants.STATS.HIT_RATING,
        StatForge.Constants.STATS.CRIT_RATING,
        StatForge.Constants.STATS.HASTE_RATING,
        StatForge.Constants.STATS.EXPERTISE_RATING,
        StatForge.Constants.STATS.MASTERY_RATING
    },
    [StatForge.Constants.STATS.HIT_RATING] = {
        StatForge.Constants.STATS.CRIT_RATING,
        StatForge.Constants.STATS.HASTE_RATING,
        StatForge.Constants.STATS.EXPERTISE_RATING,
        StatForge.Constants.STATS.MASTERY_RATING
    },
    [StatForge.Constants.STATS.CRIT_RATING] = {
        StatForge.Constants.STATS.HIT_RATING,
        StatForge.Constants.STATS.HASTE_RATING,
        StatForge.Constants.STATS.EXPERTISE_RATING,
        StatForge.Constants.STATS.MASTERY_RATING
    },
    [StatForge.Constants.STATS.HASTE_RATING] = {
        StatForge.Constants.STATS.HIT_RATING,
        StatForge.Constants.STATS.CRIT_RATING,
        StatForge.Constants.STATS.EXPERTISE_RATING,
        StatForge.Constants.STATS.MASTERY_RATING
    },
    [StatForge.Constants.STATS.EXPERTISE_RATING] = {
        StatForge.Constants.STATS.HIT_RATING,
        StatForge.Constants.STATS.CRIT_RATING,
        StatForge.Constants.STATS.HASTE_RATING,
        StatForge.Constants.STATS.MASTERY_RATING
    },
    [StatForge.Constants.STATS.MASTERY_RATING] = {
        StatForge.Constants.STATS.HIT_RATING,
        StatForge.Constants.STATS.CRIT_RATING,
        StatForge.Constants.STATS.HASTE_RATING,
        StatForge.Constants.STATS.EXPERTISE_RATING
    }
}

-- Hit and Expertise caps for different roles
StatForge.Constants.CAPS = {
    MELEE_HIT = 2550,      -- 7.5% for melee/hunters
    SPELL_HIT = 2550,      -- 15% for casters (2550 rating = 15%)
    EXPERTISE = 2550       -- 7.5% expertise cap (2550 rating)
}

-- Class and spec specific stat priorities
StatForge.Constants.STAT_PRIORITIES = {
    -- Death Knight
    ["DEATHKNIGHT"] = {
        [250] = { -- Blood (Tank)
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [251] = { -- Frost (DPS)
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [252] = { -- Unholy (DPS)
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 2550}
        }
    },
    -- Warrior
    ["WARRIOR"] = {
        [71] = { -- Arms
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [72] = { -- Fury
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [73] = { -- Protection
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 2550}
        }
    },
    -- Paladin
    ["PALADIN"] = {
        [65] = { -- Holy
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [66] = { -- Protection
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [70] = { -- Retribution
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 2550}
        }
    },
    -- Hunter
    ["HUNTER"] = {
        [253] = { -- Beast Mastery
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [254] = { -- Marksmanship
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [255] = { -- Survival
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 0}
        }
    },
    -- Rogue
    ["ROGUE"] = {
        [259] = { -- Assassination
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [260] = { -- Combat
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [261] = { -- Subtlety
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING},
            caps = {hit = 2550, expertise = 2550}
        }
    },
    -- Priest
    ["PRIEST"] = {
        [256] = { -- Discipline
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [257] = { -- Holy
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [258] = { -- Shadow
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 0}
        }
    },
    -- Shaman
    ["SHAMAN"] = {
        [262] = { -- Elemental
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [263] = { -- Enhancement
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [264] = { -- Restoration
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        }
    },
    -- Mage
    ["MAGE"] = {
        [62] = { -- Arcane
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [63] = { -- Fire
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [64] = { -- Frost
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        }
    },
    -- Warlock
    ["WARLOCK"] = {
        [265] = { -- Affliction
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [266] = { -- Demonology
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [267] = { -- Destruction
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 0}
        }
    },
    -- Monk
    ["MONK"] = {
        [268] = { -- Brewmaster
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [270] = { -- Mistweaver
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [269] = { -- Windwalker
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING},
            caps = {hit = 2550, expertise = 2550}
        }
    },
    -- Druid
    ["DRUID"] = {
        [102] = { -- Balance
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        },
        [103] = { -- Feral
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.HASTE_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [104] = { -- Guardian
            primary = {StatForge.Constants.STATS.HIT_RATING, StatForge.Constants.STATS.EXPERTISE_RATING},
            secondary = {StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING, StatForge.Constants.STATS.HASTE_RATING},
            caps = {hit = 2550, expertise = 2550}
        },
        [105] = { -- Restoration
            primary = {StatForge.Constants.STATS.HIT_RATING},
            secondary = {StatForge.Constants.STATS.HASTE_RATING, StatForge.Constants.STATS.MASTERY_RATING, StatForge.Constants.STATS.CRIT_RATING},
            caps = {hit = 2550, expertise = 0}
        }
    }
}

-- Equipment slots
StatForge.Constants.EQUIPMENT_SLOTS = {
    [1] = "HeadSlot",
    [2] = "NeckSlot", 
    [3] = "ShoulderSlot",
    [5] = "ChestSlot",
    [6] = "WaistSlot",
    [7] = "LegsSlot",
    [8] = "FeetSlot",
    [9] = "WristSlot",
    [10] = "HandsSlot",
    [11] = "Finger0Slot",
    [12] = "Finger1Slot",
    [13] = "Trinket0Slot",
    [14] = "Trinket1Slot",
    [15] = "BackSlot",
    [16] = "MainHandSlot",
    [17] = "SecondaryHandSlot"
}