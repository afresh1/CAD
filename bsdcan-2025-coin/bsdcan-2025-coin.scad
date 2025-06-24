diameter  = 50;
thickness = 3;
ridges    = 42;

$fa = $preview ? $fa : 5.0;
$fs = $preview ? $fs : 1.0;

module flatCoin() {
    module placeCircles(first=0) {
        for (i=[first:2:ridges-1]) let(
            theta = i*(360/ridges),
            x = diameter/2 * cos(theta),
            y = diameter/2 * sin(theta)
        ) translate([x,y]) rotate(90 + theta) children();
    }

    module ridge() {
        circumference = PI * diameter;
        ridgeD = circumference / ridges;

        resize([ridgeD, ridgeD/2]) circle(d=ridgeD);
    }

    rotate(5.5)
    difference() {
        union() {
            circle(d=diameter);
            placeCircles() ridge();
        }

        placeCircles(1) ridge();
    }
}

module coin() {
    minkowski() {
        linear_extrude(0.01) flatCoin();
        sphere(d=thickness);
    }
}
module txt(t) {
    font="DejaVu Sans:style=Condensed Bold";
    //font="Lucida:style=Sans:weight=Bold";
    //font="Sans;weight=Bold";
    text(t, diameter/7.5, font, halign="center");
}


puffyWidth     = diameter*7/8;
puffyDepth     = thickness/3;
puffyThickness = puffyDepth * 1.2;

//%flatCoin();
difference() {
    coin();

    translate([0,0,thickness/2 - puffyDepth])
        linear_extrude(thickness) scale(0.95) flatCoin();

    mirror([1,0,0])
    translate([
        -diameter/4 - diameter/12.5,
        -diameter/4 - diameter/25.0,
        -1.5*thickness+0.75
    ]) {
        linear_extrude(thickness) translate([diameter/3,0]) {
            translate([0, diameter*4/8]) txt("BSDCan");
            translate([0,-diameter*1/8]) txt("2025");
        }

        translate([0,1,thickness/2])
        resize([diameter*5/8,0,thickness], auto=true)
            import("Beastie_Canada_Flag_Vector_sillohette.svg_5mm.stl");
    }

}

translate([-puffyWidth/2-1,-puffyWidth/2,  thickness/2 + puffyThickness/2 - puffyDepth - 0.01])
    resize([puffyWidth,0,puffyThickness], true)
        import("tshirt-29.svg_5mm.stl");

