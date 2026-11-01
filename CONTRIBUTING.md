# Contributing to Open Prosthetics Collective

Thank you for helping expand open-source, parametric prosthetic CAD models for recipients worldwide!

## Design Standards for New CAD Submissions

1. **Parametric Source First**: Always include parametric source files (`.scad`, `.step`, or `.f3d`) alongside exported `.3mf` and `.stl` meshes.
2. **Unscaled Hardware Tolerances**: Ensure pin diameters, screw holes, strap slots, and adapter interfaces remain constant when anatomical parameters are scaled.
3. **Support-Free Print Orientation**: Orient print plates (`all_plates`) so load-bearing layers run parallel to tensile and bending stresses without requiring internal support material inside tendon channels.
4. **Built-In Fit Coupon**: Include a `fit_test` module so makers on any FDM/FFF or SLS 3D printer can verify pin and snap-fit clearances in under 15 minutes.
