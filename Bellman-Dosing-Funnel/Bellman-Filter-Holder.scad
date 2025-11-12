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

baseD = 72;
baseH =  2;

pinD  = 12;
pinH  = 50;

$fa = $preview ? $fa : 5.0;
$fs = $preview ? $fs : 0.5;

translate([0,0, pinH + baseH - (pinD*7/8)/2]) sphere(d=pinD * 7/8, $fn=6);

hull() {
    translate([0,0,pinH - pinD/8]) sphere(d=pinD/3);
    linear_extrude(pinH/3 + baseH) circle(d=pinD);
}

linear_extrude(baseH) {
    difference() {
        circle(d=baseD);
        translate([-baseD/2,-baseD/2])
        for (xx=[0:floor(baseD/(pinD/2)) + 1], yy=[0:baseD/(pinD/2) + 1]) let(
            x = pinD/2 *   xx,
            y = (pinD/2+0.5) * ( xx % 2 == 0 ? yy + 0.5 : yy )
        ) translate([x,y])
            circle(d=pinD/2, $fn=6);
    }

    difference() {
        circle(d=baseD);
        circle(d=baseD - pinD/3);
    }
}
