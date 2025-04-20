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

height = 118.5;
top    = [ 124, 48.5 ];
bot    = [ 117, 40 ];

curveOffset = 14.5; //11.41;
curveThickness = 3.5;

topOffset = [ -abs(top.x-bot.x)/2, -abs(top.y-bot.y)/2, height ];

$fa = $preview ? $fa : 1.0;
$fs = $preview ? $fs : 0.1;

include <../BOSL2/std.scad>
include <../BOSL2/beziers.scad>
inc = 0.02;

module side_flat(
    h = height,
    t = topOffset.y,
    b = curveOffset,
) {
	polygon([
		each bezier_points([
            [ t, h ],
            [ t, h * 1/2 ],
            [ t, h * 1/2 ],
            [ 0, 0 ],
		], [0:inc:1]),

		each bezier_points([
            [ b, 0 ],
            [ b,   h * 1/3 ],
            [ b+t, h * 2/3 ],
            [ 0, h ],
		], [0:inc:1]),
	]);
}

module side_cutouts(w=curveThickness) {
		a = height;
		b = w;
		side_h = sqrt( a^2 + b^2 - 2*a*b*cos(90) );

		function angle(c) = acos( ( c^2 + b^2 - a^2 ) / (2 * c * b) );

		//echo(a, b, c, angle);

		module left_cutout() {
				translate([0,0,-0.1])
				rotate([angle(side_h)-90,0,90])
				union() {
						translate([curveOffset,-w,0])
						rotate_extrude(angle=2)
								translate([-curveOffset,0,0])
								side_flat(h=side_h);


						rotate([90,0,0]) {
								linear_extrude(w) side_flat(h=side_h);

								// just a fudge to make sure it all goes away
								translate([-curveOffset, -w/2, 0])
										cube([curveOffset, a + w, w + 0.5]);
						}
				}
		}

		module right_cutout() {
				mirror([1,0]) left_cutout();
		}

		left_cutout();
		translate([bot.x,0,0]) right_cutout();
}

module top_flat(
    size        = top,
    rear_off    = [ curveThickness, -topOffset.y],
    front_curve = [ 41,   70],
    rear_curve  = [ -16 + 9.5, -16 + 3.5, -16],
    bevel       = 0.5,
    indent      = 0
) {
    	intersection() {
	polygon([
        rear_off,

		each bezier_points([
			[         rear_off.x,                 0  ],
			[         size.x/2 * 1/3,  rear_curve.x ],
			[         size.x/2 * 1/2,  rear_curve.y ],
			[         size.x/2,        rear_curve.z ],
		], [0:inc:1]),

		each bezier_points([
			[size.x - size.x/2,        rear_curve.z ],
			[size.x - size.x/2 * 1/2,  rear_curve.y ],
			[size.x - size.x/2 * 1/3,  rear_curve.x ],
			[size.x - rear_off.x,                 0 ],
		], [0:inc:1]),

		[ size.x - rear_off.x, rear_off.y ],
		[ size.x,              rear_off.y ],

		[ size.x - bevel, rear_off.y ],

		each bezier_points([
            size,
            [ size.x - front_curve.x, front_curve.y ],
            front_curve,
            [ 0, size.y],
		], [0:inc:1]),

        [ bevel, rear_off.y ],
	]);

	r=2*bevel;
	hull() {
	    for(p=[
	        [       r,       r],
	        [size.x-r,       r],
	        [size.x-r,size.y-r],
	        [       r,size.y-r],
	    ]) translate(p) circle(r=r);

	    translate([size.x/2 - size.y/2,-size.x*1/3]) square([size.y,size.x]);
	}
    }
}

module top() {
    translate(topOffset + [0,0,0.01]) linear_extrude(0.01)
        top_flat();
}

module bottom_flat(
    size        = bot,
    rear_off    = [ curveThickness, curveOffset],
    front_curve = [ 40, 63],
    rear_curve  = [ 40, -8],
    bevel       = 0.5,
    indent      = 0
) {
	intersection() {
	polygon([
        [ rear_off.x + indent, rear_off.y ],

		each bezier_points([
			[          rear_off.x + indent + bevel,                indent ],
            [          rear_off.x + rear_curve.x,   rear_curve.y + indent ],
            [ size.x - rear_off.x - rear_curve.x,   rear_curve.y + indent ],
            [ size.x - rear_off.x - indent - bevel,                indent ],
		], [0:inc:1]),

		[ size.x - rear_off.x - indent, rear_off.y ],
		[ size.x,                       rear_off.y ],

		each bezier_points([
            size,
            [ size.x - front_curve.x, front_curve.y ],
            front_curve,
            [ 0, size.y],
		], [0:inc:1]),

        [ 0, rear_off.y],
	]);

	r=2*bevel;
	hull() {
	    for(p=[
	        [       r,       r],
	        [size.x-r,       r],
	        [size.x-r,size.y-r],
	        [       r,size.y-r],
	    ]) translate(p) circle(r=r);

	    translate([size.x/2 - size.y/2,-size.x*1/3]) square([size.y,size.x]);
	}
    }
}

module bottom_cutouts() {
	size = [ [ 23.75, 21.5, 30 ], [ 42, 38, 6.5 ] ];
	corner = 5.5;
	rotation = 5.5;
	spacing  = 28.5 + 0.5;

	module left() {
		hull() {
			translate([
				 corner/2 + (size.x[0]-size.x[1])/2,
				-corner/2 + size.y[0]
			]) circle(d=corner);

			translate([
				-corner/2 + size.x[1] + (size.x[0]-size.x[1])/2,
				-corner/2 + size.y[1]
			]) circle(d=corner);

			rotate(rotation) square([size.x[0],0.01]);
		}
		rotate(rotation) hull() {
			square([size.x[0],0.01]);

			translate([
				-(size.x[2]-size.x[0])/2,
				-size.y[2]
			]) square([size.x[2],0.01]);
		}
	}

	module right() { mirror([1,0]) left(); }

	// Not sure why I need the + 0.01, something rotation related I assume
	translate([bot.x/2 + 0.01, 0, -0.01]) linear_extrude(1.75 + 0.01) {
		translate([ spacing/2, 0])  left();
		translate([-spacing/2, 0]) right();
	}
}

module bottom() {
    linear_extrude(0.01) bottom_flat();
}

module bottom_rounding(indent=2) {
//    difference() {
//        translate([0, -bot.y + curveOffset, 0 ])
//            cube([bot.x, bot.y, indent]);

	translate([0,0,indent])
        minkowski() {
	    linear_extrude(0.01)
            offset(delta = -indent)
	    intersection() {
                bottom_flat();
                translate([bot.x/2,bot.y*1/3])
		    square(bot - [ curveOffset/2, 0], true);
            }
         sphere(indent);
        }
//    }
}

module grounds_bin() {
    difference() {
        hull() {
            color("blue") top();

	    color("lightblue")
	    intersection() {
	    	hull() {
		    top();
		    bottom();
	        }
		union() {
		    bottom_rounding();
		    translate([0,curveOffset,0]) cube([bot.x, 2*bot.y, 2]);
		}
	    }
        }

        color("green") bottom_cutouts();
        color("red")   side_cutouts();

	// Notch for the detent
	color("orange")
        translate([bot.x/2,2,-1.75]) sphere(d=5);

        // Notch for adjustment cover
        translate([bot.x/2,0,height]) cube([15, top.y, 10], true);
    }
}


module blind_shaker(
    d1 = 74,
    d2 = 69,
    h1 = 30.5,
    h2 = 39.5
) {
    cylinder(d=d1, h=h1 + 0.01);

    translate([0,0,h1])
        cylinder(d1=d1, d2=d2, h=h2);
}

module blind_shaker_cutout(
    d1 = 74,
    d2 = 69,
    h1 = 30.5,
    h2 = 39.5
) {
    hull() {
        blind_shaker(d1=d1,d2=d2,h1=h1,h2=h2);

	t=80;
	b=100;
	translate([0,d1,0]) rotate([90,0])
	linear_extrude(d1) polygon([
	    [  d1/2, 0 ],
	    [  b/2, h1/2],
	    [  t/2, 2*(h1+h2) ],
	    [ -t/2, 2*(h1+h2) ],
	    [ -b/2, h1/2],
	    [ -d1/2, 0 ],
	]);
    }
}


intersection() {
    grounds_bin();

    // angle off the back
    rotate([7.7,0,0]) translate([topOffset.x,-top.y/2,-height])
	    cube([top.x,top.x,2*height]);

    difference() {
        union() {
            hull() {
                side_cutouts();
		translate([0,-top.y,0]) cube([top.x, top.y, height]);
            }
	    hull() {
                top();
		cube([bot.x,1,1]);
	    }
            translate([topOffset.x,-top.y/2,0]) cube([top.x,2*top.y,40]);
        }

        translate([bot.x/2, bot.y/2 + 10, 30])
            rotate([7.7,0,0]) blind_shaker_cutout();
    }
}

%translate([bot.x/2, bot.y/2 + 10, 30])
    rotate([7.7,0,0]) blind_shaker();
