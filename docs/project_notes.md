# Project Notes

## Source

This repository is based on the original ELL1401 Digital Dice project documentation.

## What the tested implementation contains

The tested implementation uses:

- button synchronization / rising-edge detection,
- a 3-bit LFSR,
- a dice mapping function,
- player-turn state,
- a rolling counter,
- 7-segment decoding,
- player LEDs,
- an extra-turn LED output.

The original report documents ModelSim simulation waveforms, MAX3000A pin planning, physical hardware observations, and a project demonstration.

## Why the main RTL is preserved

The author currently does not have access to the CPLD hardware. Therefore, the main `rtl/Dice4.v` file is intentionally kept as the version corresponding to the tested course project rather than replacing it with an untested "improved" implementation.

## Future improvements

The report itself identifies button bouncing, clock division/frequency, initialization, and dice mapping as possible error sources.

These can be addressed later when hardware access is available. Until then, improvements should be kept separate from the tested implementation and clearly labelled as experimental.

## Reproducibility

The repository contains:

- RTL source
- testbench
- documented pin assignments
- project notes

Quartus II and ModelSim can be used to reproduce the FPGA/CPLD development flow when the required hardware/toolchain is available.
