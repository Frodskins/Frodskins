// SUPERHERO MOVIE INTRO - QUICK SETUP SCRIPT
// This script combines both project setup and character animations for one-click setup

// Project settings
var PROJECT_NAME = "Superhero Movie Intro";
var COMP_NAME = "Main Intro";
var COMP_WIDTH = 1920;
var COMP_HEIGHT = 1080;
var COMP_DURATION = 15;
var FRAME_RATE = 24;

app.beginUndoGroup("Create Complete Superhero Movie Intro");

try {
    // PART 1: CREATE BASE COMPOSITION
    alert("Setting up base composition with effects...");
    
    var comp = app.project.items.addComp(COMP_NAME, COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION, FRAME_RATE);
    
    // Background and effects (condensed version of project_setup.jsx)
    var bgSolid = comp.layers.addSolid([0.05, 0.05, 0.15], "Dark Background", COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION);
    var gradientSolid = comp.layers.addSolid([0.1, 0.1, 0.3], "Gradient Overlay", COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION);
    
    var gradientEffect = gradientSolid.Effects.addProperty("ADBE 4 Color Gradient");
    gradientEffect.property("Point 1").setValue([0, 0]);
    gradientEffect.property("Point 2").setValue([COMP_WIDTH, COMP_HEIGHT]);
    gradientEffect.property("Color 1").setValue([0.02, 0.02, 0.1, 1]);
    gradientEffect.property("Color 2").setValue([0.1, 0.05, 0.2, 1]);
    gradientEffect.property("Color 3").setValue([0.15, 0.1, 0.25, 1]);
    gradientEffect.property("Color 4").setValue([0.05, 0.02, 0.15, 1]);
    gradientSolid.blendingMode = BlendingMode.OVERLAY;
    
    // Title text
    var titleText = comp.layers.addText("HEROES");
    var titleTextProp = titleText.property("Source Text");
    var titleTextDocument = titleTextProp.value;
    titleTextDocument.fontSize = 120;
    titleTextDocument.fillColor = [1, 1, 1];
    titleTextDocument.font = "Arial-BoldMT";
    titleTextDocument.justification = ParagraphJustification.CENTER_JUSTIFY;
    titleTextProp.setValue(titleTextDocument);
    titleText.property("Position").setValue([COMP_WIDTH/2, COMP_HEIGHT/2 - 100]);
    
    var glowEffect = titleText.Effects.addProperty("ADBE Glow2");
    glowEffect.property("Glow Colors").setValue(1);
    glowEffect.property("Color A").setValue([0.2, 0.6, 1, 1]);
    glowEffect.property("Color B").setValue([1, 0.3, 0.3, 1]);
    glowEffect.property("Glow Intensity").setValue(2);
    glowEffect.property("Glow Radius").setValue(30);
    
    // Subtitle
    var subtitleText = comp.layers.addText("RISE");
    var subtitleTextProp = subtitleText.property("Source Text");
    var subtitleTextDocument = subtitleTextProp.value;
    subtitleTextDocument.fontSize = 60;
    subtitleTextDocument.fillColor = [0.8, 0.8, 0.8];
    subtitleTextDocument.font = "Arial-BoldMT";
    subtitleTextDocument.justification = ParagraphJustification.CENTER_JUSTIFY;
    subtitleTextProp.setValue(subtitleTextDocument);
    subtitleText.property("Position").setValue([COMP_WIDTH/2, COMP_HEIGHT/2 + 50]);
    
    // Particles
    var particleLayer = comp.layers.addSolid([1, 1, 1], "Particles", COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION);
    particleLayer.moveAfter(gradientSolid);
    var particleEffect = particleLayer.Effects.addProperty("CC Particle Systems II");
    particleEffect.property("Producer").property("Position").setValue([COMP_WIDTH/2, COMP_HEIGHT/2]);
    particleEffect.property("Particle").property("Birth Color").setValue([0.3, 0.7, 1, 1]);
    particleEffect.property("Particle").property("Death Color").setValue([1, 0.3, 0.3, 1]);
    particleLayer.blendingMode = BlendingMode.ADD;
    particleLayer.opacity.setValue(30);
    
    // Lens flare
    var flareLayer = comp.layers.addSolid([1, 1, 1], "Lens Flare", COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION);
    flareLayer.moveToBeginning();
    var lensFlare = flareLayer.Effects.addProperty("ADBE Lens Flare");
    lensFlare.property("Flare Center").setValue([COMP_WIDTH/2, COMP_HEIGHT/2 - 100]);
    lensFlare.property("Flare Brightness").setValue(80);
    flareLayer.blendingMode = BlendingMode.ADD;
    
    // PART 2: ADD CHARACTER ANIMATIONS
    alert("Adding character animations and effects...");
    
    var characters = [
        {name: "Spider-Man", entrance: 5, duration: 3, position: [COMP_WIDTH * 0.25, COMP_HEIGHT * 0.6], scale: 80},
        {name: "Venom", entrance: 7, duration: 3, position: [COMP_WIDTH * 0.75, COMP_HEIGHT * 0.5], scale: 90},
        {name: "Green Goblin", entrance: 9, duration: 3, position: [COMP_WIDTH * 0.5, COMP_HEIGHT * 0.4], scale: 75}
    ];
    
    for(var i = 0; i < characters.length; i++) {
        var character = characters[i];
        var charLayer = comp.layers.addSolid([0.5, 0.5, 0.5], character.name + " Placeholder", 400, 600, 1, character.duration);
        charLayer.startTime = character.entrance;
        charLayer.property("Position").setValue(character.position);
        charLayer.property("Scale").setValue([character.scale, character.scale, 100]);
        
        // Add drop shadow
        var dropShadow = charLayer.Effects.addProperty("ADBE Drop Shadow");
        dropShadow.property("Opacity").setValue(75);
        dropShadow.property("Distance").setValue(20);
        dropShadow.property("Softness").setValue(50);
        
        // Basic entrance animation
        charLayer.property("Opacity").setValueAtTime(character.entrance, 0);
        charLayer.property("Opacity").setValueAtTime(character.entrance + 0.5, 100);
        charLayer.property("Scale").setValueAtTime(character.entrance, [0, 0, 100]);
        charLayer.property("Scale").setValueAtTime(character.entrance + 0.8, [character.scale * 1.1, character.scale * 1.1, 100]);
        charLayer.property("Scale").setValueAtTime(character.entrance + 1.2, [character.scale, character.scale, 100]);
        
        // Exit animation
        var exitTime = character.entrance + character.duration - 0.5;
        charLayer.property("Opacity").setValueAtTime(exitTime, 100);
        charLayer.property("Opacity").setValueAtTime(character.entrance + character.duration, 0);
    }
    
    // PART 3: ADD TITLE ANIMATIONS
    // Title animation
    titleText.property("Transform").property("Scale").setValueAtTime(0, [0, 0, 0]);
    titleText.property("Transform").property("Scale").setValueAtTime(2, [120, 120, 100]);
    titleText.property("Transform").property("Scale").setValueAtTime(2.5, [100, 100, 100]);
    titleText.property("Transform").property("Opacity").setValueAtTime(0, 0);
    titleText.property("Transform").property("Opacity").setValueAtTime(1.5, 100);
    titleText.property("Transform").property("Opacity").setValueAtTime(12, 100);
    titleText.property("Transform").property("Opacity").setValueAtTime(14, 0);
    
    // Subtitle animation
    subtitleText.property("Transform").property("Position").setValueAtTime(2.5, [COMP_WIDTH/2, COMP_HEIGHT/2 + 150]);
    subtitleText.property("Transform").property("Position").setValueAtTime(4, [COMP_WIDTH/2, COMP_HEIGHT/2 + 50]);
    subtitleText.property("Transform").property("Opacity").setValueAtTime(2.5, 0);
    subtitleText.property("Transform").property("Opacity").setValueAtTime(4, 100);
    subtitleText.property("Transform").property("Opacity").setValueAtTime(12, 100);
    subtitleText.property("Transform").property("Opacity").setValueAtTime(14, 0);
    
    // Lens flare animation
    lensFlare.property("Flare Brightness").setValueAtTime(0, 0);
    lensFlare.property("Flare Brightness").setValueAtTime(2, 150);
    lensFlare.property("Flare Brightness").setValueAtTime(2.5, 80);
    lensFlare.property("Flare Brightness").setValueAtTime(12, 80);
    lensFlare.property("Flare Brightness").setValueAtTime(14, 0);
    
    // Final title
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
    
    finalTitle.property("Scale").setValueAtTime(12, [0, 0, 100]);
    finalTitle.property("Scale").setValueAtTime(12.5, [110, 110, 100]);
    finalTitle.property("Scale").setValueAtTime(13, [100, 100, 100]);
    finalTitle.property("Opacity").setValueAtTime(12, 0);
    finalTitle.property("Opacity").setValueAtTime(12.3, 100);
    
    var finalGlow = finalTitle.Effects.addProperty("ADBE Glow2");
    finalGlow.property("Glow Intensity").setValue(3);
    finalGlow.property("Glow Radius").setValue(40);
    finalGlow.property("Color A").setValue([1, 0.8, 0, 1]);
    
    // Success message
    alert("🎬 SUPERHERO MOVIE INTRO CREATED SUCCESSFULLY! 🎬\n\n" +
          "✅ Base composition with cinematic background\n" +
          "✅ Animated title and subtitle text\n" +
          "✅ Character placeholder layers\n" +
          "✅ Particle effects and lens flares\n" +
          "✅ Professional animations and transitions\n\n" +
          "NEXT STEPS:\n" +
          "1. Import your superhero images (PNG with transparency)\n" +
          "2. Replace the gray placeholder layers with your images\n" +
          "3. Fine-tune positions and timing\n" +
          "4. Add background music and sound effects\n" +
          "5. Render your epic superhero intro!\n\n" +
          "📁 Check the README.md file for detailed instructions\n" +
          "🎵 See audio/ folder for music recommendations\n" +
          "🖼️ See assets/ folder for image placement guide");
    
} catch(error) {
    alert("❌ Error creating superhero intro: " + error.toString() + "\n\nPlease check:\n- After Effects scripting is enabled\n- You have a valid project open\n- All required effects are available");
}

app.endUndoGroup();