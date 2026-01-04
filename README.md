# 🚦 Advanced Traffic Light Control System  
### Four-Way Intersection with Main-Road Priority and Protected Left Turns

---

## 📌 Project Overview

This project implements a **realistic, hardware-synthesizable traffic light controller** using **Verilog HDL** for a **four-way intersection** with advanced signal phasing. The system is designed using a **Moore Finite State Machine (FSM)** and is **directly synthesized onto FPGA hardware**, where physical LEDs represent real traffic signals.

Unlike many publicly available Verilog traffic light examples—which are often simplified, simulation-only demonstrations—this design emphasizes **real-world compatibility, safety, and hardware correctness**.

Key features include:

- **Main-road prioritization (North–South direction)**
- **Protected left-turn signals for all approaches**
- **Independent straight and left-turn phases**
- **Realistic, parameterized timing behavior**
- **Explicit all-red safety intervals**
- **Deep verification using comprehensive testbenches**
- **Direct FPGA deployment (e.g., Digilent Basys 3 board)**

---

## 🧠 Design Compatibility & Realism

### Why This Design Is More Complete Than Typical Verilog Traffic Light Projects

A large number of publicly available Verilog traffic light controllers:
- Model only **two traffic directions**
- Ignore **left-turn protection**
- Omit **all-red safety buffers**
- Use monolithic or Mealy-style logic prone to glitches
- Are difficult to map cleanly to FPGA hardware
- Are intended solely for waveform simulation

This project was intentionally designed to address those limitations.

### Key Compatibility Advantages

- **Moore FSM discipline** ensures outputs depend only on state, making the design:
  - Easier to synthesize
  - Safer for timing closure
  - Less prone to glitches on real hardware
- **Parameter-driven timing** allows the controller to adapt to different clock frequencies and deployment platforms without code restructuring
- **Explicit safety states** (all-red intervals) mirror real traffic controllers and satisfy hardware safety constraints
- **Clear separation of logic** (state register, next-state logic, output decoding) aligns with industry-standard RTL design practices

As a result, this design integrates cleanly into **FPGA-based systems** and scales better than most instructional examples found online.

---

## 🚘 Supported Traffic Movements

The intersection supports **four independent traffic movements**:

- North–South straight
- North–South left turns
- East–West straight
- East–West left turns

Each movement is controlled by its own FSM phase, ensuring **non-conflicting signal combinations** and realistic operation.

---

## ↪ Right-Turn Handling Assumptions

This design **intentionally excludes explicit right-turn signal control**, reflecting real-world traffic laws and engineering practice, particularly in regions such as the **United States**.

### Rationale:
- **Right turns are generally permitted on red** (after a complete stop), unless signage explicitly prohibits them.
- Right-turn behavior is therefore a **driver decision**, not a traffic-controller decision.
- Including right-turn phases would not improve realism and would unnecessarily complicate the controller.

Right turns are therefore **implicitly supported** and are **outside the scope of the signal logic itself**.

---

## 🔁 Moore Finite State Machine Architecture

The controller is implemented as a **Moore FSM**, meaning:

- All outputs depend **only on the current state**
- Outputs do **not depend directly on inputs**
- Signal changes occur only on state transitions
- Guarantees **stable, glitch-free outputs**, ideal for FPGA synthesis

### FSM State Flow:
1. North–South Left Green *(Initial State)*
2. North–South Left Yellow
3. All Red (Safety Interval)
4. North–South Straight Green
5. North–South Straight Yellow
6. All Red
7. East–West Left Green
8. East–West Left Yellow
9. East–West Straight Green
10. East–West Straight Yellow
11. All Red → Loop Back

Tracking the **previous non–all-red state** ensures deterministic and safe sequencing after each safety interval.

---

## ⏱ Realistic Timing Control

Each phase duration is implemented using a **clock-driven counter**, closely emulating real traffic signal controllers.

| Phase | Duration (Clock Cycles) |
|------|--------------------------|
| Left-turn green | 5 |
| North–South straight green | 15 |
| East–West straight green | 10 |
| Yellow (all directions) | 2 |
| All-red safety | 2 |

All timing values are **parameterized**, making the design compatible with a wide range of FPGA clock frequencies and platforms.

---

## 🛡 Safety-Critical Design Features

- Explicit **all-red intervals** between conflicting movements
- Default output state is **all red**
- No overlapping green signals by construction
- Strict FSM sequencing prevents undefined behavior

These choices align the controller with **real traffic engineering standards**, rather than purely academic demonstrations.

---

## 🧪 Verification & Testbenches

The system has been **deeply verified using comprehensive Verilog testbenches**, which:

- Exercise all FSM states and transitions
- Validate timing accuracy
- Detect illegal or unsafe output combinations
- Confirm correct reset and recovery behavior

This verification process ensures the design behaves correctly both in simulation and when deployed on hardware.

---

## 🧩 FPGA Hardware Implementation

The controller is **fully synthesizable** and has been deployed on **FPGA hardware**, including:

- **Digilent Basys 3 FPGA Board**
- Xilinx **Artix-7** architecture

### Hardware Mapping:
- Each traffic signal output is mapped to a **dedicated onboard LED**
- LEDs represent:
  - Red / Yellow / Green straight signals
  - Red / Yellow / Green left-turn signals
- Clock driven by FPGA system clock
- Reset controlled via onboard push-button

This makes the design **directly observable and verifiable in real time**, a capability absent from many public Verilog examples.

---

## 🔌 Module Interface Summary

### Inputs
- `clk` — FPGA system clock  
- `reset` — Asynchronous hardware reset  

### Outputs (12 Total)
- North–South: red, yellow, green
- East–West: red, yellow, green
- North–South Left: red, yellow, green
- East–West Left: red, yellow, green

Each output maps cleanly to physical FPGA I/O resources.

---

## 👨‍💻 Authors

**Devansh Joshi**  
**Suren Shirani**

This system was jointly designed, implemented, deeply verified with testbenches, and synthesized on FPGA hardware by the authors, with a strong focus on **compatibility, safety, and real-world correctness**.

---

## 🏁 Conclusion

This project represents a **hardware-accurate, safety-aware, and highly compatible traffic light controller**. By incorporating protected left turns, main-road prioritization, Moore FSM discipline, right-turn realism, deep verification, and FPGA deployment, the design exceeds the scope and quality of most publicly available Verilog traffic light projects and closely reflects **modern real-world traffic signal controllers**.
