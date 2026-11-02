# Phoenix-style starter hand

**Status: experimental CAD; physical validation not documented in this snapshot.**

## Inspect the source

Open [phoenix_starter_hand.scad](phoenix_starter_hand.scad) in OpenSCAD. Use F5 for preview and F6 for rendering, then export the selected geometry as STL. The supplied STL and 3MF files are existing exports; their source parameters and reproducibility have not yet been verified.

Supported part selectors:

`assembly, palm, palm_base, fingers, pins, gauntlet_flat, gauntlet_formed, forming_jig, fit_test, all_plates`

Main sizing parameters:

`hand_width, hand_length, knuckle_thickness`

Start with the source defaults and change one parameter at a time. Record the complete parameter set and OpenSCAD version with every reproduction report.

Preview the assembly, then export the fit coupon. Bench assembly instructions and verified hardware quantities are not yet available. The source describes tendon actuation and elastic return; operation needs physical demonstration.

## Evidence needed

- Clearly labeled assembly render and component diagram.
- Export checks for every supported selector and representative sizes.
- Documented bill of materials and quantities for a bench assembly.
- Verified print orientation, support needs, and measured clearances.
- Bench observations, limitations, and failure reports.

See [printing notes](../../docs/PRINTING_NOTES.md), [validation checklist](../../docs/VALIDATION.md), and [contribution instructions](../../CONTRIBUTING.md). Do not infer human-use suitability from an exported mesh.
