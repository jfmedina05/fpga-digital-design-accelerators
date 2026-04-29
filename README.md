# FPGA Digital Design & Hardware Acceleration Projects

This repository showcases a progression of projects completed in **Digital Design with FPGAs**, focusing on hardware acceleration, embedded systems, and high-performance computation.

The work spans:
- Software optimization (Python → C)
- FPGA-based acceleration (AXI, DMA)
- Hardware/software co-design
- Advanced digital design (pipelining and parallelism)

---

## 🚀 Highlights
- Achieved up to **250× speedup** using FPGA acceleration and DMA
- Implemented **AXI4-Lite and AXI4-Stream interfaces**
- Designed **custom hardware accelerators in SystemVerilog**
- Built **C drivers for direct hardware control via Linux**
- Optimized hardware using **pipelining and parallelism**

---

## 📂 Projects Overview

### Project 1 – Fast Flower Generator
- Generated parametric shapes using polar coordinates
- Implemented efficient geometric computation

---

### Project 2 – C-Based EMA Acceleration
- Rewrote Python EMA filter in C
- Achieved ~30× speedup using low-level optimization

---

### Project 3 – FPGA EMA (AXI Stream)
- Implemented EMA in hardware using SystemVerilog
- Integrated AXI-Stream interface

---

### Project 4 – FPGA Popcount (MMIO)
- Designed memory-mapped hardware accelerator
- Implemented register-based communication

---

### Project 5 – C Hardware Interface (MMIO)
- Controlled FPGA from C using `/dev/uio`
- Used `mmap()` for direct hardware access

---

### Project 6 – DMA-Based Acceleration
- Integrated DMA for high-throughput transfers
- Reduced runtime from ~50s → <1s

---

### Project 7 – Custom DMA Driver in C
- Built low-level DMA driver
- Achieved <0.2s execution for large datasets

---

### Project 8 – Pipelined Dot Product
- Optimized hardware using pipelining
- Increased throughput via staged execution

---

### Project 9 – Parallel Dot Product Accelerator
- Introduced parallelism to dot product hardware
- Combined pipelining + parallel compute units
- Evaluated performance across matrix sizes

---

## 🧠 Technical Skills Demonstrated

**Hardware Design**
- SystemVerilog
- Pipelining & Parallelism
- Datapath & Control Logic

**FPGA Systems**
- AXI4-Lite / AXI4-Stream
- DMA Engines
- Vivado Design Flow

**Embedded Systems**
- Memory-Mapped I/O
- Linux Device Interfaces (`/dev/uio`, `udmabuf`)
- Hardware Driver Development (C)

**Software**
- Python, C
- Performance Optimization
- Hardware/Software Integration

---

## 🎯 Key Takeaway
These projects demonstrate full-stack embedded systems engineering — from high-level software down to low-level hardware acceleration — with a strong emphasis on performance and system design.
