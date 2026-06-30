# FPGA Digital Design & Hardware Acceleration Projects

<p align="center">
  <img alt="SystemVerilog" src="https://img.shields.io/badge/SystemVerilog-FF6F00?logoColor=white">
  <img alt="C" src="https://img.shields.io/badge/C-00599C?logo=c&logoColor=white">
  <img alt="Python" src="https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white">
  <img alt="Jupyter Notebook" src="https://img.shields.io/badge/Jupyter%20Notebook-F37626?logo=jupyter&logoColor=white">
  <img alt="NumPy" src="https://img.shields.io/badge/NumPy-013243?logo=numpy&logoColor=white">
  <img alt="Vivado" src="https://img.shields.io/badge/Vivado-F79500?logo=amd&logoColor=white">
  <img alt="PYNQ" src="https://img.shields.io/badge/PYNQ-00843D?logo=xilinx&logoColor=white">
  <img alt="FPGA" src="https://img.shields.io/badge/FPGA-Hardware%20Acceleration-1E4D8C?logoColor=white">
  <img alt="AXI4-Lite" src="https://img.shields.io/badge/AXI4--Lite-MMIO-4B0082?logoColor=white">
  <img alt="AXI-Stream" src="https://img.shields.io/badge/AXI--Stream-Data%20Movement-4B0082?logoColor=white">
  <img alt="AXI DMA" src="https://img.shields.io/badge/AXI%20DMA-High%20Throughput-4B0082?logoColor=white">
  <img alt="Linux" src="https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black">
  <img alt="MMIO" src="https://img.shields.io/badge/MMIO-Memory%20Mapped%20I%2FO-2C8EBB?logoColor=white">
  <img alt="mmap" src="https://img.shields.io/badge/mmap-Userspace%20Access-2C8EBB?logoColor=white">
  <img alt="Pipelining" src="https://img.shields.io/badge/Pipelining-Datapaths-6f42c1?logoColor=white">
  <img alt="Parallelism" src="https://img.shields.io/badge/Parallelism-Compute%20Units-6f42c1?logoColor=white">
  <img alt="Git" src="https://img.shields.io/badge/Git-F05032?logo=git&logoColor=white">
  <img alt="GitHub" src="https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white">
  <img alt="Markdown" src="https://img.shields.io/badge/Markdown-000000?logo=markdown&logoColor=white">
</p>

A collection of FPGA digital design and hardware acceleration projects focused on SystemVerilog, AXI interfaces, DMA-based data transfer, memory-mapped I/O, embedded C drivers, pipelining, parallelism, and high-performance computation.

This repository documents a progression from software-based computation to FPGA-accelerated hardware systems. The projects begin with algorithmic implementation and C optimization, then move into custom FPGA accelerators, AXI-Stream and AXI4-Lite interfaces, DMA pipelines, Linux userspace hardware control, and parallel hardware datapaths.

---

## Overview

Modern embedded and high-performance systems often rely on hardware acceleration to improve throughput, reduce execution time, and offload compute-heavy operations from the CPU. This repository explores that process through a sequence of projects that progressively move computation closer to custom hardware.

The work spans:

- Software optimization using Python and C
- FPGA-based acceleration using SystemVerilog
- AXI4-Lite memory-mapped hardware interfaces
- AXI-Stream data movement
- DMA-based high-throughput transfers
- Embedded Linux hardware control from C
- Pipelined and parallel hardware architectures
- Hardware/software performance benchmarking

Across the project sequence, the designs evolve from software implementations to full hardware accelerators capable of major performance improvements over software-only approaches.

---

## Project Goals

- Implement computational algorithms in software and hardware
- Compare Python, C, and FPGA-based performance
- Design custom hardware accelerators in SystemVerilog
- Use AXI4-Lite for memory-mapped register communication
- Use AXI-Stream and DMA for high-throughput data transfer
- Build C drivers for direct userspace control of FPGA hardware
- Apply pipelining to improve hardware throughput
- Apply parallelism to reduce total computation cycles
- Evaluate FPGA performance against software baselines
- Practice hardware/software co-design for embedded acceleration systems

---

## Technical Areas

| Area | Description |
|---|---|
| Digital Design | Custom datapaths, control logic, registers, counters, and hardware modules |
| Hardware Acceleration | Moving compute-heavy operations from software into FPGA logic |
| SystemVerilog | RTL design for FPGA accelerators and datapath modules |
| AXI4-Lite | Memory-mapped register interfaces for CPU-to-FPGA communication |
| AXI-Stream | Streaming data interface for high-throughput hardware pipelines |
| DMA | Direct Memory Access for efficient CPU-to-FPGA data movement |
| Embedded C | Linux userspace drivers using `/dev/uio`, `mmap()`, and DMA buffers |
| Pipelining | Increasing hardware throughput through staged execution |
| Parallelism | Using multiple compute units to perform operations concurrently |
| Benchmarking | Comparing Python, C, NumPy, and FPGA execution performance |

---

## Repository Structure

```text
fpga-digital-design-accelerators/
│
├── Project-1-Fast-Flower/
│   └── Parametric flower generation using polar coordinate transformations
│
├── Project-2-EMA-C-Acceleration/
│   └── Exponential Moving Average acceleration using C and Python integration
│
├── Project-3-FPGA-EMA-AXI-Stream/
│   └── FPGA-based EMA filter using SystemVerilog and AXI-Stream
│
├── Project-4-FPGA-Popcount-MMIO/
│   └── Memory-mapped FPGA popcount accelerator using AXI4-Lite
│
├── Project-5-C-MMIO-Hardware-Interface/
│   └── C-based hardware control using `/dev/uio` and `mmap()`
│
├── Project-6-DMA-FPGA-Acceleration/
│   └── DMA-based FPGA acceleration for high-throughput data transfer
│
├── Project-7-C-DMA-Driver/
│   └── Low-level C DMA driver using `/dev/uio0` and `/dev/udmabuf0`
│
├── Project-8-Pipelined-Dot-Product/
│   └── Pipelined FPGA dot product accelerator
│
├── Project-9-Parallel-Dot-Accelerator/
│   └── Parallel dot product accelerator using multiple compute units
│
└── README.md
```

---

## Highlights

- Achieved up to **250× speedup** over software implementations using FPGA acceleration and DMA
- Reduced DMA-based runtime from approximately **50 seconds to less than 1 second**
- Built a low-level C DMA driver that achieved runtime below **0.2 seconds** for large data workloads
- Implemented custom hardware accelerators in SystemVerilog
- Used AXI4-Lite for memory-mapped hardware control
- Used AXI-Stream and DMA for high-throughput data movement
- Controlled FPGA hardware directly from Linux userspace using C
- Applied pipelining and parallelism to optimize compute-intensive datapaths
- Benchmarked hardware implementations against software baselines

---

## Projects

### [Project 1 — Fast Flower Generator](./Project-1-Fast-Flower)

This project generates parametric flower patterns using polar coordinate transformations. It focuses on mathematical modeling, efficient computation, and visualization-ready point generation.

#### Key Work

- Generated parametric shapes using polar coordinates
- Converted polar coordinates to Cartesian coordinates
- Implemented efficient geometric computation
- Produced high-resolution point sets for smooth curve generation
- Structured reusable functions for mathematical shape generation

#### Skills Demonstrated

- Python programming
- Numerical computation
- Polar-to-Cartesian transformations
- Algorithmic thinking
- Geometry-based visualization

---

### [Project 2 — Exponential Moving Average C Acceleration](./Project-2-EMA-C-Acceleration)

This project accelerates an Exponential Moving Average filter by rewriting the performance-critical computation in C and integrating it with Python.

#### Key Work

- Rewrote a Python EMA filter in C
- Integrated C code with Python using the Python C API
- Converted the EMA recurrence into a more efficient form
- Benchmarked performance against the Python implementation
- Achieved approximately **30× speedup** over the Python version

#### Skills Demonstrated

- C programming
- Python/C integration
- Performance profiling
- Low-level optimization
- Digital signal processing
- Software acceleration

---

### [Project 3 — FPGA EMA Filter Using AXI-Stream](./Project-3-FPGA-EMA-AXI-Stream)

This project moves the Exponential Moving Average filter from software into FPGA hardware using SystemVerilog and an AXI-Stream interface.

#### Key Work

- Designed an EMA filter in SystemVerilog
- Implemented streaming data processing using AXI-Stream
- Used `TVALID` and `TREADY` handshake signals
- Integrated Python-side control with FPGA hardware
- Simulated and deployed the design using a PYNQ-based workflow

#### Skills Demonstrated

- SystemVerilog RTL design
- AXI-Stream communication
- Streaming hardware computation
- Stateful filter design
- FPGA hardware acceleration
- Hardware/software co-design

---

### [Project 4 — FPGA Popcount Accelerator Using MMIO](./Project-4-FPGA-Popcount-MMIO)

This project implements a popcount, or bit-counting, accelerator on FPGA hardware and communicates with it through AXI4-Lite memory-mapped I/O.

#### Key Work

- Designed a hardware popcount accelerator
- Implemented an AXI4-Lite register interface
- Used memory-mapped registers for CPU-to-FPGA communication
- Implemented reset, accumulation, and control logic
- Created a stateful hardware computation module

#### Skills Demonstrated

- AXI4-Lite interface design
- Memory-mapped I/O
- Register-based hardware control
- SystemVerilog datapath design
- CPU-to-FPGA communication
- FPGA accelerator design

---

### [Project 5 — C Hardware Interface Using MMIO](./Project-5-C-MMIO-Hardware-Interface)

This project extends the memory-mapped FPGA popcount accelerator by replacing Python-based control with a C-based userspace hardware interface.

#### Key Work

- Controlled FPGA hardware directly from C
- Used `/dev/uio` for userspace hardware access
- Used `mmap()` to map hardware registers into process memory
- Accessed FPGA registers through C pointers
- Implemented polling-based synchronization
- Improved performance compared to Python-based control

#### Skills Demonstrated

- Embedded C programming
- Linux userspace hardware access
- Memory mapping with `mmap()`
- Direct register control
- Hardware synchronization
- Low-level hardware/software integration

---

### [Project 6 — DMA-Based FPGA Acceleration](./Project-6-DMA-FPGA-Acceleration)

This project introduces Direct Memory Access to accelerate data transfer between the CPU and FPGA for popcount computation.

#### Key Work

- Integrated AXI DMA for block data transfers
- Modified the hardware design to support streaming input
- Used DMA to reduce CPU involvement in data movement
- Connected DMA-based data transfer with FPGA computation
- Reduced runtime from approximately **50 seconds to less than 1 second**

#### Skills Demonstrated

- DMA-based acceleration
- AXI DMA integration
- AXI-Stream data movement
- High-throughput hardware design
- System-level performance optimization
- FPGA data pipeline design

---

### [Project 7 — Custom DMA Driver in C](./Project-7-C-DMA-Driver)

This project implements a low-level DMA driver in C to control FPGA data transfers directly from Linux userspace.

#### Key Work

- Built a C-based DMA driver
- Used `/dev/uio0` for DMA register control
- Used `/dev/udmabuf0` for userspace DMA buffer access
- Controlled DMA registers directly from C
- Processed large files in chunks
- Achieved runtime below **0.2 seconds**
- Achieved approximately **250× speedup** over the software baseline

#### Skills Demonstrated

- C hardware driver development
- DMA register control
- Userspace buffer management
- Embedded Linux programming
- High-performance data pipelines
- Hardware/software synchronization
- Performance engineering

---

### [Project 8 — Pipelined Dot Product Accelerator](./Project-8-Pipelined-Dot-Product)

This project optimizes a dot product hardware implementation by adding pipelining to increase throughput.

#### Key Work

- Modified the dot product hardware datapath
- Inserted pipeline stages into the computation
- Used floating multiply-accumulate units
- Improved execution throughput over a sequential design
- Explored throughput versus latency tradeoffs
- Managed data dependencies across pipeline stages

#### Skills Demonstrated

- Pipelined hardware architecture
- Datapath optimization
- Floating-point multiply-accumulate design
- Throughput improvement
- Latency analysis
- Hardware performance tradeoff analysis

---

### [Project 9 — Parallel Dot Product Accelerator](./Project-9-Parallel-Dot-Accelerator)

This project extends the pipelined dot product accelerator by adding parallel compute units to further improve FPGA performance.

#### Key Work

- Added parallel multiply-accumulate units
- Combined pipelining with parallel hardware computation
- Split computation across rows and columns
- Modified `dot.sv` and `accel_dot.sv`
- Reduced total cycle count through parallel execution
- Evaluated performance across multiple matrix sizes
- Compared FPGA runtime against NumPy runtime

#### Evaluated Matrix Sizes

```text
20 × 10
40 × 20
80 × 40
```

#### Skills Demonstrated

- Parallel hardware architecture
- Pipelining and parallelism
- Multiply-accumulate optimization
- FPGA datapath scheduling
- Matrix computation acceleration
- Hardware/software benchmarking
- FPGA versus CPU performance analysis

---

## System Progression

This repository shows a clear progression from software to hardware acceleration.

```text
Python Algorithm
      │
      ▼
C Optimization
      │
      ▼
FPGA Hardware Module
      │
      ▼
AXI4-Lite / AXI-Stream Interface
      │
      ▼
DMA-Based Data Movement
      │
      ▼
C Userspace Hardware Driver
      │
      ▼
Pipelined Hardware Datapath
      │
      ▼
Parallel FPGA Accelerator
```

---

## Hardware Acceleration Flow

```text
Input Data
    │
    ▼
Software Baseline
Python / C
    │
    ▼
Performance Bottleneck Identified
    │
    ▼
Custom FPGA Accelerator
SystemVerilog RTL
    │
    ▼
AXI Interface
AXI4-Lite / AXI-Stream
    │
    ▼
DMA Data Movement
    │
    ▼
C Driver Control
    │
    ▼
Performance Benchmarking
```

---

## Tools and Technologies

### Languages

- SystemVerilog
- C
- Python
- Jupyter Notebook

### FPGA and Hardware Tools

- Vivado
- PYNQ
- FPGA hardware acceleration workflow
- AXI4-Lite
- AXI4-Stream
- AXI DMA

### Embedded Linux Interfaces

- `/dev/uio`
- `/dev/uio0`
- `/dev/udmabuf0`
- `mmap()`
- Userspace hardware register access
- DMA buffer management

### Core Concepts

- Hardware/software co-design
- Memory-mapped I/O
- DMA transfer control
- Register-level programming
- Streaming data pipelines
- Pipelined datapaths
- Parallel hardware computation
- Performance benchmarking

---

## Technical Skills Demonstrated

### Hardware Design

- SystemVerilog RTL development
- Datapath and control logic design
- Register interface design
- Stateful hardware modules
- Pipelining
- Parallelism
- Multiply-accumulate hardware
- FPGA accelerator architecture

### FPGA Systems

- AXI4-Lite interfaces
- AXI-Stream interfaces
- AXI DMA integration
- Vivado design flow
- PYNQ-based deployment
- FPGA hardware debugging
- CPU-to-FPGA communication

### Embedded Systems

- Memory-mapped I/O
- Linux device interfaces
- Userspace hardware access
- DMA buffer management
- C hardware driver development
- Direct register control
- Hardware synchronization

### Software and Performance

- Python algorithm development
- C optimization
- Python C API integration
- NumPy benchmarking
- Runtime profiling
- Hardware/software performance comparison
- Throughput and latency analysis

---

## Performance Summary

| Stage | Main Optimization | Result |
|---|---|---|
| Python baseline | Original software implementation | Baseline runtime |
| C acceleration | Rewrote critical computation in C | Approximately 30× speedup |
| FPGA MMIO | Moved computation into custom hardware | Hardware-controlled acceleration |
| DMA acceleration | Reduced CPU-managed data transfer overhead | Runtime reduced from ~50s to <1s |
| C DMA driver | Controlled DMA directly from userspace C | Runtime below 0.2s |
| Parallel accelerator | Combined pipelining with parallel compute units | Improved throughput beyond pipelining alone |

---

## Why This Project Matters

This repository demonstrates the full path from software computation to custom hardware acceleration. It shows how performance can be improved at multiple levels: algorithm implementation, low-level C optimization, FPGA offloading, memory-mapped hardware control, DMA data movement, pipelining, and parallel execution.

The project sequence is especially valuable because it does not only show isolated HDL modules. It shows complete hardware/software systems where software, operating system interfaces, FPGA logic, and performance benchmarking all work together.

These projects are relevant to embedded systems, computer engineering, hardware acceleration, edge computing, digital design, and high-performance computing applications.

---

## Author

**Jaiden Medina**  
Computer Engineering @ Indiana University  
Accelerated M.S. in Intelligent Systems Engineering  

- GitHub: [jfmedina05](https://github.com/jfmedina05)
- Portfolio: [www.jaidenmedina.com]( http://www.jaidenmedina.com/)
- LinkedIn: [jaiden-medina](https://www.linkedin.com/in/jaiden-medina)
