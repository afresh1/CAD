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
holeDiameter=[36,40];

height = 75;
cornerCurve = 15;

basePlateHeight = 20;
basePlateThickness = 15;
basePlateWall   = 4.5;

totalWidth = holeDiameter[1]+cornerCurve;

$fa = $preview ? $fa : 2.0;
$fs = $preview ? $fs : 0.2;

difference() {
    union() {
	hull() {
	    for ( x=[-0.5,0.5],y=[-0.5,0.5], z=[0,1] )
	        translate([x*holeDiameter[1],y*holeDiameter[1],z*(height-cornerCurve/2)])
	        if (z) sphere(d=cornerCurve);
	        else cylinder(d=cornerCurve, h=1);

	    translate([0,-cornerCurve/2,(basePlateHeight+basePlateThickness)/2]) cube([
	        totalWidth,
	        totalWidth-cornerCurve,
	        basePlateHeight + basePlateThickness
	    ], true);
	}
        translate([0,-totalWidth/2-basePlateWall,basePlateHeight/2]) {
            cube([ totalWidth, 4*basePlateWall, basePlateHeight ], true);

            translate([0,-basePlateWall,basePlateWall/2])
            cube([ totalWidth, 2*basePlateWall, basePlateHeight + basePlateWall], true);
        }
    }
    translate([0,0,-0.1]) cylinder(d1=holeDiameter[0], d2=holeDiameter[1], h=height+0.2);

    for (r=[0,90]) rotate([90,0,r]) translate([0,0,-totalWidth])
        cylinder(d=holeDiameter[0], h=2*totalWidth);
}

