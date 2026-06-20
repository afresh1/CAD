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

plate = [ 200, 94, 2.3];
cornerR = 3.5;

pinD = 5.5;
pinH = 8.0;

pinPoints = let(
    pinO = 9, // pin offset
    y0   =           pinO,
    y1   = plate.y - pinO,
) [
    [pinO,   y1], [(plate.x+pinO)/2, y1], [plate.x-pinO,   y1],
    [pinO*2, y0], [(plate.x-pinO)/2, y0], [plate.x-pinO*2, y0],
];

$fa = $preview ? $fa : 1.0;
$fs = $preview ? $fs : 0.1;

hull()
for (x=[cornerR, plate.x-cornerR], y=[cornerR,plate.y-cornerR])
    translate([x,y,0]) {
        cylinder(r1=cornerR/2, r2=cornerR, h=plate.z/2);
        translate([0,0,plate.z/2-0.01])
            cylinder(r=cornerR, h=plate.z/2+0.01);
    }

for (p=pinPoints) translate(p) {
    bevel = pinD / 4;
    cylinder(d=pinD, h=pinH + plate.z - bevel+0.01);
    translate([0,0,pinH+plate.z-bevel])
        cylinder(d1=pinD, d2=pinD - 2*bevel, h=bevel);
}
