# 🚦 Advanced Traffic Light Control System  
### Four-Way Intersection with Main-Road Priority and Protected Left Turns

---

## 📌 Project Overview

This project implements a traffic light controller using Verilog HDL for a four-way intersection. The system uses a Moore Finite State Machine (FSM) and is synthesized onto FPGA hardware, where physical LEDs represent the traffic signals.

Key features include:
- Main-road prioritization (North-South)
- Protected left-turn signals for all directions
- Independent phases for straight and left-turn movements
- Built-in clock divider (100 MHz to 1 Hz) for human-visible state changes on hardware
- Clock enable switch (SW0) to pause and resume the controller in real time
- Parameterized timing for flexibility across different platforms
- All-red safety intervals between every conflicting phase
- Testbenches for verification
- FPGA deployment on a Digilent Basys 3 board with a pre-built bitstream included

---

## 🧠 Design Compatibility and Realism

### Key Differences from Common Verilog Traffic Light Projects

A lot of basic Verilog traffic light designs out there:
- Only handle two directions
- Don't include left-turn protection
- Skip all-red safety buffers
- Use Mealy-style logic that's prone to glitches
- Are meant for simulation only, not actual hardware

This project addresses all of those:
- Moore FSM design for stable, glitch-free outputs on FPGA
- Parameter-driven timing that can be adapted to different clock frequencies
- Safety intervals (all-red phases) that reflect how real traffic lights work
- Clean separation of sequential, combinational, and output logic for straightforward FPGA integration

---

## ⚙️ Implementation Logic

### FSM Structure
The controller uses a Moore FSM with three key registers:
- `state [3:0]` - Current state (4-bit encoding for 9 states)
- `next_state [3:0]` - Calculated next state
- `prev_state [3:0]` - Tracks the last non-all-red state for proper sequencing after safety intervals

### Clock Divider
The Basys 3 runs at 100 MHz, which is far too fast to observe anything on LEDs. A 26-bit counter divides that down to 1 Hz, so each FSM state lasts a visible number of seconds. All state transitions and timer updates are driven by this 1 Hz clock.

### Timer-Based Control
- An 8-bit counter (`timer`) tracks how many seconds the FSM has been in the current state
- Increments every 1 Hz tick (once per second), resets on state transitions
- Compared against parameterized durations to trigger state changes

### State Encoding (4-bit)
```
0000 - NS Left Green (initial)
0001 - NS Left Yellow
0010 - NS Straight Green
0011 - NS Straight Yellow
0100 - EW Left Green
0101 - EW Left Yellow
0110 - EW Straight Green
0111 - EW Straight Yellow
1000 - All Red (safety state)
```

### Three-Block Architecture
1. Sequential Logic - Updates state and timer on clock edge
2. Combinational Logic - Calculates next_state based on current state and timer
3. Output Logic - Sets 12 traffic light outputs (defaults all to red, then activates the required signals)

---

## 🚘 Supported Traffic Movements

The system controls four traffic movements:
- North-South straight
- North-South left turns
- East-West straight
- East-West left turns

Each movement operates independently with non-conflicting signal phases.

---

## ↪ Right-Turn Handling

This design does not include explicit right-turn signals, which lines up with common traffic engineering practice where:
- Right turns on red are generally allowed after a full stop, unless otherwise posted
- The right-turn decision is a driver's responsibility, not something the traffic controller manages

So right turns are implicitly supported but don't affect signal logic.

---

## 🔁 Moore FSM State Flow

The controller cycles through these phases, with an all-red safety interval between each conflicting movement:

1. North-South Left Green
2. North-South Left Yellow
3. All Red
4. North-South Straight Green
5. North-South Straight Yellow
6. All Red
7. East-West Left Green
8. East-West Left Yellow
9. All Red
10. East-West Straight Green
11. East-West Straight Yellow
12. All Red → Repeat

---

## ⏱ Timing Control

With the clock divider active, each count corresponds to 1 real second:

| Phase               | Duration (Seconds) |
|---------------------|--------------------|
| Left-turn green      | 5                  |
| North-South green    | 15                 |
| East-West green      | 10                 |
| Yellow (all)         | 2                  |
| All-red safety       | 2                  |

Total cycle time is 72 seconds. All timings are parameterized in the Verilog source, so you can adjust them for different needs.

---

## 🛡 Safety Features

Key safety design choices:
- All-red intervals between every conflicting movement
- Output logic defaults all 12 signals to red, then selectively turns on the active ones - if anything goes wrong, the default state is safe
- No simultaneous conflicting greens
- Strict FSM sequencing with no undefined or unreachable states

---

## 🧪 Verification and Testbenches

The system is verified through a Verilog testbench (`TL_System_Design_TB.v`), covering:
- FSM state transitions through the full cycle
- Timing accuracy for each phase
- No illegal or unsafe output combinations
- Reset and recovery behavior

This ensures the design works in both simulation and on hardware.

---

## 🧩 FPGA Implementation

The controller is fully synthesizable and has been deployed on:
- Digilent Basys 3 FPGA Board (Xilinx Artix-7, XC7A35T)

### Pin Mapping:
- LD0–LD2: North-South straight (red, yellow, green)
- LD3–LD5: East-West straight (red, yellow, green)
- LD6–LD8: North-South left (red, yellow, green)
- LD9–LD11: East-West left (red, yellow, green)
- BTNC (U18): Reset
- SW0 (V17): Clock enable - flip up to run, down to pause
- W5: 100 MHz system clock input

All I/O uses LVCMOS33.

### Pre-Built Bitstream
A ready-to-program bitstream file (`TL_System_Design.bit`) is included at:
```
TrafficLight_System/TrafficLight_System.runs/synth_1/impl_1/TL_System_Design.bit
```
You can load this directly onto a Basys 3 board through Vivado Hardware Manager without needing to run synthesis or implementation yourself.

---

## 📐 FPGA Constraints File (XDC)

The XDC file maps the Verilog design to the physical FPGA:
- 100 MHz clock (W5) with a 10 ns period constraint
- 12 LED outputs (LD0–LD11) for each signal group
- Center push-button (BTNC, U18) for asynchronous reset
- Switch SW0 (V17) for clock enable (pause/resume control)

All I/O uses the LVCMOS33 standard.

---

## 🔌 Module Interface

### Inputs:
| Signal   | Description                                       |
|----------|---------------------------------------------------|
| `clk`    | 100 MHz system clock (divided to 1 Hz internally) |
| `clk_en` | Clock enable - active high, mapped to SW0         |
| `reset`  | Asynchronous reset - active high, mapped to BTNC  |

### Outputs:
| Signal Group    | Signals                                        |
|-----------------|------------------------------------------------|
| NS Straight     | `northsouth_red`, `_yellow`, `_green`          |
| EW Straight     | `eastwest_red`, `_yellow`, `_green`            |
| NS Left         | `northsouth_left_red`, `_yellow`, `_green`     |
| EW Left         | `eastwest_left_red`, `_yellow`, `_green`       |

---

## 👨‍💻 Authors

**Devansh Joshi** - [GitHub](https://github.com/DJdaGOAT1)  
**Suren Shirani** - [GitHub](https://github.com/ssWaterFlowing)

We designed, implemented, and verified this system with a focus on real-world correctness and FPGA compatibility.
