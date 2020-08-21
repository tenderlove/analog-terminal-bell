$fn = 90;

plate_thickness = 1.5;
bell_bottom_diameter = 86;
bell_bottom_radius = bell_bottom_diameter / 2;
bell_diameter = 70;
bell_radius = bell_diameter / 2;

fillet_height = 4;
to_bell_z = 16.5;
bell_ridge_z = 6;
solenoid_z = 12;
solenoid_x = 11;
solenoid_y = 20;

center_of_bell_ridge_z = to_bell_z + (bell_ridge_z / 2);

// align the center of the bell ridge with the center of the solenoid
// solenoid_mounting_z should be the bottom of the solenoid
solenoid_mounting_z = center_of_bell_ridge_z - (solenoid_z / 2);
post_bottom_y = ((solenoid_y / 2) - (bell_bottom_radius - bell_radius)) + 1;

module SolenoidMount() {
  sphere_radius = 5;

  translate([0, 0, solenoid_mounting_z / 2]) {
    difference() {
      color("red")
        cube(size = [solenoid_x, solenoid_y, solenoid_mounting_z], center = true);

      translate([0, 0, (solenoid_mounting_z / 2) - (2 + (2 / 2))]) {
        cube(size = [solenoid_x, 3, 2], center=true); //ziptie
      }

      for (i = [-1, 1]) {
        translate([0, i * ((solenoid_y / 2) + 5.5), 0]) {
          cube(size = [solenoid_x, solenoid_y, solenoid_mounting_z], center = true);
        }

        // Front and Back
        translate([0, i * ((solenoid_y + sphere_radius) - (bell_bottom_radius - bell_radius) + 1), -1 * (sphere_radius) - 2]) {
          minkowski() {
            cube(size = [solenoid_x, solenoid_y, solenoid_mounting_z], center = true);
            sphere(sphere_radius);
          }
        }

        // Left and Right
        translate([i * ((6 + solenoid_x) - 3), 0, -1 * (sphere_radius) - 2]) {
          minkowski() {
            cube(size = [solenoid_x, solenoid_y, solenoid_mounting_z], center = true);
            sphere(6);
          }
        }
      }

      translate([0, (-1 * (solenoid_y  / 2)) - sphere_radius - (fillet_height / 2), -1 * (sphere_radius) - 2]) {
        minkowski() {
          cube(size = [solenoid_x, solenoid_y, solenoid_mounting_z], center = true);
          sphere(sphere_radius);
        }
      }
    }
  }
}

module BellBase() {
  translate([0, 0, plate_thickness]) {
    color("Violet")
      translate([0, 0, -plate_thickness])
      linear_extrude(height = plate_thickness)
      circle(d = bell_bottom_diameter + (2 * (fillet_height + 1)));

    color("Olive")
      rotate_extrude()
      translate([bell_bottom_radius, 0, 0]) {
        union() {
          square(size = [1, fillet_height]);
          translate([1, 0, 0]) {
            intersection() {
              square(fillet_height * 2);
              difference() {
                square(fillet_height * 2, center=true);
                translate([fillet_height, fillet_height]) circle(fillet_height);
              }
            }
          }
        }
      }
  }
}

BellBase();
shift = (-1 * (bell_bottom_radius)) - post_bottom_y;
translate([0, shift + 0.1, plate_thickness]) {
  SolenoidMount();
}

rotate(90) {
  translate([0, 0, plate_thickness]) {
    linear_extrude(1) {
      text("\u30D9\u30EB", font = "Hiragino Mincho Pro:style=W3", halign = "center", valign = "center", size = 30);
    }
  }
}
