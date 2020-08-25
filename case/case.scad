$fn = 90;

plate_thickness = 1.5;
bell_bottom_diameter = 86;
bell_bottom_radius = bell_bottom_diameter / 2;
bell_diameter = 70;
bell_radius = bell_diameter / 2;

fillet_height = 4;
bottom_ridge_x = fillet_height + 1;
to_bell_z = 16.5;
bell_ridge_z = 6;
solenoid_z = 12;
solenoid_x = 11;
solenoid_y = 20.5;
solenoid_mount_wall_thickness = 1;

center_of_bell_ridge_z = to_bell_z + (bell_ridge_z / 2);

// align the center of the bell ridge with the center of the solenoid
// solenoid_mounting_z should be the bottom of the solenoid
solenoid_mounting_z = center_of_bell_ridge_z - (solenoid_z / 2);
post_bottom_y = ((solenoid_y / 2) - (bell_bottom_radius - bell_radius)) + 1;

use <solenoid-stand.scad>
use <solenoid-mount.scad>

max_overhang = bell_bottom_radius - bell_radius;
distance_from_bell_to_solenoid_case = 2.5;
overhang = max_overhang - distance_from_bell_to_solenoid_case;

module Solenoid() {
  post_bottom_thickness = bottom_ridge_x;

  SolenoidStand(solenoid_mounting_z - solenoid_mount_wall_thickness, overhang + solenoid_mount_wall_thickness, bottom_ridge_x);
  translate([0, 0, solenoid_mounting_z - solenoid_mount_wall_thickness])
  SolenoidMount();
}

module BellBase() {
  translate([0, 0, plate_thickness]) {
    color("Violet")
      translate([0, 0, -plate_thickness])
      linear_extrude(height = plate_thickness)
      circle(d = bell_bottom_diameter + (2 * bottom_ridge_x));

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

translate([0, (-(bell_bottom_radius + (solenoid_y / 2))) + overhang, plate_thickness]) {
  Solenoid();
}

BellBase();

module OuterText(txt, r, size=10, font) {
  angle = 180 * size / (PI * r);
  for (i = [0:len(txt) - 1]) {
    rotate([0, 0, -(i + 0.5) * angle])
    translate([0, r])
    text(txt[i], size=size, halign="center", valign="baseline", font=font);
  }
}

f1 = "Helvetica Neue:style=Bold";
f = "Cochin:style=Bold";

translate([0, 0, plate_thickness]) {
  linear_extrude(1) {
    rotate(325)
      OuterText(txt = "ANALOG", r = (bell_bottom_radius - 12), font = f1);

    rotate(165)
      OuterText(txt = "TERMINAL", r = (bell_bottom_radius - 12), font = f1);
  }
}

rotate(270) {
  translate([0, 4, plate_thickness]) {
    linear_extrude(1) {
      //text("\u30D9\u30EB", font = "Hiragino Mincho Pro:style=W3", halign = "center", valign = "center", size = 30);
      //text("Bell", font = "Star Trek Future:style=Regular", halign = "center", valign = "center", size = 40);
      text("BELL", font = f, halign = "center", valign = "center", size = 20);
    }
  }
}
/*
MAHJONG TILE SUMMER
Unicode: U+1F027, UTF-8: F0 9F 80 A7


WHITE SMILING FACE
Unicode: U+263A U+FE0E, UTF-8: E2 98 BA EF B8 8E
*/
