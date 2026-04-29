# Project 9 – Parallel Dot Product Accelerator

## Overview
This project extends a pipelined dot product implementation by introducing **parallelism** to further accelerate computation on FPGA hardware.

The design combines:
- Pipelining (Project 8)
- Parallel compute units
- Hardware/software benchmarking

---

## Objective
- Accelerate dot product using parallel hardware
- Evaluate performance across matrix sizes
- Compare FPGA vs NumPy performance

---

## Design Approach

### Parallelization Strategy
- Multiple multiply-accumulate (MAC) units operate simultaneously
- Computation split across:
  - Rows (horizontal parallelism)
  - Columns (vertical parallelism)

---

## Hardware Implementation
- Modified:
  - `dot.sv`
  - `accel_dot.sv`
- Implemented:
  - Parallel MAC units
  - Optimized datapath scheduling
  - Reduced total cycle count

---

## Performance Evaluation

Evaluated matrix sizes:
- 20×10
- 40×20
- 80×40 :contentReference[oaicite:2]{index=2}  

Measured:
- Hardware runtime
- NumPy runtime
- Total MAC operations

---

## Results
- Significant reduction in execution cycles
- Parallelism improved throughput beyond pipelining alone
- Performance scales with matrix size

---

## Key Concepts
- Parallel hardware computation
- Multiply-Accumulate (MAC) optimization
- Performance scaling
- FPGA vs CPU tradeoffs

---

## What I Learned
- How to design parallel hardware architectures
- Tradeoffs between resource usage and speed
- How to combine pipelining and parallelism effectively
- How to evaluate hardware performance vs software

---

## Why This Matters
This project represents a **full hardware accelerator design**, demonstrating how parallelism and pipelining can be combined to achieve high-performance computation in FPGA systems.