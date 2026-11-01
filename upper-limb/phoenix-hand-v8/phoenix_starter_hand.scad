// =============================================================================
//  Phoenix-style Starter Hand — a parametric OpenSCAD base model
// =============================================================================
//  A wrist-powered, 3D-printable assistive hand built from scratch around the
//  architecture of the e-NABLE Phoenix family (Phoenix v2 / v3, Unlimbited
//  Phoenix): a palm shell with pinned knuckles, two-segment fingers driven by
//  palmar tendons and returned by dorsal elastic, a flat-printed thermoformed
//  gauntlet, and a tensioner block for the tendons.
//
//  No Phoenix geometry is copied; every surface here is generated from the
//  parameters below, so the model is a clean starting point to remix.
//
//  WHAT MAKES IT DIFFERENT FROM SCALING AN STL
//   * Hardware never scales. Pins, tendon/elastic channels, strap slots, the
//     wrist snap and wall thicknesses stay at real-world sizes at any scale,
//     the same principle the Unlimbited Arm's OpenSCAD files use.
//   * Labelled parts. Every phalanx carries a debossed letter (I, M, R, L, T)
//     and pins come on a labelled tree, which addresses the pin mix-ups that
//     prompted Phoenix v3's labelled pins.
//   * Wrist pins snap in. Split, barbed pins lock into a pocket inside the
//     palm, which addresses the "wrist pins popped off" field report.
//   * Exact thermoform development. The gauntlet is defined on its formed
//     cross-section and unrolled by arc length, so slots and tabs land where
//     they should after forming.
//   * Built-in mechanics check. The echo report estimates tendon excursion
//     against wrist flexion and tells you how far the wrist must bend to close
//     the hand.
//   * Fit-test coupon. Print it first to choose pin clearances for your
//     printer.
//
//  HOW TO USE
//   1. Measure the recipient (see the e-NABLE "Device Sizing" wiki page) and
//      set hand_width, or force scale_override to a percentage you trust.
//   2. Print part = "fit_test"; adjust pin_fit_tight / pin_fit_free.
//   3. Render (F6) and export each part: palm, palm_base, fingers, pins,
//      gauntlet_flat, forming_jig. Check the console report for sizes and warnings.
//   4. Thermoform the gauntlet on the jig, assemble, string, tension.
//
//  SAFETY: an experimental, unreviewed design, not FDA-cleared. Fit and test
//  it with the recipient, ideally with a clinician involved.
//  Tested with OpenSCAD 2021.01.
// =============================================================================

/* [Part to render] */
part = "assembly"; // [assembly, palm, palm_base, fingers, pins, gauntlet_flat, gauntlet_formed, forming_jig, fit_test, all_plates]
hand = "right";    // [right, left]

/* [Sizing] */
// Width across the palm of the hand being fitted (mm)
hand_width = 66;
// Wrist crease to middle fingertip on the recipient's other hand (mm, 0 = proportional)
hand_length = 0;
// Back-of-hand to palm thickness across the knuckles (mm, 0 = estimate from hand_width)
knuckle_thickness = 0;
// Force a scale in percent (0 = compute from hand_width)
scale_override = 0;
// Foam padding thickness inside palm and gauntlet (mm)
foam_thickness = 3;
// Forearm thickness just behind the wrist (mm, 0 = estimate)
forearm_thickness = 0;

/* [Fit & hardware (never scaled)] */
// Clearance between moving printed parts (mm)
joint_clearance = 0.4;
// Printed pin diameter (mm)
pin_diameter = 3.0;
// Extra hole size where a pin must stay put (mm)
pin_fit_tight = 0.10;
// Extra hole size where a part rotates on a pin (mm)
pin_fit_free = 0.35;
// Wrist pin diameter (mm)
wrist_pin_diameter = 5.0;
// Palm shell wall (mm)
wall = 2.8;
// Gauntlet sheet thickness before forming (mm)
gauntlet_thickness = 3.0;
// Velcro strap width (mm) — 1" straps per the e-NABLE hardware list
strap_width = 25.4;

/* [Assembly preview] */
// Wrist flexion in degrees (+ bends the hand down and closes the grip)
wrist_angle = 25; // [-30:1:50]
// Animate the wrist with $t (View > Animate in OpenSCAD)
animate = false;
// Drive finger curl from the tendon model instead of manual_curl
auto_curl = true;
manual_curl = 0.0; // [0:0.05:1]
show_tendons = true;
// Show the non-printed parts: straps, foam, fingertip grips, tendons, elastic
show_hardware = true;
palm_color     = "#2f6fdb";
finger_color   = "#f4f4f2";
gauntlet_color = "#2f6fdb";
accent_color   = "#ffb703";
hardware_color = "#2b2b2b";
foam_color     = "#d9d4c7";

/* [Hidden] */
$fa = $preview ? 8 : 4;
$fs = $preview ? 0.9 : 0.35;
EPS = 0.01;
FONT = "Liberation Sans:style=Bold";

// ---------------------------------------------------------------- scale ----
BASE_INNER_W = 56;   // palm interior width at 100 %
S = scale_override > 0 ? scale_override / 100
                       : (hand_width + 2 * foam_thickness + 1) / BASE_INNER_W;
cl = joint_clearance;

// --------------------------------------------------------- pins & holes ----
pin_flat   = 0.35;                         // D-flat depth on lying pins
hole_tight = pin_diameter + pin_fit_tight;
hole_free  = pin_diameter + pin_fit_free;
ch_r       = 0.9;                          // tendon / elastic channel radius
wd         = wrist_pin_diameter;

// ----------------------------------------------------------------- palm ----
W_i = BASE_INNER_W * S;   W_o = W_i + 2 * wall;
H_i = 24 * S;             H_o = H_i + wall;
ZC  = 0.45 * H_i;                          // where the dorsal dome begins
a_o = W_o / 2;  b_o = H_o - ZC;
a_i = W_i / 2;  b_i = H_i - ZC;
function z_top(x) = ZC + b_o * sqrt(max(0, 1 - pow(x / a_o, 2)));

// -------------------------------------------------------------- fingers ----
ph  = 12 * S;   dh = 10.5 * S;   tip_h = 8 * S;   // segment heights
r_t = ph / 2;                                  // knuckle tongue radius
lt  = max(3.0, 2.6 * S);                       // palm lug thickness
fw  = (W_o - 5 * lt) / 4 - cl;                 // finger width
ct  = max(2.4, 0.21 * fw);                     // fork cheek thickness
tw  = fw - 2 * ct - cl;                        // distal tongue width
eo  = min(2.4, 0.22 * fw);                     // tendon/elastic split in palm
ma_p = max(0.31 * ph, hole_free / 2 + ch_r + 0.8);   // tendon moment arms
ma_d = max(0.31 * dh, hole_free / 2 + ch_r + 0.8);
// The hand fits under a slim knuckle bar: the cavity runs forward to the knuckles
// at this height, and the finger pivots sit just above, near the top of the palm.
KT    = knuckle_thickness > 0 ? knuckle_thickness : 0.33 * (W_i - 2 * foam_thickness - 1);   // ~1/3 of hand width
FOAM_UNDER_BAR = 4.1;                          // bar liner + base pad (see HARDWARE)
z_bar = min(H_i - 1, KT + FOAM_UNDER_BAR + 0.4);   // knuckle clearance under the bar
kz  = z_bar + ma_p + 2.5;                      // knuckle axis height
z_bt = kz + dh / 2 + 1.0;                      // top of the knuckle bar
lug_r = max(hole_tight / 2 + 2.4, 0.75 * r_t);

KY   = [0, 3, 0, -4] * S;                      // knuckle stagger I M R L
FNAME = ["I", "M", "R", "L"];

function x_slot(i) = -a_o + lt + (fw + cl) / 2 + i * (fw + cl + lt);
function x_lug(j)  = -a_o + lt / 2 + j * (fw + cl + lt);
function y_face(i) = KY[i] - r_t - cl;         // palm face behind finger i
function y_T(i)    = y_face(i) - 18 * S;       // tendon reaches the dorsal rib
function x_t(i)    = x_slot(i) - eo;           // tendon rib x
function x_e(i)    = x_slot(i) + eo;           // elastic anchor x
function zT(i)     = z_top(x_t(i)) + 1.0;
function zA(i)     = kz + ma_p;                // elastic runs level through the bar
function lug_nb(j) = [for (i = [j - 1, j]) if (i >= 0 && i <= 3) i];

y_face_max  = max([for (i = [0:3]) y_face(i)]);
y_cav_front = min([for (i = [0:3]) y_T(i)]) + 2 * S;   // full-height cavity ends here
y_bb    = min([for (i = [0:3]) y_face(i)]) - 12 * S;      // back of the knuckle bar
wall_f  = wall;                                           // front wall under the bar
y_kr    = min([for (i = [0:3]) y_face(i)]) - wall_f;      // front of the common knuckle region
L_cav  = 50 * S;
y_rear = y_cav_front - L_cav;
yp     = y_rear + 9 * S;                       // wrist pivot
// Finger length factor: match the wrist-to-fingertip length of the other hand.
PALM_TO_KNUCKLE = KY[1] - yp;
FL = hand_length > 0 ? max(0.7, min(1.4, (hand_length - PALM_TO_KNUCKLE) / (49 * S))) : 1;
PL   = [22, 25, 23, 18] * S * FL;              // proximal pivot-to-pivot
DL   = [22, 24, 22, 18] * S * FL;              // distal pivot-to-tip
zp     = 0.5 * H_i;
BR_H   = 5 * S;                               // rear tendon bridge lift
boss_r = 6.5 + 0.5 * S;
boss_h = 1.4;
gap_w  = 2.0;                                  // palm side to gauntlet tab
pocket = 1.6;                                  // snap pocket depth
// palm base slots: the rear one starts ahead of the wrist pivot (see PALM BASE)
PALM_SLOT_Y0 = yp + 0.45 * max(13, 11 * S);
BASE_SLOTS = [[PALM_SLOT_Y0, PALM_SLOT_Y0 + 18], [y_cav_front - 6 - 18, y_cav_front - 6]];
BS_Z0 = 1.5;  BS_Z1 = 4.9;                     // slot height in the wall

// ---------------------------------------------------------------- thumb ----
fwt   = fw * 1.12;
pht   = ph * 1.05;   dht = dh * 1.05;   tipt = tip_h * 1.05;
r_tt  = pht / 2;
ctt   = max(2.4, 0.21 * fwt);
twt   = fwt - 2 * ctt - cl;
ma_tp = max(0.31 * pht, hole_free / 2 + ch_r + 0.8);
ma_td = max(0.31 * dht, hole_free / 2 + ch_r + 0.8);
TPL   = 18 * S * FL;   TDL = 19 * S * FL;
tb_len = 5.5 * S;                              // thumb mount block depth
// Thumb pose, found by a collision-aware search for a lateral key pinch: the
// thumb pad meets the side of the index fingertip at about 75 % closure
// without crossing any finger's path, and the mount stays above the bed.
TH_DX    = 5.3 * S;                            // pivot offset out from the palm side
TH_P     = [-(a_o + 0.87 * r_tt + 2.2 + TH_DX), y_cav_front + 15.7 * S, kz - 3.2 * S];
TH_YAW   = 27;
TH_PITCH = -58;
TH_ROLL  = -77;
TH_CK    = 40;                                 // thumb joint angles at full closure
TH_CD    = 15;

function Rx(a) = [[1, 0, 0], [0, cos(a), -sin(a)], [0, sin(a), cos(a)]];
function Ry(a) = [[cos(a), 0, sin(a)], [0, 1, 0], [-sin(a), 0, cos(a)]];
function Rz(a) = [[cos(a), -sin(a), 0], [sin(a), cos(a), 0], [0, 0, 1]];
function thumb_vec(v) = Rz(TH_YAW) * (Rx(TH_PITCH) * (Ry(TH_ROLL) * v));
function thumb_pt(p)  = TH_P + thumb_vec(p);
module thumb_frame() translate(TH_P) rotate([0, 0, TH_YAW]) rotate([TH_PITCH, 0, 0]) rotate([0, TH_ROLL, 0]) children();

// ------------------------------------------------------------- gauntlet ----
gt     = gauntlet_thickness;
tab_w  = max(13, 11 * S);
x_side = a_o + gap_w + gt / 2;                 // mid-surface of the side walls
fa_half = forearm_thickness > 0 ? forearm_thickness / 2 + foam_thickness : H_i / 2;
h_up   = fa_half + gt / 2;                     // axis to mid-surface of top
zt     = zp + h_up;
blk_pitch = 7;  blk_w = 4 * blk_pitch + 9;  blk_len = 20;  blk_h = 12;  blk_ch = 6;
wc     = min(blk_w + 4, 2 * (x_side - 4));     // flat strip under the block
A_e    = x_side - wc / 2;                      // corner ellipse semi-axes
B_e    = max(2, h_up - tab_w / 2);
z_bot  = zp - tab_w / 2 - 6;
r_max  = sqrt(pow(yp - y_rear, 2) + pow(H_o + BR_H + 3.5 - zp, 2));
y_bf   = yp - (r_max + 2);                     // band front clears the palm
Lg     = 105 * S;
y_g_rear = y_bf - Lg;
Ls     = strap_width + 1.5;                    // strap slot length

// formed cross-section, right half, from the top centre outwards
PR = concat(
  [for (k = [0:4]) [k / 4 * wc / 2, zt]],
  [for (k = [1:24]) let(t = 90 * k / 24) [wc / 2 + A_e * sin(t), zt - B_e + B_e * cos(t)]],
  [for (k = [1:6]) [x_side, (zt - B_e) - (zt - B_e - z_bot) * k / 6]]);
PF = concat([for (k = [len(PR) - 1:-1:1]) [-PR[k][0], PR[k][1]]], PR);
NPF = len(PF);
CI  = len(PR) - 1;
SEGL = [for (k = [0:NPF - 2]) norm(PF[k + 1] - PF[k])];
function sum_to(v, n) = n <= 0 ? 0 : v[n - 1] + sum_to(v, n - 1);
SLR = [for (k = [0:NPF - 1]) sum_to(SEGL, k)];
SL  = [for (v = SLR) v - SLR[CI]];            // arc length, 0 at the top centre
s_end    = SL[NPF - 1];
s_vstart = SL[CI + 28];
s_p      = s_vstart + (zt - B_e - zp);         // arc length of the pivot

function seg_idx(s, k = 0) = (k >= NPF - 2 || SL[k + 1] >= s) ? k : seg_idx(s, k + 1);
function pt_s(s) = let(k = seg_idx(s), u = (s - SL[k]) / (SL[k + 1] - SL[k])) PF[k] + (PF[k + 1] - PF[k]) * u;
function nrm2(t) = [-t[1], t[0]] / norm(t);
function nrm_seg(k) = nrm2(PF[k + 1] - PF[k]);
function nrm_pt(k)  = nrm2(PF[min(k + 1, NPF - 1)] - PF[max(k - 1, 0)]);
function prof_samples(s1, s2) = concat(
  [[pt_s(s1), nrm_seg(seg_idx(s1))]],
  [for (k = [0:NPF - 1]) if (SL[k] > s1 + 0.05 && SL[k] < s2 - 0.05) [PF[k], nrm_pt(k)]],
  [[pt_s(s2), nrm_seg(seg_idx(s2))]]);

// ------------------------------------------------------------- mechanics ----
function rotw(p, phi) = let(y = p[1] - yp, z = p[2] - zp)
  [p[0], yp + y * cos(phi) + z * sin(phi), zp - y * sin(phi) + z * cos(phi)];
blk_z0 = zt + gt / 2;
function tens_x(k) = (k - 2) * blk_pitch;
function tens_y(k) = y_bf - 1.5 - (k % 2 == 0 ? 6 : 14.5);
function tens_entry(k) = [tens_x(k), y_bf - 1.5, blk_z0 + blk_ch];
function finger_exit(i) = [x_t(i), y_rear, zT(i) + BR_H];
TH_RIB_X = -(a_o - 2.6 * S);
function thumb_exit() = [TH_RIB_X, y_rear, z_top(TH_RIB_X) + 1.0 + BR_H];
function tendon_exit(k) = k == 0 ? thumb_exit() : finger_exit(k - 1);
function excursion(k, phi) = norm(rotw(tendon_exit(k), phi) - tens_entry(k)) - norm(tendon_exit(k) - tens_entry(k));
// Joint angles for a full grip. The pivots sit on the knuckle bar, above the
// hand, so the fist wraps in front of and under the palm base; these keep every
// fingertip clear of the base and the hand at every scale (tests/check.scad).
CLOSE_K = 65;  CLOSE_D = 65;
need_mid = ma_p * CLOSE_K * PI / 180 + ma_d * CLOSE_D * PI / 180;
function close_angle(phi = 0) = phi > 70 ? 99 : excursion(2, phi) >= need_mid ? phi : close_angle(phi + 1);
function curl_at(phi) = max(0, min(1, excursion(2, phi) / need_mid));

// Key-pinch check. As the hand closes, find the first moment the thumb pad
// comes within 2.5 mm of the radial (thumb-side) face of the index finger, and
// how squarely it faces that face. A collision-aware search chose the thumb
// pose so the pad touches first; tests/check.scad confirms nothing else does.
function pad_local(h, L, th) = [0, L - 0.45 * th, h / 2 - th / 2 - 0.46 * th];
function finger_pad(i, c) = [x_slot(i), KY[i], kz] + Rx(-c * CLOSE_K) * ([0, PL[i], 0] + Rx(-c * CLOSE_D) * pad_local(dh, DL[i], tip_h));
function thumb_pad(c) = thumb_pt(Rx(-c * TH_CK) * ([0, TPL, 0] + Rx(-c * TH_CD) * pad_local(dht, TDL, tipt)));
function index_radial(c) = let(R1 = Rx(-c * CLOSE_K), R2 = R1 * Rx(-c * CLOSE_D),
                               P0 = [x_slot(0), KY[0], kz], P1 = P0 + R1 * [0, PL[0], 0])
  concat([for (u = [0.3:0.05:1.0], z = [-dh / 2, -dh / 4, 0, dh / 4, dh / 2]) P0 + R1 * [-fw / 2, u * PL[0], z]],
         [for (u = [0:0.05:0.9], z = [-dh / 2, -dh / 4, 0, dh / 4, dh / 2]) P1 + R2 * [-fw / 2, u * (DL[0] - 3), z]]);
// palmar surface height of a distal phalanx at distance y from its pivot (matches module distal)
function palmar_z(h, L, th, y) = let(r = h / 2, y0 = r + cl, ay = 0.75 * th, yc = L - ay, zc = r - th / 2)
  y <= yc ? -r + (zc - th / 2 + r) * max(0, y - y0) / (yc - y0)
          : zc - th / 2 * sqrt(max(0, 1 - pow((y - yc) / ay, 2)));
function thumb_pad_pts(c) = [for (u = [0.35:0.075:0.8], x = [-0.4 * fwt, 0, 0.4 * fwt])
  thumb_pt(Rx(-c * TH_CK) * ([0, TPL, 0] + Rx(-c * TH_CD) * [x, u * TDL, palmar_z(dht, TDL, tipt, u * TDL)]))];
function min_dist(A, B) = min([for (a = A, b = B) norm(a - b)]);
function first_contact(c = 0) = c > 1 ? 1.01 : min_dist(thumb_pad_pts(c), index_radial(c)) < 2.0 ? c : first_contact(c + 0.01);
function pad_facing(c) = thumb_vec(Rx(-c * (TH_CK + TH_CD)) * [0, 0, -1]) * [-1, 0, 0];
function wrist_for(curl, phi = -10) = phi > 70 ? 99 : curl_at(phi) >= curl ? phi : wrist_for(curl, phi + 1);
KEY = first_contact();
// The thumb closes freely until its pad meets the side of the index finger, then
// it holds there: it cannot pass through the finger. th_c() turns the hand's
// closure into the thumb's, so a full grip ends in the key pinch.
function thumb_stop(cf, ct = 0) = ct >= cf ? cf
  : min_dist(thumb_pad_pts(ct + 0.01), index_radial(cf)) < 2.0 ? ct : thumb_stop(cf, ct + 0.01);
function th_c(c) = c <= KEY - 0.04 ? c : thumb_stop(c);
TH_FIST = th_c(1);
OPEN_SPAN = norm(thumb_pad(0) - finger_pad(0, 0));

// ---------------------------------------------------------------- helpers ---
function bez(p0, p1, p2, p3, t) = pow(1 - t, 3) * p0 + 3 * pow(1 - t, 2) * t * p1 + 3 * (1 - t) * t * t * p2 + pow(t, 3) * p3;
function bez_pts(p0, p1, p2, p3, n = 10) = [for (i = [0:n]) bez(p0, p1, p2, p3, i / n)];

// A round tube swept along a polyline as one closed polyhedron. (A chain of hulled
// spheres leaves near-coincident facets where the links overlap, which some CAD
// importers split into loose surfaces.) Rings are carried along by parallel
// transport and widened at bends so the bore never narrows.
function tp_clean(P, i = 1, acc = undef) = let(a = is_undef(acc) ? [P[0]] : acc)
  i >= len(P) ? a : norm(P[i] - a[len(a) - 1]) < 0.02 ? tp_clean(P, i + 1, a) : tp_clean(P, i + 1, concat(a, [P[i]]));
function tp_dir(a, b) = (b - a) / norm(b - a);
function tp_tan(P, i) = i == 0 ? tp_dir(P[0], P[1]) : i == len(P) - 1 ? tp_dir(P[i - 1], P[i])
  : unit(tp_dir(P[i - 1], P[i]) + tp_dir(P[i], P[i + 1]));
function tp_scale(P, i) = i == 0 || i == len(P) - 1 ? 1 : 1 / max(0.5, tp_dir(P[i - 1], P[i]) * tp_tan(P, i));
function tp_frames(P, i = 0, acc = []) = i == len(P) ? acc : let(t = tp_tan(P, i),
    prev = i == 0 ? cross(t, abs(t[2]) < 0.9 ? [0, 0, 1] : [1, 0, 0]) : acc[i - 1])
  tp_frames(P, i + 1, concat(acc, [unit(prev - (prev * t) * t)]));
module tube_path(pts, r, fn = 12, round_ends = false) {
  P = tp_clean(pts);  N = tp_frames(P);  n = len(P);
  ring = [for (i = [0:n - 1], k = [0:fn - 1]) let(t = tp_tan(P, i), a = 360 * (k + 0.5) / fn)
    P[i] + r * tp_scale(P, i) * (cos(a) * N[i] + sin(a) * cross(t, N[i]))];
  polyhedron(ring, concat(
    [[for (k = [0:fn - 1]) k]],
    [for (i = [0:n - 2], k = [0:fn - 1]) [i * fn + k, (i + 1) * fn + k, (i + 1) * fn + (k + 1) % fn, i * fn + (k + 1) % fn]],
    [[for (k = [fn - 1:-1:0]) (n - 1) * fn + k]]), convexity = 4);
  if (round_ends) for (q = [P[0], P[n - 1]]) translate(q) sphere(r * 0.98, $fn = fn);
}
module tube(p, q, r, round_ends = false) tube_path([p, q], r, round_ends = round_ends);
// the finger channels and the cords keep the round-jointed chain: their short,
// tightly bent paths clear their neighbours with it in every pose
module chain_path(pts, r, fn = 12) for (i = [0:len(pts) - 2]) hull() {
  translate(pts[i]) sphere(r, $fn = fn);
  translate(pts[i + 1]) sphere(r, $fn = fn);
}

// Extrude a 2D (x, z) section along Y between y1 and y2.
// convexity keeps OpenSCAD's F5 preview from drawing holes in concave sections
module ext_y(y1, y2) translate([0, y2, 0]) rotate([90, 0, 0]) linear_extrude(y2 - y1, convexity = 8) children();

// Disc around the X axis with rounded rims.
module rdisc(r, w, er = 1.2) {
  e = min(er, w / 4, r / 3);
  rotate([0, 90, 0]) rotate_extrude() hull() {
    translate([0, -w / 2]) square([r - e, w]);
    translate([r - e, w / 2 - e]) circle(e);
    translate([r - e, -w / 2 + e]) circle(e);
  }
}

// Thin rounded rectangle in the XZ plane at y = 0.
module rslab(w, h, er = 1.2) rotate([-90, 0, 0]) linear_extrude(EPS) offset(r = er) square([w - 2 * er, h - 2 * er], center = true);

module label(txt, size) text(txt, size = size, font = FONT, halign = "center", valign = "center");

// Pin lying on the bed, axis +X, D-flats top and bottom.
module chamfered_rod(d, len, c = 0.4) rotate([0, 90, 0]) rotate_extrude()
  polygon([[0, 0], [d / 2 - c, 0], [d / 2, c], [d / 2, len - c], [d / 2 - c, len], [0, len]]);
module dpin(len, d) {
  h = d - 2 * pin_flat;
  translate([0, 0, h / 2]) intersection() {
    chamfered_rod(d, len);
    translate([-1, -d, -h / 2]) cube([len + 2, 2 * d, h]);
  }
}

// ================================================================= PALM ====
module palm_section(a, b, zlow) intersection() {
  union() {
    translate([-a, zlow]) square([2 * a, ZC - zlow]);
    translate([0, ZC]) scale([a, b]) circle(1, $fn = 72);
  }
  translate([-a - 1, zlow]) square([2 * a + 2, 200]);
}

module body_front_mask() {
  yfj = [for (j = [0:4]) max([for (i = lug_nb(j)) y_face(i)])];
  translate([0, 0, -10]) linear_extrude(H_o + 40) polygon(concat(
    [[-a_o - 5, y_rear - 5], [a_o + 5, y_rear - 5], [a_o + 5, yfj[4]]],
    [for (j = [4:-1:0]) [x_lug(j), yfj[j]]],
    [[-a_o - 5, yfj[0]]]));
}

FC_CH = 2.5;                                   // front corner chamfer
module knuckle_lugs() for (j = [0:4]) {
  nb = lug_nb(j);
  hull() {
    for (i = nb) translate([x_lug(j), KY[i], kz]) rotate([0, 90, 0]) cylinder(r = lug_r, h = lt, center = true);
    // root in the bar and front wall (never behind them, where the hand is)
    translate([x_lug(j) - lt / 2, min([for (i = nb) y_face(i)]) - wall_f + 0.3, 0.35 * z_bar]) cube([lt, EPS, kz - 0.35 * z_bar]);
  }
}

// knuckle bar: a rounded beam across the top of the palm front, ramping into the dome
// chamfered, not rounded: a few clean facets keep mesh exports watertight in CAD importers
module bar_section() let(c = 4) polygon([[-a_o, z_bar], [a_o, z_bar], [a_o, z_bt - c], [a_o - c, z_bt], [-(a_o - c), z_bt], [-a_o, z_bt - c]]);
module knuckle_bar() hull() {
  ext_y(y_bb, y_face_max) bar_section();
  ext_y(y_bb - 8 * S - EPS, y_bb - 8 * S) palm_section(a_o, b_o, 0);
}

// last stretch of every tendon: climb onto the rear bridge, then exit
function ramp_tail(x, z) = concat(
  bez_pts([x, y_rear + 18 * S, z], [x, y_rear + 13 * S, z], [x, y_rear + 13 * S, z + BR_H], [x, y_rear + 8 * S, z + BR_H], 8),
  [[x, y_rear - 3, z + BR_H]]);

// tendon: in under the pivot, a gentle climb through the bar, then along a dorsal rib
function tendon_path(i) = concat(
  bez_pts([x_slot(i), y_face(i) + 1, kz - ma_p],
          [x_slot(i) - eo * 0.3, y_face(i) - 6 * S, kz - ma_p],
          [x_t(i), y_T(i) + 7 * S, zT(i)],
          [x_t(i), y_T(i), zT(i)], 12),
  ramp_tail(x_t(i), zT(i)));

// elastic: level through the bar to a knot pocket just behind it
y_A = y_bb + 1;
function elastic_path(i) = concat(
  bez_pts([x_slot(i), y_face(i) + 1, kz + ma_p],
          [x_slot(i) + eo * 0.3, y_face(i) - 3, kz + ma_p],
          [x_e(i), y_A + 3, zA(i)],
          [x_e(i), y_A, zA(i)], 8),
  [[x_e(i), y_A - 1, zA(i)]]);

module tendon_bridge() {
  xs = concat([TH_RIB_X], [for (i = [0:3]) x_t(i)]);
  hull() for (x = xs) {
    zz = z_top(x) + 1.0;
    translate([x, y_rear + 2.6, zz + BR_H - 0.3]) sphere(2.6, $fn = 16);
    translate([x, y_rear + 8 * S, zz + BR_H - 0.3]) sphere(2.6, $fn = 16);
    translate([x, y_rear + 24 * S, z_top(x) - 1]) sphere(1, $fn = 8);
    translate([x, y_rear + 0.6, z_top(x) - 2]) sphere(0.6, $fn = 8);
  }
}

module finger_ribs() for (i = [0:3])
  tube([x_t(i), y_bb, zT(i) - 0.3], [x_t(i), y_rear + 2.5, zT(i) - 0.3], 2.5, round_ends = true);

// ------- thumb mount, a small knuckle block of its own in the thumb frame ---
lug_rt = max(hole_tight / 2 + 2.4, 0.75 * r_tt);
module thumb_block_local() {
  hx = fwt / 2 + cl / 2 + lt;  e = 1.5;
  hull() for (x = [-hx + e, hx - e], y = [-(r_tt + cl) - tb_len + e, -(r_tt + cl) - e], z = [-(r_tt + 0.5) + e, r_tt + 1 - e])
    translate([x, y, z]) sphere(e, $fn = 12);
}
module thumb_lugs_local() for (sx = [-1, 1]) hull() {
  translate([sx * (fwt / 2 + cl / 2 + lt / 2), 0, 0]) rotate([0, 90, 0]) cylinder(r = lug_rt, h = lt, center = true);
  translate([sx * (fwt / 2 + cl / 2 + lt / 2) - lt / 2, -(r_tt + cl) - 2, -lug_rt]) cube([lt, 2, 2 * lug_rt]);   // root sunk into the block
}
TB_BACK = [0, -(r_tt + cl) - tb_len, 0];
function thumb_tendon_path() = let(
    b  = thumb_pt(TB_BACK + [0, 0, -ma_tp]),
    d  = thumb_vec([0, -1, 0]),
    sh = [TH_RIB_X, b[1] - 10 * S, z_top(TH_RIB_X) + 1.0])
  concat(bez_pts(b, b + d * 5 * S, sh + [0, 6 * S, -2 * S], sh, 10), ramp_tail(sh[0], sh[2]));

module thumb_mount_solid() {
  hull() {
    thumb_frame() thumb_block_local();
    translate([9 * S + TH_DX, 0, 0]) thumb_frame() thumb_block_local();
  }
  thumb_frame() thumb_lugs_local();
  // rib carrying the thumb tendon up and over the shoulder of the palm
  P = thumb_tendon_path();
  tube_path(concat([for (k = [1:10]) P[k]], [[P[10][0], y_rear + 2.5, P[10][2]]]), 2.5, round_ends = true);
}

module thumb_mount_cuts() {
  thumb_frame() {
    // clearance for the thumb proximal over its whole swing, and nothing more
    for (k = [0:3]) hull() for (c = [k / 4, (k + 1) / 4]) rotate([-c * TH_CK, 0, 0])
      translate([-(fwt + cl) / 2, -(r_tt + cl), -(r_tt + 1)]) cube([fwt + cl, r_tt + cl + TPL, 2 * (r_tt + 1)]);
    rotate([0, 90, 0]) cylinder(d = hole_tight, h = fwt + cl + 2 * lt + 1, center = true);
    // elastic straight back through the block, knot pocket at the rear face
    tube([0, -(r_tt + cl) + 1, ma_tp], [0, -(r_tt + cl) - tb_len - 4, ma_tp], ch_r);
    translate([0, -(r_tt + cl) - tb_len - 0.01, ma_tp]) rotate([90, 0, 0]) cylinder(r = 1.7, h = 10);
  }
  tube_path(concat([thumb_pt([0, -(r_tt + cl) + 1, -ma_tp])], thumb_tendon_path()), ch_r);
}

// cavity for the hand: full height over the palm, then forward under the knuckle
// bar, then a pocket for each knuckle following the finger arc. Open at the rear
// and the bottom (the palm base closes the bottom).
module knuckle_section() intersection() {
  palm_section(a_i, b_i, -8);
  translate([-60, -8]) square([120, z_bar + 8]);
}
module knuckle_pockets() for (i = [0:3]) hull() {
  translate([x_slot(i) - (fw + cl) / 2 + 0.3, y_kr - 1, -8]) cube([fw + cl - 0.6, EPS, z_bar + 8]);
  translate([x_slot(i) - (fw + cl) / 2 + 1.5, y_face(i) - wall_f - EPS, -8]) cube([fw + cl - 3, EPS, z_bar + 6]);
}
module palm_cavity() {
  hull() {
    ext_y(y_rear - 1, y_cav_front - 4 * S) palm_section(a_i, b_i, -8);
    ext_y(y_cav_front + 2 * S - EPS, y_cav_front + 2 * S) knuckle_section();
  }
  ext_y(y_cav_front, y_kr) knuckle_section();
  knuckle_pockets();
}

module palm_channels() {
  for (i = [0:3]) { tube_path(tendon_path(i), ch_r); tube_path(elastic_path(i), ch_r); }
  tube_path(thumb_tendon_path(), ch_r);
}

module palm_raw() {
  difference() {
    union() {
      intersection() {
        union() { ext_y(y_rear, y_face_max) palm_section(a_o, b_o, 0); knuckle_bar(); }
        body_front_mask();
      }
      knuckle_lugs();
      finger_ribs();
      tendon_bridge();
      thumb_mount_solid();
      // wrist bosses
      for (sx = [-1, 1]) translate([sx * (a_i + (wall + boss_h) / 2), yp, zp])
        rotate([0, 90, 0]) cylinder(r = boss_r, h = wall + boss_h + 0.4, center = true);
    }
    palm_cavity();
    // finger slots and knuckle pins
    for (i = [0:3]) {
      translate([x_slot(i) - (fw + cl) / 2, y_face(i), -1]) cube([fw + cl, 80 * S, H_o + 30]);
      translate([x_slot(i), KY[i], kz]) rotate([0, 90, 0]) cylinder(d = hole_tight, h = fw + cl + 2 * lt + 1, center = true);
      // knot pocket where each elastic leaves the back of the bar, open at the top for tying
      translate([x_e(i), y_A - 0.5, zA(i)]) rotate([90, 0, 0]) hull() {
        cylinder(r = 1.7, h = 6);
        translate([0, 12, 0]) cylinder(r = 1.7, h = 6);
      }
      // tendon exit funnels
      translate([x_t(i), y_rear - EPS, zT(i) + BR_H]) rotate([-90, 0, 0]) cylinder(r1 = ch_r + 0.8, r2 = ch_r, h = 1.5);
    }
    thumb_mount_cuts();
    palm_channels();
    translate([TH_RIB_X, y_rear - EPS, z_top(TH_RIB_X) + 1.0 + BR_H]) rotate([-90, 0, 0]) cylinder(r1 = ch_r + 0.8, r2 = ch_r, h = 1.5);
    // wrist holes with the snap pocket on the inside face
    for (sx = [-1, 1]) {
      translate([0, yp, zp]) rotate([0, 90, 0]) cylinder(d = wd + 0.15, h = W_o + 10, center = true);
      translate([sx * (a_i - 0.5 + (pocket + 0.5) / 2), yp, zp]) rotate([0, 90, 0]) cylinder(d = wd + 1.6, h = pocket + 0.5, center = true);
    }
    // snap slots for the palm base, low in both side walls
    for (sl = BASE_SLOTS) translate([-a_o - 5, sl[0], BS_Z0]) cube([W_o + 10, sl[1] - sl[0], BS_Z1 - BS_Z0]);
    // chamfer the outer front corners below the lugs, where the closing thumb passes
    for (sx = [-1, 1]) translate([sx * a_o, y_face(sx < 0 ? 0 : 3), -1]) rotate([0, 0, 45])
      translate([-FC_CH / sqrt(2), -FC_CH / sqrt(2), 0]) cube([FC_CH * sqrt(2), FC_CH * sqrt(2), 0.6 * z_bar + 1]);
    // flatten anything below the bed
    translate([-200, -300, -50]) cube([400, 600, 50]);
  }
}

module palm_side_text() {
  sx = hand == "right" ? 1 : -1;
  txt = str(hand == "right" ? "R " : "L ", round(S * 100), "%");
  translate([sx * (a_o - 0.5), (BASE_SLOTS[0][1] + BASE_SLOTS[1][0]) / 2, ZC * 0.62])
    rotate([90, 0, sx * 90]) linear_extrude(2) label(txt, min(4, ZC * 0.4));
}

module palm() difference() {
  if (hand == "right") palm_raw(); else mirror([1, 0, 0]) palm_raw();
  palm_side_text();
}

// ============================================================== FINGERS ====
// Proximal phalanx: pivot at the origin, extends +Y, width along X, dorsal +Z.
module proximal(w, h, len, hn, twn, ma1, ma2, txt) {
  r1 = h / 2;  rc = hn / 2;  e = min(1.2, w / 4);
  difference() {
    // flat dorsal and palmar faces: prints dorsal-down with no supports
    intersection() { union() {
      hull() { rdisc(r1, w); translate([0, len, 0]) rdisc(rc, w); }
      // heel: squares off the back-top quadrant so the palm face stops hyperextension
      hull() { rdisc(r1, w); translate([-(w / 2 - e), -(r1 + cl * 0.5), 0]) cube([w - 2 * e, EPS, r1 - e]); }
    }
    translate([-w, -2 * r1, -rc]) cube([2 * w, len + 4 * r1, 2 * rc]); }
    translate([-(twn + cl) / 2, len - rc - cl, -h]) cube([twn + cl, rc + rc + cl + 2, 2 * h]);
    rotate([0, 90, 0]) cylinder(d = hole_free, h = w + 2, center = true);
    translate([0, len, 0]) rotate([0, 90, 0]) cylinder(d = hole_tight, h = w + 2, center = true);
    chain_path([[0, -r1 - 1, -ma1], [0, len + rc + 1, -ma2]], ch_r);
    chain_path([[0, -r1 - 1,  ma1], [0, len + rc + 1,  ma2]], ch_r);
    translate([w / 2 - 0.5, len * 0.45, 0]) rotate([90, 0, 90]) linear_extrude(2) label(txt, min(4.5, h * 0.42));
  }
}

// Distal phalanx: pivot at the origin, tongue rides in the proximal fork.
module distal(w, h, len, tiph, twd, ma, txt) {
  r = h / 2;  e = min(1.2, w / 4);
  zt_ = tiph * 0.22;
  zc_ = r - tiph / 2;          // tip centre: nail side flush with the dorsal face
  ay  = tiph * 0.75;           // tip half-length: a rounded pad, not a cone
  yc  = len - ay;
  difference() {
    union() {
      hull() { rdisc(r, twd); translate([-(twd / 2 - e), -(r + cl * 0.5), 0]) cube([twd - 2 * e, EPS, r - e]); }
      hull() { rdisc(r, twd); translate([0, r + cl + 1.5, 0]) rdisc(r, twd); }
      hull() {
        translate([0, r + cl, 0]) rslab(w, h, e);
        translate([0, yc, zc_]) scale([w * 0.47, ay, tiph / 2]) sphere(1, $fn = 48);
      }
    }
    // grip grooves across the fingertip pad (on top when printed dorsal-down)
    for (u = [0.05, 0.35, 0.62])
      translate([0, yc + u * ay, zc_ - tiph / 2 * sqrt(1 - u * u)])
        rotate([0, 90, 0]) cylinder(r = 0.6, h = w + 2, center = true, $fn = 12);
    rotate([0, 90, 0]) cylinder(d = hole_free, h = w + 2, center = true);
    chain_path([[0, -r - 1, -ma], [0, len * 0.7, zc_ - zt_], [0, len + 1, zc_ - zt_]], ch_r);
    chain_path([[0, -r - 1,  ma], [0, len * 0.7, zc_ + zt_], [0, len + 1, zc_ + zt_]], ch_r);
    translate([0, len - 0.4, zc_]) scale([2.2, 2.6, zt_ + 1.7]) sphere(1, $fn = 24);   // knot pocket under the fingertip grip
    translate([w / 2 - 0.5, (len + r) * 0.42, 0]) rotate([90, 0, 90]) linear_extrude(2) label(txt, min(4.0, h * 0.38));
  }
}

module finger_prox(i)  proximal(fw, ph, PL[i], dh, tw, ma_p, ma_d, FNAME[i]);
module finger_dist(i)  distal(fw, dh, DL[i], tip_h, tw, ma_d, FNAME[i]);
module thumb_prox()    proximal(fwt, pht, TPL, dht, twt, ma_tp, ma_td, "T");
module thumb_dist()    distal(fwt, dht, TDL, tipt, twt, ma_td, "T");

// ================================================================= PINS ====
K_LEN = fw + cl + 2 * lt;   F_LEN = fw;
T_LEN = fwt + cl + 2 * lt;  U_LEN = fwt;
W_SHAFT = gt + (gap_w - boss_h) + (wall + boss_h - pocket) + 0.3;   // lip lands 0.3 mm inside the pocket
N_SHAFT = blk_h - 1.5 - 0.3;

module wrist_pin() {
  hd = wd + 4.5;  hl = 2.0;  bl = 1.4;  lip = 0.45;
  L = hl + W_SHAFT + bl;
  h = wd - 2 * pin_flat;
  difference() {
    translate([0, 0, h / 2]) intersection() {
      rotate([0, 90, 0]) rotate_extrude() polygon([
        [0, 0], [hd / 2 - 0.5, 0], [hd / 2, 0.5], [hd / 2, hl], [wd / 2, hl],
        [wd / 2, hl + W_SHAFT], [wd / 2 + lip, hl + W_SHAFT + 0.05],
        [wd / 2 - 0.35, L], [0, L]]);
      translate([-1, -hd, -h / 2]) cube([L + 2, 2 * hd, h]);
    }
    // split tip so the barbs flex inward in the print plane
    translate([L - 5.2, -0.7, -1]) cube([6, 1.4, h + 2]);
  }
}

module tensioner_pin() {
  d = 5.0;  h = d - 2 * pin_flat;
  difference() {
    union() {
      translate([0, -5.5, 0]) cube([3, 11, h]);                 // T-handle
      translate([0, 0, h / 2]) intersection() {
        union() {
          translate([2.9, 0, 0]) chamfered_rod(7.5, 1.2, 0.3);   // collar
          translate([4, 0, 0]) chamfered_rod(d, N_SHAFT);
        }
        translate([-1, -6, -h / 2]) cube([N_SHAFT + 6, 12, h]);
      }
    }
    translate([4 + N_SHAFT - (blk_ch - 1.5 + 0.3), 0, -1]) cylinder(d = 2.0, h = h + 2, $fn = 16);
  }
}

module pin_tree() {
  rows = [ ["K", 4, K_LEN, pin_diameter, "knuckle"], ["F", 4, F_LEN, pin_diameter, "finger"],
           ["T", 1, T_LEN, pin_diameter, "thumb knuckle"], ["U", 1, U_LEN, pin_diameter, "thumb"],
           ["W", 2, 0, wd + 4.5, "wrist snap"], ["N", 5, 0, 11, "tensioner"] ];
  pitch = [for (r = rows) r[3] + 3];
  ys = [for (k = [0:len(rows) - 1]) sum_to([for (q = [0:len(rows) - 1]) rows[q][1] * pitch[q] + 3], k)];
  for (k = [0:len(rows) - 1]) {
    r = rows[k];  y0 = ys[k];
    for (n = [0:r[1] - 1]) translate([0, y0 + n * pitch[k], 0]) {
      if (r[0] == "W") wrist_pin();
      else if (r[0] == "N") tensioner_pin();
      else dpin(r[2], r[3]);
      translate([-1.4, -0.4, 0]) cube([1.6, 0.8, 0.8]);              // break-away gate
    }
    // labelled tag for the row
    tag_y = y0 + (r[1] - 1) * pitch[k] / 2;
    translate([-16, tag_y - 4, 0]) cube([10, 8, 1.0]);
    translate([-11, tag_y, 1.0]) linear_extrude(0.6) label(r[0], 5);
  }
  // spine joining every gate
  translate([-6, -2, 0]) cube([4.6, ys[len(rows) - 1] + rows[len(rows) - 1][1] * pitch[len(rows) - 1] + 2, 0.8]);
}

// ============================================================= GAUNTLET ====
module thick_profile(s1, s2, th) {
  Q = prof_samples(s1, s2);
  polygon(concat([for (q = Q) q[0] + q[1] * th / 2], [for (i = [len(Q) - 1:-1:0]) Q[i][0] - Q[i][1] * th / 2]));
}

// Features are rectangles in (s, y): one table drives both the flat and formed parts.
// Strap slots sit low on each side wall and run along the forearm, so a 1" velcro
// strap passes through edge-on and wraps around under the arm.
SLOT_N = 3.6;                                  // slot height around the arm
SLOT_S = s_end - 4 - SLOT_N / 2;               // slot centre, arc length from the top
SLOT_Y = [y_g_rear + 8, y_bf - 8 - Ls];        // rear and front strap positions
SLOTS = [ for (sy = SLOT_Y) for (sg = [-1, 1])
          [sg > 0 ? SLOT_S - SLOT_N / 2 : -(SLOT_S + SLOT_N / 2), sg > 0 ? SLOT_S + SLOT_N / 2 : -(SLOT_S - SLOT_N / 2), sy, sy + Ls] ];
CR = 6;   // corner radius at the bottom corners of the side walls

module tab2d() hull() {
  translate([y_bf - 3, zp - tab_w / 2]) square([EPS, tab_w]);
  translate([yp, zp]) circle(d = tab_w);
}

module tensioner_block() difference() {
  hull() for (sx = [-1, 1], sy = [0, 1]) translate([sx * (blk_w / 2 - 3), -3 - sy * (blk_len - 6), 0]) {
    cylinder(r = 3, h = blk_h - 1.5);
    translate([0, 0, blk_h - 1.5]) scale([1, 1, 0.5]) sphere(3);
  }
  for (k = [0:4]) {
    translate([tens_x(k), tens_y(k) - y_bf + 1.5, 1.5]) cylinder(d = 5.0 + 0.1, h = blk_h);
    translate([tens_x(k), 1, blk_ch]) rotate([90, 0, 0]) cylinder(r = 1.0, h = blk_len + 2, $fn = 16);
    translate([tens_x(k), EPS, blk_ch]) rotate([90, 0, 0]) cylinder(r1 = 2.0, r2 = 1.0, h = 1.5, $fn = 16);
  }
}

// kept inside the flat strip under the block so it reads the same before and after forming
module gauntlet_text2d() label(str("e-NABLE ", hand == "right" ? "R" : "L", " ", round(S * 100), "%"), min(3.8, wc / 11));

module gauntlet_formed() {
  difference() {
    union() {
      ext_y(y_g_rear, y_bf) thick_profile(-s_end, s_end, gt);
      for (sx = [-1, 1]) translate([sx * x_side, 0, 0]) rotate([90, 0, 90]) linear_extrude(gt, center = true) tab2d();
      translate([0, y_bf - 1.5, blk_z0 - 0.2]) tensioner_block();
    }
    for (sl = SLOTS) ext_y(sl[2], sl[3]) thick_profile(sl[0], sl[1], gt + 2);
    translate([0, yp, zp]) rotate([0, 90, 0]) cylinder(d = wd + 0.4, h = 2 * x_side + 10, center = true);
    for (sx = [-1, 1], yc = [y_g_rear, y_bf]) translate([sx * x_side, 0, 0]) rotate([90, 0, 90])
      linear_extrude(gt + 2, center = true, convexity = 4) corner2d(yc, yc == y_bf ? 1 : -1);
    translate([0, y_g_rear + 12, blk_z0 - 0.6]) linear_extrude(1) gauntlet_text2d();
  }
}

// corner mask in (y, z) at the bottom of a side wall
module corner2d(yc, dir) difference() {
  translate([dir > 0 ? yc - CR : yc - EPS, z_bot - 1]) square([CR + EPS, CR + 1]);
  translate([yc - dir * CR, z_bot + CR]) circle(CR);
}

module gauntlet_flat() {
  difference() {
    union() {
      translate([-s_end, y_g_rear, 0]) cube([2 * s_end, Lg, gt]);
      for (sp = [-s_p, s_p]) linear_extrude(gt) hull() {
        translate([sp - tab_w / 2, y_bf - 3]) square([tab_w, EPS]);
        translate([sp, yp]) circle(d = tab_w);
      }
      translate([0, y_bf - 1.5, gt - 0.2]) tensioner_block();
    }
    for (sl = SLOTS) translate([sl[0], sl[2], -1]) cube([sl[1] - sl[0], sl[3] - sl[2], gt + 2]);
    for (sp = [-s_p, s_p]) translate([sp, yp, -1]) cylinder(d = wd + 0.4, h = gt + 2);
    for (sg = [-1, 1], yc = [y_g_rear, y_bf]) translate([0, 0, -1]) linear_extrude(gt + 2) flat_corner(sg, yc, yc == y_bf ? 1 : -1);
    translate([0, y_g_rear + 12, gt - 0.6]) linear_extrude(1) gauntlet_text2d();
  }
}

module flat_corner(sg, yc, dir) difference() {
  translate([sg > 0 ? s_end - CR : -s_end - EPS, dir > 0 ? yc - CR : yc - EPS]) square([CR + EPS, CR + EPS]);
  translate([sg * (s_end - CR), yc - dir * CR]) circle(CR);
}

// ========================================================== FORMING JIG ====
// A mandrel with the gauntlet's exact inner surface. Heat the flat-printed
// gauntlet, lay its centre strip on top, drop the strap slots over the pegs and
// the wrist-pin holes over the side pins, then press it down and let it cool.
// The side pins put both wrist holes on one axis. Symmetric, so it serves both hands.
JIG_CLR = 0.2;                                     // forming surface undersize
jig_y0 = y_g_rear - 2;
jig_y1 = yp + tab_w / 2 + 3;
module jig_section() polygon([for (q = prof_samples(-s_end, s_end)) q[0] - q[1] * (gt / 2 + JIG_CLR)]);

module forming_jig_raw() {
  difference() {
    union() {
      ext_y(jig_y0, jig_y1) jig_section();
      // registration pegs that sit in the strap slots (0.4 mm smaller all round)
      intersection() {
        for (sl = SLOTS) ext_y(sl[2] + 0.4, sl[3] - 0.4) thick_profile(sl[0] + 0.4, sl[1] - 0.4, 2 * gt - 1);
        ext_y(jig_y0, jig_y1) offset(delta = gt) jig_section();
      }
      // pivot pins through the tab holes
      for (sx = [-1, 1]) translate([sx * (x_side - gt / 2 - JIG_CLR - 1), yp, zp])
        rotate([0, sx * 90, 0]) cylinder(d = wd, h = gt + 1 + JIG_CLR + 1.5, $fn = 32);
    }
    // label on the rear face
    translate([0, jig_y0 + 0.6, (zt + z_bot) / 2]) rotate([90, 0, 0]) linear_extrude(1)
      label(str("JIG ", round(S * 100), "%"), min(6, (zt - z_bot) * 0.3));
  }
}
module forming_jig() translate([0, 0, -z_bot]) forming_jig_raw();   // flat bottom on the bed

// ============================================================ PALM BASE ====
// Closes the underside of the palm so the device wraps the hand like a glove.
// A TPU tray: a ventilated floor under the palm and knuckles, with side flanges
// that hug the palm walls. Two snap wedges per side click up into slots in the
// walls; the wedges' flat tops catch the slot edges, so the base cannot drop off.
// The flanges fit in the 2 mm between the palm and the gauntlet's wrist tabs,
// so they clear the tabs at every wrist angle. Print in TPU 95A, floor down.
b_t  = 2.4;                                    // floor thickness
b_fc = 0.15;  b_ft = 1.8;                      // flange clearance and thickness
b_fz = 7.5;                                    // flange top (below the wrist bosses)
b_x  = a_o + b_fc + b_ft;                      // outside of the flanges
b_z0 = -0.1 - b_t;                             // underside of the floor

// The front edge steps back to just behind each finger's palm face, so a closing
// finger never meets the base.
module base_outline2d() offset(r = 3) offset(delta = -3) polygon(concat(
  [[-b_x, y_rear + 0.5], [b_x, y_rear + 0.5], [b_x, y_face(3) - wall_f]],
  [for (i = [3:-1:0], sx = [1, -1]) [x_slot(i) + sx * (fw + cl) / 2, y_face(i) - 0.6]],
  [[-b_x, y_face(0) - wall_f]]));
module base_vents2d() for (ix = [-8:8], iy = [-12:12]) {
  x = ix * 5.2;  y = iy * 4.5;  yy = y + (ix % 2 == 0 ? 0 : 2.25);
  yc = (y_rear + y_cav_front) / 2;
  if (abs(x) < a_i - 7 && abs(yy) < (y_cav_front - y_rear) / 2 - 8) translate([x, yc + yy]) circle(d = 3.4, $fn = 6);
}
module palm_base() {
  difference() {
    union() {
      translate([0, 0, b_z0]) linear_extrude(b_t) base_outline2d();                       // floor
      for (sx = [-1, 1]) intersection() {                                                // side flanges
        translate([0, 0, b_z0]) linear_extrude(b_fz - b_z0) base_outline2d();
        translate([sx > 0 ? a_o + b_fc : -b_x, y_rear + 2, b_z0]) cube([b_ft, y_kr - y_rear - 4, b_fz - b_z0]);
      }
      for (sx = [-1, 1], sl = BASE_SLOTS) mirror([sx < 0 ? 1 : 0, 0, 0])                 // snap wedges
        translate([0, sl[0] + 0.5, 0]) rotate([90, 0, 0]) mirror([0, 0, 1]) linear_extrude(sl[1] - sl[0] - 1)
          polygon([[a_o + b_fc + 0.4, BS_Z0 + 0.2], [a_o + b_fc, BS_Z0 + 0.2], [a_o + b_fc - 1.0, BS_Z1 - 0.35], [a_o + b_fc + 0.4, BS_Z1 - 0.35]]);   // rooted 0.4 into the flange
    }
    translate([0, 0, b_z0 - 1]) linear_extrude(b_t + 2) base_vents2d();
  }
}
module palm_base_print() translate([0, 0, -b_z0]) palm_base();   // floor on the bed

// ============================================================== HARDWARE ====
// Non-printed parts, modelled so the assembly is complete: forearm velcro straps,
// foam liners, gel fingertip grips, and the tendon and elastic cords along their
// channels. Sizes follow the e-NABLE hardware list.
strap_t   = 1.5;                               // 1" velcro, thickness
tendon_r  = 0.18;                              // 0.36 mm braided line (40 lb Spectra / Dyneema)
elastic_r = 0.5;                               // 1 mm round elastic cord
grip_t    = 1.4;                               // gel fingertip grip wall

// -- forearm straps: through a slot on each side, under the forearm ----------
SLOT_Z = zt - B_e - (SLOT_S - s_vstart);       // slot centre height on the vertical wall
x_strap = x_side + gt / 2 + 0.25 + strap_t / 2;
under_b = (z_bot - 1) - (zp - fa_half - strap_t / 2 - 0.5);
FOREARM_STRAP_PTS = concat(
  [[x_side - gt / 2 + strap_t / 2 + 0.05, SLOT_Z], [x_strap, SLOT_Z]],
  [for (k = [0:36]) let(t = 180 * k / 36) [x_strap * cos(t), (z_bot - 1) - under_b * sin(t)]],
  [[-x_strap, SLOT_Z], [-(x_side - gt / 2 + strap_t / 2 + 0.05), SLOT_Z]]);
forearm_strap_len = sum_to([for (k = [0:len(FOREARM_STRAP_PTS) - 2]) norm(FOREARM_STRAP_PTS[k + 1] - FOREARM_STRAP_PTS[k])],
                           len(FOREARM_STRAP_PTS) - 1) + 60;   // + velcro overlap
module forearm_strap(k) ext_y(SLOT_Y[k] + (Ls - 25.4) / 2, SLOT_Y[k] + (Ls + 25.4) / 2)
  for (j = [0:len(FOREARM_STRAP_PTS) - 2]) hull() {
    translate(FOREARM_STRAP_PTS[j]) circle(d = strap_t, $fn = 12);
    translate(FOREARM_STRAP_PTS[j + 1]) circle(d = strap_t, $fn = 12);
  }

// -- foam liners --------------------------------------------------------------
// palm: lines the roof and sides above the base slots, and the underside of the knuckle bar
module foam_palm() {
  ext_y(y_rear + 1, y_cav_front - 4 * S - 1) difference() {
    palm_section(a_i - 0.15, b_i - 0.15, 5.6);
    palm_section(a_i - 0.15 - foam_thickness, b_i - 0.15 - foam_thickness, 0);
  }
  intersection() {
    ext_y(y_cav_front + 0.5, y_kr - 0.5) offset(delta = -0.15) knuckle_section();
    translate([-60, -100, z_bar - 0.15 - 2]) cube([120, 200, 2]);
  }
}
// base: a 2 mm pad on the floor of the palm base
module foam_base() ext_y(y_rear + 1, y_kr - 0.5) intersection() {
  palm_section(a_i - 0.15, b_i, -1);
  translate([-60, -0.05]) square([120, 2]);
}
// gauntlet: follows the formed inner surface over the band
module foam_gauntlet() ext_y(y_g_rear + 1, y_bf - 1) let(Q = prof_samples(-s_end + 0.5, s_end - 0.5))
  polygon(concat([for (q = Q) q[0] - q[1] * (gt / 2 + 0.15)],
                 [for (i = [len(Q) - 1:-1:0]) Q[i][0] - Q[i][1] * (gt / 2 + 0.15 + foam_thickness)]));

// -- gel fingertip grips (e.g. Lee Tippi), in a distal phalanx's own frame ----
module distal_envelope(w, h, len, tiph, off) {
  r = h / 2;  e = min(1.2, w / 4);  ay = tiph * 0.75;  zc_ = r - tiph / 2;
  hull() {
    translate([0, r + cl, 0]) rslab(w + 2 * off, h + 2 * off, e);
    translate([0, len - ay, zc_]) scale([w * 0.47 + off, ay + off, tiph / 2 + off]) sphere(1, $fn = 40);
  }
}
module fingertip_grip(w, h, len, tiph) difference() {
  intersection() {
    distal_envelope(w, h, len, tiph, grip_t + 0.15);
    // up to 11 mm long, but starting ahead of the joint tongue (which ends at 2r + cl + 1.5)
    translate([-w, len - min(11, len - (h + cl + 1.5) - 0.5), -h]) cube([2 * w, 20, 2 * h]);
  }
  distal_envelope(w, h, len, tiph, 0.15);
}

// -- tendons and elastic --------------------------------------------------------
// Each cord follows its channel centrelines body by body and crosses each joint
// with a short chord from where the channel leaves one part to where it enters
// the next. pose: wrist flexion w, closure c (as in the assembly).
function lerp3(a, b, t) = a + (b - a) * t;
function on_line(p, q, y) = lerp3(p, q, (y - p[1]) / (q[1] - p[1]));
// channel lines in each part's own frame (match modules proximal() and distal())
function dist_line(h, len, tiph, ma, sg) = let(r = h / 2, zt_ = tiph * 0.22, zc_ = r - tiph / 2)
  [[0, -r - 1, sg * ma], [0, len * 0.7, zc_ + sg * zt_]];
function prox_line(h, len, hn, ma1, ma2, sg) = let(r1 = h / 2, rc = hn / 2)
  [[0, -r1 - 1, sg * ma1], [0, len + rc + 1, sg * ma2]];
// where a channel crosses the round end of a tongue of radius r (behind the pivot)
function tongue_exit(L, r) = let(z = L[0][2]) on_line(L[0], L[1], -sqrt(max(0, r * r - z * z)) + 0.2);
// A flexed joint bends the tendon around the tongue: points on an arc that hugs the
// tongue (radius r + 0.2) inside the joint clearance, from the tongue's exit (Erel)
// round to the next part's channel entry (Frel). Both relative to the pivot.
function ang360(p) = (atan2(p[2], p[1]) + 360) % 360;
function joint_wrap(Erel, Frel, R) = let(aE = ang360(Erel), aF = ang360(Frel), n = ceil(abs(aF - aE) / 4))
  n < 2 ? [] : [for (k = [1:n - 1]) let(a = aE + (aF - aE) * k / n) [0, R * cos(a), R * sin(a)]];
function unit(v) = v / norm(v);
function gap_len(a, b) = min(1, 0.4 * norm(a - b));   // how far a cord leaves its channel across a joint gap
// the dorsal (elastic) channel leaves through the flat back face of the heel stop instead
function joint_exit(L, r, sg) = sg > 0 ? on_line(L[0], L[1], -(r + cl * 0.5) - 0.2) : tongue_exit(L, r);

// world points for finger i; sg = -1 tendon (palmar), +1 elastic (dorsal)
function finger_cord(i, sg, w, c) = let(
    kn = [x_slot(i), KY[i], kz], RK = Rx(-c * CLOSE_K), RD = Rx(-c * CLOSE_D),
    Ld = dist_line(dh, DL[i], tip_h, ma_d, sg), Lp = prox_line(ph, PL[i], dh, ma_p, ma_d, sg),
    zt_ = tip_h * 0.22, zc_ = dh / 2 - tip_h / 2,
    dloc = [[0, DL[i] - 2.0, zc_ + sg * zt_], Ld[1], joint_exit(Ld, dh / 2, sg)],
    ploc = [on_line(Lp[0], Lp[1], PL[i] - dh / 2 - cl + 0.3), joint_exit(Lp, ph / 2, sg)],
    palm_pts = sg < 0 ? concat([[x_slot(i), y_face(i) - 0.3, kz - ma_p]], [for (k = [2:len(tendon_path(i)) - 1]) tendon_path(i)[k]])
                      : concat([[x_slot(i), y_face(i) - 0.3, kz + ma_p]], [for (k = [2:len(elastic_path(i)) - 1]) elastic_path(i)[k]]),
    P1 = [0, PL[i], 0],
    wrap_d = sg < 0 ? joint_wrap(RD * dloc[2], ploc[0] - P1, dh / 2 + 0.2) : [],
    wrap_k = sg < 0 ? joint_wrap(RK * ploc[1], palm_pts[0] - kn, ph / 2 + 0.2) : [],
    // elastic at a flexed joint: straight out of its channel, then straight into the next one
    // (at most 1 mm out, and never past the other side of the gap at a slight bend)
    flex = c > 0.02 && sg > 0,
    sd = gap_len(P1 + RD * dloc[2], ploc[0]),  sk = gap_len(kn + RK * ploc[1], palm_pts[0]),
    gap_d = flex ? [P1 + RD * (dloc[2] + sd * unit(Ld[0] - Ld[1])), ploc[0] + [0, min(0.3, sd), 0]] : [],
    gap_k = flex ? [kn + RK * (ploc[1] + sk * unit(Lp[0] - Lp[1])), palm_pts[0] + [0, min(0.9, sk), 0]] : [],
    hand_pts = concat([for (p = dloc) kn + RK * (P1 + RD * p)], [for (p = wrap_d) kn + RK * (P1 + p)],
                      [for (p = gap_d) kn + RK * p],
                      [for (p = ploc) kn + RK * p], [for (p = wrap_k) kn + p], gap_k, palm_pts),
    world = [for (p = hand_pts) rotw(p, w)])
  sg < 0 ? concat(world, [tens_entry(i + 1), [tens_x(i + 1), tens_y(i + 1), blk_z0 + blk_ch]]) : world;

function thumb_cord(sg, w, c) = let(
    RK = Rx(-c * TH_CK), RD = Rx(-c * TH_CD),
    Ld = dist_line(dht, TDL, tipt, ma_td, sg), Lp = prox_line(pht, TPL, dht, ma_tp, ma_td, sg),
    zt_ = tipt * 0.22, zc_ = dht / 2 - tipt / 2,
    dloc = [[0, TDL - 2.0, zc_ + sg * zt_], Ld[1], joint_exit(Ld, dht / 2, sg)],
    ploc = [on_line(Lp[0], Lp[1], TPL - dht / 2 - cl + 0.3), joint_exit(Lp, pht / 2, sg)],
    Q1 = [0, TPL, 0], F0 = [0, -(r_tt + cl) - 0.3, sg * ma_tp],
    wrap_d = sg < 0 ? joint_wrap(RD * dloc[2], ploc[0] - Q1, dht / 2 + 0.2) : [],
    wrap_k = sg < 0 ? joint_wrap(RK * ploc[1], F0, pht / 2 + 0.2) : [],
    flex = c > 0.02 && sg > 0,
    sd = gap_len(Q1 + RD * dloc[2], ploc[0]),  sk = gap_len(RK * ploc[1], F0),
    gap_d = flex ? [Q1 + RD * (dloc[2] + sd * unit(Ld[0] - Ld[1])), ploc[0] + [0, min(0.3, sd), 0]] : [],
    gap_k = flex ? [RK * (ploc[1] + sk * unit(Lp[0] - Lp[1])), F0 + [0, min(0.9, sk), 0]] : [],
    local = concat([for (p = dloc) RK * (Q1 + RD * p)], [for (p = wrap_d) RK * (Q1 + p)],
                   [for (p = gap_d) RK * p],
                   [for (p = ploc) RK * p], wrap_k, gap_k, [F0]),
    block = sg < 0 ? thumb_tendon_path() : [thumb_pt([0, -(r_tt + cl) - tb_len - 0.5, ma_tp])],
    hand_pts = concat([for (p = local) thumb_pt(p)], block),
    world = [for (p = hand_pts) rotw(p, w)])
  sg < 0 ? concat(world, [tens_entry(0), [tens_x(0), tens_y(0), blk_z0 + blk_ch]]) : world;

module cord(pts, r) chain_path(pts, r, 8);
// left hands mirror the hand side; the tensioner order mirrors with it
function mirror_pts(P) = [for (p = P) [-p[0], p[1], p[2]]];
module tendon(k, w, c) {   // k: 0 = thumb, 1..4 = I M R L (tensioner order)
  P = k == 0 ? thumb_cord(-1, w, th_c(c)) : finger_cord(k - 1, -1, w, c);
  tube_path(hand == "right" ? P : mirror_pts(P), tendon_r, 8);   // tendons follow smooth arcs: one swept tube
}
module elastic(k, w, c) {
  P = k == 0 ? thumb_cord(1, w, th_c(c)) : finger_cord(k - 1, 1, w, c);
  cord(hand == "right" ? P : mirror_pts(P), elastic_r);
}

// ============================================================= FIT TEST ====
module fit_test() {
  cs = [0.10, 0.20, 0.30, 0.40];
  difference() {
    cube([46, 22, 10]);
    for (k = [0:3]) {
      x = 7 + k * 10.6;
      translate([x, 15.5, -1]) cylinder(d = pin_diameter + cs[k], h = 12);                         // vertical
      translate([x, -1, 5]) rotate([-90, 0, 0]) cylinder(d = pin_diameter + cs[k], h = 11);        // horizontal
      translate([x, 15.5, 9.4]) linear_extrude(1) translate([0, -5.4]) label(str(cs[k]), 2.6);
    }
  }
  translate([0, -10, 0]) dpin(24, pin_diameter);
  translate([30, -10, 0]) wrist_pin();
}

// ============================================================= ASSEMBLY ====
W_ANG = animate ? -10 + 50 * (0.5 - 0.5 * cos(360 * $t)) : wrist_angle;
curl = auto_curl ? curl_at(W_ANG) : manual_curl;

module finger_assembly(i) translate([x_slot(i), KY[i], kz]) rotate([-curl * CLOSE_K, 0, 0]) {
  color(finger_color) finger_prox(i);
  translate([0, PL[i], 0]) rotate([-curl * CLOSE_D, 0, 0]) {
    color(finger_color) finger_dist(i);
    if (show_hardware) color(hardware_color) fingertip_grip(fw, dh, DL[i], tip_h);
  }
}

module thumb_assembly() let(tc = th_c(curl)) thumb_frame() rotate([-tc * TH_CK, 0, 0]) {
  color(finger_color) thumb_prox();
  translate([0, TPL, 0]) rotate([-tc * TH_CD, 0, 0]) {
    color(finger_color) thumb_dist();
    if (show_hardware) color(hardware_color) fingertip_grip(fwt, dht, TDL, tipt);
  }
}

module hand_on_wrist() translate([0, yp, zp]) rotate([-W_ANG, 0, 0]) translate([0, -yp, -zp]) {
  color(palm_color) palm();
  color(finger_color) palm_base();
  if (show_hardware) { color(foam_color) foam_palm(); color(foam_color) foam_base(); }
  if (hand == "right") { for (i = [0:3]) finger_assembly(i); thumb_assembly(); }
  else mirror([1, 0, 0]) { for (i = [0:3]) finger_assembly(i); thumb_assembly(); }
}

// wrist snap pin: head just off the gauntlet tab, shaft pointing into the palm
module wrist_pin_installed(sx) translate([sx * (x_side + gt / 2 + 2.05), yp, zp]) rotate([0, 0, sx > 0 ? 180 : 0])
  translate([0, 0, -(wd - 2 * pin_flat) / 2]) wrist_pin();

// tensioner pin standing in its hole, cross hole turned to line up with the tendon channel
module tensioner_pin_installed(k) translate([tens_x(k), tens_y(k), blk_z0 - 0.2 + blk_h + 4.15])   // collar 0.05 mm above the block
  rotate([0, 0, 90]) rotate([0, 90, 0]) translate([0, 0, -(5.0 - 2 * pin_flat) / 2]) tensioner_pin();

module assembly() {
  hand_on_wrist();
  color(gauntlet_color) gauntlet_formed();
  // wrist pins and tensioner pins in place
  color(accent_color) for (sx = [-1, 1]) wrist_pin_installed(sx);
  color(accent_color) for (k = [0:4]) tensioner_pin_installed(k);
  if (show_tendons) color(accent_color) for (k = [0:4]) tendon(k, W_ANG, curl);
  if (show_hardware) {
    color(hardware_color) for (k = [0:1]) forearm_strap(k);
    color(hardware_color) for (k = [0:4]) elastic(k, W_ANG, curl);
    color(foam_color) foam_gauntlet();
  }
}

// =============================================================== PLATES ====
// Phalanges print dorsal face down: flat on the bed, fork walls vertical, no supports.
module fingers_plate() {
  sp = fwt + 5;
  row2 = max(PL) + r_t + dht / 2 + 8;
  for (i = [0:3]) {
    translate([i * sp, 0, dh / 2]) rotate([0, 180, 0]) finger_prox(i);
    translate([i * sp, row2, dh / 2]) rotate([0, 180, 0]) finger_dist(i);
  }
  translate([4 * sp, 0, dht / 2]) rotate([0, 180, 0]) thumb_prox();
  translate([4 * sp, row2, dht / 2]) rotate([0, 180, 0]) thumb_dist();
}

module all_plates() {
  palm();
  translate([W_o + 20, y_rear, 0]) fingers_plate();
  translate([0, -260 * S, 0]) gauntlet_flat();
  translate([-W_o - 70, y_rear, 0]) pin_tree();
  translate([-W_o - 70, y_rear - 120, 0]) palm_base_print();
  translate([W_o + 20, y_rear - 60, 0]) fit_test();
  translate([2 * s_end + 40, -260 * S, 0]) forming_jig();
}

// =============================================================== REPORT ====
function r1(v) = round(v * 10) / 10;
module report() {
  ca = close_angle();
  echo(str("=== Phoenix-style starter hand — ", hand, " — scale ", r1(S * 100), " % ==="));
  echo(str("palm interior W x H x L   : ", r1(W_i), " x ", r1(H_i), " x ", r1(L_cav), " mm"));
  echo(str("finger width / fork cheek : ", r1(fw), " / ", r1(ct), " mm"));
  echo(str("pins  K x4 ", r1(K_LEN), "   F x4 ", r1(F_LEN), "   T x1 ", r1(T_LEN), "   U x1 ", r1(U_LEN),
           "   W x2 snap   N x5 tensioner   (d ", pin_diameter, " mm)"));
  echo(str("flat gauntlet blank       : ", r1(2 * s_end), " x ", r1(yp + tab_w / 2 - y_g_rear), " mm"));
  echo(str("knuckle clearance         : ", r1(z_bar - FOAM_UNDER_BAR), " mm inside the foam for a ", r1(KT),
           " mm knuckle (", r1(z_bar), " mm under the bar, ", r1(H_i), " mm over the palm)"));
  echo(str("palm base (TPU 95A)       : ", r1(2 * b_x), " x ", r1(y_face_max - y_rear), " mm, snaps into 4 wall slots"));
  echo(str("forearm velcro straps     : 2 x 1 in x ", round(forearm_strap_len), " mm (includes 60 mm overlap)"));
  echo(str("forming jig               : ", r1(2 * (x_side - gt / 2 - JIG_CLR)), " x ", r1(jig_y1 - jig_y0), " x ", r1(zt - gt / 2 - JIG_CLR - z_bot), " mm (print at 10-15 % infill)"));
  echo(str("tendon need (middle)      : ", r1(need_mid), " mm; available at 30 deg flexion: ", r1(excursion(2, 30)), " mm"));
  echo(str("wrist to middle fingertip : ", r1(PALM_TO_KNUCKLE + PL[1] + DL[1]), " mm (finger length x", r1(FL), ")"));
  echo(str("key pinch (thumb-index)   : ", KEY > 1 ? "thumb never reaches the index - retune TH_*" :
           str("pad meets side of index at ", round(KEY * 100), "% closure (~", wrist_for(KEY), " deg wrist), facing ",
               round(-pad_facing(KEY) * 100), "%"), "; open span ", r1(OPEN_SPAN), " mm"));
  echo(str("full grip                 : thumb holds on the side of the index at ", round(TH_FIST * 100), "% of its swing"));
  echo(str("wrist flexion to close    : ", ca > 70 ? "> 70 deg  (raise the tensioner block or lower ma)" : str(ca, " deg")));
  if (ma_d / (dh / 2) > 0.72) echo("WARNING: thin wall under the distal tendon channel. Use a scale above 110 %.");
  if (2 * s_end > 250 || Lg + 40 > 250) echo("WARNING: the flat gauntlet may not fit a 250 mm bed.");
  if (A_e < 6) echo("WARNING: the gauntlet corners are very tight; check forearm_thickness.");
  if (KT + FOAM_UNDER_BAR + 0.4 > H_i - 1) echo("WARNING: the knuckles are thicker than the palm allows. Raise the scale.");
}
report();

// ============================================================= DISPATCH ====
if (part == "assembly") assembly();
else if (part == "palm") palm();
else if (part == "fingers") fingers_plate();
else if (part == "pins") pin_tree();
else if (part == "gauntlet_flat") gauntlet_flat();
else if (part == "gauntlet_formed") gauntlet_formed();
else if (part == "forming_jig") forming_jig();
else if (part == "palm_base") palm_base_print();
else if (part == "fit_test") fit_test();
else if (part == "all_plates") all_plates();
