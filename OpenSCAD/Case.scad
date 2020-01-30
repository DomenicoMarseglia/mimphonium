include <Parameters.scad>




architraveWidth = 44;
architraveThickness = 13;

module Architrave(length = 2400)
{

    
    color("white")
    {
        translate([0,architraveWidth-architraveThickness,0])
            intersection()
            {
                cylinder(r=architraveThickness,h=length);
                cube([architraveThickness,architraveThickness,length]);
            }
        cube([architraveThickness,architraveWidth-architraveThickness,length]);
    }
}

module ChamferCutArchitrave(length)
{
    difference()
    {
        union()
        {
            Architrave(length);
        }
        union()
        {
            rotate([45,0,0])
                translate([-epsilon,0,-100])
                    cube([100,100,100]);
            translate([0,0,length])
                rotate([45,0,0])
                    translate([-epsilon,0,-100])
                       cube([100,100,100]);
        }
    }
        
}

module ArchitraveFrame(outerWidth,outerHeight)
{
    // left
    ChamferCutArchitrave(outerHeight);

    // right
    translate([0,outerWidth,outerHeight])
        rotate([180,0,0])
            ChamferCutArchitrave(outerHeight);
    
    // bottom
    translate([0,outerWidth,0])
        rotate([90,0,0])
            ChamferCutArchitrave(outerWidth);
    
    // top
    translate([0,0,outerHeight])
        rotate([-90,0,0])
            ChamferCutArchitrave(outerWidth);


}

module PlankFrame(depth,outerWidth,outerHeight,  thickness)
{
    // bottom
    cube([depth,outerWidth,thickness]);
    
    // top
    translate([0,0,outerHeight-thickness])
        cube([depth,outerWidth,thickness]);
    
    // left
    cube([depth,thickness,outerHeight]);
    
    // right
    translate([0,outerWidth-thickness,0])
        cube([depth,thickness,outerHeight]);
if (0)    
    
    difference()
    {
        union()
        {
            cube([depth,outerWidth,outerHeight]);
        }
        union()
        {
            translate([-epsilon,thickness,thickness])
                cube([depth+2*epsilon,outerWidth-2*thickness,outerHeight-2*thickness]);
        }
    }
     

}

laminateWidth = 145;
laminateThickness = 13.5;

module LaminateStrip(totalLength,firstPlankLength,color1,color2)
{
    color(color1)
    cube([laminateThickness,firstPlankLength,laminateWidth]);
    translate([0,firstPlankLength,0])
    color(color2)
        cube([laminateThickness,totalLength-firstPlankLength,laminateWidth]);
}

module LaminateArea(width,height)
{
    plankLength = 1220;
    
    firstOffcutLength = 2* plankLength - width;
    secondOffcutLength = firstOffcutLength + plankLength - width;
    thirdOffcutLength = secondOffcutLength + plankLength - width;
 //   intersection()
    //{
    //    union()
    //    {
    //        cube([50,width,height]) ;
    //    }
     //   union()
     //   {
            LaminateStrip(width,plankLength,"BurlyWood","BlanchedAlmond");
            translate([0,0,laminateWidth])
            LaminateStrip(width,firstOffcutLength,"SandyBrown","Tan");
            translate([0,0,2*laminateWidth])
            LaminateStrip(width,secondOffcutLength,"Wheat","BurlyWood");
            translate([0,0,3*laminateWidth])
            LaminateStrip(width,thirdOffcutLength,"NavajoWhite","BlanchedAlmond");

     //   }
        
   // }
}

module BoxFrame()
{
    outerWidth = 1400;
    outerHeight = 4 * laminateWidth + 2 * laminateThickness;
    timberWidth = 144;
    framedInnerDepth = 90;

    

    translate([timberWidth,0,0])
        ArchitraveFrame(outerWidth,outerHeight);
    
    // an outer frame made from timber 144 x 12
    color("bisque")
        PlankFrame(144,outerWidth,outerHeight,laminateThickness);
    
    // an inner fram made from 14 mm thick floor planks
    translate([timberWidth-framedInnerDepth,laminateThickness,laminateThickness])
        color("burlywood")
            PlankFrame(framedInnerDepth,outerWidth-2*laminateThickness,outerHeight-2*laminateThickness,laminateThickness);
    
    translate([timberWidth-framedInnerDepth-laminateThickness,laminateThickness,laminateThickness])
    LaminateArea(outerWidth-2*laminateThickness,outerHeight-2*laminateThickness);
}


module FrameStandoff()
{
    difference() 
    {
        union()
        {
            cylinder(d1=12,d2=15,h=6);
        }
        union()
        {
        translate([0,0,-epsilon])
            cylinder(d=4,h=6+2*epsilon); 
        translate([0,0,-epsilon])
            cylinder(d1=8,d2=4,h=4);                 
        }
    }

   
    
}


BoxFrame();