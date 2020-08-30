case/case.stl: case/*.scad
	openscad case/case.scad -o case/case.stl

case/lid.stl: case/pcb.scad
	openscad case/pcb.scad -o case/lid.stl

case: case/case.stl case/lid.stl
