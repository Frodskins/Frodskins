# StatForge - Reforging Assistant

A comprehensive World of Warcraft addon for **Mists of Pandaria Classic** that analyzes your equipped gear and provides intelligent reforging recommendations to optimize your character's stats.

## Features

### 🎯 **Smart Stat Analysis**
- Real-time scanning of all equipped gear
- Automatic detection of reforgeable stats on items
- Precise calculation of current hit, expertise, crit, haste, and mastery ratings
- Visual percentage display for easy understanding

### 🔧 **Intelligent Reforging Recommendations**
- **Class & Spec Specific**: Tailored recommendations for all 11 classes and 34 specializations
- **Priority-Based**: Ensures hit and expertise caps are met before optimizing secondary stats
- **Cost-Effective**: Suggests the most efficient reforges to minimize gold expenditure
- **Color-Coded Interface**: Red for critical caps, green for optimization, white for informational

### 📊 **Comprehensive Class Support**
- **Death Knight**: Blood (Tank), Frost (DPS), Unholy (DPS)
- **Warrior**: Arms, Fury, Protection
- **Paladin**: Holy, Protection, Retribution
- **Hunter**: Beast Mastery, Marksmanship, Survival
- **Rogue**: Assassination, Combat, Subtlety
- **Priest**: Discipline, Holy, Shadow
- **Shaman**: Elemental, Enhancement, Restoration
- **Mage**: Arcane, Fire, Frost
- **Warlock**: Affliction, Demonology, Destruction
- **Monk**: Brewmaster, Mistweaver, Windwalker
- **Druid**: Balance, Feral, Guardian, Restoration

### 🎮 **User-Friendly Interface**
- Clean, organized UI showing current stats and recommendations
- Scrollable reforge list with detailed descriptions
- Summary panel showing total reforges and estimated costs
- Automatic gear scanning when equipment changes
- Movable and resizable window

## Installation

### Method 1: Manual Installation
1. Download the addon files
2. Extract the `StatForge` folder to your WoW addons directory:
   - **Windows**: `World of Warcraft\_classic_\Interface\AddOns\`
   - **Mac**: `Applications/World of Warcraft/_classic_/Interface/AddOns/`
3. Restart World of Warcraft or type `/reload` in-game

### Method 2: Git Clone
```bash
cd "World of Warcraft/_classic_/Interface/AddOns/"
git clone <repository-url> StatForge
```

## Usage

### Basic Commands
- `/statforge` or `/sf` - Toggle the main window
- `/statforge scan` - Manually scan gear and calculate reforges
- `/statforge hide` - Hide the main window
- `/statforge reset` - Reset all addon settings

### Getting Started
1. Log in to your character
2. Type `/statforge` to open the addon window
3. Click **"Scan Gear"** to analyze your current equipment
4. Review the recommendations in the reforge list
5. Visit a Reforging NPC and apply the suggested changes

### Understanding the Interface

#### **Current Stats Panel**
- Shows your current ratings and percentages
- **Green text** = At or above recommended cap
- **White text** = Below recommended cap

#### **Recommendations Panel**
- Displays your current specialization
- Shows stat priority order for your spec
- Lists hit and expertise cap requirements

#### **Reforge List**
- **Red Priority** = Critical for reaching hit/expertise caps
- **Green Priority** = Stat optimization for better performance
- Each entry shows: Item → "Reforge X stat to Y stat"

#### **Summary Panel**
- Total number of recommended reforges
- Estimated gold cost
- Total hit/expertise gained from all reforges

## Stat Priority Guide

### **Melee DPS Priority**
1. **Hit Rating** → 7.5% (2550 rating)
2. **Expertise** → 7.5% (2550 rating)
3. **Secondary Stats** (varies by spec)

### **Caster DPS Priority**
1. **Hit Rating** → 15% (2550 rating)
2. **Secondary Stats** (varies by spec)

### **Tank Priority**
1. **Hit Rating** → 7.5% (2550 rating)
2. **Expertise** → 7.5% (2550 rating)
3. **Mastery/Avoidance** (varies by class)

### **Healer Priority**
1. **Secondary Stats** optimized for throughput
2. Hit rating generally not required

## Advanced Features

### **Auto-Scan**
- Automatically rescans gear when equipment changes
- Can be disabled in settings (future update)

### **Reforge History**
- Tracks your reforging decisions
- Helps avoid repeated mistakes
- Stores last 100 reforge actions

### **Spec Detection**
- Automatically adapts recommendations when you change specs
- No manual configuration required

## Troubleshooting

### **"No reforges recommended"**
- Your gear is already optimized for your spec
- Try switching specs to see different recommendations
- Ensure you have reforgeable stats on your gear

### **Addon not loading**
- Check that all files are in the correct directory
- Ensure the folder is named exactly "StatForge"
- Try `/reload` in-game

### **Stats not updating**
- Click "Refresh" button in the addon window
- Try removing and re-equipping an item
- Use `/statforge scan` to force a manual scan

## Compatibility

- **Game Version**: Mists of Pandaria Classic (5.4.x)
- **Interface**: 50400
- **Language Support**: English (additional languages in future updates)
- **Other Addons**: Compatible with most popular addons

## Contributing

This addon is designed to be easily extensible. Key areas for contribution:

- **Additional Classes**: Expanding stat priorities for edge cases
- **UI Improvements**: Enhanced visual design and usability
- **Localization**: Translation support for other languages
- **Advanced Features**: Gem/enchant recommendations, set bonus awareness

## Version History

### **v1.0.0** - Initial Release
- Complete class and specialization support
- Core reforging algorithm
- User interface and gear scanning
- Database system for settings and history

## Support

For questions, bug reports, or feature requests:
- Check the troubleshooting section above
- Review existing issues before creating new ones
- Provide detailed information about your character and the issue

## License

This addon is released under the MIT License. Feel free to modify and distribute according to the license terms.

---

**Happy Reforging!** 🔨⚡

*StatForge - Making stat optimization simple for Mists of Pandaria Classic*