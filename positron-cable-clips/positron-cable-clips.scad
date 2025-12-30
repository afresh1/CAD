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

cableDiameter = 6.5;
wall = 1.5;

outerDiameter = cableDiameter + 2*wall;
length = 2.5*outerDiameter;

points = [
    [outerDiameter/2, outerDiameter+2*wall],
    [outerDiameter/2, length-outerDiameter/2],
];

cableHead = [16,9];
cableStrainDiameter = 11;
cableOffset = 15;
upperCable = 60;
standWidth = 5;

coverHinge       = [ 11, 25, 19.5 ];
hingeOffset      = 3.0;
hingeGap         = 0.5;
hingeDiameter    = 10;
hingeArmLength   = 50;
hingeArmMovement = 15;

$fa = $preview ? $fa : 1.0;
$fs = $preview ? $fs : 0.1;

module clip() { // make me
    translate([0,-wall,0])
    difference() {
        hull() for (x=points.x, y=points.y) translate([x,y,0])
            sphere(d=outerDiameter);

        for (x=points.x) translate([x,0,0])
            rotate([-90,0,0])
            cylinder(d=cableDiameter, h=length+0.2);

        translate([-2*wall, length-cableDiameter, -length*1/4])
            rotate([30.5,0,0])
            resize([2*outerDiameter, cableDiameter, length])
            cylinder(d=2*outerDiameter, h=length);


        for (i=[-0.5,0.5]) translate([
            (outerDiameter)/2,
            i*-(length+cableDiameter*3/6)+cableDiameter*1/3,
            0,
        ]) rotate([0,i*30,0])
            hull() for (y=[(cableDiameter-wall)/2, length-(cableDiameter-wall)/2])
                translate([0,y,(i-0.5)*outerDiameter])
                cylinder(d=cableDiameter, h=outerDiameter);

        for (i=[-0.5, 0.5]) translate([
            -outerDiameter/2,
            i*2*(length-wall),
            -outerDiameter/2
        ]) cube([2*outerDiameter+4*wall, length, outerDiameter]);
    }
}

module stand() { // make me
    linear_extrude(wall) difference() {
        union() {
            points = [
                [ 0, standWidth/2 ],
                [ 0, upperCable-standWidth/2 ],

                for (x=[-0.5, 0.5], y=[0,1])
                    [ x*(standWidth+length), upperCable + y*(outerDiameter+standWidth)],
            ];
            echo(points);

            for (l=[
                [points[0], points[1]],
                [points[2], points[3]],
                [points[3], points[5]],
                [points[5], points[4]],
                [points[2], points[4]],
            ])
            hull() for (p=l)
                    translate(p) circle(d=standWidth);

            translate([ 0, cableOffset])
                resize(cableHead + [cableOffset, cableOffset])
                    circle(d=cableHead.x*4*wall);

        }
        translate([0,cableOffset]) {
            square(cableHead, true);
            circle(d=cableStrainDiameter);
        }
    }
}

module hingePin(gap = 0) {
    h = coverHinge.z; //gap + coverHinge.z  + gap;
    d = gap + hingeDiameter + gap;

    //translate([0,0,-gap])
    difference() {
        cylinder(d=d, h=h);

        translate([0,0,h/2]) rotate_extrude()
            translate([d*0.55, 0]) resize([d*2/3, h/2]) circle(d=h/2);
    }
}

module coverHinge() {
    hingePosition = [-hingeOffset, coverHinge.y - hingeDiameter/2, 0];

    rotate([0,180,0])
        translate([-152, -136,-19.5])
        import("Toolboard_Cover - 1x - Accent - V1.0.stl");

    difference() {
        hull() {
            translate([0,-0.5,coverHinge.z/2])
                cube([coverHinge.x, 0, coverHinge.z], true);

                linear_extrude(coverHinge.z)
                    polygon([
                        [-coverHinge.x/2-0.5, -0.5],
                        [ coverHinge.x/2-0.5,  0],
                        [ coverHinge.x/2+0.5, -8.5],
                    ]);

            translate(hingePosition)
                cylinder(d=hingeDiameter, h=coverHinge.z);
        }

        translate(hingePosition)
            difference() {
                translate([0,0,coverHinge.z*1/4]) union() {
                    cylinder(d=hingeDiameter, h=coverHinge.z/2);

                    rotate(68) translate([0,0, coverHinge.z/4 ])
                        cube([hingeDiameter + 10*hingeGap, coverHinge.y, coverHinge.z/2], true);
                }
                hingePin();
            }
    }
}

module arm() {
    bottomThickness = ( coverHinge.z - outerDiameter )/2;

    difference() {
        hull() {
            translate([0,0,bottomThickness])
                cylinder(d=hingeDiameter, h=coverHinge.z - bottomThickness);

            *translate([0,coverHinge.y,2*wall])
                cylinder(d=hingeDiameter, h=coverHinge.z/2);

            translate([
                0,
                hingeArmLength + hingeArmMovement - outerDiameter/2,
                bottomThickness + wall
            ]) cylinder(
                d1=outerDiameter,
                d2=2*outerDiameter,
                h=coverHinge.z - bottomThickness - wall
            );

        }

        // front top angle
        *translate([
            -outerDiameter,
            hingeArmLength/2,
            coverHinge.z,
        ]) rotate([-8,0,0]) cube([
            2*outerDiameter, hingeArmLength, outerDiameter
        ]);

        // rear top angle
        *translate([
            -outerDiameter,
            hingeDiameter/2 - hingeGap/2,
            coverHinge.z * 3/4 + hingeGap
        ]) rotate([21,0,0]) cube([
            2*outerDiameter, hingeArmLength/2, outerDiameter
        ]);

        // Clip Shelf
        translate([
            0,
            hingeArmLength + hingeArmMovement-outerDiameter/2,
            coverHinge.z
        ]) rotate([90,0,90]) {
            p = [ [outerDiameter,0], [0,outerDiameter] ];
            translate([0,0,-outerDiameter])
                cylinder(d=2*outerDiameter, h=2*outerDiameter);
            for (i=[0,1]) rotate((i-0.5)*30) translate(p[i]) cube(2*outerDiameter, true);
        }

        // Cable races
        for (i=[-1,1]) translate([
            0,
            hingeArmLength + hingeArmMovement + length,
            coverHinge.z/2 + cableDiameter/2
        ]) rotate([i*10, -90, 90]) {
                h=2*(hingeArmLength + hingeArmMovement);
                cylinder(d=outerDiameter, h=h);
                for (s=[
                    [2*outerDiameter,  outerDiameter,h],
                    [  outerDiameter,2*outerDiameter,h],
                ]) translate([outerDiameter/2,i*-outerDiameter/2,h/2])
                    cube(s, true);
            }

        // knob when folded
        knobDiameter  = 25;
        knobInnerDiameter = 15;
        knobThickness = 10;
        translate([
            -knobDiameter/2 ,//- wall,
            knobDiameter/2 + hingeDiameter/2 - hingeOffset/2 - wall,
            -0.01
        ]) translate([0,0,bottomThickness])
            cylinder(d=knobDiameter, h=coverHinge.z);

        headThickness = (coverHinge.z + hingeGap)/4;

        // angle cuts to allow opening further
        rotate(-68)
        for (i=[0,1]) translate([0,0,
            i*(coverHinge.z - headThickness) + headThickness/2
        ]) cube([
            hingeDiameter + 5*hingeGap,
            2*coverHinge.y,
            headThickness+0.1
        ], true);

        hingePin(hingeGap);
    }
}

module hingedArm() { // make me
    coverHinge();
    translate([-hingeOffset, coverHinge.y - hingeDiameter/2,0])
        rotate(-90)
        //rotate(-130)
        //rotate(30)
        arm();
}

module railGuide() { // make me
    bearingD = 17;
    bearingH =  6;
    railSize = [27, 9, 10];
    railGrooveD    = 1;
    railGrooveDown = 1;
    railOffsetFromBearing = 5;

    rail = railSize + [ 0, 0.25, -bearingH/2 ];

    nutSize = 5;
    nutD = 1.1*2*( nutSize / sqrt(3) );

    bigScrewD = 6.5;
    bigScrewOffsetFromBearing = 2;

    guideZOffset = 2.5;
    guideH   = bearingH + rail.z + guideZOffset;
    guideD1  = rail.y   + 1;
    guideD2a = bearingD * 2 + 4;
    guideD2b = 2*12; // measured, but don't want configurable

    bearingHole = bearingD + 1;

    module cutout() {
        translate([
            -rail.x/2 + bearingHole/2 - railOffsetFromBearing,
            0,
            rail.z/2
        ]) difference() {
            cube(rail, true);
            translate([-rail.x/2-1,0, rail.z/2-railGrooveDown-railGrooveD/2 ])
                rotate([0,90,0]) linear_extrude(rail.x+2)
                for (p=[-0.5,0.5]) translate([0,p*(rail.y+0.5)])
                    circle(d=railGrooveD);
        }

        // bearing
        translate([0,0,-bearingH]) {
            h = bearingH * 1.1; // clearance
            cylinder(d=bearingHole, h=h);
            translate([-bearingHole,0,h/2])
                cube([2*bearingHole,bearingHole,h], true);
        }

        // nut
        cylinder(d=nutD, h=2*rail.z, $fn=6);

        // cutout for the "big screw" when closed up
        translate([bearingD/2+bigScrewD/2+bigScrewOffsetFromBearing,0,-bearingH])
            linear_extrude(20) {
                circle(d=bigScrewD);
                translate([bigScrewD/2,0]) square(bigScrewD, true);
            }

        // extra cut off of point where bearing goes into rail
        translate([-bearingD+bearingH/2, bearingHole/2, -(0.9*bearingH)/2])
            cube([bearingHole, bearingHole, 1.1*bearingH], true);
    }

    difference() {
        translate([0,0,-bearingH+0.1]) hull() {
            dL = guideD2a;
            dR = guideD2b;

            translate([0,0,guideH - bearingH/4])
                rotate_extrude()
                translate([guideD1/2,0])
                    circle(d=bearingH/2);

            difference() {
                rotate_extrude()
                    translate([bearingD,0])
                    circle(d=bearingH);
                translate([0,dL,0.5])   cube([2*dL,2*dL,bearingD+1], true);
                translate([0,0,-dL]) cube(2*dL, true);
            }

            difference() {
                resize([dL,dR,bearingH])
                rotate_extrude()
                    translate([bearingD,0])
                    circle(d=bearingH);
                translate([0,-dL,0.5])   cube([2*dL,2*dL,bearingD+1], true);
                translate([0,0,-dL]) cube(2*dL, true);
            }
        }

        cutout();

        translate([bearingD/2,guideD2a,-bearingH]) {
            h=bearingH;
            w=2*guideD2a;

            rotate([90]) cylinder(d=h, h=w);
            translate([w/2,-w/2,0]) cube([w,w,h], true);
        }

        *translate([0,0,-45/2 - 2]) rotate([12]) cube(45, true);
    }
}

for (y=[0, 20, 40]) translate([0,y+10,0])
   rotate([90]) clip();

translate([32, 10, coverHinge.z]) rotate([0,180,-90]) hingedArm();

translate([72,15,9.5]) rotate([180]) railGuide();

/*
!union() {
    translate([-hingeDiameter/2,0,0]) difference() {
        cube([hingeDiameter, coverHinge.y, coverHinge.z]);
        translate([-0.1,0,coverHinge.z/4-0.1])
            cube([hingeDiameter+0.2, hingeDiameter/2+0.1, coverHinge.z/2+0.2]);
    }
    hingePin();
    color("red", 0.3)
    difference() {
        union() {
            translate([-hingeDiameter/2,-coverHinge.y,0]) difference() {
                cube([hingeDiameter, coverHinge.y, coverHinge.z]);
            for (i=[0,1])
                translate([
                    -0.1,
                    coverHinge.y-hingeDiameter/2-0.1,
                    i*(coverHinge.z*3/4)-0.2])
                    cube([hingeDiameter+0.2, hingeDiameter/2+0.1, coverHinge.z/4+0.4]);
            }
            cylinder(d=hingeDiameter, h=coverHinge.z);
        }
        hingePin(hingeGap);
    }
}
*/
