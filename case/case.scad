$fn = 50;

bell_bottom_diameter = 86;
bell_bottom_radius = bell_bottom_diameter / 2;
fillet_height = 4;

color("Violet")
translate([0, 0, -2])
linear_extrude(height = 2)
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
