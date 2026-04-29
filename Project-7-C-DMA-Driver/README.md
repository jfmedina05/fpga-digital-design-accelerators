# Project 7 – DMA Driver in C

## Overview
This project implements a low-level DMA driver in C to control FPGA data transfers directly from Linux userspace.

---

## Objective
- Implement DMA control logic in C  
- Optimize performance further  
- Manage memory buffers efficiently  

---

## Implementation
- Used `/dev/uio0` and `/dev/udmabuf0`  
- Controlled DMA registers directly  
- Processed large files in chunks  

---

## Results
- Achieved <0.2 second runtime  
- ~250× speedup over software baseline  

---

## Key Concepts
- DMA driver development  
- Memory management  
- High-performance data pipelines  

---

## What I Learned
- Low-level hardware control  
- Embedded Linux systems  
- Performance engineering  
