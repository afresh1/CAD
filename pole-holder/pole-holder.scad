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

poleD = 25.5;

block = [ 38, 65, 65 ];

wall = 10;

outside = [
    wall + block.x + wall,
    wall + block.y + wall,
           block.z,
];

$fa = $preview ? $fa : 1.0;
$fs = $preview ? $fs : 0.1;

difference() {
    hull() {
        translate([-outside.x/2, outside.y - poleD - wall - 2*wall, 0])
            cube([ outside.x, 2*wall, outside.z ]);

        cylinder(d=wall + poleD + wall, h = outside.z);
    }

    for (p=[0, 1])
        translate([
            -outside.x/2 - 0.1,
            outside.y - poleD - wall/2,
            -2*wall + p*(4*wall + outside.z)
        ]) rotate([(p-0.5)*10, 0, 0]) translate([0,-outside.y,-p*2*wall])
            cube([outside.x + 0.2, outside.y, 2*wall]);

    translate([outside.x/2,poleD/2-wall/2,0]) rotate([0,-90])
        linear_extrude(outside.x) polygon([
            [0, 0.75],
            [0,-0.75],
            [outside.z-2*wall,0],
        ]);

    cylinder(d=poleD, h=2540);

    for (
        x=[ poleD/2 + wall/2, -(poleD/2 + wall/2) ],
        z=[ 1.5*wall, outside.z - 1.5*wall]
    ) translate([x,outside.y,z]) rotate([90]) {
            in  = 5.5;
            out = 9;
            l   = 5;
            cylinder(d=in, h=outside.y);
            translate([0,0,outside.y])
                cylinder(d1=in, d2=out, h=l);
            translate([0,0,outside.y + l])
                cylinder(d=out, h=outside.y);
        }

}
