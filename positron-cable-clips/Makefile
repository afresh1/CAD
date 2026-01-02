#!/usr/bin/env make
SCAD=positron-cable-clips.scad
SUFFIX = .stl

# match "module foobar() { // `make` me"
PREFIX = ${SCAD:S/clips.scad//}
FILES != sed -n 's/^module  *\([A-Za-z0-9_-]*\)([^\)]*) *.*make.* me.*$$/${PREFIX}\1${SUFFIX}/p' $(SCAD)

all: ${FILES}

.SUFFIXES: .scad ${SUFFIX}

PREAMBLE= $$fa=1.0;$$fs=0.1;use

${FILES}: $(SCAD)
	print '${PREAMBLE} <$(>)>;\n${@:C/^${PREFIX}//:C/${SUFFIX}$//}();' | \
	    openscad -o $@ -
