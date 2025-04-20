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

outerD = 90;
innerD = 68;

cutout = [ 15.00, 16.25, 4.0 ];

$fa = $preview ? $fa : 0.5;
$fs = $preview ? $fs : 0.01;

difference() {
    circle(d=outerD);
    circle(d=innerD);

    intersection() {
    	circle(d=innerD + 2*cutout[2]);

        for (i=[0:2]) rotate([0,0,360*i/3])
            translate([0,innerD/2])
                polygon([
                    [-cutout[0]/2, -cutout[2]/3 ],
                    [-cutout[1]/2,  cutout[2] ],
                    [ cutout[1]/2,  cutout[2] ],
                    [ cutout[0]/2, -cutout[2]/3 ],
                ]);
    }

}
