module SolenoidMount() {
  bottom_padding = 2;

  solenoid_z = 12;
  solenoid_x = 11;
  solenoid_y = 20.5;

  wall_thickness = 1;

  case_z = solenoid_z;
  case_x = solenoid_x + (wall_thickness * 2);
  case_y = solenoid_y + (wall_thickness * 2);

  shaft_width_front = 3;
  shaft_width_back = 6;
  corner_height = 3;

  union() {
    difference() {
      linear_extrude(corner_height + bottom_padding)
        square(size = [case_x, case_y], center = true);

      // Solenoid cutout
      translate([0, 0, bottom_padding])
        linear_extrude(solenoid_z)
        square(size = [solenoid_x, solenoid_y], center = true);

      for(i = [-1, 1]) {
        translate([0, i *((solenoid_y / 2) + (wall_thickness / 2)), bottom_padding])
          linear_extrude(solenoid_z)
          square(size = [shaft_width_back, wall_thickness], center = true);

        translate([i *((solenoid_x / 2) + (wall_thickness / 2)), 0, bottom_padding])
          linear_extrude(solenoid_z)
          square(size = [wall_thickness, solenoid_y - 4], center = true);
      }
    }

    translate([0, 0, bottom_padding])
      linear_extrude(1) {
        front = solenoid_y / 2;
        translate([-3, front - 5, 0])
          circle(d = 1.5);

        translate([3, front - 5 - 10, 0])
          circle(d = 1.5);
      }
  }
}

SolenoidMount();
