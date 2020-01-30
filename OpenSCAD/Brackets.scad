include <Parameters.scad>

module PowerSocketBracket()
{
    width = 18;
    heigth = 22;
    difference()
    {
        union()
        {
            translate([width/2,0,heigth/2])
            rotate([-90,0,0])
            cylinder(h=3,d=width);
            cube([width,3,heigth/2]);
            cube([width,width,3]);
        }
         union()
        {
            translate([width/2,-epsilon,heigth/2])
            rotate([-90,0,0])
            cylinder(d=8,h=3+2*epsilon);
            translate([width/2,width/2,(3+epsilon)])
            rotate([180,0,0])
                MountingScrewHole();
        }       
    }
}



module ScrewTagHole(thickness)
{
    difference() 
    {
        union()
        {   
           cylinder(h= thickness,d=10);
            translate([0,-5,0])
                cube([10,10,thickness]);
         }
        union()
        {   
            translate([0,0,-epsilon])
                cylinder(h= thickness+2*epsilon,d=4);        
            translate([0,0,epsilon+thickness-7/2])
                cylinder(h= 7/2,d1=0,d2=7);   
        }
    }


}

module SmallPcbMountingFrame(scewSpacingWidth,screwSpacingDepth,pcbScrewHoleDiameter)
{
    pillarHeight = 8;    
    frameThickness = 4;
    pillarOuterDiameter = 8;
    outerWidth = scewSpacingWidth+pillarOuterDiameter;
    difference() 
    {
        union()
        {
            translate([-outerWidth/2,-5,0])
                cube([outerWidth,10,frameThickness]);

            translate([outerWidth/2-pillarOuterDiameter,-screwSpacingDepth/2,0])
                cube([pillarOuterDiameter,screwSpacingDepth,frameThickness]);
            
            translate([-outerWidth/2,-screwSpacingDepth/2,0])
                cube([pillarOuterDiameter,screwSpacingDepth,frameThickness]);
            
            translate([scewSpacingWidth/2,screwSpacingDepth/2,0])
                cylinder(d=pillarOuterDiameter,h=pillarHeight);
            translate([scewSpacingWidth/2,-screwSpacingDepth/2,0])
                cylinder(d=pillarOuterDiameter,h=pillarHeight);
            translate([-scewSpacingWidth/2,screwSpacingDepth/2,0])
                cylinder(d=pillarOuterDiameter,h=pillarHeight);
            translate([-scewSpacingWidth/2,-screwSpacingDepth/2,0])
                cylinder(d=pillarOuterDiameter,h=pillarHeight);
        }
        union()
        {
            translate([scewSpacingWidth/2,screwSpacingDepth/2,-epsilon])
                cylinder(d=pcbScrewHoleDiameter,h=pillarHeight+2*epsilon);
            translate([scewSpacingWidth/2,-screwSpacingDepth/2,-epsilon])
                cylinder(d=pcbScrewHoleDiameter,h=pillarHeight+2*epsilon);
            translate([-scewSpacingWidth/2,screwSpacingDepth/2,-epsilon])
                cylinder(d=pcbScrewHoleDiameter,h=pillarHeight+2*epsilon);
            translate([-scewSpacingWidth/2,-screwSpacingDepth/2,-epsilon])
                cylinder(d=pcbScrewHoleDiameter,h=pillarHeight+2*epsilon);
                        
        }
    }
    translate([-(outerWidth+10)/2,0,0])
        ScrewTagHole(frameThickness);
    translate([(outerWidth+10)/2,0,0])
        rotate([0,0,180])
            ScrewTagHole(frameThickness);

}

module Dm7688MountingFrame(firstNote)
{
    frameThickness = 4;
    engraveDepth = 2;
    pillarHeight = 8;
    
    pcbScrewHoleDiameter = 2.5;
    
    difference() 
    {
        union()
        {
            cube([10,70,frameThickness]);
            translate([90,0,0])
                cube([10,70,frameThickness]);
            
            
            translate([0,-16,0])
                cube([100,16,frameThickness]);
            translate([0,70,0])
                cube([100,16,frameThickness]);
            
            
            translate([5,5,0])
                cylinder(d=10,h=pillarHeight);
            translate([95,5,0])
                cylinder(d=10,h=pillarHeight);
            translate([5,65,0])
                cylinder(d=10,h=pillarHeight);
            translate([95,65,0])
                cylinder(d=10,h=pillarHeight);
        }
        union()
        {
            translate([5,5,-epsilon])
                cylinder(d=pcbScrewHoleDiameter,h=pillarHeight+2*epsilon);
            translate([95,5,-epsilon])
                cylinder(d=pcbScrewHoleDiameter,h=pillarHeight+2*epsilon);
            translate([5,65,-epsilon])
                cylinder(d=pcbScrewHoleDiameter,h=pillarHeight+2*epsilon);
            translate([95,65,-epsilon])
                cylinder(d=pcbScrewHoleDiameter,h=pillarHeight+2*epsilon);
            
            for (i=[0:7])
            {
                noteNumber=firstNote+i;
                lableText = str(noteNumber);
                
                translate([15+10*i,-8,frameThickness+epsilon-engraveDepth])
                    rotate([0,0,90])
                        linear_extrude(height = engraveDepth)
                            #text(text=lableText,valign="center",halign="center",size=5);
            }    
 
            for (i=[0:7])
            {
                noteNumber=firstNote+i+8;
                lableText = str(noteNumber);
                
                translate([5+8*10-10*i,70+8,frameThickness+epsilon-engraveDepth])
                    rotate([0,0,90])
                        linear_extrude(height = engraveDepth)
                            #text(text=lableText,valign="center",halign="center",size=5);
            }              
        }
    }
    translate([-10,5,0])
        ScrewTagHole(frameThickness);
    translate([-10,65,0])
        ScrewTagHole(frameThickness);
    translate([110,5,0])
        rotate([0,0,180])
            ScrewTagHole(frameThickness);
    translate([110,65,0])
        rotate([0,0,180])
            ScrewTagHole(frameThickness);
}


//Dm7688MountingFrame(72);
//translate([150,0,0])
//Dm7688MountingFrame(72+16);


SmallPcbMountingFrame(76,16,2);

