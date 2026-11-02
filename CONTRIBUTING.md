# Contributing

Start with [starter tasks](docs/STARTER_TASKS.md). Prioritize reproducible CAD checks and bench documentation before adding more device categories.

## Report a problem

Include the source file, OpenSCAD version, operating system, part selector, changed parameters, expected result, actual result, and console output. Attach a screenshot or minimal example when helpful. Do not include identifiable recipient measurements or photographs without appropriate consent.

## Submit a change

1. Describe the problem and the expected behavior.
2. Include editable source alongside any changed mesh exports. Record the source parameters and export tool version.
3. List the parts and parameter sets you rendered, warnings, and any untested behavior.
4. Keep anatomical sizing separate from hardware dimensions; demonstrate the intended behavior with measurements.
5. Document print orientation and support requirements as tested or unverified. Include a fit coupon when the mechanism needs one; document exceptions.
6. Label calculations, simulations, physical observations, and validated results separately. Do not present design inputs as load ratings.

For physical reproduction reports, include printer, nozzle, material, layer height, wall count, infill, orientation, supports, measurements, and observed failures. Bench testing does not establish suitability for human use.

## Before release

Resolve [licensing and attribution](docs/LICENSE_REVIEW.md), record [validation status](docs/VALIDATION.md), and update the module README. Do not add claims about strength, fit, or clinical performance without supporting evidence.
