module Pegs(height, pin_diameter) {
  $fn = 90;
  pcb_thickness = 1.6;

  for (i = [-1, 1]) {
    for (j = [-1, 1]) {
      translate([i * (27 / 2), j * (28 / 2), 0]) {
        linear_extrude(height)
          circle(r = 2.5);
        linear_extrude(height + pcb_thickness)
          circle(d = pin_diameter);
      }
    }
  }
}

module PCBLid(top_thickness, wall_thickness) {
  pcb_padding = 2;
  pcb_x = 33 + pcb_padding;
  pcb_y = 34 + pcb_padding;
  radius = 5;
  pcb_thickness = 1.6 + 8.4; // pcb + components
  lid_height = 8.4;

  lip_height = 2.3;
  outer_lid_x = ((pcb_x + (wall_thickness * 2)) - (radius * 2));
  outer_lid_y = ((pcb_y + (wall_thickness * 2)) - (radius * 2));

  $fn = 90;
  difference() {
    union() {
      // inner lip
      linear_extrude(lid_height + top_thickness + lip_height)
        minkowski() {
          circle(r = radius);
          square(size = [pcb_x - (radius * 2), pcb_y - (radius * 2)], center = true);
        }

      // Outer
      color("green")
      linear_extrude(lid_height + top_thickness)
        minkowski() {
          circle(r = radius);
          square(size = [outer_lid_x, outer_lid_y], center = true);
        }
    }

    translate([0, 0, top_thickness])
    linear_extrude(pcb_thickness + 3) // Add 1 so it looks nice in preview
      minkowski() {
        circle(r = radius - 1);
        square(size = [pcb_x - (radius * 2), pcb_y - (radius * 2)], center = true);
      }

    for (i = [-1, 1]) {
      color("red")
        translate([0, i * ((outer_lid_y + (radius * 2)) / 2) - (i * (1 / 2)), (lid_height + top_thickness) - 1])
        linear_extrude(1)
        square(size = [5, 2], center = true);
    }

    cylinder_length = 8;
    cylinder_radius = 3;
    translate([ -(((pcb_x - pcb_padding) / 2) + (cylinder_length / 2)), ((pcb_y - pcb_padding) / 2) - cylinder_radius, top_thickness + lid_height])
      union() {
        rotate(a = [0, 90, 0])
          cylinder(h = cylinder_length, r = cylinder_radius);
        translate([0, -cylinder_radius, 0])
          linear_extrude(cylinder_radius)
          square(size = [cylinder_length, cylinder_radius * 2]);
      }
  }

  translate([-12, -5, top_thickness])
    rotate(90)
    linear_extrude(1)
      text(str(lip_height), halign = "center", valign = "center", size = 6);
}

module PCBCase(bottom_thickness, wall_thickness, peg_height = 6, pin_diameter = 2.3) {
  pcb_padding = 2;
  pcb_x = 33 + pcb_padding;
  pcb_y = 34 + pcb_padding;

  usb_height = 5;
  usb_width  = 8;

  radius = 5;
  pcb_thickness = 1.6 + 8.4; // pcb + components

  translate([0, 0, bottom_thickness]) {
    difference() {
      $fn = 90;
      //translate([0, 0, -bottom_thickness])
      translate([0, 0, -bottom_thickness])
        linear_extrude(bottom_thickness + pcb_thickness)
        minkowski() {
          circle(r = radius);
          square(size = [((pcb_x + (wall_thickness * 2)) - (radius * 2)), ((pcb_y + (wall_thickness * 2)) - (radius * 2))], center = true);
        }

        linear_extrude(pcb_thickness + 1) // Add 1 so it looks nice in preview
        minkowski() {
          circle(r = radius);
          square(size = [pcb_x - (radius * 2), pcb_y - (radius * 2)], center = true);
        }

      // USB hole
      translate([((pcb_x - pcb_padding) / 2) - 12, -((pcb_y + wall_thickness) / 2), peg_height - usb_height + 0.5])
        color("blue")
        linear_extrude(usb_height)
        // Add 1 so it looks nice in preview
        square(size = [usb_width, wall_thickness + 1], center = true);

    }

    Pegs(peg_height, pin_diameter);
    linear_extrude(1)
      text(str(pin_diameter), halign = "center", valign = "center");
  }
}

//PCBCase(1.5, 1.5);
PCBLid(1.5, 1.5);
