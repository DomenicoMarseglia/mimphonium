include <Parameters.scad>


coilOuterWidth = 34;
coilWindingDepth = 3;
coilFlangeThickness = 2;

module TrapezoidPyramid(w,l,h)
{
	linear_extrude(height = h, scale = 0.25) square([w,l], center = true);
}

module RoundedCornerCube(depth,length,height,radius)
{
    hull()
    {
        translate([(depth/2-radius),(length/2-radius),0])
            cylinder(r1=radius,r2=radius,h=height,center=true);
        translate([-(depth/2-radius),(length/2-radius),0])
            cylinder(r1=radius,r2=radius,h=height,center=true);
        translate([(depth/2-radius),-(length/2-radius),0])
            cylinder(r1=radius,r2=radius,h=height,center=true);
        translate([-(depth/2-radius),-(length/2-radius),0])
            cylinder(r1=radius,r2=radius,h=height,center=true);
    }
}

module WindingTag()
{
    tagTotalLength = 3;
    tagShankLength = 2;
    tagShankWidth = 3;
    tagHeadWidth = 5;
    
    // shank
    translate([-tagShankWidth/2,0,-coilFlangeThickness/2])
        cube([tagShankWidth,tagShankLength,coilFlangeThickness]);
    // head
	translate([-tagHeadWidth/2,tagShankLength,-coilFlangeThickness/2])
    	cube([tagHeadWidth,tagTotalLength-tagShankLength,coilFlangeThickness]);    
}

module CoilBobbin()
{
    spindleBearingClearance = 0.4;
    loosePivotHoleDiameter = spindleDiameter + spindleBearingClearance;

	wireRadius = 1.25;
	wireHoleDepth = 15;

	difference()
	{
		union()
		{
            flangeZOffset = (coilOuterHeight-coilFlangeThickness)/2;
            RoundedCornerCube(coilOuterDepth-coilWindingDepth,coilOuterWidth-coilWindingDepth,magnetDiameter,6);

            // upper flange
			translate([0,0,flangeZOffset])
				cube([coilOuterDepth,coilOuterWidth,coilFlangeThickness],center=true);
            
            // lower flange
			translate([0,0,-flangeZOffset])
				cube([coilOuterDepth,coilOuterWidth,coilFlangeThickness],center=true);
            
            // sloped inner edges to coil recess
			translate([0,0,-(flangeZOffset-coilFlangeThickness/2)])
				TrapezoidPyramid(coilOuterDepth,coilOuterWidth,6);
			translate([0,0,(flangeZOffset-coilFlangeThickness/2)]) mirror([0,0,1]) 
				TrapezoidPyramid(coilOuterDepth,coilOuterWidth,6);

            // mounting pegs
			translate([0,0,-(coilOuterHeight/2+pegLength)])  
            {
                translate([bobbinPegXOffset,bobbinPegYOffset,0])  
                    cylinder(h=pegLength,r=pegRadius);
                translate([-bobbinPegXOffset,bobbinPegYOffset,0])  
                    cylinder(h=pegLength,r=pegRadius);
                translate([bobbinPegXOffset,-bobbinPegYOffset,0])  
                    cylinder(h=pegLength,r=pegRadius);
                translate([-bobbinPegXOffset,-bobbinPegYOffset,0])  
                    cylinder(h=pegLength,r=pegRadius);
            }
            
			translate([bobbinPegXOffset,coilOuterWidth/2,flangeZOffset])
                WindingTag();
			translate([-bobbinPegXOffset,coilOuterWidth/2,flangeZOffset])
                WindingTag();

		}
		union ()
		{

            // The main cut out where the hammer hub will rotate
			cube([hammerBlockRadius*2+4,hammerBlockCutoutWidth,coilOuterHeight+2*epsilon],true);
            
            // The slightly oversized cylinder in which the hammer spindle will rotate
			rotate ([90,90,0])		
				cylinder(h=hammerSpindleLength,d=loosePivotHoleDiameter,center=true);
            
            // The slot leading down to the spindle shaft so that the hammer can drop into place
			translate([0,0,(coilOuterHeight)/4+epsilon])
				cube([loosePivotHoleDiameter,hammerSpindleLength,coilOuterHeight/2+epsilon],center=true);

            // This feature prevents the slot into which the hammer drops from
            // closing in at the top due to the way the first printed layers tend to
            // spread out on the heater plate
            translate([0,0,coilOuterHeight/2+epsilon]) mirror([0,0,1]) 
				TrapezoidPyramid(loosePivotHoleDiameter + 1,hammerSpindleLength+1,1);

            // Holes into which the wires can be glued
			translate([bobbinPegXOffset,bobbinPegYOffset,(coilOuterHeight - wireHoleDepth + 2)/2])  
				cylinder(h=wireHoleDepth,r=wireRadius,center=true);
			translate([-bobbinPegXOffset,bobbinPegYOffset,(coilOuterHeight - wireHoleDepth + 2)/2])  
				cylinder(h=wireHoleDepth,r=wireRadius,center=true);

            // The slightly oversized tops of the wire holes that prevent the holes
            // from closing up when printed
			translate([bobbinPegXOffset,bobbinPegYOffset,(coilOuterHeight + 2)/2])  
				cylinder(h=4,r1=wireRadius,r2=wireRadius+1,center=true);
			translate([-bobbinPegXOffset,bobbinPegYOffset,(coilOuterHeight + 2)/2])  
				cylinder(h=4,r1=wireRadius,r2=wireRadius+1,center=true);

		}
	}
}

module CoilBobbinWithReboundArrester()
{
    coilOuterHeight = magnetDiameter;
    
	armZShift = -(coilOuterHeight/2 + supportDepth / 2);
    width = 10;
    
    CoilBobbin();
    
       
    translate([coilOuterDepth/2 -1,0,-16.5-coilOuterHeight/2])
		cube([2,width,33 ],true);
            
                
    translate([coilOuterDepth/2 -1 - 4,0,-36.5-coilOuterHeight/2])
        rotate([0,45,0])
            cube([2,width,12 ],true);
                
     translate([coilOuterDepth/2 -1 -8,0,armZShift-39.5])
        cube([2,width,7],true);
}



CoilBobbinWithReboundArrester();