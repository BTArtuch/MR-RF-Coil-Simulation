# MR RF Coil Simulation

This repository contains custom MATLAB-based numerical solvers for simulating the electromagnetic properties of Magnetic Resonance (MR) Radiofrequency (RF) coils. Unlike traditional antennas that radiate into the far-field, MR coils are designed to operate exclusively in the near-field. This project mathematically maps these environments without relying on proprietary commercial toolboxes.

## Surface Coil
A 3D numerical solver built from scratch to calculate the B1 magnetic field distribution of a circular surface coil. The simulation mathematically proves why a surface coil has high signal near the wire but rapid signal drop-off deeper in the tissue.

![Phase 1: Surface Coil Field Drop-Off](assets/B1_Field_Dropoff.png)

## The Birdcage Volume Coil
Moving beyond single loops, this phase simulates a 16-rung Birdcage volume coil—the industry standard for clinical head scans. By driving the individual rungs with specific phase shifts, the solver demonstrates how the coil creates a highly homogenous, circularly polarized B1 field inside the cylinder.

![Phase 2: Birdcage Homogeneity](assets/Birdcage_Homogeneity.png)

## The Solenoid Coil 
A numerical solver mapping the continuous helical geometry of a 10-turn solenoid. By mathematically stacking multiple circular loops continuously along the Z-axis, the simulation demonstrates how the magnetic fields add constructively to create an intense, highly uniform longitudinal B1 field. Due to this efficiency, this architecture is primarily utilized in high-field, preclinical small-animal MRIs where the subject fits entirely within the compact cylindrical bore.

![Phase 2.1: Solenoid Coronal Field](assets/Solenoid_Homogeneity.png)

## The Two-Saddle Coil 
This phase simulates the classic 120-degree two-saddle (Golay) coil, the industry-standard baseline for volume imaging before the birdcage architecture became dominant. The transverse field mapping illustrates that while the geometry provides excellent central signal penetration, the field homogeneity drops off rapidly near the physical edges of the arcs.

![Phase 2.2: Saddle Transverse Field](assets/Saddle_Homogeneity.png)

## References
* Xia, Y. (2022). *Essential Concepts in MRI: Physics, Instrumentation, Spectroscopy, and Imaging* (1st ed.). Wiley.
* Zangwill, A. (2013). *Modern Electrodynamics*. Cambridge University Press.
* Jin, J.-M. (2015). *Theory and Computation of Electromagnetic Fields*. John Wiley & Sons.