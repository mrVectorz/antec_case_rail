
use <rounded_cube.scad>

PART = "rail";

tolerance = 0.75;
$fn=120;

module pin(pin_diameter, pin_length) {
    point = pin_diameter / 2;
    body = pin_length - point;

    rotate([0, 90, 0]) {
        cylinder(h = body, d=pin_diameter, center=true);
        translate([0, 0, body/2])
            sphere(d = pin_diameter);
    }
}

module pins(length = 5) {
    // Diameter of #6 32 screw is .1380"
    pin_diameter = .1380 * 25.4 - tolerance;
    // Distance between front and back hole is 60mm
    pin_spacing = 60;

    translate([length - tolerance, pin_spacing/2, 0]) {
        pin(pin_diameter, length);
    }
    translate([length - tolerance, -pin_spacing/2, 0]) {
        pin(pin_diameter, length);
    }
}

module clip(height, length, width) {
    angle = 16;

    difference() {
        rotate([0, 0, angle])
            cube([width, length, height]);
        translate([.1, 0, -1])
            cube([width * 2, length * 2, height + 2]);
        translate([-width, length - cos(angle), -1])
            cube([width * 2, length, height + 2]);
    }
}

module rail() {
    rail_h = 15;
    rail_l = 4.5*25.4;
    rail_w = 5;

    overlap=2;

    lock_l = 20;
    lock_w = 2;
    
    lock_x = 0;
    lock_y = rail_l - overlap;

    handle_l = 15;
    handle_w = 2;
    handle_angle = 15;

    handle_x = 0;
    handle_y = lock_y + lock_l - .5;

    translate([rail_w/2-0.001, rail_l / 2, 7])
        pins();
    rounded_cube([rail_w, rail_l, rail_h], corner_r=1);
    translate([lock_x, lock_y, 0])
        rounded_cube([lock_w, lock_l + overlap, rail_h], corner_r=1);
    translate([handle_x, handle_y, 0])
        rotate([0, 0, handle_angle])
            translate([.5, .5, 0])
                rounded_cube([handle_w, handle_l, rail_h], corner_r=1);
    translate([0.1, 120.45, rail_h/3])
    clip(rail_h / 3, 7, 2);
}

if (PART == "rail") {
	rail();
}
