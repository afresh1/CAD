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

use <Snapmaker-Artisan-Fan-hole-quick-connect.scad>;

// https://github.com/sillyfrog/snapmaker-cnc-vacuum-extras/blob/main/through_desk_to_pipe_adaptor.scad
use <through_desk_to_pipe_adaptor.scad>;
//use <snapmaker_CNC_vacuum_to_pipe_adaptor.scad>;

holeDiameter = 32 - 2*1.6; // from through_desk_to_pipe_adaptor
plateThickness = 8;

$fa = $preview ? $fa : 8.0;
$fs = $preview ? $fs : 1.0;

difference() {
	union() {
		pipe_end();
		rotate([180]) magnetPlate();
	}

	translate([0,0,-plateThickness-0.1])
		cylinder(d1=holeDiameter*2, d2=holeDiameter, h=plateThickness + 0.2);
}
