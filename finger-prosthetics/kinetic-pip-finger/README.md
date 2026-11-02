# Kinetic finger concept

**Status: experimental CAD; physical validation not documented in this snapshot.**

## Inspect the source

Open [kinetic_finger_prosthetic.scad](kinetic_finger_prosthetic.scad) in OpenSCAD. Use F5 for preview and F6 for rendering, then export the selected geometry as STL. The supplied STL and 3MF files are existing exports; their source parameters and reproducibility have not yet been verified.

Supported part selectors:

`assembly, socket_ring, middle_phalanx, distal_phalanx, linkage_bar, dorsal_cuff, pins, fit_test, all_plates`

Main sizing parameters:

`stump_circumference, stump_length, target_finger_length`

Start with the source defaults and change one parameter at a time. Record the complete parameter set and OpenSCAD version with every reproduction report.

Preview the assembly and inspect hinge alignment through the available flexion range. The claimed linkage behavior needs geometric and physical verification. No fitted-device instructions are supplied.

## Evidence needed

- Clearly labeled assembly render and component diagram.
- Export checks for every supported selector and representative sizes.
- Documented bill of materials and quantities for a bench assembly.
- Verified print orientation, support needs, and measured clearances.
- Bench observations, limitations, and failure reports.

See [printing notes](../../docs/PRINTING_NOTES.md), [validation checklist](../../docs/VALIDATION.md), and [contribution instructions](../../CONTRIBUTING.md). Do not infer human-use suitability from an exported mesh.
