# 🚦 Advanced Traffic Light Control System  
### Four-Way Intersection with Main-Road Priority and Protected Left Turns

---

## 📌 Project Overview

This project implements a **realistic, hardware-synthesizable traffic light controller** using **Verilog HDL** for a **four-way intersection**. The system employs a **Moore Finite State Machine (FSM)** and is synthesized onto FPGA hardware, where physical LEDs represent the traffic signals.

Key features include:
- **Main-road prioritization (North-South)**
- **Protected left-turn signals** for all directions
- **Independent phases** for straight and left-turn movements
- **Parameterized timing** for flexibility across different platforms
- **Explicit all-red safety intervals**
- **Comprehensive testbenches for verification**
- **FPGA deployment** (e.g., Digilent Basys 3 board)

---

## 🧠 Design Compatibility & Realism

### Key Differences from Common Verilog Traffic Light Projects

Many basic Verilog traffic light designs:
- Handle only **two directions**
- Lack **left-turn protection**
- Omit **all-red safety buffers**
- Use **Mealy-style logic** prone to glitches
- Are intended only for **simulation**, not hardware deployment

This project resolves these limitations, offering:
- A **Moore FSM** design that guarantees **stable outputs**, ideal for FPGA synthesis
- **Parameter-driven timing**, adaptable to various FPGA clock frequencies
- **Safety intervals** (all-red phases) reflecting real-world traffic logic
- **Clear separation of logic** for easy FPGA integration

---

## ⚙️ Implementation Logic

### FSM Structure
The controller uses a **Moore FSM** with three key registers:
- **`state [3:0]`** - Current state (4-bit encoding for 9 states)
- **`next_state [3:0]`** - Calculated next state
- **`prev_state [3:0]`** - Tracks last non-all-red state for proper sequencing after safety intervals

### Timer-Based Control
- **8-bit counter (`timer`)** tracks duration in each state
- Increments every clock cycle, resets on state transitions
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
1. **Sequential Logic** - Updates state and timer on clock edge
2. **Combinational Logic** - Calculates next_state based on current state and timer
3. **Output Logic** - Sets 12 traffic light outputs (defaults all to RED, then activates required signals)

---

## 🚘 Supported Traffic Movements

The system controls four traffic movements:
- North–South straight
- North–South left turns
- East–West straight
- East–West left turns

Each movement operates independently with non-conflicting signal phases.

---

## ↪ Right-Turn Handling

This design **excludes explicit right-turn signals**, aligning with common traffic engineering practices where:
- **Right turns on red** are generally allowed after a full stop, unless otherwise stated.
- The right-turn decision is a **driver's responsibility**, not a traffic controller's.

Thus, right turns are **implicitly supported** but do not affect signal logic.

---

## 🔁 Moore FSM State Flow

The controller cycles through these phases with all-red safety intervals between conflicting movements:

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

Each phase duration is defined by a **clock-driven counter** to simulate real traffic light behavior.

| Phase               | Duration (Clock Cycles) |
|---------------------|-------------------------|
| Left-turn green      | 5                       |
| North-South green    | 15                      |
| East-West green      | 10                      |
| Yellow (all)         | 2                       |
| All-red safety       | 2                       |

All timings are **parameterized**, enabling flexibility across different platforms.

---

## 🛡 Safety-Critical Features

Key safety design choices:
- **All-red intervals** between conflicting movements
- **Default state is all red** - output logic defaults all signals to RED, then explicitly activates required lights
- No simultaneous greens, ensuring no conflicts
- Strict FSM sequencing to avoid undefined behavior

These features mirror **real-world traffic controllers**.

---

## 🧪 Verification & Testbenches

The system undergoes **thorough verification** through Verilog testbenches, covering:
- FSM state transitions
- Timing accuracy
- Illegal or unsafe output combinations
- Reset and recovery behavior

This ensures the design works both in simulation and on hardware.

---

## 🧩 FPGA Implementation

The controller is fully synthesizable and has been deployed on an **FPGA**, including:
- **Digilent Basys 3 FPGA Board**
- **Xilinx Artix-7** architecture

### Hardware Mapping:
- 12 **LED outputs** for each signal (Red/Yellow/Green for both straight and left-turn signals)
- **Clock** driven by the FPGA system clock
- **Reset** controlled via an onboard push-button

This setup allows **real-time verification** of the design on hardware.

---

## 📐 FPGA Constraints File (XDC)

An **XDC file** maps the Verilog design to the physical FPGA:
- **12 LED outputs** for each signal
- **Push-button input** for an asynchronous reset
- **Clock constraint** for accurate timing analysis

The constraints file ensures proper pin mapping and FPGA operation.

---

## 🔌 Module Interface

### Inputs:
- `clk` — FPGA system clock
- `reset` — Asynchronous reset

### Outputs:
- North-South: red, yellow, green
- East-West: red, yellow, green
- North-South Left: red, yellow, green
- East-West Left: red, yellow, green

These outputs map directly to physical FPGA I/O resources.

---

## 👨‍💻 Authors

**Devansh Joshi**  
**Suren Shirani**

The system was designed, implemented, and verified by the authors with a focus on **real-world correctness** and **FPGA compatibility**.

---

## 🏁 Conclusion

This project delivers a **realistic, hardware-compatible traffic light controller** with main-road prioritization, protected left turns, and robust safety features. Its use of Moore FSM, flexible timing, deep verification, and FPGA deployment make it a practical solution for real-world traffic signal control.
