include <Parameters.scad>

supportThickness = 4;

chimeToSupportGap = 2;

chimeArmOffset = chimeToSupportGap + chimeRadius+supportThickness/2;




// This is the height in mm of the top chime support above the hammer pivot point
function CalculateChimeTopHoleHeight(chimeLength, hammerLength) = CalculateChimeHolePosition(chimeLength) - hammerLength;


// This is the cutout needed for a 3.5 x 20 wood screw
// These screws are used to mount the various arms and brackets to the wooden backplane
module MountingScrewHole()
{
    cylinder(d=4,h=20);
    cylinder(d2=4,d1=8,h=4);    
}

module RoundTopCylinder(diameter,height)
{
    cylinder(d=diameter,h=height-diameter/2);
    translate([0,0,height-diameter/2])
        sphere(d=diameter);
}

module PegCoilSupportHoleSet()
{
	translate([bobbinPegXOffset,bobbinPegYOffset,0])  
		cylinder(h=pegLength+2,r=pegRadius+pegClearance,$fn=20,center=true);
	translate([-bobbinPegXOffset,bobbinPegYOffset,0])  
		cylinder(h=pegLength+2,r=pegRadius+pegClearance,$fn=20,center=true);
	translate([bobbinPegXOffset,-bobbinPegYOffset,0])  
		cylinder(h=pegLength+2,r=pegRadius+pegClearance,$fn=20,center=true);
	translate([-bobbinPegXOffset,-bobbinPegYOffset,0])  
		cylinder(h=pegLength+2,r=pegRadius+pegClearance,$fn=20,center=true);
}


module ChimeSupportPins(armYOffset)
{
    looseClearance = 0.2;
    pinLength = 5;
	difference()
	{
		union()
		{
			translate([0,-armYOffset,0])
				cube([supportDepth,supportThickness,supportDepth],center=true);
			translate([0,armYOffset,0])
				cube([supportDepth,supportThickness,supportDepth],center=true);

 
			rotate ([90,0,0])	
                translate([0,0,-(armYOffset-supportThickness/2)])
                    RoundTopCylinder(chimeMountHoleDiameter-looseClearance,pinLength);
				
			rotate ([-90,0,0])	
                translate([0,0,-(armYOffset-supportThickness/2)])
                    RoundTopCylinder(chimeMountHoleDiameter-looseClearance,pinLength);

			translate([0,armYOffset,0])
				rotate ([45,0,0])		
					cube([supportDepth,6,6],center=true);
			translate([0,-armYOffset,0])
				rotate ([45,0,0])		
					cube([supportDepth,6,6],center=true);

		}
		union()
		{
			translate([0,(armYOffset+supportThickness/2+3),0])
                cube([supportDepth+1,6,6],center=true);
			translate([0,-(armYOffset+supportThickness/2+3),0])
				cube([supportDepth+1,6,6],center=true);
			translate([0,0,-7])
				cube([supportDepth+1,2*(armYOffset+supportDepth),6],center=true);
			translate([0,0,7])
				cube([supportDepth+1,2*(armYOffset+supportDepth),6],center=true);
		}
	}

}

module LowerChimeSupport()
{    
    armZShift = -supportDepth/2;
    armLength = chimeStandoff + supportDepth/2; 
	difference()
	{
		union()
		{
            translate([chimeStandoff,0,0])
                ChimeSupportPins(chimeArmOffset);

			// right horizontal arm
			translate([0,(chimeArmOffset)-supportThickness/2,armZShift])
				cube([armLength,supportThickness,supportDepth]);

			// left horizontal arm
			translate([0,-(chimeArmOffset)-supportThickness/2,armZShift])
                cube([armLength,supportThickness,supportDepth]);

			// back plate
			translate([0,-chimeArmOffset,armZShift])
            	cube([supportThickness,2*chimeArmOffset,supportDepth]);

		}
		union()
		{
            translate([supportThickness+epsilon,0,0])
                rotate([0,-90,0])
					MountingScrewHole();       
		}
	}
}

// This object holds the chime and the coil bobbin relative to each other
module UpperChimeSupport(noteNumber,chimeLength)
{
    coilSupportLength = hammerStandoff + coilOuterDepth / 2;
	lableText = str("N", noteNumber);

	armZShift = -(coilOuterHeight/2 + supportDepth / 2);
    
	chimeHolePosition = CalculateChimeTopHoleHeight(chimeLength, hammerLength);

	verticalArmShift = (chimeHolePosition-armZShift)/2;
	verticalArmHeight = abs(verticalArmShift)*2;


	chimeArmHeight = armZShift - chimeHolePosition;

	difference()
	{
		union()
		{
            // right vertical arm
			translate([chimeStandoff,chimeArmOffset,armZShift + verticalArmShift])
				cube([supportDepth,supportThickness,verticalArmHeight],center=true);

            // left vertical arm
			translate([chimeStandoff,-chimeArmOffset,armZShift + verticalArmShift])
				cube([supportDepth,supportThickness,verticalArmHeight],center=true);

            // chime support pins
            translate([chimeStandoff,0,chimeHolePosition])
				ChimeSupportPins(chimeArmOffset);

			// right horizontal arm
			translate([coilSupportLength/2,chimeArmOffset,armZShift])
				cube([coilSupportLength,supportThickness,supportDepth],true);

			// left horizontal arm
			translate([coilSupportLength/2,-chimeArmOffset,armZShift])
				cube([coilSupportLength,supportThickness,supportDepth],true);

			// surround for coil support pins
			translate([hammerStandoff,0,armZShift])
				cube([coilOuterDepth,2*chimeArmOffset,supportDepth],true);

			// back plate
			translate([supportThickness/2,0,armZShift])
				cube([supportThickness,2*chimeArmOffset + supportThickness,supportDepth],true);

		}
		union()
		{
				translate([supportThickness+epsilon,0,armZShift])
                    rotate([0,-90,0])
                        MountingScrewHole();
				translate([hammerStandoff,0,-(magnetDiameter/2+pegLength/2)-epsilon])  
					PegCoilSupportHoleSet();

				translate([hammerStandoff,0,armZShift])
					cube([coilOuterDepth+2*epsilon,hammerBlockCutoutWidth,supportDepth+epsilon],true);

				translate([20,0.25-chimeArmOffset-supportThickness/2,armZShift-3])
					rotate([90,0,0])
                        linear_extrude(height = 1)
                            text(text = lableText,size = 6);

		}


	}
}



//LowerChimeSupport();

// Note that the lengths here suit the chimes in my mimphonium.
// They will almost certainly not be exactly right for yours. Measure the actual chimes you have cut
// and modify the lengths here so that the chime supports fit your chimes properly.
//UpperChimeSupport(	72	,	435	);
//UpperChimeSupport(	73	,	423	);
//UpperChimeSupport(	74	,	412	);
//UpperChimeSupport(	75	,	402	);
//UpperChimeSupport(	76	,	389	);
//UpperChimeSupport(	77	,	377	);
//UpperChimeSupport(	78	,	367	);
//UpperChimeSupport(	79	,	353	);
//UpperChimeSupport(	80	,	345	);
//UpperChimeSupport(	81	,	334	);
//UpperChimeSupport(	82	,	325	);
//UpperChimeSupport(	83	,	311	);
//UpperChimeSupport(	84	,	309	);
//UpperChimeSupport(	85	,	297	);
//UpperChimeSupport(	86	,	290	);
//UpperChimeSupport(	87	,	281	);
//UpperChimeSupport(	88	,	275	);
//UpperChimeSupport(	89	,	265	);
//UpperChimeSupport(	90	,	258	);
//UpperChimeSupport(	91	,	252	);
//UpperChimeSupport(	92	,	242	);
//UpperChimeSupport(	93	,	238	);
//UpperChimeSupport(	94	,	228	);
//UpperChimeSupport(	95	,	221	);
//UpperChimeSupport(	96	,	212	);
//UpperChimeSupport(	97	,	208	);
//UpperChimeSupport(	98	,	202	);
//UpperChimeSupport(	99	,	195	);
//UpperChimeSupport(	100	,	189	);
//UpperChimeSupport(	101	,	184	);
//UpperChimeSupport(	102	,	178	);
//UpperChimeSupport(	103	,	173	);


