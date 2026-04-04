/*
 * Copyright (c) 2025 Andrew Hewus Fresh <andrew@afresh1.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
holeDiameter   = 80;

magnetDiameter = 10;
magnetThickness = 5.30;
magnetDistance = holeDiameter/2 + 1.5*magnetDiameter;
magnetCount = 6;

layerHeight   = 0.36;
layersInCover = 3;
magnetCover = layerHeight * layersInCover;
plateWall   = 2;

screwSpacing  = 72;

screwLength   = 12;
screwDiameter = 4.5;

screwHeadThickness = 4;
screwHeadDiameter  = 8;

fanThickness = 25;
fanCornerDiameter = 5;
fanWidth = holeDiameter;

defaultPlateThickness = magnetThickness + magnetCover + plateWall;

plexiglass = 3.5;

$fa = $preview ? $fa : 1.0;
$fs = $preview ? $fs : 0.1;

magnetAngles = [ for (i=[0:magnetCount-1]) 360*i/magnetCount ];
magnetPoints = [ for (i=[0:magnetCount-1]) let(
        r=magnetDistance,
        theta=360*i/magnetCount
    ) [ r*cos(theta), r*sin(theta) ] ];

module magnetSample() {
	h = magnetThickness + 2*magnetCover + 0.3;
	samples = 3;

	xPoints = [ for(i=[0:samples-1]) plateWall + i*(magnetDiameter+plateWall+(i/10)) ];
	echo(xPoints);

	difference() {
		hull() for (x=xPoints) translate([x, 0, 0])
		    cylinder(d=magnetDiameter + 2*plateWall, h=h);

		for(i=[0:len(xPoints)-1]) translate([xPoints[i]-magnetDiameter/2+1,magnetDiameter/2,-0.1])
		    linear_extrude(magnetCover) rotate([180,0,0]) text(str(i+1));

		for(i=[0:len(xPoints)-1])
		    translate([xPoints[i], 0, h-magnetThickness-magnetCover])
			cylinder(d=magnetDiameter + i/10, h=magnetThickness);
	}
}

module blankPlate(h = defaultPlateThickness) {
    hull() for (theta=magnetAngles) rotate(theta)
        translate([magnetDistance,0,0])
            cylinder(d=magnetDiameter+2*plateWall, h=h);
}

module magnetPlate(h = defaultPlateThickness) {
    difference() {
        blankPlate(h);

        for (theta=magnetAngles) rotate(theta) translate([
                magnetDistance,
                0,
                h - ( magnetThickness + magnetCover)
            ]) cylinder(d=magnetDiameter * 1.1, h=magnetThickness);
        }
}

module mainPlate() {
    difference() {
        plateThickness = max(
            magnetThickness + magnetCover + plateWall,
            ( screwLength - plexiglass )/2
        );

        magnetPlate(plateThickness);

        // main hole
        translate([0,0,-1]) cylinder(d=holeDiameter, h=plateThickness + 2);

        // screw Holes
        for (x=[-0.5,0.5], y=[-0.5,0.5]) translate([
            x*screwSpacing,
            y*screwSpacing,
            plateThickness-(screwLength+screwHeadThickness)
        ]) {
                cylinder(d=screwDiameter, h=screwLength);
                translate([0,0,screwLength - 0.1])
                    cylinder(d=screwHeadDiameter, h=screwHeadThickness + 0.2);
            }
    }
}

module fanPlateOld() {
    difference() {
        plateThickness = max(
            magnetThickness + magnetCover + plateWall,
            ( screwLength - plexiglass )/2
        );

        magnetPlate(plateThickness);

        // air hole
        translate([0,0,-1]) cylinder(d=holeDiameter, h=plateThickness + 2);

        // screw Holes
        for (x=[-0.5,0.5], y=[-0.5,0.5]) translate([
            x*screwSpacing,
            y*screwSpacing,
            plateThickness-(screwLength+screwHeadThickness)
        ]) {
                cylinder(d=screwDiameter, h=screwLength);
                translate([0,0,screwLength - 0.1])
                    cylinder(
                        d=screwHeadDiameter,
                        h=screwHeadThickness + 0.2
                    );

                //translate([0,0,screwLength - 0.1])
                //    cylinder(
                //        d1=screwDiameter,
                //        d2=screwHeadDiameter,
                //        h=screwHeadThickness + 0.2
                //    );
            }
    }
}

module fanPlate() {
    wall = 1.5*plateWall;
    difference() {
        plateThickness = max(
            magnetThickness + magnetCover + plateWall,
            ( screwLength - plexiglass )/2
        );

        union() {
            difference() {
                hull() {
                    outsideCorner = 2*fanCornerDiameter;
                    linear_extrude(fanThickness + wall)
                        hull() for (x=[-0.5,0.5], y=[-0.5,0.5]) translate([
                            x*(fanWidth-outsideCorner+2*wall),
                            y*(fanWidth-outsideCorner+2*wall)
                        ]) circle(d=outsideCorner);

                    blankPlate(plateThickness);
                }
                blankPlate(plateThickness);
            }

            translate([0,0,plateThickness]) rotate([180])
                magnetPlate(plateThickness);
        }

        // Fan Hole
        translate([0,0,-0.1]) {
            linear_extrude(fanThickness+0.1)
                hull() for (x=[-0.5,0.5], y=[-0.5,0.5]) translate([
                    x*(fanWidth-fanCornerDiameter + 0.25),
                    y*(fanWidth-fanCornerDiameter + 0.25)
                ]) circle(d=fanCornerDiameter);

            cylinder(d=holeDiameter, h=fanThickness+plateWall+10);
        }

        // wire hole
        union() {
            // Remove the unused magnet
            translate([
                fanWidth + 2*wall,
                0,
                (fanThickness + plateWall + 10)/2 - 0.1
            ]) cube([
                fanWidth + 2*wall,
                fanWidth + 2*wall,
                fanThickness + plateWall + 10
            ], true);

            // Add a slot for the fan wire
            slot = [wall + 1,10,5];
            translate([
                holeDiameter/2 + wall/2,
                holeDiameter/2 - slot.y/2 - 10,
                slot.z/2 - 0.01])
                cube(slot, true);
        }

        // screw Holes
        for (x=[-0.5,0.5], y=[-0.5,0.5]) translate([
            x*screwSpacing,
            y*screwSpacing,
            plateThickness-(screwLength+screwHeadThickness) + fanThickness
        ]) {
                cylinder(d=screwDiameter, h=screwLength);
                translate([0,0,screwLength - 0.1])
                    cylinder(
                        d=screwHeadDiameter,
                        h=screwHeadThickness + 0.2
                    );

                //translate([0,0,screwLength - 0.1])
                //    cylinder(
                //        d1=screwDiameter,
                //        d2=screwHeadDiameter,
                //        h=screwHeadThickness + 0.2
                //    );
            }
    }
}

module fanSpacerOld(h=25.25) {
    points = [ for (x=[-0.5,0.5], y=[-0.5,0.5]) [ x*screwSpacing, y*screwSpacing ] ];

    difference() {
        hull() for (p=points) translate(p) cylinder(d=magnetDiameter+screwDiameter+2*plateWall, h=h);

	translate([0,0,-0.1]) {
		for (p=points) translate(p) cylinder(d=screwDiameter, h=h+0.2);
		cylinder(d=holeDiameter, h=h+0.2);
	}
    }
}

module fanSpacer(h=25.25) {
    d=magnetDiameter+screwDiameter+2*plateWall;
    offset = 5;
    points = [ for (x=[-0.5,0.5], y=[-0.5,0.5]) [ x*screwSpacing, y*screwSpacing ] ];

    difference() {
        union() {
            difference() {
                hull() {
                    for (p=points) translate(p) cylinder(d=d, h=h);
                    translate([0,offset,0]) blankPlate();
                }
                translate([0,offset,0]) blankPlate();
            }

            translate([0,offset,defaultPlateThickness]) rotate([180]) magnetPlate();
        }

        translate([holeDiameter/2+d-plateWall/2,0,h/2]) cube([h, holeDiameter + 2*plateWall, 2*h], true);

        translate([0,0,-0.1]) {
            for (p=points) translate(p) cylinder(d=screwDiameter, h=h+0.2);
            translate([0,0,0])
            for (p=points) translate(p) cylinder(d=screwHeadDiameter, h=h-defaultPlateThickness);
            hull() for (p=[
                [0,offset,0],
                [0,0,h+0.2],
            ]) translate(p) cylinder(d=holeDiameter, h=0.1);
        }
    }
}

module exhaustPlate() {
    outer = [ 90, 24 ];
    inner = [ 74, 48 ];

    wall=1.5;

    difference() {
        union() {
            rotate([180,0,0]) magnetPlate();

	    // outer pipe
	    difference() {
		cylinder(d=outer[0], h=outer[1]);
		translate([0,0,-0.1]) cylinder(d=outer[0]-2*wall, h=outer[1]+0.2);
	    }

	    // Inner pipe
	    union() {
                cylinder(d=inner[0], h=inner[1]-2*wall+0.1);
		translate([0,0,inner[1]-2*wall])
		    cylinder(d1=inner[0], d2=inner[0]-2*wall+0.4, h=2*wall);
	    }
        }
	translate([0,0,-inner[1]]) cylinder(d=inner[0]-2*wall, inner[1]*2+0.1);

	translate([0,0,-defaultPlateThickness-0.1])
	    cylinder(d1=holeDiameter, d2=inner[0]-2*wall, h=defaultPlateThickness);
    }
}

//magnetPlate();
//mainPlate();
//exhaustPlate();
intersection() {
fanPlate();
//fanSpacer();
//translate([0,0,25])cube([holeDiameter*2, holeDiameter*2, 7], true);
}

//magnetSample();
