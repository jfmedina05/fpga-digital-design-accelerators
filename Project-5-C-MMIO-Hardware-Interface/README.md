# Project 5 – C Hardware Interface (MMIO)

## Overview
This project extends Project 4 by replacing Python control with a C-based interface using memory-mapped I/O.

---

## Objective
- Control FPGA hardware directly from C  
- Use Linux device interfaces for hardware access  
- Improve performance and efficiency  

---

## Implementation
- Used `/dev/uio` and `mmap()`  
- Accessed hardware registers via pointers  
- Implemented polling-based synchronization  

---

## Results
- Significant performance improvement over Python control  

---

## Key Concepts
- Memory mapping  
- Embedded Linux programming  
- Hardware synchronization  

---

## What I Learned
- Direct hardware control using C  
- OS-level interaction with devices  
- Efficient binary data processing  
