$fa = $preview ? $fa : 0.1;
$fs = $preview ? $fs : 0.5;

rocks    = [ 50, 75, 60 ];
starTrek = [ 60, 30, 60 ];
finger   = 20;

border = 4;

box = [
    max( rocks.x,  starTrek.x ) + 2*border,
         rocks.y + starTrek.y   + 3*border,
    max( rocks.z,  starTrek.z ) +   border,
];

module rounded_cube(s, r=border) {
    translate([r,r,r]) minkowski() {
        cube(s - [ r, r, r ]*2);
        sphere(r=r);
    }
}

module rounded_cube_insert(s, r=border/2) {
    rounded_cube(s,r);

    translate([-r,-r,-r + s.z]) difference() {
        rounded_cube([s.x+2*r,s.y+2*r,4*r],r);
        for (c=[
            [   0, s.y, 1],
            [   0,   0, 2],
            [ s.x,   0, 3],
            [ s.x, s.y, 4],
        ])  translate([r+c.x,r+c.y,-2*r])
        rotate(c.z*90) {
            h=(c.z % 2 == 1 ) ? s.x : s.y;
            translate([r,-r,2*r]) rotate([90,0,0]) cylinder(r=r,h=h-2*r);
            translate([0.75*r,0.75*r,2.5*r]) rotate(45) cube(r,true);
            translate([-r,-r,0])
                rotate_extrude(angle=90) translate([2*r,2*r]) {
                    translate([0,-r]) square([r,2*r]);
                    circle(r=r);
                }
        }
    }
}

difference() {
    rounded_cube(box);

    translate([
        (box.x - rocks.x)/2,
        border + 0.01,
        border + 0.02
    ]) {
        rounded_cube_insert(rocks);

        d=finger;
        h=rocks.z;
        for (x=[
           -0.5*(d-border),
            0.5*(d-border) + rocks.x
        ], y=[
            rocks.y*5/6,
            //(1*rocks.y - d/2)/3,
            //(2*rocks.y + d/2)/3
        ]) translate([x, y, d/2 ]) {
            cylinder(d=d,h=h);
            sphere(d=d);
        }
    }

    translate([
        (box.x - starTrek.x)/2,
        box.y - starTrek.y - border + 0.01,
        border + 0.02
    ]) rounded_cube_insert(starTrek);
}
