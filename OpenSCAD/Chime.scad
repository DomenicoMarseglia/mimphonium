include <Parameters.scad>


// This is a model of the chime. 
// It is not meant to be 3d printed.
// It is intended to be cut from a length of copper plumbing pipe.
// The origin of the pipe is the center point of the pipe.
module Chime(chimeLength)
{
	difference()
	{
        union()
        {
            // The external surface of the pipe
            cylinder(r=chimeRadius,h=chimeLength,center=true);
        }
        union()
        {
            chimeWallhickness = 0.5;
            
            // Inside of the pipe
            cylinder(r=chimeRadius-chimeWallhickness,h=chimeLength+epsilon,center=true);
     
            holePosition = CalculateChimeHolePosition(chimeLength);

            // Upper mounting holes
            translate ([0,0,holePosition])
                rotate([90,0,0])
                    cylinder(d=chimeMountHoleDiameter,h=chimeDiameter+2*epsilon,center=true);
            
            // Lower mounting holes
            translate ([0,0,-holePosition])
                rotate([90,0,0])
                    cylinder(d=chimeMountHoleDiameter,h=chimeDiameter+2*epsilon,center=true);
        }
	}
}

//Chime(150);