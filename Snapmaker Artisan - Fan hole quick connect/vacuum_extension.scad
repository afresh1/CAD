small = 30;
large = 34;

taperLength = 25;

length = 250;

extensionWall = 2;

outside = large+2*extensionWall;

inside = small-2*extensionWall;

$fa = $preview ? $fa : 2.0;
$fs = $preview ? $fs : 0.2;

module taperedTube( d1, d2, h, wall=extensionWall ) {
    difference() {
        w=2*extensionWall;
        cylinder(d1=d1, d2=d2, h=h);
        translate([0,0,-0.1]) cylinder(d1=d1-w, d2=d2-w, h=h+0.2);
    }
}

taperedTube(outside, small+2*extensionWall, taperLength);
translate([0,0,taperLength-0.1]) taperedTube(small+2*extensionWall, large, length-2*taperLength+0.2);
translate([0,0,length-taperLength]) taperedTube(large, small, taperLength);
