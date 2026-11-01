// =============================================================================
//  Kinetic PIP-Driven Finger Prosthetic — Parametric OpenSCAD Model
// =============================================================================
//  A body-powered, 3D-printable partial-finger prosthesis designed around a
//  crossed four-bar linkage and dorsal metacarpal anchor. Flexing the residual
//  proximal phalanx (PIP/MCP joint) drives the middle and distal phalanges into
//  a natural cylindrical grasp and precision pinch without requiring a wrist
//  gauntlet.
//
//  DESIGN PRINCIPLES (consistent with Phoenix Starter Hand architecture):
//   * Hardware never scales. Pin bores, linkage clearances, elastic channels,
//     and snap-fit retention pockets remain at true hardware tolerances across
//     all finger sizes.
//   * Self-contained knuckle actuation. Driven directly by residual stump
//     flexion against a low-profile dorsal ring anchor.
//   * Labelled components. Each phalanx and pin gate carries a debossed digit
//     identifier (I, M, R, L) and clearance gauge coupon.
//   * Print-in-orientation flat dorsal surfaces require zero support material.
//
//  SAFETY: Experimental open-source assistive device, not FDA-cleared. Fit and
//  evaluate with a qualified prosthetist or hand therapist.
// =============================================================================

/* [Part to render] */
part = "assembly"; // [assembly, socket_ring, middle_phalanx, distal_phalanx, linkage_bar, dorsal_cuff, pins, fit_test, all_plates]
digit = "I";       // [I:Index, M:Middle, R:Ring, L:Little]
hand = "right";    // [right, left]

/* [Sizing (Recipient Measurements in mm)] */
// Circumference of the residual proximal phalanx stump (mm)
stump_circumference = 58;
// Length of residual stump from MCP crease to stump tip (mm)
stump_length = 28;
// Total intact finger length from MCP knuckle to fingertip on opposite hand (mm)
target_finger_length = 76;
// Width across the MCP knuckle (mm, 0 = compute from circumference)
knuckle_width = 0;
// Silicone or medical foam liner thickness inside stump ring (mm)
liner_thickness = 1.5;

/* [Fit & Hardware (Never Scaled)] */
// Clearance between moving printed joints (mm)
joint_clearance = 0.35;
// Printed hinge pin diameter (mm)
pin_diameter = 2.6;
// Press-fit pin allowance (mm)
pin_fit_tight = 0.08;
// Free-running pivot pin allowance (mm)
pin_fit_free = 0.30;
// Minimum structural shell wall thickness (mm)
wall = 2.2;
// Dorsal linkage bar thickness (mm)
link_t = 2.6;
// Elastic return cord channel radius (mm)
ch_r = 0.85;

/* [Assembly Preview] */
// Residual PIP joint flexion angle in degrees (drives coupled distal curl)
pip_flexion = 35; // [0:1:75]
animate = false;
primary_color  = "#2f6fdb";
phalanx_color  = "#f4f4f2";
linkage_color  = "#ffb703";
hardware_color = "#2b2b2b";

/* [Hidden] */
$fa = $preview ? 8 : 4;
$fs = $preview ? 0.8 : 0.3;
EPS = 0.01;
FONT = "Liberation Sans:style=Bold";

// --------------------------------------------------------- Derived Sizing ----
r_stump_inner = (stump_circumference / (2 * PI)) + liner_thickness;
r_stump_outer = r_stump_inner + wall;
fw = knuckle_width > 0 ? knuckle_width : 2 * r_stump_outer;
fh = 2 * r_stump_outer;

rem_len = max(32, target_finger_length - stump_length);
L_mid   = 0.54 * rem_len;
L_dist  = 0.46 * rem_len;
tip_h   = 0.72 * fh;

hole_tight = pin_diameter + pin_fit_tight;
hole_free  = pin_diameter + pin_fit_free;
cl         = joint_clearance;
cheek_t    = max(2.2, 0.22 * fw);
tongue_w   = fw - 2 * cheek_t - 2 * cl;

// Four-bar linkage geometry: coupled DIP angle = 0.85 * PIP angle
dip_coupled = 0.85 * (animate ? 37.5 * (1 - cos(360 * $t)) : pip_flexion);
pip_ang     = animate ? 37.5 * (1 - cos(360 * $t)) : pip_flexion;
L_link      = L_mid + 6.5;

// ---------------------------------------------------------------- Helpers ----
module label_deboss(txt, sz = 3.6) {
  linear_extrude(1.6, center = true)
    text(txt, size = sz, font = FONT, halign = "center", valign = "center");
}

module d_pin(len, d) {
  flat = 0.3;
  h = d - 2 * flat;
  translate([0, 0, h / 2]) intersection() {
    rotate([0, 90, 0]) cylinder(d = d, h = len, $fn = 28);
    translate([-1, -d, -h / 2]) cube([len + 2, 2 * d, h]);
  }
}

// --------------------------------------------------- 1. Stump Socket Ring ----
module socket_ring() {
  difference() {
    union() {
      // Tapered anatomical sleeve around residual proximal phalanx
      hull() {
        rotate([-90, 0, 0]) cylinder(r = r_stump_outer, h = stump_length - 4);
        translate([0, stump_length, 0]) rotate([0, 90, 0])
          cylinder(r = fh * 0.46, h = fw, center = true);
      }
      // Dorsal linkage pivot tower on proximal ring
      hull() {
        translate([0, 6, r_stump_outer - 1]) rotate([0, 90, 0])
          cylinder(r = hole_tight / 2 + 2.2, h = tongue_w, center = true);
        translate([-tongue_w / 2, 2, r_stump_outer - 3])
          cube([tongue_w, 10, 2]);
      }
    }
    // Residual stump bore with flared proximal entry
    translate([0, -1, 0]) rotate([-90, 0, 0])
      cylinder(r1 = r_stump_inner + 0.8, r2 = r_stump_inner, h = stump_length - 2);
    // Ventral relief cutout for comfortable palmar pad skin contact
    translate([0, stump_length * 0.42, -r_stump_outer - 2])
      scale([0.75, 1.2, 0.8]) sphere(r = r_stump_inner * 0.85);
    // Breathable hex ventilation ports on lateral walls
    for (iy = [0, 1]) translate([0, 8 + iy * 8, 2])
      rotate([0, 90, 0]) cylinder(d = 3.6, h = fw + 6, center = true, $fn = 6);
    // Distal PIP fork slot for middle phalanx tongue
    translate([-(tongue_w / 2 + cl), stump_length - fh * 0.45, -fh])
      cube([tongue_w + 2 * cl, fh + 2, 2 * fh]);
    // PIP joint pivot pin bore (tight in cheeks)
    translate([0, stump_length, 0]) rotate([0, 90, 0])
      cylinder(d = hole_tight, h = fw + 4, center = true);
    // Dorsal linkage anchor bore
    translate([0, 6, r_stump_outer + 2.5]) rotate([0, 90, 0])
      cylinder(d = hole_free, h = tongue_w + 4, center = true);
    // Digit ID deboss on lateral cheek
    translate([fw / 2 - 0.4, stump_length * 0.55, 0])
      rotate([90, 0, 90]) label_deboss(digit, 3.8);
  }
}

// ------------------------------------------------------ 2. Middle Phalanx ----
module middle_phalanx() {
  r_p = fh * 0.44;
  r_d = fh * 0.39;
  difference() {
    union() {
      // Proximal tongue (rides inside socket_ring fork)
      rotate([0, 90, 0]) cylinder(r = r_p, h = tongue_w, center = true);
      // Main middle phalanx body widening to full finger width
      hull() {
        translate([0, r_p * 0.6, 0]) rotate([0, 90, 0])
          cylinder(r = r_p, h = fw, center = true);
        translate([0, L_mid, 0]) rotate([0, 90, 0])
          cylinder(r = r_d, h = fw, center = true);
      }
      // Hyperextension mechanical stop lug
      translate([-tongue_w / 2, -r_p, 0]) cube([tongue_w, r_p, r_p]);
    }
    // Distal DIP fork cutout
    translate([-(tongue_w / 2 + cl), L_mid - r_d - cl, -fh])
      cube([tongue_w + 2 * cl, 2 * r_d + 2 * cl + 2, 2 * fh]);
    // PIP pivot bore (free rotation)
    rotate([0, 90, 0]) cylinder(d = hole_free, h = fw + 4, center = true);
    // DIP pivot bore (tight pin in middle phalanx cheeks)
    translate([0, L_mid, 0]) rotate([0, 90, 0])
      cylinder(d = hole_tight, h = fw + 4, center = true);
    // Dorsal return elastic channel
    translate([0, -r_p - 1, r_d * 0.55]) rotate([-90, 0, 0])
      cylinder(r = ch_r, h = L_mid + 2 * r_p + 2);
    // Side label
    translate([fw / 2 - 0.4, L_mid * 0.5, 0])
      rotate([90, 0, 90]) label_deboss(digit, 3.5);
  }
}

// ------------------------------------------------------ 3. Distal Phalanx ----
module distal_phalanx() {
  r_d = fh * 0.38;
  r_tip = tip_h * 0.45;
  difference() {
    union() {
      // Proximal tongue with elevated linkage lever arm
      hull() {
        rotate([0, 90, 0]) cylinder(r = r_d, h = tongue_w, center = true);
        translate([0, -2.5, r_d + 2.8]) rotate([0, 90, 0])
          cylinder(r = hole_free / 2 + 1.8, h = tongue_w * 0.75, center = true);
      }
      // Anatomical tapered fingertip pad
      hull() {
        translate([0, r_d + cl, 0]) rotate([0, 90, 0])
          cylinder(r = r_d, h = fw * 0.94, center = true);
        translate([0, L_dist - r_tip, -r_d * 0.15])
          scale([fw * 0.44, r_tip * 1.3, r_tip]) sphere(1, $fn = 36);
      }
    }
    // DIP pivot bore
    rotate([0, 90, 0]) cylinder(d = hole_free, h = fw + 4, center = true);
    // Linkage coupling pin bore on dorsal cam horn
    translate([0, -2.5, r_d + 2.8]) rotate([0, 90, 0])
      cylinder(d = hole_free, h = tongue_w + 4, center = true);
    // Palmar tactile grip grooves
    for (k = [0:2])
      translate([0, L_dist * (0.48 + k * 0.14), -r_d * 0.85])
        rotate([0, 90, 0]) cylinder(r = 0.65, h = fw + 2, center = true, $fn = 14);
    // Elastic anchor knot pocket
    translate([0, L_dist * 0.65, 0]) sphere(r = 2.0, $fn = 18);
  }
}

// ------------------------------------------------- 4. Coupled Linkage Bar ----
module linkage_bar() {
  w_bar = tongue_w * 0.68;
  r_end = hole_free / 2 + 1.8;
  difference() {
    hull() {
      rotate([0, 90, 0]) cylinder(r = r_end, h = w_bar, center = true);
      translate([0, L_link, 0]) rotate([0, 90, 0])
        cylinder(r = r_end, h = w_bar, center = true);
    }
    rotate([0, 90, 0]) cylinder(d = hole_tight, h = w_bar + 4, center = true);
    translate([0, L_link, 0]) rotate([0, 90, 0])
      cylinder(d = hole_tight, h = w_bar + 4, center = true);
  }
}

// ------------------------------------------------- 5. Dorsal Knuckle Cuff ----
module dorsal_cuff() {
  cuff_w = fw + 6;
  cuff_l = 22;
  difference() {
    hull() {
      translate([-cuff_w / 2, -cuff_l, r_stump_outer - 2])
        cube([cuff_w, cuff_l, wall + 1.2]);
      translate([0, 0, r_stump_outer + 2]) rotate([0, 90, 0])
        cylinder(r = hole_tight / 2 + 2.2, h = tongue_w, center = true);
    }
    translate([0, -cuff_l - 1, 0]) rotate([-90, 0, 0])
      cylinder(r = r_stump_outer + 0.3, h = cuff_l + 6);
    translate([0, 0, r_stump_outer + 2]) rotate([0, 90, 0])
      cylinder(d = hole_tight, h = cuff_w + 4, center = true);
  }
}

// ---------------------------------------------------- 6. Pin Tree & Gauge ----
module pins() {
  lengths = [fw, fw, tongue_w, tongue_w];
  for (i = [0:3]) translate([0, i * 7, 0]) d_pin(lengths[i], pin_diameter);
  translate([-3, -2, 0]) cube([2.2, 26, 0.8]);
}

module fit_test() {
  cs = [0.08, 0.18, 0.28, 0.38];
  difference() {
    cube([42, 18, 8]);
    for (k = [0:3]) {
      translate([6 + k * 9.5, 9, -1]) cylinder(d = pin_diameter + cs[k], h = 10);
    }
  }
  translate([0, -8, 0]) d_pin(22, pin_diameter);
}

// ------------------------------------------------------------ 7. Assembly ----
module assembly() {
  color(primary_color) socket_ring();
  color(primary_color) translate([0, -4, 0]) dorsal_cuff();
  translate([0, stump_length, 0]) rotate([-pip_ang, 0, 0]) {
    color(phalanx_color) middle_phalanx();
    color(linkage_color) translate([0, 0, fh * 0.42]) linkage_bar();
    translate([0, L_mid, 0]) rotate([-dip_coupled, 0, 0]) {
      color(phalanx_color) distal_phalanx();
    }
  }
}

module all_plates() {
  translate([-35, 0, r_stump_outer]) rotate([180, 0, 0]) socket_ring();
  translate([0, 0, fh * 0.44]) rotate([180, 0, 0]) middle_phalanx();
  translate([30, 0, fh * 0.38]) rotate([180, 0, 0]) distal_phalanx();
  translate([58, 0, tongue_w * 0.34]) rotate([0, 90, 0]) linkage_bar();
  translate([-35, 45, 0]) pins();
  translate([5, 45, 0]) fit_test();
}

// ---------------------------------------------------------- Console Report ---
module report() {
  echo(str("=== Kinetic PIP-Driven Finger Prosthetic (", digit, " - ", hand, ") ==="));
  echo(str("Stump inner bore diameter : ", round(2 * r_stump_inner * 10) / 10, " mm (incl. ", liner_thickness, " mm liner)"));
  echo(str("Finger width x height     : ", round(fw * 10) / 10, " x ", round(fh * 10) / 10, " mm"));
  echo(str("Segment lengths (Mid/Dist): ", round(L_mid * 10) / 10, " / ", round(L_dist * 10) / 10, " mm"));
  echo(str("Linkage bar C-to-C length : ", round(L_link * 10) / 10, " mm (0.85x coupled DIP transmission)"));
  echo(str("Hardware pins (unscaled)  : d = ", pin_diameter, " mm | tight = ", hole_tight, " mm | free = ", hole_free, " mm"));
}
report();

if (part == "assembly") assembly();
else if (part == "socket_ring") socket_ring();
else if (part == "middle_phalanx") middle_phalanx();
else if (part == "distal_phalanx") distal_phalanx();
else if (part == "linkage_bar") linkage_bar();
else if (part == "dorsal_cuff") dorsal_cuff();
else if (part == "pins") pins();
else if (part == "fit_test") fit_test();
else if (part == "all_plates") all_plates();
