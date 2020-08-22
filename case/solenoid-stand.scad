module SolenoidStand(z, bottom_shift, ridge_thickness) {
  solenoid_x = 11;
  solenoid_y = 20.5;
  wall_thickness = 1;

  // These are from the solenoid mount file
  top_x = solenoid_x + (wall_thickness * 2);
  top_y = solenoid_y + (wall_thickness * 2);

  bottom_x = ridge_thickness;
  bottom_y = ridge_thickness;

  function center_square_points(x, y, z) = [
    [-(x / 2), -(y / 2), z],
    [(x / 2),  -(y / 2), z],
    [(x / 2),   (y / 2), z],
    [-(x / 2),  (y / 2), z],
  ];

    function translate_points(list, x, y) = [for (elm = list) [elm[0] + x, elm[1] + y, elm[2]] ];

    solenoid_mounting_z = z;

    TrapezoidPoints = concat(
        translate_points(center_square_points(bottom_x, bottom_y, 0), 0, bottom_shift), // bottom square
        center_square_points(top_x, top_y, solenoid_mounting_z));

    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left

    polyhedron(TrapezoidPoints, CubeFaces);
}

use <solenoid-mount.scad>

translate([0, 0, 15])
SolenoidMount();
SolenoidStand(15, 5, 5);
