$fn=100;

// This value is used to remove any ambiguity when holes are cut out to an extnernal face of an object.
// The shape used to make the hole sticks out this much.
epsilon = 0.01;

// This is the diameter of the hole that is drilled into the chime for the support pins
chimeMountHoleDiameter = 4;

// This is the diameter of the copper pipe used to make the chimes
chimeDiameter = 22;
chimeRadius = chimeDiameter/2;

// This is the height of the arms on the upper and lower supports
supportDepth = 8;

// This is the distance from the back plane to the middle of the chimne
chimeStandoff = 24;

// This is the radius of the hammer hub
hammerBlockRadius = 14;

// This is the distance from the back plane to the pivot point for the hammers
hammerStandoff = 70;



// The magnets are discs 8mm in diameter and 5 mm thick
//magnetRadius = 4;
magnetDiameter = 8;
magnetDepth = 7;


coilOuterDepth = hammerBlockRadius*2+8;
coilOuterHeight = magnetDiameter + 4;

// This is the length of the hammer from the middle of the pivot to the middle of the head
hammerLength = 100;    

// These define the pegs that stick out of the bottom of the bobbins and the coresponding holes
// in the upper chime supports
pegRadius = 2;
pegClearance = 0.2;
pegLength = supportDepth + 1;
bobbinPegXOffset = 8;
bobbinPegYOffset = 12;

// For the sake of a rough model for the top level assembly,
// these values are measured from an arbitrary length of copper pipe.
// Once you have a real piece of pipe cut, change this to improve the accuracy of the top level assemblymodel.
// Even then, do not rely on the calculations from this for actually cutting the back board
sampleTubeLength = 421;
sampleTubeFrequency = 560;
sampleConstant = sampleTubeLength * sampleTubeLength * sampleTubeFrequency;

// Concert A has MIDI note number 69, and has a frwquency of 440 Hz
note69Frequency = 440;

// There are 12 semitones in an octave
twelfthRoot2 = pow(2,1/12);





// This is the width of the hammer block
hammerBlockWidth = magnetDiameter + 4;

hammerBlockCutoutWidth = hammerBlockWidth+2;

// This value is added onto gaps to make the parts a tight push fit, e.g. for a magnet
//tightClearance = 0.1;

// This is the length of the spindle on which the hammer rotates
hammerSpindleLength = 24;

// This is the diameter of the 3d printing filament that we use as a material for the hammer spindle
spindleDiameter = 3;


// This is the distance from the middle of the chime to where the support holes need to be drilled
// One with this value, one with this value * -1
function CalculateChimeHolePosition(chimeLength) = (0.5 - 0.2242) * chimeLength;