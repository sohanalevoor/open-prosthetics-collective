# Adaptive attachment concepts

**Status: experimental CAD; physical validation not documented in this snapshot.**

## Inspect the source

Open [adaptive_grip_attachments.scad](adaptive_grip_attachments.scad) in OpenSCAD. Use F5 for preview and F6 for rendering, then export the selected geometry as STL. The supplied STL and 3MF files are existing exports; their source parameters and reproducibility have not yet been verified.

Supported part selectors:

`utensil_gimbal_base, hex_tool_holder, compliant_pinch_pad, all_plates`

Main sizing parameters:

`hand_width, foam_thickness, wall, utensil_slot_w, utensil_slot_h`

Start with the source defaults and change one parameter at a time. Record the complete parameter set and OpenSCAD version with every reproduction report.

This module has no assembly or fit_test selector. Preview the individual components and check their interfaces against the hand at matching parameters. Retention, torque capacity, and useful motion have not been demonstrated.

## Evidence needed

- Clearly labeled assembly render and component diagram.
- Export checks for every supported selector and representative sizes.
- Documented bill of materials and quantities for a bench assembly.
- Verified print orientation, support needs, and measured clearances.
- Bench observations, limitations, and failure reports.

See [printing notes](../../docs/PRINTING_NOTES.md), [validation checklist](../../docs/VALIDATION.md), and [contribution instructions](../../CONTRIBUTING.md). Do not infer human-use suitability from an exported mesh.
