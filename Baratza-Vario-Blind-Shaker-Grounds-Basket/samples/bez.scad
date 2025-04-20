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
top    = [ 124, 49 ];
bot    = [ 117, 40 ];

curveOffset = 14.5; //11.41;
curveThickness = 3.5;

topOffset = [ -abs(top.x-bot.x)/2, -abs(top.y-bot.y)/2, height ];

$fa = $preview ? $fa : 1.0;
$fs = $preview ? $fs : 0.1;

include <../BOSL2/std.scad>
include <../BOSL2/beziers.scad>
inc = 0.02;

/*
module side_flat_orig() {
    translate([-4.46062322256616 + 1, 119])
    mirror([0,1])
	polygon([
		[4.46062322256616,118.804884114356],
		each bezier_points([
			[4.46062322256616, 118.804884114356],
			[1.31976161594852, 79.2032560762375],
			[-0.562406775581189, 39.6016280381187],
			[0, 0],
		], [0:inc:1]),
		[4.94955664731521,0.116005133343881],
		each bezier_points([
			[4.94955664731521, 0.116005133343881],
			[14.7343264649841, 42.6006856178472],
			[17.5276977439522, 81.4376804479911],
			[17.8779421728, 119],
		], [0:inc:1]),
	]);
}
*/

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

/*
module top_flat_orig() {
    translate([0,-15.8,0])
	polygon([
		[0.342431838007341,64.3205646056688],
		[0,20.3566104502742],
		[3.47975205215706,20.3566104502742],
		[3.47975205215706,15.9150774584343],
		each bezier_points([
			[3.47975205215706, 15.9150774584343],
			[31.2068708671846, 3.82444288026955],
			[47.3917228577166, 1.34087089351659],
			[62.2036943352323, 0],
		], [0:inc:1]),
		each bezier_points([
			[62.2036943352323, 0],
			[83.8702367658721, 0.964529252321586],
			[101.753541496147, 8.61824022529946],
			[120.380033896823, 15.8055952109078],
		], [0:inc:1]),
		[120.341985513389,20.3713510940167],
		[123.619520681784,20.2860235861008],
		[124,65.5662077115773],
		each bezier_points([
			[124, 65.5662077115773],
			[82.7093139743896, 85.1366071181726],
			[41.4852318133362, 86.0889186394121],
			[0.342431838007341, 64.3205646056688],
		], [0:inc:1]),
	]);
}
*/

module top_flat(
    size        = top,
    rear_off    = [ curveThickness, -topOffset.y],
    front_curve = [ 41,   70],
    rear_curve  = [ -16 + 9.5, -16 + 3.5, -16],
    bevel       = 0.5,
    indent      = 0
) {
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

		each bezier_points([
            size,
            [ size.x - front_curve.x, front_curve.y ],
            front_curve,
            [ 0, size.y],
		], [0:inc:1]),

        [ 0, rear_off.y ],
	]);

}

module top() {
    translate([0,0,0.01]) linear_extrude(0.01)
        top_flat();
}

/*
module bottom_flat_orig() {
	polygon([
		[0,39.9390820648952],
		[0,14.641904906996],
		[3.30274329055209,14.5695803600887],
		[4.14217094829836,0],
		each bezier_points([
			[4.14217094829836, 0],
			[39.389748769686, -7.41535282147214],
			[75.4144423774692, -8.39175680257456],
			[112.569775115628, 0],
		], [0:inc:1]),
		[113.480034948851,14.6662854809432],
		[117,14.6662854809432],
		[117,39.5964826150023],
		each bezier_points([
			[117, 39.5964826150023],
			[75.9726390533204, 64.4518831338473],
			[37.2125276792013, 61.6385712484263],
			[0, 39.9390820648952],
		], [0:inc:1]),
	]);
}
*/

module bottom_flat(
    size        = bot,
    rear_off    = [ curveThickness, curveOffset],
    front_curve = [ 40, 63],
    rear_curve  = [ 40, -8],
    bevel       = 0.5,
    indent      = 0
) {
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
    difference() {
        translate([0, -bot.y + curveOffset, 0 ])
            cube([bot.x, bot.y, indent]);

        translate([0,0,indent - 0.01]) minkowski() {
            linear_extrude(0.01) difference() {
                bottom_flat(indent=indent);
                translate([0,curveOffset]) square(top);
            }
            sphere(indent);
        }
    }
}

module grounds_bin() {
    difference() {
        hull() {
            color("blue") translate(topOffset) top();
            color("lightblue") bottom();
        }

        color("green") bottom_cutouts();
        color("red")   side_cutouts();
        bottom_rounding();

    }
}

grounds_bin();
