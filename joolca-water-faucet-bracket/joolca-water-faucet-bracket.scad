/* Joolca Water Faucet Bracket for Enameled Metal Jug
 ****************************************************
 *
 * This bracket is here to let us more reliably attach the Joolca
 * spray handle to the side of the water jug.
 *
 */

/*
 * Copyright (c) 2026 Andrew Hewus Fresh <andrew@afresh1.com>
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

waterJugD = 305;
// waterJugWall = 1.1;

handleInside    = [ 82.4, 40.0, 31.4 ];
handleWidth     = 4.7;
handleWall      = 5.5;

handleTiltAngle   = 18;
handleExpandAngle = 13;
handleCornerD     = 30;

handle = [ 90.5, 46, 31.4 ];

function chordHeight(c, d) = let(
    radians  =   2 * asin(c/d),
    distance = d/2 * cos(radians/2),
    height   = d/2 - distance
) height;

// no idea why the /2
handleOffset = chordHeight(handle.x, waterJugD) / 2;

//magnetClip = [ 32.5, 6, 99 ] + [ 0.5, 0, 0 ];
//magnetClipD = magnetClip.x * 1.75;
//magnetClipPosition = [-magnetClip.x/2,0,handle.z + handleWall];

sprayHandleD    = 40;
sprayHandleH    = 75;
sprayHandleWall = 2;

$fa = $preview ? $fa : 2.5;
$fs = $preview ? $fs : 0.5;

module jugBody() {
    translate([0,0,-handle.z*10])
        cylinder(d=waterJugD, h=handle.z*12 );
}

module handleProfile() {
    d = handleWall;
    hull() for (z=[d/2,handle.z-d/2]) translate([0,z]) circle(d=d);
}

module handleSection(l, o=0) {
    rotate([90])
    translate([0,0,-l])
    linear_extrude(l+o) handleProfile();
}

module handleCurve() {
    rotate(handleExpandAngle)
    translate([-handleCornerD/2,0,0])
    rotate_extrude(90 - handleExpandAngle)
        translate([handleCornerD/2,0])
        handleProfile();
}

module jugHandle() {
    rotate([handleTiltAngle]) {
        translate([0,-handleOffset,0]) {
            handleYoffset = handle.y;
            handleXoffset = handleYoffset * sin(handleExpandAngle)/sin(90);

            curveL = 10.9; // I bet there is a way to calculate this, but . . .

            handleSide   = handleYoffset - curveL;
            curveYoffset = handleSide * sin(90 - handleExpandAngle)/sin(90);
            curveXoffset = handleSide * sin(     handleExpandAngle)/sin(90);


            translate([handle.x,0,0])
                rotate(handleExpandAngle) handleSection(handleSide, 10);

            translate([
                handle.x - curveXoffset,
                curveYoffset,
                0
            ]) handleCurve();

            // No idea why the front needs adjustments
            translate([
                handleXoffset + 12,
                handleYoffset - 0.15,
                0
            ]) rotate(-90) handleSection(handle.x - handleYoffset/2 - 2*curveL);

            translate([ curveXoffset, curveYoffset, 0 ])
                mirror([1,0,0]) handleCurve();

            rotate(-handleExpandAngle) handleSection(handleSide, 10);
        }

        //%
        //rotate([-handleTiltAngle])
        //rotate(180)
        //translate([-handleInside.x/2,0,0])
        //translate([-36,61,32.5])
        //rotate([90,0,33.5])
        //import("red-water-jug.stl");
    }
}

module jug() {
    jugBody();
    translate([0,waterJugD/2-8.5,0]) jugHandle();
}

//module magnetClip(h=false) {
//    x = magnetClip.x;
//    y = h ? h : magnetClip.y;
//    z = magnetClip.z;
//
//    rotate([-90]) hull() linear_extrude(2*y)
//        for (p= [[0,x/2], [0,z-x/2]]) translate(p) circle(d=x);
//
//    translate([0,  magnetClipD/2 + y, -1.5*magnetClip.z])
//        cylinder(d=magnetClipD, h=2*z);
//
//}

module bracket() {
    module positionSprayHandle() {
            translate([
                0,
                sprayHandleD/2,
               -sprayHandleH/2 + 2*handleWall
            ]) translate([0,-waterJugD,0]) rotate(-11)
                translate([0,waterJugD+handleWall,0])
                    children();
    }

    handleXoffset = handle.y * sin(handleExpandAngle)/sin(90);

    points = [
        [              handleWall,          handleWall,          handleWall ],
        [              handleWall,          handleWall, handle.z-handleWall ],
        [handleXoffset+handleWall, handle.y           ,          handleWall ],
        [handleXoffset+handleWall, handle.y           , handle.z-handleWall ],
        [     handle.x-handleWall,          handleWall,          handleWall - sprayHandleH/4 ],
        [     handle.x-handleWall,          handleWall, handle.z-handleWall ],
        [     handle.x-handleWall, handle.y-handleWall,          handleWall ],
        [     handle.x-handleWall, handle.y-handleWall, handle.z-handleWall ],
    ];

    difference() {
        union() {
            rotate([handleTiltAngle])
            translate([-handle.x/2,-2*handleWall,handleWall/2]) hull()
                for (p = points) translate(p) sphere(2*handleWall);

            positionSprayHandle()
                translate([-sprayHandleWall, -sprayHandleWall, 0])
                cylinder(d=sprayHandleD + 4*sprayHandleWall + handleWall, h=sprayHandleH);
        }

        positionSprayHandle() difference() {
            h = sprayHandleH + 0.2;
            union() {
                translate([sprayHandleWall,sprayHandleWall,-0.1])
                    cylinder(d=sprayHandleD, h=h);

                translate([0,0,-0.1])
                    cube([sprayHandleD, sprayHandleD, h]);
            }

            for (a=[0,90]) rotate(a) translate([sprayHandleD/2+handleWall/2,0,0])
                cylinder(r=sprayHandleWall, h=h);

        }

        translate([-handle.x/2,-handleWall,0]) {
            jugHandle();

            intersection() {
                difference() {
                    hull() jugHandle();
                           jugHandle();
                }

                rotate([handleTiltAngle]) translate(handle/2)
                    cube(handle + [0, 1, -handleWall], true);

            }

            intersection() {
                hull() jugHandle();

                rotate([handleTiltAngle]) translate([ 0, 0, handle.z/2 + handleWall/2 ])
                resize([ handle.x + 2*handleWall, 2*handle.z, handle.z + handleWall ])
                    rotate([0,90,0]) cylinder(d=handle.z, h=handle.x);
            }
        }

        translate([0,-waterJugD/2,0]) jugBody();
    }
}

module jugHandleOutside() {
    difference() {
        translate([0,15,20]) cube([100, 50, 50], true);
        translate([0,-waterJugD/2,0]) jugBody();

        translate([-handleInside.x/2-handleWall/2,0,0])
            hull() jugHandle();

        translate([0,25,-17]) rotate([handleTiltAngle])
            cube([100, 60, 50], true);
    }
}

module jugHandleInside() {
    difference() {
        translate([-handleInside.x/2-handleWall/2,0,0])
            hull() jugHandle();

        translate([0,-waterJugD/2,0]) jugBody();

        scale(1.01)
        translate([-handleInside.x/2-handleWall/2,0,0])
            jugHandle();

        translate([0,5,2*handle.z - 4]) rotate([handleTiltAngle])
            cube([100, 60, 50], true);
    }
}

//translate([0, 20, 30])
//jugHandleOutside();
//jugHandleInside();

//jugHandle();
bracket();

//%translate(magnetClipPosition) magnetClip();

//color("blue", 0.5)
//jug();

*
%
rotate(180)
translate([0,handleOffset,0])
translate([-36,61,32.5])
rotate([90,0,33.5])
import("red-water-jug.stl");
