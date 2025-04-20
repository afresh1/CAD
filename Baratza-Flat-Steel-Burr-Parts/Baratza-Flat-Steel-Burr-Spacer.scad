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

outer = 49.5;
inner = 31.0;

thickness=1.5;

screw = 5;
screwCount = 3;

$fa = $preview ? $fa : 1.00;
$fs = $preview ? $fs : 0.10;

//minkowski() {
difference() {
    edge=0; //thickness * 2/3;

    cylinder(d1=outer, d2=outer - 2*thickness, h=thickness);

    translate([0,0,-0.01]) linear_extrude(thickness - edge + 0.02) {
    //difference() {
        //circle(d=outer - edge);
        circle(d=inner + edge);

        for(i=[0:screwCount - 1]) let(
            r=outer/2 - screw/2,
            theta=i/screwCount*360,
            x=r*sin(theta),
            y=r*cos(theta)
        ) translate([x,y]) circle(d=screw + edge);
    }

    //sphere(d=edge);
}
