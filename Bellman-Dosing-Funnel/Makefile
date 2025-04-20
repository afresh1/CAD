#!/usr/bin/env make
SCAD=fourth-axis-brace.scad
SUFFIX = .stl

# match "module foobar() { // `make` me"
TARGETS != sed -n 's/^module  *\([A-Za-z0-9_-]*\)([^\)]*) *.*make.* me.*$$/\1${SUFFIX}/p' $(SCAD)

all: ${TARGETS}

.SUFFIXES: .scad ${SUFFIX}

${TARGETS}: $(SCAD)
	print 'use <$(SCAD)>;\n$*();' | openscad -m make -o $@ -
