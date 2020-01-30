include <Parameters.scad>

use <Chime.scad>
use <ChimeSupports.scad>
use <Hammer.scad>
use <Bobbin.scad>
use <Case.scad>
use <Brackets.scad>

//Hammer
//	- Shank
//	- Shank End
//	- Head
//	- Pivot pin
//	- Hammer Block
//	- Magnet

//Chime



//UpperChimeSupport
//	BobbinSuppoertArms
//	ChimeSupportArms

//LowerChimeSupport

//Hammer Hub Assembly
//	Hammer Hub
//		Bobbin
//		Rebound Arrester
//		Winding Tag
//		Mounting Dowels
//		Winding Termination Holes
//Wire




$fn = 100;


noteSpacing = 40;




// Given a MIDI note number, this function calculates the frequency in Hz
function noteFrequency(n) = note69Frequency * pow(twelfthRoot2,(n-69));

function CalculateChimeLength(n) = sqrt(sampleConstant/noteFrequency(n));





module NoteAssembly(noteNumber,angle)
{
    chimeLength = CalculateChimeLength(noteNumber);
    
   
	translate([hammerStandoff,0,0])
		CoilBobbinWithReboundArrester();
	translate([hammerStandoff,0,0])
		HammerAssembly(hammerLength,angle);
	translate([chimeStandoff,0,-hammerLength])
		Chime(chimeLength);


    UpperChimeSupport(noteNumber,chimeLength);

    bottomChimeHolePosition = - (CalculateChimeHolePosition(chimeLength) + hammerLength);
    translate([0,0,bottomChimeHolePosition])
        LowerChimeSupport();
    
}


module TLA()
{
    firstNote = 72;
    lastNote = 103;

    BoxFrame();
    translate([50,80,400])
        for (noteNumber=[firstNote:lastNote])
        {
            translate([0,noteSpacing*(noteNumber-firstNote),0])
                NoteAssembly(noteNumber,0);
        }

}

TLA();


//HammerShankEnd();
//rotate([90,0,0])
//hammerHead(0);
//Chime(100);
//hammerBlock(0);

//rotate([0,180,0])
//    coilBobbinWithReboundArrester();

//translate([0,0,-150])
//HammerShankEndCap();

//rotate([180,0,0])
//hammerBlockAndShank(hammerLength-15);

//translate([0,noteSpacing*(1),0])







//rotate([0,-90,0])
//LowerChimeSupport();
//hammerHead(0);

//PowerSocketBracket();

//chimeSupportPins(chimeArmOffset);

//FrameStandoff();