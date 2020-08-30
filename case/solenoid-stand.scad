module SolenoidStand(z, bottom_shift, ridge_thickness, outer_radius) {
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

    bottom_square_points = [
      [-(bottom_x / 2), -(bottom_y / 2), 0],
      [ (bottom_x / 2), -(bottom_y / 2), 0],
      [ (bottom_x / 2),  (bottom_y / 2), 0],
      [-(bottom_x / 2),  (bottom_y / 2), 0],
    ];

    //bottom_square = translate_points(bottom_square_points, 0, ((top_y / 2) - (bottom_y / 2)) - bottom_shift);
    bottom_square = translate_points(bottom_square_points, 0, ((top_y / 2) - (bottom_y / 2)) - bottom_shift);
    post_points = [
      [bottom_square[2][0], bottom_square[2][1], ridge_thickness - 1],
      [bottom_square[3][0], bottom_square[3][1], ridge_thickness - 1],
    ];

    TrapezoidPoints = concat(
        bottom_square,
        center_square_points(top_x, top_y, solenoid_mounting_z),
        post_points);

    echo(TrapezoidPoints);

    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,8,2,1],  // right
      [6,7,9,3,2,8],  // back
      [7,4,0,3,9],   // left
    ];

    polyhedron(TrapezoidPoints, CubeFaces, convexity = 10);
}

use <solenoid-mount.scad>

translate([0, 0, 15])
SolenoidMount();
SolenoidStand(15, 5, 5, 48);
