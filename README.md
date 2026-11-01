# Open Prosthetics Collective — Parametric Full-Body Assistive CADs

An open-source, parametric 3D-printable prosthetics repository created by **@sohanalevoor** that expands beyond traditional wrist-powered upper-limb devices into **partial-hand finger prosthetics**, **lower-limb transtibial mobility systems**, and **modular daily-living tool adapters**.

Unlike static STL repositories where scaling distorts pin bores, strap slots, and structural wall thicknesses, every OpenSCAD (`.scad`) model in this suite is built around **scale-independent hardware tolerances**: pins, tendon channels, M6/ISO pylon mounts, and snap-fit locks remain at exact real-world dimensions across any recipient size.

## Repository Architecture & CAD Modules

| Module Directory | Target Anatomy & Mechanism | Included Parametric & Mesh Files | Recommended Materials |
| :--- | :--- | :--- | :--- |
| `upper-limb/phoenix-hand-v8/` | Wrist-powered transradial / carpal hand with snap-in wrist pins, unrolled thermoform gauntlet, and TPU ventilated palm base | `phoenix_starter_hand.scad`, `Phoenix hand v8 - open.3mf`, `Phoenix hand v8 - closed.3mf`, `phoenix_starter_hand_half_closed.3mf`, `palm.stl`, `palm_base.stl` | PLA+ / PETG (palm, phalanges, gauntlet) + TPU 95A (`palm_base.stl`) |
| `finger-prosthetics/kinetic-pip-finger/` | Body-powered partial-finger prosthesis driven by residual PIP/MCP knuckle flexion via a crossed 4-bar dorsal linkage (no wrist gauntlet required) | `kinetic_finger_prosthetic.scad`, `kinetic_finger_prosthetic.3mf`, `kinetic_finger_prosthetic.stl` | PETG / Nylon / Tough PLA (socket ring, phalanges, linkage bar) |
| `lower-limb/transtibial-esar-leg/` | Below-knee Patellar-Tendon-Bearing (PTB) check socket, ISO 4-bolt 30 mm pylon receiver, and split-toe Energy-Storage-and-Return (ESAR) foot blade | `modular_transtibial_leg_prosthetic.scad`, `modular_transtibial_leg.3mf`, `esar_prosthetic_foot_keel.stl`, `ptb_transtibial_socket.stl` | PA-CF / PETG (PTB socket & ESAR keel) + TPU 95A (liner & foot shell) |
| `adaptive-attachments/universal-tool-cuff/` | High-torque daily-living gimbal dock that snaps directly into the Phoenix v8 palm base slots for utensils, pens, toothbrushes, and 1/4" hex tools | `adaptive_grip_attachments.scad`, `adaptive_grip_attachments.3mf`, `universal_tool_cuff.stl` | PETG (utensil gimbal & hex dock) + TPU 95A (compliant pinch pads) |

## Key Engineering Innovations Beyond Standard e-NABLE Devices

1. **Scale-Invariant Hardware & Clearances**: Scaling standard STL meshes shrinks or enlarges bolt holes, tendon channels, and hinge clearances, leading to binding joints or loose pins. All `.scad` models here compute anatomical geometry from recipient measurements (`hand_width`, `stump_circumference`, `proximal_stump_circ`, `knee_to_floor_height`) while locking hardware dimensions (`pin_diameter`, `joint_clearance`, `pylon_diameter = 30.0 mm`, `m6_hole = 6.4 mm`).
2. **Gauntlet-Free Partial-Hand Restoration (`kinetic-pip-finger`)**: Over 60% of upper-limb amputations involve partial digits rather than the full palm. The Kinetic PIP-Driven Finger Prosthetic uses the recipient's residual stump flexion to actuate a coupled dorsal 4-bar linkage, delivering natural cylindrical curl and key-pinch opposition in a compact, slip-on ring form factor.
3. **Lower-Limb Energy Return & Uneven-Terrain Compliance (`transtibial-esar-leg`)**: Expands open-source CAD impact to lower-limb mobility with a parametric Patellar-Tendon-Bearing (PTB) check socket, standard 30 mm pylon clamp, and a dual-spring C-curve foot keel featuring a 3 mm sagittal split slot for passive inversion/eversion on uneven ground.
4. **Task-Specific High-Torque Grip Expansion (`universal-tool-cuff`)**: Cable-driven prosthetic fingers often struggle with high lateral torque during eating, writing, or workshop use. The Universal Tool Cuff snaps into the existing 4 wall slots of `palm.stl` to hold utensils, styluses, and 1/4-inch hex bits rigidly.
5. **Automated Console Mechanics & Fit Diagnostics**: Opening any `.scad` file in OpenSCAD (2021.01+) prints a real-time engineering report to the console verifying tendon excursion, wrist closure angle, key-pinch contact percentage, or leaf-spring thickness for the recipient's body mass.

## Quick-Start Customization & Printing Workflow

1. **Measure the Recipient**:
   - **Upper-Limb Hand**: Measure `hand_width` across the knuckles, `hand_length` (wrist crease to middle fingertip on the sound hand), and `knuckle_thickness`.
   - **Finger Prosthetic**: Measure `stump_circumference`, `stump_length`, and intact `target_finger_length`.
   - **Lower-Limb Transtibial**: Measure `proximal_stump_circ` at the patellar tendon bar, `distal_stump_circ`, `stump_length`, `knee_to_floor_height`, and `body_mass_kg`.
2. **Print the Calibration Coupon First**:
   - Set `part = "fit_test"` in OpenSCAD, render (`F6`), and export to STL.
   - Test your printer's exact radial clearance (`0.08 mm` to `0.40 mm`) with a printed D-pin before committing to a full build plate.
3. **Export Individual Components or Full Build Plates**:
   - Set `part = "all_plates"` to export an entire support-free build plate, or select individual parts (`palm`, `palm_base`, `fingers`, `socket_ring`, `esar_foot_keel`, `ptb_socket`, `utensil_gimbal_base`).

## Clinical & Safety Notice

These CAD files are open-source experimental assistive and educational designs and are **not FDA-cleared medical devices**. Upper-limb and finger devices should be fitted with appropriate medical-grade closed-cell foam or silicone liners to prevent skin shear. Lower-limb transtibial check sockets and ESAR foot keels are intended for static alignment evaluation, educational prototyping, and clinician-supervised research; weight-bearing ambulation requires structural validation and fitting by a Certified Prosthetist Orthotist (CPO).

## License

Released under a dual open-source hardware and software license: **CERN Open Hardware Licence Version 2 - Permissive (CERN-OHL-P-2.0)** and **Creative Commons Attribution-ShareAlike 4.0 International (CC-BY-SA-4.0)**.
