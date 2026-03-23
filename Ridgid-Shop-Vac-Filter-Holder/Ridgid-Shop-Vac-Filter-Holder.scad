$fa = $preview ? $fa : 2.50;
$fs = $preview ? $fs : 0.25;

outside = 200;
inside  = 100;
h = 5;
hole = 3;

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
    rotate_extrude() hull() {
        translate([outside/2-h/2,0]) circle(d=h);
        translate([ inside/2+h/2,0]) circle(d=h);
    }

    translate([0,0,-h/2-0.1]) for (a=[0:45:360]) rotate(a) {
        translate([0,0,0.5]) cube([outside/2,0.1,h-0.8]);

        translate([outside/2 - h - hole/2 - 0.1,0,0]) difference() {
            cylinder(d=2*h-hole/2, h=h+0.2);

            translate([0,0,h/2+0.1]) rotate_extrude()
                translate([h/2 + hole/2+0.1,0]) circle(d=h+0.2);
        }
    }
}
