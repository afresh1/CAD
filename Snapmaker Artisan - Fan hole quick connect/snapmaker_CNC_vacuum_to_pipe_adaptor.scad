use <Spiral_extrude.scad>;

$fn=100;
fn_spiral = $fn;

COPPER_SPACING_DIA = 6.6;
COPPER_SPIRAL_SPACING = 8.5;
DUCT_INNER_DIA = 32;

SOCKET_DIA1 = 34.5;
SOCKET_DIA2 = 32.0;
SOCKET_INSERT_LEN = 24;

WALL = 1.6;
AIR_INNER_DIA = DUCT_INNER_DIA - 2*WALL;

ANGLE = 45;

JOINER_DIA = DUCT_INNER_DIA+COPPER_SPACING_DIA;

module pipe_end() {
    taper_size = JOINER_DIA - DUCT_INNER_DIA;
    working_twists = 2.5;
    twist_height = (working_twists+0.5) * COPPER_SPIRAL_SPACING;
    rotation = working_twists % 1 * 360;
    translate([-(DUCT_INNER_DIA+COPPER_SPACING_DIA)/2,0,0])
    difference() {
        union() {
            translate([0,0,-COPPER_SPACING_DIA/2]) mirror([1,0,0]) {
                rotate([0, 0, rotation]) translate([0,0,COPPER_SPIRAL_SPACING*working_twists])
                    extrude_spiral(StartRadius=DUCT_INNER_DIA/2, Angle=360*0.5, ZPitch=COPPER_SPIRAL_SPACING, RPitch=-COPPER_SPACING_DIA, StepsPerRev=fn_spiral){circle(d=COPPER_SPACING_DIA);}
                extrude_spiral(StartRadius=DUCT_INNER_DIA/2, Angle=360*working_twists, ZPitch=COPPER_SPIRAL_SPACING, StepsPerRev=fn_spiral){circle(d=COPPER_SPACING_DIA);}
            }
            cylinder(d=DUCT_INNER_DIA, h=twist_height);
            cylinder(d1=JOINER_DIA, d2=DUCT_INNER_DIA, h=taper_size);
        }
        translate([0,0,-1]) cylinder(d=AIR_INNER_DIA, h=twist_height+2);
        translate([0,0,-COPPER_SPIRAL_SPACING]) cube([50, 50, COPPER_SPIRAL_SPACING*2], center=true);
    }
}

module tool_end() {
    CHANGE_LEN = 4;
    translate([-JOINER_DIA/2,0,-SOCKET_INSERT_LEN-CHANGE_LEN])
    difference() {
        cylinder(d1=SOCKET_DIA2, d2=SOCKET_DIA1, h=SOCKET_INSERT_LEN);
        translate([0,0,-0.01]) cylinder(d1=SOCKET_DIA2-WALL*2, d2=SOCKET_DIA1-WALL*2, h=SOCKET_INSERT_LEN+0.02);
    }
    translate([-JOINER_DIA/2,0,-CHANGE_LEN])
    difference() {
        cylinder(d1=SOCKET_DIA1, d2=JOINER_DIA, h=CHANGE_LEN);
        translate([0,0,-0.01]) cylinder(d1=SOCKET_DIA1-WALL*2, d2=AIR_INNER_DIA, h=CHANGE_LEN+0.02);
    }
}

module joiner() {
    difference() {
        translate([-JOINER_DIA/2,0,-JOINER_DIA/2]) 
        difference() {
            cylinder(d=JOINER_DIA, h=JOINER_DIA);
            translate([0,0,-0.5]) cylinder(d=AIR_INNER_DIA, h=JOINER_DIA+1);
        }
        rotate([0,ANGLE/2,0]) translate([-JOINER_DIA,0,JOINER_DIA]) cube(JOINER_DIA*2, center=true);
        translate([-JOINER_DIA,0,-JOINER_DIA]) cube(JOINER_DIA*2, center=true);
    }
    difference() {
        rotate([0,ANGLE,0]) translate([-JOINER_DIA/2,0,-JOINER_DIA/2]) 
        difference() {
            cylinder(d=JOINER_DIA, h=JOINER_DIA);
            translate([0,0,-0.5]) cylinder(d=AIR_INNER_DIA, h=JOINER_DIA+1);
        }
        rotate([0,ANGLE/2,0]) translate([-JOINER_DIA,0,-JOINER_DIA]) cube(JOINER_DIA*2, center=true);
        rotate([0,ANGLE,0]) translate([-JOINER_DIA,0,JOINER_DIA]) cube(JOINER_DIA*2, center=true);
    }
}

// Flip the lot for printing
rotate([0,180-ANGLE,0]) {
tool_end();
joiner();
rotate([0,ANGLE,0]) pipe_end();
}
