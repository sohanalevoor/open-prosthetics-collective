# Starter tasks

These are draft issue descriptions for the maintainer to publish; no GitHub issues have been created.

## 1. Reproduce the hand calibration coupon

Source: upper-limb/phoenix-hand-v8/phoenix_starter_hand.scad, part = "fit_test".

Goal: document whether a newcomer can export and print the coupon. Record OpenSCAD version, parameters, printer and material settings, photos, dimensions, and which clearances work. Report failures rather than tuning them away silently.

Acceptance: a reproducible report with an exported coupon, print settings, measured results, and limitations. No recipient fitting is required.

## 2. Measure hardware dimensions at three hand sizes

Use the hand model with hand_width = 60, 66, and 75 mm as exploratory test inputs, not approved fitting sizes. Keep other settings unchanged. Export the same relevant parts and record pin diameters, bores, wall thicknesses, and interference observations.

Acceptance: a measurement table tied to source parameters and exports, including render warnings and any dimensions that vary unexpectedly. Do not assume every size is supported.

## 3. Document a hand bench assembly

Inventory required parts and consumables from the source, verify quantities through an actual bench build, then photograph each step. Document orientation, tendon routing, elastic return, tensioning, obstacles, and motion observed.

Acceptance: an illustrated procedure, verified bill of materials, short bench demonstration, and known failures. Keep the build off-body; a working bench assembly is not clinical validation.
