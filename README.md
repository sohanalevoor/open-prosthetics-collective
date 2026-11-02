# Open Prosthetics Collective

**Experimental parametric OpenSCAD models for prosthetic mechanisms and adaptive attachments.**

Explore four CAD modules whose design approach separates anatomical sizing from hardware dimensions. The models include editable source and exported meshes. Hardware dimensions and clearances still need checking across the intended parameter range; changing a measurement does not establish fit or strength.

**Status:** experimental CAD. This repository does not include physical validation reports, verified assembly guides, or clinical validation. Rendered geometry and console calculations are not performance tests. The lower-limb models are educational geometry studies and must not be treated as load-rated devices.

## Explore the models

| Module | Explore | Included formats |
| --- | --- | --- |
| Phoenix-style starter hand | [Wrist-powered hand geometry, fit coupon, and print layouts](upper-limb/phoenix-hand-v8/README.md) | SCAD, STL, 3MF |
| Kinetic finger | [Partial-finger mechanism concept and component exports](finger-prosthetics/kinetic-pip-finger/README.md) | SCAD, STL, 3MF |
| Transtibial leg concept | [Socket, adapter, and split-keel geometry studies](lower-limb/transtibial-esar-leg/README.md) | SCAD, STL, 3MF |
| Adaptive attachments | [Utensil holder, hex-tool holder, and pinch-pad geometry](adaptive-attachments/universal-tool-cuff/README.md) | SCAD, STL, 3MF |

## First look in OpenSCAD

1. Install [OpenSCAD](https://openscad.org/). The hand source records OpenSCAD 2021.01; record your own version when reporting results.
2. Open `upper-limb/phoenix-hand-v8/phoenix_starter_hand.scad`.
3. Leave the default dimensions unchanged and select `part = "assembly"` for a preview.
4. Select `part = "fit_test"`, render with F6, and export an STL to inspect the calibration geometry.
5. Review the console output and geometry before slicing. See [printing notes](docs/PRINTING_NOTES.md).

These steps are a source-based walkthrough, not a verified build procedure. Other modules have different selectors; use their individual READMEs.

## What makes this worth exploring?

The source exposes anatomical measurements separately from parameters such as pin diameter, joint clearance, and pylon diameter. The next milestone is to demonstrate that separation with measured exports at several sizes, then document a bench assembly of the hand mechanism.

The hand includes labeled parts, a calibration coupon, and estimated tendon-excursion diagnostics. Treat console reports as design calculations; they do not verify the physical mechanism.

## Help make the first reproducible release

Start with one of the [three scoped starter tasks](docs/STARTER_TASKS.md):

- Reproduce and document the hand calibration coupon.
- Check hardware dimensions across three hand sizes.
- Create an illustrated hand assembly guide from an actual bench build.

Read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting results. We welcome failed reproductions and clear bug reports as well as improvements.

## Evidence and project status

See the [validation checklist](docs/VALIDATION.md) for the evidence still needed. No photos, animations, mechanical measurements, or physical test reports are included in this snapshot. Add clearly labeled renders and bench footage as they become available.

## Design references

The hand source describes an independently generated Phoenix-style model inspired by the e-NABLE Phoenix family and Unlimbited designs. See [provenance notes](docs/PROVENANCE.md) for references and attribution questions that remain open. The existing directory name is retained for compatibility and does not establish an official upstream Phoenix release or affiliation.

## License status

Licensing needs maintainer clarification before a release: the supplied LICENSE names MIT and CC-BY-SA-4.0 but contains custom terms, while the previous README named CERN-OHL-P-2.0 and CC-BY-SA-4.0. This update preserves that original LICENSE without choosing new terms or resolving rights on the maintainer's behalf. See [the licensing checklist](docs/LICENSE_REVIEW.md).

If you find these models useful, a star helps others discover the project. Reproducible results and contributions help move it forward.
