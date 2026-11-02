// =============================================================================
//  Modular Transtibial (Below-Knee) & ESAR Foot Prosthetic — OpenSCAD Model
// =============================================================================
//  A parametric, 3D-printable lower-limb prosthetic architecture designed for
//  educational geometry exploration; not validated for fitting or ambulation. Combines:
//   1. Patellar-Tendon-Bearing (PTB) anatomical check socket with patellar bar
//      indentation, fibular head relief, and posterior popliteal flare.
//   2. Breathable TPU 95A snap-in comfort liner shell.
//   3. Unscaled ISO-compatible 4-bolt distal adapter & 30 mm pylon clamp.
//   4. Split-Toe Energy-Storage-and-Return (ESAR) dual-spring keel foot blade
//      with multi-axial uneven-terrain compliance and slip-on TPU tread shell.
//
//  DESIGN PRINCIPLES:
//   * Structural hardware never scales: 30 mm pylon bore, M6 clamping bolts,
//     and 4-hole pyramid mount pattern remain at standard clinical dimensions.
//   * Split-toe keel geometry provides passive inversion/eversion on uneven
//     ground without heavy mechanical ankle joints.
//
//  SAFETY: Experimental educational geometry only. No load rating, structural
//  validation, fatigue testing, or clinical fitting evidence is included.
//  Do not use these models for weight-bearing activity.
// =============================================================================

/* [Part to render] */
part = "assembly"; // [assembly, ptb_socket, socket_liner_tpu, pylon_adapter, esar_foot_keel, foot_shell_tpu, fit_test, all_plates]
side = "right";    // [right, left]

/* [Sizing (Recipient Measurements in mm)] */
// Circumference at patellar tendon / proximal tibia (mm)
proximal_stump_circ = 310;
// Circumference near distal end of residual limb (mm)
distal_stump_circ = 245;
// Residual limb length from patellar tendon bar to distal tip (mm)
stump_length = 155;
// Floor to patellar tendon bar height on sound leg (mm)
knee_to_floor_height = 460;
// Prosthetic foot length (mm)
foot_length = 250;
// Prosthetic foot forefoot width (mm)
foot_width = 88;
// Design mass input for an unvalidated thickness heuristic (kg); not a rating
body_mass_kg = 68;

/* [Structural & Hardware Parameters (Never Scaled)] */
// Standard prosthetic pylon outer diameter (mm) — clinical standard 30.0 mm
pylon_diameter = 30.0;
// Pylon receiver radial clearance (mm)
pylon_clearance = 0.25;
// Structural socket wall thickness (mm)
socket_wall = 5.5;
// Flexible TPU inner liner thickness (mm)
liner_thickness = 4.0;
// M6 bolt clearance hole diameter (mm)
m6_hole = 6.4;
// 4-hole distal adapter bolt circle diameter (mm)
adapter_bcd = 50.8;
// Sagittal split slot width in ESAR forefoot keel (mm)
keel_split_gap = 3.0;

/* [Assembly Preview] */
show_liner = true;
show_foot_shell = true;
socket_color  = "#2f6fdb";
liner_color   = "#d9d4c7";
adapter_color = "#ffb703";
pylon_color   = "#6c757d";
keel_color    = "#2b2b2b";
shell_color   = "#e0afa0";

/* [Hidden] */
$fa = $preview ? 8 : 4;
$fs = $preview ? 1.0 : 0.4;
EPS = 0.01;
FONT = "Liberation Sans:style=Bold";

// --------------------------------------------------- Derived Biomechanics ----
r_prox_in  = (proximal_stump_circ / (2 * PI)) + liner_thickness;
r_dist_in  = (distal_stump_circ / (2 * PI)) + liner_thickness;
r_prox_out = r_prox_in + socket_wall;
r_dist_out = r_dist_in + socket_wall;

// Unvalidated thickness heuristic (8.0 mm at 65 kg input); not a strength calculation
keel_t     = max(6.5, min(13.0, 8.0 * pow(body_mass_kg / 65.0, 0.38)));
foot_h     = 68;
adapter_h  = 42;
pylon_len  = max(60, knee_to_floor_height - stump_length - foot_h - adapter_h);

// -------------------------------------------------------- 1. PTB Check Socket -
module ptb_socket() {
  difference() {
    union() {
      // Anatomically tapered outer shell (elliptical cross-section: AP > ML)
      hull() {
        translate([0, 0, stump_length]) scale([0.92, 1.08, 1])
          cylinder(r = r_prox_out, h = 18);
        translate([0, 0, 14]) scale([0.95, 1.04, 1])
          cylinder(r = r_dist_out, h = 10);
        // Flat distal mounting boss for 4-bolt pyramid adapter
        cylinder(r = adapter_bcd * 0.72, h = 14);
      }
      // Medial/Lateral supracondylar suspension flares
      for (sx = [-1, 1])
        translate([sx * (r_prox_out * 0.86), 0, stump_length + 14])
          scale([0.35, 0.75, 0.65]) sphere(r = 28);
    }
    // Inner anatomical cavity (leaves 14 mm solid distal end-pad boss)
    hull() {
      translate([0, 0, stump_length + 1]) scale([0.92, 1.08, 1])
        cylinder(r = r_prox_in, h = 22);
      translate([0, 0, 20]) scale([0.95, 1.04, 1])
        cylinder(r = r_dist_in, h = 6);
    }
    translate([0, 0, 20]) scale([0.95, 1.04, 1])
      sphere(r = r_dist_in);
    // Patellar tendon bearing (PTB) anterior shelf indentation (+Y is anterior)
    translate([0, r_prox_out + 10, stump_length - 12])
      rotate([0, 90, 0]) cylinder(r = 18, h = r_prox_out * 1.4, center = true);
    // Posterior popliteal hamstring relief cutout (-Y is posterior)
    translate([0, -r_prox_out * 0.75, stump_length + 8])
      rotate([28, 0, 0]) cylinder(r = r_prox_out * 0.88, h = 40, center = true);
    // Distal 4-bolt ISO mounting pattern & central distal air-expulsion valve hole
    cylinder(d = 10.0, h = 30, center = true);
    for (a = [45, 135, 225, 315])
      translate([adapter_bcd / 2 * cos(a), adapter_bcd / 2 * sin(a), -1])
        cylinder(d = m6_hole, h = 22);
  }
}

// ------------------------------------------------ 2. Breathable TPU Liner ----
module socket_liner_tpu() {
  r_p_limb = r_prox_in - 0.3;
  r_d_limb = r_dist_in - 0.3;
  difference() {
    hull() {
      translate([0, 0, stump_length]) scale([0.92, 1.08, 1])
        cylinder(r = r_p_limb, h = 16);
      translate([0, 0, 22]) scale([0.95, 1.04, 1])
        cylinder(r = r_d_limb, h = 6);
    }
    hull() {
      translate([0, 0, stump_length + 2]) scale([0.92, 1.08, 1])
        cylinder(r = r_p_limb - liner_thickness, h = 18);
      translate([0, 0, 22 + liner_thickness]) scale([0.95, 1.04, 1])
        cylinder(r = r_d_limb - liner_thickness, h = 6);
    }
    // Spiral ventilation pores for moisture management
    for (iz = [0:4], ia = [0:7]) {
      ang = ia * 45 + (iz % 2) * 22.5;
      zz  = 42 + iz * 22;
      rotate([0, 0, ang]) translate([0, r_p_limb + 5, zz])
        rotate([90, 0, 0]) cylinder(d = 5.0, h = 25, $fn = 6);
    }
  }
}

// ----------------------------------------- 3. Modular 30mm Pylon Clamp ----
module pylon_adapter() {
  r_flange = adapter_bcd * 0.72;
  r_clamp  = pylon_diameter / 2 + 6.5;
  difference() {
    union() {
      cylinder(r = r_flange, h = 8);
      cylinder(r1 = r_flange * 0.75, r2 = r_clamp, h = adapter_h);
      // Pinch-bolt clamping ears
      translate([0, r_clamp + 4, adapter_h / 2 + 4])
        cube([18, 14, adapter_h - 8], center = true);
    }
    // 30 mm standard pylon socket bore
    translate([0, 0, 8])
      cylinder(d = pylon_diameter + 2 * pylon_clearance, h = adapter_h + 2);
    // Clamping split slot
    translate([-1.2, 0, 8])
      cube([2.4, r_clamp + 16, adapter_h + 2]);
    // Dual M6 pinch bolt bores
    for (zz = [adapter_h * 0.42, adapter_h * 0.78])
      translate([0, r_clamp + 5, zz]) rotate([0, 90, 0])
        cylinder(d = m6_hole, h = 26, center = true);
    // 4-bolt flange holes matching PTB socket base
    for (a = [45, 135, 225, 315])
      translate([adapter_bcd / 2 * cos(a), adapter_bcd / 2 * sin(a), -1])
        cylinder(d = m6_hole, h = 12);
  }
}

// ------------------------------------ 4. Split-Toe ESAR Energy-Return Keel ---
module esar_foot_keel() {
  y_heel = -foot_length * 0.28;
  y_toe  =  foot_length * 0.72;
  w_ank  =  foot_width * 0.72;
  difference() {
    union() {
      // Proximal ankle block (mates to lower pylon clamp)
      translate([0, 0, foot_h - 14])
        cylinder(r = adapter_bcd * 0.68, h = 14);
      // Upper C-spring main energy-storage arch (anterior sweep to toe)
      hull() {
        translate([-w_ank / 2, -18, foot_h - 14])
          cube([w_ank, 36, keel_t]);
        translate([-foot_width * 0.44, y_toe * 0.35, foot_h * 0.42])
          cube([foot_width * 0.88, 24, keel_t]);
      }
      hull() {
        translate([-foot_width * 0.44, y_toe * 0.35, foot_h * 0.42])
          cube([foot_width * 0.88, 24, keel_t]);
        translate([-foot_width * 0.46, y_toe - 18, 6])
          cube([foot_width * 0.92, 18, keel_t * 0.82]);
      }
      // Posterior heel shock-absorption leaf spring
      hull() {
        translate([-w_ank / 2, -16, foot_h * 0.48])
          cube([w_ank, 22, keel_t * 0.9]);
        translate([-w_ank * 0.45, y_heel, 6])
          cube([w_ank * 0.9, 18, keel_t * 0.78]);
      }
      // Vertical shear web joining ankle block to heel spring
      translate([-w_ank / 2, -16, foot_h * 0.48])
        cube([w_ank, 28, foot_h * 0.52 - 10]);
    }
    // Sagittal split slot for multiaxial inversion/eversion ground compliance
    translate([-keel_split_gap / 2, y_toe * 0.15, -2])
      cube([keel_split_gap, y_toe, foot_h]);
    // 4-bolt ankle mount pattern
    for (a = [45, 135, 225, 315])
      translate([adapter_bcd / 2 * cos(a), adapter_bcd / 2 * sin(a), foot_h - 16])
        cylinder(d = m6_hole, h = 20);
  }
}

// ----------------------------------------- 5. Slip-On TPU Cosmesis Shell -----
module foot_shell_tpu() {
  y_heel = -foot_length * 0.30;
  y_toe  =  foot_length * 0.74;
  difference() {
    hull() {
      translate([0, y_heel + 24, 14]) scale([foot_width * 0.38, 26, 14]) sphere(1);
      translate([0, 0, 26]) scale([foot_width * 0.46, 36, 26]) sphere(1);
      translate([0, y_toe - 28, 10]) scale([foot_width * 0.50, 32, 10]) sphere(1);
    }
    // Internal cavity for ESAR keel insertion
    translate([0, 0, 4]) scale([0.88, 0.92, 0.95])
      hull() {
        translate([0, y_heel + 24, 14]) scale([foot_width * 0.38, 26, 14]) sphere(1);
        translate([0, 0, 26]) scale([foot_width * 0.46, 36, 26]) sphere(1);
        translate([0, y_toe - 28, 10]) scale([foot_width * 0.50, 32, 10]) sphere(1);
      }
    // Flatten plantar sole at z = 0
    translate([-100, -150, -30]) cube([200, 400, 30]);
    // Anti-slip plantar tread grooves
    for (yy = [y_heel + 15 : 18 : y_toe - 15])
      translate([0, yy, 0]) rotate([0, 90, 0])
        cylinder(r = 1.8, h = foot_width + 20, center = true, $fn = 12);
  }
}

// ------------------------------------------------ 6. Fit Test & Assembly -----
module fit_test() {
  difference() {
    cylinder(d = pylon_diameter + 12, h = 18);
    translate([0, 0, -1]) cylinder(d = pylon_diameter + 2 * pylon_clearance, h = 20);
    translate([-1, 0, -1]) cube([2, pylon_diameter, 20]);
  }
}

module assembly() {
  // Foot shell & ESAR keel at ground level
  if (show_foot_shell) color(shell_color, 0.65) foot_shell_tpu();
  color(keel_color) esar_foot_keel();
  // Distal ankle pylon clamp
  color(adapter_color) translate([0, 0, foot_h]) pylon_adapter();
  // 30 mm structural pylon tube
  color(pylon_color) translate([0, 0, foot_h + 8])
    difference() {
      cylinder(d = pylon_diameter, h = pylon_len + adapter_h - 16);
      translate([0, 0, -1]) cylinder(d = pylon_diameter - 4, h = pylon_len + adapter_h);
    }
  // Proximal socket pylon clamp (inverted)
  color(adapter_color) translate([0, 0, foot_h + adapter_h + pylon_len])
    rotate([180, 0, 0]) pylon_adapter();
  // PTB Socket and TPU Liner
  z_sock = foot_h + adapter_h + pylon_len;
  color(socket_color) translate([0, 0, z_sock]) ptb_socket();
  if (show_liner) color(liner_color) translate([0, 0, z_sock]) socket_liner_tpu();
}

module all_plates() {
  translate([-110, 0, 0]) ptb_socket();
  translate([20, 0, 0]) esar_foot_keel();
  translate([135, -40, 0]) pylon_adapter();
  translate([135, 40, 0]) fit_test();
}

module report() {
  echo(str("=== Modular Transtibial & ESAR Foot Prosthetic (", side, ") ==="));
  echo(str("PTB Socket inner dia (P/D): ", round(2 * (r_prox_in - liner_thickness)), " / ", round(2 * (r_dist_in - liner_thickness)), " mm"));
  echo(str("30 mm Pylon cut length    : ", round(pylon_len), " mm (for ", knee_to_floor_height, " mm knee-to-floor height)"));
  echo(str("ESAR Foot L x W x Keel T  : ", foot_length, " x ", foot_width, " x ", round(keel_t * 10) / 10, " mm (", body_mass_kg, " kg design input; NOT a load rating)"));
}
report();

if (part == "assembly") assembly();
else if (part == "ptb_socket") ptb_socket();
else if (part == "socket_liner_tpu") socket_liner_tpu();
else if (part == "pylon_adapter") pylon_adapter();
else if (part == "esar_foot_keel") esar_foot_keel();
else if (part == "foot_shell_tpu") foot_shell_tpu();
else if (part == "fit_test") fit_test();
else if (part == "all_plates") all_plates();
