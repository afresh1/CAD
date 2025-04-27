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

$fa = $preview ? $fa : 5.0;
$fs = $preview ? $fs : 0.5;

module clip() { // make me
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


for (y=[0, 20, 40]) translate([42,y,outerDiameter/2])
    rotate(90) clip();

stand();
