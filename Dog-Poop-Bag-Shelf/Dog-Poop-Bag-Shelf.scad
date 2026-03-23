rollD  = 32;
shelfW = 90;
height = 57;

screwHead = 11;
screwD    =  5.5;

wall = 1.5;

width = wall + rollD + wall + shelfW + wall + rollD + wall;
depth = wall + rollD + wall;

$fa = $preview ? $fa : 1.0;
$fs = $preview ? $fs : 0.1;

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

difference() {
    linear_extrude(height + wall) hull() {
        for (x=[-0.5, 0.5], y=[-0.5,0.5]) let(
            d = y > 0 ? 2*wall : rollD,
            o = y > 0 ? 2*wall : 0,
        ) translate([ x * ( width - d ), y * (depth-d)+o, 0 ]) circle(d=d);
    }

    // Top Angle
    translate([0,depth/2,height+wall])
    rotate([20])
    translate([-width/2-0.1,-2*depth,0])
    cube([width+0.2, 2*depth, height]);

    // Bag holes
    for (x=[-0.5,0.5]) translate([x*(width-wall-rollD-wall),0,wall])
        cylinder(d=rollD, h=height+0.01);

    // Bag notch
    angleOffset=-17;
    for (x=[-0.5,0.5]) translate([x*(width-wall-rollD-wall),0,height+0.5])
    rotate([90,-90,0])
    linear_extrude(rollD) {
        top = rollD/8;
        topR = 4*top;
        bot = rollD/16;
        translate([-top+angleOffset,0]) difference() {
            translate([3*top,0]) square([6*top, topR + top + topR], true);
            for(y=[-1,1]) translate([0,y*(topR + top + topR)/2]) circle(topR);
        }
        hull() {
            translate([-top+bot/2+angleOffset,0]) square([bot, top], true);
            translate([-height+bot, 0]) circle(d=bot);
        }
    }

    // Shelf hole
    translate([0,0,height/2+wall])
        cube([shelfW, depth - 2*wall, height], true);

    // Shelf opening
    difference() {
        o = depth/3;
        h = height - o - angleOffset;
        d = rollD;
        w = shelfW-d;

        translate([0,-depth+2*wall,h/2+o])
            cube([shelfW, depth, h], true);

        for (x=[-0.5,0.5]) translate([
            x*(w+d),
            0,
            h-d/4+1.5*angleOffset + wall
        ]) {
            rotate([90])
                cylinder(d=d, h=2*depth);
            translate([0,-depth/2,-h/2])
                cube([d, 2*depth, h],true);
        }
    }

    // Screw holes
    // ACTUALLY MEASURE THESE!
    #for (x=[-0.5,0.5]) translate([
        x*(shelfW-2*screwHead),
        3*wall+depth/2,
        height + angleOffset/2
    ]) rotate([90]) linear_extrude(5*wall) {
        hull()
        for (y=[0,screwD+screwD]) translate([0,-y])
            circle(d=screwD+y/4);
        translate([0,-screwHead/2-screwD])
            circle(d=screwHead);
    }

}
