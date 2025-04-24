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

// Height of the funnel
height = 30;

// Top diameter inside/outside
top    = [ 74.75, 76.5 ];

// Bottom diameter inside/outside
bottom = [ 71.0, 78.0 ];

// Diameter of the middle stem
hole   = 17;

// Number of rails holding the middle hole cover
rails = 3;

// Thinkness of some walls
wall   =  1.5;

$fa = $preview ? $fa : 2.5;
$fs = $preview ? $fs : 0.5;

// Just make the outside of the funnel reusable
module outside() {
    cylinder(d1=bottom[1], d2=top[1], h=height);
}

// This is the piece that goes in the middle to cover
// the hole.
module holeCover() {
    intersection() {
        outside();

        difference() {
            union() {
                outer = hole + wall*2;
                sphere(d=outer);

                w = 2;
                for(i=[1:rails]) rotate([0,0,360*i/rails])
                    translate([w/2,0,0]) rotate([0,-90])
                        linear_extrude(w) polygon([
                            [0,          0],
                            [height*3/8, bottom[1]/2],
                            [height*7/8, bottom[1]/2],
                            [outer/2,    0],
                        ]);
            }

            sphere(d=hole);
        }
    }
}

// Makes a donut, sort-of
module rim(d, r) {
    rotate_extrude() translate([(d + r)/2, 0, 0])
        circle(d=r);
}

difference() {
    union() {
        difference() {
            outside();
            translate([0,0,-0.1])
                cylinder(d1=bottom[0]-wall, d2=top[0], h=height + 0.2);
        }

        // top edge
        //translate([0,0,height]) rim( top[0]-wall, (top[1] - top[0])/2+wall);

	// The main body, need the separate difference
	// to cut out the "rails" that hold the stem cover.
        holeCover();
    }

    // bottom cut
    rim( bottom[0], bottom[1] - bottom[0] );
}
