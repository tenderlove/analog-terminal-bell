use <solenoid-stand.scad>
use <solenoid-mount.scad>
use <pcb.scad>
use <bell-base.scad>

module BellAndSolenoidStand(pcb = true) {
  plate_thickness = 1.5;
  bell_bottom_diameter = 86;
  bell_bottom_radius = bell_bottom_diameter / 2;
  bell_diameter = 70;
  bell_radius = bell_diameter / 2;

  fillet_height = 4;
  bottom_ridge_x = fillet_height + 1;
  to_bell_z = 16.5;
  bell_ridge_z = 6;
  solenoid_x = 11;
  solenoid_y = 20.5;
  solenoid_mount_wall_thickness = 1;

  outer_radius = bell_bottom_radius + bottom_ridge_x;

  max_overhang = bell_bottom_radius - bell_radius;
  distance_from_bell_to_solenoid_case = 2.5;
  overhang = max_overhang - distance_from_bell_to_solenoid_case;


  // align the center of the bell ridge with the center of the solenoid
  // solenoid_mounting_z should be the bottom of the solenoid
  post_bottom_y = ((solenoid_y / 2) - (bell_bottom_radius - bell_radius)) + 1;

  BellBase(plate_thickness, bell_bottom_diameter, fillet_height);

  translate([0, (-(bell_bottom_radius + (solenoid_y / 2))) + overhang, plate_thickness]) {
    solenoid_z = 12;

    post_bottom_thickness = fillet_height + 1;
    center_of_bell_ridge_z = to_bell_z + (bell_ridge_z / 2);
    solenoid_mounting_z = center_of_bell_ridge_z - (solenoid_z / 2);

    echo(outer_radius);
    SolenoidStand(solenoid_mounting_z - solenoid_mount_wall_thickness, overhang + solenoid_mount_wall_thickness, bottom_ridge_x, outer_radius);
    translate([0, 0, solenoid_mounting_z - solenoid_mount_wall_thickness])
      SolenoidMount();
  }

  if (pcb) {
    translate([((34 + 2 + plate_thickness + solenoid_x + 2) / 2) + 2, -(bell_bottom_radius + ((33 + 2 + plate_thickness) / 2)) + 0.7, 0])
      rotate(90)
      PCBCase(plate_thickness, plate_thickness, 6);
  }
}
