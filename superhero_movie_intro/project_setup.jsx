// Superhero Movie Intro - After Effects Project Setup Script
// This script creates a complete movie intro composition with the provided superhero images

// Project settings
var PROJECT_NAME = "Superhero Movie Intro";
var COMP_NAME = "Main Intro";
var COMP_WIDTH = 1920;
var COMP_HEIGHT = 1080;
var COMP_DURATION = 15; // 15 seconds
var FRAME_RATE = 24;

// Create new project
app.beginUndoGroup("Create Superhero Movie Intro");

try {
    // Create new composition
    var comp = app.project.items.addComp(COMP_NAME, COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION, FRAME_RATE);
    
    // Background setup
    var bgSolid = comp.layers.addSolid([0.05, 0.05, 0.15], "Dark Background", COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION);
    
    // Create gradient overlay
    var gradientSolid = comp.layers.addSolid([0.1, 0.1, 0.3], "Gradient Overlay", COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION);
    
    // Add gradient effect to create cinematic background
    var gradientEffect = gradientSolid.Effects.addProperty("ADBE 4 Color Gradient");
    gradientEffect.property("Point 1").setValue([0, 0]);
    gradientEffect.property("Point 2").setValue([COMP_WIDTH, COMP_HEIGHT]);
    gradientEffect.property("Color 1").setValue([0.02, 0.02, 0.1, 1]);
    gradientEffect.property("Color 2").setValue([0.1, 0.05, 0.2, 1]);
    gradientEffect.property("Color 3").setValue([0.15, 0.1, 0.25, 1]);
    gradientEffect.property("Color 4").setValue([0.05, 0.02, 0.15, 1]);
    
    // Set blend mode for gradient
    gradientSolid.blendingMode = BlendingMode.OVERLAY;
    
    // Title text setup
    var titleText = comp.layers.addText("HEROES");
    var titleTextProp = titleText.property("Source Text");
    var titleTextDocument = titleTextProp.value;
    titleTextDocument.fontSize = 120;
    titleTextDocument.fillColor = [1, 1, 1];
    titleTextDocument.font = "Arial-BoldMT";
    titleTextDocument.justification = ParagraphJustification.CENTER_JUSTIFY;
    titleTextProp.setValue(titleTextDocument);
    
    // Position title text
    titleText.property("Position").setValue([COMP_WIDTH/2, COMP_HEIGHT/2 - 100]);
    
    // Add glow effect to title
    var glowEffect = titleText.Effects.addProperty("ADBE Glow2");
    glowEffect.property("Glow Colors").setValue(1); // A&B Colors
    glowEffect.property("Color A").setValue([0.2, 0.6, 1, 1]); // Blue glow
    glowEffect.property("Color B").setValue([1, 0.3, 0.3, 1]); // Red glow
    glowEffect.property("Glow Intensity").setValue(2);
    glowEffect.property("Glow Radius").setValue(30);
    
    // Subtitle text
    var subtitleText = comp.layers.addText("RISE");
    var subtitleTextProp = subtitleText.property("Source Text");
    var subtitleTextDocument = subtitleTextProp.value;
    subtitleTextDocument.fontSize = 60;
    subtitleTextDocument.fillColor = [0.8, 0.8, 0.8];
    subtitleTextDocument.font = "Arial-BoldMT";
    subtitleTextDocument.justification = ParagraphJustification.CENTER_JUSTIFY;
    subtitleTextProp.setValue(subtitleTextDocument);
    
    // Position subtitle
    subtitleText.property("Position").setValue([COMP_WIDTH/2, COMP_HEIGHT/2 + 50]);
    
    // Add subtle glow to subtitle
    var subtitleGlow = subtitleText.Effects.addProperty("ADBE Glow2");
    subtitleGlow.property("Glow Intensity").setValue(1);
    subtitleGlow.property("Glow Radius").setValue(15);
    
    // Create particle system background
    var particleLayer = comp.layers.addSolid([1, 1, 1], "Particles", COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION);
    particleLayer.moveAfter(gradientSolid);
    
    // Add CC Particle Systems II for energy effects
    var particleEffect = particleLayer.Effects.addProperty("CC Particle Systems II");
    particleEffect.property("Producer").property("Position").setValue([COMP_WIDTH/2, COMP_HEIGHT/2]);
    particleEffect.property("Producer").property("Radius X").setValue(200);
    particleEffect.property("Producer").property("Radius Y").setValue(200);
    particleEffect.property("Physics").property("Velocity").setValue(50);
    particleEffect.property("Physics").property("Gravity").setValue(0);
    particleEffect.property("Particle").property("Birth Rate").setValue(5);
    particleEffect.property("Particle").property("Longevity (sec)").setValue(3);
    particleEffect.property("Particle").property("Particle Type").setValue(3); // Faded Sphere
    particleEffect.property("Particle").property("Birth Size").setValue(0.5);
    particleEffect.property("Particle").property("Death Size").setValue(0.1);
    particleEffect.property("Particle").property("Size Variation").setValue(50);
    particleEffect.property("Particle").property("Birth Color").setValue([0.3, 0.7, 1, 1]);
    particleEffect.property("Particle").property("Death Color").setValue([1, 0.3, 0.3, 1]);
    
    // Set particle blend mode
    particleLayer.blendingMode = BlendingMode.ADD;
    particleLayer.opacity.setValue(30);
    
    // Animation keyframes
    
    // Title animation - scale and opacity
    titleText.property("Transform").property("Scale").setValueAtTime(0, [0, 0, 0]);
    titleText.property("Transform").property("Scale").setValueAtTime(2, [120, 120, 100]);
    titleText.property("Transform").property("Scale").setValueAtTime(2.5, [100, 100, 100]);
    
    titleText.property("Transform").property("Opacity").setValueAtTime(0, 0);
    titleText.property("Transform").property("Opacity").setValueAtTime(1.5, 100);
    titleText.property("Transform").property("Opacity").setValueAtTime(12, 100);
    titleText.property("Transform").property("Opacity").setValueAtTime(14, 0);
    
    // Subtitle animation - slide up and fade
    subtitleText.property("Transform").property("Position").setValueAtTime(2.5, [COMP_WIDTH/2, COMP_HEIGHT/2 + 150]);
    subtitleText.property("Transform").property("Position").setValueAtTime(4, [COMP_WIDTH/2, COMP_HEIGHT/2 + 50]);
    
    subtitleText.property("Transform").property("Opacity").setValueAtTime(2.5, 0);
    subtitleText.property("Transform").property("Opacity").setValueAtTime(4, 100);
    subtitleText.property("Transform").property("Opacity").setValueAtTime(12, 100);
    subtitleText.property("Transform").property("Opacity").setValueAtTime(14, 0);
    
    // Camera shake effect for impact
    var cameraShake = comp.layers.addNull();
    cameraShake.name = "Camera Shake";
    
    // Parent all layers to camera shake for global movement
    titleText.parent = cameraShake;
    subtitleText.parent = cameraShake;
    
    // Add wiggle expression to camera shake
    var shakeExpression = "freq = 10;\namp = 8;\nwiggle(freq, amp);";
    cameraShake.property("Transform").property("Position").expression = shakeExpression;
    
    // Animate camera shake intensity
    cameraShake.property("Transform").property("Position").setValueAtTime(0, [0, 0, 0]);
    cameraShake.property("Transform").property("Position").setValueAtTime(1.8, [0, 0, 0]);
    cameraShake.property("Transform").property("Position").setValueAtTime(2.2, [5, 5, 0]);
    cameraShake.property("Transform").property("Position").setValueAtTime(3, [0, 0, 0]);
    
    // Add lens flare effect
    var flareLayer = comp.layers.addSolid([1, 1, 1], "Lens Flare", COMP_WIDTH, COMP_HEIGHT, 1, COMP_DURATION);
    flareLayer.moveToBeginning();
    
    var lensFlare = flareLayer.Effects.addProperty("ADBE Lens Flare");
    lensFlare.property("Flare Center").setValue([COMP_WIDTH/2, COMP_HEIGHT/2 - 100]);
    lensFlare.property("Flare Brightness").setValue(80);
    
    // Animate lens flare
    lensFlare.property("Flare Brightness").setValueAtTime(0, 0);
    lensFlare.property("Flare Brightness").setValueAtTime(2, 150);
    lensFlare.property("Flare Brightness").setValueAtTime(2.5, 80);
    lensFlare.property("Flare Brightness").setValueAtTime(12, 80);
    lensFlare.property("Flare Brightness").setValueAtTime(14, 0);
    
    flareLayer.blendingMode = BlendingMode.ADD;
    
    // Add sound visualization bars (placeholder for audio reactive elements)
    for(var i = 0; i < 20; i++) {
        var bar = comp.layers.addSolid([0.2 + i*0.04, 0.6, 1], "Audio Bar " + (i+1), 8, 100, 1, COMP_DURATION);
        bar.property("Position").setValue([100 + i*15, COMP_HEIGHT - 100]);
        bar.property("Anchor Point").setValue([4, 100]);
        
        // Animate bars with random scaling
        var randomScale = Math.random() * 200 + 50;
        bar.property("Transform").property("Scale").setValueAtTime(0, [100, randomScale, 100]);
        bar.property("Transform").property("Scale").setValueAtTime(2 + Math.random() * 2, [100, Math.random() * 300 + 100, 100]);
        bar.property("Transform").property("Scale").setValueAtTime(4 + Math.random() * 2, [100, Math.random() * 200 + 50, 100]);
        
        bar.blendingMode = BlendingMode.ADD;
        bar.opacity.setValue(70);
    }
    
    alert("Superhero Movie Intro composition created successfully!\n\nTo complete the setup:\n1. Import your superhero images\n2. Add them to the composition\n3. Position and animate them as needed\n4. Render your final intro!");
    
} catch(error) {
    alert("Error creating composition: " + error.toString());
}

app.endUndoGroup();