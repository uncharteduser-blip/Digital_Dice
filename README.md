# 🎲 Digital Dice | Verilog + CPLD

A 4-player digital dice system implemented in Verilog on a CPLD as part of the **ELL1401 Digital Electronics Lab, IIT Delhi, Semester 1, 2025**.

> **Important:** This repository preserves the implementation that was actually developed, simulated, and demonstrated on the CPLD for the course project. No untested RTL modifications have been substituted into the main implementation.

## Features

- 4-player turn tracking
- LFSR-based pseudo-random dice generation
- Dice values 1–6
- 7-segment display
- Rolling animation
- Extra turn when a 6 is rolled
- Player indicator LEDs
- Extra-turn LED / buzzer control output
- Synchronized push-button input

## Hardware / Tools

- MAX3000A CPLD / EPM3064ALC44-10
- Intel Quartus II
- ModelSim
- JTAG programmer
- 7-segment display
- LEDs
- Buzzer
- Push-button / switch input

## Repository structure

```text
digital-dice-verilog/
├── README.md
├── .gitignore
├── rtl/
│   └── Dice4.v
├── tb/
│   └── Dice4_tb.v
├── constraints/
│   └── Dice4.qsf
└── docs/
    └── project_notes.md
```

## Architecture

```text
                  player_btn
                      │
                      ▼
              ┌───────────────┐
              │ Input Sync     │
              │ + Edge Detect  │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │ Roll Control  │
              │ + Roll Counter│
              └───────┬───────┘
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
   ┌──────────────┐       ┌──────────────┐
   │ 3-bit LFSR   │       │ Player Turn  │
   │ PRNG         │       │ State        │
   └──────┬───────┘       └──────┬───────┘
          │                       │
          ▼                       │
   ┌──────────────┐               │
   │ Dice Mapping │◄──────────────┘
   │ 1 ... 6      │
   └──────┬───────┘
          │
       ┌──┴──────────┐
       ▼             ▼
  7-segment     Extra-turn
    display       output
```

## LFSR

The design uses a 3-bit LFSR with:

```text
feedback = lfsr[2] ^ lfsr[1]
```

The initial seed is:

```text
3'b001
```

The generated state is mapped through `dice_map()` to dice values 1–6.

## Game logic

- Reset initializes the game and selects Player 1.
- A rising edge on the player button starts a roll.
- While rolling, the displayed dice value is updated from the LFSR.
- After the roll counter completes:
  - a result of **6** keeps the current player on turn and asserts `extra_led`;
  - any other result advances to the next player.
- Player LEDs indicate the current player.

## Simulation

The testbench is located at:

```text
tb/Dice4_tb.v
```

It generates the clock, applies reset, triggers several player-button events, and allows the design to be observed in ModelSim.

The original project report includes ModelSim waveform screenshots demonstrating the simulated signals.

## Hardware

The original project was implemented on the MAX3000A CPLD and physically demonstrated using a 7-segment display, LEDs, push-button input, and buzzer.

The original report also contains the pin planner and hardware observation photographs.

## Pin assignments

The documented MAX3000A assignments are preserved in:

```text
constraints/Dice4.qsf
```

These should be verified against the actual board before programming.

## Known limitations / future improvements

The original project report identifies several practical considerations:

- mechanical button bouncing,
- clock frequency / clock division,
- LFSR initialization,
- dice-state mapping,
- reset handling.

Possible future improvements include:

- hardware/software debouncing,
- a dedicated clock divider for a precise rolling duration,
- improved pseudo-randomness / unbiased dice mapping,
- cleaner finite-state-machine decomposition,
- parameterized display timing.

These are listed as **future work**, not claimed as completed features of the tested course implementation.

## Project documentation

See `docs/project_notes.md` for implementation notes and the distinction between the tested course version and possible future improvements.

## CV description

Suggested CV entry:

**Digital Dice | Verilog, CPLD**  
- Designed and implemented a 4-player digital dice system with turn tracking, extra-turn logic, 7-segment display and LED/buzzer control.
- Implemented an LFSR-based pseudo-random number generator and sequential control logic, and verified the design through RTL simulation and CPLD hardware testing.

