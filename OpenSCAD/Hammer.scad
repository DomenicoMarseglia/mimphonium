include <Parameters.scad>

hammerShankDiameter=8;


// This value is added onto the diameter of the magnet to make the hole a snug fit.
// The magnets should be held tight enough that they do not fall out, but no so tight as they cannot
// be pushed in place easily.
// It will vary depending on 3d printer settings, so an amount of trial and error may be
// needed to get it right.
magnetTightClearance = 0.1;

// This value is added onto the diameter of the spindle to make the hole a snug fit.
// The spindle should be held tightly enough so that the hammer does not slide along its length
// in operation, but not so tight that the spindle cannot be pushed in easily.
// It will vary depending on 3d printer settings, so an amount of trial and error may be
// needed to get it right.
spindleTightClearance = 0.1;

hammerHeadDiameter = 25;
hammerHeadWidth = 13;
magnetShift = 1 + hammerBlockRadius - magnetDepth/2; 

endCapHeight = 4;


// This is the head if the hammer, the part that comes into contact with the chime when it is struck
module HammerHead()
{
	
        difference()
        {
            union()
            {
                rotate([90,0,0])
                    cylinder(d=hammerHeadDiameter,h=hammerHeadWidth,center=true);
                cylinder(d=hammerHeadWidth,h=hammerHeadDiameter,center=true);
            }
            union()
            {
                cylinder(d=hammerShankDiameter+epsilon,h=hammerHeadDiameter+epsilon,center=true);
            }
        }
}


module HammerShankEnd()
{
    looseClearance = 0.2;
    
    difference()
    {
        union()
        {
            cylinder(d2=hammerShankDiameter,d1=hammerHeadWidth-1,h=endCapHeight);
            translate([0,0,-(hammerHeadDiameter-1)])
                cylinder(d=hammerShankDiameter-looseClearance,h=hammerHeadDiameter-1);
        }
        union()
        {
            translate([0,0,-(hammerHeadDiameter/2+12)])
                cylinder(d=2,h=14);
        }
    }
}

module HammerShankEndCap()
{
    translate([0,0,-endCapHeight])
        difference() 
        {
            union()
            {
                cylinder(d1=hammerShankDiameter,d2=hammerHeadWidth-1,h=endCapHeight);
            }
            union()
            {
                translate([0,0,-epsilon])
                    cylinder(d=3,h=endCapHeight+2*epsilon); 
                translate([0,0,-epsilon])
                    cylinder(d1=6,d2=3,h=2);                 
            }
        }
}


module HammerBlock()
{
	difference()
	{
		union()
		{
			union()
			{
                intersection()
                {
                    rotate ([90,0,0])
                        cylinder(h=hammerBlockWidth,r=hammerBlockRadius,center = true); 
                    cube([2*(hammerBlockRadius + epsilon), hammerBlockWidth + 2*epsilon, coilOuterHeight],center=true);
                }
			}
		}

		union()
		{
            magnetHoleDiamater = magnetDiameter + magnetTightClearance;
            spindleHoleDiameter = spindleDiameter + spindleTightClearance;
			// magnet holes
			translate([magnetShift,0,0])
		   		rotate ([0,90,0])
					cylinder(h=magnetDepth,d=magnetHoleDiamater,center=true);
			translate([-1 * magnetShift,0,0])
				rotate ([0,90,0])
					cylinder(h=magnetDepth,d=magnetHoleDiamater,center=true);
            
			// spindle hole
			rotate ([90,0,0])
                cylinder(h=hammerSpindleLength,d=spindleHoleDiameter,center=true); 
		}
	}
}

module HammerBlockAndShank (hammerLength)
{
	difference()
	{
		union()
		{
            HammerBlock();

			translate([0,0,-(hammerLength-hammerHeadDiameter/2)])
                cylinder(d=hammerShankDiameter,h=hammerLength-coilOuterHeight/2-hammerHeadDiameter/2);

			translate([0,0,-(hammerLength-hammerHeadDiameter/2)])
                HammerShankEnd();
		}
	}
}




module HammerAssembly(hammerLength,angle)
{
	rotate([0,angle,0])
	{
		HammerBlockAndShank(hammerLength);
        translate([0,0,-(hammerLength)])
            HammerHead();
        translate([0,0,-(hammerLength+hammerHeadDiameter/2)])
            HammerShankEndCap();
	}
}

//HammerShankEndCap();
HammerAssembly(hammerLength,45);


//HammerBlockAndShank(hammerLength);
//HammerHead();
//HammerShankEndCap();

