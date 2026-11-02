# Transtibial leg geometry study

**Status: experimental CAD; physical validation not documented in this snapshot.**

## Inspect the source

Open [modular_transtibial_leg_prosthetic.scad](modular_transtibial_leg_prosthetic.scad) in OpenSCAD. Use F5 for preview and F6 for rendering, then export the selected geometry as STL. The supplied STL and 3MF files are existing exports; their source parameters and reproducibility have not yet been verified.

Supported part selectors:

`assembly, ptb_socket, socket_liner_tpu, pylon_adapter, esar_foot_keel, foot_shell_tpu, fit_test, all_plates`

Main sizing parameters:

`proximal_stump_circ, distal_stump_circ, stump_length, knee_to_floor_height, body_mass_kg`

Start with the source defaults and change one parameter at a time. Record the complete parameter set and OpenSCAD version with every reproduction report.

Use for CAD inspection and educational geometry exploration only. Body mass is an input to a thickness heuristic, not a tested load rating. No structural, fatigue, energy-return, fitting, or interface-compatibility validation is included. Do not use the exports for weight-bearing activity.

## Evidence needed

- Clearly labeled assembly render and component diagram.
- Export checks for every supported selector and representative sizes.
- Documented bill of materials and quantities for a bench assembly.
- Verified print orientation, support needs, and measured clearances.
- Bench observations, limitations, and failure reports.

See [printing notes](../../docs/PRINTING_NOTES.md), [validation checklist](../../docs/VALIDATION.md), and [contribution instructions](../../CONTRIBUTING.md). Do not infer human-use suitability from an exported mesh.
