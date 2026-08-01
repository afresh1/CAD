$fa = $preview ? $fa : 0.5;
$fs = $preview ? $fs : 0.01;

bits    = 12;
columns =  2;
wall    =  0.8;
height  = 10;

turner = false;
fudge = 0.25;
bitDiameter = fudge + ( 1/4 * 25.4 );

bitsPerColumn = ceil( bits/columns );
extra = columns * bitsPerColumn - bits;
echo(bits, columns, bitsPerColumn, extra);

leatherman = true;
leathermanBitThickness = 3.20;

function removeEvenHole(col) = (            1 + 2 * extra > col ) ? 1 : 0;
function removeOddHole(col)  = ( extra >= columns/2 && extra > col ) ? 1 : 0;
function removeHole(col) = (col % 2 == 0) ? removeEvenHole(col) : removeOddHole(col);

function bitsPerColumn(col) = bitsPerColumn - removeHole(col);

module bit( d = bitDiameter ) {
    r = d * sin(30)/sin(120);
    s = ( sqrt( r^2 + r^2 ) );
    l = 2*r - ( d - s )/2;

    difference() {
        circle(r=r, $fn=6);

        *if (!turner)
            for (a=[30:60:359])
                translate( [ l * cos(a), l * sin(a) ] )
                circle(r=r);

        if (leatherman)
            for (y=[-0.5,0.5])
                translate([0,y*(2*r+leathermanBitThickness+fudge),0])
                    square(2*r, true);
    }
}

if (turner) {
    linear_extrude(height)
    difference() {
        hull() {
		w=bitDiameter * sin(30)/sin(120) + 2*wall;
		t=bitDiameter/2;

		circle(w);
		for (i=[-0.5,0.5]) translate([4*w*i,0])
		    circle(d=t);
        }
        bit();
    }
}
else {
    positions = [ for (r=[0:columns-1])
        let(
            d = bitDiameter + 2.2*wall,
            off = (r % 2 == 0) ? 0 : 0.5
        )
        for (c=[0:bitsPerColumn(r + 1) - 1]) [
                r * (leatherman ? 1.5*leathermanBitThickness : bitDiameter ),
                c * d + off * d
            ]
    ];

    linear_extrude(height)
    difference() {
        for (p=positions) translate(p) circle(d=bitDiameter + 4*wall);
        for (p=positions) translate(p) rotate(90) bit();
    }
}
