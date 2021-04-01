module OuterText(txt, r, size=10, font) {
  angle = 180 * size / (PI * r);
  for (i = [0:len(txt) - 1]) {
    rotate([0, 0, -(i + 0.5) * angle])
    translate([0, r])
    text(txt[i], size=size, halign="center", valign="baseline", font=font);
  }
}

module BaseText(plate_thickness, bell_bottom_radius) {
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
      text("BELL", font = f, halign = "center", valign = "center", size = 20);
    }
  }
}
}

module BellBase(plate_thickness, bell_bottom_diameter, fillet_height) {
  bell_bottom_radius = bell_bottom_diameter / 2;
  bottom_ridge_x = fillet_height + 1;

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
  BaseText(plate_thickness, bell_bottom_radius);
}
