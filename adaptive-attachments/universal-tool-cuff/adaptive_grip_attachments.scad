// =============================================================================
//  Phoenix v8 Adaptive Grip & Task-Specific Tool Cuff System — OpenSCAD Model
// =============================================================================
//  Direct modular expansion for the Phoenix Starter Hand (`palm.stl` and
//  `palm_base.stl`). Replaces or snaps into the 4 lateral wall slots of the
//  Phoenix palm to provide high-torque, task-specific daily living adapters
//  that overcome the pinch-force limits of cable-driven fingers:
//
//   1. Universal Utensil / Stylus / Toothbrush Indexing Gimbal Cuff (snaps into
//      Phoenix `BASE_SLOTS` on the palmar underside).
//   2. Hex-Bit & Workshop Tool Magnetic/Press Receiver Dock.
//   3. Compliant Metamaterial Fingertip Pinch Sleeves (fits Phoenix distal
//      phalanx geometry for high-friction key pinch).
// =============================================================================

/* [Part to render] */
part = "all_plates"; // [utensil_gimbal_base, hex_tool_holder, compliant_pinch_pad, all_plates]

/* [Sizing (Matches Phoenix Starter Hand Parameters)] */
// Recipient hand width in mm (matches phoenix_starter_hand.scad default 66 mm)
hand_width = 66;
foam_thickness = 3;
wall = 2.8;
// Universal utensil/pen pocket inner width (mm)
utensil_slot_w = 14.5;
// Utensil slot height (mm)
utensil_slot_h = 6.5;

/* [Hidden] */
$fa = $preview ? 8 : 4;
$fs = $preview ? 0.8 : 0.35;
BASE_INNER_W = 56;
S = (hand_width + 2 * foam_thickness + 1) / BASE_INNER_W;
W_i = BASE_INNER_W * S;
W_o = W_i + 2 * wall;
a_o = W_o / 2;

b_t  = 2.6;
b_fc = 0.15;
b_ft = 1.8;
b_fz = 7.5;
b_x  = a_o + b_fc + b_ft;

// -------------------------------------- 1. Universal Utensil Gimbal Base -----
module utensil_gimbal_base() {
  L_plate = 44 * S;
  difference() {
    union() {
      // Base tray matching Phoenix palm underside footprint
      translate([-b_x, -L_plate / 2, 0])
        cube([2 * b_x, L_plate, b_t]);
      // Side snap flanges and wedges matching Phoenix BASE_SLOTS
      for (sx = [-1, 1]) {
        translate([sx > 0 ? a_o + b_fc : -b_x, -L_plate / 2 + 2, 0])
          cube([b_ft, L_plate - 4, b_fz + b_t]);
        // Snap lock ridges at slot heights BS_Z0..BS_Z1
        translate([sx > 0 ? a_o + b_fc - 0.9 : -(a_o + b_fc + 0.1), -L_plate * 0.38, b_t + 3.2])
          cube([1.0, 16, 1.8]);
        translate([sx > 0 ? a_o + b_fc - 0.9 : -(a_o + b_fc + 0.1),  L_plate * 0.10, b_t + 3.2])
          cube([1.0, 16, 1.8]);
      }
      // Palmar universal utensil/pen indexing turret
      translate([0, 0, -10]) cylinder(r1 = 16, r2 = 20, h = 10.2, $fn = 36);
    }
    // Rectangular utensil tang slot (fork, spoon, paintbrush)
    translate([0, 0, -5.5])
      cube([utensil_slot_w, 42, utensil_slot_h], center = true);
    // Perpendicular cylindrical stylus / pen / toothbrush channel (d = 9.5 mm)
    translate([0, 0, -5.5]) rotate([0, 90, 0])
      cylinder(d = 9.5, h = 44, center = true, $fn = 24);
    // M4 thumb-screw retention bore from palmar face
    translate([0, 0, -11]) cylinder(d = 4.2, h = 15, $fn = 20);
    // Breathable hex vents
    for (ix = [-1, 1], iy = [-1, 1])
      translate([ix * (a_o * 0.55), iy * (L_plate * 0.28), -1])
        cylinder(d = 4.5, h = b_t + 2, $fn = 6);
  }
}

// ----------------------------------------- 2. Quarter-Inch Hex Tool Turret ---
module hex_tool_holder() {
  difference() {
    union() {
      cylinder(r = 15, h = 18, $fn = 36);
      translate([-19, -8, 0]) cube([38, 16, 4]);
    }
    // Standard 1/4 inch (6.35 mm + 0.25 mm clearance) hex driver socket
    translate([0, 0, 4]) cylinder(d = (6.60) / cos(30), h = 16, $fn = 6);
    // Cross-pin lock hole
    translate([0, 0, 11]) rotate([0, 90, 0]) cylinder(d = 3.2, h = 34, center = true);
  }
}

// ----------------------------------- 3. Compliant Metamaterial Fingertip -----
module compliant_pinch_pad() {
  fw = (W_o - 5 * max(3.0, 2.6 * S)) / 4 - 0.4;
  dh = 10.5 * S;
  difference() {
    hull() {
      translate([0, 0, 0]) scale([fw * 0.58, dh * 0.58, 1]) cylinder(r = 1, h = 14);
      translate([0, 0, 14]) scale([fw * 0.52, dh * 0.52, 5]) sphere(1);
    }
    // Inner fingertip pocket
    translate([0, 0, -1]) hull() {
      scale([fw * 0.46, dh * 0.46, 1]) cylinder(r = 1, h = 12);
      translate([0, 0, 12]) scale([fw * 0.40, dh * 0.40, 4]) sphere(1);
    }
    // Micro-ridge palmar friction ribs
    for (z = [3 : 2.5 : 13])
      translate([0, dh * 0.55, z]) rotate([0, 90, 0])
        cylinder(r = 0.6, h = fw + 4, center = true);
  }
}

module all_plates() {
  translate([0, 0, 10]) utensil_gimbal_base();
  translate([65, -18, 0]) hex_tool_holder();
  for (k = [0:1]) translate([65 + k * 24, 18, 0]) compliant_pinch_pad();
}

if (part == "utensil_gimbal_base") utensil_gimbal_base();
else if (part == "hex_tool_holder") hex_tool_holder();
else if (part == "compliant_pinch_pad") compliant_pinch_pad();
else all_plates();
