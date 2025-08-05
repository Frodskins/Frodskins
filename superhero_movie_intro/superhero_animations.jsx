// Superhero Character Animation Script
// This script adds the superhero images with dynamic animations and effects

app.beginUndoGroup("Add Superhero Animations");

try {
    // Get the main composition (assuming it exists)
    var comp = app.project.activeItem;
    if (!comp || !(comp instanceof CompItem)) {
        alert("Please select the main composition first!");
        throw new Error("No composition selected");
    }
    
    // Character animation settings
    var characters = [
        {
            name: "Spider-Man",
            entrance: 5,  // entrance time in seconds
            duration: 3,  // how long character is visible
            position: [COMP_WIDTH * 0.25, COMP_HEIGHT * 0.6],
            scale: 80,
            effects: ["web_swing", "spider_sense"]
        },
        {
            name: "Venom", 
            entrance: 7,
            duration: 3,
            position: [COMP_WIDTH * 0.75, COMP_HEIGHT * 0.5],
            scale: 90,
            effects: ["symbiote_emerge", "dark_energy"]
        },
        {
            name: "Green Goblin",
            entrance: 9,
            duration: 3,
            position: [COMP_WIDTH * 0.5, COMP_HEIGHT * 0.4],
            scale: 75,
            effects: ["glider_fly", "pumpkin_bomb"]
        }
    ];
    
    // Function to create character layer with effects
    function createCharacterLayer(character, index) {
        // Note: In actual implementation, you would import the image files first
        // For now, we'll create placeholder solids that represent where images would go
        
        var charLayer = comp.layers.addSolid([0.5, 0.5, 0.5], character.name + " Placeholder", 400, 600, 1, character.duration);
        charLayer.startTime = character.entrance;
        charLayer.property("Position").setValue(character.position);
        charLayer.property("Scale").setValue([character.scale, character.scale, 100]);
        
        // Add drop shadow
        var dropShadow = charLayer.Effects.addProperty("ADBE Drop Shadow");
        dropShadow.property("Opacity").setValue(75);
        dropShadow.property("Direction").setValue(135);
        dropShadow.property("Distance").setValue(20);
        dropShadow.property("Softness").setValue(50);
        
        // Character-specific entrance animations
        switch(character.name) {
            case "Spider-Man":
                // Web-swing entrance from top-left
                charLayer.property("Position").setValueAtTime(character.entrance, [-200, -200]);
                charLayer.property("Position").setValueAtTime(character.entrance + 0.8, character.position);
                
                // Add rotation for dynamic swing
                charLayer.property("Rotation").setValueAtTime(character.entrance, -45);
                charLayer.property("Rotation").setValueAtTime(character.entrance + 0.8, 0);
                
                // Scale bounce effect
                charLayer.property("Scale").setValueAtTime(character.entrance + 0.8, [character.scale * 1.2, character.scale * 1.2, 100]);
                charLayer.property("Scale").setValueAtTime(character.entrance + 1.2, [character.scale, character.scale, 100]);
                
                // Add web trail effect
                var webTrail = comp.layers.addSolid([1, 1, 1], "Web Trail", comp.width, comp.height, 1, 1);
                webTrail.startTime = character.entrance;
                var webEffect = webTrail.Effects.addProperty("ADBE Beam");
                webEffect.property("Starting Point").setValue([-200, -200]);
                webEffect.property("Ending Point").setValue(character.position);
                webEffect.property("Length").setValue(100);
                webEffect.property("Thickness").setValue(3);
                webEffect.property("Color").setValue([1, 1, 1, 1]);
                webTrail.blendingMode = BlendingMode.ADD;
                webTrail.moveAfter(charLayer);
                break;
                
            case "Venom":
                // Symbiote emergence from darkness
                charLayer.property("Position").setValue(character.position);
                charLayer.property("Scale").setValueAtTime(character.entrance, [0, 0, 100]);
                charLayer.property("Scale").setValueAtTime(character.entrance + 1, [character.scale * 1.3, character.scale * 0.7, 100]);
                charLayer.property("Scale").setValueAtTime(character.entrance + 1.5, [character.scale, character.scale, 100]);
                
                // Add liquid morphing effect
                var liquidEffect = charLayer.Effects.addProperty("ADBE Liquify");
                // Animate opacity with flickering
                charLayer.property("Opacity").setValueAtTime(character.entrance, 0);
                charLayer.property("Opacity").setValueAtTime(character.entrance + 0.1, 100);
                charLayer.property("Opacity").setValueAtTime(character.entrance + 0.2, 30);
                charLayer.property("Opacity").setValueAtTime(character.entrance + 0.3, 100);
                charLayer.property("Opacity").setValueAtTime(character.entrance + 0.4, 50);
                charLayer.property("Opacity").setValueAtTime(character.entrance + 0.6, 100);
                
                // Dark energy particles
                var darkParticles = comp.layers.addSolid([0.1, 0.1, 0.1], "Dark Particles", comp.width, comp.height, 1, 2);
                darkParticles.startTime = character.entrance;
                var darkParticleEffect = darkParticles.Effects.addProperty("CC Particle Systems II");
                darkParticleEffect.property("Producer").property("Position").setValue(character.position);
                darkParticleEffect.property("Particle").property("Birth Color").setValue([0.1, 0.1, 0.2, 1]);
                darkParticleEffect.property("Particle").property("Death Color").setValue([0.05, 0.05, 0.1, 1]);
                darkParticleEffect.property("Particle").property("Birth Rate").setValue(20);
                darkParticles.blendingMode = BlendingMode.MULTIPLY;
                darkParticles.moveAfter(charLayer);
                break;
                
            case "Green Goblin":
                // Flying entrance from right side
                charLayer.property("Position").setValueAtTime(character.entrance, [comp.width + 200, character.position[1] + 100]);
                charLayer.property("Position").setValueAtTime(character.entrance + 1.2, character.position);
                
                // Glider tilt animation
                charLayer.property("Rotation").setValueAtTime(character.entrance, 15);
                charLayer.property("Rotation").setValueAtTime(character.entrance + 1.2, -5);
                charLayer.property("Rotation").setValueAtTime(character.entrance + 2, 0);
                
                // Add pumpkin bomb explosion effect
                var explosion = comp.layers.addSolid([1, 0.5, 0], "Explosion", 200, 200, 1, 0.5);
                explosion.startTime = character.entrance + 1.5;
                explosion.property("Position").setValue([character.position[0] + 100, character.position[1] - 50]);
                
                var explosionEffect = explosion.Effects.addProperty("CC Particle Systems II");
                explosionEffect.property("Producer").property("Position").setValue([100, 100]);
                explosionEffect.property("Particle").property("Birth Color").setValue([1, 0.3, 0, 1]);
                explosionEffect.property("Particle").property("Death Color").setValue([1, 1, 0, 1]);
                explosionEffect.property("Particle").property("Birth Rate").setValue(50);
                explosionEffect.property("Particle").property("Longevity (sec)").setValue(0.3);
                explosion.blendingMode = BlendingMode.ADD;
                explosion.moveAfter(charLayer);
                break;
        }
        
        // Add character-specific color correction
        var colorCorrect = charLayer.Effects.addProperty("ADBE Color Balance (HLS)");
        switch(character.name) {
            case "Spider-Man":
                colorCorrect.property("Hue").setValue(5); // Slight red shift
                colorCorrect.property("Saturation").setValue(20); // More vibrant
                break;
            case "Venom":
                colorCorrect.property("Lightness").setValue(-20); // Darker
                colorCorrect.property("Saturation").setValue(-10); // Less saturated
                break;
            case "Green Goblin":
                colorCorrect.property("Hue").setValue(-15); // Green shift
                colorCorrect.property("Saturation").setValue(15);
                break;
        }
        
        // Exit animation - fade out with scale
        var exitTime = character.entrance + character.duration - 0.5;
        charLayer.property("Opacity").setValueAtTime(exitTime, 100);
        charLayer.property("Opacity").setValueAtTime(character.entrance + character.duration, 0);
        charLayer.property("Scale").setValueAtTime(exitTime, [character.scale, character.scale, 100]);
        charLayer.property("Scale").setValueAtTime(character.entrance + character.duration, [character.scale * 1.2, character.scale * 1.2, 100]);
        
        return charLayer;
    }
    
    // Create all character layers
    for(var i = 0; i < characters.length; i++) {
        createCharacterLayer(characters[i], i);
    }
    
    // Add final impact frame
    var impactFrame = comp.layers.addSolid([1, 1, 1], "Impact Frame", comp.width, comp.height, 1, 0.1);
    impactFrame.startTime = 11;
    impactFrame.blendingMode = BlendingMode.ADD;
    impactFrame.property("Opacity").setValueAtTime(11, 80);
    impactFrame.property("Opacity").setValueAtTime(11.1, 0);
    
    // Add final logo/title card
    var finalTitle = comp.layers.addText("COMING SOON");
    var finalTitleProp = finalTitle.property("Source Text");
    var finalTitleDoc = finalTitleProp.value;
    finalTitleDoc.fontSize = 80;
    finalTitleDoc.fillColor = [1, 1, 1];
    finalTitleDoc.font = "Arial-BoldMT";
    finalTitleDoc.justification = ParagraphJustification.CENTER_JUSTIFY;
    finalTitleProp.setValue(finalTitleDoc);
    
    finalTitle.property("Position").setValue([comp.width/2, comp.height/2]);
    finalTitle.startTime = 12;
    
    // Final title animation
    finalTitle.property("Scale").setValueAtTime(12, [0, 0, 100]);
    finalTitle.property("Scale").setValueAtTime(12.5, [110, 110, 100]);
    finalTitle.property("Scale").setValueAtTime(13, [100, 100, 100]);
    
    finalTitle.property("Opacity").setValueAtTime(12, 0);
    finalTitle.property("Opacity").setValueAtTime(12.3, 100);
    
    // Add final glow
    var finalGlow = finalTitle.Effects.addProperty("ADBE Glow2");
    finalGlow.property("Glow Intensity").setValue(3);
    finalGlow.property("Glow Radius").setValue(40);
    finalGlow.property("Color A").setValue([1, 0.8, 0, 1]);
    
    alert("Superhero character animations added successfully!\n\nRemember to:\n1. Replace placeholder solids with actual superhero images\n2. Adjust timing and positions as needed\n3. Add audio track for full impact\n4. Fine-tune effects for your specific images");
    
} catch(error) {
    alert("Error adding character animations: " + error.toString());
}

app.endUndoGroup();