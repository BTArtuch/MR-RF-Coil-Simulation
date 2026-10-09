# MR RF Coil Simulation

This repository contains custom MATLAB-based numerical solvers for simulating the electromagnetic properties of Magnetic Resonance (MR) Radiofrequency (RF) coils. Unlike traditional antennas that radiate into the far-field, MR coils are designed to operate exclusively in the near-field. This project mathematically maps these environments without relying on proprietary commercial toolboxes.

## Biot-Savart Field Mapping
A 3D numerical solver built from scratch to calculate the B1 magnetic field distribution of a circular surface coil. The simulation mathematically proves why a surface coil has high signal near the wire but rapid signal drop-off deeper in the tissue.

![Phase 1: Surface Coil Field Drop-Off](assets/B1_Field_Dropoff.png)

## The Birdcage Volume Coil
Moving beyond single loops, this phase simulates a 16-rung Birdcage volume coil—the industry standard for clinical head scans. By driving the individual rungs with specific phase shifts, the solver demonstrates how the coil creates a highly homogenous, circularly polarized B1 field inside the cylinder.

![Phase 2: Birdcage Homogeneity](assets/Birdcage_Homogeneity.png)
